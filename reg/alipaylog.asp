<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/alipay_class/alipay_service.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>֧������ݵ�¼</title>
</head>

<body>
<%
partner         = alipay_userid
'��ȫ�����룬�����ֺ���ĸ��ɵ�32λ�ַ�
key   			= alipay_userpass
'ҳ����תͬ��֪ͨ·�� Ҫ�� http://��ʽ������·�����������?id=123�����Զ������
return_url      = companynameurl & "/reg/alipayreturn.asp"
'return_url����������д��http://localhost/alipay.auth.authorize_asp_gb/return_url.asp������ᵼ��return_urlִ����Ч
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
