
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="bbbbbb"><img src="/template/Tpl_02/images/spacer.gif" width="1" height="2" /></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="494949"><img src="/template/Tpl_02/images/spacer.gif" width="1" height="7" /></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="6" cellspacing="0" bgcolor="ebebeb">
  <tr>
    <td width="124" align="center">&nbsp;</td>
    <td width="630"><a href="/">������ҳ</a> |<a href="/aboutus/">��������</a> | <a href="/aboutus/contact.asp">��ϵ����</a> | <a href="/customercenter/howpay.asp">���ʽ</a> | <a href="/agent/mode-d.asp">�������</a> | <a href="/manager/default.asp?page_main=%2FManager%2Fquestion%2Fsubquestion%2Easp">���ʱش�</a></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
    <td>��˾��ַ��<%=companyaddress%>���ʱࣺ<%=postcode%><br>
      �绰�ܻ���<%=telphone%> ����0���Ժ��<%=nightphone%><br>
      <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="���������Ϣ���Է�"><%=oicqitem%></a>
        <%next%>    </td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="6" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td align="center">��Ȩ���� <%=companyname%><br>
      CopyRight (c) 2002~2008 <a href="{companynameurl}"><%=companynameurl%></a> 
      all right reserved.</td>
  </tr>
</table>