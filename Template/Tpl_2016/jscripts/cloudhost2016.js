/**
 * 遗留问题:
 * 1. 试用 可以选择多台
 * 2. 部分数据动态
 * @type {Object}
 */
var cloudhost = {
    // 相关配置数据
    dataConfig: {
        cpucount: 6,
        ramcount: 12, // 等同于数组 ramIndexCountMap.length - 1
        paytimestr: paytimestr,
        // 硬盘大小范围
        dataMin: 50,
        dataMax: 1000,
        // 带宽范围
        fluxMin: 0,
        fluxMax: 100,
        // 配置类型 兼容表 url type传参对应配置类型
        defaultConfigTypeMapping: {
            shangwu: 'business',
            tejia: 'basic',
            biaozhun: 'standard'
        },
        // 默认配置类型 商务型
        defaultConfigType: 'business',
        // CPU 下标对应CPU数量
        cpuIndexCountMap: [-1, 1, 2, 4, 8, 12, 16],
        ramIndexCountMap: [-1, 0.5, 1, 2, 3, 4, 6, 8, 12, 16, 32, 64, 128]
    },

    // 推荐配置  cpu ram 为index
    recomandConfig: {
        'basic': {
            title: "入门型",
            content: {
                cpu: 2,
                ram: 2,
                data: 60,
                flux: 2
            }
        },
        'standard': {
            title: "标准型",
            content: {
                cpu: 2,
                ram: 3,
                data: 80,
                flux: 3
            }
        },
        'business': {
            title: "商务型",
            content: {
                cpu: 3,
                ram: 5,
                data: 100,
                flux: 4
            }
        },
        'comfortable': {
            title: "舒适型",
            content: {
                cpu: 3,
                ram: 5,
                data: 200,
                flux: 5
            }
        },
        'enterprise': {
            title: "企业型",
            content: {
                cpu: 4,
                ram: 7,
                data: 300,
                flux: 8
            }
        },
        'luxury': {
            title: "豪华型",
            content: {
                cpu: 5,
                ram: 8,
                data: 500,
                flux: 10
            }
        }
    },
    // 默认选择的配置及用户选择数据
    serverConfig: {
        // 索引
        cpu: 3,
        // 索引
        ram: 5,
        // 值
        data: 100,
        // 值
        flux: 4,
        // 操作系统版本
        // CHOICE_OS: 'win',
        // 线路
        room: 37,
        // 存储模式
        disktype: 'ebs',
        // 服务标准
        servicetype: '西部数码铜牌服务',
        // 购买时长
        renewTime: 1,
        // 购买数量
        buycount: 1,
        // 是否同意
        agreement: 1,
        // 集群ID 默认为空 表示 随机分配
        setebsid: '',
        // 试用或者购买 均为该字段
        act: 'buysub'
            // 购买为0  试用为1
            // paytype: 0

    },
    initBanner: function() {
        $("#J_cloudhostBanner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            effect: 'fold',
            // 背景图片属性
            switchLoad: '_bgimg',
            // 背景图片容器
            switchLoadTag: 'a',
            autoPage: true,
            autoPlay: true
        });
    },
    // 1. 全局tab 吸附
    // 2. 配置 fixed
    bindScroll: function() {

        var anchorNav = $("#J_anchorNavDom");
        var fixedConfigContainer = $("#J_currentConfigDom");
        $(window).scroll(function(event) {
            var scrollHeight = $(window).scrollTop();
            if (scrollHeight >= 1895) {
                if (!anchorNav.hasClass('wjf-page-anchor-nav-container-fixed')) {
                    anchorNav.addClass('wjf-page-anchor-nav-container-fixed');
                }
                // 移除固定配置清单
                fixedConfigContainer.removeClass('current-config-fixed');
            } else {
                anchorNav.removeClass('wjf-page-anchor-nav-container-fixed');
            }
            // 配置清单 fixed定位
            if (scrollHeight >= 590 && scrollHeight < 1115) {
                // fixedConfigContainer.addClass('current-config-fixed').css('right', $("#J_cloudhostTabDom").offset().left + 'px');
                fixedConfigContainer.addClass('current-config-fixed').css('left', ($("#J_txHostDom").offset().left + $("#J_txHostDom .tx-host").width() + 2) + 'px');
                fixedConfigContainer.removeClass('current-config-absolute');
            } else if (scrollHeight >= 1115) {
                // 配置清单 绝对定位
                fixedConfigContainer.removeClass('current-config-fixed');
                fixedConfigContainer.addClass('current-config-absolute').css('right', '0px');
                fixedConfigContainer.addClass('current-config-absolute').css('left', 'auto');
            } else {
                // 配置清单 默认状态
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
    // 云主机Tab 初始化
    initCloudHostTab: function() {
        var self = this;

        // 推荐配置
        var defaultRecomandConfig = $('#J_tuijianBtnsDom a[data-value="' + this.dataConfig.defaultConfigType + '"]').addClass('active');
        // 更新服务器配置参数
        this.updateServerConfig(this.dataConfig.defaultConfigType);
        // 注册配置选项点击事件
        $("#J_tuijianBtnsDom").on('click', 'a', function() {
            var target = $(this);
            var configType = target.attr('data-value');
            if (configType == defaultRecomandConfig.attr('data-value')) {
                return;
            }
            defaultRecomandConfig.removeClass('active');
            defaultRecomandConfig = target;
            defaultRecomandConfig.addClass('active');
            // 初始化配置
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
            $("#cpuCount").html(self.dataConfig.cpuIndexCountMap[+value] + '核');
            if (value == 1) {
                $("#J_cpuLowTip").addClass('low-config-tip-visible');
            } else {
                $("#J_cpuLowTip").removeClass('low-config-tip-visible');
            }
            // 更新当前配置
            self.updateView({
                // clearRecomandItem:true
            });
        });
        this.cpuRangeSlide = $("#cpuRange").data('rangeinput');

        // 拖拉描述信息事件
        $("#J_cpuRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.cpuRangeSlide.setValue(index);
            // 触发插件回调
            $("#cpuRange").trigger('change', index);
        });

        // 内存
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
            // 更新当前配置
            self.updateView({
                // clearRecomandItem:true
            });
        });
        this.ramRangeSlide = $("#ramRange").data('rangeinput');
        // 拖拉描述信息事件
        $("#J_ramRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.ramRangeSlide.setValue(index);
            // 触发插件回调
            $("#ramRange").trigger('change', index);
        });


        // 硬盘
        $("#dataRange").rangeinput({
            speed: 200,
            step: 10,
            min: this.dataConfig.dataMin,
            max: this.dataConfig.dataMax,
            // value: 100,
            value: this.serverConfig.data,
            progress: true
        }).change(function(event, value) {
            // 由输入框输入触发时  value为undefined
            if (typeof(value) == 'undefined') {
                value = +event.target.value;
            }
            // 输入校验 如果不是数字 则设置为上一次的值
            if (!/^[-+]?\d+$/.test(value)) {
                // 还原为上一次的值
                self.dataRangeSlide.setValue(self.serverConfig.data);
                return;
            }
            // 超出范围设置为边界
            if (value < self.dataConfig.dataMin) {
                value = self.dataConfig.dataMin;
            } else if (value > self.dataConfig.dataMax) {
                value = self.dataConfig.dataMax;
            }
            // 整数并做10倍数处理
            value = value % 10 ? (Math.floor(value / 10) + 1) * 10 : value;
            self.serverConfig.data = value;
            // 该步骤 在点击时  重复
            self.dataRangeSlide.setValue(value);
            // 更新当前配置
            self.updateView();
        });
        this.dataRangeSlide = $("#dataRange").data('rangeinput');
        // 拖拉描述信息事件
        $("#J_dataRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.dataRangeSlide.setValue(index);
            $("#dataRange").trigger('change', index);
        });

        // 带宽
        $("#fluxRange").rangeinput({
            speed: 200,
            step: 1,
            min: this.dataConfig.fluxMin,
            max: this.dataConfig.fluxMax,
            // value: 4,
            value: this.serverConfig.flux,
            progress: true
        }).change(function(event, value) {
            // 由输入框触发时 value为undefined
            if (typeof(value) == 'undefined') {
                value = +event.target.value;
            }
            // 判断输入是否为合法整数
            if (!/^[-+]?\d+$/.test(value)) {
                // 还原为上一次的值
                self.fluxRangeSlide.setValue(self.serverConfig.flux);
                return;
            }
            // 超出范围设置为边界
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
            // 该步骤 在点击时  重复
            self.fluxRangeSlide.setValue(value);
            // 更新当前配置
            self.updateView();
        });
        this.fluxRangeSlide = $("#fluxRange").data('rangeinput');

        $("#J_fluxRangeDesc").on('click', 'li', function(event) {
            var index = $(this).attr('data-index');
            self.fluxRangeSlide.setValue(index);
            $("#fluxRange").trigger('change', index);
        });


        // +- 操作

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
        // 计数在最开始并不显示 待初始化后再显示
        $(".config-count").add($('.range')).css('visibility', 'visible');
        // 操作系统子项
        this.systemSubType = new WJF.ui.select({
            dom: 'systemSubTypeDom',
            width: 400,
            selectContainerSelector: '#systemSubTypeContainer',
            selContainerMaxHeight: 380,
            onSelect: function(value, desc, item) {
                // console.log(value + ',' + desc);
                self.serverConfig['CHOICE_OS'] = value;
                // 自定义OS 修改线路
                if (value.substr(0, 7) == "diy_os_") {
                    $.post("/services/CloudHost/", "act=getdiyos&CHOICE_OS=" + escape(value), function(roomid) {
                        if (roomid != "") {
                            $("#J_roomsContainerDom").find('span').each(function() {
                                var currentItem = $(this);
                                var val = currentItem.attr('data-value');
                                // 线路ID匹配 则取消禁用
                                if (roomid.indexOf(val) >= 0) {
                                    currentItem.removeClass('disabled');
                                    currentItem.addClass('active');
                                    self.serverConfig.room = val;
                                } else {
                                    // 不匹配 则取消当前的选中
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
                // 更新当前配置
                setTimeout(function() {
                    self.updateView();
                }, 0);
            }
        });
        var isInitStatus = true;
        // 操作系统大类
        var OSTYPE = [{
            value: 'window',
            desc: 'windows'
        }, {
            value: 'linux',
            desc: 'linux'
        }, {
            value: 'linux_west_slb',
            desc: '负载均衡'
        }];
        if ($("#customSubItems li").length > 1) {
            OSTYPE.push({
                value: 'custom',
                desc: '自定义'
            });
        }
        this.systemType = new WJF.ui.select({
            dom: 'systemTypeDom',
            // 输入框默认宽度
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
                        $("#systemSubTypeContainer").html('<li class="item" data-value="">请选择相关版本</li>');
                        self.systemSubType.disable();
                        self.systemSubType.selectItem();

                        // 操作系统类型 修改为该类型
                        self.serverConfig['CHOICE_OS'] = value;
                        break;
                    case 'custom':
                        // 用户自定义操作系统
                        self.systemSubType.enable();
                        $("#systemSubTypeContainer").html($("#customSubItems").html());
                        self.systemSubType.selectItem();
                        !isInitStatus && self.systemSubType.expandItems();
                        break;
                }
                isInitStatus = false;
                // 更新配置
                setTimeout(function() {
                    self.updateView();
                }, 0);
            }
        });

        // 线路选择
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
            // 提示线路选择
            if (useripmsg != "电信" && value != 39 && value != 36) {
                clearTimeout(room_ttt);
                $("#J_roomTipDesc").fadeIn("slow");
                room_ttt = setTimeout(function() {
                    $("#J_roomTipDesc").fadeOut("slow");
                }, 10000);
            } else {
                $("#J_roomTipDesc").fadeOut("slow");
            }

            // 如果选择的是 华南GBP
            if (value == '40') {
                // 最新要求： 取消该提示
                // layer.confirm('<span style="font-size:14px">提示：该机房对内容管控严格，需要实名认证，<a href="/services/Server/servr_room_info_hnbgp.asp" target="_blank" style="color:#06c">请点击阅读相关要求</a>。<br>确认选择该机房吗？</span>', {
                //     icon: 3,
                //     title: '温馨提示'
                // }, function(index) {
                //     continueCallBack();
                //     layer.close(index);
                // });
                // return;
            }
            // DDOS 提示  智能多线、电信、华南机房
            if(/^(37|38|40)$/.test(value)){
                $("#J_roomDDOSTipDesc").fadeIn("slow");
            }else{
                $("#J_roomDDOSTipDesc").fadeOut("slow");
            }
            // 机房 带宽要求
            if ($("#fluxRange").val() == 0 && ("," + sharefluxroom + ",").indexOf("," + value + ",") >= 0) {
                layer.alert('该机房带宽必须大于0M');
                return false;
            }
            continueCallBack();

            function continueCallBack() {
                defaultRoomLink.removeClass('active');
                defaultRoomLink = target;
                defaultRoomLink.addClass('active');
                // 更新
                self.serverConfig.room = value;

                // 更新当前配置
                self.updateView();
            }
        });
        if (useripmsg != "电信") {
            var thisroomObj = $('#J_roomsContainerDom span[data-value="42"]');
            thisroomObj.trigger('click');
        }

        // DDOS 提示  智能多线、电信、华南机房
        if(/^(37|38|40)$/.test(defaultRoomLink.attr('data-value'))){
            $("#J_roomDDOSTipDesc").fadeIn("slow");
        }else{
            $("#J_roomDDOSTipDesc").fadeOut("slow");
        }

        // 存储模式
        var defaultDiskTypeLink = $("#J_diskTypeContainerDom a.active");
        $("#J_diskTypeContainerDom").on('click', 'a.link-btn', function() {
            var target = $(this);
            var value = target.attr('data-value');
            if (value == defaultDiskTypeLink.attr('data-value')) {
                return;
            }

            // 如果选择的是固态硬盘  2016/07/01 去掉
            // if (value == 'ssd') {
            //     layer.confirm('SSD固态硬盘模式有极高的随机IO性能，价格较贵，适合于大型SQlserver数据库或其他对IO性能要求较高的场景。确认选择SSD存储吗？', {
            //         icon: 3,
            //         title: '温馨提示'
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

                // 更新
                self.serverConfig.disktype = value;

                // 更新当前配置
                self.updateView();
            }
        });


        // 购买数量
        $("#J_buyCountContainerDom").on('click', 'a', function() {
            var target = $(this);
            // 减
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
            // 更新当前配置
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
            // 更新当前配置
            self.updateView();
        });

        // 购买数量输入框 输入等逻辑
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

        // 服务标准
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

            // 更新
            self.serverConfig.servicetype = value;

            // 更新当前配置
            self.updateView();
        });

        // 购买时长
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

            // 更新
            self.serverConfig.renewTime = value;

            // 更新当前配置
            self.updateView();
        });
        // 获取购买时长对应的优惠时长信息
        this.getpreday();

        // 购买或者试用按钮
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

        // 同意协议
        $("#J_agreement_label").on('click', function(event) {
            $(this).toggleClass('checked');
            // 是否同意协议
            self.serverConfig.agreement = $(this).hasClass('checked') ? 1 : 0;
        });

        $("#J_tipInner a").on('click', function() {
            if ($('#J_tipInner').hasClass('tip-inner-expand')) {
                $('#J_tipInner').removeClass('tip-inner-expand');
                $(this).html('更多>>');
            } else {
                $('#J_tipInner').addClass('tip-inner-expand');
                $(this).html('收起>>');
            }
        });
        // 再执行一次回调 以更新配置UI
        this.initConfig(this.dataConfig.defaultConfigType);
        // 渲染当前配置详情列表
        this.updateView();
    },
    getpreday: function() {
        // 待定
    },
    // 校验当前是否满足试用或者购买的标准
    // buyOrTry===true 购买
    validateCloudHost: function(buyOrTry) {
        var self = this;
        // 操作系统
        var s_os = this.systemSubType.getValue();
        // 以下字段均非索引
        var select_cpu_i = $("#cpuRange").val();
        var select_ram_i = $("#ramRange").val();
        var select_data = $("#dataRange").val();
        var select_flux = $("#fluxRange").val();
        var select_room = $("#J_roomsContainerDom span.active").attr('data-value');
        // 如果为负载均衡 且未选择操作系统
        if (s_os == ""&&this.serverConfig['CHOICE_OS']!='linux_west_slb') {
            layer.alert("请选择要安装的操作系统！");
            return false;
        }
        switch (s_os) {
            case "win":
            case "win_clean":
            case "win_64":
                if (select_ram_i < 2) {
                    layer.alert("提示：您选择的操作系统最少需要1G内存！请增加内存或更换为其他操作系统！");
                    return false;
                }
                break;
            case "win_2005":
            case "win_2008":
                if (select_ram_i < 2) {
                    layer.alert("提示：您选择的操作系统最少需要2G内存！请增加内存或更换为其他操作系统！");
                    return false;
                }
                break;
            case "win_2008_64":
            case "win_2012_clean":
                if (select_ram_i < 2) {
                    $.dialog.alert("提示：您选择的操作系统最少需要2G内存！请增加内存或更换为其他操作系统！");
                    return false;
                }
                break;
        }

        // 试用
        if (buyOrTry === false) {
            if (select_cpu_i > 3 && select_room != 41) {
                layer.alert("提示：试用主机最大允许4核CPU");
                return false;
            }
            if (select_ram_i > 5) {
                layer.alert("提示：试用主机最大允许4G内存");
                return false;
            }
            if (select_data > 200) {
                layer.alert("提示：试用主机最大允许200G硬盘");
                return false;
            }
            if (select_flux > 10) {
                layer.alert("提示：试用主机最大允许10M带宽");
                return false;
            }
        }

        if (select_room == 41 && select_cpu_i < 0) {
            layer.alert("提示:您选择的是挂机专用主机,CPU核心不能小于1核");
            return false;
        }
        if (select_room != 41 && select_cpu_i >= 5 && select_flux <= 2) {
            if (!confirm("提醒：如果您是用于挖矿等CPU密集型应用，请选择线路为“挂机专用主机”，其他线路不允许长时间CPU高负载占用。\n点“确认”继续提交，点“取消”返回修改配置。")) {
                return false;
            }
        }
        if (select_flux == 0 && ("," + sharefluxroom + ",").indexOf("," + select_room + ",") >= 0) {
            layer.alert("当前线路的带宽必须大于0M");
            return false;
        }
        if (this.serverConfig.agreement) {
            // 0 试用 1 购买
            // 购买0 试用为 1
            self.serverConfig.paytype = buyOrTry ? 0 : 1;
            if (select_room == "37" || select_room == "38") {
                isSetEbsid(function() {
                    // 更新配置信息 === 不再重新取数据(只变更集群ID)
                    self.updateView({
                        isFetch: false
                    });
                    // 执行提交订单流程
                    self.submitOrder(buyOrTry);
                });
            } else {
                // 更新配置信息 === 不再重新取数据(只变更集群ID)
                self.updateView({
                    isFetch: false
                });
                // 执行提交订单流程
                self.submitOrder(buyOrTry);
            }

        } else {
            layer.alert("您还没有同意西部数码主机租用协议");
            return false;
        }

        // 是否选择已有集群ID
        function isSetEbsid(fn) {
            if (username != "") {
                // 当前选择的路线
                var select_room = $("#J_roomsContainerDom span.active").attr('data-value');
                $.post("/config/ebslistbox.asp", "act=issetebsid&room=" + escape(select_room), function(issetebs) {
                    // 有集群ID
                    if (issetebs == "ok") {
                        var layerIndex = layer.open({
                            type: 1,
                            title: '请选择要开设的集群',
                            area: '660px',
                            content: '<span class="wjf-ui-common-loading"></span>'
                        });
                        $.post("/config/ebslistbox.asp", "room=" + escape(select_room), function(data) {
                            $("#layui-layer" + layerIndex + ' .layui-layer-content').html(data);
                            dochkebs();
                            // 开始到这个集群
                            $("input[name='ebsbtnsub']:button").click(function() {
                                $("#J_setebsidHiddenDom").val($.trim($("input[name='ebsid']:text").val()));
                                self.serverConfig.setebsid = $.trim($("input[name='ebsid']:text").val());
                                layer.close(layerIndex);
                                if ($.isFunction(fn)) {
                                    fn.call($);
                                }
                            });
                            // 随机分配
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

        // 绑定表单radio选中事件
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
    // 试用云主机
    tryCloudHost: function() {
        this.validateCloudHost(false);
    },
    // 购买云主机
    buyCloudHost: function() {
        this.validateCloudHost(true);
    },
    // 提交订单 buyOrTry===true 购买
    submitOrder: function(buyOrTry) {

        var self = this;

        // 如果是试用
        if (!buyOrTry) {
            var index = layer.confirm($("#tryTipTpl").render({
                    paytestprice: paytestprice
                }), {
                    icon: 3,
                    title: '试用须知',
                    area: '560px'
                },
                function(index) {
                    continueSubmit();
                    layer.close(index);
                },function () {
                    // 取消 则还原购买类型
                    self.serverConfig.paytype=0;
                    layer.close(index);
                });
            return;
        }
        continueSubmit();

        function continueSubmit() {
            // 根据提交数据 渲染form
            var doms = [];
            var data = self.serverConfig;
            for (var x in data) {
                doms.push('<input type="text" name="' + x + '" value="' + data[x] + '"/>');
            }
            $("#J_buyOrTryForm").html(doms.join(''));
            $("#J_buyOrTryForm").submit();
        }

    },
    // 根据推荐配置 更新配置
    initConfig: function(configType) {
        // 更新配置参数
        this.updateServerConfig(configType);
        // 更新配置
        this.dataRangeSlide.setValue(this.serverConfig.data);
        this.fluxRangeSlide.setValue(this.serverConfig.flux);

        this.cpuRangeSlide.setValue(this.serverConfig.cpu);
        this.ramRangeSlide.setValue(this.serverConfig.ram);
        // 触发插件回调 用于同步界面
        $("#cpuRange").trigger('change', this.serverConfig.cpu);
        $("#ramRange").trigger('change', this.serverConfig.ram);
    },
    // 根据配置类型  更新配置参数
    updateServerConfig: function(configType) {
        // 使用的配置类型
        var config = this.recomandConfig[configType];
        WJF.apply(this.serverConfig, config.content);
    },
    // 云主机Tab 获取最新价格 并刷新页面等
    updateView: function(opts) {
        var self = this;
        opts = opts || {};
        clearTimeout(this.updateViewTimeoutHandle);
        // 取消掉可能正在执行的ajax请求
        if (opts.isFetch !== false) {
            this.updatePriceXHR && this.updatePriceXHR.abort();
            this.updatePriceXHR = null;
            changeBuyStatus(false);
        }
        // 取消掉推荐配置item选中
        if (opts.clearRecomandItem) {
            $("#J_tuijianBtnsDom a").removeClass('active');
        }
        this.updateViewTimeoutHandle = setTimeout(function() {
            // 产品配置信息  使用描述信息
            var currentConfigDesc = {
                // 产品类型
                productTypeDesc: $("#J_tuijianBtnsDom a.active").text(),
                cpuCount: self.dataConfig.cpuIndexCountMap[+self.serverConfig.cpu],
                ramCount: self.dataConfig.ramIndexCountMap[+self.serverConfig.ram],
                dataCount: self.serverConfig.data,
                fluxCount: self.serverConfig.flux,

                // 操作系统
                CHOICE_OSDesc: $("#systemSubTypeDom").text(),

                // 线路
                roomDesc: $("#J_roomsContainerDom span.active").attr('data-desc'),
                // 存储模式
                disktypeDesc: $("#J_diskTypeContainerDom a.active").text(),
                // 服务标准
                servicetypeDesc: $("#J_serviceTypeContainerDom dt.active").attr('data-value'),
                // 购买时长
                renewTimeDesc: $("#J_renewTimeContainerDom dt.active").attr('data-desc'),
                // 购买数量
                buycount: self.serverConfig.buycount,
                // 集群ID
                setebsid: $("#J_setebsidHiddenDom").val(),
                // 赠送时长
                giftTime: $("#J_renewTimeContainerDom dt.active").attr('data-gift')
            };
            // 负载均衡 === 单独处理
            if (self.serverConfig.CHOICE_OS == 'linux_west_slb') {
                currentConfigDesc.CHOICE_OSDesc = '负载均衡';
            }

            var html = $("#J_productonfigListContainerTpl").render(currentConfigDesc);
            $("#J_productConfigListContainer").html(html);
            if (opts.isFetch === false) {
                return;
            }
            // 根据当前配置 获取价格
            var configInfo = WJF.apply({}, self.serverConfig);

            WJF.apply(configInfo, {
                // 获取价格不能有agreement 为0情况
                agreement: 1,
                // 获取价格
                act: 'getprice'
            });
            // 发送请求 获取实时价格
            self.updatePriceXHR = $.ajax({
                url: '/services/cloudhost/',
                type: 'POST',
                data: configInfo,
                success: function(msg) {
                    var priceList = msg.match(/>\d+元?</g);
                    var priceListDomArr = [];
                    var priceRegexp = /[<>元]/g;
                    if (priceList.length == 1) {
                        priceListDomArr.push('<span class="realprice">&yen; ' + (priceList[0].replace(priceRegexp, '')) + '</span>');
                    } else {
                        priceListDomArr.push('<span class="realprice">&yen; ' + (priceList[1].replace(priceRegexp, '')) + '</span>');
                        priceListDomArr.push('<span class="origiPrice">&yen; ' + (priceList[0].replace(priceRegexp, '')) + '</span>');
                    }
                    $("#J_configPriceDom").html(priceListDomArr.join(''));

                    // 如果购买的是一个月
                    if (configInfo.renewTime == '1') {
                        if (userlevel != "1" && userlevel != "") {
                            $("#priceDiscountDesc").html(" (首月8折特惠)");
                        } else {
                            $("#priceDiscountDesc").html(" (首月8.5折特惠)");
                        }
                        $("#J_firstMonthDesc").html('首月特价体验，原价' + (priceList[0].replace(priceRegexp, '')) + '元');
                        // 显示价格优惠信息
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

        // 变更按钮、价格状态
        function changeBuyStatus(flag) {
            if (flag) {
                // 启用购买按钮
                $("#J_buyBtnsContainer").removeClass('disabled');
                $("#J_configPriceDom").removeClass('disabled');
            } else {
                // 禁用购买按钮
                $("#J_buyBtnsContainer").addClass('disabled');
                $("#J_configPriceDom").addClass('disabled');
            }
        }
    },
    // END 弹性云主机逻辑============================================
    // ======================套餐云主机开始=============================
    // 套餐Tab
    initTCTab: function() {
        // 创业型云服务器
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
                        // 更新线路
                        vr_roomInput.val(value);
                        ajaxXHR && ajaxXHR.abort();
                        // 更新相应的带宽信息等
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
                                // 带宽
                                $("#radio_xcloud" + suffix + "_flux").html(msg[0]);
                                // IP
                                $("#radio_xcloud" + suffix + "_IP").html(msg[1]);
                            }
                        });
                        // 切换价格
                        $("#J_vpsromprice_xcloud" + suffix + "_container").find('div.ppl').hide();
                        $("#vpsromprice_xcloud" + suffix + "_" + item.attr('data-index')).show();
                    };
                })(suffix)
            });
        }

        // 添加hover效果
        $("#J_taocanListDom").on('mouseover', 'li.taocan-item', function(event) {
            if (!$(this).hasClass('taocan-item-hover')) {
                $(this).addClass('taocan-item-hover');
            }
        }).on('mouseleave', 'li.taocan-item', function() {
            $(this).removeClass('taocan-item-hover');
        });

    },
    // 加载用户评价信息
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
                layer.alert('载入评价信息失败，请刷新重试');
                callback && callback(false);
            },
            success: function(xml) {
                self.hasFetchPJInfo = true;
                var tmpPJContainer = $("#J_customPJTemp");

                // 当前接口不满足前端界面需求 故而先渲染再提取数据 再重新使用新界面渲染
                tmpPJContainer.html(xml);
                var pjData = {
                    header: {},
                    rows: [],
                    pagerInfo: {}
                };
                // 总评价
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
                // 获取评价数据
                var rows = pjData.rows;
                var tables = tmpPJContainer.children('table');
                var len = tables.length;
                tables.each(function(index) {
                    var currTable = $(this);
                    // 最后一个为分页栏
                    if (index == len - 1) {
                        var td = currTable.find('td');
                        var totalPage = td.find('strong').text();
                        var currPage = $("#Select1").val();

                        laypage({
                            cont: 'pager', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                            pages: totalPage, //通过后台拿到的总页数
                            curr: currPage || 1, //当前页
                            skip: true,
                            // first:false,
                            // last:false,
                            jump: function(obj, first) { //触发分页后的回调
                                if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr
                                    self.loadGuestTalk(obj.curr);
                                }
                            }
                        });
                        return;
                    }
                    // 单行评价数据
                    var row = {};
                    currTable.children('tbody').children('tr').each(function(index, el) {
                        var currTr = $(this);
                        switch (index) {
                            // 点评
                            case 0:
                                row['pjTitle'] = currTr.find('td').text();
                                break;
                                // 网站域名
                            case 1:
                                break;
                                // 访问速度等
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
                                // 评价内容
                            case 3:
                                row['pjContent'] = currTr.find('td').text();
                                break;
                                // 评价时间、地区等
                            case 4:
                                var date_area_etc = currTr.find('td').text();
                                var dateResult = date_area_etc.match(/时间：(.+)地区/);
                                if (dateResult && dateResult.length) {
                                    row['pjDate'] = $.trim(dateResult[1]);
                                }
                                // 地区
                                var areaResult = date_area_etc.match(/地区：(.+)IP：/);
                                if (areaResult && areaResult.length) {
                                    row['area'] = $.trim(areaResult[1]);
                                }
                                break;
                        }
                    });
                    rows.push(row);
                });

                // 渲染评价页面
                $("#J_cloudPJListContainer").html($("#pingjiaListTpl").render(pjData));
                callback && callback(true);
            }
        });
    },
    // 页面初始化
    init: function() {
        var self = this;
        this.bindScroll();
        this.initBanner();
        // 初始化tab
        WJF.uiTool.initTab("J_cloudhostTabDom");
        WJF.uiTool.initTab("J_anchorNavDom", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                if (currentContentID == 'J_cloudPJDom') {
                    // 如果已经发送
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

        // 初始化弹性云主机
        // 根据type 选中弹性云类型
        var type = window.location.search.match(/[&]?type=(.+)[&]?/);
        if (type) {
            this.dataConfig.defaultConfigType = this.dataConfig.defaultConfigTypeMapping[type[1]] || this.dataConfig.defaultConfigType;
        }
        this.initCloudHostTab();
        // 初始化套餐云主机
        this.initTCTab();

        // 根据URL地址 切换tab
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
