(function($) {
    //这里放入插件代码	
    $.extend({
        loadbox: function() {
            return $.dialog({
                title: false,
                content: "<div style=\"width:100px; text-align:center\"><img src=\"/newimages/facebox/loading.gif\" alt=\"加载中,请稍候..\"></div>",
                esc: false,
                lock: true,
                min: false,
                max: false
            })
        },
        okalert: function(title, content, fn) {
            return $.dialog({
                title: title,
                content: content,
                lock: true,
                min: false,
                max: false,
                icon: "success.gif",
                minWidth: 200,
                button: [{
                    name: unescape("%u786E%u5B9A"),
                    focus: true
                }],
                close: function() {
                    if ($.isFunction(fn)) {
                        fn.call();
                    }
                }
            });
        },
        alert: function(title, content, fn) {
            return $.dialog({
                title: title,
                content: content,
                lock: true,
                min: false,
                max: false,
                icon: "alert.gif",
                minWidth: 200,
                button: [{
                    name: unescape("%u786E%u5B9A"),
                    focus: true
                }],
                close: function() {
                    if ($.isFunction(fn)) {
                        fn.call();
                    }
                }
            });
        },
        Action: function(arr, overfn) {
			var self=this;
            if (arr.length > 0) {				
                var isnext = true;
                var jsonitem = arr.shift();				
                var oldcomplete = "complete" in jsonitem ? jsonitem.complete: null;
                var oldsuccess = "success" in jsonitem ? jsonitem.success: null;
                jsonitem.success = function(data) {
                    if ($.isFunction(oldsuccess)) {
                        var cr = oldsuccess.call(self,data);
                        isnext = (cr == undefined) || cr;
                    }
                }
                jsonitem.complete = function(xml) {
                    var isnext1 = true;
                    if ($.isFunction(oldcomplete)) {
                        var cr = oldcomplete.call(self,xml);
                        isnext1 = (cr == undefined) || cr;
                    }
                    xml = null;
                    if (isnext && isnext1) $.Action.call(self,arr, overfn);
                };
                $.ajax(jsonitem);
            } else {
                if ($.isFunction(overfn)) {
                    overfn();
                }
            }
        },
        getjson: function(data) {
            var datainfo;
			var reg_=/<script[\s\S]+<\/script>/;
			data=data.replace(reg_,'');
            if(data.indexOf("{")>=0){
                datainfo = eval("(" + data + ")");
            } else {
                datainfo = data;
            }
            return datainfo;
        },
        isjson: function(obj) {
            return typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
        },
        escape_b64: function(Keyword) {
            return escape(Keyword).replace(/\+/ig, "%2B").replace(/\//ig, "%2F");
        },
        pagelist: function(pagejson, midsize, fn) {
            var firstfix = Number(pagejson.pageno) - midsize;
            var lastfix = Number(pagejson.pageno) + midsize;
            if (firstfix < 1) firstfix = 1;
            if (lastfix > Number(pagejson.pagecount)) lastfix = Number(pagejson.pagecount);
            var pg_first = [];
            var pg_last = [];
            var for_first = "";
            var for_last = "";
            for (var ii = firstfix; ii <= lastfix; ii++) {
                if (ii < Number(pagejson.pageno)) {
                    pg_first.push(ii);
                } else if (ii > Number(pagejson.pageno)) {
                    pg_last.push(ii);
                }
            }
            if (firstfix > 1) {
                for_first = firstfix - (1 + midsize);
            }
            if (lastfix < pagejson.pagecount) {
                for_last = lastfix + (1 + midsize);
            }
            var newjson = {
                pagesizes: Number(pagejson.pagesizes),
                "pg_first": pg_first,
                "pg_last": pg_last,
                "for_first": for_first,
                "for_last": for_last,
                "pageno": Number(pagejson.pageno),
                "pagecount": Number(pagejson.pagecount),
                "linecount": Number(pagejson.linecount),
                "midsize": midsize
            };

            if ($.isFunction(fn)) {
                fn(newjson);
            }
            return newjson;
        },
        request: function(strParame) {
            var args = new Object();
            $.each($("script[src*='?']"),
            function(ii, nn) {
                $.each($(nn).attr("src").split("?")[1].split("&"),
                function(i, n) {
                    var pos = n.indexOf('=');
                    if (pos == -1) return;
                    var argname = n.substring(0, pos);
                    var value = n.substring(pos + 1);
                    value = value;
                    args[argname] = value;
                });
            });
            var result = args[strParame];
            return "undefined" == typeof(result) ? "": result;
        },
        chineseNumber: function(num) {
            if (isNaN(num) || num > Math.pow(10, 12))
				return "";
			var cn = "零壹贰叁肆伍陆柒捌玖";
			var unit = new Array("拾百千", "分角");
			var unit1 = new Array("万亿", "");
			var numArray = num.toString().split(".");
			var start = new Array(numArray[0].length - 1, 2);		
			function toChinese(num, index)
			{
				var num = num.replace(/\d/g, function($1)
				{
					return cn.charAt($1) + unit[index].charAt(start-- % 4 ? start % 4 : -1);
				})
				return num;
			}		
			for (var i = 0; i < numArray.length; i++)
			{
				var tmp = "";
				for (var j = 0; j * 4 < numArray[i].length; j++)
				{
					var strIndex = numArray[i].length - (j + 1) * 4;
					var str = numArray[i].substring(strIndex, strIndex + 4);
					var start = i ? 2 : str.length - 1;
					var tmp1 = toChinese(str, i);
					tmp1 = tmp1.replace(/(零.)+/g, "零").replace(/零+$/, "");
					tmp1 = tmp1.replace(/^壹拾/, "拾");
					tmp = (tmp1 + unit1[i].charAt(j - 1)) + tmp;
				}
				numArray[i] = tmp;
			}		
			numArray[1] = numArray[1] ? numArray[1] : "";
			numArray[0] = numArray[0] ? numArray[0] + "元" : numArray[0], numArray[1] = numArray[1].replace(/^零+/, "");
			numArray[1] = numArray[1].match(/分/) ? numArray[1] : numArray[1] + "整";
			return numArray[0] + numArray[1];
        },
        jsonencode: function(jsonstr) {
            jsonstr.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, "\\\"").replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f");
            return jsonstr;
        },
        pagelistbind: function(pagejson, pagefun) {
            var setpagesize = $("#pagejsonbox select[name='setpagesize']");
            var topagenobtn = $("#pagejsonbox input[name='topagenobtn']:button");
            var topageNo = function(tagpgn) {
                if (/^\d+$/ig.test(tagpgn) && Number(tagpgn) >= 1 && Number(tagpgn) <= Number(pagejson.pagecount)) {
                    var pageinfo = "pageno=" + tagpgn;
                    if (setpagesize.get(0)) {
                        pageinfo += "&pagesize=" + setpagesize.val();
                    }
                    pagefun(pageinfo);
                }
            }
            if (setpagesize.get(0)) {
                if (/^\d+$/.test(pagejson.pagesizes)) {
                    setpagesize.val(pagejson.pagesizes);
                }
                setpagesize.unbind().change(function() {
                    var pageinfo = "pagesize=" + $(this).val();
                    pagefun(pageinfo);
                });
            }
            topagenobtn.unbind().click(function() {
                var topageno = $("input[name='topageno']:text").val();
                topageNo(topageno);
            });
            $("#pagejsonbox").find("a[data-tagpgn]").unbind().click(function() {
                var tagpgn = $.trim($(this).attr("data-tagpgn"));
                topageNo(tagpgn);
            });
            $(document).unbind("keyup").keyup(function(e) {
                var id = e.keyCode;
                switch (id) {
                case 37:
                    topageNo(Number(pagejson.pageno) - 1);
                    break;
                case 39:
                    topageNo(Number(pagejson.pageno) + 1);
                    break;
                }
            })
        },
        urlencode: function(text) {
            text = escape(text.toString()).replace(/\+/g, "%2B");
            var matches = text.match(/(%([0-9A-F]{2}))/gi);
            if (matches) {
                for (var matchid = 0; matchid < matches.length; matchid++) {
                    var code = matches[matchid].substring(1, 3);
                    if (parseInt(code, 16) >= 128) {
                        text = text.replace(matches[matchid], '%u00' + code)
                    }
                }
            }
            text = text.replace('%25', '%u0025');
            return text
        },
		ConvertArray: function(o) { //将serializeArray()系列化后的值转为name:value的形式。 
			var v = {}; 
			for (var i in o) { 
				if (typeof (v[o[i].name]) == 'undefined') v[o[i].name] = o[i].value; 
				else v[o[i].name] += "," + o[i].value; 
			} 
			return v; 
		},
		formToJson: function (data) {//serialize转为json
               data=data.replace(/&/g,"\",\"");
               data=data.replace(/=/g,"\":\"");
               data=eval("({\""+data+"\"})");
               return data;
         },
		 fileboxLoad:function(url,fn){//上传实名资料弹窗
				var w="640px"
				if(url.indexOf("domainaudit.")>0){
					w="550px"
				}
				var filebox=$.dialog({
					title:"实名资料",
					content:"url:"+url,
					max:false,
					min:false,
					lock:false,
					padding:0,
					cache:false					
				});
				var seeImgBox=function(filepath){				
						var api = $.dialog({title:"图片查看",id:"box_seeImgbeian",background:"#000",opacity: 0.5,fixed: false, lock: true,max:false,min:false,padding:0});	
						api.zindex();		
						var img = new Image();
						img.src = filepath;
						img.onload=function(){
							api.content("<div id=\"seeImgBox_1\" style=\"max-height:800px;max-width:900px; overflow:auto\"></div>");	
							$("#seeImgBox_1").html(img);
							api.position("50%","20%");	
						}				
				};
				var cgh=function(event) {
					  if (event.origin.indexOf("domainaudit.vhostgo.com")>=0) {// "http://domainaudit.vhostgo.com"
						var message=event.data;
						if(message!=""){		
							var regx=/([a-zA-Z]*)\|?(.*)/gi;
							if(regx.test(message)){
								var h=RegExp.$2;								
								var mss=RegExp.$1;
					
								if(!isNaN(h)){
									filebox.size(w,(Number(h)+35) + "px");	
									filebox.position("50%","20%");			
								}						
								if(mss=="success" && $.isFunction(fn)){
									fn.call(filebox);									
								}else if(mss=="seeimg"){
									seeImgBox(h);
								}
								
							}						
						}
					  }
				}
				if (typeof window.addEventListener != "undefined" && url.indexOf("domainaudit.")>0){					
					window.addEventListener('message', cgh
					, false);				
				}else{
					filebox.size(w,"550px");
					filebox.position("50%","20%");
					
				}				
				return filebox;				
			}

    });

} (jQuery))
template.helper("outstr",function(v,k){
	if (typeof(v)=="object")
		return eval("'"+k+"' in v")?eval("v."+k):""
	else
		return "";
});
template.helper("isin",function(v,k){
	if (typeof(v)=="object")
		return eval("'"+k+"' in v");
	else
		return false;
});
template.helper("isarray",function(v){
	return $.isArray(v);
});

function printstr(cn_,en_){
	var str=cn_;
	if( typeof(language) != "undefined" ){
		if(language=="en") str=en_;
	}
	return str;
}