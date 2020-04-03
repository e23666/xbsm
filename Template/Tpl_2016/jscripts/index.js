var newMainIndex = {
    // ������ѯ��Ŀ
    initDomainQuery: function() {
        var self = this;
        // ������׺����
        this.domExtWrapper = $("#domextWrapper");
        // ȫѡ����ѡ�����ð�ť����
        this.domExtSelectOper = $("#domextSelectOper");

        // ���泣��ѡ��
        // this.domExtWrapper.find('input:checked').each(function() {
        //     $(this).attr('common-use', '1');
        // });

        // Ĭ�ϵ�������ѡ�¼�
        this.domExtWrapper.on('click', 'label', function(event) {
            // ���ε����a��ǩ����checkbox����ѡ����
            if (event.target.type == 'checkbox' || event.target.type == '') {
                return;
            }
            $(this).toggleClass('checked');
        });

        // չ��/�۵���ǩ
        $("#expandCollapseIcon").on('click', function() {
            self.domExtSelectOper.toggleClass('hide');
            self.domExtWrapper.toggleClass('collapse');
            var target = $(this);

            if (target.hasClass('collapse-icon')) {
                target.removeClass('collapse-icon');
                target.text('����չ��');
            } else {
                target.addClass('collapse-icon');
                target.text('�����۵�');
            }
        });
        // radio ѡ�����
        this.domExtSelectOper.find('input').change(function(event) {
            var target = $(this);
            var value = $(this).val();
            switch (value) {
                // ȫѡ
                case '0':
                    self.domExtWrapper.find('label').each(function() {
                        var labelDom = $(this);
                        labelDom.removeClass('checked').addClass('checked');
                        labelDom.find('input').prop('checked', 'checked');
                    });
                    break;
                // ȫ��ѡ
                case '1':
                    self.domExtWrapper.find('label').each(function() {
                        var labelDom = $(this);
                        labelDom.removeClass('checked');
                        labelDom.find('input').prop('checked', '');
                    });
                    break;
                // ����
                case '2':
                    self.domExtWrapper.find('label').each(function() {
                        var labelDom = $(this);
                        var currInput = labelDom.find('input');
                        if (currInput.attr('common-use') == '1') {
                            currInput.prop('checked', 'checked');
                            labelDom.removeClass('checked').addClass('checked');
                        } else {
                            currInput.prop('checked', '');
                            labelDom.removeClass('checked');
                        }
                    });
                    break;
            }
        });

        // ������ѯ���ύ
        $("#domainQueryForm").on('submit', function(event) {

            // 1. �ж��Ƿ�����ȷ����������
            var domName = $.trim($("#J_domName").val());
            if (!domName) {
                layer.alert('����дҪ��ѯ������!');
                return false;
            }
            var val = domName.replace(/\s/g, '');
            val = val.replace(/^\./, '');
            val = val.replace(/\.$/, '');
            // �û�ֱ������ĺ�׺
            var inputExt = val.match(/(www\.)?[^\.]*(\..*)/);
            if(inputExt){
                inputExt = inputExt[2];
            }
            val = val.replace(/\.[a-z]{2,3}\.cn$/, '.miss');

            if (val.indexOf('.') >= 0) val = val.substr(0, val.lastIndexOf('.'));
            if (val.indexOf('.') >= 0) val = val.substr(0,val.lastIndexOf('.'));
            $("#J_domName").val(val);
            domName = val;
            // var domReg = /^[-0-9a-zA-Z\u4e00-\u9fa5]+$/;
            // ֻ�ܰ��� ��ĸ����_ ,�����ط���������
            var domReg = /[^0-9a-zA-Z-\u4e00-\u9fa5]/;
            // �»��߲����ڿ�ͷ����β���Լ�����
            var repeat_ = /-{2,}|^-|-$/;
            if (domReg.test(domName) || repeat_.test(domName)) {
                layer.alert('��������������������ע�������ȷ�ϡ�');
                event.preventDefault();
                return false;
            }
            // 2. �ж��Ƿ�ѡ��������׺
            var domExts = [];
            self.domExtWrapper.find('input:checked').each(function() {
                domExts.push($(this).val());
            });
            // ���û�й�ѡ��׺ �� �û�û�������׺
            if (domExts.length == 0&&!inputExt) {
                layer.alert('���ȹ�ѡҪ��ѯ�ĺ�׺!');
                event.preventDefault();
                return false;
            }

            // ����׺ ����û������˺�׺  ��ֻʹ���û��Լ��ĺ�׺
            if(inputExt){
                domExts = [inputExt];
            }
            $("#J_querySuffix").val(domExts.join(','));

            var isGetToken = false;
            $.ajax({
                async: false,
                type: 'GET',
                cache: false,
                url: '/gettoken.asp?act=gettok',
                data: null,
                dataType: 'script',
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('��ȡ����ʧ��,�����²�ѯһ��');
                    return;
                },
                success: function() {
                    isGetToken = true;
                }
            });

            if (isGetToken) {
                return true;
            } else {
                event.preventDefault();
                return false;
            }
        });
    },
    // �����Ƽ�
    initHotListTab: function() {
        // ��ǰѡ�е�tab ��ǩ
        var currentTabLink = $("#hotListTab a.active");
        // ѡ�еı�ǩ��Ӧ������ id
        var currentHotContentId = currentTabLink.attr('data-target');

        var currentHotContent = $("#" + currentHotContentId);

        // ����
        currentHotContent.removeClass('active').addClass('active');

        // ע��tab����¼�
        var prevColumnFlagItem = $("#J_columnFlag_1");
        $("#hotListTab").on('click', 'a', function(event) {

            // �Ƴ�֮ǰѡ�е�tab����������
            currentTabLink.removeClass('active');
            currentHotContent.removeClass('active-columnList');
            // ��ǰѡ���tab������
            currentTabLink = $(event.target);
            currentHotContent = $("#" + currentTabLink.attr('data-target'));

            // ִ��ѡ��
            currentTabLink.removeClass('active').addClass('active');
            currentHotContent.removeClass('active-columnList').addClass('active-columnList');

            // �л������flag
            var flagIndex = $(this).attr('data-index');
            prevColumnFlagItem.removeClass('active-column-flag');
            prevColumnFlagItem = $("#J_columnFlag_" + flagIndex);
            prevColumnFlagItem.addClass('active-column-flag');

        }).on('mouseover', 'a', function(event) {
            if (!$(this).hasClass('active')) {
                $(this).trigger('click');
            }
        });
        // ע���Ʒչʾtab�������¼�  ������
        $("#hotRecommand").on('click', 'div.column', function() {
            // alert('click recommand div.column');
        });

        // ע���Ʒչʾtab������ hover�¼�
        $(".columnList").each(function(index, el) {
            // Ĭ�ϸ���һ�����Ͼ۽�
            var defaultColumnItem = $(".column:first");
            $(this).on('mouseover', 'div.column', function(event) {
                if (defaultColumnItem.get(0) != this) {
                    defaultColumnItem.removeClass('hover');
                }
                defaultColumnItem = $(this);
                if (!defaultColumnItem.hasClass('hover')) {
                    defaultColumnItem.addClass('hover');
                }
            });
        });

    },
    renderDomainTipInfo: function(domainName, domainLink, domainJSON) {
        if (domainName != '.gov.cn') {
            // .cn��β
            if (/\.cn$/.test(domainName)) {
                domainName = '.cn'
            }
        }

    },
    init: function() {
// ����banner��ʼ��
        $("#banner").length && $("#banner").slide({
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
        // ���placehoder֧��
        WJF.uiTool.placeholder("#J_domName");
        // �������ݼ���
        $("#J_domName").on('keyup', function() {
            if ($(this).val() == '') {
                $("#J_clearInput").hide();
            } else {
                $("#J_clearInput").show();
            }
        });
        $("#J_clearInput").on('click', function() {
            $('#J_domName').val('');
            $(this).hide();
        });
       
        // ������ѯ����
        this.initDomainQuery();
        // �����Ƽ�
        this.initHotListTab();

    }
};
$(function() {
	$("#domextWrapper").html(getdomaininput(domainconfig.hot,1,10));
    newMainIndex.init();
})

function getdomaininput(obj_,n_,max_)
{
    temp_="";
    for (var i=0;i<obj_.length ;i++ )
    {
        suffix=obj_[i].suffix;
        checkedclass_ = "";
        obj_[i].ischeck==1?checked_='checked="checked"':checked_='';
        obj_[i].ischeck==1?checkedclass_='checked':checkedclass_='';
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
            checkedclass_+=' collapsed-domain'
        }
        checkedclass_ = ' class="'+checkedclass_+'" '
        temp_+=' <label '+checkedclass_+'  for="label_for_'+n_+'_'+i+'"><input name="suffix"  '+checked_+'  value="'+suffix+'" type="checkbox" common-use="'+obj_[i].ischeck+'" id="label_for_'+n_+'_'+i+'">'+suffix+' '+i_msg+'</label>';
    }

    return temp_;
}