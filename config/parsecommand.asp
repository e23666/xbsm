<!--#include virtual="/config/cmode_sp_code.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<!--#include virtual="/config/DomainAPI.asp" -->
<!--#include virtual="/config/class/buyserver_class.asp" -->
<%
'������config.asp���ͬ���������ƣ���ʽʹ�ú�ɾ���ú���
'ȫ�ֱ��������ڴ洢�������û���
'
domainRegister=""
api_debug=false    '������
sub writelog_api(xinfo)
	line=Replace(xinfo,"'","")
	conn.Execute("insert into ActionLog (ActionUser,Remark,AddTime,LogType) values('API','" & line & "',"&PE_Now&",'API')")
end sub

function CheckEnoughMoneyForDemo(Byval u_name,byval testPrice)
	dim lrs
	if not isNumeric(testPrice) then
		testPrice=5
	end if
	set lrs=conn.Execute("select u_id from userdetail where u_usemoney+u_premoney>=" & testPrice & " and u_name='" & u_name & "'")
	CheckEnoughMoneyForDemo=not lrs.eof
	lrs.close:set lrs=nothing	
end function

function CheckEnoughMoney_demo(CustomerName,ProductID,BuyYears,BuyType,UseCoupons)
	CheckEnoughMoney_demo=false
	
	set u_rs=server.CreateObject("adodb.recordset")
	u_sql="select u_usemoney,u_premoney from UserDetail where u_name='"&CustomerName&"'"
	u_rs.open u_sql,conn,1,3
	if u_rs.eof or u_rs.bof then
		exit function
	else
		u_usemoney=u_rs("u_usemoney")
		u_premoney=u_rs("u_premoney")
	end if
	u_rs.close
	set u_rs=nothing
	
	NeedMoney=GetNeedPrice(CustomerName,ProductID,BuyYears,BuyType)
	
	if isNumeric(demoprice) then
		NeedMoney=NeedMoney-demoprice
	end if
	
	if UseCoupons then
		u_usemoney=u_usemoney+u_premoney
	end if

	if ccur(u_usemoney)<ccur(NeedMoney) then
		CheckEnoughMoney_demo=false
	else
		CheckEnoughMoney_demo=true
	end if
end function


Set glbArgus=CreateObject("Scripting.Dictionary"):glbArgus.compareMode=1

function success(inputstr)
	if left(inputstr,3)="200" then
		success=true
	else
		success=false
	end if
end function

function getInput(byVal fdname)
	inputStr=glbArgus("strCmd")
	'response.Write(inputStr&"<hr>")
	fdname=fdname & ":"
	fdname_len=len(fdname)
	ipos=instr(inputStr,fdname)	

	if ipos>0 then
		jpos=instr(ipos,inputStr,vbcrlf)
		
		if jpos>0 then
			fieldStr=mid(inputStr,ipos,jpos-ipos)					
			getInput=mid(fieldStr,fdname_len+1)
			'	response.Write(fieldStr&"======="&getInput&"<BR>")
	
		end if
	end if
	
end function

'��ȡ����ֵ
function getReturn(ByVal inputStr,byVal fdname)
	fdname=fdname & ":"
	fdname_len=len(fdname)
	ipos=instr(inputStr,fdname)
	if ipos>0 then
		jpos=instr(ipos,inputStr,vbcrlf)
			if jpos>0 then
				fieldStr=mid(inputStr,ipos,jpos-ipos)					
				getReturn=mid(fieldStr,fdname_len+1)
			end if
	end if
end function

'��ȡ����ֵ
function getReturn_rrset(ByVal inputStr,ByVal fdname)
	fdname=fdname & ":"
	fdname_len=len(fdname)
	ipos=instr(inputStr,fdname)
	if ipos>0 then
		jpos=instr(ipos,inputStr,vbcrlf  & "." & vbcrlf)
			if jpos>0 then
				fieldStr=mid(inputStr,ipos,jpos-ipos)					
				getReturn_rrset=mid(fieldStr,fdname_len+1)
			end if
	end if	
end function

function regcheck(szPattern,txtStr)
	set oReg=New RegExp
	oReg.ignoreCase=true
	oReg.pattern="^" & szPattern & "$"
	regcheck=oReg.test(txtStr)
	set oReg=nothing
end function

function connectToUp(ByVal strCmd)
 
	Md5Sig=Asp_md5(api_username & api_password & left(strCmd,10))
	postStr="userid=" & URLEncode(api_username) 
	postStr=postStr & "&versig=" & URLEncode(Md5Sig)
	postStr=postStr & "&strCmd=" & URLEncode(strCmd)
	connectToUp=OpenRemoteURL(api_url,postStr)
	'response.write api_url&"?"&postStr
	'response.End()
	if connectToUp&""="" then exit function
	if left(connectToUp,4)<>"200 " and left(connectToUp,3)="200" then connectToUp="6" & connectToUp
end function

function PCommand(ByVal strCmd,ByVal u_name)
	'�û����
	if u_name="" or finduserid(u_name)=0 then
		PCommand="500 ��Ч���û�":Exit function
	end if

	'����ȫ�ֱ���
	glbArgus.RemoveAll
	glbArgus.Add "strCmd",strCmd
	glbArgus.Add "u_name",u_name
    
	'ͳһ������������
	intPos=instr(strCmd,vbcrlf)
	if intPos=0 then PCommand="500 ��Ч������1":Exit function
	ACT_PRODUCT=left(strCmd,intPos-1) '��ȡ���
	intPosJ=instr(intPos+1,strCmd,vbcrlf)
	if intPosJ=0 then PCommand="500 ��Ч������2":Exit function
	ACT_TYPE=mid(strCmd,intPos+2,intPosJ-intPos-2) '��ȡ����
	ACT_ENTITY=getInput("entityname") '��ȡʵ��
	if ACT_ENTITY="" then PCommand="500 ��Ч������3":Exit function
	PCommand="500 ��Ч���������." & vbcrlf
	writelog_api u_name & vbcrlf & strCmd
	 
	select case ACT_PRODUCT
		Case "yunmail"
			select case ACT_TYPE
				Case "add":PCommand=create_yunmail(strCmd) '��ͨ
					
			End select
		case "miniprogram"
			select case ACT_TYPE
				case "add"
					select case ACT_ENTITY
						case "miniprogram"
							PCommand=create_wxapp(strCmd) '��ͨ��������
'						case "buysms"
'							PCommand=buysms_wxapp(strCmd) '��ͨ��������
'						case "other"
'							PCommand=connectToUp(strCmd) '��ͨ��������
					end select
'				case "renew"
'					select case ACT_ENTITY
'						case "app"
'							PCommand=renew_wxapp(strCmd) '��ͨ��������
'						case "appid"
'							PCommand=renew_wxappid(strCmd) '��ͨ��������
'					end select
'
'				case "get"
'		 
'					select case ACT_ENTITY
'						case "sms"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'						case "pwd"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'						case "manager"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'						case "productids"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'						case "list"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'						case "syn"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'					end select
'				case "set"
'					select case ACT_ENTITY
'						case "pwd"
'							PCommand=connectToUp(strCmd) '��ͨ��������
'					end select
			end select			
		case "vhost"
			
			if not AllowOpen("vhost") then
				PCommand="999 ���������ӿڱ�����Ա�ر�"
				exit function
			end if

			select case ACT_TYPE
				case "add"
					select case ACT_ENTITY
						case "vhost"
							PCommand=vhost_add_vhost() '��ͨ��������
					end select
				case "mod"
					PCommand=setftppasswd() '�޸�ftp����
				case "renewal"
					PCommand=vhost_renew() '����
				case "paytest"
					PCommand=vhost_paytest() '��������ת��
				case "set"
					if ACT_ENTITY = "upvhost" then
						PCommand=vhost_set_upgrade() '��������	
					elseif ACT_ENTITY = "reupvhost" then
						PCommand=connectToUp(glbArgus("strCmd")) '������
					end If
				case "traffic"
					PCommand=vhost_add_traffice()	'��ֵ����
			end select
		case "server"
			select case ACT_TYPE
				case "add"
					select case ACT_ENTITY
						case "server"
							  if trim(getInput("producttype"))="diyserver" then
							PCommand=server_adddiy()  'diy��������
							else						
							PCommand=server_add()
							end if
					end select
				case "renew"
						PCommand=server_renew()
				case "set"
					select case ACT_ENTITY
						case "upserver"
							PCommand=server_set_upgrade()
						case "modinfo"
						'    response.Write("������")
'							response.End()
							PCommand=server_set_modinfo()
						case "reupserver"
							PCommand=connectToUp(glbArgus("strCmd")) '������
						case "upserverdiy"
					  	    PCommand=upserverdiy(glbArgus("strCmd")) '������
							exit function
					end select
				case "paytest"
				  
					 select case ACT_ENTITY
					 case "serverdiy"
 
					    PCommand=server_paytestdiy(glbArgus("strCmd"))   'diy����
					 end select
				     '   serverip=getInput("serverip")
					 '	PCommand=connectToUp(glbArgus("strCmd")) 
				Case "manage"
					Select Case ACT_ENTITY
						case "otherips"
							PCommand=connectToUp(glbArgus("strCmd"))
					End select
			end select
			
		case "domainname"
			if not AllowOpen("domain") then
				PCommand="998 �����ӿڱ�����Ա�ر�"
				exit function
			end if

			select case ACT_TYPE
				case "add"
						PCommand=domainname_add_domain() '��ͨ���͵�����
				case "mod"
						PCommand=domainname_mod_passwd() '�޸���������
				case "renew"
						PCommand=domainname_renew() '��������
				case "check"
						PCommand=domainname_check() '������ѯ
				case "open","reopen"
					if ACT_ENTITY = "urlforword" then
						PCommand=domainname_openurljump(ACT_TYPE) '��ͨ/����URLת��
					end if
			end select
		case "mssql"

			if not AllowOpen("mssql") then
				PCommand="997 ���ݿ�ӿڱ�����Ա�ر�"
				exit function
			end if

			select case ACT_TYPE
				case "add"
						PCommand=mssql_add() '��ͨ���ݿ�
				case "mod"
						PCommand=mssql_mod_pwd() '�޸�����
				case "renewal"
						PCommand=mssql_renew() '�������ݿ�				
			end select
		case "corpmail"
			if not AllowOpen("mail") then
				PCommand="996 �ʾֽӿڱ�����Ա�ر�"
				exit function
			end if

			select case ACT_TYPE
				case "add"
						PCommand=corpmail_add() '��ͨ��ѵĻ��շѵ��ʾ�
				case "mod"
						PCommand=corpmail_mod_pwd() '�޸��ʾ�����
				case "renewal"
						PCommand=corpmail_renew() '�����ʾ�
			end select
		case "dnsresolve" 
			PCommand=connectToUp(glbArgus("strCmd"))
	 
		case "other"
			select case ACT_TYPE
				case "get"
					select case ACT_ENTITY
					case "expdate"
						    PCommand=connectToUp(glbArgus("strCmd")) 'ͬ�����ڵ���ʱ��
						case "oslist"
						    PCommand=connectToUp(glbArgus("strCmd")) '��ȡ��Ʒ��Ӧ�Ļ����б�
						case "roomlist"
							PCommand=connectToUp(glbArgus("strCmd")) '��ȡ��Ʒ��Ӧ�Ļ����б�
						case "uphostinfo"
							PCommand=connectToUp(glbArgus("strCmd")) '��ȡ��������
						case "upserverinfo"
							PCommand=connectToUp(glbArgus("strCmd")) '��ȡ��������
						case "upmssqlinfo"
							PCommand=connectToUp(glbArgus("strCmd")) '��ȡ��������										
						case "tablecontent"
							PCommand=other_get_tablecontent() '��ȡ��Ʒ�б�
						case "sysdomainprice"
							PCommand=other_get_tablecontent() '��ȡ��Ʒ�б�

						case "tmptablecontent"
							PCommand=connectToUp(glbArgus("strCmd")) '��ȡһ����Ʒ�б�
						case "ftppassword"
							PCommand=other_get_ftppassword() '��ȡftp����
						case "mailpassword"
							PCommand=other_get_mailpassword() '��ȡ�ʾ�����
						case "mssqlpassword"
							PCommand=other_get_mssqlpassword() '��ȡ���ݿ�����
						case "usemoney"
							PCommand=other_get_usemoney() '��ȡ���ý��
						case "domainpassword"
							PCommand=other_get_domainpassword() '��ȡ��������
						case "vhostexists"
							PCommand=other_get_vhostexists() '��ȡ����״̬
						case "question"
							PCommand=other_get_question() '��ȡ���ʱش�����
						case "pricecompare"
							PCommand=other_get_compare()  '��ȡ�ɱ���
						case "iscaninvoice"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "invoice"
							PCommand=other_get_invoice() '��ȡ��Ʊ״̬
						case "bgplinux"
							PCommand=connectToUp(glbArgus("strCmd")) 'bgp linux
						case "getotherip"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "getotherssl"
							PCommand=connectToUp(glbArgus("strCmd"))						
						case "server_roomlist"
							PCommand=chgroomName(connectToUp(glbArgus("strCmd")))
						case "server_paymethod"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "get_roomlistname"
							PCommand=chgroomName(connectToUp(glbArgus("strCmd")))
						case "gift"
							PCommand=getgift()
						case "mssqlver"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "mysqlver"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "mssqlexists"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "auth_check"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "auth_sendcode"
							PCommand=connectToUp(glbArgus("strCmd"))
						case "auth_checkcode"
							PCommand=connectToUp(glbArgus("strCmd"))
						Case "mysqlver"
							PCommand=connectToUp(glbArgus("strCmd"))
					end select
				case "upgrade"
					select case ACT_ENTITY
						case "mail"
							PCommand=other_upgrade_mail() '�ʾ�����
						case "mssql"
							PCommand=other_upgrade_mssql() '���ݿ�����
					end select
				case "add"
					select case ACT_ENTITY
						case "invoice"
							PCommand=other_add_invoice() '��ӷ�Ʊ
						case "question"
							PCommand=other_add_question()'�ύ���ʱش�
						case "sms"
							PCommand=other_add_sms()'���Ͷ���
					end select
				case "paytest"
					select case ACT_ENTITY
						case "mail"
							PCommand=other_paytest_mail() '�ʾ�ת��
						case "mssql"
							
							PCommand=other_paytest_mssql() '����ת��
					end select
				case "sync"
					select case ACT_ENTITY
						case "vhost"
							PCommand=other_sync_vhost()'ͬ����������
						case "domain"
							PCommand=other_sync_domain()'ͬ����������
						case "mail"
							PCommand=other_sync_mail()'ͬ���ʾ�����
						case "database"
							PCommand=other_sync_database()'ͬ�����ݿ�
						case "allpassword"
							PCommand=other_sync_allpassword()'ͬ����������
						case "server"
							PCommand=other_sync_server()'ͬ����������
						case "record"
							PCommand=other_sync_record() 'ͬ������ҵ������
					end select
				case "test"
					PCommand=connectToUp(glbArgus("strCmd"))
				end select
			end select

	writelog_api "���ؽ��:" & PCommand
