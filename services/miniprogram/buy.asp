<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/class/miniprogram_class.asp" --> 
<%
response.Charset="gb2312" 
conn.open constr
call needregSession()
productid=requesta("productid")
buyyear=requesta("buyyear")
set app=new miniprogram
app.setproid=productid
app.setuid=session("u_sysid")
act=requesta("act")
if act="addshopcar" then 
	if trim(app.errmsg)<>"" then
		die echojson("500",app.errmsg,"")
	end if
	paytype=requesta("paytype")
	years=requesta("years")
	appname=requesta("appname")
	if trim(appname)="" or len(trim(appname)&"")>45 then die echojson("500","APP����Ϊ�ջ򳤶ȳ���45���ַ�","")
	if not isnumeric(years&"") then die echojson("500","������������","")
	if not isnumeric(paytype&"") then die echojson("500","����ʽ����","")
	if app.addbagshow(appname,years,paytype) then
		die echojson("200","���빺�ﳵ�ɹ�","")
	else
		die echojson("500",app.errmsg,"")
	end if
end if 

if trim(app.errmsg)<>"" then
	errpage "��Ǹ���ò�Ʒ������"
end if








priceyear=GetNeedPrice(app.user_name,productid,1,"new")
prices=app.paytypeprice&","&priceyear&","&priceyear*2&","&priceyear*3

call setHeaderAndfooter()
call setMailLeft()
tpl.set_file "main", USEtemplate&"/services/miniprogram/buy.html"
tpl.set_function "main","Price","tpl_function"

tpl.set_var "usemoney",app.u_usemoney,false
tpl.set_var "appname",app.p_name,false
tpl.set_var "appproid",productid,false
tpl.set_var "paytypeprice",app.paytypeprice,false
tpl.set_var "prices",prices,false


tpl.parse "mains","main",false


tpl.p "mains" 
set tpl=nothing

%>