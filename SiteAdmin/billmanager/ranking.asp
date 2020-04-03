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
    <td height='30' align="center" ><strong> 消费排行</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table>
<br />
<div align="left">
<%
Dim totalmoney : totalmoney = 0
totalmoney = Conn.Execute("Select sum(Amount) as InM from ourmoney where Amount>0 and ismove=0")(0)
%>
<h3 style="text-align: center;">用户消费记录排行，总收入：<%=totalmoney%>元</h3> 
<table width="95%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
    <tr  bgcolor=#ffffff>
      <td class="Title">序号</td>
      <td class="Title">用户名</td>
      <td class="Title">真实姓名</td>
      <td class="Title">未审金额</td>
      <td class="Title">可用金额</td>
      <td class="Title">消费额</td>
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
	 <td> <a href="/siteadmin/usermanager/detail.asp?u_id=<%=c_rs("u_id")%>" style="color:blue"><% = c_rs("u_name")%></a> [<a href="/siteadmin/chguser.asp?module=chguser&username=<%=c_rs("u_name")%>" target="_blank">代管</a>]</td>
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
            <td colspan =10 align="center">               <a href="?page=1">第一页</a> 
              &nbsp; <a href="?page=<%=page-1%>">前一页</a>&nbsp; 
              <a href="?page=<%=page+1%>">下一页</a>&nbsp; 
              <a href="?pages=<%=PageCount%>">共<%=PageCount%>页</a>&nbsp; 
              第<%=page%>页</td>
          </tr>
  </table>
</div>
<!--#include virtual="/config/bottom_superadmin.asp" --> 
