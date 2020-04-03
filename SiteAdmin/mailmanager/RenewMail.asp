<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(1)%>
<%
conn.open constr
MailID=Trim(Requesta("MailID"))
myact=trim(requestf("myact"))
D1=Trim(Requesta("D1"))
if not isNumeric(MailID) then url_return "缺少邮局ID",-1
Sql="Select * from mailsitelist where m_sysid=" & MailID
Rs.open Sql,conn,1,1
if Rs.eof then url_return "未找到此邮局",-1
maildomain=Rs("m_bindname")

localRs_SQL="select u_name,u_usemoney,u_premoney,u_level from userdetail where u_id=" & rs("m_ownerid")
Set localRs=conn.Execute(localRs_sql)
if localRs.eof then
	url_return "错误,对应用户不存在",-1
end if

u_name=localRs("u_name")
u_usemoney=localRs("u_usemoney")
u_premoney=localRs("u_premoney")
u_level=localRs("u_level")
localRs.close
Set localRs=nothing
ReNewPid=Rs("m_productId")


Sql="Select p_price from pricelist where p_u_level=" & u_level &" and p_proid='" & ReNewPid &"'"
Set TestRs=conn.Execute(Sql)
if TestRs.eof then url_return "未找到此种类型的邮局，请联系管理员",-1
price=TestRs("p_price")
TestRs.close



%>



<script>
function check(form){
if(confirm("您要为<%=Rs("m_bindname")%> 续费" + form.D1.value + "年\n费用" + form.B1.value + "元\n\n确认您的选择吗？"))
 return true;
else
 return false;
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 企业邮局管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">企业邮局管理</a> | <a href="MailAdd.asp">手工添加企业邮局</a> 
      | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
<%
if isNumeric(D1) then
	D1=Abs(Cint(D1))
	returnStr=putRenew("mail",maildomain,D1,u_name)
	if left(returnStr,3)="200" then
		response.Write("<script>alert(""邮局续费已经成功！"")</script>")
	else
		response.Write("邮局续费已经失败！"&returnStr&"</script>")
	end if
end if
%>
<table width="100%" height="42" border="0" cellpadding="0" cellspacing="0" class="border">
                    <tr> 
                      <td height="21" class="tdbg"> 
                        <form name="form1" method="post" action="<%=Request("script_name")%>" onSubmit="return check(this);">
                          <table width="100%" border="0" cellpadding="3" cellspacing="1">
                            <tr> 
                              <td align="right">1. 邮 局</td>
                              <td class="e8"><%=Rs("m_bindname")%></td>
                            </tr>
                            <tr> 
                              <td align="right"><font color="#000000">2. 
                                年 限</font></td>
                              <td> <%=Rs("m_years")%></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <p align="right">注册日期：</p>                              </td>
                              <td><%=formatDateTime(Rs("m_buydate"),2)%></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <p align="right">到期日期：</p>                              </td>
                              <td><%=formatDateTime(DateAdd("yyyy",Rs("m_years"),Rs("m_buydate")),2)%></td>
                            </tr>
                              <tr> 
                                          <td colspan="2" align="center">&nbsp;</td>
                              </tr>
                            <tr> 
                              <td align="right"> 选择交费年头：</td>
                              <td>&nbsp; 
                                <select name="D1" size="1" class="input" onChange="GetRenewDomainPrice()">
                                  <option value="0" selected>请选择交费年头</option>
                                  <option value="1">1</option>
                                  <option value="2">2</option>
                                  <option value="3">3</option>
                                  <option value="4">4</option>
                                  <option value="5">5</option>
                                  <option value="6">6</option>
                                  <option value="7">7</option>
                                  <option value="8">8</option>
                              </select>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                交费金额：</td>
                              <td>&nbsp; <span id="MySize"><iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=ReNewPid%>&years=0&user_name=<%=u_name%>></iframe></span><script language="JavaScript">
							function GetRenewDomainPrice()
							{
								years=form1.D1.value;
								MySize.innerHTML="<iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=ReNewPid%>&years="+years+"&user_name=<%=u_name%>>对不起，你的浏览器不支持框架或者是被设置为不显示框架。</iframe>"
							}
							</script></td>
                            </tr>
                            <tr align="center"> 
                              <td colspan="2">
                                  <input name="C1" type="submit" class="buttom" style="font-family:宋体;font-size:9pt" value="　邮　局　续　费　">
                            <input type="hidden" name="MailID" value="<%=MailID%>">
                                </td>
                            </tr>
                          </table>
                        </form>
                        </td>
                    </tr>
                    <tr> 
                      <td width="100%" height="21"></td>
                    </tr>
                  </table>

<!--#include virtual="/config/bottom_superadmin.asp" -->

