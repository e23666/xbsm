<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/uphost_class.asp" -->
<%
response.Charset="gb2312"
conn.open constr
hostID=Trim(Requesta("HostID"))		'本次操作的主机ID
act=trim(requesta("act"))
set up=new uphost_class:up.u_sysid=session("u_sysid"):up.setHostid=hostid

if act="reupdate" then
	commandstr="vhost"& vbcrlf & _
			   "set"& vbcrlf & _
			   "entityname:reupvhost" & vbcrlf & _
			   "siteName:" & up.s_comment & vbcrlf & _
			   "." & vbcrlf	   
	resultstr=pcommand(commandstr,up.u_name)	
	set up=nothing	
	if left(resultstr,3)="200" then
		gowithwin "uphost.asp?hostid="&hostid
	else
		alert_redirect resultstr,requesta("script_name")&"?hostid="&hostid
	end if
	response.end
end if
if up.istostatepage and instr(requesta("script_name"),"uphost_state.asp")=0 then 
	gowithwin "uphost_state.asp?hostid="&hostid
elseif not up.istostatepage and instr(requesta("script_name"),"uphost.asp")=0 then
	gowithwin "uphost.asp?hostid="&hostid	 
end if
call doUserSyn("vhost",up.s_comment)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-虚拟主机管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
	<script language="javascript">
	$(function(){
		$("input[name='reupdatebutton']:button").click(function(){
			if(confirm("确定删除该升级记录重新升级吗？"))
			window.location.href="uphost_state.asp?act=reupdate&hostID=<%=hostid%>";
		});
	});
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
			    <li><a href="/Manager/sitemanager/">虚拟管理管理</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
	
		  <table class="manager-table">
			<tbody>
				<tr><th colspan=2>独立IP主机升级</th></tr>
				<tr>
					<th align="right">站点名称:</th>
					<td align="left"><%=up.s_comment%></td>
				</tr>
				<tr>
					<th align="right">使用时间:</th>
					<td align="left"><%=up.s_buydate%>～<%=up.s_expiredate%>&nbsp;&nbsp;剩余天数:<%=up.dayHave%>天</td>
				</tr>
				<tr>
					<th align="right">当前型号:</th>
					<td align="left"><%=up.s_ProName%>(<%=up.s_productid%>)</td>
				</tr>
				<tr>
					<th align="right">当前机房:</th>
					<td align="left"><%=up.s_roomname%></td>
				</tr>
				<tr>
					<th align="right">当前型号:</th>
					<td align="left"><%=up.s_ProName%>(<%=up.s_productid%>)</td>
				</tr>
				<tr>
					<td colspan=2>



			<table class="manager-table">
				<tbody>
					<tr>
						<th colspan=2>  
							 <%if up.movestate=0 then%>
							  <div class="adsf">请检查网站在新服务器上运行是否正常</div>
							  <%elseif up.movestate=1 then%>
							  <div class="adsf">正在迁移数据</div>
							  <%elseif up.movestate=3 then%>
							  <div class="adsf">数据转移失败,请联系管理员</div>
							  <%elseif up.movestate=2 then%>
							  <div class="adsf">请下载原数据到新机房</div>
							  <%end if%>
						 </th>
					  </tr>
 <%if up.s_ProNameClass="mysql" then%>
					 <tr>
						<td>
      <form name="mysqlform1" method="post" action="http://mysql.myhostadmin.net/index.php" target="_blank">
                
                  <div>原IP:<%=up.old_serverip%><a href="###" onclick=javascript:$('form[name="mysqlform1"]').submit() style="color:#06c">[连接]</a></div>
                  <div>mysql名:<%=up.s_comment%></div>
                  <div>mysql密码:<%=up.s_ftppassword%></div>
                  <input type="hidden" name="mysqlhost" value="<%=up.old_serverip%>">
                  <input type="hidden" name="pma_username" value="<%=up.s_comment%>">
                  <input type="hidden" name="pma_password" value="<%=up.s_ftppassword%>">
                  <input type="hidden" name="mysqlport" value="3306">
                  <input type="hidden" name="server" value="1">
                  <input type="hidden" name="lang" value="zh-utf-8">
                  <input type="hidden" name="convcharset" value="iso-8859-1">
                
              </form>
						</td>

						<td>
				 <form name="mysqlform2" method="post" action="http://mysql.myhostadmin.net/index.php" target="_blank">
               
                  <div>当前IP:<%=up.s_serverip%><a href="###" onclick=javascript:$('form[name="mysqlform2"]').submit()  style="color:#06c">[连接]</a></div>
                  <div>mysql名:<%=up.s_comment%></div>
                  <div>mysql密码:<%=up.s_ftppassword%></div>
                  <input type="hidden" name="mysqlhost" value="<%=up.s_serverip%>">
                  <input type="hidden" name="pma_username" value="<%=up.s_comment%>">
                  <input type="hidden" name="pma_password" value="<%=up.s_ftppassword%>">
                  <input type="hidden" name="mysqlport" value="3306">
                  <input type="hidden" name="server" value="1">
                  <input type="hidden" name="lang" value="zh-utf-8">
                  <input type="hidden" name="convcharset" value="iso-8859-1">
               
              </form>		
		
						</td>
					 </tr>
					     <%else%>
		<tr>
			<td> 
                <div>原IP:<%=up.old_serverip%><a href="ftp://<%=up.s_comment%>:<%=up.s_ftppassword%>@<%=up.old_serverip%>/" style="color:#06c" target="_blank">[连接]</a></div>
                <div>ftp名:<%=up.s_comment%></div>
                <div>ftp密码:<%=up.s_ftppassword%></div>
             </td>

			<td> 
                <div>当前IP:<%=up.targetip%><a href="ftp://<%=up.s_comment%>:<%=up.s_ftppassword%>@<%=up.targetip%>/"  style="color:#06c" target="_blank">[连接]</a></div>
                <div>ftp名:<%=up.s_comment%></div>
                <div>ftp密码:<%=up.s_ftppassword%></div>
            </td>
		</tr>
		<%if up.movestate<>1 then %>
			<tr><th colspan=2> <input type="button" value="删除记录重新升级" name="reupdatebutton"  class="manager-btn s-btn" /></th></tr>
		<%end if%>
		<%End if%>
				</tbody>
			</table>








			 
					
					
					
					</td>
				</tr>
				<tr>
				<td colspan=2 align="left">
					1.升级主机型号可以获得更大的空间和更多的系统资源。<br />
              2.升级后主机的到期日期不变，升级费用为：新旧主机型号每天的差价*主机剩余的天数。升级费用不足30元的，按30元计算。<br />
              3.主机升级后对应的企业邮局自动升级，但是新型号如果有域名赠品，则无法获取。<br />
              4.集群主机只接收企业用户，个人用户请勿升级为分布式集群主机，否则无法绑定域名。<br>
              5.智能建站主机，如果跨机房升级，刚数据不能被保留，需要重建网站!如果原来的主机不支持asp.net，而升级后需要使用asp.net功能的，请联系客服增加&quot;network 
              service&quot;权限。<br />
              6.如果选择了"自动转移数据"，则需要等数据迁移完成后，系统再完成域名解析、变更服务器IP等操作;如果不需要数据，则是实时生效。电信和网通机房之间速度很慢，如果数据量太大，可能需要相当长的转移时间，甚至转移失败。<br />
              7.升级不享受购买时的优惠活动
				</td>
			</tbody>
		  </table>
  

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>