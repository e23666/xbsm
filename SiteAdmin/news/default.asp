<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(1)%>
<%
sqlstring="select * from news where newsid>0"
module="search"
If module="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		seachqtype = Requesta("qtype")
		sqlcmd= sqlstring & sqllimit
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����
		conn.open constr
		session("sqlsearch")=sqlcmd & " order by newsid desc"
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & " order by q_id asc"
	rs.open session("sqlsearch"),conn,3
End If
%>
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
    <td width="771"><a href="default.asp">��������</a> | <a href="addnews.asp">��������</a> | <%if not rs.eof then%><a href="checked.asp?newsid=<%=rs("newsid")%>">������ҳ</a><%end if%></td>
  </tr>
</table>
<br>
<%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 10
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
              <TABLE width="100%" border=0 cellPadding=3 cellSpacing=1 class="border">
                <TR> 
                  <td nowrap class="Title"> 
                  <p align="center" style="margin-left: 9"><strong>���ű���</strong></p>                  </td>
                  <td nowrap class="Title"><strong> 
                  �����û�</strong></td>
                  <td nowrap class="Title"><strong> 
                  html</strong></td>
                  <td nowrap class="Title"><strong> 
                  ͼƬ</strong></td>
                  <td align="center" nowrap class="Title"><strong> 
                  ʱ��</strong></td>
                  <td align="center" nowrap class="Title"> 
                  <p align="center" style="margin-left: 6">&nbsp;</p>                  </td>
                </TR>
                <%
	Do While Not rs.eof And i<11
	%>
                <TR bgcolor="#FFFFFF"> 
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                  <p style="margin-left: 9"><font color="#6699CC"><%= left(rs("newstitle"),10) %></font>                  </td>
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                  <p style="margin-left: 9"><font color="#6699CC"><%= rs("newsman")%></font>                  </td>
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                    <p style="margin-left: 6"><font color="#6699CC"> 
                      <%if rs("html")=0 then Response.Write "��" Else Response.Write "��" %>
                      </font></p>                  </td>
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                    <p style="margin-left: 6"><font color="#6699CC"> 
                      <% if rs("newpic")<>"" then Response.Write replace(rs("newpic"),"/updatefiles/","") %>
                      </font></p>                  </td>
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                  <p style="margin-left: 6"><font color="#6699CC"><%=left(replace(rs("newpubtime")," ","   "),10)%></font>                  </td>
                  <td bgcolor="#FFFFFF" class="tdbg"> 
                    <%
					If rs("newsshow")<>0 Then
						Response.Write "[<a href=""detailnews.asp?newsid="&rs("newsid")&""">����</a>]"
					 else
						Response.Write "[<a href=""detailnews.asp?newsid="&rs("newsid")&""">����</a>]"
					End If
					%>
                    [<a href="checked.asp?module=del&newsid=<%=rs("newsid")%>">ɾ��</a>] 
                    [<a href="editnews.asp?newsid=<%=rs("newsid")%>">�༭</a>]</td>
                </TR>
                <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan =7 align="center" bgcolor="#FFFFFF">                     <a href="default.asp?module=search&pages=1">��һҳ</a> 
                    &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">ǰһҳ</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=pages+1%>">��һҳ</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=rsPageCount%>">��<%=rsPageCount%>ҳ</a>&nbsp; 
                    ��<%=pages%>ҳ</td>
                </TR>
              </table>
              <%
  else
	rs.close
	conn.close
End If

%>
              <%
Function showqtype(q_type)
	Select Case q_type
		case 0101
		showqtype="����������-����֪ʶ"
		case 0102
		showqtype="����������-ҵ�����"
		case 0103
		showqtype="����������-���Ͻ��"
		case 0104
		showqtype="����������-����"
		case 0201
		showqtype="�ռ�������-����֪ʶ"
		case 0202
		showqtype="�ռ�������-ҵ�����"
		case 0203
		showqtype="�ռ�������-���Ͻ��"
		case 0204
		showqtype="�ռ�������-����"
		case 0301
		showqtype="�����ʾ���-����֪ʶ"
		case 0302
		showqtype="�����ʾ���-ҵ�����"
		case 0303
		showqtype="�����ʾ���-���Ͻ��"
		case 0304
		showqtype="�����ʾ���-����"
		case 0401
		showqtype="��վ������-����֪ʶ"
		case 0402
		showqtype="��վ������-ҵ�����"
		case 0403
		showqtype="��վ������-���Ͻ��"
		case 0404
		showqtype="��վ������-����"
		case 0501
		showqtype="ϵͳ������-����֪ʶ"
		case 0502
		showqtype="ϵͳ������-ҵ�����"
		case 0503
		showqtype="ϵͳ������-���Ͻ��"
		case 0504
		showqtype="ϵͳ������-����"
		case 0601
		showqtype="������-����֪ʶ"
		case 0602
		showqtype="������-ҵ�����"
		case 0603
		showqtype="������-���Ͻ��"
		case 0604
		showqtype="������-����"
		case else
		showqtype="������-����"
	End Select
End Function
%>


<!--#include virtual="/config/bottom_superadmin.asp" -->
