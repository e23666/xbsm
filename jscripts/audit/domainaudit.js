var domainaudit = {
    configbody: { loadurl: "/manager/domainmanager/contactinfo/newajax.asp", tab: "lb", cfg: {}, cache: {}, token: null },
    init: function () {
        var thisform = $("form[name='audit_form']");
        T = this;
        T.verify();
        T.loadtab.call(thisform);
        $("#audittab li[data-tmp='" + T.configbody.tab + "']").trigger("click");
    },
    ad_init: function () {
        var thisform = $("form[name='ad_audit_form']");
        T = this;
        T.configbody.loadurl = "load.asp";
        T.configbody.isadmin = true;
        T.verify();
        T.ad_loadtab.call(thisform);
        $("#ad_audittab li[data-tmp='bdzl']").trigger("click");

    },
    auto_init: function (thisform, domainlist, fun) {
        T = this;
        T.verify();
        thisform.data("domainlist", domainlist);
        T.lbminbody.call(thisform, function () {
            if ($.isFunction(fun)) {
                fun.call(this);
            }
        });
    },
    buy_init: function () {
        var thisform = $("form[name='form1']");
        T = this;
        T.verify();
        thisform.find("button[name='regdomainbtn']").prop("disabled", true);
        var regdomain = $("select[name='regdomain']");
        var domainlist = [];
        $.each(regdomain, function (i, n) {
            domainlist.push($(n).val().replace(/^(.+?)\|[\w\|]+$/ig, "$1"));
        });
        thisform.data("domainlist", domainlist.join("\r\n"));
        T.lbminbody.call(thisform, function () {
            thisform.find("#ghlbminbox").html(this);
            thisform.find("button[name='regdomainbtn']").prop("disabled", false);
        });
    },
    push_init: function (domainjson) {
        var thisform = $("form[name='form_pushlist']");
        T = this;
        T.verify();
        thisform.find("button[name='subbtn']").prop("disabled", true);
        var domainlist = [];

        $.each(domainjson, function (i, n) {
            domainlist.push(n.domain);
        });

        thisform.data("domainlist", domainlist.join("\r\n"));
        T.lbminbody.call(thisform, function () {
            thisform.find("#ghlbminbox").html(this);
            thisform.find("button[name='subbtn']").prop("disabled", false);
        });
    },
    domainmodi_init: function (d_id) {//修改域名资料
        if (!/^\d+$/ig.test(d_id) || d_id <= 0) {
            layer.error("域名id出错" + d_id);
            return;
        };
        var thisform = $("form[name='domainmodi_form']");
        T = this;
        T.verify();
        T.domainmodibox.call(thisform, d_id);
    },
    dm_init: function () {//域名状态
        var thisform = $("form[name='formdata']");
        T = this;
        T.verify();
        T.bindfun_auditform.call(thisform);
    },
    statuslistbtn: function (obj, statusjson) {
        T = this;
        if (!statusjson && !obj[0]) return;
        var thisform = $(document.body);
        var html = template("statusbtnlist_tmp", statusjson);
        obj.html(html);
        T.bindfun_auditform.call(thisform, statusjson);
    },
    ad_loadtab: function () {
        var html = template("ad_audittab_tmp", T.configbody);
        this.before(html);
        T.ad_tabbind.call(this);
    },
    ad_tabbind: function () {
        var thisform = this;
        $("#ad_audittab li").off("click").on("click", function (e, para) {
            layer.closeAll();
            var data_tmp = $(e.target).attr("data-tmp");
            $(e.target).siblings("li").removeClass("layui-this");
            $(e.target).addClass("layui-this");
            thisform.data("reloadpage", function () { T.shenghelist.call(this, data_tmp) });
            /*
            if (data_tmp == "shenghe") {
                thisform.data("reloadpage",function(){T.shenghelist.call(thisform,data_tmp)} );
            } else if (data_tmp == "ddsb") {     
                thisform.data("reloadpage", T.ddsbload);
            } else if (data_tmp == "shtg") {
                thisform.data("reloadpage", T.shtgload);
            } else if (data_tmp == "shjj") {
                thisform.data("reloadpage", T.shjjload);
            } else if (data_tmp == "smgl") {
                thisform.data("reloadpage", T.smglload);
            }
            */
            $.hasData(thisform[0]) && $.isFunction(thisform.data("reloadpage")) && thisform.data("reloadpage").call(thisform);
        });
    },
    shenghelist: function (data_tmp) {
        var thisform = this;
        var getinfo = function () {
            var lbox = layer.loading(3);
            var formdata = $.ConvertArray(thisform.serializeArray());
            var pagedata = thisform.data("pagedata");
            var putdata = $.extend(true, { act: "shenghelist", data_tmp: data_tmp }, formdata, pagedata);
            T.dosubmit(putdata, function (jsondata) {
                if (jsondata.result == "200") {
                    jsondata.cfg = $.extend(true, {}, T.configbody.cfg);
                    var html = template("ad_infolist_tmp", $.extend(true, {}, jsondata));
                    thisform.find("#infobox").html(html);
                    var tb = { skin: 'line', size: 'lg', limit: jsondata.data.pagelist.pagesizes };
                    laytable.init("ad_infolist_table", tb);
                    T.bindfun_auditform.call(thisform, jsondata);
                    T.ishasdomain.call(thisform, true);
                } else {
                    layer.error(jsondata.msg.join(";"));
                }
            }, function () {
                layer.close(lbox);
            });
        }
        var getsearch = function () {
            var shjson = $.extend(true, { data_tmp: data_tmp }, { cfg: T.configbody.cfg });
            var schhtml = template("ad_infosearch_tmp", shjson);
            thisform.find("#searchbox_" + data_tmp).html(schhtml);
            layform.render();
            getinfo();
        }
        if (!thisform.find("#searchbox_" + data_tmp)[0]) {
            thisform.html("<div id=\"searchbox_" + data_tmp + "\"></div><div id=\"infobox\"></div>");
            T.getcfg(T.needcfg(["regtypepair", "contacttype", "statusinfo"]), function () {
                getsearch();

            });
        } else {
            getinfo();
        }
    },
    loadtab: function () {
        var html = template("audittab_tmp", T.configbody);
        this.before(html);
        T.tabbind.call(this);
    },
    tabbind: function () {
        var thisform = this;
        $("#audittab li").off("click").on("click", function (e, para) {
            layer.closeAll();
            var data_tmp = $(e.target).attr("data-tmp");
            $(e.target).siblings("li").removeClass("layui-this");
            $(e.target).addClass("layui-this");
            if (data_tmp == "lb") {
                thisform.data("reloadpage", T.lbload);
                //T.lbload.call(thisform);
            } else if (data_tmp == "tj") {
                thisform.data("reloadpage", function () {
                    $.removeData(thisform[0], "domainlist");
                    T.tjload.call(thisform, para, function (html) { thisform.html(html); });
                });
                //T.tjload.call(thisform, para, function (html) { thisform.html(html); });
            } else if (data_tmp == "gh") {
                thisform.data("reloadpage", T.ghload);
                //T.ghload.call(thisform);
            } else if (data_tmp == "zt") {
                thisform.data("reloadpage", T.ztload);
                // T.ztload.call(thisform);
            }
            $.hasData(thisform[0]) && $.isFunction(thisform.data("reloadpage")) && thisform.data("reloadpage").call(thisform);
        });
    },
    lbload: function () {//列表
        var thisform = this;
        var getinfo = function () {
            var lbox = layer.loading(3);
            var formdata = $.ConvertArray(thisform.serializeArray());
            var pagedata = thisform.data("pagedata");
            var putdata = $.extend(true, { act: "lbload" }, formdata, pagedata);
            T.dosubmit(putdata, function (jsondata) {
                if (jsondata.result == "200") {
                    jsondata.cfg = T.configbody.cfg;
                    var html = template("lbbody_tmp", $.extend(true, {}, jsondata));
                    thisform.find("#infobox").html(html);

                    var tb = { skin: 'line', size: 'lg', limit: jsondata.data.pagelist.pagesizes };
                    laytable.init("lbbodytable", tb);
                    T.bindfun_auditform.call(thisform, jsondata);
                    T.ishasdomain.call(thisform, false);
                } else {
                    layer.error(jsondata.msg.join(";"));
                }
            }, function () {
                layer.close(lbox);
            });
        }
        var getsearch = function () {
            var schhtml = template("lbsearch_tmp", T.configbody);
            thisform.find("#searchbox").html(schhtml);
            layform.render();
            getinfo();
        }
        if (!thisform.find("#searchbox")[0]) {
            thisform.html("<div id=\"searchbox\"></div><div id=\"infobox\"></div>");
            T.getcfg(T.needcfg(["regtypepair", "contacttype", "statusinfo"]), function () {
                getsearch();
            });
        } else {
            getinfo();
        }
    },
    needcfg: function (cfgtab) {
        return cfgtab.filter(function (item) {
            if (!(item in T.configbody.cfg)) {
                return item;
            }
        });
    },
    ishasdomain: function () {
        var thisform = this;
        var thisbtn = thisform.find("button[name='domainlbbtn'][data-id]");
        var putdata = new Array();
        if (!T.configbody.cache.ishasdomain)
            T.configbody.cache.ishasdomain = {};
        var hasdomaincache = T.configbody.cache.ishasdomain;
        var dfun = function (result_) {          
            var c_sysid = $(this).attr("data-id");
            var btn = thisform.find("button[name='domainlbbtn'][data-id='" + c_sysid + "']");
            var dellbbtn = btn.siblings("button[name='dellbbtn']");
            if (result_.result == "200") {
                btn.prop("disabled", false).removeClass("layui-btn-disabled");
                if (!dellbbtn.hasClass("layui-btn-disabled")) {
                    dellbbtn.prop("disabled", true).addClass("layui-btn-disabled");
                }
            } else {
                if (!btn.hasClass("layui-btn-disabled")) {
                    btn.prop("disabled", true).addClass("layui-btn-disabled");
                }
                dellbbtn.prop("disabled", false).removeClass("layui-btn-disabled");
            }
        }
        $.each(thisbtn, function (i, n) {
            var c_sysid = $(n).attr("data-id");
            putdata.push({
                url: T.configbody.loadurl,
                catch: true,
                type: "POST",
                data: { act: "ishasdomain", c_sysid: c_sysid },
                beforeSend: function (x) {                                          
                    if (hasdomaincache[c_sysid]) {                                    
                        dfun.call(n, hasdomaincache[c_sysid]);
                        return false;
                    } 
                },
                success: function (data) {                  
                    var jsondata = $.getjson(data);
                    if ($.isjson(jsondata)) {
                        hasdomaincache[c_sysid] = jsondata;
                        dfun.call(n, jsondata);
                    }
                }
            });
        });
        $.Action(putdata);
    },
    domainmodisub: function (jsondata) {
        var thisform = this;
        if (!(jsondata && jsondata.auditinfo)) return;
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: "domainmodisub", d_id: jsondata.auditinfo.d_id, eppidtype: jsondata.eppidtype }, formdata, datakeyval);
        T.dosubmit(putdata, function (subdata) {
            if (subdata.result == "200") {
                layer.success("修改" + jsondata.cfg.eppidtype[jsondata.eppidtype] + "已成功", function () {
                    T.configbody.isreload = true;
                    T.reloadpage.call(thisform);
                    layer.closeAll();
                });
            } else {
                layer.error(subdata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    domainmodibody: function (d_id, eppidtype) {
        var thisform = this;
        thisform.find("#domainmodibox_body").html("");
        T.tjload.call(thisform, { act: "domaininfo", tjtype: "domain", d_id: d_id, eppidtype: eppidtype }, function (html, tjdata) {
            thisform.find("#strdomain").html(tjdata.auditinfo.strdomain);
            thisform.find("#domainmodibox_body").html(html);
        });
    },
    domainmodibox: function (d_id) {
        var thisform = this;
        T.getcfg(T.needcfg(["eppidtype"]), function () {
            var html = template("domainmodibox_tmp", T.configbody);
            thisform.html(html);
            var tab = thisform.find("#domainmodibox .layui-tab-title");
            tab.find("li").off("click").on("click", function (e) {
                layer.closeAll();
                var data_tmp = $(e.target).attr("data-tmp");
                $(e.target).siblings("li").removeClass("layui-this");
                $(e.target).addClass("layui-this");
                thisform.data("reloadpage", function () { T.domainmodibody.call(thisform, d_id, data_tmp) });
                $.hasData(thisform[0]) && $.isFunction(thisform.data("reloadpage")) && thisform.data("reloadpage").call(thisform);
            });
            tab.find("li[data-tmp='dom_id']").trigger("click");
        });
    },
    tjshowbody: function (showfn) {
        var thisform = this;
        //var tjdata = $.extend(true, {}, T.configbody.tjresetData, { cfg: T.configbody.cfg }); 
        var tjdata = T.configbody.tjresetData;
        var html = template("tjbody_tmp", tjdata);
        if ($.isFunction(showfn)) {
            showfn.call(thisform, $(html), tjdata);
        }
        layform.render();
        T.bindfun_auditform.call(thisform, tjdata);
    },

    tjload: function (para, showfn) { //添加       
        var thisform = this;
        var getinfo = function () {
            var tjdata = { cfg: T.configbody.cfg };
            var showbody = function () {
                tjdata.tjtype = para && para.tjtype ? para.tjtype : "add";
                tjdata.eppidtype = (para && para.eppidtype) ? para.eppidtype : "dom_id";
                tjdata.ishasobj = T.ishasotherdomain.call(thisform);
                T.configbody.tjresetData = tjdata;
                T.tjshowbody.call(thisform, showfn);
            }
            if (para && Object.keys(para).length > 0 && /^\d+$/.test(para.c_sysid || para.d_id)) {
                var lbox = layer.loading(3);
                var putdata = { act: para && para.act ? para.act : "auditinfo" };
                $.extend(true, putdata, para);
                T.dosubmit(putdata, function (jsondata) {
                    if (jsondata.result == "200") {
                        tjdata.auditinfo = $.isArray(jsondata.data) ? jsondata.data[0] : jsondata.data;
                        showbody();
                    } else {
                        layer.error(jsondata.msg.join(";"));
                    }
                }, function () {
                    layer.close(lbox);
                });
            } else {
                tjdata.auditinfo = T.configbody.cfg.fromuser;//用户资料填充
                showbody();
                thisform.find("input[name='c_org_m'],input[name='c_ln_m'],input[name='c_fn_m'],input[name='c_adr_m']").trigger("blur");
            }
        }
        T.getcfg(T.needcfg(para && para.tjtype == "domain" ? ["regtypepair", "contacttype", "ipaddr"] : ["regtypepair", "contacttype", "ipaddr", "fromuser", "history"]), function () {
            getinfo();
        });
    },
    shengheunpass: function (jindex, auditdata) {
        var thisform = this;
        var para = auditdata.data.info[jindex];
        var html = template("shengheunpassbox_tmp", para);
        layer.open({
            type: 1,
            title: "填写拒绝原因",
            area: ['410px'],
            content: html,
            btn: ['确定拒绝', '取消'],
            success: function (layero, indexs) {
                layform.render(); layer.render_();
                var shform = layero.find("form");
                T.bindfun_auditform.call(shform, para);
            },
            yes: function (indexs, layero) {
                var shform = layero.find("form");
                if (shform.find("textarea[name='jjyy']").val() == "") {
                    layer.msg("请正确输入拒绝原因", { time: 1000 });
                    return false;
                }
                layer.close(indexs);
                var lbox = layer.loading();

                var formdata = $.ConvertArray(shform.serializeArray());
                var putdata = $.extend(true, {}, { act: "shengheunpass", c_sysid: para.c_sysid }, formdata);
                T.dosubmit(putdata, function (jsondata) {
                    if (jsondata.result == "200") {
                        auditdata.data.info.splice(jindex, 1);
                        layer.closeAll();
                        layer.open({
                            type: 0, title: "拒绝成功", icon: 1, content: "审核操作成功，是否继续审下一条?", btn: ['继续', '取消'],
                            yes: function (indexs, layero) {
                                if (auditdata.data.info.length < 1) {
                                    layer.msg("没有了");
                                } else {
                                    layer.close(indexs);
                                    jindex++;
                                    T.showshenghebox.call(thisform, jindex, auditdata);
                                }
                            },
                            end: function () {
                                T.configbody.isreload = true;
                                var pageform = $("form[name='ad_audit_form']");
                                T.reloadpage.call(pageform);
                            }
                        });
                    } else {
                        layer.error(jsondata.msg.join(";"));
                    }
                }, function () {
                    layer.close(lbox);
                });
                return false;
            }
        });
    },
    shenghepass: function (jindex, auditdata) {
        var thisform = this;
        var para = auditdata.data.info[jindex];
        var lbox = layer.loading(3);
        var putdata = { act: "shenghepass", c_sysid: para.c_sysid };
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                auditdata.data.info.splice(jindex, 1);
                layer.open({
                    type: 0, title: "通过成功", icon: 1, content: "审核操作成功，是否继续审下一条?", btn: ['继续', '取消'],
                    yes: function (indexs, layero) {
                        if (auditdata.data.info.length < 1) {
                            layer.msg("没有了");
                        } else {
                            layer.close(indexs);
                            jindex++;
                            T.showshenghebox.call(thisform, jindex, auditdata);
                        }
                    },
                    end: function () {
                        T.configbody.isreload = true;
                        var pageform = $("form[name='ad_audit_form']");
                        T.reloadpage.call(pageform);
                    }
                });
            } else {
                layer.error(jsondata.msg.join(";"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    showshenghebox: function (jindex, auditdata) {
        var thisform = this;
        if (jindex > auditdata.data.info.length - 1) {
            T.configbody.isreload = true;
            T.reloadpage.call(thisform);
            jindex = 0;
        }
        var para = auditdata.data.info[jindex];
        T.getcfg(T.needcfg(["zjlxpair"]), function () {
            if (para && para.c_sysid && /^\d+$/.test(para.c_sysid)) {
                var lbox = layer.loading(3);
                var putdata = { act: "auditfileadmin", showfile: "1", c_sysid: para.c_sysid };
                T.dosubmit(putdata, function (jsondata) {
                    if (jsondata.result == "200") {
                        //T.configbody.fileresetData = { auditinfo: jsondata.data };
                        layer.open({
                            type: 1,
                            title: false,//"<i class=\"layui-icon layui-icon-auz\" style=\"font-size: 14px;\"></i>  实名认证审核",
                            content: "<form name=\"auditshenghe_form\"  class=\"layui-form\"></form>",
                            area: [true ? '1170px' : '680px'],
                            btn: false,
                            resize: false,
                            success: function (layero, indexs) {
                                var shform = layero.find("form");
                                shform.data("renderbox", function () {
                                    layer.render_(layero, indexs);
                                });
                                T.shengheshowbody.call(shform, jsondata, auditdata, jindex);
                            },
                            end: function () {
                                $(document).off('keyup');
                            }
                        });
                    } else {
                        layer.error(jsondata.msg.join(";"));
                    }
                }, function () {
                    layer.close(lbox);
                });
            }
        });
    },
    findzjlx: function (f_type, zjlxpair) {
        var t_name;
        $.each(zjlxpair, function (i, n) {
            if (n.t_sysid == f_type) {
                t_name = n.t_name;
                return false;
            }
        })
        return t_name;
    },
    shenghebefore: function (info) {
        var thisform = this;
        if (info.auditinfo && info.auditinfo.orgfile) {
            var filedata = info.auditinfo.orgfile;
            var file = filedata.f_path;
            if ($.isbase64(file)) file = "data:image/jpeg;base64," + file;
            var file_s = filedata.f_path_s;
            if ($.isbase64(file_s)) file_s = "data:image/jpeg;base64," + file_s;
            var filesysid = filedata.f_sysid;
            var alt = T.findzjlx(filedata.f_type, info.cfg.zjlxpair) + ":" + filedata.f_code;
            thisform.find("#upbtn_org,#seebtn_org").html("<img style=\"width: 100px; height:100px\" layer-pid=\"" + filesysid + "\" layer-src=\"" + file + "\" src=\"" + file_s + "\" alt=\"" + alt + "\">");
            if ($("#seephoto")[0]) {
                $("#seephoto").html("<img style=\"max-width: 585px; max-height:650px\" src=\"" + file + "\" >");
                $('#seephoto img').on('load', function () {
                    thisform.data("renderbox").call(thisform);
                    $('#seephoto img').unbind().lightzoom();

                });

            }
        }
        if (info.auditinfo && info.auditinfo.lxrfile) {
            var filedata = info.auditinfo.lxrfile;
            var file = filedata.f_path;
            if ($.isbase64(file)) file = "data:image/jpeg;base64," + file;
            var file_s = filedata.f_path_s;
            if ($.isbase64(file_s)) file_s = "data:image/jpeg;base64," + file_s;
            var filesysid = filedata.f_sysid;
            var alt = T.findzjlx(filedata.f_type, info.cfg.zjlxpair) + ":" + filedata.f_code;
            thisform.find("#upbtn_lxr,#seebtn_lxr").html("<img style=\"width: 100px; height:100px\" layer-pid=\"" + filesysid + "\" layer-src=\"" + file + "\" src=\"" + file_s + "\" alt=\"" + alt + "\">");
        }
    },
    rotatefile: function (para, filedata) {
        var thisform = this;
        var lbox = layer.loading();
        var putdata = { act: "rotatefile", f_sysid: para.f_sysid };
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                if (para.type == "org") {
                    filedata.auditinfo.orgfile.f_path = jsondata.data.f_path;
                    filedata.auditinfo.orgfile.f_path_s = jsondata.data.f_path_s;
                } else if (para.type == "lxr") {
                    filedata.auditinfo.lxrfile.f_path = jsondata.data.f_path;
                    filedata.auditinfo.lxrfile.f_path_s = jsondata.data.f_path_s;
                }
                T.shenghebefore.call(thisform, filedata);
            } else {
                layer.error(jsondata.msg.join(";"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    shengheshowbody: function (jsondata, listdata, jindex) {
        var thisform = this;
        var filedata = { auditinfo: jsondata.data, cfg: T.configbody.cfg, jindex: jindex, listdata: listdata };
        var html = template("shengheboxcontainer_tmp", filedata);
        thisform.html(html);
        T.shenghebefore.call(thisform, filedata);
        layform.render();
        thisform.data("renderbox").call(thisform);
        T.bindfun_auditfileform.call(thisform, filedata);
    },
    fileshowbefore: function () {
        var thisform = this;
        var fileresetData = $.hasData(thisform[0]) && thisform.data("fileresetData") || null;
        var filedata = $.extend(true, {}, fileresetData, { cfg: T.configbody.cfg });
        if (filedata.auditinfo && filedata.auditinfo.orgfile && filedata.auditinfo.orgfile.f_path_s) {
            var file_s = filedata.auditinfo.orgfile.f_path_s;
            var filesysid = filedata.auditinfo.orgfile.f_sysid;
            T.insertimg(thisform.find("#upbtn_org,#seebtn_org,#nobtn_org"), 0, "data:image/jpeg;base64," + file_s, "", function () {
                T.postkeyval(thisform.find("#upbtn_org,#seebtn_org")[0], { file_orgid: filesysid });
            });
        }
        if (filedata.auditinfo && filedata.auditinfo.lxrfile && filedata.auditinfo.lxrfile.f_path_s) {
            var file_s = filedata.auditinfo.lxrfile.f_path_s;
            var filesysid = filedata.auditinfo.lxrfile.f_sysid;
            T.insertimg(thisform.find("#upbtn_lxr,#seebtn_lxr,#nobtn_lxr"), 0, "data:image/jpeg;base64," + file_s, "", function () {
                T.postkeyval(thisform.find("#upbtn_lxr,#seebtn_lxr")[0], { file_lxrid: filesysid });
            });
        }
        if (filedata.auditinfo && filedata.auditinfo.domaininfo && filedata.auditinfo.domaininfo.ymsqb_path_s) {
            var file_s = filedata.auditinfo.domaininfo.ymsqb_path_s;
            var file = filedata.auditinfo.domaininfo.ymsqb_path;
            if ($.isbase64(file)) file = "data:image/jpeg;base64," + file;
            if ($.isbase64(file_s)) file_s = "data:image/jpeg;base64," + file_s;
            //T.insertimg(thisform.find("#upbtn_ymsqb,#seebtn_ymsqb"), 0, "data:image/jpeg;base64," + file_s, "");
            thisform.find("#upbtn_ymsqb,#seebtn_ymsqb").html("<img style=\"width: 100px; height:100px\" layer-pid=\"0\" layer-src=\"" + file + "\" src=\"" + file_s + "\" alt=\"域名申请表\">");
        }

    },
    auditbox: function (para) {
        var thisform = this;
        var boxhtml = template("auditbox_tmp", T.configbody);
        //   var auditform = $(boxhtml).find("form");
        var showbox = function (fun) {
            layer.open({
                type: 1,
                title: false,
                content: boxhtml,
                area: [$(window).width()<=650?'390px':'650px'],
                fixed: false,
                resize: false,
                success: function (layero, indexs) {
                    var auditform = layero.find("form");
                    auditform.data("renderbox", function () {
                        layer.render_(layero, indexs);
                    });
                    layero.find("#auditboxtab li").off("click").on("click", function () {
                        var data_tmp = $(this).attr("data-tmp");
                        $(this).siblings("li").removeClass("layui-this");
                        $(this).addClass("layui-this");
                        if (data_tmp == "file") {
                            auditform.data("reloadpage", function () {
                                T.auditfile.call(auditform, para, function (jsondata) {
                                    auditform.data("fileresetData", { auditinfo: jsondata.data });
                                    T.fileshowbody.call(auditform);
                                });
                            });
                        } else if (data_tmp == "status") {
                            var statusboxhtml = template("auditstatusbox_tmp", T.configbody);
                            T.getcfg(T.needcfg(["statusinfo"]), function () {
                                auditform.html(statusboxhtml, T.configbody);
                            });
                            var searchHtml = template("auditstatussearch_tmp", T.configbody);
                            auditform.find("#auditstatussearchbox").html(searchHtml);
                            auditform.data("reloadpage", function () {
                                T.auditstatusinfo.call(auditform, para);
                            });
                        } else if (data_tmp == "ymsqb") {
                            auditform.data("reloadpage", function () {
                                T.auditymsqb.call(auditform);
                            });
                        }
                        $.hasData(auditform[0]) && $.isFunction(auditform.data("reloadpage")) && auditform.data("reloadpage").call(auditform);
                    });
                    if ($.isFunction(fun)) {
                        fun.call(auditform);
                    }
                },
                end: function () {
                    T.reloadpage.call(thisform);
                }
            });
        }
        if (para.tab == "auditfile") {
            showbox(function () {
                $("#auditboxtab li[data-tmp='file']").trigger("click");
            });
        } else {
            showbox(function () {
                $("#auditboxtab li[data-tmp='status']").trigger("click");
            });
        }
    },
    auditstatusinfo: function (para) {
        var thisform = this;
        T.getcfg(T.needcfg(["statusinfo"]), function () {
            if (para && para.c_sysid && /^\d+$/.test(para.c_sysid)) {
                T.getcfg(T.needcfg(["zjlxpair"]), function () {
                    var lbox = layer.loading(3);
                    var formdata = $.ConvertArray(thisform.serializeArray());
                    var pagedata = thisform.data("pagedata");
                    var putdata = $.extend(true, { act: T.configbody.isadmin ? "auditstatusadmin" : "auditstatus", c_sysid: para.c_sysid, dotype: para.dotype }, formdata, pagedata);
                    T.dosubmit(putdata, function (jsondata) {
                        if (jsondata.result == "200") {
                            jsondata.cfg = T.configbody.cfg;
                            var html = template("auditstatusinfo_tmp", $.extend(true, {}, jsondata));
                            thisform.find("#auditstatusinfobox").html(html);
                            var tb = { skin: 'line', limit: jsondata.data.pagelist.pagesizes };
                            if (jsondata.data.info.length >= 8) tb.height = 300;
                            laytable.init("auditstatustable", tb);
                            layform.render();
                            thisform.data("renderbox").call(thisform);
                            T.bindfun_auditfileform.call(thisform, jsondata);
                        } else {
                            layer.closeAll();
                            layer.error(jsondata.msg.join(";"));
                        }
                    }, function () {
                        layer.close(lbox);
                    });
                });
            }
        });
    },
    auditymsqb: function () {
        var thisform = this;
        var fileresetData = $.hasData(thisform[0]) && thisform.data("fileresetData") || null;
        if (fileresetData == null) {
            layer.error("出现错误fileresetData");
            return;
        };
        var filedata = $.extend(true, {}, fileresetData, { cfg: T.configbody.cfg });
        var html = template("ymsqbbox_tmp", filedata);
        thisform.html(html);
        T.fileshowbefore.call(thisform);
        layform.render();
        thisform.data("renderbox").call(thisform);
        T.bindfun_auditfileform.call(thisform, filedata);
    },
    auditfile: function (para, showfun) {
        var thisform = this;
        if (para && para.c_sysid && /^\d+$/.test(para.c_sysid)) {
            T.getcfg(T.needcfg(["zjlxpair", "statusinfo"]), function () {
                var lbox = layer.loading(3);
                var putdata = { act: T.configbody.isadmin ? "auditfileadmin" : "auditfile", c_sysid: para.c_sysid, dotype: para.dotype };
                T.dosubmit(putdata, function (jsondata) {
                    if (jsondata.result == "200") {
                        if (jsondata.data.domaininfo && jsondata.data.domaininfo.proid == "domgovcn") {
                            $("#auditboxtab li[data-tmp='ymsqb']").show();
                        }
                        if ($.isFunction(showfun)) {
                            showfun.call(thisform, jsondata);
                        }
                    } else {
                        layer.closeAll();
                        layer.error(jsondata.msg.join(";"));
                    }
                }, function () {
                    layer.close(lbox);
                });
            });
        }
    },
    fileshowbody: function () {
        var thisform = this;
        var fileresetData = $.hasData(thisform[0]) && thisform.data("fileresetData") || null;
        if (fileresetData == null) {
            layer.error("出现错误fileresetData");
            return;
        };
        var filedata = $.extend(true, {}, fileresetData, { cfg: T.configbody.cfg });
        var html = template("auditfilebox_tmp", filedata);
        thisform.html(html);
        T.fileshowbefore.call(thisform);
        layform.render();
        $.hasData(thisform[0]) && thisform.data("renderbox") && thisform.data("renderbox").call(thisform);
        T.bindfun_auditfileform.call(thisform, filedata);
    },
    getdivparents: function (div) {
        var ret = {};
        $.each(div.find("input[name],select[name],textarea[name]:visible"), function (i, n) {
            var name = $(n).attr("name");
            var value = $(n).val();
            ret[name] = value;
        });
        return ret;
    },
    islbbody: function (fun, fun1) {
        var thisform = this;
        T.dosubmit({ act: "islbbody" }, function (jsondata) {
            if (jsondata.result == "200") {
                fun.call(thisform);
            } else {
                fun1.call(thisform);
            }
        });
    },
    showlbmininfo: function (lbminbox, showfn) {
        var thisform = this;
        var lbox = layer.loading(3);
        var boxdata = T.getdivparents(lbminbox);
        var pagedata = lbminbox.data("pagedata");
        var putdata = $.extend(true, { act: "lbload" }, boxdata, pagedata);
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                jsondata.cfg = T.configbody.cfg;

                var html = template("lbminbody_tmp", $.extend(true, {}, jsondata));
                lbminbox.find("#lbmininfo").html(html);

                if ($.isFunction(showfn)) {
                    showfn.call(lbminbox);
                }
                T.getdomaintype.call(thisform);
                //  var tb = { skin: 'line' };
                var tb = { skin: 'line', size: 'lg', limit: jsondata.data.pagelist.pagesizes };
                if (jsondata.data.info.length > 10) tb.height = 560;
                laytable.init("lbmintable", tb);
                layform.render();
                T.bindfun_auditform.call(thisform, jsondata);
            } else {
                layer.error(jsondata.msg.join(";"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    ishasotherdomain: function () {
        var thisform = this;
        var ghdomainObj = $("textarea[name='ghdomain']");
        var ghdomain = thisform.data("domainlist") || ghdomainObj[0] && ghdomainObj.val() || null;

        var ishashk = false, ishasgswl = false, isgovcn = false
        if (/[\w\u4e00-\u9fa5\-]+\.hk[\r\n\|]*/ig.test(ghdomain) && !/[\w\u4e00-\u9fa5\-]+\.hk\.cn[\r\n\|]*/ig.test(ghdomain)) {
            ishashk = true;
        }
        if (/[\w\u4e00-\u9fa5\-]+(\.公司)|(\.xn\-\-55qx5d)|(\.网络)|(\.xn\-\-io0a7i)|(\.佛山)|(\.xn\-\-1qqw23a)|(\.广东)|(\.xn\-\-xhq521b)[\r\n\|]*/ig.test(ghdomain)) {
            ishasgswl = true;
        }
        if (/[\w\u4e00-\u9fa5\-]+\.gov\.cn[\r\n\|]*/ig.test(ghdomain)) {
            isgovcn = true;
        }

        if (ghdomainObj[0]) {
            var alertmsg = "";
            if (isgovcn) alertmsg += "<i class=\"layui-icon layui-icon-tips\" style=\"font-size:12px\"></i>&nbsp;含有gov.cn域名,该域名不允许变更所有者<br>";
            if (ishashk) alertmsg += "<i class=\"layui-icon layui-icon-tips\" style=\"font-size:12px\"></i>&nbsp;含有hk域名,需选择适用的资料且注意域名类型（企业、个人）与所选资料类型对应<br>";
            if (ishasgswl) alertmsg += "<i class=\"layui-icon layui-icon-tips\" style=\"font-size:12px\"></i>&nbsp;含有公司、网络、佛山、广东域名,需选择适用的资料";
            if (alertmsg != "") {
                layer.tips(alertmsg, ghdomainObj[0], { tips: [4, "#1E9FFF"], time: 5000 });
            }

        }


        return { ishashk: ishashk, ishasgswl: ishasgswl, isgovcn: isgovcn };
    },
    getdomaintype: function () {
        var thisform = this;
        //var ghdomainObj=thisform.find("textarea[name='ghdomain']");
        var lbmintableObj = thisform.find("#lbmininfo input[name='c_sysid']:radio");
        var ishasObj = T.ishasotherdomain.call(thisform);
        $.each(lbmintableObj, function (i, n) {
            var reg_contact_type = $(n).attr("data-type");
            var r_status = $(n).attr("data-rstatus");
            var regtype = $(n).attr("data-regtype");
            ishasObj.ishashk && reg_contact_type.indexOf("hk") < 0 && $(n).prop("checked", false).prop("disabled", true) ||
                ishasObj.ishasgswl && reg_contact_type.indexOf("gswl") < 0 && $(n).prop("checked", false).prop("disabled", true) ||
                ishasObj.isgovcn && reg_contact_type.indexOf("govcn") < 0 && r_status == 1 && $(n).prop("checked", false).prop("disabled", true) ||
                $(n).prop("disabled", false);
        });
        layform.render();
    },
    lbminbody_lb: function (lbminbox, showfn) {//showfn:用于显示操作
        var thisform = this;
        var lbminbox_lb = $(template("lbminbox_lb_tmp", T.configbody));
        lbminbox.find("#lbminbox_content").html(lbminbox_lb);
        lbminbox.data("reloadpage", function (showfn) {
            T.showlbmininfo.call(thisform, lbminbox, showfn);
        });
        T.getcfg(T.needcfg(["regtypepair", "eppidtype", "contacttype", "statusinfo"]), function () {
            var schhtml = template("lbminsearch_tmp", T.configbody);
            lbminbox.find("#lbminsearch").html(schhtml);
            lbminbox.data("reloadpage").call(thisform, showfn);
        });
    },
    lbminbody_tj: function (lbminbox, showfn) {
        var thisform = this;
        T.tjload.call(thisform, { tjtype: "gh" }, function (html) {
            lbminbox.find("#lbminbox_content").html(html);
            if ($.isFunction(showfn)) {
                showfn.call(lbminbox);
            }
        });

    },
    lbminbodymod_tj: function (para) {
        var boxform = $("<form name=\"minbodytj_form\"  class=\"layui-form\"></form>");
        T.tjload.call(boxform, para, function (html, jsondata) {
            var thisform = this;
            layer.open({
                type: 1,
                title: "编辑模板",
                offset: '5px',
                area: [$(window).width()<=700?'390px':'900px'],
                resize: false,
                maxmin: false,
                move: false,
                fixed: false,
                success: function (layero, indexs) {
                    thisform.html(html);
                    layero.find(".layui-layer-content").html(thisform);
                    $("form[name='minbodytj_form']").data("renderbox", function () {
                        layer.render_(layero, indexs);
                    });
                    $("form[name='minbodytj_form']").data("renderbox").call();
                }
            });
        });
    },
    lbminbody: function (showfn) {
        var thisform = this;
        var lbminbox = $(template("lbminbox_tmp", T.configbody));
        T.islbbody(function () {
            T.lbminbody_lb.call(thisform, lbminbox, showfn);
        }, function () {
            lbminbox.find(".layui-tab-title li").removeClass("layui-this");
            lbminbox.find(".layui-tab-title li[data-tmp='tj']").addClass("layui-this");
            T.lbminbody_tj.call(thisform, lbminbox, showfn);
        });

    },
    ghload: function () { //过户
        var thisform = this;
        T.getcfg(T.needcfg(["regtypepair", "eppidtype", "statusinfo"]), function () {
            var html = template("ghbody_tmp", T.configbody);
            thisform.html(html);
            T.lbminbody.call(thisform, function () {
                thisform.find("#ghlbminbox").html(this);
            });
        });
    },
    ztload: function () { //过户状态
        var thisform = this;
        var getinfo = function () {
            var lbox = layer.loading(3);
            var formdata = $.ConvertArray(thisform.serializeArray());
            var pagedata = thisform.data("pagedata");
            var putdata = $.extend(true, { act: "ztload" }, formdata, pagedata);
            var a = function () {
                if (!thisform.find("#ghztinfo")[0]) {
                    //clearTimeout(T.configbody.timer9);
                    return;
                }
                T.dosubmit(putdata, function (jsondata) {
                    if (jsondata.result == "200") {
                        jsondata.cfg = T.configbody.cfg;
                        var html = template("ghztbody_tmp", jsondata);
                        thisform.find("#ghztinfo").html(html);
                        var tb = { skin: 'line', limit: jsondata.data.pagelist.pagesizes, size: 'lg' };
                        laytable.init("ghzttable", tb);
                        T.bindfun_auditform.call(thisform, jsondata);
                        // clearTimeout(T.configbody.timer9);
                        //T.configbody.timer9 = window.setTimeout(a, 5000);
                    } else {
                        layer.error(jsondata.msg.join(";"));
                    }
                }, function () {
                    layer.close(lbox);
                });
            }
            a();

        }
        var getsearch = function () {
            var schhtml = template("ghztsearch_tmp", T.configbody);
            thisform.find("#ghztsearch").html(schhtml);
            layform.render();
        }
        if (thisform.find("#ghztsearch")[0]) {
            getinfo();
        } else {
            thisform.html(template("ghztbox_lb_tmp", T.configbody));
            T.getcfg(T.needcfg(["eppidtype", "statusinfo"]), function () {
                getsearch();
                getinfo();
            });
        }
    },
    getcfg: function (lb, fun) {
        if (lb.length > 0) {
            var loadindex = layer.loading(3);
            T.dosubmit({ act: "getcfg", tab: lb.join(",") }, function (jsondata) {
                if (jsondata.result == "200") {
                    $.extend(true, T.configbody.cfg, jsondata.data);

                    if ($.isFunction(fun)) {
                        fun.call(this);
                    }
                } else {
                    layer.error(jsondata.msg.join(";"));
                }
            }, function () {
                layer.close(loadindex);
            });
        } else if ($.isFunction(fun)) {
            fun.call(this);
        }
    },
    bindfun_auditdomainform: function (jsondata) {
        var thisform = this;
        T.pageload(thisform.find("#domainpagebox_mg")[0], jsondata && jsondata.data && jsondata.data.pagelist ? jsondata.data.pagelist : null, $(window).width()<=700?['prev', 'next', 'limit', 'count']:['prev', 'page', 'next', 'limit', 'count'], function (pageobj) {
            thisform.removeData("pagedata").data("pagedata", { pageno: pageobj.curr, pagesize: pageobj.limit });
            T.showdomanlistinfo.call(thisform, function (jsondata) {
                thisform.data("overfun").call(this, jsondata);
            });
        });
        thisform.find("button[name='domainsearchbtn']").off("click").on("click", function () {
            thisform.removeData("pagedata");//搜索后回到第一页
            T.showdomanlistinfo.call(thisform, function (jsondata) {
                thisform.data("overfun").call(this, jsondata);
            });
        });
        thisform.find("button[name='exportdomain']").off("click").on("click", function () {
            var exportdata = jsondata.data.info.map(function (item) {
                return [item.strdomain.indexOf("xn--") >= 0 ? item.s_memo : item.strdomain, item.regdate];
            })
            laytable.exportFile(['域名', '注册时间'], exportdata, 'csv'); //默认导出 csv，也可以为：xls
        });
        layform.on('submit(domainguohubtn)', function (obj) {
            return false;
        });
        thisform.find("button[name='domainclsbtn']").off("click").on("click", function () {
            layer.closeAll();
        });
        thisform.find("*[data-tips]").off("click").on("click", function () {
            var tips = $(this).attr("data-tips");
            if (tips != "") {
                layer.tips(tips, this, { tips: [2, "#FF5722"] });
            }
        })
    },
    bindfun_auditfileform: function (jsondata) {
        var thisform = this;
        if (T.configbody.isadmin && thisform.find('button[name="shpassbtn"]')[0]) {
            $(document).off('keyup').on('keyup', function (event) {
                var keyCode = event.keyCode;
                // q 拒绝
                if (keyCode == "81") {
                    thisform.find('button[name="shdenybtn"]').trigger('click');
                } else if (keyCode == "69") {// E 通过
                    thisform.find('button[name="shpassbtn"]').trigger('click');
                }
            });
        }
        thisform.find("button[name='shpassbtn']").off("click").on("click", function () {
            var passfun = function () {
                layer.closeAll();
                T.shenghepass.call(thisform, jsondata.jindex, jsondata.listdata);
            }
            var f_type_org = thisform.find("select[name='f_type_org']").val();
            var f_code_org = thisform.find("input[name='f_code_org']").val();
            if (f_type_org != jsondata.auditinfo.orgfile.f_type || f_code_org != jsondata.auditinfo.orgfile.f_code) {
                layer.sure("信息发生变化，确定审核通过修改后的信息？", function (index__) {
                    T.auditfilesub_.call(thisform, { auditinfo: jsondata.auditinfo }, function () {
                        layer.close(index__);
                        passfun();
                    });
                });
            } else {
                layer.sure("确定审核通过?", function (indexs_) {
                    layer.close(indexs_);
                    passfun();
                });
            }
        });
        thisform.find("button[name='shdenybtn']").off("click").on("click", function () {
            T.shengheunpass.call(thisform, jsondata.jindex, jsondata.listdata);
        });
        thisform.find("button[name='shnextbtn']").off("click").on("click", function () {
            if (jsondata.listdata.data.info.length == 1) {
                layer.msg("没有了");
            } else {
                layer.closeAll();
                jsondata.jindex++;
                T.showshenghebox.call(thisform, jsondata.jindex, jsondata.listdata);
            }
        });
        thisform.find("button[name='shclosebtn']").off("click").on("click", function () {
            layer.closeAll();
        });
        thisform.find("button[name='shmodbtn']").off("click").on("click", function () {
            layer.sure("确定修改该信息？", function () {
                T.auditfilesub_.call(thisform, { auditinfo: jsondata.auditinfo });
                return false;
            });
        });
        layform.on('submit(auditfilesubbtn)', function (obj) {
            T.auditfilesub.call(thisform, jsondata);
            return false;
        });
        layform.on('submit(auditymsqbsubbtn)', function (obj) {
            T.auditymsqbsub.call(thisform, jsondata);
            return false;
        });
        thisform.find("button[name='auditfileresetbtn']").off("click").on("click", function () {
            T.fileshowbody.call(thisform);
        });
        thisform.find("button[name='searchbtn']").off("click").on("click", function () {

            T.configbody.isreload = true;
            T.reloadpage.call(thisform);
        });
        T.pageload(thisform.find("#pagebox_mg")[0], jsondata && jsondata.data && jsondata.data.pagelist ? jsondata.data.pagelist : null, ['count', 'prev', 'page', 'next'], function (pageobj) {
            thisform.removeData("pagedata").data("pagedata", { pageno: pageobj.curr, pagesize: pageobj.limit });
            T.configbody.isreload = true;
            T.reloadpage.call(thisform);
        });
        thisform.find("#seebtn_org,#seebtn_lxr,#seebtn_ymsqb").off("click").on("click", function () {
            if ($("#seephoto")[0]) {
                var file = $(this).find("img").attr("layer-src");
                if ($.isbase64(file)) file = "data:image/jpeg;base64," + file;
                $("#seephoto").html("<img style=\"max-width: 585px;max-height:650px\" src=\"" + file + "\" >");
                $('#seephoto img').on('load', function () {
                    thisform.data("renderbox").call(thisform);
                    $('#seephoto img').unbind().lightzoom();
                });

            } else {
                layer.photos({
                    photos: thisform,
                    closeBtn: 2,
                    shadeClose: false,
                    shade: 0.5,
                    anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
                });
            }
        });
        thisform.find("button[name='xuanzhuan']").off("click").on("click", function () {
            var type = $(this).attr("data-type");
            var f_sysid = $(this).attr("data-fsysid");
            T.rotatefile.call(thisform, { type: type, f_sysid: f_sysid }, jsondata);
        });
        T.uploadbind.call(thisform);
        T.showzjxx_file.call(thisform, jsondata);
    },
    findjson: function (c_sysid, jsondata) {
        return jsondata.filter(function (item) {
            if (item.c_sysid == c_sysid) {
                return item;
            }
        });
    },
    bindfun_auditform: function (jsondata) {
        var thisform = this, lbminbox = thisform.find("#lbminbox");
        $("body").undelegate("*[data-hovermsg]", "mouseenter mouseleave").delegate("*[data-hovermsg]", "mouseenter", function (event) {
            var datamsg = $(this).attr("data-hovermsg");
            //layer.tips(datamsg, this, { tips: [1, "#FFB800"]});
            layer.open({
                title: false, type: 4, closeBtn: 0, time: 10000, fixed: false, shade: 0, anim: 0, tipsMore: false, tips: [1, "#e2eaff"],
                content: ["<li class=\"layui-icon layui-icon-about\" style=\"color:#6f78b8\">&nbsp;<span style=\"font-size:12px\">" + datamsg + "</span></li>", this]//数组第二项即吸附元素选择器或者DOM
            });
        }).delegate("*[data-hovermsg]", "mouseleave", function (event) {
            layer.closeAll("tips");
        });
        T.pageload(thisform.find("#pagebox_mg")[0], jsondata && jsondata.data && jsondata.data.pagelist ? jsondata.data.pagelist : null, $(window).width()<=700?['count', 'prev', 'next', 'limit']:['refresh', 'count', 'prev', 'page', 'next', 'limit', 'skip'], function (pageobj) {
            thisform.removeData("pagedata").data("pagedata", { pageno: pageobj.curr, pagesize: pageobj.limit });
            T.configbody.isreload = true;
            T.reloadpage.call(thisform);
        });
        thisform.find("button[name='searchbtn']").off("click").on("click", function () {
            thisform.removeData("pagedata");//搜索
            T.configbody.isreload = true;
            T.reloadpage.call(thisform);
        });
        thisform.find("button[name='modlbbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-id");
            $("#audittab li[data-tmp='tj']").trigger("click", { c_sysid: c_sysid, tjtype: "mod" });
        });
        thisform.find("button[name='modlbminbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-id");
            T.lbminbodymod_tj.call(thisform, { c_sysid: c_sysid, tjtype: "mod" });
        });
        thisform.find("button[name='dellbbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-id");
            layer.sure("确定删除这个资料模板?", function (index) {
                layer.close(index);
                T.auditdel(c_sysid);
            });
        });
        thisform.find("input[name='c_adr_m']:text").off("blur").on("blur", function (e) {
            var c_adrObj = thisform.find("input[name='c_adr']:text");
            if (thisform.find("select[name='c_co']").val() == "CN") {
                c_adrObj.val($(e.target).toPinyin());
            } else if (c_adrObj.val() == "") {
                c_adrObj.val($(e.target).toPinyin());
            }
        });
        thisform.find("input[name='c_org_m']:text").off("blur").on("blur", function (e) {
            var c_orgObj = thisform.find("input[name='c_org']:text");
            c_orgObj.val($(e.target).toPinyin());
        });
        thisform.find("input[name='c_ln_m']:text").off("blur").on("blur", function (e) {
            var c_lnObj = thisform.find("input[name='c_ln']:text");
            c_lnObj.val($(e.target).toPinyin());
        });
        thisform.find("input[name='c_fn_m']:text").off("blur").on("blur", function (e) {
            var c_fnObj = thisform.find("input[name='c_fn']:text");
            c_fnObj.val($(e.target).toPinyin());
        });
        layform.on("radio(c_regtype)", function (obj) {
            obj.value == "E" && thisform.find("#orgxmxx,#orgxmxxen").html("联系人姓名") && thisform.find("div.orgname").slideDown() || thisform.find("#orgxmxx,#orgxmxxen").html("所有者姓名") && thisform.find("div.orgname").slideUp(); T.zjxxshow.call(thisform, jsondata);
            if ($.hasData(thisform) && thisform.data("renderbox")) {
                thisform.data("renderbox").call(thisform);
            }
            T.checkinput.call(thisform.find("div.orgname"));
        });
        layform.on("select(searchkey)", function (obj) {

            var text = $(obj.elem).find("option:selected").text();
            var searchval = $("input[name='searchval']:text");
            if (searchval[0]) {
                searchval.attr("placeholder", "搜索" + text);
            }
        });
        layform.on("select(history)", function (obj) {
            layer.closeAll("tips");
            var c_sysid = obj.value;
            var para = { tjtype: jsondata.tjtype };
            if (/^\d+$/.test(c_sysid)) para.c_sysid = c_sysid;
            if (lbminbox[0]) {
                T.tjload.call(thisform, para, function (html) {
                    thisform.find("#lbminbox_content").html(html);
                });
            } else {
                T.tjload.call(thisform, para, function (html) { thisform.html(html); });
            }
        });
        thisform.find("button[name='statusbtn']").off("click").on("click", function () {
            var datamsg = $(this).attr("data-msg");
            layer.tips(datamsg, this, { tips: [1, "#1E9FFF"] });
        });
        thisform.find("button[name='resetbtn']").off("click").on("click", function () {
            T.tjshowbody.call(thisform);
        });
        layform.on('submit(auditsubbtn)', function (obj) {
            T.auditsub.call(thisform, jsondata);
            return false;
        });
        layform.on('submit(domainmodisubbtn)', function (obj) {
            T.domainmodisub.call(thisform, jsondata);
            return false;
        });
        thisform.find("button[name='auditfilebtn'],button[name='auditstatusbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-sysid");
            T.auditbox.call(lbminbox[0] && lbminbox || thisform, { c_sysid: c_sysid, tab: "auditfile" });
        });
        thisform.find("button[name='auditdoaminbtn']").off("click").on("click", function (e) {
            var d_id = $(e.target).attr("data-sysid");
            T.auditbox.call(lbminbox[0] && lbminbox || thisform, { c_sysid: d_id, tab: "auditfile", dotype: "domain" });
        });
        thisform.find("button[name='auditfileadminbtn'],button[name='auditstatusadminbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-sysid");
            T.auditbox.call(lbminbox[0] && lbminbox || thisform, { c_sysid: c_sysid, tab: "auditfile" });
        });
        thisform.find("button[name='domainlbbtn']").off("click").on("click", function (e) {
            var c_sysid = $(e.target).attr("data-id");
            var org = $(e.target).attr("data-org");
            T.showdomainlbbox.call(thisform, { c_sysid: c_sysid, org: org });
        });
        thisform.find("button[name='shenghebtn']").off("click").on("click", function () {
            var jindex = $(this).attr("data-index");
            T.showshenghebox.call(thisform, Number(jindex), jsondata);
        });
        layform.on('submit(ghsubbtn)', function (obj) {
            T.getdomaintype.call(thisform);
            T.chkghsub.call(thisform) && T.auditghsub.call(thisform, jsondata);
            return false;
        });
        layform.on('submit(regdomainbtn)', function (obj) {
            T.getdomaintype.call(thisform);
            T.chkregsub.call(thisform) && T.auditregsub.call(thisform, jsondata);
            return false;
        });
        thisform.find(".dropdate").each(function (i, n) {
            laydate.render({
                elem: n
                , trigger: "click"
                , type: "datetime"
                , theme: "#2086ee"
                , calendar: true
            });
        });
        thisform.find("textarea[name='ghdomain']").off("blur").on("blur", function () {
            thisform.data("domainlist", $(this).val());
            T.getdomaintype.call(thisform);
        });
        //----------过户

        if (lbminbox[0]) {
            T.pageload(lbminbox.find("#lbminpagebox_mg")[0], jsondata && jsondata.data && jsondata.data.pagelist ? jsondata.data.pagelist : null, $(window).width()<=700?[ 'count', 'prev','next', 'limit']:['refresh', 'count', 'prev', 'page', 'next', 'limit', 'skip'], function (pageobj) {
                lbminbox.removeData("pagedata").data("pagedata", { pageno: pageobj.curr, pagesize: pageobj.limit });
                T.configbody.isreload = true;
                T.reloadpage.call(lbminbox);
                //T.showlbmininfo.call(thisform, lbminbox);
            });
            lbminbox.find("button[name='lbminsearchbtn']").off("click").on("click", function () {
                T.configbody.isreload = true;
                T.reloadpage.call(lbminbox);
                //T.showlbmininfo.call(thisform, lbminbox);
                lbminbox.removeData("pagedata");
            });
            lbminbox.find("button[name='lbminresetbtn']").off("click").on("click", function (e) {
                lbminbox.find("#lbminsearch *[name]").val("");
                layform.render("select");
                //T.showlbmininfo(lbminbox);
            });
            lbminbox.find(".layui-tab-title li").off("click").on("click", function (e) {
                var data_tmp = $(e.target).attr("data-tmp");
                $(e.target).siblings("li").removeClass("layui-this");
                $(e.target).addClass("layui-this");
                if (data_tmp == "lb") {
                    //T.showlbmininfo.call(thisform,lbminbox);
                    T.lbminbody_lb.call(thisform, lbminbox);
                } else if (data_tmp == "tj") {
                    T.lbminbody_tj.call(thisform, lbminbox);
                }
            });
        }
        thisform.find("button[name='domsearchbtn']").off("click").on("click", function () {
            $.SelectDomain(function (dataset) {
                var arr = [];
                $.each(dataset, function (i, d) {
                    arr.push(d.dom);
                })
                arr.push("");
                var obj = thisform.find("textarea[name='ghdomain']");
                obj.val(obj.val() + arr.join('\r\n'));
                thisform.data("domainlist", obj.val());
                T.getdomaintype.call(thisform);
            });
        });
        thisform.find("button[name='eppcmdbtn']").off("click").on("click", function () {
            var index = $(this).attr("data-index");
            if (index) {
                var eppcmdjson = jsondata.data.info[index].eppcmd;
                if (eppcmdjson) {
                    T.showeppcmd(eppcmdjson);
                }
            }
        });
        layform.on("select(jjyyselect)", function (obj) {
            var jjyy = obj.value;
            thisform.find("textarea[name='jjyy']").val(jjyy);
        });
        layform.on("checkbox(defaultbtn)", function (obj) {
            T.setdefault.call(thisform, obj);
        });
        T.showzjxx.call(thisform, jsondata);//香港网络等选项
        T.showphbox.call(thisform, jsondata);//电话
        T.showcoshengshi.call(thisform, jsondata);//区域
        T.checkinput.call(thisform);//输入检测
    },
    setdefault: function (obj) {
        var c_sysid = $(obj.elem).attr("data-id");
        var regtype = $(obj.elem).attr("data-regtype");
        var isdefault = obj.elem.checked;
        layer.sure(isdefault ? "设置该模板为(" + regtype + ")默认模板后,将取消其它已设置的(" + regtype + ")默认模板,确定设置该模板为默认模板?" : "确定取消(" + regtype + ")默认模板?", function () {
            var lbox = layer.loading(3);
            var putdata = { act: "setdefault", c_sysid: c_sysid, isdefault: isdefault ? 1 : 0 };
            T.dosubmit(putdata, function (jsondata) {
                if (jsondata.result == "200") {
                    $("#audittab li[data-tmp='lb']").trigger("click");
                } else {
                    $(obj.elem).prop("checked", !isdefault);
                    layform.render("checkbox");
                    layer.error(jsondata.msg.join("\r\n"));
                }
            }, function () {
                layer.close(lbox);
            });
        }, function () {
            $(obj.elem).prop("checked", !isdefault);
            layform.render("checkbox");
        });
    },
    showeppcmd: function (eppcmdjson) {
        var html = template("eppcmdbody_tmp", eppcmdjson);
        layer.open({
            type: 1,
            title: "执行日志,仅管理员才看得到",
            content: html,
            area: ['910px'],
            btn: ['关闭'],
            resize: false,
            end: function () {
                layer.closeAll();
            },
            success: function (layero, indexs) {
                var tb = { skin: 'row', even: true, size: 'bg', limit: eppcmdjson.length };
                if (eppcmdjson.length >= 8) tb.height = 300;
                laytable.init("eppcmdtable", tb);
                layer.render_(layero, indexs);
                layform.render();
            }
        });
    },
    chkregsub: function () {
        var thisform = this;
        var c_sysidObj = thisform.find("input[name='c_sysid']:radio:checked");
        var lbmintab = thisform.find("#lbminbox li.layui-this").attr("data-tmp");
        var domainlist = $.hasData(thisform[0]) && thisform.data("domainlist") || null;
        if (domainlist == null) {
            layer.error("没有找到注册的域名");
            return false;
        }
        if (lbmintab == "lb" && !c_sysidObj[0]) {
            layer.error("请选择资料");
            return false;
        }
        T.postkeyval($("#lbminbox")[0], { tab: lbmintab });
        return true;
    },
    chkghsub: function () {
        var thisform = this;
        var ghdomainObj = thisform.find("textarea[name='ghdomain']");
        var eppidObj = thisform.find("input[name='eppidtype']:checkbox:checked");
        var c_sysidObj = thisform.find("input[name='c_sysid']:radio:checked");
        var lbmintab = thisform.find("#lbminbox li.layui-this").attr("data-tmp");
        if (ghdomainObj[0]) {
            var ghdomain = ghdomainObj.val()
            if (!/\.[a-zA-z\-\u4e00-\u9fa5]{1,10}/ig.test(ghdomain)) {
                layer.error("请输入域名");
                return false;
            }
        }
        if (!eppidObj[0]) {
            layer.error("请选择修改对象");
            return false;
        }
        if (lbmintab == "lb" && !c_sysidObj[0]) {
            layer.error("请选择资料");
            return false;
        }
        T.postkeyval($("#lbminbox")[0], { tab: lbmintab });
        return true;
    },
    auditregsub: function (jsondata) {
        var thisform = this;
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: "auditregsub" }, formdata, datakeyval);
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                layer.msg("放入购物车成功,正在跳转到购物车...");
                window.location.href =T.configbody.bagshowurl && T.configbody.bagshowurl!=""?T.configbody.bagshowurl:"/bagshow/";
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    getauditmould: function (fun) {
        var thisform = this;
        T.getdomaintype.call(thisform);
        if (!T.chkregsub.call(thisform)) return false;
        var c_sysidObj = thisform.find("#lbminbox input[name='c_sysid']:radio:checked");
        var lbmintab = thisform.find("#lbminbox li.layui-this").attr("data-tmp");
        if (lbmintab == "tj") {
            T.auditsubact(thisform, null, function (jsondata) {
                if ($.isFunction(fun)) {
                    fun.call(thisform, { c_sysid: $.isArray(jsondata.data) ? jsondata.data[0].c_sysid : jsondata.data.c_sysid });
                }
                layer.closeAll();
            });
        } else if (c_sysidObj[0]) {
            fun.call(thisform, { c_sysid: c_sysidObj.val() });
        }
    },
    auditghsub: function (jsondata) {
        var thisform = this;
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: "auditghsub" }, formdata, datakeyval);
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                layer.success("提交过户任务成功，请查过户状态", function () {
                    $("#audittab li[data-tmp='zt']").trigger("click");
                    layer.closeAll();
                });
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    auditdel: function (c_sysid) {
        var lbox = layer.loading(3);
        var putdata = { act: "auditdel", c_sysid: c_sysid };
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                layer.success("删除已成功", function (index) {
                    layer.close(index);
                    $("#audittab li[data-tmp='lb']").trigger("click");
                });
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    auditsubact: function (thisform, otherputdata, fun) {
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: "auditsub" }, formdata, datakeyval);
        otherputdata && $.extend(true, putdata, otherputdata);
        T.dosubmit(putdata, function (data) {
            if (data.result == "200") {
                if ($.isFunction(fun)) {
                    fun(data);
                }
            } else {
                layer.error(data.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    auditsub: function (jsondata) {
        var thisform = this;
        var otherputdata = jsondata && jsondata.auditinfo && jsondata.tjtype == "mod" && { c_sysid: jsondata.auditinfo.c_sysid } || null;
        T.auditsubact(thisform, otherputdata, function () {
            layer.success("操作已成功", function () {
                $("#audittab li[data-tmp='lb']").trigger("click");
                layer.closeAll();
            });
        });
    },
    getwcfvalue: function (wcfdata, key) {
        var ret = null;
        if ($.isArray(wcfdata)) {
            $.each(wcfdata, function (i, n) {
                if (n.Key == key) {
                    ret = n.Value;
                    return false;
                }
            });
        }
        return ret;
    },
    uploadwcf: function (filejson) {
        var thisform = this;
        var lbox = layer.loading(3);
        var datakeyval = T.getpostkeyval(thisform);
        // console.log(jQuery.support.cors);
        var actgloab = {
            type: "POST",
            url: "https://netservice.vhostgo.com/wcfservice/Service1.svc/Wcf_AuditUploadFile",
            contentType: "application/json; charset=UTF-8",
            dataType: "json"
        };
        var actarr = [];
        var postdata = { token: filejson.data };

        $.each(datakeyval, function (k, v) {
            if (["file_org", "file_lxr", "file_ymsqb"].indexOf(k) >= 0) {
                postdata[k] = v;
            }
        });

        actarr.push($.extend(true, {
            data: JSON.stringify(postdata),
            success: function (wcfretdata) {
                if ($.isjson(wcfretdata) && wcfretdata.d) {
                    var wcfret = wcfretdata.d;
                    if (wcfret.Result == 200) {
                        var apiret = $.getjson(wcfret.Msg);
                        if ($.isjson(apiret)) {
                            if (apiret.result == 200) {
                                layer.success("操作已成功", function () {
                                    T.configbody.isreload = true;
                                    layer.closeAll();
                                });
                            } else {
                                layer.error(apiret.msg.join(";"));
                            }
                        } else {
                            layer.error(apiret);
                        }
                    } else {
                        layer.error(wcfret.Msg);
                        return false;//退出  
                    }
                } else {
                    layer.error(wcfretdata);
                    return false;//退出
                }
            }
        }, actgloab));
        $.Action(actarr, function () {
            layer.close(lbox);
        });
    },
    auditfilesub: function (jsondata) {
        var thisform = this;
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        delete datakeyval["file_org"];
        delete datakeyval["file_lxr"];
        delete datakeyval["file_ymsqb"];//删除文件信息,不用传
        if (jsondata && jsondata.auditinfo && jsondata.auditinfo.domaininfo && jsondata.auditinfo.domaininfo.proid == "domgovcn") formdata.reg_contact_type_file = "govcn";//由于变灰造成没值,强行赋值      
        var putdata = $.extend(true, { act: T.configbody.isadmin ? "uploadwcfadmintoken" : "uploadwcftoken" }, formdata, datakeyval, { c_sysid: jsondata.auditinfo.c_sysid });
        T.dosubmit(putdata, function (jsondata) {

            if (jsondata.result == "200") {
                T.uploadwcf.call(thisform, jsondata);
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    auditfilesub_: function (jsondata, fun) {
        var thisform = this;
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        if (jsondata && jsondata.auditinfo && jsondata.auditinfo.domaininfo && jsondata.auditinfo.domaininfo.proid == "domgovcn") formdata.reg_contact_type_file = "govcn";//由于变灰造成没值,强行赋值
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: T.configbody.isadmin ? "auditfileadminsub" : "auditfilesub" }, formdata, datakeyval, { c_sysid: jsondata.auditinfo.c_sysid });

        //jsondata && jsondata.auditinfo && jsondata.auditinfo.dotype == "mod" && $.extend(true, putdata, { c_sysid: jsondata.auditinfo.c_sysid });
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                if ($.isFunction(fun)) {
                    fun.call(thisform);
                } else {
                    layer.success("操作已成功", function (index) {
                        T.configbody.isreload = true;
                        layer.close(index);
                        //  layer.closeAll();
                    });
                }
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    auditymsqbsub: function (jsondata) {
        var thisform = this;
        if (!(jsondata && jsondata.auditinfo && jsondata.auditinfo.domaininfo && jsondata.auditinfo.domaininfo.d_id)) {
            layer.error("域名id丢失"); return;
        };
        var lbox = layer.loading(3);
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var putdata = $.extend(true, { act: T.configbody.isadmin ? "auditymsqbadminsub" : "auditymsqbsub" }, formdata, datakeyval, { d_id: jsondata.auditinfo.domaininfo.d_id });
        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                layer.success("域名申请表上传已成功", function () {
                    T.configbody.isreload = true;
                    layer.closeAll();
                });
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    dosubmit: function (putdataarr, fun, fun1) {

        var getputdate = function (putdata) {
            $.each(putdata, function (k, v) {
                if (v && /^[^\d\.]+$/ig.test(v) && v.indexOf("·") >= 0) {
                    putdata[k] = v.replace("·", "^.^");
                }
            });
            T.configbody.token && $.extend(true, putdata, { token: T.configbody.token });
            var ajaxPara = $.extend(true, {}, {
                url: T.configbody.loadurl,
                catch: true,
                type: "POST"
            }, {
                    data: putdata,
                    success: function (data) {
                        var jsondata = $.getjson(data);
                        if ($.isjson(jsondata)) {
                            if ($.isFunction(fun)) {
                                fun.call(this, $.extend(true, {}, jsondata));
                            }
                        } else
                            layer.error(jsondata);
                    }
                });
            return ajaxPara;
        }
        var putArr = [];
        if ($.isArray(putdataarr)) {
            $.each(putdataarr, function (i, n) {
                putArr.push(getputdate(n));
            });
        } else {
            putArr.push(getputdate(putdataarr));
        }
        $.Action(putArr, function () {
            if ($.isFunction(fun1)) {
                fun1.call();
            }
        });
    },
    showdomanlistinfo: function (fn) {
        var thisform = this;
        var lbox = layer.loading(3);
        var c_sysid = thisform.attr("data-id");
        var formdata = $.ConvertArray(thisform.serializeArray());
        var datakeyval = T.getpostkeyval(thisform);
        var pagedata = thisform.data("pagedata");
        var putdata = $.extend(true, { act: T.configbody.isadmin ? "domainlbadmin" : "domainlb", c_sysid: c_sysid }, datakeyval, formdata, pagedata);

        T.dosubmit(putdata, function (jsondata) {
            if (jsondata.result == "200") {
                jsondata.cfg = T.configbody.cfg;
                //jsondata.r_sysid = T.configbody.cache.ishasdomain[c_sysid];
                var html = template("domainlb_tmp", $.extend(true, {}, jsondata));
                thisform.find("#domaininfobox").html(html);
                if ($.isFunction(fn)) fn.call(this, jsondata);
            } else {
                layer.error(jsondata.msg.join("\r\n"));
            }
        }, function () {
            layer.close(lbox);
        });
    },
    showdomainlbbox: function (paradata) {
        var bodyhtml = $(template("domainlistbox_tmp", paradata));
        var opendomainlbbox = function (jsondata) {
            layer.open({
                type: 1,
                title: "<span class=\"layui-badge layui-bg-orange\">" + paradata.org + "</span> 关联的所有域名",
                content: bodyhtml.prop("outerHTML"),
                area: [$(window).width()<=700?'390px':'700px'],
                resize: false,
                success: function (layero, indexs) {
                    var f = function (jsondata) {
                        var tb = { skin: 'line', limit: jsondata.data.pagelist.pagesizes };
                        if (jsondata.data.info.length >= 8) tb.height = 340;
                        laytable.init("domainlb", tb);

                        layform.render();
                        layer.render_(layero, indexs);
                        T.bindfun_auditdomainform.call($("form[name='auditdomainlb_form']"), jsondata);
                    }
                    f(jsondata);
                    $("form[name='auditdomainlb_form']").removeData("overfun").data("overfun", function (jsondata) { f(jsondata); });
                }
            });
        }
        var getsearch = function () {
            var schhtml = template("domainlbsearch_tmp", T.configbody);
            bodyhtml.find("#domainsearchbox").html(schhtml);
        }
        var firstshow = function () {
            getsearch();
            T.showdomanlistinfo.call(bodyhtml, function (jsondata) {
                opendomainlbbox(jsondata);
            });
        }
        T.getcfg(T.needcfg(["eppidtype", "statusinfo"]), function () {
            firstshow();
        });
    },
    postkeyval: function (obj, jsonitem) {
        var datakey = "data-putkeyval";
        var putkeyval = $(obj).data(datakey);
        if (jsonitem) {
            if ($.isjson(putkeyval)) {
                $.extend(true, jsonitem, putkeyval);
            }
            $(obj).data(datakey, jsonitem);
        }
        return putkeyval;
    },
    getpostkeyval: function (thisform) {
        var putkeyval = {};
        var obj = thisform && thisform.find("*[id]:visible,*[name]:visible,select[name]:hidden") || $("*[id]:visible,*[name]:visible,select[name]:hidden");
        $.each(obj, function (i, n) {
            if ($.hasData(n)) {
                var bindkv = T.postkeyval(n);
                if ($.isjson(bindkv)) {
                    $.each(bindkv, function (k, v) {
                        if (k in putkeyval) {
                            bindkv[k] = putkeyval[k] + "," + v;
                        }
                    });
                }
                $.extend(true, putkeyval, bindkv);
            }
        });
        // console.log(putkeyval);
        return putkeyval;
    },
    showcoshengshi: function (jsondata) {
        var thisform = this;
        var co_obj = thisform.find("select[name='c_co']");
        if (!co_obj[0]) return;
        var sheng_obj = thisform.find("select[name='c_st_m']");
        var shi_obj = thisform.find("select[name='c_ct_m']");
        var xian_obj = thisform.find("select[name='c_dt_m']");
        //var { c_co, c_st_m, c_ct_m } = jsondata && jsondata.auditinfo || {};
        var c_co = jsondata && jsondata.auditinfo && jsondata.auditinfo.c_co || null;
        var c_st_m = jsondata && jsondata.auditinfo && jsondata.auditinfo.c_st_m || null;
        var c_ct_m = jsondata && jsondata.auditinfo && jsondata.auditinfo.c_ct_m || null;
        var c_dt_m = jsondata && jsondata.auditinfo && jsondata.auditinfo.c_dt_m || null;
        if (c_st_m && c_st_m.indexOf("省") > 0) c_st_m = c_st_m.replace("省", "");
        var getCoObjInfo = function () {
            var coobjoption = co_obj.find("option:selected");
            var cocode = coobjoption.attr("data-cocode");
            var coenname = coobjoption.attr("data-coenname");
            return { "cocode": cocode, "coenname": coenname };
        }
        var bindCoData = function () {
            var cojson = getCoObjInfo();
            thisform.find("#cocode").html(cojson.cocode + "&nbsp;.");
            //thisform.find("input[name='c_st']").html(cojson.cocode + "&nbsp;.");
            T.postkeyval(co_obj[0], cojson);//绑定cocode            
        }
        var setEnvalue = function () {
            var cojson = getCoObjInfo();
            if (co_obj.val() == "CN") {
                thisform.find("input[name='c_st']").val(thisform.find("select[name='c_st_m']").toPinyin());
                thisform.find("input[name='c_ct']").val(thisform.find("select[name='c_ct_m']").toPinyin());
            } else {
                if (thisform.find("input[name='c_st']").val() == "") {
                    thisform.find("input[name='c_st']").val(cojson.coenname);
                }
                if (thisform.find("input[name='c_ct']").val() == "") {
                    thisform.find("input[name='c_ct']").val(cojson.coenname);
                }
            }
        }
        var setcolist = function () {
            co_obj.empty();
            $.each(coInfo, function (i, n) {
                co_obj.append("<option data-cocode=\"" + n.code + "\" data-coenname=\"" + n.enname + "\" value=\"" + n.id + "\" " + ((c_co && n.id == c_co || n.id == "CN") && "selected") + " >" + n.cnname + "</option>");
            });
            setshenglist();
            layform.render("select");
        }
        var setpostcode = function (isfirst) {
            if (!xian_obj) return false;
            var xian_option = xian_obj.find("option:selected");
            var xian_pc = xian_option.attr("data-pc");
            if (xian_pc && xian_pc != null) {
                var pcobj = thisform.find("input[name='c_pc']");
                if (pcobj && pcobj.val() == "" || !isfirst)
                    pcobj.val(xian_pc);
            }
        };
        var setshenglist = function () {
            var coid = co_obj.val();
            var coname = co_obj.find("option:selected").text();
            sheng_obj.empty();
            sheng_obj.append("<option></option>");
            if (coid == "CN") {
                $.each(cityInfo, function (i, n) {
                    if (["香港", "澳门", "台湾"].indexOf(n.province) < 0) {
                        sheng_obj.append("<option data-id=\"" + i + "\" value=\"" + n.province + "\" " + ((c_st_m && c_st_m != null && n.province.indexOf(c_st_m) >= 0 || !c_st_m && jsondata && jsondata.cfg && jsondata.cfg.ipaddr && jsondata.cfg.ipaddr.indexOf(n.province) >= 0) && "selected") + ">" + n.province + "</option>");
                    }
                });
                setshilist();
            } else if (coid) {
                sheng_obj.append("<option data-id=\"" + coid + "\" value=\"" + coname + "\" " + (c_st_m && c_st_m == coname && "selected") + ">" + coname + "</option>");
                setshilist();
            }
            layform.render("select");
            bindCoData();
            setEnvalue();
        }
        var setshilist = function () {
            var shengid = sheng_obj.find("option:selected").attr("data-id");
            var coid = co_obj.val();
            var coname = co_obj.find("option:selected").text();
            shi_obj.empty();
            shi_obj.append("<option></option>");
            if (shengid && shengid != null) {
                if (coid == "CN") {
                    $.each(cityInfo[shengid].city, function (i, n) {
                        shi_obj.append("<option data-id=\"" + i + "\" value=\"" + n.name + "\" " + ((c_ct_m && c_ct_m != null && n.name.indexOf(c_ct_m) >= 0 || !c_ct_m && jsondata && jsondata.cfg && jsondata.cfg.ipaddr && jsondata.cfg.ipaddr.indexOf(n.name) >= 0) && "selected") + ">" + n.name + "</option>");
                    });
                } else if (coid) {
                    shi_obj.append("<option data-id=\"" + coid + "\" value=\"" + coname + "\" " + (c_ct_m && c_ct_m == coname && "selected") + ">" + coname + "</option>");
                }
            }
            layform.render("select");
            setxianlist();
        }
        var setxianlist = function () {
            if (!xian_obj) return;
            var shengid = sheng_obj.find("option:selected").attr("data-id");
            var shiid = shi_obj.find("option:selected").attr("data-id");
            var coid = co_obj.val();
            var coname = co_obj.find("option:selected").text();
            xian_obj.empty();
            xian_obj.append("<option></option>");
            if (shiid && shiid != null) {
                if (coid == "CN") {
                    $.each(cityInfo[shengid].city[shiid].district, function (i, n) {
                        xian_obj.append("<option data-pc=\"" + n.post + "\" data-id=\"" + i + "\" value=\"" + n.name + "\" " + ((c_dt_m && c_dt_m != null && n.name.indexOf(c_dt_m) >= 0 || !c_dt_m && jsondata && jsondata.cfg && jsondata.cfg.ipaddr && jsondata.cfg.ipaddr.indexOf(n.name) >= 0) && "selected") + ">" + n.name + "</option>");
                    });
                } else if (coid) {
                    xian_obj.append("<option data-id=\"" + coid + "\" value=\"" + coname + "\" " + (c_ct_m && c_ct_m == coname && "selected") + ">" + coname + "</option>");
                }
                setpostcode(true);
            }
            layform.render("select");
        }
        setcolist();
        layform.on("select(c_co)", function (obj) {
            setshenglist();
        });
        layform.on("select(c_st_m)", function (obj) {
            setshilist();
            setxianlist();
        });
        layform.on("select(c_ct_m)", function (obj) {
            setxianlist();
            setEnvalue();
        });
        layform.on("select(c_dt_m)", function (obj) {
            setpostcode(false);
        });
    },
    zjxxshow: function (jsondata, obj) {
        var thisform = this;
        var reg_contact_type = thisform.find("input[name='reg_contact_type']:checkbox");
        var ischecked = false, val = '';
        var showfun = function () {
            if (val == "hk") {
                if (ischecked) {
                    var html = template("zjxxhkidtype_tmp", jsondata);
                    thisform.find("#hkidtype_box").html(html);
                    thisform.find("#zjxxhkbox").slideDown(100);
                } else {
                    thisform.find("#zjxxhkbox").slideUp(100);
                }
                T.checkinput.call(thisform.find("#zjxxhkbox"));
            } else if (val == "gswl") {
                if (ischecked) {
                    thisform.find("#zjxxgswlbox").slideDown(100);
                } else {
                    thisform.find("#zjxxgswlbox").slideUp(100);
                }
                T.checkinput.call(thisform.find("#zjxxgswlbox"));
            }
        }
        if (reg_contact_type[0]) {
            if (obj && obj.elem) {//点击选中的
                val = obj.value;
                ischecked = obj.elem.checked;
                showfun();
            } else {
                var ishasObj = T.ishasotherdomain.call(thisform);

                var c_regtypeObj = thisform.find("input[name='c_regtype']:radio:checked");
                if (c_regtypeObj[0]) {
                    var c_regtype = c_regtypeObj.val();
                    jsondata.auditinfo ? jsondata.auditinfo.c_regtype = c_regtype : jsondata.auditinfo = { c_regtype: c_regtype };
                }
                $.each(reg_contact_type, function (i, n) {//加载时已选中的
                    val = $(n).val();
                    val == "hk" && ishasObj.ishashk && $(n).prop("checked", true).prop("disabled", true) && T.postkeyval($("input[name='c_idnum_hk']:text")[0], { reg_contact_type: "hk" }) ||
                        val == "gswl" && ishasObj.ishasgswl && $(n).prop("checked", true).prop("disabled", true) && T.postkeyval($("input[name='c_idnum_gswl']:text")[0], { reg_contact_type: "gswl" });
                    ischecked = $(n).is(":checked");
                    showfun();
                });
            }
            layform.render();
        }
    },
    showzjxx: function (jsondata) {
        var thisform = this;
        T.zjxxshow.call(thisform, jsondata);
        layform.on("checkbox(reg_contact_type)", function (obj) {
            T.zjxxshow.call(thisform, jsondata, obj);
        });
    },
    showzjxx_file: function () {
        var thisform = this;
        if (!thisform.find("input[name='reg_contact_type_file']")[0]) return;
        var render = function () {
            $.hasData(thisform[0]) && thisform.data("renderbox") && thisform.data("renderbox").call(thisform);
            layform.render();
        }
        var show = function () {
            $.each(thisform.find("input[name='reg_contact_type_file']:checkbox"), function (i, n) {
                var btnobj = $(n), val = btnobj.val();
                if (val == "govcn") {
                    if (btnobj.is(":checked")) {
                        $("#zjxxgovcnbox").slideDown(100, function () {
                            render();
                        });
                    } else {
                        $("#zjxxgovcnbox").slideUp(100, function () {
                            render();
                        });
                    }
                }
            });
        }
        show();
        layform.on("checkbox(reg_contact_type_file)", function (obj) {
            show();
        });
    },
    showphbox: function (jsondata) {
        var thisform = this;
        var c_ph_type = thisform.find("select[name='c_ph_type']");
        if (c_ph_type[0]) {
            var show = function () {
                var c_ph_type_v = thisform.find("select[name='c_ph_type']").val();
                if (c_ph_type_v == 0) {
                    thisform.find(".zjbox").fadeOut(50, function () {
                        thisform.find(".sjbox").fadeIn(50);
                        T.checkinput.call(c_ph_type.parents(".layui-form-item"));
                    });
                } else {
                    thisform.find(".sjbox").fadeOut(50, function () {
                        thisform.find(".zjbox").fadeIn(50);
                        T.checkinput.call(c_ph_type.parents(".layui-form-item"));
                    });
                }
            }
            show();
            layform.on("select(c_ph_type)", function (obj) {
                show();
            });
        }
    },
    pageload: function (pagebox, pagelist, layout, fun) {
        if (pagebox) {
            if (pagelist) {
                laypage.render({
                    elem: pagebox //ID，不用加 # 号					
                    , count: pagelist.linecount //数据总数，从服务端得到
                    , curr: pagelist.pageno
                    , limit: pagelist.pagesizes
                    , limits: [10, 20, 50, 100, 200, 500, 1000, 3000]
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
    },
    insertimg: function (obj, pid, src, alt, fn) {
        obj.html("<img style=\"width: 100px; height:100px\" layer-pid=\"" + pid + "\" src=\"" + src + "\" alt=\"" + alt + "\">");
        obj.removeClass("imgerror");
        if ($.isFunction(fn)) {
            fn.call();
        }
    },
    uploadbind: function () {
        var uploadOrg = layupload.render({
            elem: "#upbtn_org",
            auto: false,
            size: 10000, //最大允许上传的文件大小      
            choose: function (obj) {
                obj.preview(function (index, file, result) {
                    //console.log(result);
                    T.insertimg($("#upbtn_org"), index, result, file.name, function () {
                        T.postkeyval($("#upbtn_org")[0], { file_org: result });
                    });
                });
            }
        });
        var uploadLxr = layupload.render({
            elem: '#upbtn_lxr',
            auto: false,
            size: 10000, //最大允许上传的文件大小 
            choose: function (obj) {
                obj.preview(function (index, file, result) {
                    T.insertimg($("#upbtn_lxr"), index, result, file.name, function () {
                        T.postkeyval($("#upbtn_lxr")[0], { file_lxr: result });
                    });
                });
            }
        });
        var uploadymsqb = layupload.render({
            elem: '#upbtn_ymsqb',
            auto: false,
            size: 4096, //最大允许上传的文件大小 
            choose: function (obj) {
                obj.preview(function (index, file, result) {
                    T.insertimg($("#upbtn_ymsqb"), index, result, file.name, function () {
                        T.postkeyval($("#upbtn_ymsqb")[0], { file_ymsqb: result });
                    });
                });
            }
        });
    },
    reloadpage: function () {
        var thisform = this;
        if (T.configbody.isreload) {
            $.hasData(thisform[0]) && $.isFunction(thisform.data("reloadpage")) && thisform.data("reloadpage").call(thisform);
            T.configbody.isreload = false;
        }
    },
    checkinput: function () {
        layer.closeAll("tips");
        var thisform = this;
        $.each(thisform.find("[lay-verify]:visible"), function (i, n) {
            T.checkinputItem.call(n);
        });
    },
    checkinputItem: function () {
        if (!this) return;
        var n = $(this);
        if (!n.is(":visible")) return;
        var varifykey = n.attr("lay-verify");
        if (varifykey) {
            if (varifykey in T.varifyjson) {
                n.on("blur", function () {
                    var val = $(this).val();
                    var errstr = T.varifyjson[varifykey](val, this);
                    if (errstr) {
                        // layer.tips(errstr, this, {
                        //   tips: [["c_fn_m", "c_fn", "c_ln_m", "c_ln", "phoneqh", "phonenum", "phonefj"].indexOf(varifykey) >= 0 ? 1 : 2, "#2086ee"]
                        // });
                        if (!$(this).data("tindex")) {
                            var tindex = layer.open({
                                title: false,
                                type: 4,
                                closeBtn: 0,
                                time: 5000,
                                fixed: false,
                                shade: 0,
                                anim: -1,
                                tipsMore: true,
                                tips: [["c_ln_m", "c_ln", "phoneqh", "phonenum"].indexOf(varifykey) >= 0  || $(window).width()<=700 ? 1 : 2, "#efefef"],
                                content: ["<li class=\"layui-icon layui-icon-face-cry\" style=\"color:red\">&nbsp;<span style=\"font-size:12px\">" + errstr + "</span></li>", this] //数组第二项即吸附元素选择器或者DOM
                            });
                            $(this).data("tindex", tindex);
                        }
                    }
                });
                n.on("focus", function () {
                    if ($(this).data("tindex")) {
                        layer.close($(this).data("tindex"));
                        $.removeData(this, "tindex");
                    }
                    //
                });
            }
        }
    },
    varifyjson: {
        c_org_m: function (v, o) {
            if ($(o).is(":visible")) {
                if (!/^(.*[\u4e00-\u9fa5\·]+.*){2,64}$/ig.test(v)) {
                    return "域名所有者单位名称必须是2-64位的字符且必须含有中文";
                } else if (["成都西维数码科技有限公司", "等待更新", "临时模版", "隐私保护"].indexOf(v) >= 0) {
                    return "不允许填写:" + v;
                }
            }
        },
        c_ln_m: function (v, o) {
            if ($(o).is(":visible") && !/^[\u4e00-\u9fa5\·]{1,10}$/ig.test(v)) {
                return "中文姓格式错误";
            }
        },
        c_fn_m: function (v, o) {
            if ($(o).is(":visible") && !/^[\u4e00-\u9fa5\·]{1,10}$/ig.test(v)) {
                return "中文名格式错误";
            }
        },
        c_st_m: function (v, o) {
            if ($(o).siblings(".layui-form-select").is(":visible") && !/^[\u4e00-\u9fa5]{2,10}$/ig.test(v)) {
                return "省份必须选择";
            }
        },
        c_ct_m: function (v, o) {
            if ($(o).siblings(".layui-form-select").is(":visible") && !/^[\u4e00-\u9fa5]{1,20}$/ig.test(v)) {
                return "城市必须选择";
            }
        },
        c_adr_m: function (v, o) {
            if ($(o).is(":visible") && !/^([\u4e00-\u9fa5]+.*){4,64}$/ig.test(v)) {
                return "通讯地址必须是5-64位的中文字符";
            }
        },
        pcnumber: function (v, o) {//邮编
            if (!/^\d{5,10}$/ig.test(v)) {
                return "请输入正确的邮编";
            } else if (/^(1{6})$|^(2{6})$|^(3{6})$|^(4{6})$|^(5{6})$|^(6{6})$|^(7{6})$|^(8{6})$|^(9{6})$|^(0{6})$/ig.test(v)) {
                return "无效邮编";
            } else if ("01234567890".indexOf(v) >= 0 || "09876543210".indexOf(v) >= 0) {
                return "无效邮编.";
            }
        },
        phone: function (v, o) {
            if ($(o).is(":visible") && !/^\d{8,11}$/ig.test(v)) {
                return "手机格式错误";
            }
        },
        phoneqh: function (v, o) {
            if ($(o).is(":visible") && !/^\d{2,10}$/ig.test(v)) {
                return "固话区号格式错误";
            }
        },
        phonenum: function (v, o) {
            if ($(o).is(":visible")) {
                if (!/^\d{5,11}$/ig.test(v)) {
                    return "固话号码格式错误";
                }
            }
        },
        phonefj: function (v, o) {
            if ($(o).is(":visible") && !/^\d{0,8}$/ig.test(v)) {
                return "分机号码格式错误";
            }
        },
        email: function (v, o) {
            if ($(o).is(":visible")) {
                if (!/^[\w\-]+(\.[\w\-]+)*\@[\w\-]+(\.[\w\-]+)+$/ig.test(v)) {
                    return "邮箱格式错误";
                } else if (/\.((cn)|(com)|(net)|(hk)|(tw)|(top)|(xyz)|(vip)|(email)|(shop)|(club)|(ltd)|(asia))\w+$/ig.test(v)) {
                    return "邮箱后缀不正确,请检查";
                }
            }

        },
        c_org: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s\#\·\.\,\-\(\)\+]{5,100}$/ig.test(v)) {
                return "域名所有者单位名称必须是5-100位的字符";
            }
        },
        c_ln: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s\·]{1,64}$/ig.test(v)) {
                return "英文姓必须是1-64位的字符";
            }
        },
        c_fn: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s\·]{1,64}$/ig.test(v)) {
                return "英文名必须是1-64位的字符";
            }
        },
        c_st: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s]{2,64}$/ig.test(v)) {
                return "英文省份必须是2-64位的字符";
            }
        },
        c_ct: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s]{2,64}$/ig.test(v)) {
                return "英文城市必须是2-64位的字符";
            }
        },
        c_adr: function (v, o) {
            if ($(o).is(":visible") && !/^[\w\s\-\,\.\(\)]{9,150}$/ig.test(v)) {
                return "英文通讯地址必须是9-150位的字符";
            }
        },
        idtype: function (v, o) {
            if ($(o).siblings(".layui-form-select").is(":visible")) {
                if (!/^\w{1,20}$/ig.test(v)) {
                    return "证件类型格式错误";
                }
            }
        },
        idnum: function (v, o) {
            if ($(o).is(":visible")) {
                if (!/^.{5,50}$/ig.test(v)) {
                    return "证件号码格式错误";
                }
                if ($(o).attr("name") == "f_code_org") {
                    var f_type_org = $("select[name='f_type_org']").val();
                    if (f_type_org == "1") {
                        if (!/(^\d{18}$)|(^\d{17}[xX]$)$/ig.test(v)) {
                            return "身份证号码格式错误";
                        }
                    } else if (f_type_org == "3") {
                        if (!/^((?:(?![IOZSV])[\dA-Z]){2}\d{6}(?:(?![IOZSV])[\dA-Z]){10})|(\d{15})$/ig.test(v)) {
                            return "统一社会信用代码或注册号格式错误";
                        }
                    }
                }
                if ($(o).attr("name") == "f_code_lxr") {
                    var f_type_lxr = $("select[name='f_type_lxr']").val();
                    if (f_type_lxr == "1") {
                        if (!/(^\d{18}$)|(^\d{17}[xX]$)$/ig.test(v)) {
                            return "身份证号码格式错误";
                        }
                    }
                }
                if ($(o).attr("name") == "c_idnum_gswl") {
                    var c_idtype_gswl = $("select[name='c_idtype_gswl']").val();
                    if (c_idtype_gswl == "SFZ") {
                        if (!/(^\d{18}$)|(^\d{17}[xX]$)$/ig.test(v)) {
                            return "身份证号码格式错误";
                        }
                    }
                }
                if ($(o).attr("name") == "c_idnum_hk") {
                    var c_idtype_hk = $("select[name='c_idtype_hk']").val();
                    if (c_idtype_hk == "OTHID") {
                        if (!/(^\d{18}$)|(^\d{17}[xX]$)$/ig.test(v)) {
                            return "大陆身份证号码格式错误";
                        }
                    } else if (c_idtype_hk == "HKID") {
                        if (!/^[A-Z]{1,2}[0-9]{6}\(?[0-9A]\)?$/ig.test(v)) {
                            return "香港身份证号码格式错误";
                        }
                    }
                }

            }

        },
        uploadfile: function (v, o) {
            if ($(o).is(":visible")) {
                var img = $(o).find("img[layer-pid]");
                if (img[0]) {
                    if (!$.hasData(o)) {
                        $(o).addClass("imgerror");
                        return "图片材料出错,请重新传择图片";
                    }
                } else {
                    $(o).addClass("imgerror");
                    return "请上传图片材料";
                }
            }
        },
        passwd: function (v, o) {
            if (!/^.{6,50}$/ig.test(v)) {
                return "域名密码需6-50位字符";
            } else if (/(^\d+$)/ig.test(v)) {
                return "域名密码不能是纯数字";
            }
        },
        domain: function (v, o) {
            if (!/^([\w\-\u4e00-\u9fa5]+|\*)(\.[\w\-\u4e00-\u9fa5]+)*(\.[\w\-\u4e00-\u9fa5]+)+$/ig.test(v)) {
                return "域名格式错误"
            }
        },
        agreement: function (v, o) {
            if (!$(o).is(":checked")) {
                return "请勾选协议并了解权利和责任";
            }
        }
    },
    verify: function () {
        layform.verify(T.varifyjson);
    }
}