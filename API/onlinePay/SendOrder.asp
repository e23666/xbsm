<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<%
'''''''''''''''��������''''''''''''''''''''''''''''''''''''''''''''''''''''
	agent_url1=request.servervariables("HTTP_REFERER")'Դ��ַ
	agentPage=trim(request.form("agentPage"))'�����̵Ĵ���ҳ��
	agentRingnum=trim(request.form("agentRingnum"))'�����̵Ķ�����
	agent_user=request.form("users")'����������Ŀͻ���
	ring_us=request.form("ring_us")'��������
	PayAmount=FormatNumber(request.form("dj"),2,-1,-1)'Ǯ
	dj=request.form("dj")
	agentMid5=trim(request.form("agentMid5"))'���ܴ�
	GUID=GetGUID()
''''''''''''''''''''''''''''''''��ȫ�ж�''''''''''''''''''''''''''''''''''''''''''''
	conn.open constr	

	u_api_pwd=getapipwd(ring_us)
	agentMid5str=asp_md5(agentPage & agentRingnum & agent_user & ring_us & dj&u_api_pwd)
	if agentMid5<>agentMid5str then RaiseError("md5��֤�д�")

'-------------------------------------------------


'	setagentpay=agentpayType()
	PayRate=tenpay_fy '����
	agent_url=returnWeburl(agent_url1)
	if agent_url="" or agentPage="" then Call RaiseError("�벻Ҫ�Ƿ�ʹ��.")'û���ҵ�������
	if not agentpd(ring_us) then RaiseError("�벻Ҫ�Ƿ�ʹ��!")'û���ҵ�������
	if not isNumeric(PayAmount) or PayAmount="" then  Call RaiseError("����֧��������������")
	if PayAmount<=0 then Call RaiseError("����֧��������������")
	conn.execute "Insert into Ring (Ring_us,Ring_tp,Ring_ve,Ring_pr,Ring_dt,Ring_ov,agent_user,agent_url) values ('" & ring_us &"',1,'"&GUID&"'," & replace(PayAmount,",","") & ",'" & now() & "',0,'"& agent_user &"','"& agent_url &"')"

	if GetPayOrder(GUID,PayOrder,PayAmount2,ring_id) then
		discount=f_number(PayAmount2 * PayRate)
		PayAmount=PayAmount2 + discount
	else
		RaiseError("��ȡ����ʧ��,������һ��")
	end if
	
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			formaction="https://www.tenpay.com/cgi-bin/v1.0/pay_gate.cgi"
			spid= tenpay_userid		' �̻���
			sp_key= tenpay_userpass	'32��Կ
			cmdno		= "1"				' �Ƹ�֧ͨ��Ϊ"1" (��ǰֻ֧�� cmdno=1)	
			bill_date	= CFTGetServerDate	' �������� (yyyymmdd)	
			bank_type	= "0"				' ��������:	0	�Ƹ�ͨ
			desc		= agent_user		' ��Ʒ����
			purchaser_id = ""				' �û��Ƹ�ͨ�ʺţ����û�п����ÿ�
			bargainor_id = spid				' �̻���
			sp_billno	 = right(replace(PayOrder,"-",""),32)			' �̻����ɵĶ�����(���32λ)	)
			spbill_create_ip=Request.ServerVariables("REMOTE_ADDR")
			' ��Ҫ:
			' ���׵���(28λ): �̻���(10λ) + ����(8λ) + ��ˮ��(10λ), ���밴�˸�ʽ����, �Ҳ����ظ�
			' ���sp_billno����10λ, ���ȡ���е���ˮ�Ų��ּӵ�transaction_id��(����10λ��0)
			' ���sp_billno����10λ, ����0, �ӵ�transaction_id��
			transaction_id = spid & bill_date & reSetOrder(sp_billno)
			total_fee	 = PayAmount * 100		' �ܽ��, ��Ϊ��λ
			fee_type	 = "1"				' ��������: 1 �C RMB(�����) 2 - USD(��Ԫ) 3 - HKD(�۱�)
			return_url	 = "http://" & Request.ServerVariables("SERVER_NAME") & "/API/onlinePay/notify_handler.asp" '�Ƹ�ͨ�ص�ҳ���ַ, (�255���ַ�)
			attach		 = ring_id & "|" & agentRingnum &"|"& agentMid5str & "|" & agentPage & "|" & agent_user	' �̻�˽������, ����ص�ҳ��ʱԭ������
			' ����MD5ǩ��    
			sign_text = "cmdno=" & cmdno & "&date=" & bill_date & "&bargainor_id=" & bargainor_id &_
						"&transaction_id=" & transaction_id & "&sp_billno=" & sp_billno &_
						"&total_fee=" & total_fee & "&fee_type=" & fee_type & "&return_url=" & return_url &_
						"&attach=" & attach & "&spbill_create_ip="&spbill_create_ip&"&key=" & sp_key
			md5_sign = ucase(ASP_MD5(sign_text))

 	
