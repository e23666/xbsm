<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
 newcheckstr="^((����)|(����)|(����)|(ת��)|(����Ա)|(�Ұ���)|(����)|(׬Ǯ)|(����)|(��ˮ)|(N\/A)|(NA)|(Domain Whois Protect)|(webmaster)|\d)$"		  'ע�����ϲ������ùؼ���(������ʽ)


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-����ģ�����</title>
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
/* ����ƶ�ʱ��������ʽ*/
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
/*�����б���ʽ*/
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
/*����ʱ���ֵ���ʾ*/
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
        <li><a href="/">��ҳ</a></li>
        <li><a href="/Manager/">��������</a></li>
        <li><a href="/Manager/domainmanager/">��������</a></li>
        <li><a href="/manager/domainmanager/momould.asp">����ע��ģ�����</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <div class="tab">����ע��ģ�����&nbsp;&nbsp;��<a href="?act=add">���ģ��</a>��</div>
      <%
	  
	  act=requesta("act")
	  select case trim(act)
	  case "add","edit":
	  addedit()
	  case "del"
	  id=requesta("id")
if not isnumeric(id) or trim(id)="" then id=0

conn.execute("delete from domainTemp  where id="&id&" and u_name='"&session("user_name")&"'")
call Alert_Redirect("�����ɹ�!","?act=list")
	  case "save"
	  savedb()
	  case else
	  list
	  
	  end select
	  
	  sub list
	  %>
      <table class="manager-table">
        <tr align="center"  class="titletr">
          <th>���</th>
          <th>����������</th>
          <th>����ʱ��</th>
          <th>����</th>
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
          <td><a href="?act=edit&id=<%=mrs("id")%>">�޸�</a> <a href="?act=del&id=<%=mrs("id")%>" onclick="return confirm('��ȷ��Ҫɾ��!')">ɾ��</a></td>
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
            <th align="right" width="30%">����������(DNS):</th>
            <td align="left"> 
			  <label>
              <input name="dns_host1"  type="text"  class="manager-input s-input"  value="<%=dns_host1%>" size="28" maxlength="30"  datatype="dm" errormsg="��������ȷDNS����������"  />
             </label>
			 <label><label class="Validform_checktip"></label></label>
			 </td> 
          </tr>
          <tr>
            <th align="right">����������(IP):</th>
            <td align="left"><label>
                <input name="dns_ip1"  type="text"  class="manager-input s-input"  value="<%=dns_ip1%>" size="28" maxlength="30"  datatype="ip4" errormsg="��������ȷip��ַ" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">����������(DNS):</th>
            <td align="left"><label>
                <input name="dns_host2"  type="text"  class="manager-input s-input"  value="<%=dns_host2%>" size="28" maxlength="30"  datatype="dm" errormsg="��������ȷDNS����������"  />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">����������(IP): 
            </th> 
            <td align="left"><label>
                <input name="dns_ip2"  type="text"  class="manager-input s-input"  value="<%=dns_ip2%>" size="28" maxlength="30"  datatype="ip4" errormsg="��������ȷip��ַ" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th colspan=2>������������</th>
          </tr>
          <tr>
            <th align="right">����������:</th>
            <td align="left"> 
                <input name="dom_org_m" type="text"   class="manager-input s-input" value="<%=dom_org_m%>" size="28" maxlength="60" datatype="dom_org_m_cn" errormsg="��������������ȫ����"  nullmsg="����������ȫ��Ϊ�գ�"  >
              
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��:</th>
            <td align="left"><label>
                <input name="dom_ln_m" type="text"  class="manager-input s-input"  value="<%=dom_ln_m%>" size="28" maxlength="8"  datatype="cn1-18" errormsg="�������������ϣ�"  nullmsg="��������������Ϊ�գ�" >
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��:</th>
            <td align="left"><label>
                <input name="dom_fn_m" type="text" class="manager-input s-input"  value="<%=dom_fn_m%>" size="28" maxlength="8" datatype="cn1-18" errormsg="�������������ƣ�"  nullmsg="��������������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">ʡ��:</th>
            <td align="left"><label>
                <select name="dom_st_m"    datatype="*1-20" errormsg="��ѡ��ʡ��"  nullmsg="ʡ��δѡ����ѡ��">
                  <option label="" value="">��ѡ��</option>
                  <option label="����" value="BJ" selected>����</option>
                  <option label="���" value="HK">���</option>
                  <option label="����" value="MO">����</option>
                  <option label="̨��" value="TW">̨��</option>
                  <option label="�Ϻ�" value="SH">�Ϻ�</option>
                  <option label="��������" value="SZ">��������</option>
                  <option label="�㶫" value="GD">�㶫</option>
                  <option label="ɽ��" value="SD">ɽ��</option>
                  <option label="�Ĵ�" value="SC">�Ĵ�</option>
                  <option label="����" value="FJ">����</option>
                  <option label="����" value="JS">����</option>
                  <option label="�㽭" value="ZJ">�㽭</option>
                  <option label="���" value="TJ" >���</option>
                  <option label="����" value="CQ">����</option>
                  <option label="�ӱ�" value="HE">�ӱ�</option>
                  <option label="����" value="HA">����</option>
                  <option label="������" value="HL">������</option>
                  <option label="����" value="JL" >����</option>
                  <option label="����" value="LN">����</option>
                  <option label="���ɹ�" value="NM">���ɹ�</option>
                  <option label="����" value="HI">����</option>
                  <option label="ɽ��" value="SX">ɽ��</option>
                  <option label="����" value="SN">����</option>
                  <option label="����" value="AH">����</option>
                  <option label="����" value="JX">����</option>
                  <option label="����" value="GS">����</option>
                  <option label="�½�" value="XJ">�½�</option>
                  <option label="����" value="HB">����</option>
                  <option label="����" value="HN">����</option>
                  <option label="����" value="YN">����</option>
                  <option label="����" value="GX">����</option>
                  <option label="����" value="NX">����</option>
                  <option label="����" value="GZ">����</option>
                  <option label="�ຣ" value="QH" >�ຣ</option>
                  <option label="����" value="XZ">����</option>
                  <option label="���" value="WG">���</option>
                </select>
                <input type="hidden" name="cndom_st_m" value="����">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">����:</th>
            <td align="left"><label>
                <input name="dom_ct_m" type="text" class="manager-input s-input"  value="<%=dom_ct_m%>" size="28" maxlength="30" datatype="cncity" errormsg="�������������"  nullmsg="��������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��ַ:</th>
            <td align="left"><label>
                <input name="dom_adr_m" type="text"  class="manager-input s-input" value="<%=dom_adr_m%>" size="28" maxlength="95" datatype="cnaddress" errormsg="�����������ϸ��ϵ��ַ��4-30���֣�"  nullmsg="������ϵ��ַΪ��Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th colspan=2>����Ӣ������</th>
          </tr>
          <tr>
            <th align="right">����������:</th>
            <td align="left"><label>
                <input name="dom_org"  type="text" class="manager-input s-input"  value="<%=dom_org%>" size="28" maxlength="60" datatype="enname" errormsg="����������Ӣ������,ÿ�������ÿո�ֿ���"  nullmsg="Ӣ������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��:</th>
            <td align="left"><label>
                <input name="dom_ln"  type="text" class="manager-input s-input"  value="<%=dom_ln%>" size="28" maxlength="8" datatype="enname2" errormsg="����������Ӣ������,ÿ�������ÿո�ֿ���"  nullmsg="Ӣ������Ϊ�գ�" />
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��:</th>
            <td align="left"><label>
                <input name="dom_fn"  type="text" class="manager-input s-input"  value="<%=dom_fn%>" size="28" maxlength="15"  datatype="enname2" errormsg="����������Ӣ����,ÿ�������ÿո�ֿ���"  nullmsg="Ӣ����Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">���Ҵ���:</th>
            <td align="left"><label>
                <select name="dom_co" style="width:170px;"  datatype="*1-20" errormsg="��ѡ��"  nullmsg="δѡ����ѡ��">
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
            <th align="right">ʡ��:</th>
            <td align="left"><label>
                <select name="dom_st" id="dom_st_en"   datatype="*1-20" errormsg="��ѡ��ʡ��"  nullmsg="ʡ��δѡ����ѡ��">
                  <option label="��ѡ��" value="">��ѡ��</option>
                  <option value="BJ" selected="selected" label="����" >����</option>
                  <option label="���" value="HK" >���</option>
                  <option label="����" value="MO" >����</option>
                  <option label="̨��" value="TW" >̨��</option>
                  <option label="�Ϻ�" value="SH" >�Ϻ�</option>
                  <option label="��������" value="SZ" >��������</option>
                  <option label="�㶫" value="GD" >�㶫</option>
                  <option label="ɽ��" value="SD" >ɽ��</option>
                  <option label="�Ĵ�" value="SC" >�Ĵ�</option>
                  <option label="����" value="FJ" >����</option>
                  <option label="����" value="JS" >����</option>
                  <option label="�㽭" value="ZJ" >�㽭</option>
                  <option label="���" value="TJ" >���</option>
                  <option label="����" value="CQ" >����</option>
                  <option label="�ӱ�" value="HE" >�ӱ�</option>
                  <option label="����" value="HA" >����</option>
                  <option label="������" value="HL" >������</option>
                  <option label="����" value="JL" >����</option>
                  <option label="����" value="LN" >����</option>
                  <option label="���ɹ�" value="NM" >���ɹ�</option>
                  <option label="����" value="HI" >����</option>
                  <option label="ɽ��" value="SX" >ɽ��</option>
                  <option label="����" value="SN" >����</option>
                  <option label="����" value="AH" >����</option>
                  <option label="����" value="JX" >����</option>
                  <option label="����" value="GS" >����</option>
                  <option label="�½�" value="XJ" >�½�</option>
                  <option label="����" value="HB" >����</option>
                  <option label="����" value="HN" >����</option>
                  <option label="����" value="YN" >����</option>
                  <option label="����" value="GX" >����</option>
                  <option label="����" value="NX" >����</option>
                  <option label="����" value="GZ" >����</option>
                  <option label="�ຣ" value="QH" >�ຣ</option>
                  <option label="����" value="XZ" >����</option>
                  <option label="���" value="WG" >���</option>
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
            <th align="right">����:</th>
            <td align="left"><label>
                <input name="dom_ct"  type="text"  class="manager-input s-input" size="28" maxlength="30" value="<%=dom_ct%>" datatype="enaddress" errormsg="����������Ӣ�ĳ�������,ÿ�������ÿո�ֿ���"  nullmsg="Ӣ�ĳ�������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">��ַ:</th>
            <td align="left"><label>
                <input name="dom_adr1"  type="text"  class="manager-input s-input" size="28" maxlength="95" value="<%=dom_adr1%>" datatype="enaddress" errormsg="����������Ӣ�ĵ�ַ����,ÿ�������ÿո�ֿ���"  nullmsg="Ӣ�ĵ�ַ����Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">�ʱ�:</th>
            <td align="left"><label>
                <input name="dom_pc"  type="text" class="manager-input s-input"  value="<%=dom_pc%>" size="28" maxlength="6" datatype="zip" errormsg="�����������������룡"  nullmsg="��������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">�绰:</th>
            <td align="left"><label>
                <input name="dom_ph"  type="text" class="manager-input s-input"  value="<%=dom_ph%>" size="23" maxlength="12" style="width:165px;" datatype="tel" errormsg="������������ȷ�绰���룡"  nullmsg="�绰����Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">����:</th>
            <td align="left"><label>
                <input name="dom_fax"  type="text"  class="manager-input s-input" value="<%=dom_fax%>" size="23" maxlength="12" style="width:165px;" datatype="fax" errormsg="������������ȷ���棡"  nullmsg="�������Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right">�����ʼ�:</th>
            <td align="left"><label>
                <input name="dom_em"  type="text"  class="manager-input s-input" value="<%=dom_em%>" size="28" maxlength="50" datatype="e" errormsg="���������ĵ����ʼ���"  nullmsg="�����ʼ�Ϊ�գ�">
              </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <th align="right"> </th>
            <td align="left"><label> </label>
              <label><label class="Validform_checktip"></label></label></td>
          </tr>
          <tr>
            <td colspan=2><input  type="button" class="z_btn-buy manager-btn s-btn" value="������Ϣ">
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
				/*����gets�ǻ�ȡ���ı�Ԫ��ֵ��
				  objΪ��ǰ��Ԫ�أ�
				  curformΪ��ǰ��֤�ı���
				  regxpΪ���õ�һЩ������ʽ�����á�*/
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


