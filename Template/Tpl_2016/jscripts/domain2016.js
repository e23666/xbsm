var domainReg = {
    // 自定义 查询 校验
    submitcheck_custom: function (F) {
        var v_ = F.searchedDomainName_custom.value.split("\n");

        for (var i = 0; i < v_.length; i++) {

            if (v_[i].indexOf(".") <= 0 || v_[i].indexOf(".") == (v_[i].length - 1) || v_[i].split(".").length != 2) {
                layer.alert("请录入正确要查询的域名及后缀,不支持域名多点后缀域名<br>如果您需要查询其它二级后缀,请前往其它后缀选项卡进行查询");
                return false;
            }
            var d_ = v_[i].substring(0, v_[i].indexOf("."));
            var s_ = v_[i].substring(v_[i].indexOf("."), v_[i].length);
            if (s_.length < 3) {
                layer.alert("域名后缀有误，请仔细检查");
                return false;
            }
        }
        var isOk = true;
        $.ajax({
            async: false,
            type: 'GET',
            url: '/gettoken.asp?act=gettok',
            data: null,
            cache: false,
            dataType: 'script',
            error: function (jqXHR, textStatus, errorThrown) {
                isOk = false;
                layer.alert('获取令牌失败,请重新查询一次');
                return;
            }
        });

        return isOk;
    },
    // 非自定义 表单提交校验
    submitchecken: function (F) {
        var arrext = [];
        var arrdom = [];
        var domains = F.searchedDomainName.value;

        if (domains == "" || domains.match(/请输入您要注册的域名/)) {
            layer.alert("请填写要查询的域名，每行一个，且不要后缀。");
            return false;
        }

        $(F).parents('.wjf-ui-tab-content').find('[name="suffix"]').each(function () {
            if (this.checked) arrext.push(this.value)
        });


        if (F.name != "chineseDomainForm") {
            if (/[\u4e00-\u9fa5]+/.test(domains)) {
                layer.alert("您输入的域名中含有[中文字符]，当前选项卡只能查询英文域名。 <br>若需要查询中文域名，请到中文域名选项卡中查询，谢谢。");
                return false;
            }
        }

        var arrList = domains.split('\n');
        var userCustomExt = null;
        var domainNameCount = 0;
        for (var i = 0; i < arrList.length; i++) {
            var val = arrList[i].replace(/\s/g, '');
            val = val.replace(/^\./, '');
            val = val.replace(/\.$/, '');
            if (val == "") {
                continue;
            }
            // 用户直接输入的后缀
            var inputExt = val.match(/(www\.)?[^\.]*(\..*)/);
            if (inputExt) {
                userCustomExt = inputExt[2];
            }
            val = val.replace(/\.[a-z]{2,3}\.cn$/, '.miss');
            if (val.indexOf('.') >= 0) val = val.substr(0, val.lastIndexOf('.'));
            if (val.indexOf('.') >= 0) val = val.substr(0,val.lastIndexOf('.'));
            if (/^[0-9a-z\-\u4e00-\u9fa5]+$/ig.test(val)) arrdom.push(val.toLowerCase());
            domainNameCount++;
        }

        // 没有输入自定义后缀 且没有勾选后缀
        if (arrext.length == 0 && !(userCustomExt && domainNameCount == 1)) {
            layer.alert("请您勾选需要查询的域名后缀。");
            return false;
        }

        if (arrdom.length > 300 && arrdom.length > 1) {
            if (!confirm("您当前查询的域名太多，建议不要多选后缀，避免查询太多导致界面卡死，确认继续？")) return false;
        }

        if (arrdom.length > 500) {
            layer.alert("抱歉，每批查询域名数量不能超过500个，当前有" + arrdom.length + "个");
            return false;
        } else if (arrdom.length == 0) {
            layer.alert("您填写的域名不正确，无法查询。");
            return false;
        }

        F.searchedDomainName.value = arrdom.join('\n');

        if (F.name != 'customForm') {
            // 只输入一条语句 且 有后缀情况 使用用户输入的后缀做查询
            if (domainNameCount == 1 && userCustomExt) {
                F.suffix.value = [userCustomExt];
            } else {
                F.suffix.value = arrext;
            }
        }

        var isOK = true;
        $.ajax({
            async: false,
            type: 'POST',
            url: '/gettoken.asp?act=gettok',
            data: null,
            cache: false,
            dataType: 'script',
            error: function (jqXHR, textStatus, errorThrown) {
                alert('获取令牌失败,请重新查询一次');
                isOK = false;
                return;
            }
        });

        return isOK;
    },
    renderDomainTipInfo: function (domainName, domainLink, domainJSON) {
        if (domainName != '.gov.cn') {
            // .cn结尾
            if (/\.cn$/.test(domainName)) {
                domainName = '.cn'
            }
        }
    },
    regEvent: function () {
        var self = this;
        // 输入之后弹起
        $(".common-input").on('keyup', function () {
            var currentCommonInput = $(this);
            var closeIcon = currentCommonInput.siblings('.clear-domain-input');
            if (currentCommonInput.scrollTop() > 0) {
                closeIcon.show();
            } else {
                closeIcon.hide();
            }
        });
        // X 清除输入框内容
        $(".clear-domain-input").on('click', function () {
            $(this).hide().siblings('.common-input').val('').focus();
        });

        // 处理选择操作
        $('.select-op').change(function (event) {
            var val = $(this).val();

            var domExtsContainer = $(this).parents('.domext-select-container').next();
            switch (val) {
                // 全选
                case '0':
                    domExtsContainer.find('label').removeClass('checked').addClass('checked');
                    domExtsContainer.find('input').each(function () {
                        $(this).prop('checked', 'checked');
                    });
                    break;
                // 全不选
                case '1':
                    domExtsContainer.find('label').removeClass('checked');
                    domExtsContainer.find('input').each(function () {
                        $(this).prop('checked', '');
                    });
                    break;
                // 常用
                case '2':
                    domExtsContainer.find('input').each(function () {
                        var currInput = $(this);
                        if (currInput.attr('common-use') == '1') {
                            currInput.prop('checked', 'checked');
                            currInput.parent('label').removeClass('checked').addClass('checked');
                        } else {
                            currInput.prop('checked', '');
                            currInput.parent('label').removeClass('checked');
                        }
                    });
                    break;
            }
        });

        // 处理勾选操作 IE6 FOR 需要ID
        var ie6 = !-[1,] && !window.XMLHttpRequest;
        $('.domext-wrapper').on('click', 'label', function (event) {
            if (event.target.type == 'checkbox' || event.target.type == '') {
                return;
            }
            if ($(this).hasClass('checked')) {
                $(this).removeClass('checked');
                ie6 && $(this).find('input').prop('checked', '');
            } else {
                $(this).addClass('checked');
                ie6 && $(this).find('input').prop('checked', 'checked');
            }
        });

        //处理查看更多
        $('.more-domains').on('click', function () {
            var status = !$(this).data('expanded');
            $(this).data('expanded', status);
            if(status==true){
                $(this).html('隐藏更多&gt;&gt;');
            }else{
                $(this).html('查看更多&gt;&gt;');
            }
            $(this).siblings('.collapsed-domain').toggle();
        });
    },
    init: function () {

// 顶部banner初始化
        $(".sec-banner").length && $(".sec-banner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            interTime: 7000,
            effect: 'fold',
            // 背景图片属性
            switchLoad: '_bgimg',
            // 背景图片容器
            switchLoadTag: 'a',
            autoPage: true,
            autoPlay: true
        });
        // 添加placeholder支持
        WJF.uiTool.placeholder('.common-input');
        var initTextAreaValue = '';
        // 初始化tab
        WJF.uiTool.initTab("domainsTab", {
            // 临时实现多个textarea共用值
            onTabChange: function (tabId, currentLiDom, currentContentID, prevContentId) {
                if (prevContentId != 'customDomain') {
                    initTextAreaValue = $("#" + prevContentId + ' textarea.common-input').val();
                }
                if (currentContentID != 'customDomain') {
                    var currentTextarea = $("#" + currentContentID + ' textarea.common-input');
                    currentTextarea.val(initTextAreaValue);
                    currentTextarea.focus();
                    currentTextarea.blur();
                }
            }
        });
        // 注册事件
        this.regEvent();
    }
};

