<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%

call setHeaderAndfooter()
if len(trim(company_Name)&"")<=0 then company_Name=companyname
tpl.set_file "main", USEtemplate&"/aboutUs/default.html"
tpl.set_file "left", USEtemplate&"/config/aboutUsleft/AboutusLeft.html"
tpl.set_var "companyname",company_Name,false
tpl.parse "#AboutusLeft.html","left",false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>