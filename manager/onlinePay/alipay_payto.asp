<!--#include file="alipay_md5.asp"-->
<%
If Right(companynameurl,1)<>"/" Then 
	If ishttps Then
		companynameurl="https://"& requesta("HTTP_HOST")&"/"
	else
		companynameurl="http://"& requesta("HTTP_HOST")&"/"
	end if
end if
'���������ID����2088��ͷ��16λ������
partner         = alipay_userid
'��ȫ�����룬�����ֺ���ĸ��ɵ�32λ�ַ�
key   			= alipay_userpass
'ǩԼ֧�����˺Ż�����֧�����ʻ�
seller_email    = alipay_account

'���׹����з�����֪ͨ��ҳ�� Ҫ�� http://��ʽ������·�����������?id=123�����Զ������
'notify_url      = companynameurl & "manager/onlinePay/onlinePayEnd.asp"
'��������ת��ҳ�� Ҫ�� http://��ʽ������·�����������?id=123�����Զ������
return_url      = companynameurl & "manager/onlinePay/alipayend.asp"
notify_url      = companynameurl & "manager/onlinePay/onlinePayEnd.asp"
'��վ��Ʒ��չʾ��ַ���������?id=123�����Զ������
show_url        = companynameurl
'�տ���ƣ��磺��˾���ơ���վ���ơ��տ���������
mainname		= "�տ����"
'�ַ������ʽ Ŀǰ֧�� gbk �� utf-8
input_charset	= "gbk"
'ǩ����ʽ �����޸�
sign_type       = "MD5"



'���ѡ���֧����ʽ
paymethod    = "directPay"
'pay_mode	 = request.Form("pay_bank")
'if pay_mode = "directPay" then
'	paymethod    = "directPay"	'Ĭ��֧����ʽ���ĸ�ֵ��ѡ��bankPay(����); cartoon(��ͨ); directPay(���); CASH(����֧��)
'	defaultbank	 = ""
'else
'	paymethod    = "bankPay"	'Ĭ��֧����ʽ���ĸ�ֵ��ѡ��bankPay(����); cartoon(��ͨ); directPay(���); CASH(����֧��)
'	defaultbank  = pay_mode		'Ĭ���������ţ������б��http://club.alipay.com/read.php?tid=8681379
'end if
defaultbank=""
'�̻����ж��Ƶ�����
extra_common_param = "" 


exter_invoke_ip   = ""			'��ȡ�ͻ��˵�IP��ַ�����飺��д��ȡ�ͻ���IP��ַ�ĳ���
anti_phishing_key = ""			'������ʱ���

buyer_email		   = ""			'Ĭ�����֧�����˺�

royalty_type		= ""		'������ͣ���ֵΪ�̶�ֵ��10������Ҫ�޸�
royalty_parameters	= ""		'�����Ϣ��











sub WriteLog(Xinfo)
	Exit sub
	AlipayLog="D:\tmp\alipay.txt"
	Dim fso:set fso=CreateObject("scripting.FileSystemObject")
	set oFile=fso.openTextFile(AlipayLog,8,true)
	Xline=now & " " & Xinfo 
	oFile.writeline(Xline)
	oFile.close
	set oFile=nothing:Set fso=nothing
end sub

'������������������������������������������������������������������������������������������������������������

'��notify_url����֤
'��� ��֤�����true/false
function notify_verify()
	notify_verify = false
	responseTxt = get_http()			'�ж���Ϣ�ǲ���֧��������	
	sGetArray = GetRequestPost()		'��ȡ֧����POST����֪ͨ��Ϣ������"������=����ֵ"����ʽ�������

	if IsArray(sGetArray) then			'��֤�Ƿ������鴫��
		sArray = para_filter(sGetArray)	'������POST��������������ȥ�ո�
		sort_para = arg_sort(sArray)	'������POST������������������
		mysign  = build_mysign(sort_para,key,sign_type,input_charset)	'����ǩ�����		
		'sWord = "responseTxt="& responseTxt &"\n return_url_log:sign="&request.Form("sign")&"&mysign="&mysign&"&"&create_linkstring(sort_para)
		if mysign = request.Form("sign") and responseTxt = "true" then
			notify_verify = true
		end if
	end if
