<%
function GetTimeRadom()
	filetype=right(Fname1,3)
	images_name1=now()
	images_name1=replace(images_name1,"-","")
	images_name1=replace(images_name1," ","")
	images_name1=replace(images_name1,":","")
	GetTimeRadom=images_name1
end function

sub settleover()
			MailBody="�𾴵�" & Rs("u_namecn") & "<br>&nbsp;&nbsp;���ã�<p>&nbsp;&nbsp;��л����Ϊ��˾�ģ֣ã�ģʽ������飬�����ڵ������ܶ��Ѵ�" & Utotal & "Ԫ�������Ѿ���" & Utotal & "Ԫ�ֽ�㵽��������дVCP���ϵ�ʱ�����µ������ʻ�(������ַ���Ա�ʺ�)�ϣ���ע�����.�����û������ṩ�Ļ�ʽ����û�л��ɹ����뼰ʱ�������ϵ���ѣѣ�" & oicq& "���绰��"& telphone & " .���в����֮����Ҳ��ӭ������˾��ϵ"
			MailBody=MailBody & "��<p>&nbsp;&nbsp;&nbsp;��<p>��<p>" & companyname & "<br>��ַ:" & companynameurl & "<br>" & formatDateTime(now,1)
			sendHtmlMail Rs("u_email"),"VCP����֪ͨ",MailBody,true
end sub

Response.Buffer=false
%>
<!--#include virtual="/config/config.asp" --><%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���Ź���</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="vcp_newautoSettle.asp">�Զ�����</a> | <a href="adver.asp">������</a> | <a href="settlelist.asp">�鿴����¼</a></td>
  </tr>
</table> <br>
<%
Server.ScriptTimeOut=99999
%>
<%Check_Is_Master(6)%>
<%

conn.open constr
set MyRs=Server.CreateObject("ADODB.RecordSet")

Start=Trim(Requesta("Start"))
TotalSum=0
dotcount=0

Response.write "<html><head><title>�Զ�����..</title></head><body>"
if Start<>"" then
	Response.write "==��ʼ�Զ�����(������������ڵ���100Ԫ���û�)==<hr>"
	Sql="Select  f.*,u.u_namecn,u.u_email from fuser as f inner join userdetail as u on f.u_id=u.u_id where f.L_ok="&PE_True&" order by f.id asc"
	Rs.open Sql,conn,1,1
	do while not Rs.eof 
		set lrs=conn.Execute("select sum(v_royalty) as Utotal from vcp_record where v_start=0 and v_fid=" & rs("u_id"))
		if not lrs.eof then
			if not isnull(lrs(0)) then
				Utotal=Ccur(lrs(0))
			else
				Utotal=0
			end if

			if Utotal>=100 then
				dotcount=dotcount+1
				Response.write dotcount & ".&nbsp;&nbsp;�û�:" & rs("username") & ",����:" & Utotal & "Ԫ,"
				if rs("C_RemitMode")<>"��Ա��ֵ" then
					Response.write "����:" & rs("C_RemitMode") & ",�ʺ�:" & rs("C_Accounts") & ",����:" & rs("C_bank")
				else
					conn.Execute("update userdetail set u_usemoney=u_usemoney+" &Utotal & " where u_id=" & rs("u_id"))
					conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_in,u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&rs("u_id")&"," & Utotal & "," & Utotal & ",0,'"&GetTimeRadom()&"','VCP���','"&now()&"','"&now()&"','"&now()&"',0)")
					Response.write "��Ա��ֵ(�ѳɹ�)"
				end if
				
				Response.write "<BR><BR>"
				conn.Execute("update vcp_record set v_start=1 where v_start=0 and v_fid=" & rs("u_id"))
				conn.Execute("update fuser set N_total=N_total+" & Utotal & ",D_end="&PE_Now&" where u_id=" & rs("u_id"))
				conn.Execute("insert into vcp_settlelist(s_userid,s_date,s_money) values("& rs("u_id") &",now(),"& Utotal &")")
				TotalSum=TotalSum+Utotal
				Call settleover()
			end if
		end if
		lrs.close: set lrs=nothing
		Rs.moveNext
	loop
	Rs.close
	Response.write "<hr>ȫ�����!����:<b><font color=red>" & TotalSum & "</font></b>Ԫ(<b>�ر�����:�뽫������Ϣ����������������ʾ���û����</>)"
else
	Response.write "<form action=""" & Request("script_name") & """ name=form1><input type=submit name=Start value=��ʼ></form>"
end if
%><!--#include virtual="/config/bottom_superadmin.asp" -->
