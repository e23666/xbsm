<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<!--#include file="alipay_payto.asp"-->
<% Response.Buffer = true %>
<%
conn.open constr
If request.QueryString("trade_no")<>"" Then
	dim gateway			'���ص�ַ
	dim mysign			'ǩ�����
	Dim responseTxt
	gateway = "http://notify.alipay.com/trade/notify_query.do?"

	verify_result = return_verify()
	'verify_result=true
	if verify_result then	'����ó�֪ͨ��֤���
		out_trade_no	= request.QueryString("out_trade_no")	'��ȡ������'�̻�������
		total_fee		= request.QueryString("total_fee")		'��ȡ�ܽ��
		trade_no		= request.QueryString("trade_no")		'֧�������׺�
		
		If Not IsNumeric(trade_no) Or Not IsNumeric(out_trade_no) Then
			echoString "����ķ��ؽ��׺źͶ�����","e"
		End if
		if request.QueryString("trade_status") = "TRADE_FINISHED" or request.QueryString("trade_status") = "TRADE_SUCCESS" then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
			'writelog "POST���׳ɹ�, ���:" & total_fee & "Ԫ, ���׺�Ϊ:" & trade_no & ",������Ϊ:" & out_trade_no
		else
			if alipay_type="SELLER_PAY" and request.QueryString("trade_status")="WAIT_BUYER_CONFIRM_GOODS" then
				dim sPara
				call addRec(user_name,"���û�֧��������������֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]")
				parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
				para=split(parastr,"|")
				
				Call alipay_service(para)
				returnstr = sendfh()
				
				if returnstr then
				call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ������ɹ�")
				echoString "��ϲ����ѡ�񵣱�����,�����ѷ�������ȷ���ջ���Ϊ��������Ӧ����","r" 
				else
				
				call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ�����ʧ��")
				echoString "��ѡ�񵣱�����֧���ɹ���������ʧ������ϵ����Ա!","e"
				end if




			ElseIf requesta("seller_actions")="SEND_GOODS" And  request.QueryString("trade_status")="WAIT_SELLER_SEND_GOODS" Then
					call addRec(user_name,"���û�֧��������������֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]")
					parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						para=split(parastr,"|")
						
						Call alipay_service(para)
						returnstr = sendfh()
						
						if returnstr then
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ������ɹ�")
						echoString "��ϲ����ѡ�񵣱�����,�����ѷ�������ȷ���ջ���Ϊ��������Ӧ����","r" 
						else
						
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ�����ʧ��")
						echoString "��ѡ�񵣱�����֧���ɹ���������ʧ������ϵ����Ա!","e"
						end if
			elseif request.QueryString("trade_status")="WAIT_BUYER_CONFIRM_GOODS" Then
					echoString "��ϲ����ʹ�õ������ף������ѷ�������ȷ���ջ����Զ����","r"
				
 		else
				echoString "����״̬�벻��ȷ�����ν���ʧ��","e"
			end if
		end If
	else
		echoString "���Ч��ʧ�ܣ�MD5����ȷ���޷��������ף�","e"
	end If
End If

function echoString(byval str,byval p)
	response.Redirect "/manager/config/echo.asp?str="& server.urlEncode(str)&"&p=" & p 'p=r/e
	response.write str
	response.end
end Function

''���鶩����''''''''''
function isRing(byval ordernum,byref u_name,byref myorderID)
	isRing=false
	if ordernum<>"" and isnumeric(ordernum) then
		myorderID= clng(ordernum) - 100000
		sql="select top 1 Ring_us,Ring_id,ring_ov from ring where Ring_id="& trim(myorderID) &" and ring_ov="&PE_False&" order by ring_dt desc"
	
		rs1.open sql,conn,1,3
		if not rs1.eof then

			u_name=rs1("Ring_us")
			isRing=true
			rs1("ring_ov")=true
			rs1.update
		end if
		rs1.close
	end if
end function
%>