<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
Response.Charset="GB2312"
conn.open constr
newcheckstr="^((域名)|(合作)|(出租)|(转让)|(管理员)|(我爱你)|(出售)|(赚钱)|(张三)|(游水)|(N\/A)|(NA)|(Domain Whois Protect)|(webmaster)|\d)$"		  '注册资料参数禁用关键字(正则表达式)
checkdomainStr="aoyun,2008,89"'域名禁用关键字(逗号分隔)
'入库操作
If requesta("act")="sub" Then
	If trim(session("u_sysid"))&""="" Then die echojson(500,"未登陆不能处理","")
	if session("transferdomain").count=0 then  die echojson(500,"请录入转入域名后操作","")
	strdomain=requesta("1")
	chgdns=requesta("3")
	mobanid=requesta("2")
	If Not isdomain(strdomain) Or Not isnumeric(mobanid&"") Then  die echojson(500,"参数错误!","")
	If chgdns&""<>"1" Then chgdns=0
	If Not session("transferdomain").Exists(strdomain&"") Then  die echojson(500,"参数错误!","")
    dpwd=Replace(session("transferdomain")(strdomain&""),"╂","~")
	dPrice=getDnametjg(strdomain) 
	set drs=Server.CreateObject("adodb.recordset")

	 sql="select top 1 * from domainlist where strDomain='"&strdomain&"'"
	 drs.open sql,conn,1,3
	 if drs.eof then
		 '转入域名扣费操作
		 if consume(session("user_name"),dPrice,true,"transfer_in("&strdomain&")","域名转入["&strdomain&"]",GetDomainType(strdomain),"") Then
			 drs.addnew
			 drs("strDomain")=strdomain
			 drs("proid")=GetDomainType(strdomain)
			 drs("rsbdate")=now()
			 drs("regdate")=now()
			 drs("years")=0
			 drs("rexpiredate")=now()
			 drs("tran_state")=0
			 drs("userid")=session("u_sysid")
			 drs.update

			 strcmd="domainname"&vbcrlf&_
					"transfer"&vbcrlf&_
					"entityname:request"&vbcrlf&_
					"domain:"&strdomain&vbcrlf&_
					"authcode:"&dpwd&vbcrlf&_
					"mobanid:"&mobanid&vbcrlf&_
					"chdns:"&chgdns&vbcrlf&_ 
					"."&vbcrlf 
			 loadRet=connectToUp(strcmd)
			  if left(loadRet,3)="200" then
				  crdate=getReturn(loadRet,"crdate")
				  exdate=getReturn(loadRet,"exdate")
				  years=getReturn(loadRet,"years")
				  sql="update  domainlist set regdate='"&crdate&"',rexpiredate='"&exdate&"',years="&years&",tran_state=1  where strDomain='"&strdomain&"' and userid="&session("u_sysid")
				  conn.execute(sql)
				  die echojson(200,"转入申请成功","")
			  ElseIf InStr(loadRet,"转移密码错误")>0 Then 
				'服务器远程转入失败
				  call addRec("域名【"&dname&"】转入失败,用户已扣款,转入密码["&dpwd&"]",loadRet) 
				  die echojson(500,"用户已扣款,转入密码错误","") 
			  else
				  '服务器远程转入失败
				  call addRec("域名【"&dname&"】转入失败,用户已扣款,转入密码["&dpwd&"]",loadRet) 
				  die echojson(200,"转入申请成功","")	
			  end If 
		 Else
			die echojson(500,"转入申请失败,扣费失败!","")

	     End If	   
	  Else
			call  addRec("域名【"&dname&"】转入失败","数据库已经存在！")
			die echojson(500,"转入申请失败,数据已经存在","")	 
	  End If 
End If

if requesta("act")="save" then
die "no used"
If trim(session("u_sysid"))&""="" Then
	response.write "<script language=javascript>parent.location.href='/login.asp';</script>"
	response.end	
