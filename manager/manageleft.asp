<!-- �������� ���˵�����ʽ -->
<div class="manage_left_menu">
<div class="text-c pt-20 userimg">
<p><img src="/manager/images/2016/user-img.jpg" /></p>
<p class="mt-15 font16"><a href="/manager/"><span class="redColor"><%=session("user_name")%></span></a></p>
</div>
    <a class="leftmenu_top" href="/manager/">
        <i class="icon_manage"></i>��������</a>
    <div class="leftmenu_main">
        <div class="leftmenulist ywgl-leftmenulist">
            <h1 data-id="ywgl">
                <i class="icon_manage lmenu-ywgl"></i>ҵ�����<i class="expand-icon "></i>
            </h1>
            <ul>
                <li class="domainzk">
                    <a href="/manager/domainmanager"><em></em>��������</a>
                </li>

                <li>
                    <a href="/manager/sitemanager"><em></em>������������</a>
                </li>

                <li>
                    <a href="/manager/mailmanager"><em></em>��ҵ�ʾֹ���</a>
                </li>

                <li>
                    <a href="/manager/servermanager"><em></em>����IP��������</a>
                </li>
				<li>
                    <a href="/manager/miniprogram"><em></em>΢��С����</a>
                </li>
                <li>
                    <a href="/manager/sqlmanager"><em></em>Mssql���ݿ����</a>
                </li>
				 <li>
                    <a href="http://www.yjz.top" target="_blank"><em></em>�ƽ�վ����</a>
                </li>
			 
                <li>
                    <a href="/manager/move/movein.asp"><em></em>ҵ��ת��</a>
                </li>
                 <li>
                     <a href="/manager/move/moveout.asp"><em></em>ҵ��ת��</a>
                 </li>
                 <li>
                     <a href="/manager/Renew.asp"><em></em>�������ҵ��</a>
                 </li>
                 <li>
                     <a href="/manager/domainmanager/zhuanru.asp"><em></em>����ת���ѯ</a>
                 </li>
                 <li>
                     <a href="http://beian.vhostgo.com/" target="_blank"><em></em>ICP��վ����</a>
                 </li>
              
				 <li>
                     <a href="/manager/domainmanager/contactinfo/"  style="color:red"><em></em>ͨ��ģ��</a>
                 </li>
				  <li>
                     <a href="/manager/domainmanager/contactinfo/?tab=gh"  style="color:red"><em></em>����ģ�����</a>
                 </li>

				 <li>
                     <a href="/manager/export.asp"><em></em>��������</a>
                 </li>
				 
            </ul>
        </div>

        <div class="leftmenulist ">
            <h1 data-id="cwgl">
                <i class="icon_manage lmenu-cwgl"></i>�������<i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/useraccount/mlist.asp"><em></em>������ϸ</a>
                </li>
                <li>
                    <a href="/manager/onlinePay/onlinePay.asp"><em></em>����֧��</a>
                </li>
                <li>
                    <a href="/manager/useraccount/fapiao.asp"><em></em>��Ʊ��ȡ</a>
                </li>
                <li>
                    <a href="/manager/useraccount/VFaPiao.asp"><em></em>��Ʊ��ѯ</a>
                </li>
                <li>
                    <a href="/manager/useraccount/payend.asp"><em></em>���ȷ��</a>
                </li>
                <li>
                    <a href="/manager/useraccount/ViewPayEnd.asp"><em></em>����ѯ</a>
                </li>
            </ul>
        </div>

        <div class="leftmenulist ">
            <h1 data-id="zhgl">
                <i class="icon_manage lmenu-zhgl"></i>�˺Ź���<i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/usermanager/default2.asp"><em></em>�޸�����</a>
                </li>
                <li>
                    <a href="/manager/productall/default.asp"><em></em>��Ʒ�۸�</a>
                </li>
                <li>
                    <a href="/manager/usermanager/userlog.asp"><em></em>��¼��־</a>
                </li>
				 <%if session("isauthmobile")&""<>"1" then%>
				 <li>
                    <a href="/manager/usermanager/renzheng.asp"><em></em>�ֻ���֤</a>
                </li>
				<%end if%>
            </ul>
        </div>

