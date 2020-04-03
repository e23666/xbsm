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

Act=requesta("act")
PN=Requesta("PN")

if not isNumeric(PN) then PN=1
PN=Cint(PN)
if PN<1 then PN=1

if Act="clean" then
	conn.Execute("delete from ActionLog where LogType='API'")
end if

sql="select * from ActionLog where LogType='API' order by id desc"
rs.open sql,conn,1,3
if not rs.eof then
	rs.pageSize=15
	if PN>rs.pageCount then PN=rs.pageCount
	rs.absolutePage=PN
	end if

PNtmp="<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?PN="
PStr="共" & Rs.PageCount & "页,第" & PN & "页，" & PNtmp & (PN-1) & ">上一页</a>，" & PNtmp & (PN+1) & ">下一页</a>，" & PNtmp & "1>首页</a>，" & PNTmp & Rs.PageCount & ">尾页</a>"

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
      <td width="771"><a href="javascript:if (confirm('确定删除')){location.href='ViewAPILog.asp?act=clean'}"><font color="#0000FF">清空日志</font></a> 
        <a href="ViewLog.asp"><font color="#0000FF">查看系统日志</font></a> </td>
  </tr>
</table>
<br>
<%=PStr%><br>
  <table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
    <tr bgcolor="#FFFFFF"> 
      <td width="4%" align="center" class="Title"><strong>No.</strong></td>
      <td width="19%" align="center" class="Title"><strong>操作时间</strong></td>
      <td width="5%" align="center" class="Title"><strong>来源</strong></td>
      <td width="72%" align="center" class="Title"><strong>命令备注</strong></td>
    </tr>
    <%
i=0
do while not rs.eof and i<=rs.pageSize
	i=i+1
%>
    <tr bgcolor="#FFFFFF"> 
      <td align="center" class="tdbg"><%=i%></td>
      <td valign="top" nowrap class="tdbg"><%=rs("AddTime")%></td>
      <td align="center" valign="top" nowrap class="tdbg"><%=rs("ActionUser")%></td>
      <td class="tdbg"><pre style="display:inline"><%=(rs("Remark"))%></pre></td>
    </tr>
    <%
	rs.MoveNext
	Loop
	rs.close
%>
  </table>


  <table width="100%" border="0" cellspacing="0" cellpadding="3">
    <tr>
      <td align="center"></td>
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