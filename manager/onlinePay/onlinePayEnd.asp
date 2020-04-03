<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<% Response.Buffer = true %>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->

<!--#include file="alipay_payto.asp"-->
<!--#include file="shengpayclass.asp"-->
<% 
response.Charset="gb2312"
'取返回参数
attach	= Request("attach") '自定参数
MP		= requesta("r8_MP")
merchant_param =  requesta("merchant_param")		'''获取商户私有参数
ext1	 =requesta("ext1")
subject  =DelStr(Request("subject")) '获取收货人手机
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
	dim gateway			'网关地址
	dim mysign			'签名结果
	Dim responseTxt
	dim sPara
	gateway = "http://notify.alipay.com/trade/notify_query.do?"
	Call putalipay()
	If Err.number=0 Then response.Write "success" else response.write "fail"
	response.end
End if
select case lcase(paytype)
	   case	"defaultpay"
	   		agent_user		=requesta("username")'我的用户名
			AddMoney		=requesta("AddMoney")'实际交易额
			GetAmount		=FormatNumber(requesta("GetAmount"),2,-1,-1,0)'提交的钱
			urlPage			=requesta("urlPage")'返回网址
			c_order			=requesta("c_order")'主站订单号
			c_transnum		=requesta("c_transnum")
			c_ymd 			=requesta("c_ymd")'主站订单产生日期
			ToagentRingnum	=requesta("ToagentRingnum")'代理定单号
			mid5str			=requesta("mid5str")
			iform           =requesta("iform")	 '来源
		 
			call putDefaultPay()
	   case "tenpay"
				cmdno			= requesta("cmdno")  ' 财付通支付为"1" (当前只支持 cmdno=1)	
				pay_result		= requesta("pay_result")
				pay_info		= requesta("pay_info")
				bill_date		= requesta("date")
				bargainor_id	= requesta("bargainor_id") ' 商户号
				transaction_id	= requesta("transaction_id")
				sp_billno		= requesta("sp_billno") '商户生成的订单号
				total_fee		= requesta("total_fee")  'total_fee,总金额'分为单位
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
	   			key=alipay_userpass		'支付宝安全教研码
 				partner=alipay_userid	'支付宝合作id

	   			out_trade_no	=DelStr(Request("out_trade_no"))	'获取定单号
				total_fee		=DelStr(Request("total_fee"))		'获取支付的总价格
				receive_name    =DelStr(Request("receive_name"))	'获取收货人姓名
				receive_address =DelStr(Request("receive_address"))	'获取收货人地址
				receive_zip     =DelStr(Request("receive_zip"))		'获取收货人邮编
				receive_phone   =DelStr(Request("receive_phone"))	'获取收货人电话
				receive_mobile  =DelStr(Request("receive_mobile"))	'获取收货人手机
			 				
				call putalipay()
	   case "kuaiqian"
	   			 merchant_key   =  kuaiqian_userpass		'''商户密钥
				 mymerchant_id  =  kuaiqian_userid		'''商户编号
				 merchant_id    =  request("merchant_id")			'''获取商户编号
				 orderid 		=  request("orderid")		'''获取订单编号
				 amount 		=  request("amount")	'''获取订单金额
				 dealdate		=  request("date")		'''获取交易日期
				 succeed 		=  request("succeed")	'''获取交易结果,Y成功,N失败
				 mac 			=  request("mac")		'''获取安全加密串
				 couponid 		= request("couponid")		'''获取优惠券编码
				 couponvalue    = request("couponvalue") 		'''获取优惠券面额
				 call putkuaiqian()
		case "kuaiqian2"
				
				 mymerchant_id  =kuaiqian2_userid		'''账户号
				 key			=kuaiqian2_userpass		'''商户密钥
				 merchantAcctId =trim(request("merchantAcctId"))'得到的账户号

	  			 version		=trim(request("version"))'版本号
				 language		=trim(request("language"))'语言
				 signType		=trim(request("signType"))'签名类型
				 payType		=trim(request("payType"))'支付方式
				 bankId			=trim(request("bankId"))'银行代码
				 orderId		=trim(request("orderId"))'订单号
				 orderTime		=trim(request("orderTime"))'提交时间
				 orderAmount	=trim(request("orderAmount"))'金额 单位:分
				 dealId			=trim(request("dealId"))'快钱交易号
				 bankDealId		=trim(request("bankDealId"))'银行交易号
				 dealTime		=trim(request("dealTime"))'快钱交易时间
				 payAmount		=trim(request("payAmount"))'实际金额
				 fee			=trim(request("fee"))'交易手续费
				 ext1			=trim(request("ext1"))'
				 ext2			=trim(request("ext2"))
				 payResult		=trim(request("payResult"))'''10代表 成功11代表 失败
				 errCode		=trim(request("errCode"))''获取错误代码
				 signMsg		=trim(request("signMsg"))'加密签名
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
		 	v_oid=request("v_oid")'订单号
			v_pmode=request("v_pmode")'银行名称 如：招商银行
			v_pstatus=request("v_pstatus")'支付状态 如：20 支付成功，30 支付失败
			v_pstring=request("v_pstring")'支付状态说明 如：支付成功
			v_amount=request("v_amount")'支付金额
			v_moneytype=request("v_moneytype")'币种 如：CNY
			v_md5str=request("v_md5str")'MD5效验码
			call putchinabank()
		case "shengpay"
	  		  call shengpayaction()
     case else 
