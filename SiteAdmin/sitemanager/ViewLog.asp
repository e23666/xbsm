<!--#include virtual="/config/config.asp"--> 
<%Check_Is_Master(6)%>
<%
conn.open constr
%> <HTML> <HEAD> <script language=javascript>
function writeMemo(form,uid,defaultinfo,uname){
	oldinfo=prompt('请输入备注(不能含有\'号):',defaultinfo);
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
rs.PageSize=20 '每页记录数
rs.CacheSize=rs.PageSize '记录缓存
If IsBlank(PageNo) or not IsNumeric(PageNo) then PageNo=1 '如果PageNo为空,则PageNo等于1
PageNo=CLng(PageNo)
If PageNo<1 then PageNo=1 '如果PageNo小于1,则PageNo等于1
If PageNo>rs.PageCount then PageNo=rs.PageCount '如果PageNo大小总页数,则PageNo等于总页数
Dim i,n
i=(PageNo-1)*rs.PageSize '序号
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>日志查看</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="ViewAPILog.asp"><span class="STYLE4">API命令日志查看</span></a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
    <tr>
      <td align="center" class="tdbg"><table border="0" cellspacing="0" cellpadding="4">
        <tr>
          <td>操作人：
            <input name="ActionUser" type="text" id="ActionUser" size="15"></td>
          <td nowrap>时间：
            <input name="S_Date" type="text" id="S_Date" size="15">
            -
            <input name="E_Data" type="text" id="E_Data" size="15"></td>
          <td>类型：</td>
          <td><select name="ActionType" id="ActionType">
              <option value="host" selected>主机</option>
              <option value="domain">域名</option>
              <option value="mail">邮件</option>
              <option value="other">其它</option>
          </select></td>
          <td><input type="submit" name="Submit" value=" 搜 索 "></td>
        </tr>
      </table></td>
    </tr>
</table>
  <br>
  <table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
    <tr bgcolor="#FFFFFF"> 
      <td width="4%" align="center" class="Title"><strong>No.</strong></td>
      <td width="18%" align="center" class="Title"><strong>操作时间</strong></td>
      <td width="19%" align="center" class="Title"><strong>操作人</strong></td>
      <td width="59%" align="center" class="Title"><strong>电话QQ备注</strong></td>
    </tr>
    <%

If not rs.Eof then
rs.AbsolutePage=PageNo '设置当前页
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
		GotoStr=GotoStr & vbCrlf & "<Option value="&n&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&""&P&">第" & n & "页</Option>" & vbCrlf
	Next
End Function


response.Write("共有 <strong><font color=ff0000>"&rs.pagecount&"</font></strong> 页")

response.Write(" <a href=?pageno=1&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">首页</a> <a href=?pageno="&pageno - 1&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">上一页</a> <a href=?pageno="&pageno + 1&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">下一页</a> <a href=?pageno="&rs.pagecount&"&ActionUser="&ActionUser&"&S_Date="&S_Date&"&E_Data="&E_Data&"&ActionType="&ActionType&">尾页</a>")

response.Write("&nbsp; 转到：<select name=GoTo class=input-box onchange=Goto(this) ID=Select1>" & GotoStr & "</select>")
	rs.close
		%></td>
    </tr>
  </table>
  </FORM> 
</BODY>
</HTML>
<Script language=javascript>
<!--
//页面跳转
function Goto(the) {
	location.href="?pageno=" + the.value
}
-->
</script>
<!--#include virtual="/config/bottom_superadmin.asp" -->