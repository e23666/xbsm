
<%
''开通订单
''protype 如"domain" "vhost" ..
''orderid 订单号 
''user_name 用户名
''zxw 08-5-5
domainRegister=""
function putOrderlist(byval protype,byval orderid,byval user_name)
set orderRs=server.CreateObject("ADODB.Recordset")
		select case trim(lcase(protype))
			case "domain"
				putOrderlist=putDomain(user_name,orderid,orderRs)
			case "vhost"
				putOrderlist=putVhost(user_name,orderid,orderRs)
			case else
				putOrderlist="404 传递参数错误"
		end select
	set orderRs=nothing
end function
''产品续费
''producttype 如"domain" "vhost" ..
''p_name 产品在数据库中的名字 
''years 续费年限
''zxw 08-5-5
function putRenew(byval productType,byval p_name,byval years,byval user_name)
	select case lcase(productType)
			case "domain"
				putRenew=renewdomain(user_name,p_name,years)
			case "vhost"
				putRenew=renewhost(user_name,p_name,years)
			case "mail"
				putRenew=Putrenewmail(user_name,p_name,years)
			case "dnsdomain"
				putRenew=renewdns(user_name,p_name,years)
			case "mssql"
				putRenew=renewdata(user_name,p_name,years)
			case "server"
				putRenew=renewServer(user_name,p_name,years)
			case else
				putRenew="404 传递参数错误"
	end select
end function
''产品升级
''producttype 如"domain" "vhost" ..
''p_name 产品在数据库中的名字 
''zxw 08-5-5
function putUP(byval productType,byval p_name,byval targetT,byval updateType,byval user_name)
	select case lcase(productType)
			case "vhost"
				putUP=uphost(user_name,p_name,targetT,updateType)
			case "mail"
				putUP=upmail(user_name,p_name,targetT,updateType)
			case "mysql"
			case "mssql"
				putUP=updata(user_name,p_name,targetT,updateType)
			case else
				url_return "传递参数错误",-1
	end select
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function putDomain(byval user_name,byval orderid,byval orderRs)
	sql="Select *,(select u_email from userdetail where u_name=PreDomain.username) as u_email from PreDomain Where d_id =" & orderid & " and username='" & user_name &"'"
		orderRs.open sql,conn,1,1
		if not orderRs.eof then
		    	productname=orderRs("strDomain")
				price=orderRs("price")
				vyears=orderRs("years")
				sDate=orderRs("regdate")
				productid=orderRs("proid")
				u_email=orderRs("u_email")
				allprice=GetNeedPrice(user_name,productid,vyears,"new")
				password=orderRs("strDomainpwd")
				strdomain=orderRs("strdomain")
				
		Set objMyData = Server.CreateObject("Scripting.Dictionary")
				objMyData.Add "org", orderRs("dom_org")
				objMyData.Add "fn",orderRs("dom_fn")
				objMyData.Add "ln", orderRs("dom_ln")
				objMyData.Add "adr1", orderRs("dom_adr1")
				objMyData.Add "ct", orderRs("dom_ct")
				objMyData.Add "st", orderRs("dom_st")
				objMyData.Add "co", orderRs("dom_co")
				objMyData.Add "pc", orderRs("dom_pc")
				objMyData.Add "ph", orderRs("dom_ph")
				objMyData.Add "fax", orderRs("dom_fax")
				objMyData.Add "em", orderRs("dom_em")
				objMyData.Add "org_m", orderRs("dom_org_m")
				objMyData.Add "fn_m", orderRs("dom_fn_m")
				objMyData.Add "ln_m", orderRs("dom_ln_m")
				objMyData.Add "adr_m", orderRs("dom_adr_m")
				objMyData.Add "ct_m", orderRs("dom_ct_m")
				objMyData.Add "st_m", orderRs("dom_st_m")
		
		
	
