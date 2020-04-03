<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<%

conn.open constr
strDomain=Lcase(Trim(Requesta("strDomain")))
domainPWD=Trim(Requesta("domainPWD"))
UserName=Trim(Requesta("UserName"))
Price=Trim(Requesta("Price"))
dom_org=Trim(Requesta("dom_org"))
dom_ln=Trim(Requesta("dom_ln"))
dom_fn=Trim(Requesta("dom_fn"))
dom_co=Trim(Requesta("dom_co"))
dom_st=Trim(Requesta("dom_st"))
dom_ct=Trim(Requesta("dom_ct"))
dom_adr1=Trim(Requesta("dom_adr1"))
dom_pc=Trim(Requesta("dom_pc"))
dom_ph=Trim(Requesta("dom_ph"))
dom_fax=Trim(Requesta("dom_fax"))
dom_em=Trim(Requesta("dom_em"))
dns_host1=Trim(Requesta("dns_host1"))
dns_host2=Trim(Requesta("dns_host2"))
dns_ip1=Trim(Requesta("dns_ip1"))
dns_ip2=Trim(Requesta("dns_ip2"))
register=Trim(Requesta("register"))
rsbdate=Request("rsbdate")
period=Request("period")
if not isNumeric(period) then period=1
simulate_price=Trim(Requesta("simulate_price"))
if Requesta("Submit")="" and UserName<>"" then
	Sql="Select * from userdetail where u_name='" & UserName & "'"
	Rs.open Sql,conn,1,1
	
	if not Rs.eof then
dom_org=Rs("u_nameEn")
dom_ln=Rs("u_nameEn")
dom_fn=Rs("u_nameEn")
dom_co=Rs("u_contry")
dom_st=Rs("u_province")
dom_ct=Rs("u_city")
dom_adr1=Rs("u_address")
dom_pc=Rs("u_zipcode")
dom_ph=Rs("u_telphone")
dom_fax=Rs("u_fax")
dom_em=Rs("u_email")


	t_proid=GetDomainType(strDomain)

	
u_level=trim(Rs("u_level"))

	'Sql="Select p_price from pricelist where p_u_level=" & u_level & " and p_proid='" & t_proid & "'"
	'Set Trs=conn.Execute(Sql)
	'if not Trs.eof then Price=TRs("p_price")
	'Price=100
	'Trs.close
	'Set Trs=nothing

'	end if
'	Rs.close
if t_proid="domhz" then
	Price=260
else
   if u_level>=2 then
     Price=80
   else
	Price=100
   end if
end if
If Lcase(right(strDomain,2))="cn" Then
   if u_level>=2 then
     Price=80
   else
	Price=100
   end if

'elseif iscn(strDomain) then
'	Price=0
'else
'	Price=100
End If
end if
end if


if strDomain<>"" and Requesta("Submit")<>"" then
    proid=GetDomainType(strDomain)
	if proid="docnon" then url_return "未知的域名类型",-1
	Sql="Select u_id,u_usemoney from userdetail where u_name='" & UserName & "'"
	Rs.open Sql,conn,1,1
    if Rs.eof then url_return "没有找到此用户",-1
	u_id=Rs("u_id")
	u_usemoney=Rs("u_usemoney")
	Rs.close
	if Ccur(u_usemoney)<Ccur(Price) then url_return "用户余额不足",-1
	if not isDate(rsbdate) then url_return "日期格式不对",-1
	if not isNumeric(period) then url_return "年限不对",-1
	
       if isNumeric(simulate_price) then	
		simulatePrice=simulate_price
	else
		simulatePrice=-1
	end if

if simulatePrice=-1 then url_return "请填入模拟扣款金额！！",-1


	dns_host1=Trim(Requesta("dns_host1"))
	dns_host2=Trim(Requesta("dns_host2"))
	dns_ip1=Trim(Requesta("dns_ip1"))
	dns_ip2=Trim(Requesta("dns_ip2"))

