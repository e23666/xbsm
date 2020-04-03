<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312" 
act=requesta("act")
keyword=session("u_sysid")
select case trim(act)
case "getproid":getproid()
case "addmould":addmould()
case "getlist":getlist()
case "delmould":delmould()
case "audit":audit()
case "getgouhuinf":getgouhuinf()
case "dmguohu":dmguohu()
case "getmyproid":getmyproid()
case "del"
	delfile="/noedit/webuploader/zjfile/"&session("u_sysid")
	call Deltextfile(delfile)
case else:	die echojson(500,"Error","")
end select

function getproid()
	
	dim strCmd,domain
	returnstr=Application("mould_proid")
	if trim(returnstr)="" then
		domain=requesta("domain")
		strCmd="domainname"&vbcrlf&_
			   "contact"&vbcrlf&_
			   "entityname:getdomainproid"&vbcrlf
		if isdomain(domain) then
		strCmd=strCmd&"domain:"&domain&vbcrlf
		end if
		strCmd=strCmd&"."&vbcrlf
		returnstr=echojson(200,"ok",",""info"":"&connectToUp(strCmd))
		Application("mould_proid")=returnstr
	end if
	die returnstr  

end function
'选中我有域名后缀型号
function getmyproid()
	conn.open constr
	sql="select proid from domainlist where isreglocal=0 and userid="&session("u_sysid")&"  group by proid"
	set chkrs=conn.execute(sql)
	strproid=""
	do while not chkrs.eof
		if trim(strproid)="" then
			strproid=chkrs(0)
		else
			strproid=strproid&","&chkrs(0)
		end if
	chkrs.movenext
	loop
	chkrs.close:set chkrs=nothing
	conn.close
	die echojson(200,"ok",",""info"":"""&strproid&"""")	
end function
function addmould()
'	die echojson(500,"添加成功","")
	m_title=requesta("m_title")
	domtype=requesta("domtype")
	dom_org_m=requesta("dom_org_m")
	dom_ln_m=requesta("dom_ln_m")
	dom_fn_m=requesta("dom_fn_m")
	dom_st_m=requesta("dom_st_m")
	dom_ct_m=requesta("dom_ct_m")
	dom_adr_m=requesta("dom_adr_m")
	dom_org=requesta("dom_org")
	dom_ln=requesta("dom_ln")
	dom_fn=requesta("dom_fn")
	dom_co=requesta("dom_co")
	dom_st=requesta("dom_st")
	dom_ct=requesta("dom_ct")
	dom_adr1=requesta("dom_adr1")
	dom_pc=requesta("dom_pc")
	dom_ph=requesta("dom_ph")
	dom_fax=requesta("dom_fax")
	dom_em=requesta("dom_em")
	m_sysid=requesta("m_sysid")
	register=requesta("register")
	
	'domgs,domwl
	dom_idtype=requesta("dom_idtype")
	dom_idnum=requesta("dom_idnum")
	'domhk
	reg_contact_type=requesta("reg_contact_type")
	custom_reg2=requesta("custom_reg2")
	custom_reg1=requesta("custom_reg1")
	entityname="create"
	if not isnumeric(m_sysid&"") then m_sysid=0
	if m_sysid>0 then entityname="modify" 

	if not isbadinput(m_title) or not isbadinput(domtype) or not isbadinput(dom_org_m) or not isbadinput(dom_ln_m) or not isbadinput(dom_fn_m) or not isbadinput(dom_st_m) or not isbadinput(dom_ct_m) or not isbadinput(dom_adr_m) or not isbadinput(dom_org) or not isbadinput(dom_ln) or not isbadinput(dom_fn) or not isbadinput(dom_co) or not isbadinput(dom_st) or not isbadinput(dom_ct) or not isbadinput(dom_adr1) or not isbadinput(dom_pc) or not isbadinput(dom_ph) or not isbadinput(dom_fax) or not isbadinput(dom_em)  then
		die echojson(500,"传递参数有误","")
	end if
	
	

	
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:"&entityname&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "m_title:"&m_title&vbcrlf&_
		   "dom_org_m:"&dom_org_m&vbcrlf&_
		   "dom_org:"&dom_org&vbcrlf&_
		   "dom_ln_m:"&dom_ln_m&vbcrlf&_
		   "dom_ln:"&dom_ln&vbcrlf&_
		   "dom_fn_m:"&dom_fn_m&vbcrlf&_
		   "dom_fn:"&dom_fn&vbcrlf&_
		   "dom_co:"&dom_co&vbcrlf&_
		   "dom_st_m:"&dom_st_m&vbcrlf&_
		   "dom_st:"&dom_st&vbcrlf&_
		   "dom_adr_m:"&dom_adr_m&vbcrlf&_
		   "dom_adr1:"&dom_adr1&vbcrlf&_
		   "dom_ct_m:"&dom_ct_m&vbcrlf&_
		   "dom_ct:"&dom_ct&vbcrlf&_
		   "dom_pc:"&dom_pc&vbcrlf&_
		   "dom_ph:"&dom_ph&vbcrlf&_
		   "dom_fax:"&dom_fax&vbcrlf&_
		   "dom_em:"&dom_em&vbcrlf
		   
		   
	if trim(register)<>"" and domtype="automouldtype" and m_sysid=0 then 	
			strCmd=strCmd&"registercode:"&register&vbcrlf
		else		
		   strCmd=strCmd&"domtype:"&domtype&vbcrlf
	end if
		   select case trim(lcase(domtype))
		   case "domgs","domwl"
		   strCmd=strCmd&"dom_idtype:"&dom_idtype&vbcrlf&_
						 "dom_idnum:"&dom_idnum&vbcrlf
			
		   case "domhk"
		    strCmd=strCmd&"reg_contact_type:"&reg_contact_type&vbcrlf&_
						 "custom_reg2:"&custom_reg2&vbcrlf&_
						 "custom_reg1:"&custom_reg1&vbcrlf
		   end select
		   if m_sysid>0 then
		   strCmd=strCmd&"m_sysid:"&m_sysid&vbcrlf
		   end if
		   strCmd=strCmd&"."&vbcrlf
		   
		 
		die  echojson(200,"ok",",""info"":"&connectToUp(strCmd))
		 
end function

function getlist()
	m_sysid=requesta("m_sysid")
	domain=requesta("domain")
	pagesize=requesta("pagesize")
	pageno=requesta("pageno")
	if not isnumeric(m_sysid&"") then m_sysid=0
	if not isdomain(domain&"") then domain=""
	if not isnumeric(pagesize&"") then pagesize=50
	if not isnumeric(pageno&"") then pageno=1
	if pageno<1 then pageno=1
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:select"&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "pagesize:"&pagesize&vbcrlf&_
		   "pageno:"&pageno&vbcrlf		   
		   
	if m_sysid>0 then
		strCmd=strCmd&"m_sysid:"&m_sysid&vbcrlf
	end if
	if trim(domain)<>"" then
		strCmd=strCmd&"domain:"&domain&vbcrlf
	end if
	
	
	strCmd=strCmd&"."&vbcrlf
	die  echojson(200,"ok",",""info"":"&connectToUp(strCmd))
'	getlist=connectToUp(strCmd)
'	die getlist
end function

function isbadinput(byval v_)
	isbadinput=true
	if trim(v_)="" then exit function
	if instr(v_,chr(10))>0 then exit function
end function

'删除
function delmould()
	m_sysid=getformatrequestnum(requesta("m_sysid"))	
	if trim(m_sysid&"")="" then die echojson(500,"Error","")
	
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:delete"&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "m_sysid:"&m_sysid&vbcrlf&"."&vbcrlf
	'die connectToUp(strCmd)
	die  echojson(200,"ok",",""info"":"&connectToUp(strCmd))
end function

'格式化并检查传放内容全为数字并去掉空格
function getformatrequestnum(byval num_)
	getformatrequestnum=""
	if trim(num_)<>"" then
		for each n_ in split(num_,",")
			if isnumeric(n_&"") then
				if trim(getformatrequestnum)="" then
					getformatrequestnum=trim(n_)
				else
					getformatrequestnum=getformatrequestnum&","&trim(n_)
				end if
			end if
		next	
	end if
end Function
function audit()
	dom_id=requesta("dom_id")
	registranttype=requesta("registranttype")
	idtype=requesta("idtype")
	idcode=requesta("idcode")
	idimgurl=requesta("idimgurl")
	orgprooftype=requesta("orgprooftype")
	orgcode=requesta("orgcode")
	orgmsgurl=requesta("orgmsgurl")
	
	if instr("I,E",registranttype)=0 then die echojson(500,"registranttype Error","")
	if instr("SFZ,JGZ,QT",idtype)=0 then die echojson(500,"idtype Error","")
	if trim(idcode)="" then  die echojson(500,"idcode Error","")
	if trim(idimgurl)="" then  die echojson(500,"idimgurl Error","")
	urlpath="http://"&Request.ServerVariables("SERVER_NAME")
	if ishttps() then
		urlpath="https://"&Request.ServerVariables("SERVER_NAME")
	end if
	idimgurl=urlpath&idimgurl
	if trim(orgmsgurl)<>"" then
	orgmsgurl=urlpath&orgmsgurl
	end if
	
	
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:audit"&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "dom_id:"&dom_id&vbcrlf&_
		   "registranttype:"&registranttype&vbcrlf&_
		   "idtype:"&idtype&vbcrlf&_
		   "idcode:"&idcode&vbcrlf&_
		   "idimgurl:"&idimgurl&vbcrlf
	
	
	if registranttype = "E" Then
		if instr("YYZZ,ORG,QT",orgprooftype)=0 then die echojson(500,"orgprooftype Error","")
		if trim(orgcode)="" then die echojson(500,"orgcode Error","")
		if trim(orgmsgurl)="" then die echojson(500,"orgmsgurl Error","")
		strCmd=strCmd&"orgprooftype:"&orgprooftype&vbcrlf&_
					   "orgcode:"&orgcode&vbcrlf&_
					   "orgmsgurl:"&orgmsgurl&vbcrlf
		
	else
		orgprooftype=""
		orgcode=""
		orgmsgurl=""
	end if
	
	strCmd=strCmd&"."&vbcrlf
	infostr=connectToUp(strCmd)
	if instr(infostr,"""result"":""200""")>0 then 
		'操作成功删除上传目录
		delfile="/noedit/webuploader/zjfile/"&session("u_sysid")&"/"&session.sessionid
		call Deltextfile(delfile)
	end if
	die  echojson(200,"ok",",""info"":"&infostr)
end function

'通过域名获取可过户模板
function getgouhuinf()
	dim ids,okid,strdomain
	ids=Requesta("ids")
	if trim(ids)="" then  die echojson(500,"参数错误","")
	okid="0"
	for each id_ in split(ids,",")
		if isnumeric(trim(id_)&"") then 
			okid=okid&","&trim(id_)
		end if
	next
	if okid&""="0" then  die echojson(500,"参数错误","")
	sql="select strdomain from domainlist where userid="&session("u_sysid")&" and isreglocal=0 and d_id in("&okid&")"
	conn.open constr
	set drs=conn.execute(sql)
	if drs.eof then die echojson(500,"数据查询失败","")
 
	do while not drs.eof
		if trim(strdomain)="" then
			strdomain=drs(0)
		else
			strdomain=strdomain&","&drs(0)
		end if
	drs.movenext
	loop
	drs.close:set drs=nothing
	conn.close
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:select"&vbcrlf&_
		   "domain:"&strdomain&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "."&vbcrlf
	
 
	infostr=connectToUp(strCmd)
	die echojson(200,"ok",",""info"":"&infostr)
end function

function dmguohu()
	dim okstrdomain,strdm,strdomain
	strdm=requesta("strdomain")
	m_sysid=requesta("m_sysid")
	if trim(strdm)="" then  die echojson(500,"域名参数错误","")
	if not isnumeric(m_sysid&"") then  die echojson(500,"模板ID参数错误","")
	for each dm in split(strdm,",")
		if isdomain(trim(dm)) then
			if trim(okstrdomain)="" then
				okstrdomain=trim(dm)
			else
				okstrdomain=okstrdomain&","&trim(dm)
			end if
		end if	
	next
	if trim(okstrdomain)="" then  die echojson(500,"域名参数错误","")
	sql="select strdomain from domainlist where userid="&session("u_sysid")&" and isreglocal=0 and strdomain in('"&replace(okstrdomain,",","','")&"')"
	conn.open constr
	set drs=conn.execute(sql)
	if drs.eof then die echojson(500,"数据查询失败","") 
	do while not drs.eof
		if trim(strdomain)="" then
			strdomain=drs(0)
		else
			strdomain=strdomain&","&drs(0)
		end if
	drs.movenext
	loop
	drs.close:set drs=nothing
	conn.close
	strCmd="domainname"&vbcrlf&_
		   "contact"&vbcrlf&_
		   "entityname:push"&vbcrlf&_
		   "domain:"&strdomain&vbcrlf&_
		   "m_sysid:"&m_sysid&vbcrlf&_
		   "keyword:"&keyword&vbcrlf&_
		   "."&vbcrlf 
	infostr=connectToUp(strCmd)
	die echojson(200,"ok",",""info"":"&infostr)	
end function

Function Deltextfile(fileurl)'参数为相对路径 
	 Set objFSO = CreateObject("Scripting.FileSystemObject") 
	  fileurl = Server.MapPath(fileurl) 
	  if objFSO.FolderExists(fileurl) then '检查文件是否存在 
	   objFSO.DeleteFolder(fileurl) 
	  end if 
	 Set objFSO = nothing 
End Function

%>