<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<% Response.Buffer = true %>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->

<!--#include file="alipay_payto.asp"-->
<!--#include file="shengpayclass.asp"-->
<% 
response.Charset="gb2312"
'ȡ���ز���
attach	= Request("attach") '�Զ�����
MP		= requesta("r8_MP")
merchant_param =  requesta("merchant_param")		'''��ȡ�̻�˽�в���
ext1	 =requesta("ext1")
subject  =DelStr(Request("subject")) '��ȡ�ջ����ֻ�
c_memo1 = Requesta("c_memo1")
remark1=request("remark1")

'die ext1

if trim(attach)&""<>""  then 
	paytype=attach
elseif trim(MP)&""<>"" 		then 
	paytype=MP
elseif trim(merchant_param)&""<>""  then 
	paytype=merchant_param	
elseif trim(subject)&""<>"" then 
	paytype=subject
elseif trim(ext1)&""<>"" then
	paytype=trim(ext1)
elseif trim(c_memo1) & ""<>"" then
	paytype=c_memo1
elseif trim(remark1) & ""<>"" then
	paytype=remark1
else
	paytype="defaultpay"
end if
conn.open constr
If requesta("trade_no")<>"" Then
	dim gateway			'���ص�ַ
	dim mysign			'ǩ�����
	Dim responseTxt
	dim sPara
	gateway = "http://notify.alipay.com/trade/notify_query.do?"
	Call putalipay()
	If Err.number=0 Then response.Write "success" else response.write "fail"
	response.end
End if
select case lcase(paytype)
	   case	"defaultpay"
	   		agent_user		=requesta("username")'�ҵ��û���
			AddMoney		=requesta("AddMoney")'ʵ�ʽ��׶�
			GetAmount		=FormatNumber(requesta("GetAmount"),2,-1,-1,0)'�ύ��Ǯ
			urlPage			=requesta("urlPage")'������ַ
			c_order			=requesta("c_order")'��վ������
			c_transnum		=requesta("c_transnum")
			c_ymd 			=requesta("c_ymd")'��վ������������
			ToagentRingnum	=requesta("ToagentRingnum")'��������
			mid5str			=requesta("mid5str")
			iform           =requesta("iform")	 '��Դ
		 
			call putDefaultPay()
	   case "tenpay"
				cmdno			= requesta("cmdno")  ' �Ƹ�֧ͨ��Ϊ"1" (��ǰֻ֧�� cmdno=1)	
				pay_result		= requesta("pay_result")
				pay_info		= requesta("pay_info")
				bill_date		= requesta("date")
				bargainor_id	= requesta("bargainor_id") ' �̻���
				transaction_id	= requesta("transaction_id")
				sp_billno		= requesta("sp_billno") '�̻����ɵĶ�����
				total_fee		= requesta("total_fee")  'total_fee,�ܽ��'��Ϊ��λ
				fee_type		= requesta("fee_type")
				md5_sign		= requesta("sign")
				call putTenPay()
	   case "yeepay"
				sMerchantID	= requesta("p1_MerId")
	   			sCmd		= requesta("r0_Cmd")
				sErrorCode  = requesta("r1_Code")
				sTrxId		= requesta("r2_TrxId")
				amount		= requesta("r3_Amt")
				cur			= requesta("r4_Cur")
				productId	= requesta("r5_Pid")
				orderId		= requesta("r6_Order")
				userId		= requesta("r7_Uid")
				bType		= requesta("r9_BType") 
				hmac		= requesta("hmac")
				call putyeePay()
	   case "alipay"
				'writelog "xxxx"
				response.end
	   			key=alipay_userpass		'֧������ȫ������
 				partner=alipay_userid	'֧��������id

	   			out_trade_no	=DelStr(Request("out_trade_no"))	'��ȡ������
				total_fee		=DelStr(Request("total_fee"))		'��ȡ֧�����ܼ۸�
				receive_name    =DelStr(Request("receive_name"))	'��ȡ�ջ�������
				receive_address =DelStr(Request("receive_address"))	'��ȡ�ջ��˵�ַ
				receive_zip     =DelStr(Request("receive_zip"))		'��ȡ�ջ����ʱ�
				receive_phone   =DelStr(Request("receive_phone"))	'��ȡ�ջ��˵绰
				receive_mobile  =DelStr(Request("receive_mobile"))	'��ȡ�ջ����ֻ�
			 				
				call putalipay()
	   case "kuaiqian"
	   			 merchant_key   =  kuaiqian_userpass		'''�̻���Կ
				 mymerchant_id  =  kuaiqian_userid		'''�̻����
				 merchant_id    =  request("merchant_id")			'''��ȡ�̻����
				 orderid 		=  request("orderid")		'''��ȡ�������
				 amount 		=  request("amount")	'''��ȡ�������
				 dealdate		=  request("date")		'''��ȡ��������
				 succeed 		=  request("succeed")	'''��ȡ���׽��,Y�ɹ�,Nʧ��
				 mac 			=  request("mac")		'''��ȡ��ȫ���ܴ�
				 couponid 		= request("couponid")		'''��ȡ�Ż�ȯ����
				 couponvalue    = request("couponvalue") 		'''��ȡ�Ż�ȯ���
				 call putkuaiqian()
		case "kuaiqian2"
				
				 mymerchant_id  =kuaiqian2_userid		'''�˻���
				 key			=kuaiqian2_userpass		'''�̻���Կ
				 merchantAcctId =trim(request("merchantAcctId"))'�õ����˻���

	  			 version		=trim(request("version"))'�汾��
				 language		=trim(request("language"))'����
				 signType		=trim(request("signType"))'ǩ������
				 payType		=trim(request("payType"))'֧����ʽ
				 bankId			=trim(request("bankId"))'���д���
				 orderId		=trim(request("orderId"))'������
				 orderTime		=trim(request("orderTime"))'�ύʱ��
				 orderAmount	=trim(request("orderAmount"))'��� ��λ:��
				 dealId			=trim(request("dealId"))'��Ǯ���׺�
				 bankDealId		=trim(request("bankDealId"))'���н��׺�
				 dealTime		=trim(request("dealTime"))'��Ǯ����ʱ��
				 payAmount		=trim(request("payAmount"))'ʵ�ʽ��
				 fee			=trim(request("fee"))'����������
				 ext1			=trim(request("ext1"))'
				 ext2			=trim(request("ext2"))
				 payResult		=trim(request("payResult"))'''10���� �ɹ�11���� ʧ��
				 errCode		=trim(request("errCode"))''��ȡ�������
				 signMsg		=trim(request("signMsg"))'����ǩ��
				 call putkuaiqian2()
		case "cncard"
			c_mid=Request("c_mid")
			c_order=Request("c_order")
			c_orderamount=Request("c_orderamount")
			c_ymd=Request("c_ymd")
			c_moneytype=Request("c_moneytype")
			c_transnum=Request("c_transnum")
			c_succmark=Request("c_succmark")
			c_signstr=Request("c_signstr")
			 call putcncard()
		 case "chinabank"
		 	v_oid=request("v_oid")'������
			v_pmode=request("v_pmode")'�������� �磺��������
			v_pstatus=request("v_pstatus")'֧��״̬ �磺20 ֧���ɹ���30 ֧��ʧ��
			v_pstring=request("v_pstring")'֧��״̬˵�� �磺֧���ɹ�
			v_amount=request("v_amount")'֧�����
			v_moneytype=request("v_moneytype")'���� �磺CNY
			v_md5str=request("v_md5str")'MD5Ч����
			call putchinabank()
		case "shengpay"
	  		  call shengpayaction()
     case else 
