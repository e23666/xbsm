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
if checkRegExp(showMoney,"^\d+\.$") then url_return "��������ȷ��֧����",-1
if not isnumeric(showMoney) then url_return "��������ȷ��֧����",-1
showMoney=FormatNumber(showMoney,2,-1,-1)
conn.open constr

select case lcase(paytype)
	   case	"defaultpay"
	   		payName="ϵͳĬ��֧���ӿ�"
			payImg="onlineImg/0.gif"" style=""display:none"
			payContent=""
			pay_fy=defaultpay_fy
			action=defaultpay_url
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=defaultpayaction()
			
	   case "tenpay"
	   		payName="�Ƹ�֧ͨ��"
			payImg="onlineImg/tenpay.gif"
			payContent="�Ƹ�֧ͨ���ӿ�"
			pay_fy=tenpay_fy
			action="https://www.tenpay.com/cgi-bin/v1.0/pay_gate.cgi"
			payOrderID=GetOrder(showMoney,1,payName)

			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=tenpayaction()
	   case "yeepay"
	   		payName="�ױ�֧��"
			payImg="onlineImg/yeepay.gif"
			payContent="�ױ�֧���ӿ�"
			pay_fy=yeepay_fy
			action="https://www.yeepay.com/app-merchant-proxy/node"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=yeepayaction()
	   case "alipay"
	   		payName="֧����֧��"
			payImg="onlineImg/alipay.gif"
			payContent="֧����֧���ӿ�"
			pay_fy=alipay_fy
			'action="https://www.alipay.com/cooperate/gateway.do?"
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			payOrderID=GetOrder(showMoney,1,payName)
			subject    		=alipayName& "(" & payOrderID&")"
			out_trade_no	=payOrderID
			total_fee = ccur(payMoney)	'Ӧ���ܽ��
			token=session("token")&""
			if token="" then token=request.Cookies("token")&""
			tokenstr=""
			if trim(token)<>"" then tokenstr="|token="&token			

		    if alipay_type="SELLER_PAY" then	 
				logistics_fee="0.00"
				logistics_payment="SELLER_PAY"
				parastr="service=trade_create_by_buyer|logistics_type=EXPRESS|quantity=1|payment_type=1|partner="&partner&"|seller_email="&seller_email&"|return_url="&return_url&"|notify_url="&notify_url&"|_input_charset="&input_charset&"|show_url="&show_url&"|out_trade_no="&out_trade_no&"|subject="&subject&"|body="&subject&"|logistics_fee="&logistics_fee&"|logistics_payment="&logistics_payment&"|price="&total_fee&"|defaultbank="&defaultbank&"|anti_phishing_key="&anti_phishing_key&"|exter_invoke_ip="&exter_invoke_ip&"|extra_common_param="&extra_common_param&"|buyer_email="&buyer_email&"|royalty_type="&royalty_type&"|royalty_parameters="&royalty_parameters&tokenstr

				alertbox="<div style=""line-height:15px; padding:5px; border:1px rgba(255,166,0,1.00) dashed; background-color:#FF9;color:#cccccc;padding:5px;margin:5px;font-size:16px;font-weight: 700""><font color=red>������ʾ:</font>��ѡ�񵣱����ף���֧���ɹ��󣬵�֧������̨����ջ�ȷ����������������ɳ�ֵ</div>"
			elseif alipay_type="DBSELLER_PAY" then
				logistics_fee="0.00"
				logistics_payment="SELLER_PAY"
				parastr="service=create_partner_trade_by_buyer|logistics_type=EXPRESS|quantity=1|payment_type=1|partner="&partner&"|seller_email="&seller_email&"|return_url="&return_url&"|notify_url="&notify_url&"|_input_charset="&input_charset&"|show_url="&show_url&"|out_trade_no="&out_trade_no&"|subject="&subject&"|body="&subject&"|logistics_fee="&logistics_fee&"|logistics_payment="&logistics_payment&"|price="&total_fee&"|defaultbank="&defaultbank&"|anti_phishing_key="&anti_phishing_key&"|exter_invoke_ip="&exter_invoke_ip&"|extra_common_param="&extra_common_param&"|buyer_email="&buyer_email&"|royalty_type="&royalty_type&"|royalty_parameters="&royalty_parameters&tokenstr
				alertbox="<div style=""line-height:25px; padding:5px; border:1px rgba(255,166,0,1.00) dashed; background-color:#FF9;color:#333;padding:5px;margin:5px;font-size:16px;""><font color=red>������ʾ:</font><BR>��ѡ�񵣱����ף���֧���ɹ��󣬵�֧������̨����ջ�ȷ����������������ɳ�ֵ</div>"
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
	   		payName="��Ǯ֧��"
			payImg="onlineImg/kuaiqian.gif"
			payContent="��Ǯ֧���ӿ�"
			pay_fy=kuaiqian_fy
			action="https://www.99bill.com/webapp/receiveMerchantInfoAction.do"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=kuaiqianaction()
	   case "kuaiqian2"
	   		payName="��Ǯ֧��"
			payImg="onlineImg/kuaiqian.gif"
			payContent="��Ǯ֧���ӿ�"
			pay_fy=kuaiqian2_fy
			action="https://www.99bill.com/gateway/recvMerchantInfoAction.htm"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=round(showMoney+showMoney*pay_fy,2)
			payMoney=formatnumber(payMoney,2,-1,-1,0)
			postinput=kuaiqian2action()
		case "cncard"
			payName="����֧��"
			payImg="onlineImg/cncard.gif"
			payContent="����֧���ӿ�"
			pay_fy=cncard_fy
			action="https://www.cncard.net/purchase/getorder.asp"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=cncardaction()
		case "chinabank"
			payName="��������֧��"
			payImg="onlineImg/chinabank.gif"
			payContent="��������֧���ӿ�"
			pay_fy=chinabank_fy
			action="https://pay3.chinabank.com.cn/PayGate?encoding=utf-8"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=chinabankaction()
		case "shengpay"
			payName="ʢ��ͨ����֧��"
			payImg="onlineImg/shengpay.jpg"
			payContent="ʢ��ͨ����֧���ӿ�"
			pay_fy=shengpay_fy
			action="http://mas.sdo.com/web-acquire-channel/cashier.htm"
			'action="http://mer.mas.sdo.com/web-acquire-channel/cashier.htm"
			payOrderID=GetOrder(showMoney,1,payName)
			payMoney=FormatNumber(round(showMoney+showMoney*pay_fy,2),2,-1,-1,0)
			postinput=shengpayaction()
	   case else url_return "��ѡ��֧������",-1
