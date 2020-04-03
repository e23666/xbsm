var siteUtil = {
    initTab: function (tabId, opts) {
        opts = opts || {};
        // Ĭ�������tab��ǩ ����ʹ�ù���className
        var tabActiveCls = opts.tabActiveCls || 'active';
        var tabContentActiveCls = opts.tabContentActiveCls || 'active';
        var tabs = $("#" + tabId);
        var currentActiveTab = tabs.find('li.' + tabActiveCls);
        var currentActiveContentId = currentActiveTab.attr('data-target');
        var prevActiveTab = null;
        $("#" + currentActiveContentId).removeClass(tabContentActiveCls).addClass(tabContentActiveCls);
        tabs.on('click', 'li', function (event) {
            if (opts.onBeforeChange && opts.onBeforeChange.call($(this), tabId, $(this), event) === false) {
                return;
            }
            // �Ƴ�ǰһ��ѡ������
            $("#" + currentActiveContentId).removeClass(tabContentActiveCls);
            currentActiveTab.removeClass(tabActiveCls);
            prevActiveTab = currentActiveTab;

            currentActiveTab = $(this);
            currentActiveTab.removeClass(tabActiveCls).addClass(tabActiveCls);

            var clickTabContentId = currentActiveTab.attr('data-target');
            $("#" + clickTabContentId).removeClass(tabContentActiveCls).addClass(tabContentActiveCls);

            // ����ص� tab Id ,��ǰѡ��TAB ID ǰһ��TAB ID
            if (clickTabContentId != currentActiveContentId) {
                // tab������ID �����������ĸ�tab������
                // ��ǰ�����tab��li����
                // ǰһ�������tab��li����
                // ��ǰ�������������ID
                // ǰһ������ĵ����� ID
                // ��ǰ����ı�ǩ����
                // tabId, currentActiveTab, prevActiveTab, currentTabContentId, prevTabContentId
                opts.onTabChange && opts.onTabChange({
                    tabId: tabId,
                    currentActiveTab: currentActiveTab,
                    prevActiveTab: prevActiveTab,
                    currentTabContentId: clickTabContentId,
                    prevTabContentId: currentActiveContentId
                });
            }
            currentActiveContentId = clickTabContentId;
        });
    },
    /**
     * ͨ�ù������
     * @param params
     * @param opts
     */
    commonBuy: function (params, opts) {
        islogin(function () {
            opts = opts || {};
            var loadingId = layer.load(2);
            var data = $.extend(params, opts.data);
            opts.onBeforeBuy && opts.onBeforeBuy(data);
            $.ajax({
                // ʹ��ȫ�ֵ�ַ
                url: opts.choiceTargetUrl || SITES_BUY_CONFIG.choiceTargetUrl,
                type: 'get',
                data: data,
                dataType: 'json',
                success: function (data) {
                    var msg = data.message || 'δ֪����';
                    if (data.status == '0') {
                        layer.error("����ʧ�ܣ�" + decodeURIComponent(msg));
                        return;
                    }
                    if (opts.success) {
                        opts.success(data);
                    } else {
                        window.location.href = data.url;
                    }
                },
                error: function (a, b, c) {
                    layer.error('����ʧ�ܣ����Ժ����ԣ�');
                    opts.error && opts.error(a, b, c);
                },
                complete: function () {
                    layer.close(loadingId);
                    opts.complete && opts.complete();
                }
            });
        })
    },

    /**
     * ģ��Ԥ��ҳ�Ĺ������
     * @param params
     * @param opts
     */
    commonBuy2: function (params, opts) {
        opts = opts || {};
        var data = $.extend(params, opts.data);
        opts.onBeforeBuy && opts.onBeforeBuy(data);
        var url = SITES_BUY_CONFIG.directTargetUrl;
        var queryString = "?";
        for(var i in data){
            queryString = queryString+i+"="+data[i]+"&";
        }
        queryString = queryString.substring(0,queryString.length-1);
        //console.log(queryString);return false;
        location.href = url+queryString;
    }
}