<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
page_main=requesta("page_main")
If Trim(page_main)<>"" Then response.redirect(page_main)
conn.open constr%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
        <meta name="renderer" content="webkit"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <title>�û���������| <%=companyname%></title>
        <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
        <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
        <link rel="stylesheet" href="/manager/css/2016/manager-new.css?t=20161223">
        <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

    </head>
    <body>
 <!--#include virtual="/manager/top.asp" -->
 <!--#include virtual="/manager/rengzheng.asp" -->
            <div id="MainContentDIV">

   <%
		sql="select [notice] from systemvar"
		rs1.open sql,conn,1,1
		if not rs1.eof then info=rs1("notice")
		rs1.close
		if info&""<>"" then%>
        <div style="margin:5px 10px; padding:5px; background-color:#FFFF99;font-size:14px;color:#FF0000">
          <div style="float:left; width:auto;font-weight:bold; color:#000">�����¼�֪ͨ��</div>
          <marquee scrolldelay="120" style="display:block; float:left; width:550px;">
          <%=info%>
          </marquee>
          <div style="clear:both"></div>
        </div>
        <%end if%>


                <!-- ����� -->
<!--#include virtual="/manager/manageleft.asp" -->

                <!--�Ҳ������� ��ʼ-->
                <div id="ManagerRight" class="ManagerRightShow">

                    <!--��һ���˻���Ϣ ��ʼ-->
                    <div class="manager-top cl">
                        <!--�˺���Ϣ ��ʼ-->
                        <div class="mt-left">
                            <div class="mt-info">
                                <div class="mt-info-title">
                                    <a href="/manager/usermanager/default2.asp" style="color:#1999ef"><%=session("user_name")%></a>����ӭ����
                                    <label>���ļ����ǣ�<span><%=session("u_level")%></span>
									<%if session("priusername")<>"" then%>
										<a style="font-size:14px; color:#06c" href="<%=InstallDir%>manager/whoami.asp?module=returnme">��ԭ���:<%= session("priusername") %></a>
										<%end if%>
                                    </label>
									
									<label>
										<%
										if   issetauthmobile then 
											if session("priusername")="" then
												if session("isauthmobile")  then%>
												<font class="ml-20 common-btn" style="background-color: green"  >�ֻ��Ѿ���֤</font>
												<%else%>
												<a class="ml-20 common-btn" href="usermanager/renzheng.asp" color="red">�ֻ�δ��֤</a>
										<%		end if
											end if
										end if
										%>
									</label>

                                </div>
                                <div class="mt-info-txt">
                                    <div class="mt-info-left">
                                       <span class="font16">��ʹ�ý�� = <strong class="redColor"><%=session("u_usemoney")%></strong>Ԫ + <strong class="redColor"><%=session("u_premoney")%></strong>Ԫ (�Ż�ȯ)</span><a class="ml-20 common-btn" href="/customercenter/howpay.asp">�˻���ֵ</a>
                                    </div>

                                </div>

                            </div>
                            <div class="mt-money">
                                <div class="mt-10">
                                   <a href="/manager/useraccount/fapiao.asp" class="kj-link"><i class="manager-icon-bg icon-position1"></i>��Ʊ��ȡ</a><a href="/manager/useraccount/mlist.asp" class="kj-link"><i class="manager-icon-bg icon-position2"></i>������ϸ</a><a href="/manager/question/subquestion.asp" class="kj-link"><i class="manager-icon-bg icon-position3"></i>��Ҫ����</a><a href="/manager/question/allquestion.asp?module=search&qtype=myall" class="kj-link"><i class="manager-icon-bg icon-position5"></i>�鿴�ظ�</a><a href="/faq" class="kj-link"><i class="manager-icon-bg icon-position4"></i>��������</a>
                                </div>
                            </div>
                        </div>
                        <!--�˺���Ϣ ����-->
                        <!--�������� ��ʼ-->
                        <div class="mt-news" >
                            <div class="mt-news-title">
                                <a class="item active" href="/news2/default.asp" target="_blank">�������� <span></span></a>


                            </div>
                            <!--��������-->
                            <ul class="mt-news-list">
