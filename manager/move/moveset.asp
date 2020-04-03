<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
if session("u_levelid")=1 then  url_return "你不是代理",-1
conn.open constr
 module=requestf("module")
if module="module" then
	moveSet=requestf("moveSet")
	if moveSet=1 then
		sets=0
	else
		sets=1
	end if
	sql="update userDetail set u_moveSet="& sets &" where u_id="& session("u_sysid")
	conn.execute sql
  Alert_Redirect "设置成功","moveset.asp"
response.end
end if

sql="select top 1 u_moveSet from userDetail where u_id="& session("u_sysid") & " and u_level<>1"
rs.open sql,conn,1,3
if rs.eof then
    rs.close
	response.write "<script language=javascript>history.back();</script>"
	response.end
end if
moveset=trim(rs("u_moveSet"))
 start="允许"

if moveset=1 then
 start="禁止"
 moveset=1
else
 moveset=0
end if
if start="允许" then
	startbutton="禁止"
else
	startbutton="允许"
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-业务转移设置</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language=javascript>
 function dosub(){
   var p=document.form1.moveSet.value;
   var v="禁止";
   
   		if(p==1){
			v="允许";
		}
		if(confirm("您确定要-"+ v +"-用户转入吗?")){
			document.form1.module.value="module";
			document.form1.submit();
			return true;
		}else{
		  return false;
		}
   	
  
 }
</script>
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
        <li><a href="/manager/usermanager/default2.asp">业务转移设置</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="form1" action="moveset.asp" method="post">
        <table  class="manager-table">
          <tr>
            <th>你的所有业务目前的转移状态是:<font color=red><%=start%></font>被其他用户转入到他的账号下。</th>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" value="<%=moveSet%>" name="moveSet">
              <input type="button" class="manager-btn s-btn" onClick="return dosub()" value="我要<%=startbutton%>用户转入"></td>
            <input type="hidden" value="" name="module">
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" class="tdbg"> 提示：<br />
              通过此项设置，可以禁止自己的业务被其他会员转出，即使他知道业务管理密码也不能转出。但如果您连续三个月内都没有登录过我司网站，则该设置自动失效。</td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
