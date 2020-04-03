<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(6)%>

<%
conn.open constr
Select Case Requesta("module")
  Case "topnews"
	sqlcmd="SELECT top 1 * FROM [news] order by newsid desc"
  Case Else
	newsid=Requesta("newsid")
	sqlcmd="SELECT * FROM [news] where newsid="&newsid&""
End Select
rs.open sqlcmd,conn,3
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
    <td width="771"><a href="default.asp">所有新闻</a> | <a href="addnews.asp">发布新闻</a></td>
  </tr>
</table>
<br>

<TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
                <TR bgColor=#ffffff> 
                  <TD width="14%" align="right" bgcolor="#ffffff" class="tdbg">新闻标题</TD>
                  <TD width="86%" bgcolor="#ffffff" class="tdbg"><%=rs("newstitle")%> </TD>
                </TR>
                <TR bgColor=#ffffff> 
                  <TD align="right" bgcolor="#ffffff" class="tdbg">新闻内容</TD>
                  <TD bgcolor="#ffffff" class="tdbg"> <%=rs("newscontent")%><BR>
                    <%
				  If rs("newpic")<>"" Then
					Response.Write "<img src="""&rs("newpic")&""">"
				  End If
				  %>                  </TD>
                </TR>
                <TR bgColor=#ffffff> 
                  <TD colspan=2 align=center bgcolor="#ffffff" class="tdbg"> 
                  <%
					If rs("newsshow")=1 Then
						Response.Write "<a href=""checked.asp?newsid="&rs("newsid")&""">审核发布该新闻</a>"
					End If
					%>                  </TD>
                </TR>
</TABLE>
<%
rs.close
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
