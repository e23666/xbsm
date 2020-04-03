<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<!--#include file="alipay_payto.asp"-->
<!--#include file="shengpayclass.asp"-->
<%
response.Charset="gb2312"

alertbox=""
httpstr="http://"
If ishttps Then httpstr="https://"
onlinepayEnd=httpstr& requesta("HTTP_HOST") & "/manager/onlinePay/onlinePayEnd.asp"
paytype=requesta("paytype")
showMoney=requesta("payMoney")
if checkRegExp(showMoney,"^\d+\.$") then url_return "请输入正确的支付款",-1
if not isnumeric(showMoney) then url_return "请输入正确的支付款",-1
showMoney=FormatNumber(showMoney,2,-1,-1)
conn.open constr

select case lcase(paytype)
	   case	"defaultpay"
	   		payName="系统默认支付接口"
			payImg="onlineImg/0.gif"" style=""display:none"
			payContent=""
			pay_fy=defaultpay_fy
			action=defaultpay_url
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=defaultpayaction()
			
	   case "tenpay"
	   		payName="财付通支付"
			payImg="onlineImg/tenpay.gif"
			payContent="财付通支付接口"
			pay_fy=tenpay_fy
			action="https://www.tenpay.com/cgi-bin/v1.0/pay_gate.cgi"
			payOrderID=GetOrder(showMoney,1,payName)

			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=tenpayaction()
	   case "yeepay"
	   		payName="易宝支付"
			payImg="onlineImg/yeepay.gif"
			payContent="易宝支付接口"
			pay_fy=yeepay_fy
			action="https://www.yeepay.com/app-merchant-proxy/node"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=yeepayaction()
	   case "alipay"
	   		payName="支付宝支付"
			payImg="onlineImg/alipay.gif"
			payContent="支付宝支付接口"
			pay_fy=alipay_fy
			'action="https://www.alipay.com/cooperate/gateway.do?"
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			payOrderID=GetOrder(showMoney,1,payName)
			subject    		=alipayName& "(" & payOrderID&")"
			out_trade_no	=payOrderID
			total_fee = ccur(payMoney)	'应付总金额
			token=session("token")&""
			if token="" then token=request.Cookies("token")&""
			tokenstr=""
			if trim(token)<>"" then tokenstr="|token="&token			

		    if alipay_type="SELLER_PAY" then	 
				logistics_fee="0.00"
				logistics_payment="SELLER_PAY"
				parastr="service=trade_create_by_buyer|logistics_type=EXPRESS|quantity=1|payment_type=1|partner="&partner&"|seller_email="&seller_email&"|return_url="&return_url&"|notify_url="&notify_url&"|_input_charset="&input_charset&"|show_url="&show_url&"|out_trade_no="&out_trade_no&"|subject="&subject&"|body="&subject&"|logistics_fee="&logistics_fee&"|logistics_payment="&logistics_payment&"|price="&total_fee&"|defaultbank="&defaultbank&"|anti_phishing_key="&anti_phishing_key&"|exter_invoke_ip="&exter_invoke_ip&"|extra_common_param="&extra_common_param&"|buyer_email="&buyer_email&"|royalty_type="&royalty_type&"|royalty_parameters="&royalty_parameters&tokenstr

				alertbox="<div style=""line-height:15px; padding:5px; border:1px rgba(255,166,0,1.00) dashed; background-color:#FF9;color:#cccccc;padding:5px;margin:5px;font-size:16px;font-weight: 700""><font color=red>友情提示:</font>如选择担保交易，请支付成功后，到支付宝后台点击收货确认这样才能正常完成充值</div>"
			elseif alipay_type="DBSELLER_PAY" then
				logistics_fee="0.00"
				logistics_payment="SELLER_PAY"
				parastr="service=create_partner_trade_by_buyer|logistics_type=EXPRESS|quantity=1|payment_type=1|partner="&partner&"|seller_email="&seller_email&"|return_url="&return_url&"|notify_url="&notify_url&"|_input_charset="&input_charset&"|show_url="&show_url&"|out_trade_no="&out_trade_no&"|subject="&subject&"|body="&subject&"|logistics_fee="&logistics_fee&"|logistics_payment="&logistics_payment&"|price="&total_fee&"|defaultbank="&defaultbank&"|anti_phishing_key="&anti_phishing_key&"|exter_invoke_ip="&exter_invoke_ip&"|extra_common_param="&extra_common_param&"|buyer_email="&buyer_email&"|royalty_type="&royalty_type&"|royalty_parameters="&royalty_parameters&tokenstr
				alertbox="<div style=""line-height:25px; padding:5px; border:1px rgba(255,166,0,1.00) dashed; background-color:#FF9;color:#333;padding:5px;margin:5px;font-size:16px;""><font color=red>友情提示:</font><BR>如选择担保交易，请支付成功后，到支付宝后台点击收货确认这样才能正常完成充值</div>"
		    else parastr="service=create_direct_pay_by_user|payment_type=1|partner="&partner&"|seller_email="&seller_email&"|return_url="&return_url&"|notify_url="&notify_url&"|_input_charset="&input_charset&"|show_url="&show_url&"|out_trade_no="&out_trade_no&"|subject="&subject&"|body="&body&"|total_fee="&total_fee&"|paymethod="&paymethod&"|defaultbank="&defaultbank&"|anti_phishing_key="&anti_phishing_key&"|exter_invoke_ip="&exter_invoke_ip&"|extra_common_param="&extra_common_param&"|buyer_email="&buyer_email&"|royalty_type="&royalty_type&"|royalty_parameters="&royalty_parameters&tokenstr
			end if
			para=split(parastr,"|")
			dim sPara , gateway , mysign
			Call alipay_service(para)
			postinput = build_form()
			action=	gateway &"_input_charset="&input_charset
           ' die action
			'action=alipayaction()
	   case "kuaiqian"
	   		payName="快钱支付"
			payImg="onlineImg/kuaiqian.gif"
			payContent="快钱支付接口"
			pay_fy=kuaiqian_fy
			action="https://www.99bill.com/webapp/receiveMerchantInfoAction.do"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=kuaiqianaction()
	   case "kuaiqian2"
	   		payName="快钱支付"
			payImg="onlineImg/kuaiqian.gif"
			payContent="快钱支付接口"
			pay_fy=kuaiqian2_fy
			action="https://www.99bill.com/gateway/recvMerchantInfoAction.htm"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=kuaiqian2action()
		case "cncard"
			payName="云网支付"
			payImg="onlineImg/cncard.gif"
			payContent="云网支付接口"
			pay_fy=cncard_fy
			action="https://www.cncard.net/purchase/getorder.asp"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=cncardaction()
		case "chinabank"
			payName="网银在线支付"
			payImg="onlineImg/chinabank.gif"
			payContent="网银在线支付接口"
			pay_fy=chinabank_fy
			action="https://pay3.chinabank.com.cn/PayGate?encoding=utf-8"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=chinabankaction()
		case "shengpay"
			payName="盛付通在线支付"
			payImg="onlineImg/shengpay.jpg"
			payContent="盛付通在线支付接口"
			pay_fy=shengpay_fy
			action="http://mas.sdo.com/web-acquire-channel/cashier.htm"
			'action="http://mer.mas.sdo.com/web-acquire-channel/cashier.htm"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=shengpayaction()
	   case else url_return "请选择支付网关",-1
