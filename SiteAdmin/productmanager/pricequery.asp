<!--#include virtual="/config/config.asp"-->
<%Check_Is_Master(1)%>
<%	

conn.open constr

if requesta("submit")<>"" then
	ProductID=requesta("proid")
	u_level=requesta("u_level")
	username=requesta("username")
	BuyYears=requesta("years")
	BuyType=requesta("BuyType")
	if ProductID="" or BuyYears="" or BuyType="" then url_return "ȱ�ٲ���!",-1
	if username<>"" then
		price=GetNeedPrice(username,ProductID,BuyYears,BuyType)
	end if
	
	if username="" and u_level<>"" then
		sql="select top 1 u_name from UserDetail where u_level="&u_level
		rs.open sql,conn,1,1
		if not rs.eof then	username2=rs(0)
		price=GetNeedPrice(username2,ProductID,BuyYears,BuyType)
	
	end if
	costPrice=""
	costSql="select top 1 * from productlist where p_proId='"& ProductID &"'"
	rs11.open costSql,conn,1,1
	if not rs11.eof then
		costPrice=rs11("p_costPrice")
	end if
	rs11.close

end if

%>
<html>
<head>
<script>
function ChanggeValue()
{
	form.Proid.value=form.select1.value;
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�۸��ѯ</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
<br>
<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bgcolor="#F0F0F0" class="border">
  <form name="form" method="post" action="">
<%
if price<>"" then
	if buytype="new" then 
	buytype="�¹���" 
	else
	buytype="����" 
	end if
%> 
    <tr>
      <td height="40" colspan="2" align="center" ><span style="color: #FF0000"><strong style="font-size:14px">�û�:<%=username%>����:(<%=u_level%>)<%=buytype%><%=BuyYears%>��<%=ProductID%>��Ҫ <%=price%>Ԫ</strong>[�ɱ���:<%=costPrice%>]</span></td>
    </tr>
<%end if%>
    <tr bgcolor="#FFFFFF">
      <td align="right" >�û�����</td>
      <td ><input type="text" name="username">
        ��ѡ,����������û�����ֻ������û��ļ۸�</td>
    </tr>
    <tr bgcolor="#eaf5fc">
      <td align="right" >�û�����</td>
      <td ><select name="u_level">
        <option value="0" selected>--- ��ѡ���û����� ---</option>
        <option value="1">1ֱ�ӿͻ�</option>
        <option value="2">2������</option>
        <option value="3">3һ������</option>
        <option value="4">4�Ѻô���</option>
        <option value="5">5������</option>
        <option value="6">6�������</option>
        <option value="7">7���ƴ���</option>
      </select>      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td align="right" >���ޣ�</td>
      <td ><select name="years"  size="1" class="selectbox" >
        <option value=1 selected>1</option>
        <option value=2>2</option>
        <option value=3>3</option>
        <option value=4>4</option>
        <option value=5>5</option>
        <option value=6>6</option>
        <option value=7>7</option>
        <option value=8>8</option>
        <option value=9>9</option>
        <option value=10>10</option>
      </select>      </td>
    </tr>
    <tr bgcolor="#eaf5fc">
      <td align="right" >��Ʒ���ͣ�</td>
      <td ><input name="Proid" type="text" id="Proid">
        &lt;-- ���±�ѡ���Ʒ�ͺ�
        <select name="select1" onChange="ChanggeValue()">
          <option value="">ѡ���Ʒ�ͺ�</option>
          <%
		sql="SELECT P_proId,p_name FROM productlist"
		rs1.open sql,conn,1,3
		if not rs1.eof then
		do while not rs1.eof
	  %>
          <option value="<%=rs1(0)%>"><%=rs1(0)&rs1(1)%></option>
          <%
		rs1.movenext
		loop
		end if
		rs1.close
		%>
        </select>      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td align="right" >���ͣ�</td>
      <td ><input type="radio" name="buytype" value="new" checked>
        �¹���
        <input type="radio" name="buytype" value="renew">
        ���� </td>
    </tr>
    <tr bgcolor="#eaf5fc">
      <td colspan="2" align="center" bgcolor="#eaf5fc" ><input type="submit" name="Submit" value="  �� ѯ  ">      </td>
    </tr>
    <tr>
      <td colspan="2" bgcolor="#FFFFFF" ><br>
        ��ʾ��<br>
      �ù��ܿ��Բ�ѯ��ͬ���û�����ͬ�Ĵ������Ʒ�ļ۸񣬷��㱨�ۡ�<br>
      <br></td>
    </tr>
  </form>
</table>
<p>&nbsp;</p>
</body>
</html>
