<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
function Trims(varStr)
 varStr=Trim(varStr)
 Trims=replace(varStr,"'","＇")
end function

conn.open constr

subject=Trims(Requesta("subject"))
fundamount=Trims(Requesta("fundamount"))
purpose=Trims(Requesta("purpose"))
address=Trims(Requesta("address"))
postcode=Trims(Requesta("postcode"))
receiver=Trims(Requesta("receiver"))
telephone=Trims(Requesta("telephone"))
sendtype=Trims(Requesta("sendtype"))
receive_cp=requesta("receive_cp")
memo =requesta("memo")
taxcode=requesta("taxcode")

Xcmd= "other" & vbcrlf
Xcmd=Xcmd & "add" & vbcrlf
Xcmd=Xcmd & "entityname:invoice" & vbcrlf
Xcmd=Xcmd & "subject:" & subject & vbcrlf
Xcmd=Xcmd & "fundamount:" & fundamount &  vbcrlf
Xcmd=Xcmd & "purpose:" & purpose & vbcrlf
Xcmd=Xcmd & "address:" & address & vbcrlf
Xcmd=Xcmd & "postcode:" & postcode & vbcrlf
Xcmd=Xcmd & "receiver:" & receiver & vbcrlf
Xcmd=Xcmd & "telephone:" & telephone &  vbcrlf
Xcmd=Xcmd & "sendtype:" & sendtype &  vbcrlf
Xcmd=Xcmd & "receive_cp:" & receive_cp &  vbcrlf
Xcmd=Xcmd & "taxcode:" & taxcode &  vbcrlf
Xcmd=Xcmd & "memo:" & memo &  vbcrlf
Xcmd=Xcmd & "." & vbcrlf

loadRet=Pcommand(Xcmd,Session("user_name"))	'1559
if left(loadRet,3)="200" then
	Response.write "<script language=javascript>alert('发票提交成功，财务部将在本周五挂号寄出，请注意查收！');location.href='Vfapiao.asp';</script>"
else
	Response.write "<script language=javascript>alert('发票提交失败！" & loadRet & "');history.back();</script>"
end if
%>