<%
Response.buffer=false
%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr
module=Trim(Requesta("module"))
OrderNo=Trim(Requesta("OrderNo"))
Opened=Trim(Requesta("Opened"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {color: #FF0000}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 手工添加虚拟主机</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">虚拟主机管理</a> | <a href="addnewsite.asp">手工添加虚拟主机</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
<TABLE width=100% border=0 cellPadding=0 cellSpacing=0>
  <TBODY> 
  <TR> 
    <TD vAlign=top align=middle> 
      <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
        <TBODY> 
        <TR> 
          <TD></TD>
        </TR>
        <TR valign="top"> 
          <TD> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
              <TBODY> 
              <TR> 
                <TD height="561" valign="top" colspan="3"> 
                  <%
  if module="Erase" then
    Sql="Delete from PreHost Where OrderNo='" & OrderNo  & "'"
    conn.Execute(Sql)
    Alert_Redirect "删除成功","PreHost.asp"
  elseif module="" then
	Sql="Select top 20 * from PreHost where opened=0 "
	Page=Trim(Requesta("Page"))
	if not isNumeric(page) then Page=1
	Page=Cint(Page)
	PageSize=5
	SOrderNo=Trim(Requesta("SOrderNo"))
	SDomain=Trim(Requesta("SDomain"))
	SUserName=Trim(Requesta("SUserName"))
	if SOrderNo<>"" then Sql=Sql & " and OrderNo='" & SOrderNo & "'"
	if SDomain<>"" then Sql=Sql & "  and domains='" & SDomain & "'"
	if SUserName<>"" then Sql=Sql & " and u_Name='" & SUserName & "'"
	if Opened="" then Sql = Sql & " or (opened=1 and OrderNo='" & SOrderNo & "')"
	Sql=Sql & " order by sDate desc"
	Rs.open Sql,conn,3,2
	if Not Rs.eof then
		Rs.PageSize=PageSize
		PageCount=Rs.PageCount
		if Page<1 or Page>PageCount then Page=1
		Rs.AbsolutePage=Page
	end if
%>
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" height="73">
                    <tr> 
                      <td width="100%" height="31" colspan="3" valign="top"> 
                        <form name="form1" method="post" action="PreHost.asp">
                          <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#FFFFFF" class="border">
                            <tr> 
                              <td align="right" class="tdbg">订单号：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SOrderNo" maxlength="20" size="10">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">域名：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SDomain" maxlength="50" size="20">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">用户名：</td>
                              <td class="tdbg"> 
                                <input type="text" name="SUserName" maxlength="20" size="10">                              </td>
                              <td class="tdbg"> 
                                <input type="submit" name="Submit" value="查找">                              </td>
                            </tr>
                            <tr> 
                              <td colspan="3" align="center" class="tdbg"><a href=PreHost.asp?page=<%=page-1%>>上一页</a>,<a href=PreHost.asp?page=<%=Page+1%>>下一页</a>,共<%=PageCount%>页,第<%=Page%>页</td>
                            </tr>
                          </table>
                          <br>
                          <%
	i=1
	do while not Rs.eof and i<=pageSize
%>
                          <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#000000" bordercolordark="#ffffff" class="border">
                            <tr> 
                              <td colspan="2" class="tdbg"><font size="2"><img src="/images/dnsline.gif" width="100%" height="1"></font></td>
                            </tr>
                            <tr> 
                              <td width="32%" align="right" class="tdbg">用户名: 
                              </td>
                              <td width="68%" class="tdbg"><%=Rs("u_name")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 订单号: </td>
                              <td class="tdbg"><%=Rs("OrderNo")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 下单日期: </td>
                              <td class="tdbg"><%=Rs("sDate")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 绑域名: </td>
                              <td class="tdbg"><%=Rs("domains")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">年限：</td>
                              <td class="tdbg"><%=Rs("years")%>年 </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 价格: </td>
                              <td class="tdbg"><%=formatNumber(Rs("price"),2,-1,-1)*Rs("years")%>元/<%=Rs("years")%>年
                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">FTP用户名: </td>
                              <td colspan="2" class="tdbg"><%=Rs("ftpaccount")%> 
                              </td>
                            </tr>
                            <tr>
                              <td align="right" class="tdbg">FTP密码：</td>
                              <td valign="top" class="tdbg"><%=Rs("ftppassword")%></td>
                            </tr>
                            <tr>
                              <td align="right" class="tdbg">操作系统：</td>
                              <td valign="top" class="tdbg"><%=Rs("osvar")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">主机类型: </td>
                              <td valign="top" class="tdbg"><%=Rs("proid")%></td>
                            </tr>
                            <tr> 
                              <td colspan="2" align="right" class="tdbg"> <font size="2"> 
                                <input type="button" name="Button" value="正式注册" onClick="window.location.href='Openhost.asp?module=Open&OrderNo=<%=Rs("OrderNo")%>';" <%if Rs("opened") then Response.write " disabled"%>>
                                <input type="button" name="Submit2" value="删除订单" onClick="if(confirm('确定要删除?')){this.form.module.value='Erase';this.form.OrderNo.value=<%=Rs("OrderNo")%>;this.form.submit();}">
                                </font></td>
                            </tr>
                            <tr> 
                              <td colspan="2" class="tdbg"> <font size="2"><img src="/images/dnsline.gif" width="100%" height="1"></font></td>
                            </tr>
                          </table>
                          <br>
                          <%
	i=i+1
	Rs.MoveNext
Loop
	Rs.close
%>
                          <input type="hidden" name="module">
                          <input type="hidden" name="OrderNo" value="">
                          <br>
                        </form>
                      </td>
                    </tr>
                  </table>
                  </TD>
              </TR>
              </TBODY> 
            </TABLE>
          </TD>
        </TR>
        <TR> 
          <TD bgColor=#cfdfef> </TD>
        </TR>
        <TR></TR>
        </TBODY> 
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>

<%
end if
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->