<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
id=Requesta("id")
If id="" Then url_return "�Բ�����ѡ���ƷID�� !",-1
conn.open constr
sql="select * from searchlist where id="&id
rs.open sql,conn,1,1
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
    <td width="771"><a href="default.asp">�ƹ�ҵ�����</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
<TABLE width="100%" border=0 align=center  cellPadding=2 cellSpacing=0 class="border">
<TBODY> 
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">�û�����</TD>
                  <TD class="tdbg">&nbsp;<%=rs("u_name")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��Ʒ���ƣ�</TD>
                  <TD class="tdbg">&nbsp;<%=rs("p_name")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ƷID�ţ�</TD>
                  <TD class="tdbg">&nbsp;<%=ucase(rs("p_proid"))%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��Ʒ˵����</TD>
                  <TD class="tdbg">&nbsp;<%=rs("p_info")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��Ʒ���ۣ�</TD>
                  <TD class="tdbg"><B><FONT 
        color=#084b8e>&nbsp;��<%=rs("p_agent_price")%></FONT></B></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">����������</TD>
                  <TD class="tdbg">&nbsp;<%=rs("buy_num")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ϵ��������</TD>
                  <TD class="tdbg">&nbsp;<%=rs("contact")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��˾���ƣ�</TD>
                  <TD class="tdbg">&nbsp;<%=rs("company")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ϵ�绰��</TD>
                  <TD class="tdbg">&nbsp;<%=rs("phone")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">Email ��ַ��</TD>
                  <TD class="tdbg">&nbsp;<%=rs("email")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��վ URL ��ַ��</TD>
                  <TD class="tdbg">&nbsp;<%=rs("url")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">��ע��</TD>
                  <TD class="tdbg">&nbsp;<%=rs("memo")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">״̬��</TD>
                  <TD class="tdbg">&nbsp; <%
                    If rs("check")="1" Then 
                         Response.Write "�������"
                       ElseIf rs("check")="-1" Then
					      Response.Write "�������ܾ�"
                       ElseIf rs("check")="-2" Then
					      Response.Write "�����ѷ���"
					   else
					      Response.Write "δ����"
					End if
                    %> </TD>
    </TR>
                <form <%if ucase(rs("p_proid"))<>"CN001" then%>action="setoksearch.asp" 
<%else
%>
action="setokdomain.asp" 
<%end if

%>meth=post>
                  <TR bgcolor="#FFFFFF"> 
                    <TD align="right" class="tdbg">��ע/�ܾ�ԭ�� </TD>
                    <TD align="center" class="tdbg"> 
                    <textarea name="Mark" cols="30" rows="5"><%=rs("Mark")%></textarea>                    </TD>
                  </TR>
                  <%
If rs("check")=0 Then

%> 
                  <TR bgcolor="#FFFFFF"> 
                    <TD colspan="2" align="center" class="tdbg"> 
					  <input type="button" name="sub1" value=" �� �� ͨ �� " onClick="subForm(this.form,'pass')">
					  <input type="button" name="sub1" value=" �� �� �� �� " onClick="subForm(this.form,'refuse')">
					  <input type="button" name="sub1" value=" �� �� �� �� " onClick="subForm(this.form,'drop')">
                      <input type="hidden" name="action" value="" >
                      <input type="hidden" name="id" value="<%=rs("id")%>">                    </TD>
                  </TR>
                  <%
else
%>                  <TR bgcolor="#FFFFFF"> 
                    <TD colspan="2" align="center" class="tdbg">
					  <input type="submit" name="submit1" value=" �� �� �� ע ">
                      <input type="hidden" name="action" value="keep">
                      <input type="hidden" name="id" value="<%=rs("id")%>">               </TD>
                  </TR>
<%
End If
%> 
                </form>
<script language=javascript>
function subForm(form,op){
	if (op=="refuse"){
			if (form.Mark.value==""){
				alert("�����ܾ������ɣ�����^_^");
				form.Mark.value="���ڴ���������";
				form.Mark.select();
				form.Mark.focus();
				return false;
			}
		}
	form.action.value=op;
	form.submit();
	}
</script>
              </TABLE>      
<%
Function showstatus(svalues)
    Select Case svalues
      Case 0   '����
        showstatus="<img src=/images/green1.gif width=17 height=17>"
      Case -1'
        showstatus="<img src=/images/nodong.gif width=17 height=17>"
      Case else
        showstatus="<img src=/images/nodong.gif width=17 height=17>"
    End Select
End Function
%><!--#include virtual="/config/bottom_superadmin.asp" -->
