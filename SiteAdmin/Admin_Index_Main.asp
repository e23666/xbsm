<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/patch_inc.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<!--#include virtual="/config/uercheckadmin.asp" -->
 
<%

lVer=Csng(getVer())
rVer=Csng(Session("Rver"))

if lVer>=rVer then
	isNewVersion=true
else
	isNewVersion=false
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>后台管理首页</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="css/Admin_Style.css" rel=stylesheet>
<META content="MSHTML 6.00.6000.16525" name=GENERATOR>
<style type="text/css">
<!--
.STYLE4 {
	font-weight: bold
}
.STYLE6 {
	color: #000000;
	font-weight: bold;
}
.STYLE7 {
	color: #FFFFFF;
	font-weight: bold;
}
.STYLE8 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
</HEAD>
<BODY topMargin=0 marginheight="0">
<%
conn.open constr
call opendiv()

'定时读取的东西，比如域名转入状态——————————————————————
zrapp="time_zrstate"
if application(zrapp)&""="" or not isdate(application(zrapp)) then application(zrapp)=Now()
if datediff("h",application(zrapp),Now())>2 or 1=1 then 
	'开始执行吧，1小时一次。
	Set oDic = CreateObject("scripting.dictionary")
	If isdbsql Then
		sql="select strdomain,tran_state from domainlist where  isnull(tran_state,0)>0 and isnull(tran_state,0)<>5"
	else
		sql="select strdomain,tran_state from domainlist where iif( isnull(tran_state),0,tran_state)>0 and iif(isnull(tran_state),0,tran_state)<>5"
	End if
	rs.open sql,conn,1,1
	domains=""
	while not rs.eof
		strDom=trim(lcase(rs("strdomain")))
		if strDom<>"" then
			domains = domains & strDom & ","
			oDic.Add strDom,rs("tran_state")
		end if
		rs.movenext
	wend
	rs.close
	if domains<>"" then
		if right(domains,1)="," then domains=left(domains,len(domains)-1)
		cmdinfo="domainname" & vbcrlf & _
			"trans" & vbcrlf & _
			"entityname:get_state" & vbcrlf & _
			"domain:" & domains & vbcrlf & _
			"." & vbcrlf
		retCode=connectToUp(cmdinfo)
		'将得到 domain:2,domain:4 这样的集合
		Set oreg=New RegExp
		oreg.Pattern="(.*?)\:(\d+),?"
		oreg.Global=True:oreg.IgnoreCase=True
		Set matches=oreg.Execute(retCode)
		For Each match In matches
			tmpDom=match.Submatches(0)
			tmpVal=match.Submatches(1)
			if oDic.exists(tmpDom) and isnumeric(tmpVal&"") then
			conn.execute("update domainlist set tran_state=" & tmpVal & " where strdomain='" & tmpDom & "'")
			oDic.remove(tmpDom)
			end if
		Next
		set oreg=nothing
		for each tmpDom in oDic.keys	'未查到记录的应该就可以删了
			conn.execute("update domainlist set tran_state=0 where strdomain='" & tmpDom & "'")
		next
	end if
	application(zrapp)=Now()
end if

%>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
    <TR>
      <TD width=392 rowSpan=2><img height=126 
      src="images/adminmain01.gif" width=392></TD>
      <TD vAlign=top background=images/adminmain0line2.gif 
    height=114><TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
          <TBODY>
            <TR>
              <TD height=20></TD>
            </TR>
            <TR>
              <TD><SPAN class=STYLE4>帮助公告</SPAN></TD>
            </TR>
            <TR>
              <TD height=8><IMG height=1 
            src="images/adminmain0line.gif" width=283></TD>
            </TR>
            <TR>
              <TD><DIV id=peinfo1>正在读取数据中...</DIV>
                <DIV id=peinfo2 
            style="Z-INDEX: 1; VISIBILITY: hidden; POSITION: absolute"></DIV>
                <DIV id=peinfo5 
    style="VISIBILITY: hidden"></DIV></TD>
            </TR>
          </TBODY>
        </TABLE></TD>
    </TR>
    <TR>
      <TD vAlign=bottom background=images/adminmain03.gif 
      height=9><IMG height=12 src="images/adminmain02.gif" 
      width=23></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
    <TR></TR>
  </TBODY>
