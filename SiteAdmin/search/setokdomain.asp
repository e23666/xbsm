<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
action=Requesta("action")
If action="pass" Then 
   check=1
ElseIf action="refuse" Then
   check=-1
ElseIf action="drop" Then
   check=-2
End if
id=Requesta("id")
makedate=now()
Mark=Replace(Trim(Requesta("Mark")),"'"," ")
If id="" Then url_return "对不起，请选择产品ID号 !",-1
conn.open constr


Sql="Update searchlist set Mark='" & Mark &"' where id=" & id
conn.Execute(Sql)

if action="keep" then
	Alert_reDirect "更新成功","m_default.asp?id=" & id
end if

sql="select * from searchlist where id="&id
	rs.open sql,conn,1,1
	p_name=Rs("p_name")
	o_memo=rs("p_name")
	o_typeid=rs("id")
	o_type=rs("p_proid")
	o_url=Rs("url")
	p_agent_price=rs("p_agent_price")
	u_name=Rs("u_name")
	u_id=Rs("u_id")
	b_num=Rs("buy_num")
    l_price=Ccur(b_num*p_agent_price)
	mymemo=rs("memo")
	rs.close
Sql="Select u_email from userdetail where u_id=" & u_id
Rs.open Sql,conn,1,1
if Rs.eof then url_return "用户未找到",-1
u_email=Rs("u_email")
Rs.close

If check=1 Then
'入帐单
   Sql="Select u_usemoney from Userdetail Where u_name='" & u_name &"'"
   Rs.open Sql,conn,1,1
   if Rs.eof then url_reutrn "未找到此用户",-1
   if l_price>Ccur(Rs("u_usemoney")) then url_return "此用户帐户余额不足，不能开通",-1
   Rs.Close


    BodyString="尊敬的用户：" & vbCrLf & VbCrLf & "    您好" & VbCrLf & VbCrLf & "   您购买的中文域名：" & mymemo & ",对应网址:" & o_url &" ]已经开通成功，将在一个工作日内生效" & VbCrLf & VbCrLf & VbCrLf & "若您还有其它问题，请与我们公司联系" & VbCrLf & VbCrLf & "致" & VbCrLf & "    礼" & VbCrLf & companyname
    MailTitle="中文域名开通通知"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  输入smtp服务器验证登陆名
		msg.MailServerPassword = mailpassword '  输入smtp服务器验证密码
		msg.From = mailfrom    '  发件人
		msg.FromName = companyname
		msg.AddRecipient  u_email '  收件人
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp服务器地址
		set msg = nothing

Sql="Update Searchlist set [check]=1,makedate=GetDate() where id=" & id
conn.Execute(Sql)

Call Alert_Redirect ("审核通过！","default.asp")
else
   if check=-1 then
    BodyString="尊敬的用户：" & vbCrLf & VbCrLf & "    您好" & VbCrLf & VbCrLf & "   您购买的中文域名[" & mymemo & ",对应网址:" & o_url &"]开通失败，原因:" & VbCrLf & Mark & "．" & VbCrLf & VbCrLf & VbCrLf & "若您还有其它问题，欢迎与我们公司联系" & VbCrLf & VbCrLf & "致" & VbCrLf & "    礼" & VbCrLf & "{companyname}" & VbCrLf & "网址：http://www.west263.com"
    MailTitle="中文域名开通失败通知"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  输入smtp服务器验证登陆名
		msg.MailServerPassword = mailpassword '  输入smtp服务器验证密码
		msg.From = mailfrom    '  发件人
		msg.FromName = companyname
		msg.AddRecipient  u_email'  收件人
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp服务器地址
		set msg = nothing
   end if
Sql="Update Searchlist set [check]=" & check & ",makedate=GetDate() where id=" & id
conn.Execute(Sql)
Call Alert_Redirect ("已经处理！","default.asp")

End If
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