end function
function server_renew()
	result=""
	u_name=glbArgus("u_name")
	allocateip=getInput("serverip")
	renewtime=getInput("renewtime")
	paymethod=getInput("paymethod")
	set sb=new buyServer_Class
	sb.setUserid=finduserid(u_name)
	sb.getHostdata(allocateip)
	sb.paymethod=paymethod
	sb.renewTime=renewtime
	call sb.getrenewPrice()
	needprice=cdbl(sb.PricMoney)
    
	
	if needprice>sb.u_usemoney then
		server_renew="400 No Money"
		exit function
	end if
	'renewMonth=cdbl(renewtime) * cdbl(sb.paymonthnum)
	renewMonth = cdbl(sb.paymonthnum)
	If Not api_debug then
		loadRet=connectToUp(glbArgus("strCmd"))
	else
		loadRet="200 ok"
 	End if
	if success(loadRet) Then
	If CDbl(sb.ipprice)>0 Then othertips="(������IP:"&sb.ipprice&")"
		
		if not consume(u_name,needprice,false,"server-" & Left(Cstr(Clng(rnd()*100000)),6) , "����IP��������" & allocateip & othertips ,sb.p_proid,"") then
			result="500 err"
			addRec "�ۿ�ʧ��","����IP��������"& vpsIP &"�ɹ����ϼ����ѿۣ����û���δ�ܿ۳���" 
		else
			sql="select * from hostrental where allocateip='"& allocateip &"'"
			rs1.open sql,conn,1,3
			if not rs1.eof then
				torenewTime=clng(rs1("alreadypay")) + clng(renewMonth)
				Years=clng(torenewTime / 12)
				if torenewTime mod 12 >0 then Years=Years+1
				rs1("alreadypay")=torenewTime
				rs1("Years")=Years
				rs1("paymethod")=paymethod
				rs1.update()
				result="200 ok"
				Call Set_vcp_record(sb.p_proid,finduserid(u_name),needprice,renewMonth,"����������",true)
			end if		
			rs1.close	
		end if
	else
		result=loadRet
		if instr(loadRet,"���ϴ�����ʱ��")>0 then
			AddRec "����IP������","����IP������ʧ��["&allocateip & "]�ϼ�����:"&loadRet&",�����Ƿ�۷�"
			result="500 ϵͳ��������ϵ����Ա"
			exit function
		end if
	
	end if
	server_renew=result
end function
function server_add()	
	u_name=glbArgus("u_name")
	aid=getInput("aid")
	if not isnumeric(aid) or aid="" then 
		server_add="500 aid is Err"
		exit function	
	end if
	set sb=new buyServer_Class
	sb.p_proid=getInput("p_proid")
	sb.serverroom=getInput("serverroom")
	sb.PayMethod=getInput("paymethod")
	sb.cdntype=getInput("cdntype")
	sb.servicetype=getInput("servicetype")
	sb.isvps=getInput("isvps")
	sb.renewtime=getInput("renewtime")
	sb.setUserid=finduserid(u_name)
	call sb.getServerPrice("new")
	needprice=cdbl(sb.PricMoney)
	if needprice>sb.u_usemoney then
		server_add="400 No Money"
		exit function
	end if
	loadRet=connectToUp(glbArgus("strCmd"))
	if success(loadRet) then
		vpsIP=getReturn(loadRet,"vpsIP")
		vpsPassWord=getReturn(loadRet,"vpsPassWord")
		server_add = "200 ok"
		randomize(timer())
		if not consume(u_name,needprice,false,"server-" & Left(Cstr(Clng(rnd()*100000)),6) , "����IP��������" & vpsIP ,sb.p_proid,"") then
			addRec "�ۿ�ʧ��","����IP��������"& vpsIP &"�ɹ����ϼ����ѿۣ����û���δ�ܿ۳���" 
		else
			sql="select * from HostRental where id="& aid
			rs1.open sql,conn,1,3
			if not rs1.eof then
				rs1("start")=true
				rs1("AllocateIP")=vpsIP
				rs1("RamdomPass")=vpsPassWord
				rs1("MoneyPerMonth")=sb.MoneyPerMonth
				rs1("AlreadyPay")=sb.paymonthnum
				rs1("StartTime")=date()
				rs1("addedServer")=sb.servicetype
				rs1("addServerPrice")=sb.servicetypePrice
				rs1("u_name")=u_name
				rs1.update()
			end if
			rs1.close 
			server_add=loadRet					    
		end if
	else
		server_add="500 ERR=" & loadRet
	end if
end function

function vhost_add_traffice()
	u_name=glbArgus("u_name")
	s_comment=getInput("ftpuser")
	tproid=getInput("tproid")	
	tsize=GetTSize(tproid)
	pcnt=getInput("pcnt")
	tprice=GetNeedPrice(u_name,tproid,1,"new")
	monthlist=getInput("monthlist")	
	ttraffic =Tsize*pcnt
	Monthlist =split(monthlist,",")
	MonthTotal=Ubound(Monthlist)+1
	paymoney=MonthTotal*pcnt*Tprice

	if pcnt<1 then pcnt=1
	
	if tprice<1 then
		vhost_add_traffice="400 No product"
		exit function
	end if

	if not CheckEnoughMoney(u_name,tproid,abs(pcnt*MonthTotal),"new",false) then
		vhost_add_traffice="400 No Money"
		exit function
	end if
	
	showInfo=""
	for k=0 to Ubound(Monthlist)
		if isDate(Monthlist(k)) then
			Mstr=Monthlist(k)
			showInfo=showInfo & left(Mstr,instrRev(Mstr,"-")-1) & ","
		end if
	next
	if right(showInfo,1)="," then showInfo=left(showInfo,len(showInfo)-1)
	countinfo="����" & s_comment & "������ֵ" & pcnt*Tsize & "G,�·�:" & showInfo
	countid=left("TRA-" & UCase(left(u_name,10)) & "-" &Cstr(timer()) ,20)
	loadRet=connectToUp(glbArgus("strCmd"))	
	if success(loadRet) then
		Cret=consume(u_name,paymoney,false,countid,countinfo,Tproid,"")	
		if not Cret then addRec "������ֵ����",s_comment & "������ֵ�ɹ������ۿ�ʧ��,���ֹ���ʵ"
		for each xdate in Monthlist
		if isDate(xdate) then
			conn.Execute("insert into app_traffic(s_comment,tdate,ttraffic) values('" & s_comment & "','" & xdate & "'," & ttraffic & ")")
		end if
		next
		vhost_add_traffice="200 ok"
	else
		vhost_add_traffice="500 ERR=" & loadRet
	end if
end Function

function vhost_add_vhost()
	'��ͨ��ʽ/������������
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.CompareMode=1
	p_proid=getInput("producttype")
	s_comment=getInput("ftpuser")
	paytype=getInput("paytype")
	settouch=getInput("settouch")
	gift=getInput("gift")
	isGift=(gift="true")
	iptype=getInput("iptype")
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
	if iptype&""="" or not isnumeric(iptype) then iptype=0
	if isGift then
		m_bindname=getInput("attach-ident")
		Set localRs=conn.Execute("select m_years from mailsitelist where m_bindname='" & m_bindname & "' and m_ownerid=" & u_id)
		if localRs.eof then
			vhost_add_vhost="500 ����ҵ�񲻴���"
			exit function
		end if
		s_year=localRs("m_years")
		localRs.close:set localRs=nothing		
	else
		s_year=getInput("years")
		if not isNumeric(s_year) then
			vhost_add_vhost="500 ���޸�ʽ����ȷ"
			exit function
		end if

		s_year=Cint(s_year)

		if s_year<1 or s_year>10 then
			vhost_add_vhost="500 ���޸�ʽ����ȷ"
			exit function
		end if
	end if


	if exists_sql("select s_comment from vhhostlist where s_comment='" & s_comment & "'")	then
		vhost_add_vhost="500 ���������Ѿ�����"
		exit function
	end if

	if not regcheck("[\w\_]{3,50}",s_comment) then
		vhost_add_vhost="500 FTP�û�����Ч"
		exit function
	end if

	if not isNumeric(paytype) then
		vhost_add_vhost="��ͨ������Ч"
		exit function
	end if

	if not regcheck("[a-zA-Z0-9,\-\.]*",getInput("domain")) then
		vhost_add_vhost="��Ч�İ�����"
		exit function
	end if

	if not regcheck("\d*",getInput("room")) then
		vhost_add_vhost="��Ч�Ļ���ID"
		exit function
	end if

	appInfos=split(settouch,"|")

	if Ubound(appInfos)=3 then
		appName=appInfos(0)
		appAdd=appInfos(1)
		appTel=appInfos(2)
		appEmail=appInfos(3)
	else
		appName=""
		appAdd=""
		appTel=""
		appEmail=""
	end if
	if paytype="1" or isGift then iptype=0
	if paytype="0" and not isGift then
		set u_rs=server.CreateObject("adodb.recordset")
		u_sql="select u_usemoney,u_premoney from UserDetail where u_name='"&u_name&"'"
		u_rs.open u_sql,conn,1,3
		if u_rs.eof or u_rs.bof then
			vhost_add_vhost="500 ���û�������"
			exit function
		else
			u_usemoney=u_rs("u_usemoney")
			u_premoney=u_rs("u_premoney")
		end if
		u_rs.close
		set u_rs=nothing
		NeedMoney=GetNeedPrice(u_name,p_proid,s_year,"new")
		if iptype&""="1" then

			if lcase(left(p_proid,2))="tw" then
				ipproid="twaddip"
			else
				ipproid="vhostaddip"
			end if
			ipMoney=GetNeedPrice(u_name,ipproid,s_year,"new")			 
			if ipMoney&""="" or not isnumeric(ipMoney) then ipMoney=0
			NeedMoney=cdbl(NeedMoney)+cdbl(ipMoney)
		end if
		if cdbl(NeedMoney)>cdbl(u_usemoney)+cdbl(u_premoney) then
			vhost_add_vhost="500 ����"
			exit function
		end if
	elseif paytype="1" then
		if not CheckEnoughMoneyForDemo(u_name,demoprice) then
			vhost_add_vhost="500 ����,���ܿ�ͨ��������"
			exit function
		end if		
		'����һ����־
		glbArgus("strCmd")=Replace(glbArgus("strCmd"),"." & vbcrlf,"demoprice:" & demoprice & vbcrlf & "." & vbcrlf)
	end if

	s_bindings=getInput("domain")
	if Lcase(s_bindings)="www." then 
		s_bindings=""
		glbArgus("strCmd")=Replace(glbArgus("strCmd"),":www.",":")
	end if

	PArgs.Add "Ftp_UserName",s_comment
	PArgs.Add "P_Type",paytype
	PArgs.Add "ServerBindings",s_bindings
	PArgs.Add "username",u_name
	PArgs.Add "producttype",p_proid
	PArgs.Add "FtpPassword",getInput("ftppassword")
	PArgs.Add "appName",appName
	PArgs.Add "appAdd",appAdd
	PArgs.Add "appTel",appTel
	PArgs.Add "appEmail",appEmail
    
'2013 8-29 ����������/��������ʱ��
	select case s_year
	case 2
	Giftyear=1+s_year
	case 3
	Giftyear=2+s_year
	case 5
	Giftyear=5+s_year
	case 10
	Giftyear=10+s_year
	case else
	Giftyear=s_year
	end select 

	PArgs.Add "vyears",s_year




	Call sp_addsite(PArgs)

	result=Cint(PArgs("result"))
	orderid=PArgs("ordersysid")
	sysid=PArgs("identity")

	PArgs.RemoveAll

	if result>0 then
		if result="1234" then
			vhost_add_vhost="500 ������Ӵ��󣬴�����:����������������7��"
		else
			vhost_add_vhost="500 ������Ӵ��󣬴�����:" & result
		end if
		exit function
	end if

	'die glbArgus("strCmd")&"<hr>" &chgStrCmd(glbArgus("strCmd"),"set","ppricetemp",NeedMoney)
	'chgStrCmd

	'loadRet=connectToUp(glbArgus("strCmd"))
	if not api_debug then

		loadRet=connectToUp(chgStrCmd(glbArgus("strCmd"),"set","ppricetemp",NeedMoney))    '���ù��ﳵ�۸�
	else
		loadRet="200 command completed successfully"&vbcrlf&_
				"ip:"&s_comment&".gotoftpXX.com"&vbcrlf&_
				"orderid:3801270"&vbcrlf&_
				"freedomain:"&s_comment&".gotoipXX.com"&vbcrlf&_
				"backupurl:"&vbcrlf&_
				"expdate:"&formatdatetime(dateadd("D",1,now()),2)&""&vbcrlf&_
				"."&vbcrlf
	end if

 	doSuccess=success(loadRet)
	freeDomain=getReturn(loadRet,"freedomain")
	if left(freeDomain,len(s_comment))=s_comment then
		freeDomain=mid(freeDomain,len(s_comment)+2)
	end if
	PArgs.Add "ordersysid",orderid
	PArgs.Add "strServerIp",getReturn(loadRet,"ip")
	PArgs.Add "freedomain",freeDomain
	PArgs.Add "iptype",iptype
	'2013 8-29 ����������/��������ʱ��
	PArgs.Add "giftyears",Giftyear
	if isGift then
		PArgs.Add "free","true"	
	else
		PArgs.Add "free","false"	
	end if

	if not doSuccess then
		PArgs.Add "intOrderStatus",1
	else
		PArgs.Add "intOrderStatus",0
	end if
	
	Call checkorder_site(PArgs)
	ret=PArgs("result")
