<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
register=requesta("register")

sql="select proid from domainlist where isreglocal=0 and userid="&session("u_sysid")&"  group by proid"
set chkrs=conn.execute(sql)
strproid=""
do while not chkrs.eof
	if trim(strproid)="" then
		strproid=chkrs(0)
	else
		strproid=strproid&","&chkrs(0)
	end if
chkrs.movenext
loop
chkrs.close:set chkrs=nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名模板管理</title>
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
#regdomain {
	background: url(/newimages/Domains/Domain_registration_bg_2.jpg) no-repeat;
	width: 720px;
	overflow: hidden;
	margin: auto;
	padding: 15px 15px 0px 15px;
}
#regdomain form {
	display: block;
	margin: 0;
	padding: 0;
}
#regdomain dl, #regdomain dt, #regdomain dd {
	display: block;
	margin: 0;
	padding: 0;
	clear: both;
}
#regdomain dl {
	width: 90%;
	margin: 0 auto;
	margin-bottom: 10px;
}
#regdomain dt {
	background: url(/newimages/default/C_Title_ring_on.gif) center left no-repeat;
	padding-left: 20px;
	font-size: 14px;
	color: #000;
	font-weight: bold;
	height: 35px;
	line-height: 35px;
}
#regdomain dd {
	color: #666;
	height: 30px;
	line-height: 30px;
}
#regdomain label {
	display: block;
	float: left;
	width: 120px;
	text-align: right;
	color: #333;
	font-weight: inherit;
	margin: 0;
	padding: 0;
}
#regdomain h1, #regdomain h2, #regdomain h3 {
	display: block;
	float: left;
	font-size: 12px;
	color: #999;
	font-weight: normal;
	margin: 0;
	padding: 0;
}
#regdomain h1 {
	width: 240px;
}
#regdomain h2 {
	width: 265px;
	clear: right;
}
#regdomain p {
	width: 90%;
	display: block;
	clear: both;
	text-align: center;
	margin: 10px auto;
	padding: 0;
}
/* 鼠标移动时产生的样式*/
#regdomain input.oldbg {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #999;
	border-right-color: #f1f1f1;
	border-bottom-color: #f1f1f1;
	border-left-color: #CCC;
	height: 14px;
	color: #666;
}
#regdomain input.chgbg {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #35CDFF;
	border-right-color: #B3ECFF;
	border-bottom-color: #B3ECFF;
	border-left-color: #35CDFF;
	height: 14px;
	color: #666;
	background-color: #E9F6FF;
}
#regdomain dd select.oldbg {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #999;
	border-right-color: #f1f1f1;
	border-bottom-color: #f1f1f1;
	border-left-color: #CCC;
	height: 18px;
	color: #666;
}
#regdomain dd select.chgbg {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #35CDFF;
	border-right-color: #B3ECFF;
	border-bottom-color: #B3ECFF;
	border-left-color: #35CDFF;
	height: 18px;
	color: #666;
}
/*域名列表样式*/
.domaincontent {
	height: auto;
}
#regdomain .domaincontent label {
	height: 90px;
	background: url(/newimages/Domains/gowuchebg.gif) no-repeat;
	background-position: 20px 1px;
}
#regdomain .domaincontent h3 {
	width: 500px;
}
#regdomain dd h3 ul {
	display: block;
	list-style-type: none;
	margin: 0;
	padding: 0;
}
#regdomainmsg {
	display: block;
	margin-bottom: 15px;
	margin-top: 15px;
}
#regdomainmsg li {
	height: 25px;
	line-height: 25px;
	background: url(/newimages/Domains/domainquery_bg01.gif);
}
.domaintitle {
	background: url(/newimages/default/assess_icon.gif) left no-repeat;
	padding-left: 10px;
	padding-right: 5px;
	display: block;
	float: left;
	background: #fff;
	width: auto;
	color: #000;
}
.domainmsg {
	display: block;
	float: right;
	background: #fff;
	width: auto;
}
#regdomain .clearbottom {
	clear: both;
}
/*出错时出现的提示*/
#regdomain dl dd h2 span {
	margin: 0;
	padding: 0;
	display: none;
	height: 25px;
}
.Domain_Title {
	background: url(/newimages/default/C_Title_ring_on.gif) no-repeat 0px 10px;
	padding-left: 20px;
	font-size: 14px;
	color: #000;
	font-weight: bold;
	height: 35px;
	line-height: 35px;
	margin-top: 20px;
}
.Domain_Info_Content ul li {
	float: left;
}
.ttl_ {
	height: 24px;
	width: 125px;
	text-align: right;
	color: #369;
	font-weight: bold;
}
.iil_ {
	margin-left: 15px;
	width: 215px;
	height: 24px;
}
.rrl_ {
	margin-left: 15px;
	height: 24px;
	width: 250px;
}
.domainprice_d {
	width: 100px;
	display: block;
	float: left;
	padding-left: 10px;
}
.domainprice_c {
	width: 120px;
	display: block;
	float: left;
	padding-left: 10px;
}
.filelist {
	display: block;
	float: left;
	text-align: center;
	margin: 0;
	padding: 0;
	position: relative;
}
.inp300 {
	display: inline-block;
	margin: -5px 2px 2px 2px;
	padding: 4px 5px;
	border: 1px solid #ccc;
	vertical-align: middle;
	height: 32px;
	line-height: 32px;
	width: 300px;
	box-sizing: border-box;
}
ul.list_box  .filebtn{ display:block; float:left; margin:12px 5px 0 5px; padding:0;}
.filebtn {
    display: block;
    float: left;
    margin: 12px 5px 0 5px;
    padding: 0;
}
</style>
<script language="javascript" src="/noedit/check/Validform.js"></script>
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
        <li class="liactive" tag="create"><a>添加模板</a></li>
        <li tag="list"><a>模板列表</a></li>
      </ul>
      <div id="contenthtml"></div>
    </div>
  </div>
</div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
<style>
.showbox{width:900px; height:500px;}
.showdomainlist{width:900px; height:420px;overflow:auto;}
.showdomainlist ul,.showdomainlist li{padding:0;margin:0;list-style:none;}
.showdomainlist li{    padding: 5px 10px;
    float: left;
    line-height: 25px;
    border: 1px #ccc solid;
    width: 100px;
    background-color: #efefef;
    margin: 2px;}
