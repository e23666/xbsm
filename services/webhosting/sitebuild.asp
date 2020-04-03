<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
call setHeaderAndfooter()
call setwebhostingLeft()
call setwebhostingtop()

tpl.set_file "sitebuildleft", USEtemplate&"/config/sitebuildleft/sitebuildleft.html" 
tpl.parse "#sitebuildleft.html","sitebuildleft",false
tpl.set_file "main", USEtemplate&"/services/webhosting/sitebuild.html"
tpl.set_function "main","Price","tpl_function"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>