<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<LINK href="css/Admin_Style.css" rel=stylesheet>
<title>����ȿɿ���Ʊ����</title>
</head>
<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>ɾ��<font color=red><%=year(now)%>��</font>��ǰ�ɿ���Ʊ���</strong></td>
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

<form action="?act=sure" method="post" onsubmit="return confrim('ȷ��Ҫɾ����ǰ�ɿ���')">
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr><td>
<ol>
<li>������շ�Ʊ�ɿ����Ϊ0��</li>
<li>�ٴ�<%=year(now)%>��Ȳ�����ˮ�лָ�����ɿ���Ʊ��</li>
<li>���Ѿ���<%=year(now)%>��׷�Ʊ��������ָ�����ֹ�ɾ����Ӧ��Ʊ��</li>
<li>ע�⣺���ֶ���ӹ���Ʊ��ʧЧ��</li>
</ol>

</td></tr>
<tr><td align="center"><input name="submit" type="submit" value="ȷ����տɿ����" /></td></tr>
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
��Ʊ�Ѿ���0�����Ե�3�Ժ󣬶�<%=year(now)%>�귢Ʊ���лָ������Ѿ���Ʊ���ֶ�ɾ����Ӧ���
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
		response.Write("�û�"&crs("u_id")&"���:��Ʊ���"&crs("u_in")&"Ԫ<BR>")
		crs.movenext
		loop
		response.Write("��Ϣ3�Ժ�ִ�У�<meta http-equiv=""refresh"" content=""3;URL=?act=update&sid="&sid&""" />")
	else
	%>
    <table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr>
<td>
�����Ѿ�����룬�ֹ����ѿ���Ʊ�����ֹ�����
</td>
</tr>
</table>
    
    <%
	end if

end sub
%>

</body>
</html>
