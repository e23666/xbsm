/*banner*/


/**
 * ҳ�涥�����Ҳ��������˵�
 */

// ȫ���������˵�ѡ�е�ID
var globalDefaultMainNavMenuId = null;
if (typeof(CURRENT_MENU_ID) != 'undefined') {
    globalDefaultMainNavMenuId = CURRENT_MENU_ID;
}

function checkLoginForm(formObj) {
    if (formObj.u_name.value == "") {
        layer.alert("�û�������Ϊ�գ�");
        formObj.u_name.focus();
        return false;
    }
    if (formObj.u_password.value == "") {
        layer.alert("���벻��Ϊ�գ�");
        formObj.u_password.focus();
        return false;
    }
}
/**
 * ѡ���������˵�
 * @param  {[type]} menuId [description]
 * @return {[type]}        [description]
 */
function selectNavMenu(menuId) {
    globalDefaultMainNavMenuId && $("#J_mainMenu_" + globalDefaultMainNavMenuId).removeClass('current');
    globalDefaultMainNavMenuId = menuId;
    $("#J_mainMenu_" + globalDefaultMainNavMenuId).addClass('current');
}
// ɾ�����ﳵ
function del_shopcart_one(id_) {
    $.post("/bagshow/", "act=del&checkitem=" + id_, function(data) {
        if (data == "200 ok") {
            load_myshopcart()
        }

    })
}
// ���ع��ﳵ
function load_myshopcart() {
    $.post("/getmyshopcart.asp", "", function(json) {

        $(".top_shopcar_count").html(json.shopcart.count);
        $(".top_shopcar_sum").html(json.shopcart.sum);
        var tbobj = $(".shopping-car-list")
        tbobj.empty();
        for (var i = 0; i < json.shopcart.datas.length; i++) {
            var id_ = json.shopcart.datas[i].id
            var name_ = json.shopcart.datas[i].name
            var proid_ = json.shopcart.datas[i].proid
            var price_ = json.shopcart.datas[i].price
            tbobj.append('<tr id="top_shopcar_line_' + id_ + '"><td class="shopping-name"><a href="javascript:void(0)" >' + name_ + '</a></td><td class="shopping-price">' + price_ + '</td><td  class="shopping-delete"  onclick="del_shopcart_one(' + id_ + ')"></td></tr>')
        }
    }, "json")
}
// ���ﳵ��ʼ��
$(function() {
    load_myshopcart();
	load_topnews();
});

function load_topnews()
{
	$(".txtList").empty();
	$.post("/noedit/ajax.asp","act=gettopnews",function(data){
		for(var i=0;i<data.datas.length;i++)
		{
			var obj=data.datas[i];
			$(".txtList").append('<li><em>&nbsp;</em> <a href="/news/list.asp?newsid='+obj.id+'" class="text-overflow" target="_blank">'+obj.title+'</a></li>')
		}
		//	alert(data.datas)
	   add_notice_style(data.datas);
	},"json")
}

// ���¹��� ��������߼�  ��ʼ

if (!localStorage.Noticeliststa) {
    localStorage.Noticeliststa = [0, 0, 0, 0,0]
}
if (localStorage.Noticelistcon) {
    localStorage.removeItem("Noticelistcon")
}
var datasta = localStorage.Noticeliststa.split(",");

function add_notice_style(obj) {
	 //nav_top_json
    if (!localStorage.Noticelistconm||localStorage.Noticelistconm=="[]") {
       //console.log("11111111")
        localStorage.Noticelistconm = JSON.stringify(obj);
        //��һ����������
        for (i = 0; i < obj.length; i++) {
			
            if (obj[i].day <= 20) {
                $("#topnav-notice").children("ol").children("li").eq(i).children("em").css("background-color", "red");
                $("#topnav-notice").children("ol").children("li").eq(i).attr("onclick", "notice_click(this)");
            } else {
                datasta[i] = "1";
                localStorage.Noticeliststa = datasta;
            }
        }
		
    } else {
		// console.log("[222222222]")
		//	 localStorage.Noticelistconm=""
        var datacon = JSON.parse(localStorage.Noticelistconm);
		
      

        for (i = 0; i < datacon.length; i++) {
            var old_notice = datacon[i];
            if (old_notice.id != obj[i].id) {
                if (obj[i].day <= 10) {
                    $("#topnav-notice").children("ol").children("li").eq(i).children("em").css("background-color", "red");
                    $("#topnav-notice").children("ol").children("li").eq(i).attr("onclick", "notice_click(this)");
                    datasta[i]='0';
                } else {
                    datasta[i] = "1";
                    //���±��ش洢
                    localStorage.Noticeliststa = datasta;
                }
                old_notice.id=obj[i].id;
                old_notice.day=obj[i].day;
                datacon[i]=JSON.stringify(old_notice);
            } else {
                if (datasta[i] == "0" && obj[i].day <= 20) {
                    $("#topnav-notice").children("ol").children("li").eq(i).children("em").css("background-color", "red");
                    $("#topnav-notice").children("ol").children("li").eq(i).attr("onclick", "notice_click(this)");
                }
                   else{
					   datasta[i] = "1";
                    //���±��ش洢
                    localStorage.Noticeliststa = datasta;
                }
            }
			localStorage.Noticelistconm = JSON.stringify(datacon)
        }
		//alert(datacon)
      
    }
    count_message();
}

