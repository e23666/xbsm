<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->


<%Check_Is_Master(6)%>
<%
	conn.open constr
Sub writelog(errmes)
	id=Requesta("id")
	AllocateIP=Requesta("AllocateIP")
	sql="insert into ServerActiolog (ServerId,ServerIP,u_name,Content) values("&id&",'"&AllocateIP&"','"&session("user_name")&"','"&errmes&"')"
	conn.execute(sql)
 
End Sub

if requesta("weihulist")<>"" then
	'writelog requesta("weihulist")
end if

	check_is_master(6)
	
	id=Requesta("id")
	
	AlreadyPay=Requesta("AlreadyPay")
	MoneyPerMonth=Requesta("MoneyPerMonth")
	AllocateIP=Requesta("AllocateIP")
	deposit=Requesta("deposit")
    preday=trim(Requesta("preday"))
	if preday="" then
	 preday=0
	 else
	  preday=clng(preday)
	 end if

    zxws=trim(requestf("zxws"))''''''''''''-->�Ƿ��ǿ�ͨ���õ��ж�'''''''''''''
	 
	if Requesta("Alert")<>"" then
			Alert=1
	else
			Alert=0
	end if

	MainBoard=Requesta("MainBoard")
	StartTime=Requesta("StartTime")
	Act=Requesta("Act")
	
	Company=Requesta("Company")
	u_name=Requesta("u_name")
	Name=Requesta("Name")
	Telephone=Requesta("Telephone")
	Email=Requesta("Email")
	QQ=Requesta("QQ")
	Fax=Requesta("Fax")
	Zip=Requesta("Zip")
	Address=Requesta("Address")

	HostID=Requesta("HostID")
	Apply=Requesta("Apply")
	CPU=Requesta("CPU")
	HardDisk=Requesta("HardDisk")
	Memory=Requesta("Memory")

	Years=Requesta("BuyYear")
	PayMethod=Requesta("PayMethod")
	Memo=Requesta("Memo")
    flux=Requesta("flux")
	HostType=Requesta("HostType")
	if not isnumeric(flux) then flux=0

	if not isNumeric(id) then url_return "ID������",-1
    if zxws="freehost" then
	''''''''''''��ͨ���õ�''''''''''''''''''
		AlreadyPay=0
			edw_RadomPass=requesta("RadomPass")
			set fileobj=server.createobject(objName_FSO)
			set mailfile=fileobj.opentextfile(server.mappath("/mailModel/server_register.txt"))
			mailcontent=mailfile.readall
			mailfile.close
			set mailfile=nothing
			mailcontent=replace(mailcontent,"$USERNAME",NAME)
			mailcontent=replace(mailcontent,"$SERVERIP",AllocateIp)
			mailcontent=replace(mailcontent,"$SERVERTYPE",HostID)
			mailcontent=replace(mailcontent,"$PRICE",MoneyPerMonth)
			mailcontent=replace(mailcontent,"$DATE",StartTime)
			mailcontent=replace(mailcontent,"$PASSWORD",edw_RadomPass)
			mailcontent=replace(mailcontent,"{companyname}",companyname)
			call sendMail(Email,"����������֪ͨͨ",mailcontent)
			
			'�Ƿ����֪ͨ
			if requesta("SMSAlert")="1" then
				httpSendSMS "����,�������ѿ�ͨip:"&AllocateIp&" �û���Administrator ����"&edw_RadomPass&" {companyname}",Fax
			end if
	''''''''''''''''''''''''''''''''''''''''
	else
		if Act<>"" then
				if left(session("u_type"),1)<>"1" then url_return "Ȩ�޲���",-1
	
			if AlreadyPay<1 then url_return "��ѡ���Ѹ��·�",-1
			totalprice=MoneyPerMonth * AlreadyPay
			if deposit="yesneed" then totalprice=totalprice + MoneyPerMonth
			sql="select u_id,f_id from userdetail where u_name='" & u_name & "' and u_usemoney >=" & totalprice
			rs1.open sql,conn,1,1
			if rs1.eof then url_return "û�д��û������߿�������",-1
			if isNumeric(rs1("f_id")) then
				if rs1("f_id")>0 then url_return "�֣ã����û�,��ͨʧ��",-1
			end if
			rs1.close
			markinfo="���÷�����" & AllocateIp & ",�Ѹ�" & AlreadyPay & "��"
			if deposit="yesneed" then
				markinfo=markinfo & ",��Ѻ��"
			else
				markinfo=markinfo & ",��Ѻ��"
			end if
			randomize(timer())
			countid="server-" & left(u_name,3) & Left(Cstr(Clng(rnd()*100000)) & "00000",6)
			if not consume(u_name,totalprice,false,countid,markinfo,"","") then
				url_return "���ѿۿ�ʧ�ܣ������Ƿ����㹻��������һ��!",-1
			end if
			sql="update userdetail set u_invoice=u_invoice+" & totalprice & " where u_name='" & u_name & "'"
			conn.Execute(Sql)
			set fileobj=server.createobject(objName_FSO)
			set mailfile=fileobj.opentextfile(server.mappath("/mailModel/server_register.txt"))
			mailcontent=mailfile.readall
			mailfile.close
			set mailfile=nothing
			edw_RadomPass=requesta("RadomPass")
			mailcontent=replace(mailcontent,"$USERNAME",NAME)
			mailcontent=replace(mailcontent,"$SERVERIP",AllocateIp)
			mailcontent=replace(mailcontent,"$SERVERTYPE",HostID)
			mailcontent=replace(mailcontent,"$PRICE",MoneyPerMonth)
			mailcontent=replace(mailcontent,"$DATE",StartTime)
			mailcontent=replace(mailcontent,"$PASSWORD",edw_RadomPass)
			mailcontent=replace(mailcontent,"{companyname}",companyname)

			call sendMail(Email,"����������֪ͨͨ",mailcontent)
			
			'�Ƿ����֪ͨ
			if requesta("SMSAlert")="1" then
				httpSendSMS "����,�������ѿ�ͨip:"&AllocateIp&"�û���:Administrator����:"&edw_RadomPass&" " & companyname,Fax
			end if
		end if
	end if

	Sql="Select * from HostRental where id=" & id
'response.write sql
	Rs.open Sql,conn,3,3
	if Rs.eof then
		Rs.close
		url_return "����δ�ҵ�",-1
	end if
		
	Rs("Company")=Company
	Rs("u_name")=U_name
	Rs("Name")=Name
	Rs("Telephone")=Telephone
	Rs("Address")=Address
	Rs("Zip")=Zip
	Rs("Email")=Email
	Rs("QQ")=QQ
	Rs("Fax")=Fax
	Rs("weihulist")=requesta("weihulist")
	Rs("HostType")=HostType

	Rs("Memo")=Memo
	
if Session("user_name")<>"superadmin" then
	if left(session("u_type"),1)="1" then
	
		Rs("MoneyPerMonth")=MoneyPerMonth
		Rs("StartTime")=StartTime
		Rs("AlreadyPay")=AlreadyPay

	Rs("AllocateIP")=AllocateIP
	Rs("Alert")=Alert
	Rs("HostID")=HostID
	Rs("Apply")=Apply
	Rs("CPU")=CPU
	Rs("HardDisk")=HardDisk
	Rs("Memory")=Memory
	Rs("MainBoard")=MainBoard
	Rs("Years")=Years
	Rs("PayMethod")=PayMethod
    Rs("preday")=preday
	if not isnumeric(flux&"") then flux=0
	Rs("flux")=flux
	rs("RamdomPass")=requesta("RadomPass")
	if Act<>"" then
		Rs("Start")=true
	end if
	
	end if
else
   if Act<>"" then
	Rs("MoneyPerMonth")=MoneyPerMonth
	Rs("StartTime")=StartTime
	Rs("AlreadyPay")=AlreadyPay
   end If
   Rs("preday")=preday
	Rs("AllocateIP")=AllocateIP
	Rs("Alert")=Alert
	Rs("HostID")=HostID
	Rs("Apply")=Apply
	Rs("CPU")=CPU
	Rs("HardDisk")=HardDisk
	Rs("Memory")=Memory
	Rs("MainBoard")=MainBoard
	Rs("Memo")=Memo
	Rs("Years")=Years
	Rs("PayMethod")=PayMethod
	rs("RamdomPass")=requesta("RadomPass")
	if Act<>"" then
		Rs("Start")=true
	end if
'writelog "������"&AllocateIP&"��qingmuyuya�޸���ϢΪ:"&MoneyPerMonth&"  "&StartTime&"  "&AlreadyPay

end if
	
	Rs.update
	Rs.close

conn.close
Response.write "<script language=javascript>alert('���³ɹ�');location.href='default.asp';</script>"
%>
