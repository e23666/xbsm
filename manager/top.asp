<link rel="stylesheet" href="/template/Tpl_2016/css/default-color.css">
<!--[if lte IE 7]>

<div class="browser-notice" id="J_browserNotice">
    <div class="wide1190 pos-r">
        <p class="notice-content">����������汾̫�ͣ�Ϊ�ƶ������W3C��׼�����õ��û����飬��վǿ�ҽ�����������֧��HTML5�����������ȡ���õ��û����顣</p><i class="close"></i>
    </div>
</div>

<![endif]-->
<!-- �Ͱ汾��Ӧʽ֧��-->
<!--[if lt ie 9 ]> <script type="text/javascript" src="/template/Tpl_2016/jscripts/jresponsed.js"></script> <![endif]-->
<div id="header2016">

    <!--����ҳ��-->
    <!-- ��������� -->
    <div class="headerTop">
        <div class="wide1190 cl headerTop-content">
            <ul class="topnav">
                <!-- ���ﳵ ��ʼ-->
                <li class="shopping-menu-container common-dropdown-container">
                    <a href="/bagshow/" class="menu shoppingcar va-m" rel="nofollow">
                        <b class="b2 va-m"></b>���ﳵ&nbsp;
                        <span class="orangeColor va-m top_shopcar_count" >0</span>
                        <i class="trangle-icon va-m"></i>
                        <i class="va-m-assistant"></i>
                    </a>
                    <div class="shopping-car-container common-dropdown hide">
                        <div class="shopping-car-box">
                            <h3>
                                <span>�ҵĹ��ﳵ</span>
                            </h3>
                            <table class="shopping-car-list">

                            </table>
                        </div>
                        <div class="shopping-car-bottom">
                            <div>
                                ��
                                <span class="shopping-num top_shopcar_count" >0</span>
                                ����Ʒ������
                                <span class="price top_shopcar_sum">0</span>
                            </div>
                            <a class="shopping-car-btn" href="/bagshow/">ȥ���ﳵ����</a>
                        </div>
                    </div>
                </li>
                <!-- ���ﳵ ����-->
                <li class="pos-r common-dropdown-container">


                    <a href="/news/?act=top" class="news-notice menu"><span>���¹���&nbsp;</span>
                        <i class="trangle-icon"></i>
                        <i class="va-m-assistant"></i>
                    </a>
                    <div class="topnav-notice common-dropdown" id="topnav-notice">
                        <p id='noread_countbox'>δ����Ϣ :<span class="allread_notice"></span> <span class="notice_all_bg">&nbsp;</span><a class="count_noread_all" href="/news/?act=top"></a><span class='ignore_notice' onclick='ignore_notice()'>����</span></p>
                        <ol class="txtList cl">
                            <li><em>&nbsp;</em> <a href="/news/list.asp?newsid=677" class="text-overflow" target="_blank">[�²�Ʒ����] DDoS�߷���������</a>
                                <span class="newsDate">2016-09-07</span></li>
                        </ol>
                        <p class="notice_all_content"><a href="/news/?act=top" onclick="ignore_notice()">�鿴ȫ��</a></p>
                    </div>
                    <script>var nav_top_json=[{"id":677,"day":"7"},{"id":676,"day":"20"},{"id":675,"day":"29"},{"id":674,"day":"30"}]</script>
                </li>
                <li><a href="/customercenter/" class="menu link-menu" >��������</a></li>


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
		managerurl=newInstallDir & "/manager"'�û��������ĵ�ַ
		If session("u_type")<>"0" Then
			managerurl=SystemAdminPath
		End If
		%>
		����:&nbsp;<a href="<%=managerurl%>" class="link"><%=session("user_name")%></a>&nbsp;&nbsp;&nbsp;
		���ļ�����:&nbsp;<span class="redColor"><%=session("u_level")%></span>  &nbsp;&nbsp;&nbsp;<a href="<%=managerurl%>" class="link">��������</a>
		<a href="/signout.asp" class="gray-link ml-15">�� ��</a>
		</div>
            </div>
        </div>
    </div><!-- �����˵���-->
    <div class="header-nav">
        <div class="wide1190 cl header-nav-content">
<div class="header-pos">
            <a class="logo" href="/" title=""><img src="<%=logimgPath%>"   /></a>
            <ul class="main-nav-wrapper cl" id="J_mainNavWrapper">
                <li>
                    <a href="/" class="nav-menu" id="J_mainMenu_sy">��ҳ</a>
                </li>
                <li>
                    <a href="/services/domain/" class="nav-menu" id="J_mainMenu_ymzc">����ע��</a>
                </li>
                <li>
                    <a href="/services/webhosting/" class="nav-menu" id="J_mainMenu_xnzj">��������</a>
                </li>
                <li>
                    <a href="/services/cloudhost/" class="nav-menu" id="J_mainMenu_yfwq">�Ʒ�����</a>
                </li>
                <li>
                    <a href="/services/vpsserver/" class="nav-menu" id="J_mainMenu_vps">VPS����</a>
                </li>
                <li>
                    <a href="/services/server/" class="nav-menu" id="J_mainMenu_zjzy">��������</a>
                </li>
                <li>
                    <a href="/services/sites/" class="nav-menu" id="J_mainMenu_yjz">�ƽ�վ</a>
               </li>
                   <li>
                    <a href="/services/miniprogram/" class="nav-menu" id="J_mainMenu_yjz">С����</a>
               </li>
                <li>
                    <a href="/services/webhosting/sites.asp" class="nav-menu" id="J_mainMenu_cpwz">��Ʒ��վ</a>
                </li>
                <li>
                    <a href="/services/mail/" class="nav-menu" id="J_mainMenu_qyyj">��ҵ�ʾ�</a>
                </li>
                <li>
                    <a href="/agent/" class="nav-menu" id="J_mainMenu_dlzq">����ר��</a>
                </li>
            </ul>
</div>
        </div>

    </div>
</div>