//�ж�δ����Ϣ���������
function count_message() {
    var num = 0;
    for (i = 0; i < datasta.length; i++) {
        if (datasta[i] == "0") {
            num = num + 1;
        }
    }
    if (num == 0) {
        $(".notice_all_bg").hide()
        $("#noread_notice_all").remove();
        $("#noread_countbox").children(".count_noread_all").hide();
        $("#noread_countbox").show();
        $(".allread_notice").text("��");
        return false;
    } else {
        $(".notice_all_bg").show()
        $("#noread_notice_all").remove();
        $(".news-notice").children("span").eq(0).after("<span style='color:#fe7402;font-size:14px;vertical-align:middle;' id='noread_notice_all'>" + num + "</span>");
        $("#noread_countbox").children(".count_noread_all").text(num + "��δ��").attr("onclick", "ignore_notice()");
        $(".allread_notice").text("");
        $("#noread_countbox").show();
    }
}

function notice_click(obj) {
    var num = $(obj).index();
    datasta[num] = "1";
    localStorage.Noticeliststa = datasta;
    //��������ת����Ҫ�Ƴ��¼��Ƴ���ʽ��
    $(obj).children("em").css("background-color", "#a0a0a0");
    $(obj).removeAttr("onclick");
    count_message();
}

function ignore_notice() {
    datasta = [1, 1, 1, 1]
    localStorage.Noticeliststa = [1, 1, 1, 1];
    $("#topnav-notice").children("ol").children("li").children("em").css("background-color", "#a0a0a0");
    $("#topnav-notice").children("ol").children("li").removeAttr("onclick", "notice_click(this)");
    count_message();
}
 
