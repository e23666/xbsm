$(function () {
        //联系方式
        $("#J_dxHostingCaseActSlide").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            autoPage: true,
            autoPlay: true,
            interTime: 4000,
            effect: "leftLoop",
            vis: 5,
            scroll: 5
        });
        $('.J-scroll').on('click', function () {
            var target = $(this).attr('data-target');
            var targetTop = 0;
            if (target == "top") {
                targetTop = 0;
            } else {
                targetTop = $("#" + target).offset().top;
            }
            $('html, body').animate({
                scrollTop: targetTop
            }, '300');
            //浮动导航切换
            if (!$(this).hasClass("active")) {
                $(this).addClass("active");
                $(this).parent().siblings().find("a").removeClass("active");
            }
        });
        // 初始化tab
        WJF.uiTool.initTab("J_dxHostingConfigTab", {
            onTabChange: function (tabId, currentLiDom, currentContentID, prevContentId, prevActiveTabLink, currentActiveTabLink) {
                if (prevActiveTabLink) {
                    prevActiveTabLink.parent('li').removeClass('active');
                }
                currentActiveTabLink.parent('li').addClass('active');
            }
        });
        //浮动导航
        var anchorNav = $("#J_anchorNavDom");
        $(window).scroll(function (event) {
            var scrollHeight = $(window).scrollTop();
            if (scrollHeight >= 1240) {
                if (!anchorNav.hasClass('wjf-page-anchor-nav-container-fixed')) {
                    anchorNav.addClass('wjf-page-anchor-nav-container-fixed');
                }
            } else {
                anchorNav.removeClass('wjf-page-anchor-nav-container-fixed');
            }
        });
        var timeoutHandle = null;
        $(window).resize(function () {
            clearTimeout(timeoutHandle);
            timeoutHandle = setTimeout(function () {
                $(window).trigger('scroll');
            }, 200);
        });
        $(window).trigger('scroll');
        function getFormData(formDom) {
            var formData = $(formDom).serializeArray();
            var formMap = {};
            for (var i = 0, len = formData.length; i < len; i++) {
                var item = formData[i];
                formMap[item.name] = item.value;
            }
            return formMap;
        }

        $(".J-op").on('click', function (event) {
            var target = $(event.target);
            var formData = getFormData(target.parents('form:first'));
            window.location.href='/services/webhosting/buy.asp?productid='+formData.roomType;
        });

    });
     
