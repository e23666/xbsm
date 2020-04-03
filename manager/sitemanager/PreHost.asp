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
  elseif module="Over" then

	if left(Session("results"),3)="200" then
		Sql="Update PreHost Set opened=1 where orderNo='" & OrderNo & "'"
        conn.Execute(Sql)
		Sql="Select * from PreHost where orderNo='" & OrderNo & "'"
		Rs.open Sql,conn,1,1
		if not Rs.eof then
			Sql="Update vhhostlist set s_appName='" & Rs("s_appName") & "',s_appAdd='" & Rs("s_appAdd") & "',s_appTel='" & Rs("s_appTel") & "',s_appEmail='" & Rs("s_appEmail") & "' where s_comment='" & Requesta("ftpAccount") & "'"
			conn.Execute(Sql)
		end if
		Rs.close
		Response.write "<div align=center><img src=/images/process.jpg></div>"

										orderid = getstrReturn(Session("results")&vbCrLf , "orderid")
										ip=getstrReturn(Session("results")&vbCrLf , "ip")
										freeurl=getstrReturn(Session("results")&vbCrLf , "freedomain")
										line1="<br>主机开设成功，同时系统分配您一个三级域名，您现在可以通过<a href=""http://"&freeurl&"/"" target=_blank>"&freeurl&"</a>立即投入使用。<br>"
										line2="服务器IP地址:"&ip&" &nbsp;<br>FTP帐号:"&Requesta("ftpaccount")&"<br>"
										line3="您可以给您的虚拟主机绑定自己的域名，并且把域名解析到IP地址:"&ip&"<BR>  好了,现在就进入您的<a href=/manager/vhost>虚拟主机的控制面板</a>看看吧.<br>"

										mailbodys= mailbodys & "尊敬的客户：您好！" & vbCrLf
										mailbodys= mailbodys & "您的订单#" & orderid &"（" & Requesta("proid") & "虚拟主机）已受理并开设完成。" & vbCrLf
										mailbodys= mailbodys & "" & vbCrLf
										mailbodys= mailbodys & "FTP地址：" & ip & "" & vbCrLf
										mailbodys= mailbodys & "FTP帐号：" & Requesta("ftpAccount") &  " " & vbCrLf
										mailbodys= mailbodys & "FTP密码：******（您所设置的密码）" & vbCrLf
										mailbodys= mailbodys & "网址：http://"&freeurl&"" & vbCrLf
										mailbodys= mailbodys & "" & vbCrLf
										mailbodys= mailbodys & "此网址由系统自动分配，若需要使用自己的域名，请登陆管理中心-绑定域名。登陆管理中心http://www.west263.com/manager，可对虚拟主机进行完善的管理（如：修改FTP密码、绑定域名、修改默认页、虚拟主机续费等）。" & vbCrLf & "特别提示：文件上传成功后，必须在１５天内按http://www.west263.com/beian/所述方式对网站进行备案，否则空间将被关闭！" & VbCrLf & VbCrLf
                                        mailbodys= mailbodys & "欢迎参加vcp D模式流量计费活动，让你的网站流量为您带来收入！详情请访问：http://www.west263.com/agent/mode-d.asp"
										mailbodys= mailbodys & "" & vbCrLf & VbCrLf & VbCrLf
										mailbodys= mailbodys & "" & "欢迎与我司交换友情链接，共同提高Google排名，详情请访问:http://www.west263.com/link" & VbCrLf  
										mailbodys= mailbodys & " " & vbCrLf
										mailbodys= mailbodys & " " & vbCrLf
										mailbodys= mailbodys & "" & vbCrLf
										mailbodys= mailbodys & "Tel:028-86262244 86263048 86263408 86263960 86264018  Fax:028-86264041" & vbCrLf
										mailbodys= mailbodys & "Email:support@west263.com" & vbCrLf
										mailbodys= mailbodys & "http://www.west263.com"

		Call sendmailplantext(Requesta("u_email"),"主机开通通知",mailbodys)
		Response.write line1 &line2 & line3 & "<!--" & Session("results") & "-->"

    else
		Response.write "<div align=center><img src=/images/process.jpg><br><br>主机开通失败，请与管理员联系，或检查用户的帐上是否有足够余额!</div>"& "<!--" & Session("results") & "-->"
    end if

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
                              <td align="center" class="tdbg">订单号：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SOrderNo" maxlength="20" size="10">                              </td>
                            </tr>
                            <tr> 
                              <td align="center" class="tdbg">域名：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SDomain" maxlength="50" size="20">                              </td>
                            </tr>
                            <tr> 
                              <td align="center" class="tdbg">用户名:</td>
                              <td class="tdbg"> 
                                <input type="text" name="SUserName" maxlength="20" size="10">                              </td>
                              <td class="tdbg"> 
                                <input type="submit" name="Submit" value="查找">                              </td>
                            </tr>
                            <tr> 
                              <td colspan="3" class="tdbg"><a href=PreHost.asp?page=<%=page-1%>>上一页</a>,<a href=PreHost.asp?page=<%=Page+1%>>下一页</a>,共<%=PageCount%>页,第<%=Page%>页</td>
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
                              <td width="32%" align="right" class="tdbg">用户名:                                 </td>
                              <td width="68%" class="tdbg"><%=Rs("u_name")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 订单号:                                 </td>
                              <td class="tdbg"><%=Rs("OrderNo")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 绑域名:                                 </td>
                              <td class="tdbg"><%=Rs("domains")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">年限：</td>
                              <td class="tdbg"><%=Rs("years")%>年 </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 价格:  </td>
                              <td class="tdbg"><%=formatNumber(Rs("price"),2,-1,-1)%>元                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">FTP用户名: </td>
                              <td colspan="2" class="tdbg"><%=Rs("ftpaccount")%>                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">主机类型:  </td>
                              <td valign="top" class="tdbg"><%=Rs("proid")%></td>
                            </tr>
                            <tr> 
                              <td colspan="2" align="right" class="tdbg"> <font size="2"> 
                                <input type="button" name="Button" value="正式注册" onClick="window.location.href='PreHost.asp?module=Open&OrderNo=<%=Rs("OrderNo")%>';" <%if Rs("opened") then Response.write " disabled"%>>
                                <input type="button" name="Submit2" value="删除订单" onClick="this.form.module.value='Erase';this.form.OrderNo.value=<%=Rs("OrderNo")%>;this.form.submit();">
                                </font></td>
                            </tr>
                            <tr> 
                              <td colspan="2" class="tdbg"> <font size="2"><img src="/images/dnsline.gif" width="100%" height="1"></font></td>
                            </tr>
                          </table>
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
                  <%
  elseif module="Open" then
	Sql="Select * from PreHost Where OrderNo='" & OrderNo  & "'"
    Rs.open Sql,conn,1,1
    if Rs.eof then URL_return "未找到此订单",-1
  %>
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" height="60">
                    <tr> 
                      <td colspan="2" height="60"> 
                        <p align="center" style="margin-right: 13"><br>
                          <br>
                          <br>
                          <img border="0" src="/images/orderreg.gif" width="50" height="39" align="absmiddle">waiting.....<br>
                          <br>
                          <font size="2">系统正在为您的服务进行初始化设置，整个过程持续时间视您的网速而定，交易过程中，<b>请不要关　　　　闭浏览器，请不要刷新本页！</b> 
                          </font>
                      </td>
                    </tr>
                    <tr> 
                      <td width="52%"> 
                        <p>&nbsp;</p>
                        <FORM name=loading>
                          <DIV align=center> 
                            <P>&nbsp; 
                              <INPUT     