</TABLE>
<TABLE height=10 cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
    <TR>
      <TD align="center" height="16">
        <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <tr><td width="76%">
      	<div align="left"><br>
          <img src="images/warning.gif" width="16" height="16"> 提示：系统当前版本为:v<%=formatNumber(lVer,2,-1,-1)%>,官方最新版本为:<font color="#FF0000">v<%=formatNumber(rVer,2,-1,-1)%></font>。
          <%if not isNewVersion then%>
          请<a href=update/><font color="#0033CC">立即升级</font></a>
          <%else%>
            当前已经是最新版本!
          <%end if%><br>
          <%
		  set u_rs=conn.execute("select * from UserDetail where u_type<>'0'")
		  u_uname=""
		  do while not u_rs.eof
		    
				  if u_uname="" then
				  u_uname=u_rs("u_name")
				  else
				  u_uname=u_uname&","&u_rs("u_name")
				  end if
				  if trim(u_rs("u_name"))=trim(session("user_name")) then
				   u_ip=u_rs("u_ip")
				  end if
		  u_rs.movenext
		  loop
		  u_rs.close
		  set u_rs=nothing
		 
		  
		  array_temp=split(u_ip&"",",")
		  if ubound(array_temp)-1>=0 then
		  t_temp=split(array_temp(ubound(array_temp)-1)&"","|")
		  lostip=t_temp(0)
		   losttime=t_temp(1)
		  end if
		  %>
          
               <img src="images/warning.gif" width="16" height="16"> 当前系统管理员列表：<a href="setuser" title="点击进行管理员修改操作"><font color="#0000FF"><%=u_uname%></font></a>。 上次登录时间:<font color="red"><%=losttime%></font>，登录IP：<font color="#0000ff"><%=lostip%></font>
<BR>

          <%if lcase(mailfrom)="agentuser@west.cn" then%><img src="images/warning.gif" width="16" height="16"> <font color="#FF0000"><b>您的代理平台发件人地址还是：agentuser@west.cn,请<a href="/siteadmin/SystemSet/EditConfig.asp">修改</a></b></font><%end if%>
          <br>
          <br>
          <%server.execute("/config/autonote.asp")%>
        </div>
        </td>
        <td width="24%" align="left">
        <%
		 
		Set md5Dic = CreateObject("scripting.dictionary")
		tempWords=Array("110110","5201314","1314520","987654321","54321","001","002","007","008","10th","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","100","101","108","133","163","166","188","233","266","350","366","450","466","136","137","138","139","158","168","169","192","198","200","222","233","234","258","288","300","301","333","345","388","400","433","456","458","500","555","558","588","600","666","598","668","678","688","888","988","999","1088","1100","1188","1288","1388","1588","1688","1888","1949","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1997","1999","2000","2001","2002","2088","2100","2188","2345","2588","3000","3721","3888","4567","4728","5555","5678","5888","6666","6688","6789","6888","7788","8899","9988","9999","23456","34567","45678","88888","654321","737","777","1111","2222","3333","4321","computer","cpu","memory","disk","soft","y2k","software","cdrom","rom","admin","master","card","pci","lock","ascii","knight","creative","modem","internet","intranet","web","www","isp","unlock","ftp","telnet","ibm","intel","microsoft","dell","compaq","toshiba","acer","info","aol","56k","server","dos","windows","win95","win98","office","word","excel","access","unix","linux","password","file","program","mp3","mpeg","jpeg","gif","bmp","billgates","chip","silicon","sony","link","word97","office97","network","ram","sun","yahoo","excite","hotmail","yeah","sina","pcweek","mac","apple","robot","key","monitor","win2000","office2000","word2000","net","virus","company","tech","technology","print","coolweb","guest","printer","superman","hotpage","enter","myweb","download","cool","coolman","coolboy","coolgirl","netboy","netgirl","log","login","connect","email","hyperlink","url","hotweb","java","cgi","html","htm","home","homepage","icq","mykey","c++","basic","delphi","pascal","anonymous","crack","hack","hacker","chinese","vcd","chat","chatroom","mud","cracker","happy","hello","room","english","user","netizen","frontpage","agp","netwolf","acdsee","usa","hot","site","address","mail","news","topcool","win98","qq2000","mylove","admin888","admin8","admin88","aaabbb")
		
		for each word in tempWords
			md5str = lcase(cstr(md5_16(word)))
			if not md5Dic.exists(md5str) then
				md5Dic.add md5str,""
			end if
		next
		'--------------------------------------------------------------
		strng=""
		if api_username="demo5" then
			strng=strng & "<li>您的API账号" & api_username & "设置不正确，业务将无法进行。</li>"
		end if
		
 	sql="select u_id,u_name,u_password from userdetail where u_type<>'0'"' and u_password in ('469e80d32c0559f8','7a57a5a743894a0e','4817cc8dcbb3fb5c','7f8d3ee6b2525320')"
 		rs.open sql,conn,1,1
 		while not rs.eof
 		u_name=rs("u_name")
 			u_password=rs("u_password")
 			if md5Dic.exists(lcase(cstr(u_password))) then
 				strng=strng & "<li>管理账号<a href='usermanager/detail.asp?u_id="&rs("u_id")&"' target=""_blank"" style=""color:red"" title=""点击帐号修改"">" & u_name & "</a>的密码是弱口令，黑客会盗用您的资产，请立即修改！</li>"
 			end if
 			rs.movenext
 		wend
     	rs.close
		
		if strng<>"" then
		%>
         <div style="border:#FF9900 solid 1px; background:#ffffcc; width:170px">
          <TABLE cellSpacing=0 cellPadding=0 width="90%" border=0>
          <tr><td><span class="STYLE8">*警告:</span></td>
          </tr>
          <tr><td><%=strng%></td>
          </tr>
          <tr><td align="right"><a href="<%=SystemAdminPath%>/SystemSet/EditConfig.asp"><font color=blue>[设置]</font></a>&nbsp;<a href="http://help.west.cn/help/list.asp?unid=372" target="_blank"><font color=blue>[帮助]</font></a></td>
          </tr>
          </TABLE>
         </div>
        <%end if%>
        
        
        
        
