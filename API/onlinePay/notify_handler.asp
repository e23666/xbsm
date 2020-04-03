<% Response.Buffer = true 
   response.charset="GB2312"
%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<meta name="TENCENT_ONELINE_PAYMENT" content="China TENCENT">
<html>
<%

conn.open constr
'取返回参数
cmdno			= Request("cmdno")  ' 财付通支付为"1" (当前只支持 cmdno=1)	
pay_result		= Request("pay_result")'支付结果
pay_info		= Request("pay_info")'支付结果信息,空为成功
bill_date		= Request("date")'商户日期
bargainor_id	= Request("bargainor_id") ' 商户号
transaction_id	= Request("transaction_id")'财富通交易号
sp_billno		= Request("sp_billno") '商户生成的订单号
total_fee		= Request("total_fee")  'total_fee,总金额'分为单位
fee_type		= Request("fee_type")'支付币种
attach			= Request("attach") '自定参数[ring_id,代理平台的订单号,代理平台的md5验证,代理处理页面]
md5_sign		= Request("sign")


'本地参数
spid	= tenpay_userid	' 这里替换为您的实际商户号
sp_key  = tenpay_userpass' sp_key是32位商户密钥, 请替换为您的实际密钥

'返回值定义
Private Const retOK = 0					' 成功					
Private Const invalidSpid = 1			' 商户号错误
Private Const invalidSign = 2			' 签名错误
Private Const tenpayErr	= 3				' 财付通返回支付失败
Private Const orderErr	= 4				' 财付通返回支付失败
Private Const getmd5err	= 5				' 代理md5错误
Private Const getArraerr= 6				' 代理md5错误
'验签函数
Function verifyMd5Sign

	origText = "cmdno=" & cmdno & "&pay_result=" & pay_result &_ 
		       "&date=" & bill_date & "&transaction_id=" & transaction_id &_
			   "&sp_billno=" & sp_billno & "&total_fee=" & total_fee &_
			   "&fee_type=" & fee_type & "&attach=" & attach &_
			   "&key=" & sp_key
	
	localSignText = ucase(ASP_MD5(origText))
	verifyMd5Sign = (localSignText = md5_sign)
	
End Function

	

'返回值
Dim retValue
retValue = retOK

'判断商户号
If bargainor_id <> spid Then
	retValue = invalidSpid
Else 
' 验签
	If verifyMd5Sign <> True Then
		retValue = invalidSign
	Else
