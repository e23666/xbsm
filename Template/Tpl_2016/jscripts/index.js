var newMainIndex = {
    // 域名查询栏目
    initDomainQuery: function() {
        var self = this;
        // 域名后缀容器
        this.domExtWrapper = $("#domextWrapper");
        // 全选、反选、常用按钮容器
        this.domExtSelectOper = $("#domextSelectOper");

        // 保存常用选择
        // this.domExtWrapper.find('input:checked').each(function() {
        //     $(this).attr('common-use', '1');
        // });

        // 默认的域名勾选事件
        this.domExtWrapper.on('click', 'label', function(event) {
            // 屏蔽掉点击a标签导致checkbox被勾选问题
            if (event.target.type == 'checkbox' || event.target.type == '') {
                return;
            }
            $(this).toggleClass('checked');
        });

        // 展开/折叠标签
        $("#expandCollapseIcon").on('click', function() {
            self.domExtSelectOper.toggleClass('hide');
            self.domExtWrapper.toggleClass('collapse');
            var target = $(this);

            if (target.hasClass('collapse-icon')) {
                target.removeClass('collapse-icon');
                target.text('向下展开');
            } else {
                target.addClass('collapse-icon');
                target.text('向上折叠');
            }
        });
        // radio 选择操作
        this.domExtSelectOper.find('input').change(function(event) {
            var target = $(this);
            var value = $(this).val();
            switch (value) {
                // 全选
                case '0':
                    self.domExtWrapper.find('label').each(function() {
                        var labelDom = $(this);
                        labelDom.removeClass('checked').addClass('checked');
                        labelDom.find('input').prop('checked', 'checked');
                    });
                    break;
                // 全不选
                case '1':
                    self.domExtWrapper.find('label').each(function() {
                        var labelDom = $(this);
                        labelDom.removeClass('checked');
                        labelDom.find('input').prop('checked', '');
                    });
                    break;
                // 常用
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

        // 域名查询表单提交
        $("#domainQueryForm").on('submit', function(event) {

            // 1. 判断是否是正确的域名名称
            var domName = $.trim($("#J_domName").val());
            if (!domName) {
                layer.alert('请填写要查询的域名!');
                return false;
            }
            var val = domName.replace(/\s/g, '');
            val = val.replace(/^\./, '');
            val = val.replace(/\.$/, '');
            // 用户直接输入的后缀
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
            // 只能包含 字母数字_ ,其他地方允许中文
            var domReg = /[^0-9a-zA-Z-\u4e00-\u9fa5]/;
            // 下划线不能在开头、结尾，以及相连
            var repeat_ = /-{2,}|^-|-$/;
            if (domReg.test(domName) || repeat_.test(domName)) {
                layer.alert('您输入域名不符合域名注册规则，请确认。');
                event.preventDefault();
                return false;
            }
            // 2. 判断是否勾选了域名后缀
            var domExts = [];
            self.domExtWrapper.find('input:checked').each(function() {
                domExts.push($(this).val());
            });
            // 如果没有勾选后缀 且 用户没有输入后缀
            if (domExts.length == 0&&!inputExt) {
                layer.alert('请先勾选要查询的后缀!');
                event.preventDefault();
                return false;
            }

            // 填充后缀 如果用户输入了后缀  则只使用用户自己的后缀
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
                    alert('获取令牌失败,请重新查询一次');
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
    // 热门推荐
    initHotListTab: function() {
        // 当前选中的tab 标签
        var currentTabLink = $("#hotListTab a.active");
        // 选中的标签对应的内容 id
        var currentHotContentId = currentTabLink.attr('data-target');

        var currentHotContent = $("#" + currentHotContentId);

        // 激活
        currentHotContent.removeClass('active').addClass('active');

        // 注册tab点击事件
        var prevColumnFlagItem = $("#J_columnFlag_1");
        $("#hotListTab").on('click', 'a', function(event) {

            // 移除之前选中的tab和内容区域
            currentTabLink.removeClass('active');
            currentHotContent.removeClass('active-columnList');
            // 当前选择的tab和内容
            currentTabLink = $(event.target);
            currentHotContent = $("#" + currentTabLink.attr('data-target'));

            // 执行选中
            currentTabLink.removeClass('active').addClass('active');
            currentHotContent.removeClass('active-columnList').addClass('active-columnList');

            // 切换左侧列flag
            var flagIndex = $(this).attr('data-index');
            prevColumnFlagItem.removeClass('active-column-flag');
            prevColumnFlagItem = $("#J_columnFlag_" + flagIndex);
            prevColumnFlagItem.addClass('active-column-flag');

        }).on('mouseover', 'a', function(event) {
            if (!$(this).hasClass('active')) {
                $(this).trigger('click');
            }
        });
        // 注册产品展示tab内容区事件  区域点击
        $("#hotRecommand").on('click', 'div.column', function() {
            // alert('click recommand div.column');
        });

        // 注册产品展示tab内容区 hover事件
        $(".columnList").each(function(index, el) {
            // 默认给第一个加上聚焦
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
            // .cn结尾
            if (/\.cn$/.test(domainName)) {
                domainName = '.cn'
            }
        }

    },
    init: function() {
// 顶部banner初始化
        $("#banner").length && $("#banner").slide({
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
        // 添加placehoder支持
        WJF.uiTool.placeholder("#J_domName");
        // 输入数据监听
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
       
        // 域名查询区域
        this.initDomainQuery();
        // 热门推荐
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