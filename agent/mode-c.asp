<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
			call setHeaderAndfooter()
			call setagentLeft()

			tpl.set_file "main", USEtemplate&"/agent/mode-c.html"
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>