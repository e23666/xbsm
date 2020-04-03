<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
 <%=session("whoisValue")%>
<%
if session("esymok")="ok" then
session("esymok")=""
conn.open constr
response.charset="gb2312"
k=trim(requesta("k"))
Xcmd= "other" & vbcrlf
Xcmd=Xcmd & "aprice" & vbcrlf
Xcmd=Xcmd & "entityname:elite" & vbcrlf
Xcmd=Xcmd & "domain:"&k&"" & vbcrlf
Xcmd=Xcmd & "." & vbcrlf
loadRet=connectToUp(Xcmd)

if left(loadRet,3)="200" then
response.Write(replace(loadRet,"200 ok,",""))
end if
response.End()
end if
%>


