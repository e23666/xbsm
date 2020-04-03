<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
Response.Buffer = True  
Response.ExpiresAbsolute = Now() - 1  
Response.Expires = 0  
response.write(request.ServerVariables("Referer"))
Response.CacheControl = "no-cache"  
chkcode_u_name=session("chkcode_u_name")
chkcode_u_password=session("chkcode_u_password")
'die chkcode_u_name
session("chkcode_u_name")=""
session("chkcode_u_password")=""
if trim(chkcode_u_name)="" or trim(chkcode_u_password)="" then
response.redirect("/login.asp")
end if
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/inputcode.html" 
tpl.set_var "u_name",chkcode_u_name,false
tpl.set_var "u_password",chkcode_u_password,false
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing

%>