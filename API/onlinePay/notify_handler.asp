<% Response.Buffer = true 
   response.charset="GB2312"
%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<meta name="TENCENT_ONELINE_PAYMENT" content="China TENCENT">
<html>
<%

conn.open constr
'ȡ���ز���
cmdno			= Request("cmdno")  ' �Ƹ�֧ͨ��Ϊ"1" (��ǰֻ֧�� cmdno=1)	
pay_result		= Request("pay_result")'֧�����
pay_info		= Request("pay_info")'֧�������Ϣ,��Ϊ�ɹ�
bill_date		= Request("date")'�̻�����
bargainor_id	= Request("bargainor_id") ' �̻���
transaction_id	= Request("transaction_id")'�Ƹ�ͨ���׺�
sp_billno		= Request("sp_billno") '�̻����ɵĶ�����
total_fee		= Request("total_fee")  'total_fee,�ܽ��'��Ϊ��λ
fee_type		= Request("fee_type")'֧������
attach			= Request("attach") '�Զ�����[ring_id,����ƽ̨�Ķ�����,����ƽ̨��md5��֤,������ҳ��]
md5_sign		= Request("sign")


'���ز���
spid	= tenpay_userid	' �����滻Ϊ����ʵ���̻���
sp_key  = tenpay_userpass' sp_key��32λ�̻���Կ, ���滻Ϊ����ʵ����Կ

'����ֵ����
Private Const retOK = 0					' �ɹ�					
Private Const invalidSpid = 1			' �̻��Ŵ���
Private Const invalidSign = 2			' ǩ������
Private Const tenpayErr	= 3				' �Ƹ�ͨ����֧��ʧ��
Private Const orderErr	= 4				' �Ƹ�ͨ����֧��ʧ��
Private Const getmd5err	= 5				' ����md5����
Private Const getArraerr= 6				' ����md5����
'��ǩ����
Function verifyMd5Sign

	origText = "cmdno=" & cmdno & "&pay_result=" & pay_result &_ 
		       "&date=" & bill_date & "&transaction_id=" & transaction_id &_
			   "&sp_billno=" & sp_billno & "&total_fee=" & total_fee &_
			   "&fee_type=" & fee_type & "&attach=" & attach &_
			   "&key=" & sp_key
	
	localSignText = ucase(ASP_MD5(origText))
	verifyMd5Sign = (localSignText = md5_sign)
	
End Function

	

'����ֵ
Dim retValue
retValue = retOK

'�ж��̻���
If bargainor_id <> spid Then
	retValue = invalidSpid
Else 
' ��ǩ
	If verifyMd5Sign <> True Then
		retValue = invalidSign
	Else
' ���Ƹ�ͨ����ֵ
		attachArray=split(attach,"|")
		if ubound(attachArray)>=4 then
			ring_id=attachArray(0) '������
			agentRingnum=attachArray(1) '��������
			agentMd5=attachArray(2) '
			agentBackurl=attachArray(3)
			agent_user=attachArray(4) '������û�
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

'�����ﴦ��ҵ���߼� 

		poststr="username="& agent_user & "&AddMoney="&PayAmount&"&GetAmount="&GetAmount&"&urlPage="&agentBackurl&"&c_order="&sp_billno&"&c_transnum="&transaction_id&"&c_ymd="&bill_date&"&ToagentRingnum="&agentRingnum&"&mid5str="&ToagentMid5str
