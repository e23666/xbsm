<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
conn.open constr
response.Charset="gb2312"
response.Buffer=true

act=requesta("act")


call setHeaderAndfooter()
call setvpsserverLeft()
ishasoem=false
sql="select 1 from productlist where left(p_proid,6)='oemvps'"
rs.open sql,conn,1,1
if not rs.eof then
	ishasoem=true
end if
rs.close
if ishasoem then
	tpl.set_file "main", USEtemplate&"/services/vpsserver/default_oem.html"
else
	tpl.set_file "main", USEtemplate&"/services/vpsserver/default.html"
end if
tpl.set_function "main","ServerName","tpl_function_name"
tpl.set_function "main","ServerMEM","tpl_function_mem"
tpl.set_function "main","ServerHD","tpl_function_hd"
tpl.set_function "main","ServerRoomList","GetCloudPriceRoom"
tpl.parse "mains","main",false
tpl.p "mains"
set tpl=nothing
%>