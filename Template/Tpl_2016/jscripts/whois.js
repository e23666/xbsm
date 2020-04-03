
// 域名查询 == 查询域名价格、是否已注册等
var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var base64DecodeChars = new Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);

    /**
     * base64编码
     */

function base64Encode(str) {
    var out, i, len;
    var c1, c2, c3;
    len = str.length;
    i = 0;
    out = "";
    while (i < len) {
        c1 = str.charCodeAt(i++) & 0xff;
        if (i == len) {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt((c1 & 0x3) << 4);
            out += "==";
            break;
        }
        c2 = str.charCodeAt(i++);
        if (i == len) {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
            out += base64EncodeChars.charAt((c2 & 0xF) << 2);
            out += "=";
            break;
        }
        c3 = str.charCodeAt(i++);
        out += base64EncodeChars.charAt(c1 >> 2);
        out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
        out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
        out += base64EncodeChars.charAt(c3 & 0x3F);
    }
    return out;
};

/**
 * Q:
 * 1. 批量修改价格时 如果没有登录 则无法获取到价格信息 要求登录
 * 	  高价域名 无法获取正确的年限价格 qq.xyz
 * 2. 提交时 需要登陆
 * 3. setCache方法 未知
 * 4. 移出自定义 错误随机触发
 * 5. 检查cn域名提示信息 === step2 和 step3返回提示结果不同
 */