'die now()&"|"&PArgs.Item("vyears")&"|"&PArgs.Exists("vyears")
	if ret=0 then
		vhost_add_vhost=loadRet
	else
		vhost_add_vhost="500 checkorder error"
	end if
	Set PArgs=nothing

	if isGift and doSuccess then 
		Call gift_opened("vhost",s_comment)
	end if
	
end function

Sub gift_opened(buyType,ident)
	
	attach_type=getInput("attach-type")
	attach_ident=getInput("attach-ident")
	u_id=finduserid(glbArgus("u_name"))

	select case buyType
		case "vhost"
			tb_open_flg="pre2"
			tb_gift_tbname="vhhostlist"
			tb_gift_ident_fd="s_comment"
			tb_gift_owner_fd="s_ownerid"
			tb_gift_sysid_fd="s_sysid"
		case "mssql"
			tb_open_flg="pre4"
			tb_gift_tbname="databaselist"
			tb_gift_ident_fd="dbname"
			tb_gift_owner_fd="dbu_id"
			tb_gift_sysid_fd="dbsysid"
		case "domainname"
			tb_open_flg="pre1"
			tb_gift_tbname="domainlist"
			tb_gift_ident_fd="strdomain"
			tb_gift_owner_fd="userid"
			tb_gift_sysid_fd="d_id"
	end select

	select case attach_type
		case "host"
			tb_name="vhhostlist"
			tb_owner_fd="s_ownerid"
			tb_ident_fd="s_comment"
		case "mail"
			tb_name="mailsitelist"
			tb_owner_fd="m_ownerid"
			tb_ident_fd="m_bindname"
	end select

	Qsql="select " & tb_gift_sysid_fd & " from " & tb_gift_tbname & " where " & tb_gift_owner_fd & "=" & u_id & " and " & tb_gift_ident_fd & "='" & ident & "'"
	Set checkRs=conn.Execute(Qsql)

	if checkRs.eof then
		p_sysid="0"
	else
		p_sysid=checkRs(tb_gift_sysid_fd)
	end if
	checkRs.close
	Set checkRs=nothing

	Qsql="update " & tb_name & " set " & tb_open_flg & "=" & p_sysid & " where " & tb_owner_fd & "=" & u_id & " and " & tb_ident_fd & "='" & attach_ident & "'"
	conn.Execute(Qsql)
end sub

function setftppasswd()
	'�޸�ftp����
	setftppasswd=connectToUp(glbArgus("strCmd"))
	if success(setftppasswd) then
		Set PArgs=CreateObject("Scripting.Dictionary"):Pargs.CompareMode=1
		PArgs.Add "ServerComment",getInput("sitename")
		PArgs.Add "username",glbArgus("u_name")
		PArgs.Add "newpwd",getInput("ftppassword")
		setftppwd PArgs
		Set PArgs=nothing
	end if
end function

Function checkmail(byval p_id,byref m_bindname,byref errstr)
	checkmail=false
sqlstring="Select * from mailsitelist where m_sysid=" & p_id & " and m_ownerid=" & Session("u_sysid")
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="û���ҵ���Ҫ���ѵķ�����":exit function
	m_bindname=rs("m_bindname")
	checkmail=true
end function
function vhost_renew()
	'������������
	s_comment=getInput("sitename")
	s_year=getInput("years")
	u_name=glbArgus("u_name")
	otherip=getInput("otherip")
	p_proid=getFieldValue("s_productid","vhhostlist","s_comment",s_comment)
	u_id=finduserid(u_name)
	if not isNumeric(s_year) then
		vhost_renew="500 ���޲���ȷ"
		exit function
	end if

	if cint(s_year)<1 then
		vhost_renew="500 ���޲���ȷ"
		exit function
	end if
	set u_rs=server.CreateObject("adodb.recordset")
	u_sql="select u_usemoney,u_premoney from UserDetail where u_name='"&u_name&"'"
	u_rs.open u_sql,conn,1,1
	if u_rs.eof or u_rs.bof then
		vhost_renew="500 ���û�������"
		exit function
	else
		u_usemoney=u_rs("u_usemoney")
		u_premoney=u_rs("u_premoney")
	end if
	u_rs.close
	set u_rs=nothing
	NeedMoney=GetNeedPrice(u_name,p_proid,s_year,"renew")	
	if isip(otherip) then

		if lcase(left(p_proid,2))="tw" then
			ipproid="twaddip"
			else
			ipproid="vhostaddip"
		end if
	    	ipprice=getneedprice(u_name,ipproid,s_year,"renew")
		
		if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
		NeedMoney=cdbl(NeedMoney)+cdbl(ipprice)
	else
		sslprice=0
		sqlstring="select top 1 s_ssl,s_sslset from vhhostlist where S_ownerid=" &  u_id & " and s_comment='" & s_comment &" '"
		set chkrs=conn.execute(sqlstring)
		if not chkrs.eof then
			s_ssl=chkrs("s_ssl")
			s_sslset=chkrs("s_sslset")
			if not isnumeric(s_ssl&"") then s_ssl=0
			if not isnumeric(s_sslset&"") then s_sslset=0
			if s_ssl>0 then 
				If s_sslset>0 Then 
					sslprice=getneedprice(u_name,"gfssl",s_year,"renew")
				else
					sslprice=getneedprice(u_name,"vhostssl",s_year,"renew")
				End if
			End if
			NeedMoney=cdbl(NeedMoney)+cdbl(sslprice)
		end if
	end if
	if cdbl(NeedMoney)>cdbl(u_usemoney)+cdbl(u_premoney) then
		vhost_renew="500 ����"
		exit function
	end if 
	
	Set PArgs=CreateObject("Scripting.Dictionary"):Pargs.CompareMode=1
	PArgs.Add "sitename",s_comment
	PArgs.Add "u_name",u_name

    '2013 8-29 ����������/��������ʱ��
	select case s_year
	case 2
	Giftyear=1
	case 3
	Giftyear=2
	case 5
	Giftyear=5
	case 10
	Giftyear=10
	case else
	Giftyear=0
	end select 
	PArgs.add "Giftyear",Giftyear
	PArgs.add "buyyears",s_year
	PArgs.add "otherip",otherip
	
	vhost_renew=connectToUp(glbArgus("strCmd")) 

	if left(vhost_renew,3)=200 then
			Call renewvhost(PArgs)
			ret=PArgs("result")
			Set PArgs=nothing
			if ret>0 then
				vhost_renew="501 " & ret
				exit function
			end If
			Call Set_vcp_record(p_proid,u_id,NeedMoney,s_year,"������������",true)
     else
	       Call addRec("��������ʧ��","��������ʧ��["&s_comment & "],�ϼ�������:" & vhost_renew) 
	       vhost_renew="501 ϵͳ��������ϵ����Ա"
		   exit function	 
	 end if	
	
'	if not success(vhost_renew) then
'		Call addRec("��������ʧ��",s_comment & "���ѿ۳������ϼ�����������ʧ�ܣ����ֹ���ʵ,������:" & vhost_renew) 
'		vhost_renew="200 ok"
'	end if
end function

function vhost_paytest()
'��������ת��
	s_comment=getInput("sitename")
	u_name=glbArgus("u_name")
	p_proid=getFieldValue("s_productid","vhhostlist","s_comment",s_comment)
	s_year=getFieldValue("s_year","vhhostlist","s_comment",s_comment)

	
	
 
	if not CheckEnoughMoney_demo(u_name,p_proid,s_year,"new",true) then
		vhost_paytest="500 ����"
		exit function
	end if
	vhost_paytest=connectToUp(glbARgus("strCmd"))
	if success(vhost_paytest) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "sitename",s_comment
		PArgs.Add "u_name",u_name
		Call PayDemoHost(PArgs)
		ret=PArgs("result"):Set PArgs=nothing
		if ret>0 then
			addRec "����ת������",s_comment & "ת���ɹ������ۿ�ʧ��,���ֹ���ʵ"
		end if
		call doUserSyn("vhost",s_comment)
	end if
end function
function server_set_modinfo()
name=getInput("UserName")
'response.Write("������"&getInput("UserName"))
'response.End()

	serverip=getInput("serverip")
	
	telephone=getInput("telephone")
	address=getInput("address")
	Email=getInput("Email")
	QQ=getInput("QQ")
	fax=getInput("fax")
	RamdomPass=getInput("RamdomPass")
	loadRet=connectToUp(glbArgus("strCmd"))
	'response.Write(requesta("userName"))
	'response.End()
	if success(loadRet) then
		sql="select top 1 * from hostrental where u_name='"& u_name &"' and AllocateIP='"& serverip &"'"
		rs1.open sql,conn,1,3
		if not rs1.eof then
'		2012-8-13 ȡ��ͬ��������ϵ��ʽ
			rs1("Name")=sqlincode(name)
			rs1("telephone")=sqlincode(telephone)
			rs1("address")=sqlincode(address)
			rs1("Email")=sqlincode(Email)
			rs1("QQ")=sqlincode(QQ)
			rs1("fax")=sqlincode(fax)
			rs1("RamdomPass")=sqlincode(RamdomPass)
			rs1.update
			server_set_modinfo="200 ok"
		else
			server_set_modinfo="501 err:server not exist"
		end if
		rs1.close
	else
		server_set_modinfo="500 err:"& loadRet
	end if
end function
function server_set_upgrade()
	result=""
	upgradeCmd=glbArgus("strCmd")
	u_name=glbArgus("u_name")
	serverip=getInput("serverip")
	newproid=getInput("newproid")
	newserverRoom=getInput("newroomid")
	newcdntype=getInput("cdntype")
	blday=getInput("baoliuday")
	set bs=new buyServer_Class:bs.setUserid=finduserid(u_name):bs.oldhostid=serverip
	call bs.getHostdata(serverip)
	call bs.getUpInfo(newproid,newserverRoom,blday)
	oldproid=bs.oldproid
	bs.newproid=newproid
	bs.newRoom=newserverRoom
	bs.newcdn=newcdntype
	bs.blday=blday
	
	upprice=bs.getupneedprice()
	if upprice>bs.u_usemoney then
		server_set_upgrade="400 No Money"
		exit function
	end if
	loadRet=connectToUp(upgradeCmd)
	if success(loadRet) then
		vpsIP=getReturn(loadRet,"vpsIP")
		vpsPassWord=getReturn(loadRet,"vpsPassWord")
		server_set_upgrade = loadRet
		randomize(timer())
		if not consume(u_name,upprice,false,"server-" & Left(Cstr(Clng(rnd()*100000)),6) , "����IP��������" & serverip & "("& oldproid &")��" & vpsIP & "("& newproid &")" ,bs.oldproid,"") then
			addRec "�ۿ�ʧ��","����IP����"& serverip &"������"& vpsIP &"�ɹ����ϼ����ѿۣ����û���δ�ܿ۳���" 
		else
			sql="select * from HostRental where AllocateIP='"& serverip &"' and u_name='"& u_name &"'"
			rs1.open sql,conn,1,3
			if not rs1.eof then
				rs1("AllocateIP")=vpsIP
				rs1("RamdomPass")=vpsPassWord
				rs1("p_proid")=newproid
				rs1("cdntype")=newcdntype
				rs1("serverRoom")=newserverRoom
				rs1.update()
			end if
			rs1.close 	    
		end if
	else
		server_set_upgrade="500 ERR=" & replace(loadRet,vbcrlf," ")
	end if	
end function
function vhost_set_upgrade()
	'��������
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1	
	PArgs.Add "username",glbArgus("u_name")
	PArgs.Add "s_comment",getInput("hostname")
	PArgs.Add "t_productid",getInput("new_proid")
	PArgs.Add "new_room",getInput("new_room")
	PArgs.Add "ismovedata",getInput("ismovedata")
	PArgs.Add "updateType","OldupdateType"
	PArgs.Add "keepip",getInput("keepip")
	toupcmdstr=glbArgus("strCmd")
	Call UpgradeVhost(PArgs)
	ret=PArgs("result"):set Pargs=nothing
	if ret>0 then
		vhost_set_upgrade="500 ����ʧ��" & ret
		exit function
	end if
	vhost_set_upgrade=connectToUp(toupcmdstr)
	if not success(vhost_set_upgrade) then
		addRec "��������ʧ��",getInput("hostname") & "���ѿ۳���������ʧ�ܣ����ֹ�����"
	end if
end function

