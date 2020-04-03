<link rel="stylesheet" href="/template/Tpl_2016/css/default-color.css">
<!--[if lte IE 7]>

<div class="browser-notice" id="J_browserNotice">
    <div class="wide1190 pos-r">
        <p class="notice-content">您的浏览器版本太低，为推动浏览器W3C标准及更好的用户体验，本站强烈建议您升级到支持HTML5的浏览器，获取更好的用户体验。</p><i class="close"></i>
    </div>
</div>

<![endif]-->
<!-- 低版本响应式支持-->
<!--[if lt ie 9 ]> <script type="text/javascript" src="/template/Tpl_2016/jscripts/jresponsed.js"></script> <![endif]-->
<div id="header2016">

    <!--测试页面-->
    <!-- 最顶部导航条 -->
    <div class="headerTop">
        <div class="wide1190 cl headerTop-content">
            <ul class="topnav">
                <!-- 购物车 开始-->
                <li class="shopping-menu-container common-dropdown-container">
                    <a href="/bagshow/" class="menu shoppingcar va-m" rel="nofollow">
                        <b class="b2 va-m"></b>购物车&nbsp;
                        <span class="orangeColor va-m top_shopcar_count" >0</span>
                        <i class="trangle-icon va-m"></i>
                        <i class="va-m-assistant"></i>
                    </a>
                    <div class="shopping-car-container common-dropdown hide">
                        <div class="shopping-car-box">
                            <h3>
                                <span>我的购物车</span>
                            </h3>
                            <table class="shopping-car-list">

                            </table>
                        </div>
                        <div class="shopping-car-bottom">
                            <div>
                                共
                                <span class="shopping-num top_shopcar_count" >0</span>
                                件商品，共计
                                <span class="price top_shopcar_sum">0</span>
                            </div>
                            <a class="shopping-car-btn" href="/bagshow/">去购物车结算</a>
                        </div>
                    </div>
                </li>
                <!-- 购物车 结束-->
                <li class="pos-r common-dropdown-container">


                    <a href="/news/?act=top" class="news-notice menu"><span>最新公告&nbsp;</span>
                        <i class="trangle-icon"></i>
                        <i class="va-m-assistant"></i>
                    </a>
                    <div class="topnav-notice common-dropdown" id="topnav-notice">
                        <p id='noread_countbox'>未读消息 :<span class="allread_notice"></span> <span class="notice_all_bg">&nbsp;</span><a class="count_noread_all" href="/news/?act=top"></a><span class='ignore_notice' onclick='ignore_notice()'>忽略</span></p>
                        <ol class="txtList cl">
                            <li><em>&nbsp;</em> <a href="/news/list.asp?newsid=677" class="text-overflow" target="_blank">[新产品发布] DDoS高防服务上线</a>
                                <span class="newsDate">2016-09-07</span></li>
                        </ol>
                        <p class="notice_all_content"><a href="/news/?act=top" onclick="ignore_notice()">查看全部</a></p>
                    </div>
                    <script>var nav_top_json=[{"id":677,"day":"7"},{"id":676,"day":"20"},{"id":675,"day":"29"},{"id":674,"day":"30"}]</script>
                </li>
                <li><a href="/customercenter/" class="menu link-menu" >帮助中心</a></li>


            </ul>
            <div class="login-left welcome-manager">
				<style>
				.gray-link {
    display: inline-block;
    width: 50px;
    height: 26px;
    line-height: 26px;
    text-align: center;
    background-color: #52555a;
    border-radius: 3px;
	color: #fff;
}
				</style>


         <div id="TitleLoginOk">
		<%
		managerurl=newInstallDir & "/manager"'用户管理中心地址
		If session("u_type")<>"0" Then
			managerurl=SystemAdminPath
		End If
		%>
		您好:&nbsp;<a href="<%=managerurl%>" class="link"><%=session("user_name")%></a>&nbsp;&nbsp;&nbsp;
		您的级别是:&nbsp;<span class="redColor"><%=session("u_level")%></span>  &nbsp;&nbsp;&nbsp;<a href="<%=managerurl%>" class="link">管理中心</a>
		<a href="/signout.asp" class="gray-link ml-15">退 出</a>
		</div>
            </div>
        </div>
    </div><!-- 导航菜单栏-->
    <div class="header-nav">
        <div class="wide1190 cl header-nav-content">
<div class="header-pos">
            <a class="logo" href="/" title=""><img src="<%=logimgPath%>"   /></a>
            <ul class="main-nav-wrapper cl" id="J_mainNavWrapper">
                <li>
                    <a href="/" class="nav-menu" id="J_mainMenu_sy">首页</a>
                </li>
                <li>
                    <a href="/services/domain/" class="nav-menu" id="J_mainMenu_ymzc">域名注册</a>
                </li>
                <li>
                    <a href="/services/webhosting/" class="nav-menu" id="J_mainMenu_xnzj">虚拟主机</a>
                </li>
                <li>
                    <a href="/services/cloudhost/" class="nav-menu" id="J_mainMenu_yfwq">云服务器</a>
                </li>
                <li>
                    <a href="/services/vpsserver/" class="nav-menu" id="J_mainMenu_vps">VPS主机</a>
                </li>
                <li>
                    <a href="/services/server/" class="nav-menu" id="J_mainMenu_zjzy">主机租用</a>
                </li>
                <li>
                    <a href="/services/sites/" class="nav-menu" id="J_mainMenu_yjz">云建站</a>
               </li>
                   <li>
                    <a href="/services/miniprogram/" class="nav-menu" id="J_mainMenu_yjz">小程序</a>
               </li>
                <li>
                    <a href="/services/webhosting/sites.asp" class="nav-menu" id="J_mainMenu_cpwz">成品网站</a>
                </li>
                <li>
                    <a href="/services/mail/" class="nav-menu" id="J_mainMenu_qyyj">企业邮局</a>
                </li>
                <li>
                    <a href="/agent/" class="nav-menu" id="J_mainMenu_dlzq">代理专区</a>
                </li>
            </ul>
</div>
        </div>

    </div>
</div>