.icon {
    width: 17px;
    height: 17px;
    display: inline-block;
    vertical-align: top;
    background-image: url(/template/Tpl_2016/images/icon.png);
    background-repeat: no-repeat;
    margin-left: 3px;
    margin-top: 1px;
}
.hot {
    background-position: -36px -498px;
}
</style>
<script id="temp_showdomaintype" type="text/html">
	<div class="showbox">
		<center><div style="font-size:18px;color:red;padding:10px;">请选择要创建的模板后缀,注意部份产品有中英文区别</div></center>
		<div class="showdomainlist">
			<ul>
			{{each db as key index}}
				<li title="{{key.p_name}}"><label for="types_{{index}}"> <INPUT TYPE="checkbox" NAME="proid" id="types_{{index}}" value="{{key.domtype}}" >{{key.p_suffix}}</label></li>
			{{/each}}
			<ul>
		</div>
	<div style="clear:both"></div>
	<center><br /><LABEL><INPUT TYPE="checkbox" NAME="myproidbt" onclick="mould.selectmyproid(this)">选中我现有产品类型</LABEL>&nbsp;&nbsp;<button class="z_btn-buy manager-btn s-btn" onclick="mould.selectdomaintype()">选中型号</button></center>
	</div>
</script>
<script id="temp_list_box" type="text/html">
	<div style="line-height:35px; margin:10px 0px;"> 
	<form name="searchform" id="searchform" method="post" onsubmit="return false">
		每页显示:<select name="pagesize" class="manager-select s-select"> 
					<option value="50">50条</option>
					<option value="100">100条</option>					
					<option value="150">150条</option>
					<option value="150">300条</option>
				 </select>
		<input type="hidden" name="pageno" value="1"><input type="hidden" name="act" value="getlist">
		<button id="searchbtn" class="z_btn-buy manager-btn s-btn addmodulebtn">查询</button>
		<input type="reset" class="z_btn-buy manager-btn s-btn">
	</form>
	<div id="list_box_info">
	</div>
	</div>
</script>
<script id="temp_list" type="text/html">
	<table class="manager-table">
        <tbody> 
			<tr><th>编号</th><th>模板名称</th><th>型号</th><th>所有者</th><th>电话</th><th>邮箱</th><th>状态</th><th>操作</th></tr>
			{{each data as key index}}
			<tr id="line_tr_{{key.m_sysid}}">
				<td>{{index+1}}</td>
				<td>{{key.m_title}}</td>
				<td>{{key.domtype}}</td>
				<td>{{key.dom_org_m}}</td>
				<td>{{key.dom_ph}}</td>
				<td>{{key.dom_em}}</td>
				<td>
					{{if key.dom_id!=""}}
						{{if key.m_state == "0"}}
							<a href="javascript:mould.uploadfile('{{key.dom_id}}','{{key.dom_org_m}}')" title="点击上传认证">待上传</a>
						{{else if key.m_state == "1"}}
							<font color=green>已认证</font>
						{{else if key.m_state == "2"}}
							<a href="javascript:mould.uploadfile('{{key.dom_id}}','{{key.dom_org_m}}')" title="点击上传认证"><font color=red>认证失败</font></a>
							<br><font color=red>{{key.unpassmsg}}</font>
						{{else}}
							<font color=red>审核中</font>
						{{/if}}
					{{else}}
						-
					{{/if}}
				</td>
				<td><a href="javascript:mould.delete({{key.m_sysid}})" > 删除 </a> <a href="javascript:mould.edit({{key.m_sysid}})"> 修改 </a>
				{{if key.dom_id!=""}}
					{{if key.m_state=="1"}}
						<a href="javascript:mould.guohu('{{key.m_sysid}}','{{key.dom_id}}','{{key.domtype}}')" > 过户 </a>
					{{/if}}
				{{/if}}
				
				</td>
			</tr>
			{{/each}}
		</tbody>
	</table>
	
	<div class="mf-page ">

 	 
   {{if result=="200"}} 
   {{showpagelist pageinfo.pagesizes pageinfo.pageno pageinfo.linecount "javascript:mould.dotopage(__id__)" 6}}
   {{/if}} 
