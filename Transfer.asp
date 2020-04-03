<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%
cfg=Server.MapPath("/config/const.asp")
set fso=createobject("scripting.FileSystemObject")

set otxt=fso.opentextfile(cfg,1,false)
MB=otxt.readall()

otxt.close: set otxt=nothing
Set rea = New RegExp
rea.IgnoreCase=true
rea.Pattern="(DomainTransfer)\s*=\s*""([^'""\n\r]*)"""
RequestStr=trim("domcom,domcn,domnet,domhzcom,domhznet,domhzcn,domorg,domchina,domhk,domcc,chinacc,domwang")
RequestStr=replace(RequestStr,chr(34),"")
RequestStr=replace(RequestStr,"<","&lt;")
RequestStr=replace(RequestStr,">","&gt;")
MB=rea.replace(MB,"$1=""" & RequestStr & """")
set rea=nothing
	set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
	file.write MB
	file.close 
	set file = nothing 
	response.write "ok"
%>
