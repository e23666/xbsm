<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(5)%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>用户财务明细</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table><br>
<table width="100%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
<form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff> 
              <td width="33%" align="right" nowrap bgcolor="#FFFFFF" class="tdbg">用户名：</td>
              <td width="67%" bgcolor="#FFFFFF" class="tdbg"> <input name=module value="search" type=hidden> 
                <input name=UserName size="20" style="font-size: 9pt" value="<%=Requesta("UserName")%>">
                <input type="submit" name="button" id="button" value=" 搜 索 "></td>
    </tr>
          </form>
          <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff> 
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">域名：</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden><input name=DomainName size="20" style="font-size: 9pt" value="<%=Requesta("DomainName")%>"> 
                <input type="submit" name="button" id="button" value=" 搜 索 "> </td>
            </tr>
          </form>
          <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff>
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">ftp用户名：</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden><input name=FtpName size="20" style="font-size: 9pt" value="<%=Requesta("FtpName")%>"> 
                <input type="submit" name="button" id="button" value=" 搜 索 "> </td>
            </tr>
          </form>
		  <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff>
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">赠品：</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden>
			  <input name="freename" size="20" style="font-size: 9pt" value="<%=Requesta("freename")%>"> 
              <input type="submit" name="button" id="button" value=" 搜 索 "> <input  type="checkbox" name="freeall"value="ok" <%if trim(requesta("freeall"))="ok" then%>checked="checked"<%end if%>>全部</td>
            </tr>
          </form>
        </table>
        <br>
<%
		if Requesta("UserName")<>"" then
		  conn.open constr
			sql="select u_remcount,u_usemoney,u_checkmoney,u_resumesum,u_id from userdetail where u_name='"&Requesta("UserName")&"'"
			rs.open sql,conn,1,3
			if not rs.eof then
				u_remcount=rs(0)
				u_usemoney=rs(1)
				u_checkmoney=rs(2)
				u_resumesum=rs(3)
				u_id=rs("u_id")
			end if
			rs.close
			
			if u_id<>"" then
				sql="select sum(u_out) as dddddd from countlist where u_id="&u_id&""
				rs.open sql,conn,1,3
				u_summoney=rs(0)
				rs.close
			end if
		  conn.close
		end if
		%>
        
<table width="70%" border="0" cellspacing="0" cellpadding="3">
  <tr> 
    <td><font color="#FF0000"><strong>未审核款项:<%=u_checkmoney%></strong></font></td>
    <td><font color="#FF0000"><strong>可使用金额:<%=u_usemoney%></strong></font></td>
    <td><strong><font color="#003399">总消费金额:<%=u_summoney%></font></strong></td>
  </tr>
</table> 
        <table width="100%" border=0 align=center cellpadding=3 cellspacing=1 class="border">
          <tr align=middle> 
            <td align="center" valign="bottom" class="Title"><strong>用户名</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>代管</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>凭证单号</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>发生金额</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>入账</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>支出</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>时间</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>款项类型</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>余额</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>删除</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>状态</strong></td>
          </tr>
          <%
      PageCount=0
	  conn.open constr
	  sql="select top 100 a.*,b.u_name from (countlist a inner join userdetail b on a.u_id=b.u_id) order by c_date desc,sysid desc"
    if Requesta("UserName")<>"" then
      Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id and b.u_name='" &Requesta("UserName") & "')) order by c_date desc,sysid desc"
	elseif requesta("DomainName")<>"" then
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where u_countId like '%"&requesta("DomainName")&"%' or c_memo like '%"&requesta("DomainName")&"%' order by c_date desc,sysid desc"
	elseif requesta("FtpName")<>"" then
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where u_countId like '%"&requesta("FtpName")&"%' or c_memo like '%"&requesta("FtpName")&"%' order by c_date desc,sysid desc"
	elseif requesta("freename")<>"" then
	  if trim(requesta("freeall"))="ok" then
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where  charindex('[赠品]',c_memo)>0 order by c_date desc,sysid desc"
	  else
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where u_countId like '%"&requesta("freename")&"%' and c_memo like '%[赠品]%' order by c_date desc,sysid desc"
	  end if
	end if
	
	  Rs.open Sql,conn,3,2
      Rs.pageSize=20
      if Not Rs.eof then
		PageCount=Rs.PageCount
		Page=Requesta("Page")
		if not isNumeric(Page) then Page=1
		Page=Cint(Page)
		if Page<1 or Page>PageCount then Page=1
		Rs.AbsolutePage=Page
	   end if
  	   i=0

	Do While Not rs.eof And i<20
	%>
          <tr align=middle bgcolor="#FFFFFF"> 
            <td valign="center" class="tdbg"><a href="../usermanager/detail.asp?u_id=<%=Rs("u_id")%>" target="_blank"><font color="#0000FF"><%=rs("u_name")%></font></a></td>
             <td align="center" nowrap bgcolor="#EAF5FC" class="tdbg" width="4%"><a href="../chguser.asp?module=chguser&username=<%=rs("U_Name")%>"><font color="#0000FF">代管</font></a></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_countId")%></font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_moneysum")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_in")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_out")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("c_date")%></font></td>
            <td valign="center" class="tdbg"><font color="#000000"> 
              <%
if rs("c_check") then
response.write rs("c_memo")&"<a href=mlistedit.asp?sysid="&rs("sysid")&"> (修改)</a>"
else

response.write rs("c_memo")
end if
%>
              </font></td>
            <td valign="center" class="tdbg"  ><%=rs("u_Balance")%></td>
            <td valign="center" class="tdbg"  >&nbsp;<a href=mlistedit.asp?act=del&sysid=<%=rs("sysid")%>> 
              删</a></td>
            <td valign="center" class="tdbg"  > <font color="#000000"> 
              <%
				                If rs("c_check") Then
				               		Response.Write "未审"
				                   else
				               		Response.Write "完成"
				                End If
				                %>
              </font> </td>
          </tr>
          <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
          <tr bgcolor="#FFFFFF"> 
            <td colspan =10 align="center">               <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=1">第一页</a> 
              &nbsp; <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=<%=page-1%>">前一页</a>&nbsp; 
              <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=<%=page+1%>">下一页</a>&nbsp; 
              <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&pages=<%=PageCount%>">共<%=PageCount%>页</a>&nbsp; 
              第<%=page%>页</td>
          </tr>
</table>

<!--#include virtual="/config/bottom_superadmin.asp" -->
