<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<% Check_Is_Master(6) %>
<%
conn.open constr
Act=Trim(Requesta("Act"))
Id=Trim(Requesta("id"))
Memo=Trim(Requesta("Memo"))
page=Trim(Requesta("page"))
MaskItem=Trim(Requesta("MaskItem"))
selectField=Requesta("selectField")
content=Requesta("content")

if isNumeric(id) and Act="Del" then
  Sql="Delete from Unprocess where id=" & id
  conn.Execute(Sql)
end if

if isNumeric(id) and Act="Mark" and Memo<>"" then
	Sql="Update Unprocess set Mark='" & Memo &"' where id=" & id
	conn.Execute(Sql)
end if
 if MaskItem="" then
	Sql="Select * from Unprocess "
  elseif MaskItem="SEEK" then
	 Sql="Select * from Unprocess where " & selectField & " like '%" & content & "%'"
  else
	 Sql="Select * from Unprocess where OType like '%" & MaskItem & "%'"
 end if
Sql=Sql & " order  by Odate desc"
Rs.open Sql,conn,3,3
PageSize=20
Rs.PageSize=PageSize
if not isNumeric(page) then page=1
page=Cint(page)
if not Rs.eof then
  if Page<1 then page=1
  if Page>Rs.PageCount then Page=Rs.PageCount
  Rs.AbsolutePage=page
end if
i=1
%>
<html>
<head>
<script language=javascript>

function Mark(id,Memo){
  document.form1.id.value=id;
  document.form1.Act.value="Mark";
  document.form1.Memo.value=Memo;
  document.form1.submit();
}
</script>
<title>���ֹ�����ҵ��.</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="style.css" type="text/css">
</head>

