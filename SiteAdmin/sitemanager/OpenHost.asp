<%
Response.buffer=false
server.ScriptTimeout=99999
%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(6)%>
<%
conn.open constr
module=Trim(Requesta("module"))
OrderID=Trim(Requesta("OrderNo"))
if OrderID="" then URL_return "ȱ�ٶ�����",-1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>������ͨ</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
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
                      ϵͳ����Ϊ���ķ�����г�ʼ������<font size="2">��</font>�������̳���ʱ�����������ٶ���<font size="2">��</font>���׹�����<font size="2">��</font><span class="STYLE4">�벻Ҫ�ر������<font size="2">��</font>�벻Ҫˢ�±�ҳ<font size="2">��</font></span></td>
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
                  
    </td>
  </tr>
</table>
<%
					Sql="Select * from PreHost Where OrderNo='" & OrderID  & "'"
					Rs.open Sql,conn,1,1
					if Rs.eof then URL_return "δ�ҵ��˶���",-1
						
						PerOrderID=OrderID
					
					Session("results")=putOrderlist("vhost",OrderID,Rs("u_name"))
					if left(Session("results"),3)="200" then
						Sql="Update PreHost Set opened=1 where orderNo='" & PerOrderID & "'"
						conn.Execute(Sql)
					end if
					response.Write("<script>location.href='OpenHost.asp?module=Over&FtpName="&Rs("ftpaccount")&"&FtpPwd="&Rs("ftppassword")&"&years="&Cstr(Rs("years"))&"&productname="&productName&"&ppricetemp="&Rs("price")&"&producttype="&Rs("proid")&"&OrderNo="&PerOrderID&"'</script>")

elseif module="Over" then

if left(Session("results"),3)="200" then

		IPAddress=getstrReturn(Session("results"),"ip")
		freedomain=getstrReturn(Session("results"),"freedomain")
	
	PicPath="../images/ok101.gif"
	Mess="������ͨ�ɹ���"
else
	PicPath="../images/err101.gif"
	Mess="������ͨʧ�ܣ�"
end if
%>
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<tr>
        <td width="34%" align="right" class="tdbg">&nbsp;</td>
        <td width="66%" class="tdbg"><img src="<%=PicPath%>"></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">״̬��</td>
        <td class="tdbg"><%=Mess%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">��Ϣ��</td>
        <td class="tdbg"><%=Session("results")%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">IP��ַ��</td>
        <td class="tdbg"><%=IPAddress%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">���������</td>
        <td class="tdbg"><%=freedomain%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">�������룺</td>
        <td class="tdbg"><%=requesta("FtpPwd")%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">��Ʒ�ͺţ�</td>
        <td class="tdbg"><%=requesta("producttype")%></td>
      </tr>
      <tr>
        <td align="right" class="tdbg">���ۣ�</td>
        <td class="tdbg"><%=requesta("ppricetemp")%>Ԫ</td>
      </tr>
      <tr>
        <td align="right" class="tdbg">���ޣ�</td>
        <td class="tdbg"><%=requesta("years")%>��</td>
      </tr>
      <tr>
        <td align="right" class="tdbg">&nbsp;</td>
        <td class="tdbg"><input type="button" name="button" id="button" value="����������������" onClick="location.href='PreHost.asp'"></td>
      </tr>
</table>
<%
end if
%>
</body>
</html>
