<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
call setHeaderAndfooter()
tpl.set_root "/faq"
tpl.set_file "main", "bottom.html"
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
%>