fildnamestr="dns_host1,dns_ip1,dns_host2,dns_ip2,dom_org,dom_fn,dom_ln,dom_adr1,dom_ct,dom_st,dom_co,dom_pc,dom_ph,dom_fax,dom_em,admi_fn,admi_ln,admi_adr1,admi_ct,admi_st,admi_co,admi_pc,admi_ph,admi_fax,admi_em,tech_fn,tech_ln,tech_adr1,tech_ct,tech_st,tech_co,tech_pc,tech_ph,tech_fax,tech_em,bill_fn,bill_ln,bill_adr1,bill_ct,bill_st,bill_co,bill_pc,bill_ph,bill_fax,bill_em,dom_org_m,dom_fn_m,dom_ln_m,dom_adr_m,dom_ct_m,dom_st_m,admi_org_m,admi_fn_m,admi_ln_m,admi_adr_m,admi_ct_m,admi_st_m"
			orderyears=orderRs("years")
			if orderyears<1 or orderyears>10 then putDomain="406 订单年限应在1-10之间":set objMyData=nothing:exit function
				commandstr= commandstr&"domainname"& vbcrlf
				commandstr= commandstr&"add"& vbcrlf
				commandstr= commandstr&"entityname:domain"& vbcrlf
				commandstr= commandstr&"domainname:"& strdomain & vbcrlf
				commandstr= commandstr&"dmtype:ENG"& vbcrlf
				commandstr= commandstr&"term:"& orderyears & vbcrlf
				commandstr= commandstr&"dns_host1:"& orderRs("dns_host1")& vbcrlf
				commandstr= commandstr&"dns_ip1:" & orderRs("dns_ip1") & vbcrlf
				commandstr= commandstr&"dns_host2:" & orderRs("dns_host2") & vbcrlf
				commandstr= commandstr&"dns_ip2:" & orderRs("dns_ip2") & vbcrlf
for each fildName in split(fildnamestr,",")
	fildName=trim(fildName)
	if fildname<>"" then
		xx=instr(fildName,"_")
		if xx>0 then
			newfild=right(fildName,len(fildname)-xx)
			if objMyData.Exists(newfild) then
				commandstr= commandstr & fildName & ":" & objMyData.item(newfild) & vbcrlf
			end if
		end if
	end if
next
			if lcase(orderRs("proid"))="domhk" then
			    commandstr= commandstr&"reg_contact_type:"& orderRs("reg_contact_type")& vbcrlf
				commandstr= commandstr&"custom_reg1:" & orderRs("custom_reg1") & vbcrlf
				commandstr= commandstr&"custom_reg2:" & orderRs("custom_reg2") & vbcrlf
				commandstr= commandstr&"adm_contact_type:" & orderRs("reg_contact_type") & vbcrlf
				commandstr= commandstr&"custom_adm1:" & orderRs("custom_reg1") & vbcrlf
				commandstr= commandstr&"custom_adm2:" & orderRs("custom_reg2") & vbcrlf
				commandstr= commandstr&"tec_contact_type:" & orderRs("reg_contact_type") & vbcrlf
				commandstr= commandstr&"custom_tec1:" & orderRs("custom_reg1") & vbcrlf
				commandstr= commandstr&"custom_tec2:" & orderRs("custom_reg2") & vbcrlf
				commandstr= commandstr&"bil_contact_type:" & orderRs("reg_contact_type") & vbcrlf
				commandstr= commandstr&"custom_bil1:" & orderRs("custom_reg1") & vbcrlf
				commandstr= commandstr&"custom_bil2:" & orderRs("custom_reg2") & vbcrlf
			end if
set objMyData=nothing
if orderRs("proid")="domxm" then
	commandstr = commandstr & "producttype:"& orderRs("proid") & vbCrLf
end if
commandstr = commandstr & "ppricetemp:" & allprice & vbCrLf & _
			 			  "domainpwd:"& orderRs("strdomainpwd") & vbcrlf & _
						  "." & vbcrlf

				orderRs.close
				Set orderRs=nothing
 
				putDomain=pcommand(commandstr,user_name)

				if left(putDomain,3)="200" then
									
						getStr="domain="& productName &","& _
								"Password="& password
						mailbody=redMailTemplate("BuyDomainSucess.txt",getStr)
						call sendMail(u_email,"您的域名("& productName &")开通成功!",mailbody)

						conn.Execute("update preDomain set opened="&PE_True&" where d_id=" & orderid)
				end if
	else
			putDomain="401 没有找到域名订单":exit function
	end if
