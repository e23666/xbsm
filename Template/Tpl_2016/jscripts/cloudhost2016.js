/**
 * ��������:
 * 1. ���� ����ѡ���̨
 * 2. �������ݶ�̬
 * @type {Object}
 */
var cloudhost = {
    // �����������
    dataConfig: {
        cpucount: 6,
        ramcount: 12, // ��ͬ������ ramIndexCountMap.length - 1
        paytimestr: paytimestr,
        // Ӳ�̴�С��Χ
        dataMin: 50,
        dataMax: 1000,
        // ����Χ
        fluxMin: 0,
        fluxMax: 100,
        // �������� ���ݱ� url type���ζ�Ӧ��������
        defaultConfigTypeMapping: {
            shangwu: 'business',
            tejia: 'basic',
            biaozhun: 'standard'
        },
        // Ĭ���������� ������
        defaultConfigType: 'business',
        // CPU �±��ӦCPU����
        cpuIndexCountMap: [-1, 1, 2, 4, 8, 12, 16],
        ramIndexCountMap: [-1, 0.5, 1, 2, 3, 4, 6, 8, 12, 16, 32, 64, 128]
    },

    // �Ƽ�����  cpu ram Ϊindex
    recomandConfig: {
        'basic': {
            title: "������",
            content: {
                cpu: 2,
                ram: 2,
                data: 60,
                flux: 2
            }
        },
        'standard': {
            title: "��׼��",
            content: {
                cpu: 2,
                ram: 3,
                data: 80,
                flux: 3
            }
        },
        'business': {
            title: "������",
            content: {
                cpu: 3,
                ram: 5,
                data: 100,
                flux: 4
            }
        },
        'comfortable': {
            title: "������",
            content: {
                cpu: 3,
                ram: 5,
                data: 200,
                flux: 5
            }
        },
        'enterprise': {
            title: "��ҵ��",
            content: {
                cpu: 4,
                ram: 7,
                data: 300,
                flux: 8
            }
        },
        'luxury': {
            title: "������",
            content: {
                cpu: 5,
                ram: 8,
                data: 500,
                flux: 10
            }
        }
    },
    // Ĭ��ѡ������ü��û�ѡ������
    serverConfig: {
        // ����
        cpu: 3,
        // ����
        ram: 5,
        // ֵ
        data: 100,
        // ֵ
        flux: 4,
        // ����ϵͳ�汾
        // CHOICE_OS: 'win',
        // ��·
        room: 37,
        // �洢ģʽ
        disktype: 'ebs',
        // �����׼
        servicetype: '��������ͭ�Ʒ���',
        // ����ʱ��
        renewTime: 1,
        // ��������
        buycount: 1,
        // �Ƿ�ͬ��
        agreement: 1,
        // ��ȺID Ĭ��Ϊ�� ��ʾ �������
        setebsid: '',
        // ���û��߹��� ��Ϊ���ֶ�
        act: 'buysub'
            // ����Ϊ0  ����Ϊ1
            // paytype: 0

    },
    initBanner: function() {
        $("#J_cloudhostBanner").slide({
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
    // 1. ȫ��tab ����
    // 2. ���� fixed
    bindScroll: function() {

        var anchorNav = $("#J_anchorNavDom");
        var fixedConfigContainer = $("#J_currentConfigDom");
        $(window).scroll(function(event) {
            var scrollHeight = $(window).scrollTop();
            if (scrollHeight >= 1895) {
                if (!anchorNav.hasClass('wjf-page-anchor-nav-container-fixed')) {
                    anchorNav.addClass('wjf-page-anchor-nav-container-fixed');
                }
                // �Ƴ��̶������嵥
                fixedConfigContainer.removeClass('current-config-fixed');
            } else {
                anchorNav.removeClass('wjf-page-anchor-nav-container-fixed');
            }
            // �����嵥 fixed��λ
            if (scrollHeight >= 590 && scrollHeight < 1115) {
                // fixedConfigContainer.addClass('current-config-fixed').css('right', $("#J_cloudhostTabDom").offset().left + 'px');
                fixedConfigContainer.addClass('current-config-fixed').css('left', ($("#J_txHostDom").offset().left + $("#J_txHostDom .tx-host").width() + 2) + 'px');
                fixedConfigContainer.removeClass('current-config-absolute');
            } else if (scrollHeight >= 1115) {
                // �����嵥 ���Զ�λ
                fixedConfigContainer.removeClass('current-config-fixed');
                fixedConfigContainer.addClass('current-config-absolute').css('right', '0px');
                fixedConfigContainer.addClass('current-config-absolute').css('left', 'auto');
            } else {
                // �����嵥 Ĭ��״̬
                fixedConfigContainer.removeClass('current-config-fixed current-config-absolute');
            }
        });
        $(function() {
            $(window).trigger('scroll');
        });
        var timeoutHandle = null;
        $(window).resize(function() {
            clearTimeout(timeoutHandle);
            timeoutHandle = setTimeout(function() {
                $(window).trigger('scroll');
            }, 200);
        });

    },
    // ������Tab ��ʼ��
    initCloudHostTab: function() {
        var self = this;

        // �Ƽ�����
        var defaultRecomandConfig = $('#J_tuijianBtnsDom a[data-value="' + this.dataConfig.defaultConfigType + '"]').addClass('active');
        // ���·��������ò���
        this.updateServerConfig(this.dataConfig.defaultConfigType);
        // ע������ѡ�����¼�
        $("#J_tuijianBtnsDom").on('click', 'a', function() {
            var target = $(this);
            var configType = target.attr('data-value');
            if (configType == defaultRecomandConfig.attr('data-value')) {
                return;
            }
            defaultRecomandConfig.removeClass('active');
            defaultRecomandConfig = target;
            defaultRecomandConfig.addClass('active');
            // ��ʼ������
            self.initConfig(defaultRecomandConfig.attr('data-value'));
        });

        // CPU
        $("#cpuRange").rangeinput({
            step: 1,
            min: 1,
            max: this.dataConfig.cpucount,
            speed: 200,
            // value: 3,
            value: this.serverConfig.cpu,
            progress: true
        }).change(function(event, value) {
            self.serverConfig.cpu = value;
            $("#cpuCount").html(self.dataConfig.cpuIndexCountMap[+value] + '��');
            if (value == 1) {
                $("#J_cpuLowTip").addClass('low-config-tip-visible');
            } else {
                $("#J_cpuLowTip").removeClass('low-config-tip-visible');
            }
            // ���µ�ǰ����
            self.updateView({
                // clearRecomandItem:true
            });
        });
        this.cpuRangeSlide = $("#cpuRange").data('rangeinput');

        // ����������Ϣ�¼�
        $("#J_cpuRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.cpuRangeSlide.setValue(index);
            // ��������ص�
            $("#cpuRange").trigger('change', index);
        });

        // �ڴ�
        $("#ramRange").rangeinput({
            speed: 200,
            step: 1,
            min: 1,
            max: this.dataConfig.ramcount,
            // value: 5,
            value: this.serverConfig.ram,
            progress: true
        }).change(function(event, value) {
            self.serverConfig.ram = value;
            $("#ramCount").html(self.dataConfig.ramIndexCountMap[+value] + 'G');
            if (value == 1) {
                $("#J_ramLowTip").addClass('low-config-tip-visible');
            } else {
                $("#J_ramLowTip").removeClass('low-config-tip-visible');
            }
            // ���µ�ǰ����
            self.updateView({
                // clearRecomandItem:true
            });
        });
        this.ramRangeSlide = $("#ramRange").data('rangeinput');
        // ����������Ϣ�¼�
        $("#J_ramRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.ramRangeSlide.setValue(index);
            // ��������ص�
            $("#ramRange").trigger('change', index);
        });


        // Ӳ��
        $("#dataRange").rangeinput({
            speed: 200,
            step: 10,
            min: this.dataConfig.dataMin,
            max: this.dataConfig.dataMax,
            // value: 100,
            value: this.serverConfig.data,
            progress: true
        }).change(function(event, value) {
            // ����������봥��ʱ  valueΪundefined
            if (typeof(value) == 'undefined') {
                value = +event.target.value;
            }
            // ����У�� ����������� ������Ϊ��һ�ε�ֵ
            if (!/^[-+]?\d+$/.test(value)) {
                // ��ԭΪ��һ�ε�ֵ
                self.dataRangeSlide.setValue(self.serverConfig.data);
                return;
            }
            // ������Χ����Ϊ�߽�
            if (value < self.dataConfig.dataMin) {
                value = self.dataConfig.dataMin;
            } else if (value > self.dataConfig.dataMax) {
                value = self.dataConfig.dataMax;
            }
            // ��������10��������
            value = value % 10 ? (Math.floor(value / 10) + 1) * 10 : value;
            self.serverConfig.data = value;
            // �ò��� �ڵ��ʱ  �ظ�
            self.dataRangeSlide.setValue(value);
            // ���µ�ǰ����
            self.updateView();
        });
        this.dataRangeSlide = $("#dataRange").data('rangeinput');
        // ����������Ϣ�¼�
        $("#J_dataRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.dataRangeSlide.setValue(index);
            $("#dataRange").trigger('change', index);
        });

        // ����
        $("#fluxRange").rangeinput({
            speed: 200,
            step: 1,
            min: this.dataConfig.fluxMin,
            max: this.dataConfig.fluxMax,
            // value: 4,
            value: this.serverConfig.flux,
            progress: true
        }).change(function(event, value) {
            // ������򴥷�ʱ valueΪundefined
            if (typeof(value) == 'undefined') {
                value = +event.target.value;
            }
            // �ж������Ƿ�Ϊ�Ϸ�����
            if (!/^[-+]?\d+$/.test(value)) {
                // ��ԭΪ��һ�ε�ֵ
                self.fluxRangeSlide.setValue(self.serverConfig.flux);
                return;
            }
            // ������Χ����Ϊ�߽�
            if (value < self.dataConfig.fluxMin) {
                value = self.dataConfig.fluxMin;
            } else if (value > self.dataConfig.fluxMax) {
                value = self.dataConfig.fluxMax;
            }
            self.serverConfig.flux = value;
            if (value == 0) {
                $("#J_fluxLowTip").addClass('low-config-tip-visible');
            } else {
                $("#J_fluxLowTip").removeClass('low-config-tip-visible');
            }
            // �ò��� �ڵ��ʱ  �ظ�
            self.fluxRangeSlide.setValue(value);
            // ���µ�ǰ����
            self.updateView();
        });
        this.fluxRangeSlide = $("#fluxRange").data('rangeinput');

        $("#J_fluxRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.fluxRangeSlide.setValue(index);
            $("#fluxRange").trigger('change', index);
        });


        // +- ����

        $(".config-modify").css('visibility', 'visible').on('click', function() {

            var target = $(this);
            var isMinus = target.hasClass('config-minus');
            var type = target.attr('data-target');

            switch (type) {
                case 'cpu':
                    if (isMinus) {
                        self.serverConfig.cpu--;
                    } else {
                        self.serverConfig.cpu++;
                    }
                    if (self.serverConfig.cpu < 1) {
                        self.serverConfig.cpu = 1;
                        return;
                    }
                    if (self.serverConfig.cpu > self.dataConfig.cpucount) {
                        self.serverConfig.cpu = self.dataConfig.cpucount;
                        return;
                    }
                    self.cpuRangeSlide.setValue(self.serverConfig.cpu);
                    $("#cpuRange").trigger('change', self.serverConfig.cpu);
                    break;
                case 'ram':
                    if (isMinus) {
                        self.serverConfig.ram--;
                    } else {
                        self.serverConfig.ram++;
                    }
                    if (self.serverConfig.ram < 1) {
                        self.serverConfig.ram = 1;
                        return;
                    }
                    if (self.serverConfig.ram > self.dataConfig.ramcount) {
                        self.serverConfig.ram = self.dataConfig.ramcount;
                        return;
                    }
                    self.ramRangeSlide.setValue(self.serverConfig.ram);
                    $("#ramRange").trigger('change', self.serverConfig.ram);
                    break;
                case 'data':
                    if (isMinus) {
                        self.serverConfig.data -= 10;
                    } else {
                        self.serverConfig.data += 10;
                    }
                    if (self.serverConfig.data < self.dataConfig.dataMin) {
                        self.serverConfig.data = self.dataConfig.dataMin;
                        return;
                    }
                    if (self.serverConfig.data > self.dataConfig.dataMax) {
                        self.serverConfig.data = self.dataConfig.dataMax;
                        return;
                    }
                    self.dataRangeSlide.setValue(self.serverConfig.data);
                    $("#dataRange").trigger('change', self.serverConfig.data);
                    break;
                case 'flux':
                    if (isMinus) {
                        self.serverConfig.flux--;
                    } else {
                        self.serverConfig.flux++;
                    }
                    if (self.serverConfig.flux < self.dataConfig.fluxMin) {
                        self.serverConfig.flux = self.dataConfig.fluxMin;
                        return;
                    }
                    if (self.serverConfig.flux > self.dataConfig.fluxMax) {
                        self.serverConfig.flux = self.dataConfig.fluxMax;
                        return;
                    }
                    self.fluxRangeSlide.setValue(self.serverConfig.flux);
                    $("#fluxRange").trigger('change', self.serverConfig.flux);
                    break;
            }

        });
        // �������ʼ������ʾ ����ʼ��������ʾ
        $(".config-count").add($('.range')).css('visibility', 'visible');
        // ����ϵͳ����
        this.systemSubType = new WJF.ui.select({
            dom: 'systemSubTypeDom',
            width: 400,
            selectContainerSelector: '#systemSubTypeContainer',
            selContainerMaxHeight: 380,
            onSelect: function(value, desc, item) {
                // console.log(value + ',' + desc);
                self.serverConfig['CHOICE_OS'] = value;
                // �Զ���OS �޸���·
                if (value.substr(0, 7) == "diy_os_") {
                    $.post("/services/CloudHost/", "act=getdiyos&CHOICE_OS=" + escape(value), function(roomid) {
                        if (roomid != "") {
                            $("#J_roomsContainerDom").find('span').each(function() {
                                var currentItem = $(this);
                                var val = currentItem.attr('data-value');
                                // ��·IDƥ�� ��ȡ������
                                if (roomid.indexOf(val) >= 0) {
                                    currentItem.removeClass('disabled');
                                    currentItem.addClass('active');
                                    self.serverConfig.room = val;
                                } else {
                                    // ��ƥ�� ��ȡ����ǰ��ѡ��
                                    currentItem.removeClass('active');
                                    if (username != "west263") {
                                        currentItem.addClass('disabled');
                                    }
                                }
                            });
                            self.updateView();
                        }
                    });
                }
                // ���µ�ǰ����
                setTimeout(function() {
                    self.updateView();
                }, 0);
            }
        });
        var isInitStatus = true;
        // ����ϵͳ����
        var OSTYPE = [{
            value: 'window',
            desc: 'windows'
        }, {
            value: 'linux',
            desc: 'linux'
        }, {
            value: 'linux_west_slb',
            desc: '���ؾ���'
        }];
        if ($("#customSubItems li").length > 1) {
            OSTYPE.push({
                value: 'custom',
                desc: '�Զ���'
            });
        }
        this.systemType = new WJF.ui.select({
            dom: 'systemTypeDom',
            // �����Ĭ�Ͽ��
            width: 142,
            selContainerH: 'auto',
            defaultValue: 'window',
            data: OSTYPE,
            onSelect: function(value, desc) {
                switch (value) {
                    case 'window':
                        self.systemSubType.enable();
                        $("#systemSubTypeContainer").html($("#windowSubItems").html());
                        self.systemSubType.selectItem();
                        !isInitStatus && self.systemSubType.expandItems();
                        break;
                    case 'linux':
                        self.systemSubType.enable();
                        $("#systemSubTypeContainer").html($("#linuxSubItems").html());
                        self.systemSubType.selectItem();
                        !isInitStatus && self.systemSubType.expandItems();
                        break;
                    case 'linux_west_slb':
                        $("#systemSubTypeContainer").html('<li class="item" data-value="">��ѡ����ذ汾</li>');
                        self.systemSubType.disable();
                        self.systemSubType.selectItem();

                        // ����ϵͳ���� �޸�Ϊ������
                        self.serverConfig['CHOICE_OS'] = value;
                        break;
                    case 'custom':
                        // �û��Զ������ϵͳ
                        self.systemSubType.enable();
                        $("#systemSubTypeContainer").html($("#customSubItems").html());
                        self.systemSubType.selectItem();
                        !isInitStatus && self.systemSubType.expandItems();
                        break;
                }
                isInitStatus = false;
                // ��������
                setTimeout(function() {
                    self.updateView();
                }, 0);
            }
        });

        // ��·ѡ��
        var defaultRoomLink = $("#J_roomsContainerDom span.active");
        var room_ttt = null;
        $("#J_roomsContainerDom").on('click', 'span.link-btn', function(event) {
            if (!$(event.target).hasClass('link-btn')) {
                return;
            }
            var target = $(this);
            var value = target.attr('data-value');
            if (value == defaultRoomLink.attr('data-value')) {
                return;
            }
            // ��ʾ��·ѡ��
            if (useripmsg != "����" && value != 39 && value != 36) {
                clearTimeout(room_ttt);
                $("#J_roomTipDesc").fadeIn("slow");
                room_ttt = setTimeout(function() {
                    $("#J_roomTipDesc").fadeOut("slow");
                }, 10000);
            } else {
                $("#J_roomTipDesc").fadeOut("slow");
            }

            // ���ѡ����� ����GBP
            if (value == '40') {
                // ����Ҫ�� ȡ������ʾ
                // layer.confirm('<span style="font-size:14px">��ʾ���û��������ݹܿ��ϸ���Ҫʵ����֤��<a href="/services/Server/servr_room_info_hnbgp.asp" target="_blank" style="color:#06c">�����Ķ����Ҫ��</a>��<br>ȷ��ѡ��û�����</span>', {
                //     icon: 3,
                //     title: '��ܰ��ʾ'
                // }, function(index) {
                //     continueCallBack();
                //     layer.close(index);
                // });
                // return;
            }
            // DDOS ��ʾ  ���ܶ��ߡ����š����ϻ���
            if(/^(37|38|40)$/.test(value)){
                $("#J_roomDDOSTipDesc").fadeIn("slow");
            }else{
                $("#J_roomDDOSTipDesc").fadeOut("slow");
            }
            // ���� ����Ҫ��
            if ($("#fluxRange").val() == 0 && ("," + sharefluxroom + ",").indexOf("," + value + ",") >= 0) {
                layer.alert('�û�������������0M');
                return false;
            }
            continueCallBack();

            function continueCallBack() {
                defaultRoomLink.removeClass('active');
                defaultRoomLink = target;
                defaultRoomLink.addClass('active');
                // ����
                self.serverConfig.room = value;

                // ���µ�ǰ����
                self.updateView();
            }
        });
        if (useripmsg != "����") {
            var thisroomObj = $('#J_roomsContainerDom span[data-value="42"]');
            thisroomObj.trigger('click');
        }

        // DDOS ��ʾ  ���ܶ��ߡ����š����ϻ���
        if(/^(37|38|40)$/.test(defaultRoomLink.attr('data-value'))){
            $("#J_roomDDOSTipDesc").fadeIn("slow");
        }else{
            $("#J_roomDDOSTipDesc").fadeOut("slow");
        }

        // �洢ģʽ
        var defaultDiskTypeLink = $("#J_diskTypeContainerDom a.active");
        $("#J_diskTypeContainerDom").on('click', 'a.link-btn', function() {
            var target = $(this);
            var value = target.attr('data-value');
            if (value == defaultDiskTypeLink.attr('data-value')) {
                return;
            }

            // ���ѡ����ǹ�̬Ӳ��  2016/07/01 ȥ��
            // if (value == 'ssd') {
            //     layer.confirm('SSD��̬Ӳ��ģʽ�м��ߵ����IO���ܣ��۸�Ϲ��ʺ��ڴ���SQlserver���ݿ��������IO����Ҫ��ϸߵĳ�����ȷ��ѡ��SSD�洢��', {
            //         icon: 3,
            //         title: '��ܰ��ʾ'
            //     }, function(index) {
            //         continueCallBack();
            //         layer.close(index);
            //     });
            //     return;
            // }
            continueCallBack();

            function continueCallBack() {

                defaultDiskTypeLink.removeClass('active');
                defaultDiskTypeLink = target;

                defaultDiskTypeLink.addClass('active');

                // ����
                self.serverConfig.disktype = value;

                // ���µ�ǰ����
                self.updateView();
            }
        });


        // ��������
        $("#J_buyCountContainerDom").on('click', 'a', function() {
            var target = $(this);
            // ��
            if (target.hasClass('cSubtract')) {
                self.serverConfig.buycount -= 1;
                if (self.serverConfig.buycount < 1) {
                    self.serverConfig.buycount = 1;
                }
            } else if (target.hasClass('cAdd')) {
                self.serverConfig.buycount += 1;
                if (self.serverConfig.buycount > 100) {
                    self.serverConfig.buycount = 100;
                }
            }

            $("#J_buyCountDom").val(self.serverConfig.buycount);
            // ���µ�ǰ����
            self.updateView();

        })
        $("#J_buyCountDom").on('blur', function() {
            var val = $(this).val();
            if (/^\d+$/.test(val)) {
                val = +val;
            } else {
                val = 1;
            }

            if (val < 1) {
                val = 1;
            } else if (val > 100) {
                val = 100;
            }
            self.serverConfig.buycount = val;
            $("#J_buyCountDom").val(self.serverConfig.buycount);
            // ���µ�ǰ����
            self.updateView();
        });

        // ������������� ������߼�
        var buyCountTimeoutHandle = null;
        $("#J_buyCountDom").on('keydown', function(event) {
            var keyCode = event.keyCode;
            if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105) || (keyCode == 8 || keyCode == 37 || keyCode == 39)) {
                return true;
            }
            return false;
        }).blur(function(event) {
            var val = $("#J_buyCountDom").val();
            if (/^[0-9]{1,}$/.test(val)) {
                val = +val;
                if (val < 1) {
                    val = 1;
                } else if (val > 100) {
                    val = 100;
                }
            } else {
                val = 1;
            }
            $("#J_buyCountDom").val(val);
            self.updateView();
        });

        // �����׼
        var defaultServiceTypeDom = $("#J_serviceTypeContainerDom dt.active");
        $("#J_serviceTypeContainerDom").on('click', 'dt', function() {
            var target = $(this);
            var value = target.attr('data-value');
            if (value == defaultServiceTypeDom.attr('data-value')) {
                return;
            }
            defaultServiceTypeDom.removeClass('active');
            defaultServiceTypeDom = target;

            defaultServiceTypeDom.addClass('active');

            // ����
            self.serverConfig.servicetype = value;

            // ���µ�ǰ����
            self.updateView();
        });

        // ����ʱ��
        var defaultRenewTimeDt = $("#J_renewTimeContainerDom dt.active");
        $("#J_renewTimeContainerDom").on('click', 'dt', function() {
            var target = $(this);
            var value = target.attr('data-value');
            if (value == defaultRenewTimeDt.attr('data-value')) {
                return;
            }
            defaultRenewTimeDt.removeClass('active active-gift');
            defaultRenewTimeDt = target;

            defaultRenewTimeDt.addClass('active');
            if (defaultRenewTimeDt.hasClass('gift')) {
                defaultRenewTimeDt.addClass('active-gift');
            }

            // ����
            self.serverConfig.renewTime = value;

            // ���µ�ǰ����
            self.updateView();
        });
        // ��ȡ����ʱ����Ӧ���Ż�ʱ����Ϣ
        this.getpreday();

        // ����������ð�ť
        var buyBtnsContainer = $("#J_buyBtnsContainer");
        buyBtnsContainer.on('click', 'a', function() {
            if ($(this).hasClass('disabled')) {
                return;
            }
            if ($(this).hasClass('btn_buy')) {
               // self.buyCloudHost();
			   islogin(function(){self.buyCloudHost.call(self)})
            } else if ($(this).hasClass('btn_vhostupcloud')) {
                //self.buyCloudHost();
				 islogin(function(){self.buyCloudHost.call(self)})
            } else {
              //  self.tryCloudHost();
			   islogin(function(){self.tryCloudHost.call(self)})
            }
        });

        // ͬ��Э��
        $("#J_agreement_label").on('click', function(event) {
            $(this).toggleClass('checked');
            // �Ƿ�ͬ��Э��
            self.serverConfig.agreement = $(this).hasClass('checked') ? 1 : 0;
        });

        $("#J_tipInner a").on('click', function() {
            if ($('#J_tipInner').hasClass('tip-inner-expand')) {
                $('#J_tipInner').removeClass('tip-inner-expand');
                $(this).html('����>>');
            } else {
                $('#J_tipInner').addClass('tip-inner-expand');
                $(this).html('����>>');
            }
        });
        // ��ִ��һ�λص� �Ը�������UI
        this.initConfig(this.dataConfig.defaultConfigType);
        // ��Ⱦ��ǰ���������б�
        this.updateView();
    },
    getpreday: function() {
        // ����
    },
    // У�鵱ǰ�Ƿ��������û��߹���ı�׼
    // buyOrTry===true ����
    validateCloudHost: function(buyOrTry) {
        var self = this;
        // ����ϵͳ
        var s_os = this.systemSubType.getValue();
        // �����ֶξ�������
        var select_cpu_i = $("#cpuRange").val();
        var select_ram_i = $("#ramRange").val();
        var select_data = $("#dataRange").val();
        var select_flux = $("#fluxRange").val();
        var select_room = $("#J_roomsContainerDom span.active").attr('data-value');
        // ���Ϊ���ؾ��� ��δѡ�����ϵͳ
        if (s_os == ""&&this.serverConfig['CHOICE_OS']!='linux_west_slb') {
            layer.alert("��ѡ��Ҫ��װ�Ĳ���ϵͳ��");
            return false;
        }
        switch (s_os) {
            case "win":
            case "win_clean":
            case "win_64":
                if (select_ram_i < 2) {
                    layer.alert("��ʾ����ѡ��Ĳ���ϵͳ������Ҫ1G�ڴ棡�������ڴ�����Ϊ��������ϵͳ��");
                    return false;
                }
                break;
            case "win_2005":
            case "win_2008":
                if (select_ram_i < 2) {
                    layer.alert("��ʾ����ѡ��Ĳ���ϵͳ������Ҫ2G�ڴ棡�������ڴ�����Ϊ��������ϵͳ��");
                    return false;
                }
                break;
            case "win_2008_64":
            case "win_2012_clean":
                if (select_ram_i < 2) {
                    $.dialog.alert("��ʾ����ѡ��Ĳ���ϵͳ������Ҫ2G�ڴ棡�������ڴ�����Ϊ��������ϵͳ��");
                    return false;
                }
                break;
        }

        // ����
        if (buyOrTry === false) {
            if (select_cpu_i > 3 && select_room != 41) {
                layer.alert("��ʾ�����������������4��CPU");
                return false;
            }
            if (select_ram_i > 5) {
                layer.alert("��ʾ�����������������4G�ڴ�");
                return false;
            }
            if (select_data > 200) {
                layer.alert("��ʾ�����������������200GӲ��");
                return false;
            }
            if (select_flux > 10) {
                layer.alert("��ʾ�����������������10M����");
                return false;
            }
        }

        if (select_room == 41 && select_cpu_i < 0) {
            layer.alert("��ʾ:��ѡ����ǹһ�ר������,CPU���Ĳ���С��1��");
            return false;
        }
        if (select_room != 41 && select_cpu_i >= 5 && select_flux <= 2) {
            if (!confirm("���ѣ�������������ڿ��CPU�ܼ���Ӧ�ã���ѡ����·Ϊ���һ�ר����������������·������ʱ��CPU�߸���ռ�á�\n�㡰ȷ�ϡ������ύ���㡰ȡ���������޸����á�")) {
                return false;
            }
        }
        if (select_flux == 0 && ("," + sharefluxroom + ",").indexOf("," + select_room + ",") >= 0) {
            layer.alert("��ǰ��·�Ĵ���������0M");
            return false;
        }
        if (this.serverConfig.agreement) {
            // 0 ���� 1 ����
            // ����0 ����Ϊ 1
            self.serverConfig.paytype = buyOrTry ? 0 : 1;
            if (select_room == "37" || select_room == "38") {
                isSetEbsid(function() {
                    // ����������Ϣ === ��������ȡ����(ֻ�����ȺID)
                    self.updateView({
                        isFetch: false
                    });
                    // ִ���ύ��������
                    self.submitOrder(buyOrTry);
                });
            } else {
                // ����������Ϣ === ��������ȡ����(ֻ�����ȺID)
                self.updateView({
                    isFetch: false
                });
                // ִ���ύ��������
                self.submitOrder(buyOrTry);
            }

        } else {
            layer.alert("����û��ͬ������������������Э��");
            return false;
        }

        // �Ƿ�ѡ�����м�ȺID
        function isSetEbsid(fn) {
            if (username != "") {
                // ��ǰѡ���·��
                var select_room = $("#J_roomsContainerDom span.active").attr('data-value');
                $.post("/config/ebslistbox.asp", "act=issetebsid&room=" + escape(select_room), function(issetebs) {
                    // �м�ȺID
                    if (issetebs == "ok") {
                        var layerIndex = layer.open({
                            type: 1,
                            title: '��ѡ��Ҫ����ļ�Ⱥ',
                            area: '660px',
                            content: '<span class="wjf-ui-common-loading"></span>'
                        });
                        $.post("/config/ebslistbox.asp", "room=" + escape(select_room), function(data) {
                            $("#layui-layer" + layerIndex + ' .layui-layer-content').html(data);
                            dochkebs();
                            // ��ʼ�������Ⱥ
                            $("input[name='ebsbtnsub']:button").click(function() {
                                $("#J_setebsidHiddenDom").val($.trim($("input[name='ebsid']:text").val()));
                                self.serverConfig.setebsid = $.trim($("input[name='ebsid']:text").val());
                                layer.close(layerIndex);
                                if ($.isFunction(fn)) {
                                    fn.call($);
                                }
                            });
                            // �������
                            $("input[name='ebsbtnsubrnd']:button").click(function() {
                                $("#J_setebsidHiddenDom").val("");
                                self.serverConfig.setebsid ="";
                                layer.close(layerIndex);
                                if ($.isFunction(fn)) {
                                    fn.call($);
                                }
                            });
                            // ???
                            // dotitles("setebsidbox", 350, 50, 1);
                        });
                    } else {
                        fn.call($);
                    }
                });
            } else {
                fn.call($);
            }
        };

        // �󶨱�radioѡ���¼�
        function dochkebs() {
            $("input[name='chkebs']:radio").click(function() {
                var chkebs = $.trim($(this).val());
                if (/^[\w\-]{3,20}$/.test(chkebs)) {
                    $("input[name='ebsid']:text").val(chkebs);
                }
            });
        }

        return true;
    },
    // ����������
    tryCloudHost: function() {
        this.validateCloudHost(false);
    },
    // ����������
    buyCloudHost: function() {
        this.validateCloudHost(true);
    },
    // �ύ���� buyOrTry===true ����
    submitOrder: function(buyOrTry) {

        var self = this;

        // ���������
        if (!buyOrTry) {
            var index = layer.confirm($("#tryTipTpl").render({
                    paytestprice: paytestprice
                }), {
                    icon: 3,
                    title: '������֪',
                    area: '560px'
                },
                function(index) {
                    continueSubmit();
                    layer.close(index);
                },function () {
                    // ȡ�� ��ԭ��������
                    self.serverConfig.paytype=0;
                    layer.close(index);
                });
            return;
        }
        continueSubmit();

        function continueSubmit() {
            // �����ύ���� ��Ⱦform
            var doms = [];
            var data = self.serverConfig;
            for (var x in data) {
                doms.push('<input type="text" name="' + x + '" value="' + data[x] + '"/>');
            }
            $("#J_buyOrTryForm").html(doms.join(''));
            $("#J_buyOrTryForm").submit();
        }

    },
    // �����Ƽ����� ��������
    initConfig: function(configType) {
        // �������ò���
        this.updateServerConfig(configType);
        // ��������
        this.dataRangeSlide.setValue(this.serverConfig.data);
        this.fluxRangeSlide.setValue(this.serverConfig.flux);

        this.cpuRangeSlide.setValue(this.serverConfig.cpu);
        this.ramRangeSlide.setValue(this.serverConfig.ram);
        // ��������ص� ����ͬ������
        $("#cpuRange").trigger('change', this.serverConfig.cpu);
        $("#ramRange").trigger('change', this.serverConfig.ram);
    },
    // ������������  �������ò���
    updateServerConfig: function(configType) {
        // ʹ�õ���������
        var config = this.recomandConfig[configType];
        WJF.apply(this.serverConfig, config.content);
    },
    // ������Tab ��ȡ���¼۸� ��ˢ��ҳ���
    updateView: function(opts) {
        var self = this;
        opts = opts || {};
        clearTimeout(this.updateViewTimeoutHandle);
        // ȡ������������ִ�е�ajax����
        if (opts.isFetch !== false) {
            this.updatePriceXHR && this.updatePriceXHR.abort();
            this.updatePriceXHR = null;
            changeBuyStatus(false);
        }
        // ȡ�����Ƽ�����itemѡ��
        if (opts.clearRecomandItem) {
            $("#J_tuijianBtnsDom a").removeClass('active');
        }
        this.updateViewTimeoutHandle = setTimeout(function() {
            // ��Ʒ������Ϣ  ʹ��������Ϣ
            var currentConfigDesc = {
                // ��Ʒ����
                productTypeDesc: $("#J_tuijianBtnsDom a.active").text(),
                cpuCount: self.dataConfig.cpuIndexCountMap[+self.serverConfig.cpu],
                ramCount: self.dataConfig.ramIndexCountMap[+self.serverConfig.ram],
                dataCount: self.serverConfig.data,
                fluxCount: self.serverConfig.flux,

                // ����ϵͳ
                CHOICE_OSDesc: $("#systemSubTypeDom").text(),

                // ��·
                roomDesc: $("#J_roomsContainerDom span.active").attr('data-desc'),
                // �洢ģʽ
                disktypeDesc: $("#J_diskTypeContainerDom a.active").text(),
                // �����׼
                servicetypeDesc: $("#J_serviceTypeContainerDom dt.active").attr('data-value'),
                // ����ʱ��
                renewTimeDesc: $("#J_renewTimeContainerDom dt.active").attr('data-desc'),
                // ��������
                buycount: self.serverConfig.buycount,
                // ��ȺID
                setebsid: $("#J_setebsidHiddenDom").val(),
                // ����ʱ��
                giftTime: $("#J_renewTimeContainerDom dt.active").attr('data-gift')
            };
            // ���ؾ��� === ��������
            if (self.serverConfig.CHOICE_OS == 'linux_west_slb') {
                currentConfigDesc.CHOICE_OSDesc = '���ؾ���';
            }

            var html = $("#J_productonfigListContainerTpl").render(currentConfigDesc);
            $("#J_productConfigListContainer").html(html);
            if (opts.isFetch === false) {
                return;
            }
            // ���ݵ�ǰ���� ��ȡ�۸�
            var configInfo = WJF.apply({}, self.serverConfig);

            WJF.apply(configInfo, {
                // ��ȡ�۸�����agreement Ϊ0���
                agreement: 1,
                // ��ȡ�۸�
                act: 'getprice'
            });
            // �������� ��ȡʵʱ�۸�
            self.updatePriceXHR = $.ajax({
                url: '/services/cloudhost/',
                type: 'POST',
                data: configInfo,
                success: function(msg) {
                    var priceList = msg.match(/>\d+Ԫ?</g);
                    var priceListDomArr = [];
                    var priceRegexp = /[<>Ԫ]/g;
                    if (priceList.length == 1) {
                        priceListDomArr.push('<span class="realprice">&yen; ' + (priceList[0].replace(priceRegexp, '')) + '</span>');
                    } else {
                        priceListDomArr.push('<span class="realprice">&yen; ' + (priceList[1].replace(priceRegexp, '')) + '</span>');
                        priceListDomArr.push('<span class="origiPrice">&yen; ' + (priceList[0].replace(priceRegexp, '')) + '</span>');
                    }
                    $("#J_configPriceDom").html(priceListDomArr.join(''));

                    // ����������һ����
                    if (configInfo.renewTime == '1') {
                        if (userlevel != "1" && userlevel != "") {
                            $("#priceDiscountDesc").html(" (����8���ػ�)");
                        } else {
                            $("#priceDiscountDesc").html(" (����8.5���ػ�)");
                        }
                        $("#J_firstMonthDesc").html('�����ؼ����飬ԭ��' + (priceList[0].replace(priceRegexp, '')) + 'Ԫ');
                        // ��ʾ�۸��Ż���Ϣ
                        $("#priceDiscountDesc").show();
                    } else {
                        $("#priceDiscountDesc").hide();
                    }
                    changeBuyStatus(true);
                },
                error: function() {

                },
                complete: function() {

                }
            });
        }, 200);

        // �����ť���۸�״̬
        function changeBuyStatus(flag) {
            if (flag) {
                // ���ù���ť
                $("#J_buyBtnsContainer").removeClass('disabled');
                $("#J_configPriceDom").removeClass('disabled');
            } else {
                // ���ù���ť
                $("#J_buyBtnsContainer").addClass('disabled');
                $("#J_configPriceDom").addClass('disabled');
            }
        }
    },
    // END �����������߼�============================================
    // ======================�ײ���������ʼ=============================
    // �ײ�Tab
    initTCTab: function() {
        // ��ҵ���Ʒ�����
        var id_suffix = 'ABCDEF'.split('');
        var self = this;
        for (var i = 0, len = id_suffix.length; i < len; i++) {
            var suffix = id_suffix[i];
            new WJF.ui.select({
                dom: 'J_xcloud' + suffix + '_roomsDom',
                width: 302,
                defaultValue: 1,
                selectContainerSelector: '#J_xcloud' + suffix + '_containerDom',
                onSelect: (function(suffix) {
                    var vr_roomInput = $("#J_xcloud" + suffix + "_vr_roomDom");
                    var ajaxXHR = null;
                    return function(value, desc, item) {
                        // ������·
                        vr_roomInput.val(value);
                        ajaxXHR && ajaxXHR.abort();
                        // ������Ӧ�Ĵ�����Ϣ��
                        ajaxXHR = $.ajax({
                            url: '/services/cloudhost/default.asp',
                            type: 'post',
                            data: {
                                act: 'ServBand',
                                proid: 'xcloud' + suffix,
                                serverRoom: value
                            },
                            success: function(msg) {
                                msg = msg.split("|");
                                // ����
                                $("#radio_xcloud" + suffix + "_flux").html(msg[0]);
                                // IP
                                $("#radio_xcloud" + suffix + "_IP").html(msg[1]);
                            }
                        });
                        // �л��۸�
                        $("#J_vpsromprice_xcloud" + suffix + "_container").find('div.ppl').hide();
                        $("#vpsromprice_xcloud" + suffix + "_" + item.attr('data-index')).show();
                    };
                })(suffix)
            });
        }

        // ���hoverЧ��
        $("#J_taocanListDom").on('mouseover', 'li.taocan-item', function(event) {
            if (!$(this).hasClass('taocan-item-hover')) {
                $(this).addClass('taocan-item-hover');
            }
        }).on('mouseleave', 'li.taocan-item', function() {
            $(this).removeClass('taocan-item-hover');
        });

    },
    // �����û�������Ϣ
    loadGuestTalk: function(page, callback) {
        var self = this;
        var info = "act=LoadGuestTalk&PageNo=" + escape(page) + "&random=" + Math.round(Math.random() * 10000);
        var ajaxurlstr = "/services/cloudhost/default.asp";
        $.ajax({
            type: "POST",
            url: ajaxurlstr,
            data: info,
            datatype: "json",
            timeout: 30000,
            error: function(XmlHttpRequest, textStatus, errorThrown) {
                layer.alert('����������Ϣʧ�ܣ���ˢ������');
                callback && callback(false);
            },
            success: function(xml) {
                self.hasFetchPJInfo = true;
                var tmpPJContainer = $("#J_customPJTemp");

                // ��ǰ�ӿڲ�����ǰ�˽������� �ʶ�����Ⱦ����ȡ���� ������ʹ���½�����Ⱦ
                tmpPJContainer.html(xml);
                var pjData = {
                    header: {},
                    rows: [],
                    pagerInfo: {}
                };
                // ������
                tmpPJContainer.find('.zongping_div table').addClass('zong-ping-table').find('tr').each(function(index) {
                    var value = $(this).find('td:last').text();
                    switch (index) {
                        case 1:
                            pjData.header.speedStarCount = value;
                            break;
                        case 2:
                            pjData.header.priceStarCount = value;
                            break;
                        case 3:
                            pjData.header.serviceStarCount = value;
                            break;
                        case 4:
                            pjData.header.descStarCount = value;
                            break;
                    }
                });
                // ��ȡ��������
                var rows = pjData.rows;
                var tables = tmpPJContainer.children('table');
                var len = tables.length;
                tables.each(function(index) {
                    var currTable = $(this);
                    // ���һ��Ϊ��ҳ��
                    if (index == len - 1) {
                        var td = currTable.find('td');
                        var totalPage = td.find('strong').text();
                        var currPage = $("#Select1").val();

                        laypage({
                            cont: 'pager', //������ֵ֧��id����ԭ��dom����jquery���󡣡��������Ϊ����<div id="page1"></div>
                            pages: totalPage, //ͨ����̨�õ�����ҳ��
                            curr: currPage || 1, //��ǰҳ
                            skip: true,
                            // first:false,
                            // last:false,
                            jump: function(obj, first) { //������ҳ��Ļص�
                                if (!first) { //�����ҳ�����������������ݵ�ǰҳ��obj.curr
                                    self.loadGuestTalk(obj.curr);
                                }
                            }
                        });
                        return;
                    }
                    // ������������
                    var row = {};
                    currTable.children('tbody').children('tr').each(function(index, el) {
                        var currTr = $(this);
                        switch (index) {
                            // ����
                            case 0:
                                row['pjTitle'] = currTr.find('td').text();
                                break;
                                // ��վ����
                            case 1:
                                break;
                                // �����ٶȵ�
                            case 2:
                                var tds = currTr.children('td').find('table').find('td');
                                row['speedStarCount'] = tds.eq(1).find('img').filter(function(index) {
                                    if ($(this).attr('src').match(/yellow/)) {
                                        return true;
                                    }
                                    return false;
                                }).length;
                                row['priceStarCount'] = tds.eq(3).find('img').filter(function(index) {
                                    if ($(this).attr('src').match(/yellow/)) {
                                        return true;
                                    }
                                    return false;
                                }).length;
                                row['serviceStarCount'] = tds.eq(5).find('img').filter(function(index) {
                                    if ($(this).attr('src').match(/yellow/)) {
                                        return true;
                                    }
                                    return false;
                                }).length;
                                row['descStarCount'] = tds.eq(7).find('img').filter(function(index) {
                                    if ($(this).attr('src').match(/yellow/)) {
                                        return true;
                                    }
                                    return false;
                                }).length;
                                break;
                                // ��������
                            case 3:
                                row['pjContent'] = currTr.find('td').text();
                                break;
                                // ����ʱ�䡢������
                            case 4:
                                var date_area_etc = currTr.find('td').text();
                                var dateResult = date_area_etc.match(/ʱ�䣺(.+)����/);
                                if (dateResult && dateResult.length) {
                                    row['pjDate'] = $.trim(dateResult[1]);
                                }
                                // ����
                                var areaResult = date_area_etc.match(/������(.+)IP��/);
                                if (areaResult && areaResult.length) {
                                    row['area'] = $.trim(areaResult[1]);
                                }
                                break;
                        }
                    });
                    rows.push(row);
                });

                // ��Ⱦ����ҳ��
                $("#J_cloudPJListContainer").html($("#pingjiaListTpl").render(pjData));
                callback && callback(true);
            }
        });
    },
    // ҳ���ʼ��
    init: function() {
        var self = this;
        this.bindScroll();
        this.initBanner();
        // ��ʼ��tab
        WJF.uiTool.initTab("J_cloudhostTabDom");
        WJF.uiTool.initTab("J_anchorNavDom", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                if (currentContentID == 'J_cloudPJDom') {
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
                if ($(window).scrollTop() >= 1895) {
                    $(window).scrollTop(1895);
                }
            }
        });

        // ��ʼ������������
        // ����type ѡ�е���������
        var type = window.location.search.match(/[&]?type=(.+)[&]?/);
        if (type) {
            this.dataConfig.defaultConfigType = this.dataConfig.defaultConfigTypeMapping[type[1]] || this.dataConfig.defaultConfigType;
        }
        this.initCloudHostTab();
        // ��ʼ���ײ�������
        this.initTCTab();

        // ����URL��ַ �л�tab
        var param = window.location.search.match(/[&]?tabindex=(.+)[&]?/);
        if (param) {
            $("#J_cloudhostTabDom li").eq(param[1]).trigger('click');
        }
        // IE6
        if (typeof(DD_belatedPNG) != 'undefined') {
            DD_belatedPNG.fix('.handle');
        }
    }
}

$(function() {
    cloudhost.init();
})