end select
%>
 
<%
'tenpay验签函数
Function verifyMd5Sign()

	origText = "cmdno=" & cmdno & "&pay_result=" & pay_result &_ 
		       "&date=" & bill_date & "&transaction_id=" & transaction_id &_
			   "&sp_billno=" & sp_billno & "&total_fee=" & total_fee &_
			   "&fee_type=" & fee_type & "&attach=" & attach &_
			   "&key=" & tenpay_userpass
	
	localSignText = UCase(ASP_MD5(origText)) ' 转换为大写
	verifyMd5Sign = (localSignText = md5_sign)
	
End Function
Function yeepayMd5sign()
	 Set mctSDK = Server.CreateObject("HmacMd5API.HmacMd5Com")
	sbOld = sMerchantID
	'加入消息类型
	sbOld = sbOld + sCmd
	'加入业务返回码
	sbOld = sbOld + sErrorCode
	'加入交易ID
	sbOld = sbOld + sTrxId
	'加入交易金额
	sbOld = sbOld + amount
	'加入货币单位
	sbOld = sbOld + cur
	'加入产品Id
	sbOld = sbOld + productId
	'加入订单ID
	sbOld = sbOld + Cstr(orderId)
	'加入用户ID
	sbOld = sbOld + userId
	'加入商家属性信息
	sbOld = sbOld + MP
	'加入返回类型
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
''检验订单号''''''''''
function isRing(byval ordernum,byref u_name,byref myorderID)
	isRing=false
	
	if ordernum<>"" and isnumeric(ordernum) then
		myorderID= clng(ordernum) - 100000
		sql="select Ring_us,Ring_id,ring_ov,ring_dt from ring where Ring_id="& trim(myorderID) &" and ring_ov="&PE_False&" "
		rs1.open sql,conn,1,3
		if not rs1.eof then
			if datediff("d",rs1("ring_dt"),date())>7 then
				'超过7天的自动放弃,
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
	'''''''''''''''用户信息'''''''''''''''''''''''
	doinsql=false
	usql="select top 1 * from userdetail where u_name='"& R_User &"'"
	rs11.open usql,conn,1,1
	if rs11.eof then doinsql=false:rs11.close:exit function
	 U_id=rs11("u_id")
	'''''''''''''''''''钱钱'''''''''''''''''''''''''''
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
'''''''''''''''''''''财务流水'''''''''''''''''''''''''
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
		
'''''''''''''''''''入款''''''''''''''''''''''''''''''''	

	  Sql="Update UserDetail Set u_usemoney=u_usemoney+" & AddMoney &",u_remcount=u_remcount+" & AddMoney & " Where u_name='" & R_User & "'"
		conn.Execute(Sql)
		OurMoneys=AddMoney
''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''财务记录'''''''''''''''''''''''''
 '显示余额功能
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
	'开始检查用户是否有未还借款，有且支付金额足够则自动还借款
	set BorrowMRS=server.CreateObject("adodb.recordset")
	BorrowMsql="SELECT countlist.u_moneysum, countlist.sysid FROM (countlist INNER JOIN UserDetail ON countlist.u_id = UserDetail.u_id) WHERE (UserDetail.u_name = '"&R_User&"') AND (countlist.c_check = "&PE_True&") AND (countlist.c_memo = '借款') ORDER BY countlist.c_dateinput DESC"
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
				'显示余额功能
		u_Balance=conn.execute("select u_usemoney from Userdetail  where u_id=" & edward_u_id)(0)
				
					''插入支付欠款记录
				sql="INSERT INTO dbo.countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note,u_Balance) VALUES ("&edward_u_id&","&tempBorrowMoney&",0,"&tempBorrowMoney&",'"&DateRadom&"','支付欠款',"&PE_False&",'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0,"&u_Balance&")"
				conn.execute(sql)

				'将借款记录改为已审核
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
		DelStr	= Replace(DelStr,"　","")
		DelStr	= Replace(DelStr,"%20","")
		DelStr	= Replace(DelStr,"--","")
		DelStr	= Replace(DelStr,"==","")
		DelStr	= Replace(DelStr,"<","")
		DelStr	= Replace(DelStr,">","")
		DelStr	= Replace(DelStr,"%","")
End Function
function putTenPay()
	If bargainor_id <> tenpay_userid Then echoString "商户号验证错误","e"
	If not verifyMd5Sign then echoString "md5验证错误TenPay","e"
	if isRing(sp_billno,user_name,orderID) then
		If pay_result <> 0 Then echoString "支付失败","e"
		
		total_fee=total_fee / 100 '化为元为单位
		if doinsql(user_name,orderID,total_fee,"财付通在线支付") then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
		echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
end function

function putcncard()
	if c_mid<>cncard_cmid then
			echoString "商户号验证错误","e"
	end if
	VerifyMsg=ASP_Md5(c_mid & c_order & c_orderamount & c_ymd & c_transnum & c_succmark & c_moneytype & c_memo1 & cncard_cpass)
	if VerifyMsg<>c_signstr then
			echoString "md5指纹验证失败","e"
	end if
	if isRing(c_order,user_name,orderIDs) then
		if c_succmark<>"Y" then echoString "支付失败","e"
		if doinsql(user_name,orderIDs,c_orderamount,"云网支付") then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
		echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
end function

function putchinabank()
	md5text = Ucase(trim(asp_md5(v_oid & v_pstatus & v_amount & v_moneytype & chinabank_cpass)))
	if md5text<>v_md5str then echoString "md5验证错误chinabank","e"
	if isRing(v_oid,user_name,orderIDs) then
	if v_pstatus<>"20" then echoString "支付失败","e"
		if doinsql(user_name,orderIDs,v_amount,"银网在线支付") then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
		echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
end function

function putyeePay()
	If sMerchantID <> yeepay_userid Then echoString "商户号验证错误","e"
	if not yeepayMd5sign then echoString "md5验证错误yeePay","e"
	if isRing(orderId,user_name,orderIDs) then
		If sErrorCode <> 1 Then echoString "支付失败","e"
		
		if doinsql(user_name,orderIDs,amount,"易宝在线支付") then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
		echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
end function
function putkuaiqian()
	If merchant_id <> kuaiqian_userid Then echoString "商户号验证错误","e"
	If not kuaiquanMD5sign then echoString "md5验证错误bill99","e"
	if isRing(orderid,user_name,orderIDs) then
		If succeed <> "Y" Then echoString "支付失败","e"
		
	
		if doinsql(user_name,orderIDs,amount,"快钱在线支付") then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
		echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
end function 
function putkuaiqian2()
	If mymerchant_id <> merchantAcctId Then echoString2 "商户号验证错误","e"
	If not kuaiquan2MD5sign then echoString2 "md5验证错误bill99","e"
	if isRing(orderid,user_name,orderIDs) then
		If payResult <> "10" Then echoString2 "支付失败","e"
		orderAmount=orderAmount / 100 '化为元为单位
		if doinsql(user_name,orderIDs,orderAmount,"快钱在线支付") then
				echoString2 "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
		end if
	else
			echoString2 "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
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
	if verify_result then	'计算得出通知验证结果
		out_trade_no	= requesta("out_trade_no")	'获取订单号'商户订单号
		total_fee		= requesta("total_fee")		'获取总金额
		trade_no		= requesta("trade_no")		'支付宝交易号
		If Not IsNumeric(trade_no) Or Not IsNumeric(out_trade_no) Then
			'writelog "错误的返回交易号和订单号"
			Exit Function
		End if
		if requesta("trade_status") = "TRADE_FINISHED" or requesta("trade_status") = "TRADE_SUCCESS" then
			if isRing(out_trade_no,user_name,orderID) then
				if doinsql(user_name,orderID,total_fee,"支付宝在线支付") then
					'writelog "POST交易成功, 金额:" & total_fee & "元, 交易号为:" & trade_no & ",订单号为:" & out_trade_no
				else
					'writelog "支付失败"
				end if
			else
				'writelog "重复处理或无此订单"
			end If
		else
			'writelog "交易状态码不正确"
			if alipay_type="SELLER_PAY" and requesta("trade_status")="WAIT_SELLER_SEND_GOODS" then
					'写代手工处理
					call addRec(user_name,"有用户支付担保交易请检查支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]")
						  parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						 para=split(parastr,"|")
						 
						Call alipay_service(para)
						returnstr = sendfh()
						if returnstr then
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货成功")
						else
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货失败")
						end if


			 ElseIf   requesta("trade_status")="WAIT_SELLER_SEND_GOODS" Then
					call addRec(user_name,"有用户支付担保交易请检查支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]")
					parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						para=split(parastr,"|")
						
						Call alipay_service(para)
						returnstr = sendfh()
						
						if returnstr then
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货成功")
						 
						else
						
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货失败")
						 
						end if
			end if

		end If
	else
		'writelog "验证失败"
	end If
End Function

function putDefaultPay()
	strmd5=urlPage & ToagentRingnum & agent_user & api_username & GetAmount & c_ymd & c_order & api_password 
	ToagentMid5str=md5_32(strmd5)
    if mid5str<>ToagentMid5str then 
		errStr = "非法请求校验失败,您的订单号是:"& ToagentRingnum
	else
		if not isRing(ToagentRingnum,user_name,orderID) then 
			errStr="抱歉,订单"& ToagentRingnum &" 已支付或不存在.请联系管理员_"
		else
		   if user_name<>agent_user then
		  		errstr="抱歉，用户不相同"
		   else
				
											
				if doinsql(user_name,orderID,AddMoney,"默认在线支付") then


					result = "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．" 			
					if iform="west" then result = "SUCCESS"
					response.write result
					exit function
				else
					errstr="抱歉,支付失败,请查看财务记录"
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
			InstCode=requesta("InstCode")	'银行名字
			MerchantNo=requesta("MerchantNo")
			TransType=requesta("TransType")
			ErrorCode=requesta("ErrorCode")
			Ext1=requesta("Ext1")
			Ext2=requesta("Ext2")
			SignMsg=requesta("SignMsg")
			
			TraceNo=requesta("TraceNo")			'请求序列号，报文发起方唯一标识
			OrderAmount=requesta("OrderAmount")	'支付金额
			TransAmount=requesta("TransAmount")	'实际支付金额
			TransNo=requesta("TransNo")			'盛付通交易号
			OrderNo=requesta("OrderNo")			'我司系统订单号
			TransStatus=requesta("TransStatus")	'支付状态：01为成功 00等待付款 02付款失败
			TransTime=requesta("TransTime")		'盛付通交易时间
			
			origin =Name & Version & Charset & TraceNo & MsgSender & SendTime & InstCode & OrderNo & OrderAmount &_
					TransNo & TransAmount & TransStatus & TransType & TransTime & MerchantNo & Ext1 & Ext2 & SignType&shengpay_Md5Key
			mySignMsg = sp.BuildSign(origin)
			v_oid=OrderNo
		
	'	die 	origin&"<BR>"&mySignMsg&"="&SignMsg&"="&TransStatus
	 
	if  mySignMsg=SignMsg  and TransStatus="01" then
		if isRing(v_oid,user_name,orderIDs) then
			if doinsql(user_name,orderIDs,TransAmount,"盛付通在线支付") then
            	echoString "恭喜！在线支付成功1!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
			end if
		else
             echoString "恭喜！在线支付成功2!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	    end if
	else
 
	       echoString "在线支付失败!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
	end if
	
	 
			

end function
	
			
%>
