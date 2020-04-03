<%
' ������AlipayService
' ���ܣ�֧�������ӿڹ�����
' ��ϸ������֧�������ӿ��������
' �汾��3.2
' �޸����ڣ�2011-03-31
' ˵����
' ���´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ���վ����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣
' �ô������ѧϰ���о�֧�����ӿ�ʹ�ã�ֻ���ṩһ���ο�
%>

<!--#include file="alipay_submit.asp"-->

<%
'֧�������ص�ַ���£�
GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?"
'֧�������ص�ַ���ɣ�
GATEWAY_OLD = "https://www.alipay.com/cooperate/gateway.do?"

Class AlipayService
	''
	' �����ݵ�¼�ӿ�
	' param anti_phishing_key ������ʱ���
	' param exter_invoke_ip �û����ص��Ե�IP��ַ
	' return ���ύHTML��Ϣ
	Public Function Alipay_auth_authorize(anti_phishing_key, exter_invoke_ip)
		Dim sButtonValue, sHtml
		
		'���������������
		sParaTemp = Array("service=alipay.auth.authorize","target_service=user.auth.quick.login","partner="&partner,"return_url="&return_url,"_input_charset="&input_charset,"anti_phishing_key="&anti_phishing_key,"exter_invoke_ip="&exter_invoke_ip)
		
		'ȷ�ϰ�ť��ʾ����
		sButtonValue = "֧������ݵ�¼"
		
		'������ύHTML����
		Set  objSubmit = New AlipaySubmit
		sHtml = objSubmit.BuildFormHtml(sParaTemp, key, sign_type, input_charset, GATEWAY_NEW, "get", sButtonValue)
		
		Alipay_auth_authorize = sHtml
	End Function

	''
	' ���ڷ����㣬����֧����������ӿ�(query_timestamp)����ȡʱ����Ĵ�����
	' ע�⣺Զ�̽���XML������IIS�����������й�
	' return ʱ����ַ���
	Public Function Query_timestamp()
		Dim sUrl, encrypt_key
		sUrl = GATEWAY_NEW&"service=query_timestamp&partner="&partner
		encrypt_key = ""
		
		Dim objHttp, objXml
		Set objHttp=Server.CreateObject("Microsoft.XMLHTTP")
		'���Microsoft.XMLHTTP���У���ô���滻����������д��볢��
		'Set objHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		'objHttp.setOption 2, 13056
		objHttp.open "GET", sUrl, False, "", ""
		objHttp.send()
		Set objXml=Server.CreateObject("Microsoft.XMLDOM")
		objXml.Async=true
		objXml.ValidateOnParse=False
		objXml.Load(objHttp.ResponseXML)
		Set objHttp = Nothing
		
		Set objXmlData = objXml.getElementsByTagName("encrypt_key")  ' �ڵ������
		If Isnull(objXml.getElementsByTagName("encrypt_key")) Then
			encrypt_key = ""
		Else
			encrypt_key = objXmlData.item(0).childnodes(0).text
		End If

		Query_timestamp = encrypt_key
	End Function
	
	'******************��Ҫ��������֧�����ӿڣ����԰�������ĸ�ʽ����******************

	''
	' ����(֧�����ӿ�����)�ӿ�
	' param sPara1 �������1
	' param sPara2 �������2
	' param sParaN �������3
	' return ���ύHTML�ı�����֧��������XML������
	Public Function Alipay_interface(sPara1, sPara2, sParaN)

		'���������������
		
		'�����֧�������������
		Set  objSubmit = New AlipaySubmit
		'����ʽ���������֣�
		'1.������ύHTML���ݣ�
		'sHtml = objSubmit.BuildFormHtml(sParaTemp, key, sign_type, input_charset, gateway, sMethod", sButtonValue)
		'2.����ģ��Զ��HTTP��GET���󣬻�ȡ֧�����ķ���XML��������
		'sHtml = objSubmit.SendGetInfo(sParaTemp, key, sign_type, input_charset, gateway)
		'����ݲ�ͬ�Ľӿ����Զ�ѡһ
	End Function

End Class

%>