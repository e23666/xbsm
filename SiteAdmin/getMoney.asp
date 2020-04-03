<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
Response.CodePage=936
Response.Charset="gb2312"
conn.open constr
Xcmd="other"&vbcrlf
Xcmd=Xcmd&"get"&vbcrlf
Xcmd=Xcmd&"entityname:usemoney"&vbcrlf
Xcmd=Xcmd&"."&vbcrlf
 
loadRet=Pcommand(Xcmd,Session("user_name"))
arrstr=Split(loadRet,vbcrlf)
if trim(arrstr(0))="200 ok" then
useMoney=replace(arrstr(1),"usemoney:","")
else
useMoney=-1
end if
if useMoney=-1 then
s="-1"
else
s=FormatCurrency(useMoney,2,-1,-1,-1)
end if

%>
document.getElementById("money").innerHTML='<%=s%>';
 