function domainname_add_domain()
	'��ͨ����
	strDomain=getInput("domainname")
	ppricetemp=getInput("ppricetemp")
	if not isDomain(strDomain) then
		domainname_add_domain="500 ��Ч��������ʽ"
		exit function
	end if
	p_proid=GetDomainType(strDomain)
	if p_proid="domcn" then
		producttype=getInput("producttype")
		if trim(producttype)="domxm" then p_proid="domxm"		
	end if
	gift=getInput("gift")
	isGift=(gift="true")
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
 
	if isGift then
		Call check_valid_gift("domainname",s_year)
	else
		s_year=getInput("term")
	end if

	if not isGift then
	 
	    NeedPrice=GetNeedPrice(u_name,p_proid,s_year,"new")
		'die NeedPrice&"|"&u_name&"|"&p_proid&"|"&s_year
		if ppricetemp<>"" then
			if cdbl(ppricetemp)<cdbl(NeedPrice) then
				domainname_add_domain="500 �������ڳɱ��ۣ�����ϵ����Ա"
				exit function
			end if
		end if


	   '����������
	    if not consume(u_name,NeedPrice,false,"domain-" & strDomain,"buy domain:" & strDomain ,p_proid,"") then
			domainname_add_domain="500 ����"
			exit function
		end if
 
		'if not CheckEnoughMoney(u_name,p_proid,s_year,"new",false) then
		'			domainname_add_domain="500 ����"
		'			exit function
		'		end if		
	end if

	if not api_debug then
	    domainname_add_domain=domainDispatch(glbArgus("strCmd"))
	else
		domainname_add_domain="200 command completed successfully"&vbcrlf&_
						  "orderid:0"&vbcrlf&_
						  "."&vbcrlf
    end if
 	if not success(domainname_add_domain) then
	       call consume(u_name,-NeedPrice,false,"Refunddomain-" & strDomain,"Refund domain:" & strDomain ,p_proid,"")
		   exit function
	end if
 
	domain_fields="dns_host1,dns_ip1,dns_host2,dns_ip2,dom_org,dom_fn,dom_ln,dom_adr1,dom_ct,dom_st,dom_co,dom_pc,dom_ph,dom_fax,dom_em,admi_fn,admi_ln,admi_adr1,admi_ct,admi_st,admi_co,admi_pc,admi_ph,admi_fax,admi_em,tech_fn,tech_ln,tech_adr1,tech_ct,tech_st,tech_co,tech_pc,tech_ph,tech_fax,tech_em,bill_fn,bill_ln,bill_adr1,bill_ct,bill_st,bill_co,bill_pc,bill_ph,bill_fax,bill_em,dom_org_m,dom_fn_m,dom_ln_m,dom_adr_m,dom_ct_m,dom_st_m,admi_org_m,admi_fn_m,admi_ln_m,admi_adr_m,admi_ct_m,admi_st_m"
	domain_fields_array=split(domain_fields,",")
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	for each fieldname in domain_fields_array
		PArgs.Add fieldname,getInput(fieldname)
	next
	'�����������⴦��
	s_memo=""
	if isChinese(strDomain) then		
		kPos=instrRev(strDomain,".")
		suffix=mid(strDomain,kPos+1)
		if not isChinese(suffix) then
			s_memo=punycode(strDomain)
			strDomain=strDomain
		end if
	end if
	'----------------
	
	m_register=getRegister(strDomain)

	PArgs.Add "username",u_name
	PArgs.Add "strdomain",strDomain
	PArgs.Add "strDomainpwd",getInput("domainpwd")
	PArgs.Add "years",s_year
	PArgs.Add "s_memo",s_memo
	PArgs.Add "register",m_register
	if isGift then
		PArgs.Add "free","true"
	else
		PArgs.Add "free","false"
	end if
	Call addnewdomain(PArgs)
	sysid=PArgs("identity")
	result=PArgs("result")

	Set PArgs=nothing

	if result>0 then
	    
		addRec "��������",strDomain & "���ϼ�������ע��ɹ������ۿ�ʧ�ܣ����ֹ���ʵ"
	end if

	if isGift then
		gift_opened "domainname",strDomain
	end if

	'---------���DNS����˾,����������˾DNS����������ע���̲�����˾
	if getInput("dns_host1")=default_dns1 and m_register<>"default" and using_dns_mgr then
		addDnsCmd="dnsresolve" & vbcrlf & "add" & vbcrlf & "entityname:dnsdomain" & vbcrlf & "domainname:" & strDomain & vbcrlf & "term:1" & vbcrlf &"producttype:dns001" & vbcrlf & "domainpwd:" & getInput("domainpwd") & vbcrlf & "." & vbcrlf
		tmpState=connectToUp(addDnsCmd)
		if not success(tmpState) then
			Call AddRec("DNS���ʧ��",strDomain & "��DNS���ʧ�ܣ����ֹ���ʵ")
		end if
	end if
end function

function domainname_mod_passwd()
	'�޸���������
	u_name=glbArgus("u_name")
	strdomain=getInput("domainname")
	newpass=getInput("domainpwd")	
	domainname_mod_passwd=domainDispatch(glbArgus("strCmd"))
	if success(domainname_mod_passwd) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "strDomain",strdomain
		PArgs.Add "username",u_name
		PArgs.Add "domainpwd",newpass

		Call setdomainpwd(PArgs)
		set PArgs=nothing
	end if
end function
function domainname_check() 
	domainname_check=domainDispatch(glbArgus("strCmd"))
end function
function domainname_openurljump(ACT_TYPE)	'shj2010.4

	strdomain=getInput("domainname")
	strUsername=glbArgus("u_name")
	byear=getInput("buyyear")
	urlproid=getInput("entityname")
	
	if ACT_TYPE="open" then 
	tmp1="��ͨ"
	urlneedPrice=getNeedPrice(strUsername,urlproid,byear,"new")
	elseif ACT_TYPE="reopen" then 
	tmp1="����"
	urlneedPrice=getNeedPrice(strUsername,urlproid,byear,"renew")
	Else
	domainname_openurljump
	end If
	
	if not CheckEnoughMoney(strUsername,urlproid,byear,"new",false) then
	domainname_openurljump = "500 Enough Money .."
	Exit function
	end If
	
	tmpResult=connectToUp(glbArgus("strCmd"))

	if success(tmpResult) then
		domainname_openurljump = "200 ok"
		randomize(timer())
		if not consume(strUsername,urlneedPrice,false,"urlfwd-" & Left(Cstr(Clng(rnd()*100000)),6) , strDomain & tmp1 & "URLת��" & byear & "��" ,urlproid,"") then
			addRec "�ۿ�ʧ��",strdomain & tmp1 & "URLת��" & byear & "�ɹ����ϼ����ѿۣ����û���δ�ܿ۳���" 
		end if
	else
		domainname_openurljump = tmpResult
	end if

end function

function domainname_renew()
	'��������
	dim strdomain
	strdomain=getInput("domain")
	u_name=glbArgus("u_name")
	s_year=getInput("term")
	ppricetemp=getInput("ppricetemp")
	p_proid=getDomainType_fromdb(strDomain)
	if not isDomain(strdomain) then
		domainname_renew="500 ������ʽ����"
		exit function
	end if
	if not isNumeric(s_year) then
		domainname_renew="500 ���޲���"
		exit function
	end if
	if Cint(s_year)<1 then
		domainname_renew="500 ���޲���"
		exit function
	end if
	domainRegister=getDomUpReg(strdomain)
    
     NeedPrice=GetNeedPrice(u_name,p_proid,s_year,"renew")
	 
        if not consume(u_name,NeedPrice,false,"renew-" & strdomain,"renew domain:" & strdomain ,p_proid,"") then
          domainname_renew="500 ����"
         exit function
       end if
	
	'if not CheckEnoughMoney(u_name,p_proid,s_year,"renew",false) then
'		domainname_renew="500 ����"
'		exit function
'	end if
	domainname_renew=domainDispatch(glbArgus("strCmd"))	
	if not success(domainname_renew) then
	   call consume(u_name,-NeedPrice,false,"RefundRdomain-" & strDomain,"Refund Rdomain:" & strDomain ,p_proid,"")
	 '   addRec "��������",strDomain & "ע��ʧ�ܣ����ۿ�ʧ�ܣ����ֹ��˷�"
		domainname_renew="500 ����ʧ��,������:" & domainname_renew
	else
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1	
		PArgs.Add "strDomain",strdomain
		PArgs.Add "username",u_name
		PArgs.Add "years",s_year
		Call sp_renewDomain(PArgs)
		ret=PArgs("result"):set PArts=nothing	
		if ret>0 then
			addRec "�������ѳɹ�",strdomain & "�����û���"& ppricetemp &"Ԫʧ�ܣ����ֹ���ʵ"
			domainname_renew="500 �ۿ�ʧ��" & ret
		else
			call renewdnsdomain()
			domainname_renew="200 ok"
		end if		
	end if
end function

sub renewdnsdomain()
	strdomain=getInput("domain")
	Set lrs=conn.execute("select dns_host1,isreglocal,bizcnorder from domainlist where strdomain='" & strdomain & "'")	
	if not lrs.eof then
		dns_host1=lrs("dns_host1")
		xflag=lrs("isreglocal")
		m_register=lrs("bizcnorder")
	else
		exit sub
	end if
	lrs.close
	Set lrs=nothing

	if m_register<>"" and m_register<>"default" and dns_host1=default_dns1 then
		xcmd="domainname" & vbcrlf
		xcmd=xcmd & "renew" & vbcrlf
		xcmd=xcmd & "entityname:domain" & vbcrlf
		xcmd=xcmd & "domain:" & strdomain & vbcrlf
		xcmd=xcmd & "term:1" & vbcrlf
		xcmd=xcmd & "isdns:true" & vbcrlf & "." & vbcrlf

		zzzz=connectToUp(xcmd)

		if not success(zzzz) then
			AddRec "DNS����","ϵͳ�Զ�������" & strdomain & "��DNS����ʧ��"
		end if
	end if
end sub

function mssql_add()
	'��ͨ���ݿ�
	p_proid=getInput("producttype")
	dbname=getInput("databasename")
	u_name=glbArgus("u_name")
	gift=getInput("gift")
	isGift=(gift="true")
	u_id=finduserid(u_name)
	paytype=getInput("paytype")
	
	if isGift then
		s_comment=getInput("attach-ident")
		Set localRs=conn.Execute("select s_year from vhhostlist where s_comment='" & s_comment & "' and s_ownerid=" & u_id)
		if localRs.eof then
			mssql_add="500 ҵ�񲻴���"
			exit function
		end if
		s_year=localRs("s_year")
		localRs.close:set localRs=nothing
	else
		s_year=getInput("years")
	end if

	if paytype="0" and not isGift then
		if not CheckEnoughMoney(u_name,p_proid,s_year,"new",true) then
			mssql_add="500 ����"
			exit function
		end if
	elseif paytype="1" then
		if not CheckEnoughMoneyForDemo(u_name,demomssqlprice) then
			mssql_add="500 ����,���ܿ�ͨ����Mssql"
		end if
	end if

	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "databaseuser",dbname
	PArgs.Add "databasename",dbname
	PArgs.Add "dbupassword",getInput("dbupassword")
	PArgs.Add "proid",p_proid
	PArgs.Add "username",u_name
	PArgs.Add "years",s_year
	PArgs.Add "p_type",paytype

	Call addmssql(PArgs)
	ret=PArgs("result")
	if ret>0 then
		mssql_add="500 ��Ӷ���ʧ��" & ret
		exit function
	end if
	
	sysid=PArgs("identity")
	orderid=PArgs("ordersysid")
    if not api_debug then
		mssql_add=connectToUp(glbArgus("strCmd"))
	else
		mssql_add="200 command completed successfully"&vbcrlf&_
					  "ip:sql.m45.vhostgo.com"&vbcrlf&_
					  "orderid:23"&vbcrlf&_
					  "."&vbcrlf
	end if
	PArgs.RemoveAll

	PArgs.Add "ordersysid",orderid
	if not success(mssql_add) then
		PArgs.Add "strServerIp","no"
	else
		PArgs.Add "strServerIp",getReturn(mssql_add,"ip")
	end if

	if isGift then
		PArgs.Add "free","true"
	else
		PArgs.Add "free","false"
	end if
	
	Call checkorder_mssql(PArgs)
	ret=PArgs("result")

	if ret>0 then
		addRec "���ݿ�����",dbname & "��ͨ�ɹ������ۿ�ʧ��,���ֹ���ʵ"
	end if
	Set PArgs=nothing

	if isGift and success(mssql_add) then 
		Call gift_opened("mssql",dbname)
	end if

end function

function mssql_mod_pwd()
	'�޸����ݿ�����
	dbname=getInput("databasename")
	u_name=glbArgus("u_name")
	newpwd=getInput("dbupassword")

	mssql_mod_pwd=connectToUp(glbArgus("strCmd"))
	
	if success(mssql_mod_pwd) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "dbname",dbname
		PArgs.Add "dbpasswd",newpwd
		PArgs.Add "username",u_name

		Call setdbpwd(PArgs)
		Set PArgs=nothing
	end if
end function

function mssql_renew()
	'���ݿ�����
	u_name=glbArgus("u_name")
	dbname=getInput("databasename")
	s_year=getInput("years")
	p_proid=getFieldValue("dbproid","databaselist","dbname",dbname)

	if not CheckEnoughMoney(u_name,p_proid,s_year,"renew",true) then
		mssql_renew="500 ����"
		exit function
	end if

	mssql_renew=connectToUp(glbArgus("strCmd"))
	
	if success(mssql_renew) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "databasename",dbname
		PArgs.Add "u_name",u_name
		PArgs.Add "buyyears",s_year

		Call Renewmssql(PArgs)

		ret=PArgs("result"):Set PArgs=nothing

		if ret>0 then
			AddRec "���ݿ���������",dbname & "����" & s_year & "�ɹ������ۿ�ʧ�ܣ����ֹ���ʵ"
		end if
	end if
end function

