<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(6)%>
<%
conn.open constr
id=Trim(Requesta("id"))
Act=Trim(Requesta("Act"))

'	conn.Execute(Sql)

if not isNumeric(id) or Act="" then
   Response.write "<script language=javascript>alert('����ĵ���');window.close();</script>"
   Response.end
end if
Sql="Select u_id,C_domain from fuser where id=" & id
	Rs.open sql,conn,1,1
if Rs.eof then
   Response.write "<script language=javascript>alert('����ĵ���');window.close();</script>"
   Response.end
end if
Sql="Select u_namecn,u_email,u_resumesum,u_remcount,u_usemoney from userdetail where u_id=" & Rs("u_id")
Set URs=conn.Execute(Sql)
if URs.eof then
   Response.write "<script language=javascript>alert('����ĵ���');window.close();</script>"
   Response.end
end if

promptString="����ɹ�"

if Act="Pass" then
  leftMoney=Ccur(URs("u_usemoney"))-100
  if leftMoney<0 then
   Response.write "<script language=javascript>alert('���㣬��ͨʧ��');window.close();</script>"
   Response.end
  end if
 Sql="update userdetail set u_resumesum=u_resumesum+100, u_remcount=u_remcount-100, u_usemoney=u_usemoney-100 where u_id=" & Rs("u_id")
  conn.Execute(Sql)
 Sql="insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck , c_type) values (" & Rs("u_id") & " ,100 ,0,  100 ,'vcp-" & URs("u_namecn") & "','��ͨVCP',0,'"&now()&"','"&now()&"','"&now()&"',10)"
  conn.execute(Sql)

  Subject="���������ѻ����ͨ��"
  
	getStr="Thisusername="& URs("u_namecn") &","& _
		   "RegmailSendTime="& now()
	mailbody=redMailTemplate("VCP_Reginfo_true.txt",getStr)

  Sql="update fuser set L_ok="&PE_True&" where id=" & id
  conn.Execute(Sql)
'-----------------------------
promptString="����ɹ����뽫������������ű���վ�ķ�������IP�����������󶨣�"

'-----------------------------

elseif Act="NoPass" then
  Subject="��������δͨ�����"
	getStr="Thisusername="& URs("u_namecn") &","& _
		   "RegmailSendTime="& now()
	mailbody=redMailTemplate("VCP_Reginfo_false.txt",getStr)

  Sql="Delete from fuser where id=" & id
  conn.Execute(Sql)
end if

call sendHtmlMail(URs("u_email"),Subject,mailbody,"true")


Rs.close
URs.close
Set URs=nothing
Response.write "<script language=javascript>alert('" & promptString & "');opener.location.reload();window.close();</script>"
%>