<script language=javascript>
function maskit(form,values){
	form.MaskItem.value=values;
	form.submit();
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���ֹ�����ҵ��</strong></td>
  </tr>
</table>
<br>
<form name="form1" method="post" Action="Unprocess.asp">
  <input type="button" name="Mask2" value="��������" onClick="maskit(this.form,this.value)">
  <input type="button" name="Mask3" value="��������" onClick="maskit(this.form,this.value)">
  <input type="button" name="Mask" value="��������ת��" onClick="maskit(this.form,this.value)">
  <input type="button" name="Mask5" value="��������ת��" onClick="maskit(this.form,this.value)">
  <input type="button" name="Mask" value="�������" onClick="maskit(this.form,this.value)">
  <input type="hidden" name="MaskItem" value="<%=MaskItem%>">
  <br>
  <select name="selectField">
    <option value="U_name" <%if selectField="U_name" then Response.write " selected"%>>�û���</option>
    <option value="Otype"<%if selectField="Otype" then Response.write " selected"%>>��Ŀ</option>
    <option value="Memo"<%if selectField="Memo" then Response.write " selected"%>>��ע</option>
    <option value="Mark"<%if selectField="Mark" then Response.write " selected"%>>ע��</option>
  </select>
  <input type="text" name="content" value="<%=content%>">
  <input type="button" name="Button" value="��ѯ" onClick="maskit(this.form,'SEEK');">
  <br>
  <br>
  <table width="100%" border="0" cellpadding="2" cellspacing="1" bordercolor="#000000" bordercolordark="#FFFFFF" class="border">
    <tr align="center"> 
      <td class="Title"><strong>No</strong></td>
      <td class="Title"><strong>�û���</strong></td>
      <td class="Title"><strong>��Ŀ</strong></td>
      <td class="Title"><strong>�漰���</strong></td>
      <td class="Title"><strong>��ע</strong></td>
      <td class="Title"><strong>����</strong></td>
      <td class="Title"><strong>ע��</strong></td>
      <td class="Title"><strong>����</strong></td>
  </tr>
  <%
do while not Rs.eof and i<=pageSize
%> 
  <tr align="center"> 
      <td class="tdbg"><font size="2"><%=(page-1)*pageSize+i%></font></td>
      <td class="tdbg"><font size="2"><%if instr(Server.HTMLEncode(Rs("U_name")),"iframe")<>0 then response.Write("<font color=ff0000>����ľ��<font>"&Server.HTMLEncode(Rs("U_name"))) else response.Write("<a href=../usermanager/detail.asp?u_id=" & finduserid(Rs("U_name")) & ">" & Rs("U_name") & "</a>") end if%></font></td>
      <td class="tdbg"><font size="2"><% if Rs("OType")="��������" then
	    if instr(Server.HTMLEncode(Rs("OType")),"iframe")<>0 then response.Write("<font color=ff0000>����ľ��<font>"&Server.HTMLEncode(Rs("OType"))) else response.Write("<font color=red>" & Rs("OType") & "</font>") end if
		'Response.write "<font color=red>" & Rs("OType") & "</font>"
		else
		if instr(Server.HTMLEncode(Rs("OType")),"iframe")<>0 then response.Write("<font color=ff0000>����ľ��<font>"&Server.HTMLEncode(Rs("OType"))) else response.Write(Rs("OType")) end if
		'Response.write Rs("OType")
		end if%></font></td>
      <td class="tdbg"><font size="2"><%=Rs("Omoney")%></font></td>
      <td class="tdbg"><font size="2"><%if instr(Server.HTMLEncode(Rs("Memo")),"iframe")<>0 then response.Write("<font color=ff0000>����ľ��<font>"&Server.HTMLEncode(Rs("Memo"))) else response.Write(Rs("Memo")) end if%></font></td>
      <td class="tdbg"><font size="2"><%=formatDateTime(Rs("Odate"),2)%></font></td>
      <td align=left class="tdbg"><font size="2" color=<%if inStr(Rs("OType"),"CN")=0 then Response.write "green"%>> <%if Rs("Mark")<>"" then 
	if instr(Server.HTMLEncode(Rs("Mark")),"iframe")<>0 then response.Write("<font color=ff0000>����ľ��<font>"&Server.HTMLEncode(Rs("Mark"))) else response.Write(Rs("Mark")) end if
	'Response.write Rs("Mark")
	else
	Response.write "&nbsp;"
	end if
%></font></td>
      <td class="tdbg">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><input type="button" name="b2" value="ɾ" onClick="if(confirm('��ȷ��ɾ������Ϣ��<%if Rs("OType")="��������" Then Response.write "��" & Rs("Memo") & "��\n\n[����!��׼��ɾ�������������Ѽ�¼��ȷ�ϴ������Ѿ����ѳɹ�?]"%>')){window.location.href='Unprocess.asp?Act=Del&id=<%=Rs("id")%>'}"></td>
            <td><input type="button" name="b1" value="ע" onClick="strValue=prompt('�����뱸ע����(С��255�ַ�)','<%

if not isNull(Rs("Mark")) then 
	Response.write Replace(Rs("Mark"),"""","")
else
	Response.write " "
end if

%>');if (strValue!=null){Mark(<%=Rs("id")%>,strValue);}"></td>
          </tr>
        </table></td>
  </tr>
  <%
i=i+1
Rs.moveNext
Loop
%> 
    <tr align="center"> 
      <td colspan="8" class="tdbg">��<font size="2"><%=page%></font>ҳ/��<font size="2"><%=Rs.PageCount%></font>ҳ/<a href="Unprocess.asp?MaskItem=<%=MaskItem%>&Page=<%=page-1%>&content=<%=content%>&selectField=<%=selectField%>">��һҳ</a>/<a href="Unprocess.asp?MaskItem=<%=MaskItem%>&Page=<%=page+1%>&content=<%=content%>&selectField=<%=selectField%>">��һҳ</a>,��
  <input type="text" name="Page" size="2" maxlength="2" value="<%=page%>">
  ҳ
  <input type="submit" value="ȷ��" name="submit22">
  </td>
    </tr>
</table>

<input type="hidden" name="id" >
<input type="hidden" name="Act">
<input type="hidden" name="Memo">
</form>
<%Rs.close
%>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
