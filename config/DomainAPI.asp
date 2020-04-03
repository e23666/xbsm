<!--#include virtual="/config/Interface_bizcn.asp" -->
<!--#include virtual="/config/Interface_xinet.asp" -->
<!--#include virtual="/config/Interface_dnscn.asp" -->
<!--#include virtual="/config/Interface_netcn.asp" -->
<%

sub writelog_domain(xinfo)
	line=Replace(xinfo,"'","")
	conn.Execute("insert into ActionLog (ActionUser,Remark,AddTime,LogType) values('API','" & line & "',now(),'API')")
end sub


Function isChinese(para) '--------汉字的叛断
       On Error Resume Next
       isChinese = False
       Dim str
       Dim i
       Dim c
       If IsNull(para) Then
          isChinese = False
          Exit Function
       End If
       str = CStr(para)
       If Trim(str) = "" Then
          isChinese = False
          Exit Function
       End If
       For i = 1 To Len(str)
       c = Asc(Mid(str, i, 1))
             If c < 0 Then
                isChinese = True
                Exit For
           End If
       Next
	   if left(trim(str),4)="xn--" then isChinese = True:exit function
       If Err.Number <> 0 Then Err.Clear
End Function

function punycode(strdomain)
  on error resume next
	  PHPURL="http://beianmii.gotoip1.com/idna/api.php?a=encode&p="&server.URLEncode(strdomain) & "&pasd="& timer()
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 10000, 10000, 10000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  punycode=retCode'myinstr(retCode,":\s+([\w\.\-]+)\s*</pre>")
end function

function myinstr(byval mystring, byval regstr)
			itm1=""
			set m_RegExp1 = New RegExp	
			m_RegExp1.Pattern=regstr
			set regExplist1=m_RegExp1.execute(mystring)
			for each vv1 in regExplist1
				itm1=vv1.subMatches(0)
			next
			set m_RegExp1=nothing
			myinstr=itm1
end function
function chgStrCmd(ByVal szCmd,ByVal opt,ByVal fdname,ByVal fdvalue)
	chgStrCmd=szCmd
	select case opt
		case "set"
			ifdLen=len(fdname)
			iPos=instr(szCmd,fdname & ":")
			if iPos=0 then Exit Function
			jPos=instr(iPos,szCmd,vbcrlf)
			if jPos=0 then Exit Function
			chgStrCmd=left(szCmd,iPos+ifdLen) & fdvalue & mid(szCmd,jPos)
		case "del"
			ifdLen=len(fdname)
			iPos=instr(szCmd,fdname & ":")
			if iPos=0 then Exit Function
			jPos=instr(iPos,szCmd,vbcrlf)
			if jPos=0 then Exit Function			
			chgStrCmd=left(szCmd,iPos-1) & mid(szCmd,jPos+2)
		case "add"
			iPos=instr(szCmd,vbcrlf & "." & vbcrlf)
			if iPos=0 then exit function
			chgStrCmd=left(szCmd,iPos-1) & vbcrlf & fdname & ":" & fdvalue & mid(szCmd,iPos)
		case "chg-head"
			iPos=instr(vbcrlf & szCmd,vbcrlf & fdname & vbcrlf)
			if iPos=0 then exit function
			if iPos=1 then
				chgStrCmd=fdvalue & mid(szCmd,len(fdname)+1)
			else
				iPos=iPos-2
				chgStrCmd=left(szCmd,iPos+1) & fdvalue & mid(szCmd,iPos+2+len(fdname))
			end if
	end select
end function


