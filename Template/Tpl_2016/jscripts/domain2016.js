var domainReg = {
    // �Զ��� ��ѯ У��
    submitcheck_custom: function (F) {
        var v_ = F.searchedDomainName_custom.value.split("\n");

        for (var i = 0; i < v_.length; i++) {

            if (v_[i].indexOf(".") <= 0 || v_[i].indexOf(".") == (v_[i].length - 1) || v_[i].split(".").length != 2) {
                layer.alert("��¼����ȷҪ��ѯ����������׺,��֧����������׺����<br>�������Ҫ��ѯ����������׺,��ǰ��������׺ѡ����в�ѯ");
                return false;
            }
            var d_ = v_[i].substring(0, v_[i].indexOf("."));
            var s_ = v_[i].substring(v_[i].indexOf("."), v_[i].length);
            if (s_.length < 3) {
                layer.alert("������׺��������ϸ���");
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
                layer.alert('��ȡ����ʧ��,�����²�ѯһ��');
                return;
            }
        });

        return isOk;
    },
    // ���Զ��� ���ύУ��
    submitchecken: function (F) {
        var arrext = [];
        var arrdom = [];
        var domains = F.searchedDomainName.value;

        if (domains == "" || domains.match(/��������Ҫע�������/)) {
            layer.alert("����дҪ��ѯ��������ÿ��һ�����Ҳ�Ҫ��׺��");
            return false;
        }

        $(F).parents('.wjf-ui-tab-content').find('[name="suffix"]').each(function () {
            if (this.checked) arrext.push(this.value)
        });


        if (F.name != "chineseDomainForm") {
            if (/[\u4e00-\u9fa5]+/.test(domains)) {
                layer.alert("������������к���[�����ַ�]����ǰѡ�ֻ�ܲ�ѯӢ�������� <br>����Ҫ��ѯ�����������뵽��������ѡ��в�ѯ��лл��");
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
            // �û�ֱ������ĺ�׺
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

        // û�������Զ����׺ ��û�й�ѡ��׺
        if (arrext.length == 0 && !(userCustomExt && domainNameCount == 1)) {
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

        F.searchedDomainName.value = arrdom.join('\n');

        if (F.name != 'customForm') {
            // ֻ����һ����� �� �к�׺��� ʹ���û�����ĺ�׺����ѯ
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
                alert('��ȡ����ʧ��,�����²�ѯһ��');
                isOK = false;
                return;
            }
        });

        return isOK;
    },
    renderDomainTipInfo: function (domainName, domainLink, domainJSON) {
        if (domainName != '.gov.cn') {
            // .cn��β
            if (/\.cn$/.test(domainName)) {
                domainName = '.cn'
            }
        }
    },
    regEvent: function () {
        var self = this;
        // ����֮����
        $(".common-input").on('keyup', function () {
            var currentCommonInput = $(this);
            var closeIcon = currentCommonInput.siblings('.clear-domain-input');
            if (currentCommonInput.scrollTop() > 0) {
                closeIcon.show();
            } else {
                closeIcon.hide();
            }
        });
        // X ������������
        $(".clear-domain-input").on('click', function () {
            $(this).hide().siblings('.common-input').val('').focus();
        });

        // ����ѡ�����
        $('.select-op').change(function (event) {
            var val = $(this).val();

            var domExtsContainer = $(this).parents('.domext-select-container').next();
            switch (val) {
                // ȫѡ
                case '0':
                    domExtsContainer.find('label').removeClass('checked').addClass('checked');
                    domExtsContainer.find('input').each(function () {
                        $(this).prop('checked', 'checked');
                    });
                    break;
                // ȫ��ѡ
                case '1':
                    domExtsContainer.find('label').removeClass('checked');
                    domExtsContainer.find('input').each(function () {
                        $(this).prop('checked', '');
                    });
                    break;
                // ����
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

        // ����ѡ���� IE6 FOR ��ҪID
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

        //����鿴����
        $('.more-domains').on('click', function () {
            var status = !$(this).data('expanded');
            $(this).data('expanded', status);
            if(status==true){
                $(this).html('���ظ���&gt;&gt;');
            }else{
                $(this).html('�鿴����&gt;&gt;');
            }
            $(this).siblings('.collapsed-domain').toggle();
        });
    },
    init: function () {

// ����banner��ʼ��
        $(".sec-banner").length && $(".sec-banner").slide({
            mainCell: ".slide-wrapper ul",
            titCell: '.slide-pagination ul',
            interTime: 7000,
            effect: 'fold',
            // ����ͼƬ����
            switchLoad: '_bgimg',
            // ����ͼƬ����
            switchLoadTag: 'a',
            autoPage: true,
            autoPlay: true
        });
        // ���placeholder֧��
        WJF.uiTool.placeholder('.common-input');
        var initTextAreaValue = '';
        // ��ʼ��tab
        WJF.uiTool.initTab("domainsTab", {
            // ��ʱʵ�ֶ��textarea����ֵ
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
        // ע���¼�
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