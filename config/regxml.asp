<%

function xmlDomconn(xmlpath)
	if IsObject(objDom) then
	   set objDom=nothing
	end if
	set objDom=Server.CreateObject("Microsoft.XMLDOM")
	objDom.async = false
	objDom.load(server.MapPath(xmlpath)) 
	if objDom.ParseError.ErrorCode <> 0 then
		Response.Write objDom.ParseError.Reason
	else
		Set objroot = objDom.documentElement
		set xmlDomconn=objroot
	end if
		
end function
function GetuserIp()
    dim realip,proxy
    realip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
    proxy = Request.ServerVariables("REMOTE_ADDR")
    if realip = "" then
        GetuserIp = proxy
    else
        GetuserIp = realip
    end if
end function
function  standip(userip)
		xmlpath="/config/data.xml"
		set root=xmlDomconn(xmlpath)
		set nodeLis = root.childNodes(1).childNodes
		standip=false
		   for each iplines in nodeLis
		   			ipline=iplines.text
		   			allpd=instr(ipline,"*")
					if allpd>0 then
						midstrs=allpd-1
						ippd=trim(mid(ipline,1,clng(midstrs)))
					else
						ippd=trim(ipline)
					end if
					
					
					if instr(trim(userip),ippd)>0 then
						standip=true
					end if
				
		   next
end function


'''''''''''是否允许用户登陆''''''''''''''''
function setuserip(pdss)
	xmlpath="/config/data.xml"
	set root=xmlDomconn(xmlpath)
	temp=trim(root.selectSingleNode("//"&pdss).text)
	if temp&""="" then temp=0
	setuserip=temp
end function
'''''''''''''''是否充许用户试用主机'''''''''''''

function UpdateXmlNodeText(elementname,inis,newelementtext) 
	xmlpath="/config/data.xml"
	
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	objDoms.async = false
	objDoms.load(server.MapPath(xmlpath)) 
	if objDoms.ParseError.ErrorCode <> 0 then
		Response.Write objDoms.ParseError.Reason
	else
		Set objroot = objDoms.documentElement
	
	
		objroot.selectSingleNode("//"&elementname).childNodes(cint(inis)).text=newelementtext
		
		objDoms.save(server.mappath(xmlpath))
	end if
	set objDoms=nothing
end function 
function DeleteXmlNodeText(elementname,inis) 
	xmlpath="/config/data.xml"
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	objDoms.async = false
	objDoms.load(server.MapPath(xmlpath)) 
	if objDoms.ParseError.ErrorCode <> 0 then
		Response.Write objDoms.ParseError.Reason
	else
		Set objroot = objDoms.documentElement
		objroot.selectsinglenode("//"&elementname).removechild(objroot.selectsinglenode("//"&elementname).childNodes(cint(inis)))
		objDoms.save(server.mappath(xmlpath))
	end if
    set objDoms=nothing
end function 
function InsertXmlNodeText(befelementname,elementname,elementtext) 
	xmlpath="/config/data.xml"
	'set root=xmlDomconn(xmlpath)
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	objDoms.async = false
	objDoms.load(server.MapPath(xmlpath)) 
	if objDoms.ParseError.ErrorCode <> 0 then
		Response.Write objDoms.ParseError.Reason
	else
		Set objroot = objDoms.documentElement
		set befelement=objroot.selectSingleNode("//"&befelementname) 
		set element= objDoms.createelement(elementname) 
		befelement.insertBefore element,befelement.firstchild 
		element.text=elementtext
		objDoms.save(server.mappath(xmlpath))
	end if
	set objDoms=nothing
end function 

'''''''''''''最终调用叛断'''''''''''''''''''''''
sub douserhandip(pds)
  if pds="userlog" then
	if setuserip("userlog") then
		muhanduserip=GetuserIp()
		
		if standip(muhanduserip) then
			response.write "<script language=javascript>alert('对不起,你的IP被禁止');history.back();</script>"
			
			response.end
		end if
	end if
  elseif pds="userreg" then
  	if setuserip("userreg") then
		muhanduserip=GetuserIp()
		
		if standip(muhanduserip) then
			response.write "<script language=javascript>alert('对不起,你的IP被禁止');history.back();</script>"
			
			response.end
		end if
	end if
  elseif pds="host" then
  	if setuserip("host") then
		muhanduserip=GetuserIp()
		if standip(muhanduserip) then
			response.write "<script language=javascript>alert('对不起,你的IP被禁止');"
			response.write "history.back();</script>"
			response.end
		end if
	end if
  end if
