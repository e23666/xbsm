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
		'重新查找  分别需要定义 传上来的参数等等求出
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
    <td height='30' align="center" ><strong>新闻管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">所有新闻</a> | <a href="addnews.asp">发布新闻</a> | <%if not rs.eof then%><a href="checked.asp?newsid=<%=rs("newsid")%>">生成首页</a><%end if%></td>
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
                  <p align="center" style="margin-left: 9"><strong>新闻标题</strong></p>                  </td>
                  <td nowrap class="Title"><strong> 
                  发布用户</strong></td>
                  <td nowrap class="Title"><strong> 
                  html</strong></td>
                  <td nowrap class="Title"><strong> 
                  图片</strong></td>
                  <td align="center" nowrap class="Title"><strong> 
                  时间</strong></td>
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
                      <%if rs("html")=0 then Response.Write "是" Else Response.Write "否" %>
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
						Response.Write "[<a href=""detailnews.asp?newsid="&rs("newsid")&""">待审</a>]"
					 else
						Response.Write "[<a href=""detailnews.asp?newsid="&rs("newsid")&""">发布</a>]"
					End If
					%>
                    [<a href="checked.asp?module=del&newsid=<%=rs("newsid")%>">删除</a>] 
                    [<a href="editnews.asp?newsid=<%=rs("newsid")%>">编辑</a>]</td>
                </TR>
                <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan =7 align="center" bgcolor="#FFFFFF">                     <a href="default.asp?module=search&pages=1">第一页</a> 
                    &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">前一页</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=pages+1%>">下一页</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=rsPageCount%>">共<%=rsPageCount%>页</a>&nbsp; 
                    第<%=pages%>页</td>
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
		showqtype="域名服务类-基础知识"
		case 0102
		showqtype="域名服务类-业务相关"
		case 0103
		showqtype="域名服务类-故障解决"
		case 0104
		showqtype="域名服务类-其他"
		case 0201
		showqtype="空间租用类-基础知识"
		case 0202
		showqtype="空间租用类-业务相关"
		case 0203
		showqtype="空间租用类-故障解决"
		case 0204
		showqtype="空间租用类-其他"
		case 0301
		showqtype="集团邮局类-基础知识"
		case 0302
		showqtype="集团邮局类-业务相关"
		case 0303
		showqtype="集团邮局类-故障解决"
		case 0304
		showqtype="集团邮局类-其他"
		case 0401
		showqtype="建站利器类-基础知识"
		case 0402
		showqtype="建站利器类-业务相关"
		case 0403
		showqtype="建站利器类-故障解决"
		case 0404
		showqtype="建站利器类-其他"
		case 0501
		showqtype="系统集成类-基础知识"
		case 0502
		showqtype="系统集成类-业务相关"
		case 0503
		showqtype="系统集成类-故障解决"
		case 0504
		showqtype="系统集成类-其他"
		case 0601
		showqtype="其他类-基础知识"
		case 0602
		showqtype="其他类-业务相关"
		case 0603
		showqtype="其他类-故障解决"
		case 0604
		showqtype="其他类-其他"
		case else
		showqtype="其他类-其他"
	End Select
End Function
%>


<!--#include virtual="/config/bottom_superadmin.asp" -->