function corpmail_add()
	'��ͨ�ʾ�
	entityname=getInput("entityname")
	domainname=getInput("domainname")
	postmater=getInput("mailmaster")
	paytype=getInput("paytype")
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
	p_proid=getInput("producttype")
	isGift=(entityname="freecorpmail")

	if not isDomain(domainname) then
		corpmail_add="500 ��Ч������"
		exit function
	end if

	if not isNumeric(paytype) then
		corpmail_add="500 ��ͨ���Ͳ���ȷ"
		exit function
	end if

	if not regCheck("[\w\_\-]+",postmater) then
		corpmail_add="500 postmaster�����Ƿ�"
		exit function
	end if

	if isGift then
		s_comment=getInput("sitename")
		Set localRs=conn.Execute("select s_year from vhhostlist where s_comment='" & s_comment & "' and s_ownerid=" & u_id)
		if localRs.eof then
			corpmail_add="500 ��Ӧ����������"
			exit function
		end if
		s_year=localRs("s_year")
		localRs.close:set localRs=nothing
	else
		s_year=getInput("years")
	end if

	if not isNumeric(s_year) then
		corpmail_add="500 ���޲���ȷ"
		exit function
	end if

	if cint(s_year)<1 then
		corpmail_add="500 ���޲���ȷ"
		exit function
	end if
	
'	select case cint(s_year)
'	case 2
'	e_year=s_year+1
'	case 3
'	e_year=s_year+2
'	case 5
'	e_year=s_year+5
'	case 10
'	e_year=s_year+10
'	case else
	e_year=s_year
'	end select
	
'	die e_year
    if trim(p_proid)="diymail" then
			mailsize=getInput("mailsize")
			usernum=getInput("usernum")
            m_price=getDiyMailprice(mailsize,usernum)
	       if not CheckEnoughMoneydiy(u_name,m_price,s_year,true) then
				corpmail_add="500 ����"
				exit function
			end if
	else
		if paytype="0" and not isGift then
			if not CheckEnoughMoney(u_name,p_proid,s_year,"new",true) then
				corpmail_add="500 ����"
				exit function
			end if
		elseif paytype="1" then
			if not CheckEnoughMoneyForDemo(u_name,demomailprice) then
				corpmail_add="500 ����,���ܿ�ͨ�����ʾ�"
			end if
		end if
    end if
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "m_mastername",postmater
	PArgs.Add "m_bindname",domainname
	PArgs.Add "username",u_name
	PArgs.Add "m_productId",p_proid
	PArgs.Add "m_password",getInput("password")
	PArgs.Add "m_years",s_year
	PArgs.Add "p_type",paytype
	Pargs.Add "e_years",e_year
	PArgs.Add "mailsize",mailsize
	PArgs.Add "usernum",usernum
	
	Call addnewmail(PArgs)

	ret=PArgs("result")

	if ret>0 then
		corpmail_add="500 �������ʧ��" & ret
		exit function
	end if

	sysid=PArgs("identity")
	orderid=PArgs("ordersysid")
 
	if not api_debug then
		corpmail_add=connectToUp(glbArgus("strCmd"))
	else

		corpmail_add="200 Command completed successfully"&vbcrlf&_
					 "MailIp:127.0.0.1"&vbcrlf&_
					 "orderid:109668"
	end if
	doSuccess=success(corpmail_add)


	PArgs.removeAll
	PArgs.Add "ordersysid",orderid
	PArgs.Add "mailsize",mailsize
	PArgs.Add "usernum",usernum
' die orderid
	if not doSuccess then
		PArgs.Add "strServerIp","no"
	else
		PArgs.Add "strServerIp",getReturn(lcase(corpmail_add),"mailip")
	end if
	if isGift then
		PArgs.Add "free","true"	
	else
		PArgs.Add "free","false"
	end if
 
	Call checkorder_mail(PArgs)
	ret=PArgs("result")

	if doSuccess and ret>0 then
		addRec "�ʾֿۿ�ʧ��",domainname &"��ͨ�ɹ������ۿ�ʧ�ܣ����ֹ���ʵ"
	end if

	if isGift and doSuccess then
		conn.Execute("update vhhostlist set s_mid=" & sysid & " where s_comment='" & s_comment & "'")
	end if

	Set PArgs=nothing
end function

function corpmail_mod_pwd()
	'�޸��ʾ�����
	m_bindmae=getInput("domainname")
	u_name=glbArgus("u_name")
	mailpasswd=getInput("upassword")

	corpmail_mod_pwd=connectToUp(glbArgus("strCmd"))
	if success(corpmail_mod_pwd) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "m_bindname",m_bindmae
		PArgs.Add "username",u_name
		PArgs.Add "mailpasswd",mailpasswd

		Call setmailpwd(PArgs)
		set PArgs=nothing
	end if
end function

function corpmail_renew()
	'�ʾ�����
	u_name=glbArgus("u_name")
	m_bindname=getInput("domainname")
	s_year=getInput("years")

	if not isDomain(m_bindname) then
		corpmail_renew="500 ��Ч������"
		exit function
	end if
	p_proid=getFieldValue("m_productid","mailsitelist","m_bindname",m_bindname)

	if p_proid="" then
		corpmail_renew="500 �ʾֲ�����"
		exit function
	end if
	if not isNumeric(s_year) then
		corpmail_renew="500 ���޲���ȷ"
		exit function
	end if

	if cint(s_year)<1 then
		corpmail_renew="500 ���޲���ȷ"
		exit function
	end if

   if p_proid="diymail" then
 
		sqlstring="SELECT * FROM mailsitelist where m_ownerid="&finduserid(u_name)&"  and m_bindname='"& m_bindname &"'"
		set mrs=conn.execute(sqlstring)
        if mrs.eof and mrs.bof then die "err"
        m_price=getDiyMailprice(mrs("m_size")/mrs("m_mxuser"),mrs("m_mxuser"))
	    if not CheckEnoughMoneydiy(u_name,m_price,s_year,true) then
		corpmail_renew="500 ����"
		exit function
		end if
 
   else
	if not CheckEnoughMoney(u_name,p_proid,s_year,"renew",true) then
		corpmail_renew="500 ����"
		exit function
	end if
   end if


    corpmail_renew=connectToUp(glbArgus("strCmd"))
	if instr(corpmail_renew,"���ϴ�����ʱ��")>0 then
	    AddRec "�ʾ�����ʧ��","�ʾ�����ʧ��["&m_bindname & "]�ϼ�����:"&corpmail_renew&",�����Ƿ�۷�"
		corpmail_renew="500 ϵͳ��������ϵ����Ա"
		exit function
	end if
	
	
	if success(corpmail_renew) then
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "mailname",m_bindname
		PArgs.Add "u_name",u_name
		PArgs.Add "buyyears",s_year

		Call Renewmail(PArgs)
		ret=PArgs("result"):Set PArgs=nothing

		if ret>0 then
			AddRec "�ʾ���������",m_bindname & "���ѳɹ������ۿ�ʧ�ܣ����ֹ���ʵ" 
		end if
	end if
end function

function other_get_tablecontent()
	'ͬ����Ʒ�б�
	other_get_tablecontent=connectToUp(glbArgus("strCmd"))
	

'	die other_get_tablecontent
	if success(other_get_tablecontent) then
		fdlist=getReturn(other_get_tablecontent,"fieldlist")
		 
		rrset=getReturn_rrset(other_get_tablecontent,"recordset")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1 
		
		PArgs.Add "tbname",getInput("tbname")
		PArgs.Add "update",getInput("update")
		PArgs.Add "fdlist",fdlist
		PArgs.Add "recordset",rrset

		Call updateProduct(PArgs)

		ret=PArgs("result")

		if ret>0 then
			other_get_tablecontent="500 ͬ��ʧ��" & ret
		else
			other_get_tablecontent="200 ͬ���ɹ�"
		end if
	end if
end function
function other_get_compare()
'��ȡ�ɱ���
	other_get_compare="400 err"
	other_get_compare1=connectToUp(glbArgus("strCmd"))
	
	if success(other_get_compare1) then
		getproduct=getInput("getproduct")
		if getproduct="all_product" then
			for each priceitem in split(right(other_get_compare1,len(other_get_compare1)-3),"|")

				if instr(priceitem,":")>0 then
					parr=split(priceitem,":")
					if ubound(parr)>0 then
						getproduct=trim(parr(0))
						getprice=trim(parr(1))
						if len(getproduct)>0 then
							if len(getPrice)<=0 then getPrice=0
							if isnumeric(getPrice) then
								conn.execute "update productlist set p_costPrice="& getPrice &" where P_proId='"& getproduct &"'"
								other_get_compare="200 ok"
							end if
						end if
					end if
				end if
			next
		else
			get_compare=trim(right(other_get_compare1,len(other_get_compare1)-3))
			if instr(get_compare,":")>0 then
					parr=split(get_compare,":")
					if ubound(parr)>0 then
						getproduct=parr(0)
						getprice=parr(1)
						if len(getproduct)>0 then
							if len(getPrice)<=0 then getPrice=0
							if isnumeric(getPrice) then
							conn.execute "update productlist set p_costPrice="& getPrice &" where P_proId='"& getproduct &"'"
							other_get_compare="200 ok"
							end if
						end if
					end if
			end if
		end if
	end if
	other_get_compare=other_get_compare & vbcrlf & _
					  other_get_compare1 & vbcrlf & "." & vbcrlf
end function
function other_get_ftppassword()
'��ȡFTP����
	u_name=glbArgus("u_name")
	sitename=getInput("sitename")
	other_get_ftppassword=connectToUp(glbArgus("strCmd"))
	
	if success(other_get_ftppassword) then
		ftppassword=getReturn(other_get_ftppassword,"ftppassword")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "ServerComment",sitename
		PArgs.Add "username",u_name
		PArgs.Add "newpwd",ftppassword

		Call setftppwd(PArgs)
		ret=PArgs("result"):Set PArgs=nothing
		if ret>0 then
			other_get_ftppassword="500 ҵ�񲻴��� " & ret
		end if
	end if
end function

function other_get_mailpassword()
'��ȡ�ʾ�����
	u_name=glbArgus("u_name")
	domainname=getInput("domainname")
	other_get_mailpassword=connectToUp(glbArgus("strCmd"))

	if success(other_get_mailpassword) then
		mailpassword=getReturn(other_get_mailpassword,"mailpassword")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "m_bindname",domainname
		PArgs.Add "username",u_name
		PArgs.Add "mailpasswd",mailpassword

		Call setmailpwd(PArgs)
		ret=PArgs("result"):Set PArgs=nothing
		if ret>0 then
			other_get_mailpassword="500 ҵ�񲻴��� " & ret
		end if
	end if
end function

function other_get_mssqlpassword()
'��ȡ���ݿ�����
	u_name=glbArgus("u_name")
	databasename=getInput("databasename")
	other_get_mssqlpassword=connectToUp(glbArgus("strCmd"))
	if success(other_get_mssqlpassword) then
		mssqlpassword=getReturn(other_get_mssqlpassword,"mssqlpassword")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "dbname",databasename
		PArgs.Add "username",u_name
		PArgs.Add "dbpasswd",mssqlpassword

		Call setdbpwd(PArgs)
		ret=PArgs("result"):Set PArgs=nothing
		if ret>0 then
			other_get_mssqlpassword="500 ҵ�񲻴��� " & ret
		end if
	end if
end function

function other_get_usemoney()
'��ȡ���ý��
	other_get_usemoney=connectToUp(glbArgus("strCmd"))
end function

function other_get_domainpassword()
	'��ȡ��������
	u_name=glbArgus("u_name")
	domainname=getInput("domainname")
	other_get_domainpassword=domainDispatch(glbArgus("strCmd"))

	if success(other_get_domainpassword) then
		domainpassword=getReturn(other_get_domainpassword,"domainpassword")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "strDomain",domainname
		PArgs.Add "username",u_name
		PArgs.Add "domainpwd",domainpassword

		Call setdomainpwd(PArgs)
		ret=PArgs("result"):Set PArgs=nothing
		if ret>0 then
			other_get_domainpassword="500 ҵ�񲻴��� " & ret
		end if
	end if
end function

Function getReturn_rrset2(content,title)
	On Error Resume Next
	Dim postr,s1,s2
	postr = title & ":"
	s1=InStr(content,postr)
	If s1>1 Then
		s1 = s1+Len(postr)
		s2 = InStr(s1,content,vbCrLf)
		getReturn_rrset2=Mid(content,s1, s2-s1)
	End If
End Function 

function other_get_question()
	'��ȡ���ʱش�����
	u_name=glbArgus("u_name")
	q_id=getInput("q_id")
	if not isNumeric(q_id) then
		other_get_question="500 ��Ч������id"
		exit function
	end if

	Set localRs=conn.Execute("select q_status,q_reply_content,q_parentID from question where q_id=" & q_id & " and q_user_name='" & u_name & "'")
	if localRs.eof then
		other_get_question="500 �����ⲻ����"
		exit function
	end if

	replyStatus=localRs("q_status")
	replyContent=localRs("q_reply_content")
	q_parentID=localRs("q_parentID")

	if not replyStatus then
		other_get_question="200 ok" & vbcrlf & "reply:" & replyContent & vbcrlf & "." & vbcrlf
		exit function	
	end if

	if isNumeric(q_parentID) and q_parentID>0 then
				q_cmd="other" & vbcrlf & "get" & vbcrlf & "entityname:question" & vbcrlf & "q_id:" & q_parentID & vbcrlf & "." & vbcrlf
				q_answer=connectToUp(q_cmd)
				if left(q_answer,3)="200" Then
					q_reply_time=getReturn(q_answer,"reply_time")
					q_p_reply=getReturn_rrset(q_answer,"reply")
					q_state_new=getReturn(q_answer,"state_new")
					If Not isdate(q_reply_time) Then
						q_reply_time=Now()
					End If

					If Not IsNumeric(q_state_new&"") Then
						q_state_new=0
					End If

					sql="select * from question where q_id=" & q_id
					rs11.open sql,conn,3,3
					rs11("q_reply_time")=q_reply_time
					rs11("q_status")=False
					rs11("q_reply_content")=q_p_reply
					rs11("q_state_new") = q_state_new
					q_fid = rs11("q_fid")
					rs11.update
					rs11.close
					If q_fid>0 Then 
						conn.execute("update question set q_state_new=" & q_state_new & " where q_fid=0 and q_id=" & q_fid)
					End if
