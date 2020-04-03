var webhosting = {
    initBanner: function() {
        $(".sec-banner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            effect: 'fold',
            // ����ͼƬ����
            switchLoad: '_bgimg',
            // ����ͼƬ����
            switchLoadTag: 'a',
            autoPage: true,
            autoPlay: true
        });
    },
    bindScroll: function() {
        var anchorNav = $("#J_anchorNavDom");
        $(window).scroll(function(event) {
            if ($(window).scrollTop() >= $("#J_tabContentContainer").offset().top) {
                if (!anchorNav.hasClass('wjf-page-anchor-nav-container-fixed')) {
                    anchorNav.addClass('wjf-page-anchor-nav-container-fixed');
                }
            } else {
                anchorNav.removeClass('wjf-page-anchor-nav-container-fixed');
            }
        });
        $(window).trigger('scroll');
    },
    // ҳ���ʼ��
    init: function() {
        var self = this;
        this.initBanner();
        // ��ʼ��tab
        WJF.uiTool.initTab("J_webhostingTab", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId, prevActiveTabLink, currentActiveTabLink) {
                if (prevActiveTabLink) {
                    prevActiveTabLink.parent('li').removeClass('active');
                }
                currentActiveTabLink.parent('li').addClass('active');
            }
        });
        $('#J_webhostingTabContainer').on('mouseover', '.webhosting-list li', function(event) {
            if (!$(this).hasClass('column-li-hover')) {
                $(this).addClass('column-li-hover');
            }
        }).on('mouseleave', '.webhosting-list li', function() {
            $(this).removeClass('column-li-hover');
        });
        WJF.uiTool.initTab("J_anchorNavDom", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                if (currentContentID == 'J_webPJDom') {
                    // ����Ѿ�����
                    if (self.hasFetchPJInfo) {
                        return;
                    }
                    self.loadGuestTalk(1, function(flag) {
                        if (!flag) {
                            self.hasFetchPJInfo = false;
                        }
                    });
                }
                var targetTop = $("#J_tabContentContainer").offset().top;
                if ($(window).scrollTop() >= targetTop) {
                    $(window).scrollTop(targetTop);
                }
            }
        });
        this.bindScroll();

        // ����URL��ַ �л�tab
        var param = window.location.search.match(/[&]?index=(.+)[&]?/);
        if (param) {
            $("#J_webhostingTab li").eq(param[1]).trigger('click');
        }
    }
}

$(function() {
    webhosting.init();
})
