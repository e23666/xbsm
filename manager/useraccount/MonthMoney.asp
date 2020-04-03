<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
conn.open constr
MonthNum=requesta("MonthNum")
sql="SELECT SUM(u_out) AS outMoney FROM countlist WHERE (DATEDIFF("&PE_DatePart_M&", c_date,"&PE_Now&") <= "&MonthNum&") AND (u_id = "&session("u_sysid")&")"
rs.open sql,conn,1,1
if not rs.eof then
	response.Write("document.write('"&rs(0)&"');")
else
	response.Write("document.write('0')")
end if
rs.close
conn.close
%>