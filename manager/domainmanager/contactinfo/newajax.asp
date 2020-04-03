<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312" 
act=requesta("act")
conn.open constr




Select Case Trim(act)
Case "dmlist":dmlist
Case "auditregsub":auditregsub
Case Else

	set d=new west_domain_api
	set p=newoption()
	If  d.doaction(act) then
		die d.retcode
	Else
		die ""	
	End If 
End Select


Sub dmlist()

	domkey=requesta("domkey")
	groupid=requesta("groupid")
	setsize=requesta("pagesize")
	pageno=requesta("pageno")
	newsql=" userid="&session("u_sysid")&" and isreglocal=0"
	If Not isnumeric(groupid&"") Then groupid=0
	If Not isnumeric(setsize&"") Then setsize=50
	If Not isnumeric(pageno&"") Then pageno=1
	If CLng(pageno)<1 Then pageno=1
	If CLng(setsize)<1 Then setsize=50
	If Trim(domkey)<>"" Then 
		newsql=newsql&" and strdomain like '%"&domkey&"%'"
	End If
	If groupid>0 Then newsql=newsql&" and d_id in (select yw_id  from groupinfo where gid="&groupid&") " 
	sql="select d_id,strdomain from domainlist where "&newsql &" order by d_id desc"
	rs.open sql,conn,1,1 
	 rs.pageSize=setsize
	 if setsize>0 then rs.CacheSize=setsize '记录缓存
	 pageCounts=rs.pageCount
	 linecounts=rs.RecordCount
	 if clng(pageNo)>clng(pageCounts) then pageNo=pageCounts
	 if not rs.eof then rs.AbsolutePage=pageNo 
	Set ret=newoption()
	Set arr=newarray() 
	For i=1 To setsize 
		If rs.eof Then Exit for
		strdomain=rs("strdomain")
		d_id=rs("d_id")
		Set line=newoption()
		line.add "d_id",d_id
		line.add "domain",strdomain
		arr.push(line)
	 
		rs.movenext
	next
	rs.close 
	Set ret("datas")=arr
	ret("pagecount")=pageCounts
	ret("rowcount")=linecounts
	ret("pageno")=pageno
	ret("pagesize")=setsize
	die aspjsonprint(ret)
 
End sub


 