style="text-align: center; font-size: 8pt; font-family: Verdana; color: #808080; border-style: none; border-width: medium" 
size=6 name=percent>
                              &nbsp; 
                              <INPUT     
style="font-family: Arial; font-color: red; font-size: 9pt; color: #808080; border-style: solid; border-color: #FFFFFF; padding: 0px" 
size=55 name=chart>
                              <SCRIPT language="">       
var bar = 0 
var line = "||" 
var amount ="||" 
count() 
function count(){ 
bar= bar+2
amount =amount  +  line 
document.loading.chart.value=amount 
document.loading.percent.value=bar+"%" 
if (bar<99) 
{setTimeout("count()",600);} 
else 
{}} 
</SCRIPT>
                            </P>
                          </DIV>
                        </FORM>
                      </td>
                    </tr>
                  </table>
                  <%
				strContents=""
				strContents=""
				paytype=0
				productName="虚拟主机"
				strContents = strContents & "vhost" & vbCrLf
				strContents = strContents & "add" & vbCrLf
				strContents = strContents & "entityname:vhost" & vbCrLf
				strContents = strContents & "producttype:" & Rs("proid") & vbCrLf
				strContents = strContents & "years:" & Rs("years") & vbCrLf
				strContents = strContents & "ftpuser:" & Rs("ftpaccount") & vbCrLf
				strContents = strContents & "ftppassword:" & Rs("ftppassword") & vbCrLf
				strContents = strContents & "paytype:" & paytype & vbCrLf
				strContents = strContents & "domain:" & Rs("domains") & vbCrLf
				'多于的用户购物车的信息
				strContents = strContents & "ppricetemp:" & Rs("price") & vbCrLf
				strContents = strContents & "productnametemp:" & productName & vbCrLf
				strContents = strContents & "." & vbCrLf

		Sql="Select u_email from userdetail where u_name='" & Rs("u_name") & "'"
		Set TestRs=conn.Execute(Sql)
		Email=TestRs("u_email")
		TestRs.close
		Set TestRs=nothing
%>
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
	Set conn1=  Server.CreateObject("cmodex.actx")
	Session("results") = conn1.ImPortOrDerArray(strContents,Rs("u_name"))
	Set conn1=nothing
	Response.write "<script language=javascript>window.location.href='PreHost.asp?module=Over&OrderNo=" & OrderNo & "&ftpaccount=" & Rs("ftpaccount") & "&proid=" & Rs("proid") & "&u_email=" & Email & "';</script>"
    Rs.close
end if
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->