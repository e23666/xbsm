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
	'������������̻���ҵ���߼��������
	
	'�������������ҵ���߼�����д�������´�������ο�������
    '��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�
    user_id = request("user_id")	'֧�����û�id
	user_type=request("user_type")'1˾2��
	user_status=request("user_status")&""'�û�״̬
	firm_name=request("firm_name")&""'˾��
	real_name=request("real_name")&""'�û���ʵ����
	email=request("email")&""
	cert_no=request("cert_no")'֤��
	gender=request("gender")'�Ա�
	phone=request("phone")
	mobile=request("mobile")
	province=request("province")&""'ʡ
	city=request("city")&""'��
	area=request("area")&""'��
	adderss=request("adderss")&""'��ַ
	zip=request("zip")&""'�ʱ�
	u_class="�����û�"
	if user_type="1" then u_class="��˾�û�"
	if Province="" then Province="�Ĵ�"
	if city="" then city="�ɶ���"
	if email="" then alert_redirect "���������½ʧ�ܣ����������վ����Ա������ϵ֧������ͨ����ʺŻ�ȡ��Ӧ���ϵĹ��ܣ���������֧�����������޷���ͨ�ģ����ڴ���ƽ̨��̨�����йر�֧������ݵ�¼���ܣ�",companynameurl & "/reg/"
	if firm_name="" then firm_name=real_name
	'ִ���̻���ҵ�����

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
		rs("u_employees")="����"
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
	   Call setuserSession(email)'�Զ���½
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
		call SendMail(email,"ע��ɹ�! ��ӭ����Ϊ"&companyname&"�û�!" ,mailbody)
	   gowithwin companynameurl &"/manager/"
	else
		alert_redirect "��½ʧ��!!",companynameurl & "/reg/"
	end if
	rs.close
else
	alert_redirect "��½ʧ��!",companynameurl & "/reg/"
end if











%>
