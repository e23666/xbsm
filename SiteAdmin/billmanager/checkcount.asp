<!--#include virtual="/config/config.asp" -->
<%

Check_Is_Master(2)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {font-weight: bold}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table><br>
<table width="100%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
<FORM action="checkcount.asp" method=post>
                  <tr bgcolor=#ffffff> 
                    <td width="40%" align="right" class="tdbg"> ƾ֤��ţ�                      </td>
                    <td width="60%" class="tdbg"> 
                      <input name=module value="search" type=hidden>
                      <input name=qid1 size="20">                    </td>
    </tr>
                  <tr bgcolor=#ffffff>
                    <td align="right" class="tdbg" >�������ͣ� </td>
                    <td class="tdbg">
                      <input name=c_memo size="20">                    </td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg" >ʱ�䣺</td>
                    <td class="tdbg">�� 
                      <input name=qid2 value="2002-1-1" size="8">
                      �� 
                      <input name=qid3 value="<%=date()%>" size="8">
                      (yyyy-mm-dd) </td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg">�� </td>
                    <td class="tdbg"> 
                      <input name=qid4 size="20">
                      Ԫ</td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg">�û��� </td>
                    <td class="tdbg"> 
                      <input name=qid5  size="20">                    </td>
                  </tr>
                  <tr bgcolor=#FFFFFF> 
                    <td  align=center class="tdbg">&nbsp; </td>
                    <td class="tdbg"><input type="submit" name="button" id="button" value=" ��ʼ���� "></td>
                  </tr>
                </form>
              </table>
<br>
<%


Ident=Ucase(left(Session("user_name"),3))

Set MyRs=Server.CreateObject("ADODB.RecordSet")
module=Requesta("module")
c_id=Requesta("c_id")
ck_id=Trim(Requesta("ck_id"))
PPPP=Trim(Requesta("PPPP"))
ActID=Trim(Requesta("ActID"))
NoteContent=Trim(Requesta("NoteContent"))

conn.open constr
if module="note" then
    if  not isNumeric(ActID) or NoteContent="" then url_return "��ѡ��Ҫ��������¼����֪ͨ!,����������֪ͨ����",-1 
	Sql="Select distinct userdetail.u_email,userdetail.u_contract,countlist.u_moneysum,countlist.u_countid,countlist.c_memo,countlist.c_date from userdetail,countlist where userdetail.u_id=countlist.u_id and countlist.sysid=" & ActID
    Rs.open Sql,conn,1,1
	if not Rs.eof then
		MailBody="�𾴵��û�" & Rs("u_contract") & ",����!<p>&nbsp;&nbsp;����һ�ʷ�����" & formatDateTime(Rs("c_date"),1) & "�Ĳ����¼(ƾ֤��:" & Rs("u_countid") &",�漰���:" & Rs("u_moneysum") & ",��ע:" & Rs("c_memo") & ")δ��ͨ����ˣ�ԭ����<b><font color=red>" 
		MailBody=MailBody & NoteContent & "</font></b>,�����յ��ʼ�֪ͨ�󾡿������������ܽ���Ӱ��ҵ�������ʹ�á�"
		MailBody=MailBody & "<br>&nbsp;&nbsp;Ϊ�˸��������Ĳ���֮�������½⣬����Ҳ���������ܵõ����ĺ����������Դ��в����֮������ӭ�µ���˾ҵ�񲿽�����ѯ"
		SendMail Rs("u_email"),"����!�����¼δ�����",MailBody
		Sql="Update countlist set c_note=c_note+1,c_noteTime="&PE_Now&" where sysid=" & ActID
		conn.Execute(Sql)
		Response.write "<script language=javascript>alert('�ʼ����ͳɹ�');</script>"
		module="search"
	end if
	Rs.close
End If