'					conn.Execute("update question set q_reply_time=now(),q_status=false,q_reply_content='" & q_p_reply & "' where q_id=" & q_id )
	
	'other_get_question="200 ok" & vbcrlf & "reply:" & q_p_reply & vbcrlf & "." &  vbcrlf
	other_get_question="200 ok" & vbcrlf
	other_get_question=other_get_question & "reply_time:" & q_reply_time & vbcrlf
	other_get_question=other_get_question & "state_new:" & q_state_new & vbcrlf
	other_get_question=other_get_question & "reply:" & q_p_reply & vbcrlf & "." & vbcrlf

				else
					other_get_question="501 ����δ�ظ�"
				end if
	else
		other_get_question="502 ����δ�ظ�"
	end if
end function

function other_get_invoice()
	'��ȡ��Ʊ״̬
	u_name=glbArgus("u_name")
	f_id=getInput("identity")
	set lrs=conn.Execute("select f_fid,f_status,f_senddate,f_reject from fapiao where f_username='" & u_name & "' and f_id=" & f_id )
	if lrs.eof then
			other_get_invoice="500 ��Ʊ������"
			exit function
	end if
	f_fid=lrs("f_fid")
	f_status=lrs("f_status")
	f_senddate=lrs("f_senddate")
	f_reject=lrs("f_reject")
	
	lrs.close:set lrs=nothing
	
	if (f_status=0 or f_status=1) and isNumeric(f_fid) then
		if f_fid>0 then
			newStrCmd=chgStrCmd(glbArgus("strCmd"),"set","identity",f_fid)
			loadRet=connectToUp(newStrCmd)
			if success(loadRet) then
				f_status_f=getReturn(loadRet,"invoicecode")
				f_senddate_f=getReturn(loadRet,"postdate")
				f_appinfo_f=getReturn(loadRet,"appinfo")
				
				f_status=f_status_f
				
				select case f_status_f
					case "2"
						QState=",f_SendDate=#" & f_senddate_f & "#"
						f_senddate=f_senddate_f
					case "3"
						QState=",f_reject='" & f_appinfo_f & "'"
						f_reject=f_appinfo_f
					case else
						QState=""						
				end select
				conn.Execute("update fapiao set f_status=" & f_status & QState & " where f_id=" & f_id)
			end if
		end if
	end if
	other_get_invoice="200 ok" & vbcrlf & "invoicecode:" & f_status & vbcrlf & "postdate:" & f_senddate & vbcrlf & "appinfo:" & f_reject & vbcrlf & "." & vbcrlf
end function

function other_upgrade_mail()
	'��ҵ�ʾ�����
	m_bindname=getInput("domain")
	username=glbArgus("u_name")
	t_productid=getInput("TargetProductid")
	updateType="NewupdateType"  '�������͹̶�ѡ��Ϊ��ͨ���ڰ�������
	updateType="OldupdateType"  '����

	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "m_bindname",m_bindname
	PArgs.Add "username",username
	PArgs.Add "t_productid",t_productid
	PArgs.Add "updateType",updateType

	Call UpgradeMail(PArgs)
	ret=PArgs("result"):Set PArgs=nothing

	if ret>0 then
		other_upgrade_mail="500 ���㣬����ʧ��"
		exit function
	end if
	
	other_upgrade_mail=connectToUp(glbArgus("strCmd"))

	if not success(other_upgrade_mail) then
		AddRec "�ʾ���������",m_bindname & "�ʾ������ۿ�ɹ��������ϼ�����������ʧ�ܣ����ֹ�����,������:" & other_upgrade_mail
		other_upgrade_mail="200 �����ɹ�"
	end if
end function

function other_upgrade_mssql()

  
	'���ݿ�����
	dbname=getInput("databasename")
	username=glbArgus("u_name")
	t_productid=getInput("TargetProductid")
	new_room=getInput("new_room")
	'updateType="NewupdateType" '�������͹̶�ѡ��Ϊ��ͨ���ڰ�������

	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "dbname",dbname
	PArgs.Add "username",username
	PArgs.Add "t_productid",t_productid
	PArgs.Add "new_room",new_room
	toupcmdstr=glbArgus("strCmd")
	Call UpgradeMssql(PArgs)
	ret=PArgs("result"):Set PArgs=nothing	
	if ret>0 then
		other_upgrade_mssql="500 ���㣬����ʧ��"
		exit function
	end if
	other_upgrade_mssql=connectToUp(toupcmdstr) 
	if not success(other_upgrade_mssql) then
		other_upgrade_mssql="200 �����ɹ�"
		AddRec "���ݿ���������",dbname & "���ݿ������ۿ�ɹ��������ϼ�����������ʧ�ܣ����ֹ�����,������:" & other_upgrade_mssql
	end if
end function

function other_add_invoice()
	'�ύ��Ʊ
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "username",glbArgus("u_name")
	PArgs.Add "subject",getInput("subject")
	PArgs.Add "fundamount",getInput("fundamount")
	PArgs.Add "purpose",getInput("purpose")
	PArgs.Add "postcode",getInput("postcode")
	PArgs.Add "receiver",getInput("receiver")
	PArgs.Add "telephone",getInput("telephone")
	PArgs.Add "address",getInput("address")
	PArgs.Add "sendtype",getInput("sendtype")
	PArgs.Add "receive_cp",getInput("receive_cp")
	PArgs.Add "memo",getInput("memo")
	PArgs.Add "taxcode",getInput("taxcode") 


	'�����ڱ��ӿڴ�����飬�Է��¼������ύ�Ĵ�����������,	'������Ч����ٱ��棬�������ֶε���Ϣ���ظ��ύ�����

	inputvalue = getInput("subject")
	if len(inputvalue)<5 then
		other_add_invoice="500 ��ƱͶͷ�����ǹ�˾����"
		exit function
	end if
	inputvalue = PArgs("address")
	If InStr(inputvalue,"�Ϻ�")=0 And InStr(inputvalue,"����")=0 And InStr(inputvalue,"���")=0 And InStr(inputvalue,"����")=0 Then
		If InStr(inputvalue,"ʡ")=0 Or InStr(inputvalue,"��")=0 Then
			other_add_invoice="500 ��ַ����ϸ,�������xxʡxx�С�"
			exit function
		End If
	End If
	inputvalue = PArgs("fundamount")
	if not isnumeric(inputvalue) or inputvalue<1  then
		other_add_invoice="500 ��Ʊ������"
		exit function
	end if
	sql="select 1 from fapiao where f_username='" & PArgs("username") & "' and f_status=0 and f_address='" & PArgs("address") & "' and f_title='" & PArgs("subject") & "'"
	set trs=conn.execute(sql)
	if not trs.eof then
		other_add_invoice="500 �����ظ��ύ��Ʊ������ɾ������ύ����ͬ��Ʊ�����һ���ۼӺ������ύ��"
		exit function
	end if
	trs.close
	
	
	
	
	
	
	
	
	


	if fapiao_api then
	
	Call subInvoice(PArgs)
			
				if PArgs.Exists("invoiceid") then
					invoiceid=PArgs("invoiceid")
				end if
				
				ret=PArgs("result"):Set PArgs=nothing
				
				if ret=3000 then
					other_add_invoice="500 ���ý�����֧����Ʊ�ʷ�"
					exit function
				end if
			
				if ret>0 then
					other_add_invoice="500 ��Ʊ����ʧ��"
					exit function
				end if
	
	
	
		loadret=connectToUp(glbArgus("strCmd"))
		if not success(loadret) then
			AddRec "��Ʊ���⣺",glbArgus("u_name") & "�ύ���ϼ���ʧ�ܣ�Code=" & loadret
			other_add_invoice=loadret
			 exit function
		else
		
			
		
		
		
			f_fid=getReturn(loadret,"identity")
			if isNumeric(invoiceid) and isNumeric(f_fid) then
				conn.Execute("update fapiao set f_fid=" & f_fid & " where f_id=" & invoiceid)
			end if
			
			other_add_invoice="200 ok" & vbcrlf & "identity:" & invoiceid & vbcrlf &"." & vbcrlf
		end if
		
		
		
		else
				'��������Ʊ���
				Call subInvoice(PArgs)
			
				if PArgs.Exists("invoiceid") then
					invoiceid=PArgs("invoiceid")
				end if
				
				ret=PArgs("result"):Set PArgs=nothing
				
				if ret=3000 then
					other_add_invoice="500 ���ý�����֧����Ʊ�ʷ�"
					exit function
				end if
			
				if ret>0 then
					other_add_invoice="500 ��Ʊ����ʧ��"
					exit function
				end if
						other_add_invoice="200 ok" & vbcrlf & "identity:" & invoiceid & vbcrlf &"." & vbcrlf
	end if

end function

function other_add_question()
	'�ύ���ʱش�
	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	fid=getInput("fid")
	pic=getInput("pic")
	if not isNumeric(fid) or fid&""="" then fid=0

	PArgs.Add "username",glbArgus("u_name")
	PArgs.Add "subject",getInput("subject")
	PArgs.Add "domain",getInput("domain")
	PArgs.Add "type",getInput("type")
	content=getReturn_rrset(glbArgus("strCmd"),"content")
	PArgs.Add "content",content
	PArgs.Add "pic",pic
	PArgs.Add "fid",fid

	Call subQuestion(PArgs)
	ret=PArgs("result")
	qid=PArgs("qid")
	Set PArgs=Nothing
	
	If IsNumeric( fid&"" ) Then
		sql0="update question set q_state_new=0 where q_id=" & fid ' & " OR q_id=" & q_id 
		Conn.execute(sql0)
	End if

	if blSubmitQuestion(getInput("type")) then
		if fid>0 then
			Set lrs=conn.Execute("select q_parentID from question where q_id=" & fid)
			if not lrs.eof then
				fid=lrs("q_parentID")
			else
				fid=0
			end if
			lrs.close:set lrs=nothing
		end if
		newStrCmd=chgStrCmd(glbArgus("strCmd"),"set","fid",fid)
		loadret=connectToUp(newStrCmd)
		if success(loadret) then
			ffid=getReturn(loadret,"identity")
			conn.Execute("update question set q_parentID=" & ffid & " where q_id=" & qid)
		else
			AddRec "���ʱش�",u_name & "�ύ�����ʱش�" & getInput("subject") &"���ϼ��������ύʧ��,������:" & loadret
		end if
	end if

	other_add_question="200 ok" & vbcrlf
	other_add_question=other_add_question & "identity:" & qid & vbcrlf & "." & vbcrlf
end function
function other_paytest_mssql()
	'����mssqlת��

	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "dbname",getInput("dbname")
	PArgs.Add "u_name",glbArgus("u_name")
	Call PayDemoMssql(PArgs)
	ret=PArgs("result"):Set PArgs=nothing

	if ret>0 then
		other_paytest_mssql="500 ת��ʧ�ܣ�����" & ret
		exit function
	end if
	other_paytest_mssql=connectToUp(glbArgus("strCmd"))
	if not success(other_paytest_mssql) then
		other_paytest_mssql="200 ok"
		AddRec "MSSQL����","MSSQL" & getInput("dbname") & "ת���ۿ�ɹ��������ϼ�������ת��ʧ�ܣ����ֹ�����"
	end if
end function
function other_paytest_mail()
	'�����ʾ�ת��

	Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
	PArgs.Add "m_bindname",getInput("domain")
	PArgs.Add "u_name",glbArgus("u_name")
	Call PayDemoMail(PArgs)
	ret=PArgs("result"):Set PArgs=nothing

	if ret>0 then
		other_paytest_mail="500 ת��ʧ�ܣ�����" & ret
		exit function
	end if

	other_paytest_mail=connectToUp(glbArgus("strCmd"))

	if not success(other_paytest_mail) then
		other_paytest_mail="200 ok"
		AddRec "�ʾ�����","�ʾ�" & getInput("domain") & "ת���ۿ�ɹ��������ϼ�������ת��ʧ�ܣ����ֹ�����"
	end if
end function

function privite_sync_data(ByVal tbname)
	u_name=glbArgus("u_name")
	tbname=tbname
	privite_sync_data=connectToUp(glbArgus("strCmd"))
	if success(privite_sync_data) then
		fdlist=getReturn(privite_sync_data,"fdlist")
		rrset=getReturn_rrset(privite_sync_data,"recordset")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1

		PArgs.Add "ownername",u_name
		PArgs.Add "tbname",tbname
		PArgs.Add "fdlist",fdlist
		PArgs.Add "recordset",rrset

		Call SynData(PArgs)
			
		ret=PArgs("result"):Set PArgs=nothing

		if ret>0 then
			privite_sync_data="500 ͬ��ʧ��." & ret
		else
			privite_sync_data="200 ͬ���ɹ�"
		end if
	end if	
end function

function other_sync_vhost()
	'ͬ����������
	other_sync_vhost=privite_sync_data("vhhostlist")
end function

function other_sync_domain()
	'ͬ������
	other_sync_domain=privite_sync_data("domainlist")
end function

function other_sync_mail()
	'ͬ���ʾ�
	other_sync_mail=privite_sync_data("mailsitelist")
end function
function other_sync_server()
	'ͬ�����ݿ�
	other_sync_server=privite_sync_data("hostrental")
end function
function other_sync_database()
	'ͬ�����ݿ�
	other_sync_database=privite_sync_data("databaselist")
end function

function other_sync_allpassword()
	'ͬ����������
	other_sync_allpassword=connectToUp(glbArgus("strCmd"))
	if success(other_sync_allpassword) then
		rrset=getreturn_rrset(other_sync_allpassword,"recordset")
		Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
		PArgs.Add "recordset",rrset
		Call synPasswd(PArgs)
		ret=PArgs("result"):Set PArgs=nothing

		if ret>0 then
			other_sync_allpassword="500 ͬ��ʧ��"
		else
			other_sync_allpassword="200 ͬ���ɹ�"
		end if
	end if
