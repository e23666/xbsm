<!-- 管理中心 左侧菜单栏样式 -->
<div class="manage_left_menu">
<div class="text-c pt-20 userimg">
<p><img src="/manager/images/2016/user-img.jpg" /></p>
<p class="mt-15 font16"><a href="/manager/"><span class="redColor"><%=session("user_name")%></span></a></p>
</div>
    <a class="leftmenu_top" href="/manager/">
        <i class="icon_manage"></i>管理中心</a>
    <div class="leftmenu_main">
        <div class="leftmenulist ywgl-leftmenulist">
            <h1 data-id="ywgl">
                <i class="icon_manage lmenu-ywgl"></i>业务管理<i class="expand-icon "></i>
            </h1>
            <ul>
                <li class="domainzk">
                    <a href="/manager/domainmanager"><em></em>域名管理</a>
                </li>

                <li>
                    <a href="/manager/sitemanager"><em></em>虚拟主机管理</a>
                </li>

                <li>
                    <a href="/manager/mailmanager"><em></em>企业邮局管理</a>
                </li>

                <li>
                    <a href="/manager/servermanager"><em></em>独立IP主机管理</a>
                </li>
				<li>
                    <a href="/manager/miniprogram"><em></em>微信小程序</a>
                </li>
                <li>
                    <a href="/manager/sqlmanager"><em></em>Mssql数据库管理</a>
                </li>
				 <li>
                    <a href="http://www.yjz.top" target="_blank"><em></em>云建站管理</a>
                </li>
			 
                <li>
                    <a href="/manager/move/movein.asp"><em></em>业务转入</a>
                </li>
                 <li>
                     <a href="/manager/move/moveout.asp"><em></em>业务转出</a>
                 </li>
                 <li>
                     <a href="/manager/Renew.asp"><em></em>最近到期业务</a>
                 </li>
                 <li>
                     <a href="/manager/domainmanager/zhuanru.asp"><em></em>域名转入查询</a>
                 </li>
                 <li>
                     <a href="http://beian.vhostgo.com/" target="_blank"><em></em>ICP网站备案</a>
                 </li>
              
				 <li>
                     <a href="/manager/domainmanager/contactinfo/"  style="color:red"><em></em>通用模板</a>
                 </li>
				  <li>
                     <a href="/manager/domainmanager/contactinfo/?tab=gh"  style="color:red"><em></em>域名模板过户</a>
                 </li>

				 <li>
                     <a href="/manager/export.asp"><em></em>导出数据</a>
                 </li>
				 
            </ul>
        </div>

        <div class="leftmenulist ">
            <h1 data-id="cwgl">
                <i class="icon_manage lmenu-cwgl"></i>财务管理<i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/useraccount/mlist.asp"><em></em>财务明细</a>
                </li>
                <li>
                    <a href="/manager/onlinePay/onlinePay.asp"><em></em>在线支付</a>
                </li>
                <li>
                    <a href="/manager/useraccount/fapiao.asp"><em></em>发票索取</a>
                </li>
                <li>
                    <a href="/manager/useraccount/VFaPiao.asp"><em></em>发票查询</a>
                </li>
                <li>
                    <a href="/manager/useraccount/payend.asp"><em></em>汇款确认</a>
                </li>
                <li>
                    <a href="/manager/useraccount/ViewPayEnd.asp"><em></em>汇款查询</a>
                </li>
            </ul>
        </div>

        <div class="leftmenulist ">
            <h1 data-id="zhgl">
                <i class="icon_manage lmenu-zhgl"></i>账号管理<i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/usermanager/default2.asp"><em></em>修改资料</a>
                </li>
                <li>
                    <a href="/manager/productall/default.asp"><em></em>产品价格</a>
                </li>
                <li>
                    <a href="/manager/usermanager/userlog.asp"><em></em>登录日志</a>
                </li>
				 <%if session("isauthmobile")&""<>"1" then%>
				 <li>
                    <a href="/manager/usermanager/renzheng.asp"><em></em>手机验证</a>
                </li>
				<%end if%>
            </ul>
        </div>

<div class="leftmenulist ">
            <h1 data-id="dlsgl">
                <i class="icon_manage lmenu-dlsgl"></i>代理商管理 <i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/vcp/vcp_index.asp"><em></em>VCP业务管理</a>
                </li>
                <li>
                    <a href="/manager/vcp/vcp_Vuser.asp"><em></em>我的VCP用户</a>
                </li>
                <li>
                    <a href="/manager/vcp/settleList.asp"><em></em>VCP打款明细</a>
                </li>
                 <li>
                     <a href="/manager/vcp/royalty.asp"><em></em>VCP利润明细</a>
                 </li>
                 <li>
                     <a href="/manager/vcp/vcp_Edit.asp"><em></em>修改VCP资料</a>
                 </li>
                 <li>
                     <a href="/manager/vcp/newGetADS.asp?code=u"><em></em>VCP广告代码</a>
                 </li>
                 <li>
                     <a href="/manager/usermanager/APIconfig.asp"><em></em>API接口配置</a>
                 </li>
 <li>
                     <a href="/manager/move/moveset.asp"><em></em>业务转移设置</a>
                 </li>
            </ul>
        </div>
