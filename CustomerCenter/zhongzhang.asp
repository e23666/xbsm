<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
call setHeaderAndfooter()

tpl.set_file "main", USEtemplate&"/customercenter/zhongzhang.html"
tpl.set_file "left", USEtemplate&"/config/customercenterleft/CustomerCenterLeft.html"
tpl.parse "#CustomerCenterLeft.html","left",false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>