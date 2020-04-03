<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
call setHeaderAndfooter()
call setvpsserverLeft()
tpl.set_file "main", USEtemplate&"/services/vpsserver/hongkongvps.html"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
%>