<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
Check_is_Master(6)
						sysid=Requesta("sysid")
						conn.open constr
						conn.Execute "delete from serverlist where s_id='"&serverid&"'"
						conn.close
%>
