<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
call needregSession()
conn.open constr
ReferenceID=requesta("ReferenceID")
bankNo=Trim(Requesta("bankNo"))
bank=Trim(Requesta("bank"))
remitMode=Trim(Requesta("remitMode"))
from=Trim(Requesta("from"))
domain="www.vcp-d-mode-user.com"

if not isNumeric(ReferenceID) then
  Response.write "<script language=javascript>alert('请必须正确输入用户名与密码');history.back();</script>"
  Response.end
end if

remitMethod=remitMode
Sql="Select id from Fuser Where u_id=" & ReferenceID 
Set chkRs=conn.Execute(Sql)
if not chkRs.eof then
    Response.write "<script language=javascript>alert('错误,您已经申请成为C/Ｄ模式用户了，不能再次申请');history.back();</script>"
    Response.end
end if
   chkRs.close
   Set chkRs=nothing


Set FRs=Server.CreateObject("ADODB.RecordSet")
FRs.open "Fuser",conn,2,2
FRs.AddNew

FRs("u_id")=ReferenceID
FRs("username")=Session("user_name")
FRs("C_Accounts")=bankNo
FRs("C_bank")=bank
FRs("C_RemitMode")=remitMethod
FRs("C_domain")=domain
FRs("C_dCenter")=domain
FRs("C_AgentType")=15
FRs("C_from")=from
FRs("D_end")=dateAdd("d",now,-1)
FRs("N_remain")=0
FRs("N_total")=0
FRs("N_Ptotal")=0
FRs("D_date")=now
FRs("L_ok")=1
FRs("ModeD")=1
FRs.Update

FRs.close
Set FRs=nothing
			call setHeaderAndfooter()
			call setagentLeft()
			tpl.set_file "main", USEtemplate&"/agent/ModeD_save.html"
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
			conn.close
%>

