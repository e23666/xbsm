<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(3)
conn.open constr
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style>
td {
	line-height:2em;
}
.border tr:hover{background-color: #BCBCBC;}
.border tr{cursor: pointer;}
.ghbg {
  background-color: #EAF5FC;
}
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> ��������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table>
<br />
<div align="left">
<%
Dim totalmoney : totalmoney = 0
totalmoney = Conn.Execute("Select sum(Amount) as InM from ourmoney where Amount>0 and ismove=0")(0)
%>
<h3 style="text-align: center;">�û����Ѽ�¼���У������룺<%=totalmoney%>Ԫ</h3> 
<table width="95%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
    <tr  bgcolor=#ffffff>
      <td class="Title">���</td>
      <td class="Title">�û���</td>
      <td class="Title">��ʵ����</td>
      <td class="Title">δ����</td>
      <td class="Title">���ý��</td>
      <td class="Title">���Ѷ�</td>
    </tr>
<%
sql = "select u_id,u_name,u_company,u_usemoney,u_checkmoney,u_resumesum  from userdetail where u_resumesum > 0 order by u_resumesum desc"
Set c_rs = Server.createobject("ADODB.Recordset")
 c_rs.open sql,conn,3,2
  c_rs.pageSize=20
      if Not c_rs.eof then
		PageCount=c_rs.PageCount
		Page=Requesta("Page")
		if not isNumeric(Page) then Page=1
		Page=Cint(Page)
		if Page<1 or Page>PageCount then Page=1
		c_rs.AbsolutePage=Page
	   end if
  	   cur=0

	Do While Not c_rs.eof And cur<20
	If cur Mod 2 = 0 Then css = " class='ghbg'"
	%>
	 <tr <%=css%>> 
	 <td> <% = cur%></td>
	 <td> <a href="/siteadmin/usermanager/detail.asp?u_id=<%=c_rs("u_id")%>" style="color:blue"><% = c_rs("u_name")%></a> [<a href="/siteadmin/chguser.asp?module=chguser&username=<%=c_rs("u_name")%>" target="_blank">����</a>]</td>
	 <td> <% = c_rs("u_company")%> </td>
	 <td> <% = c_rs("u_checkmoney")%> </td>
	 <td> <% = c_rs("u_usemoney")%> </td> 
	 <td> <% = c_rs("u_resumesum")%> </td> 
	 </tr> 
	<%
	cur = cur + 1
	c_rs.movenext
Loop
c_rs.Close : Set c_rs = Nothing
%>

 <tr bgcolor="#FFFFFF"> 
            <td colspan =10 align="center">               <a href="?page=1">��һҳ</a> 
              &nbsp; <a href="?page=<%=page-1%>">ǰһҳ</a>&nbsp; 
              <a href="?page=<%=page+1%>">��һҳ</a>&nbsp; 
              <a href="?pages=<%=PageCount%>">��<%=PageCount%>ҳ</a>&nbsp; 
              ��<%=page%>ҳ</td>
          </tr>
  </table>
</div>
<!--#include virtual="/config/bottom_superadmin.asp" --> 
