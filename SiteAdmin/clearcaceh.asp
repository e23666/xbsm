<!--#include virtual="/config/config.asp" --><%
response.Charset="gb2312"
Check_Is_Master(6)
Check_Is_Master(1)
if requesta("act")="clear" then 
	application.contents.removeall
	die "�����վ����ɹ�!"
end if
%>

<html>
<head>
<title>����վ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="css/Admin_Style.css" rel=stylesheet>
<script src="/jscripts/jq.js"></script>

<script>
	function clearweb()
	{
		if(confirm("��ȷ��Ҫ�����վ����?")){
			$.get("?act=clear","",function(d){
			
				alert(d)
			})
		
		}
	}
</script>

</head>

<body bgcolor="#FFFFFF" text="#000000">
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
  <tbody><tr class="topbg">
    <td height="30" align="center"><strong>ϵͳ��������</strong></td>
  </tr>
  <tr><td>
		<button onclick="clearweb()">�����վ����</button>
		<div>
			
			<ol>
				<dt>ϵͳ��������</td>
			</ol>
		</div>
  
  </td></tr>
</tbody></table>
 
</body>
</html><!--#include virtual="/config/bottom_superadmin.asp" -->
