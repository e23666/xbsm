<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%

 


'response.buffer=true
response.charset="gb2312"
u_name=requesta("param")

if ucase(left(u_name,3))=ucase("qq_") then
response.Write("帐号不能以qq_开头!")
response.End()
end if

if u_name="" then 
response.Write("帐号错误！")
response.End()
end If
 If not checkRegExp(u_name,"^[0-9a-zA-Z\u4e00-\u9fa5\_-]{4,18}$") Then  
 	response.Write("帐号由长度4-18个字符组成")
	response.End()
end If
 

conn.open constr
	vsql="select top 1 * from userdetail where u_name='"&u_name&"'"
	set vRs=conn.execute(vsql)
	if not vRs.eof Then
	 response.Write(u_name&"已经存在！请重新输入。")
	 else
	 response.Write("y")
    end if

%>