<%
			  sql="select top 5 * from news order by newsid desc"
			  rs.open sql,conn,1,3
			  if not rs.eof then
			  do while not rs.eof
			  %>
                <li><a href="<%=InstallDir%>news/list.asp?newsid=<%=rs("newsid")%>" target="_blank"><%= left(rs("newstitle"),18) %></a><span><%=formatdatetime(rs("newpubtime"),2)%></span></li>
                <%
			  rs.movenext
			  loop
			  else
			  %>
                <li><a href="#">��������</a><span class="time"></span></li>
                <%
			  end if
			  rs.close
			  %>
                            </ul>


                        </div>
                        <!--�������� ����-->
                    </div>
                    <!--��һ���˻���Ϣ ����-->
                    <!--�ڶ��㳣������ ��ʼ-->
                    <div class="manager-link" id="J_managerLink">
                        <ul class="ml-list cl">
                            <li>
                                <a class="item" href="/manager/domainmanager" target="_blank">
                                    <i class="item-icon item-position1"></i>
                                    <span>��������</span>
                                </a>
                            </li>
                            <li>
                                <a class="item" href="/manager/sitemanager" target="_blank" data-minwidth="180">
                                    <i class="item-icon item-position2"></i>
                                    <span>������������</span>
                                </a>
                            </li>
                            <li class="mid-last-li">
                                <a class="item" href="/manager/mailmanager">
                                     <i class="item-icon item-position3"></i>
                                     <span>�ʾֹ���</span>
                                </a>
                            </li>
							<li>
                                <a class="item" href="/customercenter/howpay.asp" >
                                    <i class="item-icon item-position4"></i>
                                    <span>��ֵԤ����</span>
                                </a>
                            </li>
                            <li>
                                <a class="item" href="/manager/usermanager/default2.asp" target="_blank">
                                    <i class="item-icon item-position5"></i>
                                    <span>���������޸�</span>
                                </a>
                            </li>
                            <li class="last-li">
                                <a class="item" href="http://www.myhostadmin.net/" target="_blank">
                                    <i class="item-icon item-position6"></i>
                                    <span>�����������</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <!--�ڶ��㳣������ ����-->
                    <!--�������Ʒ����� ��ʼ-->
                    <div class="manager-product">
                        <div class="mp-title">
                            <span>�ҵĲ�Ʒ�����</span>
                        </div>
                        <table class="mp-info">
                            <thead>
                                <tr>
                                    <th>�ҵ�ҵ��</th>
                                    <th>ӵ������</th>
                                    <th>30���ڵ�������</th>
                                    <th>�Ѿ�����</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="left">
                                        <a class="mp-info-rt" href="/manager/domainmanager">����</a>
                                    </td>
                                    <td>
                                        <a  href="/manager/domainmanager">
                                            <b class="domain_sum">-</b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=30&act=domain">
                                            <b class="domain_exp30">-</b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=-1&act=domain">
                                            <b class="domain_exp">-</b>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        <a class="mp-info-rt" href="/manager/sitemanager">��������</a>
                                    </td>
                                    <td>
                                        <a  href="/manager/sitemanager">
                                            <b class="vhost_sum"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=30&act=vhost">
                                            <b class="vhost_exp30"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=-1&act=vhost">
                                            <b class="vhost_exp"></b>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        <a class="mp-info-rt" href="/manager/servermanager">������</a>
                                    </td>
                                    <td>
                                        <a  href="/manager/servermanager">
                                            <b class="server_sum"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=30&act=server">
                                            <b class="server_exp30"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=-1&act=server">
                                            <b class="server_exp"></b>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        <a class="mp-info-rt" href="/manager/mailmanager">��ҵ�ʾ�</a>
                                    </td>
                                    <td>
                                        <a  href="/manager/mailmanager">
                                            <b class="mail_sum"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=30&act=mail">
                                            <b class="mail_exp30"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=-1&act=mail">
                                            <b class="mail_exp"></b>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="left">
                                        <a class="mp-info-rt" href="/manager/sqlmanager">���ݿ�</a>
                                    </td>
                                    <td>
                                        <a  href="/manager/sqlmanager">
                                            <b class="db_sum"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=30&act=db">
                                            <b class="db_exp30"></b>
                                        </a>
                                    </td>
                                    <td>
                                        <a  href="/manager/Renew.asp?eday=-1&act=db">
                                            <b class="db_exp"></b>
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!--�������Ʒ����� ����-->


                </div>
                <!--�Ҳ������� ����-->
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