end function

function other_add_sms()
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
	Set lrs=conn.Execute("select * from mailsitelist where m_bindname='" & getInput("domainname") & "' and m_ownerid=" & u_id)
	if lrs.eof then
		other_add_sms="500 �޴��ʾ�"
		exit function
	end if
	lrs.close:set lrs=nothing

	other_add_sms=connectToUp(glbArgus("strCmd"))
end function

sub check_valid_gift(ByVal buyType,ByRef getYears)
	u_id=finduserid(glbArgus("u_name"))
	attach_type=getInput("attach-type")
	attach_ident=getInput("attach-ident")

	select case buyType
		case "vhost"
			gift_p_proid=getInput("producttype")

			tb_open_flg="pre2"
			tb_gift_list="freeproid2"
		case "domainname"
			gift_p_proid=GetDomainType(getInput("domainname"))

			tb_open_flg="pre1"
			tb_gift_list="freeproid1"
		case "mssql"
			gift_p_proid=getInput("producttype")

			tb_open_flg="pre4"
			tb_gift_list="freeproid4"
		case "mysql"
			gift_p_proid=getInput("producttype")

			tb_open_flg="pre3"
			tb_gift_list="freeproid3"
	end select
	

	select case attach_type
		case "mail"
			tb_name="mailsitelist"
			tb_fd_owner="m_ownerid"
			tb_proid_name="m_productId"
			tb_years_name="m_years"
			tb_fd_ident="m_bindname"
			tb_fd_test="m_buytest"
			tb_reg_time="m_buydate"

			Set freeRs=conn.Execute("select m_free from mailsitelist where m_bindname='" & attach_ident & "'")
			if not freeRs.eof then
				if freeRs("m_Free") then
					Response.write "500 ����ʾֲ��ܻ�ȡ��Ʒ"
					Response.end
				end if
			end if
			freeRs.close:Set freeRs=nothing
		case "host"
			tb_name="vhhostlist"
			tb_fd_owner="s_ownerid"
			tb_proid_name="s_productid"
			tb_years_name="s_year"
			tb_fd_ident="s_comment"
			tb_fd_test="s_buytest"
			tb_reg_time="s_buydate"
			
			Set freeRs=conn.Execute("select m_sysid from mailsitelist where pre2=(select s_sysid from vhhostlist where s_comment='" & attach_ident & "')")
			if not freeRs.eof then
					Response.write  "500 ���͵��������ܻ�ȡ��Ʒ"
					Response.end
			end if
			freeRs.close:Set freeRs=nothing
		case else
			 Response.write "500 ��Ч����������"
			 Response.end
	end select

	QState="select " & tb_years_name & "," & tb_open_flg & "," & tb_proid_name & "," & tb_fd_test & "," & tb_reg_time & " from " & tb_name & " where " & tb_fd_owner & "=" & u_id & " and " & tb_fd_ident & " ='" & attach_ident & "'"
	Set checkRs=conn.Execute(QState)
	if checkRs.eof then 
		Resposne.write "500 ����ҵ�񲻴���"
		Response.end
	end if
	tb_val_proid=checkRs(tb_proid_name)
	tb_val_open=checkRs(tb_open_flg)
	tb_val_years=checkRs(tb_years_name)
	tb_val_test=checkRs(tb_fd_test)
	tb_val_buydate=checkRs(tb_reg_time)

	checkRs.close
	Set checkRs=nothing

	if datediff("d","2008-5-1",tb_val_buydate)<0 then 
		Resposne.write "ֻ����ע���ҵ��ſ��Դ˷�ʽ��ȡ��Ʒ"
		Response.end
	end if
	if tb_val_test then 
		Response.write "����ҵ�������ȡ��Ʒ"
	end if

	if tb_val_open<>"" then 
		Resposne.write "��Ʒ�Ѿ���ȡ"
		Response.end
	end if

	Sql="select " & tb_gift_list & " from protofree where proid='" & tb_val_proid & "'"

	Set checkRs=conn.Execute(Sql)
	if checkRs.eof then
		checkRs.close:set checkRs=nothing
		Response.write "��ҵ��û����Ʒ"
		Response.end
	end if
	
	tb_val_giftlist=checkRs(tb_gift_list)

	checkRs.close:set checkRs=nothing

	if tb_val_giftlist="" then 
		Response.write "��ҵ��û����Ʒ"
		Response.end
	end if
	if instr(tb_val_giftlist,gift_p_proid)=0 then 
		Response.write "�ò�Ʒ��������֮��"
		Response.end
	end if

	if buyType="vhost" or buyType="mssql" or buyType="mysql" then
		getYears=tb_val_years
	else
		getYears=1
	end if
end sub


function getDomainType_fromdb(Byval xdomain)
	set lrs=conn.Execute("select proid,isreglocal from domainlist where strdomain='" & xdomain & "'")
	if not lrs.eof then
		if lrs("isreglocal") then
			getDomainType_fromdb=lrs("proid")
		else
			getDomainType_fromdb=getDomainType(xdomain)
		end if
	else
		getDomainType_fromdb="NOT_EXISTS_PROID"
	end if
	lrs.close:set lrs=nothing
end function

function other_get_vhostexists()
	other_get_vhostexists=connectToUp(glbArgus("strCmd"))
end function

function other_sync_record()
		ident=getInput("ident")
		tbname=getInput("tbname")
		u_name=glbArgus("u_name")
		u_id=finduserid(u_name)

		select case tbname
			case "vhhostlist"
				ident_fields="s_comment"
				fdowner="s_ownerid"
				fd_sys="s_sysid"
			case "hostrental"
				ident_fields="allocateip"
				fdowner="u_name"
				fd_sys="id"
				u_id=u_name
			case "domainlist"
				ident_fields="strdomain"
				fdowner="userid"
				fd_sys="d_id"
			case "mailsitelist"
				ident_fields="m_bindname"
				fdowner="m_ownerid"
				fd_ident="m_bindname"
				fd_sys="m_sysid"
			case "databaselist"
				ident_fields="dbname"
				fdowner="dbu_id"
				fd_sys="dbsysid"
			case else
				other_sync_record="900 ��Ч�ı���"
				exit function
		end select
		if  isnumeric(u_id) and fdowner<>"u_name" then
			sqlstring="select " & fd_sys & " from " & tbname & " where " & ident_fields & "='" & ident & "' and " & fdowner & "=" & u_id
		else
			sqlstring="select " & fd_sys & " from " & tbname & " where " & ident_fields & "='" & ident & "' and " & fdowner & "='" & u_id &"'"
		end if
		set lrs=conn.Execute(sqlstring)
		if lrs.eof then
			other_sync_record="555 �޴�ҵ��"
			exit function
		end if
		lrs.close: set lrs=nothing

		other_sync_record=connectToUp(glbArgus("strCmd"))
		if success(other_sync_record) then
			Set PArgs=CreateObject("Scripting.Dictionary"):PArgs.compareMode=1
			tbname=getInput("tbname")
			ident=getInput("ident")
			fdlist=getReturn(other_sync_record,"fdlist")
			recordset=getReturn_rrset(other_sync_record,"recordset")

			PArgs.Add "ownername",glbArgus("u_name")
			PArgs.Add "tbname",tbname
			PArgs.Add "ident",ident
			PArgs.Add "fdlist",fdlist
			PArgs.Add "recordset",recordset

			Call SynData_record(PArgs)

			ret=PArgs("result"):Set PArgs=nothing

			if ret>0 then
				other_sync_record="500 ͬ��ʧ��" & ret
			end if
		end if
end function

'ĳ��ҵ�������Ƿ�����ʹ�á�
function AllowOpen(Byval Pstr)
	CmpStr=split(api_autoopen,",")

	for iIndex=0 to Ubound(CmpStr)
		zStr=Trim(CmpStr(iIndex))
		if Pstr=zStr then
			AllowOpen=true
			exit function
		end if
	next
	AllowOpen=false
end function



'2012-8-15
'��鷢Ʊ�Ƿ����ϼ���
'ly
function chk_fapiao_ok()
dim str_bool:str_bool=false
            Xcmd= "other" & vbcrlf
			Xcmd=Xcmd & "get" & vbcrlf
			Xcmd=Xcmd & "entityname:iscaninvoice" & vbcrlf
			Xcmd=Xcmd & "." & vbcrlf
     		loadRet=Pcommand(Xcmd,Session("user_name"))
			if getReturn(loadRet,"invoicetype")<>"True" then
			str_bool=False
			else
			str_bool=True
			end if
			chk_fapiao_ok=str_bool
end function



'vpsͬ��
'2012-8-14
function Syn_vpsjf()

on  error  resume  next  
Syn_vpsjf=false
sqlstring="select p_proid from productlist where p_type in(9,11,12,13)"
set vpsrs=conn.execute(sqlstring)
do while not vpsrs.eof
'response.Write(vpsrs(0)&"<BR>")

call doUserSyn_vps(vpsrs(0),false)
vpsrs.movenext
loop

if  Err.number<>0 then 
Syn_vpsjf=false
 Err.Clear 
else
Syn_vpsjf=true
end if
end function



'����������
function server_adddiy()
	u_name=glbArgus("u_name")
	aid=getInput("aid")
	if not isnumeric(aid) or aid="" then 
		server_adddiy="500 aid is Err"
		exit function	
	end if
	set ds=new diyserver_class
	if isapicomm then
	ds.user_sysid=u_sysid
	else
	ds.user_sysid=session("u_sysid")
	end if
	p_proid="ebscloud"
	ds.setProid=p_proid
	aid=getInput("aid")
	strCmd=glbArgus("strCmd")
	ds.setParam(strCmd) 
	u_p_pricmoney=getInput("pricmoney")
    needprice=ds.getprice("new")
	if cdbl(needprice)>cdbl(u_p_pricmoney) then
        server_adddiy="500 ��Ʒ�۸����ô�������ϵ����Ա,��ɾ�����ﳵ�����¹���"
     	exit function
	end if
	if isapicomm then
		ds.buyordersub()
		aid=ds.aid
	end if
	
	if cdbl(needprice)>cdbl(ds.u_usemoney) then
		server_adddiy="400 No Money!"
		exit function
	end if
	 if not  api_debug then
     loadRet=connectToUp(glbArgus("strCmd"))
	 else
	 loadRet="200 Command completed successfully"&vbcrlf&_
			"vpsIP:127.0.0.1"&vbcrlf&_
			"vpsPassWord:hfbh7hvr"&vbcrlf&_
			"isnowpay:True"&vbcrlf&_
			"orderid:175987"&vbcrlf&_
			"."&vbcrlf
      end if

	if success(loadRet) then
		vpsIP=getReturn(loadRet,"vpsIP")
		vpsPassWord=getReturn(loadRet,"vpsPassWord")
		server_adddiy = "200 ok"
		randomize(timer())
		if not consume(u_name,needprice,false,"server-" & Left(Cstr(Clng(rnd()*100000)),6) , "����IP��������" & vpsIP ,ds.p_proid,"") then
			addRec "�ۿ�ʧ��","����IP��������"& vpsIP &"�ɹ����ϼ����ѿۣ����û���δ�ܿ۳���" 
		else
			sql="select * from HostRental where id="& aid
			rs1.open sql,conn,1,3
			if not rs1.eof then
				rs1("start")=true
				rs1("AllocateIP")=vpsIP
				rs1("RamdomPass")=vpsPassWord
				rs1("MoneyPerMonth")=ds.MoneyPerMonth
				rs1("AlreadyPay")=ds.monthnum
				rs1("StartTime")=date()
				rs1("addedServer")=ds.servicetype
				rs1("addServerPrice")=ds.addserverprice
				rs1("u_name")=u_name
				rs1.update()
			end if
			rs1.close 
			
			Call Set_vcp_record(p_proid,ds.user_sysid,needprice,ds.monthnum,"�����ƹ���",false)

     optCode="other"& vbCrLf & _
             "get"& vbCrLf & _
             "entityname:expdate"& vbCrLf & _
             "ptype:svr"& vbCrLf & _
             "pident:"&vpsIP&""& vbCrLf & _
             "."& vbCrLf 
             call  PCommand(optCode,u_name)


			server_adddiy=loadRet					    
		end if
	else
		server_adddiy="500 ERR=" & loadRet
	end if
end function


'2013-7-8
function upserverdiy(strCmd)

	serverip=getInput("serverip")
		'�����Ƿ�Ϊip���
	if not isip(serverip) then
		server_set_upgradediy="303 ��������(ip)"
		exit function	
	end if

     'ȡֵ
	 p_proid=getInput("p_proid")      '��Ʒ���
	 cpuhz=getInput("cpuhz")          'cpu����
	 data=getInput("data")            'Ӳ�̴�С
	 ramsize=getInput("ramsize")      '�ڴ��С
	 flux=getInput("flux")            '����
	 pricmoney=getInput("pricmoney")    '֧���۸�


		if not isnumeric(cpu) or   not isnumeric(ram) or   not isnumeric(flux) or   not isnumeric(data) then
		upserverdiy="405 diy������������"
		exit function
		end if

	 ' server_set_upgradediy="����cpu"&chkdiyconfig(cpuhz,"cpu")
	 ' exit function
	
	  cpu=chkdiyconfig(cpuhz,"cpu")
	  ram=chkdiyconfig(ramsize,"ram")
	 

	    set ds=new diyserver_class
		p_proid="ebscloud"
		ds.user_sysid=u_sysid
		ds.setHostid=serverip
		if trim(ds.errstr)<>"" then 
		   server_set_upgradediy="505 "&ds.errstr
			exit function	
		end if
		ds.p_proid=p_proid
	
		'���ò���
		ds.cpu=	cpu
		ds.ram=	ram
		ds.data=data
		ds.flux=flux
		ds.room=ds.oldroom
		ds.isfast=false
		
		ds.zh_cpuandram()
 
		needMoney=ds.getupprice("renew")
		
		if cdbl(getInput("pricmoney"))<cdbl(needMoney) then
		' die needMoney&"===>"&getInput("pricmoney")
	 
			 upserverdiy="601 ����۸���ڳɱ���"
			  exit function
		end if	
	
	   	 
		return=ds.upgrade()    '����ִ��
	    upserverdiy=return
 