end if



	'检查转入域名是否存在
	if not isobject(session("transferdomain")) then
	    die url_return("请录入转入域名后操作1",-2)
	else
		if session("transferdomain").count=0 then 
		die url_return("请录入转入域名后操作",-2)	
		end if
	end if
	chgdns=session("chgdns")
	     dom_org=CheckInputType(trim(Requesta("dom_org")),"^[\w\.\,\s]{4,100}$","英文域名所有者",false)
		dom_fn=CheckInputType(trim(Requesta("dom_fn")),"^[\w\.\s]{2,30}$","英文名",false)
		dom_ln=CheckInputType(trim(Requesta("dom_ln")),"^[\w\.\s]{2,30}$","英文姓",true)
		 dom_org_m=domainChinese(trim(requesta("dom_org_m")),2,100,"中文所有者")
		dom_fn_m=CheckInputType(trim(Requesta("dom_fn_m")),"^[\u4e00-\u9fa5]{1,4}$","中文姓",true)
		dom_ln_m=CheckInputType(trim(Requesta("dom_ln_m")),"^[\u4e00-\u9fa5]{1,6}$","中文名",true)
		dom_em=CheckInputType(trim(Requesta("dom_em")),"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$","邮箱号码",false)
		'转入流程:入库-->扣费-->改状态--->上传命令-->改状态
		
	a=session("transferdomain").Keys
	for i=0 to session("transferdomain").count-1
         dname=trim(a(i))    '转入域名
		 dPrice=getDnametjg(a(i))    '转入价格
		 dpwd=session("transferdomain").item(replace(a(i)&"","╂","~"))
		 
		 set drs=Server.CreateObject("adodb.recordset")
		 sql="select top 1 * from domainlist where strDomain='"&dname&"'"
		 drs.open sql,conn,1,3
		 '不存在记录进行添加入库
		 if drs.eof then
				 '转入域名扣费操作
				 if consume(session("user_name"),dPrice,true,"transfer_in("&dname&")","域名转入["&dname&"]",GetDomainType(dname),"") then
				 
				 drs.addnew
					 drs("strDomain")=dname
					 drs("proid")=GetDomainType(dname)
					 drs("dom_org")=dom_org
					 drs("dom_fn")=dom_fn
					 drs("dom_ln")=dom_ln
					 drs("dom_org_m")=dom_org_m
					 drs("dom_fn_m")=dom_fn_m
					 drs("dom_ln_m")=dom_ln_m
					 drs("dom_em")=dom_em
					 drs("rsbdate")=now()
					 drs("regdate")=now()
					 drs("years")=0
					 drs("rexpiredate")=now()
					 drs("tran_state")=0
					 drs("userid")=session("u_sysid")
				     drs.update 
 					 strcmd="domainname"&vbcrlf&_
							"transfer"&vbcrlf&_
							"entityname:request"&vbcrlf&_
							"domain:"&dname&vbcrlf&_
							"authcode:"&dpwd&vbcrlf&_
							"chdns:"&chgdns&vbcrlf&_
							"dom_org_m:"&dom_org_m&vbcrlf&_
							"dom_ln_m:"&dom_ln_m&vbcrlf&_
							"dom_fn_m:"&dom_fn_m&vbcrlf&_
							"dom_org:"&dom_org&vbcrlf&_
							"dom_ln:"&dom_ln&vbcrlf&_
							"dom_fn:"&dom_fn&vbcrlf&_
							"dom_em:"&dom_em&vbcrlf&_
							"."&vbcrlf
				          loadRet=connectToUp(strcmd)
						  if left(loadRet,3)="200" then
						  crdate=getReturn(loadRet,"crdate")
						  exdate=getReturn(loadRet,"exdate")
						  years=getReturn(loadRet,"years")
						  sql="update  domainlist set regdate='"&crdate&"',rexpiredate='"&exdate&"',years="&years&",tran_state=1  where strDomain='"&dname&"' and userid="&session("u_sysid")
						  conn.execute(sql)
						  msg=msg&"【"&dname&"】转入申请成功!\n"
 						  else
						  '服务器远程转入失败
						  call addRec("域名【"&dname&"】转入失败,用户已扣款",loadRet)
						  msg=msg&"【"&dname&"】转入申请成功!\n"
						  end if
    				 
				 else
    			 msg=msg&"【"&dname&"】转入申请失败,扣费失败!\n"
				 end if
		 
		else
		  call  addRec("域名【"&dname&"】转入失败","数据库已经存在！")
		  msg=msg&"【"&dname&"】转入申请失败,数据已经存在!\n"
		end if 
	next 
		
		
    
 die Alert_Redirect(msg&"\n如有疑问请管理员","/services/domain/transfer.asp")
end if


dim iszr
iszr=false
if request.QueryString("t")<>"input" then
	myMoban=USEtemplate&"/services/domain/transfer.html"
else
	myMoban=USEtemplate&"/services/domain/transfer_data.html"
	if not isobject(session("transferdomain")) then
	    die url_return("请录入转入域名后操作1",-2)
	else
		if session("transferdomain").count=0 then 
		die url_return("请录入转入域名后操作",-2)	
		end if
	end if
	iszr=true
end if

