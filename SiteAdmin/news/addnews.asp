<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
if requesta("act")="addNews" then
	subject=requesta("subject")
	content=request.Form("content")
	ispub  =(requesta("ispub")="yes")
	if subject="" or content="" then url_return "����д���������",-1
	'Call htmlEnCode_(content)
	conn.open constr
	rs.open "select * from [news] where newsid=0",conn,1,3
	rs.addnew
	rs("newstitle") = subject
	rs("newscontent") = content
	rs("newsman") = session("user_name")
	rs("html") = 0	'����֧��HTML
	rs.update
	if isdbsql then
		newsid = conn.execute("SELECT @@IDENTITY;")(0)
	else
		newsid = rs("newsid")
	end if
	rs.close
	conn.close
	response.Write "<script type=""text/javascript"">alert(""��ӳɹ�"");</script>"
	if ispub then
		returl = "checked.asp?newsid=" & newsid
	else
		returl = "default.asp"
	end if
	response.Write "<script type=""text/javascript"">location.href =""" & returl & """;</script>"
	response.End()
end if


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�������</title>
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
  <form action="?act=addNews" method="post" onsubmit="return check1(this)">
    <tr>
      <td width="18%" align="right" >���ű���*��</td>
      <td width="82%" ><input type="text" class="input" size="70" name="subject" onkeydown="if(window.event.keyCode==13)return false;"> <label><input type="checkbox" name="ispub" value="yes" title="��δ����ѡ���ӵ�������Ҫ�ֹ����������ť�Ż���ʾ����" />ֱ�ӷ���</label></td>
    </tr>
    <tr>
      <td align="right" >��������*��</td>
      <td><script type="text/plain" id="editor" style="width:800px;"></script><textarea style="display:none" name="content"></textarea></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td> <input type="submit" value="�������"><br />��������Shift+�س�������ǻ������ֱ�Ӵ�س�����������������ȫ�ǵ������ո�</td>
    </tr>
  </form>
</TABLE>
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
	//ue.setContent(document.getElementById("hisContent").innerHTML);
</script>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->