$(function () {

	$("#rxhz").html(getdomaininput(domainconfig.hot,1,999));
	$("#newhz").html(getdomaininput(domainconfig.new,2,20));
	$("#chinahz").html(getdomaininput(domainconfig.zh,4,99));
	$("#cohz").html(getdomaininput(domainconfig.co,5,99));
    $("#cnhz").html(getdomaininput(domainconfig.cn,6,999));
    domainReg.init();
})

function getdomaininput(obj_,n_,max_)
		{
			temp_="";
			for (var i=0;i<obj_.length ;i++ )
			{
				suffix=obj_[i].suffix
				obj_[i].ischeck==1?checked_='checked="checked"':checked_='';
				obj_[i].ischeck==1?checkedclass_='class="checked"':checkedclass_='';
				i_msg=''
				switch (obj_[i].property+"")
				{
					case "1":
						i_msg='<i class="icon promotion"></i>';
						break
					case "2":
						i_msg='<i class="icon hot"></i>';
						break
					case "3":
						i_msg='<i class="icon new"></i>';
						break
				} 
				if (i>max_)
				{
					checkedclass_='class="collapsed-domain"'
				}
			 
			  temp_+=' <label '+checkedclass_+'  for="label_for_'+n_+'_'+i+'"><input name="suffix"  '+checked_+'  value="'+suffix+'" type="checkbox" common-use="'+obj_[i].ischeck+'" id="label_for_'+n_+'_'+i+'">'+suffix+' '+i_msg+'</label>';
			  
			}

			return temp_;		
		}