'	strDomain="_" & strDomain
	
	Sql="Select d_id from domainlist where strdomain='" & strdomain & "'"
	Rs.open Sql,conn,1,1
	if not Rs.eof then
		url_return "错误，域名已经存在",-1
	end if
	Rs.close


	sql="insert into domainlist (regok,proid,userid,regdate,rexpiredate,rsbdate,strDomain,strDomainpwd,admi_pc,years,dom_ln,admi_fax,tech_fn,tech_ph,bill_ct,bill_em,dns_host1,dns_host2,dom_fn,admi_co,bill_ln,bill_fax,dns_ip1,dom_fax,admi_fn,admi_ph,tech_st,tech_fax,dns_ip2,admi_ct,admi_em,dom_org,admi_st,dom_co,dom_ph,tech_pc,bill_co,dom_st,dom_pc,dom_ct,dom_adr1,dom_em,tech_co,bill_pc ,admi_ln,admi_adr1,tech_ct,tech_em,bill_st,bill_ph,tech_ln,tech_adr1,bill_fn,bill_adr1,bizcnorder,isreglocal) values ('0','" & proid & "'," & u_id & ", '" & rsbdate & "','" & dateadd("yyyy",period,rsbdate) & "', '"&date()&"','" & strDomain &"','" & domainPWD & "','" & dom_pc & "'," & period & ",'" & dom_ln & "','" & dom_fax & "','" & dom_fn & "','" & dom_ph & "','" & dom_ct &"','" & dom_em &"','" & dns_host1 & "','" & dns_host2 & "','" & dom_fn &"','" & dom_co & "','" & dom_ln & "','" & dom_fax & "','" & dns_ip1 & "','" & dom_fax & "','" & dom_fn & "','" & dom_ph & "','" & dom_st & "','" & dom_fax & "','" & dns_ip2 & "','" & dom_ct & "','" & dom_em & "','" & dom_org & "','" & dom_st & "','" & dom_co & "','" & dom_ph & "','" & tech_pc & "','" & dom_co & "','" & dom_st & "','" & dom_pc &"','" & dom_ct & "','" & dom_adr1 & "','" & dom_em & "','" & dom_co & "','"& dom_pc & "','" & dom_ln &"','" & dom_adr1 & "','" & dom_ct & "','" & dom_em &"','" & dom_st & "','" & dom_ph &"','" & dom_ln & "','" & dom_adr1 &"','" & bill_fn & "','" & bill_adr1 &"','" & register & "',0)"
	conn.Execute(Sql)
	Sql="Select d_id from domainlist where strDomain='" & strDomain & "'"
    Rs.open Sql,conn,1,1
	if Rs.eof then url_return "没道理呀,我才添加的,没了",-1
	IDENTITY=Rs("d_id")
	Rs.close
	Sql="insert into orderlist (o_okdate,o_typeid,o_type,o_ok,o_ownerid,o_producttype,o_memo,o_money) values ('"&date()&"'," & IDENTITY & ",'" & proid & "','0'," & u_id & ",3,'" & strDomain & "'," & Price & ")"
	conn.Execute(Sql)
	Sql="Select max(o_id) as o_id from orderlist where o_ownerid=" & u_id & " and o_producttype=3"
	Rs.open Sql,conn,1,1
	OrderID=Rs("o_id")
	Rs.close
	Sql="update orderlist set o_key=o_id where o_id = " & OrderId
	conn.Execute(Sql)
	Sql="insert into [_order] (o_key,o_moneysum,o_date , o_ok) values( " & OrderID & " ," & Price & " ,'"&date()&"',0)"
	conn.Execute(Sql)
	Sql="update userdetail set u_resumesum=u_resumesum+ " & Price &" , u_accumulate=u_accumulate+1 , u_remcount=u_remcount-" & Price & " , u_usemoney=u_usemoney-" & Price & "  where u_id=" & u_id
	conn.Execute(Sql)
	Sql="insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck,c_type,o_id,p_proid) values (" & u_id & " ," & Price & " ,0,  " & Price & " ,'" & strDomain &"-" & Cstr(OrderID) & "','域名转入',0,'"&date()&"','"&date()&"','"&date()&"',3, " & OrderID & ",'" & proid &"')"
	conn.Execute(Sql)
	 Alert_Redirect "转入成功","./DomainIn.asp"
