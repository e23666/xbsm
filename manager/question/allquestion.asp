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

'同步问题
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
'自动获取上级服务商问题


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
		'重新查找  分别需要定义 传上来的参数等等求出
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
		showqtype="售前咨询"
		case 0102
		showqtype="虚拟主机问题"
		case 0103
		showqtype="域名问题"
		case 0104
		showqtype="企业邮箱问题"
		case 0201
		showqtype="数据库问题"
		case 0202
		showqtype="主机租用/托管问题"
		case 0203
		showqtype="VPS、云主机相关问题"
		case 0204
		showqtype="财务相关问题"
		case 0301
		showqtype="续费问题"
		case 0302
		showqtype="网站备案问题"
		case 0303
		showqtype="网站推广问题"
		case 0304
		showqtype="渠道代理相关问题"
		case 0305
		showqtype="代理平台相关问题"
		case 0701
		showqtype="投诉建议"
		case 0801
		showqtype="其他"
		case 142
		showqtype="云建站"	
 		case else
		showqtype="其他类-其他"
	End Select
End Function

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-有问必答</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<SCRIPT language=javascript>

function checkstr()
{
	if(document.form1.subject.value==""){
		alert("提示：\n\n请输入问题题目！");
		document.form1.subject.focus();
		return false;
	}
	if(document.form1.content.value==""){
		alert("提示：\n\n请输入问题内容！");
		document.form1.content.focus();
		return false;
	}
	
}


</SCRIPT><SCRIPT language=javascript>

function checkstr()
{
	if(document.form1.subject.value==""){
		alert("提示：\n\n请输入问题题目！");
		document.form1.subject.focus();
		return false;
	}
	if(document.form1.content.value==""){
		alert("提示：\n\n请输入问题内容！");
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/manager/question/allquestion.asp?module=search&qtype=myall">有问必答</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">

 <strong>管理导航：</strong> <a href="allquestion.asp?module=search&qtype=myallask" class="manager-btn s-btn">尚未答复</a> <a href="allquestion.asp?module=search&qtype=myallreply" class="manager-btn s-btn">已经答复</a>  <a href="allquestion.asp?module=search&qtype=myall" class="manager-btn s-btn">所有问题</a>  <a href="allquestion.asp?module=search&qtype=myall" class="manager-btn s-btn">所有问题</a>  <a href="subquestion.asp" class="manager-btn s-btn">发新问题</a> 
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
          <th>问题类型</th>
          <th>问题标题</th>
          <th>关键字</th>
          <th>来自</th>
          <th>问题时间</th>
          <th>操作</th>
        </tr>
        <%
	Do While Not rs.eof And i<21
	%>
        <tr> 
          <td><%=showqtype(rs("q_type")) %> </td>
          <td><%= left(rs("q_subject"),10) %></td>
          <td><%= left(rs("q_keyword"),5) %></td>
          <td><%if trim(rs("q_from"))<>"" then
  				response.write "独立控制面板"
				else
  				response.write session("user_name")
				end if%>
		  </td>
          <td><%=left(replace(rs("q_reg_time")," ","   "),10)%></td>
          <td><%
					'If Not rs("q_status") Then
			If rs("q_state_new")&""="3" then
						Response.Write "[<a href=""detail.asp?qid="&rs("q_id")&""">已答复</a>]"
						'如果被锁就不能再回答了。
			else
					%>
              [<a href="detail.asp?qid=<%=rs("q_id")%>"><%= msg %>未答</a>|<a href="javascript:if (confirm('你确信删除此问题？')){window.location.href='allquestion.asp?Act=Del&id=<%=rs("q_id")%>';}" title="删除此问题"><font color="#CC0000">删</font></a>] 
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
			<a href="allquestion.asp?module=search&pages=1" class="z_next_page">第一页</a> 
            &nbsp; <a href="allquestion.asp?module=search&pages=<%=pages-1%>" class="z_next_page">前一页</a>&nbsp; 
            <a href="allquestion.asp?module=search&pages=<%=pages+1%>" class="z_next_page">下一页</a>&nbsp; 
            <a href="allquestion.asp?module=search&pages=<%=rsPageCount%>"  class="z_next_page">共<%=rsPageCount%>页</a>&nbsp; 
            第<%=pages%>页</td>
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
 