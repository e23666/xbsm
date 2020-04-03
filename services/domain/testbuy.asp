<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312"
d=requesta("d")
price=requesta("price")
conn.open constr

if oicq<>"" then
qq=split(oicq,",")(0)
end if


 

call setHeaderAndfooter()
call setDomainLeft()
tpl.set_file "main",USEtemplate&"/services/domain/Testbuy.html"
if isfree then tpl.set_var "freeid",freeid,false

tpl.set_block "main", "suffixlist", "mylist"
tpl.set_var "d",d,false
tpl.set_var "price",price,false
tpl.set_var "companyname",companyname,false
tpl.set_var "tel",telphone,false
tpl.set_var "qq",qq,false



tpl.set_function "main","Price","tpl_function"
tpl.set_function "main","cnPrice","tpl_cnfunction"
tpl.set_function "main","cnrenewPrice","tpl_cnrenewfunction"
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
conn.close

function tpl_cnrenewfunction(v)

		renewprices=GetNeedPrice(session("user_name"),v,1,"renew")

	tpl_cnrenewfunction=renewprices
end function
function tpl_cnfunction(v)

 	tpl_cnfunction=GetNeedPrice(session("user_name"),v,1,"new")

	
end function

%>