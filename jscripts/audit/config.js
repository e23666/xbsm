(function ($) {
    //这里放入插件代码	
    $.extend({
        Action: function (arr, overfn) {
            var self = this;
            if (arr.length > 0) {
                var isnext = true;
                var jsonitem = arr.shift();
                var oldbeforeSend = jsonitem && jsonitem.beforeSend ? jsonitem.beforeSend : null;
                var oldcomplete = jsonitem && jsonitem.complete ? jsonitem.complete : null;
                var oldsuccess = jsonitem && jsonitem.success ? jsonitem.success : null;
                jsonitem.success = function (data) {
                    if ($.isFunction(oldsuccess)) {
                        var cr = oldsuccess.call(self, data);
                        isnext = (cr == undefined) || cr;
                    }
                }
                jsonitem.complete = function (xml) {
                    var isnext1 = true;
                    if ($.isFunction(oldcomplete)) {
                        var cr = oldcomplete.call(self, xml);
                        isnext1 = (cr == undefined) || cr;
                    }
                    xml = null;
                    if (isnext && isnext1) $.Action.call(self, arr, overfn);
                };
                jsonitem.beforeSend = function () {
                    if ($.isFunction(oldbeforeSend)) {
                        var cr = oldbeforeSend.call(self);
                        if (!cr) $.Action.call(self, arr, overfn);
                    }
                };
                $.ajax(jsonitem);
            } else {
                if ($.isFunction(overfn)) {
                    overfn();
                }
            }
        },
        getjson: function (data) {
            var datainfo;
            var reg_ = /<script[\s\S]+<\/script>/;
            data = data.replace(reg_, '');
            if (data.indexOf("{") >= 0 || data.indexOf("[") >= 0) {
                datainfo = eval("(" + data + ")");
            } else {
                datainfo = data;
            }
            return datainfo;
        },
        isjson: function (obj) {
            return typeof (obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
        },
        isbase64: function (str) {
            return (/^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$/ig.test(str));
        },
        escape_b64: function (Keyword) {
            return escape(Keyword.replace(/\·/ig, ".")).replace(/\+/ig, "%2B").replace(/\//ig, "%2F");
        },
        jsonencode: function (jsonstr) {
            jsonstr.replace(/\\n/g, "\\n").replace(/\\'/g, "\\'").replace(/\\"/g, "\\\"").replace(/\\&/g, "\\&").replace(/\\r/g, "\\r").replace(/\\t/g, "\\t").replace(/\\b/g, "\\b").replace(/\\f/g, "\\f");
            return jsonstr;
        },
        urlencode: function (text) {
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
        ConvertArray: function (o) { //将serializeArray()系列化后的值转为name:value的形式。 
            var v = {};
            for (var i in o) {
                if (typeof (v[o[i].name]) == 'undefined') v[o[i].name] = o[i].value;
                else v[o[i].name] += "," + o[i].value;
            }
            return v;
        }
    });

}(jQuery))
if ("defaults" in template) {
    template.defaults.imports.outstr = function (v, k) {
        if (typeof (v) == "object")
            return eval("'" + k + "' in v") ? eval("v." + k) : ""
        else
            return "";
    }
    template.defaults.imports.isin = function (v, k) {
        if (typeof (v) == "object")
            return eval("'" + k + "' in v");
        else
            return false;
    }
    template.defaults.imports.isarray = function (v) {
        return $.isArray(v);
    }
    template.defaults.imports.Number = function (v) {
        return Number(v);
    }
    template.defaults.imports.escape_b64 = function (v) {
        return $.escape_b64(v);
    }
    template.defaults.imports.jsonlength = function (obj) {
        var size = 0, key;
        if ($.isjson(obj)) {
            for (key in obj) {
                if (obj.hasOwnProperty(key)) size++;
            }
        }
        return size;
    }
}