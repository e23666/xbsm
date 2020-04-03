<!--#include virtual="/config/config.asp" -->
<%
		oldonline=	Application("online")
		Application.lock
		Application("online")=deletesubstring(oldonline,session("user_name"))
		Application.unlock
		session.abandon()
		Call SetHttpOnlyCookie("user_name","","","/",#1980-1-1#)
		Call SetHttpOnlyCookie("user_pwd","","","/",#1980-1-1#)
		Response.redirect "/default.asp"

%>