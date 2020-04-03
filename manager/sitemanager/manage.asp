<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-虚拟主机管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<%
p_id=requesta("p_id")
act=requesta("act")
if len(p_id)<=0 then url_return "参数错误",-1
sql="select * from vhhostlist where s_sysid="& p_id &" and S_ownerid=" & session("u_sysid")
rs.open sql,conn,1,3
if rs.eof and rs.bof then rs.close:conn.close:url_return "没有找到此产品",-1
s_comment=rs("s_comment")
session("Control_vhost_name")=s_comment
s_ftppassword=rs("s_ftppassword")
s_serverIP=rs("s_serverIP")
if s_serverIP="" then s_serverIP = s_comment & "." & rs("s_serverName")
s_buydate=rs("s_buydate")
s_expiredate=rs("s_expiredate")
s_ProductId=rs("s_ProductId")

If act="synmail" Then '同步赠品域名
	commandstr="other" & vbcrlf & _
				"get" & vbcrlf & _
				"entityname:getvhostmail" & vbcrlf & _
				"sitename:" & s_comment & vbcrlf & _
				"." & vbcrlf
	loadRet=connectToUp(commandstr)  
	if left(loadRet,3)="200" Then
		objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}"  
		set obj_=jsontodic(objstr) 
 		set ars=Server.CreateObject("adodb.recordset")

		If ubound(obj_("datas"))>=0 then
			for each line_ in obj_("datas")
				sql="select top 1 * from mailsitelist  where m_bindname='" & line_("m_bindname") &"'"
			 	ars.open sql,conn,1,3
				if ars.eof then
					ars.addnew()				
					ars("m_bindname")=line_("m_bindname")
				end If
					ars("m_ownerid")=session("u_sysid")
					ars("m_serverip")=line_("m_serverip")
					ars("m_productid")=line_("m_productid")
					ars("m_buydate")=line_("m_buydate")
					ars("m_expiredate")=line_("m_expiredate")
					ars("m_serverip")=line_("m_serverip")
					ars("m_password")=line_("m_password")
					ars("m_status")=line_("m_status")
					ars("m_free")=line_("m_free")
					ars("m_buytest")=line_("m_buytest")
					ars("preday")=line_("preday")
					ars("alreadypay")=line_("alreadypay")
					ars("postnum")=line_("postnum")
					ars("m_years")=line_("m_years")
				ars.update
				ars.close
				Set ars=Nothing 
			Next
		    alert_redirect "同步邮局成功!",request("script_name") & "?p_id=" & p_id
		Else
			alert_redirect "同步失败:您还没有开通免费邮局,可登陆高级管理进行获取!" ,request("script_name") & "?p_id=" & p_id
		End if
	Else
		alert_redirect "同步失败:"& loadRet ,request("script_name") & "?p_id=" & p_id
	End if


   
	

elseif act="changepwd" then
        newpwd=requesta("p_pwd")
         ftppwd=requesta("ftppassword")

		 pwderrstr=checkpwdcpx(newpwd,s_comment,"FTP",8,50,5)  
		 If  Trim(pwderrstr)<>"" Then
			issimple="true"
			die url_return(pwderrstr,-1)
		 End if


	
	commandstr="vhost" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:ftppassword" & vbcrlf & _
				"sitename:" & s_comment & vbcrlf & _
				"ftppassword:" & newpwd & vbcrlf & _
				"." & vbcrlf
	
	if isBad(s_comment,newpwd,binfo) then url_return "FTP密码很重要，您输入的密码过于简单，请重新设置。",-1
	if checkPassStrw(newpwd) then url_return "密码中含有不可识别的字符，请重新设置。",-1
		
	renewdata=pcommand(commandstr,session("user_name"))
	if left(renewdata,3)="200" then
		alert_redirect "修改密码成功",request("script_name") & "?p_id=" & p_id
	else
		alert_redirect "修改密码失败:"& renewdata ,request("script_name") & "?p_id=" & p_id
	end if
	rs.close
	conn.close
	response.end
elseif act="syn" then
	returnstr=doUserSyn("vhost",s_comment)
	if left(returnstr,3)="200" then
		alert_redirect "同步数据成功",request("script_name") & "?p_id=" & p_id
	else
	 	alert_redirect "同步数据失败" & returnstr,request("script_name") & "?p_id=" & p_id
	end if
end if
''''''''''''''''''''''''''''''''''''''赠品相关''''''''''''''''''''''''''''''''''''
 set prs=server.CreateObject("adodb.recordset")
 domainFree=false
 hostFree=false
 mssqlFree=false
 mysqlFree=false
 preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4 from protofree a inner join vhhostlist b on (b.s_buytest="&PE_False&" and a.proid=b.s_productId and b.s_ownerid=" & session("u_sysid") & " and b.s_sysid=" & p_id & " and a.type='host') where not exists(select sysid from protofree where b.s_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='host')"
 prs.open preSql,conn,3
 
 if not prs.eof then
 	if len(trim(prs("pre1")&""))=0 and len(prs("freeproid1")&"")>0 and dateDiff("d",s_buydate,date)<=365 and isgetFreeProduct("host",s_comment,prs("freeproid1")) then	domainFree=true
	if len(trim(prs("pre2")&""))=0 and len(prs("freeproid2")&"")>0  and isgetFreeProduct("host",s_comment,prs("freeproid2"))   then hostFree=true
	if len(trim(prs("pre3")&""))=0 and len(prs("freeproid3")&"")>0   and isgetFreeProduct("host",s_comment,prs("freeproid3"))  then mysqlFree=true
	if len(trim(prs("pre4")&""))=0 and len(prs("freeproid4")&"")>0  and isgetFreeProduct("host",s_comment,prs("freeproid4"))   then mssqlFree=true
 end if
 prs.close
 set prs=nothing
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
rs.close
conn.close
%>
<script language=javascript>
function changepwd(f){
	var v=f.p_pwd;

	if (v.value.length<6){
		alert('密码太短，请重新设置。');
		v.focus();
		return false;
	}
	f.action += '?act=changepwd';
	return confirm('确定修改此密码吗?');

}
function buyfree(f,v){
	if(v!=''){
		f.target='_parent';
		f.action = '/manager/config/getFree.asp';
		f.freeident.value=v;
		f.submit();
	}
}
</script>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			    <li><a href="/Manager/sitemanager/">虚拟管理管理</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 


 <form name=form1 action="<%=request("script_name")%>" method=post>
  <div style="border:dashed 1px #ff0000; padding:7px; background:#ffff99; width:99%; margin:10px auto; margin-bottom:5px;">