</div>
	
	
</script>
<script id="temp_create" type="text/html">
 <form method=post action="mouldajax.asp" id="addmoudelform"  onsubmit="return false">


	<table class="manager-table">
          <tbody> 
		  <tr>
            <th colspan="2">模版名称相关</th>
          </tr>
		  <tr>
            <th align="right">模版名称:</th>
            <td align="left"> 
                <label><input name="m_title" type="text" class="manager-input s-input" value="{{m_title}}" size="28" maxlength="60" datatype="*1-60" errormsg="请输入模版名称！" nullmsg="模版名称为空！"> </label>
              
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
		
		  <tr>
            <th align="right">适用类型:</th>
            <td align="left">
			  <%if trim(register)<>"" then%>
		   	  <input type="hidden" name="register" value="<%=register%>" > - 
			  <input type="hidden" name="domtypelist" value="automouldtype" >
			  <%else%>
			  <input type="text" name="domtypelist" value="{{domtype}}" class="manager-input s-input" style="width:350px" readonly {{if m_sysid==0 }}onclick="mould.showdomaintype()"{{/if}}>
              {{if m_sysid=="" }}<a href="javascript:void(0)" onclick="mould.showdomaintype()">选择</a>{{/if}}
              <label><label class="Validform_checktip"></label></label>
			  <%end if%>
			  </td>
          </tr>
		
          <tr>
            <th colspan="2">域名中文资料</th>
          </tr>
          <tr>
            <th align="right">域名所有者:</th>
            <td align="left"> 
                <label><input name="dom_org_m" type="text" class="manager-input s-input" value="{{dom_org_m}}" size="28" maxlength="60" datatype="dom_org_m_cn" errormsg="请输入您的中文全名！" nullmsg="域名所有者全名为空！" {{if m_sysid > 0 }}readonly{{/if}}></label>
              
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">姓:</th>
            <td align="left"><label>
                <input name="dom_ln_m" type="text" class="manager-input s-input" value="{{dom_ln_m}}" size="28" maxlength="8" datatype="cn1-18" errormsg="请输入您的姓氏！" nullmsg="域名所有者姓氏为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">名:</th>
            <td align="left"><label>
                <input name="dom_fn_m" type="text" class="manager-input s-input" value="{{dom_fn_m}}" size="28" maxlength="8" datatype="cn1-18" errormsg="请输入您的名称！" nullmsg="域名所有者名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">省份:</th>
            <td align="left"><label>
               <select name="dom_st_m" class="common-select reg-area-select" style="width: 150px;">
							</select> 
							<select name="dom_ct_m" class="common-select reg-area-select"  style="width: 150px;">
							</select> 
							<select name="dom_dic_m" class="common-select reg-area-select"  style="width: 150px;">
							</select> 
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          
          <tr>
            <th align="right">地址:</th>
            <td align="left"><label>
                <input name="dom_adr_m" type="text" class="manager-input s-input" value="{{dom_adr_m}}" size="28" maxlength="95" datatype="cnaddress" errormsg="请输入你的详细联系地址（4-30个字）" nullmsg="中文联系地址为能为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th colspan="2">域名英文资料</th>
          </tr>
          <tr>
            <th align="right">域名所有者:</th>
            <td align="left"><label>
                <input name="dom_org" type="text" class="manager-input s-input" value="{{dom_org}}" size="28" maxlength="150" datatype="enname" errormsg="请输入您的英文姓名,每个词语用空格分开！" nullmsg="英文姓名为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">姓:</th>
            <td align="left"><label>
                <input name="dom_ln" type="text" class="manager-input s-input" value="{{dom_ln}}" size="28" maxlength="8" datatype="enname2" errormsg="请输入您的英文姓氏,每个词语用空格分开！" nullmsg="英文姓氏为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">名:</th>
            <td align="left"><label>
                <input name="dom_fn" type="text" class="manager-input s-input" value="{{dom_fn}}" size="28" maxlength="15" datatype="enname2" errormsg="请输入您的英文名,每个词语用空格分开！" nullmsg="英文名为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">国家代码:</th>
            <td align="left"><label>
                <select name="dom_co" style="width:170px;" datatype="*1-20" errormsg="请选择省份" nullmsg="省份未选择，请选择！">
                  <option value="cn"  selected>China</option>
								<option value="hk">China Hong Kong</option>								
                                <option value="tw">China Taiwan</option>								
                                <option value="mo">China Macau</option>
                                <option value="ac">Ascension Island</option>
                                <option value="ad">Andorra</option>
                                <option value="ae">United Arab Emirates</option>
                                <option value="af">Afghanistan</option>
                                <option value="ag">Antigua and Barbuda</option>
                                <option value="ai">Anguilla</option>
                                <option value="al">Albania</option>
                                <option value="am">Armenia</option>
                                <option value="an">Netherlands Antilles</option>
                                <option value="ao">Angola</option>
                                <option value="aq">Antartica</option>
                                <option value="ar">Argentina</option>
                                <option value="as">American Samoa</option>
                                <option value="at">Austria</option>
                                <option value="au">Australia</option>
                                <option value="aw">Aruba</option>
                                <option value="az">Azerbaijan</option>
                                <option value="ba">Bosnia and Herzegovina</option>
                                <option value="bb">Barbados</option>
                                <option value="bd">Bangladesh</option>
                                <option value="be">Belgium</option>
                                <option value="bf">Burkina Faso</option>
                                <option value="bg">Bulgaria</option>
                                <option value="bh">Bahrain</option>
                                <option value="bi">Burundi</option>
                                <option value="bj">Benin</option>
                                <option value="bm">Bermuda</option>
                                <option value="bn">Brunei Darussalam</option>
                                <option value="bo">Bolivia</option>
                                <option value="br">Brazil</option>
                                <option value="bs">Bahamas</option>
                                <option value="bt">Bhutan</option>
                                <option value="bv">Bouvet Island</option>
                                <option value="bw">Botswana</option>
                                <option value="by">Belarus</option>
                                <option value="bz">Belize</option>
                                <option value="ca">Canada</option>
                                <option value="cc">Cocos (Keeling) Islands</option>
                                <option value="cd">Congo, Democratic Republic of the</option>
                                <option value="cf">Central African Republic</option>
                                <option value="cg">Congo, Republic of</option>
                                <option value="ch">Switzerland</option>
                                <option value="ci">Cote d'Ivoire</option>
                                <option value="ck">Cook Islands</option>
                                <option value="cl">Chile</option>
                                <option value="cm">Cameroon</option>
                                <option value="co">Colombia</option>
                                <option value="cr">Costa Rica</option>
                                <option value="cu">Cuba</option>
                                <option value="cv">Cap Verde</option>
                                <option value="cx">Christmas Island</option>
                                <option value="cy">Cyprus</option>
                                <option value="cz">Czech Republic</option>
                                <option value="de">Germany</option>
                                <option value="dj">Djibouti</option>
                                <option value="dk">Denmark</option>
                                <option value="dm">Dominica</option>
                                <option value="do">Dominican Republic</option>
                                <option value="dz">Algeria</option>
                                <option value="ec">Ecuador</option>
                                <option value="ee">Estonia</option>
                                <option value="eg">Egypt</option>
                                <option value="eh">Western Sahara</option>
                                <option value="er">Eritrea</option>
                                <option value="es">Spain</option>
                                <option value="et">Ethiopia</option>
                                <option value="fi">Finland</option>
                                <option value="fj">Fiji</option>
                                <option value="fk">Falkland Islands (Malvina)</option>
                                <option value="fm">Micronesia, Federal State of</option>
                                <option value="fo">Faroe Islands</option>
                                <option value="fr">France</option>
                                <option value="ga">Gabon</option>
                                <option value="gd">Grenada</option>
                                <option value="ge">Georgia</option>
                                <option value="gf">French Guiana</option>
                                <option value="gg">Guernsey</option>
                                <option value="gh">Ghana</option>
                                <option value="gi">Gibraltar</option>
                                <option value="gl">Greenland</option>
                                <option value="gm">Gambia</option>
                                <option value="gn">Guinea</option>
                                <option value="gp">Guadeloupe</option>
                                <option value="gq">Equatorial Guinea</option>
                                <option value="gr">Greece</option>
                                <option value="gs">South Georgia and the South Sandwich Islands</option>
                                <option value="gt">Guatemala</option>
                                <option value="gu">Guam</option>
                                <option value="gw">Guinea-Bissau</option>
                                <option value="gy">Guyana</option>                                
                                <option value="hm">Heard and McDonald Islands</option>
                                <option value="hn">Honduras</option>
                                <option value="hr">Croatia/Hrvatska</option>
                                <option value="ht">Haiti</option>
                                <option value="hu">Hungary</option>
                                <option value="id">Indonesia</option>
                                <option value="ie">Ireland</option>
                                <option value="il">Israel</option>
                                <option value="im">Isle of Man</option>
                                <option value="in">India</option>
                                <option value="io">British Indian Ocean Territory</option>
                                <option value="iq">Iraq</option>
                                <option value="ir">Iran (Islamic Republic of)</option>
                                <option value="is">Iceland</option>
                                <option value="it">Italy</option>
                                <option value="je">Jersey</option>
                                <option value="jm">Jamaica</option>
                                <option value="jo">Jordan</option>
                                <option value="jp">Japan</option>
                                <option value="ke">Kenya</option>
                                <option value="kg">Kyrgyzstan</option>
                                <option value="kh">Cambodia</option>
                                <option value="ki">Kiribati</option>
                                <option value="km">Comoros</option>
                                <option value="kn">Saint Kitts and Nevis</option>
                                <option value="kp">Korea, Democratic People's Republic</option>
                                <option value="kr">Korea, Republic of</option>
                                <option value="kw">Kuwait</option>
                                <option value="ky">Cayman Islands</option>
                                <option value="kz">Kazakhstan</option>
                                <option value="la">Lao People's Democratic Republic</option>
                                <option value="lb">Lebanon</option>
                                <option value="lc">Saint Lucia</option>
                                <option value="li">Liechtenstein</option>
                                <option value="lk">Sri Lanka</option>
                                <option value="lr">Liberia</option>
                                <option value="ls">Lesotho</option>
                                <option value="lt">Lithuania</option>
                                <option value="lu">Luxembourg</option>
                                <option value="lv">Latvia</option>
                                <option value="ly">Libyan Arab Jamahiriya</option>
                                <option value="ma">Morocco</option>
                                <option value="mc">Monaco</option>
                                <option value="md">Moldova, Republic of</option>
                                <option value="mg">Madagascar</option>
                                <option value="mh">Marshall Islands</option>
                                <option value="mk">Macedonia, Former Yugoslav Republic</option>
                                <option value="ml">Mali</option>
                                <option value="mm">Myanmar</option>
                                <option value="mn">Mongolia</option>
                                <option value="mp">Northern Mariana Islands</option>
                                <option value="mq">Martinique</option>
                                <option value="mr">Mauritania</option>
                                <option value="ms">Montserrat</option>
                                <option value="mt">Malta</option>
                                <option value="mu">Mauritius</option>
                                <option value="mv">Maldives</option>
                                <option value="mw">Malawi</option>
                                <option value="mx">Mexico</option>
                                <option value="my">Malaysia</option>
                                <option value="mz">Mozambique</option>
                                <option value="na">Namibia</option>
                                <option value="nc">New Caledonia</option>
                                <option value="ne">Niger</option>
                                <option value="nf">Norfolk Island</option>
                                <option value="ng">Nigeria</option>
                                <option value="ni">Nicaragua</option>
                                <option value="nl">Netherlands</option>
                                <option value="no">Norway</option>
                                <option value="np">Nepal</option>
                                <option value="nr">Nauru</option>
                                <option value="nu">Niue</option>
                                <option value="nz">New Zealand</option>
                                <option value="om">Oman</option>
                                <option value="pa">Panama</option>
                                <option value="pe">Peru</option>
                                <option value="pf">French Polynesia</option>
                                <option value="pg">Papua New Guinea</option>
                                <option value="ph">Philippines</option>
                                <option value="pk">Pakistan</option>
                                <option value="pl">Poland</option>
                                <option value="pm">St. Pierre and Miquelon</option>
                                <option value="pn">Pitcairn Island</option>
                                <option value="pr">Puerto Rico</option>
                                <option value="ps">Palestinian Territories</option>
                                <option value="pt">Portugal</option>
                                <option value="pw">Palau</option>
                                <option value="py">Paraguay</option>
                                <option value="qa">Qatar</option>
                                <option value="re">Reunion Island</option>
                                <option value="ro">Romania</option>
                                <option value="ru">Russian Federation</option>
                                <option value="rw">Rwanda</option>
                                <option value="sa">Saudi Arabia</option>
                                <option value="sb">Solomon Islands</option>
                                <option value="sc">Seychelles</option>
                                <option value="sd">Sudan</option>
                                <option value="se">Sweden</option>
                                <option value="sg">Singapore</option>
                                <option value="sh">St. Helena</option>
                                <option value="si">Slovenia</option>
                                <option value="sj">Svalbard and Jan Mayen Islands</option>
                                <option value="sk">Slovak Republic</option>
                                <option value="sl">Sierra Leone</option>
                                <option value="sm">San Marino</option>
                                <option value="sn">Senegal</option>
                                <option value="so">Somalia</option>
                                <option value="sr">Suriname</option>
                                <option value="st">Sao Tome and Principe</option>
                                <option value="sv">El Salvador</option>
                                <option value="sy">Syrian Arab Republic</option>
                                <option value="sz">Swaziland</option>
                                <option value="tc">Turks and Caicos Islands</option>
                                <option value="td">Chad</option>
                                <option value="tf">French Southern Territories</option>
                                <option value="tg">Togo</option>
                                <option value="th">Thailand</option>
                                <option value="tj">Tajikistan</option>
                                <option value="tk">Tokelau</option>
                                <option value="tm">Turkmenistan</option>
                                <option value="tn">Tunisia</option>
                                <option value="to">Tonga</option>
                                <option value="tp">East Timor</option>
                                <option value="tr">Turkey</option>
                                <option value="tt">Trinidad and Tobago</option>
                                <option value="tv">Tuvalu</option>
                                <option value="tz">Tanzania</option>
                                <option value="ua">Ukraine</option>
                                <option value="ug">Uganda</option>
                                <option value="uk">United Kingdom</option>
                                <option value="um">US Minor Outlying Islands</option>
                                <option value="us">United States</option>
                                <option value="uy">Uruguay</option>
                                <option value="uz">Uzbekistan</option>
                                <option value="va">Holy See (City Vatican State)</option>
                                <option value="vc">Saint Vincent and the Grenadines</option>
                                <option value="ve">Venezuela</option>
                                <option value="vg">Virgin Islands (British)</option>
                                <option value="vi">Virgin Islands (USA)</option>
                                <option value="vn">Vietnam</option>
                                <option value="vu">Vanuatu</option>
                                <option value="wf">Wallis and Futuna Islands</option>
                                <option value="ws">Western Samoa</option>
                                <option value="ye">Yemen</option>
                                <option value="yt">Mayotte</option>
                                <option value="yu">Yugoslavia</option>
                                <option value="za">South Africa</option>
                                <option value="zm">Zambia</option>
                                <option value="zw">Zimbabwe</option>
                </select>
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">省份:</th>
            <td align="left"><label>
                <input name="dom_st" type="text" class="oldbg common-input" size="26" maxlength="30" value="{{dom_st}}" datatype="enaddress" errormsg="请输入您的英文城市名称,每个词语用空格分开！" nullmsg="英文城市名称为空！">
                
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">城市:</th>
            <td align="left"><label>
                <input name="dom_ct" type="text" class="manager-input s-input" size="28" maxlength="30" value="{{dom_ct}}" datatype="enaddress" errormsg="请输入您的英文城市名称,每个词语用空格分开！" nullmsg="英文城市名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">地址:</th>
            <td align="left"><label>
                <input name="dom_adr1" type="text" class="manager-input s-input" size="28" maxlength="95" value="{{dom_adr1}}" datatype="enaddress" errormsg="请输入您的英文地址名称,每个词语用空格分开！" nullmsg="英文地址名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">邮编:</th>
            <td align="left"><label>
                <input name="dom_pc" type="text" class="manager-input s-input" value="{{dom_pc}}" size="28" maxlength="6" datatype="zip" errormsg="请输入您的邮政编码！" nullmsg="邮政编码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">电话:</th>
            <td align="left"><label>
                <input name="dom_ph" type="text" class="manager-input s-input" value="{{dom_ph}}" size="23" maxlength="12" style="width:165px;" datatype="tel" errormsg="请输入您的正确电话号码！" nullmsg="电话号码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">传真:</th>
            <td align="left"><label>
                <input name="dom_fax" type="text" class="manager-input s-input" value="{{dom_fax}}" size="23" maxlength="12" style="width:165px;" datatype="fax" errormsg="请输入您的正确传真！" nullmsg="传真号码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">电子邮件:</th>
            <td align="left"><label>
                <input name="dom_em" type="text" class="manager-input s-input" value="{{dom_em}}" size="28" maxlength="50" datatype="e" errormsg="请输入您的电子邮件！" nullmsg="电子邮件为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
      
		  <tr class="domgsclass" style="display:none">
			<th align="right">证件类型(公司,网络)</th>
            <td align="left"><label>
				<select name="dom_idtype" class="common-select reg-area-select" style="width: 150px;">
					<option value="SFZ">身份证</option>
					<option value="ORG">组织机构代码证</option>
				</select>
			</label>
            <label><label class="Validform_checktip"></label></label></td>
		  </tr>

		  <tr class="domgsclass" style="display:none">
			<th align="right">证件号码(公司,网络)</th>
            <td align="left"><label>
				 <input name="dom_idnum" type="text" class="manager-input s-input" value="{{dom_idnum}}" size="28" maxlength="50">
			</label>
            <label><label class="Validform_checktip"></label></label></td>
		  </tr>


		  <tr class="domhkclass" style="display:none">
			<th align="right">注册人类别(HK)</th>
            <td align="left"><label>
				<select name="reg_contact_type" class="common-select reg-area-select" style="width: 150px;">
					<option value="0">个人</option>
					<option value="1">企业</option>
				</select>
			</label>
            <label><label class="Validform_checktip"></label></label></td>
		  </tr>

		  <tr class="domhkclass"  style="display:none">
			<th align="right">证件类型(HK)</th>
            <td align="left"><label>
				 <select name="custom_reg2" class="common-select reg-area-select" style="width: 150px;">
					<option value="OTHID">大陆身份证(个人)</option>
					<option value="HKID">香港身份证(个人)</option>
					<option value="PASSNO">护照号码(个人)</option>
					<option value="BIRTHCERT">出生证明(个人)</option>
					<option value="CI">营业执照(企业)</option>
					<option value="BR">香港公司登记证(企业)</option>
				</select>
			</label>
            <label><label class="Validform_checktip"></label></label></td>
		  </tr>

  		 <tr class="domhkclass"  style="display:none">
			<th align="right">证件号码(HK)</th>
            <td align="left"><label>
				 <input name="custom_reg2" type="text" class="manager-input s-input" value="{{custom_reg2}}" size="28" maxlength="50">
			</label>
            <label><label class="Validform_checktip"></label></label></td>
		  </tr>


          <tr>
            <td colspan="2"><input type="button"  class="z_btn-buy manager-btn s-btn addmodulebtn" value="保存信息">
              <input type="hidden" name="act" value="addmould">
			  <input type="hidden" name="m_sysid" value="{{m_sysid}}">
			</td>
          </tr>
        </tbody></table>
		</form>