if PPPP<>"" and ck_id<>"" then
	ar_ck_id=split(ck_id,",")
	for each sid in ar_ck_id
		sid=Trim(sid)
		Sql="Select u_id,u_moneysum,u_countId from countlist where sysid=" & sid
		Rs.open Sql,conn,1,1
		if not rs.eof then
			'if Ucase(left(Rs("u_countId"),3))<>Ident then
				if left(Rs("u_countId"),5)="(OL)-" then
					Sql="update Userdetail set u_checkmoney = u_checkmoney - " & Rs("u_moneysum") & " , u_remcount = u_remcount + " & Rs("u_moneysum") & ",u_usemoney=u_usemoney+" & Rs("u_moneysum") & "  where u_id=" & Rs("u_id")					
				else
					Sql="update Userdetail set u_checkmoney = u_checkmoney - " & Rs("u_moneysum") & " , u_remcount = u_remcount + " & Rs("u_moneysum") & "  where u_id=" & Rs("u_id")
				end if
				conn.Execute(Sql)
				Sql="update  countlist set c_check="&PE_False&" , c_datecheck="&PE_Now&"  where   sysid  = " & sid
				conn.Execute(Sql)
			'end if
		end if
		Rs.close
	next
end if
%>

<script language=javascript>
function Gather(form,ActID){
   noteContent=prompt("�����벻���ԭ��:","��Ϊ������˾ע���Աʱ��д���û����ϣ���������ַ���绰�ȣ�����ʵ������");
   if (noteContent!=null){
		form.module.value='note';
		form.NoteContent.value=noteContent;
		form.ck_id.value='';
		form.ActID.value=ActID;
		form.submit();
	}
	return true;
}
</script>
<table width="100%" height="218" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
          <tr> 
            <td height="175" valign="top"> 
 <%
