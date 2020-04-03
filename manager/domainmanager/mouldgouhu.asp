<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
ids=Requesta("ids")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名模板过户管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/noedit/template.js"></script>
<script language="javascript" src="/noedit/pinyin.js"></script>
<script src="/database/cache/citypost.js"></script>
<script language="javascript" src="/noedit/check/Validform.js?!21212"></script>
<link rel="stylesheet" href="/noedit/webuploader/webuploader.css">
<script language="javascript" src="/noedit/webuploader/webuploader.min.js"></script>
<link href="/noedit/check/chkcss.css" rel="stylesheet" type="text/css" />
<style>
.linebox2, .linebox2 dt, .linebox2 dd {
	display: block;
	list-style: none;
	margin: 0;
	padding: 0;
}
.linebox2 { width: 680px; }
.linebox2 dt {
	font-size: 14px;
	font-weight: bold;
	text-align: left;
	padding: 5px 0;
	color: #000;
}
.linebox2 dd {
	padding: 5px 0;

}
.linebox2 dd.clearfix label {
	display: block;
	padding-top: 6px;
	float: left;
	text-align: right;
	width: 120px;
	font-size: 14px;
	color: #000;
	text-align: right;
}
.linebox2 dd.clearfix label.msg {
	width: auto;
	text-align: left;
	margin-left: 8px;
	font-weight: normal;
}
.linebox2 .bottom {
	display: block;

	padding: 6px;
	margin: 2px 0;
	clear: both;
	border: none;
}
.linebox2 .bottom input {
	float: none;
	display: inline;
}
.linebox2 .inputtext_new { margin-top: -6px; }
.linebox2 select {
	border: 1px solid #ccc;
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1) inset;
	color: #666;
	cursor: text;
	height: 30px;
	line-height: 22px;
	padding: 3px 5px;
	width: 230px;
	margin-top: -6px;
}
.linebox2 textarea {
	border: 1px solid #c2c2c2;
	width: 360px;
	height: 150px;
	line-height: 20px;
	padding: 10px;
	margin-right: 10px;
}
.showredomain li {
	overflow: hidden;
	border-bottom: 1px #efefef solid;
	line-height: 30px;
	height: 30px;
}
.fail { color: #FF4F00 }
.success { color: #31C505 }
.editClass {
	width: 380px;
	height: 512px;
}
.GreenColor {
	color: #090;
	font-weight: bold;
}
#pushmsg { display:block; border:1px solid #ccc; padding:5px; margin:10px;}
.pushload { color: #ccc; }
.pusherr { color: #FF4F00; }
.pushok { color: #31C505 }
#pushbox{
	overflow:auto;
	max-height:500px;
}
#pushbox .allload {
	text-align: center;
	
	margin: 2 5px;
	background-color: #efefef;
}
#pushbox .pushover {
	text-align: center;
	border: none;
	margin: 2 5px;
	background-color:#efefef;
	color: #FF4F00
}
#pushbox .pushitem {
	margin: 5px;
	color: #000;
}
.linebox2 dd.clearfix label.domaininfo div{
	padding:0; margin:0; width:auto;
}
.linebox2 dd.clearfix label.domaininfo{
	max-height:200px;
	width:530px;
	overflow-w:hidden;
	overflow-y:auto;
	padding:0;
}

input.textbtn {
    background: #F30;
    padding: 0px 20px;
    border-radius: 3px;
    font-size: 14px;
    line-height: 30px;
    border: none;
    color: #fff;
    cursor: pointer;
    text-align: center;
    height: 30px;
    text-indent: 0px;
}
input.btnstyle {
    background: #1b75b8;
    padding: 0px 20px;
    border-radius: 3px;
    font-size: 14px;
    line-height: 30px;
    border: none;
    color: #fff;
    cursor: pointer;
    text-align: center;
    height: 30px;
    text-indent: 0px;
}
</style>
<script language="javascript" src="/noedit/check/Validform.js"></script>
<script>
	var ids="<%=ids%>";
</script>
</HEAD>
<body>
<!--#include virtual="/manager/top.asp" -->
<div id="MainContentDIV"> 
  <!--#include virtual="/manager/manageleft.asp" -->
  <div id="ManagerRight" class="ManagerRightShow">
    <div id="SiteMapPath">
      <ul>
        <li><a href="/">首页</a></li>
        <li><a href="/Manager/">管理中心</a></li>
        <li><a href="/Manager/domainmanager/">域名管理</a></li>
        <li><a href="/manager/domainmanager/momould.asp">域名注册模板管理</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <ul class="manager-tab">
        <li class="liactive"><a>域名模板1</a></li>
        <li tag="list"><a href="./">域名列表</a></li>
        <li tag="list"><a href="./momouldnew.asp">添加模板</a></li>
      </ul>
      <div id="contenthtml"></div>
    </div>
  </div>
</div>
</div>
<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
<script id="temp_guohulist_box" type="text/html">
	{{if result=="200"}}
		{{each data}}
		 
				<dl class="linebox2" id="pushmsg">
					<dd class="clearfix">
						<label>过户域名:</label>
						<label class="msg clearfix domaininfo">
						{{each $value.domainarr}}
							<div>{{$value.strdomain}}</div>
						{{/each}}
						</label>
					</dd>
				 
					<dd class="clearfix" style="border-bottom:none">
						<label>选择模板:</label>
						<label class="msg clearfix" for=" ">
						<span class="pos-r">
							<select name="Tempid" class="common-select reg-area-select">
								<option value="">请选择模板</option>
								{{each $value.mould}}
									<option value="{{$index}}">{{$value}}</option>
								{{/each}}
							</select>
						</span>
						</label>
						<label class="msg clearfix" style="position: relative;top: 7px;">
							<a href="./momouldnew.asp?act=add&register={{(escapecode($value.registercode))}}" style="color:#06c" href="javascript:void(0)" class="newmouldbtn hlp_msg" data-help="提示：某些后缀可能有不同注册接口，其模板互不通用。如果不能选择到以前的模板，请点击该链接重新创建模板。">没有找到模板?立即创建</a>
						</label>
					</dd>
			
					<dd class="clearfix">
						<label>&nbsp;</label>&nbsp;
						<input type="button" name="pushbtn" value="确定过户" class="textbtn" data-index="{{$index}}" />
						&nbsp;
						<input type="button" name="backbtn" value="返回" class="btnstyle" />
						<span class="pl-20 ml-20" style="background: url(/images2016/ico_notice.gif) no-repeat left center;">
							<a class="orange-link" href="javascript:;" target="_blank"><b>模板需通过审核才能用于过户</b></a>
						</span>
					</dd>
				</dl>
 	
		{{/each}}
	{{else}}
		<div>出错了:{{msg}}</div>
	{{/if}}
</script>
<script>
	var mouldguohu={
			cfg:{
				url:"mouldajax.asp"
			},
			load:function(){
				var self=this;
				var postdata={"act":"getgouhuinf","ids":ids}
				$.post(self.cfg.url,postdata,function(data){
						if(data.result=="200"){
								$("#contenthtml").html(template("temp_guohulist_box",data.info[0]))
								self.bindbt()			
							}else{
								$.dialog.alert(data.msg)	
							}
					
					},"json")
				
				},
			sureguohu:function(strdomain,m_sysid){
					var self=this;
					var postdata={"act":"dmguohu","strdomain":strdomain,"m_sysid":m_sysid}
					$.post(self.cfg.url,postdata,function(data){
						if(data.result=="200"){
								msgstr=""
							 	if(data.info[0].result=="200"){
									var obj=data.info[0].data
									for(var i=0;i<obj.length;i++)
									{
										if(obj[i].result !="200"){
											msgstr+=obj[i].domain+" <font color=red>操作失败["+obj[i].msg+"]</font><br>"
										}else{
											msgstr+=obj[i].domain+" <font color=greeb>操作成功</font><br>"
										}
									}
									$.dialog.alert(msgstr);
								}
							}else{
								$.dialog.alert(data.msg)	
							}
					
					},"json")
				},
			bindbt:function(){
					var self=this;
					$("input[name='pushbtn']").click(function(){
						var obj=$(this);
						var index_=obj.attr("data-index");
						var domaininfo=$(".domaininfo").eq(index_).find("div");
						var Tempid=$("select[name='Tempid']").eq(index_).val();
						if(Tempid=="null"){Tempid=""}
						var strdomainArr=[]
						domaininfo.each(function(i,o){
								var temp_=$(this).text();
								if(temp_ != ""){
									strdomainArr.push(temp_)		
								}
							})
						if(Tempid==""){
							$.dialog.alert("请先选择要过户的模板")	
							return false;
						}
						if(strdomainArr.length<=0){
							$.dialog.alert("获取域名数据失败")	
							return false;
						}
						self.sureguohu(strdomainArr.join(","),Tempid);						
					})
				},
			init:function(){
				mouldguohu.load();
			}
		}
	$(function(){			
			template.helper("escapecode",escapecode)
			mouldguohu.init();		
	})
</script>
<style>
.showbox{width:900px; height:500px;}
.showdomainlist{width:900px; height:400px;overflow:auto;}
.showdomainlist ul,.showdomainlist li{padding:0;margin:0;list-style:none}
.showdomainlist li{padding:5px 10px;;float:left;line-height:25px; border-bottom:1px #ccc solid}
</style>