end select

if (payMoney - payMoney * pay_fy)<=0 then url_return "支付金额应大于手续费",-1
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-确认支付</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
}
</script>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/customercenter/howpay.asp">确认支付</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


    
<form name="form1" action="<%=action%>" method="post" target="_blank">  


 
  <table class="manager-table">
	  <%If Trim(alertbox)<>"" then%>
	　<tr><th colspan=2><%=alertbox%></th></tr>
	  <%End if%>
      <%If Trim(payImg)<>"" then%>
  	  <tr>
      	<td colspan=2 align="center" ><img border=0 src="<%=payImg%>"></td>
      </tr>
	  <%End If
	  If Trim(payName)<>"" then
	  %>
      <tr>
        <th colspan=2><%=payName%></th>
      </tr>
	<%End if
	If Trim(payContent)<>"" then%>
      <tr>
      
        <td  colspan=2><%=payContent%></td>
      </tr>
	<%End if%>
      <tr>
          <th width="37%" align="right">用户名:</th>
          <td width="63%" align="left"><%=session("user_name")%></td>
      </tr>
      <tr>
          <th align="right">支付序号:</th>
          <td align="left"><%=payOrderID%></td>
      </tr>
      <tr>
          <th align="right">汇款金额:</th>
          <td align="left"><%=formatNumber(showMoney,2,-1,-1)%>￥</td>
      </tr>
      <tr>
          <th align="right">手续费:</th>
          <td align="left"><%=FormatNumber((showMoney * pay_fy),2,-1,-1)%>￥</td>
      </tr>
      <tr>
          <th align="right">最终金额:</th>
          <td align="left"><%=payMoney%>￥</td>
      </tr>
  