sqlstring="SELECT UserDetail.u_name, UserDetail.u_bizbid AS Expr2,countlist.*, UserDetail.u_operator AS u_operator, UserDetail.u_mode AS u_mode, UserDetail.u_nameEn AS u_nameEn, UserDetail.u_namecn AS u_namecn,UserDetail.u_province AS u_province FROM countlist LEFT OUTER JOIN UserDetail ON countlist.u_id = UserDetail.u_id where countlist.sysid > 0 and left(countlist.u_countid,5)<>'(OL)-' "
if Requesta("module")="" then sqlstring= sqlstring & " and c_check="&PE_True&""
If module="" Then module="search"
If module="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))

		rs.open session("sqlsearch") ,conn,3
	  else
		date1=Requesta("qid2")
		u_moneysum=Requesta("qid4")
		u_countid=Requesta("qid1")
		c_memo=Requesta("c_memo")
		date2=Requesta("qid3")
		u_name=Requesta("qid5")
		sqllimit=""
		If u_countid<>"" Then sqllimit= sqllimit & " and countlist.u_countid like'%"&u_countid&"%'"
		if c_memo<>"" then sqllimit= sqllimit & " and countlist.c_memo like '%" & c_memo & "%'"
		If date1<>"" Then  sqllimit= sqllimit & " and countlist.c_date >=#"&date1&"#"
		If date1<>"" Then  sqllimit= sqllimit & " and countlist.c_date <=#"&date2&"#"
		If u_moneysum<>"" Then  sqllimit= sqllimit & " and countlist.u_moneysum ="&u_moneysum
		If u_name<>"" Then sqllimit= sqllimit & " and UserDetail.u_name = '"&u_name&"'"
		sqlcmd= sqlstring & sqllimit
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����


		session("sqlsearch")=sqlcmd & " order by countlist.c_check desc , countlist.sysid desc"
		
		rs.open session("sqlsearch"),conn,3
	End If

	%> <%
	If Not (rs.eof And rs.bof) Then
	    Rs.PageSize = 10
	    rsPageCount = rs.PageCount
	    flag = pages - rsPageCount
	    If pages < 1 or flag > 0 then pages = 1
	    Rs.AbsolutePage = pages
	%> 
              <form action="checkcount.asp" method=post>
                <TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
                  <TR align=center> 
                    <TD valign="bottom" nowrap class="Title"><strong>ƾ֤��</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>�������</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>����</strong></TD>
                    <TD valign="bottom" nowrap class="Title"><strong>����</strong></TD>
                    <TD valign="bottom" nowrap class="Title"><strong>ʱ��</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>�û���</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>����</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>��������</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>״̬</strong></TD>
                    <TD valign="bottom" nowrap class="Title" > 
                      <input name="PPPP" type="submit" class="STYLE4" value="���">                    </TD>
                    <TD valign="bottom" nowrap class="Title" ><strong> 
                    <input type="hidden" name="ActID">
                    <input type="hidden" name="module">
                    <input type="hidden" name="NoteContent">
				    <input type="hidden" name="pages" value="<%=pages%>">                    
				    </strong></TD>
                  </TR>
                  <%
		Do While Not rs.eof And i<11
			Sql="Select u_namecn,u_name,u_contract,u_address,u_telphone,u_city from userdetail where u_id=" & rs("u_id")
			MyRs.open Sql,conn,1,1
			TitleString=""
			u_name=""
			if not  MyRs.eof then
				u_name=MyRs("u_name")
				TitleString=TitleString & "�û���:      " & u_name & VbCrLF
				TitleString=TitleString & "����/��˾��: " & MyRs("u_namecn") & VbCrLf
				TitleString=TitleString & "��ϵ��:      " & MyRs("u_contract")& VbCrLf
				TitleString=TitleString & "����:        " & MyRs("u_city")& VbCrLf
				TitleString=TitleString & "��ϸ��ַ:    " & MyRs("u_address")& VbCrLf
				TitleString=TitleString & "�绰:        " & MyRs("u_telphone") & VbCrLf
				TitleString=TitleString & "����֪ͨ����:" & Rs("c_note") & VbCrLf
 			 	if Rs("c_note")>0 then
				TitleString=TitleString & "�ʼ�����ʱ��:" & FormatDateTime(Rs("c_noteTime"),2)
				end if
			end if
			MyRs.close	
		%>
                  <TR align=middle title="<%=TitleString%>"> 
                    <TD valign="center" class="tdbg"><%=rs("u_countId")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_moneysum")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_in")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_out")%></TD>
                    <TD valign="center" class="tdbg"><%=formatdatetime(rs("c_date"),2)%></TD>
                    <TD valign="center" class="tdbg" ><a href="../usermanager/detail.asp?u_id=<%=Rs("u_id")%>" target="_blank"><font color="#0000FF"><%=u_name%></font></a></TD>
                    <td align="center" nowrap bgcolor="#EAF5FC" class="tdbg" width="4%"><a href="../chguser.asp?module=chguser&username=<%=u_name%>"><font color="#0000FF">����</font></a></td>
                    <TD valign="center" class="tdbg"><%=rs("c_memo")%></TD>
                    <td valign="center" class="tdbg"  >                      <%
									If rs("c_check") Then  
											Response.Write "δ���"
										else
											Response.Write "��"
									End If
									%>                     </td>
                    <td align="center" valign="center" class="tdbg"  > 
                      
                      <input type="checkbox" name="ck_id"  value="<%=rs("sysid")%>" <% if not rs("c_check") then Response.write " disabled"%>>
               
                    <td align="center" valign="center" class="tdbg"  >
                      <input type="button" name="PPPP2" value="����" onClick="Gather(this.form,<%=Rs("sysid")%>);">                    </td>
                  </TR>
                  <%
			rs.movenext
			i=i+1
		Loop
		rs.close
		%>
                  <tr bgcolor="#FFFFFF"> 
                    <td colspan =11 align="center" bgcolor="#FFFFFF">                       <a href="checkcount.asp?module=search&pages=1">��һҳ</a> 
                      &nbsp; <a href="checkcount.asp?module=search&pages=<%=pages-1%>">ǰһҳ</a>&nbsp; 
                      <a href="checkcount.asp?module=search&pages=<%=pages+1%>">��һҳ</a>&nbsp; 
                      <a href="checkcount.asp?module=search&pages=<%=rsPageCount%>">��<%=rsPageCount%>ҳ</a>&nbsp; 
                      ��<%=pages%>ҳ</td>
                  </TR>
                </table>
              </form>
              <br>
              <%
	  else
		rs.close
	End If

End If
%> 
              
            </td>
          </tr>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
