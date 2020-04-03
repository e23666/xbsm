<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/class/yunmail_class.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
call setHeaderAndfooter()
call setMailLeft()
tpl.set_file "main", USEtemplate&"/services/mail/yunmail.html"
Set yun=new yunmail_class 

tpl.set_function "main","Price","tpl_function" 
tpl.set_var  "cfg",dicTojson(yun.configDic,""),false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
%>