<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
act=requesta("act")
newsid=requesta("newsid")
if not isnumeric(newsid&"") then url_return "��������",-1
conn.open constr

if act="editNews" then
	subject=requesta("subject")
	content=request.Form("content")
	'Call htmlEnCode_(content)
	rs.open "select * from [news] where newsid=" & newsid,conn,1,3
	if rs.eof then url_return "�����²�����",-1
	rs("newstitle") = subject
	rs("newscontent") = content
	rs("html") = 0	'����֧��HTML
	rs.update
	rs.close
	conn.close
	Alert_Redirect "����ɹ�", request.ServerVariables("SCRIPT_NAME") & "?newsid=" & newsid
end if

set trs=conn.execute("select * from [news] where newsid=" & newsid)
if trs.eof then url_return "�����²�����",-1
subject=trs("newstitle")
content=trs("newscontent")
Call htmlDeCode_(content)
trs.close
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�༭����</title>
<link href="../css/Admin_Style.css" rel="stylesheet">
<script type="text/javascript" charset=gbk src="/ueditor4/editor_config.js"></script>
<script type="text/javascript" charset=gbk src="/ueditor4/editor_all_min.js"></script>
<link rel="stylesheet" type="text/css" href="/ueditor4/themes/default/ueditor.css"/>
<style type="text/css">
.input{
	background-color:#dde6ef;
	height:25px;
	line-height:25px;
	font-size:14px;
}
#hisContent{
	display:none
}
</style>
</head>

<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���Ź���</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">��������</a> | <a href="addnews.asp">��������</a></td>
  </tr>
</table>
<br>
<table width="100%" class="border">
  <form action="?act=editNews&newsid=<%=newsid%>" method="post" onsubmit="return check1(this)">
    <tr>
      <td width="18%" align="right" >���ű���*��</td>
      <td width="82%" ><input type="text" class="input" size="70" name="subject" onkeydown="if(window.event.keyCode==13)return false;" value="<%=Server.HTMLEncode(subject)%>"></td>
    </tr>
    <tr>
      <td align="right" >��������*��</td>
      <td><script type="text/plain" id="editor" style="width:800px;"></script><textarea style="display:none" name="content"></textarea></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td> <input type="submit" value="����༭"></td>
    </tr>
  </form>
</TABLE>
<div id="hisContent"><%=content%></div>
<script type="text/javascript">
	function check1(obj){
		if (obj.subject.value=="" || !ue.hasContents()){
			alert("��������ݱ��붼��д");
			return false;
		}
		obj.content.value=ue.getContent();
	}
    var ue = new baidu.editor.ui.Editor({
		autoHeightEnabled : false,
		autoFloatEnabled : false
	});
    ue.render('editor');
	ue.setContent(document.getElementById("hisContent").innerHTML);
</script>
</body>
</HTML>
<!--#include virtual="/config/bottom_superadmin.asp" -->
