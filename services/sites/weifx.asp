<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/services/sites/weifx.html"
tpl.set_function "main","Price","tpl_function"
tpl.parse "mains", "main",false

'��� 
tpl.p "mains" 
set tpl=nothing

%>