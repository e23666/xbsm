<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(6)%>
<%

conn.open constr

dataID=Trim(Requesta("dataID"))
if not isNumeric(dataID) then url_return "ȱ�����ݿ�ID",-1
Sql="select * from databaselist where dbsysid="&dataID&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "δ�ҵ������ݿ�",-1
dbname=Rs("dbname")
db_productids=rs("dbproid")
db_ownerid=rs("dbu_id")

CustomerName=GetUserName(db_ownerid)

localRs_SQL="select u_name,u_usemoney,u_premoney,u_level from userdetail where u_id=" & db_ownerid
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


CustomerName=GetUserName(rs("dbu_id"))
price=GetNeedPrice(CustomerName,db_productids,rs("dbyear"),"renew")
StartRenew=requesta("StartRenew")

if StartRenew="OKay" then
	RenewYear=Requesta("RenewYear")
	D1=RenewYear
	
	returnStr=putRenew("mssql",dbname,RenewYear,CustomerName)
	if left(returnStr,3)="200" then
		response.Write("<script>alert(""���ݿ������Ѿ��ɹ���"")</script>")
	else
		response.Write("<script>alert(""���ݿ������Ѿ�ʧ�ܣ�"&returnStr&""")</script>")
	end if
end if

%>

<script language="javascript">

function check(form){
if(confirm("��ҪΪ<%=dbname%> ����" + form.RenewYear.value + "��\n����" + form.B1.value + "Ԫ\n\nȷ������ѡ����"))
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
    <td height='30' align="center" ><strong>SQL �� �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">SQL���ݿ����</a> | <a href="adddatabase.asp">�ֹ����SQL���ݿ�</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
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
                              <td align="right">���ݿ⣺</td>
                              <td class="e8"><%=rs("dbname")%></td>
                            </tr>
                            <tr>
                              <td align="right"><font color="#000000"> �� �ޣ�</font></td>
                              <td><%=Rs("dbyear")%></td>
                            </tr>
                            <tr>
                              <td align="right"><p align="right">��ͨ���ڣ�</p></td>
                              <td><%=formatDateTime(Rs("dbbuydate"),2)%></td>
                            </tr>
                            <tr>
                              <td align="right"><p align="right">�������ڣ�</p></td>
                              <td><%=formatDateTime(DateAdd("yyyy",Rs("dbyear"),Rs("dbexpdate")),2)%></td>
                            </tr>
                            <tr>
                              <td colspan="2">&nbsp;</td>
                            </tr>
                              <tbody>
                              <tr> 
                                <td width="36%" height="26" align="right"> ѡ�񽻷���ͷ��</td>
                              <td width="64%" height="26"><select name="RenewYear" size="1" class="input" onChange="GetRenewDomainPrice()">
                                    <option value="0" selected>��ѡ�񽻷���ͷ</option>
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
                                ���ѽ�</td>
                              <td>&nbsp; <span id="MySize"><iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=db_productids%>&years=0&user_name=<%=u_name%>></iframe></span><script language="JavaScript">
							function GetRenewDomainPrice()
							{
								years=form1.RenewYear.value;
								MySize.innerHTML="<iframe height=15 frameborder=0  name=ad marginwidth=0 width=130 scrolling=no src=/config/GetRenewPrice.asp?ProId=<%=db_productids%>&years="+years+"&user_name=<%=u_name%>>�Բ�������������֧�ֿ�ܻ����Ǳ�����Ϊ����ʾ��ܡ�</iframe>"
							}
							</script></td>
                            </tr>
                              <tr> 
                                <td height="1" align="center">
                                <td height="1"><input name="C1" type="submit" class="solidinput"  value="���������������ѡ�" />
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
            <strong>��ʾ��</strong>�����&quot;��������&quot;�󣬲���ˢ�¸�ҳ�森����ʱ��û����Ӧ���������������ĺ�ʵ�����Ƿ�ɹ��������½����ҳ�森<br />
            <br /></td>
        </tr>
        </form>
</table>
      <%rs.close%>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
