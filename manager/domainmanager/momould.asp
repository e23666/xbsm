<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
 newcheckstr="^((域名)|(合作)|(出租)|(转让)|(管理员)|(我爱你)|(出售)|(赚钱)|(张三)|(游水)|(N\/A)|(NA)|(Domain Whois Protect)|(webmaster)|\d)$"		  '注册资料参数禁用关键字(正则表达式)


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
      <div class="tab">域名注册模板管理&nbsp;&nbsp;【<a href="?act=add">添加模板</a>】</div>
      <%
	  
	  act=requesta("act")
	  select case trim(act)
	  case "add","edit":
	  addedit()
	  case "del"
	  id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0

conn.execute("delete from domainTemp  where id="&id&" and u_name='"&session("user_name")&"'")
call Alert_Redirect("操作成功!","?act=list")
	  case "save"
	  savedb()
	  case else
	  list
	  
	  end select
	  
	  sub list
	  %>
      <table class="manager-table">
        <tr align="center"  class="titletr">
          <th>编号</th>
          <th>域名所有者</th>
          <th>管理时间</th>
          <th>操作</th>
        </tr>
        <%
  i=1
  set mrs=conn.execute("select top 20 * from domainTemp where u_name='"&session("user_name")&"'")
  do while not mrs.eof
  %>
        <tr align="center">
          <td height="25"><%=i%></td>
          <td><%=mrs("dom_org_m")%></td>
          <td><%=mrs("addtime")%></td>
          <td><a href="?act=edit&id=<%=mrs("id")%>">修改</a> <a href="?act=del&id=<%=mrs("id")%>" onclick="return confirm('您确定要删除!')">删除</a></td>
        </tr>
        <%mrs.movenext
  loop%>
      </table>
      <%end sub
sub addedit
id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0
sql="select top 1 * from domainTemp where id="&id&" and u_name='"&session("user_name")&"'"
 
 set mrs=conn.execute(sql)
	if not mrs.eof then
		u_name=mrs("u_name")
		dns_host1=mrs("dns_host1")
		dns_ip1=mrs("dns_ip1")
		dns_host2=mrs("dns_host2")
		dns_ip2=mrs("dns_ip2")
		dom_org_m=mrs("dom_org_m")
		dom_ln_m=mrs("dom_ln_m")
		dom_fn_m=mrs("dom_fn_m")
		dom_st_m=mrs("dom_st_m")
		cndom_st_m=mrs("cndom_st_m")
		dom_ct_m=mrs("dom_ct_m")
		dom_adr_m=mrs("dom_adr_m")
		dom_org=mrs("dom_org")
		dom_ln=mrs("dom_ln")
		dom_fn=mrs("dom_fn")
		dom_co=mrs("dom_co")
		dom_st=mrs("dom_st")
		dom_ct=mrs("dom_ct")
		dom_adr1=mrs("dom_adr1")
		dom_pc=mrs("dom_pc")
		dom_ph=mrs("dom_ph")
		dom_fax=mrs("dom_fax")
		dom_em=mrs("dom_em")
	else
		dns_host1="ns1.myhostadmin.net"
		dns_ip1="220.166.64.222"
		dns_host2="ns2.myhostadmin.net"
		dns_ip2="61.236.150.177"
	end if
