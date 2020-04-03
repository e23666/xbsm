<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(6)%>
<%
needOpen=false

conn.open constr

hostid=Requesta("hostid")
StartRenew=Requesta("StartRenew")
if not isNumeric(hostid) then url_return "抱歉，请输入ID值",-1
sql="select s_comment,s_buydate,s_year,s_productid,s_ownerid,s_ssl,s_other_ip from vhhostlist where s_sysid=" & hostid
rs.open sql,conn,1,1
if rs.eof then url_return "抱歉，该站点未找到",-1
s_comment=Rs("s_comment")
s_productids=rs("s_productid")
s_ownerid=rs("s_ownerid")
s_ssl=rs("s_ssl")
s_other_ip=rs("s_other_ip")
if not isnumeric(s_ssl&"") then s_ssl=0
sslprice=0
ipprice=0
p_prices=9999
NeedMoney=0
otherstr=""

localRs_SQL="select u_name,u_usemoney,u_premoney,u_level from userdetail where u_id=" & s_ownerid
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

if clng(s_ssl)>0 then
	sslprice=getneedprice(u_name,"vhostssl",1,"renew")
	otherstr=otherstr&"(含SSL:"&sslprice&"元/年)"
end if
if isip(s_other_ip) then
	if lcase(left(p_proid,2))="tw" then
		ipproid="twaddip"
		else
		ipproid="vhostaddip"
	end if
	ipprice=getneedprice(u_name,ipproid,1,"renew")
	otherstr=otherstr&"(含独立IP:"&ipprice&"元/年)"
end if

p_prices=GetNeedPrice(u_name,s_productids,1,"renew")

NeedMoney=ccur(p_prices)+ccur(ipprice)+ccur(sslprice)
 
if StartRenew="OKay" then
	RenewYear=Requesta("RenewYear")
	D1=RenewYear
	
	returnStr=putRenew("vhost",s_comment,RenewYear,GetUserName(s_ownerid))
	if left(returnStr,3)="200" then
		response.Write("<script>alert(""主机续费已经成功！"")</script>")
	else
		response.Write("<script>alert(""主机续费已经失败！"&returnStr&""")</script>")
	end if
end if
sql="select p_price from pricelist where p_proid='" & rs("s_productid") & "' and p_u_level=" & u_level
rs1.open sql,conn,1,1
if rs1.eof then url_return "抱歉，没有该主机所对应的价格表",-1
price=Rs1("p_price")
rs1.close

ReNewPid=rs("s_productid")


sql="SELECT NeedYear,RenewPrice FROM RegisterDomainPrice WHERE (ProId = '"&ReNewPid&"')"
rs1.open sql,conn,1,3
%>

<script language="javascript">

function check(form){
if(confirm("您要为<%=Rs("s_comment")%> 续费" + form.RenewYear.value + "年\n费用" + form.B1.value + "元\n\n确认您的选择吗？"))
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
    <td height='30' align="center" ><strong>虚 拟 主 机 续 费</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">虚拟主机管理</a> | <a href="addnewsite.asp">手工添加虚拟主机</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
        <form name="form1" method="post" action="" onSubmit="return check(this);">        
        <tr>
          <td class="tdbg"><table width="100%" border="0"  cellpadding="2" cellspacing="0">
                        <tr> 
                          <td><%if CheckIsBuyTestHost(Rs("s_comment")) then%>
                            试用主机不能进行续费操作,需要正式开通后才能续费 
                            <%else%>
                            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                              <tr> 
                                <td width="36%" align="right">对应用户：</td>
                                <td width="64%" height="15" class="e8"><%=u_name%></td>
                              </tr>
                              <tr> 
                                <td align="right">可用余额：</td>
                                <td height="15" class="e8"><%=u_usemoney%></td>
                              </tr>
                              <tr> 
                                <td align="right">优惠卷：</td>
                                <td height="15" class="e8"><%=u_premoney%></td>
                              </tr>
                              <tr>
                                <td align="right">&nbsp;</td>
                                <td height="15" class="e8">&nbsp;</td>
                              </tr>
                              <tbody> 
                              <tr> 
                                <td align="right">主<font color="#000000">&nbsp; 
                                  </font>机：</td>
                                <td height="15" class="e8"><%=Rs("s_comment")%></td>
                              </tr>
                              <tr> 
                                <td align="right"><font color="#000000"> 年 限：</font></td>
                                <td height="16"> <%=Rs("s_year")%></td>
                              </tr>
                              <tr> 
                                <td align="right"> 
                                  <p align="right">注册日期：</p>                                </td>
                                <td height="2"><%=formatDateTime(Rs("s_buydate"),2)%></td>
                              </tr>
                              <tr> 
                                <td align="right"> 
                                  <p align="right">到期日期：</p>                                </td>
                                <td height="26"><%=formatDateTime(DateAdd("yyyy",Rs("s_year"),Rs("s_buydate")),2)%></td>
                              </tr>
                              <tr> 
                                <td height="26" colspan="2">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td height="26" align="right"> 选择交费年头：</td>
                              <td height="26"><select name="RenewYear" size="1" class="input" onChange="GetRenewDomainPrice()">
                                    <option value="0" selected>请选择交费年头</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                  </select>                                </td>
                              </tr>
                            <tr> 
                              <td align="right"> 
                                交费金额：</td>
                              <td>&nbsp; <span id="MySize"></span><script language="JavaScript">
							  var price=<%=NeedMoney%>;
							  var otherstr="<%=otherstr%>"
							function GetRenewDomainPrice()
							{
								years=form1.RenewYear.value;
								MySize.innerHTML="<font color=red>"+(years*price)+"元</font>"+otherstr
								//MySize.innerHTML="<iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=s_productids%>&years="+years+"&user_name=<%=u_name%>&p_name=<%=s_comment%>&sslprice=<%=sslprice%>>对不起，你的浏览器不支持框架或者是被设置为不显示框架。</iframe>"
							}
							</script></td>
                            </tr>
                              <tr> 
                                <td height="1" align="center">
                                <td height="1"><input name="C1" type="submit" class="solidinput"  value="　主　机　续　费　" />
                                  <input type="hidden" name="Hostid" value="<%=Hostid%>" />
                                  <input type="hidden" name="StartRenew" value="OKay" />                              </tr>
                              </tbody> 
                            </table>
                          <%end if%>                          </td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td class="tdbg"><br />
            <strong>提示：</strong>您点击&quot;主机续费&quot;后，不能刷新该页面．若长时间没有响应，请先至管理中心核实续费是否成功后再重新进入该页面．<br />
            <br /></td>
        </tr>
        </form>
</table>
      <%rs.close%>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
