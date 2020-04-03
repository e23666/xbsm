<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
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

   Sql="update UserDetail Set u_resumesum=u_resumesum+" & l_price &",u_accumulate=u_accumulate+1,u_remcount=u_remcount-" & l_price & ",u_usemoney=u_usemoney-" & l_price & ",u_invoice=u_invoice+" & l_price & " Where u_name='" & u_name & "'"
   conn.Execute(Sql)
	
   rs.open "orderlist",conn,3,3
   rs.addnew
   rs("o_typeid")=o_typeid
   rs("o_type")=o_type
   rs("o_money")=p_agent_price
   rs("o_ok")=0
   rs("o_ownerid")=u_id
   rs("o_mkdate")=makedate
   rs("o_okdate")=now()
   rs("bizbid")=1
   rs("o_producttype")=4
   rs("o_memo")=o_memo
   rs.update
   rs.close

   sql="SELECT MAX(o_id) AS o_id FROM orderlist WHERE (o_producttype = 4) "
   rs.open sql,conn,1,1
   o_keys=rs("o_id")
   rs.close
	
	Sql="Update orderlist set o_key=o_id where o_id=" & o_keys
	conn.Execute(Sql)

   sql="insert into _order  (o_key,o_moneysum,o_date,o_ok) values("&o_keys&","&p_agent_price&" ,'"&makedate&"',0)"
   conn.Execute(Sql)

	o_url=Replace(o_url,"http://","")

   Sql="insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck,c_type,o_id,p_proid) values ("
   Sql= Sql & u_id &"," & l_price & ",0," & l_price & ",'" & "search-" & id & "','" & o_url & "',0,now(),now(),now(),4," & o_keys & ",'" &o_type &"')"
   conn.Execute(Sql) 

    BodyString="尊敬的用户：" & vbCrLf & VbCrLf & "    您好" & VbCrLf & VbCrLf & "   您购买的推广产品[" & p_name & ",网址:" & o_url &" ]已经开通成功，将在三个工作日内生效" & VbCrLf & VbCrLf & VbCrLf & "若您还有其它问题，请与我们公司联系" & VbCrLf & VbCrLf & "致" & VbCrLf & "    礼" & VbCrLf & companyname
    MailTitle="推广业务开通通知"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  输入smtp服务器验证登陆名
		msg.MailServerPassword = mailserverpassword '  输入smtp服务器验证密码
		msg.From = mailfrom    '  发件人
		msg.FromName = companyname
		msg.AddRecipient  u_email '  收件人
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp服务器地址
		set msg = nothing

Sql="Update Searchlist set [check]=1,makedate=now() where id=" & id
conn.Execute(Sql)

Call Alert_Redirect ("审核通过！","default.asp")
else
   if check=-1 then
    BodyString="尊敬的用户：" & vbCrLf & VbCrLf & "    您好" & VbCrLf & VbCrLf & "   您购买的推广产品[" & p_name & ",网址:" & o_url &"]被拒绝处理，原因:" & VbCrLf & Mark & "．" & VbCrLf & VbCrLf & VbCrLf & "若您还有其它问题，欢迎与我们公司联系" & VbCrLf & VbCrLf & "致" & VbCrLf & "    礼" & VbCrLf & companyname
    MailTitle="推广业务处理失败通知"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  输入smtp服务器验证登陆名
		msg.MailServerPassword = mailserverpassword '  输入smtp服务器验证密码
		msg.From = mailfrom    '  发件人
		msg.FromName = companyname
		msg.AddRecipient  u_email'  收件人
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp服务器地址
		set msg = nothing
   end if
Sql="Update Searchlist set [check]=" & check & ",makedate=now() where id=" & id
conn.Execute(Sql)
Call Alert_Redirect ("已经处理！","default.asp")

End If
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
