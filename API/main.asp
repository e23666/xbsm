<!--#include virtual="/config/config.asp" -->
<!--#include file="config.asp" -->
<!--#include virtual="/config/class/diyserver_Class.asp"-->
<!--#include file="ParseAPICommand.asp" -->

<%
conn.open constr

userid=Requesta("userid")
versig=Requesta("versig")
strCmd=Requesta("strCmd")
Call sigCheck(userid,strCmd,versig)
const isapicomm=true

usersql="select * from userdetail where u_name='"& userid &"'"
rs.open usersql,conn,1,1
if not rs.eof then
	u_sysid=rs("u_id")
	u_name=rs("u_name")
	u_level=rs("u_level")
	u_usemoney=rs("u_usemoney")
end if
rs.close
Call checkAllParam(strCmd)
Call checkOwner(userid,strCmd)
Call checkCommand(strCmd)

retInfo=ToParseAPICommand(strCmd)

Response.write retInfo

'Call writelog_api(retInfo)
conn.close
%>