end sub
''''''''''''''''''''''''写入用户登陆ip'''''''''''''''''''''''
sub insertusersip()
	On Error Resume Next
	usersip=GetuserIp()
	xmlpath="/config/data.xml"
	set objDoms_ip=Server.CreateObject("Microsoft.XMLDOM")
	objDoms_ip.async = false
	objDoms_ip.load(server.MapPath(xmlpath)) 
	if objDoms_ip.ParseError.ErrorCode <> 0 then
		Response.Write objDoms_ip.ParseError.Reason
	else
		Set objroot = objDoms_ip.documentElement
		set befelement=objroot.childNodes(2)
		'''''''''''''删除最老的''''''''''
		set logips=befelement.childNodes
		ipdelsi=0
		for each ipiis in logips
			u_ipname=ipiis.attributes.getNamedItem("user_name").nodeValue
			if TRIM(session("user_name"))=TRIM(u_ipname) then
				ipdelsi=ipdelsi+1
				if (ipdelsi)>=5 then
					befelement.removechild ipiis
				end if
				
			end if	
		next

		'''''''''''新建''''''''''''''''''
		set element= objDoms_ip.createelement("u_ip") 
		befelement.insertBefore element,befelement.firstchild 
		'element.attributes.getNamedItem("logtime").nodeValue=now()
		'element.attributes.getNamedItem("user_name").nodeValue=session("user_name")
		element.setAttribute "logtime", FormatDateTime(now(),0)
		element.setAttribute "user_name",session("user_name") 
		element.text=usersip
		objDoms_ip.save(server.mappath(xmlpath))
		''''''''''''''''''''''''''''
	end if
	
	set objDoms_ip=nothing
end sub
sub isAuditing()
		xmlpath="/config/data.xml"
		set root=xmlDomconn(xmlpath)
		set befelement = root.childNodes(3)
		set Auditclass=befelement.childNodes
		Auditpd=false
		for each Audititem in Auditclass
			u_name=Audititem.attributes.getNamedItem("user_name").nodeValue
			if TRIM(session("user_name"))=TRIM(u_name) then
				
				Auditpd=true
				exit for
				
			end if	
		next
		if not Auditpd then
			response.write "<script language=javascript>alert('对不起，您的帐号需要先经管理员审核后才能开通试用主机...');location.href='/aboutus/contact.asp';</script>"
			response.end
		end if
end sub
sub cnconlinepay()
''''''''''''''''''
		xmlpath="/config/data.xml"
		set root=xmlDomconn(xmlpath)
		set befelement = root.childNodes(4)
		set Auditclass=befelement.childNodes
		for each Audititem in Auditclass
			u_name=Audititem.attributes.getNamedItem("name").nodeValue
			if "cnc"=TRIM(u_name) then
				PayRate=Audititem.attributes.getNamedItem("PayRate").nodeValue
					if PayRate="" then PayRate=0.00
				
					if Audititem.text=1 then
						Auditpd=true
					end if
				exit for
			end if	
		next
end sub	
	'''''''''''''''''''''''''''''
function isNodes(rootNodes,nodesname,xmlpath,getRoot,byref objDoms)'判断节点存不存在,不存在就创建(父节点,子节点,xml文件位置,true/false是否得到子对像,返回的对像),并得到父节点对像
	'xmlpath=server.mappath("/config/data.xml")
		p="n"
		objDoms.async = false
		objDoms.load(xmlpath)
		if objDoms.ParseError.ErrorCode = 0 then
			 Set objroot = objDoms.documentElement
			 set myrootnodes=objDoms.selectSingleNode("//"& rootNodes)
			 if myrootnodes is nothing then
			 	set rootelement= objDoms.createelement(rootNodes)
				objroot.appendChild rootelement
				set myrootnodes=rootelement
				p="y"
			 end if
			  if trim(nodesname)<>"" then 
			 	  set mynodes=myrootnodes.selectSingleNode(trim(nodesname))
				  if mynodes is Nothing  then 
					'节点不存在就建
					set mynodes= objDoms.createelement(trim(nodesname))
					myrootnodes.appendChild mynodes
					
					p="y"
				  end if 
				  if getRoot then
					set isNodes=mynodes
					
				  else
					set isNodes=myrootnodes
				  end if
			  else
			  	set isNodes=myrootnodes
			  end if
			  if p="y" then
			  	objDoms.save(xmlpath)
			  end if
	  else
	 	Response.Write objDoms.ParseError.Reason
	  end if

end function
%>