end select

if (payMoney - payMoney * pay_fy)<=0 then url_return "֧�����Ӧ����������",-1
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-ȷ��֧��</title>
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/customercenter/howpay.asp">ȷ��֧��</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


    
<form name="form1" action="<%=action%>" method="post" target="_blank">  


 
  <table class="manager-table">
	  <%If Trim(alertbox)<>"" then%>
	��<tr><th colspan=2><%=alertbox%></th></tr>
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
          <th width="37%" align="right">�û���:</th>
          <td width="63%" align="left"><%=session("user_name")%></td>
      </tr>
      <tr>
          <th align="right">֧�����:</th>
          <td align="left"><%=payOrderID%></td>
      </tr>
      <tr>
          <th align="right">�����:</th>
          <td align="left"><%=formatNumber(showMoney,2,-1,-1)%>��</td>
      </tr>
      <tr>
          <th align="right">������:</th>
          <td align="left"><%=FormatNumber((showMoney * pay_fy),2,-1,-1)%>��</td>
      </tr>
      <tr>
          <th align="right">���ս��:</th>
          <td align="left"><%=payMoney%>��</td>
      </tr>
  
<tr>
  <td colspan=2>
  <input type="submit" value="����֧��" class="manager-btn s-btn">&nbsp;
  <input type="button" value="�����޸�"  class="manager-btn s-btn" onclick="javascript:history.back();">
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
	if user_name="" then url_return "�ỰʧЧ�������µ�¼��",-1
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
		url_return "�������⣬�������Ա��ϵ",-1
	end if
	OrderRs.close
	Set OrderRs=nothing
	if Clng(tmpOrderID)>9999999999999999 then 
		url_return "������Դ���꣬�������Ա��ϵ",-1
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

