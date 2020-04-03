<!--#include file="conn.asp" -->
<!--#include file="const.asp"-->
<%Check_Is_Master(6)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache">
<title>π‹¿Ì ◊“≥</title>
<link href="image/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" charset=gbk src="/ueditor4/editor_config.js"></script>
<script type="text/javascript" charset=gbk src="/ueditor4/editor_all_min.js"></script>
<link rel="stylesheet" type="text/css" href="/ueditor4/themes/default/ueditor.css"/>
</head>

<BODY leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" bgcolor="#F4EEE4" class="Dtu">
<script language="javascript">
function CheckAll(form)
  {
  for (var i=0;i<form.elements.length;i++)
    {
    var e = form.elements[i];
    if (e.name != 'chkall')
       e.checked = form.chkall.checked;
    }
  }
</script>
<%
Sub htmlEnCode_(strng)
	strng = strng & ""
	strng = Replace(strng,"<","&lt1;")
	strng = Replace(strng,">","&gt1;")
	strng = Replace(strng,"'","&#391;")
	strng = Replace(strng,"""","&quot1;")
	strng = Replace(strng," ","&nbsp1;")
	strng = Replace(strng,vbcrlf,"<br />")
End Sub
Sub htmlDeCode_(strng)
	strng = strng & ""
	strng = Replace(strng,"&lt1;","<")
	strng = Replace(strng,"&gt1;",">")
	strng = Replace(strng,"&#391;","'")
	strng = Replace(strng,"&quot1;","""")
	strng = Replace(strng,"&nbsp1;"," ")
End Sub
%>
