<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���ⶨ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="RegisterPriceAdd.asp">�������ⶨ��</a> | <a href="../levelmanager/default.asp">���ⶨ��</a> | <A href="RegisterPriceList.asp" target="main">��Ʒ���깺��۸�</A></td>
  </tr>
</table>
<%
 	conn.open constr
if requesta("Proid")<>"" then
	p_id=requesta("Proid")
	p_Register=requesta("Register")
	p_UserLevel=requesta("UserLevel")
	p_User_Name=requesta("User_Name")
	
		for i=1 to 10
			if requesta("ReNewPrice_"&i)<>"" then
				BuyYears=requesta("BuyYears_"&i)
				ReNewPrice=requesta("ReNewPrice_"&i)
				BuyPrice=requesta("BuyPrice_"&i)
				if BuyPrice="" or BuyPrice=null then
					BuyPrice="0"
				end if
				
				sql="INSERT INTO RegisterDomainPrice (ProId, NewPrice, RenewPrice, NeedYear, UserLevel,User_Name) VALUES ('"&p_id&"',"&BuyPrice&","&ReNewPrice&","&BuyYears&","&p_UserLevel&",'"&p_User_Name&"')"
				
				'sql="INSERT INTO RegisterDomainPrice (ProductClassTeam, ProductId, BuyYears, BuyPrice, ReNewPrice) VALUES ("&p_type&",'"&p_id&"',"&BuyYears&","&BuyPrice&","&ReNewPrice&")"
				'response.Write(sql&"<br>")
				conn.execute(sql)
			end if
		next
response.Write("��ӳɹ���")
end if
%>
<br>
<table width="100%" border="0" cellpadding="4" cellspacing="1" class="border">
  <form name="form1" method="post" action="">
    <tr> 
      <td width="34%" align="right" class="tdbg">��Ʒid�� </td>
      <td width="66%" class="tdbg"> <input name="Proid" type="text" class="inputbox" id="Proid"> &lt;-- ���ұ�ѡ�� 
        <select name="select1" onChange="ChanggeValue()">
          <%
		sql="SELECT P_proId,p_name FROM productlist"
		rs1.open sql,conn,1,3
		if not rs1.eof then
		do while not rs1.eof
	  %>
          <option value="<%=rs1(0)%>"><%=rs1(1)%></option>
          <%
		rs1.movenext
		loop
		end if
		rs1.close
		%>
        </select></td>
<script>
function ChanggeValue()
{
	form1.Proid.value=form1.select1.value;
}
</script> <script>
function ChanggeValueregse()
{
	form1.Register.value=form1.regse.value;
}
</script>
    </tr>
    <tr> 
      <td align="right" class="tdbg" height="18">�û�����</td>
      <td width="66%" class="tdbg" height="18"> 
        <p> 
          <select name="UserLevel">
            <%for i=1 to 6%>
            <option value="<%=i%>"><%=i%></option>
            <%next%>
          </select>
          1��Ϊֱ�ӿͻ���2��Ϊ��ͨ�����Դ����ơ�</p>
        </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">ָ���û���</td>
      <td width="66%" class="tdbg"><input name="User_Name" type="text" class="inputbox" id="User_Name">
        ����������ˣ���˼۸�ֻ���ڴ��û���һ�㽨�鲻����д�� </td>
    </tr>
    <tr> 
      <td align="right" valign="top" class="tdbg">����۸�</td>
      <td class="tdbg"><table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td>����</td>
            <td>����۸�</td>
            <td>���Ѽ۸�</td>
          </tr>
          <%for i=1 to 10%>
          <tr> 
            <td nowrap><%=i%>�ꡡ</td>
            <td nowrap><input name="BuyPrice_<%=i%>" type="text" class="inputbox" size="9"></td>
            <td nowrap><input name="ReNewPrice_<%=i%>" type="text" class="inputbox" size="9"> 
              <input type="hidden" name="BuyYears_<%=i%>" value="<%=i%>"></td>
          </tr>
          <%next%>
        </table></td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="Submit" value="ȷ�����"></td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table>
</body>
</html>
<%
 	conn.close
%><!--#include virtual="/config/bottom_superadmin.asp" -->
