<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
act=requesta("act")
if act="sureexport" then
conn.open constr
	types=requesta("types")
	filetype=requesta("filetype")
	if instr(",domain,server,vhost,mail,db,",","&types&",")=0 or instr(",csv,txt,",","&filetype&",")=0 then call url_return("��������",1)
	Response.Clear()
	Response.Buffer = true
	Response.AddHeader "Content-Disposition","attachment; filename="&types&"_"&date()&"."&filetype 
	Response.CharSet = "iso-8859-1" '�ļ�����
	Response.ContentType = "application/octet-stream"  
	select case trim(types)
	case "vhost"
		sql="select  s_comment as FTP��,s_serverIP as �ϴ���ַ,(s_comment+'.'+s_serverName) as ���Ե�ַ,s_productid as ��Ʒ�ͺ�,s_buydate as ����ʱ��,s_expiredate as ����ʱ��,s_ftppassword as ftp���� from vhhostlist where S_ownerid="&session("u_sysid")
	case "domain"
		sql="select strDomain as ����,proid as �ͺ�,strdomainpwd as ����,regdate as ��ͨʱ��,rexpiredate as ����ʱ��,years as  ע������,dns_host1 as dns1,dns_host2 as dns2 from domainlist where userid="&session("u_sysid")
	case "mail"
		sql="select m_bindname as �ʾ�����,m_mastername as �����ʺ�,m_password as ��������,m_productId as �ͺ�, m_serverip as ������ip,m_size as ��С,m_buydate as ����ʱ��,m_years as ����  from mailsitelist where m_ownerid="&session("u_sysid")
	case "server"
		If not isdbsql Then
			sql="select AllocateIP as ������ip,StartTime as ��ͨʱ��,DateAdd("&PE_DatePart_D&",iif(isnull(preday),0,preday),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime)) as ����ʱ��,RamdomPass as ��������,addedServer as ��ֵ����,p_proid as ��Ʒ�ͺ� from hostrental where u_name='"&session("user_name")&"'"
		else
			sql="select AllocateIP as ������ip,StartTime as ��ͨʱ��,DateAdd("&PE_DatePart_D&",isnull(preday,0),DateAdd("&PE_DatePart_M&",AlreadyPay,starttime)) as ����ʱ��,RamdomPass as ��������,addedServer as ��ֵ����,p_proid as ��Ʒ�ͺ� from hostrental where u_name='"&session("user_name")&"'"
		end if
	case "db"
		sql="select dbname as ���ݿ���,dbloguser as ��½�ʺ�,dbpasswd  as ��½����,dbbuydate as ����ʱ��,dbexpdate as ������־,dbyear as ����,dbproid as �ͺ�,dbserverip as ������ip from databaselist where dbserverip<>'-1' and dbu_id="&session("u_sysid")
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
        <title>ҵ�񵼳�����| <%=companyname%></title>
        <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
        <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
        <link rel="stylesheet" href="/manager/css/2016/manager-new.css?t=20161223">
        <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

    </head>
    <body>
 <!--#include virtual="/manager/top.asp" -->
            <div id="MainContentDIV">
				<!--#include virtual="/manager/manageleft.asp" -->

                <!--�Ҳ������� ��ʼ-->
                <div id="ManagerRight" class="ManagerRightShow">
                	<div id="SiteMapPath">
                         <ul>
                           <li><a href="/">��ҳ</a></li>
                           <li><a href="/Manager/">��������</a></li>
                           <li>ҵ�񵼳�</li>
                         </ul>
                   </div>

				   <div class="manager-right-bg">
                   <form name="form1" method="post" action="export.asp">
                        <table class="manager-table">
                            <tbody>
                            	<tr><th colspan=2>ҵ�����ݵ���</th></tr>
                                <tr bgcolor="#ffffff">
                                    <th align="right" nowrap="" class="tdbg">ҵ������:</th>
                                    <td   nowrap="" bgcolor="#ffffff" class="tdbg" align="left">
                                    	<input type="radio" value="vhost" name="types" checked id="types_vhost"><lable for="types_vhost">��������</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    	<input type="radio" value="domain" name="types" id="types_domain"><lable for="types_domain">����</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="server" name="types" id="types_server"> <lable for="types_server">������</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="mail" name="types" id="types_mail"> <lable for="types_mail">�ʾ�</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="db" name="types" id="types_db"> <lable for="types_db">���ݿ�</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                	<th  align="right" nowrap="" class="tdbg">��������:</th>
                                    <td  nowrap="" bgcolor="#ffffff" class="tdbg" align="left">
                                    	<input type="radio" value="txt" name="filetype" checked id="file_txt"><lable for="file_txt">TXT</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                       <input type="radio" value="csv" name="filetype" id="file_csv" > <lable  for="file_csv">CSV</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr><th colspan=2>
                                <input type="hidden" name="act" value="sureexport">
                                <input type="submit" name="serarchsubmit" value="��������" class="manager-btn s-btn"></th></tr>
                            </tbody>
                        </table>
                   </form>
                   
                   
                   </div>


                </div>
  
            </div>
            <!-- END MainContentDIV -->
            <!-- ҳ�� -->

<!-- ��������ҳ��  ʹ�õļ򵥰汾ҳ�� -->
  <!--#include virtual="/manager/bottom.asp" -->


  <!-- ҳ��ͨ�ù������ -->
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


  <!-- IE6 PNG ֧�� -->
  <!--[if ie 6 ]><script src="/template/Tpl_2016/jscripts/dd_belatedpng_0.0.8a-min.js"></script> <script type="text/javascript"> $(function () { DD_belatedPNG.fix('.pngFix'); }); </script> <![endif]-->
  <!-- IE6 PNG ���� -->

 

    </body>
</html>
