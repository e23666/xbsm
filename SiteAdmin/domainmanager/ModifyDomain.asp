<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
strDomain=Requesta("strDomain")
years=Requesta("years")
regDate=Requesta("regDate")
if strDomain<>"" and years<>"" then
  conn.open constr
 if not isDate(regDate) then url_return "错误的日期格式(yyyy-MM-dd)",-1
  if not isNumeric(years) then url_return "年限必须是数字",-1
Sql="update domainlist set regdate='" & regDate & "',years=" & years & ",rexpiredate='" & DateAdd("yyyy",years,RegDate) & "' where strdomain='" & strDomain & "'"
conn.Execute(Sql)
 url_return "域名日期/年限修改成功,请返回",-1
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 域 名 日 期 校 正 </strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">域名管理</a></span> | <a href="ModifyDomain.asp">域名日期校正</a> | <a href="DomainIn.asp">域名转入</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<form name="form1" method="post" action="ModifyDomain.asp">
    <tr> 
      <td align="right" class="tdbg">域名：</td>
      <td class="tdbg"> 
      <input type="text" name="strDomain">      </td>
    </tr>
    <tr> 
      <td height="30" align="right" class="tdbg">开通日期：</td>
      <td height="30" class="tdbg"> 
        <input type="text" name="regDate">
      格式yyyy-mm-dd</td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">年限：</td>
      <td class="tdbg"> 
        <input type="text" name="years" maxlength="5" size="5">
      必须数字</td>
    </tr>
    <tr align="center"> 
      <td colspan="2" class="tdbg">
        <input type="submit" name="Submit" value=" 确 认 修 改">　
        <input type="reset" name="Submit2" value=" 重 新 输 入">      </td>
    </tr>
    <tr align="center">
      <td colspan="2" class="tdbg">&nbsp;</td>
    </tr>
  </form>
  </table>
  <p>&nbsp;</p>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