'�����Ϣ
Dim pay_msg
Select Case retValue
	Case retOK			
		total_fee=FormatNumber((total_fee/100),2,-1,-1) '��ΪԪΪ��λ
		if doinsql(u_name,ring_id,total_fee) then
			isagent=agentmoney(agentBackurl,poststr)
			if isagent then
				actionOK "��ϲ��֧���ɹ�!�������Ĺ������Ĳ鿴"
			else
				pay_msg = "֧��ʧ��,���Ľ��׺���:["&transaction_id&"],��������:["&sp_billno&"]"
			end if
		end if
	Case invalidSpid	pay_msg = "������̻���!"	
	Case invalidSign	pay_msg = "��֤MD5ǩ��ʧ��!"
	case getmd5err 		pay_msg = "��֤MD5�ַ���ʱʧ��!<br>"
	case getArraerr 	pay_msg ="��֤����ʧ��"
	case orderErr 		
			isagent=agentmoney(agentBackurl,poststr)
			if isagent then
				actionOK "��ϲ��֧���ɹ�!��������<font color=blue>��������</font>�鿴"
			else
				
				pay_msg = "֧��ʧ��,���Ľ��׺���:["&transaction_id&"],��������:["&sp_billno&"]"
			end if
	
	Case Else	pay_msg = "֧��ʧ��!"
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
	''''''''''''''''''�����¼'''''''''''''''''''''''''
	 set rstemp2=server.createobject("adodb.recordset")
	  rstemp2.open "CountList",conn,3,3
	  rstemp2.addnew  
	  rstemp2("u_id")=U_id
	  rstemp2("u_MoneySum")=AddMoney
	  rstemp2("u_in")=AddMoney
	  rstemp2("u_out")=0
	  rstemp2("u_CountID")="(OL)-" & orderNo
	  rstemp2("c_memo")="�Ƹ�֧ͨ��"
	
	  rstemp2("c_check")=0
	
	  rstemp2("c_date")=Now
	  rstemp2("c_dateinput")=now
	  rstemp2("c_datecheck")=now
	  rstemp2("c_type")=10

	  rstemp2.update
	  rstemp2.close
	  set rstemp2=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''������ˮ'''''''''''''''''''''''''
set rstemp=server.createobject("adodb.recordset")
		rstemp.open "ourmoney",conn,3,3
		rstemp.addnew
	
		rstemp("Name")=R_User
		rstemp("UserName")=R_User
		rstemp("PayMethod")="�Ƹ�֧ͨ��"
		rstemp("Amount")=AddMoney
		rstemp("PayDate")=now()
		rstemp("Orders")=orderNo
		rstemp("Memo")="�Ƹ�֧ͨ��"
	
		rstemp.update
		rstemp.close
		
'''''''''''''''''''���''''''''''''''''''''''''''''''''	

	  Sql="Update UserDetail Set u_usemoney=u_usemoney+" & AddMoney &",u_remcount=u_remcount+" & AddMoney & " Where u_name='" & R_User & "'"
		conn.Execute(Sql)
''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'=============================
	'��ʼ����û��Ƿ���δ��������֧������㹻���Զ������
	set BorrowMRS=server.CreateObject("adodb.recordset")
	BorrowMsql="SELECT dbo.countlist.u_moneysum, dbo.countlist.sysid FROM dbo.countlist INNER JOIN dbo.UserDetail ON dbo.countlist.u_id = dbo.UserDetail.u_id WHERE (dbo.UserDetail.u_name = '"&R_User&"') AND (dbo.countlist.c_check = 1) AND (dbo.countlist.c_memo = '���') ORDER BY dbo.countlist.c_dateinput DESC"
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
				
				''����֧��Ƿ���¼
				sql="INSERT INTO dbo.countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note) VALUES ("&edward_u_id&","&tempBorrowMoney&",0,"&tempBorrowMoney&",'"&DateRadom&"','֧��Ƿ��',0,'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0)"
				conn.execute(sql)
				
				conn.execute("update userdetail set u_usemoney=u_usemoney-" & tempBorrowMoney & ",u_checkmoney=u_checkmoney-" & tempBorrowMoney & " where u_id=" & edward_u_id)

				'������¼��Ϊ�����
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
		url_return "������Ϊ��",-1
	end if
end function
''���鶩����''''''''''
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
'���������վ���û��Ŀ�
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