<tr>
  <td colspan=2>
  <input type="submit" value="立即支付" class="manager-btn s-btn">&nbsp;
  <input type="button" value="返回修改"  class="manager-btn s-btn" onclick="javascript:history.back();">
  <%=postinput%> 
  </td>
</tr>

</table>
</form>
<%
Function GetOrder(r_price,r_type,r_value)
	tmpOrderID=0
	TStamp=Now()
	newr_price=replace(r_price,",","")
	user_name=Session("user_name")
	if user_name="" then url_return "会话失效，请重新登录！",-1
	Sql="Insert into Ring (Ring_us,Ring_tp,Ring_ve,Ring_pr,Ring_dt,Ring_ov) values ('" & user_name &"'," & r_type & ",'" & r_value &"'," &newr_price& ",'"& tstamp &"',"&PE_False&")"
	conn.Execute(Sql)
	if isdbsql then
	Sql="Select top 1 Ring_id from Ring Where Ring_dt='" & TStamp &"' and Ring_us='" & user_name & "' order by ring_id desc"
	else
	Sql="Select top 1 Ring_id from Ring Where Ring_dt=#" & TStamp &"# and Ring_us='" & user_name & "' order by ring_id desc"
    end if
	Set OrderRs=conn.Execute(Sql)
	if not OrderRs.eof then
		tmpOrderID=OrderRs("Ring_id")
	else
		url_return "发生意外，请与管理员联系",-1
	end if
	OrderRs.close
	Set OrderRs=nothing
	if Clng(tmpOrderID)>9999999999999999 then 
		url_return "订单资源用完，请与管理员联系",-1
	end if
	GetOrder=100000 + tmpOrderID
end Function
function pad(strNumber)
  pad=strNumber
  if pad<10 then 
  	pad="0" & Cstr(pad)
  else
	pad=Cstr(pad)
  end if
end function

' 获取日期，格式YYYYMMDD
Function CFTGetServerDate 
		Dim strTmp, iYear,iMonth,iDate 
		iYear = Year(Date) 
		iMonth = Month(Date) 
		iDate = Day(Date) 

		strTmp = CStr(iYear)
		If iMonth < 10 Then 
			strTmp = strTmp & "0" & Cstr(iMonth)
		Else 
			strTmp = strTmp & Cstr(iMonth)
		End If 
		If iDate < 10 Then 
			strTmp = strTmp & "0" & Cstr(iDate) 
		Else 
			strTmp = strTmp & Cstr(iDate) 
		End If 
		CFTGetServerDate = strTmp 
End Function
function reSetOrder(byval orderstr)
	orderstr=trim(orderstr)
	if orderstr <>"" then
		if len(orderstr)>10 then
			reSetOrder=left(orderstr,10)
		else
			reSetOrder=right("0000000000" & orderstr,10)
		end if
	else
		url_return "订单号为空",-1
	end if
end function
function tenpayaction()
   '订单号