end function
function putVhost(byval user_name,byval orderid,byval orderRs)
		set orderRs=server.CreateObject("ADODB.Recordset")		
		sql="select a.*,b.p_name,(select u_email from userdetail where u_name=a.u_name) as u_email  from PreHost a inner join Productlist b on (a.proid=b.p_proid)  where a.OrderNo='"& orderid & "' and a.u_name='"& user_name &"'"
		orderRs.open sql,conn,1,1
		
		if not orderRs.eof then
			productid=orderRs("proid")
			vyears=orderRs("years")
			domainstr=orderRs("domains")
			ftpaccount=orderRs("ftpAccount")
			ftppassword=orderRs("ftppassword")
			pmver=orderRs("pmver")
			price=orderRs("price")
			productName=orderRs("p_name")
			sDate=orderRs("sDate")
			u_email=orderRS("u_email")
			allprice= GetNeedPrice(user_name,productid,vyears,"new")
			room=orderRS("room")
			osvar=orderRs("osvar")
			cdntype=orderRS("cdntype")
			s_appname=orderRs("s_appName")
			s_appAdd=orderRs("s_appAdd")
			s_appTel=orderRs("s_appTel")
			s_appEmail=orderRs("s_appEmail")
			settouch=""
			paytype="0"
		else
				putVhost="401 没有找到您的订单号":exit function
		end If
		orderRs.close
		set orderRs=nothing
	commantstr="vhost" & vbcrlf & _
			   "add" & vbcrlf & _
				"entityname:vhost" & vbcrlf & _
				"producttype:" & productid & vbcrlf & _
				"years:" & vyears & vbcrlf & _
				"ftpuser:" & ftpaccount & vbcrlf & _
				"ftppassword:" & ftppassword & vbcrlf & _
				"cdntype:" & cdntype & vbcrlf & _
				"paytype:" & paytype & vbcrlf & _
				"pmver:" & pmver & vbcrlf & _
				"domain:" & domainstr & vbcrlf & _
				"settouch:" & settouch & vbcrlf & _
				"room:" & room & vbcrlf & _
				"osver:" & osvar & vbcrlf & _
				"ppricetemp:" & allprice & vbCrLf & _
				"appname:" & s_appname & vbcrlf & _
				"appAdd:" & s_appAdd & vbcrlf & _
				"appTel:" & s_appTel & vbcrlf & _
				"appEmail:" & s_appEmail & vbCrLf & _
				"." & vbcrlf
			
				putVhost=pcommand(commantstr,user_name)
					if left(putVhost,3)="200" then
						freeurl=getstrReturn(putVhost,"freedomain")
						serverip=getstrReturn(putVhost,"ip")
						if trim(domainstr)&""="" then domainstr="暂没绑定" 
						getStr= "domainstr=" & domainstr & "," & _
								"productid=" & productid &"," & _
								"vyears=" & vyears & "," & _
								"ftpaccount=" & ftpaccount & "," & _
								"ftppassword=" & ftppassword & "," & _
								"price=" & price & "," & _
								"allprice=" & allprice & "," & _
								"freedomain=" & freeurl & "," & _
								"serverip=" & serverip & "," & _
								"now=" & sDate
						mailbody=redMailTemplate("buyhostsucess.txt",getStr)
						call sendMail(u_email,"主机订单开通成功!",mailbody)
					end if

end function

