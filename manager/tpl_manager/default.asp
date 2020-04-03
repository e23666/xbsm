<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script src="/manager/js/menu.js" type="text/javascript"></script>
<link rel="stylesheet" href="/manager/css/default.css" type="text/css" />
<%
conn.open constr
Sql="Select * from Fuser Where username='" & Session("user_name") & "' and L_ok="&PE_True&""
Set FRs=conn.Execute(Sql)
return_vcp=false
if not FRs.eof then
	return_vcp=true
end if
frs.close
set frs=nothing
session("vcp")=return_vcp
%>
<title>用户管理后台</title>
<body>
<dl id="header">
	<dt></dt>
	<dd>
		<li><a href="/" target="_blank">首页</a>&nbsp;|&nbsp;</li>
		<li><a href="/signout.asp">退出</a>&nbsp;</li>
	</dd>
</dl>
<div id="contents">
	<div class="left">
		<ul id="manageruser">
			<li><img src="/manager/images/Style/user_ico.gif" border=0>&nbsp; <a href="../usermanager/default2.asp" onclick="doopenpage1('TabPage2','left_tab6','修改资料','userpage11')" target="content3" title="修改资料" ><span class="fil" style="cursor:pointer"><%=gotTopic(session("user_name"),19)%></span></a></li>
			<li><img src="/manager/images/Style/users_ico.gif" border=0>&nbsp; <%If session("priusername")<>"" Then%><a href="../whoami.asp?module=returnme" style="cursor:pointer"><span class="fil">还原身份:<%= session("priusername") %></span></a><%else%><span class="fil"><%=session("u_level")%></span><%end if%></li>
		</ul>
		<div class="menu_top"></div>
		<div class="menu" id="TabPage3">
			<ul id="TabPage2">
				<li id="left_tab1" class="Selected" onClick="javascript:border_left('TabPage2','left_tab1');" title="业务管理">业务</li>
				<li id="left_tab2" onClick="javascript:border_left('TabPage2','left_tab2');" title="订单管理">订单</li>		
				<li id="left_tab3" onClick="javascript:border_left('TabPage2','left_tab3');" title="财务管理">财务</li>
				<li id="left_tab6" onClick="javascript:border_left('TabPage2','left_tab6');" title="账号管理">账号</li>
                <%if session("vcp") or session("u_levelid")>1 then%>
				<li id="left_tab4" onClick="javascript:border_left('TabPage2','left_tab4');" title="代理商管理">代理</li><%end if%>
				<li id="left_tab5" onClick="javascript:border_left('TabPage2','left_tab5');" title="帮助中心">问题</li>
			</ul>
			<div id="left_menu_cnt">
				<ul id="dleft_tab1">
					<li id="now11" class="Selected"><a id="domain11" href="../domainmanager/default.asp" onClick="go_cmdurl('域名管理',this);" target="content3" title="域名管理">域名管理</a></li>
				  <li id="now11"><a id="host11" href="../sitemanager/default.asp" onClick="go_cmdurl('空间管理',this);" target="content3" title="空间管理">虚拟主机管理</a></li>
				  <li id="now11"><a id="mail11" href="../mailmanager/default.asp" onClick="go_cmdurl('邮局管理',this);" target="content3" title="邮局管理">企业邮局管理</a></li>
				  <li id="now11"><a href="../servermanager/default.asp" onClick="go_cmdurl('租用托管',this)" target="content3" title="租用托管">主机租用托管</a></li>
				  <li id="now11"><a href="../search/default.asp" onClick="go_cmdurl('推广产品',this);" target="content3" title="推广产品">推广产品管理</a></li>
				  <li id="now11"><a href="../sqlmanager/default.asp" onClick="go_cmdurl('Mssql',this)" target="content3" title="Mssql">Mssql数据库管理</a></li>
				  <li id="now11"><a href="../move/movein.asp" onClick="go_cmdurl('业务转入',this)" target="content3" title="业务转入">业务转入</a></li>
				  <li id="now11"><a href="../move/moveout.asp" onClick="go_cmdurl('业务转出',this)" target="content3" title="业务转出">业务转出</a></li>
                  <li id="now11"><a href="../domainmanager/zhuanru.asp" onClick="go_cmdurl('域名转入',this)" target="content3" title="域名转入列表">域名转入查询</a></li>
				  <li id="now11"><a href="http://beian.vhostgo.com/" target="_blank" title="进入我司委托备案系统">ICP网站备案</a></li>
			  </ul>
				<ul id="dleft_tab2" style="display:none;">
					<li id="now11"><a id="domainorder11" href="../ordermanager/domain/default.asp" onClick="go_cmdurl('域名订单',this)" target="content3" title="域名订单">域名订单</a></li>
					<li id="now11"><a id="hostorder11" href="../ordermanager/vhost/default.asp" onClick="go_cmdurl('主机订单',this)" target="content3" title="主机订单">虚拟主机订单</a></li>
				</ul>
				<ul id="dleft_tab3" style="display:none;">
					<li id="now11"><a id="mlist11" href="../useraccount/mlist.asp" onClick="go_cmdurl('财务明细',this)" target="content3" title="财务明细">财务明细</a></li>
					<li id="now11"><a id="onlinePay11" href="../onlinePay/onlinePay.asp" onClick="go_cmdurl('在线支付',this)" target="content3" title="在线支付">在线支付</a></li>
					<li id="now11"><a id="fapiao11" href="../useraccount/fapiao.asp" onClick="go_cmdurl('发票索取',this)" target="content3" title="发票索取">发票索取</a></li>
                    <li id="now11"><a href="../useraccount/VFaPiao.asp" onClick="go_cmdurl('发票查询',this)" target="content3" title="发票查询">发票查询</a></li>
					<li id="now11"><a href="../useraccount/payend.asp" onClick="go_cmdurl('汇款确认',this)" target="content3" title="汇款确认">汇款确认</a></li>
                    <li id="now11"><a href="../useraccount/ViewPayEnd.asp" onClick="go_cmdurl('汇款查询',this)" target="content3" title="汇款查询">汇款查询</a></li>
                   
				</ul>
				<ul id="dleft_tab6" style="display:none;">
					<li id="now11"><a id="userpage11" href="../usermanager/default2.asp" onClick="go_cmdurl('修改资料',this)" target="content3" title="修改资料">修改资料</a></li>
					<li id="now11"><a href="../productall/default.asp" onClick="go_cmdurl('产品价格',this)" target="content3" title="产品价格">产品价格</a></li>
					<li id="now11"><a href="../usermanager/userlog.asp" onClick="go_cmdurl('登陆日志',this)" target="content3" title="登陆日志">登陆日志</a></li>
					
				</ul>
				<ul id="dleft_tab4" style="display:none;">
                <%if session("vcp") then%>
					<li id="now11"><a href="../vcp/vcp_index.asp" onClick="go_cmdurl('VCP管理',this)" target="content3" title="VCP管理">VCP业务管理</a></li>
					<li id="now11"><a href="../vcp/vcp_Vuser.asp" onClick="go_cmdurl('VCP用户',this)" target="content3" title="VCP用户">我的VCP用户</a></li>
					<li id="now11"><a href="../vcp/settleList.asp" onClick="go_cmdurl('VCP打款',this)" target="content3" title="VCP打款">VCP打款明细</a></li>
					<li id="now11"><a href="../vcp/royalty.asp" onClick="go_cmdurl('VCP利润',this)" target="content3" title="VCP利润">VCP利润明细</a></li>
                    <li id="now11"><a href="../vcp/vcp_Edit.asp" onClick="go_cmdurl('修改资料',this)" target="content3" title="修改资料">修改VCP资料</a></li>
                    <li id="now11"><a href="../vcp/newGetADS.asp?code=u" onClick="go_cmdurl('VCP广告',this)" target="content3" title="VCP广告">VCP广告代码</a></li>
                 <%end if%>
                 <%if session("u_levelid")>1 then%>
                    <li id="now11"><a href="../usermanager/APIconfig.asp" onClick="go_cmdurl('API配置',this)" target="content3" title="API配置">API接口配置</a></li>
                    <li id="now11"><a href="../move/moveset.asp" onClick="go_cmdurl('业务转移',this)" target="content3" title="业务转移">业务转移设置</a></li>
                 <%end if%>
				</ul>
				<ul id="dleft_tab5" style="display:none;">
					<li id="now11"><a href="/faq" onClick="go_cmdurl('常见问题',this)" target="content3" title="常见问题">常见问题FAQ</a></li>
					<li id="now11"><a id="question11" href="../question/subquestion.asp" onClick="go_cmdurl('有问必答',this)" target="content3" title="有问必答">有问必答</a></li>
					<li id="now11"><a href="../question/allquestion.asp?module=search&qtype=myall" onClick="go_cmdurl('问题跟踪',this)" target="content3" title="问题跟踪">问题处理跟踪</a></li>
                    <li id="now11"><a href="/customercenter/" onClick="go_cmdurl('客服中心',this)" target="_blank" title="客服中心">客服中心</a></li>		
				</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div class="menu_end"></div>
	</div>
	<div class="right">
	   <ul id="TabPage1">
			<li id="Tab1" class="Selected" onClick="javascript:switchTab('TabPage1','Tab1');" title="管理首页">管理首页</li>
			
			<li id="Tab3" onClick="javascript:switchTab('TabPage1','Tab3');"><span id="dnow99" style="display:block">域名管理</span></li>
	   </ul>
		<div id="cnt">
		  <div id="dTab1" class="Box">
		  <iframe src="/manager/tpl_manager/main.asp" name="content1" frameborder="0" scrolling="auto"></iframe>
		  </div>
			<div id="dTab3" class="HackBox Box">
			<iframe src="../domainmanager/default.asp" name="content3" id="content3" frameborder="0" scrolling="auto"></iframe>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<%
page_main=request("page_main")
if page_main<>"" then
	if instr(page_main,"onlinePay.asp")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab3','在线支付','onlinePay11');"
	elseif instr(page_main,"subquestion.asp")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab5','有问必答','question11');"
	elseif instr(page_main,"domainmanager")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab1','域名管理','domain11');"
	end if
	response.write "document.frames['content3'].location.href='"& page_main &"';</script>"
end if
%>
</body>
</html>