<div class="leftmenulist ">
            <h1 data-id="bzzx">
                <i class="icon_manage lmenu-bzzx"></i>帮助中心 <i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/faq"><em></em>常见问题FAQ</a>
                </li>
                <li>
                    <a href="/manager/question/subquestion.asp"><em></em>有问必答</a>
                </li>
                <li>
                    <a href="/manager/question/allquestion.asp?module=search&qtype=myall"><em></em>问题处理跟踪</a>
                </li>
                 <li>
                     <a href="/customercenter/"><em></em>客服中心</a>
                 </li>

            </ul>
        </div>

    </div>
</div>
<script>
    $(".domainzk").hover(function () {
        $(this).addClass('hover');
        var menuTop = $(this).offset().top - 102;

        var minTop = 102 + 50;
        var itemsList = $(this).children(".sec_cd");
        var itemsCount = itemsList.find('.sec_icon').length;
        // 默认情况下 箭头居中
        var minusTop = Math.floor((itemsCount*40+10 - 36)/2);
        var subMenuTop = menuTop  - minusTop;
        if(subMenuTop<50){
            subMenuTop = 50;
        }
        itemsList.find('.blank').css('top',menuTop-subMenuTop+(36-21)/2);
        itemsList.css("top", subMenuTop).fadeIn("fast");
    }, function () {
        $(".sec_cd").hide();
        $(".ms_right").hide();
        $(".ms_right").eq(0).show();
        $(this).removeClass('hover');
    });

    var currentLeftMenuList = null;
    $(".leftmenulist h1").click(function () {
        var me = this;
        var _this = $(this);
        if (currentLeftMenuList && currentLeftMenuList != this) {
            $(currentLeftMenuList).siblings("ul").slideToggle(200);

            $(currentLeftMenuList).removeClass('current');
        }
        _this.siblings("ul").slideToggle(200, function () {
            if (!$(this).is(":hidden")) {
                _this.addClass("current");
                currentLeftMenuList = me;
            } else {
                _this.removeClass("current");
                currentLeftMenuList = null;
            }
        });
        var leftMenuID = _this.attr('data-id');
        var date = new Date();
        date.setTime(date.getTime() + (30 * 24 * 60 * 60 * 1000));
        document.cookie = '_m_menuid_='+leftMenuID+';expires=' + date.toUTCString() + ';path=/;';
    })

    var autofn = new function () {
        var isfound = false;
        $(".leftmenulist>ul li a").each(function () {
            var ipage = document.title.split('|')[0];
            var flag = $(this).attr("tag") == ipage;
            if (!flag)
                flag = $(this).text() == ipage;
            if (flag) {
                $(this).addClass("linkcur"); //选中
                currentLeftMenuList = $(this).parents("ul").show().siblings("h1").addClass("current")[0]; //加号
                isfound = true;
            }
        })
        if (!isfound) {
            var lastManagerMenuId = document.cookie.match(/_m_menuid_=([^;]+);?/);
            if(lastManagerMenuId){
                currentLeftMenuList = $('.leftmenulist h1[data-id="'+lastManagerMenuId[1]+'"]').addClass('current');
                currentLeftMenuList.siblings('ul').show();
                currentLeftMenuList = currentLeftMenuList[0];
//                currentLeftMenuList = $(".leftmenulist>ul:first").show().siblings("h1").addClass("current")[0]; //加号
            }else{
                currentLeftMenuList = $(".leftmenulist>ul:first").show().siblings("h1").addClass("current")[0]; //加号
            }
        }
    };

	$(function () {
        var header2016 = document.getElementById("header2016");
        var footer2016 = document.getElementById("footer2016");
        if(!footer2016){
            return;
        }
		// 设置MainContentDIV内容区最小高度
		var contentMinHeight = document.documentElement.clientHeight - header2016.offsetHeight - footer2016.offsetHeight;
		// -1px 为容器顶部加了1px 边框
		document.getElementById("MainContentDIV").style.minHeight=(contentMinHeight-50+120) + 'px';
		// 中间内容区 高度设置最小高度 -1px 是因为加了1px top边框
        var managerRightShowDom =  $(".ManagerRightShow")[0];
//		document.getElementsByClassName('ManagerRightShow')[0].style.minHeight=(contentMinHeight-50-20-20 -1) + 'px';
		managerRightShowDom.style.minHeight=(contentMinHeight-50-20-20 -1) + 'px';
	});
</script>