function renewServer(byval u_name,byval serverip,byval renewTime)
	if instr(renewTime,"^|^") then 
		renewArr=split(renewTime,"^|^")
		renewTime=trim(renewArr(0))
		paymethod=trim(renewArr(1))
	end if
	commandstr="server" & vbcrlf & _
			   "renew" & vbcrlf & _
			   "entityname:server" & vbcrlf & _
			   "serverip:" & trim(serverip) & vbcrlf & _
			   "paymethod:"& paymethod & vbcrlf & _
			   "renewtime:" & renewTime & vbcrlf & _
			   "." & vbcrlf
	renewServer=pcommand(commandstr,u_name)
end function

function renewdomain(byval u_name,byval strdomain,byval years)
	p_proid=GetDomainType(strdomain)	
	set trs=conn.execute("select * FROM domainlist where strdomain='" & strdomain & "' and isreglocal="&PE_False&"")
	if not trs.eof then
		d_years = trs("years")
		d_regdate = trs("regdate")
		domainRegister=getDomUpReg(strdomain)
		if not isnumeric(d_years&"") or not isdate(d_regdate) then 
			renewdomain="500 域名本地年限和注册日期错误"
			exit function
		end if
		expireDate = DateAdd("yyyy",d_years,d_regdate)
	end if
	trs.close
	renewprice=getRenewCnPrice(strdomain,years)
	if renewprice="" then
		renewprice=getneedprice(u_name,p_proid,years,"renew")
	end if
	commandstr="domainname" & vbcrlf & _
			   "renew" & vbcrlf & _
			   "entityname:domain" & vbcrlf & _
			   "domain:" & trim(strdomain) & vbcrlf & _
			   "term:" & years & vbcrlf & _
			   "expiredate:" & expireDate & vbcrlf & _
			   "ppricetemp:" & renewprice & vbCrLf 
	if trim(renewmode)<>"" then 
	   commandstr=commandstr&"renewmode:" & renewmode & vbCrLf  
	end if
	commandstr=commandstr&"." & vbcrlf  
	renewdomain=pcommand(commandstr,u_name)
end function

function renewdns(byval u_name,byval strdomain,byval years)
	Dim expireDate,d_years,d_regdate
	set trs=conn.execute("select years,regdate FROM domainlist where strdomain='" & strdomain & "' and isreglocal="&PE_True&"")
	if not trs.eof then
		d_years = trs("years")
		d_regdate = trs("regdate")
	Else
		renewdns = "500 不存在此记录":Exit Function
	End if
	expireDate = DateAdd("yyyy",d_years,d_regdate)

	commandstr="domainname" & vbcrlf & _
			   "renew" & vbcrlf & _
			   "entityname:domain" & vbcrlf & _
			   "domain:" & trim(strdomain) & vbcrlf & _
			   "term:" & years & vbcrlf & _
			   "isdns:true" & vbcrlf & _
			   "expiredate:" & expiredate & vbcrlf & _
			   "." & vbcrlf
	renewdns=pcommand(commandstr,u_name)	 
end Function
'2013-9-4添加空间续费余额不足检查及价格保护
function renewhost(byval u_name,byval s_comment,byval years)


'2013-9-5 续费价格保护后台启用关闭
if vhost_ren_price then
     sql="select s_ProductId,s_ssl,s_sslset from vhhostlist where s_comment='"&s_comment&"'"
    set p_rs=conn.execute(sql)
	if p_rs.eof then
	renewprice=999999
	Else
	s_ssl=p_rs("s_ssl")
	s_sslset=p_rs("s_sslset")
	sslprice=0
	if not isnumeric(s_ssl&"") then s_ssl=0
	if not isnumeric(s_sslset&"") then s_sslset=0 
	If CDbl(s_ssl)>0 Then 
		If CDbl(s_sslset)>0 Then
			sslprice=getneedprice(u_name,"gfssl",1,"renew")	
		Else
			sslprice=getneedprice(u_name,"vhostssl",1,"renew")
		End if
	End if


	  if trim(p_rs("s_ProductId"))="" then
	  renewprice=999999
	  else
	  renewprice=getneedprice(u_name,p_rs("s_ProductId"),years,"renew")
	  end If
	  
	  renewprice=CDbl(renewprice)+CDbl(sslprice)
	end if
else
  renewprice=999999