call setHeaderAndfooter()
call setdomainLeft()
tpl.set_file "main", myMoban
tpl.set_var "mydomain",domain,false
tpl.set_var "myauthcode",authcode,false
tpl.set_var "mychgdns",chgdns,false
tpl.set_var "myoldregistrar",oldregistrar,false
tpl.set_var "transferTable",getTransfertable,false

if iszr then
'内容替换
if trim(session("chgdns"))="1" then
tpl.set_var "dns_host1",ns1,false
tpl.set_var "dns_ip1",ns1_ip,false
tpl.set_var "dns_host2",ns2,false
tpl.set_var "dns_ip2",ns2_ip,false
else
tpl.set_var "dns_host1","",false
tpl.set_var "dns_ip1","",false
tpl.set_var "dns_host2","",false
tpl.set_var "dns_ip2","",false
end if

'内容替换结束

'转入域名和价格显示
	tpl.set_block "main","dnamelistzr","dnamelist"
	a=session("transferdomain").Keys
	sumprice=0
	for i=0 to session("transferdomain").count-1
		price=getDnametjg(a(i))
		sumprice=ccur(sumprice)+ccur(price)
		tpl.set_var "bh",i+1,false
		tpl.set_var "dname", a(i),false
		tpl.set_var "dnamejg",price,false
		tpl.parse "dnamelist", "dnamelistzr", true
	next 
	
tpl.set_var "sumprice",sumprice,false
end if

tpl.parse "mains","main",false
tpl.p "mains" 
%>
<!--#include virtual="/config/class/tpl.asp" --> 
<%
set tpl=nothing


 

function getTransfertable()
getTransfertable="ss"
getTransfertable="<table width=""100%"" border=0 align=center cellPadding=3 cellSpacing=1 class=""border""> <tr>"&vbcrlf
getTransfertable=getTransfertable&"<td align=""center"" valign=""middle"" class=""Title"">转入域名产品名称</td>"&vbcrlf
getTransfertable=getTransfertable&"<td align=""center"" valign=""middle"" class=""Title"">产品编号</td>"&vbcrlf
  '  set lrs=conn.execute("select top 5 * from levellist order by l_level asc")
'	do while not lrs.eof 
 '  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"" >"&lrs("l_name")&"</td>"&vbcrlf
   
'	lrs.movenext
'	loop
'	lrs.close
  
  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"" >您的转入价格</td>"&vbcrlf
  i=1
  set prs=conn.execute("select p_name,P_proId from productlist where P_proId in('"&replace(DomainTransfer,",","','")&"')")
  do while not prs.eof
 
 if i mod 2=0 then
 tbg="bgcolor=""#EAF5FC"""
 else
 tbg=""
 end if
 
 getTransfertable=getTransfertable&" <tr "&tbg&">"&vbcrlf
    getTransfertable=getTransfertable&"  <td align=""center"" valign=""middle"">"&prs("p_name")&" </td>"&vbcrlf
     getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&prs("P_proId")&"</td>"&vbcrlf
	 
	 if session("u_levelid")<>"" then
	 getTransfertable=getTransfertable&" <td align=""center"" valign=""middle""><span class=""price"">"&getDnameTransfer(prs("P_proId"),session("u_levelid"))&"</span>   元</td>"&vbcrlf
	 else
	getTransfertable=getTransfertable&" <td align=""center"" valign=""middle""><span class=""price"">"&getDnameTransfer(prs("P_proId"),1)&"   </span>元</td>"&vbcrlf 
	 end if
	 
    '  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),1)&"   元</td>"&vbcrlf
'    getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),2)&"   元</td>"&vbcrlf
'	 getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),3)&"   元</td>"&vbcrlf
'	  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),4)&"   元</td>"&vbcrlf
'	   getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),5)&"   元</td>"&vbcrlf
  	   getTransfertable=getTransfertable&"</tr>"
 
  i=i+1
  prs.movenext
  loop
  	   getTransfertable=getTransfertable&" </table>"

end function



function CheckInputType(byval values,byval reglist,byval errinput,byval pd)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "格式错误",-1
	else
		
		if pd then
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
		
	end if
	CheckInputType=values
end function
function domainChinese(byval values,byval flen,byval llen,byval errinput)
	if len(values)<=llen and len(values)>=flen then
		if not ischinese(values) then
			conn.close
			url_return errinput & "需含有中文",-1
		else
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
	else
		conn.close
		url_return errinput & "字符长度应在" & flen & "-" & llen & "之间",-1
	end if
	domainChinese=values
end function
sub checkdmbuydomain()'安全检验
	if not isAlldomain(strdomain,errstr1) then url_return errstr1,-1
end sub
%>