function CheckDomainReg(ByVal strUserCmd,m_register)
	strDomain=getInput("domainname")
	years=getInput("term")
	dom_st_m=getInput("dom_st_m")
	p_proid=GetDomainType(strDomain)

	dns1=getInput("dns_host1")
	dns2=getInput("dns_host2")
	
	if isChinese(strDomain) then
		if  dns1=default_dns1 then
		
			if m_register="bizcn" then
				dns1="ns1.4everdns.com"
				dns2="ns2.4everdns.com"
				dns_ip1="218.5.77.19"
				dns_ip2="61.151.252.240"

			elseif m_register="netcn" then
				dns1="dns11.hichina.com"
				dns2="dns12.hichina.com"
				dns_ip1="218.30.103.150"
				dns_ip2="218.244.143.82"
			elseif m_register="xinet" then
				dns1=xinet_mns
				dns2=xinet_mns
				dns_ip1="210.51.170.66"
				dns_ip2="61.236.150.177"
			else
				dns1=default_dns1
				dns2=default_dns2
				dns_ip1=default_ip1
				dns_ip2=default_ip2
			end if
		 
			strUserCmd=chgStrCmd(strUserCmd,"set","dns_host1",dns1)
			strUserCmd=chgStrCmd(strUserCmd,"set","dns_host2",dns2)
			strUserCmd=chgStrCmd(strUserCmd,"set","dns_ip1",dns_ip1)
			strUserCmd=chgStrCmd(strUserCmd,"set","dns_ip2",dns_ip2)
		 end if

		if m_register="bizcn" then
				strUserCmd=chgStrCmd(strUserCmd,"set","dom_st_m","中国" & dom_st_m)	
		end if

		if m_register="xinet" then
				strUserCmd=chgStrCmd(strUserCmd,"set","dmtype","CHI")	
		end if

		iTmpPos=instrRev(strDomain,".")
		strSuffix=mid(strDomain,iTmpPos+1)

		if isChinese(strSuffix) then
			'中文国内
			strUserCmd=chgStrCmd(strUserCmd,"chg-head","domainname","chinesedomain")
			strUserCmd=chgStrCmd(strUserCmd,"add","year",years)
		else
			'中文国际
			if m_register="bizcn" then
					strUserCmd=chgStrCmd(strUserCmd,"add","language","chinese")	
					strUserCmd=chgStrCmd(strUserCmd,"set","domainname",punycode(strDomain))	
			end if
		end if
	else
		'英文国际域名
		if p_proid="domcn" then
				strUserCmd=chgStrCmd(strUserCmd,"set","entityname","domaincn")				
				strUserCmd=chgStrCmd(strUserCmd,"add","admi_org",getInput("dom_org"))				
		end if

		if dns1=default_dns1 and not using_dns_mgr then
			select case m_register
				case "xinet"
					dns1=xinet_dns1
					dns2=xinet_dns2
				case "dnscn"
					dns1=dnscn_dns1
					dns2=dnscn_dns2				
				case "netcn"
					dns1=netcn_dns1
					dns2=netcn_dns2				
				case "bizcn"
					dns1=bizcn_dns1
					dns2=bizcn_dns2
					dns_ip1=bizcn_ip1
					dns_ip2=bizcn_ip2
			end select
			if m_register<>"default" then
				strUserCmd=chgStrCmd(strUserCmd,"set","dns_host1",dns1)
				strUserCmd=chgStrCmd(strUserCmd,"set","dns_host2",dns2)
				strUserCmd=chgStrCmd(strUserCmd,"set","dns_ip1",dns_ip1)
				strUserCmd=chgStrCmd(strUserCmd,"set","dns_ip2",dns_ip2)
			end if
		end if '//如果DNS填写的是我司，又使用的是其它公司的接口，则替换成相应服务商的
	end if
	CheckDomainReg=strUserCmd
end function

function getRegByCmd(ByVal xDo)
	if xDo="add" then
		getRegByCmd=getRegister(getInput("domainname"))
	else
		if xDo="renew" then
			strDomain=getInput("domain")
		else
			strDomain=getInput("domainname")
		end If
		Set lrs=conn.Execute("select dns_host1,bizcnorder from domainlist where strDomain='" & strDomain & "'")
		if lrs.eof then		
			getRegByCmd="Register_not_Exists"
		Else
			getRegByCmd=lrs("bizcnorder")
		end if
		lrs.close:Set lrs=nothing				
	end if
end function

function domainDispatch(Byval AllCmd)
	'现在仅支持四个命令，新注册，续费及获取密码,设置密码
	'optMode=add,renew,get,mod
	dim strdomain
	iPos=instr(AllCmd,vbcrlf)
	jPos=instr(iPos+2,AllCmd,vbcrlf)
	optMode=mid(AllCmd,iPos+2,jPos-iPos-2)
	domain_reg=getRegByCmd(optMode)
	strdomain=getinput("domain")
	if optMode="add" and domain_reg<>"default" then
		AllCmd=CheckDomainReg(AllCmd,domain_reg)
		glbArgus("strCmd")=AllCmd
	end If

	if left(strdomain,4)="xn--" and (domain_reg="bizcn" or domain_reg="xinet") Then
				s_memo=""
				Set s_rs=conn.execute("select s_memo from domainlist where strDomain='"& strdomain &"'")
				If Not s_rs.eof then
					s_memo=s_rs("s_memo")
				End if
				s_rs.close:Set s_rs=Nothing
				If s_memo="" Then s_memo=Gbkcode(strdomain)
				AllCmd=chgStrCmd(AllCmd,"set","domainname",s_memo)
	end If

	select case domain_reg
		case "bizcn"
			domainDispatch=gotoBizcn(AllCmd,optMode)
		case "xinet"
			domainDispatch=gotoXinet(AllCmd,optMode)
		case "dnscn"
			domainDispatch=gotoDnscn(AllCmd,optMode)
		case "netcn"
			domainDispatch=gotoNetcn(AllCmd,optMode)
		case else
			domainDispatch=connecttoUp(AllCmd)
	end select

	if optMode="mod" and usMYDNS(getinput("domainname")) and domain_reg<>"default" then
			domainDispatch=connecttoUp(AllCmd)
	end if
end function

Function usMYDNS(Byval xDom)
	usMYDNS=false
	Set krs=conn.Execute("select dns_host1 from domainlist where strdomain='" & xDom & "'")
	if not krs.eof then
		if krs(0)=default_dns1 then usMYDNS=true
	end if
	krs.close:set krs=nothing
end function
%>