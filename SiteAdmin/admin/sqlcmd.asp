<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(1)%>
<html>
<head>
<title>Sql命令执行</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>

</head>

<body bgcolor="#FFFFFF" text="#000000">
<script language=javascript>
function check(form){
if (confirm("你确定执行["+form.Sql.value+"]这条命令吗？")) {
	
	 if ((form.Sql.value.toLowerCase().indexOf("update")!=-1||form.Sql.value.toLowerCase().indexOf("delete")!=-1)&&(form.Sql.value.toLowerCase().indexOf("where")==-1))
	 if (confirm("您执行了含有Update/Delete的SQL命令，并且没有Where限定，这样将影响所有记录，是危险的，你确信无误吗？")) return true;
	 else return false;
	 else return true;
	}
return false;
}
</script>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'> 
    <td height='30' align="center" ><b>SQL命令<strong> </strong></b><strong><b>(直接操作数据库)</b></strong></td>
  </tr>
</table>
<form name=form1 action="sqlcmd.asp" method=post onSubmit="return check(this);">
SQL命令 :<input type="text" size="50" name="Sql" value="">
  <input type="submit" value="运   行">
</form>
<hr>
<%
lnAffect=0
conn.open constr
Sql=Trim(request("Sql"))
Response.write "<b><center>" & Sql & "</center></b><br>"

if inStr(Ucase(Sql),"SELECT")>0 then
	Rs.open Sql,conn,1,1
	Response.write "<table border=1 align=center> <tr>"
	for i=0 to Rs.Fields.Count-1
		 Response.write "<th> " & Rs.Fields(i).Name & "</th>"
	Next
	Response.write "</tr>"
	jj=1
	do while not Rs.eof 
		 Response.write "<tr>"
	for i=0 to Rs.Fields.Count-1
   Response.write "<td>" & Rs.Fields(i).value &"</td>"
	  next
	 Response.write "</tr>"
	Rs.moveNext
	jj=jj+1
	Loop
	Response.write "</table>"
	Rs.close
  elseif inStr(Ucase(Sql),"DELETE")>0 then
	if inStr(Ucase(Sql),"WHERE")>0 then
	    Call conn.Execute(Sql,lnAffect)
	end if
  elseif inStr(Ucase(Sql),"UPDATE")>0 or inStr(Ucase(Sql),"INSERT")>0 then
     Call conn.Execute(Sql,lnAffect)
  end if
Response.write "<div><center>受影响的行数:" & lnAffect & "</center></div>"
%>
<hr>
</body>
</html><!--#include virtual="/config/bottom_superadmin.asp" -->
