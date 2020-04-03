<%
function getReturnAPI_rrset(ByVal inputStr,ByVal fdname)
	fdname=fdname & ":"
	fdname_len=len(fdname)
	ipos=instr(inputStr,fdname)
	if ipos>0 then
		jpos=instr(ipos,inputStr,vbcrlf  & "." & vbcrlf)
			if jpos>0 then
				fieldStr=mid(inputStr,ipos,jpos-ipos)					
				getReturnAPI_rrset=mid(fieldStr,fdname_len+1)
			end if
	end if	
end function

sub writelog_api(xinfo)
	logPath=Server.MapPath("/") & "\AgentLogs"
	fName="\AGENT_API_" & Cstr(date()) & ".log"
	physicalPath=logPath & fName
	Set objFile=CreateObject("Scripting.FileSystemObject")
	if not objFile.FolderExists(logPath) then
		objFile.CreateFolder logPath
	end if
	Set objHander=objFile.openTextFile(physicalPath,8,true)
	line=now & vbcrlf & "IP:" & Request.ServerVariables("Remote_Addr") & vbcrlf & "User:" & userid & vbcrlf & strCmd & vbcrlf & xinfo & vbcrlf
	objHander.write(line)
	objHander.close
	Set objHander=nothing
	Set objFile=nothing
end sub

sub die(strMsg)
	Response.write "501 " & strMsg
	Response.end
end sub

Sub sigCheck(ByVal userid,ByVal strCmd,ByVal tocheckMd5)
	
	if not api_open then
		Call Die("服务商未开放API使用接口")
	end if

	if not regcheck("\w{2,}",userid) then 
		Call Die("无效的用户名")
	end if

	QState="SELECT APIuser_list.* FROM APIuser_list INNER JOIN UserDetail ON APIuser_list.u_id = UserDetail.u_id WHERE (((APIuser_list.a_lock)=0) AND ((UserDetail.u_name)='" & userid & "'))"
	Set URs=conn.Execute(QState)
	if URs.eof then
		Call Die("代理帐户不存在")
	end if

	a_password=URs("a_password")
	a_IPlist=URs("a_IPlist")

	Set URs=nothing

	strCheck=asp_md5(userid & a_password & left(strCmd,10))
	
	if strCheck<>tocheckMd5 then
		Call Die("md5验证失败")
	end if

	if a_IPlist<>"" then
		a_IPlist_array=split(a_IPlist,",")
		logIp= Getuserip()'Request.ServerVariables("Remote_Addr")

		if not inArray(a_IPlist_array,logIp) then
			Call Die("无效的登录IP" & logIp)
		end if

	end if
end Sub

function GetuserIp()
  Dim strIPAddr 
  If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" OR InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then 
    strIPAddr = Request.ServerVariables("REMOTE_ADDR") 
  ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then 
    strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",")-1) 
  ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then 
    strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";")-1) 
  Else 
    strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
  End If
  GetuserIp = Trim(Mid(strIPAddr, 1, 30))
  if not isip(GetuserIp) then GetuserIp=""
end function


function inArray(objSearch,ByVal objItem)
		objItem=Lcase(objItem)

		for i=0 to Ubound(objSearch)
			arrayItem=Trim(lcase(objSearch(i)))
			if objItem=arrayItem then
				inArray=true
				exit function
			end if
		next
		inArray=false
end function

Sub checkAllParam(ByVal strCmd)
	intPos=inStr(strCmd,vbcrlf)
	if intPos=0 then Call Die("命令格式无效")

	act_type=left(strCmd,intPos-1)

	if not inArray(Array("vhost","domainname","mssql","corpmail","other","dnsresolve","server"),act_type) then
		Die "操作码不正确"
	end if

	intFinal=inStr(strCmd,vbcrlf & "." & vbcrlf)
	if intFinal=0 then
		Die "命令格式无效"
	end if

	strLocal=strCmd
	intPos=instr(strLocal,vbcrlf)

	do while intPos>0
		strField=left(strLocal,intPos-1)
		if strField="." then
			exit do
		end if
	
		intPosJ=inStr(strField,":")
	
		if intPosJ=0 then
			if not regcheck("[a-z]{1,20}",strField) then Call Die(strField & "无效1")
		else
			strCmdName=left(strField,intPosJ-1)
			strCmdValue=mid(strField,intPosJ+1)

	
			if strCmdName="content" and act_type="other" then
				'忽略有问必答内容检测
				exit sub
			end if

			if not regcheck("[a-z0-9_\-]{1,20}",strCmdName) then
				Call Die(strField & "无效2")
			end if
	
		end if
		strLocal=mid(strLocal,intPos+2)
		intPos=instr(strLocal,vbcrlf)
	loop

