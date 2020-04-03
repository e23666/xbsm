
// ������ѯ == ��ѯ�����۸��Ƿ���ע���
var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var base64DecodeChars = new Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);

    /**
     * base64����
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
 * 1. �����޸ļ۸�ʱ ���û�е�¼ ���޷���ȡ���۸���Ϣ Ҫ���¼
 * 	  �߼����� �޷���ȡ��ȷ�����޼۸� qq.xyz
 * 2. �ύʱ ��Ҫ��½
 * 3. setCache���� δ֪
 * 4. �Ƴ��Զ��� �����������
 * 5. ���cn������ʾ��Ϣ === step2 �� step3������ʾ�����ͬ
 */

var whois2016 = {
    // ͨ���ύ
    submitchecken: function(F) {
        var arrext = [];
        var arrdom = [];
        var domains = F.searchedDomainName.value;

        if (domains == "" || domains.match(/��������Ҫע�������/)) {
            layer.alert("����дҪ��ѯ��������ÿ��һ�����Ҳ�Ҫ��׺��");
            return false;
        }

        var activeTabId = $("#domainsTab").find('a.active').attr('data-target');

        $("#" + activeTabId).find('[name="suffix"]').each(function() {
            if (this.checked) arrext.push(this.value);
        });

        // ���ò���
        $('#J_queryDomainForm [name="suffix"]').val(arrext.join(','));

        if (activeTabId != "chineseDomain") {
            if (/[\u4e00-\u9fa5]+/.test(domains)) {
                layer.alert("������������к���[�����ַ�]����ǰѡ�ֻ�ܲ�ѯӢ�������� <br>����Ҫ��ѯ�����������뵽��������ѡ��в�ѯ��лл��");
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
            // �û�ֱ������ĺ�׺
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
            layer.alert("������ѡ��Ҫ��ѯ��������׺��");
            return false;
        }

        if (arrdom.length > 300 && arrdom.length > 1) {
            if (!confirm("����ǰ��ѯ������̫�࣬���鲻Ҫ��ѡ��׺�������ѯ̫�ർ�½��濨����ȷ�ϼ�����")) return false;
        }

        if (arrdom.length > 500) {
            layer.alert("��Ǹ��ÿ����ѯ�����������ܳ���500������ǰ��" + arrdom.length + "��");
            return false;
        } else if (arrdom.length == 0) {
            layer.alert("����д����������ȷ���޷���ѯ��");
            return false;
        }

        // ����
        F.searchedDomainName.value = arrdom.join('\n');
        // ׷��һ���ֶ� �ύ������׺����
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
                alert('��ȡ����ʧ��,�����²�ѯһ��');
                isOK = false;
                return;
            }
        });

        return isOK;
    },
    // �¼���
    regEvent: function() {
        var self = this;

        // �����׺չ��
        $("#J_expandDomainExt").on('click', function(event) {
            var item = $(this);
            if ($(this).hasClass('expanded')) {
                item.removeClass('expanded');
                $("#J_domainExtContainer").stop().slideUp(200);
                $("#J_expandDomainExt").text('���չ������������ѯ');
            } else {
                item.addClass('expanded');
                $("#J_domainExtContainer").stop().slideDown(400);
                $("#J_expandDomainExt").text('����۵�����������ѯ');
            }
            event.stopPropagation();
            return false;
        });
        // ��ֹ���tab���� ����tab���屻�۵�bug
        $("#J_domainExtContainer").add($("#J_searchedDomainName")).on('click', function(event) {
            event.stopPropagation();
        });

        $(document).on('click', function(event) {
            if ($("#J_expandDomainExt").hasClass('expanded')) {
                $("#J_expandDomainExt").trigger('click');
            }
        });

        // ����֮����
        $(".common-input").on('keyup', function() {
            var currentCommonInput = $(this);
            var closeIcon = currentCommonInput.siblings('.clear-domain-input');
            if (currentCommonInput.scrollTop() > 0) {
                closeIcon.show();
            } else {
                closeIcon.hide();
            }
        });
        // X ������������
        $(".clear-domain-input").on('click', function() {
            $(this).hide().siblings('.common-input').val('').focus();
        });
        // ����ѡ�����
        $('.select-op').change(function(event) {
            var val = $(this).val();

            var domExtsContainer = $(this).parents('.domext-select-container').next();
            switch (val) {
                // ȫѡ
                case '0':
                    domExtsContainer.find('label').removeClass('checked').addClass('checked');
                    domExtsContainer.find('input').each(function() {
                        $(this).prop('checked', 'checked');
                    });
                    break;
                    // ȫ��ѡ
                case '1':
                    domExtsContainer.find('label').removeClass('checked');
                    domExtsContainer.find('input').each(function() {
                        $(this).prop('checked', '');
                    });
                    break;
                    // ����
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

        // ����ѡ���� IE6 FOR ��ҪID
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
        // ��ʼ������ѡ��tab
        WJF.uiTool.initTab("domainsTab", {
            // ��ʱʵ�ֶ��textarea����ֵ
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId) {
                // $("#J_searchedDomainName").val('');
            }
        });
        // ���placeholder֧��
        WJF.uiTool.placeholder('.common-input');
        // ע���¼�
        this.regEvent();
        // ���� domainGroup �е��������� �����ѯ���е������
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
//            // ����������� ���л�������tab��
//            if (hasChinese) {
//                $("#domainsTab").find('a[data-target="chineseDomain"]').trigger('click');
//            }
//            // ����textarea�� ��Ҫ��ѯ���������ƻ���
//
//            // ����û�����ǹ̶��ĵ�������
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