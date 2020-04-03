<!--#include virtual="/config/config.asp" -->
<!--#include file="qqconnect.asp"-->
<%
Dim qc, url,t
t=request.QueryString("t")
if t="" then t=0

if not isnumeric(t) then 
t=0
else
t=clng(t)
end if



session("qqbind")=t


SET qc = New QqConnet
    Session("State")=qc.MakeRandNum()
    url = qc.GetAuthorization_Code()
    Response.Redirect(url)
Set qc=Nothing
%>