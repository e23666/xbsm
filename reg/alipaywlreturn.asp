<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/alipaywl_class/alipay_notify.asp"-->
<%

partner         = alipay_userid
key   			= alipay_userpass
return_url      = companynameurl & "/reg/alipayreturn.asp"
input_charset	= "gbk"
sign_type       = "MD5"

Set objNotify = New AlipayNotify
sVerifyResult = objNotify.VerifyReturn()
If sVerifyResult Then
	conn.open constr
	'请在这里加上商户的业务逻辑程序代码
	
	'——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
    '获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表
    user_id = request("user_id")	'支付宝用户id
	user_type=request("user_type")'1司2人
	user_status=request("user_status")&""'用户状态
	firm_name=request("firm_name")&""'司名
	real_name=request("real_name")&""'用户真实名称
	email=request("email")&""
	cert_no=request("cert_no")'证号
	gender=request("gender")'性别
	phone=request("phone")
	mobile=request("mobile")
	province=request("province")&""'省
	city=request("city")&""'市
	area=request("area")&""'区
	adderss=request("adderss")&""'地址
	zip=request("zip")&""'邮编
	u_class="个人用户"
	if user_type="1" then u_class="公司用户"
	if Province="" then Province="四川"
	if city="" then city="成都市"
	if email="" then alert_redirect "发生错误登陆失败！如果你是网站管理员：请联系支付宝开通你的帐号获取相应资料的功能，若不符合支付宝的条件无法开通的，请在代理平台后台管理中关闭支付宝快捷登录功能！",companynameurl & "/reg/"
	if firm_name="" then firm_name=real_name
	'执行商户的业务程序

	sql="select * from userdetail where alipay_userid='"& user_id &"' or u_name='"& email &"'"
	rs.open sql,conn,1,3
	if rs.eof then		
		u_password=CreateRandomKey(6)
		password = md5_16(u_password)
		rs.addnew()
		rs("alipay_userid")=user_id
		rs("u_name")=email
		rs("u_password")=password
		rs("u_province")=province
		rs("u_fax")=phone
		rs("u_zipcode")=zip
		rs("u_company")=firm_name
		rs("u_introduce")=""
		rs("u_contract")=real_name
		rs("u_address")=address
		rs("u_trade")=cert_no
		rs("u_contry")="CN"
		rs("u_email")=email
		rs("u_city")=city
		rs("u_telphone")=phone
		rs("u_website")=""
		rs("u_employees")=""
		rs("u_employees")="其它"
		rs("u_namecn")=real_name
		rs("u_nameen")=""
		rs("u_operator")=0
		rs("qq_msg")=""
		rs("msn_msg")=mobile
		rs("u_ip")=""
		rs("f_id")=0
		rs("u_class")=u_class
		rs("u_type")=0
		rs("u_meetonce")=1
		rs.update()
	   Call setuserSession(email)'自动登陆
		getStr="username_cn="& real_name & "," & _		
			   "password=" & u_password & "," & _
			   "companyname=" & companyname & "," & _
			   "username=" & email & "," & _
			   "companynameurl=" & companynameurl & "," & _
			   "companyaddress=" & companyaddress & "," & _
			   "supportmail=" & supportmail & "," & _
			   "postcode=" & postcode & "," & _
			   "telphone=" & telphone & "," & _
			   "oicq=" & oicq
		mailbody=redMailTemplate("regalipaysub.txt",getStr)
		call SendMail(email,"注册成功! 欢迎您成为"&companyname&"用户!" ,mailbody)
	   gowithwin companynameurl &"/manager/"
	else
		alert_redirect "登陆失败!!",companynameurl & "/reg/"
	end if
	rs.close
else
	alert_redirect "登陆失败!",companynameurl & "/reg/"
end if











%>