end select
%>
 
<%
'tenpay��ǩ����
Function verifyMd5Sign()

	origText = "cmdno=" & cmdno & "&pay_result=" & pay_result &_ 
		       "&date=" & bill_date & "&transaction_id=" & transaction_id &_
			   "&sp_billno=" & sp_billno & "&total_fee=" & total_fee &_
			   "&fee_type=" & fee_type & "&attach=" & attach &_
			   "&key=" & tenpay_userpass
	
	localSignText = UCase(ASP_MD5(origText)) ' ת��Ϊ��д
	verifyMd5Sign = (localSignText = md5_sign)
	
End Function
Function yeepayMd5sign()
	 Set mctSDK = Server.CreateObject("HmacMd5API.HmacMd5Com")
	sbOld = sMerchantID
	'������Ϣ����
	sbOld = sbOld + sCmd
	'����ҵ�񷵻���
	sbOld = sbOld + sErrorCode
	'���뽻��ID
	sbOld = sbOld + sTrxId
	'���뽻�׽��
	sbOld = sbOld + amount
	'������ҵ�λ
	sbOld = sbOld + cur
	'�����ƷId
	sbOld = sbOld + productId
	'���붩��ID
	sbOld = sbOld + Cstr(orderId)
	'�����û�ID
	sbOld = sbOld + userId
	'�����̼�������Ϣ
	sbOld = sbOld + MP
	'���뷵������
	sbOld = sbOld + bType
	sNew= mctSDK.HmacMd5(sbOld, yeepay_userpass)
	 
	 if sNew=hmac then
	 	yeepayMd5sign=true	
	 else
	 	yeepayMd5sign=false
	 end if
	 Set mctSDK = nothing
