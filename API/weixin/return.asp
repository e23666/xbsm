 <%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/weixin_pay.asp" -->
<!--#include virtual="/config/class/aspframework.asp"-->
<%

conn.open constr
set wx=new weixin_pay 
if wx.GetNotify() then
    out_trade_no = wx.okobj("out_trade_no")
    total_fee = wx.okobj("total_fee") 
 
    if isRing(out_trade_no,u_name,orderIDs) Then 
		
        if doinsql(u_name,orderIDs,total_fee,"微信在线支付") then
            response.write "<xml><return_code>SUCCESS</return_code><return_msg>OK</return_msg></xml>"
        else
            response.write "<xml><return_code>SUCCESS</return_code><return_msg>OK</return_msg><info>OrderError:" & out_trade_no & "</info></xml>"
        end if
    else
     die "no order"
    end if
else
    response.write "err"
end If
''检验订单号''''''''''
function isRing(byval ordernum,byref u_name,byref myorderID)
	isRing=False 
	if  isnumeric(ordernum&"") Then
	
		myorderID= clng(ordernum) - 100000 
		sql="select Ring_us,Ring_id,ring_ov,ring_dt from ring where Ring_id="& trim(myorderID)  &" and ring_ov="&PE_False&" " 
		 
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
end Function
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
	end If
	
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
%>