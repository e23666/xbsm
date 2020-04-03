<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/jscripts/layui/css/layui.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
    <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script> 
	<script type="text/javascript" src="/jscripts/template.js"></script>
	<script type="text/javascript" src="/jscripts/audit/data.js"></script> 
	<script type="text/javascript" src="/jscripts/audit/pinyin.js"></script> 
    <script type="text/javascript" src="/jscripts/audit/config.js"></script>
	<script type="text/javascript" src="/jscripts/audit/domainbox.js?r=<%=timer()%>"></script>
	<script type="text/javascript" src="/jscripts/audit/domainaudit.js"></script>
    
  

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/domainmanager/">管理中心</a></li>
			   <li>通用模板</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
			 <form name="audit_form"  class="layui-form" action="">        
            
                </form>

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
 <!--#include virtual="/config/class/tpl.asp" -->
 <script src="/jscripts/layui/layui.js"></script>
 <script type="text/javascript">
   $(function(){
        layui.use(['form','laydate','laypage','layer','table','upload'], function(){			
          layform = layui.form;
          laypage = layui.laypage;
          laydate = layui.laydate;
          layer=layui.layer;
          laytable = layui.table;    
          layupload=layui.upload;  
         <%if requesta("tab")<>"" then %>
          domainaudit.configbody.tab="<%=requesta("tab")%>";
          <%end if%>
          <%if requesta("ghdomain")<>"" then %>
          domainaudit.configbody.ghdomain="<%=replace(requesta("ghdomain"),",","\r\n")%>";
          <%end if%>

          domainaudit.init();
        });    
    });
</script>
</body>
</html>