// ���¹��� ��������߼�  ����
// ������������ʼ��
$(function() {

    // ������в˵��Ĺ�����Ϣ
    $("#J_mainNavWrapper .scroll-msg-container").html($("#J_scrollMsgContent").html());


    $(".westdialogopen").click(function() {
        var me = $(this);
        var link_ = me.attr("href");
        var title = me.attr("title");
        var diaid = "westdialogopen_me";
        if (link_.substr(1, 1) != "/") {
            diaid += "qq";
        }
        $.dialog({
            title: title,
            width: 800,
            height: 500,
            content: "url:" + link_,
            zIndex: 9999999,
            id: diaid
        })
        return false;
    });

    // �����¼�ע��
    $(".common-dropdown-container").hover(function() {
        var target = $(this);
        clearTimeout(target.attr('data-timehandler'));
        var timeoutHandler = setTimeout(function() {
            target.find('.menu').addClass('hover');
            target.find('.common-dropdown').stop().slideDown(300);
        }, 100);
        target.attr('data-timehandler', timeoutHandler);
    }, function(event) {
        // ���ε�firefox �������Ϊ�û��� autocomplete ѡ��ʱ����ʧȥ���� �Ӷ������۵���bug
        if (event.target.name == "u_name") {
            return;
        }
        var target = $(this);
        clearTimeout(target.attr('data-timehandler'));
        if (typeof(WJF_DEBUG) != 'undefined') {
            return;
        }
        target.find('.menu').removeClass('hover');
        target.find('.common-dropdown').stop().slideUp(200);
    });

    var browser = {
        versions: function() {
            var u = navigator.userAgent,
                app = navigator.appVersion;
            return { //�ƶ��ն�������汾��Ϣ
                trident: u.indexOf('Trident') > -1, //IE�ں�
                presto: u.indexOf('Presto') > -1, //opera�ں�
                webKit: u.indexOf('AppleWebKit') > -1, //ƻ�����ȸ��ں�
                gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //����ں�
                mobile: !!u.match(/AppleWebKit.*Mobile.*/), //�Ƿ�Ϊ�ƶ��ն�
                ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios�ն�
                android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android�ն˻���uc�����
                iPhone: u.indexOf('iPhone') > -1, //�Ƿ�ΪiPhone����QQHD�����
                iPad: u.indexOf('iPad') > -1, //�Ƿ�iPad
                webApp: u.indexOf('Safari') == -1 //�Ƿ�webӦ�ó���û��ͷ����ײ�
            };
        }(),
        language: (navigator.browserLanguage || navigator.language).toLowerCase()
    };
    // �ƶ���
    if (false) {
        // �����������˵�������ת
        var currActiveNavMenu = null;
        $("#J_mainNavWrapper").on('click', 'a.nav-menu', function(event) {
            // ��ǰչ�������˵�
            if (currActiveNavMenu && currActiveNavMenu != this) {
                $(currActiveNavMenu).removeClass('hover').siblings('.nav-content').removeClass('active').stop().slideUp(200);
            }
            // ��ҳֱ��ת
            if (this.id == 'J_mainMenu_sy') {
                currActiveNavMenu = null;
                return;
            }
            // �����Ӧ�Ĳ˵����� ��ʾ��  ֱ����תҳ��
            var navContent = $(this).siblings('.nav-content');
            if (navContent.hasClass('active')) {
                return;
            } else {
                navContent.addClass('active').stop().slideDown(300);
                $(this).addClass('hover');
            }
            currActiveNavMenu = this;
            event.preventDefault();
        });
    } else {
        // ������
        var mainNavInTimeoutHandle;
        var mainNavOutTimeoutHandle;
        $("#J_mainNavWrapper >li").hover(function() {
            var currentLink = $(this).find('a.nav-menu');
            var targetNavContent = $(this).find('.nav-content');
            clearTimeout(mainNavInTimeoutHandle);
            mainNavInTimeoutHandle = setTimeout(function() {
                currentLink.addClass('hover');
                // ���ÿ���޸�ie7�� ��������չ������
                targetNavContent.addClass('active').css('width', $('body').width() + 'px').stop().slideDown(300);
            }, 150);
        }, function() {
            if (typeof(WJF_DEBUG) != 'undefined') {
                return
            }
            clearTimeout(mainNavInTimeoutHandle);
            var currentLink = $(this).find('a.nav-menu');
            var targetNavContent = $(this).find('.nav-content');
            mainNavOutTimeoutHandle = setTimeout(function() {
                currentLink.removeClass('hover');
                targetNavContent.removeClass('active').stop().slideUp(200);
            }, 150);
            targetNavContent.attr('data-timehandler', mainNavOutTimeoutHandle);
        });
        $("#J_mainNavWrapper .nav-content").hover(function() {
            clearTimeout($(this).attr('data-timehandler'));
            $(this).show();
        });
    }
    // ie6 ֧��
    if (typeof(DD_belatedPNG) != 'undefined') {
        // ���placehoder֧��
        // WJF.uiTool.placeholder("#J_u_name");
        // WJF.uiTool.placeholder("#J_u_password");
    }
    // ָ����ȫ���������˵�ID
    if (globalDefaultMainNavMenuId) {
        selectNavMenu(globalDefaultMainNavMenuId);
    } else {
        // ���ݵ�ǰҳ��URLƥ��
        var pageUrl = document.URL.toLowerCase();
        var dftMenu = '';
        if (pageUrl.indexOf("/services/domain/auction") >= 0) {
            dftMenu = 'ymzc';
        }else if (pageUrl.indexOf("/services/webhosting/sites.asp") >= 0) {
            dftMenu = 'cpwz';
		}else if (pageUrl.indexOf("/services/webhosting/cloudhost.asp") >= 0) {
            dftMenu = 'yxj';
        } else if (pageUrl.indexOf("/webhosting") >= 0) {
            dftMenu = 'xnzj';
        } else if (pageUrl.indexOf("/services/sites/") >= 0) {
            dftMenu = 'yjz';
        } else if (pageUrl.indexOf("/diysite") >= 0) {
            // dftMenu = '3';
        } else if (pageUrl.indexOf("/server") >= 0) {
            dftMenu = 'zjzy';
        } else if (pageUrl.indexOf("/cloudhost") >= 0) {
            dftMenu = 'yfwq';
        } else if (pageUrl.indexOf("/vpsserver") >= 0) {
            dftMenu = 'vps';
        } else if (pageUrl.indexOf("/domain") >= 0) {
            dftMenu = 'ymzc';
        } else if (pageUrl.indexOf("/mail") >= 0) {
            dftMenu = 'qyyj';
        } else if (pageUrl.indexOf("/agent") >= 0) {
            dftMenu = 'dlzq';
        } else if (pageUrl.indexOf("/jiaoyi") >= 0) {
            dftMenu = 'ymjy';
		} else if (pageUrl.indexOf("/miniprogram") >= 0) {
            dftMenu = 'xcx';
        } else if (pageUrl.indexOf("/ssl") >= 0) {
            dftMenu = 'ssl';
        } else if (pageUrl.indexOf("/customercenter") >= 0 || pageUrl.indexOf("/faq") >= 0) {
            // dftMenu = 10;
        }
        if (dftMenu) {
            selectNavMenu(dftMenu);
        } else {
            // ѡ����ҳ
            (window.location.pathname == "/" || window.location.pathname == '/default.asp') && selectNavMenu('sy');
        }
    }
});