end if
	
'	 die renewprice&"|"&u_name&"|"&years&"renew"
	otherip=getOtherip(s_comment,u_name) 
    If isip(otherip) Then
		if lcase(left(p_rs("s_ProductId"),2))="tw" then
			ipproid="twaddip"
			else
			ipproid="vhostaddip"
		end if
		ipprice=getneedprice(u_name,ipproid,1,"renew")	 
		if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
		renewprice=cdbl(renewprice)+cdbl(ipprice)
	End if

	commandstr="vhost"& vbcrlf & _
			   "renewal"& vbcrlf & _
			   "entityname:vhost" & vbcrlf & _
			   "sitename:" & s_comment & vbcrlf & _
			   "years:" & years & vbcrlf & _
			   "otherip:" & otherip & vbcrlf & _
			   "ppricetemp:" & renewprice & vbcrlf & _
			   "." & vbcrlf 
	renewhost=pcommand(commandstr,u_name)

end function

function Putrenewmail(byval u_name,byval m_bindname,byval years)
	commandstr="corpmail"& vbcrlf & _
			   "renewal"& vbcrlf & _
			   "entityname:corpmail" & vbcrlf & _
			   "domainname:" & m_bindname & vbcrlf & _
			   "years:" & years & vbcrlf & _
			   "." & vbcrlf
	
	Putrenewmail=pcommand(commandstr,u_name)
end function

function renewdata(byval u_name,byval dbname,byval years)
	commandstr="mssql"& vbcrlf & _
			   "renewal"& vbcrlf & _
			   "entityname:mssql" & vbcrlf & _
			   "databasename:" & dbname & vbcrlf & _
			   "databaseuser:" & dbname & vbcrlf & _
			   "years:" & years & vbcrlf & _
			   "." & vbcrlf
	renewdata=pcommand(commandstr,u_name)
end function
function uphost(byval user_name,byval s_comment,byval targetT,byval updateType)
	commandstr="vhost"& vbcrlf & _
			   "set"& vbcrlf & _
			   "entityname:upvhost" & vbcrlf & _
			   "hostname:" & s_comment & vbcrlf & _
			   "TargetProductid:" & TargetT & vbcrlf & _
			   "updateType:" & updateType & vbcrlf & _
			   "." & vbcrlf
	uphost=pcommand(commandstr,user_name)
end function

function upmail(byval user_name,byval m_bindname,byval targetT,byval updateType)
	commandstr="other"& vbcrlf & _
			   "upgrade"& vbcrlf & _
			   "entityname:mail" & vbcrlf & _
			   "domain:" & m_bindname & vbcrlf & _
			   "TargetProductid:" & TargetT & vbcrlf & _
			   "." & vbcrlf

		   
	upmail=pcommand(commandstr,user_name)

end function
function updata(byval user_name,byval dbname,byval targetT,byval updateType)
	commandstr="other"& vbcrlf & _
			   "upgrade"& vbcrlf & _
			   "entityname:mssql" & vbcrlf & _
			   "databasename:" & dbname & vbcrlf & _
			   "TargetProductid:" & TargetT & vbcrlf & _
			   "." & vbcrlf

	updata=pcommand(commandstr,user_name)

