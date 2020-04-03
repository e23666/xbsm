<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
call setHeaderAndfooter()
call setwebhostingLeft()
call setwebhostingtop()
tpl.set_file "main", USEtemplate&"/services/webhosting/bjvhost.html"
tpl.set_function "main","Price","tpl_function"
tpl.set_function "main","Psize","tpl_function_size"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>