class west_domain_api
  dim api_url,u_id,errArr,retcode
  Private Sub Class_Initialize() 
    api_url="http://api.west263.com/api/audit/" 'api地址
    u_id=session("u_sysid")
	Set errArr=newarray()
  End Sub

  Function addErr(ByVal msg)
	errArr.push(msg)
  End Function
  
  Function clear_audit_session()
	session("mylb_lbload")=""
	session("mylb_islbbody")=""
	session("mb_getcfg_history")=""
  End function
	
  Function doaction(ByVal action_)
	doaction=False
	iscache=true
	tab=requesta("tab")
	Select Case Trim(action_)
	Case "lbload","islbbody" '获取模板列表记录
		formarr=Split("c_regtype,c_org_m,reg_contact_type,c_em,c_status,r_status,c_date_begin,c_date_end,pageno,pagesize",",")	
		For Each k In formarr
			If Trim(requesta(k))<>"" Then iscache=false
			Exit for
		Next
		retcode=session("mylb_"&action_)	
		If Trim(retcode)<>"" Then doaction=true:Exit Function 
	Case "auditsub" '创建模板
		formarr=split("c_sysid,c_regtype,c_org_m,c_ln_m,c_fn_m,c_co,cocode,c_st_m,c_ct_m,c_dt_m,c_adr_m,c_pc,c_ph_type,c_ph,c_ph_code,c_ph_num,c_ph_fj,c_em,c_org,c_ln,c_fn,c_st,c_ct,c_adr,reg_contact_type,c_idtype_hk,c_idnum_hk,c_idtype_gswl,c_idnum_gswl",",")
		clear_audit_session()
	Case "auditdel"	'4.	删除模板
		formarr=split("c_sysid",",")
		clear_audit_session()
	Case "regdomain"	'5.	注册域名
		formarr=split("strdomain,regyear,strdomainpwd,dns_host1,dns_host2,c_sysid,client_price",",")
		Exit function
	Case "domaininfo"	'6.	获取域名资料
		formarr=split("d_id,eppidtype",",")
	Case "domainmodisub"  '7.	修改域名资料
		formarr=split("d_id,eppidtype,c_ln_m,c_fn_m,c_co,cocode,c_st_m,c_ct_m,c_dt_m,c_adr_m,c_pc,c_ph_type,c_ph,c_ph_code,c_ph_num,c_ph_fj,c_em,c_ln,c_fn,c_st,c_ct,c_adr",",")
		clear_audit_session()
	Case "auditfile" ' 9.	获取域名实名信息
		formarr=split("c_sysid",",")
	Case "uploadwcftoken" '获取上传token参数
		formarr=split("f_type_org,f_code_org,c_sysid",",")
	Case "auditurl" '域名、模板实名url简易方式
		formarr=split("c_sysid,d_id",",")
	Case "auditghsub" '11.	域名过户
		formarr=split("ghdomain,eppidtype,c_regtype,c_org_m,c_status,r_status,reg_contact_type,c_sysid,tab,strdomain",",")   'strdomain,eppidtype,c_sysid
	Case "ztload" '12.	查询过户状态记录
		formarr=split("strdomain,g_status,g_date_begin,g_date_end,pageno,pagesize",",")
	Case "getcfg"
		'session("mb_getcfg")="" 
		If tab="regtypepair,contacttype,statusinfo" Then retcode=ReadFileContent("/noedit/auditconfig.json"):doaction=true:Exit Function
		If tab="ipaddr,fromuser,history" Then retcode=session("mb_getcfg_history"):If Trim(retcode)<>"" Then:doaction=true:Exit Function
		formarr=split("tab",",") 
	Case "auditstatus"
		formarr=split("c_sysid,registrantid,r_status",",")
	Case "setdefault"
		formarr=split("c_sysid,isdefault",",")
	Case "auditinfo"
		formarr=split("c_sysid,tjtype",",")
	Case "ishasdomain"
		formarr=split("c_sysid",",")
	Case "domainlb"
		formarr=split("c_sysid,strdomain,r_status",",") 
	Case Else
		addErr("未知操作["&action_&"]")
		Exit function
	End Select
	actPostData="act="&action_

	For Each k In request.form
		If k<>"act" Then actPostData=actPostData&"&"&k&"="&server.URLENcode(requesta(k))
	next
	'for each k in formarr
		
	'next 
    
	retcode=sendapi(actPostData) 
	Set retdic=aspjsonParse(retcode)
	If InStr(",lbload,islbbody,",","&action_&",")>0 And iscache Then
		If  retdic("result")="200"  then
			session("mylb_"&action_)=retcode
		ElseIf retdic.exists("msg") Then 
			If retdic("msg")(0)="没有资料列表" Then session("mylb_"&action_)=retcode 
		End if
	End If
	If tab="ipaddr,fromuser,history" Then
		If  retdic("result")="200"  Then session("mb_getcfg_history")=retcode
	End if
	If Trim(action_)="getcfg" And InStr(","&tab&",",",fromuser,")>0 And Trim(session("u_contract"))<>""  Then  
		
		If retdic("result")="200" Then 
			If Not retdic("data").exists("fromuser") Then 
				set	line=newoption()
				line.add "c_org_m",session("u_contract")
				If Len(session("u_contract"))>1 Then 
					line.add "c_ln_m",Left(session("u_contract"),1)
					line.add "c_fn_m",Mid(session("u_contract"),2,Len(session("u_contract")))
				End if
				line.add "c_em",session("u_email")
				line.add "c_ph",session("msn")
				If Left(session("msn")&"",1)="1" And Len(session("msn")&"") Then 
					line.add "c_ph_type",1 
				else
					line.add "c_ph_type",0 
				End if
				line.add "c_adr_m",session("u_address") 
				retdic("data").add "fromuser",line
				retcode=aspjsonprint(retdic)
			End If
		  
		End if
	End if
	doaction=true
  End Function

  function sendapi(byval postdb) 
	Dim t_
	t_=formatdatetime(now(),0) 
    postinfo="username="&api_username&"&time="&server.URLENcode(t_)&"&versig="&ASP_MD5(api_username&api_password&t_) &"&"&postdb &"&c_keyword=agent_" & u_id  
    sendapi=PostData(api_url,postinfo) 
  end Function
  
  Function PostData(ByVal strURL,ByVal strParam) 
		Set objxml=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		objxml.SetTimeOuts 500000, 500000, 500000, 1000000
		objxml.open "POST",strURL,false
		objxml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=utf-8"
		objxml.send(strParam)
		if objxml.status=200 then
			PostData=objxml.responseText
		Else 
			PostData="599 API连接打开失败" & objxml.responseText
		end If 
		Set objxml=nothing
	end function
