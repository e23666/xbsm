<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
			call setHeaderAndfooter()
			tpl.set_file "seachleft",USEtemplate&"/config/seachLeft/seachleft.html"
			tpl.set_file "main", USEtemplate&"/services/search/google/default.html"
			tpl.parse "#seachleft.html","seachleft",false
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>