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
		if Ccur(u_out)=0 then url_return "错误，涉及金额为零，什么也没做",-1
		If Not isdate(c_date&"") Then c_date=now()
	conn.open constr
	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		url_return "凭证编号重复",-1
	end if
	rs.close
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		u_id=rs(0)
	else
		url_return "错误用户失败",-1
	end if
	rs.close
	'''''''''''''''''''''''''''''''''''''''''''''''''''''
	
		sql="update Userdetail set u_premoney =  u_premoney + "& u_out &" where u_name ='"& u_name&"'"
		conn.execute(sql)
	 '显示余额功能
    u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
		sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput ,c_datecheck,c_check,c_type,o_id,p_proid,u_Balance) values ("&u_id&", 0, 0, 0, '"&u_countid&"' , '"&c_memo&"-加入"& u_out &"优惠券', '"&c_date&"',"&PE_Now&","&PE_Now&",1,9,null,'',"&u_Balance&")"
		conn.execute(sql)
		
		
		'conn.execute("update UserDetail set u_checkmoney=u_checkmoney+"&u_out&" where u_name='"&u_name&"'")
		Alert_Redirect u_name&"成功加入"&u_out&"优惠券","coupons.asp"
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
    <td height='30' align="center" ><strong>加优惠券</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="coupons.asp">优惠券入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
  <table   bordercolor="#FFFFFF" cellpadding="0" cellspacing="0" id="AutoNumber3" style="border-collapse: collapse" width="100%" height="154">
    <tr>
      <td height="152" width="99%" valign="top"  align="center"><form action="coupons.asp" method="post" name="form1" id="form1">
          <table width="99%" border="0" align="center" cellpadding="3" cellspacing="0"  bordercolor="#61BCF6" bordercolordark="#FFFFFF" class="border">
            <tr>
              <td width="341" align="right" class="tdbg">凭证编号：<%=Ucase(left(session("user_name"),4))%>-</td>
              <td width="422" class="tdbg"><input name="sid1" size="20" value="<%=u_countid%>" />
                  <input name="module" type="hidden" value="coupons" />
              </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">用 户：</td>
              <td width="422" class="tdbg"><input name="sid2" size="20" />
              </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">金额：</td>
              <td width="422" class="tdbg"><input name="sid3" size="20">
              元</td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">款项类型：</td>
              <td width="422" class="tdbg"> 优惠券 </td>
            </tr>
            <tr>
              <td width="341" align="right" class="tdbg">时　间：</td>
              <td width="422" class="tdbg"><input name="sid4" size="20"  value="<%=now()%>" />
              (yyyy-mm-dd)</td>
            </tr>
            <tr>
              <td colspan="2" align="center" class="tdbg"><input name="button" type="button" onClick="javascript:if(confirm('确认吗?')){this.form.submit();}" value="优惠券确认" />
              </td>
            </tr>
          </table>
      </form></td>
    </tr>
  </table>
  </div>
<!--#include virtual="/config/bottom_superadmin.asp" -->
优惠券：优惠券仅能用于虚拟主机、企业邮局、数据库的购买及续费，不适用于域名。