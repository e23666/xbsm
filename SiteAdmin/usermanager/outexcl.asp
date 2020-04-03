<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
Response.Expires = 0
Response.Buffer = True
conn.open constr
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "inline; filename=Userinfo.xls"
%> 
<table width="100%" border="1" cellpadding="2" cellspacing="1">
<tr>
<td>用户名</td>
<td>公司名称</td>
<td>联系人姓名</td>
<td>电话</td>
<td>手机</td>
<td>QQ</td>
<td>邮箱信息</td>
</tr>
<%
set rs2=server.CreateObject("adodb.recordset")
sql="select * from UserDetail order by u_id asc"
rs2.open sql,conn,1,1
if rs2.recordcount > 0 then
do while not rs2.eof
%>
<tr>
<td><%=rs2("u_name")%></td>
<td><%=rs2("u_company")%></td>
<td><%=rs2("u_contract")%></td>
<td><%=rs2("u_telphone")%></td>
<td><%=rs2("qq_msg")%></td>
<td><%=rs2("msn_msg")%></td>
<td><%=rs2("u_email")%></td>
</tr>
<%
rs2.movenext
loop
end if
%>
</table>
 
<%
rs2.close
set rs2=nothing
%>