end function





'�û�����ת��(2013-7-11)
function server_paytestdiy(ByVal strCmd)
	set ds=new diyserver_class
    serverip=getInput("serverip")
	servicetype=trim(getInput("servicetype"))
	PayMethod=trim(getInput("paymethod"))
	renewTime=trim(getInput("renewtime"))
	checkstr=ds.checkinput("servicetype",servicetype)

	if checkstr<>"" then
		server_paytestdiy="305 "&checkstr
		exit function	
	end if
   
    checkstr=ds.checkinput("paymethod",PayMethod)
	if checkstr<>"" then
		server_paytestdiy="305 "&checkstr
		exit function	
	end if

   checkstr=ds.checkinput("renewtime",renewTime)
	if checkstr<>"" then
		server_paytestdiy="305 "&checkstr
		exit function	
	end if
	

	'�����Ƿ�Ϊip���
	if not isip(serverip) then
		server_paytestdiy="303 ��������(ip)"
		exit function	
	end if
	

	ds.user_sysid=u_sysid
	'ds.gethostinfo(serverip)
   
	ds.setHostid=serverip
   
	if ds.errstr<>"" then 
		server_paytestdiy="505 "&ds.errstr
		exit function	
	end if



	ds.newservicetype=servicetype
	ds.newPayMethod=PayMethod
	ds.newrenewTime=renewTime

	tmppaytest=ds.paytype

	PricMoney=ds.getpaytestprice()
	ds.paytype=tmppaytest
    
    '���ͼ��	
	if trim("ebscloud")<>trim(ds.p_proid) then
    	server_paytestdiy = "401 p_proid error"
		exit function
	end if
    
    'ת�����
	if  clng(tmppaytest)<>1 then
    	server_paytestdiy = "402 ���ǲ��Է��������ܲ���!"
		exit function
	end if
  

    if  cdbl(getInput("pricmoney"))<cdbl(PricMoney) then
    	server_paytestdiy = "404 �۸����ò���ȷ!"
		exit function
	end if

	if ds.dopaytest() then
		returnstr="200 ok"&vbCrLf&"expiredate:"&getexpiredate("server",serverip)& vbCrLf & "." & vbCrLf
	elseif instr(errstr,"���")>0 then
		returnstr="404 ����"
	else
		returnstr="504"&ds.errstr
	end if
    server_paytestdiy = returnstr
end function


'�¼Ӽ�鲢ת��diy����(���д���-1)
function chkdiyconfig(val,dt)
chkdiyconfig=-1
select case trim(dt)
  case "cpu" 'cpu����(1,2,4,8,16)
     select case cstr(val)
		 case "1"
		 chkdiyconfig=1
		 case "2"
		 chkdiyconfig=2
		 case "4"
		 chkdiyconfig=3
		 case "8"
		 chkdiyconfig=4
		 case "12"
		 chkdiyconfig=5
		 case "16"
		 chkdiyconfig=6
	 end select 
	
  case "ram"  '0.5,1,2,3,4,6,8,16,32
      select case cstr(val)
         case "0.5"
		 chkdiyconfig=1
		 case "1"
		 chkdiyconfig=2
		 case "2"
		 chkdiyconfig=3
		 case "3"
		 chkdiyconfig=4
		 case "4"
		 chkdiyconfig=5
		 case "6"
		 chkdiyconfig=6
		 case "8"
		 chkdiyconfig=7
		 case "12"
		 chkdiyconfig=8
		 case "16"
		 chkdiyconfig=9
		 case "32"
		 chkdiyconfig=10
		 case "64"
		 chkdiyconfig=11
		 end select
  case "flux" '����1-100
       if  isnumeric(val) then
	      if 1=<clng(val)<=100 then
	      chkdiyconfig=val
		  end if
	   end if
  case "data"   
       if  isnumeric(val) then
	      if 50=<clng(val)<=500 then
	      chkdiyconfig=val
		  end if
	   end if
  case "paymethod"  '֧����ʽ���
       select case cstr(val)
		 case "0"
		 chkdiyconfig=0
		 case "1"
		 chkdiyconfig=1
		 case "2"
		 chkdiyconfig=2
		 case "3"
		 chkdiyconfig=3
		end select
  case "renewtime"
      if  isnumeric(val) then
	      if clng(val)>=1 then
	      chkdiyconfig=val
		  end if
	   end if
  case "room"  'ֻ��37,38
      select case cstr(val)
         case "37"
		 chkdiyconfig=37
		 case "38"
		 chkdiyconfig=38
		 case "39"
		 chkdiyconfig=39
		 case "36"
		 chkdiyconfig=36
		  case "40"
		 chkdiyconfig=40
		   case "41"
		 chkdiyconfig=41
		   case "42"
		 chkdiyconfig=42
	  end select
  case "paytype" '0--��ʽ,1---����
       select case cstr(val)
         case "1"
		 chkdiyconfig=1
		 case "0"
		 chkdiyconfig=0
	  end select
  case "servicetype" '��������|ͭ�Ʒ���|���Ʒ���|���Ʒ���
       select case cstr(zh_servicetype(val))
         case "��������"
		 chkdiyconfig="��������"
		 case "ͭ�Ʒ���"
		 chkdiyconfig="ͭ�Ʒ���"
		 case "���Ʒ���"
		 chkdiyconfig="���Ʒ���"
		 case "���Ʒ���"
		 chkdiyconfig="���Ʒ���"
	  end select
   case "os" 'win,win_2005,win_clean,win_64,win_2008_64,win_2008,win_2012_clean,linux_wd,linux_64,linux_6.4,
       select case cstr(val)
         case "win"
		 chkdiyconfig="win"
		 case "win_2005"
		 chkdiyconfig="win_2005"
		 case "win_clean"
		 chkdiyconfig="win_clean"
		 case "win_64"
		 chkdiyconfig="win_64"
		 case "win_2008_64"
		 chkdiyconfig="win_2008_64"
		 case "win_2008"
		 chkdiyconfig="win_2008"
		 case "win_2012_clean"
		 chkdiyconfig="win_2012_clean"
		 case "linux_wd"
		 chkdiyconfig="linux_wd"
		 case "linux_64"
		 chkdiyconfig="linux_64"
		 case "linux_6.4"
		 chkdiyconfig="linux_6.4"
		 case "linux_ubuntu"
		 chkdiyconfig="linux_ubuntu"
		  case "linux_debian64"
		 chkdiyconfig="linux_debian64"
		 case "linux_ubuntu_64"
		 chkdiyconfig="linux_ubuntu_64"
		 case else
		 '�ɴ��Զ���ģ��
		 if instr(val,"diy_os_")>0 then
		 chkdiyconfig=val
		 end if
	  end select
	 case "disktype"
	     select case cstr(val)
			 case "ebs"
			 chkdiyconfig="ebs"
			 case "local"
			 chkdiyconfig="local"
			 case "ssd"
			 chkdiyconfig="ssd"
		 end select
	case "servertype"
	   select case lcase(cstr(val))
	          case "reboot"
			  chkdiyconfig="reboot"
			  case "openserver"
			  chkdiyconfig="openserver"
			  case "closeserver"
			  chkdiyconfig="closeserver"
	   end select
	case "bool"
	   select case lcase(cstr(trim(val)))
	          case "true"
			  chkdiyconfig="true"
			  case "false"
			 chkdiyconfig="false"
	   end select
end select

end function

'��Ʒ����ʱ���ȡ
function getexpiredate(t,iporhost)
returntime="1900-01-01"

select case lcase(trim(t))
case "server"
  if isip(iporhost) then
  sql="select preday,AlreadyPay,StartTime,Start from hostrental where ','+allocateip+',' like '%," & iporhost & ",%'"
  
     set expirers=conn.execute(sql) 
	
     if not expirers.eof then
 
		if  expirers("Start") then
	
		preday=expirers("preday")
		
		if preday&""="" or not isnumeric(preday) then preday=0
			
			ExpireTime=dateadd("d",preday,DateAdd("m",expirers("AlreadyPay"),expirers("StartTime")))
		
			returntime=formatDateTime(ExpireTime,2)  
		end if
	expirers.close()
  end if
 end if
  
case else
end select
getexpiredate=formatdatetime(returntime,2)
end function

function getgift()
	returnstr=connectToUp(glbArgus("strCmd"))
	if left(returnstr,3)="200" then
		temparray=split(returnstr,vbcrlf)
		if ubound(temparray)=2 then
		getgift="500 ������ͬ��"
		else
			conn.execute("delete from giftabout")
			for i=1 to ubound(temparray)-2
			temps=split(temparray(i),",")
			if ubound(temps)<>3 then
			sql="insert into giftabout(gtype,gname,gcomment) values("&cdbl(temps(0))&",'"&trim(temps(2))&"','"&trim(temps(1))&"')"
			conn.execute(sql)
			end if

			next
			getgift="200 ��ȡmssql��Ʒ�����ɹ�"
		end if
		 
	else
	getgift="500 ��ȡmssql��Ʒ����ʧ��"
	end if
end function
 
function create_wxapp(byval strContents)
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
	Set app=new miniprogram 
	app.setuid=u_id
	If Trim(app.errmsg)<>"" Then create_wxapp="500 err["&app.errmsg&"]":Exit function 
	If app.create(strContents) Then 
		create_wxapp="200 ok"
	Else
		create_wxapp="500 err["&app.errmsg&"]"
	End If 
end Function

Function buysms_wxapp(ByVal strContents)
	num=requesta("num") 
	u_name=glbArgus("u_name")
	u_id=finduserid(u_name)
	Set app=new miniprogram 
	app.setuid=u_id
	If Trim(app.errmsg)<>"" Then buysms_wxapp="500 err["&app.errmsg&"]":Exit function 
	If app.buysms(num) Then 
		buysms_wxapp="200 ok"
	Else
		buysms_wxapp="500 err["&app.errmsg&"]"
	End If 
End Function

'����С����
Function renew_wxapp(ByVal strContents)
	appid=getInput("appid")
	years=getInput("years")
	productids=getInput("productids")
	u_name=glbArgus("u_name")

	u_id=finduserid(u_name)
	if	not isnumeric(appid&"") then die echojson(500,"APPid����","")
	if	not isnumeric(years&"") then die echojson(500,"����ʱ������","")
	set app=new miniprogram
	app.setuid=u_id
	if trim(app.errmsg)<>"" then die echojson("500",app.errmsg,"")
	app.setAppid=appid
	If trim(app.errmsg)<>"" Then die echojson(500,app.errmsg,"")
	 if app.renew(years,productids) then
		die echojson(200,"���ѳɹ�","")
	 else
		die echojson("500",app.errmsg,"")
	 end if 
End Function

 

'��ͨ���ʾ�
Function create_yunmail(byval strContents)
	domain=getInput("domain")
	passwd=getInput("passwd")
	alreadypay=getInput("alreadypay")
	postnum=getInput("postnum")
	ppricetemp=getInput("ppricetemp")
	istry=getInput("istry")
	isfree=getInput("isfree")
	s_comment=getInput("s_comment")
	u_name=glbArgus("u_name")
	If InStr(",0,1,",","&istry&",")=0 Then istry=0

	u_id=finduserid(u_name)
	Set yun=new yunmail_class 
	yun.setuid=u_id
	Set optdic=newoption()
	optdic.add "domain",domain
	optdic.add "passwd",passwd
	optdic.add "alreadypay",alreadypay
	optdic.add "postnum",postnum
	optdic.add "istry",istry
	If Trim(s_comment)<>"" Then 
	    optdic.add "s_comment",s_comment
		optdic.add "isfree",isfree
	Else
		optdic.add "isfree",0
	End If 
	yun.buyyunmail(optdic)
	if yun.isnext Then
		create_yunmail="200 ok"
	Else
		create_yunmail="500 err["&yun.errarr.join(",")&"]"
	End if

End Function

Function get_server_otherip(ByVal ip)
	If isip(ip&"") Then
		cmdstr="server"&vbcrlf&_
			   "manage"&vbcrlf&_
			   "entityname:otherips"&vbcrlf&_
			   "serverip:"& ip &vbcrlf&_
			   "."&vbcrlf 
		get_server_otherip=connectToUp(cmdstr)
	End if
End Function

'/*���ϼ�ͬ��һ��������ֻ��id����*/
Function startUpsync(hostid)
	dim sql,trs,i_table,i_field,u_name
	sql="select b.u_name,a.* from vhhostlist a inner join userdetail b On a.s_ownerid=b.u_id where a.s_sysid=" & hostid
	set trs=conn.execute(sql)
	if not trs.eof then
		i_table = "vhhostlist"
		u_name = trs("u_name")
		s_comment = trs("s_comment")
		for i=1 to trs.Fields.Count-1
			i_field = i_field & trs.Fields(i).Name & ","
		next
		i_field = left(i_field,len(i_field)-1)
		cmdstr = "other" & vbcrlf & _
				"sync" & vbcrlf & _
				"entityname:record" & vbcrlf & _
				"tbname:" & i_table & vbcrlf & _
				"fdlist:" & i_field & vbcrlf & _
				"ident:" & s_comment & vbcrlf & _
				"." & vbcrlf
		startUpsync=pcommand(cmdstr,u_name)
	else
		startUpsync="500 Not Found"
	end if
	trs.close
End function
%>