<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(1)%>
<%
conn.open constr
UP=Trim(Requesta("UP"))
mailID=Trim(Requesta("mailID"))
myact=trim(requestf("myact"))
TargetT=Trim(Requesta("TargetT"))

OneYear=True
if not isNumeric(mailID) then url_return "ȱ���ʾ�ID",-1
Sql="Select * from mailsitelist where m_sysid=" & mailID
Rs.open Sql,conn,1,1
if Rs.eof then url_return "δ�ҵ����ʾ�",-1
mailserverip=Rs("m_serverip")
maildomain=Rs("m_bindname")

localRs_SQL="select u_name,u_usemoney,u_premoney,u_level from userdetail where u_id=" & rs("m_ownerid")
Set localRs=conn.Execute(localRs_sql)
if localRs.eof then
	url_return "����,��Ӧ�û�������",-1
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
if TestRs.eof then url_return "δ�ҵ��������͵��ʾ֣�����ϵ����Ա",-1
price=TestRs("p_price")
Dprice=0
TestRs.close
if TargetT<>"" then
  Sql="Select p_price from pricelist where p_u_level=" & u_level & " and p_proid='" & TargetT & "'"
  TestRs.open Sql
  if not TestRs.eof then Dprice=TestRs("p_price")
  TestRs.close
end if
m_buyDate=Rs("m_buyDate")
m_year=Rs("m_years")
s_year=m_year
if m_year>1 then OneYear=False
UsedDays=DateDiff("d",m_buyDate,Now)
LeftDays=DateDiff("d",Now,DateAdd("yyyy",m_year,m_buyDate))
TotalDays=UsedDays+LeftDays

if OneYear then
 NeedPrice=Cint(Dprice-price*(1-UsedDays/365))
else
 NeedPrice=Cint((Dprice/365)*LeftDays-(Price*s_year)*(1-UsedDays/TotalDays))
end if

'Sql="Select p_proId,p_name,p_size from productlist where p_type=2 and charindex('hmail',p_proid)=0 order by p_proid"
Sql="Select p_proId,p_name,p_size from productlist where p_type=2 order by p_proid"
Set PRs=conn.Execute(Sql)
%>

<script language="javascript" src="/manager/inter_menu.js"></script>
<script language="javascript" src="/manager/menu1.js"></script>
<script language="javascript">

function check(form){
var userMoney=<%=u_usemoney+u_premoney%>;
var NeedMoney=<%=NeedPrice%>;
CM=NeedMoney-userMoney;
if(confirm("��ȷ��Ҫ����ҵ�ʾ�(<%=Rs("m_bindname")%>,ԭ����:<%=Rs("m_productID")%>)������������<%=TargetT%>��������Ϊ:<%=NeedPrice%>"))
  if (userMoney<NeedMoney) {
     alert("��Ǹ���˴���������"+NeedMoney+".00Ԫ���������ʻ���ʣ"+userMoney+"Ԫ���뽫���"+CM+"�㵽��˾����ִ�д˲���!");
	 return false;;
	}
  else 
   { 
	form.UP.value="YES";
	form.submit();
	return true;}
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
    <td height='30' align="center" ><strong> ��ҵ�ʾֹ���</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">��ҵ�ʾֹ���</a> | <a href="MailAdd.asp">�ֹ������ҵ�ʾ�</a> 
      | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
<%
if UP<>"" and TargetT<>"" then
	returnStr=putUP("mail",maildomain,TargetT,"OldupdateType",u_name)
	if left(returnStr,3)="200" then
		response.Write("<script>alert(""�ʾ������ɹ���"")</script>")
	else
		response.Write("�ʾ�����ʧ�ܣ�"&returnStr)
	end if
end if
%> 
<table width="100%" height="42" border="0" cellpadding="0" cellspacing="0" class="border">
                    <tr> 
                      <td height="21" class="tdbg">
                        <form name="form1" method="post" action="<%=Request("SCRIPT_NAME")%>">
                          <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0">
                            <tr> 
                              <td width="30%" align="right">1. �� ��</td>
                              <td width="70%" class="e8"><%=Rs("m_bindname")%></td>
                            </tr>
                            <tr> 
                              <td align="right"><font color="#000000">2. 
                                �� ��</font></td>
                              <td> <%=Rs("m_years")%></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <p align="right">��ͨ���ڣ�</p>                              </td>
                              <td><%=formatDateTime(Rs("m_buydate"),2)%></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <p align="right">�������ڣ�</p>                              </td>
                              <td><%=formatDateTime(DateAdd("yyyy",Rs("m_years"),Rs("m_buydate")),2)%></td>
                            </tr>
                            <tr> 
                              <td colspan="2"> 
                                <p align="left">&nbsp;</p>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> ��ҵ�ʾ�ԭ���ͣ�</td>
                              <td><%=Rs("m_ProductId")%>                              </td>
                            </tr>
                            <tr> 
                              <td align="right">��ҵ�ʾ������ͣ�</td>
                              <td> 
                                <select name="TargetT" size="1" class="input" onChange="if(this.value!='') this.form.submit();">
                                  <option value="">�ʾ�����</option>
                                  <% do while not PRs.eof%> 
                                  <option value="<%=PRs("p_proid")%>" <%if TargetT=PRs("p_proid") then Response.write " selected"%>><%=PRs("p_proid") & "-" & PRs("p_name") & "(" & PRs("p_size")  & "M)"%></option>
                                  <%
	PRS.MoveNext
	Loop
	PRs.close
	Set PRS=nothing
%> 
                                </select>                              </td>
                            </tr>
                            <tr> 
                              <td align="right">�����ۣ�</td>
                              <td>���ڵļ۸�[<font color="#FF0000"> 
                                <%if DPrice>0 then 
  Response.write DPrice
else
  Response.write "--"
end if%>
                                </font>]-ԭ�۸�[<font color="#FF0000"><%=price%></font>]��(1-ʹ������[<font color="#FF0000"><%=UsedDays%></font>]��365)=<font color="#FF0000"> 
                                <%if NeedPrice>0 then
  Response.write NeedPrice
else
  Response.write "0"
end if%>
                                </font>Ԫ</td>
                            </tr>
                            <tr> 
                              <td align="right">ע��</td>
                              <td> 1. 
                                <br>
                                2.�������ò���50Ԫ�ģ���50Ԫ���㡣 <br>
                                3.����ʾ������󽫳�Ϊ�շ��ʾ֣���ԭ����Ӧ�������������ѵ�ʱ�򲻻��Զ�Ϊ���ʾ����ѣ��շ��ʾ���Ҫ�������ѣ�</td>
                            </tr>
                            <tr align="center"> 
                              <td colspan="2"> 
                                <p> 
                                  <input name="C1" type="button" class="buttom" style="font-family:����;font-size:9pt" value=" ȷ �� �� ��" onClick="check(this.form);">
                                </p>
                                <p> 
                             <input type="hidden" name="mailID" value="<%=mailID%>">
                                  <input type="hidden" name="UP">
                                </p>                              </td>
                            </tr>
                          </table>
                        </form>
                        <%
Rs.close
%> </td>
                    </tr>
                    <tr> 
                      <td width="100%" height="21"></td>
                    </tr>
                  </table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
</body>
