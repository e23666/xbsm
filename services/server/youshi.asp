<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setserverLeft()


tpl.set_file "main", USEtemplate&"/services/server/youshi.html"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>