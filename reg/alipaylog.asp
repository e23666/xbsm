<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/alipay_class/alipay_service.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>支付宝快捷登录</title>
</head>

<body>
<%
partner         = alipay_userid
'安全检验码，以数字和字母组成的32位字符
key   			= alipay_userpass
'页面跳转同步通知路径 要用 http://格式的完整路径，不允许加?id=123这类自定义参数
return_url      = companynameurl & "/reg/alipayreturn.asp"
'return_url的域名不能写成http://localhost/alipay.auth.authorize_asp_gb/return_url.asp，否则会导致return_url执行无效
input_charset	= "gbk"
sign_type       = "MD5"
'exter_invoke_ip=getUserip()
Set objService = New AlipayService
	'anti_phishing_key = objService.Query_timestamp()
	sHtml = objService. Alipay_auth_authorize(anti_phishing_key, exter_invoke_ip)
response.Write sHtml
%>
</body>
</html>
