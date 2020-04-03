<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"

pages =strtonum(pages)

sqlstring="select u_ip from UserDetail where u_id="&session("u_sysid")
session("sqlcmd_VU")=sqlstring
conn.open constr
rs.open session("sqlcmd_VU") ,conn,3
 
If Not (rs.eof And rs.bof) Then
	if not isnull(rs(0)) then
	  u_ip=split(trim(rs(0)),",")
	else
	  u_ip=Array()
	end if
end if
rs.close
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-登录日志</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
</HEAD>
<body>
<!--#include virtual="/manager/top.asp" -->
<div id="MainContentDIV"> 
  <!--#include virtual="/manager/manageleft.asp" -->
  <div id="ManagerRight" class="ManagerRightShow">
    <div id="SiteMapPath">
      <ul>
        <li><a href="/">首页</a></li>
        <li><a href="/Manager/">管理中心</a></li>
        <li><a href="/manager/usermanager/userlog.asp">登录日志</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table class="manager-table">
        <tr>
          <th>序号</th>
          <th>登陆时间</th>
          <th>登陆ip</th>
        </tr>
        <%
        for ii=0 to ubound(u_ip)
          ip_time =split(u_ip(ii),"|")
          if ubound(ip_time)>0 then 
            logip=ip_time(0)
            logtime=ip_time(1)
          end if
          trcolor="#ffffff"
    
            response.write "<tr><td>"&ii+1&"</td><td >&nbsp;"&logtime&"</td><td>"&logip&"</td></tr>"
          
        next
        %>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
