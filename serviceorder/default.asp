<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%response.buffer = false%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/class/diyserver_Class.asp" -->
<!--#include virtual="/config/class/miniprogram_class.asp" -->
<!--#include virtual="/config/class/yunmail_class.asp" -->
<%
response.Charset="gb2312"
 conn.open constr
Server.ScriptTimeout=999999
ordermoneysum=session("ordermoneysum")
act=requesta("act")

function forjson(byval str)
	forjson=replace(str,vbcrlf,"\n\r")
	forjson=replace(forjson,"'","‘")
	forjson=replace(forjson,"""","‘")
end function
if act="buy" then
 
	code=500
	errmsg="未知错误！"
	set grs=Server.CreateObject("adodb.recordset")
	sql="select top 1 * from shopcart where userid="&session("u_sysid")&" and s_status=0 order by cartID asc"
	grs.open sql,conn,2,3
	if grs.eof then 
		errmsg="数据为空!"
		code=400
	else


			id=requesta("id")
			if not isnumeric(id&"") then id=0
			if cdbl(id)<>cdbl(grs("cartID")) then
					errmsg="购物车非法操作!"
					code=400
			else
					orderlist=grs("cartContent") 
					cartID=grs("cartID")
					ywType=grs("ywType")
					grs.close:set grs=Nothing

					dim ppricetemp
					ppricetemp=9999999   '检查金额
					gift=getstrReturn(orderlist,"gift")
				
					select case trim(ywType)
						case "domain"
							ppricetemp=getstrReturn(orderlist,"ppricetemp")
						Case "yunmail"
							ppricetemp=getstrReturn(orderlist,"ppricetemp")
						case "vhost"
							istry=getstrReturn(orderlist,"paytype")
							if istry="1" then
							ppricetemp=demoprice
							else
							ppricetemp=getstrReturn(orderlist,"ppricetemp")
							end if
						case "server"
							istry=getstrReturn(orderlist,"paytype")
							if istry="1" then
							ppricetemp=5
							else
							ppricetemp=getstrReturn(orderlist,"pricmoney")
							end if
						case "mssql"
							istry=getstrReturn(orderlist,"paytype")
							if istry="1" then
							ppricetemp=demomssqlprice
							else
							ppricetemp=getstrReturn(orderlist,"ppricetemp")
							end if 
						case "mail"
							istry=getstrReturn(orderlist,"paytype")
							if istry="1" then
							ppricetemp=demomailprice
							else
							ppricetemp=getstrReturn(orderlist,"ppricetemp")
							end if
						case "miniprogram"
							istry=getstrReturn(orderlist,"paytype")
							if istry="1" then
								ppricetemp=miniprogram_paytype_money
							else
								ppricetemp=getstrReturn(orderlist,"ppricetemp")
							end if
					 
						case "DNS"
							istry=0					 
							ppricetemp=getstrReturn(orderlist,"ppricetemp") 
					end select 
					
					if lcase(gift&"")="true" then
						ppricetemp=0
					end if 
						

					if not chkbuymoneyok(ppricetemp)  then
						 die "{""code"":400,""msg"":""余额不足，请充值("&ppricetemp&")""}"
					end if

					call update_shopcar(cartID,"开通锁定",-1)
					dim li:li=0
								if orderlist<>"" then 
									itemreturnstr=pcommand(orderlist,session("user_name"))
									returnstr=returnstr & itemreturnstr & vbcrlf & "~@~" & vbcrlf
									isfree=getstrReturn(orderlist,"gift")
									code=trim(left(itemreturnstr,3))
									if not isnumeric(code&"") then code=500
									errmsg=forjson(itemreturnstr)
									if not isnumeric(code&"") then   '返回结果
										code=500 
									end if
									call update_shopcar(cartID,itemreturnstr,0)	
									if trim(isfree)="true" then
										randid=getstrReturn(orderlist,"attach-randid")
										conn.execute "update free set f_isget="&PE_True&" where f_randid='"& randid &"'"
									end if
									if left(itemreturnstr,3)="200" then
										call update_shopcar(cartID,itemreturnstr,1)
										Ptype=Trim(getstrReturn(orderlist, "entityname"))				
										select case trim(lcase(Ptype))
										case "dnsdomain"
											domain=Trim(getstrReturn(orderlist,"domainname"))
											proid=Trim(getstrReturn(orderlist,"producttype"))
											years=Trim(getstrReturn(orderlist,"term"))
											price=GetNeedPrice(session("user_name"),proid,years,"new")
											strdomainpwd=Trim(getstrReturn(orderlist,"domainpwd"))
											call adddnsdomain(domain,strdomainpwd,proid,years,price)
											'getStr="dnsdomain="& domain &","& _
											'"Password="& strdomainpwd
											'mailbody=redMailTemplate("BuyDnsDomainSusess.txt",getStr)
											'call sendMail(session("u_email"),"您的DNS("& domain &")开通成功!",mailbody)
										case "domain"
											domainname=Trim(getstrReturn(orderlist,"domainname"))
											domainpwd=Trim(getstrReturn(orderlist,"domainpwd"))
											if lcase(dns_host1)<>lcase(default_dns1) then
											LoadRet=GetOperationPassWord(domainname,"domain",session("user_name"))
											if left(LoadRet,3)="200" then
											domainpwd=getReturn(LoadRet,"domainpassword")
											end if
											end if
											'getStr="domain="& domainname &","& _
											'"Password="& domainpwd
											'mailbody=redMailTemplate("BuyDomainSucess.txt",getStr)
											'call sendMail(session("u_email"),"您的域名("& domainname &")开通成功!",mailbody)
										case "server"	
											p_proid=getstrReturn(orderlist,"p_proid")
											vpsip=getstrReturn(itemreturnstr,"vpsip")
											password=getstrReturn(itemreturnstr,"vpsPassWord")
											ftpuser=vpsip
											if trim(p_proid)="ebscloud" then
											paytype=getstrReturn(orderlist,"paytype")
											if paytype<>0 then ftpuser="[试用]"
											end if


											sDate=date()
										'	getStr= "serverip=" & vpsip & "," & _
										'	"servertype=" & p_proid &"," & _
										'	"password=" & password & "," & _								
										'	"now=" & sDate & "," & _								
										'	"date=" & sDate

										'	if trim(p_proid)="ebscloud" then
										'	mailbody=redMailTemplate("ebs.txt",getStr)
										'	else
										'	mailbody=redMailTemplate("buyserversucess.txt",getStr)
										'	end if
											'die session("u_email")&mailbody
										'	call sendMail(session("u_email"),"主机("& ftpuser &")开通成功!",mailbody)
											case "vhost"
											domainstr=getstrReturn(orderlist,"domain")
											producttype=getstrReturn(orderlist,"producttype")
											years=getstrReturn(orderlist,"years")
											ftpuser=getstrReturn(orderlist,"ftpuser")
											ftppassword=getstrReturn(orderlist,"ftppassword")
											iptype=getstrReturn(orderlist,"iptype")
											price=GetNeedPrice(session("user_name"),producttype,1,"new")
											if iptype&""="1" then

												if lcase(left(p_proid,2))="tw" then
													ipproid="twaddip"
												else
													ipproid="vhostaddip"
												end if
 
													ipprice=GetNeedPrice(session("user_name"),ipproid,1,"new")
												 
											if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
											end if
											price=cdbl(price)+cdbl(ipprice)
											paytype=getstrReturn(orderlist,"paytype")
											freeurl=getstrReturn(itemreturnstr,"freedomain")
											serverip=getstrReturn(itemreturnstr,"ip")

											if paytype<>0 then ftpuser=ftpuser & "[试用]"
											allprice=GetNeedPrice(session("user_name"),producttype,years,"new")
											sDate=date()
											if trim(domainstr)&""="" then domainstr="暂没绑定"
										'	getStr= "domainstr=" & domainstr & "," & _
										'	"productid=" & producttype &"," & _
										'	"vyears=" & years & "," & _
										'	"ftpaccount=" & ftpuser & "," & _
										'	"ftppassword=" & ftppassword & "," & _
										'	"price=" & price & "," & _
										'	"allprice=" & allprice & "," & _
										'	"freedomain=" & freeurl & "," & _
										'	"serverip=" & serverip & "," & _
										'	"now=" & sDate
										'	mailbody=redMailTemplate("BuyhostSucess.txt",getStr)
										'	call sendMail(session("u_email"),"主机("& ftpuser &")开通成功!",mailbody)
										case "corpmail"
											domainname=getstrReturn(orderlist,"domainname")
											producttype=getstrReturn(orderlist,"producttype")
											password=getstrReturn(orderlist,"password")
											years=getstrReturn(orderlist,"years")
											price=GetNeedPrice(session("user_name"),producttype,1,"new")
											if trim("producttype")="diymail" then
											mailsize=getstrReturn(orderlist,"mailsize")
											usernum=getstrReturn(orderlist,"usernum")
											price=getDiyMailprice(mailsize,usernum)
											allprice=price*years
											else
											allprice=GetNeedPrice(session("user_name"),producttype,years,"new")
											end if
											paytype=getstrReturn(orderlist,"paytype")
											if paytype<>0 then domainname=domainname & "[试用]"
											sDate=date()
										'	getStr= "m_bindname=" & domainname & "," & _
										'	"productid=" & producttype &"," & _
										'	"Password=" & password &"," & _
										'	"vyears=" & years & "," & _
										'	"price=" & price & "," & _
										'	"allprice=" & allprice & "," & _
										''	"now=" & sDate
										'	mailbody=redMailTemplate("BuyMailSucess.txt",getStr)
										'	call sendMail(session("u_email"),"企业邮局("& domainname &")开通成功!",mailbody)
										case "mssql"
											databasename=getstrReturn(orderlist,"databasename")
											dbupassword=getstrReturn(orderlist,"dbupassword")
											years=getstrReturn(orderlist,"years")
											producttype=getstrReturn(orderlist,"producttype")
											price=GetNeedPrice(session("user_name"),producttype,1,"new")
											allprice=GetNeedPrice(session("user_name"),producttype,years,"new")
											sDate=date()
									    '	getStr= "dbname=" & databasename & "," & _
										'	"productid=" & producttype &"," & _
										'	"Password=" & dbupassword &"," & _
										'	"vyears=" & years & "," & _
										'	"price=" & price & "," & _
										'	"allprice=" & allprice & "," & _
										'	"now=" & sDate
										'	mailbody=redMailTemplate("BuyMssqlSucess.txt",getStr)
										'	call sendMail(session("u_email"),"MSSQL数据库("& domainname &")开通成功!",mailbody)
										case "miniprogram"
											appname=getstrReturn(orderlist,"appname") 
											years=getstrReturn(orderlist,"years")
											producttype=getstrReturn(orderlist,"producttype")
											price=GetNeedPrice(session("user_name"),producttype,1,"new")
											allprice=GetNeedPrice(session("user_name"),producttype,years,"new")
											sDate=date()
										Case "yunmail"



											
										case else
											code=400
											errmsg="未知操作"
										end select

									else    'no 200
									 
										if left(itemreturnstr,13)="599 API连接打开失败" then
											code="599"
											errmsg="api接口出错"
											Ptype=Trim(getstrReturn(orderlist, "entityname"))
											if Ptype="domain" then
												domainname=Trim(getstrReturn(orderlist,"domainname"))
												domainpwd=Trim(getstrReturn(orderlist,"domainpwd"))
												strcmd="domainname"&vbcrlf&_
													   "info"&vbcrlf&_
													   "entityname:domain"&vbcrlf&_
													   "domain:"&domainname&""&vbcrlf&_
													   "."&vbcrlf
													   die strcmd
												       returnstr=pcommand(strcmd,session("user_name"))
													   if left(returnstr,3)="200" then
															call addRec("域名已存在请检查是否重复","["&domainname&"]已经存在，请检查是否正常扣费")
													   end if
											end if
 										end if

										call update_shopcar(cartID,itemreturnstr,0)
									end if
								end if
								li=li+1
						'	next

					'''end go



			end if
    end if
	
	conn.close
   die "{""code"":"&code&",""msg"":"""&replace(errmsg,vbcrlf,"")&"""}"
end if

if not isnumeric(ordermoneysum) then ordermoneysum=Requesta("ordermoneysum")
if not isNumeric(ordermoneysum) or ordermoneysum<0 then
 url_return "结算金额不能为空或负",-1
end if
 

tpl.set_unknowns "remove"
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate & "/serviceorder/default.html"
If (cdbl(session("u_usemoney"))+cdbl(session("u_borrormax")) + cdbl(session("u_premoney"))) < cdbl(ordermoneysum)  Then
	tpl.set_var "display_nomoney","",false
	tpl.set_var "display_buy","style=""display:none""",false
	tpl.set_var "ordersid","0",false
	tpl.set_var "runjs","",false
	tpl.parse "mains","main",false
	tpl.p "mains"
	set tpl=nothing
else
   set ors=conn.execute("select cartID from shopcart where userid="&session("u_sysid")&" and s_status=0 order by cartID asc ")
   cartidstr=""
   do while not ors.eof
		if cartidstr="" then
		cartidstr=ors(0)
		else
		cartidstr=cartidstr&","&ors(0)
		end if
   ors.movenext
   loop
   ors.close
   set ors=nothing
   if trim(cartidstr)="" then
	 url_return "购物车数据为空！",-1
   end if
	
	tpl.set_var "display_nomoney","style=""display:none""",false
	tpl.set_var "display_buy","",false
	tpl.set_var "ordersid",cartidstr,false
	tpl.set_var "runjs","starorder()",false
	tpl.parse "mains","main",false
	tpl.p "mains"
	set tpl=nothing
	retrunstr=""
end if

function adddnsdomain(byval domain,byval strdomainpwd,byval proid,byval years,byval price)
	sql1="select p_size,p_server from productlist where p_proId ='"& proid &"'"
	rs.open sql1,conn,1,1
	if not rs.eof then
		p_size=rs("p_size")
		p_server=rs("p_server")
		
		countid=left("dns-" & UCase(left(session("user_name"),10)) & "-" &Cstr(timer()) ,20)
		if not consume(session("user_name"),price,True,countid,"buy dnsdomain:" & domain,proid,"") then url_return "余额不足，扣款失败",-1
		
		'conn.execute "update userdetail set u_resumesum=u_resumesum+ "& price &" , u_accumulate=u_accumulate+1 , u_remcount=u_remcount-"& price &" , u_usemoney=u_usemoney-"& price &"  where u_id="& session("u_sysid")
		conn.execute "insert into domainlist([mxdnsrec],[dns_status],[isreglocal],[userid],[fatherid],[regok],[proid],[rsbdate],[regdate],[rexpiredate],[strDomain],[strdomainpwd],[years],[dns_host1],[dns_ip1],[dns_host2],[dns_ip2]) values ("& p_size &",0,3,"& session("u_sysid") &","& session("u_sysid") &",0,'"& proid &"',now(),now(),dateadd('yyyy',"& years &",now()),'"& domain &"','"& strdomainpwd &"',"& years &",'"& ns1 &"','"& ns1_ip &"','"& ns2 &"','"& ns2_ip &"')"
		conn.execute "insert into orderlist ([o_okdate],[o_type],[o_ok],[o_ownerid],[o_producttype],[o_memo],[o_money]) values (now(),'"& proid &"','0',"& session("u_sysid") &",3,'"& domain &"',"& price &")"
		rs1.open "select top 1 * from orderlist where o_type='"& proid & "' and o_ownerid="& session("u_sysid")&" and o_memo='"& domain &"' order by o_id desc",conn,1,1
		if not rs1.eof then
			o_id=rs1("o_id")
			conn.execute "update orderlist set o_key="& o_id &",o_typeid="& o_id &" where o_id = "& o_id
			conn.execute "insert into [_order] (o_key,o_moneysum,o_date , o_ok) values("& o_id &" ,"& price &",now(),0)"
		end if
		rs1.close
		'conn.execute "insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck,c_type,o_id,p_proid) values ("& session("u_sysid") &","& price &",0,"& price &",'"&domain&"-"& o_id &"','buy dnsdomain',0,now(),now(),now(),3, "& o_id &",'"&proid&"')"
	end if
	rs.close
	
end function


function chkbuymoneyok(byval chkmoney)
	chkbuymoneyok=false
	if not isnumeric(chkmoney&"") then chkmoney=9999999
	if chkmoney<0 then chkmoney=9999999
	sql="select u_usemoney,u_premoney from UserDetail where u_id="&session("u_sysid")
	set chkrs=conn.execute(sql)
	u_usemoney=0
	if not chkrs.eof then u_usemoney=ccur(chkrs("u_usemoney"))
	chkrs.close:set chkrs=nothing
	if ccur(u_usemoney)>=ccur(chkmoney) then
		chkbuymoneyok=true
	end if	 
end function


conn.close
%>