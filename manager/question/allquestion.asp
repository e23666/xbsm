<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
response.Charset="gb2312"
conn.open constr
if Requesta("Act")="Del" and isNumeric(Requesta("id")) then
  Sql="Delete from question where q_id=" & Requesta("id") & " and q_user_name='" & Session("user_name") &"'"
   conn.Execute(Sql)
end if

'ͬ������
xDo="select top 100 * from question where q_status="&PE_True&" and q_parentID>0 and q_user_name='"&session("user_name")&"'"
rs.open xDo,conn,1,1
do while not rs.eof
		Xcmd="other" & vbcrlf
		Xcmd=Xcmd & "get" & vbcrlf
		Xcmd=Xcmd & "entityname:question" & vbcrlf
		Xcmd=Xcmd & "q_id:" & rs("q_id") & vbcrlf & "." & vbcrlf
		loadRet=Pcommand(Xcmd,Session("user_name"))
		rs.moveNext
loop
rs.close
'�Զ���ȡ�ϼ�����������


sqlstring="select * from  question where q_user_name='"&session("user_name")&"'"

module="search" 
If module="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		rs.open session("sqlsearch") ,conn,3
	  else
		seachqtype = Requesta("qtype")
		if seachqtype="" then seachqtype="myallreply"
		Select Case seachqtype
		  Case "myall"
			sqllimit=""
		  Case "myallask"
			'sqllimit=" and q_status="&PE_True&"" q_state_new
			If isdbsql Then
				sqllimit=" and  isnull(q_state_new,0)<>3"
			else
				sqllimit=" and iif( isnull(q_state_new),0,q_state_new)<>3"
			End if
		  Case "myallreply"
			'sqllimit=" and q_status=False"
			sqllimit=" and q_state_new=3"
		End Select
		sqlcmd= sqlstring & sqllimit & " AND q_fid=0"
		'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����
		session("sqlsearch")=sqlcmd & " order by q_id desc"
		rs.open session("sqlsearch") ,conn,1,3
	End If
else
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & " order by q_id desc"
	
	rs.open session("sqlsearch"),conn,1,3
End If
 
Function showqtype(q_type)
		Select Case q_type
 		case 0101
		showqtype="��ǰ��ѯ"
		case 0102
		showqtype="������������"
		case 0103
		showqtype="��������"
		case 0104
		showqtype="��ҵ��������"
		case 0201
		showqtype="���ݿ�����"
		case 0202
		showqtype="��������/�й�����"
		case 0203
		showqtype="VPS���������������"
		case 0204
		showqtype="�����������"
		case 0301
		showqtype="��������"
		case 0302
		showqtype="��վ��������"
		case 0303
		showqtype="��վ�ƹ�����"
		case 0304
		showqtype="���������������"
		case 0305
		showqtype="����ƽ̨�������"
		case 0701
		showqtype="Ͷ�߽���"
		case 0801
		showqtype="����"
		case 142
		showqtype="�ƽ�վ"	
 		case else
		showqtype="������-����"
	End Select
End Function

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���ʱش�</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<SCRIPT language=javascript>

function checkstr()
{
	if(document.form1.subject.value==""){
		alert("��ʾ��\n\n������������Ŀ��");
		document.form1.subject.focus();
		return false;
	}
	if(document.form1.content.value==""){
		alert("��ʾ��\n\n�������������ݣ�");
		document.form1.content.focus();
		return false;
	}
	
}


</SCRIPT><SCRIPT language=javascript>

function checkstr()
{
	if(document.form1.subject.value==""){
		alert("��ʾ��\n\n������������Ŀ��");
		document.form1.subject.focus();
		return false;
	}
	if(document.form1.content.value==""){
		alert("��ʾ��\n\n�������������ݣ�");
		document.form1.content.focus();
		return false;
	}
	
}


</SCRIPT>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/manager/question/allquestion.asp?module=search&qtype=myall">���ʱش�</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">

 <strong>��������</strong> <a href="allquestion.asp?module=search&qtype=myallask" class="manager-btn s-btn">��δ��</a> <a href="allquestion.asp?module=search&qtype=myallreply" class="manager-btn s-btn">�Ѿ���</a>  <a href="allquestion.asp?module=search&qtype=myall" class="manager-btn s-btn">��������</a>  <a href="allquestion.asp?module=search&qtype=myall" class="manager-btn s-btn">��������</a>  <a href="subquestion.asp" class="manager-btn s-btn">��������</a> 
<br>

<table class="manager-table">
 
 
      <%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 20
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
    
        <tr> 
          <th>��������</th>
          <th>�������</th>
          <th>�ؼ���</th>
          <th>����</th>
          <th>����ʱ��</th>
          <th>����</th>
        </tr>
        <%
	Do While Not rs.eof And i<21
	%>
        <tr> 
          <td><%=showqtype(rs("q_type")) %> </td>
          <td><%= left(rs("q_subject"),10) %></td>
          <td><%= left(rs("q_keyword"),5) %></td>
          <td><%if trim(rs("q_from"))<>"" then
  				response.write "�����������"
				else
  				response.write session("user_name")
				end if%>
		  </td>
          <td><%=left(replace(rs("q_reg_time")," ","   "),10)%></td>
          <td><%
					'If Not rs("q_status") Then
			If rs("q_state_new")&""="3" then
						Response.Write "[<a href=""detail.asp?qid="&rs("q_id")&""">�Ѵ�</a>]"
						'��������Ͳ����ٻش��ˡ�
			else
					%>
              [<a href="detail.asp?qid=<%=rs("q_id")%>"><%= msg %>δ��</a>|<a href="javascript:if (confirm('��ȷ��ɾ�������⣿')){window.location.href='allquestion.asp?Act=Del&id=<%=rs("q_id")%>';}" title="ɾ��������"><font color="#CC0000">ɾ</font></a>] 
              <%
					End If
					%></td>
        </tr>
        <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
        <tr> 
          <td colspan =7 align="center">
			<a href="allquestion.asp?module=search&pages=1" class="z_next_page">��һҳ</a> 
            &nbsp; <a href="allquestion.asp?module=search&pages=<%=pages-1%>" class="z_next_page">ǰһҳ</a>&nbsp; 
            <a href="allquestion.asp?module=search&pages=<%=pages+1%>" class="z_next_page">��һҳ</a>&nbsp; 
            <a href="allquestion.asp?module=search&pages=<%=rsPageCount%>"  class="z_next_page">��<%=rsPageCount%>ҳ</a>&nbsp; 
            ��<%=pages%>ҳ</td>
        </tr>
      </table>
      <%
  else
	rs.close
	conn.close
End If

%>
    </td>
  </tr>
</table>






		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
 