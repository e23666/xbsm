<!--#include virtual="/config/config.asp" -->
<%
times=ToUnixTime(now(),+8)
server_v1=Cstr(Request.ServerVariables("HTTP_REFERER"))
server_v2=Cstr(Request.ServerVariables("SERVER_NAME"))
newserver=mid(server_v1,8,len(server_v2))
If ishttps() Then  newserver=mid(server_v1,9,len(server_v2))
If newserver<>server_v2 Then
else
token=webmanagesrepwd&api_username&api_password&webmanagespwd&times
sign=md5_16(token)
response.cookies("whoistoken")=sign
End if
die times
%>