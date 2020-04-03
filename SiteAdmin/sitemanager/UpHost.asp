<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
hostID=Trim(Requesta("HostID"))
if not isNumeric(hostID) then url_return "缺少主机ID",-1
conn.open constr
Sql="Select (select u_name from userdetail where u_id=vhhostlist.s_ownerid) as u_name,s_comment from vhhostlist where s_sysid=" & hostID 
Rs.open Sql,conn,1,1
if Not rs.eof then
	u_name=rs("u_name")
	s_comment=rs("s_comment")
end if
rs.close
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>虚拟主机升级</title>
<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
</head>
<script language="javascript">
function dosub(){
	<%if u_name=session("user_name") then%>
	window.location="/manager/sitemanager/uphost.asp?hostID=<%=hostID%>";
	<%else%>
	$("form[name='form1']").submit();
	<%end if%>
}
</script>
<body>
<form name="form1" action="<%=SystemAdminPath%>/chguser.asp" method="post" target="_blank">                    
 <dl class="linebox" style="width:700px; margin:10px;">
   <dd class="clearfix">
      <label class="title">所属用户名:</label>
      <label><%=u_name%></label>
    </dd>
    <dd class="clearfix">
      <label class="title">站点名称:</label>
      <label><%=s_comment%></label>
    </dd>
    <dd class="buttonmsg">
    <input type="button" value="代管至前台升级" name="subbtton" onclick="dosub()" />
    </dd>
 </dl>
	<input type="hidden" name="module" value="chguser">
	<input type=hidden  name="username" value="<%=u_name%>">
</form>
</body>
</html>
