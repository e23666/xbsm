<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
Check_Is_Master(6)

conn.open constr
sid=requesta("sid")
sql="select * from mailsitelist where m_sysid ="&sid
rs.open sql,conn,1,3
if rs.eof then
	url_return "������ҵ�ʾֲ�����" , -1
end if

ACT=requesta("ACT")
if ACT="FlUSHPASS" then
	stMailDomain=requesta("MailDomain")
	stUser=requesta("User")
	if left(GetOperationPassWord(stMailDomain,"mail",stUser),3)="200" then
		Response.Write("<script>alert(""�ʾ�������³ɹ���"")</script>")
	else
		Response.Write("<script>alert(""�ʾ��������ʧ�ܣ�"")</script>")
	end if
elseif ACT="DEL" then
	stMailDomain=requesta("MailDomain")
	sql="delete from mailsitelist where m_bindname='"&stMailDomain&"'"
	 call Add_Event_logs(session("user_name"),2,stMailDomain,"ɾ���ʾֲ���")
	conn.execute(sql)
	Alert_Redirect "����ɾ���ɹ���","default.asp"
end if

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
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<form name="form1" method="post" action="m_default.asp?sid=<%=sid%>">
    <tr> 
      <td width="29%" align="right" class="tdbg">&nbsp;</td>
      <td width="21%" class="tdbg">&nbsp;</td>
      <td width="15%" class="tdbg">&nbsp;</td>
      <td width="35%" class="tdbg">
<%
	if ACT="Modi" then
		BuyDate=requesta("BuyDate")
		if not isdate(BuyDate) then
			url_return "������ͨʱ���ʽ����",-1
		end if
		ExDate=requesta("ExDate")
		if not isdate(ExDate) then
			url_return "��������ʱ���ʽ����",-1
		end if
		BuyYears=requesta("BuyYears")
		P_type=requesta("P_type")
		s_memo=requesta("Remark")
		
		sql="update mailsitelist set m_buydate=#"&BuyDate&"#,m_expiredate=#"&ExDate&"#,m_years="&BuyYears&",m_productid='"&P_type&"',s_mark='"&s_memo&"' where m_sysid="&sid
		conn.execute(sql)
		response.Write("<font class='STYLE4'>�ʾ���Ϣ�Ѿ��޸ĳɹ���</font>")
	end if
%>      </td>
    </tr>
    <tr> 
      <td height="30" align="right" class="tdbg">�ʾ�������</td>
      <td height="30" class="tdbg"><%=rs("m_bindname")%></td>
      <td align="right" class="tdbg">��ͨʱ�䣺</td>
      <td class="tdbg">
        <input type="text" name="BuyDate" id="BuyDate" value="<%=rs("m_buydate")%>">      </td>
    </tr>
    <tr> 
      <td align="right" valign="top" class="tdbg">�ʾ����룺</td>
      <td class="tdbg"><table border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td nowrap><%=rs("m_password")%></td>
            <td><a href="m_default.asp?ACT=FlUSHPASS&MailDomain=<%=rs("m_bindname")%>&User=<%=GetUserName(rs("m_Ownerid"))%>&sid=<%=sid%>"><img src="/images/pic_03.gif" alt="��������" border="0"></a></td>
          </tr>
        </table></td>
      <td align="right" valign="top" class="tdbg">����ʱ�䣺</td>
      <td valign="top" class="tdbg"><input type="text" name="ExDate" id="ExDate" value="<%=rs("m_expiredate")%>">      </td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">���ޣ�</td>
      <td class="tdbg"><select name="BuyYears" id="BuyYears">
      <%for i=1 to 10%>
        <option value="<%=i%>"<%if rs("m_years")=i then%> selected<%end if%>><%=i%></option>
       <%next%>
      </select>      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg"><a href="//www.myhostadmin.net/mail/checkloginsign.asp?userid=<%=rs("m_bindname")%>&sign=<%=WestSignMd5(rs("m_bindname"),rs("m_password"))%>" target="_blank"><span class="STYLE4">���벢�ҹ�����ʾ�</span></a></td>
      <td align="right" class="tdbg">�ʾ��ͺţ�</td>
      <td class="tdbg"><select name="P_type" id="P_type" style="width:250px">
      <%
	  sql1="select * from productlist where p_type=2"
	  rs1.open sql1,conn,1,3
	  if not rs1.eof then
	  do while not rs1.eof
	  %>
        <option value="<%=rs1("p_proid")%>"<%if rs1("p_proid")=rs("m_productId") then%> selected<%end if%>><%=rs1("p_proid")%></option>
       <%
	   rs1.movenext
	   loop
	   end if
	   rs1.close
	   %>
      </select></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">��ʾ:��������ʾֹ�����ʾ�����������ͬ������<a href="m_default.asp?ACT=FlUSHPASS&MailDomain=<%=rs("m_bindname")%>&User=<%=GetUserName(rs("m_Ownerid"))%>&sid=<%=sid%>"><img src="/images/pic_03.gif" alt="��������" border="0"></a></td>
      <td align="right" class="tdbg">��ע��</td>
      <td class="tdbg"><textarea name="Remark" cols="42" rows="4" id="Remark"><%=rs("s_mark")%></textarea></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">
        <table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td nowrap><a href="m_default.asp?ACT=DEL&MailDomain=<%=rs("m_bindname")%>&sid=<%=sid%>"><span class="STYLE4">ɾ�����ʾ�</span></a></td>
            <td><a href="m_default.asp?ACT=DEL&MailDomain=<%=rs("m_bindname")%>&sid=<%=sid%>"><img src="/images/20070730192531213.gif" alt="��������" border="0"></a></td>
          </tr>
        </table>
      </td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button" id="button" value="�����޸����ݿ⡡">
        <input name="ACT" type="hidden" id="ACT" value="Modi"></td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
  </table>
<%
Function showstatus(svalues)
	Select Case svalues
	  Case 0   '����
		showstatus="<img src=/images/green1.gif width=17 height=17>"
	  Case -1'
		showstatus="<img src=/images/nodong.gif width=17 height=17>"
	  Case else
		showstatus="<img src=/images/nodong.gif width=17 height=17>"
	End Select
End Function
%> <!--#include virtual="/config/bottom_superadmin.asp" -->
