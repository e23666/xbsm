<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<%
conn.open constr
sid=requesta("sid")
ACT=Requesta("ACT")

sql="select * from databaselist where dbsysid="&sid
rs.open sql,conn,1,3
if rs.eof then
	url_return "���ݿⲻ����",-1
end if

if ACT="Modi" then
	rs("dbname")=Requesta("dbname")
	rs("dbsize")=Requesta("dbsize")
	rs("dbpasswd")=Requesta("dbpasswd")
	rs("dbbuydate")=Requesta("dbbuydate")
	rs("dbexpdate")=Requesta("dbexpdate")
	rs("dbproid")=Requesta("dbproid")
	rs("dbyear")=Requesta("dbyear")
	rs("dbstatus")=Requesta("dbstatus")
	rs("dbserverip")=Requesta("dbserverip")
	rs.update
	Response.write "<script language=javascript>alert('�޸ĳɹ�');</script>"
end if

if ACT="DEL" and isNumeric(sid) then
	conn.execute("delete from databaselist where dbsysid=" & sid)
	Alert_Redirect "ɾ���ɹ�","default.asp"
end if

if ACT="FlUSHPASS" then
	if left(GetOperationPassWord(rs("dbname"),"database",GetUserName(rs("dbu_id"))),3)="200" then
		Response.Write("<script>alert(""���ݿ�������³ɹ���"")</script>")
	else
		Response.Write("<script>alert(""���ݿ��������ʧ�ܣ�"")</script>")
	end if
end if


%>
<style type="text/css">
<!--
.STYLE4 {color: #FF0000}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�� �� SQL �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">SQL���ݿ����</a> | <a href="adddatabase.asp">�ֹ����SQL���ݿ�</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
  <form name="form1" method="post" action="m_default.asp?sid=<%=sid%>">
    <tr>
      <td colspan="2"  class="tdbg">&nbsp;</td>
    </tr>
	<tr>
      <td align="right"  class="tdbg">�������ݿ⣺</td>
    <td class="tdbg"><a href="http://www.myhostadmin.net/database/checklogin.asp?dbuserid=<%=rs("dbname")%>&dbpasswd=<%=rs("dbpasswd")%>" target="_blank"><span class="STYLE4">�������SQL���ݿ���ϸ����</span></a></td>
    </tr>
	<tr>
	  <td align="right"  class="tdbg">ɾ�����ݿ⣺</td>
      <td class="tdbg"><table border="0" cellspacing="0" cellpadding="3">
        <tr>
          <td nowrap><a href="javascript:if (confirm('ȷ��ɾ��?')){location.href='m_default.asp?ACT=DEL&sid=<%=sid%>'}"><span class="STYLE4">ɾ�������ݿ�</span></a></td>
          </tr>
      </table></td>
	</tr>
	<tr>
	  <td align="right"  class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
	</tr>
    <tr>
      <td align="right"  class="tdbg">���ݿ��û�����</td>
    <td class="tdbg"><input name="dbname" type="text" class="textfield" id="dbname" value="<%=rs("dbname")%>">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ��С��</td>
    <td  class="tdbg"><input name="dbsize" type="text" class="textfield" id="dbsize" value="<%=rs("dbsize")%>">
      MB      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">
        ���ݿ����룺</td>
    <td class="tdbg"><table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td nowrap><input name="dbpasswd" type="text" class="textfield" id="dbpasswd" value="<%=rs("dbpasswd")%>"></td>
          <td width="60" align="center"><a href="m_default.asp?ACT=FlUSHPASS&SqldbName=<%=rs("dbname")%>&User=<%=GetUserName(rs("dbu_id"))%>&sid=<%=sid%>"><img src="/images/pic_03.gif" alt="��������" border="0"></a></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">��ͨ���ڣ�</td>
    <td class="tdbg"><input name="dbbuydate" type="text" class="textfield" id="dbbuydate" value="<%=rs("dbbuydate")%>"></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">�������ڣ�<br>      </td>
    <td class="tdbg"> <input name="dbexpdate" type="text" class="textfield" id="dbexpdate" value="<%=rs("dbexpdate")%>">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ��ͺţ�</td>
    <td class="tdbg"><select name="dbproid" class="textfield" id="dbproid">
            <%
sql="SELECT * FROM productlist WHERE p_name like '%mssql%'"
rs1.open sql,conn,1,1
Do While Not rs1.eof
%>
            <option value="<%=rs1("p_proid")%>"<%if rs("dbproid")=rs1("p_proid") then%> selected<%end if%>><%=rs1("p_name")%></option>
            <%
rs1.movenext
Loop 
rs1.close
%>
          </select>      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">�������ޣ�</td>
    <td class="tdbg"><select name="dbyear" class="textfield" id="dbyear">
        <%
		for i=1 to 10
		%>
        <option value="<%=i%>"<%if rs("dbyear")=i then%> selected<%end if%>><%=i%></option>
        <%
		next
		%>
      </select></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ�״̬��</td>
    <td class="tdbg"><select name="dbstatus" class="textfield" id="dbstatus">
        <option value="0"<%if rs("dbstatus")="0" then%> selected<%end if%>>����</option>
        <option value="-1"<%if rs("dbstatus")="-1" then%> selected<%end if%>>ֹͣ</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">������ip��</td>
    <td class="tdbg"><input name="dbserverip" type="text" class="textfield" id="dbserverip" value="<%=rs("dbserverip")%>">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg"><input name="Submit" type="submit" class="textfield" id="Submit" value="��ȷ���޸����ݿ⡡">
      <input name="ACT" type="hidden" id="ACT" value="Modi" /></td>
    </tr>
    <tr>
      <td colspan="2" class="tdbg"><br>
        <strong>��ʾ��</strong><br>
        <span class="STYLE4">�޸����ݿ��¼�����ڱ����ݿ����޸ġ�</span><br>
      <br></td>
    </tr>
  </form>
</table>
<%
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
