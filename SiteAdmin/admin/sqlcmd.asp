<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(1)%>
<html>
<head>
<title>Sql����ִ��</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>

</head>

<body bgcolor="#FFFFFF" text="#000000">
<script language=javascript>
function check(form){
if (confirm("��ȷ��ִ��["+form.Sql.value+"]����������")) {
	
	 if ((form.Sql.value.toLowerCase().indexOf("update")!=-1||form.Sql.value.toLowerCase().indexOf("delete")!=-1)&&(form.Sql.value.toLowerCase().indexOf("where")==-1))
	 if (confirm("��ִ���˺���Update/Delete��SQL�������û��Where�޶���������Ӱ�����м�¼����Σ�յģ���ȷ��������")) return true;
	 else return false;
	 else return true;
	}
return false;
}
</script>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'> 
    <td height='30' align="center" ><b>SQL����<strong> </strong></b><strong><b>(ֱ�Ӳ������ݿ�)</b></strong></td>
  </tr>
</table>
<form name=form1 action="sqlcmd.asp" method=post onSubmit="return check(this);">
SQL���� :<input type="text" size="50" name="Sql" value="">
  <input type="submit" value="��   ��">
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
Response.write "<div><center>��Ӱ�������:" & lnAffect & "</center></div>"
%>
<hr>
</body>
</html><!--#include virtual="/config/bottom_superadmin.asp" -->
