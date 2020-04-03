<!--#include virtual="/config/config.asp" --> <%Check_Is_Master(1)%> <%
conn.open constr

startChg=Request.Form("startChg")

if startChg<>"" then
	for each wwwvar in Request.Form
		if left(wwwvar,6)="level_" then
			levelid=mid(wwwvar,7)
			levelname=Request.Form(wwwvar)
			if levelname<>"" then
				conn.execute("update levellist set l_name='" & levelname & "' where l_level=" & levelid)
				conn.Execute("update userdetail set u_levelName='" & levelname & "' where u_level=" & levelid)
			end if
		end if
	next
	noteinfo="<HR>代理级别名称更新成功</HR>"
end if

%> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <HTML><HEAD> 
<TITLE></TITLE> <META http-equiv=Content-Type content="text/html; charset=gb2312"> 
<LINK href="../css/Admin_Style.css" rel=stylesheet> <body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'> 
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>修改代理级别名称</strong></td></tr> 
</table><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'> 
<tr class='tdbg'> <td width='91' height='30' align="center" ><strong>管理导航：</strong></td><td width="771">&nbsp;</td></tr> 
</table><br><%=noteinfo%><br> <TABLE WIDTH="100%" BORDER=0 ALIGN=center CELLPADDING=3 CELLSPACING=1 class="border" >
  <FORM NAME="form1" METHOD="post" ACTION="" onSubmit="return confirm('确定改变代理级别名称?')"> 
<TR BGCOLOR="#FFFFFF"> <TD WIDTH="47%" ALIGN="CENTER" BGCOLOR="#FFFFFF" class="tdbg"><%

rs1.open "select * from levellist",conn,1,1
do while not rs1.eof
	levelid=rs1("l_level")
%> <BR>级别<%=levelid%>:<INPUT TYPE="text" NAME="level_<%=levelid%>" value=<%=rs1("l_name")%>> 
<%
rs1.movenext
loop
rs1.close
%> <BR><BR><INPUT TYPE="submit" NAME="startChg" VALUE="确定改变"></TD></TR> 
</FORM></TABLE>
