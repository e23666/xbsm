<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr
Act=requesta("ACT")
if Act="add" then
	u_name=requesta("u_name")
	sql="select u_id from UserDetail where u_name='"&u_name&"'"
	rs.open sql,conn,1,3
	if rs.eof then
		rs.close
		url_return "��������û������ڣ����ʵ��",-1
	end if
	u_id=rs(0)
	rs.close
	
	Proid=requesta("Proid")
	buy_num=requesta("buy_num")
	contact=requesta("contact")
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE6 {color: #FFFFFF; font-weight: bold; }
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> �ƹ�ҵ�����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">�ƹ�ҵ�����</a> | <a href="AddSearch.asp">����ƹ�ҵ��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
      
<TABLE width="100%" border=0 align=center  cellPadding=3 cellSpacing=0 class="border">
  <form name="form1" method="post" action="">
<TBODY> 
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">�û�����</TD>
                  <TD class="tdbg">&nbsp;
                  <input type="text" name="u_name" id="u_name"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��Ʒ���ƣ�</TD>
                  <TD class="tdbg">&nbsp;
                    <select name="Proid" id="Proid">
                      <%
					  sql="select * from productlist where p_type=4"
					  rs.open sql,conn,1,3
					  if not rs.eof then 
					  do while not rs.eof 
					  %>
                      <option value="<%=rs("P_proId")%>"><%=rs("p_name")%></option>
                      <%
					  rs.movenext
					  loop
					  end if
					  rs.close
					  %>
                    </select></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">����������</TD>
                  <TD class="tdbg">&nbsp;
                    <select name="buy_num" id="buy_num">
                    	<%for i=1 to 10%>
                      <option value="<%=i%>"><%=i%></option>
                      	<%next%>
                    </select>                  </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ϵ��������</TD>
                  <TD class="tdbg">&nbsp;
                  <input type="text" name="contact" id="contact"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��˾���ƣ�</TD>
                  <TD class="tdbg">&nbsp; <input type="text" name="company" id="company"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ϵ�绰��</TD>
                  <TD class="tdbg">&nbsp; <input type="text" name="phone" id="phone"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">Email ��ַ��</TD>
                  <TD class="tdbg">&nbsp; 
                  <input type="text" name="email" id="email"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��վ URL ��ַ��</TD>
                  <TD class="tdbg">&nbsp; <input type="text" name="url" id="url"></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ע��</TD>
                  <TD class="tdbg"><textarea name="Mark" cols="30" rows="5"></textarea></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">״̬��</TD>
                  <TD class="tdbg">&nbsp;<select name="check" id="check">
                    <option value="1">�������</option>
                    <option value="-1">�������ܾ�</option>
                    <option value="-2">�����ѷ���</option>
                    <option value="0">δ����</option>
                  </select>                  </TD>
    </TR>
                  <TR bgcolor="#FFFFFF"> 
                    <TD colspan="2" align="center" class="tdbg"> 
					  <input type="button" name="sub1" value=" �� �� ͨ �� " onClick="subForm(this.form,'pass')">
					  <input type="button" name="sub1" value=" �� �� �� �� " onClick="subForm(this.form,'refuse')">
					  <input type="button" name="sub1" value=" �� �� �� �� " onClick="subForm(this.form,'drop')">
                      <input name="ACT" type="hidden" id="ACT" value="add" ></TD>
                  </TR>
</form></TABLE>  
<%
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
