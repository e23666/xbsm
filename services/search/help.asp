<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
			call setHeaderAndfooter()
			tpl.set_file "sitebuildleft", USEtemplate&"/config/sitebuildleft/sitebuildleft.html" 
			tpl.parse "#sitebuildleft.html","sitebuildleft",false
			tpl.set_file "webhostingleft",USEtemplate&"/config/webhostingLeft/webhostingLeft.html"
			tpl.set_file "main", USEtemplate&"/services/search/help.html"
			tpl.parse "#webhostingleft.html","webhostingleft",false
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>