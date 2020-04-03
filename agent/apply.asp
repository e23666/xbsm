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
	Memo=Replace(Memo,"'","’")
	conn.open constr
	 Sql="Select u_id,u_password from userdetail where u_name='" & UserName & "'"
	Rs.open Sql,conn,1,1
	if Rs.eof then url_return "错误的用户名，如果没注册，请先注册后再申请",-1
	PWD2=Rs("u_password")
	Rs.close
	
	strPassword    = md5_16(replace(PWD,"'","''"))

    if strPassword<>PWD2 then url_return "密码错误!",-1

	 Sql="Insert into [Unprocess] ([Otype],[U_name],[Omoney],[Memo],[Odate]) values ('申请代理','" & UserName &"'," & NeedPrice & ",'模式:" & model & ",级别:" & level & ",备注:" & Memo &"',now)"
	conn.Execute(Sql)
	alert_redirect "代理申请提交成功，若有相关问题，请与我司市场部联系。","/agent"
end if
call setHeaderAndfooter()
			call setagentLeft()

			tpl.set_file "main", USEtemplate&"/agent/apply.html"
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
%>
