<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
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
    <td height='30' align="center" ><strong>�� �� SQL �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">SQL���ݿ����</a> | <a href="adddatabase.asp">�ֹ����SQL���ݿ�</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
<!--Body Start-->

<%
conn.open constr
module=requesta("module")
If module="add" Then
user_name=trim(request.form("user_name"))
rs.open "select u_id from UserDetail where u_name='"& user_name &"'" ,conn,3

If Not ( rs.bof and rs.eof ) Then 
   dbf_id=rs("u_id")
   dbu_id=rs("u_id")
   rs.close
else
   rs.close
   url_return  "���û��������ڣ�",-1
end	if

rs.open "select * from databaselist where  dbname='"&dbname&"'" ,conn,3
If not(rs.bof and rs.eof)  Then 
   rs.close
   url_return  "�����ݿ����Ѿ����ڣ�",-1
else
   rs.close
End if

dbbuydate=Requesta("dbbuydate")
dbexpdate=Requesta("dbexpdate")
if not isdate(dbbuydate) then
	url_return  "���ڸ�ʽ����",-1
end if
if not isdate(dbexpdate) then
	url_return  "���ڸ�ʽ����",-1
end if
dbexpdate=dateadd("yyyy",Requesta("dbyear"),dbbuydate)
	   sql="select top 1 * from databaselist"
	   rs.open sql,conn,3,3
	   rs.addnew
		rs("dbname")=Requesta("dbname")
		rs("dbloguser")=Requesta("dbloguser")
		rs("dbsize")=Requesta("dbsize")
		rs("dbpasswd")=Requesta("dbpasswd")
		rs("dbbuydate")=dbbuydate
		rs("dbexpdate")=dbexpdate
		rs("dbproid")=Requesta("dbproid")
		rs("dbtype")=Requesta("dbtype")
		rs("dbyear")=Requesta("dbyear")
		rs("dbstatus")=Requesta("dbstatus")
		rs("dbf_id")=dbf_id
		rs("dbu_id")=dbu_id
		rs("dbserverip")=Requesta("dbserverip")
		rs.update
	    rs.close
		alert_redirect "�����ɹ�","default.asp"
End if
%>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="border">
  <form name="form1" method="post" action="adddatabase.asp">
    <tr>
      <td colspan="2"  class="tdbg">&nbsp;</td>
    </tr>
	<tr>
      <td align="right"  class="tdbg">�����û�����</td>
    <td class="tdbg">&nbsp;
      <input name="user_name" type="text" class="textfield" id="user_name" >
      <input name="module" type="hidden" id="module" value="add"></td>
    </tr>
    <tr>
      <td align="right"  class="tdbg">���ݿ��û�����</td>
    <td class="tdbg">&nbsp;
      <input name="dbname" type="text" class="textfield" id="dbname">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">��½����</td>
    <td class="tdbg">&nbsp;
      <input name="dbloguser" type="text" class="textfield" id="dbloguser">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ��С��</td>
    <td  class="tdbg">&nbsp;
      <input name="dbsize" type="text" class="textfield" id="dbsize" value="50">
      MB      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">
        ���ݿ����룺</td>
    <td class="tdbg">&nbsp;
      <input name="dbpasswd" type="text" class="textfield" id="dbpasswd">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">��ͨ���ڣ�</td>
    <td class="tdbg">&nbsp;
      <input name="dbbuydate" type="text" class="textfield" id="dbbuydate" value="<%=now()%>"></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">�������ڣ�<br>      </td>
    <td class="tdbg"> &nbsp;
      <input name="dbexpdate" type="text" class="textfield" id="dbexpdate" value="<%=now()%>">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ��ͺţ�</td>
    <td class="tdbg">&nbsp;
      <select name="dbproid" class="textfield" id="dbproid">
            <%
sql="SELECT * FROM productlist WHERE p_name like '%mssql%'"
rs1.open sql,conn,1,1
Do While Not rs1.eof
%>
            <option value="<%=rs1("p_proid")%>"><%=rs1("p_name")%></option>
            <%
rs1.movenext
Loop 
rs1.close
conn.close
%>
          </select>      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">�������ޣ�</td>
    <td class="tdbg">&nbsp;
      <select name="dbyear" class="textfield" id="dbyear">
        <%
		for i=1 to 10
		%>
        <option value="<%=i%>"><%=i%></option>
        <%
		next
		%>
      </select></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">���ݿ�״̬��</td>
    <td class="tdbg">&nbsp;
      <select name="dbstatus" class="textfield" id="dbstatus">
        <option value="0" selected>����</option>
        <option value="-1">ֹͣ</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">������ip��</td>
    <td class="tdbg">&nbsp;
      <input name="dbserverip" type="text" class="textfield" id="dbserverip" value="61.139.126.36">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;
      <input name="Submit" type="submit" class="textfield" id="Submit" value="��ȷ���������ݿ⡡"></td>
    </tr>
    <tr>
      <td colspan="2" class="tdbg"><br>
        <strong>��ʾ��</strong><br>
        <span class="STYLE4">�������ݿ��¼�����ڱ����ݿ�������һ����¼��</span><br>
      <br></td>
    </tr>
  </form>
</table>
</BODY>
</HTML>
  

<!--#include virtual="/config/bottom_superadmin.asp" -->
