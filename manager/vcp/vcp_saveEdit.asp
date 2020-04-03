<!--#include virtual="/config/config.asp" -->
<%
conn.open constr
Function isDomainC(varStr)
isDomainC=True
validStr="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"

if varStr="" or len(varStr)<3 or len(varStr)>53 then
   isDomainC=false
   Exit Function
end if

  for i=1 to len(varStr)
     char=mid(varStr,i,1)
     if inStr(validStr,char)=0 then
       isDomainC=False
		Exit Function
     end if
   Next
End Function

if Session("user_name")="" then Response.ReDirect "/login.asp"
bankNo=Trim(Requesta("bankNo"))
bank=Trim(Requesta("bank"))
remitMode=Trim(Requesta("remitMode"))
from=Trim(Requesta("from"))

remitMethod=""

 Select case remitMode
   Case "post"
     remitMethod="邮政汇款"
   Case "company"
     remitMethod="公司转帐"
   Case "person"
     remitMethod="个人电汇"
 end Select


Set FRs=Server.CreateObject("ADODB.RecordSet")

Sql="Select * from Fuser Where username='" & Session("user_name") & "'"

FRs.open Sql,conn,2,2

FRs("C_Accounts")=bankNo
FRs("C_bank")=bank
FRs("C_RemitMode")=remitMode
FRs("C_from")=from

FRs.Update

FRs.close
Set FRs=nothing

Response.write "<script language=javascript>alert('资料修改成功!');location.href='vcp_edit.asp'</script>"
response.end


%>