</script>



<script id="temp_uploadfile" type="text/html">
<div style="width:600px;">
	<form method=post  id="uploadfileform"  onsubmit="return false">
	<table class="manager-table" width="100%">
        <tbody>
			<tr>
				<th colspan=2>上传实名认证资料</th>
			</tr>
		 
			<tr>
				<td width="130">所有者:</td>
				<td align=left>{{name}}</td>
			</tr>
		 
			<tr>
				<td>注册人类型</td>
				<td align=left>
					<label>
						<select name="registranttype" class="inp300">
							<option value="I">个人</option>
							<option value="E">组织</option>
						<select>
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			<tr>
				<td>证件类型</td>
				<td align=left>
						<label>
							<select name="idtype" class="inp300">
							<option value="SFZ">身份证</option>
							<option value="JGZ">军官证</option>
							<option value="QT">其它</option>
							<select>
						</label>
						<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			<tr>
				<td>证件号码</td>
				<td align=left>
					<label>
						<input type="test" name="idcode" class="manager-input s-input inp300" datatype="*4-30" errormsg="证件号码有误！" nullmsg="证件号码为空！">
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			
			<tr>
				<td>证件网络地址</td>
				<td align=left>
					<div id="idimgurl_s" class="filelist"><img src="/noedit/webuploader/image.png"></div>
					<div class="filebtn" id="idimgurl_id" data-s="idimgurl_s"  data-name="idimgurl">选择证件图片</div>
					<label>
						<input type="hidden" name="idimgurl"  class="manager-input s-input" datatype="*4-200" errormsg="证件图片没有上传！" nullmsg="证件图片没有上传！">
						
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			
		
			
			<tr class="qiyiclass" style="display:none">
				<td>组织证件类型</td>
				<td  align=left>
					<label>
						<select name="orgprooftype" class="inp300">
							<option value="YYZZ">营业执照</option>
							<option value="ORG">组织机构代码证</option>
							<option value="QT">其它</option>
						<select>
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			<tr class="qiyiclass"  style="display:none">
				<td>组织证件号码</td>
				<td align=left>
					<label>
						<input type="test" name="orgcode"  class="manager-input s-input inp300" datatype="orgcode"  errormsg="组织证件号码为空！" >
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			
			<tr class="qiyiclass"  style="display:none">
				<td>组织证件网络地址</td>
				<td  align=left>
					<label>
					
						<div id="orgmsgurl_s" class="filelist"><img src="/noedit/webuploader/image.png"></div>
						<div class="filebtn" id="orgmsgurl_id" data-s="orgmsgurl_s"    data-name="orgmsgurl">选择组织证件图片</div>
					</label>
					
					<label>
							<input type="hidden" name="orgmsgurl"  class="manager-input s-input inp300" datatype="orgcodeimg" errormsg="组织证件图片没有上传！" nullmsg="组织证件图片没有上传！"> 
					</label>
					<label><label class="Validform_checktip"></label></label>
				</td>
			</tr>
			<tr>
			<th colspan=2>
			<input type="hidden" name="dom_id" value="{{dom_id}}">
			<input type="hidden" name="act" value="audit">
			<button   class="uploadfileformbtn manager-btn s-btn ">确定上传</button> <button onclick="mould.loading.close()"  class="z_btn-buy manager-btn s-btn">关闭</button></th>
			</tr>
		</tbody>		
	</table>
	</form>