' 检查财付通返回值
		attachArray=split(attach,"|")
		if ubound(attachArray)>=4 then
			ring_id=attachArray(0) '订单号
			agentRingnum=attachArray(1) '代理订单号
			agentMd5=attachArray(2) '
			agentBackurl=attachArray(3)
			agent_user=attachArray(4) '代理的用户
			PayAmount=FormatNumber((total_fee/100),2,-1,-1)
			'''''''''''''''''''''''
			GetAmount=getuserPrice(ring_id,u_name)
			u_api_pwd=getapipwd(u_name)
			'die agentBackurl & agentRingnum & agent_user & u_name & PayAmount & bill_date & sp_billno&u_api_pwd
			ToagentMid5str=asp_md5(agentBackurl & agentRingnum & agent_user & u_name & PayAmount & bill_date & sp_billno&u_api_pwd)
			if isRing(sp_billno,ring_id) then
				If pay_result <> 0 Then
					retValue = tenpayErr
				End If
			else
				retValue=orderErr
			end if
		else
			retValue=getArraerr
		end if
	End If
End If

'在这里处理业务逻辑 

		poststr="username="& agent_user & "&AddMoney="&PayAmount&"&GetAmount="&GetAmount&"&urlPage="&agentBackurl&"&c_order="&sp_billno&"&c_transnum="&transaction_id&"&c_ymd="&bill_date&"&ToagentRingnum="&agentRingnum&"&mid5str="&ToagentMid5str
'输出信息
Dim pay_msg
Select Case retValue
	Case retOK			
		total_fee=FormatNumber((total_fee/100),2,-1,-1) '化为元为单位
		if doinsql(u_name,ring_id,total_fee) then
			isagent=agentmoney(agentBackurl,poststr)
			if isagent then
				actionOK "恭喜！支付成功!请在您的管理中心查看"
			else
				pay_msg = "支付失败,您的交易号是:["&transaction_id&"],订单号是:["&sp_billno&"]"
			end if
		end if
	Case invalidSpid	pay_msg = "错误的商户号!"	
	Case invalidSign	pay_msg = "验证MD5签名失败!"
	case getmd5err 		pay_msg = "验证MD5字符串时失败!<br>"
	case getArraerr 	pay_msg ="验证参数失败"
	case orderErr 		
			isagent=agentmoney(agentBackurl,poststr)
			if isagent then
				actionOK "恭喜！支付成功!请在您的<font color=blue>管理中心</font>查看"
			else
				
				pay_msg = "支付失败,您的交易号是:["&transaction_id&"],订单号是:["&sp_billno&"]"
			end if
	
	Case Else	pay_msg = "支付失败!"
End Select
conn.close
actionerr pay_msg
function getuserPrice(orderNo,byref u_name)
	getuserPrice=0
	Set prRs=conn.Execute("select top 1 ring_pr,Ring_us from ring where ring_id=" & orderNo)
	if not prRs.eof then
		getuserPrice=prRs(0)
		u_name=prRs(1)
	end if
	prRs.close
	set prRs=nothing
end function
function doinsql(R_User,orderNo,c_orderamount)
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
	''''''''''''''''''财务记录'''''''''''''''''''''''''
	 set rstemp2=server.createobject("adodb.recordset")
	  rstemp2.open "CountList",conn,3,3
	  rstemp2.addnew  
	  rstemp2("u_id")=U_id
	  rstemp2("u_MoneySum")=AddMoney
	  rstemp2("u_in")=AddMoney
	  rstemp2("u_out")=0
	  rstemp2("u_CountID")="(OL)-" & orderNo
	  rstemp2("c_memo")="财富通支付"
	
	  rstemp2("c_check")=0
	
	  rstemp2("c_date")=Now
	  rstemp2("c_dateinput")=now
	  rstemp2("c_datecheck")=now
	  rstemp2("c_type")=10

	  rstemp2.update
	  rstemp2.close
	  set rstemp2=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''财务流水'''''''''''''''''''''''''
set rstemp=server.createobject("adodb.recordset")
		rstemp.open "ourmoney",conn,3,3
		rstemp.addnew
	
		rstemp("Name")=R_User
		rstemp("UserName")=R_User
		rstemp("PayMethod")="财富通支付"
		rstemp("Amount")=AddMoney
		rstemp("PayDate")=now()
		rstemp("Orders")=orderNo
		rstemp("Memo")="财富通支付"
	
		rstemp.update
		rstemp.close
		
'''''''''''''''''''入款''''''''''''''''''''''''''''''''	

	  Sql="Update UserDetail Set u_usemoney=u_usemoney+" & AddMoney &",u_remcount=u_remcount+" & AddMoney & " Where u_name='" & R_User & "'"
		conn.Execute(Sql)
''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'=============================
	'开始检查用户是否有未还借款，有且支付金额足够则自动还借款
	set BorrowMRS=server.CreateObject("adodb.recordset")
	BorrowMsql="SELECT dbo.countlist.u_moneysum, dbo.countlist.sysid FROM dbo.countlist INNER JOIN dbo.UserDetail ON dbo.countlist.u_id = dbo.UserDetail.u_id WHERE (dbo.UserDetail.u_name = '"&R_User&"') AND (dbo.countlist.c_check = 1) AND (dbo.countlist.c_memo = '借款') ORDER BY dbo.countlist.c_dateinput DESC"
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
				
				''插入支付欠款记录
				sql="INSERT INTO dbo.countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note) VALUES ("&edward_u_id&","&tempBorrowMoney&",0,"&tempBorrowMoney&",'"&DateRadom&"','支付欠款',0,'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0)"
				conn.execute(sql)
				
				conn.execute("update userdetail set u_usemoney=u_usemoney-" & tempBorrowMoney & ",u_checkmoney=u_checkmoney-" & tempBorrowMoney & " where u_id=" & edward_u_id)

				'将借款记录改为已审核
				sql="UPDATE dbo.countlist SET c_check =0 WHERE sysid="&SysId_array&""
				conn.execute(sql)
				
			end if
			Uidrs.close
		end if
	end if
	BorrowMRS.close
	'=============================
	doinsql=true
end function
function reSetOrder(orderstr)
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
''检验订单号''''''''''
function isRing(ordernum,ring_id)
	isRing=false
	if ordernum<>"" then
		sql="select top 1 Ring_us,Ring_id,ring_ov from ring where Ring_id="& trim(ring_id) &" and ring_ov=0 order by ring_dt desc"
		
		rs1.open sql,conn,1,3
		if not rs1.eof then
			'u_name=rs1("Ring_us")
			getorder=right(ordernum,len(ring_id))
			if ring_id=getorder then isRing=true
			rs1("ring_ov")=1
			rs1.update
		end if
		rs1.close
	end if
end function
'加入代理网站里用户的款
function agentmoney(sendurl,poststr)
	agentMoney=false
	set objxml=server.CreateObject("Msxml2.XMLHTTP")
	with objxml
			.open "POST",sendurl&"?str="&timer,false
			.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			.send(poststr)
	end with
	if objxml.status=200 then
		agentMoney=true
	end if
	set objxml=nothing
end function
function actionerr(errstr)
				Response.write "<script language=javascript>"
				Response.write "window.location.href='http://www.myhostadmin.net/manager/agentpay/tenpay/errs.asp?str=" & errstr &"';"
				Response.write "</script>"
				response.end
end function
function actionOK(okstr)
				Response.write "<script language=javascript>"
				Response.write "window.location.href='http://www.myhostadmin.net/manager/agentpay/tenpay/ok.asp?str=" & okstr &"';"
				Response.write "</script>"
				response.end
end function


function getapipwd(u)
	getapipwd="sdaflksadjfpojOJML:DF90j32hjrndsjf0923jrnopkdjf"
	sql="select a_password from APIuser_list inner join  UserDetail on APIuser_list.u_id=UserDetail.u_id where u_name='"&u&"'"
	set u_rs=conn.execute(sql)
	if not u_rs.eof then
		getapipwd=u_rs(0)
	end if
	u_rs.close:set u_r=nothing
end function
%>