// ��������
$(function() {
    $("#J_globalNotice .expand").on('click', function() {
        var expand = $(this);
        // ��ǰ�Ѿ�չ����
        if (expand.hasClass('collapse')) {
            expand.removeClass('collapse');
            $("#J_globalNotice .notice-content").removeClass('notice-content-expanded');
            expand.text('չ����ʾ');
        } else {
            expand.addClass('collapse');
            $("#J_globalNotice .notice-content").addClass('notice-content-expanded');
            expand.text('������ʾ');
        }
    });
    $("#J_globalNotice .close").on('click', function() {
        $("#J_globalNotice").fadeOut();
        document.cookie = 'HIDE_G_NOTICE=1;'
    });
});

// ���������
$(function() {
    // �ұ߲�������
    var rightMenuBarContainer = $("#rightMenuBar2016");
    if (!rightMenuBarContainer.length) {
        return;
    }
    // �������ʾ�Ҳ��� �����øñ�ʾΪfalse
    if (typeof(G_SHOW_RIGHT_BAR) != 'undefined' && G_SHOW_RIGHT_BAR === false) {
        rightMenuBarContainer.hide();
        return;
    }
    var minHeight = 100;
    $(window).scroll(function() {
        var s = $(window).scrollTop();
        if (s > minHeight) {
            $("#J_backTop").addClass('back-top-visible');
        } else {
            $("#J_backTop").removeClass('back-top-visible');
        }
    });
    $(window).trigger('scroll');
    $("#J_backTop").on('click', function() {
        $('html,body').stop();
        $('html,body').animate({
            scrollTop: 0
        }, 400, 'swing');
        return false;
    });
    // �������
    var prevLink = null;
    $("#J_rightBarMenuContainer").on('click', 'a', function(event) {
        var currentLink = $(this);
        prevLink && prevLink.removeClass('hover');
        currentLink.addClass('hover');

        var concatPhoneContainer = $("#J_concatPhoneContainer");
        // �绰����
        if (currentLink.hasClass('phone')) {
            if (concatPhoneContainer.hasClass('active-concat-container')) {
                concatPhoneContainer.removeClass('active-concat-container');
                currentLink.removeClass('hover');
            } else {
                concatPhoneContainer.addClass('active-concat-container');
            }
        } else {
            concatPhoneContainer.removeClass('active-concat-container');
        }
        prevLink = currentLink;
    });

    // ��ϵ�绰
    $("#J_concatPhoneContainer").on('click', '.close', function() {
        $('#J_concatPhoneContainer').removeClass('active-concat-container');
        $("#J_rightBarMenuContainer a.phone").removeClass('hover');
    });

    // �رղ���
    $("#J_closeRightBar").on('click', function() {
        rightMenuBarContainer.css('right', '-40px');
        rightMenuBarContainer.addClass('mini-right-menu-bar');
        var date = new Date();
        date.setTime(date.getTime() + (30 * 24 * 60 * 60 * 1000));
        document.cookie = '_rbarStatus_=0;expires=' + date.toUTCString() + ';path=/;';
        return false;
    });
    // չ������
    $("#J_expandRightBar").on('click', function() {
        rightMenuBarContainer.removeClass('mini-right-menu-bar');
        rightMenuBarContainer.css('right', '0px');
        var date = new Date();
        date.setTime(date.getTime() + (30 * 24 * 60 * 60 * 1000));
        document.cookie = '_rbarStatus_=1;expires=' + date.toUTCString() + ';path=/;';
        return false;
    });
    setTimeout(function() {
        // ��ʼ������
        if (document.cookie.match(/_rbarStatus_=0/) /*|| document.body.clientWidth < 1190*/ ) {
            // ��Ӳ�����С�����
            rightMenuBarContainer.addClass('mini-right-menu-bar');
        } else {
            rightMenuBarContainer.css('right', '0px');
        }
    }, 1000);
});
$(function() {
    // IE 67 ��ʾ��Ϣ
    var appName = navigator.appName,
        appVersion = navigator.appVersion;
    if (appName == "Microsoft Internet Explorer" &&
        (navigator.appVersion.match(/7./i) == "7." || navigator.appVersion.match(/6./i) == "6.")) {
        if (document.cookie.match(/_BW_NOTICE=0/)) {
            return;
        }
        $("#J_browserNotice .close").on('click', function() {
            document.cookie = '_BW_NOTICE=0;path=/;';
            $("#J_browserNotice").hide();
        });
    }
});
