<%
Response.buffer=false
server.ScriptTimeout=99999

%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/action.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr
module=Trim(Requesta("module"))
OrderID=Trim(Requesta("OrderID"))
if OrderID="" then URL_return "缺少订单号",-1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域名开通</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
<br />
<%
if module="Open" then
%>
<table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
  <tr>
    <td align="center" class="tdbg"><table border="0" cellpadding="0" cellspacing="0" width="100%" height="60">
                    <tr> 
                      <td colspan="2" height="60"> 
                        <p align="center" style="margin-right: 13"><br>
                          <br>
                          <br>
                          <br>
                      系统正在为您的服务进行初始化设置<font size="2">，</font>整个过程持续时间视您的网速而定<font size="2">，</font>交易过程中<font size="2">，</font><span class="STYLE4">请不要关闭浏览器<font size="2">，</font>请不要刷新本页<font size="2">！</font></span></td>
                    </tr>
                    <tr> 
                      <td width="52%"> 
                        <p>&nbsp;</p>
                        <FORM name=loading>
                          <DIV align=center> 
                            <P>&nbsp; 
                              <INPUT name=percent class="tdbg"     
style="color: #808080; border-style: none; border-width: medium" 
size=6>
                              &nbsp; 
                              <INPUT name=chart class="tdbg" size=55 style="color: #808080; border-style: none; border-width: medium" >
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
{setTimeout("count()",300);} 
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
					rs.open "select * from preDomain where d_id=" & OrderID,conn,1,1
					if not rs.eof then						
						Session("results")=putOrderlist("domain",OrderID,Rs("UserName"))
						response.Write("<script>location.href='RegCn.asp?module=Over&Domain="&Rs("strDomain")&"&DomainPwd="&Rs("strDomainpwd")&"&years="&Cstr(Rs("years"))&"&productname="&Rs("productName")&"&ppricetemp="&Rs("price")&"&producttype="&Rs("Proid")&"&OrderID="&OrderID&"'</script>")
					else
						Call errpage("无此订单")
					end if
				  %>
                  </td>
  </tr>
</table>
<%
elseif module="Over" then

if left(Session("results"),3)="200" then
		call doupfile(requesta("Domain"),"")
		PicPath="../images/ok101.gif"
		Mess="域名开通成功！"
	else
		PicPath="../images/err101.gif"
		Mess="域名开通失败！"
	end if
%>

<table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
  <tr>
    <td class="tdbg"><table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
        <td width="34%" align="right">&nbsp;</td>
        <td width="66%"><img src="<%=PicPath%>"></td>
      </tr>
      <tr>
        <td align="right">状态：</td>
        <td><%=Mess%></td>
      </tr>
      <tr>
        <td align="right">信息：</td>
        <td><%=showerrmsg(Session("results"))%></td>
      </tr>
      <tr>
        <td align="right">域名：</td>
        <td><%=requesta("Domain")%></td>
      </tr>
      <tr>
        <td align="right">管理密码：</td>
        <td><%=requesta("DomainPwd")%></td>
      </tr>
      <tr>
        <td align="right">产品型号：</td>
        <td><%=requesta("producttype")%></td>
      </tr>
      <tr>
        <td align="right">产品名称：</td>
        <td><%=requesta("productname")%></td>
      </tr>
      <tr>
        <td align="right">单价：</td>
        <td><%=requesta("ppricetemp")%></td>
      </tr>
      <tr>
        <td align="right">年限：</td>
        <td><%=requesta("years")%></td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><input type="button" name="button" id="button" value="　返回域名订单　" onClick="location.href='predomain.asp'"></td>
      </tr>
    </table></td>
  </tr>
</table>
<%end if%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