end Function
function kuaiquanMD5sign()
	ScrtStr = "merchant_id=" & merchant_id & "&orderid=" & orderid & "&amount=" & amount & "&date=" & dealdate & "&succeed=" & succeed & "&merchant_key=" & merchant_key
	mymac=ASP_MD5(ScrtStr) 
	kuaiquanMD5sign=(Ucase(mymac)=Ucase(mac))
end function
function kuaiquan2MD5sign()
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"merchantAcctId",merchantAcctId)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"version",version)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"language",language)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"signType",signType)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"payType",payType)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"bankId",bankId)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"orderId",orderId)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"orderTime",orderTime)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"orderAmount",orderAmount)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"dealId",dealId)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"bankDealId",bankDealId)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"dealTime",dealTime)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"payAmount",payAmount)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"fee",fee)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"ext1",ext1)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"ext2",ext2)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"payResult",payResult)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"errCode",errCode)
	merchantSignMsgVal=appendParam(merchantSignMsgVal,"key",key)
	merchantSignMsg= asp_md5(merchantSignMsgVal)
	kuaiquan2MD5sign=(Ucase(merchantSignMsg)=Ucase(signMsg))
end function
''���鶩����''''''''''
function isRing(byval ordernum,byref u_name,byref myorderID)
	isRing=false
	
	if ordernum<>"" and isnumeric(ordernum) then
		myorderID= clng(ordernum) - 100000
		sql="select Ring_us,Ring_id,ring_ov,ring_dt from ring where Ring_id="& trim(myorderID) &" and ring_ov="&PE_False&" "
		rs1.open sql,conn,1,3
		if not rs1.eof then
			if datediff("d",rs1("ring_dt"),date())>7 then
				'����7����Զ�����,
				exit function
			end if
			u_name=rs1("Ring_us")
			isRing=true
			rs1("ring_ov")=true
			rs1.update
		end if
		rs1.close
	end if
end function

function doinsql(byval R_User,byval orderNo,byval c_orderamount,byval payName)
	'''''''''''''''�û���Ϣ'''''''''''''''''''''''
	doinsql=false
	usql="select top 1 * from userdetail where u_name='"& R_User &"'"
	rs11.open usql,conn,1,1
	if rs11.eof then doinsql=false:rs11.close:exit function
	 U_id=rs11("u_id")
	'''''''''''''''''''ǮǮ'''''''''''''''''''''''''''
	Set RingRs=conn.Execute("select ring_us,ring_pr from ring where ring_id=" & orderNo)
	R_Price=RingRs("ring_pr")
	R_User=RingRs("Ring_us")
	RingRs.close
	Set RingRs=nothing 
	PayAmount=Ccur(c_orderamount) 'total_fee
	GetAmount=Ccur(R_Price)
	AddMoney=0
	if PayAmount>=GetAmount then
		AddMoney=GetAmount
	else
		AddMoney=PayAmount
	end if