'''''''''''''''''请求参数''''''''''''''''''''''''''''''''''''''''''
	cmdno		= "1"				' 财付通支付为"1" (当前只支持 cmdno=1)	
	bill_date	= CFTGetServerDate	' 交易日期 (yyyymmdd)	
	bank_type	= "0"				' 银行类型:	0	财付通
	desc		= Session("user_name")	' 商品名称
	purchaser_id = ""				' 用户财付通帐号，如果没有可以置空
	bargainor_id = tenpay_userid				' 商户号
	sp_billno	 = payOrderID		' 商户生成的订单号(最多32位)	
	
	' 重要:
	' 交易单号(28位): 商户号(10位) + 日期(8位) + 流水号(10位), 必须按此格式生成, 且不能重复
	' 如果sp_billno超过10位, 则截取其中的流水号部分加到transaction_id后部(不足10位左补0)
	' 如果sp_billno不足10位, 则左补0, 加到transaction_id后部
	transaction_id = bargainor_id & bill_date & reSetOrder(sp_billno)
	total_fee	 = payMoney * 100		' 总金额, 分为单位
	fee_type	 = "1"				' 货币类型: 1 – RMB(人民币) 2 - USD(美元) 3 - HKD(港币)
	return_url	 = onlinepayEnd ' 财付通回调页面地址, (最长255个字符)
	attach		 = "tenpay" ' 商户私有数据, 请求回调页面时原样返回
	spbill_create_ip=trim(GetuserIp())
	' 生成MD5签名    

	sign_text = "cmdno=" & cmdno & "&date=" & bill_date & "&bargainor_id=" & bargainor_id &_
        		"&transaction_id=" & transaction_id & "&sp_billno=" & sp_billno &_
       			"&total_fee=" & total_fee & "&fee_type=" & fee_type & "&return_url=" & return_url &_
        		"&attach=" & attach & "&spbill_create_ip="& spbill_create_ip & "&key=" & tenpay_userpass
	md5_sign = UCase(ASP_MD5(sign_text))       ' 转换为大写 
			poststring="<input type=hidden name=""cmdno""		    value="""& cmdno &""">" & vbcrlf & _
            			"<input type=hidden name=""date""			value="""& bill_date &""">" & vbcrlf & _
            			"<input type=hidden name=""bank_type""	    value="""& bank_type &""">" & vbcrlf & _
            			"<input type=hidden name=""desc""			value="""& desc &""">" & vbcrlf & _
            			"<input type=hidden name=""purchaser_id""	value="""& purchaser_id &""">" & vbcrlf & _
            			"<input type=hidden name=""bargainor_id""	value="""& bargainor_id &""">" & vbcrlf & _
            			"<input type=hidden name=""transaction_id""	value="""& transaction_id &""">" & vbcrlf & _
            			"<input type=hidden name=""sp_billno""		value="""& sp_billno &""">" & vbcrlf & _
            			"<input type=hidden name=""total_fee""		value="""& total_fee &""">" & vbcrlf & _
            			"<input type=hidden name=""fee_type""		value="""& fee_type &""">" & vbcrlf & _
            			"<input type=hidden name=""return_url""		value="""& return_url &""">" & vbcrlf & _
            			"<input type=hidden name=""attach""			value="""& attach &""">" & vbcrlf & _
            			"<input type=hidden name=""sign""			value="""& md5_sign &""">" & vbcrlf & _
						"<input type=hidden name=""spbill_create_ip"" value="""& spbill_create_ip &""">"
	
	tenpayaction=poststring
end function
function yeepayaction()
	 Set mctSDK = Server.CreateObject("HmacMd5API.HmacMd5Com")
	p0_Cmd="Buy"
	p1_MerId=yeepay_userid
	p2_Order=payOrderID
	p3_Amt=payMoney
	p4_Cur= "CNY"
	p5_Pid="" '商品ID
	p6_Pcat=""'商品种类
	p7_Pdesc = "" '商品描述
	P8_Url=onlinePayEnd
	p9_SAF="0"	 
	pa_MP="yeepay"  
	    sbOld=""
        sbOld = sbOld + p0_Cmd
        '加入商家ID
        sbOld = sbOld + CStr(p1_MerId)
        '加入定单号ID
         sbOld = sbOld + Cstr(p2_Order)
        '加入金额
        sbOld = sbOld + CStr(p3_Amt)
        '加入货币单位
        sbOld = sbOld + p4_Cur
        '加入产品ID
        sbOld = sbOld + p5_Pid
        '加入产品分类
        sbOld = sbOld + p6_Pcat
        '加入产品描述
        sbOld = sbOld + p7_Pdesc
        '加入商家回报URL
        sbOld = sbOld + P8_Url
        '加入送货地址标识
        sbOld = sbOld + p9_SAF
        '加入商家属性
        sbOld = sbOld + pa_MP

        sNewString = null

        sNewString = mctSDK.HmacMd5(sbOld,yeepay_userpass)                
	poststring= "<input type=""hidden"" name=""p0_Cmd""  value=""" & p0_Cmd & """>" & vbcrlf & _
				"<input type=""hidden"" name=""p1_MerId""  value=""" & p1_MerId &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p2_Order""  value="""& p2_Order &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p3_Amt""  value="""& p3_Amt &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p4_Cur""  value="""& p4_Cur &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p5_Pid""    value="""& p5_Pid &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p6_Pcat""   value="""& p6_Pcat &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p7_Pdesc""  value="""& p7_Pdesc &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p8_Url""  value="""& onlinePayEnd &""">" & vbcrlf & _
				"<input type=""hidden"" name=""p9_SAF""  value="""& p9_SAF &""">" & vbcrlf & _
				"<input type=""hidden"" name=""pa_MP""  value="""& pa_MP &""">" & vbcrlf & _
				"<input type=""hidden"" name=""hmac""  value=""" & sNewString &""">"
	yeepayaction=poststring
	Set mctSDK = nothing
end function
function kuaiqianaction()
	 merchant_id = kuaiqian_userid		'''商户编号
	 merchant_key = kuaiqian_userpass		'''商户密钥
	 orderid = payOrderID		'''订单编号
	 amount = payMoney		'''订单金额
	 curr = "1"		'''货币类型,1为人民币
	 isSupportDES = "2"		'''是否安全校验,2为必校验,推荐
	
	 merchant_url = onlinepayEnd		'''支付结果返回地址
	 pname = session("user_name")		'''支付人姓名
	 commodity_info = ""		'''商品信息
	 merchant_param = "kuaiqian"		'''商户私有参数
	 pemail=""		'''传递email到快钱网关页面
	 pid=""		'''代理/合作伙伴商户编号
	
	'''生成加密串,注意顺序
	ScrtStr="merchant_id=" & merchant_id & "&orderid=" & orderid & "&amount=" & amount & "&merchant_url=" & merchant_url & "&merchant_key=" & merchant_key
	mac=ucase(asp_md5(ScrtStr))

		poststring=	"<input name=""merchant_id"" type=""hidden"" value=""" & merchant_id &""">" & vbcrlf & _
					"<input name=""orderid""  type=""hidden"" value="""& orderid &""">" & vbcrlf & _
					"<input name=""amount""  type=""hidden"" value="""& amount &""">" & vbcrlf & _
					"<input name=""currency""  type=""hidden"" value="""& curr &""">" & vbcrlf & _
					"<input name=""isSupportDES""  type=""hidden"" value="""& isSupportDES &""">" & vbcrlf & _
					"<input name=""mac""  type=""hidden"" value="""& mac &""">" & vbcrlf & _
					"<input name=""merchant_url""  type=""hidden""  value="""& merchant_url &""">" & vbcrlf & _
					"<input name=""pname""  type=""hidden"" value="""& pname &""">" & vbcrlf & _
					"<input name=""commodity_info""  type=""hidden""  value="""& commodity_info &""">" & vbcrlf & _
					"<input name=""merchant_param"" type=""hidden""  value="""& merchant_param &""">" & vbcrlf & _
					"<input name=""pemail"" type=""hidden""  value="""& pemail &""">" & vbcrlf & _
					"<input name=""pid"" type=""hidden""  value=""" & pid &""">"
		kuaiqianaction=poststring
end function
function kuaiqian2action()
	merchantAcctId  =kuaiqian2_userid '商户号
	key			    =kuaiqian2_userpass '商户密钥
	inputCharset    ="3"	'gb2312
	bgUrl		    =onlinepayEnd	'返回地址
	versions		="v2.0"'版本号
	language	    ="1"'语言 中文
	signType	    ="1"'选择md5加密
	payerName	    =session("user_name") '支付人姓名
	payerContactType="1"'联系方式 邮箱
	payerContact	=session("u_email")'联系邮箱地址
	orderId			=payOrderID'订单号
	orderAmount		=payMoney * 100 '以分为单位，必须是整型数字
	orderTime		=getDateStr()'提交时间,14位数字
	productName		=session("user_name")'商品名称
	productNum		="1"'商品数量
	productId		=""'商品代码
	productDesc		=""	'商品描述
	ext1			="kuaiqian2"'原样返回给客户
	ext2			=""
	payType			="00"'网页支付
	redoFlag		="1"'禁止重复提交
	pid				=kuaiqian2_pid'合作伙伴账号号
	'生成加密签名串
''请务必按照如下顺序和规则组成加密串！
	signMsgVal=appendParam(signMsgVal,"inputCharset",inputCharset)
	signMsgVal=appendParam(signMsgVal,"bgUrl",bgUrl)
	signMsgVal=appendParam(signMsgVal,"version",versions)
	signMsgVal=appendParam(signMsgVal,"language",language)
	signMsgVal=appendParam(signMsgVal,"signType",signType)
	signMsgVal=appendParam(signMsgVal,"merchantAcctId",merchantAcctId)
	signMsgVal=appendParam(signMsgVal,"payerName",payerName)
	signMsgVal=appendParam(signMsgVal,"payerContactType",payerContactType)
	signMsgVal=appendParam(signMsgVal,"payerContact",payerContact)
	signMsgVal=appendParam(signMsgVal,"orderId",orderId)
	signMsgVal=appendParam(signMsgVal,"orderAmount",orderAmount)
	signMsgVal=appendParam(signMsgVal,"orderTime",orderTime)
	signMsgVal=appendParam(signMsgVal,"productName",productName)
	signMsgVal=appendParam(signMsgVal,"productNum",productNum)
	signMsgVal=appendParam(signMsgVal,"productId",productId)
	signMsgVal=appendParam(signMsgVal,"productDesc",productDesc)
	signMsgVal=appendParam(signMsgVal,"ext1",ext1)
	signMsgVal=appendParam(signMsgVal,"ext2",ext2)
	signMsgVal=appendParam(signMsgVal,"payType",payType)
	signMsgVal=appendParam(signMsgVal,"redoFlag",redoFlag)
	signMsgVal=appendParam(signMsgVal,"pid",pid)
	signMsgVal=appendParam(signMsgVal,"key",key)
	signMsg= Ucase(asp_md5(signMsgVal))

			poststring ="<input type=""hidden"" name=""inputCharset"" value="""& inputCharset &""">" & vbcrlf& _
						"<input type=""hidden"" name=""bgUrl"" value="""& bgUrl &""">" & vbcrlf& _
						"<input type=""hidden"" name=""version"" value="""& versions &""">" & vbcrlf& _
						"<input type=""hidden"" name=""language"" value="""& language &""">" & vbcrlf& _
						"<input type=""hidden"" name=""signType"" value="""& signType &""">" & vbcrlf& _
						"<input type=""hidden"" name=""signMsg"" value="""& signMsg &""">" & vbcrlf& _
						"<input type=""hidden"" name=""merchantAcctId"" value="""& merchantAcctId &""">" & vbcrlf& _
						"<input type=""hidden"" name=""payerName"" value="""& payerName &""">" & vbcrlf& _
						"<input type=""hidden"" name=""payerContactType"" value="""& payerContactType &""">" & vbcrlf& _
						"<input type=""hidden"" name=""payerContact"" value="""& payerContact &""">" & vbcrlf& _
						"<input type=""hidden"" name=""orderId"" value="""& orderId &""">" & vbcrlf& _
						"<input type=""hidden"" name=""orderAmount"" value="""& orderAmount &""">" & vbcrlf& _
						"<input type=""hidden"" name=""orderTime"" value="""& orderTime &""">" & vbcrlf& _
						"<input type=""hidden"" name=""productName"" value="""& productName &""">" & vbcrlf& _
						"<input type=""hidden"" name=""productNum"" value="""& productNum &""">" & vbcrlf& _
						"<input type=""hidden"" name=""productId"" value="""& productId &""">" & vbcrlf& _
						"<input type=""hidden"" name=""productDesc"" value="""& productDesc &""">" & vbcrlf& _
						"<input type=""hidden"" name=""ext1"" value="""& ext1 &""">" & vbcrlf& _
						"<input type=""hidden"" name=""ext2"" value="""& ext2 &""">" & vbcrlf& _
						"<input type=""hidden"" name=""payType"" value="""& payType &""">" & vbcrlf& _
						"<input type=""hidden"" name=""redoFlag"" value="""& redoFlag &""">" & vbcrlf& _
						"<input type=""hidden"" name=""pid"" value="""& pid &""">"
						kuaiqian2action=poststring
end function
function alipayaction()
'    show_url        = companynameurl      '网站的网址
	seller_email    = alipay_account				'请设置成您自己的支付宝帐户
'	partner			= alipay_userid					'支付宝的账户的合作者身份ID
'	key			    = alipay_userpass	 '支付宝的安全校验码'
'	notify_url		= ""				 '付完款后服务器通知的页面 要用 http://格式的完整路径
'	return_url		= onlinepayEnd		 '付完款后跳转的页面 要用 http://格式的完整路径
	subject			=	"alipay"		 '商品名称
	body			=	""				 'body			商品描述
	out_trade_no    =   payOrderID       '订单
	price		    =	payMoney		 'price商品单价			0.01～50000.00
    quantity        =   "1"              '商品数量,如果走购物车默认为1
'	discount        =   "0"              '商品折扣
   	Set AlipayObj	= New creatAlipayItemURL
	itemUrl=AlipayObj.creatAlipayItemURL(subject,body,out_trade_no,price,quantity,seller_email)
	alipayaction=itemUrl
end function

function defaultpayaction()
	merchantCallbackURL = onlinepayEnd
	orderNo=payOrderID
	payMoney=formatnumber(payMoney,2,-1,-1)
	agentMid5str=trim(merchantCallbackURL & orderNo & session("user_name") & api_username & payMoney & api_password)

	sNewString = asp_Md5(agentMid5str) 

	poststring = 	"<input type=""hidden"" name=""agentPage""  value="""& merchantCallbackURL &""">"& vbcrlf & _
					"<input type=""hidden"" name=""agentRingnum""  value="""& OrderNo &""">" & vbcrlf & _
					"<input type=""hidden"" name=""users""  value="""& session("user_name") &""">" & vbcrlf & _
					"<input type=""hidden"" name=""ring_us""  value="""& api_username &""">" & vbcrlf & _
					"<input type=""hidden"" name=""dj""  value="""& payMoney &""">" & vbcrlf & _
					"<input type=""hidden"" name=""agentMid5""  value="""& sNewString &""">"
	defaultpayaction=poststring
end function

Function cncardaction()
	c_mid=cncard_cmid
	c_order=payOrderID
	c_orderamount=payMoney
	c_name=Session("user_name")
	c_ymd=GetDate_cncard()
	c_moneytype="0"
	c_retflag="1"
	c_returl=onlinepayEnd
	c_memo1="cncard"
'Response.write "<HR><b>" & c_mid & c_order &c_orderamount & c_ymd & c_moneytype & c_retflag & c_returl & c_memo1 & cncard_cpass  & "</b><HR>"
	c_signstr=ASP_md5(c_mid & c_order &c_orderamount & c_ymd & c_moneytype & c_retflag & c_returl & c_memo1 & cncard_cpass )

	poststring=				"<input type=""hidden"" name=""c_mid"" value=""" & c_mid & """> "
	poststring=poststring & "<input type=""hidden"" name=""c_order"" value=""" & c_order & """>"
	poststring=poststring & "<input type=""hidden"" name=""c_name"" value=""" & c_name & """> "
	poststring=poststring & "<input type=""hidden"" name=""c_orderamount"" value=""" & c_orderamount & """>"
	poststring=poststring & "<input type=""hidden"" name=""c_ymd"" value=""" & c_ymd & """> "
	poststring=poststring & "<input type=""hidden"" name=""c_moneytype"" value=""" & c_moneytype & """> "
	poststring=poststring & "<input type=""hidden"" name=""c_retflag"" value=""" & c_retflag & """>"
	poststring=poststring & "<input type=""hidden"" name=""c_returl"" value=""" & c_returl & """>"
	poststring=poststring & "<input type=""hidden"" name=""c_memo1"" value=""" & c_memo1 & """>"
	poststring=poststring & "<input type=""hidden"" name=""c_signstr"" value=""" & c_signstr & """>"	

	cncardaction=poststring
end Function
function chinabankaction()
	v_mid=chinabank_cmid
	v_key=chinabank_cpass
	v_oid=payOrderID
	v_amount=payMoney
	v_rcvname=Session("user_name")
	v_moneytype="CNY"
	v_url=onlinepayEnd
	remark1="chinabank"
	v_md5info=Ucase(trim(ASP_md5(v_amount & v_moneytype & v_oid & v_mid & v_url & v_key)))
  poststring= "<input type=""hidden"" name=""v_md5info""    value="""& v_md5info &""">" & vbcrlf & _
			  "<input type=""hidden"" name=""v_mid""        value="""& v_mid & """>" & vbcrlf & _
			  "<input type=""hidden"" name=""v_oid""        value="""& v_oid &""">" & vbcrlf & _
			  "<input type=""hidden"" name=""v_amount""     value="""& v_amount &""">" & vbcrlf & _
			  "<input type=""hidden"" name=""v_moneytype""  value="""& v_moneytype &""">" & vbcrlf & _
			  "<input type=""hidden"" name=""v_url""        value="""& v_url &""">" & vbcrlf & _
			  "<input type=""hidden""  name=""remark1"" value="""& remark1 &""">" & vbcrlf & _
			  "<input type=""hidden""  name=""v_rcvname"" value="""& v_rcvname &""">"
	chinabankaction=poststring
end function

'盛付通支付
function shengpayaction()
	'户意指我司
	   set sp=new ShengPayClass
		Name_s	= "B2CPayment"				'版本名称
		Version_s     ="V4.1.1.1.1"
		MsgSender	= shengpay_MerId			'发送方标识(商户号)
		Charset_s="GB2312"
		OrderAmount	= FormatNumber(payMoney,2,-1,0,0)	'订单金额，转换为两位小数的
		OrderNo		= payOrderID	'商户的订单号，在商户系统中唯一，不唯一的会提示已经支付成功过
		OrderTime	= sp.NumTime(Now())		'创建订单时间
		PageUrl		= onlinepayEnd		'浏览器回显
		NotifyUrl	= "http://"& requesta("HTTP_HOST") & "/manager/onlinePay/ShengPayPayEnd.asp"	'后台回调通知成功的地址
		BuyerIp		= getUserip()			'@买家IP地址
		ProductName = "在线充值预付款"		'@商品名称
		SignType="MD5"
		'PayType	= "PT001"				'@支付类型编码,PT001表示网银支付
		'SendTime	= ""					'@发送支付请求时间
		'InstCode	= ""					'@网银编码列表
		'BuyerContact=""					'@支付人联系方式
		Ext1		= "shengpay"	'@自定义参数
		Ext2		= session("user_name")	'@自定义参数
		Origin = Name_s & Version_s & Charset_s & MsgSender & SendTime & OrderNo &_ 
		OrderAmount & OrderTime & PayType_s&  InstCode & PageUrl & NotifyUrl & ProductName &_
		BuyerContact & BuyerIp & Ext1 &Ext2& SignType&shengpay_Md5Key
		' die Origin
		SignMsg = sp.BuildSign(Origin)
 shengpayaction="<input name=""Name"" type=""hidden"" value="""&Name_s&""">"&_
				"<input name=""Version"" type=""hidden"" value="""&Version_s&""">"&_
				"<input name=""Charset"" type=""hidden"" value="""&Charset_s&""">"&_
				"<input name=""MsgSender"" type=""hidden"" value="""&MsgSender&""">"&_
				"<input name=""OrderNo"" type=""hidden"" value="""&OrderNo&""">"&_
				"<input name=""OrderAmount"" type=""hidden"" value="""&OrderAmount&""">"&_
				"<input name=""OrderTime"" type=""hidden"" value="""&OrderTime&""">"&_
				"<input name=""PageUrl"" type=""hidden"" value="""&PageUrl&""">"&_
				"<input name=""NotifyUrl"" type=""hidden"" value="""&NotifyUrl&""">"&_
				"<input name=""ProductName"" type=""hidden"" value="""&ProductName&""">"&_
				"<input name=""BuyerContact"" type=""hidden"" value="""">"&_
				"<input name=""BuyerIp"" type=""hidden"" value="""&BuyerIp&""">"&_
				"<input name=""Ext1"" type=""hidden"" value="""&Ext1&""">"&_
				"<input name=""Ext2"" type=""hidden"" value="""&Ext2&""">"&_
				"<input name=""SignType"" type=""hidden"" value="""&SignType&""">"&_
				"<input name=""SignMsg"" type=""hidden"" value="""&SignMsg&""">"

end function

Function GetDate_cncard()
	GetDate_cncard=Cstr(year(now()))
	mday=month(now())
	if mday<10 then
		GetDate_cncard=GetDate_cncard & "0" & mday
	else
		GetDate_cncard=GetDate_cncard & mday
	end if
	dday=day(now())
	if dday<10 then
		GetDate_cncard=GetDate_cncard & "0" & dday		
	else
		GetDate_cncard=GetDate_cncard & dday	
	end if
end Function

Function getDateStr() 
	dim dateStr1,dateStr2,strTemp 
	dateStr1=split(cstr(formatdatetime(now(),2)),"-") 
	dateStr2=split(cstr(formatdatetime(now(),3)),":") 

	for each StrTemp in dateStr1 
	if len(StrTemp)<2 then 
	getDateStr=getDateStr & "0" & strTemp 
	else 
	getDateStr=getDateStr & strTemp 
	end if 
	next 

	for each StrTemp in dateStr2 
	if len(StrTemp)<2 then 
	getDateStr=getDateStr & "0" & strTemp 
	else 
	getDateStr=getDateStr & strTemp 
	end if
	next
End function
	'功能函数。将变量值不为空的参数组成字符串
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
%>
          











		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>

　