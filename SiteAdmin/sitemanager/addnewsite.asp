<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
module=Requesta("module") '

If module="vhostadd" Then
 
	vusername=Requesta("vusername")
	Sql="Select u_id from userdetail where u_name='" & vusername & "'"
	conn.open constr
	Rs.open Sql,conn,1,1
	if Rs.eof then
		url_return "�޴��û�",-1
	end if
	u_id=Rs("u_id")
	Rs.close

	producttype=Requesta("producttype") 'HK100
	domain=Requesta("domain")
	defaultdoc="index.asp,index.php,default.asp,default.htm,index.htm,index.html"
	ftpaccount=Requesta("ftpaccount")
	ftppassword=Requesta("ftppassword")
	expiredate=Requesta("expiredate")
	servername=Requesta("servername")
	startdate=Requesta("startdate")
	paytype=Requesta("paytype")
	vyear=Requesta("vyear")
	vstatus=Requesta("status")
	bizbid=1
	myvar=Requesta("myVar")
	
	if ftpaccount="" then url_return "��ɶ��FTP�ʺ�û����",-1
	if ftppassword="" then url_return "��ȷ�Ų�Ҫ����Ҳ�ܵ�¼�ռ䣿�Ҳ���ô��Ϊ",-1
	if not isNumeric(vyear) then url_return "��!�ˣ������������ô��ģ��������ôŪ��",-1
	if not isDate(startdate) then url_return "����ѧ�ģ�����ģ��ϸ�ģ��Ͻ��ģ���ϸ�ĶԿ�ͨ���ڵĸ�ʽ������֤���������ĸ�ʽ�ǲ��Եģ���ȥ����",-1

	Sql="Select p_size from productlist where p_proid='" & producttype & "'"
	p_size=200
	Rs.open Sql,conn,1,1
	if not Rs.eof then p_size=Rs("p_size")
	Rs.close

	Sql="insert into vhhostlist (s_comment,s_bindings,s_Defaultdoc,s_defaultbindings,s_ftppassword,s_serverIP,s_ProductId,s_year,s_buydate,s_expiredate,s_updatedate,s_SiteState,s_buytest,S_ownerid, s_appid, s_serverName,s_size,s_payok) values('" & ftpaccount & "','" & domain & "','" & defaultdoc & "','','" & ftppassword &"','" & servername & "','" & producttype & "'," & vyear & ",'" & startdate &"','" & DateAdd("yyyy",vyear,startDate) &"','GetDate()'," & vstatus & ",0," & u_id &",111,'" & myVar & "'," & p_size & ",1)"
	conn.Execute(Sql)	
	alert_redirect "�ۣ����ǿ������ӳɹ��ˣ�Ŷ�����˸����㣬���������ǿ��Բ����^_^,���У��Լ�ȥ�ۿ","javascript:history.back()"
	response.end
End If 
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
    <td height='30' align="center" ><strong> �ֹ������������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">������������</a> | <a href="addnewsite.asp">�ֹ������������</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
<table width="100%" border=0 cellpadding=2 cellspacing=0 bordercolordark="#FFFFFF" class="border">
<form name=form1 action="addnewsite.asp" method=post>
                       <input 
              type=hidden value=vhostadd name=module>
                        <tbody> 
                        <tr> 
                          <td align="right" class="tdbg">&nbsp;</td>
                          <td class="tdbg STYLE4">�������ݿ����������¼�������Զ����û��Ŀ</td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">�����û���</td>
                          <td class="tdbg"> 
                          <input name=vusername>                          </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">��ַ��http://</td>
                          <td class="tdbg"> 
                            <input name=domain>
                          (����ö���","�ֿ�) </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">FTP�ʺţ�</td>
                          <td class="tdbg"> 
                          <input name=ftpaccount>                          </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">FTP���룺</td>
                          <td class="tdbg"> 
                            <input name=ftppassword>
                          (����4λ) </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">��Ʒ���� </td>
                          <td class="tdbg"> 
                            <select name=producttype>
                              <% 
					conn.open constr
					rs.open "select * from productlist where p_type=1 and p_company=1",conn,3
					Do While Not rs.eof
						Response.Write "<OPTION  value="""& rs("p_proid") &""">" & rs("p_name") &  "</OPTION>"				
					rs.movenext
					Loop 
					rs.close
					conn.close
					%>
                          </select>                          </td>
                        </tr>
                        <tr>
                        <td height="30" align="right" class="tdbg">��ʼʱ�䣺</td>
                        <td height="30" colspan="2" class="tdbg"> 
                          <input name=startdate>
                          (yyyy-mm-dd) </td>
                        </tr>
<tr> 
                          <td align="right" class="tdbg">����ʱ�䣺</td>
                          <td class="tdbg"> 
                            <input name=expiredate>
                          (yyyy-mm-dd) </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">���ޣ�</td>
                          <td class="tdbg"> 
                          <input name=vyear>                          </td>
                        </tr>
                        <tr> 
                          <td align="right" class="tdbg">������̨��������</td>
                          <td class="tdbg"> 
                          <input name=servername>                          </td>
    </tr>
                        <tr> 
                          <td align="right" class="tdbg">����������</td>
                          <td class="tdbg"> 
                            <input name=myVar>
        (��W101.myhostadmin.net) </td>
                        </tr>
                        <tr>
                        <td height="30" align="right" class="tdbg">����״̬��</td>
                        <td height="30" colspan="2" class="tdbg"> 
                          <input type=radio CHECKED value=0 
                  name=status>
                          ���� 
                          <input type=radio value=1 name=status>
                          ֹͣ</td>
                        </tr>
                        <tr align="center"> 
                          <td colspan="2" class="tdbg"> 
                          <input type=submit value=" ȷ �� �� �� �� �� " name=Submit>                          </td>
                        </tr>
                </form>
                      </table>
                      
                      
<div align="left"></div>


