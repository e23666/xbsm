<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Interface_bizcn.asp" -->
<!--#include virtual="/config/Interface_dnscn.asp" -->
<!--#include virtual="/config/Interface_netcn.asp" -->
<!--#include virtual="/config/Interface_xinet.asp" -->
<%Check_Is_Master(1)%>
<%
die "ֻ��ʹ��Ĭ�Ͻӿ�"
function isGrant(dmreg)
	select case dmreg
		case "dnscn"
			isGrant=GRANTCODE_DNSCN
		case "bizcn"
			isGrant=GRANTCODE_BIZCN
		case "netcn"
			isGrant=GRANTCODE_NETCN
		case "xinet"
			isGrant=GRANTCODE_XINET
		case else
			isGrant=true
	end select
end function

function GetAList()
	QS="select p_name,P_proId from productlist where p_type=3"
	Set localRs=CreateObject("Adodb.RecordSet")
	LocalRs.open QS,conn,1,1
	do while not LocalRs.eof
		GetAList=GetAList & vbcrlf 
		GetAList=GetAList & "<option value=""" & LocalRs("p_proid") & """>" & LocalRs("p_name") & "(" & LocalRs("P_proid") & ")" &  "</option>"
		LocalRs.moveNext
	Loop
	LocalRs.close
	Set LocalRs=nothing
end function

function GetPName(xxx)
	QS="select p_name from productlist where P_proId='" & xxx & "'"
	Set localRs=CreateObject("Adodb.RecordSet")
	LocalRs.open QS,conn,1,1
	if not LocalRs.eof then
		GetPName=LocalRs("p_name")
	else
		GetPName="δ֪"
	end if
	LocalRs.close
	Set LocalRs=nothing
end function

conn.open constr
MainSQL="select * from RegisterMap"
Act=Requesta("Act")

select case Act
	case "NEW"
		D_T=Requesta("D_T")
		R_V=Requesta("R_V")
		if D_T="" or R_V="" then url_return "�뽫��Ϣ��д����!",-1
		if not isGrant(R_V) then
			Response.write "<script language=javascript>alert('����,�ýӿ�" & R_V & "��δ����Ȩ����鿴ҳ����ʾ����������������ϵ��������ͷ�');history.back();</script>"
			Response.End()
		end if
		rs.open "select id from registerMap where domaintype='" & D_T &"'",conn,1,1
		if not rs.eof then
			rs.close
			Response.write  "<script language=javascript>alert('��Ǹ��������" & D_T & "�Ѿ�����');history.back();</script>"
			Response.end
		end if
		rs.close
		conn.execute("insert into RegisterMap(domaintype,register) values ('" & D_T & "','" & R_V & "')")
	case "UPDATE"
		for each formVar in Request.Form
			if left(formVar,3)="OP_" then
				opid=Cint(mid(formVar,4))
				opval=Request(formVar)
				if not isGrant(opval) then
					Response.write "<script language=javascript>alert('����,�ýӿ�" & opval & "��δ����Ȩ������ϵ��������ͷ�');history.back();</script>"
				else
					conn.execute("update RegisterMap set register='" & opval & "' where id=" & opid )
				end if
			end if
		next
	case "DEL"
			ACTID=Requesta("ACTID")
			if not isNumeric(ACTID) then Response.write  "����ID��ʧ":Response.End()
			conn.Execute("delete from RegisterMap where id=" & ACTID)
end select

rs.open MainSQL,conn,1,1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�� �� �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>�ر�������</strong></td>
    <td width="771">�˹�����Ҫ������Ȩ������֧���������Ա��ϵ�������ڴ�֮ǰ��Ӧ�����ú���ط����̵��û��������롣�������ú�����ע�Ṧ�ܽ��޷�ʹ�á��������ã�����������Ĭ��ʹ����������ӿ�ע�ᡣ</td>
  </tr>
</table>

<br>
<table width="100%" border="0" align="center" cellpadding="4" cellspacing="1" class="border" borderdark="#ffffff">
<form name="form1" method="post" action="">    
    <tr align="center"> 
      <td align="center" class="Title"><strong>�������</strong></td>
      <td class="Title"><strong>��Ʒ���</strong></td>
      <td class="Title"><strong>ע����</strong></td>
      <td class="Title"><strong>����</strong></td>
    </tr>
<%do while not rs.eof%>
    <tr> 
      <td align="center" class="tdbg"><%=GetPName(rs("domaintype"))%></td>
      <td align="center" class="tdbg"><%=rs("domaintype")%></td>
      <td align="center" class="tdbg"> 
        <input type="text" name="OP_<%=rs("id")%>" value="<%=rs("register")%>">      </td>
      <td class="tdbg"> 
        <input type="button" name="Submit" value="ɾ��" onClick="if (confirm('ȷ��ɾ��<%=rs("domaintype")%>?')){this.form.ACT.value='DEL';this.form.ACTID.value=<%=rs("id")%>;this.form.submit();}">      </td>
    </tr>
<%
rs.moveNext
loop%>
    <tr> 
      <td colspan="2" class="tdbg"> 
       <input type="hidden" name="ACT">
      <input type="hidden" name="ACTID">
        <select name="D_T">
			<%=GetAList()%>
        </select>      </td>
      <td align="center" class="tdbg"> 
        <select name="R_V">
          <option value="default">��������(Ĭ��)</option>
          <option value="bizcn">�����й�</option>
          <option value="xinet">�� ��</option>
          <option value="dnscn">��������</option>
          <option value="netcn">�� ��</option>
        </select>
        <input type="button" name="Submit3" value="���" onClick="this.form.ACT.value='NEW';this.form.submit();">      </td>
      <td class="tdbg"> 
        <input type="button" name="Submit2" value="����" onClick="this.form.ACT.value='UPDATE';this.form.submit();">      </td>
    </tr>
    <tr>
      <td colspan="4" class="tdbg">
        <p><br>
          ˵��:��ע���̵���д��default(��������) bizcn(�����й�),dnscn(��������),xinet(����),netcn(����)<br>
          ��ϵͳ֧������5������ע��ӿڣ�Ĭ��ֻ��ѿ�ͨ����������ӿڡ�<br>
          ��ʹ�������ӿ����ȵ���������  <a href="http://www.west263.com/reg" target="_blank">www.west263.com/reg</a> ע��Ϊ��Ա���踶��200Ԫ����ͨ�ӿڡ� ��֪ͨ����2012��8��15�տ�ʼ��ֹͣ���������ӿڣ�</p>
      <p>        ��ʹ�������й��Ľӿڣ���Ҫ�ڷ����������������й���jdk+�м���������mysocket.dll����ʹ�����������Ľӿڣ���Ҫ�ڷ�������ע������������DLL�ļ�������������Ľӿڣ�����Ҫ������ע���̴�����IP��Ȩ��      </p></td>
    </tr>
    </form>
  </table>
</body>
</html>