' ��ȡ���ڣ���ʽYYYYMMDD
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
		url_return "������Ϊ��",-1
	end if
end function
function tenpayaction()
   '������
'''''''''''''''''�������''''''''''''''''''''''''''''''''''''''''''
	cmdno		= "1"				' �Ƹ�֧ͨ��Ϊ"1" (��ǰֻ֧�� cmdno=1)	
	bill_date	= CFTGetServerDate	' �������� (yyyymmdd)	
	bank_type	= "0"				' ��������:	0	�Ƹ�ͨ
	desc		= Session("user_name")	' ��Ʒ����
	purchaser_id = ""				' �û��Ƹ�ͨ�ʺţ����û�п����ÿ�
	bargainor_id = tenpay_userid				' �̻���
	sp_billno	 = payOrderID		' �̻����ɵĶ�����(���32λ)	
	
	' ��Ҫ:
	' ���׵���(28λ): �̻���(10λ) + ����(8λ) + ��ˮ��(10λ), ���밴�˸�ʽ����, �Ҳ����ظ�
	' ���sp_billno����10λ, ���ȡ���е���ˮ�Ų��ּӵ�transaction_id��(����10λ��0)
	' ���sp_billno����10λ, ����0, �ӵ�transaction_id��
	transaction_id = bargainor_id & bill_date & reSetOrder(sp_billno)
	total_fee	 = payMoney * 100		' �ܽ��, ��Ϊ��λ
	fee_type	 = "1"				' ��������: 1 �C RMB(�����) 2 - USD(��Ԫ) 3 - HKD(�۱�)
	return_url	 = onlinepayEnd ' �Ƹ�ͨ�ص�ҳ���ַ, (�255���ַ�)
	attach		 = "tenpay" ' �̻�˽������, ����ص�ҳ��ʱԭ������
	spbill_create_ip=trim(GetuserIp())
	' ����MD5ǩ��    

	sign_text = "cmdno=" & cmdno & "&date=" & bill_date & "&bargainor_id=" & bargainor_id &_
        		"&transaction_id=" & transaction_id & "&sp_billno=" & sp_billno &_
       			"&total_fee=" & total_fee & "&fee_type=" & fee_type & "&return_url=" & return_url &_
        		"&attach=" & attach & "&spbill_create_ip="& spbill_create_ip & "&key=" & tenpay_userpass
	md5_sign = UCase(ASP_MD5(sign_text))       ' ת��Ϊ��д 
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
	p5_Pid="" '��ƷID
	p6_Pcat=""'��Ʒ����
	p7_Pdesc = "" '��Ʒ����
	P8_Url=onlinePayEnd
	p9_SAF="0"	 
	pa_MP="yeepay"  
	    sbOld=""
        sbOld = sbOld + p0_Cmd
        '�����̼�ID
        sbOld = sbOld + CStr(p1_MerId)
        '���붨����ID
         sbOld = sbOld + Cstr(p2_Order)
        '������
        sbOld = sbOld + CStr(p3_Amt)
        '������ҵ�λ
        sbOld = sbOld + p4_Cur
        '�����ƷID
        sbOld = sbOld + p5_Pid
        '�����Ʒ����
        sbOld = sbOld + p6_Pcat
        '�����Ʒ����
        sbOld = sbOld + p7_Pdesc
        '�����̼һر�URL
        sbOld = sbOld + P8_Url
        '�����ͻ���ַ��ʶ
        sbOld = sbOld + p9_SAF
        '�����̼�����
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
	 merchant_id = kuaiqian_userid		'''�̻����
	 merchant_key = kuaiqian_userpass		'''�̻���Կ
	 orderid = payOrderID		'''�������
	 amount = payMoney		'''�������
	 curr = "1"		'''��������,1Ϊ�����
	 isSupportDES = "2"		'''�Ƿ�ȫУ��,2Ϊ��У��,�Ƽ�
	
	 merchant_url = onlinepayEnd		'''֧��������ص�ַ
	 pname = session("user_name")		'''֧��������
	 commodity_info = ""		'''��Ʒ��Ϣ
	 merchant_param = "kuaiqian"		'''�̻�˽�в���
	 pemail=""		'''����email����Ǯ����ҳ��
	 pid=""		'''����/��������̻����
	
	'''���ɼ��ܴ�,ע��˳��
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
	merchantAcctId  =kuaiqian2_userid '�̻���
	key			    =kuaiqian2_userpass '�̻���Կ
	inputCharset    ="3"	'gb2312
	bgUrl		    =onlinepayEnd	'���ص�ַ
	versions		="v2.0"'�汾��
	language	    ="1"'���� ����
	signType	    ="1"'ѡ��md5����
	payerName	    =session("user_name") '֧��������
	payerContactType="1"'��ϵ��ʽ ����
	payerContact	=session("u_email")'��ϵ�����ַ
	orderId			=payOrderID'������
	orderAmount		=payMoney * 100 '�Է�Ϊ��λ����������������
	orderTime		=getDateStr()'�ύʱ��,14λ����
	productName		=session("user_name")'��Ʒ����
	productNum		="1"'��Ʒ����
	productId		=""'��Ʒ����
	productDesc		=""	'��Ʒ����
	ext1			="kuaiqian2"'ԭ�����ظ��ͻ�
	ext2			=""
	payType			="00"'��ҳ֧��
	redoFlag		="1"'��ֹ�ظ��ύ
	pid				=kuaiqian2_pid'��������˺ź�
	'���ɼ���ǩ����
