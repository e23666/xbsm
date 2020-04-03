<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%

call setHeaderAndfooter()
if len(trim(company_Name)&"")<=0 then company_Name=companyname
tpl.set_file "main", USEtemplate&"/aboutUs/contact.html"
tpl.set_file "left", USEtemplate&"/config/aboutUsleft/AboutusLeft.html"
tpl.set_var "companyname",company_Name,false
	tpl.set_block "main","oicqlist_msg","qqlists_msg"
	for each oicq in split(oicq,",")
		tpl.set_var "oicq_msg", oicq,false
		tpl.parse "qqlists_msg", "oicqlist_msg", true
	next 


tpl.parse "#AboutusLeft.html","left",false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>