<script type="text/javascript" src="http://api.west.cn/api/agent_api/ad.js" ></script>

        
        
        
        
        
        
        
        
        </td>
        </tr>
        </table>
      </TD>
    </TR>
    <TR>
      <TD align="left">
      <table width="100%" border="0" align="center">
      <tr>
      <td width="33%" valign="top">
      <table width="100%" border="0" align=center cellpadding="4" cellspacing="1" class="border">
           <tr>
            <td height=25 colspan=2 class="Title"><strong>系统初次使用指南</strong></td>
          </tr>
          <tr>
            <td width="15%" height=37 align="center" class="tdbg"><img src="images/user_tag1.gif" alt="" width="36" height="30" /></td>
            <td width="*" height="37" align="left" class="tdbg"><a href="admin/default2.asp" class="STYLE3">修改登陆密码</a>:注意设置好email和手机号，方便忘记密码时找回</td>
          </tr>
          <tr>
            <td height=23 align="center" class="tdbg"><img src="images/user_tag2.gif" alt="" width="36" height="38" /></td>
            <td width="0" height=23 align="left" class="tdbg"><a href="SystemSet/EditConfig.asp">系统设置(将对你网站的信息显示,相关接口的设置和修改)</a></td>
          </tr>
          <tr>
            <td height=23 align="center" class="tdbg"><img src="images/user_tag3.gif" alt="" width="36" height="36" /></td>
            <td width="*" align="left" class="tdbg"><a href="productmanager/default.asp">进行产品设置(调整价格等，可批量调整价格)</a></td>
          </tr>
          <tr>
            <td height=23 align="center" class="tdbg"><img src="images/user_tag4.gif" width="36" height="34"></td>
            <td width="0" height=23 align="left" class="tdbg"><a href="SystemSet/EditNumber.asp">支付方式设置(设置用户在线支付的方式)</a></td>
          </tr>
          <tr>
            <td height=34 align="center" class="tdbg"><img src="images/user-tag6.jpg" width="37" height="32"></td>
            <td width="0" height=34 align="left" class="tdbg"><a href="SystemSet/LogoUpload.asp">上传网站Logo</a>，<a href="SystemSet/TemplateSet.asp">模板设置</a>，进行适当美化（可选）。设置好以后即可开张营业。</td>
          </tr>
        </table>
        </td>
        <td width="33%" valign="top">
          <table width="100%" border="0" align=center cellpadding="0" cellspacing="1" class="border">
           <tr>
            <td width="85%" height=25 class="Title"><strong>内部新闻公告</strong></td>
           
           </tr>
           <tr bgcolor="#FFFFFF">
            <td width="15%" height=37 align="center">
            <script language="javascript">
				<%=getjsnews("https://api.west.cn/api/news/?act=nbxw")%>
			</script>
			</td>
           </tr>
            <tr bgcolor="#FFFFFF">
           <td width="15%" height="9" align="right"><a href="http://www.west.cn/news2/default.asp" target="_blank" class="STYLE7">More..</a></td>
           </tr>
          </table>
        </td>
        
        <TD width="33%" valign="top"><table width="100%" border="0" align=center cellpadding="0" cellspacing="1" class="border">
          <tr>
            <td width="85%" height=25 class="Title"><strong>代理公告与动态</strong></td>
          </tr>
          <tr bgcolor="#FFFFFF">
            <td width="15%" height=37 align="center"><script language="javascript">
			<%=getjsnews("https://api.west.cn/api/news/?act=dlxw")%>
			</script></td>
          </tr>
          <tr bgcolor="#FFFFFF">
            <td width="15%" height="9" align="right"><a href="http://www.west.cn/news3/" target="_blank" class="STYLE7">More..</a></td>
          </tr>
        </table></TD>
        </tr>
        
        
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
        </table>
        <table width="50%" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td nowrap ><strong>常用功能</strong></td>
          </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="Title">
          <tr>
            <td height="1"></td>
          </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td><a href="customercenter/default.asp">有问必答</a>| <a href="admin/Unprocess.asp" target="main"><span class="STYLE6">等手工处理订单</span></a> | <a href="sitemanager/ViewAPILog.asp" target="main"><span class="STYLE6">日志查看</span></a> | <a href="billmanager/Vpayend.asp" target="main"><span class="STYLE6">付款确认</span></a> | <a href="billmanager/incount.asp" target="main"><span class="STYLE6">用户入款</span></a> | <a href="billmanager/ViewOurMoney.asp" target="main"><span class="STYLE6">查看流水</span></a> | <a href="domainmanager/default.asp" target="main"><span class="STYLE6">域名管理</span></a> | <a href="sitemanager/default.asp" target="main"><span class="STYLE6">主机管理 </span></a>| <a href="productmanager/pricequery.asp" target="main"><span class="STYLE6">价格查询</span></a> </td>
          </tr>
          <tr>
            <td><div align="left">
                <hr>
              </div></td>
          </tr>
        </table>
        <br />
        <table width="100%" border="0" cellpadding="0" cellspacing="1" class="border">
          <tr>
            <td height="25" colspan="2" valign="middle" class="Title"><strong>系统管理帮助</strong></td>
          </tr>
          <tr>
            <td width="15%" height="27" align="right" class="tdbg">产品开发：</td>
            <td height="27" class="tdbg"><a href="http://www.west.cn" target="_blank">西部数码开发部</a></td>
          </tr>
          <tr>
            <td align="right" class="tdbg">渠道专员：</td>
            <td class="tdbg"> 
              联系电话：028-86263048 86267838 86262244　86264018
              <div style="zoom:1;overflow:hidden;margin-top:5px;">
              您的客服专员：<%