end function

'********************************************************************************

'��return_url����֤
'��� ��֤�����true/false
function return_verify()
	return_verify = false
	responseTxt = get_http()			'�ж���Ϣ�ǲ���֧��������
	sGetArray = GetRequestGet()			'��ȡ֧����GET����֪ͨ��Ϣ������"������=����ֵ"����ʽ�������

	if IsArray(sGetArray) then			'��֤�Ƿ������鴫��
		sArray = para_filter(sGetArray)	'������GET��������������ȥ�ո�
		sort_para = arg_sort(sArray)	'������GET������������������
		mysign  = build_mysign(sort_para,key,sign_type,input_charset)	'����ǩ�����
		'sWord = "responseTxt="& responseTxt &"\n return_url_log:sign="&request.QueryString("sign")&"&mysign="&mysign&"&"&create_linkstring(sort_para)
		if mysign = request.QueryString("sign") and responseTxt = "true" then
			return_verify = true
		end if	
	end if
end function

'********************************************************************************

'��ȡ֧����GET����֪ͨ��Ϣ������"������=����ֵ"����ʽ�������
'��� request��������Ϣ��ɵ�����
function GetRequestGet()
	dim sArray()
	i = 0
	For Each varItem in Request.QueryString
		Redim Preserve sArray(i)
		sArray(i) = varItem&"="&Request(varItem) 
		i = i + 1
	Next 
	if i = 0 then	'��֤�Ƿ������鴫��
		GetRequestGet = ""
	else
		GetRequestGet = sArray
	end if
	
end function

'********************************************************************************

'��ȡ֧����POST����֪ͨ��Ϣ������"������=����ֵ"����ʽ�������
'��� request��������Ϣ��ɵ�����
function GetRequestPost()
	dim sArray()
	i = 0
	For Each varItem in Request.Form
		Redim Preserve sArray(i)
		sArray(i) = varItem&"="&Request(varItem) 
		i = i + 1
	Next 
	if i = 0 then	'��֤�Ƿ������鴫��
		GetRequestPost = ""
	else
		GetRequestPost = sArray
	end if
end function

'********************************************************************************

'��ȡԶ�̷�����ATN���
'��� ������ATN����ַ���
function get_http()
	gateway = gateway &"partner=" & partner & "&notify_id=" & request("notify_id")
	Set Retrieval = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
    Retrieval.setOption 2, 13056 
    Retrieval.open "GET", gateway, False, "", "" 
    Retrieval.send()
    ResponseTxt = Retrieval.ResponseText
	Set Retrieval = Nothing
	get_http = ResponseTxt
end function

'������������������������������������������������������������������������������������������������������������




'���캯��
'�������ļ�������ļ��г�ʼ������
'inputPara ��Ҫǩ���Ĳ�������
function alipay_service(inputPara)
	gateway = "https://mapi.alipay.com/gateway.do?"
	sPara = para_filter(inputPara)
	
	sort_para = arg_sort(sPara)		'�õ�����ĸa��z������ǩ����������
	'���ǩ�����
	mysign = build_mysign(sort_para,key,sign_type,input_charset)
end function

'��ȥ�����еĿ�ֵ��ǩ������
'sArray ǩ��������
'��� ȥ����ֵ��ǩ�����������ǩ��������
function para_filter(sArray)
	dim para()
	nCount = ubound(sArray)
	dim j
	j = 0
	for i = 0 to nCount
		'��sArray���������Ԫ�ظ�ʽ��������=ֵ���ָ��
		pos = Instr(sArray(i),"=")			'���=�ַ���λ��
		nLen = Len(sArray(i))				'����ַ�������
		itemName = left(sArray(i),pos-1)	'��ñ�����
		itemValue = right(sArray(i),nLen-pos)'��ñ�����ֵ
		
		if itemName <> "sign" and itemName <> "sign_type" and itemValue <> "" then
			Redim Preserve para(j)
			para(j) = sArray(i)
			j = j + 1
		end if
	next
	
	para_filter = para