var whois2016 = {
    // 通用提交
    submitchecken: function(F) {
        var arrext = [];
        var arrdom = [];
        var domains = F.searchedDomainName.value;

        if (domains == "" || domains.match(/请输入您要注册的域名/)) {
            layer.alert("请填写要查询的域名，每行一个，且不要后缀。");
            return false;
        }

        var activeTabId = $("#domainsTab").find('a.active').attr('data-target');

        $("#" + activeTabId).find('[name="suffix"]').each(function() {
            if (this.checked) arrext.push(this.value);
        });

        // 设置参数
        $('#J_queryDomainForm [name="suffix"]').val(arrext.join(','));

        if (activeTabId != "chineseDomain") {
            if (/[\u4e00-\u9fa5]+/.test(domains)) {
                layer.alert("您输入的域名中含有[中文字符]，当前选项卡只能查询英文域名。 <br>若需要查询中文域名，请到中文域名选项卡中查询，谢谢。");
                return false;
            }
        }

        var arrList = domains.split('\n');
        var userCustomExt = null;
        var domainNameCount=0;
        for (var i = 0; i < arrList.length; i++) {
            var val = arrList[i].replace(/\s/g, '');
            val = val.replace(/^\./, '');
            val = val.replace(/\.$/, '');
            if(val==""){
                continue;
            }
            // 用户直接输入的后缀
            var inputExt = val.match(/(www\.)?[^\.]*(\..*)/);
            if(inputExt){
                userCustomExt = inputExt[2];
            }
            val = val.replace(/\.[a-z]{2,3}\.cn$/, '.miss');
            if (val.indexOf('.') >= 0) val = val.substr(0, val.lastIndexOf('.'));
            if (val.indexOf('.') >= 0) val = val.substr(val.lastIndexOf('.') + 1);
            if (/^[0-9a-z\-\u4e00-\u9fa5]+$/ig.test(val)) arrdom.push(val.toLowerCase());
            domainNameCount++;
        }

        if (arrext.length == 0&&!(userCustomExt&&domainNameCount==1)) {
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

        // 回填
        F.searchedDomainName.value = arrdom.join('\n');
        // 追加一个字段 提交域名后缀数组
        if(domainNameCount==1&&userCustomExt){
            F.suffix.value = [userCustomExt];
        }else{
            F.suffix.value = arrext;
        }


        var isOK = true;
        $.ajax({
            async: false,
            type: 'POST',
            url: '/gettoken.asp?act=gettok',
            data: null,
            cache: false,
            dataType: 'script',
            error: function(jqXHR, textStatus, errorThrown) {
                alert('获取令牌失败,请重新查询一次');
                isOK = false;
                return;
            }
        });

        return isOK;
    },
    // 事件绑定
    regEvent: function() {
        var self = this;

        // 更多后缀展开
        $("#J_expandDomainExt").on('click', function(event) {
            var item = $(this);
            if ($(this).hasClass('expanded')) {
                item.removeClass('expanded');
                $("#J_domainExtContainer").stop().slideUp(200);
                $("#J_expandDomainExt").text('点击展开更多域名查询');
            } else {
                item.addClass('expanded');
                $("#J_domainExtContainer").stop().slideDown(400);
                $("#J_expandDomainExt").text('点击折叠更多域名查询');
            }
            event.stopPropagation();
            return false;
        });
        // 防止点击tab内容 导致tab整体被折叠bug
        $("#J_domainExtContainer").add($("#J_searchedDomainName")).on('click', function(event) {
            event.stopPropagation();
        });

        $(document).on('click', function(event) {
            if ($("#J_expandDomainExt").hasClass('expanded')) {
                $("#J_expandDomainExt").trigger('click');
            }
        });

        // 输入之后弹起
        $(".common-input").on('keyup', function() {
            var currentCommonInput = $(this);
            var closeIcon = currentCommonInput.siblings('.clear-domain-input');
            if (currentCommonInput.scrollTop() > 0) {
                closeIcon.show();
            } else {
                closeIcon.hide();
            }
        });
        // X 清除输入框内容
        $(".clear-domain-input").on('click', function() {
            $(this).hide().siblings('.common-input').val('').focus();
        });
        // 处理选择操作
        $('.select-op').change(function(event) {
            var val = $(this).val();

            var domExtsContainer = $(this).parents('.domext-select-container').next();
            switch (val) {
                // 全选
                case '0':
                    domExtsContainer.find('label').removeClass('checked').addClass('checked');
                    domExtsContainer.find('input').each(function() {
                        $(this).prop('checked', 'checked');
                    });
                    break;
                    // 全不选
                case '1':
                    domExtsContainer.find('label').removeClass('checked');
                    domExtsContainer.find('input').each(function() {
                        $(this).prop('checked', '');
                    });
                    break;
                    // 常用
                case '2':
                    domExtsContainer.find('input').each(function() {
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
        var ie6 = !-[1, ] && !window.XMLHttpRequest;
        $('.domext-wrapper').on('click', 'label', function(event) {
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
    },
    init: function() {
        // 初始化域名选择tab
        WJF.uiTool.initTab("domainsTab", {
            // 临时实现多个textarea共用值
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                // $("#J_searchedDomainName").val('');
            }
        });
        // 添加placeholder支持
        WJF.uiTool.placeholder('.common-input');
        // 注册事件
        this.regEvent();
        // 根据 domainGroup 中的域名名称 回填查询表单中的输入框
      //  this.domainNameArr = [];
//        if (domainGroup[0]) {
//            var tmpObj = {};
//            var domainArr = domainGroup[0].split(':')[0].split(',');
//            var hasChinese = false;
//            for (var i = 0, len = domainArr.length; i < len; i++) {
//                var item = domainArr[i];
//                if (!item) {
//                    continue;
//                }
//                var itemBase64Key = base64Encode(item);
//                if (tmpObj[itemBase64Key]) {
//                    continue;
//                }
//                this.domainNameArr.push(item);
//                if (item.match(/[\u4e00-\u9fa5]+/)) {
//                    hasChinese = true;
//                }
//                tmpObj[itemBase64Key] = true;
//            }
//            // 如果存在中文 则切换到中文tab中
//            if (hasChinese) {
//                $("#domainsTab").find('a[data-target="chineseDomain"]').trigger('click');
//            }
//            // 回填textarea框 将要查询的域名名称回填
//
//            // 如果用户查的是固定的单个域名
//            //console.log(domainGroup);
//            if(domainGroup.length==1){
//                var domainGroupStr = domainGroup[0];
//                var searchDomainName = domainGroupStr.split(':')[0];
//                var searchDomainExt = domainGroupStr.split(':')[1];
//                if(searchDomainName.split(',').length<=1&&searchDomainExt.split(',').length<=1){
//                    $("#J_searchedDomainName").val(searchDomainName.split(',')[0]+searchDomainExt.split(':')[0]);
//                }else{
//                    $("#J_searchedDomainName").val(this.domainNameArr.join('\n'));
//                }
//            }else{
//                $("#J_searchedDomainName").val(this.domainNameArr.join('\n'));
//            }
//        }

    }
}


$("#rxhz").html(getdomaininput(domainconfig.hot,1,999));
$("#newhz").html(getdomaininput(domainconfig.new,2,20));
$("#chinahz").html(getdomaininput(domainconfig.zh,4,99));
$("#cohz").html(getdomaininput(domainconfig.co,5,99));
$("#cnhz").html(getdomaininput(domainconfig.cn,5,999));




whois2016.init();

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