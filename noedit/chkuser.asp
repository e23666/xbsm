<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%

 


'response.buffer=true
response.charset="gb2312"
u_name=requesta("param")

if ucase(left(u_name,3))=ucase("qq_") then
response.Write("�ʺŲ�����qq_��ͷ!")
response.End()
end if

if u_name="" then 
response.Write("�ʺŴ���")
response.End()
end If
 If not checkRegExp(u_name,"^[0-9a-zA-Z\u4e00-\u9fa5\_-]{4,18}$") Then  
 	response.Write("�ʺ��ɳ���4-18���ַ����")
	response.End()
end If
 

conn.open constr
	vsql="select top 1 * from userdetail where u_name='"&u_name&"'"
	set vRs=conn.execute(vsql)
	if not vRs.eof Then
	 response.Write(u_name&"�Ѿ����ڣ����������롣")
	 else
	 response.Write("y")
    end if

%>