%>
<html>
<body onLoad="javascript:document.form1.submit();">
<form name="form1" method="post" action="<%=formaction%>">

                <input type=hidden name="cmdno"				value="<%=cmdno%>">
                <input type=hidden name="date"			    value="<%=bill_date%>">
                <input type=hidden name="bank_type"			value="<%=bank_type%>">
                <input type=hidden name="desc"				value="<%=desc%>">
                <input type=hidden name="purchaser_id"		value="<%=purchaser_id%>">
                <input type=hidden name="bargainor_id"		value="<%=bargainor_id%>">
                <input type=hidden name="transaction_id"	value="<%=transaction_id%>">
                <input type=hidden name="sp_billno"			value="<%=sp_billno%>">
                <input type=hidden name="total_fee"			value="<%=total_fee%>">
                <input type=hidden name="fee_type"			value="<%=fee_type%>">
                <input type=hidden name="return_url"		value="<%=return_url%>">
                <input type=hidden name="attach"			value="<%=attach%>">
                <input type=hidden name="sign"				value="<%=md5_sign%>">
                <input type=hidden name="spbill_create_ip"			value="<%=spbill_create_ip%>">
       
               
          
</form>
</body>
</html>
<%


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
''��ȡ10λ������
function reSetOrder(orderstr)
	orderstr=trim(orderstr)
	if orderstr <>"" then
		if len(orderstr)>10 then
			reSetOrder=right(orderstr,10)
		else
			reSetOrder=right("0000000000" & orderstr,10)
		end if
	else
		url_return "������Ϊ��",-1
	end if
end function
function iif(ByVal condition,ByVal firstV,ByVal secondV)
	if condition then
		iif=firstV
	else
		iif=secondV
	end if
end function
function returnWeburl(url)
	urlsreturn=""
	if url<>"" then
		urls=""
		if left(url,5)="http:" then
			urls=mid(url,8)
		end if
		if instr(urls,"/")>0 then
			ArrayUrls=split(urls,"/")
			urlsreturn=ArrayUrls(0)
		else
			urlsreturn=url
		end if
	end if	
	
		returnWeburl=urlsreturn
	
end function
function GetFormatDate()
	Mdays=month(now())
	DDays=day(now())
	YDays=Year(now())
	GetFormatDate=Cstr(YDays) & iif(Mdays<10,"0" & Mdays,Cstr(Mdays)) & iif(DDays<10,"0" & DDays,Cstr(DDays))
end function

function f_number(ByVal cast)
	enlarge=cast * 100
	enlargeInt=Round(enlarge)
	reduce=enlargeInt / 100
	f_number=reduce
end function

function GetPayOrder(ByVal GUIDNumber,ByRef PayOrder,Byref PayAmount,ByRef ring_id)
	Set PayOrder_Rs=CreateObject("Adodb.RecordSet")
	PayOrder_Rs.open "select ring_id,ring_pr from ring where ring_ve='" & GUIDNumber & "'",conn,0,1
	if PayOrder_Rs.eof then
		GetPayOrder=False
	else
		PayAmount=PayOrder_Rs("ring_pr")
		ring_id=PayOrder_Rs("ring_id")
		ring_id_str=right("00000000" & Cstr(ring_id),8)
		PayOrder=GetFormatDate() & "-" & ring_id_str
		GetPayOrder=true
	end if
	PayOrder_Rs.close
	set PayOrder_Rs=nothing
end function

function agentpd(users)
	agentpd=false
	if users<>"" then
		agentSql="select top 1 u_id from userDetail where u_name='"& trim(users) &"'"
		set agentRs=conn.execute(agentSql)
		if not agentRs.eof then
			agentpd=true
		end if
	end if
end function
sub RaiseError(mes)
	Response.write mes
	response.end
end sub
function GetGUID()
	Randomize timer
	zNum = cint(8999*Rnd+1000)
	GetGUID=Replace(Cstr(Date()),"-","") & Cstr(Clng(Timer())) & Cstr(Session("u_sysid"))&"-"&zNum
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