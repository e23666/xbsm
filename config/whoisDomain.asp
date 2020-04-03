<%
class WhoisDomain_Class
	
	Public DomainResult,nowcnUrl,nowcnUrl1,netcnUrl,xinnetUrl
	public DomainResult_allow,DomainResult_cancel,DomainResult_nonestr,DomainResult_prestr
	Private Sub Class_Initialize()
		nowcnUrl = "http://now.net.cn/domain/domaincheck.php" '接口地址
		nowcnUrl1 = "http://www.now.cn/domain/CNMcheck.net" '远程读取地址
		netcnUrl = "http://panda.www.net.cn/cgi-bin/check_muitl.cgi"
		xinnetUrl = "http://www.paycenter.com.cn/cgi-bin/Check"
		west263Url = api_url
		DomainResult_allow = ""
		DomainResult_cancel = ""
		DomainResult_nonestr = ""
	   
	End Sub
	Private Sub Class_Terminate()
		DomainResult_allow = ""
		DomainResult_cancel = ""
		DomainResult_nonestr = ""
	End Sub
	Public Function checkExists(ByVal checktype, ByVal domainname, ByVal suffix)
		Dim allStr
		Dim cancelStr
		Dim nonestrStr
		if len(domainname)>0 then
			Select Case LCase(Trim(checktype))
			Case "nowcn"
				 Call nowcnwhois(domainname, suffix)
			Case "nowcn1"
				 Call nowcnwhois1(domainname, suffix)
			Case "netcn"
				 Call netcnwhois(domainname, suffix)
			Case "xinet"
				 Call xinetwhois(domainname, suffix)
			Case "xinnet"
				 Call xinetwhois(domainname, suffix)
			Case "bizcn"
				 Call bizcnwhois(domainname, suffix)
			Case "west263"
				 call west263whois(domainname,suffix)
			Case Else
				checkExists = doresultstr("500 err", "查询参数checktype错误")
				Exit Function
			End Select
		else
			for each domain_item in split(domainname,",")
				domain_item=trim(domain_item)
				if domain_item<>"" then
					for each suffix_item in split(suffix,",")
						suffix_item=trim(suffix_item)
						if suffix_item<>"" then
							If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
							DomainResult_nonestr=DomainResult_nonestr &","& domain_item & "." & suffix_item
						end if
					next
				end if
			next
		end if
		allStr = DomainResult_allow
		cancelStr = DomainResult_cancel
		nonestrStr = DomainResult_nonestr
		preStr = DomainResult_prestr
		If Right(allStr, 1) = "," Then allStr = Left(allStr, Len(allStr) - 1)
		If Right(cancelStr, 1) = "," Then cancelStr = Left(cancelStr, Len(cancelStr) - 1)
		If Right(nonestrStr, 1) = "," Then nonestrStr = Left(nonestrStr, Len(nonestrStr) - 1)
		If Right(preStr, 1) = "," Then preStr = Left(preStr, Len(preStr) - 1)
		ReturnString = "a:" & allStr & ";"
		ReturnString = ReturnString & "b:" & cancelStr & ";"
		ReturnString = ReturnString & "c:" & nonestrStr &";"
		ReturnString = ReturnString & "d:" & preStr &";"
		checkExists = doresultstr("200 ok", ReturnString)
	End Function
	Private Function doresultstr(ByVal resultnum, ByVal resultstr)
		Dim resultstring
		resultstring = resultnum & vbCrLf
		resultstring = resultstring & "return:" & resultstr & vbCrLf
		resultstring = resultstring & "." & vbCrLf
		doresultstr = resultstring
	End Function
	Private function west263whois(byval domain,byval suffix)
	'西部数码查询
		commandstr="domainname" & vbcrlf & _
                   "check" & vbcrlf & _
				   "entityname:domain-check" & vbcrlf & _
				   "domainname:" & domain & vbcrlf & _
				   "suffix:" & suffix & vbcrlf & _
				   "." & vbcrlf

		TakenHTML=pcommand(commandstr,"AgentUserVCP")
		'die TakenHTML
		'response.write "["&TakenHTML&"]"
		if left(trim(TakenHTML)&"",3)="200" then
			returnArr=split(split(TakenHTML,vbcrlf)(1),";")
			 
			for cur=0 to ubound(returnArr)
					return_item=lcase(trim(returnArr(cur)))
					if return_item<>"" then
						return_value=trim(right(return_item,len(return_item)-2))
					'response.write(left(return_item,2)&"="&return_value&"<hr>")
						if left(return_item,2)="a:" then
							DomainResult_allow=return_value
						elseif left(return_item,2)="b:" then
							DomainResult_cancel=return_value
						elseif left(return_item,2)="c:" then
							DomainResult_nonestr=return_value
						else
							DomainResult_prestr=return_value
						end if
					end if
			next
		else
			for each domain_item in split(domain,",")
				domain_item=trim(domain_item)
				if domain_item<>"" then
					for each suffix_item in split(suffix,",")
						suffix_item=trim(suffix_item)
						if suffix_item<>"" then
							If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
							DomainResult_nonestr=DomainResult_nonestr &","& domain_item & "." & suffix_item
						end if
					next
				end if
			next
		end if
	end function
	Private Function nowcnwhois1(ByVal domain, ByVal suffix)
	'时代互联查询(远程读取网页方式)
		
		Dim TakenHTML, returnStr, suffixlist
		Dim Domainlist, DomainStr
		Dim domaincount
		For Each domain_item In Split(domain, ",")
			domain_item = Trim(domain_item)
			If domain_item <> "" Then
				domaincount = 0
				Domainlist = ""
				For Each suffix_item In Split(suffix, ",")
					suffix_item = Trim(suffix_item)
					If suffix_item <> "" Then
						If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
						suffixlist = suffixlist & "&domain[]=." & suffix_item
						DomainStr = domain_item & "." & suffix_item
						Domainlist = Domainlist & DomainStr & ","
						domaincount = domaincount + 1
					End If
				Next
				
				If domaincount <= 2 Then
					Call nowcnwhois(domain_item, suffix)
				Else
					TakenHTML = checkwebPost(nowcnUrl1, "query=" & domain_item & suffixlist)
					Call checkNowCnwebBody(TakenHTML, Domainlist)
				End If
			End If
	   Next
	  
		
	End Function
	Public Function checkNowCnwebBody(ByVal htmlBody, ByVal Domaininfo)
		Dim getBody 
		Dim startIndex
		Dim oneStr, oneStr1, twoStr, twoStr1
		Dim isfind: isfind = False
		
		 For Each domain_item In Split(Domaininfo, ",")
			domain_item = Trim(domain_item)
			If InStr(domain_item, ".") > 0 Then
					startIndex = InStr(htmlBody, domain_item & Chr(32))
					If startIndex = 0 Then startIndex = InStr(htmlBody, domain_item & Chr(9))
					If startIndex > 0 Then
						oneStr = Left(htmlBody, startIndex)
						oneStr1 = InStrRev(oneStr, vbCrLf) + 2
						twoStr = Right(htmlBody, Len(htmlBody) - oneStr1)
						twoStr1 = InStr(twoStr, vbCrLf)
						If twoStr1 > 0 And oneStr1 > 0 Then
							isfind = True
							getBody = Mid(htmlBody, oneStr1, twoStr1) '有域名的那一行数据
	
							If InStr(getBody, "没被注册") > 0 Then
								DomainResult_allow = DomainResult_allow & domain_item & ","
							ElseIf InStr(getBody, "已被注册") > 0 Then
							  DomainResult_cancel = DomainResult_cancel & domain_item & ","
							Else
								DomainResult_nonestr = DomainResult_nonestr & domain_item & ","
							End If
						End If
					End If
					If Not isfind Then
						 DomainResult_nonestr = DomainResult_nonestr & domain_item & ","
					End If
				
			End If
		 Next
	End Function
	Private Function nowcnwhois(ByVal domain, ByVal suffix)
	'时代互联查询(通过接口方式)
		Dim TakenHTML
		Dim DomainStr
		domain = Trim(domain)
		For Each suffix_item In Split(suffix, ",")
			suffix_item = Trim(suffix_item)
			If suffix_item <> "" Then
				If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
				DomainStr = domain & "." & suffix_item
				TakenHTML = checkwebPost(nowcnUrl & "?query=" & DomainStr, "")
				If InStr(TakenHTML, "恭喜") Then
							DomainResult_allow = DomainResult_allow & DomainStr & ","
				ElseIf InStr(TakenHTML, "已被") Then
							DomainResult_cancel = DomainResult_cancel & DomainStr & ","
				Else
							DomainResult_nonestr = DomainResult_nonestr & DomainStr & ","
	
				End If
			End If
		Next
	End Function
	Private Function netcnwhois(ByVal domain, ByVal suffix)
 
	'万网查询
		Dim this_querystring
		Dim DomainStr
		Dim resultnum, resultDomain
		Dim Domainlist: Domainlist = ""
		
		For Each domain_item In Split(domain, ",")
			domain_item = Trim(domain_item)
			If domain_item <> "" Then
				For Each suffix_item In Split(suffix, ",")
					suffix_item = Trim(suffix_item)
					If suffix_item <> "" Then
						If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
						DomainStr = domain_item & "." & suffix_item
						if instr(","&Domainlist&",",","&DomainStr&",")=0 then
						Domainlist = Domainlist & DomainStr & ","
						end if

					End If
				Next
			End If
		Next

	'	die Domainlist
				If Right(Domainlist, 1) = "," Then Domainlist = Left(Domainlist, Len(Domainlist) - 1)
				this_querystring = netcnUrl
			
				TakenHTML = checkwebPost(this_querystring, "domain=" & Domainlist)
				For Each resultDomain_item In Split(TakenHTML, vbCrLf)
					resultDomain_item = Trim(resultDomain_item)
					resultdomain_Arr = Split(resultDomain_item,"|")
					If UBound(resultdomain_Arr) >= 2 Then
					   resultnum = Trim(resultdomain_Arr(2))
					   resultDomain = Trim(resultdomain_Arr(1))
					   If resultnum = "210" Then
							 DomainResult_allow = DomainResult_allow & resultDomain & ","
					   ElseIf resultnum = "211" Or resultnum = "212" Then
							 DomainResult_cancel = DomainResult_cancel & resultDomain & ","
					   Else
							 DomainResult_nonestr = DomainResult_nonestr & resultDomain & ","
					   End If
					   
					End If
				Next
	
	End Function
	Private Function bizcnwhois(ByVal domain, ByVal suffix)
	'商中
		Dim this_querystring: this_querystring = ""
		Dim DomainStr
		Dim resultstr
		Dim Domainlist: Domainlist = ""
		Dim isOK: isOK = False
	
		
	   
		If ischinese(domain) Or ischinese(suffix) Then
			If ischinese(suffix) Then '中文后辍
				 this_querystring = "chinesedomain" & vbCrLf
				 this_querystring = this_querystring & "check" & vbCrLf
				 this_querystring = this_querystring & "entityname:domains" & vbCrLf
			Else '英文后辍
				 this_querystring = "domainname" & vbCrLf
				 this_querystring = this_querystring & "check" & vbCrLf
				 this_querystring = this_querystring & "entityname:chinese-international-domain" & vbCrLf
			End If
		Else
			this_querystring = "domainname" & vbCrLf
			this_querystring = this_querystring & "check" & vbCrLf
			this_querystring = this_querystring & "entityname:domains" & vbCrLf
		End If
	  
		 For Each domain_item In Split(domain, ",")
				domain_item = Trim(domain_item)
				If domain_item <> "" Then
				
					For Each suffix_item In Split(suffix, ",")
						suffix_item = Trim(suffix_item)
						If suffix_item <> "" Then
							If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
							DomainStr = domain_item & "." & suffix_item
							this_querystring = this_querystring & "domainname:" & DomainStr & vbCrLf
							Domainlist = Domainlist & DomainStr & ","
						End If
					Next
					
				End If
		  Next
		this_querystring = this_querystring & "." & vbCrLf
		resultstr = biztosocket(this_querystring)
		If InStr(resultstr, vbCrLf) > 0 Then
			If Left(resultstr, 3) = "200" Then
				isOK = True
				For Each resultDomain_item In Split(resultstr, vbCrLf)
					resultDomain_item = Trim(resultDomain_item)
					If InStr(resultDomain_item, ":") > 0 Then
						domainArr = Split(resultDomain_item, ":")
						resultDomain = Trim(domainArr(0))
						reSultstate = Trim(domainArr(1))
						If InStr(Domainlist, resultDomain) > 0 Then
							If reSultstate = "available" Then
								DomainResult_allow = DomainResult_allow & resultDomain & ","
							ElseIf reSultstate = "notavailable" Then
								DomainResult_cancel = DomainResult_cancel & resultDomain & ","
							Else
								DomainResult_nonestr = DomainResult_nonestr & resultDomain & ","
							End If
						End If
					End If
				Next
			End If
		End If
		If Not isOK Then '查询出错时
			 For Each resultDomain_item In Split(Domainlist, ",")
				resultDomain_item = Trim(resultDomain_item)
				If resultDomain_item <> "" Then
					DomainResult_nonestr = DomainResult_nonestr & resultDomain_item & ","
				End If
			 Next
		End If
	  
		
	End Function
	Private Function biztosocket(ByVal strcmd)
		
		Dim instrReturn
		Set mysocket = server.CreateObject("mysocket.aspsock")
		If (Not mysocket.Class_Initial()) Then  '第一：初始化本类
				 instrReturn = "999" + vbCrLf + "无法初始化"
		Else
				 If (Not mysocket.createtcpsocket()) Then  '第二：打开一个socket
					 instrReturn = "999" + vbCrLf + "无法打开一个socket"
				 Else
					 bsuccess = mysocket.connectsocket("127.0.0.1", "8001")
					 '连接socket,第一个参数为所要连接的服务器，第二个为所要连接的端口号
					 mysocket.send (strcmd)
					 mysocket.receive
					 instrReturn = mysocket.receivemessage
					 
				 End If
	   End If
	   
	   biztosocket = instrReturn
	   mysocket.class_teminial  '关闭socket
	   Set mysocket = Nothing '撤消mysocket对象
	End Function
	
	
	Private Function xinetwhois(ByVal domain, ByVal suffix)
	'新网
		Dim newsuffix
		Dim this_querystring
		Dim objinfo
		Dim k
		
		Dim chk
		Dim dm
		Set objinfo =server.CreateObject("Scripting.Dictionary")
		For Each domain_item In Split(domain, ",")
			domain_item = Trim(domain_item) & ""
			If domain_item <> "" Then
				objinfo.removeAll
				newsuffix = ""
				If ischinese(domain_item) Then
					this_querystring = "name=" & server.URLEncode(domain_item) & "&enc=G&client=agent5958"
				Else
					this_querystring = "name=" & domain_item & "&enc=E&client=agent5958"
				End If
				For Each suffix_item In Split(suffix, ",")
					 suffix_item = Trim(suffix_item)
					If Trim(suffix_item) <> "" Then
						If Left(suffix_item, 1) = "." Then suffix_item = Right(suffix_item, Len(suffix_item) - 1)
						If suffix_item <> "mobi" And suffix_item <> "tv" Then
							If ischinese(suffix_item) Then
								suffix_item = server.URLEncode(suffix_item)
							End If
							   newsuffix = newsuffix & "&suffix=." & suffix_item
							
						End If
					End If
				Next

				TakenHTML = checkwebPost(xinnetUrl & "?" & this_querystring & newsuffix, "")
				
				For Each info_item In Split(TakenHTML, "&")
					info_item = Trim(info_item)
					If info_item <> "" Then
						If InStr(info_item, "=") > 0 Then
							newinfo = Split(info_item, "=")
						   objinfo.Add newinfo(0), Replace(Trim(newinfo(1)), Chr(10), "")
							
						End If
					End If
				Next
				nums = CInt(objinfo.Item("num"))
				For k = 1 To nums
							
							chk = Trim(objinfo.Item("chk" & Trim(k)))
							dm = Trim(objinfo.Item("name" & Trim(k)))
							If chk = "100" Then
								DomainResult_allow = DomainResult_allow & dm & ","
							ElseIf chk = "0" Then
							   DomainResult_cancel = DomainResult_cancel & dm & ","
							Else
							   DomainResult_nonestr = DomainResult_nonestr & dm & ","
							End If
				Next
			End If
		Next
		Set objinfo = Nothing
	End Function
end class
%>
