<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
id=requesta("id")
If id="" Then url_return "�Բ�����ѡ���ƹ��Ʒ !",-1
conn.open constr
sql="select * from searchlist where u_id="&session("u_sysid")&" and id="& id &""
rs.open sql,conn,1,1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><title>�û������̨-�ƹ��Ʒ����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
</HEAD>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">�ƹ��Ʒ����</div>
          <div class="table_out">
         
         <table width="100%" border=0 align=center  cellpadding=4 cellspacing=1 class="border managetable tableheight">
<tbody>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��Ʒ���ƣ�</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("p_name")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��ƷID�ţ�</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=ucase(rs("p_proid"))%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��Ʒ˵����</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("p_info")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��Ʒ���ۣ�</td>
                            <td bgcolor="#FFFFFF" class="tdbg"><b><font 
        color=#084b8e>&nbsp;��<%=rs("p_agent_price")%></font></b></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��������/������</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("buy_num")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF">
                            <td align=right bgcolor="#FFFFFF" class="tdbg">�����ܽ�</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;��<%=rs("p_agent_price")*rs("buy_num")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��ϵ��������</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("contact")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��˾���ƣ�</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("company")%>                            </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��ϵ�绰��</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("phone")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">Email ��ַ��</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("email")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��վ URL ��ַ��</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("url")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">��ע��</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("memo")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">״̬��</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp; 
                            <%
                    If rs("check")="1" Then 
                         Response.Write "�������"
                       ElseIf rs("check")="-1" Then
					      Response.Write "�������ܾ�"
                       ElseIf rs("check")="-2" Then
					      Response.Write "�����ѷ���"
					   else
					      Response.Write "δ����"
					End if
 %>                            </td>
                          </tr>
                          <%
If rs("check")="0" Then 
%>
                          <tr align="center" bgcolor="#FFFFFF"> 
                            <td colspan="2" bgcolor="#FFFFFF" class="tdbg"> <a href="setoksearch.asp?action=drop&id=<%=rs("id")%>">��������</a>                            </td>
                          </tr>
                          <%
End  if
%>
</table>
<%
conn.close
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
%>
         
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>

</body>
</html>