dom_org=CheckInputType(trim(Requesta("dom_org")),"^[\w\.\,\s]{4,100}$","Ӣ������������",true)
		dom_fn=CheckInputType(trim(Requesta("dom_fn")),"^[\w\.\s]{2,30}$","Ӣ����",true)
		dom_ln=CheckInputType(trim(Requesta("dom_ln")),"^[\w\.\s]{2,30}$","Ӣ����",true)
		dom_adr1=CheckInputType(trim(Requesta("dom_adr1")),"^[\w\.\,\s#,]{7,75}$","Ӣ�ĵ�ַ",false)
		dom_ct=CheckInputType(trim(Requesta("dom_ct")),"^[\w\.\s]{4,30}$","Ӣ�ĳ���",false)
		dom_st=CheckInputType(trim(Requesta("dom_st")),"^[\w\.\s]{1,30}$","Ӣ��ʡ��",false)
		dom_co=CheckInputType(trim(Requesta("dom_co")),"^[\w\.\s]{1,30}$","���Ҵ���",false)
		dom_pc=CheckInputType(trim(Requesta("dom_pc")),"^[\d]{6}$","�ʱ�",false)
		dom_ph=CheckInputType(trim(Requesta("dom_ph")),"^[\d\-\.]{8,16}$","�绰����",false)
		'if IsValidMobileNo(dom_ph) then
		'	url_return "�绰���벻�����ֻ���!",-1
		'end if
		
		dom_fax=CheckInputType(trim(Requesta("dom_fax")),"^[\d\-\.]{8,16}$","�������",false)
		dom_em=CheckInputType(trim(Requesta("dom_em")),"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$","�������",false)
	    dom_org_m=domainChinese(trim(requesta("dom_org_m")),2,100,"����������")
		dom_fn_m=CheckInputType(trim(Requesta("dom_fn_m")),"^[\u4e00-\u9fa5]{1,4}$","������",true)
		dom_ln_m=CheckInputType(trim(Requesta("dom_ln_m")),"^[\u4e00-\u9fa5]{1,6}$","������",true)
		dom_adr1_m=domainChinese(trim(Requesta("dom_adr_m")),7,100,"���ĵ�ַ")
		dom_ct_m=CheckInputType(trim(Requesta("dom_ct_m")),"^[\u4e00-\u9fa5]{2,60}$","���ĳ���",false)
		cndom_st_m=CheckInputType(trim(Requesta("cndom_st_m")),"^[\u4e00-\u9fa5]{2,10}$","����ʡ��",false)
		
		dom_st_m=CheckInputType(trim(Requesta("dom_st_m")),"^[A-Za-z ]{1,10}$","����ʡ��",false)
		 
		dns_host1=CheckInputType(requesta("dns_host1"),"^[\w\.\-]{2,60}$","DNS1",false)
		dns_host2=CheckInputType(requesta("dns_host2"),"^[\w\.\-]*$","DNS2",false)
		dns_ip1=CheckInputType(requesta("dns_ip1"),"^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$","DNS1��ip1",false)
		dns_ip2=CheckInputType(requesta("dns_ip2"),"^[\d\.]*$","DNS2��ip2",false)

 
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

call Alert_Redirect("�����ɹ�!","?act=list")

end sub


function CheckInputType(byval values,byval reglist,byval errinput,byval pd)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "��ʽ����",-1
	else
		
		if pd then
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "���ܺ��н��ùؼ���",-1
			end if
		end if
		
	end if
	CheckInputType=values
end function
function domainChinese(byval values,byval flen,byval llen,byval errinput)
	if len(values)<=llen and len(values)>=flen then
		if not ischinese(values) then
			conn.close
			url_return errinput & "�躬������",-1
		else
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "���ܺ��н��ùؼ���",-1
			end if
		end if
	else
		conn.close
		url_return errinput & "�ַ�����Ӧ��" & flen & "-" & llen & "֮��",-1
	end if
	domainChinese=values
end function
sub checkdmbuydomain()'��ȫ����
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
