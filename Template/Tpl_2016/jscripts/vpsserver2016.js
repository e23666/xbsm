if (typeof(console) == 'undefined') {
    console = {
        log: function() {

        }
    }
}
var vpsServer = {
    // ���̡��ڴ� ��С���� === ��ʱʹ�þ�ֵ̬
    dataConfig: {
        // 26��·
        diskSizeMap: {
            "vps001": "30",
            "vps002": "40",
            "vps003": "50",
            "vps000": "20"
        },
        diskSizeSMap: {
            "vps001": "60",
            "vps002": "80",
            "vps003": "100",
            "vps000": "40"
        },
        ramSizeMap: {
            'vps001': "1 GB ECC",
            "vps002": "1.5 GB ECC",
            "vps003": "2 GB ECC",
            "vps000": "512 MB ECC"
        },
        ramSizeSMap: {
            "vps001": "2 GB ECC",
            "vps002": "3 GB ECC",
            "vps003": "4 GB ECC",
            "vps000": "1 GB ECC"
        }
    },
    bindScroll: function() {
        var anchorNav = $("#J_anchorNavDom");
        $(window).scroll(function(event) {
            var scrollHeight = $(window).scrollTop();
            if (scrollHeight >= 1680) {
                if (!anchorNav.hasClass('wjf-page-anchor-nav-container-fixed')) {
                    anchorNav.addClass('wjf-page-anchor-nav-container-fixed');
                }
            } else {
                anchorNav.removeClass('wjf-page-anchor-nav-container-fixed');
            }
        });
        $(function() {
            $(window).trigger('scroll');
        });
    },
    init: function() {
        var self = this;
        $("#J_vpsBanner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            effect: 'fold',
            switchLoad:'_bgimg',
            switchLoadTag:'a',
            autoPage: true,
            autoPlay: true
        });
        // ��ʼ��tab
        WJF.uiTool.initTab("J_anchorNavDom", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                // return
                if (currentContentID == 'J_vpsPJDom') {
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
                if ($(window).scrollTop() >= 1680) {
                    $(window).scrollTop(1680);
                }
            }
        });
        var id_suffix = ['000', '001', '002', '003'];
        for (var i = 0, len = id_suffix.length; i < len; i++) {
            var suffix = id_suffix[i];
            var domId = 'J_vps' + suffix + '_roomsDom';
            var defaultValue = $("#"+domId).attr('data-value')||1;
            new WJF.ui.select({
                dom: 'J_vps' + suffix + '_roomsDom',
                width: 231,
                defaultValue: +defaultValue,
                selectContainerSelector: '#J_vps' + suffix + '_containerDom',
                onSelect: (function(suffix) {
                    var ajaxXHR = null;
                    return function(value, desc, item) {
                        ajaxXHR && ajaxXHR.abort();
                        // ==================
                        var objU = document.getElementById('J_vps_btn_' + suffix);
                        var url = objU.href;
                        var Kname = 'vr_room';
                        var Kval = value;
                        var ss = "/\\b" + Kname + "=[^&=]+/";
                        var oCheck = eval(ss);
                        if (oCheck.test(url)) {
                            url = url.replace(oCheck, Kname + "=" + escape(Kval));
                        } else {
                            url += "&" + Kname + "=" + escape(Kval);
                        }
                        objU.href = url;
                        // ==================

                        // ������Ӧ�Ĵ�����Ϣ��
                        ajaxXHR = $.ajax({
                            url: '/services/vpsserver/default.asp',
                            type: 'post',
                            data: {
                                act: 'ServBand',
                                proid: 'vps' + suffix,
                                serverRoom: value
                            },
                            success: function(msg) {
                                msg = msg.split("|");
                                // ����
                                $("#radio_vps" + suffix + "_flux").html(msg[0]);
                                // IP
                                $("#radio_vps" + suffix + "_IP").html(msg[1]);

                                // ===== ���̴�С���ڴ��С ��ʱʹ�ù̶�ֵ

                                // ���̴�С
								/*
                                var diskSizeDesc;
                                if (value != '26') {
                                    var diskSize = self.dataConfig.diskSizeSMap['vps' + suffix];
                                    diskSizeDesc = diskSize + "G SASӲ��+" + diskSize + "G SATA(���ܱ���)";
                                } else {
                                    var diskSize = self.dataConfig.diskSizeMap['vps' + suffix];
                                    diskSizeDesc = diskSize + "G SASӲ��";
                                }
								*/
								var diskSize = self.dataConfig.diskSizeSMap['vps' + suffix];
                                diskSizeDesc = diskSize + "G SASӲ��+" + diskSize + "G SATA(���ܱ���)";
                                $("#radio_vps" + suffix + "_disk").html(diskSizeDesc);

                                // �ڴ�
                                var ramSizeDesc =self.dataConfig.ramSizeSMap['vps' + suffix]; //value != '26' ? self.dataConfig.ramSizeSMap['vps' + suffix] : self.dataConfig.ramSizeMap['vps' + suffix];
                                $("#radio_vps" + suffix + "_ram").html(ramSizeDesc);
                            }
                        });
                        // �л��۸�
                        $("#J_vpsromprice_vps" + suffix + "_container").find('div.ppl').hide();
                        $("#vpsromprice_vps" + suffix + "_" + item.attr('data-index')).show();
                    };
                })(suffix)
            });
        }

        // ��ťhoverЧ��
        $("#J_vpsListDom li.vps-item").mouseover(function(event) {
            if (!$(this).hasClass('vps-item-hover')) {
                $(this).addClass('vps-item-hover');
            }
        }).mouseout(function(event) {
            $(this).removeClass('vps-item-hover');
        });;

        this.bindScroll();
    }
}
$(function() {
    vpsServer.init();
})
