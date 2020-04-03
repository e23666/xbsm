<script language="JavaScript" type="text/JavaScript">
<!--
try{
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
}catch(e){}
//-->
</script>
<style type="text/css">
.fei {
	position:absolute;
	margin-top:-10px;
	float:left;
	height:15px;
	width:30px;
	margin-left:-10px;
	zoom:1;
	overflow:hidden;
}
</style>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="65"><img src="<%=logimgPath%>"></td>
    <td width="713" align="right" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="/Template/Tpl_01/images/spacer.gif" width="3" height="3"></td>
        </tr>
      </table>
      <table border="0" cellspacing="0" cellpadding="1">
        <tr>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_19.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/buystep.asp">购买流程</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_23.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/howpay.asp">付款方式</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_17.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/faq">常见问题</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_15.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/manager/default.asp?page_main=%2FManager%2Fquestion%2Fsubquestion%2Easp">在线提问</a>&nbsp;</td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_21.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/renew.asp">续租服务</a>&nbsp;</td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_01/images/Default_15.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/bagshow/">购物车</a></td>
          <td bgcolor="f2f2f2"><select onChange="MM_jumpMenu('parent',this,0)" name=menu1>
              <option selected>产品服务快速通道</option>
              <option>----------------</option>
              <option value="/manager/default.asp?page_main=%2FManager%2Fproductall%2Fdefault%2Easp">==产品价格总览==</option>
              <option value="http://www.miibeian.gov.cn/chaxun/sfba.jsp">==是否备案查询==</option>
              <option value="/services/domain/">==域名注册==</option>
              <option value="/services/domain/">英文域名注册</option>
              <option value="/services/domain/defaultcn.asp">中文域名注册</option>
              <option value="/services/domain/dns.asp">DNS管理</option>
              <option value="/services/search/">==网站推广==</option>
              <option value="/services/webhosting/">==虚拟主机==</option>
              <option>----------------</option>
              <option value="/services/webhosting/twolinevhost.asp">双线路虚拟主机</option>
              <option value="/services/webhosting/basic.asp">基本型虚拟主机</option>
            
              <option value="/services/webhosting/database.asp">数据库</option>
              <option value="/services/application/">应用服务</option>
              <option value="/services/webhosting/demohost.asp">虚拟主机免费试用</option>
              <option value="/services/webhosting/SpeedTest.htm">机房速度测试</option>
              <option>----------------</option>
              <option value="/services/server/">==租用托管==</option>
              <option value="/services/server/">服务器租用</option>
              <option value="/services/trusteehost/default.asp">主机托管</option>
              <option>----------------</option>
              <option value="/services/mail/">==企业邮局==</option>
              <option value="/services/mail/">购买企业邮局</option>
              <option>----------------</option>
              <option value="/customercenter/howpay.asp">==付款方式==</option>
              <option>----------------</option>
              <option value="/aboutus/contact.asp">==联系我们==</option>
              <option value="/faq/">常见问题</option>
            </select></td>
        </tr>
      </table>
      <%
	  if len(session("user_name"))>0 then
	  	managerurl=newInstallDir & "/manager"
		  If session("u_type")<>"0" Then
			managerurl=SystemAdminPath
		 End If
	  %>
      <table border="0" cellspacing="0" cellpadding="3">
        <tr>
          <td nowrap><img src="/Template/Tpl_01/images/icoTip.gif" width="14" height="18">&nbsp;&nbsp;&nbsp;</td>
          <td nowrap>您好：<font color="#CC0000"><strong><%=session("user_name")%>&nbsp;&nbsp;</strong></font></td>
          <td nowrap>您的级别是:<strong><font color="#CC0000"><%=session("u_level")%>&nbsp;&nbsp;</font></strong></td>
          <td nowrap><a href="<%=managerurl%>"><u><font color="#CC0000"><strong>管理中心</strong></font></u></a>&nbsp;&nbsp;</td>
          <td nowrap><a href="/signout.asp"><img src="/Template/Tpl_01/images/button_logout_03.gif" border="0"></a></td>
        </tr>
      </table>
      <%else%>
      <script language="JavaScript">
	  function checkLogin()
	  {
	  	if(myform.u_name.value=="")
		{
			alert("用户名不能为空！");
			myform.u_name.focus();
			return false;
		}
	  	if(myform.u_password.value=="")
		{
			alert("密码不能为空！");
			myform.u_password.focus();
			return false;
		}
	  }
	  </script>
      <table border="0" cellspacing="0" cellpadding="3">
        <form name="myform" action="/chklogin.asp" method="post" onSubmit="return checkLogin()">
          <tr>
            <td nowrap>用户名:</td>
            <td nowrap><input name="u_name" type="text" class="inputbox" size="16"></td>
            <td nowrap>密　码: </td>
            <td nowrap><input name="u_password" type="password" class="inputbox" size="16"></td>
            <td nowrap><input name="imageField" type="image" src="/Template/Tpl_01/images/Default_34.gif" width="80" height="21" border="0"></td>
            <td nowrap><a href="/reg"><img src="/Template/Tpl_01/images/Default_36.gif" width="80" height="21" border="0"></a></td>
            <td nowrap><a href="/reg/forget.asp"><font color="#CC0000">忘记密码？</font></a></td>
          </tr>
        </form>
      </table>
      <%end if%></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" id="menu">
  <tbody>
    <tr>
      <td align="middle" width="75" 
    background="/Template/Tpl_01/Timages/v2_10.jpg" 
      height="42"><a href="/"><font color="#FFFFFF">首页</font></a></td>
      <td align="middle" width="76" 
    background="/Template/Tpl_01/Timages/v2_11.gif"><a 
      href="/services/domain/"><font color="#FFFFFF">域名注册</font></a></td>
      <td align="middle" width="77" 
    background="/Template/Tpl_01/Timages/v2_12.gif"><a 
      href="/services/webhosting/"><font color="#FFFFFF">虚拟主机</font></a></td>
      <td align="middle" width="76" 
    background="/Template/Tpl_01/Timages/v2_13.jpg"><a 
      href="/services/CloudHost/"><font color="#FFFFFF">云主机</font></a><span style="background:url(/Template/tpl_04/images/tjnew.gif) no-repeat" class="fei"></span></td>
      <td align="middle" width="76" 
    background="/Template/Tpl_01/Timages/v2_14.jpg"><a 
      href="/services/mail/"><font color="#FFFFFF">企业邮局</font></a></td>
      <td align="middle" width="76" 
    background="/Template/Tpl_01/images/v2_17_site.gif"><a href="/services/webhosting/sites.asp"><font color="#FFFFFF">成品网站</font></a></td>
      <td align="middle" width="77" 
    background="/Template/Tpl_01/Timages/v2_16.jpg"><a href="/services/vpsserver/"><font color="#FFFFFF">VPS主机</font></a></td>
      <td align="middle" width="76" 
    background="/Template/Tpl_01/Timages/v2_18.jpg"><a 
      href="/agent/"><font color="#FFFFFF">代理专区</font></a></td>
      <td align="middle" width="75" 
    background="/Template/Tpl_01/Timages/v2_19.jpg"><a href="/customercenter/"><font color="#FFFFFF">客服中心</font></a></td>
    </tr>
  </tbody>
</table>