%>
      <form name="domainreg" id="domainreg" action="?act=save" method="post" >
        <table class="manager-table">
          <tr>
            <th align="right" width="30%">域名服务器(DNS):</th>
            <td align="left"> 
			  <label>
              <input name="dns_host1"  type="text"  class="manager-input s-input"  value="<%=dns_host1%>" size="28" maxlength="30"  datatype="dm" errormsg="请输入正确DNS服务器域名"  />
             </label>
			 <label><label class="Validform_checktip"></label></label>
			 </td> 
          </tr>
          <tr>
            <th align="right">域名服务器(IP):</th>
            <td align="left"><label>
                <input name="dns_ip1"  type="text"  class="manager-input s-input"  value="<%=dns_ip1%>" size="28" maxlength="30"  datatype="ip4" errormsg="请输入正确ip地址" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">域名服务器(DNS):</th>
            <td align="left"><label>
                <input name="dns_host2"  type="text"  class="manager-input s-input"  value="<%=dns_host2%>" size="28" maxlength="30"  datatype="dm" errormsg="请输入正确DNS服务器域名"  />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">域名服务器(IP): 
            </th> 
            <td align="left"><label>
                <input name="dns_ip2"  type="text"  class="manager-input s-input"  value="<%=dns_ip2%>" size="28" maxlength="30"  datatype="ip4" errormsg="请输入正确ip地址" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th colspan=2>域名中文资料</th>
          </tr>
          <tr>
            <th align="right">域名所有者:</th>
            <td align="left"> 
                <input name="dom_org_m" type="text"   class="manager-input s-input" value="<%=dom_org_m%>" size="28" maxlength="60" datatype="dom_org_m_cn" errormsg="请输入您的中文全名！"  nullmsg="域名所有者全名为空！"  >
              
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">姓:</th>
            <td align="left"><label>
                <input name="dom_ln_m" type="text"  class="manager-input s-input"  value="<%=dom_ln_m%>" size="28" maxlength="8"  datatype="cn1-18" errormsg="请输入您的姓氏！"  nullmsg="域名所有者姓氏为空！" >
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">名:</th>
            <td align="left"><label>
                <input name="dom_fn_m" type="text" class="manager-input s-input"  value="<%=dom_fn_m%>" size="28" maxlength="8" datatype="cn1-18" errormsg="请输入您的名称！"  nullmsg="域名所有者名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">省份:</th>
            <td align="left"><label>
                <select name="dom_st_m"    datatype="*1-20" errormsg="请选择省份"  nullmsg="省份未选择，请选择！">
                  <option label="" value="">请选择</option>
                  <option label="北京" value="BJ" selected>北京</option>
                  <option label="香港" value="HK">香港</option>
                  <option label="澳门" value="MO">澳门</option>
                  <option label="台湾" value="TW">台湾</option>
                  <option label="上海" value="SH">上海</option>
                  <option label="深圳特区" value="SZ">深圳特区</option>
                  <option label="广东" value="GD">广东</option>
                  <option label="山东" value="SD">山东</option>
                  <option label="四川" value="SC">四川</option>
                  <option label="福建" value="FJ">福建</option>
                  <option label="江苏" value="JS">江苏</option>
                  <option label="浙江" value="ZJ">浙江</option>
                  <option label="天津" value="TJ" >天津</option>
                  <option label="重庆" value="CQ">重庆</option>
                  <option label="河北" value="HE">河北</option>
                  <option label="河南" value="HA">河南</option>
                  <option label="黑龙江" value="HL">黑龙江</option>
                  <option label="吉林" value="JL" >吉林</option>
                  <option label="辽宁" value="LN">辽宁</option>
                  <option label="内蒙古" value="NM">内蒙古</option>
                  <option label="海南" value="HI">海南</option>
                  <option label="山西" value="SX">山西</option>
                  <option label="陕西" value="SN">陕西</option>
                  <option label="安徽" value="AH">安徽</option>
                  <option label="江西" value="JX">江西</option>
                  <option label="甘肃" value="GS">甘肃</option>
                  <option label="新疆" value="XJ">新疆</option>
                  <option label="湖北" value="HB">湖北</option>
                  <option label="湖南" value="HN">湖南</option>
                  <option label="云南" value="YN">云南</option>
                  <option label="广西" value="GX">广西</option>
                  <option label="宁夏" value="NX">宁夏</option>
                  <option label="贵州" value="GZ">贵州</option>
                  <option label="青海" value="QH" >青海</option>
                  <option label="西藏" value="XZ">西藏</option>
                  <option label="外国" value="WG">外国</option>
                </select>
                <input type="hidden" name="cndom_st_m" value="北京">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">城市:</th>
            <td align="left"><label>
                <input name="dom_ct_m" type="text" class="manager-input s-input"  value="<%=dom_ct_m%>" size="28" maxlength="30" datatype="cncity" errormsg="请输入城市名称"  nullmsg="城市名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">地址:</th>
            <td align="left"><label>
                <input name="dom_adr_m" type="text"  class="manager-input s-input" value="<%=dom_adr_m%>" size="28" maxlength="95" datatype="cnaddress" errormsg="请输入你的详细联系地址（4-30个字）"  nullmsg="中文联系地址为能为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th colspan=2>域名英文资料</th>
          </tr>
          <tr>
            <th align="right">域名所有者:</th>
            <td align="left"><label>
                <input name="dom_org"  type="text" class="manager-input s-input"  value="<%=dom_org%>" size="28" maxlength="60" datatype="enname" errormsg="请输入您的英文姓名,每个词语用空格分开！"  nullmsg="英文姓名为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">姓:</th>
            <td align="left"><label>
                <input name="dom_ln"  type="text" class="manager-input s-input"  value="<%=dom_ln%>" size="28" maxlength="8" datatype="enname2" errormsg="请输入您的英文姓氏,每个词语用空格分开！"  nullmsg="英文姓氏为空！" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">名:</th>
            <td align="left"><label>
                <input name="dom_fn"  type="text" class="manager-input s-input"  value="<%=dom_fn%>" size="28" maxlength="15"  datatype="enname2" errormsg="请输入您的英文名,每个词语用空格分开！"  nullmsg="英文名为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">国家代码:</th>
            <td align="left"><label>
                <select name="dom_co" style="width:170px;"  datatype="*1-20" errormsg="请选择"  nullmsg="未选择，请选择！">
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
                <select name="dom_st" id="dom_st_en"   datatype="*1-20" errormsg="请选择省份"  nullmsg="省份未选择，请选择！">
                  <option label="请选择" value="">请选择</option>
                  <option value="BJ" selected="selected" label="北京" >北京</option>
                  <option label="香港" value="HK" >香港</option>
                  <option label="澳门" value="MO" >澳门</option>
                  <option label="台湾" value="TW" >台湾</option>
                  <option label="上海" value="SH" >上海</option>
                  <option label="深圳特区" value="SZ" >深圳特区</option>
                  <option label="广东" value="GD" >广东</option>
                  <option label="山东" value="SD" >山东</option>
                  <option label="四川" value="SC" >四川</option>
                  <option label="福建" value="FJ" >福建</option>
                  <option label="江苏" value="JS" >江苏</option>
                  <option label="浙江" value="ZJ" >浙江</option>
                  <option label="天津" value="TJ" >天津</option>
                  <option label="重庆" value="CQ" >重庆</option>
                  <option label="河北" value="HE" >河北</option>
                  <option label="河南" value="HA" >河南</option>
                  <option label="黑龙江" value="HL" >黑龙江</option>
                  <option label="吉林" value="JL" >吉林</option>
                  <option label="辽宁" value="LN" >辽宁</option>
                  <option label="内蒙古" value="NM" >内蒙古</option>
                  <option label="海南" value="HI" >海南</option>
                  <option label="山西" value="SX" >山西</option>
                  <option label="陕西" value="SN" >陕西</option>
                  <option label="安徽" value="AH" >安徽</option>
                  <option label="江西" value="JX" >江西</option>
                  <option label="甘肃" value="GS" >甘肃</option>
                  <option label="新疆" value="XJ" >新疆</option>
                  <option label="湖北" value="HB" >湖北</option>
                  <option label="湖南" value="HN" >湖南</option>
                  <option label="云南" value="YN" >云南</option>
                  <option label="广西" value="GX" >广西</option>
                  <option label="宁夏" value="NX" >宁夏</option>
                  <option label="贵州" value="GZ" >贵州</option>
                  <option label="青海" value="QH" >青海</option>
                  <option label="西藏" value="XZ" >西藏</option>
                  <option label="外国" value="WG" >外国</option>
                </select>
                <script language=javascript>
		var st=document.domainreg.dom_st;
		for (var ii=0;ii<st.options.length;ii++){
			
			if (st.options[ii].value=='{dom_st}'){
				st.selectedIndex=ii;
			}
		}
		</script> 
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">城市:</th>
            <td align="left"><label>
                <input name="dom_ct"  type="text"  class="manager-input s-input" size="28" maxlength="30" value="<%=dom_ct%>" datatype="enaddress" errormsg="请输入您的英文城市名称,每个词语用空格分开！"  nullmsg="英文城市名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">地址:</th>
            <td align="left"><label>
                <input name="dom_adr1"  type="text"  class="manager-input s-input" size="28" maxlength="95" value="<%=dom_adr1%>" datatype="enaddress" errormsg="请输入您的英文地址名称,每个词语用空格分开！"  nullmsg="英文地址名称为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">邮编:</th>
            <td align="left"><label>
                <input name="dom_pc"  type="text" class="manager-input s-input"  value="<%=dom_pc%>" size="28" maxlength="6" datatype="zip" errormsg="请输入您的邮政编码！"  nullmsg="邮政编码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">电话:</th>
            <td align="left"><label>
                <input name="dom_ph"  type="text" class="manager-input s-input"  value="<%=dom_ph%>" size="23" maxlength="12" style="width:165px;" datatype="tel" errormsg="请输入您的正确电话号码！"  nullmsg="电话号码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">传真:</th>
            <td align="left"><label>
                <input name="dom_fax"  type="text"  class="manager-input s-input" value="<%=dom_fax%>" size="23" maxlength="12" style="width:165px;" datatype="fax" errormsg="请输入您的正确传真！"  nullmsg="传真号码为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">电子邮件:</th>
            <td align="left"><label>
                <input name="dom_em"  type="text"  class="manager-input s-input" value="<%=dom_em%>" size="28" maxlength="50" datatype="e" errormsg="请输入您的电子邮件！"  nullmsg="电子邮件为空！">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right"> </th>
            <td align="left"><label> </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <td colspan=2><input  type="button" class="z_btn-buy manager-btn s-btn" value="保存信息">
              <input  type="hidden" name="id" value="<%=id%>"></td>
          </tr>
        </table>
      </form>
      <script>
 $(function(){
	 var dom_st_m="<%=dom_st_m%>";
	 var cndom_st_m="<%=cndom_st_m%>";
	 var dom_st_en="<%=dom_st%>";
	 	 $("select[name='dom_st_m']").change(function(){
         $("input[name='cndom_st_m']").val($(this).find('option:selected').text())
 $("#dom_st_en").val($(this).val() )
 			 })
			 
		if(dom_st_m!="")
		{
			$("select[name='dom_st_m']").val(dom_st_m);
		}
			if(dom_st_en!="")
		{
			$("select[name='dom_st']").val(dom_st_en);
		}
			if(cndom_st_m!="")
		{
			$("input[name='cndom_st_m']").val(cndom_st_m);
		}
	 
	 $("#domainreg").Validform({
		tiptype:2,
		showAllError:true,
		btnSubmit:".z_btn-buy",
		datatype:{
			"enname":function(gets,obj,curform,regxp)
				{
				/*参数gets是获取到的表单元素值，
				  obj为当前表单元素，
				  curform为当前验证的表单，
				  regxp为内置的一些正则表达式的引用。*/
				  var reg=""
                  ennameval=obj[0].value;
				  
						  if(ennameval.indexOf(" ")>0)
						 {
						 return true;
						 }else
						 {
						return false;
						 }
				},
			 "dom_org_m_cn":function(gets,obj,curform,regxp)
				{
					var reg=/^[\u4E00-\u9FA5\uf900-\ufa2d\(\)]{2,30}$/;
					do_org_m_cn=obj[0].value;
					if(reg.test(do_org_m_cn))
					{
	
					return true;}
					else{
					return false;	
						}
				} 

		}
	});
	


 
	 
	 })
 </script>
      <%
