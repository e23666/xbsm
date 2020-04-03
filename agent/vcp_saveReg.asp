<!--#include virtual="/config/config.asp" -->
<%
conn.open constr
function is_dname(ByVal ckVal)
	dmRegStr="^([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]?\.)+([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]\.?)$"
	Set RegObj=New RegExp
	RegObj.Pattern=dmRegStr
	RegObj.ignoreCase=true
	is_dname=RegObj.test(ckVal)
	Set RegObj=nothing
end function

function is_self(domains)
	regdomains=replace(companynameurl,"http://","")
	xdms=regdomains & "," & replace(regdomains,"www.","")
	xdms_list=split(xdms,",")
	for k=0 to Ubound(xdms_list)
		if domains=xdms_list(k) then
			is_self=true
			exit function
		end if
	next
	is_self=false
end function

if Session("user_name")="" then Response.ReDirect "/login.asp"
domain=Lcase(Trim(Requesta("domain")))
bankNo=Trim(Requesta("bankNo"))
bank=Trim(Requesta("bank"))
remitMode=Trim(Requesta("remitMode"))
from=Trim(Requesta("from"))

if not is_dname(domain) then
  Response.write "<script language=javascript>alert('请输入有效的域名!');history.back();</script>"
  Response.end
end if

remitMethod=""

remitMethod=remitMode

if left(domain,4)="www." then 
	Cdomain=mid(domain,5)
else
	Cdomain=domain
end if

if is_self(Cdomain) then url_return "请勿输入我司保留域名" & Cdomain,-1

Sql="Select id from Fuser Where C_Dcenter='" & Cdomain & "'"
Set chkRs=conn.Execute(Sql)
if not chkRs.eof then
    Response.write "<script language=javascript>alert('错误,此域名已被其它用户使用，请选择其它域名!');history.back();</script>"
    Response.end
end if
   chkRs.close
   Set chkRs=nothing

Sql="Select id from Fuser Where u_id=" & Session("u_sysid")
  Set chkRs=conn.Execute(Sql)
  if not chkRs.eof then
    Response.write "<script language=javascript>alert('错误,你已经申请,不能再申请!');window.location.href='/default.asp';</script>"
    Response.end
  end if
   chkRs.close
   Set chkRs=nothing
 
Sql="Select * from user where username='" & Session("username") &"'"

Set FRs=Server.CreateObject("ADODB.RecordSet")
FRs.open "Fuser",conn,2,2
FRs.AddNew

FRs("u_id")=Session("u_sysid")
FRs("username")=Session("user_name")
FRs("C_Accounts")=bankNo
FRs("C_bank")=bank
FRs("C_RemitMode")=remitMode
FRs("C_domain")=domain
FRs("C_dCenter")=Cdomain
FRs("C_AgentType")=15
FRs("C_from")=from
FRs("D_end")=dateAdd("d",now,-1)
FRs("N_remain")=0
FRs("N_total")=0
FRs("N_Ptotal")=0
FRs("D_date")=now
FRs("L_ok")=0
FRs("ModeD")=0

FRs.Update

FRs.close
Set FRs=nothing

Response.write "<script language=javascript>alert('申请提交成功，请打款后联系我司客服开通!');window.location.href='/agent/default.asp'</script>"
Resposne.end

















%>