<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/alipaywl_class/alipay_service.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>支付宝快捷登录</title>
</head>

<body>
<%
partner         = alipay_userid
key   			= alipay_userpass
return_url      = companynameurl & "/reg/alipaywlreturn.asp"
input_charset	= "gbk"
sign_type       = "MD5"
token=request.QueryString("token")
if token="" then token=session("token")
'exter_invoke_ip=getUserip()
sParaTemp = Array("service=user.logistics.address.query","partner="&partner,"return_url="&return_url,"_input_charset="&input_charset,"token="&token)

'构造快捷登录用户物流地址查询接口表单提交HTML数据，无需修改
Set objService = New AlipayService
sHtml = objService.User_logistics_address_query(sParaTemp)
response.Write sHtml
%>
</body>
</html>