end sub


sub savedb
id=requesta("id")
id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0


dom_org=CheckInputType(trim(Requesta("dom_org")),"^[\w\.\,\s]{4,100}$","英文域名所有者",true)
		dom_fn=CheckInputType(trim(Requesta("dom_fn")),"^[\w\.\s]{2,30}$","英文名",true)
		dom_ln=CheckInputType(trim(Requesta("dom_ln")),"^[\w\.\s]{2,30}$","英文姓",true)
		dom_adr1=CheckInputType(trim(Requesta("dom_adr1")),"^[\w\.\,\s#,]{7,75}$","英文地址",false)
		dom_ct=CheckInputType(trim(Requesta("dom_ct")),"^[\w\.\s]{4,30}$","英文城市",false)
		dom_st=CheckInputType(trim(Requesta("dom_st")),"^[\w\.\s]{1,30}$","英文省份",false)
		dom_co=CheckInputType(trim(Requesta("dom_co")),"^[\w\.\s]{1,30}$","国家代码",false)
		dom_pc=CheckInputType(trim(Requesta("dom_pc")),"^[\d]{6}$","邮编",false)
		dom_ph=CheckInputType(trim(Requesta("dom_ph")),"^[\d\-\.]{8,16}$","电话号码",false)
		'if IsValidMobileNo(dom_ph) then
		'	url_return "电话号码不能是手机号!",-1
		'end if
		
		dom_fax=CheckInputType(trim(Requesta("dom_fax")),"^[\d\-\.]{8,16}$","传真号码",false)
		dom_em=CheckInputType(trim(Requesta("dom_em")),"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$","邮箱号码",false)
	    dom_org_m=domainChinese(trim(requesta("dom_org_m")),2,100,"中文所有者")
		dom_fn_m=CheckInputType(trim(Requesta("dom_fn_m")),"^[\u4e00-\u9fa5]{1,4}$","中文姓",true)
		dom_ln_m=CheckInputType(trim(Requesta("dom_ln_m")),"^[\u4e00-\u9fa5]{1,6}$","中文名",true)
		dom_adr1_m=domainChinese(trim(Requesta("dom_adr_m")),7,100,"中文地址")
		dom_ct_m=CheckInputType(trim(Requesta("dom_ct_m")),"^[\u4e00-\u9fa5]{2,60}$","中文城市",false)
		cndom_st_m=CheckInputType(trim(Requesta("cndom_st_m")),"^[\u4e00-\u9fa5]{2,10}$","中文省份",false)
		
		dom_st_m=CheckInputType(trim(Requesta("dom_st_m")),"^[A-Za-z ]{1,10}$","中文省份",false)
		 
		dns_host1=CheckInputType(requesta("dns_host1"),"^[\w\.\-]{2,60}$","DNS1",false)
		dns_host2=CheckInputType(requesta("dns_host2"),"^[\w\.\-]*$","DNS2",false)
		dns_ip1=CheckInputType(requesta("dns_ip1"),"^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$","DNS1的ip1",false)
		dns_ip2=CheckInputType(requesta("dns_ip2"),"^[\d\.]*$","DNS2的ip2",false)

 
