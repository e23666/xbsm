<!--#include virtual="/config/config.asp"-->
<%
check_is_master(6)
conn.open constr
Act=Requesta("Act")
info=Request("info")
url=Request("url")
if Act<>"" then
  if info<>"" and url<>"" then info="<a href=""" & url & """><font color=red>" & info & "</font></a>"
  sql="update systemvar set notice='" & info & "'"
  conn.Execute(Sql)
  appMes="����ɹ�<Br>"
end if
sql="select [notice] from systemvar"
rs.open sql,conn,1,1
if not rs.eof then info=rs("notice")
rs.close
conn.close
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>����֪ͨ</strong></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
  <form name="form1" method="post" action="">
    <tr> 
      <td align="center" class="tdbg" >&nbsp;</td>
      <td class="tdbg" ><%=appMes%></td>
    </tr>
    <tr> 
      <td colspan="2" align="right" class="tdbg">
        <div align="left">����֪ͨ�����û�����������ʾ��</div>
      </td>
    </tr>
    <tr> 
      <td width="37%" align="right" class="tdbg"> ֪ͨ����: </td>
      <td width="63%" class="tdbg"> 
        <input type="text" name="info" maxlength="500" size="40" value="<%=Server.HTMLEncode(info&"")%>">
        (���500�ַ���Ϊ��ȡ��֪ͨ) </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">���ӵ�ַ: </td>
      <td class="tdbg"> 
        <input type="text" name="url">
        (�ɲ���д)</td>
    </tr>
    <tr> 
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg"> 
        <input type="submit" name="Act" value="����">
      </td>
    </tr>
    <tr> 
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table>


</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