<div class="leftmenulist ">
            <h1 data-id="dlsgl">
                <i class="icon_manage lmenu-dlsgl"></i>�����̹��� <i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/manager/vcp/vcp_index.asp"><em></em>VCPҵ�����</a>
                </li>
                <li>
                    <a href="/manager/vcp/vcp_Vuser.asp"><em></em>�ҵ�VCP�û�</a>
                </li>
                <li>
                    <a href="/manager/vcp/settleList.asp"><em></em>VCP�����ϸ</a>
                </li>
                 <li>
                     <a href="/manager/vcp/royalty.asp"><em></em>VCP������ϸ</a>
                 </li>
                 <li>
                     <a href="/manager/vcp/vcp_Edit.asp"><em></em>�޸�VCP����</a>
                 </li>
                 <li>
                     <a href="/manager/vcp/newGetADS.asp?code=u"><em></em>VCP������</a>
                 </li>
                 <li>
                     <a href="/manager/usermanager/APIconfig.asp"><em></em>API�ӿ�����</a>
                 </li>
 <li>
                     <a href="/manager/move/moveset.asp"><em></em>ҵ��ת������</a>
                 </li>
            </ul>
        </div>
<div class="leftmenulist ">
            <h1 data-id="bzzx">
                <i class="icon_manage lmenu-bzzx"></i>�������� <i class="expand-icon "></i>
            </h1>
            <ul>
                <li>
                    <a href="/faq"><em></em>��������FAQ</a>
                </li>
                <li>
                    <a href="/manager/question/subquestion.asp"><em></em>���ʱش�</a>
                </li>
                <li>
                    <a href="/manager/question/allquestion.asp?module=search&qtype=myall"><em></em>���⴦�����</a>
                </li>
                 <li>
                     <a href="/customercenter/"><em></em>�ͷ�����</a>
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
        // Ĭ������� ��ͷ����
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
                $(this).addClass("linkcur"); //ѡ��
                currentLeftMenuList = $(this).parents("ul").show().siblings("h1").addClass("current")[0]; //�Ӻ�
                isfound = true;
            }
        })
        if (!isfound) {
            var lastManagerMenuId = document.cookie.match(/_m_menuid_=([^;]+);?/);
            if(lastManagerMenuId){
                currentLeftMenuList = $('.leftmenulist h1[data-id="'+lastManagerMenuId[1]+'"]').addClass('current');
                currentLeftMenuList.siblings('ul').show();
                currentLeftMenuList = currentLeftMenuList[0];
//                currentLeftMenuList = $(".leftmenulist>ul:first").show().siblings("h1").addClass("current")[0]; //�Ӻ�
            }else{
                currentLeftMenuList = $(".leftmenulist>ul:first").show().siblings("h1").addClass("current")[0]; //�Ӻ�
            }
        }
    };

	$(function () {
        var header2016 = document.getElementById("header2016");
        var footer2016 = document.getElementById("footer2016");
        if(!footer2016){
            return;
        }
		// ����MainContentDIV��������С�߶�
		var contentMinHeight = document.documentElement.clientHeight - header2016.offsetHeight - footer2016.offsetHeight;
		// -1px Ϊ������������1px �߿�
		document.getElementById("MainContentDIV").style.minHeight=(contentMinHeight-50+120) + 'px';
		// �м������� �߶�������С�߶� -1px ����Ϊ����1px top�߿�
        var managerRightShowDom =  $(".ManagerRightShow")[0];
//		document.getElementsByClassName('ManagerRightShow')[0].style.minHeight=(contentMinHeight-50-20-20 -1) + 'px';
		managerRightShowDom.style.minHeight=(contentMinHeight-50-20-20 -1) + 'px';
	});
</script>