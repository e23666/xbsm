
<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-Mssql数据库管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<%
conn.open constr
p_id=requesta("p_id")
act=requesta("act")
if len(p_id)<=0 then url_return "参数错误",-1
sql="select * from databaselist where dbsysid="& p_id &" and dbu_id=" & session("u_sysid")
rs.open sql,conn,1,3
if rs.eof and rs.bof then rs.close:conn.close:url_return "没有找到此产品",-1
s_comment=rs("dbname")
s_ftppassword=rs("dbpasswd")
s_serverIP=rs("dbserverip")
s_buydate=rs("dbbuydate")
s_expiredate=rs("dbexpdate")
s_ProductId=rs("dbproid")
if act="changepwd" then
	newpwd=requesta("p_pwd")
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "密码("& newpwd &")应为字母数字或_组成,长度在5-20位之间",-1
	commandstr="mssql" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:chgpwd" & vbcrlf & _
				"databasename:" & s_comment & vbcrlf & _
				"databaseuser:" & s_comment & vbcrlf & _
				"dbupassword:" & newpwd & vbcrlf & _
				"." & vbcrlf

	renewdata=pcommand(commandstr,session("user_name"))
	if left(renewdata,3)="200" then
		alert_redirect "修改密码成功",request("script_name") & "?p_id=" & p_id
	else
		alert_redirect "修改密码失败:"& renewdata ,request("script_name") & "?p_id=" & p_id
	end if
	rs.close
	conn.close
	response.end
elseif act="syn" then
	returnstr=doUserSyn("mssql",s_comment)
	if left(returnstr,3)="200" then
		alert_redirect "重置数据成功",request("script_name") & "?p_id=" & p_id
	else
	 	alert_redirect "重置数据失败" & returnstr,request("script_name") & "?p_id=" & p_id
	end if
end if

rs.close
conn.close
%>
<script language=javascript>
function changepwd(f){
	var v=f.p_pwd;
	var regv=/^[\w]{5,20}$/;

	if (!regv.test(v.value)){
		alert('密码('+ v.value +')应为字母数字或_组成,长度在5-20位之间');
		v.focus();
		return false;
	}
	f.action += '?act=changepwd';
	return confirm('确定修改此密码吗?');

}
function buyfree(f,v){
	if(v!=''){
		f.target='_parent';
		f.action = '/manager/config/getFree.asp';
		f.freeident.value=v;
		f.submit();
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
			   <li><a href="/manager/sqlmanager/">Mssql数据库管理</a></li>
			   <li>Mssql管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		          <form name=form1 action="<%=request("script_name")%>" method=post>
                         <table class="manager-table">

                     <tr>
                       <th class="tdbg">数据库/用户名:</th>
                       <td class="tdbg"><%=s_comment%></td>
                       <th class="tdbg">密码:</th>
                       <td class="tdbg"><input type=text value="<%=s_ftppassword%>" name="p_pwd" class="manager-input s-input">
                         <input type="submit" value="修改密码" class="manager-btn s-btn" onclick="return changepwd(this.form)">      </td>
                     </tr>
                     <tr>
                       <th class="tdbg">IP地址:</th>
                       <td class="tdbg"><%=s_serverIP%></td>
                       <th class="tdbg">数据库型号:</th>
                       <td class="tdbg"><%=s_ProductId%></td>
                     </tr>
                     <tr>
                       <th class="tdbg">购买时间:</th>
                       <td class="tdbg"><%=s_buydate%></td>
                       <th class="tdbg">到期时间:</th>
                       <td class="tdbg"><%=s_expiredate%></td>
                     </tr>
                     <tr>
                       <td  colspan=4 align="center" class="tdbg">
                       	<input type="submit" name="sub2" value="进入高级管理" class="manager-btn s-btn" onclick="javascript:this.form.action='http://www.myhostadmin.net/database/checklogin.asp';this.form.target='_blank';">
                          <input type="submit" name="sub3" value="   同步数据   " class="manager-btn s-btn" onclick="javascript:this.form.action='<%=request("script_name")%>?act=syn';">
                         <input type="hidden" name="dbuserid" value="<%=s_comment%>">
                        	<input type="hidden" name="dbpasswd" value="<%=s_ftppassword%>">
                         <input type="hidden" name="p_id" value="<%=p_id%>">
                      </td>
                     </tr>


                 </table>
                                    </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>