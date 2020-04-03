<!--#include file="admin_head.asp"--><body bgcolor="#F4EEE4">
<br><br>
<%
 action=Request.QueryString("action")
 
 flag=replace(Request("flag"),"'","")
 
 if flag="" then flag=0
 
 
 if action="del" then
  ClassID=replace(Request("ClassID"),"'","")
conn.execute("delete * from article_class where unid="&ClassID&" and unid>16")
 Response.Write("<script>alert('操作成功!\n系统分类不允许删除，只能更改');location.href='?action=list&flag="&flag&"'</script>") 
 response.End()
 end if
 
 if action="editsave" then
 ClassID=replace(Request("ClassID"),"'","")
 ClassName=replace(Request("ClassName"),"'","")
 
 set crs=Server.CreateObject("adodb.recordset")
 sql="select top 1 * from article_class where unid="&ClassID
 crs.open sql,conn,1,3
   if crs.eof then
   crs.addnew
   crs("flag")=flag
   end if 
   crs("ClassName")=ClassName
   crs.update
   Response.Write("<script>alert('操作成功!');location.href='?action=list&flag="&flag&"'</script>") 
 response.End()
 end if
 
%>
<table width="95%" border="1" cellspacing="0" cellpadding="3" align="center" bordercolorlight="#ECEEE4" bordercolordark="#CCCABC">
  <tr> 
    <td colspan="6" align="center" height="30" background="image/tablebg.gif"><b>常见问题分类</b> [<a href="?action=list">根目录</a>]</td>
  </tr>
  <tr align="center"> 
    <td height="25"><strong>ID</strong></td>
    <td><strong>分类名称</strong></td>
    <td><strong>父ID</strong></td>
   <td><strong>操作</strong></td>
  </tr>
 
 
      <%
	set rs=server.createobject("adodb.recordset")
 
		Sql = "Select * from article_class where flag = "&flag&" order by Unid desc"
 
	
	rs.open sql,conn,1,1
 	if rs.eof and rs.bof then
		Response.Write "<center><font color=red>暂无数据！</font></center>"
	else
	 
	%>
 
 
    <%do while not rs.eof%>
    <tr> 
      <td height="25" align="center"><%=rs("Unid")%></td>
      <td height="25" align="center"> 
       <%=rs("className")%>
      </td>
      <td height="25" align="center"><%=rs("flag")%></td>
      <td align="center"><a href="?action=edit&amp;classid=<%=rs("Unid")%>&flag=<%=rs("flag")%>">修改</a> <a href="?action=del&amp;classid=<%=rs("Unid")%>">删除</a><%if clng(flag)=0 then%> <a href="?action=add&amp;flag=<%=rs("unID")%>">查看子类</a> <a href="?action=add&amp;flag=<%=rs("unID")%>">添加子类</a><%end if%></td>
    </tr>
    <%
  
  rs.movenext
  loop
  end if
  
  
  classid=replace(Request("classid"),"'","")
  if classid="" then classid=0
  className=""
 flag=0
  if action="edit" then
  set ers=conn.execute("Select * from article_class where unid = "&classid&" order by Unid desc")
	  if not ers.eof then
	  classid=ers("unid")
	  className=ers("className")
	  flag=ers("flag")
	  end if
  end if
  
  %>
<TR><td colspan="4">
<form action="?action=editsave" method="post" onsubmit="return checkform()">
所属分类:<select name="flag">
<option value="0">---根---</option>
<%
set nrs=conn.execute("Select * from article_class where flag = 0 order by Unid desc")
do while not nrs.eof 
if clng(flag)=clng(nrs("unid")) then
response.Write("<option value="""&nrs("unid")&""" selected >"&nrs("className")&"</option>")
else
response.Write("<option value="""&nrs("unid")&""" >"&nrs("className")&"</option>")
end if

nrs.movenext
loop
%>
</select>

<input name="ClassID" type="hidden" id="ClassID" value="<%=ClassID%>" />
<input name="ClassName" type="text" id="ClassName" value="<%=ClassName%>" />
<input type="submit" name="button" id="button" value="确定操作" /> 
(注:分类所属一经选中不能更改，系统所添加类型不允许删除！)
</form>
</td></TR>
</table>
<!--#include file="admin_copy.asp"-->