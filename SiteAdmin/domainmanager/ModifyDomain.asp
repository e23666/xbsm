<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
strDomain=Requesta("strDomain")
years=Requesta("years")
regDate=Requesta("regDate")
if strDomain<>"" and years<>"" then
  conn.open constr
 if not isDate(regDate) then url_return "��������ڸ�ʽ(yyyy-MM-dd)",-1
  if not isNumeric(years) then url_return "���ޱ���������",-1
Sql="update domainlist set regdate='" & regDate & "',years=" & years & ",rexpiredate='" & DateAdd("yyyy",years,RegDate) & "' where strdomain='" & strDomain & "'"
conn.Execute(Sql)
 url_return "��������/�����޸ĳɹ�,�뷵��",-1
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> �� �� �� �� У �� </strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">��������</a></span> | <a href="ModifyDomain.asp">��������У��</a> | <a href="DomainIn.asp">����ת��</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<form name="form1" method="post" action="ModifyDomain.asp">
    <tr> 
      <td align="right" class="tdbg">������</td>
      <td class="tdbg"> 
      <input type="text" name="strDomain">      </td>
    </tr>
    <tr> 
      <td height="30" align="right" class="tdbg">��ͨ���ڣ�</td>
      <td height="30" class="tdbg"> 
        <input type="text" name="regDate">
      ��ʽyyyy-mm-dd</td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">���ޣ�</td>
      <td class="tdbg"> 
        <input type="text" name="years" maxlength="5" size="5">
      ��������</td>
    </tr>
    <tr align="center"> 
      <td colspan="2" class="tdbg">
        <input type="submit" name="Submit" value=" ȷ �� �� ��">��
        <input type="reset" name="Submit2" value=" �� �� �� ��">      </td>
    </tr>
    <tr align="center">
      <td colspan="2" class="tdbg">&nbsp;</td>
    </tr>
  </form>
  </table>
  <p>&nbsp;</p>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