end class 


Sub auditregsub()
	Dim f_content,f_freeproid
	regdomain=requesta("regdomain")
	agreement=requesta("agreement")
	strdomainpwd=requesta("strdomainpwd")
	dns_host1=requesta("dns_host1")
	dns_host2=requesta("dns_host2")
	c_sysid=requesta("c_sysid")
	'#''''''''赠品相关''''''''''''
	freeid=trim(requesta("ajaxFree"))
	f_content=""
	f_freeproid=""
	isfree=getFreedatebase(freeid,f_freeproid,f_content)
 
	
	If Not isnumeric(c_sysid&"") Then die echojson(500,"模板ID有误!","")
	If Not isnumeric(agreement&"")<>"1" Then die echojson(500,"请先阅读并接授相关协议!","")
	if Trim(strdomainpwd)="" Or Len(strdomainpwd&"")<6 Then  die echojson(500,"密码长度必须大于6位!","")
	If Trim(dns_host1)="" Or Trim(dns_host2)="" Then   die echojson(500,"域名服务器(DNS)有误!","")
	Set dmdic=newoption()
	For Each line In Split(regdomain,",")
		If InStr(line,"|")>0 Then 
			temp=Split(line,"|")
			dm_=temp(0)
			year_=CLng(temp(1)) 
			If  isdomain(dm_) And  chkregyearnum(year_)   Then 
				dmdic(dm_)=year_
				
			End if
		End if
	Next
	If dmdic.count<1 Then  die echojson(500,"没有找到您要注册的域名","")
	if isfree And dmdic.count<>1 Then  die echojson(500,"赠品只允许注册一个","")
	For Each dm In dmdic 
		dm=LCase(dm)
		p_ProId=GetDomainType(dm)
		strContents="domainname"& vbcrlf &_
				   "add"& vbcrlf &_
				   "entityname:domain" & vbcrlf &_
				   "dmtype:ENG" & vbcrlf &_
				   "domainname:"& dm & vbcrlf &_
				   "term:"& dmdic(dm) & vbcrlf &_
				   "dns_host1:"& dns_host1 & vbcrlf &_
				   "dns_host2:"& dns_host2 & vbcrlf &_
				   "domainpwd:"& strdomainpwd & vbcrlf &_
				   "producttype:"& p_ProId & vbcrlf &_
				   "contact_info_id:"& c_sysid & vbcrlf &_ 
				   "c_keyword:agent_"& session("u_sysid") & vbcrlf &_				  
				   "productnametemp:域名" & vbcrlf  
		If Not isfree Then strContents = strContents &  "ppricetemp:"& GetNeedPrice(session("user_name"),p_ProId,dmdic(dm),"new") & vbcrlf 
		strContents = strContents & f_content
		strContents = strContents & "." & vbCrLf 
		call add_shop_cart(session("u_sysid"),"domain",dm,strContents)		
	Next
	 die echojson(200,"放入购物车成功","")



End Sub

Function chkregyearnum(ByVal y)
	chkregyearnum=False
	If Not isnumeric(y&"") Then Exit Function
	y=CLng(y)
	If CLng(y)<1 Or CLng(y)>10 Then Exit Function
	chkregyearnum=true
End function
%>