</div>
</script>
<script>
	var mould={
		cfg:{
			url:"mouldajax.asp",
			proids:[],
			myproid:"<%=strproid%>"
		},		
		modif:function(id){
		
		},
		create:function(obj){
			var selfp=this;		
			$("#contenthtml").html(template("temp_create",obj));
			selfp.bindprovince();
			$("input[name='dom_org_m']").on("keyup keydown change blur",function (){
					$("input[name='dom_org']").val($(this).toPinyin());
				});
			$("input[name='dom_ln_m']").on("keyup keydown change blur",function (){
					$("input[name='dom_ln']").val($(this).toPinyin());
				});
				
			$("input[name='dom_fn_m']").on("keyup keydown change blur",function (){
					$("input[name='dom_fn']").val($(this).toPinyin());
				});	
				
			$("input[name='dom_ct_m']").on("keyup keydown change blur",function (){
				$("input[name='dom_ct']").val($(this).toPinyin());
			});
			$("input[name='dom_adr_m']").on("keyup keydown change blur",function (){
				$("input[name='dom_adr1']").val($(this).toPinyin());
			});	
			$("#addmoudelform").Validform({
				tiptype:2,
				showAllError:true,
				ajaxPost:true,
				btnSubmit:".addmodulebtn",
				datatype:{
				"enname":function(gets,obj,curform,regxp)
				{
				/*参数gets是获取到的表单元素值，
				  obj为当前表单元素，
				  curform为当前验证的表单，
				  regxp为内置的一些正则表达式的引用。*/
				  var reg=""
                  ennameval=obj[0].value; 
					var reg=/^[0-9a-zA-Z\_\-\.\s]{5,60}$/;
				 
					if(reg.test(ennameval))
					{
						return true;}
					else{
					return false;	
						}

				},
			  "enaddress":function(gets,obj,curform,regxp){
				
				var reg=/^[0-9a-zA-Z\_\-\.\s#,]{4,75}$/;
					enaddress=obj[0].value;
					if(reg.test(enaddress))
					{
					 
					return true;}
					else{
					return false;	
						}
				},
			 "dom_org_m_cn":function(gets,obj,curform,regxp)
				{
					var reg=/^[\u4E00-\u9FA5\uf900-\ufa2d\(\)#A-Z0-9a-z]{2,50}$/;
					do_org_m_cn=obj[0].value;
					if(reg.test(do_org_m_cn))
					{
					
					//chkxmName(do_org_m_cn)
					return true;}
					else{
					return false;	
						}
				},
			"tel":function(gets,obj,curform,regxp)		 
				{
				    tel_=curform.find("input[name='dom_ph']");
					v=tel_.val();
                    if(!/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/.test(v)){
					tel_.attr("errormsg","格式错误,eg:028-87654321或手机号码");
							return false
					}
					if(isEasystr(myinstr(v,/\-(\d+)/ig)) ){
							tel_.attr("errormsg","号码不能为连续或重复的数字");
							return false
						}else{
							return true;
							}
				 },
			"fax":function(gets,obj,curform,regxp)		 
				{
				    tel_=curform.find("input[name='dom_fax']");
					v=tel_.val();
                    if(!/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/.test(v)){
					tel_.attr("errormsg","格式错误,eg:028-87654321或手机号码");
							return false
					}
					if(isEasystr(myinstr(v,/\-(\d+)/ig)) ){
							tel_.attr("errormsg","号码不能为连续或重复的数字");
							return false
						}else{
							return true;
							}
				 }  

			 },
			beforeSubmit:function(curform){
					selfp.loadbox();
					var domtypelist=$("input[name='domtypelist']").val().split(",")
					selfp.total=domtypelist.length;
					selfp.runnum=0;					
 					selfp.runcreate($("#addmoudelform").serialize(),domtypelist);
					return false
				}
			})
		},
		runcreate:function(postdata,arr){
			var self=this;
			var domtype=arr.shift();
			if(typeof(domtype)=="undefined" || domtype=="")
			{
				self.loading.close();
				$.dialog.alert("操作成功");
				$(".manager-tab li").eq(1).click();
				return false	
			}
			self.runnum++;
			self.loading.content("正在执行第<font color=red>"+self.runnum+"</font>条数据,共<font color=red>"+self.total+"</font>条数据")
 			$.post(self.cfg.url,postdata+"&domtype="+escape(domtype),function(data){
				if(data.result=="200")
				{
					if(data.info[0].result=="200")
					{ 	if(data.info[0].data[0].result=="200")
						{
							self.runcreate(postdata,arr);
						}else{
							$.dialog.alert(data.info[0].data[0].msg);
							self.loading.close(); 	
						}
					}else{
						$.dialog.alert(data.info[0].msg);
						self.loading.close(); 	
 					}
				}else{
						$.dialog.alert(data.msg);
						self.loading.close();						
					}
					
 			},"json")
			
		},
		showdomaintype:function(){
			var self=this;
			self.loadbox();
			self.loading.title("选择域名类型");
			self.loading.content(template("temp_showdomaintype",{"db":self.cfg.proids}))
			//self.loadbox = $.dialog({"title":"选择域名类型","content":template("temp_showdomaintype",{"db":self.cfg.proids})});
			var domtypeobj=$("input[name='domtypelist']").val();			
			if(typeof(domtypeobj)!="undefined")
			{
				domtypeobj=domtypeobj.split(",");
				$.each(domtypeobj,function(i,v){
					$("input[name='proid'][value='"+v+"']").attr("checked",true)
				})
			}
		 
			
		},
		selectdomaintype:function(){
			var self=this;
			var arrlist=[];
			$(".domgsclass").hide();
			$(".domhkclass").hide();
			$.each($("input[name='proid']:checked"),function(i,obj){
				arrlist.push(obj.value);
				if(obj.value=="domgs" || obj.value=="domwl"){
						$(".domgsclass").show();
					}
				if(obj.value=="domhk" || obj.value=="domcomhk"){
						$(".domhkclass").show();
					}
			});
			if(arrlist.length>9){
				$.dialog.alert("每次最多创建10个不同模板,请减少创建后缀数量")
				return false	
			}
			
			
			self.loading.close();
			$("input[name='domtypelist']").val(arrlist.join(","))

			
		},
		loadbox:function(){
			var self=this;
			self.loading=$.dialog({title: false,content: "加载中,请稍候..",esc: false,lock: true,min: false,max: false})
		},
		getproid:function(domain){
			var self=this;
			self.loadbox();
			//self.loading=$.dialog({title: false,content: "加载中,请稍候..",esc: false,lock: true,min: false,max: false})
			var postdata={"act":"getproid","domain":escape(domain)}
			$.post(self.cfg.url,postdata,function(data){
				if(data.result=="200"){
					if(data.info[0].result=="200")
					{
						self.cfg.proids=data.info[0].data
					}else{
						$.dialog.alert(data.info[0].msg);			
					}
				}else{
					$.dialog.alert(data.msg);	
					
					}
				self.loading.close();
			},"json")
		},
		list:function(){
			var self=this;
			$("#contenthtml").html("数据加载中...")	;
			$("#contenthtml").html(template("temp_list_box",[]))
			$("select[name='pagesize']").change(function(){
				$("input[name='pageno']").val(1);				
			})			
			$("#searchbtn").click(function(){
				
					self.getlist();					
				})
			self.getlist();		
			
		},
		getlist:function(){
			var self=this;
			$("#list_box_info").html("数据加载中,请稍后...")
			$.post(self.cfg.url,$("#searchform").serialize(),function(data){
					$("#list_box_info").html(template("temp_list",data.info[0]))
			},"json")
			
			},
		bindprovince:function(){
			var self=this;
			self.setprovince("四川省")
			$("select[name='dom_st_m']").change(function(){
				 self.setcity("")
			})
			$("select[name='dom_ct_m']").change(function(){
				 self.setdistrict()

			})
			$("select[name='dom_dic_m']").change(function(){
				self.setpostshow();
			})

		
		},
		setprovince:function (sn_){
			var self=this;
			$("select[name='dom_st_m']").empty();
			for (var i=0;i<citydb.length ;i++ )
			{
					p_=citydb[i].province
					if (sn_==p_)
					{
						$("select[name='dom_st_m']").append('<option value="'+p_+'" selected>'+p_+'</option>')
					}else
					{
						$("select[name='dom_st_m']").append('<option value="'+p_+'">'+p_+'</option>')
					}
			}
			 self.setcity("成都市");
			
		},
		setcity:function(cn_){
				var self=this;
				var p_=$("select[name='dom_st_m']").val();
				var cobj_=$("select[name='dom_ct_m']");
				cobj_.empty();
				if(p_!="")
				{	

					for (var i=0;i<citydb.length ;i++ )
					{
							if(p_==citydb[i].province)
							{
								for (ii=0;ii<citydb[i].city.length ;ii++ )
								{
									c_=citydb[i].city[ii].name
									if (cn_==c_)
									{
										cobj_.append('<option value="'+c_+'" selected >'+c_+'</option>')
									}else
									{
										cobj_.append('<option value="'+c_+'">'+c_+'</option>')
									}
								}
								 self.setdistrict()
								return false;
							}															
					}
				}
			},
		setdistrict:function(){
			var self=this;
			var p_=$("select[name='dom_st_m']").val();
			var c_=$("select[name='dom_ct_m']").val();
			var dobj_=$("select[name='dom_dic_m']");
			dobj_.empty();
			if(p_!="" && c_!="")
			{
					for (var i=0;i<citydb.length ;i++ )
					{
							if(p_==citydb[i].province)
							{
									for (ii=0;ii<citydb[i].city.length ;ii++ )
									{
										if(c_==citydb[i].city[ii].name)
										{
											for(var iii=0;iii<citydb[i].city[ii].district.length;iii++)
											{
												d_=citydb[i].city[ii].district[iii].name
												p_=citydb[i].city[ii].district[iii].post
												dobj_.append('<option value="'+d_+'" tag="'+p_+'">'+d_+'</option>')
											}
											 self.setpostshow()
											return false;
										}																			
									}
									return false;
							}															
					}
			
			}
		},
		setpostshow:function(){
			var v_=$("select[name='dom_dic_m']").val();
			$("input[name='dom_pc']").val($("select[name='dom_dic_m']").find("option[value='"+v_+"']").attr("tag"));
			$("input[name='dom_adr_m']").val(v_);
			$("input[name='dom_st']").val($("select[name='dom_st_m']").toPinyin());
			$("input[name='dom_ct']").val($("select[name='dom_ct_m']").toPinyin());
		},
		inittab:function(){
				var self=this;
				$(".manager-tab li").click(function(){
						$(".manager-tab li").removeClass("liactive");
						$(this).addClass("liactive");
						var act=$(this).attr("tag");
						if(act=="create"){
							self.create({"m_sysid":0});
						}else if(act=="list"){
							self.list();
						}
					})
			},
		delete:function(m_sysid){
				var self=this;
				$.dialog.confirm("您确定要删除此模板",function(){
						var postdata={"act":"delmould","m_sysid":m_sysid}
						$.post(self.cfg.url,postdata,function(data){
							 
								 if(data.result=="200"){
									 if(data.info[0].result=="200")
									 {
										 for(var i=0;i<data.info[0].data.length;i++){
											 var line=data.info[0].data[i];
											$("#line_tr_"+line.m_sysid).remove(); 
										}
										$.dialog.alert("操作成功!"); 
									 }
								 }else{
										$.dialog.alert("操作成功!"); 
									 }
							 
								 
							},"json")
					})
			
			},
		checkshowqiyi:function(){
					if($("select[name='registranttype']").val()=="E"){
							$(".qiyiclass").show();
						}else{
							$(".qiyiclass").hide();
						}
			},
		uploadfile:function(dom_id,name){
				var self=this;
				self.loadbox();
				self.loading.title("实名认证资料上传")
				self.loading.content(template("temp_uploadfile",{"dom_id":dom_id,"name":name}));
				$(".filebtn").each(function(i,obj){ 
						self.createupload($(obj),$(this).attr("data-name"),$(this).attr("data-s"))
					})
					
				$("select[name='registranttype']").change(function(){
						 self.checkshowqiyi()
					})
				 self.checkshowqiyi()
				$("#uploadfileform").Validform({
				tiptype:2,
				showAllError:true,
				ajaxPost:false,
				btnSubmit:".uploadfileformbtn",
				datatype:{
						"orgcode":function(gets,obj,curform,regxp){ 
								if($("select[name='registranttype']").val()=="E"){
									if(obj[0].value==""){
										return false 
									}
								}
								return true;						
							},
						 "orgcodeimg":function(gets,obj,curform,regxp){ 
								if($("select[name='registranttype']").val()=="E"){
									if(obj[0].value==""){
										return false 
									}
								}
								return true;						
							}				
				},
				beforeSubmit:function(curform){	
					$(".uploadfileformbtn").html("数据提交中,请稍后..");
					$(".uploadfileformbtn").prop("disabled",true)
					self.sureaudit();
					return false	
				}
			
				
				})
			 
			},
		createupload:function(pickid,urlpath,imgurl){ 
					var uploader=WebUploader.create({			
							auto: true,			
							swf: '/noedit/webuploader/Uploader.swf',
							server:"/noedit/webuploader/up.asp?act=uploadfile",
							formData:{urlpath:urlpath,imgurl:imgurl},
							pick:{id:pickid,multiple:false},				
							accept: {
								title: 'Images',
								extensions: 'jpg,jpeg',
								mimeTypes: 'image/jpg,image/jpeg'
							}
						});	
				uploader.on( 'beforeFileQueued', function(file){
					file.name=new Date().getTime()+"."+file.ext; 
					console.log(uploader.options.pick)
//					$(uploader.options.pick.parents('label[data-par="filelabel"]')).find("div.errmsg").remove();
				});		
			uploader.on( 'fileQueued', function( file ) {				
				var li = $('<div id="' + file.id + '" class="file-item thumbnail"><img></div>'),img = li.find('img');	
				$("#"+imgurl).html( li );
				uploader.makeThumb( file, function( error, src ) {
					if ( error ) {
						img.replaceWith('<span>不能预览</span>');
						return;
					}
					img.attr( 'src', src ).attr("data-tmp","");
				},60,58);
			});
					
					uploader.on( 'uploadSuccess', function( file ,obj) {
							if(obj.result==200){	
								$("input[name='"+obj.urlpath+"']").val(obj.url)
							}else{
								$.dialog.alert(obj.msg)	
							}
					});
					
					uploader.on( 'uploadError', function( file ) {
					 
					});
					
					uploader.on( 'uploadComplete', function( file ) {
						
					});
	 

			
			},		
		sureaudit:function(){
			var self=this
			
			$.post(self.cfg.url,$("#uploadfileform").serialize(),function(data){
				if(data.result=="200"){
						if(data.info[0].result=="200")
						{
							self.loading.close();
							$.dialog.alert("操作完成!")	;
							$(".manager-tab li").eq(1).click();
						}else{
								$(".uploadfileformbtn").html("确定上传");
								$(".uploadfileformbtn").prop("disabled",false) 
								$.dialog.alert(data.info[0].msg)	;
							}
				}else{ 
						$(".uploadfileformbtn").html("确定上传");
						$(".uploadfileformbtn").prop("disabled",false) 
						$.dialog.alert(data.msg)	;
				}
			
				
				},"json")
			
			},
		edit:function(m_sysid){
				var self=this;
				var postdate={"m_sysid":m_sysid,"act":"getlist"}
				$.post(self.cfg.url,postdate,function(data){
						if(data.result=="200"){
							var objinfo=data.info[0].data[0]
							self.create(objinfo); 
							self.setprovince(objinfo.dom_st_m+"".replace("省",""))
							//$("select[name='dom_st_m']").val(objinfo.dom_st_m.replace("省",""));
							$("select[name='dom_ct_m']").val(objinfo.dom_ct_m);
							$("input[name='dom_adr_m']").val(objinfo.dom_adr_m);


							$("select[name='reg_contact_type']").val(objinfo.reg_contact_type);
							$("select[name='custom_reg2']").val(objinfo.custom_reg2);
							$("select[name='dom_idtype']").val(objinfo.dom_idtype);
							$("select[name='dom_idnum']").val(objinfo.dom_idnum); 
							
												
						}else{
							$.dialog.alert(data.msg)						
						}
					},"json")
			},
		selectmyproid:function(obj){
				var self=this
				var myproid=self.cfg.myproid
				if(myproid!="")
				{
					$.each(myproid.split(","),function(i,o){
						$("input[name='proid'][value='"+o+"']").prop("checked",$("input[name='myproidbt']").prop("checked"))
					})		
				}
		},
		dotopage:function(page){
			var self=this
			$("input[name='pageno']:hidden").val(page);
			self.getlist();
		},
		init:function(){
			
			var self=this;
			template.helper("showpagelist", showpagelist);
			self.inittab();
			self.getproid("");
			var act=$(".manager-tab li.liactive").attr("tag");
			if(act=="create"){
				self.create({"m_sysid":0});
			}else if(act=="list"){
				self.list();
			}
		}
	}
	$(function(){
		mould.init();
		//mould.create();
		 
	})
	function strReverse(s1){
	var s2 = "";
	s2 = s1.split('').reverse().join('');
	return s2;
}
	function isEasystr(strnum){
		var result=false;
		var strAll="0123456789abcdefghijklmnopqrstuvwxyz";
		strnum=strnum.toString();
		if(strnum.length>1){		
			var revstr=strReverse(strnum);
			var revstrAll=strReverse(strAll);		
			if(strAll.toUpperCase().indexOf(strnum)>=0 || revstrAll.toUpperCase().indexOf(strnum)>=0){
				result=true;
			}else if(strnum.substr(0,strnum.length/2+1)==revstr.substr(0,revstr.length/2+1) || revstr==strnum){
				result=true;
			}
		}
		return result;
	}
	function selectall(obj,name)
	{
	 
		$("input[name='"+name+"']").attr("checked",$(obj).is(":checked"))
	}
	function showpagelist(pageSize, pageIndex, totalCount, linkUrl, centSize){
	  if (totalCount < 1 || pageSize < 1)
				{
					return "";
				}
				var  pageCount = parseInt(totalCount/pageSize);
				 if (pageCount < 1)
				{
					return "";
				}
				if (totalCount % pageSize > 0)
				{
					pageCount += 1;
				}
				if (pageCount <= 1)
				{
					return "";
				}
				var pageStr =""
				var pageId = "__id__";
				var firstBtn = "<a href=\"" +linkUrl.replace( pageId, (parseInt(pageIndex) - 1)) + "\" class=\"z_next_page\"><span aria-hidden=\"true\">上一页</span></a>";
				var lastBtn = "<a href=\"" + linkUrl.replace( pageId, (parseInt(pageIndex)+ 1)) + "\"  class=\"z_next_page\"><span aria-hidden=\"true\">下一页</span></a>";
				var firstStr = "<a href=\"" + linkUrl.replace( pageId, 1) + "\"  class=\"z_next_page\" >1</a>";
				var lastStr = "<a href=\"" + linkUrl.replace( pageId, pageCount) + "\"  class=\"z_next_page\" >" + pageCount + "</a>";
	
				if (pageIndex <= 1)
				{
					firstBtn = "<a   class=\"z_next_page\">上一页</a>";
				}
				if (pageIndex >= pageCount)
				{
					lastBtn = "<a   class=\"z_next_page\">下一页</a>";
				}
				if (pageIndex == 1)
				{
					firstStr = "<a class=\"z_this_page\">1</a>";
				}
				if (pageIndex == pageCount)
				{
					lastStr = "<a  class=\"z_this_page\">" + pageCount + "</span>";
				}
				var  firstNum = parseInt(pageIndex-(centSize/2)) 
				if (pageIndex < centSize)
					firstNum = 2;
				var lastNum = parseInt(pageIndex) + centSize - ((centSize/2) + 1)
				if (lastNum >= pageCount)
					lastNum = pageCount - 1;
				pageStr+="<a  class=\"z_next_page\">总条数 " + totalCount + "</a>";
				pageStr+=firstBtn + firstStr;
				if (pageIndex >= centSize)
				{
					pageStr+="<a  class=\"z_next_page\">...</a>";
				}
				for (var  i = firstNum; i <= lastNum; i++)
				{
					if (i == pageIndex)
					{
						pageStr+="<a class=\"z_this_page\">" + i + "</a>";
					}
					else
					{
						pageStr+="<a href=\"" + linkUrl.replace( pageId, i) + "\"  class=\"z_next_page\">" + i + "</a>";
					}
				}
				if (pageCount - pageIndex > centSize - ((centSize / 2)))
				{
					pageStr+="<a  class=\"z_next_page\">...</a>";
				}
				pageStr+=lastStr + lastBtn;
				return pageStr
}

	function myinstr(str,reg){
		if(reg.test(str)){
			return RegExp.$1;
		}else{
			return "";
		}
	}
</script>
