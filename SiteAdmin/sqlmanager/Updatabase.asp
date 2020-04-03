<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
dataID=Trim(Requesta("dataID"))
if not isNumeric(dataID) then url_return "缺少mssqlID",-1
conn.open constr
Sql="select (select u_name from userdetail where u_id=databaselist.dbu_id) as u_name,dbname from databaselist where dbsysid="& dataID
Rs.open Sql,conn,1,1
if Not rs.eof then
	u_name=rs("u_name")
	dbname=rs("dbname")
end if
rs.close
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>mssql升级</title>
<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
</head>
<script language="javascript">
function dosub(){
	<%if u_name=session("user_name") then%>
	window.location="/manager/sqlmanager/updata.asp?ID=<%=dataID%>";
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
      <label class="title">数据库名称:</label>
      <label><%=dbname%></label>
    </dd>
    <dd class="buttonmsg">
    <input type="button" value="代管至前台升级" name="subbtton" onClick="dosub()" />
    </dd>
 </dl>
	<input type="hidden" name="module" value="chguser">
	<input type=hidden  name="username" value="<%=u_name%>">
</form>
</body>
</html>
