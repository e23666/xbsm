<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<!--#include file="alipay_payto.asp"-->
<% Response.Buffer = true %>
<%
conn.open constr
If request.QueryString("trade_no")<>"" Then
	dim gateway			'网关地址
	dim mysign			'签名结果
	Dim responseTxt
	gateway = "http://notify.alipay.com/trade/notify_query.do?"

	verify_result = return_verify()
	'verify_result=true
	if verify_result then	'计算得出通知验证结果
		out_trade_no	= request.QueryString("out_trade_no")	'获取订单号'商户订单号
		total_fee		= request.QueryString("total_fee")		'获取总金额
		trade_no		= request.QueryString("trade_no")		'支付宝交易号
		
		If Not IsNumeric(trade_no) Or Not IsNumeric(out_trade_no) Then
			echoString "错误的返回交易号和订单号","e"
		End if
		if request.QueryString("trade_status") = "TRADE_FINISHED" or request.QueryString("trade_status") = "TRADE_SUCCESS" then
			echoString "恭喜！在线支付成功!请登录<a href="& companynameurl &" target=_blank>管理中心</a>查看．","r" 
			'writelog "POST交易成功, 金额:" & total_fee & "元, 交易号为:" & trade_no & ",订单号为:" & out_trade_no
		else
			if alipay_type="SELLER_PAY" and request.QueryString("trade_status")="WAIT_BUYER_CONFIRM_GOODS" then
				dim sPara
				call addRec(user_name,"有用户支付担保交易请检查支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]")
				parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
				para=split(parastr,"|")
				
				Call alipay_service(para)
				returnstr = sendfh()
				
				if returnstr then
				call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货成功")
				echoString "恭喜，因选择担保交易,卖家已发货，请确认收货后将为您充入相应金额！！","r" 
				else
				
				call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货失败")
				echoString "因选择担保交易支付成功，但发货失败请联系管理员!","e"
				end if




			ElseIf requesta("seller_actions")="SEND_GOODS" And  request.QueryString("trade_status")="WAIT_SELLER_SEND_GOODS" Then
					call addRec(user_name,"有用户支付担保交易请检查支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]")
					parastr="service=send_goods_confirm_by_platform|partner="&partner&"|_input_charset="&input_charset&"|trade_no="&trade_no&"|logistics_name=my|invoice_no=|transport_type=DIRECT"
						para=split(parastr,"|")
						
						Call alipay_service(para)
						returnstr = sendfh()
						
						if returnstr then
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货成功")
						echoString "恭喜，因选择担保交易,卖家已发货，请确认收货后将为您充入相应金额！！","r" 
						else
						
						call addRec(user_name,"支付宝交易号["&trade_no&"]商户订单号["&out_trade_no&"]["&total_fee&"元]，自动发货失败")
						echoString "因选择担保交易支付成功，但发货失败请联系管理员!","e"
						end if
			elseif request.QueryString("trade_status")="WAIT_BUYER_CONFIRM_GOODS" Then
					echoString "恭喜，因使用担保交易，卖家已发货，请确认收货后将自动入款","r"
				
 		else
				echoString "交易状态码不正确，本次交易失败","e"
			end if
		end If
	else
		echoString "身份效验失败，MD5不正确，无法继续交易！","e"
	end If
End If

function echoString(byval str,byval p)
	response.Redirect "/manager/config/echo.asp?str="& server.urlEncode(str)&"&p=" & p 'p=r/e
	response.write str
	response.end
end Function

''检验订单号''''''''''
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