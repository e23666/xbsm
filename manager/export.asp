<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
act=requesta("act")
if act="sureexport" then
conn.open constr
	types=requesta("types")
	filetype=requesta("filetype")
	if instr(",domain,server,vhost,mail,db,",","&types&",")=0 or instr(",csv,txt,",","&filetype&",")=0 then call url_return("参数错误",1)
	Response.Clear()
	Response.Buffer = true
	Response.AddHeader "Content-Disposition","attachment; filename="&types&"_"&date()&"."&filetype 
	Response.CharSet = "iso-8859-1" '文件编码
	Response.ContentType = "application/octet-stream"  
	select case trim(types)
	case "vhost"
		sql="select  s_comment as FTP名,s_serverIP as 上传地址,(s_comment+'.'+s_serverName) as 测试地址,s_productid as 产品型号,s_buydate as 购买时间,s_expiredate as 到期时间,s_ftppassword as ftp密码 from vhhostlist where S_ownerid="&session("u_sysid")
	case "domain"
		sql="select strDomain as 域名,proid as 型号,strdomainpwd as 密码,regdate as 开通时间,rexpiredate as 结束时间,years as  注册年限,dns_host1 as dns1,dns_host2 as dns2 from domainlist where userid="&session("u_sysid")
	case "mail"
		sql="select m_bindname as 邮局域名,m_mastername as 管理帐号,m_password as 管理密码,m_productId as 型号, m_serverip as 服务器ip,m_size as 大小,m_buydate as 购买时间,m_years as 年限  from mailsitelist where m_ownerid="&session("u_sysid")
	case "server"
		If not isdbsql Then
			sql="select AllocateIP as 服务器ip,StartTime as 开通时间,DateAdd("&PE_DatePart_D&",iif(isnull(preday),0,preday),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime)) as 到期时间,RamdomPass as 管理密码,addedServer as 增值服务,p_proid as 产品型号 from hostrental where u_name='"&session("user_name")&"'"
		else
			sql="select AllocateIP as 服务器ip,StartTime as 开通时间,DateAdd("&PE_DatePart_D&",isnull(preday,0),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime)) as 到期时间,RamdomPass as 管理密码,addedServer as 增值服务,p_proid as 产品型号 from hostrental where u_name='"&session("user_name")&"'"
		end if
	case "db"
		sql="select dbname as 数据库名,dbloguser as 登陆帐号,dbpasswd  as 登陆密码,dbbuydate as 购买时间,dbexpdate as 到期日志,dbyear as 年限,dbproid as 型号,dbserverip as 服务器ip from databaselist where dbserverip<>'-1' and dbu_id="&session("u_sysid")
	end select
	 
 	set ers=conn.execute(sql)
	for i=0 to ers.Fields.Count-1
	    if i=0 then
			response.write(ers.Fields(i).Name)
		else
			response.write(","&ers.Fields(i).Name)
		end if	
	Next
	response.write(vbcrlf)
	do while not ers.eof 
		for i=0 to ers.Fields.Count-1		 
			
			 if i=0 then
			 	response.write(ers(i))
			 else
				response.write(","&ers(i))
			end if	
		Next
		response.write(vbcrlf)
	ers.movenext
	loop
	conn.close
	die ""
end if
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
        <meta name="renderer" content="webkit"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <title>业务导出数据| <%=companyname%></title>
        <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
        <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
        <link rel="stylesheet" href="/manager/css/2016/manager-new.css?t=20161223">
        <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

    </head>
    <body>
 <!--#include virtual="/manager/top.asp" -->
            <div id="MainContentDIV">
				<!--#include virtual="/manager/manageleft.asp" -->

                <!--右侧内容区 开始-->
                <div id="ManagerRight" class="ManagerRightShow">
                	<div id="SiteMapPath">
                         <ul>
                           <li><a href="/">首页</a></li>
                           <li><a href="/Manager/">管理中心</a></li>
                           <li>业务导出</li>
                         </ul>
                   </div>

				   <div class="manager-right-bg">
                   <form name="form1" method="post" action="export.asp">
                        <table class="manager-table">
                            <tbody>
                            	<tr><th colspan=2>业务数据导出</th></tr>
                                <tr bgcolor="#ffffff">
                                    <th align="right" nowrap="" class="tdbg">业务类型:</th>
                                    <td   nowrap="" bgcolor="#ffffff" class="tdbg" align="left">
                                    	<input type="radio" value="vhost" name="types" checked id="types_vhost"><lable for="types_vhost">虚拟主机</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    	<input type="radio" value="domain" name="types" id="types_domain"><lable for="types_domain">域名</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="server" name="types" id="types_server"> <lable for="types_server">服务器</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="mail" name="types" id="types_mail"> <lable for="types_mail">邮局</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="db" name="types" id="types_db"> <lable for="types_db">数据库</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                	<th  align="right" nowrap="" class="tdbg">导出类型:</th>
                                    <td  nowrap="" bgcolor="#ffffff" class="tdbg" align="left">
                                    	<input type="radio" value="txt" name="filetype" checked id="file_txt"><lable for="file_txt">TXT</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="csv" name="filetype" id="file_csv" > <lable  for="file_csv">CSV</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr><th colspan=2>
                                <input type="hidden" name="act" value="sureexport">
                                <input type="submit" name="serarchsubmit" value="导出数据" class="manager-btn s-btn"></th></tr>
                            </tbody>
                        </table>
                   </form>
                   
                   
                   </div>


                </div>
  
            </div>
            <!-- END MainContentDIV -->
            <!-- 页脚 -->

<!-- 管理中心页面  使用的简单版本页脚 -->
  <!--#include virtual="/manager/bottom.asp" -->


  <!-- 页面通用滚动插件 -->
  <!--[ SCRIPT PLACEHOLDER START ]-->
  <script type="text/javascript" src="/template/Tpl_2016/jscripts/common.js"></script>
  <script type="text/javascript" src="/template/Tpl_2016/jscripts/menu.js"></script>
  <!--[ SCRIPT PLACEHOLDER END ]-->

<script>
$(function(){
		$.post("/noedit/ajax.asp","act=getmyyeweuinfo",function(data){
				if(data.result==200)
				{

					var obj=data.datas
					for(var key in obj)
					{
						for(var item in obj[key])
						{
							var hzarray=new Array("_sum","_exp30","_exp")

							for(var hz=0;hz<hzarray.length;hz++)
							{

								$("."+item+hzarray[hz]).text(obj[key][item][hz]);
							}
						}

					}
				}
			},"json")

	})
</script>


  <!-- IE6 PNG 支持 -->
  <!--[if ie 6 ]><script src="/template/Tpl_2016/jscripts/dd_belatedpng_0.0.8a-min.js"></script> <script type="text/javascript"> $(function () { DD_belatedPNG.fix('.pngFix'); }); </script> <![endif]-->
  <!-- IE6 PNG 结束 -->

 

    </body>
</html>
