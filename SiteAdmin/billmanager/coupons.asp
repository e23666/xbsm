<!--#include virtual="/config/config.asp" --><%Check_Is_Master(1)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(6)%>
<%
module=Requesta("module")
if module="coupons" then
	 	u_countid=Ucase(left(session("user_name"),4)) & "-" & Requesta("sid1")
		u_name=Requesta("sid2")
		u_out=Requesta("sid3")
		c_date=Requesta("sid4")
		c_memo="coupons"
		if Ccur(u_out)=0 then url_return "�����漰���Ϊ�㣬ʲôҲû��",-1
		If Not isdate(c_date&"") Then c_date=now()
	conn.open constr
	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		url_return "ƾ֤����ظ�",-1
	end if
	rs.close
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		u_id=rs(0)
	else
		url_return "�����û�ʧ��",-1
	end if
	rs.close
	'''''''''''''''''''''''''''''''''''''''''''''''''''''
	
		sql="update Userdetail set u_premoney =  u_premoney + "& u_out &" where u_name ='"& u_name&"'"
		conn.execute(sql)
	 '��ʾ����
    u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
		sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput ,c_datecheck,c_check,c_type,o_id,p_proid,u_Balance) values ("&u_id&", 0, 0, 0, '"&u_countid&"' , '"&c_memo&"-����"& u_out &"�Ż�ȯ', '"&c_date&"',"&PE_Now&","&PE_Now&",1,9,null,'',"&u_Balance&")"
		conn.execute(sql)
		
		
		'conn.execute("update UserDetail set u_checkmoney=u_checkmoney+"&u_out&" where u_name='"&u_name&"'")
		Alert_Redirect u_name&"�ɹ�����"&u_out&"�Ż�ȯ","coupons.asp"
		conn.close
	''''''''''''''''''''''''''''''''''''''''''''''''''''''
end if
if u_countid="" then u_countid="-" &getDateTimeNumber()
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet><body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���Ż�ȯ</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="coupons.asp">�Ż�ȯ���</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
  <table   bordercolor="#FFFFFF" cellpadding="0" cellspacing="0" id="AutoNumber3" style="border-collapse: collapse" width="100%" height="154">
    <tr>
      <td height="152" width="99%" valign="top"  align="center"><form action="coupons.asp" method="post" name="form1" id="form1">
          <table width="99%" border="0" align="center" cellpadding="3" cellspacing="0"  bordercolor="#61BCF6" bordercolordark="#FFFFFF" class="border">
            <tr>
              <td width="341" align="right" class="tdbg">ƾ֤��ţ�<%=Ucase(left(session("user_name"),4))%>-</td>
              <td width="422" class="tdbg"><input name="sid1" size="20" value="<%=u_countid%>" />
                  <input name="module" type="hidden" value="coupons" />
              </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">�� ����</td>
              <td width="422" class="tdbg"><input name="sid2" size="20" />
              </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">��</td>
              <td width="422" class="tdbg"><input name="sid3" size="20">
              Ԫ</td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">�������ͣ�</td>
              <td width="422" class="tdbg"> �Ż�ȯ </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">ʱ���䣺</td>
              <td width="422" class="tdbg"><input name="sid4" size="20"  value="<%=now()%>" />
              (yyyy-mm-dd)</td>
            </tr>
            <tr>
              <td colspan="2" align="center" class="tdbg"><input name="button" type="button" onClick="javascript:if(confirm('ȷ����?')){this.form.submit();}" value="�Ż�ȯȷ��" />
              </td>
            </tr>
          </table>
      </form></td>
    </tr>
  </table>
  </div>
<!--#include virtual="/config/bottom_superadmin.asp" -->
�Ż�ȯ���Ż�ȯ��������������������ҵ�ʾ֡����ݿ�Ĺ������ѣ���������������