end function

'����������
'sArray ����ǰ������
'��� ����������
function arg_sort(sArray)
	nCount = ubound(sArray)
	For i = nCount TO 0 Step -1
		minmax = sArray( 0 )
    	minmaxSlot = 0
    	For j = 1 To i
            mark = (sArray( j ) > minmax)
        	If mark Then 
            	minmax = sArray( j )
            	minmaxSlot = j
        	End If
    	Next
		If minmaxSlot <> i Then 
			temp = sArray( minmaxSlot )
			sArray( minmaxSlot ) = sArray( i )
			sArray( i ) = temp
		End If
	Next
	arg_sort = sArray
end function

'����ǩ�����
'sArray Ҫǩ��������
'key ��ȫУ����
'sign_type ǩ������
'��� ǩ������ַ���
function build_mysign(sArray, key, sign_type,input_charset)
	prestr = create_linkstring(sArray)
	nLen = Len(prestr)
	prestr = left(prestr,nLen-1)
    prestr = prestr & key
    mysign = sign(prestr,sign_type,input_charset)
    build_mysign = mysign
end function

'����������Ԫ�أ�����"����=����ֵ"��ģʽ��"&"�ַ�ƴ�ӳ��ַ���
'sArray ��Ҫƴ�ӵ�����
'��� ƴ������Ժ���ַ���
function create_linkstring(sArray)
	nCount = ubound(sArray)
	dim prestr
	for i = 0 to nCount
		prestr = prestr & sArray(i) & "&"
	next
	create_linkstring = prestr
end function

'ǩ���ַ���
'prestr ��Ҫǩ�����ַ���
'sign_type ǩ������
'��� ǩ�����
function sign(prestr,sign_type,input_charset)
	dim sResult
	if sign_type = "MD5" then
		sResult = md5(prestr,input_charset)
	else 
		sResult = ""
	end if
	sign = sResult
end function

'������ύHTML
'��� ���ύHTML�ı�
function build_form()
	'GET��ʽ����
	'POST��ʽ���ݣ�GET��POST����ѡһ��
	'sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='"& gateway &"_input_charset="&input_charset&"' method='post'>"
	nCount = ubound(sPara)
	for i = 0 to nCount
		'��sArray���������Ԫ�ظ�ʽ��������=ֵ���ָ��
		pos = Instr(sPara(i),"=")			'���=�ַ���λ��
		nLen = Len(sPara(i))				'����ַ�������
		itemName = left(sPara(i),pos-1)		'��ñ�����
		itemValue = right(sPara(i),nLen-pos)'��ñ�����ֵ		
		sHtml = sHtml & "<input type='hidden' name='"& itemName &"' value='"& itemValue &"'/>"
	next
	sHtml = sHtml & "<input type='hidden' name='sign' value='"& mysign &"'/>"
	sHtml = sHtml & "<input type='hidden' name='sign_type' value='"& sign_type &"'/>"
	'submit��ť�ؼ��벻Ҫ����name���� '
	'sHtml = sHtml & "<input type=""submit"" value=""֧����ȷ�ϸ���"">"
	build_form = sHtml
end Function


'˫���ܷ����ӿ�
function sendfh()
	nCount = ubound(sPara)
	newPara=""
    sendfh=false
	for i = 0 to nCount
		'��sArray���������Ԫ�ظ�ʽ��������=ֵ���ָ��
		pos = Instr(sPara(i),"=")			'���=�ַ���λ��
		nLen = Len(sPara(i))				'����ַ�������
		itemName = left(sPara(i),pos-1)		'��ñ�����
		itemValue = right(sPara(i),nLen-pos)'��ñ�����ֵ		
		newPara=newPara&itemName&"="&itemValue&"&"
	next

		sURl=gateway&newPara&"sign="&mysign&"&sign_type="&sign_type
       'sendfh=newPara
	    returnxml=GetRemoteUrl(sURl) 
		if instr(returnxml,"<is_success>T</is_success>")>0 then
		sendfh=true
		end if
		 
end function
%>

