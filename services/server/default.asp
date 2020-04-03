<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
			call setHeaderAndfooter()
			call setserverleft()
			tpl.set_file "ourserver",USEtemplate&"/config/serverLeft/ourserver.html"
			tpl.set_file "main", USEtemplate&"/services/server/default.html"
			tpl.parse "#ourserver.html","ourserver",false
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>