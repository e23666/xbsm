<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
sqlstring="select u_id ,u_name ,U_resumesum ,u_remcount,u_levelname,u_level,u_usemoney from UserDetail where u_id>0"
If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		u_level=Requesta("u_level")
		if not isnumeric(u_level) and u_level<>"" then
			url_return "�û��ȼ�ֻ��Ϊ����",-1
		end if
		u_name=Requesta("u_name")
		u_resumesum_min=Requesta("u_resumesum1")
		if not isnumeric(u_resumesum_min) and u_resumesum_min<>"" then
			url_return "���ֻ��Ϊ����",-1
		end if
		u_resumesum_mx=Requesta("u_resumesum2")
		if not isnumeric(u_resumesum_mx) and u_resumesum_mx<>"" then
			url_return "���ֻ��Ϊ����",-1
		end if
		u_remcount_min=Requesta("u_remcount1")
		if not isnumeric(u_remcount_min) and u_remcount_min<>"" then
			url_return "���ֻ��Ϊ����",-1
		end if
		u_remcount_mx=Requesta("u_remcount2")
		if not isnumeric(u_remcount_mx) and u_remcount_mx<>"" then
			url_return "���ֻ��Ϊ����",-1
		end if
		sqllimit=""
		If u_level<>"" Then  sqllimit= sqllimit & " and u_level ="&u_level&""
		If u_name<>"" Then sqllimit= sqllimit & " and u_name ='"&u_name&"'"
		If u_resumesum_mx<>"" Then sqllimit= sqllimit & " and u_resumesum<"&u_resumesum_mx&""
		If u_resumesum_min<>"" Then sqllimit= sqllimit & " and u_resumesum > "&u_resumesum_min&""
		If u_remcount_mx<>"" Then sqllimit= sqllimit & " and u_remcount  <"&u_remcount_mx&""
		If u_remcount_min<>"" Then sqllimit= sqllimit & " and u_remcount > "&u_remcount_min&""
		sqlcmd= sqlstring & sqllimit
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����

		conn.open constr
		session("sqlsearch")=sqlcmd & " order by u_id desc"
		'response.Write(session("sqlsearch"))
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd  & " order by u_id desc"
	rs.open session("sqlsearch"),conn,3

	Set localRs=conn.Execute("select * from levellist")
	do while not localRs.eof
		levelstr=levelstr & localRs("l_name") & "(" & localRs("l_level") & ")"
		localRs.moveNext
		if not localRs.eof then
			levelstr=levelstr & ",&nbsp;"
		end if
	loop
	localRs.close:set localRs=nothing
End If


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�����̼������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
<br>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolordark=#FFFFFF class="border">
  <form action="default.asp" method=post>
    <tr>
      <input name="module" type="hidden" value="search">
      <td width="37%" align="right" class="tdbg">�������ѯ��</td>
      <td width="18%" class="tdbg"><input name="u_level" size="8">
      </td>
      <td width="45%" class="tdbg">��</td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���û���ѯ��</td>
      <td class="tdbg"><input name="u_name" size="8">
      </td>
      <td class="tdbg">��</td>
    </tr>
    <tr>
      <td align="right" class="tdbg">�������ܶ</td>
      <td class="tdbg"><input name="u_resumesum1" size="8">
        (����)</td>
      <td class="tdbg"><input name="u_resumesum2" size="8">
        (С��)</td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���˻���</td>
      <td class="tdbg"><input name="u_remcount1" size="8">
        (����)</td>
      <td class="tdbg"><input name="u_remcount2" size="8">
        (С��)</td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td colspan="2" class="tdbg"><input name="sub" type="submit" value=" ��ʼ���� "></td>
    </tr>
    <tr>
      <td colspan="3" class="tdbg"><br>
        ��ʾ��<%=levelstr%><br>
        <br></td>
    </tr>
  </form>
</table>
<br>
<br>
<%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 20
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 class="border">
  <TR align=middle  bgColor="#CCCCCC" >
    <TD align="center"  valign="bottom" bgcolor="#CCCCCC" class="Title"><strong>�û���</strong></TD>
    <TD align="center"  valign="bottom" bgcolor="#CCCCCC" class="Title" ><strong>�� 
      ��</strong></TD>
    <TD align="center"  valign="bottom" bgcolor="#CCCCCC" class="Title" ><strong>�� 
      ��</strong></TD>
    <TD align="center"  valign="bottom" bgcolor="#CCCCCC" class="Title"><strong>�����ܶ�</strong></TD>
    <TD align="center"  valign="bottom" bgcolor="#CCCCCC" class="Title"><strong>�ʻ����</strong></TD>
  </TR>
  <%
	Do While Not rs.eof And i<20


	%>
  <TR align=middle>
    <td class="tdbg" ><a href="m_default.asp?u_id=<%=rs("u_id")%>"><font color="#0033CC"><%= rs("u_name") %></font></a></td>
    <td class="tdbg" ><%= rs("u_level") %></td>
    <td class="tdbg" ><%= rs("u_levelname") %></td>
    <td class="tdbg" ><%= rs("u_resumesum") %></td>
    <td class="tdbg" ><%= rs("u_usemoney") %></td>
  </tr>
  <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
  <tr bgcolor="#FFFFFF">
    <td colspan =8 align="center" bgcolor="#FFFFFF"><a href="default.asp?module=search&pages=1">��һҳ</a> &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">ǰһҳ</a>&nbsp; <a href="default.asp?module=search&pages=<%=pages+1%>">��һҳ</a>&nbsp; <a href="default.asp?module=search&pages=<%=rsPageCount%>">��<%=rsPageCount%>ҳ</a>&nbsp; 
      ��<%=pages%>ҳ</td>
  </TR>
</table>
<br>
<%
  else
	rs.close
	conn.close
End If

%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