end Sub


function getInputAPI(Byval Keyname)
	getInputAPI=""
	fdname=Keyname & ":"
	fdname_len=len(fdname)
	ipos=instr(strCmd,fdname)
	if ipos>0 then
		jpos=instr(ipos,strCmd,vbcrlf)
			if jpos>0 then
				fieldStr=mid(strCmd,ipos,jpos-ipos)					
				getInputAPI=mid(fieldStr,fdname_len+1)
			end if
	end if
end function

sub checkowner(u_name,strCmd)
	u_id=u_sysid
	intPos=instr(strCmd,vbcrlf)
	ACT_TYPE=left(strCmd,intPos-1)
	intPosJ=instr(intPos+1,strCmd,vbcrlf)
	ACT_ENTITY=mid(strCmd,intPos+2,intPosJ-intPos-2)
	
	strCheckSQL=""
	blTocheck=false

	select case ACT_TYPE
		case "vhost"
			if ACT_ENTITY<>"add" then
				blTocheck=true
				strCheckSQL="select s_sysid from vhhostlist where s_comment='" & get_cmd_identity("vhost") & "' and s_ownerid=" & u_id 
			end if
		case "domainname"
			if ACT_ENTITY<>"add" and ACT_ENTITY<>"check" then
				blTocheck=true
				strCheckSQL="select d_id from domainlist where strdomain='" & get_cmd_identity("domain") & "' and userid=" & u_id 
			end if
		case "mssql"
			if ACT_ENTITY<>"add" then
				blTocheck=true
				strCheckSQL="select dbsysid from databaselist where dbname='" & get_cmd_identity("mssql") & "' and dbu_id=" & u_id
			end if			
		case "corpmail"
			if ACT_ENTITY<>"add" then
				blTocheck=true
				strCheckSQL="select m_sysid from mailsitelist where m_bindname='" & get_cmd_identity("mail") & "' and m_ownerid=" & u_id
			end if			
	end select


	if blTocheck then
		Set localRs=conn.Execute(strCheckSQL)
		if localRs.eof then
			Call Die("警告!业务不属于您,您无权操作" & ACT_TYPE & "," & ACT_ENTITY)
		end if
		localRs.close
		Set localRs=nothing
	end if
end sub

sub checkCommand(ByVal strCmd)

	Set allCmds=CreateObject("Scripting.Dictionary"):allCmds.CompareMode=1

	'allCmds.Add "vhost",Array(Array("add","vhost"),Array("traffic","add"),Array("renewal","vhost"),Array("paytest","vhost"),Array("mod","ftppassword"),Array("set","upvhost","reupvhost"))
	'allCmds.Add "domainname",Array(Array("add","domain","domaincn"),Array("mod","domain-passwd"),Array("renew","domain"),Array("check","domain-check","regi"),Array("open","urlforword"),Array("reopen","urlforword"),Array("trans","renin","get_reg","get_state","goepp","getprice","newin","isagent"))
	'allCmds.Add "mssql",Array(Array("add","mssql"),Array("mod","chgpwd"),Array("renewal","mssql"))
	'allCmds.Add "server",Array(Array("add","server"),Array("renew","server"),array("set","upserver","modinfo","reupserver"))
	'allCmds.Add "corpmail",Array(Array("add","corpmail","freecorpmail"),Array("mod","mmasterpass"),Array("renewal","corpmail"))
