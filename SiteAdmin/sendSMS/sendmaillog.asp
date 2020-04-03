<!--#include virtual="/config/config.asp"-->
<!--#include virtual="/config/asp_md5.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>短信发送</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="index.asp">群发短信</a> | <a href="sendlog.asp">短信发送日志 </a></td>
  </tr>
</table>
<br>
<%
str=requesta("str")
conn.open constr
conn.execute("delete from maillog where datediff("&PE_DatePart_D&",addtime,"&PE_Now&")>30")
		sql="select top 1000 * from maillog  order by addtime desc"
		rs11.open sql,conn,1,3
		%>
		<table width="100%" border=0 cellpadding="3" cellspacing="1" class="border">
		<tr>
		<td width="150"  align="center" nowrap class="Title"><strong>收件人</strong></td>
		<td  align="center" nowrap class="Title"><strong>标题</strong></td>
		<td width="40"  align="center" nowrap class="Title"><strong>状态</strong></td>
		<td width="150"   align="center" nowrap class="Title"><strong>时间</strong></td>
		</tr>
		<%
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs11,setsize,othercode,pageCounts,linecounts)

	Do While Not rs11.eof And cur<=setsize
				%>
			<tr>
			<td align="center" nowrap class="tdbg"><%=rs11("m_mail")%></td>
			<td nowrap class="tdbg"><%=rs11("m_title")%></td>
			<td align="center" class="tdbg"><%=rs11("m_status")%></td>
			<td align="center" class="tdbg"><%=rs11("addtime")%></td>
			</tr>
			
				<%
		cur=cur+1
		rs11.movenext
		loop
%>
		<td colspan="4" align="center"><%=pagenumlist%></td>
		</table>
		<%
conn.close

Function GotoStr()
	Dim P
	For n=1 to rs11.PageCount
		If PageNo=n then P=" Selected" Else P=""
		GotoStr=GotoStr & vbCrlf & "<Option value="&n&"&sid="&sid&""&P&">第" & n & "页</Option>" & vbCrlf
	Next
End Function

%>

<!--#include virtual="/config/bottom_superadmin.asp" -->
