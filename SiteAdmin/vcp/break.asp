<!--#include virtual="/config/config.asp"-->
<%
check_is_master(6)
username=Requesta("username")
if username<>"" then
	conn.open constr
	sql="select f_id,u_resumesum from userdetail where u_name='" & username & "'"
	rs.open sql,conn,1,1
	if rs.eof then url_return "δ�ҵ����û�",-1
	rs.close
	sql="update userdetail set f_id=0 where u_name='" & username & "'"
	conn.Execute(Sql)
	url_return "����VCP�ɹ�",-1
end if
%>
<html>
<head>
<title>����VCP</title>


<LINK href="../css/Admin_Style.css" rel=stylesheet>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"></head>
<body bgcolor="#FFFFFF" text="#000000"> 
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'> 
    <td height='30' align="center" >����VCP����</td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'> 
    <td width='91' height='30' align="center" ><strong>ʹ��˵����</strong></td>
    <td width="771">����VCP���ܣ�ĳ�û�ԭ����ĳVCP������¼��ͻ��������Ҫȡ�����ִ����ϵʱ������ʹ�ñ����ܴ���</td>
  </tr>
</table>
<form name="form1" method="post" action="<%=Requesta("SCRIPT_NAME")%>">
  <p>&nbsp;</p>
  <p>�û���: 
    <input type="text" name="username">
    <input type="submit" name="Submit" value="ȷ��">
  </p>
</form>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
