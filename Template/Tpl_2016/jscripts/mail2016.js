var mail = {

    init: function() {

        var self = this;
        // ����������
        $(".sec-banner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            effect: 'fold',
            switchLoad:'_bgimg',
            switchLoadTag:'a',
            autoPage: true,
            autoPlay: true
        });

        WJF.uiTool.initTab("J_mailTabDom", {
            activeCls: 'guide-active',
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                if (currentContentID == 'J_mail_3') {
                    $("#J_mailFaq").addClass('collapse-faq');
                    $("#J_mailLeft").addClass('expand-left');
                } else {
                    $("#J_mailFaq").removeClass('collapse-faq');
                    $("#J_mailLeft").removeClass('expand-left');
                }
            }
        });

        // ����URL��ַ �л�tab
        var param = window.location.search.match(/[&]?tabindex=(.+)[&]?/);
        if (param) {
            $("#J_mailTabDom li").eq(param[1]).trigger('click');
        }

      

    }
}
$(function() {
    mail.init();
})
