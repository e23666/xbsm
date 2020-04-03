<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<LINK href="css/Admin_Style.css" rel=stylesheet>
<title>上年度可开发票清理</title>
</head>
<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>删除<font color=red><%=year(now)%>年</font>以前可开发票金额</strong></td>
  </tr>
</table>
<%
act=requesta("act")

select case trim(act)
case "sure"
clearfp()
case "update"
add
case else
read
end select

sub read
%>

<form action="?act=sure" method="post" onsubmit="return confrim('确定要删除以前可开金额！')">
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr><td>
<ol>
<li>首先清空发票可开金额为0。</li>
<li>再从<%=year(now)%>年度财务流水中恢复今年可开发票金额。</li>
<li>如已经对<%=year(now)%>年底发票开出，请恢复完后手工删除相应发票金额！</li>
<li>注意：如手动添加过发票金额将失效！</li>
</ol>

</td></tr>
<tr><td align="center"><input name="submit" type="submit" value="确定清空可开金额" /></td></tr>
</table>

</form>
<%
end sub

sub clearfp
conn.open constr
conn.execute("update UserDetail  set u_Invoice=(u_usemoney+u_resumesum)")
%>
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr>
<td>
发票已经清0，请稍等3稍后，对<%=year(now)%>年发票进行恢复，如已经开票请手动删除相应金额
<meta http-equiv="refresh" content="3;URL=?act=update" />
</td>
</tr>
</table>
<%
end sub

sub add
sid=requesta("sid")
if not isnumeric(sid) or sid="" then sid=0

conn.open constr
sql="select top 20 sysid ,u_id,u_in from countlist where datediff('d','"&year(now)&"-1-1',c_date)>=0 and u_in>0 and sysid >"&sid&" order by sysid asc"
'die sql
'response.Write(sql&"<BR>")
	set crs=conn.execute(sql)
	if not crs.eof then
		do while not crs.eof
		conn.execute("update UserDetail  set u_Invoice=(u_Invoice-"&crs("u_in")&") where u_id="&crs("u_id"))
		sid=crs("sysid")
		response.Write("用户"&crs("u_id")&"编号:发票添加"&crs("u_in")&"元<BR>")
		crs.movenext
		loop
		response.Write("休息3稍后执行，<meta http-equiv=""refresh"" content=""3;URL=?act=update&sid="&sid&""" />")
	else
	%>
    <table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr>
<td>
操作已经完成请，手工对已开发票进行手工处理！
</td>
</tr>
</table>
    
    <%
	end if

end sub
%>

</body>
</html>