'读取我的客服专员
diqukefu=request.Cookies("diqukefu")
if diqukefu="" then
cmdinfo="other" & vbcrlf & _
			"get" & vbcrlf & _
			"entityname:mykefuinfo" & vbcrlf & _
			"." & vbcrlf
diqukefu=connectToUp(cmdinfo)
Call SetHttpOnlyCookie("diqukefu",diqukefu,"","/",date()+2)
end if
if left(diqukefu,3)="200" then
	diqukefu = mid(diqukefu, instr(diqukefu,",")+1)
	kefu = split(diqukefu,",")
	response.Write kefu(0) & " 分机：" & kefu(1) & " QQ：" & kefu(2)
else
    response.Write "无法读取，或您未完善在主站的资料"
end if		  
%>
        </div>
              
              
              </td>
          </tr>
          
          <tr>
            <td height="21" align="right" class="tdbg">开发论坛：</td>
            <td height="21" class="tdbg"><a href="http://help.west.cn/bbs" target="_blank"><font color="#0000FF">在线交流论坛</font></a> (对本系统有任何疑问、建议都可以到论坛提问，会有专人为您解答) </td>
          </tr>
        </table>
        <br>
        <table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
          <tr align="center">
            <td height=25 colspan=2 class="topbg"><span class="Glow">服 务 器 信 息</span> 
          </tr>
          <tr class="tdbg" height=23>
            <td width="50%">服务器类型： <%=Request.ServerVariables("OS")%>(IP:<%=Request.ServerVariables("LOCAL_ADDR")%>)</td>
            <td width="50%">脚本解释引擎：
              <%
    response.write ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion
    If CSng(ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion) < 5.6 Then
        response.write "&nbsp;&nbsp;<a href='http://www.microsoft.com/downloads/release.asp?ReleaseID=33136' target='_blank'><font color='green'>版本过低，请点此更新</font></a>"
    End If
    %>
            </td>
          </tr>
          <tr class="tdbg" height=23>
            <td width="50%">站点物理路径： <%=request.ServerVariables("APPL_PHYSICAL_PATH")%></td>
            <td width="50%">数据库使用：
              <%ShowObjectInstalled("adodb.connection")%>
            </td>
          </tr>
          <tr class="tdbg" height=23>
            <td width="50%">FSO文本读写：
              <%ShowObjectInstalled(objName_FSO)%>
            </td>
            <td width="50%">数据流读写：
              <%ShowObjectInstalled("Adodb.Stream")%>
            </td>
          </tr>
          <tr class="tdbg" height=23>
            <td width="50%">XMLHTTP组件支持：
              <%ShowObjectInstalled("Microsoft.XMLHTTP")%>
            </td>
            <td width="50%">XMLDOM组件支持：
              <%ShowObjectInstalled("Microsoft.XMLDOM")%>
            </td>
          </tr>
          <tr class="tdbg" height=23>
            <td width="50%">XML组件支持：
              <%ShowObjectInstalled("MSXML2.XMLHTTP")%>
            </td>
            <td width="50%">Jmail组件支持：
              <%ShowObjectInstalled("JMail.SMTPMail")%>
            </td>
          </tr>
        </table></TD>
    </TR>
  </TBODY>
