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
If id="" Then url_return "�Բ�����ѡ���ƷID�� !",-1
conn.open constr


Sql="Update searchlist set Mark='" & Mark &"' where id=" & id
conn.Execute(Sql)

if action="keep" then
	Alert_reDirect "���³ɹ�","m_default.asp?id=" & id
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
if Rs.eof then url_return "�û�δ�ҵ�",-1
u_email=Rs("u_email")
Rs.close

If check=1 Then
'���ʵ�
   Sql="Select u_usemoney from Userdetail Where u_name='" & u_name &"'"
   Rs.open Sql,conn,1,1
   if Rs.eof then url_reutrn "δ�ҵ����û�",-1
   if l_price>Ccur(Rs("u_usemoney")) then url_return "���û��ʻ����㣬���ܿ�ͨ",-1
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

    BodyString="�𾴵��û���" & vbCrLf & VbCrLf & "    ����" & VbCrLf & VbCrLf & "   ��������ƹ��Ʒ[" & p_name & ",��ַ:" & o_url &" ]�Ѿ���ͨ�ɹ���������������������Ч" & VbCrLf & VbCrLf & VbCrLf & "���������������⣬�������ǹ�˾��ϵ" & VbCrLf & VbCrLf & "��" & VbCrLf & "    ��" & VbCrLf & companyname
    MailTitle="�ƹ�ҵ��֪ͨͨ"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  ����smtp��������֤��½��
		msg.MailServerPassword = mailserverpassword '  ����smtp��������֤����
		msg.From = mailfrom    '  ������
		msg.FromName = companyname
		msg.AddRecipient  u_email '  �ռ���
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp��������ַ
		set msg = nothing

Sql="Update Searchlist set [check]=1,makedate=now() where id=" & id
conn.Execute(Sql)

Call Alert_Redirect ("���ͨ����","default.asp")
else
   if check=-1 then
    BodyString="�𾴵��û���" & vbCrLf & VbCrLf & "    ����" & VbCrLf & VbCrLf & "   ��������ƹ��Ʒ[" & p_name & ",��ַ:" & o_url &"]���ܾ�����ԭ��:" & VbCrLf & Mark & "��" & VbCrLf & VbCrLf & VbCrLf & "���������������⣬��ӭ�����ǹ�˾��ϵ" & VbCrLf & VbCrLf & "��" & VbCrLf & "    ��" & VbCrLf & companyname
    MailTitle="�ƹ�ҵ����ʧ��֪ͨ"

		Set msg = Server.CreateObject("JMail.Message")
		msg.silent = true
		msg.Logging = true
		msg.Charset = "so-8859-1"
		msg.MailServerUserName = mailfrom    '  ����smtp��������֤��½��
		msg.MailServerPassword = mailserverpassword '  ����smtp��������֤����
		msg.From = mailfrom    '  ������
		msg.FromName = companyname
		msg.AddRecipient  u_email'  �ռ���
		msg.Subject = MailTitle
		msg.Body  =BodyString
		msg.Send (mailserverip)   '  smtp��������ַ
		set msg = nothing
   end if
Sql="Update Searchlist set [check]=" & check & ",makedate=now() where id=" & id
conn.Execute(Sql)
Call Alert_Redirect ("�Ѿ�����","default.asp")

End If
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
