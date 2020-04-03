<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setserverLeft()

	call setcloudhostLeft()

tpl.set_file "main", USEtemplate&"/services/server/vip.html"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

%>