<!--#include virtual="/config/config.asp"--> 
<%Check_Is_Master(6)%>
<%
conn.open constr
%> <HTML> <HEAD> <script language=javascript>
function writeMemo(form,uid,defaultinfo,uname){
	oldinfo=prompt('�����뱸ע(���ܺ���\'��):',defaultinfo);
	if (oldinfo!=''&&oldinfo!=null){
		form.ACT.value='SAVE';
		form.u_id.value=uid;
		form.info.value=oldinfo;
		form.u_name.value=uname;
		form.pageno.value=
		form.submit();
	}
	return;
}
</script>
<style type="text/css">
<!--
.STYLE4 {
	color: #0000FF;
	font-weight: bold;
}
-->
</style>
<FORM NAME="form1" METHOD="post" ACTION="<%=Request("Script_name")%>">
 <%
ActionUser=requesta("ActionUser")
S_Date=requesta("S_Date")
E_Data=requesta("E_Data")
ActionType=requesta("ActionType")

sql="select top 200 * from ActionLog where LogType<>'API'"
if ActionUser<>"" then
	sql=sql&" and ActionUser='"&ActionUser&"'"
end if
if isDate(S_Date) then
	sql=sql&" and AddTime>'"&S_Date-1&"'"
end if
if isDate(E_Data) then
	sql=sql&" and AddTime>'"&E_Date+1&"'"
end if
if ActionType<>"" then
	sql=sql&" and LogType='"&ActionType&"'"
end if
sql=sql&" order by id desc"
rs.open sql,conn,1,1
Dim PageNo
PageNo=Request.QueryString("PageNo")
rs.PageSize=20 'ÿҳ��¼��
rs.CacheSize=rs.PageSize '��¼����
If IsBlank(PageNo) or not IsNumeric(PageNo) then PageNo=1 '���PageNoΪ��,��PageNo����1
PageNo=CLng(PageNo)
If PageNo<1 then PageNo=1 '���PageNoС��1,��PageNo����1
If PageNo>rs.PageCount then PageNo=rs.PageCount '���PageNo��С��ҳ��,��PageNo������ҳ��
Dim i,n
i=(PageNo-1)*rs.PageSize '���
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��־�鿴</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="ViewAPILog.asp"><span class="STYLE4">API������־�鿴</span></a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
    <tr>
      <td align="center" class="tdbg"><table border="0" cellspacing="0" cellpadding="4">
        <tr>
          <td>�����ˣ�
            <input name="ActionUser" type="text" id="ActionUser" size="15"></td>
          <td nowrap>ʱ�䣺
            <input name="S_Date" type="text" id="S_Date" size="15">
            -
            <input name="E_Data" type="text" id="E_Data" size="15"></td>
          <td>���ͣ�</td>
          <td><select name="ActionType" id="ActionType">
              <option value="host" selected>����</option>
              <option value="domain">����</option>
              <option value="mail">�ʼ�</option>
              <option value="other">����</option>
          </select></td>
          <td><input type="submit" name="Submit" value=" �� �� "></td>
        </tr>
      </table></td>
    </tr>
</table>
  <br>
  <table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
    <tr bgcolor="#FFFFFF"> 
      <td width="4%" align="center" class="Title"><strong>No.</strong></td>
      <td width="18%" align="center" class="Title"><strong>����ʱ��</strong></td>
      <td width="19%" align="center" class="Title"><strong>������</strong></td>
      <td width="59%" align="center" class="Title"><strong>�绰QQ��ע</strong></td>
    </tr>
    <%

If not rs.Eof then
rs.AbsolutePage=PageNo '���õ�ǰҳ
For n=1 to rs.PageSize
i=i+1
%>
    <tr bgcolor="#FFFFFF"> 
      <td align="center" class="tdbg"><%=i%></td>
      <td valign="top" nowrap class="tdbg"><%=rs("AddTime")%></td>
      <td align="center" valign="top" nowrap class="tdbg"><%=rs("ActionUser")%></td>
      <td class="tdbg"><%=(rs("Remark"))%></td>
    </tr>
    <%
	rs.MoveNext
	If rs.EOF then Exit For
	Next
	end if
%>
  </table>


  <table width="100%" border="0" cellspacing="0" cellpadding="3">
    <tr>
      <td align="center"><%
Function GotoStr()
	Dim P
	For n=1 to rs.PageCount
		If PageNo=n then P=" Selected" Else P=""
		GotoStr=GotoStr & vbCrlf & "<Option value="&n&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&""&P&">��" & n & "ҳ</Option>" & vbCrlf
	Next
End Function


response.Write("���� <strong><font color=ff0000>"&rs.pagecount&"</font></strong> ҳ")

response.Write(" <a href=?pageno=1&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">��ҳ</a> <a href=?pageno="&pageno - 1&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">��һҳ</a> <a href=?pageno="&pageno + 1&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">��һҳ</a> <a href=?pageno="&rs.pagecount&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">βҳ</a>")

response.Write("&nbsp; ת����<select name=GoTo class=input-box onchange=Goto(this) ID=Select1>" & GotoStr & "</select>")
	rs.close
		%></td>
    </tr>
  </table>
  </FORM> 
</BODY>
</HTML>
<Script language=javascript>
<!--
//ҳ����ת
function Goto(the) {
	location.href="?pageno=" + the.value
}
-->
</script>
<!--#include virtual="/config/bottom_superadmin.asp" -->