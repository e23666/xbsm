<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width=100% border=0 CELLSPACING="0" class="tdbg"> 
  <script language=javascript>
function check(form){
	var mode=/\.(gif)|(jpg)|(jpeg)$/i;
	if (!mode.test(form.uploadFile.value)){
		alert('抱歉，请选择要上传的文件，扩展名必须是jpg,jpeg,gif');
		return false;
	}
	return true;
}

</script> <form name=upload method=post action="post_upload_2.asp" enctype="multipart/form-data" onSubmit="return check(this);"> 
<tr> <td style="font-size:9pt"> <input name=uploadFile type=file class="inputbox" SIZE="30" site=30> 
<input name=upload type=submit class="button" value=" 上 传 "></td></tr> </form></table>
</BODY>
</HTML>