end function
function getShouxufei(byval ftpname,byval newproid)
	getShouxufei=0
	newproid=replace(newproid,"'","")
	dim mysqlHost_Types,javaHost_types,linuxHost_types,autoHost_Types,twoHost_Types
	dim duoHost_Types,jiqunHost_Types,usaHost_Types,taiwanHost_Types,ceshiHost_Types
	dim specialHost_Types,iHost_Types,hosttypes2
	dim rsTS,sql
	dim productname,productid,oProductID,nProductID
	
	Set mysqlHost_Types = CreateObject("scripting.dictionary")'MYSQL专用
	Set javaHost_types = CreateObject("scripting.dictionary")'java主机
	Set linuxHost_types = CreateObject("scripting.dictionary")'linux主机
	Set autoHost_Types = CreateObject("scripting.dictionary")'智能建站
	Set twoHost_Types = CreateObject("scripting.dictionary")'双线
	Set duoHost_Types = CreateObject("scripting.dictionary")'多线
	Set jiqunHost_Types = CreateObject("scripting.dictionary")'集群
	Set usaHost_Types = CreateObject("scripting.dictionary")'美国
	Set taiwanHost_Types = CreateObject("scripting.dictionary")'台湾
	Set ceshiHost_Types = CreateObject("scripting.dictionary")'测试
	Set specialHost_Types = CreateObject("scripting.dictionary")'专用
	Set iHost_Types = CreateObject("scripting.dictionary")	'国内虚拟主机
	Set hosttypes2 = CreateObject("scripting.dictionary")	'
	'＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
	'读取所有产品并把型号分开，存在各自变量中。目前只有这种方式来判断虚拟主机类型中的类型了
	sql = "select p_ProID,p_name from productlist where p_type=1 order by p_name,p_ProID desc"
	set rsTS=server.CreateObject("adodb.recordset")
	rsTS.open sql,conn,1,1
	while not rsTS.eof
	productname = lcase(rsTS("p_name"))
	productid = lcase(rsTS("p_ProID"))
	if instr(productname,"mysql")>0 then 			'MYSQL数据库
		mysqlHost_Types.add productid,""
	elseif instr(productname,"java")>0 then
		javaHost_types.add productid,""
	elseif instr(productname,"linux")>0 then
		linuxHost_types.add productid,""
	elseif instr(productname,"智能")>0 then
		autoHost_Types.add productid,""
	elseif instr(productname,"双线")>0 then
		twoHost_Types.add productid,""
	elseif instr(productname,"多线")>0 then
		duoHost_Types.add productid,""
	elseif instr(productname,"集群")>0 then
		jiqunHost_Types.add productid,""
	elseif instr(productname,"美国")>0 then
		usaHost_Types.add productid,""
	elseif instr(productname,"港台")>0 or instr(productname,"香港")>0 or instr(productname,"台湾")>0 then
		taiwanHost_Types.add productid,""
	elseif instr(productname,"测试")>0 then
		ceshiHost_Types.add productid,""
	elseif instr(",agentnew,b069,b041,w041,b050,b800,b043,w043," , ","&productid&"," )>0 then'特殊主机：代理/特惠/学生
		specialHost_Types.add productid,""
	else											
		iHost_Types.add productid,""
	end if
	rsTS.movenext
	wend
	rsTS.close
	'＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
	for each a1 in iHost_Types : hosttypes2.add a1,"" : next
	for each a1 in twoHost_Types :hosttypes2.add a1,"" :next
	for each a1 in duoHost_Types :hosttypes2.add a1,"" :next
	'＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
	sql="Select s_ProductId from vhhostlist where s_comment='" & ftpname & "'"
	rsTS.open sql,conn,1,1
	if rsTS.eof then exit function
	oProductID = Lcase(rsTs("s_ProductId"))'旧型号
	nProductId = lcase(newproid) '新型号
	rsTS.close

	if hosttypes2.exists(oProductID) then
		if not hosttypes2.exists(nProductID) then getShouxufei=20
	elseif linuxHost_types.exists(oProductID) then
		if not linuxHost_types.exists(nProductId) then getShouxufei=20
	elseif javaHost_types.exists(oProductID) then
		if not javaHost_types.exists(nProductID) then getShouxufei=20
	elseif autoHost_Types.exists(oProductID) then
		if not autoHost_Types.exists(nProductID) then getShouxufei=20
	elseif jiqunHost_Types.exists(oProductId) then
		if not jiqunHost_Types.exists(nProductId) then getShouxufei=20
	elseif taiwanHost_Types.exists(oProductId) then
		if not taiwanHost_Types.exists(nProductId) then getShouxufei=20
	elseif usaHost_Types.exists(oProductId) then
		if not usaHost_Types.exists(nProductId) then getShouxufei=20
	end if

end Function
%>