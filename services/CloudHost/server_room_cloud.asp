<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
call setHeaderAndfooter()
call setcloudhostLeft()
tpl.set_file "main", USEtemplate&"/services/cloudhost/server_room_cloud.html"
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
%>