<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/gbtobig.asp" -->
<!--#include virtual="/config/whoisDomain.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<%
Server.ScriptTimeout=300000
response.Charset="gb2312"
response.Buffer=true
t=requesta("t")
session("esymok")=""
whoistoken=request.cookies("whoistoken")
response.cookies("whoistoken")=""
'if whoistoken="" then die "{""code"":500,""msg"":""服务器忙请稍后1!!""}"
'if not isnumeric(t&"") then  die "{""code"":500,""msg"":""服务器忙请稍后1!!""}"
newtimer=ToUnixTime(now(),+8)
'if clng(newtimer-t)>1 then   die "{""code"":500,""msg"":""服务器忙请稍后1!!""}"
token=webmanagesrepwd&api_username&api_password&webmanagespwd&t
sign=md5_16(token)
if sign<>whoistoken then

'die "服务器忙请稍后3!!"
end if
 
conn.open constr
set wd=new checkDomain
returnstr=wd.whoisDomain()
%>


<%
oklist=""   
nolist=""
errlist=""
Prelist=""


if left(returnstr,3)="200" then
	returnarr = wd.resultstr
	session_pd_str=session("whoisValue")

	for i=0 to ubound(returnarr)
		'Response.write "["&returnarr(i)&"]"
		domainTypelist=trim(returnarr(i))
		 

		for each domainlist in split(domainTypelist,",")
			p_proid=""
			explain=""
			Price=0


			domainlist=trim(domainlist&"")
			if instr(domainlist,".")>0 Then
				isyjym=false
				yjprice=0
				if instr(domainlist,"=")>0 then  
					yjarray=split(domainlist,"=")
					domainlist=yjarray(0)
					yjprice=myinstr(yjarray(1),"([\d]+)")
					isyjym=true
				end if
			    p_proid=GetDomainType(domainlist)  '
				explain=getExplain(domainlist)
				if i=0 or i=2 then session_pd_str=session_pd_str& domainlist & "|"		 
	  			othersuffixstr=".tw|.cd|.hk|.ph|.us|.tel"
				getdomainsuffix=trim(mid(domainlist,instr(domainlist,".")))
				otherspd=True
				If InStr(",domcn,domchina,domgovcn,domhzcn,domcom,domnet,domhz,domtop,domxyz,",","&LCase(p_proid)&",")>0 Then
					explain=explain&" <a href=""javascript:;;"" class=""link"" target=""_blank"">【需实名认证】</a>"
				End if

				Select Case CLng(i)
				Case 0
					Price=GetNeedPrice(session("user_name"),p_proid,1,"new")
					If Trim(oklist)="" Then
						oklist="{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
					Else
						oklist=oklist&",{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
					End if
				Case 1
					If Trim(nolist)="" Then
						nolist="{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":""""}"
					Else
						nolist=nolist&",{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":""""}"
					End if
				Case 2
					if isyjym then
						Price=yjprice
						If Trim(Prelist)="" Then
							Prelist="{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
						Else
							Prelist=Prelist&",{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
						End if

					else
						Price=GetNeedPrice(session("user_name"),p_proid,1,"new")
						If Trim(errlist)="" Then
							errlist="{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
						Else
							errlist=errlist&",{""domain"":"""&Escape(domainlist)&""",""p_proid"":"""&p_proid&""",""explain"":"""&Escape(explain)&""",""Price"":"&Price&"}"
						End if
					end if 
					
				End select

			end if
		 next
	next
	'if session_pd_str<>"" and right(session_pd_str,1)="|" then session_pd_str=left(session_pd_str,len(session_pd_str)-1)
	session("whoisValue")=session_pd_str 
End if%>{"code":200,"msg":"","datainfo":{"ok":[<%=oklist%>],"no":[<%=nolist%>],"err":[<%=errlist%>],"premium":[<%=Prelist%>]}}
<%
Function getExplain(ByVal domain)
	getExplain=""
	if right(domainlist,7)=".gov.cn" Then
		getExplain="<a href=""/faq/domgov.asp"" class=""link"" target=""_blank"">【政府域名注册须知】</a>"
	ElseIf right(domainlist,3)=".cn" Then
		getExplain="<a href=""/faq/domcn.asp"" class=""link"" target=""_blank"">【CN域名注册须知】</a>"
	End if
End function

set wd=nothing
conn.close
class checkDomain
	public whoisCompany,resultstr,domain,suffix
	private this_rs,this_conn,objInfo
	Private Sub Class_Initialize
		set this_conn=server.CreateObject("adodb.connection")
		set this_rs=server.CreateObject("adodb.recordset")
		set objInfo=Server.CreateObject("Scripting.dictionary")'用于存放域名商对商的域名后辍
		this_conn.open constr
		whoisCompany="netcn,nowcn,bizcn,xinnet"'指定有哪些接口
		domain=lcase(Requesta("searcheddomainname"))
		suffix=lcase(Requesta("suffix"))
		
		'domain="west263"
		'suffix=".com,.cn,.tw,.net,.net.cn"
	End Sub
	Private Sub Class_Terminate
		if this_rs.state=1 then this_rs.close
		if this_conn.state=1 then this_conn.close
        Set this_rs= Nothing
        Set this_conn= Nothing
		set objInfo= Nothing
    End Sub

	public function whoisDomain()
     
		whoisDomain="500 err"

		new_domain_array=split(domain,",")
		if ubound(new_domain_array)>=100 then die "500 批量域名查询限100个"
		for each chk_domain in new_domain_array
		chk_domain=checkStr("^[\u4e00-\u9fa5\w\-\,]{1,500}$",chk_domain,"域名格式错误，只能是中英文或-组成且总长度为500",iserr)
		next
		resultstr=domain
		if iserr then exit function
		suffix=checkStr("^[a-z\.\,\u4e00-\u9fa5]+$",suffix,"后辍格式有错,只能是英文或.组成",iserr)
		resultstr=suffix
		if iserr then exit function
	 
		call thisGetWhoisFrom(suffix)
		EndreturnStr=""
		returnstr=""
		for each objInfo_item in objInfo
			checktype=trim(lcase(objInfo_item&""))'注册商
			obj_suffix=trim(lcase(objInfo(objInfo_item)))'域名类型
	 
			if checktype&""="" then checktype="netcn"
			if obj_suffix&""<>"" then
				if right(obj_suffix,1)="," then obj_suffix=left(obj_suffix,len(obj_suffix)-1)
				if ischinese(domain) or ischinese(obj_suffix) then 
					returnStr=checkChineseDomain(checktype,domain,obj_suffix)'繁体和简体查询
				else
					if checktype="nowcn" and instr(domain,",")>0 then checktype="nowcn1"'新网用接口方式不支持多域名单后辍查询，所以改为抓取网页的方式
					set wc_class=New WhoisDomain_Class
					'die checktype
						iswhoischeck=true
						returnStr=wc_class.checkExists(checktype,domain,obj_suffix)
					set wc_class=nothing
					
				end if

				EndreturnStr=EndreturnStr & returnStr & "|"
				
			end if
		next
 
		whoisDomain = setresultover(EndreturnStr)
	end function
	public function checkChineseDomain(byval checktype,byval domain,byval suffix)
		returnStr1=""
		returnStr2=""
		returnStr3=""
		for each domain in split(domain,",")
			'domainBig=trim(GbToBig(domain))

			set wc_class=New WhoisDomain_Class
				'returnStr=wc_class.checkExists(checktype,domain & "," & domainBig,suffix)
				returnStr=wc_class.checkExists(checktype,domain,suffix)
			set wc_class=nothing
	
			if left(returnStr,3)="200" then
				for each suffixItem in split(suffix,",")
					suffixItem=trim(suffixItem) & ""
					if suffixItem<>"" then
						if left(suffixItem,1)="." then suffixItem=right(suffixItem,len(suffixItem)-1)
						resultSuffix=getstrReturn(returnStr,"return")
						thisdomain= domain & "." & suffixItem
						thisDomainBig=domainBig & "." & suffixItem
						domainResult=checkisResult(thisdomain,resultSuffix)
						domainBigResult=checkisResult(thisDomainBig,resultSuffix)
						'response.write  domainResult & "<br>" & domainBigResult
						if domainResult="a" and domainBigResult="a" then
							returnStr1=returnStr1 & thisdomain & ","
						elseif domainResult="b" or domainResult="b" then
							returnStr2=returnStr2 & thisdomain & ","
						else
							returnStr3=returnStr3 & thisdomain & ","
						end if
					end if
				next
			end if
		next
		if right(returnStr1,1)="," then returnStr1=left(returnStr1,len(returnStr1)-1)
		if right(returnStr2,1)="," then returnStr2=left(returnStr2,len(returnStr2)-1)
		if right(returnStr3,1)="," then returnStr3=left(returnStr3,len(returnStr3)-1)
		checkChineseDomain="200 ok"& vbcrlf &"return:a:" & returnStr1 & ";b:" & returnStr2 & ";c:" & returnStr3 & vbcrlf & "."
	end function
	public function checkisResult(byval domain,byval resultStr)
		checkisResult="c"
		for each resultItem in split(resultStr,";")
			resultItem=trim(resultItem)
			if instr(resultItem,domain)>0 then
				checkisResult=lcase(left(resultItem,1))
				exit for
			end if
		next
	end function
	private function getmidstr(txt)
		dim getStrA
		dim getStrB
		dim gethttpstr
		
		getStrA="</SPAN></LEGEND>"
		getStrB="<span id=""sugesstion_more"">"
		gethttpstr=""
		if instr(txt,getStrA)>0 then
			newArray1=split(txt,getStrA)
			if ubound(newArray1)>0 then
				newstr1=trim(newArray1(1))
				if instr(newstr1,getStrB)>0 then
					newArray2=split(newstr1,getStrB)
					if ubound(newArray2)>0 then
						newstr2=trim(newArray2(0))
						gethttpstr=replace(newstr2,"domain[]","domains")
					end if
				end if
			end if
		end if
		getmidstr=gethttpstr
	end function
	private function setresultover(byval returnstr)
		setresultover="510 err"
		aaa="":bbb="":ccc=""
		if returnstr&""<>"" then
			dim returnArr(2)
			
			for each result_item in split(returnstr,"|")
				result_item=trim(result_item)
				if result_item<>"" then
					if left(result_item,3)="200" then
						resultSuffix=getstrReturn(result_item,"return")
							for each suffixtype in split(resultSuffix,";")
								suffixtype=trim(suffixtype)
								if suffixtype<>"" then
									thisDomains=trim(mid(suffixtype,3))&""
									if thisDomains<>"" then
										if left(suffixtype,1)="a" then
											aaa= aaa & thisDomains & "," 
										elseif left(suffixtype,1)="b" then
											bbb= bbb & thisDomains & ","
										else
											ccc= ccc & thisDomains & ","
										end if
									end if
								end if
							next
					end if
				end if
			next
			
			if right(aaa,1)="," then  aaa=left(aaa,len(aaa)-1)
			if right(bbb,1)="," then  bbb=left(bbb,len(bbb)-1)
			if right(ccc,1)="," then  ccc=left(ccc,len(ccc)-1)
			returnArr(0)=aaa
			returnArr(1)=bbb
			returnArr(2)=ccc
			resultstr=returnArr
			setresultover="200 ok"
		end if
	end function
'''''''''''''''''''''''''''''''''''''''''''''''''''''########################"""""'''''''''''''	
	private function setWhoisCompany()
		'设置域名的指定查询接口
		redim whoisCpy(6)
		whoisCpy(0)="domchina,netcn"
		whoisCpy(1)="domtravel,netcn"
		whoisCpy(2)="domme,netcn"
		whoisCpy(3)="bizchina,netcn"
		whoisCpy(4)="chinacc,netcn"
		whoisCpy(5)="domname,netcn"
		whoisCpy(6)="dommobi,netcn"
		setWhoisCompany=whoisCpy
	end function
	private function thisGetWhoisFrom(byval suffix)
	'从数据库中获得当前使用哪个域名查询接口
		defaultCpy=GetWhoisFrom
		thishttpUrl=Request.ServerVariables("HTTP_HOST")
		if defaultCpy<>"west263" and isChinese(domain) then
				defaultCpy="netcn"
		end if

		whoisCpy = setWhoisCompany()
		for each suffix_item in split(suffix,",")
			suffix_item=trim(suffix_item)
			if suffix_item&""<>"" then
				suffix_itemtype=GetDomainType(domain & suffix_item)'类型
				findArr=filter(whoisCpy,suffix_itemtype)
				if  defaultCpy<>"west263" and ubound(findArr)>=0 then'如果找到了指定接口的域名
					otherDomainArr=split(findArr(0),",")
					othersuffix=suffix_item
					otherCpy=otherDomainArr(1)
					if objInfo.exists(otherCpy) then
						objinfo(otherCpy) = objinfo(otherCpy) & othersuffix & ","
					else
						objInfo.add otherCpy,othersuffix & ","
					end if
				else'没有另外设置的就按默认的
					if objInfo.exists(defaultCpy) then
						objinfo(defaultCpy) = objinfo(defaultCpy) & suffix_item & ","
					else
						objInfo.add defaultCpy,suffix_item & ","
					end if
				end if
			end if
		next
		
	end function
    private function checkStr(byval regPattern,byval checkvalue,byval errstr,byref iserr)
		if not regCheck(regPattern,checkvalue) then
			checkStr=errstr
			iserr=true
		else
			checkStr=checkvalue
			iserr=false
		end if
	end function
	private function regCheck(byval regPattern,byval checkvalue)
	'正则判断
		Set oRegExp = new RegExp
			oRegExp.Pattern = regPattern
			oRegExp.IgnoreCase = False '不区分大小写
			oRegExp.Global = True	'全局
			regCheck = oRegExp.Test(checkvalue)
		Set oRegExp = Nothing
	end function
	public function isChinese(byval checkstr)
		isChinese=regCheck("^[\w\.\-\u4e00-\u9fa5]*[\u4e00-\u9fa5]+[\w\.\-\u4e00-\u9fa5]*$",checkstr)
	end function
	public function MobiWeb(byval isokstr,byval returnArr)
	'手机站调用此页面查询要用到的函数
		if left(isokstr,3)="200" then
			if isArray(returnArr) and ubound(returnArr)>=2 then
				thisreturnstr="a:"& returnArr(0) & vbcrlf & _
							  "b:"& returnArr(1) & vbcrlf & _
							  "c:"& returnArr(2)
				
			else
				thisreturnstr="888 not is array"
			end if
		else
			thisreturnstr=isokstr
		end if
		MobiWeb=thisreturnstr
	end function
end Class
Function Escape(byval str) 
    dim i,s,c,a 
    s="" 
    For i=1 to Len(str) 
        c=Mid(str,i,1) 
        a=ASCW(c) 
        If (a>=48 and a<=57) or (a>=65 and a<=90) or (a>=97 and a<=122) Then 
            s = s & c 
        ElseIf InStr("@*_+-./",c)>0 Then 
            s = s & c 
        ElseIf a>0 and a<16 Then 
            s = s & "%0" & Hex(a) 
        ElseIf a>=16 and a<256 Then 
            s = s & "%" & Hex(a) 
        Else 
            s = s & "%u" & Hex(a) 
        End If 
    Next 
    Escape = s 
End Function
 
%>
