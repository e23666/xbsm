 <%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<% Response.Buffer = true %>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->

<!--#include file="alipay_payto.asp"-->
<!--#include file="shengpayclass.asp"-->
<%
conn.open constr
ext1	 =request("ext1")
select case trim(ext1)
case "shengpay"
shengpayact()
end select

sub shengpayact()
   set sp=new ShengPayClass
			Name=request.form("Name")
			MsgSender=request.form("MsgSender")
			Version=request.form("Version")
			Charset=request.form("Charset")
			ErrorMsg=request.form("ErrorMsg")
			SignType=request.form("SignType")
			SendTime=request.form("SendTime")
			InstCode=request.form("InstCode")	'银行名字
			MerchantNo=request.form("MerchantNo")
			TransType=request.form("TransType")
			ErrorCode=request.form("ErrorCode")
			Ext1=request.form("Ext1")
			Ext2=request.form("Ext2")
			SignMsg=request.form("SignMsg")
			
			TraceNo=request.form("TraceNo")			'请求序列号，报文发起方唯一标识
			OrderAmount=request.form("OrderAmount")	'支付金额
			TransAmount=request.form("TransAmount")	'实际支付金额
			TransNo=request.form("TransNo")			'盛付通交易号
			OrderNo=request.form("OrderNo")			'我司系统订单号
			TransStatus=request.form("TransStatus")	'支付状态：01为成功 00等待付款 02付款失败
			TransTime=request.form("TransTime")		'盛付通交易时间
			
			origin =Name & Version & Charset & TraceNo & MsgSender & SendTime & InstCode & OrderNo & OrderAmount &_
					TransNo & TransAmount & TransStatus & TransType & TransTime & MerchantNo & Ext1 & Ext2 & SignType&shengpay_Md5Key
			mySignMsg = sp.BuildSign(origin)
			v_oid=OrderNo
			
			
				if  mySignMsg=SignMsg  and TransStatus="01" then
		if isRing(v_oid,user_name,orderIDs) then
			if doinsql(user_name,orderIDs,TransAmount,"盛付通在线支付") then
            	die "TRADE_SUCCESS"
			end if
		else
             	die "TRADE_SUCCESS"
	    end if
	else
              	die "TRADE_FINISHED"
	end if




end sub 

''检验订单号''''''''''
function isRing(byval ordernum,byref u_name,byref myorderID)
	isRing=false
	
	if ordernum<>"" and isnumeric(ordernum) then
		myorderID= clng(ordernum) - 100000
		sql="select top 1 Ring_us,Ring_id,ring_ov,ring_dt from ring where Ring_id="& trim(myorderID) &" and ring_ov="&PE_False&" order by ring_dt desc"
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
%>