'''''''''''''''''''''������ˮ'''''''''''''''''''''''''
set rstemp=server.createobject("adodb.recordset")
		rstemp.open "ourmoney",conn,3,3
		rstemp.addnew
	
		rstemp("Name")=R_User
		rstemp("UserName")=R_User
		rstemp("PayMethod")=payName
		rstemp("Amount")=AddMoney
		rstemp("PayDate")=now()
		rstemp("Orders")=orderNo
		rstemp("Memo")=payName
	
		rstemp.update
		rstemp.close
		
'''''''''''''''''''���''''''''''''''''''''''''''''''''	

	  Sql="Update UserDetail Set u_usemoney=u_usemoney+" & AddMoney &",u_remcount=u_remcount+" & AddMoney & " Where u_name='" & R_User & "'"
		conn.Execute(Sql)
		OurMoneys=AddMoney
''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''�����¼'''''''''''''''''''''''''
 '��ʾ����
    p_u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&R_User&"'")(0)
	 set rstemp2=server.createobject("adodb.recordset")
	  rstemp2.open "CountList",conn,3,3
	  rstemp2.addnew  
	  rstemp2("u_id")=U_id
	  rstemp2("u_MoneySum")=AddMoney
	  rstemp2("u_in")=AddMoney
	  rstemp2("u_out")=0
	  rstemp2("u_CountID")="(OL)-" & orderNo
	  rstemp2("c_memo")=payName
	
	  rstemp2("c_check")=false
	  rstemp2("u_Balance")=p_u_Balance
	  rstemp2("c_date")=Now
	  rstemp2("c_dateinput")=now
	  rstemp2("c_datecheck")=now
	  rstemp2("c_type")=10

	  rstemp2.update
	  rstemp2.close
	  set rstemp2=nothing
	'=============================
	'��ʼ����û��Ƿ���δ��������֧������㹻���Զ������
	set BorrowMRS=server.CreateObject("adodb.recordset")
	BorrowMsql="SELECT countlist.u_moneysum, countlist.sysid FROM (countlist INNER JOIN UserDetail ON countlist.u_id = UserDetail.u_id) WHERE (UserDetail.u_name = '"&R_User&"') AND (countlist.c_check = "&PE_True&") AND (countlist.c_memo = '���') ORDER BY countlist.c_dateinput DESC"
	BorrowMRS.open BorrowMsql,conn,1,1
	tempBorrowMoney=ccur(0)
	if not BorrowMRS.eof then
		tempBorrowMoney=BorrowMRS(0)
		SysId_array=BorrowMRS(1)
		if CCur(OurMoneys)>=ccur(tempBorrowMoney) then
			set Uidrs=server.CreateObject("adodb.recordset")
			sql="SELECT u_id FROM UserDetail where u_name='"&R_User&"'"
			Uidrs.open sql,conn,1,1
			if not Uidrs.eof then
				edward_u_id=Uidrs(0)
				DateRadom=GetDateRadom()
				
			
				
				conn.execute("update userdetail set u_usemoney=u_usemoney-" & tempBorrowMoney & ",u_checkmoney=u_checkmoney-" & tempBorrowMoney & " where u_id=" & edward_u_id)
				'��ʾ����
		u_Balance=conn.execute("select u_usemoney from Userdetail  where u_id=" & edward_u_id)(0)
				
					''����֧��Ƿ���¼
				sql="INSERT INTO dbo.countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note,u_Balance) VALUES ("&edward_u_id&","&tempBorrowMoney&",0,"&tempBorrowMoney&",'"&DateRadom&"','֧��Ƿ��',"&PE_False&",'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0,"&u_Balance&")"
				conn.execute(sql)

				'������¼��Ϊ�����
				sql="UPDATE dbo.countlist SET c_check ="&PE_False&" WHERE sysid="&SysId_array&""
				conn.execute(sql)
				
			end if
			Uidrs.close
		end if
	end if
	BorrowMRS.close
	'=============================
	doinsql=true
end function
Function DelStr(Str)
		If IsNull(Str) Or IsEmpty(Str) Then
			Str	= ""
		End If
		DelStr	= Replace(Str,";","")
		DelStr	= Replace(DelStr,"'","")
		DelStr	= Replace(DelStr,"&","")
		DelStr	= Replace(DelStr," ","")
		DelStr	= Replace(DelStr,"��","")
		DelStr	= Replace(DelStr,"%20","")
		DelStr	= Replace(DelStr,"--","")
		DelStr	= Replace(DelStr,"==","")
		DelStr	= Replace(DelStr,"<","")
		DelStr	= Replace(DelStr,">","")
		DelStr	= Replace(DelStr,"%","")
End Function
function putTenPay()
	If bargainor_id <> tenpay_userid Then echoString "�̻�����֤����","e"
	If not verifyMd5Sign then echoString "md5��֤����TenPay","e"
	if isRing(sp_billno,user_name,orderID) then
		If pay_result <> 0 Then echoString "֧��ʧ��","e"
		
		total_fee=total_fee / 100 '��ΪԪΪ��λ
		if doinsql(user_name,orderID,total_fee,"�Ƹ�ͨ����֧��") then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
		echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function

function putcncard()
	if c_mid<>cncard_cmid then
			echoString "�̻�����֤����","e"
	end if
	VerifyMsg=ASP_Md5(c_mid & c_order & c_orderamount & c_ymd & c_transnum & c_succmark & c_moneytype & c_memo1 & cncard_cpass)
	if VerifyMsg<>c_signstr then
			echoString "md5ָ����֤ʧ��","e"
	end if
	if isRing(c_order,user_name,orderIDs) then
		if c_succmark<>"Y" then echoString "֧��ʧ��","e"
		if doinsql(user_name,orderIDs,c_orderamount,"����֧��") then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
		echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function

function putchinabank()
	md5text = Ucase(trim(asp_md5(v_oid & v_pstatus & v_amount & v_moneytype & chinabank_cpass)))
	if md5text<>v_md5str then echoString "md5��֤����chinabank","e"
	if isRing(v_oid,user_name,orderIDs) then
	if v_pstatus<>"20" then echoString "֧��ʧ��","e"
		if doinsql(user_name,orderIDs,v_amount,"��������֧��") then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
		echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function

function putyeePay()
	If sMerchantID <> yeepay_userid Then echoString "�̻�����֤����","e"
	if not yeepayMd5sign then echoString "md5��֤����yeePay","e"
	if isRing(orderId,user_name,orderIDs) then
		If sErrorCode <> 1 Then echoString "֧��ʧ��","e"
		
		if doinsql(user_name,orderIDs,amount,"�ױ�����֧��") then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
		echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function
function putkuaiqian()
	If merchant_id <> kuaiqian_userid Then echoString "�̻�����֤����","e"
	If not kuaiquanMD5sign then echoString "md5��֤����bill99","e"
	if isRing(orderid,user_name,orderIDs) then
		If succeed <> "Y" Then echoString "֧��ʧ��","e"
		
	
		if doinsql(user_name,orderIDs,amount,"��Ǯ����֧��") then
			echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
		echoString "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function 
function putkuaiqian2()
	If mymerchant_id <> merchantAcctId Then echoString2 "�̻�����֤����","e"
	If not kuaiquan2MD5sign then echoString2 "md5��֤����bill99","e"
	if isRing(orderid,user_name,orderIDs) then
		If payResult <> "10" Then echoString2 "֧��ʧ��","e"
		orderAmount=orderAmount / 100 '��ΪԪΪ��λ
		if doinsql(user_name,orderIDs,orderAmount,"��Ǯ����֧��") then
				echoString2 "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
		end if
	else
			echoString2 "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
end function 
function echostring2(byval str,byval p)
	conn.close
	showurl=companynameurl&"/manager/config/echo.asp?str="& server.urlEncode(str)&"&p=" & p 'p=r/e
	response.write "<result>1</result><redirecturl>"& showurl &"</redirecturl>"
	
	response.end

end Function

Function putalipay()
 
	verify_result = notify_verify()
	verify_result=true
	if verify_result then	'����ó�֪ͨ��֤���
		out_trade_no	= requesta("out_trade_no")	'��ȡ������'�̻�������
		total_fee		= requesta("total_fee")		'��ȡ�ܽ��
		trade_no		= requesta("trade_no")		'֧�������׺�
		If Not IsNumeric(trade_no) Or Not IsNumeric(out_trade_no) Then
			'writelog "����ķ��ؽ��׺źͶ�����"
			Exit Function
		End if
		if requesta("trade_status") = "TRADE_FINISHED" or requesta("trade_status") = "TRADE_SUCCESS" then
			if isRing(out_trade_no,user_name,orderID) then
				if doinsql(user_name,orderID,total_fee,"֧��������֧��") then
					'writelog "POST���׳ɹ�, ���:" & total_fee & "Ԫ, ���׺�Ϊ:" & trade_no & ",������Ϊ:" & out_trade_no
				else
					'writelog "֧��ʧ��"
				end if
			else
				'writelog "�ظ�������޴˶���"
			end If
		else
			'writelog "����״̬�벻��ȷ"
			if alipay_type="SELLER_PAY" and requesta("trade_status")="WAIT_SELLER_SEND_GOODS" then
					'д���ֹ�����
					call addRec(user_name,"���û�֧��������������֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]")
						  parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						 para=split(parastr,"|")
						 
						Call alipay_service(para)
						returnstr = sendfh()
						if returnstr then
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ������ɹ�")
						else
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ�����ʧ��")
						end if


			 ElseIf   requesta("trade_status")="WAIT_SELLER_SEND_GOODS" Then
					call addRec(user_name,"���û�֧��������������֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]")
					parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						para=split(parastr,"|")
						
						Call alipay_service(para)
						returnstr = sendfh()
						
						if returnstr then
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ������ɹ�")
						 
						else
						
						call addRec(user_name,"֧�������׺�["&trade_no&"]�̻�������["&out_trade_no&"]["&total_fee&"Ԫ]���Զ�����ʧ��")
						 
						end if
			end if

		end If
	else
		'writelog "��֤ʧ��"
	end If
End Function

function putDefaultPay()
	strmd5=urlPage & ToagentRingnum & agent_user & api_username & GetAmount & c_ymd & c_order & api_password 
	ToagentMid5str=md5_32(strmd5)
    if mid5str<>ToagentMid5str then 
		errStr = "�Ƿ�����У��ʧ��,���Ķ�������:"& ToagentRingnum
	else
		if not isRing(ToagentRingnum,user_name,orderID) then 
			errStr="��Ǹ,����"& ToagentRingnum &" ��֧���򲻴���.����ϵ����Ա_"
		else
		   if user_name<>agent_user then
		  		errstr="��Ǹ���û�����ͬ"
		   else
				
											
				if doinsql(user_name,orderID,AddMoney,"Ĭ������֧��") then


					result = "��ϲ������֧���ɹ�!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��" 			
					if iform="west" then result = "SUCCESS"
					response.write result
					exit function
				else
					errstr="��Ǹ,֧��ʧ��,��鿴�����¼"
				end if

			end if
			
		end if
	end if
	response.write errstr
end function
Function appendParam(returnStr,paramId,paramValue)

	If returnStr <> "" Then
		If paramValue <> "" then
			returnStr=returnStr&"&"&paramId&"="&paramValue
		End if
	Else 
		If paramValue <> "" then
			returnStr=paramId&"="&paramValue
		End if
	End if
	appendParam=ReturnStr

End Function	

function shengpayaction()
  		    set sp=new ShengPayClass
			Name=requesta("Name")
			MsgSender=requesta("MsgSender")
			Version=requesta("Version")
			Charset=requesta("Charset")
			ErrorMsg=requesta("ErrorMsg")
			SignType=requesta("SignType")
			SendTime=requesta("SendTime")
			InstCode=requesta("InstCode")	'��������
			MerchantNo=requesta("MerchantNo")
			TransType=requesta("TransType")
			ErrorCode=requesta("ErrorCode")
			Ext1=requesta("Ext1")
			Ext2=requesta("Ext2")
			SignMsg=requesta("SignMsg")
			
			TraceNo=requesta("TraceNo")			'�������кţ����ķ���Ψһ��ʶ
			OrderAmount=requesta("OrderAmount")	'֧�����
			TransAmount=requesta("TransAmount")	'ʵ��֧�����
			TransNo=requesta("TransNo")			'ʢ��ͨ���׺�
			OrderNo=requesta("OrderNo")			'��˾ϵͳ������
			TransStatus=requesta("TransStatus")	'֧��״̬��01Ϊ�ɹ� 00�ȴ����� 02����ʧ��
			TransTime=requesta("TransTime")		'ʢ��ͨ����ʱ��
			
			origin =Name & Version & Charset & TraceNo & MsgSender & SendTime & InstCode & OrderNo & OrderAmount &_
					TransNo & TransAmount & TransStatus & TransType & TransTime & MerchantNo & Ext1 & Ext2 & SignType&shengpay_Md5Key
			mySignMsg = sp.BuildSign(origin)
			v_oid=OrderNo
		
	'	die 	origin&"<BR>"&mySignMsg&"="&SignMsg&"="&TransStatus
	 
	if  mySignMsg=SignMsg  and TransStatus="01" then
		if isRing(v_oid,user_name,orderIDs) then
			if doinsql(user_name,orderIDs,TransAmount,"ʢ��ͨ����֧��") then
            	echoString "��ϲ������֧���ɹ�1!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
			end if
		else
             echoString "��ϲ������֧���ɹ�2!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	    end if
	else
 
	       echoString "����֧��ʧ��!���¼<a href="& companynameurl &" target=_blank>��������</a>�鿴��","r" 
	end if
	
	 
			

end function
	
			
%>
