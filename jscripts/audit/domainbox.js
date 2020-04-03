(function ($){
	$.SelectDomain = function (fn) {
		var lbox = layer.loading(3);
		 $.get("/config/loadbox/domainlistbox.asp", function (html) {
            layer.close(lbox);
            layer.open({
                type: 1,
                title: "域名选择器" ,
                content: html,
                btn: ['添加选择的域名','关闭'],
                area: ['800px'],
                resize: false,
                yes: function (index, layero) {
                    var darr = $.SelectDom();
                    if (darr.length == 0) {
                        return false;
                    }
                    if ($.isFunction(fn)) {
                        fn(darr);
                    }
                    layer.close(index); 

                },
                success: function (layero, indexs) {
                   $("form[name='formdata']").data("overfun", function () {
                        layer.render_(layero, indexs);
                    });
                    $("form[name='formdata']").data("overfun").call();
                },
                end: function () {
                    
                }
            });
			 $.setsearchbox();
		 });
	}

	$.SelectDom = function () {
        var arr = [];
        var o = $("ul.bodyline").find("input[name=sysid]:checked");
        if (o.size() == 0) {
            $.dialog.tips('请先勾选域名！');
        } else {
            o.each(function () {
                var j = {};
                j["dom"] = this.title;
                j["did"] = this.value;
                arr.push(j);
            })
        }
        return arr;
    }

	$.setsearchbox = function () { 
                        $.Action([$.loadbody()]);
                        $.searchbind();
						 $("form[name='formdata']").data("overfun").call();
    }

	$.searchbind = function () {
        $("input[name='searchbtn']").click(function () {
            $.Action([$.loadbody()]);
        });
        $("form[name='frmsearch']").find("select[name='pagesize']").remove();
        if (typeof WJF != "undefined") {
            new WJF.ui.select({
                dom: 'mydekeyword1',
                selectContainerWidth: 220,
                itemHeight: 20,
                // 1 反填value 2 反填vlue
                autoFillType: 2,
                data: ["a,e,i,o,u,v", "i,o,u,v", "0,4", "0,4,a,e,i,o,u,v", "0,a,e,i,o,u,v", "4,a,e,i,o,u,v"],
                wrapper: true
            });
        }
    }

	 $.loadbody = function (otherstr) {
		 var querystr = "act=dmlist";
        if ($("form[name='frmsearch']").serialize() != "") querystr += "&" + $("form[name='frmsearch']").serialize();
        if (typeof (otherstr) != "undefined") querystr += "&" + otherstr;
		var bodyjson = {
            url: "/manager/domainmanager/contactinfo/newajax.asp", data: querystr,
            beforeSend: function () {
                $("form[name='formdata']").html(template("domboxload_tmp"));
            }, success: function (data) {
                data = $.getjson(data);
                if ($.isjson(data)) {
                    var datalist = $.formatbodyjson(data);
                    $("form[name='formdata']").html(template("bodylist_tmp", datalist));
                    $.pageload($("#pagejsonbox")[0], datalist.pagelist, ['prev', 'page', 'next', 'limit', 'count'], function (pageobj) {
                        var pagedata = "pageno=" + pageobj.curr + "&pagesize=" + pageobj.limit;
                        $.Action([$.loadbody(pagedata)]);
                    });
                    $("form[name='frmsearch'] .dropdate").each(function (i, n) {
                        laydate.render({
                            elem: n
                            , trigger: "click"                            
                            , theme: "#2086ee"
                            , calendar: true
                        });
                    });

                    $("form[name='frmsearch'] input[name='alldombcheck']:checkbox").click(function () {
                        $(".bodyline input[name='sysid']:checkbox").prop("checked", $(this).prop("checked"));
                    });
                    $("form[name='formdata']").data("overfun").call();
                } else {
                    $("form[name='formdata']").html(data);
                }
            }, error: function (a, b, c) {
                $("form[name='formdata']").html(a + b + c);
            }
        }
        return bodyjson;
	 
	 }

	$.formatbodyjson = function (bodyjson) {
        var newjson = { "datalist": bodyjson.datas, "pagelist": { "pagecount": bodyjson.pagecount, "linecount": bodyjson.rowcount, "pageno": bodyjson.pageno, "pagesizes": bodyjson.pagesize } };
        return newjson;
    }

	$.pageload = function (pagebox, pagelist, layout, fun) {
			if (pagebox) {
				if (pagelist) {
					laypage.render({
						elem: pagebox //ID，不用加 # 号					
						, count: pagelist.linecount //数据总数，从服务端得到
						, curr: pagelist.pageno
						, limit: pagelist.pagesizes
						, limits:[10,50,100,200,500,1000,3000]
						, theme: '#FF5722'
						, layout: layout
						, jump: function (obj, first) {
							if (!first) {
								fun.call(this, obj);
							}
						}
					});
				}
			}
		}

 
}(jQuery))