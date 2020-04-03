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
    <td width="771"><a href="index.asp">群发短信</a> | <a href="sendlog.asp">短信发送日志</a></td>
  </tr>
</table>
<br>
<%
str=requesta("str")
conn.open constr
		sql="select top 1000 * from smsback where (backNum ='' or backNum is null) order by sendTime desc"
		rs11.open sql,conn,1,3
		%>
		<table width="100%" border=0 cellpadding="3" cellspacing="1" class="border">
		<tr>
		<td width="17%" align="center" nowrap class="Title"><strong>发送人</strong></td>
		<td width="15%" align="center" nowrap class="Title"><strong>发送时间</strong></td>
		<td width="68%" align="center" nowrap class="Title"><strong>发送内容</strong></td>
		</tr>
		<%
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs11,setsize,othercode,pageCounts,linecounts)

	Do While Not rs11.eof And cur<=setsize
				%>
			<tr>
			<td align="center" nowrap class="tdbg"><%=rs11("senduser")%></td>
			<td nowrap class="tdbg"><%=rs11("sendTime")%></td>
			<td class="tdbg"><%=rs11("sendcontent")%></td>
			</tr>
			
				<%
		cur=cur+1
		rs11.movenext
		loop
%>
		<td colspan="3" align="center"><%=pagenumlist%></td>
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
