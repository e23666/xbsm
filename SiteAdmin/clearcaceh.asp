<!--#include virtual="/config/config.asp" --><%
response.Charset="gb2312"
Check_Is_Master(6)
Check_Is_Master(1)
if requesta("act")="clear" then 
	application.contents.removeall
	die "清空网站缓存成功!"
end if
%>

<html>
<head>
<title>清网站缓存</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="css/Admin_Style.css" rel=stylesheet>
<script src="/jscripts/jq.js"></script>

<script>
	function clearweb()
	{
		if(confirm("您确定要清空网站缓存?")){
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
    <td height="30" align="center"><strong>系统缓存清理</strong></td>
  </tr>
  <tr><td>
		<button onclick="clearweb()">清空网站缓存</button>
		<div>
			
			<ol>
				<dt>系统缓存清理</td>
			</ol>
		</div>
  
  </td></tr>
</tbody></table>
 
</body>
</html><!--#include virtual="/config/bottom_superadmin.asp" -->
