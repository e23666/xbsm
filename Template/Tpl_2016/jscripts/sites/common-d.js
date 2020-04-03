var siteUtil = {
    initTab: function (tabId, opts) {
        opts = opts || {};
        // 默认情况下tab标签 激活使用过的className
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
            // 移除前一个选中内容
            $("#" + currentActiveContentId).removeClass(tabContentActiveCls);
            currentActiveTab.removeClass(tabActiveCls);
            prevActiveTab = currentActiveTab;

            currentActiveTab = $(this);
            currentActiveTab.removeClass(tabActiveCls).addClass(tabActiveCls);

            var clickTabContentId = currentActiveTab.attr('data-target');
            $("#" + clickTabContentId).removeClass(tabContentActiveCls).addClass(tabContentActiveCls);

            // 点击回调 tab Id ,当前选中TAB ID 前一个TAB ID
            if (clickTabContentId != currentActiveContentId) {
                // tab父容器ID 用于区分是哪个tab父容器
                // 当前激活的tab下li容器
                // 前一个激活的tab下li容器
                // 当前激活的内容区域ID
                // 前一个激活的的容器 ID
                // 当前激活的标签对象
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
     * 通用购买操作
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
                // 使用全局地址
                url: opts.choiceTargetUrl || SITES_BUY_CONFIG.choiceTargetUrl,
                type: 'get',
                data: data,
                dataType: 'json',
                success: function (data) {
                    var msg = data.message || '未知错误';
                    if (data.status == '0') {
                        layer.error("购买失败：" + decodeURIComponent(msg));
                        return;
                    }
                    if (opts.success) {
                        opts.success(data);
                    } else {
                        window.location.href = data.url;
                    }
                },
                error: function (a, b, c) {
                    layer.error('购买失败，请稍后重试！');
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
     * 模板预览页的购买操作
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