友情提示:从2018年5月5日起，续费虚拟主机不再同步延长赠品邮局的时间。赠送的域名和邮局时间为1年，过期后需单独续费。
 </div>
 <table  class="manager-table">
 
    <tr>
      <th align="right">ftp名:</th>
      <td align="left"><%=s_comment%>&nbsp;&nbsp;<a href="ftp://<%=s_comment&":"&s_ftppassword&"@"&s_serverIP%>/" target="_blank"><font color="blue">[上传]</font></a></td>
      <th  align="right">密码:</th>
      <td align="left"><input type=text value="<%=s_ftppassword%>" name="p_pwd"  class="manager-input s-input" >
        <input type="submit" value="修改密码"  class="manager-btn s-btn" onclick="return changepwd(this.form)" class="manager-btn s-btn"></td>
    </tr>
    <tr>
      <th align="right">服务器地址:</th>
      <td align="left"><%=s_serverIP%></td>
      <th align="right">主机型号:</th>
      <td align="left"><%=s_ProductId%></td>
    </tr>
    <tr>
      <th align="right">购买时间:</th>
      <td align="left"><%=s_buydate%></td>
      <th align="right">到期时间:</th>
      <td align="left"><%=s_expiredate%></td>
    </tr>
    <tr>
      <td  colspan=4 align="center" ><input type="submit" name="sub2" value="进入高级管理" onclick="javascript:this.form.action='../jump.asp?t=vhost&n=<%=s_comment%>';this.form.target='_blank';"  class="manager-btn s-btn" >
        <input type="submit" name="sub3" value="   同步数据   " onclick="javascript:this.form.action='<%=request("script_name")%>?act=syn';"  class="manager-btn s-btn">
        <input type="button"  value="流量充值" onclick="location.href='add_traffic.asp'"  class="manager-btn s-btn">
		<input type="button"  value="同步赠品邮局" onclick="location.href='<%=request("script_name")%>?act=synmail&p_id=<%=p_id%>'"  class="manager-btn s-btn">

        <input type="hidden" name="ftpname" value="<%=s_comment%>">
        <input type="hidden" name="sign" value="<%=WestSignMd5(s_comment,s_ftppassword)%>">
        <input type="hidden" name="p_id" value="<%=p_id%>">
        <input type="hidden" name="freetype" value="host">
        <input type="hidden" name="freeident" value=""></td>
    </tr>
    <tr>
      <td colspan=4 ><table  class="manager-table">
          <tr>
            <th align="center" colspan=4><img src="/Template/Tpl_01/images/!.GIF" width="27" height="33">提示：如果进入高级管理提示密码错误，请先修改密码。</th>
          </tr>
          <tr>
            <th colspan=4>获 取 赠 品</th>
          </tr>
          <tr>
            <td align="center"><%
			if not domainFree then%>
              <img src="../images/agent_free_button_1_1.jpg" width="115" height="24" border="0" />
              <%else%>
              <a href="javascript:;" onclick="buyfree(form1,'domain')"><img src="../images/agent_free_button_1_2.jpg" width="115" height="24" border="0" /></a>
              <%end if%></td>
            <td align="center"><%if not hostFree then%>
              <img src="../images/agent_free_button_2_1.jpg" width="115" height="24" border="0" />
              <%else%>
              <a href="javascript:;" onclick="buyfree(form1,'vhost')"><img src="../images/agent_free_button_2_2.jpg" width="115" height="24" border="0" /></a>
              <%end if%></td>
            <td align="center"><%if not mssqlFree then%>
              <img src="../images/agent_free_button_4_1.jpg" width="115" height="24" border="0" />
              <%else%>
              <a href="javascript:;" onclick="buyfree(form1,'mssql')"><img src="../images/agent_free_button_4_2.jpg" width="115" height="24" border="0" /></a>
              <%end if%></td>
          </tr>
          <tr>
            <td align="left" colspan=4> *注:
              <ul>
                <li>可以通过本功能免费获取虚拟主机赠送的域名，数据库和邮局赠品请点击“进入高级管理”获取。</li>
 <li>主机开通后365天内可获取赠品，过期未领取表示自动放弃赠品。</li>
 <li>赠送的域名和邮局使用期限为一年，到期后若要继续使用需自行办理续费；其他赠品使用期限同产品使用时间，续费产品则赠品到期时间会同步延长，无需支付赠品续费费用。</li>
 <li>需直接开通含有域名赠品的主机型号才能获取域名赠品，中途升级到含有域名赠品的主机型号则不支持。产品升级后将不能再获得赠品。</li>
 <li>如果该产品是赠品，将不能再获得针对此产品的赠品。 </li>
              </ul></td>
          </tr>
        </table></td>
    </tr>
 
</table>
 </form>




		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>