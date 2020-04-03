<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setDomainLeft()
tpl.set_file "main",USEtemplate&"/services/domain/defaultcn.html"
tpl.set_function "main","Price","tpl_function"
tpl.set_function "main","cnPrice","tpl_cnfunction"
tpl.set_function "main","cnrenewPrice","tpl_cnrenewfunction"
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
conn.close
function tpl_cnrenewfunction(v)
	
	renewprices=GetNeedPrice(session("user_name"),v,1,"renew")
	
	tpl_cnrenewfunction=renewprices
end function
function tpl_cnfunction(v)

 	tpl_cnfunction=GetNeedPrice(session("user_name"),v,1,"new")
end function
%>