<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(6)%>
<%

if session("tempd")<>"" then
	application("E_Q_id")=replace(application("E_Q_id"),"|"&session("tempd")&"="&session("user_name"),"")
end if
acc=requesta("acc")
if acc="view" then
	response.Write(application("E_Q_id"))
elseif acc="del" then
	application("E_Q_id")=""
	response.Write("已经清除成功！")
end if
%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
.STYLE4 {color: #FFFFFF}
.STYLE5 {color: #FF0000}
-->
</style>
<%
sqlstring="select top 500 * from  question where q_id>0"
module="search" 
If module="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		seachqtype = Requesta("qtype")
		if seachqtype="" then seachqtype="alltoreply"
		Select Case seachqtype
		  Case "mytoreply"
			sqllimit=" and q_answeruser='"&session("user_name")&"' and q_state_new=3"
		  Case "myreplyed"
			sqllimit=" and q_reply_name='"&session("user_name")&"' and q_state_new=3"
		  Case "alltoreply"
			sqllimit=" and q_state_new=0"
		  Case "allanswered"
			sqllimit=" and q_state_new=3"
		  case "allquestion"
			sqllimit=""
		  case "AnserUser"
			sqllimit="and q_reply_name='"&requesta("CosName")&"' and q_state_new=3"
		  case "UserOther"
			sqllimit="and q_user_name='"&requesta("userName")&"' and q_state_new=3"
		End Select
		sqlcmd= sqlstring & sqllimit
		'重新查找  分别需要定义 传上来的参数等等求出
		conn.open constr
		session("sqlsearch")=sqlcmd & " order by q_id desc"
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
    <td height='30' align="center" ><strong>有问必答</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>
<table width="100%" border="0" cellpadding="4" cellspacing="1" class="border">
  <tr>
    <td align="center" class="Title"><strong>[<a href="default.asp?module=search&amp;qtype=mytoreply"><span class="STYLE4">我的问题</span></a>]</strong></td>
    <td align="center" class="Title"><strong>[<a href="default.asp?module=search&amp;qtype=myreplyed"><span class="STYLE4">我已回答</span></a>]</strong></td>
    <td align="center" class="Title"><strong>[<a href="default.asp?module=search&amp;qtype=allquestion"><span class="STYLE4">所有问题</span></a>]</strong></td>
    <td align="center" class="Title"><strong>[<a href="default.asp?module=search&amp;qtype=alltoreply"><span class="STYLE4">所有未答</span></a>]</strong></td>
    <td align="center" class="Title"><strong>[<a href="default.asp?module=search&amp;qtype=allanswered"><span class="STYLE4">所有已答</span></a>]</strong></td>
    <td align="center" class="Title"><strong>[辅助（<a href="default.asp?acc=view"><span class="STYLE4">看</span></a> | <a href="default.asp?acc=del"><span class="STYLE4">删</span></a>）] </strong></td>
  </tr>
</table>
<br />
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
                <form action="" method="post" name="form1" class="border">
                  <tr> 
                    <td nowrap class="tdbg">员工用户名： <input name="CosName" type="text" id="CosName"> 
                      <input type="submit" name="Submit" value="搜索">
                      <input name="module" type="hidden" id="module" value="search">
                      <input name="qtype" type="hidden" id="qtype" value="AnserUser"></td>
                  </tr>
  </form>
</table>
<div align="left">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td valign="top"> 
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="21">
          <tr> 
            <td width="98%" height="21"> 
              <!--  BODY  -->
              <%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 10
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%> <TABLE width="100%" border=0 cellPadding=3 cellSpacing=1 class="border">
                <TR> 
                  <td align="center" class="Title"> <p style="margin-left: 9"><strong>问题类型</strong></p></td>
                  <td align="center" class="Title"><strong> 问题标题                      </strong></td>
                  <td align="center" class="Title"> <p style="margin-left: 6"><strong>问题时间</strong></p></td>
                  <td align="center" class="Title"><strong> 用户</strong></td>
                  <td align="center" class="Title"><strong> 标识</strong></td>
                  <td align="center" class="Title"><strong>评分</strong></td>
                  <td align="center" class="Title"> <p style="margin-left: 6"><strong>操作</strong></p></td>
                </TR>
                <%
	Do While Not rs.eof And i<11
	%>
                <TR bgcolor="#FFFFFF"> 
                  <td class="tdbg" title="<%=showqtype(rs("q_type")) %>"> 
                    <p style="margin-left: 9"><font color="#000000"><%=showqtype(rs("q_type")) %></font>
					<%
						if Rs("q_parentID")>0 then
							Response.write "<font color=red>★</font>"
					end if%> </td>
                  <td class="tdbg"> 
                    <p style="margin-left: 9"><font color="#000000"><a href="reply.asp?qid=<%=rs("q_id")%>"><font color="#0000FF"><%= left(rs("q_subject"),10) %></font></a> 
                      <font color="#0000FF">
                      <%
u_level=0
sql="select u_level from userdetail where u_name='" & rs("q_user_name") & "'"
rs1.open sql,conn,1,1
if not rs1.eof then
 u_level=rs1("u_level")
end if
rs1.close

					  if rs("q_from")<>"" and u_level>1 then response.write "[<font color=red>独立面板</font>]"%>
                      </font> </font> 
                  </td>
                  <td class="tdbg"> <p style="margin-left: 6"><font color="#000000"><%=left(replace(rs("q_reg_time")," ","   "),20)%></font></p></td>
                  <td class="tdbg"> <p style="margin-left: 6"><font color="#000000"><%= rs("q_user_name") %></font></p></td>
                  <td align="center" class="tdbg"> <p style="margin-left: 6"> 
                       
<%if not Rs("q_status") then 
  		flag="◇"
	else
	    flag="〓"
	end if
if Rs("q_fid")=0 then
	Response.write "<font color=#FF6600>" & flag & "</font>"
else
	Response.write "<font color=#000000>" & flag & "</font>"
end if

%>
                      </td>
                  <td align="center" class="tdbg"><%
				  if rs("q_score")>-1 then
				     Response.write rs("q_score")
				  else
				     Response.write "&nbsp;"
				  end if
				  %></td>
                  <td align="center" bgcolor="#FFFFFF" class="tdbg"> [<a href="reply.asp?qid=<%=rs("q_id")%>"><font color="#0000FF">答</font></a>][<a href="javascript:if (confirm('你确认删除此问题?用户将得不到答复')){window.location.href='reply.asp?qid=<%=rs("q_id")%>&Del=YES';}">删</a>]</td>
                </TR>
                <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan =8 align="center" bgcolor="#FFFFFF" class="tdbg">  <a href="default.asp?module=search&pages=1">第一页</a> 
                    &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">前一页</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=pages+1%>">下一页</a>&nbsp; 
                    <a href="default.asp?module=search&pages=<%=rsPageCount%>">共<%=rsPageCount%>页</a>&nbsp; 第<%=pages%>页</td>
                </TR>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan =8 class="tdbg"><br />
                    提示：<br />
                    <font color="#ff6000">◇</font>已答,单独问题 <font color="#000000">◇已答,跟踪问题 </font><font color="#ff6000">〓</font>未答,单独问题 
                  〓 <font color="#000000">未答,跟踪问题 </font><span class="STYLE5">★</span><font color="#000000">问题提交上级服务商处理<br />
                  <br />
                  </font></td>
                </TR>
              </table>
              <br> <%
  else
	rs.close
	conn.close
End If

%> 
              <!--  BODY END -->            </td>
          </tr>
        </table>
      <%
Function showqtype(q_type)
	Select Case q_type
		case 0101
		showqtype="售前咨询"
		case 0102
		showqtype="虚拟主机问题"
		case 0103
		showqtype="域名问题"
		case 0104
		showqtype="邮箱问题"
		case 0201
		showqtype="数据库问题"
		case 0202
		showqtype="服务器重启"
		case 0203
		showqtype="服务器重装系统"
		case 0204
		showqtype="财务问题"
		case 0301
		showqtype="续费问题"
		case 0302
		showqtype="网站备案问题"
		case 0305
		showqtype="服务器故障解决"
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
%></td>
    </tr>
  </table>

</div>

<!--#include virtual="/config/bottom_superadmin.asp" -->
