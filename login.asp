<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
If isnumeric(trim(session("u_sysid"))&"") Then Response.redirect "/manager"
pageStr=replace(replace(replace(request("pageStr"),"<",""),">",""),"""","")
'pageStr=Server.URLEncode(pageStr)
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/login.html" 
tpl.set_var "HTTP_REFERER",pageStr,false
if alipaylog then
tpl.set_var "alipaylog","<a href=""/reg/alipaylog.asp""><img src=""/images/alipay/alipaylog1.png"" style=""width:100px; height:28px"" /></a>",false
else
tpl.set_var "alipaylog","",false
end if
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
%>