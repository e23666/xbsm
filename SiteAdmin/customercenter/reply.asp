<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)%>
<%

function dvHTMLEncode(fString)
if not isnull(fString) then
    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")

    fString = Replace(fString, " ", "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    dvHTMLEncode = fString
end if
end function
function HTMLCode(SString)
if SString<>"" then


    SString = replace(SString, "&gt;",">")
    SString = replace(SString,  "&lt;","<")

   SString = Replace(SString, "&nbsp;", " ")
   SString = Replace(SString, "&quot;", CHR(34))
   SString = Replace(SString, "&#39;",  CHR(39))
   SString = Replace(SString, "</P><P> ", CHR(10) & CHR(10))
   SString = Replace(SString,  "<BR> ",CHR(10))

    HTMLCode = SString
end if
end function

function gltx(p)
    p = Replace(p,"\""", "&quot;")
    p = Replace(p,"'", "")
	gltx=p
end function

Check_Is_Master(6)

q_id=Trim(Requesta("qid"))
E_Q_id=requesta("qid")
nowUserAt=""
if instr(application("E_Q_id"),"|"&E_Q_id)<>0 then
	EqParts=split(application("E_Q_id"),"|")
	for each eqPart in EqParts
		if instr(eqPart,E_Q_id)<>0 then
			parts=split(eqPart,"=")
			nowUserAt=nowUserAt&","&parts(1)
		end if
	next
	response.Write("<script>if(confirm('"&nowUserAt&"�Ѿ��ڲ鿴��������ˣ����Ƿ�ȷ�������ش𣡵㡰�ǡ������ش�')){}else{location.href='default.asp'}</script>")
end if
application("E_Q_id")=application("E_Q_id")&"|"&E_Q_id&"="&session("user_name")
session("tempd")=E_Q_id


conn.open constr
Del=Trim(Requesta("Del"))
if Del<>"" and isNumeric(Requesta("qid"))then
  Sql="Delete from question where q_id=" & Requesta("qid")
  conn.Execute(Sql)
  Alert_Redirect "�ɹ�ɾ��","default.asp"
end if
%> <div align="left"> </div><%
rs.open "SELECT q_parentID,q_status FROM question where q_id="&Requesta("qid")&"",conn,1,1
if rs.eof then url_return "δ�ҵ�������",-1
q_status=rs("q_status")
q_parentID=rs("q_parentID")
rs.close

if q_status and q_parentID>0 then
	Xcmd="other" & vbcrlf
	Xcmd=Xcmd & "get" & vbcrlf
	Xcmd=Xcmd & "entityname:question" & vbcrlf
	Xcmd=Xcmd & "q_id:" & q_id & vbcrlf & "." & vbcrlf

	loadRet=Pcommand(Xcmd,Session("user_name"))
	if left(loadRet,3)="200" then
		q_status=false
	end if
end if

IDSet=""
idSet=Cstr(q_id)
Csearch=True
Do While Csearch
  Sql="Select * from Question where q_id=" & q_id
  Rs.open Sql,conn,1,1
  if Rs.eof then
	Csearch=False
  else
	if Rs("q_fid")>0 then
		idSet=idSet & "," & Rs("q_fid")
		q_id=Rs("q_fid")
	else
		Csearch=False
	end if
  end if
	Rs.close
Loop
Sql="Select * from Question Where q_id in (" & IDSet & ") order by q_id"
Rs.open Sql
%> <script language=javascript>
function check(form){
if (form.content.value=="") {
  alert("�ظ����ݲ���Ϊ��!");
  return false;
}
  return true;
}
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���ʱش�</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>
<TABLE width="100%" border=0 cellPadding=2 cellSpacing=1 bordercolordark="#ffffff" class="border">
  <form action="replyok.asp"   method="post" name="form1" onSubmit="return check(this);">
    <%
i=1
q_type=""
do while not rs.eof
if i=1 then q_type=Rs("q_type")
i=i+1
%>
    <TR> 
      <TD class="tdbg">״̬:</TD>
      <TD class="tdbg"> 
        <%if not rs("q_status") then
  Response.write "�ѻظ�"
else
  Response.write "<font color=red>δ�ظ�</font>"
end if%>
        ����: 
        <%if not rs("q_status") then
  Response.write Rs("q_reply_name")
else
  Response.write "&nbsp;"
end if%>
        &nbsp; </TD>
    </TR>
    <TR> 
      <TD class="tdbg">UserName:</TD>
      <TD class="tdbg"><%=rs("q_user_name")%> <a href="../billmanager/Mlist.asp?username=<%=rs("q_user_name")%>&module=serach" target="_blank"><img src="/images/finance.gif" border="0" ALT="��ѯ���û��Ĳ�����Ϣ" width="16" height="16"></a> 
        <a href="../chguser.asp?module=chguser&username=<%=rs("q_user_name")%>"><font color="#FF0000">����</font></a> 
        <a href="default.asp?module=search&qtype=UserOther&userName=<%=rs("q_user_name")%>">���û���������</a> 
      </TD>
    </TR>
    <TR> 
      <TD class="tdbg">������Ŀ:</TD>
      <TD class="tdbg"><%=rs("q_subject")%>������� <%=showqtype(rs("q_type"))%> &nbsp; 
      </TD>
    </TR>
    <TR> 
      <TD class="tdbg">�������:</TD>
      <TD class="tdbg"><%=rs("q_user_domain")%> <a href="http://www.miibeian.gov.cn/chaxun/sfba.jsp" target="_blank"><font color="#0000FF">����Ƿ񱸰�</font></a> 
      </TD>
    </TR>
    <TR> 
      <TD class="tdbg">���IP��ַ:</TD>
      <TD class="tdbg"><%=rs("q_user_ip")%> ����ؼ���:<%=rs("q_keyword")%> </TD>
    </TR>
    <TR> 
      <TD class="tdbg">����ʱ�䣺</TD>
      <TD class="tdbg"><%=rs("q_reg_time")%></TD>
    </TR>
    <TR> 
      <TD class="tdbg">��ʱ�䣺</TD>
      <TD class="tdbg"><font color="red"><%=rs("q_reply_time")%></font></TD>
    </TR>
    <TR> 
      <TD class="tdbg">��������:</TD>
      <TD class="tdbg"><%=rs("q_content")%> &nbsp; </TD>
    </TR>
    <tr> 
      <td class="tdbg">������Դ:</td>
      <td class="tdbg"> 
        <%
u_level=0
sql="select u_level from userdetail where u_name='" & rs("q_user_name") & "'"
rs1.open sql,conn,1,1
if not rs1.eof then
 u_level=rs1("u_level")
end if
rs1.close
if rs("q_from")<>"" and u_level>1 then  
	addinfo=false
  response.write "[<font color=red>�����������</font>]"
else
	addinfo=true
  response.write "��ͨ�û�"
end if
sql="select * from userdetail where u_name='" & session("user_name")& "'"
rs1.open sql,conn,1,1
if not rs1.eof then
 u_name=rs1("u_contract")
end if
rs1.close



%>
      </td>
    </tr>
    <TR> 
      <TD class="tdbg">�����:<a href="modi.asp?qid=<%=rs("q_id")%>">[<font color="#0000FF">��</font>]</a></TD>
      <TD class="tdbg"> 
        <%
if rs("q_status") and Clng(Requesta("qid"))=rs("q_id") then
%>
        <TEXTAREA style="BACKGROUND-COLOR: #dde6ef" name=content rows=7 cols=70>�𾴵��û�,����! 
</TEXTAREA>
        <%
else
	Response.write rs("q_reply_content")
end if
%>
      </TD>
    </TR>
    <TR> 
      <TD class="tdbg">�û�����:</TD>
      <TD class="tdbg"> 
        <%
				  if rs("q_score")=-1 then
				  	Response.write "δ����"
				  else
				    Response.write rs("q_score") &"��"
				  end if
				  %>
      </TD>
    </TR>
    <%
q_pic=rs("q_pic")
if q_pic<>"" then
%>
    <TR> 
      <TD class="tdbg">��ͼ:</TD>
      <TD class="tdbg"><a href="<%=q_pic%>" target=_blank><img src="<%=gltx(q_pic)%>" border=0 width="327" height="57"></a></TD>
    </TR>
    <%end if%>
    <TR bgcolor="#FFFFFF"> 
      <TD colspan="2" class="tdbg"> 
        <hr size="1" noshade>
      </TD>
    </TR>
    <%
Rs.MoveNext
Loop
%>
    <TR> 
      <TD colSpan=2 align="center" class="tdbg"> 
        <select name="yuyan" onChange="WriteLiMaoyu()">
          <option value="">��ѡ����ò����</option>
          <option value=",�ǳ���л�����ڶ���˾��֧��.�ɴ˸��������Ĳ���֮��,����ԭ��!лл!">,�ǳ���л�����ڶ���˾��֧��.�ɴ˸��������Ĳ���֮��,����ԭ��!лл!</option>
          <option value=",�ǳ���л�����ڶ���˾��֧��!">,�ǳ���л�����ڶ���˾��֧��!</option>
          <option value=",�ɴ˸��������Ĳ���֮��,����ԭ��!лл!">,�ɴ˸��������Ĳ���֮��,����ԭ��!лл!</option>
          <option value=",�������ⲻ̫�����������ϸ˵��һ��!лл��">,�������ⲻ̫�����������ϸ˵��һ��!лл��</option>
          <option value=",�õģ����������������ϻᴦ�����ԵȺ��ٹ۲�!лл��">,�õģ����������������ϻᴦ�����ԵȺ��ٹ۲�!лл��</option>
          <option value=",����Ӧ�����������Ѿ�����!лл��">,����Ӧ�����������Ѿ�����!лл��</option>
        </select>
        <br>
        <input type=hidden name="qid" value="<%=Requesta("qid")%>">
        <input type=hidden name="module" value="">
        <INPUT type=submit value=������[S] name=Submit id=Answer onClick="javascript:document.form1.module.value='reply';" <%
	if not q_status then 
		Response.write " disabled"
	else
		if q_type=701 then
			if left(session("u_type"),1)="0" then Response.write " disabled"
		end if
	end if
%>>
        <label for=Answer AccessKey=S></label> <label for=Hello AccessKey=A></label> 
        <script>
					  function WriteLiMaoyu()
					  {
						  form1.content.value+=form1.yuyan.value;			
					  }
					  </script>
        <br>
        <%
if addinfo  then  

%>
        <br>
        <%end if%>
      </TD>
    </TR>
  </form>
</TABLE>
<%
rs.close
conn.close
%>
<%
Function showqtype(q_type)
	Select Case q_type
		case 0101
		showqtype="��ǰ��ѯ"
		case 0102
		showqtype="������������"
		case 0103
		showqtype="��������"
		case 0104
		showqtype="��������"
		case 0201
		showqtype="���ݿ�����"
		case 0202
		showqtype="����������"
		case 0203
		showqtype="��������װϵͳ"
		case 0204
		showqtype="��������"
		case 0301
		showqtype="��������"
		case 0302
		showqtype="��վ��������"
		case 0305
		showqtype="���������Ͻ��"
		case 0701
		showqtype="Ͷ�߽���"
		case 0801
		showqtype="����"
		case else
		showqtype="������-����"
	End Select
End Function

%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