set mrs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from domainTemp where id="&id&" and u_name='"&session("user_name")&"'"
mrs.open sql,conn,1,3
if mrs.eof then
mrs.addnew
end if
mrs("u_name")=session("user_name")
mrs("dns_host1")=dns_host1
mrs("dns_ip1")=dns_ip1
mrs("dns_host2")=dns_host2
mrs("dns_ip2")=dns_ip2
mrs("dom_org_m")=dom_org_m
mrs("dom_ln_m")=dom_ln_m
mrs("dom_fn_m")=dom_fn_m
mrs("dom_st_m")=dom_st_m
mrs("cndom_st_m")=cndom_st_m
mrs("dom_ct_m")=dom_ct_m
mrs("dom_adr_m")=dom_adr1_m
mrs("dom_org")=dom_org
mrs("dom_ln")=dom_ln
mrs("dom_fn")=dom_fn
mrs("dom_co")=dom_co
mrs("dom_st")=dom_st
mrs("dom_ct")=dom_ct

mrs("dom_adr1")=dom_adr1
mrs("dom_pc")=dom_pc
mrs("dom_ph")=dom_ph
mrs("dom_fax")=dom_fax
mrs("dom_em")=dom_em
mrs.update

call Alert_Redirect("操作成功!","?act=list")

end sub


function CheckInputType(byval values,byval reglist,byval errinput,byval pd)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "格式错误",-1
	else
		
		if pd then
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
		
	end if
	CheckInputType=values
end function
function domainChinese(byval values,byval flen,byval llen,byval errinput)
	if len(values)<=llen and len(values)>=flen then
		if not ischinese(values) then
			conn.close
			url_return errinput & "需含有中文",-1
		else
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
	else
		conn.close
		url_return errinput & "字符长度应在" & flen & "-" & llen & "之间",-1
	end if
	domainChinese=values
end function
sub checkdmbuydomain()'安全检验
	if not isAlldomain(strdomain,errstr1) then url_return errstr1,-1
end sub

%>
    </div>
  </div>
</div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
