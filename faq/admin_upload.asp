<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<%Check_Is_Master(6)%>
<html>
<head>
<title>图片上传</title>
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=gb2312">
<link href="image/style.css" rel="stylesheet" type="text/css">
</head>

<body text="#000000" leftmargin="0" topmargin="0" bgcolor="#F4EEE4" class="Utu">
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#CCCCCC">
    <tr> <form name="form" method="post" action="admin_upfile.asp" enctype="multipart/form-data">
      <td valign="middle"> 
	  	<input type="file" name="file1" size="30">
        &nbsp;<input type="submit" name="Submit" value="上传" onclick="parent.document.form1.Submit.disabled=true,
parent.document.form1.Submit2.disabled=true;">
      </td>
	</form>
	</tr>
  </table>
</body>
</html>