<table id="table1" background="/Template/Tpl_01/timages/bottomBg.gif" cellspacing="0" cellpadding="0" width="778" align="center" border="0">
  <tbody>
    <tr>
      <td 
    height="29" align="center"><strong><a href="/"><font color="#FFFFFF">������ҳ</font></a> |<a href="/aboutus/"><font color="#FFFFFF">��������</font></a> 
            | <a href="/aboutus/contact.asp"><font color="#FFFFFF">��ϵ����</font></a> | <a href="/customercenter/howpay.asp"><font color="#FFFFFF">���ʽ</font></a> 
      | <a href="/agent/mode-d.asp"><font color="#FFFFFF">�������</font></a> | <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><font color="#FFFFFF">���ʱش�</font></a></strong></td>
    </tr>
  </tbody>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr> 
    <td height="86" valign="top" align="left"> 
      <div align="center"><br>
        ��Ȩ���� <%=companyname%>���Ͻ����� <br>
        ���߿ͷ�: 
        <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="���������Ϣ���Է�"><%=oicqitem%></a>
        <%next%>
        <br>
        �������ߣ�<%=telphone%>�����棺<%=faxphone%><br>
        ��Ϣ������<a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">ҵ����ѯ</a> 
        <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">��������</a> 
        <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">����Ͷ��</a> 
        ���л����񹲺͹���ֵ����ҵ��Ӫ���֤����B2-20030065�� <br>
        <br />
       </div>
    </td>
  </tr>
</table>