</TABLE>

<div id="peinfo3" style="height:1;overflow=auto;visibility:hidden;">
  <script src="http://help.west.cn/note/default.asp"></script>
</div>
<div id="peinfo4" style="height:1;overflow=auto;visibility:hidden;"> </div>
<script language="JavaScript">
marqueesHeight=36;
scrillHeight=20;
scrillspeed=60;
stoptimes=50;
stopscroll=false;preTop=0;currentTop=0;stoptime=0;
peinfo1.scrollTop=0;
with (peinfo1)
{
  style.width=0;
  style.height=marqueesHeight;
  style.overflowX='visible';
  style.overflowY='hidden';
  noWrap=true;
  onmouseover=new Function("stopscroll=true");
  onmouseout=new Function("stopscroll=false");
}
function init_srolltext()
{
  peinfo2.innerHTML='';
  peinfo2.innerHTML+=peinfo3.innerHTML;
  peinfo1.innerHTML=peinfo3.innerHTML+peinfo3.innerHTML;
  setInterval("scrollUp()",scrillspeed);
}

function init_peifo()
{
  peinfo5.innerHTML=peinfo4.innerHTML;
}
function scrollUp()
{
  if(stopscroll==true) return;
  currentTop+=1;
  if(currentTop==scrillHeight)
  {
   stoptime+=1;
   currentTop-=1;
   if(stoptime==stoptimes) { currentTop=0; stoptime=0; }
  }
  else
  {
   preTop=peinfo1.scrollTop;
   peinfo1.scrollTop+=1;
   if(preTop==peinfo1.scrollTop){ peinfo1.scrollTop=peinfo2.offsetHeight-marqueesHeight; peinfo1.scrollTop+=1; }
  }
}
init_peifo();
setInterval("",1000);
init_srolltext();
</script>
</BODY>
</HTML>
<%
conn.close

