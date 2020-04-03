<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
response.Charset="GB2312"
response.Expires=-1
conn.open constr
dm=requesta("dm")
sign=requesta("sign")
chksign=ASP_MD5(api_password&dm&webmanagespwd&date())
if trim(sign)<>trim(chksign) then
	die "{""code"":500,""msg"":""sign err""}"
end if

url="http://api.west263.com/api/chkdmauditapi.asp"
signday=year(date())&"-"&right("0"&month(date()),2)&"-"&right("0"&day(date()),2)
sign=ASP_MD5(api_username&dm&api_password&signday)
postdata="dm="&server.URLEncode(dm)&"&username="&api_username&"&sign="&sign
returnstr=OpenRemoteUrl(url,postdata)
die returnstr
if left(returnstr&"",1)="{" then
	die returnstr
else
	die "{""code"":500,""msg"":""post err""}"
end if
%>