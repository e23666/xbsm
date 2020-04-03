<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
errstr=requesta("errstr")
if errstr="" then errstr="ÒâÍâ´íÎó"
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/error.html" 
tpl.set_var "errstr",errstr,false
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
%>