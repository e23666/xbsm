<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
id=requesta("id")
If Not isnumeric(id&"")  Then id=0
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-云建站管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
 
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
			   <li>域名管理</li>
			 </ul>
		  </div>

             
<div class="panel">
                    <div class="panel-title"><span class="txt">站点详细信息</span></div>
                    <div class="panel-content">
				<table class="manager-table">
					<tr>
						<th width=15% align="right">站点类型：</th>
						<td id="zdlx" width="35%"></td>
						<th width="15%" align="right">CNAME解析：</th>
						<td id="cnamejx"  width="35%"></td>
					</tr>
					<tr>
						<th align="right">测试地址：</th>
						<td></td>
						<th align="right">备案码：</th>
						<td></td>
					</tr>

				</table>
 
                        <div class="product-detail-desc mt-30">
                            <div class="title">
                                <span>温馨提示</span>
                            </div>
                            <ol class="pdd-list">
                                <li>
                                    网站模板更换后，不会立即生效，一般24小时之内生效。
                                </li>
                                <li>
                                    登录独立管理后台修改了网站管理名称或者管理密码后，请点击“刷新”按钮重新获取一下数据。
                                </li>
                                <li>
                                    若发现页面站点信息有误，请点击“刷新”按钮重新获取一下最新数据。
                                </li>
                                <li>
                                    微小店建站类型不能更换模板，且使用的模板为特殊模板，该模板id无法在模板列表中查询到。
                                </li>
                                <li>
                                    “增购模板”列出的为当前建站已经购买的精品模板id列表，仅能用于当前站点，不能用于您的其它站点。
                                </li>
                                <li>
                                    模板功能分为：基础功能型，标准功能型，营销功能型，等级依次增高，低等级的建站产品不能使用高等级的模板。
                                </li>
                            </ol>
                        </div>
                    </div>
                </div>






 
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>