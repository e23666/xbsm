<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(1)

c_date=date()
c_memo="还款"
substrings="<input type=submit name=Submit1 value=确定 onClick=""javascript:document.form1.module.value='incount';"">"
module=Requesta("module")
If module="incount" Then
 		u_countid=Requesta("sid1")

		u_name=Requesta("sid2")
		u_out=Requesta("sid3")
		if u_out<=0 then  url_return "金额不能为负数！",-1

		c_date=Requesta("sid4")
		c_memo=Requesta("sid5")
		If u_out="" Then u_out=0

		substrings="<input type=submit name=Submit1 value=款项二次确认 onClick=""javascript:document.form1.module.value='check';"">"
End If
If module="check" Then
	substrings="<input type=submit name=Submit1 value=再次确认 onClick=""javascript:document.form1.module.value='check';"">"
	u_countid=Ucase(left(session("user_name"),4)) & "-" & Requesta("sid1")

	u_name=Requesta("sid2")
	u_out=Requesta("sid3")
	c_date=Requesta("sid4")
	c_memo=Requesta("sid5")
	If u_out="" Then u_out=0

	needcheck=0
	if instr(c_memo,"优惠入款")>0 then
		needcheck=1
	end if
	
	conn.open constr

	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		url_return "凭证编号重复",-1
	end if
	rs.close
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	if rs.eof then
		url_return "错误用户失败",-1
	end if
	u_id=rs(0)
	rs.close
	
	sql="update Userdetail set u_remcount =  u_remcount + "&u_out&" , u_usemoney = u_usemoney  + "&u_out&" ,u_resumesum=u_resumesum - "&u_out&"  where u_name = '"&u_name&"'"
	conn.execute(sql)
	'显示余额功能
    u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
		
	sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput ,c_datecheck,c_check,c_type,o_id,p_proid,u_Balance) values ("&u_id&", -"&u_out&", 0, -"&u_out&", '"&u_countid&"' , '"&c_memo&"', '"&c_date&"','"&now()&"', '"&now()&"',"&needcheck&",9,0,'',"&u_Balance&")"
	conn.execute(sql)

		msg= "成功"
		u_countid=""

		u_name=""
		u_out=""
		c_date=date()
		c_memo="还款"
		substrings="<input type=submit name=Submit1 value=确定 onClick=""javascript:document.form1.module.value='incount';"">"
		conn.close
End If

if u_countid="" then u_countid="-" & getDateTimeNumber()
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet><body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>还款入户</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="<%=SystemAdminPath%>/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="coupons.asp">优惠券入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table><br>
                  <table width="100%" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse" >
      <tr>
						<td valign="top"  align="center">
				    <%
						Response.Write msg
						%>


						    <FORM action="returncount.asp" method=post name=form1>
						    <table width="100%" border=0 align=center cellpadding=3 cellspacing=0 bordercolordark=#FFFFFF class="border">
					          <TR>
						           
            <TD width="38%" align="right" class="tdbg">&nbsp;</TD>
						           
            <TD width="62%" class="tdbg">&nbsp;</TD>
						            </TR>
					          <TR>
						           
            <TD width="38%" align="right" class="tdbg">凭证编号：<%=Ucase(left(session("user_name"),4))%>-</TD>
						           
            <TD width="62%" class="tdbg"> 
              <INPUT name=sid1 size="20" value="<%=u_countid%>">
                                <input name=module type=hidden value=incount></TD>
						            </TR>
						         <TR>
						           
            <TD align="right" class="tdbg">用 户：</TD>
						           
            <TD class="tdbg">
<INPUT name=sid2 size="20"  value="<%=u_name%>">  </TD>
						            </TR>
						         <TR>
						           
            <TD align="right" class="tdbg">还款：</TD>
						           
            <TD class="tdbg">
<INPUT name=sid3 size="20"  value="<%=u_out%>"> 元</TD>
						            </TR>
						 		<TR>
						           
            <TD align="right" class="tdbg">款项类型：</TD>
						           
            <TD class="tdbg">
<INPUT name=sid5 size="20"  value="<%=c_memo%>"></TD>
						            </TR>
						 		<TR>
						           
            <TD align="right" class="tdbg">时　间：</TD>
						           
            <TD class="tdbg">
<INPUT name=sid4 size="20"  value="<%=c_date%>">(yyyy-mm-dd)</TD>
						            </TR>
						         <TR>
						           <TD align=center class="tdbg">&nbsp;</TD>
						           <TD class="tdbg"><%= substrings  %></TD>
						         </TR>
						         <TR>
						           <TD align=center class="tdbg">&nbsp;</TD>
						           <TD class="tdbg">&nbsp;</TD>
				              </TR>
							  </table>  
					      </form>



						</td>
				    </tr>
					</table>
  

<!--#include virtual="/config/bottom_superadmin.asp" -->
还款入户：用户申请业务失败，但已经扣款。通过这个功能将款项退回。用户可用金额增加，总金额不变。<br>