'	allCmds.Add "other",Array(Array("get","mykefuinfo","roomlist","tablecontent","tmptablecontent","ftppassword","mailpassword","mssqlpassword","usemoney","pricecompare","vhostexists","domainpassword","question","invoice","uphostinfo","upmssqlinfo","bgplinux","server_roomlist","server_paymethod","get_roomlistname","server_roomlist_info","upserverinfo","oslist","getotherip"),Array("upgrade","mail","mssql"),Array("add","invoice","question","sms"),Array("paytest","mail"),Array("sync","vhost","domain","mail","database","allpassword","record","server"),Array("test","test"))
'	allCmds.Add "dnsresolve",Array(Array("add","dnsdomain"))
allCmds.Add "vhost",Array(Array("add","vhost","openmysql"),Array("traffic","add"),Array("renewal","vhost"),Array("paytest","vhost"),Array("mod","ftppassword","removedomain","adddomain"),Array("set","upvhost","reupvhost"),Array("get","vhostinfo"))
	allCmds.Add "domainname",Array(Array("add","domain","domaincn"),Array("mod","domain-passwd","domain-dns"),Array("renew","domain"),Array("check","domain-check","regi","isxmname"),Array("open","urlforword"),Array("reopen","urlforword"),Array("trans","renin","get_reg","get_state","goepp","getprice","newin","isagent"),Array("transfer","request","status","check"),Array("info","domain","uploadstate"),Array("transfer","status") )
	allCmds.Add "mssql",Array(Array("add","mssql"),Array("mod","chgpwd"),Array("renewal","mssql"))
	allCmds.Add "server",Array(Array("add","server"),Array("renew","server"),array("set","upserver","modinfo","reupserver","upserverdiy"),Array("paytest","entityname","serverdiy"),Array("manage","serverdiy","getserverinfo","backup","changeroom","getserverlog","addwhite","whitelist","delwhite","serverreload","disktype","buyserverip","getworkorder","addworkorder","uppassword","getdb","myhostpassword","otherips"))
	allCmds.Add "corpmail",Array(Array("add","corpmail","freecorpmail"),Array("mod","mmasterpass"),Array("renewal","corpmail"))
	allCmds.Add "other",Array( Array("aprice","elite"),Array("get","expdate","oslist","mykefuinfo","roomlist","tablecontent","tmptablecontent","ftppassword","mailpassword","mssqlpassword","usemoney","pricecompare","vhostexists","domainpassword","question","invoice","iscaninvoice","uphostinfo","upmssqlinfo","bgplinux","server_roomlist","server_paymethod","get_roomlistname","server_roomlist_info","upserverinfo","getotherip","domainauditstatus","mysqlver"),Array("upgrade","mail","mssql"),Array("upload","domainfile"),Array("add","invoice","question","sms"),Array("paytest","mail","mssql"),Array("sync","vhost","domain","mail","database","allpassword","record","server"),Array("test","test"),Array("expired","list","movein","status"))
	allCmds.Add "dnsresolve",Array(Array("add","dnsdomain","dnsrecord"),Array("mod","dnsrecord"),Array("del","dnsrecord"),Array("list","dnsrecord"))
	
	intPos=instr(strCmd,vbcrlf)
	ACT_PRODUCT=left(strCmd,intPos-1)
	intPosJ=instr(intPos+1,strCmd,vbcrlf)
	ACT_TYPE=mid(strCmd,intPos+2,intPosJ-intPos-2)
	ACT_ENTITY=getInputAPI("entityname")
	if not allCmds.Exists(ACT_PRODUCT) then
		Call Die("无效的命令")
	end if

	blCheck=false
	array_check=allCmds.Item(ACT_PRODUCT)
	for i=0 to Ubound(array_check)
		if array_check(i)(0)=ACT_TYPE then
			blCheck=true
			Exit for
		end if
	next

	if not blCheck then
		Call Die("无效的子命令")
	end if

	blCheck=false
	for j=1 to Ubound(array_check(i))
		if ACT_ENTITY=array_check(i)(j) then
			blCheck=true
			exit for
		end if
	next

	if not blCheck then
		Call Die("无效的操作对象2")
	end if

	Set allCmds=nothing
end sub

function get_cmd_identity(byVal vType)
	'获取每种不同类别命令的标识符
	select case vType
		case "vhost"
			identField=Array("ftpuser","sitename","hostname")
		case "domain"
			identField=Array("domainname","domain")
		case "mssql"
			identField=Array("databasename")
		case "mail"
			identField=Array("domainname")
	end select

	iFound=false

	for each keyWords in identField
		if getInputAPI(keyWords)<>"" then
			get_cmd_identity=getInputAPI(keyWords)
			iFound=true
			exit for
		end if
	next
	if not iFound then 
		Die "命令缺少标识符"
	end if
end function

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
%>