Sub ShowObjectInstalled(strObjName)
	If IsObjInstalled(strObjName) Then
		Response.Write "<b>√</b>"
	Else
		Response.Write "<font color='red'><b>×</b></font>"
	End If
End Sub
'**************************************************
'函数名：IsObjInstalled
'作  用：检查组件是否已经安装
'参  数：strClassString ----组件名
'返回值：True  ----已经安装
'        False ----没有安装
'**************************************************
function IsObjInstalled(strClassString)
    On Error Resume Next
    IsObjInstalled = False
    Err = 0
    Dim xTestObj
    Set xTestObj = CreateObject(strClassString)
    If Err.Number = 0 Then IsObjInstalled = True
    Set xTestObj = Nothing
    Err = 0
End Function
sub opendiv()
%>
<DIV id=eMeng style="BORDER-RIGHT: #455690 1px solid; BORDER-TOP: #a6b4cf 1px solid; Z-INDEX:99999; LEFT: 0px; VISIBILITY: hidden; BORDER-LEFT: #a6b4cf 1px solid; WIDTH: 180px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 0px; HEIGHT: 116px; BACKGROUND-COLOR: #c9d3f3">
  <TABLE style="BORDER-TOP: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid" cellSpacing=0 cellPadding=0 width="100%" bgColor=#cfdef4 border=0>
    <TBODY>
      <TR>
        <TD style="FONT-SIZE: 12px;COLOR: #0f2c8c" width=30 height=24></TD>
        <TD style="FONT-WEIGHT: normal; FONT-SIZE: 12px;COLOR: #1f336b; PADDING-TOP: 4px;PADDING-left: 4px" vAlign=center width="100%">今天的系统记录：</TD>
        <TD style="PADDING-TOP: 2px;PADDING-right:2px" vAlign=center align=right width=19><span title=关闭 style="CURSOR: hand;color:red;font-size:12px;font-weight:bold;margin-right:4px;" onclick=closeDiv() >×</span>
          <!-- <IMG title=关闭 style="CURSOR: hand" onclick=closeDiv() hspace=3 src="msgClose.jpg"> --></TD>
      </TR>
      <TR>
        <TD style="PADDING-RIGHT: 1px; PADDING-BOTTOM: 1px" colSpan=3 height=90><DIV style="BORDER-RIGHT: #b9c9ef 1px solid; PADDING-RIGHT: 13px; BORDER-TOP: #728eb8 1px solid; PADDING-LEFT: 13px; FONT-SIZE: 12px; PADDING-BOTTOM: 13px; BORDER-LEFT: #728eb8 1px solid;  COLOR: #1f336b; PADDING-TOP: 18px; BORDER-BOTTOM: #b9c9ef 1px solid;WIDTH: 100%;HEIGHT: 100%; background-color:#FFFFFF">
            <!--待手工处理业务多少个、新业务订单多少个-->
            <%
		  dim SqlstrArr(9)
         		 SqlstrArr(0)="Select count(*) from Unprocess where dateDiff("&PE_DatePart_D&",odate,"&PE_Now&")=0|待手工处理|"& SystemAdminPath &"/admin/Unprocess.asp" '待手工处理
		  		 SqlstrArr(1)= "select count(*) from PreHost where dateDiff("&PE_DatePart_D&",sDate,"&PE_Now&")=0|主机订单|"& SystemAdminPath &"/sitemanager/PreHost.asp"'
				 SqlstrArr(2)="select count(*) from PreDomain where dateDiff("&PE_DatePart_D&",regDate,"&PE_Now&")=0|域名订单|"& SystemAdminPath &"/domainmanager/PreDomain.asp"'
				 SqlstrArr(3)="select count(*) from vhhostlist where ((left(s_productid,2)='tw' or left(s_productid,1)='m') and dateDiff("&PE_DatePart_D&",s_buydate,"&PE_Now&")=0) or ((left(s_productid,2)<>'tw' and left(s_productid,1)<>'m') and dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_M&",-1,s_buydate),"&PE_Now&")=0)|购买主机|"& SystemAdminPath &"/sitemanager/default.asp"'
				 SqlstrArr(4)="select count(*) from domainlist where dateDiff("&PE_DatePart_D&",regdate,"&PE_Now&")=0|购买域名|"& SystemAdminPath &"/domainmanager/default.asp"'
				 SqlstrArr(5)="select count(*) from mailsitelist where dateDiff("&PE_DatePart_D&",m_buydate,"&PE_Now&")=0|购买邮局|"& SystemAdminPath &"/mailmanager/default.asp" '
				SqlstrArr(6)= "select count(*) from databaselist where dateDiff("&PE_DatePart_D&",dbbuydate,"&PE_Now&")=0|MSSQL数据库|"& SystemAdminPath &"/sqlmanager/default.asp"
				SqlstrArr(7)="select count(*) from userdetail where dateDiff("&PE_DatePart_D&",u_regdate,"&PE_Now&")=0|新注册用户|"& SystemAdminPath &"/usermanager/default.asp"
				SqlstrArr(8)= "select count(*) from ourmoney where dateDiff("&PE_DatePart_D&",PayDate,"&PE_Now&")=0|财务流水|"& SystemAdminPath &"/billmanager/ViewOurMoney.asp"
				SqlstrArr(9)= "select count(*) from question where dateDiff("&PE_DatePart_D&",q_reg_time,"&PE_Now&")=0|有问必答|"& SystemAdminPath &"/customercenter/default.asp"

				redim seeArr(ubound(SqlstrArr),2)
				curcur=0
				divsql=""

				for each stritem in SqlstrArr
					newstritem=split(stritem,"|")
					if ubound(newstritem)>1 then
						
						set divRs=conn.execute(newstritem(0))
						if not divRs.eof then
							seeArr(curcur,0)=divRs(0)
						else
							seeArr(curcur,0)=0
						end if
						divRs.close
				  		set divRs=nothing
						seeArr(curcur,1)=newstritem(1)
						seeArr(curcur,2)=newstritem(2)
					end if
				curcur=curcur+1
				next
				 
          %>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
            <%
			for jj=0 to ubound(seeArr,1)
				msgs=seeArr(jj,0)
				titles=seeArr(jj,1)
				urls=seeArr(jj,2)
				fontcolor="#cccccc"
				spancolor="STYLE5"
				if msgs>0 then
				fontcolor="red"
				spancolor="STYLE6"
				end if
			%>
              <tr onMouseOver="this.style.background='#EAF5FC';" onMouseOut="this.style.background='#ffffff'">
                <td><a href="<%=urls%>"><font color="blue"><%=titles%></font></a></td>
                <td><a href="<%=urls%>"><span class="<%=spancolor%>"><font color="<%=fontcolor%>"><%=msgs%></font>&nbsp;条记录</span></a></td>
              </tr>
            <%
			next
			%>
            </table>
            <!---over-->
          </DIV></TD>
      </TR>
    </TBODY>
  </TABLE>
</DIV>
<script language="javascript" src="/Scripts/OpenWindow.js"></script>
<%
end sub
function getjsnews(byval strURL)
	Set objxml=CreateObject("MSXML2.ServerXMLHTTP")
	objxml.open "GET",strURL,false
	objxml.send
	if objxml.status=200 then
		bodystr=bstr(objxml.ResponseBody)
	else
		bodystr=""
	end if
	set objxml=nothing
	getjsnews=setnewsstr(bodystr)
end function
function setnewsstr(byval newstr)
	if len(newstr)>0 then
		newstr=replace(newstr,"href='/news","target='_blank' href='http://west.cn/news")
		newstr=replace(newstr,"background=/images/","background=http://www.west.cn/images/")
	end if
	setnewsstr=newstr
end function

 
%>