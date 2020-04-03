<!--#include virtual="/manager/config/config.asp" --><%Check_Is_Master(6)%>
<script src="/config/mouse_on_title.js"></script>
<html>
<head>
<title>虚拟主机续费管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
td {  font-size: 9pt}
.STYLE4 {
	color: #0066CC;
	font-weight: bold;
}
.STYLE5 {color: #0066CC}
-->

</style>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<%
conn.open constr
act=trim(requesta("act"))
searchday = trim(requesta("searchday"))
noteSmarkid = trim(requesta("noteSmarkid"))
markid =	trim(requesta("markid"))
u_name=	trim(requesta("u_name"))
if notesmarkid="" then notesmarkid=0
noteSmark="=''"
if noteSmarkid=1 then noteSmark="<>''"
if searchday="" or not isnumeric(searchday) then searchday=30 

setsize=15 '分页数
cur=1	   '全局
sysfiledid=""
filedmark=""
fileduserid=""
allcolor="#000000"
vhostcolor=allcolor:mailcolor=allcolor:domaincolor=allcolor
dim searchItem:dim condition:dim searchValue:dim othercode:dim sqlArray:dim pagenumlist
formothercode="act=" & act
select case lcase(act)
	case "mail"
		mailcolor="blue"
		call doMailInsqlsub(markid)
		set myrs=domail(searchday,filedArray)
		
	case "domain"
		domaincolor="blue"
		call doDomainInsqlsub(markid)
		set myrs=dodomain(searchday,filedArray)
	case "mssql"
		mssqlcolor="blue"
		call domssqlInsqlsub(markid)
		set myrs=domssql(searchday,filedArray)
	case "server"
		servercolor="blue"
		call doserverInsqlsub(markid)
		set myrs=doserver(searchday,filedArray)
	case else
		vhostcolor="blue"
		call doVhostInsqlsub(markid)
		set myrs=dovhost(searchday,filedArray)
    
end select
%>
<script language="javascript">
function donotesub(){
	document.form1.submit();
}
function domark(cur){
	var f=document.getElementById('trmark' + cur);
	//f.style.display='';
	if(f.style.display==''){
		f.style.display='none';
	}else{
		f.style.display='';
	}
}
function marksub(cur){
	var f=eval('document.form1.s_mark' + cur);
	if(f.value!=''){
		if (f.value.lenght>250){
			alert('备注长度不能超过250个字符');
			f.focus();
			return false
		}
		var mar=document.form1.markid;
		mar.value=cur;
		return true;
	}else{
		return false;
	}
}

</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>虚拟主机续费管理(今天日期：<%=formatDateTime(now(),2)%>)</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">
     <a href="c_charge.asp?u_name=<%=u_name%>"><font color="<%=vhostcolor%>">主机续费通知</font></a> | 
    <a href="c_charge.asp?act=mail&u_name=<%=u_name%>"><font color="<%=mailcolor%>">邮局续费通知</font></a> | 
    <a href="c_charge.asp?act=domain&u_name=<%=u_name%>"><font color="<%=domaincolor%>">域名续费通知</font></a> | 
    <a href="c_charge.asp?act=mssql&u_name=<%=u_name%>"><font color="<%=mssqlcolor%>">MSSQL续费通知</font></a> | 
    <a href="c_charge.asp?act=server&u_name=<%=u_name%>"><font color="<%=servercolor%>">服务器续费通知</font></a></td>
  </tr>
</table>
<br>
<form name="form1" action="<%=request("script_name")%>?<%=formothercode%>" method="post">
<table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">

 <tr>
    <td width="46%" align="right" class="tdbg" nowrap>
     会员帐号: <input name="u_name" type="text" id="u_name" value="<%=u_name%>" size="10">
    查找剩余日期小于

      <input name="searchday" type="text" id="searchday" value="<%=searchday%>" size="3">天的站点
      <input type="submit" name="searchsub" value=" 开始查找 ">
      <input type="radio" value=0 name="noteSmarkid" <%if notesmarkid=0 then response.write "checked "%> onClick="donotesub()">未备注
      <input type="radio" value=1 name="noteSmarkid" <%if notesmarkid=1 then response.write "checked "%> onClick="donotesub()">已备注
      
	</td>
  </tr>
<tr align="center">
<td>

<table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
  <tr align="center">
    <%
	for each filedname in filedArray
		if filedname<>"" and instr(filedname,",")>0  then
			fileditem=split(filedname,",")
	%>
    <td nowrap class="Title"><strong><font color="#FFFFFF"><%=fileditem(0)%></font></strong></td>
	<%
		end if
	next
	%>
    <td width="5%" nowrap class="Title"><strong>操作</strong></td>
  </tr>
  <%
  do while not myrs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
	sysid=myrs(sysfiledid)
	s_mark=myrs(filedmark)

	u_id=myrs(fileduserid)
	theuserstring=getuserstring(u_id)
  %>
  <tr bgcolor="<%=tdcolor%>" onmouseover="this.style.background='#FFFFCC';" onmouseout="this.style.background='<%=tdcolor%>'"> 
  <%
	for each filedname in filedArray
		if filedname<>"" and instr(filedname,",")>0  then
			fileditem=split(filedname,",")
			filedvalue=trim(fileditem(1))
			
			lookstr=myrs(filedvalue)
			if isdate(lookstr)			 then lookstr=formatdatetime(lookstr,2)
			if filedvalue="s_bindings"   then lookstr=replace(lookstr,",","<br>")
			if filedvalue="myoutdate"    then lookstr="<font color=red><b>"& lookstr &"</b></font>"
			if filedvalue="u_name" 		 then lookstr="<a  href="""&SystemAdminPath&"/usermanager/detail.asp?u_id="& u_id &""" target=""_blank"" ><font color=blue alt="""& theuserstring &""">"& lookstr &"</font></a>"
			
	%>
    <td nowrap><%=lookstr%></td>
	<%
		end if
	next

	%>
    <td align="center" nowrap>
    	<table width="100%" border="0" cellpadding="3" cellspacing="0" >
        <tr>
        <td align="center" nowrap>
        <%if notesmarkid=1 and s_mark<>"" then
		
			buttonvalue="<font color=blue alt="""& htmlencodes(trim(s_mark)) &""">" & gotTopic(replace(trim(s_mark),vbcrlf,""),18) &"</font>"
		  else
		  	buttonvalue="<b>备注</b>"
		  end if
		%>
        <a href=#### onClick="domark('<%=sysid%>')"><%=buttonvalue%></a>
        </td>
        </tr>
        <tr style="display:none" id="trmark<%=sysid%>"><td>
                <table width="100%" border="0" cellpadding="3" cellspacing="0" >
                <tr><td>
       			<textarea rows="4" name="s_mark<%=sysid%>"><%=trim(s_mark)%></textarea>
                </td></tr>
                <tr><td align="center" newrap>
             
                <input type="submit" name="submark" value="确定" onclick="return marksub('<%=sysid%>')">&nbsp;
                <input type="button" value="取消" name="buttonmark" onClick="domark('<%=sysid%>')">
                </td></tr>
             	</table>
        </td></tr>
        </table>
    </td>
  </tr>
  <%
  cur=cur+1
  myrs.movenext
  loop
  myrs.close
  %>
</table>
</td>
</tr>
<tr><td>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
<tr align="center" bgcolor="#ffffff">
        <td colspan="9" class="tdbg"><%=pagenumlist%></td>
</tr>
<tr>
	<td colspan="9" class="tdbg"><%=searchlist%></td>
</tr>
</table>
<input type="hidden" value="" name="markid">
</td></tr>

</table>
</form>

</body>
<%
function getuserstring(byval u_sysid)
	if u_sysid="" or not isnumeric(u_sysid) then exit function
	UserString="未知"
	usersql="select * from userdetail where u_id=" & u_sysid
	rs11.open usersql,conn,1,1
	if not rs11.eof then

			Namecn=rs11("u_namecn")
			UserName=rs11("u_name")
			Company=rs11("u_company")
			TelPhone=rs11("u_telphone")
			Email=rs11("u_email")
			QQ=rs11("qq_msg")
			Address=rs11("u_address")
			Zip=rs11("u_zipcode")
			Fax=rs11("u_fax")
			UsedMoney=rs11("u_usemoney")
			U_Type=rs11("U_levelName")
			sj=""
			if IsValidMobileNo(msn_msg) then
				sj=msn_msg
			else
				if IsValidMobileNo(TelPhone) then
					sj=TelPhone
				end if
			end if
		
		
			UserString=				"姓名:      " & Namecn & "<br>"
			UserString=UserString & "用户名:    " & UserName & "<br>"
			UserString=UserString & "公司:      " & Company & "<br>"
			UserString=UserString & "<font color=blue>电话:      " & TelPhone & "</font><br>"
			if sj<>"" then UserString = UserString & "手机:      " & sj & "<br>"
			UserString=UserString & "Email:     " & Email & "<br>"
			UserString=UserString & "QQ:        " & QQ & "<br>"
			UserString=UserString & "地址:      " & Address & "<br>"
			UserString=UserString & "邮编:      " & Zip & "<br>"
			UserString=UserString & "传真:      " & FAX & "<br>"
			UserString=UserString & "可用金额:￥" & formatNumber(UsedMoney,2,-1) & "<br>"
			UserString=UserString & "类别:      " & U_Type & "<br>"

	end if
	rs11.close
	getuserstring=UserString
end function
function dovhost(byval searchday,byref filedArray)
	 
	sqlArray=Array("s_comment,站点名,str","s_bindings,绑定域名,str","u_name,用户名,str","s_buydate,购买时间,date","s_expiredate,到期日期,date","s_year,购买年限,int","s_productid,类型ID,str","s_serverIP,IP地址,str")
	newsql=searchEnd(searchItem,condition,searchValue,othercode)
	u_sql=""
	if trim(u_name)<>"" then u_sql=" and c.u_name='"&u_name&"'"
	If isdbsql Then
		betweenstr="0 and " & searchday & " "
		if searchday<0 then betweenstr=" " & searchday & "  and 0"
		sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate) as myoutdate FROM ((vhhostlist a INNER JOIN productlist b on b.p_proid=a.s_productid) INNER JOIN userdetail c on  c.u_id=a.S_ownerid) where dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate) between "&betweenstr&" " & newsql & " and s_buytest="&PE_False&" and isnull(s_mark,'')"& noteSmark  &"  "&u_sql&"  order by s_expiredate"
	else
		sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate) as myoutdate FROM ((vhhostlist a INNER JOIN productlist b on b.p_proid=a.s_productid) INNER JOIN userdetail c on  c.u_id=a.S_ownerid) where dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate) between 0 and " & searchday & " " & newsql & " and s_buytest="&PE_False&" and iif(isnull(s_mark),'',s_mark)"& noteSmark  &" "&u_sql&" order by s_expiredate"
	End if 
	rs.open sqlstring,conn,1,1
	
	pagenumlist=GetPageClass(rs,setsize,othercode&"&noteSmarkid="& noteSmarkid &"&searchday="&searchday&"&"&formothercode&"&u_name="&u_name,pageCounts,linecounts)
	
	set dovhost=rs
	sysfiledid="s_sysid"
	filedmark="s_mark"
	fileduserid="S_ownerid"
	filedArray=Array("站点名,s_comment","绑定域名,s_bindings","IP地址,s_serverIP","用户名,u_name","产品型号,s_productid","开通时间,s_buydate","购买年限,s_year","到期日期,s_expiredate","剩余天数,myoutdate")
end function

function  dodomain(byval searchday,byref filedArray)
  
	sqlArray=Array("strdomain,域名,str","u_name,用户名,str","regdate,购买时间,date","rexpiredate,到期日期,date","years,购买年限,int","proid,类型ID,str")
	newsql=searchEnd(searchItem,condition,searchValue,othercode)
	if trim(u_name)<>"" then u_sql=" and c.u_name='"&u_name&"'"
	If isdbsql Then
	betweenstr="0 and " & searchday & " "
	if searchday<0 then betweenstr=" " & searchday & "  and 0"
	sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",rexpiredate) as myoutdate FROM ((domainlist a INNER JOIN productlist b on b.p_proid=a.proid) INNER JOIN userdetail c on  c.u_id=a.userid) where dateDiff("&PE_DatePart_D&","&PE_Now&",rexpiredate) between "&betweenstr&" " & newsql & " and isnull(s_mark,'')"& noteSmark &" "&u_sql&" order by rexpiredate"
	Else
	

	sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",rexpiredate) as myoutdate FROM ((domainlist a INNER JOIN productlist b on b.p_proid=a.proid) INNER JOIN userdetail c on  c.u_id=a.userid) where dateDiff("&PE_DatePart_D&","&PE_Now&",rexpiredate) between 0 and " & searchday & " " & newsql & " and iif(isnull(s_mark),'',s_mark)"& noteSmark &" "&u_sql&"  order by rexpiredate"
    End if
	rs.open sqlstring,conn,1,1
	
	pagenumlist=GetPageClass(rs,setsize,othercode&"&noteSmarkid="& noteSmarkid &"&searchday="&searchday&"&"&formothercode,pageCounts,linecounts)
	
	set dodomain=rs
	sysfiledid="d_id"
	filedmark="s_mark"
	fileduserid="userid"
	filedArray=Array("域名,strdomain","用户名,u_name","产品型号,proid","开通时间,regdate","购买年限,years","到期日期,rexpiredate","剩余天数,myoutdate")
end function

function  domail(byval searchday,byref filedArray)
	sqlArray=Array("m_bindname,邮局域名,str","u_name,用户名,str","m_buydate,购买时间,date","m_expiredate,到期日期,date","m_years,购买年限,int","m_productid,类型ID,str","m_serverIP,IP地址,str")
	newsql=searchEnd(searchItem,condition,searchValue,othercode)
	
	if trim(u_name)<>"" then u_sql=" and c.u_name='"&u_name&"'"
	If isdbsql Then
		betweenstr="0 and " & searchday & " "
		if searchday<0 then betweenstr=" " & searchday & "  and 0"
		sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",m_expiredate) as myoutdate FROM ((mailsitelist a INNER JOIN productlist b on b.p_proid=a.m_productid) INNER JOIN userdetail c on  c.u_id=a.m_ownerid) where dateDiff("&PE_DatePart_D&","&PE_Now&",m_expiredate) between "&betweenstr& " " & newsql & " and m_buytest="&PE_False&" and isnull(s_mark,'')"& noteSmark  &" "&u_sql&"  order by m_expiredate"
	else
		sqlstring="SELECT a.*,b.p_name,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",m_expiredate) as myoutdate FROM ((mailsitelist a INNER JOIN productlist b on b.p_proid=a.m_productid) INNER JOIN userdetail c on  c.u_id=a.m_ownerid) where dateDiff("&PE_DatePart_D&","&PE_Now&",m_expiredate) between 0 and " & searchday & " " & newsql & " and m_buytest="&PE_False&" and iif(isnull(s_mark),'',s_mark)"& noteSmark  &"  "&u_sql&" order by m_expiredate"
	End if
	rs.open sqlstring,conn,1,1
	pagenumlist=GetPageClass(rs,setsize,othercode&"&noteSmarkid="& noteSmarkid &"&searchday="&searchday&"&"&formothercode,pageCounts,linecounts)
	
	set domail=rs
	sysfiledid="m_sysid"
	filedmark="s_mark"
	fileduserid="m_ownerid"
	filedArray=Array("邮局域名,m_bindname","IP地址,m_serverIP","用户名,u_name","产品型号,m_productid","开通时间,m_buydate","购买年限,m_years","到期日期,m_expiredate","剩余天数,myoutdate")
end function
function doMailInsqlsub(byval sysid)
	if sysid="" or not isnumeric(sysid) then exit function
	markvalue=trim(requesta("s_mark" & sysid))
	if markvalue="" then exit function
	sql="update mailsitelist set s_mark='"& markvalue &"',s_notedate="&PE_Now&" where m_sysid=" & sysid
	conn.execute sql
end function
function doDomainInsqlsub(byval sysid)
	if sysid="" or not isnumeric(sysid) then exit function
	markvalue=trim(requesta("s_mark" & sysid))
	if markvalue="" then exit function
	sql="update domainlist set s_mark='"& markvalue &"',notedate="&PE_Now&" where d_id=" & sysid

	conn.execute sql
end function
function domssqlInsqlsub(byval sysid)
	
end function
function doVhostInsqlsub(byval sysid)
	if sysid="" or not isnumeric(sysid) then exit function
	markvalue=trim(requesta("s_mark" & sysid))
	if markvalue="" then exit function
	sql="update vhhostlist set s_mark='"& markvalue &"',s_notedate="&PE_Now&" where s_sysid=" & sysid
	conn.execute sql
end function
function htmlencodes(fString)
if fString<>"" and not isnull(fstring) then

	fString = replace(fString, ">", "&gt;")
	fString = replace(fString, "<", "&lt;")

	fString = Replace(fString, chr(32), "&nbsp;")
	fString = Replace(fString, CHR(10) & CHR(10), "</P><P>")
	fString = Replace(fString, CHR(10), "<BR>")
	htmlencodes=fString
else
	htmlencodes=""
end if
end function


function domssql(byval searchday,byref filedArray)
	 
	sqlArray=Array("dbname,数据库,str","u_name,用户名,str","dbloguser,登陆帐号,str","dbpasswd,密码,str","dbbuydate,购买时间,date","dbexpdate,到期日期,date","dbyear,购买年限,int","dbproid,类型ID,str","dbserverip,IP地址,str")
	newsql=searchEnd(searchItem,condition,searchValue,othercode)
	if trim(u_name)<>"" then u_sql=" and c.u_name='"&u_name&"'"
	  betweenstr="0 and " & searchday & " "
	 If isdbsql Then
 		if searchday<0 then betweenstr=" " & searchday & "  and 0"
	 end if
		sqlstring="select a.*,c.u_name,dateDiff("&PE_DatePart_D&","&PE_Now&",dbexpdate) as myoutdate from [databaselist] as a  left join [userdetail] as c on c.u_id=a.dbu_id where  dateDiff("&PE_DatePart_D&","&PE_Now&",dbexpdate) between "&betweenstr & " " & newsql & " "&u_sql&" order by dbexpdate"
	 
  'die sqlstring
	rs.open sqlstring,conn,1,1
	
	pagenumlist=GetPageClass(rs,setsize,othercode&"&noteSmarkid="& noteSmarkid &"&searchday="&searchday&"&"&formothercode,pageCounts,linecounts)
	
	set domssql=rs
	sysfiledid="dbsysid"
	filedmark="dbbackup1"
	fileduserid="dbu_id"
	filedArray=Array("数据库,dbname","用户名,u_name","登陆帐号,dbloguser","密码,dbpasswd","服务器地址,dbserverip","产品型号,dbproid","开通时间,dbbuydate","购买年限,dbyear","到期日期,dbexpdate","剩余天数,myoutdate")
end function


function doserver(byval searchday,byref filedArray)
	 
	sqlArray=Array("AllocateIP,IP,str","u_name,用户名,str","preday,赠送天数,int","RamdomPass,密码,str","SubmitTime,购买时间,date","expdate,到期日期,date","Years,购买年限,int","p_proid,类型ID,str")
	newsql=searchEnd(searchItem,condition,searchValue,othercode)
	
	if trim(u_name)<>"" then u_sql=" and  u_name='"&u_name&"'"
	 betweenstr="0 and " & searchday & " "
	 If isdbsql Then
		if searchday<0 then betweenstr=" " & searchday & "  and 0"
	 end if
		sqlstring="select * from(select DateAdd("&PE_DatePart_D&",preday,DateAdd("&PE_DatePart_M&",AlreadyPay,starttime)) as expdate,dateDiff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",preday,DateAdd("&PE_DatePart_M&",AlreadyPay,starttime))) as myoutdate,c.u_id,HostRental.* from [HostRental] left join [userdetail] as c on c.u_name=HostRental.u_name ) as temp   where  myoutdate between "&betweenstr&" " & newsql & " "&u_sql&" order by expdate"
	 
 
	rs.open sqlstring,conn,1,1
	
	pagenumlist=GetPageClass(rs,setsize,othercode&"&noteSmarkid="& noteSmarkid &"&searchday="&searchday&"&"&formothercode,pageCounts,linecounts)
	
	set doserver=rs
	sysfiledid="id"
	filedmark="Memo"
	fileduserid="u_id"
	filedArray=Array("IP,AllocateIP","用户名,u_name","赠送天数,preday","密码,RamdomPass","产品型号,p_proid","开通时间,SubmitTime","购买年限,Years","到期日期,expdate","剩余天数,myoutdate")
end function


function doserverInsqlsub(byval sysid)
	if sysid="" or not isnumeric(sysid) then exit function
	markvalue=trim(requesta("s_mark" & sysid))
	if markvalue="" then exit function
	sql="update HostRental set [Memo]='"& markvalue &"'  where id=" & sysid
 
	conn.execute sql
end function
%>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->