''����ذ�������˳��͹�����ɼ��ܴ���
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
'    show_url        = companynameurl      '��վ����ַ
	seller_email    = alipay_account				'�����ó����Լ���֧�����ʻ�
'	partner			= alipay_userid					'֧�������˻��ĺ��������ID
'	key			    = alipay_userpass	 '֧�����İ�ȫУ����'
'	notify_url		= ""				 '�����������֪ͨ��ҳ�� Ҫ�� http://��ʽ������·��
'	return_url		= onlinepayEnd		 '��������ת��ҳ�� Ҫ�� http://��ʽ������·��
	subject			=	"alipay"		 '��Ʒ����
	body			=	""				 'body			��Ʒ����
	out_trade_no    =   payOrderID       '����
	price		    =	payMoney		 'price��Ʒ����			0.01��50000.00
    quantity        =   "1"              '��Ʒ����,����߹��ﳵĬ��Ϊ1
'	discount        =   "0"              '��Ʒ�ۿ�
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

'ʢ��֧ͨ��
function shengpayaction()
	'����ָ��˾
	   set sp=new ShengPayClass
		Name_s	= "B2CPayment"				'�汾����
		Version_s     ="V4.1.1.1.1"
		MsgSender	= shengpay_MerId			'���ͷ���ʶ(�̻���)
		Charset_s="GB2312"
		OrderAmount	= FormatNumber(payMoney,2,-1,0,0)	'������ת��Ϊ��λС����
		OrderNo		= payOrderID	'�̻��Ķ����ţ����̻�ϵͳ��Ψһ����Ψһ�Ļ���ʾ�Ѿ�֧���ɹ���
		OrderTime	= sp.NumTime(Now())		'��������ʱ��
		PageUrl		= onlinepayEnd		'���������
		NotifyUrl	= "http://"& requesta("HTTP_HOST") & "/manager/onlinePay/ShengPayPayEnd.asp"	'��̨�ص�֪ͨ�ɹ��ĵ�ַ
		BuyerIp		= getUserip()			'@���IP��ַ
		ProductName = "���߳�ֵԤ����"		'@��Ʒ����
		SignType="MD5"
		'PayType	= "PT001"				'@֧�����ͱ���,PT001��ʾ����֧��
		'SendTime	= ""					'@����֧������ʱ��
		'InstCode	= ""					'@���������б�
		'BuyerContact=""					'@֧������ϵ��ʽ
		Ext1		= "shengpay"	'@�Զ������
		Ext2		= session("user_name")	'@�Զ������
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
	'���ܺ�����������ֵ��Ϊ�յĲ�������ַ���
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

��