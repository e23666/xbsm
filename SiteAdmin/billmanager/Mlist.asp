<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(5)%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�û�������ϸ</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table><br>
<table width="100%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
<form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff> 
              <td width="33%" align="right" nowrap bgcolor="#FFFFFF" class="tdbg">�û�����</td>
              <td width="67%" bgcolor="#FFFFFF" class="tdbg"> <input name=module value="search" type=hidden> 
                <input name=UserName size="20" style="font-size: 9pt" value="<%=Requesta("UserName")%>">
                <input type="submit" name="button" id="button" value=" �� �� "></td>
    </tr>
          </form>
          <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff> 
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">������</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden><input name=DomainName size="20" style="font-size: 9pt" value="<%=Requesta("DomainName")%>"> 
                <input type="submit" name="button" id="button" value=" �� �� "> </td>
            </tr>
          </form>
          <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff>
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">ftp�û�����</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden><input name=FtpName size="20" style="font-size: 9pt" value="<%=Requesta("FtpName")%>"> 
                <input type="submit" name="button" id="button" value=" �� �� "> </td>
            </tr>
          </form>
		  <form action="Mlist.asp" method=post>
            <tr bgcolor=#ffffff>
              <td align="right" nowrap bgcolor="#FFFFFF" class="tdbg">��Ʒ��</td>
              <td bgcolor="#FFFFFF" class="tdbg"><input name=module value="search" type=hidden>
			  <input name="freename" size="20" style="font-size: 9pt" value="<%=Requesta("freename")%>"> 
              <input type="submit" name="button" id="button" value=" �� �� "> <input  type="checkbox" name="freeall"value="ok" <%if trim(requesta("freeall"))="ok" then%>checked="checked"<%end if%>>ȫ��</td>
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
    <td><font color="#FF0000"><strong>δ��˿���:<%=u_checkmoney%></strong></font></td>
    <td><font color="#FF0000"><strong>��ʹ�ý��:<%=u_usemoney%></strong></font></td>
    <td><strong><font color="#003399">�����ѽ��:<%=u_summoney%></font></strong></td>
  </tr>
</table> 
        <table width="100%" border=0 align=center cellpadding=3 cellspacing=1 class="border">
          <tr align=middle> 
            <td align="center" valign="bottom" class="Title"><strong>�û���</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>����</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>ƾ֤����</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>�������</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>����</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>֧��</strong></td>
            <td align="center" valign="bottom" class="Title"><strong>ʱ��</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>��������</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>���</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>ɾ��</strong></td>
            <td align="center" valign="bottom" class="Title" ><strong>״̬</strong></td>
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
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where  charindex('[��Ʒ]',c_memo)>0 order by c_date desc,sysid desc"
	  else
	  Sql="Select a.*,b.u_name from (countlist a inner join userdetail b on (a.u_id=b.u_id)) where u_countId like '%"&requesta("freename")&"%' and c_memo like '%[��Ʒ]%' order by c_date desc,sysid desc"
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
             <td align="center" nowrap bgcolor="#EAF5FC" class="tdbg" width="4%"><a href="../chguser.asp?module=chguser&username=<%=rs("U_Name")%>"><font color="#0000FF">����</font></a></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_countId")%></font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_moneysum")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_in")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("u_out")%>.00</font></td>
            <td valign="center" class="tdbg"><font color="#000000"><%=rs("c_date")%></font></td>
            <td valign="center" class="tdbg"><font color="#000000"> 
              <%
if rs("c_check") then
response.write rs("c_memo")&"<a href=mlistedit.asp?sysid="&rs("sysid")&"> (�޸�)</a>"
else

response.write rs("c_memo")
end if
%>
              </font></td>
            <td valign="center" class="tdbg"  ><%=rs("u_Balance")%></td>
            <td valign="center" class="tdbg"  >&nbsp;<a href=mlistedit.asp?act=del&sysid=<%=rs("sysid")%>> 
              ɾ</a></td>
            <td valign="center" class="tdbg"  > <font color="#000000"> 
              <%
				                If rs("c_check") Then
				               		Response.Write "δ��"
				                   else
				               		Response.Write "���"
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
            <td colspan =10 align="center">               <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=1">��һҳ</a> 
              &nbsp; <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=<%=page-1%>">ǰһҳ</a>&nbsp; 
              <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&page=<%=page+1%>">��һҳ</a>&nbsp; 
              <a href="Mlist.asp?UserName=<%=Requesta("UserName")%>&DomainName=<%=requesta("DomainName")%>&FtpName=<%=requesta("FtpName")%>&freename=<%=requesta("freename")%>&freeall=<%=requesta("freeall")%>&pages=<%=PageCount%>">��<%=PageCount%>ҳ</a>&nbsp; 
              ��<%=page%>ҳ</td>
          </tr>
</table>

<!--#include virtual="/config/bottom_superadmin.asp" -->
