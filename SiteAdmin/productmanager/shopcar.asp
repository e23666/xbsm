<%
response.Charset="gb2312"
response.Buffer=true
%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%Check_Is_Master(6)
conn.open constr
act=requesta("act")
if act="del" then
	cartID=requesta("cartID")
	if not isnumeric(cartID&"") then url_return "��������1",-1
	sql="delete from shopcart where s_status=0 and  cartID="&cartID
	conn.execute(sql)
	 url_return "�����ɹ���",-1
end if 
if act="savecontent" then
	cartID=requesta("cartID")
	cartContent=requesta("cartContent")
	if not isnumeric(cartID&"") then url_return "��������1",-1
    if trim(cartContent)="" then url_return "��������2",-1
	sql="select top 1 * from shopcart where s_status=0 and  cartID="&cartID
	rs.open sql,conn,1,3
	if not rs.eof then
	rs("cartContent")=cartContent
	rs.update
	end if
	rs.close
	Alert_Redirect "�����ɹ���","?ok"
end if

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>���ﳵ����</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #0650D2;
	font-weight: bold;
}
.STYLE5 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
 <script language="javascript" src="/jscripts/check.js"></script>
 
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���ﳵ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="?s_status=0">δ����</a> | <A HREF="?s_status=1">�ɹ�����</A></td>
  </tr>
</table>
<br>
</p> <form name="form2" action="<%=request("script_name")%>" method="post" >
      <table width="99%" border=0 align="center" cellpadding=2 cellspacing=1 class="border managetable tableheight">
		<tr  class="titletr">
			<th class="Title"></th>
			<th class="Title">�û�</th>
			<th class="Title">ҵ������</th>
            <th class="Title">���</th>
			<th class="Title">���ʱ��</th>
			<th class="Title">״̬</th>
			<th class="Title">��ϸ����</th>
			
			<th class="Title">����ֵ</th>
			<th class="Title">����</th>
		</tr>
		<%
	'othercode=" cartID desc"
	s_status=requesta("s_status")
	if not isnumeric(s_status&"") then s_status=0
	wherestr=" where 1=1"
	select case s_status
	case 1
	wherestr=wherestr&" and s_status>0"
	case 2
	wherestr=wherestr&" and s_status>0"
	case else
	wherestr=wherestr&" and s_status=0"
	end select
	sql="select   s.*,u_name from shopcart as s inner join UserDetail as u on s.UserID=u.u_id "&wherestr&" order by cartID desc"
	rs.open sql,conn,1,1
    setsize=10
	cur=1
	othercode="&s_status="&s_status
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
  
	do while not rs.eof and cur<=setsize
		tdcolor="#ffffff"
 		if cur mod 2=0 then tdcolor="#EAF5FC"
		content=rs("cartContent")
		buymoney=getReturn(content,"ppricetemp")
		'if instr(ubound(content),"ppricetemp:")>0 then
		

 %>  
<form name="form2" action="<%=request("script_name")%>" method="post" >
  <TR align=middle bgcolor="<%=tdcolor%>">
			<td><%=rs("cartID")%></td>
			<td><a href="/SiteAdmin/usermanager/detail.asp?u_id=<%=rs("UserID")%>" target="_blank"><%=rs("u_name")%></a></td>
			<td><a href="?ywType=<%=rs("ywType")%>&s_status=<%=s_status%>"><%=rs("ywType")%></a></td>
			<td><%=buymoney%></td><td><%=rs("addtime")%></td>
			<td><a href="?ywType=ywType&s_status=<%=rs("s_status")%>"><%
				select case rs("s_status")
				case 0 
				    response.write("<font color=red>δ����</font>")
				case 1
					response.write("<font color=green>�ɹ�����</font>")
				case 2
					response.write("<font color=blue>�ѷ��ʼ�</font>")
				end select
				%></a>
			</td>
			<td><TEXTAREA NAME="cartContent" ROWS="5" COLS="45"><%=content%></TEXTAREA></td>
			<td><TEXTAREA NAME="return_msg" ROWS="5" COLS="45"><%=rs("return_msg")%></TEXTAREA></td>
		
			<td>
			   <INPUT TYPE="hidden" name="cartID" value="<%=rs("cartID")%>">
			  
				<INPUT TYPE="submit">
				<%
				if clng(rs("s_status"))=0 then
				%>
 <INPUT TYPE="hidden" name="act" value="savecontent">
				<a href="?act=del&cartID=<%=rs("cartID")%>">ɾ��</a>
				<%
				end if
				%>
			</td>

  <tr>
  </form>
  <%
		cur=cur+1
		rs.movenext
	Loop
	rs.close
	
	%>
	  <tr bgcolor="#FFFFFF">
    <td colspan =9 align="center" nowrap bgcolor="#FFFFFF"><%=pagenumlist%></td>
  </TR>
	 </table>
   </form>
<br>

<!--#include virtual="/config/bottom_superadmin.asp" -->
