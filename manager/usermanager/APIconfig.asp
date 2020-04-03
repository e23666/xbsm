<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/asp_md5.asp" -->
<%
response.buffer=true
response.Charset="gb2312"
if session("u_levelid")=1 then response.write "<script language=javascript>alert('您还不是代理！');history.back();</script>":response.end

conn.open constr

act=trim(requesta("act"))
if act="do" then
	apipwd=requesta("apipwd")
	apiiplist=requesta("apiiplist")
	if apipwd="" then url_return "密码必须设置",-1
	iplist=""
	cur=1
	if trim(apiiplist)<>"" then
		for each iplistitem in split(apiiplist,vbcrlf)
			if isCheckip(trim(iplistitem)) then
				iplist=iplist & trim(iplistitem) & ","
				cur=cur+1
			else
				url_return "IP地址:"& iplistitem &"有错误",-1
				exit for
			end if
		next
		if right(iplist,1)="," then iplist=left(iplist,len(iplist)-1)
	end if
	if cur>5 then url_return "IP最多为5个,请检查",-1
	sql="select * from APIuser_list where u_id="& session("u_sysid")
	rs.open sql,conn,3,3
	if rs.eof and rs.bof then
		rs.addnew()
	end if
	rs("a_password")=apipwd
	rs("u_id")=session("u_sysid")
	rs("a_iplist")=iplist
	rs.update()
	rs.close
	Alert_Redirect "设置成功",request("script_name")
	
end if

sql="select * from APIuser_list where u_id="& session("u_sysid")
rs.open sql,conn,1,1
if not rs.eof then
	apipwd=rs("a_password")
	apilock=rs("a_lock")
	apiiplist=trim(rs("a_iplist"))
	if apiiplist&""<>"" then
		apiiplist=replace(apiiplist,",",vbcrlf)
	end if
end if
rs.close
function isCheckip(sInput)
	Dim oRegExp
	Set oRegExp = new RegExp
	oRegExp.Pattern = "^(\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}$)|(^\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}\/\d{1,2}$)"
	oRegExp.IgnoreCase = false
	oRegExp.Global = True
	isCheckip = oRegExp.Test(sInput)
	Set oRegExp = Nothing

end function
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-API接口配置</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
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
        <li><a href="/manager/usermanager/APIconfig.asp">API接口配置</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="form1" action="<%=request("script_name")%>?act=do" method="post">
        <table class="manager-table">
          <tbody>
            <tr>
              <th align="right">账号:</th>
              <td align="left"><%=session("user_name")%></td>
            </tr>
            <tr>
              <th align="right">安全邮箱:</th>
              <td align="left"><%=session("u_email")%></td>
            </tr>
            <tr>
              <th align="right">api连接密码:</th>
              <td align="left"><input type="text" class="manager-input s-input" value="<%=apipwd%>" name="apipwd"></td>
            </tr>
            <tr>
              <th align="right">允许访问的IP地址: <br>
                一行一个
                </td>
              <td align="left"><textarea name="apiiplist" cols="30" rows="6" class="manager-input s-input" style="height:60px;"><%=apiiplist%></textarea></td>
            </tr>
            <tr>
              <td colspan=2><input type="submit" value=" 确 定 " name="sbbutton" class="manager-btn s-btn">
                &nbsp;&nbsp;
                <input type="button" value=" 返 回 " class="manager-btn s-btn" name="javascript:history.back();">
                </th>
            </tr>
            <tr>
              <td colspan=2><b>API接口</b><br>
                <br>
                API接口是基于本站业务系统开发，集域名注册、虚拟主机、企业邮箱的实时购买开通API程序接口。<br>
                <br>
                <br>
                <b>适用对象：</b><br>
                使用我司B模式代理平台的客户； 允许访问的IP地址处可以不填，或者填代理平台所放置的服务器的IP地址。</td>
            </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