end if

%>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域 名 转 入</strong></td>
  </tr>
</table>
<script language="javascript" src="/config/PopupCalendar.js"></script>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">域名管理</a></span> | <a href="ModifyDomain.asp">域名日期校正</a> | <a href="DomainIn.asp">域名转入</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
<script language=javascript>

function isNumber(number){
var i,str1="0123456789.";
	for(i=0;i<number.value.length;i++){
	if(str1.indexOf(number.value.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function checkNull(data,text){
	if (data.value==""){
		alert("抱歉!提交失败，"+text+"不能为空!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}

function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("抱歉!["+text+"]必须是数字,否则无法提交");
	data.focus();
	data.select();
	return false;
	}
}
return true;
}

function check(form){

 if (!checkNull(form.strDomain,"域名名称")) return false;
 if (!checkNull(form.dns_host1,"主DNS")) return false;
 if (!checkNull(form.dns_host2,"辅DNS")) return false;
 if (!checkNull(form.UserName,"用户名")) return false;
 if (!isDigital(form.Price,"扣款金额")) return false;
 if (!checkNull(form.dom_org,"域名所有人")) return false;
 if (!checkNull(form.dom_ln,"姓")) return false;
 if (!checkNull(form.dom_fn,"名")) return false;
 if (!checkNull(form.dom_st,"省")) return false;
 if (!checkNull(form.dom_ct,"省")) return false;
 if (!checkNull(form.dom_ct,"城市")) return false;
 if (!checkNull(form.dom_adr1,"地址")) return false;
 if (!checkNull(form.dom_pc,"邮编")) return false;
 if (!isDigital(form.dom_pc,"邮编")) return false;
 if (!checkNull(form.dom_ph,"电话")) return false;
 if (!checkNull(form.dom_em,"Email")) return false;

return true;
}

</script>
<br>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
<tr class="title"><td height="25"><p class="STYLE4" style="margin-left: 9">注意:以下每项资料必填且只能输入英文!</td>
</tr>
 <form name=domainreg onSubmit="return check(this)" action="DomainIn.asp" method=post> 
<tr> <td valign="top">
        <table width="100%" border=0 align="center" cellpadding="3" cellspacing="0">
          <tr> 
            <td width="19%" align="right" class="tdbg">域名注册商：</td>
            <td width="81%" class="tdbg"> 
              <%temp=Request.Form("register")%>
              <select name="register">
                <option value="default" <%if temp="default" then response.write "selected"%>>西部数码</option>
                <option value="bizcn" <%if temp="bizcn" then response.write "selected"%>>商务中国</option>
                <option value="netcn" <%if temp="netcn" then response.write "selected"%>>万网</option>
                <option value="xinet" <%if temp="xinet" then response.write "selected"%>>新网</option>
                <option value="dnscn" <%if temp="dnscn" then response.write "selected"%>>新网互联</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">转入的域名：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="strDomain" size="40" value="<%=strDomain%>">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">DNS1：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="dns_host1" maxlength=32 size="20" value="ns1.myhostadmin.net">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">DNS2：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="dns_host2" maxlength=32 size="20" value="ns2.myhostadmin.net">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">IP1：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="dns_ip1" maxlength=32 size="20" value="220.166.64.222">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">IP2：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="dns_ip2" maxlength=32 size="20" value="61.236.150.177">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">域名管理密码：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="domainPWD" maxlength=32 size="20" value="<%=domainPWD%>">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">用户名：</td>
            <td class="tdbg"> 
              <input style="font-size: 9pt" type="text" name="UserName" maxlength=32 size="20" onBlur="this.form.Submit.value='';this.form.submit();" value="<%=UserName%>">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">扣款金额：</td>
            <td class="tdbg"> 
              <input type="text" name="Price" maxlength="10" size="5" value="<%=Price%>">
              注意，现在的扣款金额是:<font color=red><%=Price%></font> 
              <input type="hidden" name="simulate_price" value="0">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">注册时间：</td>
            <td class="tdbg"> 
              <INPUT TYPE="text" NAME="rsbdate" SIZE="15" MAXLENGTH="15" VALUE="<%=rsbdate%>" onClick="getDateString(this,oCalendarChs)">
            </td>
          </tr>
          <tr> 
            <td align="right" class="tdbg">年限：</td>
            <td class="tdbg"> 
              <INPUT TYPE="text" NAME="period" SIZE="5" MAXLENGTH="2" VALUE="<%=period%>">
            </td>
          </tr>
        </table>
              
      </td>
</tr> <tr> <td valign="top"><br>
  <table width="100%" border=0 cellpadding="3" cellspacing="0"> 
<tr> <td width="19%" align="right" class="tdbg">域名所有者：</td>
<td width="81%" class="tdbg">  <input type="text" name="dom_org" maxlength="50" size="20" value="<%=dom_org%>"></td></tr> <tr> <td align="right" class="tdbg">姓：</td>
<td class="tdbg">  <input type="text" name="dom_ln" maxlength="30" size="20" value="<%=dom_ln%>"></td></tr> <tr> <td align="right" class="tdbg">名：</td>
<td class="tdbg">  <input type="text" name="dom_fn" maxlength="30" size="20" value="<%=dom_fn%>"></td></tr> <tr> <td align="right" class="tdbg">国家代码：</td>
<td class="tdbg"> 
  <select name="dom_co" style="width:170pt"> 
    <%           
										  if dom_co ="" then
										  %> 
    <option value="cn"  selected>China</option> 
    <%
										   else
										 %> 
    <option value="<%=dom_co%>"  selected><%=dom_co%></option> 
    <%
										 end if
										 %> 
    <option value="ac">Ascension Island</option> 
    <option value="ad">Andorra</option> 
    <option value="ae">United Arab Emirates</option> 
    <option value="af">Afghanistan</option> 
    <option value="ag">Antigua and Barbuda</option> 
    <option value="ai">Anguilla</option> 
    <option value="al">Albania</option> 
    <option value="am">Armenia</option> 
    <option value="an">Netherlands 
      Antilles</option> 
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
    <option value="cd">Congo, 
      Democratic Republic of the</option> 
    <option value="cf">Central African Republic</option> 
    <option value="cg">Congo, Republic of</option> 
    <option value="ch">Switzerland</option> 
    <option value="ci">Cote d'Ivoire</option> 
    <option value="ck">Cook Islands</option> 
    <option value="cl">Chile</option> 
    <option value="cm">Cameroon</option> 
    <option value="cn" >China</option> 
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
    <option value="fo">Faroe 
      Islands</option> 
    <option value="fr">France</option> 
    <option value="ga">Gabon</option> 
    <option value="gd">Grenada</option> 
    <option value="ge">Georgia</option> 
    <option value="gf">French 
      Guiana</option> 
    <option value="gg">Guernsey</option> 
    <option value="gh">Ghana</option> 
    <option value="gi">Gibraltar</option> 
    <option value="gl">Greenland</option> 
    <option value="gm">Gambia</option> 
    <option value="gn">Guinea</option> 
    <option value="gp">Guadeloupe</option> 
    <option value="gq">Equatorial 
      Guinea</option> 
    <option value="gr">Greece</option> 
    <option value="gs">South Georgia 
      and the South Sandwich Islands</option> 
    <option value="gt">Guatemala</option> 
    <option value="gu">Guam</option> 
    <option value="gw">Guinea-Bissau</option> 
    <option value="gy">Guyana</option> 
    <option value="hk">Hong Kong</option> 
    <option value="hm">Heard and McDonald Islands</option> 
    <option value="hn">Honduras</option> 
    <option value="hr">Croatia/Hrvatska</option> 
    <option value="ht">Haiti</option> 
    <option value="hu">Hungary</option> 
    <option value="id">Indonesia</option> 
    <option value="ie">Ireland</option> 
    <option value="il">Israel</option> 
    <option value="im">Isle 
      of Man</option> 
    <option value="in">India</option> 
    <option value="io">British Indian 
      Ocean Territory</option> 
    <option value="iq">Iraq</option> 
    <option value="ir">Iran 
      (Islamic Republic of)</option> 
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
    <option value="kp">Korea, Democratic 
      People's Republic</option> 
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
    <option value="mo">Macau</option> 
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
    <option value="nc">New 
      Caledonia</option> 
    <option value="ne">Niger</option> 
    <option value="nf">Norfolk 
      Island</option> 
    <option value="ng">Nigeria</option> 
    <option value="ni">Nicaragua</option> 
    <option value="nl">Netherlands</option> 
    <option value="no">Norway</option> 
    <option value="np">Nepal</option> 
    <option value="nr">Nauru</option> 
    <option value="nu">Niue</option> 
    <option value="nz">New 
      Zealand</option> 
    <option value="om">Oman</option> 
    <option value="pa">Panama</option> 
    <option value="pe">Peru</option> 
    <option value="pf">French Polynesia</option> 
    <option value="pg">Papua New Guinea</option> 
    <option value="ph">Philippines</option> 
    <option value="pk">Pakistan</option> 
    <option value="pl">Poland</option> 
    <option value="pm">St. 
      Pierre and Miquelon</option> 
    <option value="pn">Pitcairn Island</option> 
    <option value="pr">Puerto 
      Rico</option> 
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
    <option value="sk">Slovak 
      Republic</option> 
    <option value="sl">Sierra Leone</option> 
    <option value="sm">San 
      Marino</option> 
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
    <option value="tw">Taiwan</option> 
    <option value="tz">Tanzania</option> 
    <option value="ua">Ukraine</option> 
    <option value="ug">Uganda</option> 
    <option value="uk">United Kingdom</option> 
    <option value="um">US Minor Outlying Islands</option> 
    <option value="us">United 
      States</option> 
    <option value="uy">Uruguay</option> 
    <option value="uz">Uzbekistan</option> 
    <option value="va">Holy See (City Vatican State)</option> 
    <option value="vc">Saint 
      Vincent and the Grenadines</option> 
    <option value="ve">Venezuela</option> 
    <option value="vg">Virgin 
      Islands (British)</option> 
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
  </select></td></tr> <tr> <td align="right" class="tdbg">省份：</td>
<td class="tdbg"> 
<input type="text" name="dom_st" maxlength="40" size="20" value="<%=dom_st%>"> 
(请填英文或拼音) </td></tr> <tr> <td align="right" class="tdbg">城市：</td>
<td class="tdbg"> 
<input type="text" name="dom_ct" maxlength="30" size="20" value="<%=dom_ct%>"> 
(请填英文或拼音) </td></tr> <tr> <td align="right" class="tdbg">地址：</td>
<td class="tdbg"> 
<input type="text" name="dom_adr1" maxlength="120" size="20" value="<%=dom_adr1%>"> 
(请填英文或拼音) </td></tr> <tr> <td align="right" class="tdbg">邮编：</td>
<td class="tdbg">  <input type="text" name="dom_pc" size="20" value="<%=dom_pc%>"></td></tr> <tr> <td align="right" class="tdbg">电话：</td>
<td class="tdbg">  <input type="text" name="dom_ph" size="20" value="<%=dom_ph%>"></td></tr> <tr> <td align="right" class="tdbg">传真：</td>
<td class="tdbg">  <input type="text" name="dom_fax" size="20" value="<%=dom_fax%>"></td></tr> <td align="right" class="tdbg">电子邮件：</td>
<td class="tdbg">  <input type="text" name="dom_em" size="20" value="<%=dom_em%>"></td></tr> </table>
  <br>
  <table width="100%" border="0" cellspacing="0" cellpadding="3">
    <tr>
      <td width="19%" class="tdbg">&nbsp;</td>
      <td width="81%" class="tdbg"><input type="submit" name="Submit" value="　域名转入　">
        <br></td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </table>
  </td>
</tr> 
</form></table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
