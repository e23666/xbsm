<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
submit=Trim(Requesta("submit"))
UserName=Trim(Requesta("UserName"))
PWD=Trim(Requesta("PWD"))
Memo=Trim(Requesta("Memo"))
model=Trim(Requesta("model"))
level=Trim(Requesta("level"))
NeedPrice=0

if UserName<>"" then
	Memo=Replace(Memo,"'","��")
	conn.open constr
	 Sql="Select u_id,u_password from userdetail where u_name='" & UserName & "'"
	Rs.open Sql,conn,1,1
	if Rs.eof then url_return "������û��������ûע�ᣬ����ע���������",-1
	PWD2=Rs("u_password")
	Rs.close
	
	strPassword    = md5_16(replace(PWD,"'","''"))

    if strPassword<>PWD2 then url_return "�������!",-1

	 Sql="Insert into [Unprocess] ([Otype],[U_name],[Omoney],[Memo],[Odate]) values ('�������','" & UserName &"'," & NeedPrice & ",'ģʽ:" & model & ",����:" & level & ",��ע:" & Memo &"',now)"
	conn.Execute(Sql)
	alert_redirect "���������ύ�ɹ�������������⣬������˾�г�����ϵ��","/agent"
end if
call setHeaderAndfooter()
			call setagentLeft()

			tpl.set_file "main", USEtemplate&"/agent/apply.html"
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>
