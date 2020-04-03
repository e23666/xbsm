<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(6)%>
<%

conn.open constr

dataID=Trim(Requesta("dataID"))
if not isNumeric(dataID) then url_return "缺少数据库ID",-1
Sql="select * from databaselist where dbsysid="&dataID&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "未找到此数据库",-1
dbname=Rs("dbname")
db_productids=rs("dbproid")
db_ownerid=rs("dbu_id")

CustomerName=GetUserName(db_ownerid)

localRs_SQL="select u_name,u_usemoney,u_premoney,u_level from userdetail where u_id=" & db_ownerid
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


CustomerName=GetUserName(rs("dbu_id"))
price=GetNeedPrice(CustomerName,db_productids,rs("dbyear"),"renew")
StartRenew=requesta("StartRenew")

if StartRenew="OKay" then
	RenewYear=Requesta("RenewYear")
	D1=RenewYear
	
	returnStr=putRenew("mssql",dbname,RenewYear,CustomerName)
	if left(returnStr,3)="200" then
		response.Write("<script>alert(""数据库续费已经成功！"")</script>")
	else
		response.Write("<script>alert(""数据库续费已经失败！"&returnStr&""")</script>")
	end if
end if

%>

<script language="javascript">

function check(form){
if(confirm("您要为<%=dbname%> 续费" + form.RenewYear.value + "年\n费用" + form.B1.value + "元\n\n确认您的选择吗？"))
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
    <td height='30' align="center" ><strong>SQL 数 据 库 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">SQL数据库管理</a> | <a href="adddatabase.asp">手工添加SQL数据库</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
<br />
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
        <form name="form1" method="post" action="" onSubmit="return check(this);">        
        <tr>
          <td class="tdbg"><table width="100%" border="0"  cellpadding="2" cellspacing="0">
                        <tr> 
                          <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr>
                              <td align="right">数据库：</td>
                              <td class="e8"><%=rs("dbname")%></td>
                            </tr>
                            <tr>
                              <td align="right"><font color="#000000"> 年 限：</font></td>
                              <td><%=Rs("dbyear")%></td>
                            </tr>
                            <tr>
                              <td align="right"><p align="right">开通日期：</p></td>
                              <td><%=formatDateTime(Rs("dbbuydate"),2)%></td>
                            </tr>
                            <tr>
                              <td align="right"><p align="right">到期日期：</p></td>
                              <td><%=formatDateTime(DateAdd("yyyy",Rs("dbyear"),Rs("dbexpdate")),2)%></td>
                            </tr>
                            <tr>
                              <td colspan="2">&nbsp;</td>
                            </tr>
                              <tbody>
                              <tr> 
                                <td width="36%" height="26" align="right"> 选择交费年头：</td>
                              <td width="64%" height="26"><select name="RenewYear" size="1" class="input" onChange="GetRenewDomainPrice()">
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
                              <td>&nbsp; <span id="MySize"><iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=db_productids%>&years=0&user_name=<%=u_name%>></iframe></span><script language="JavaScript">
							function GetRenewDomainPrice()
							{
								years=form1.RenewYear.value;
								MySize.innerHTML="<iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=db_productids%>&years="+years+"&user_name=<%=u_name%>>对不起，你的浏览器不支持框架或者是被设置为不显示框架。</iframe>"
							}
							</script></td>
                            </tr>
                              <tr> 
                                <td height="1" align="center">
                                <td height="1"><input name="C1" type="submit" class="solidinput"  value="　主　机　续　费　" />
                                  <input type="hidden" name="dataID" value="<%=dataID%>" />
                                  <input type="hidden" name="StartRenew" value="OKay" />                              </tr>
                              </tbody> 
                            </table>
                          </td>
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
