function CheckInput(companyname) {
var s_comfirm='按下确定按钮后将开始注册; 如果域名注册成功,将从您的帐户中扣除相应的款项. '
//var s_comfirm='Click the Submit button for registrating so that responsibile item will be costed from your account';
if (!document.domainreg.agreement.checked)
{
	alert('您尚未阅读并接受'+companyname+'的域名注册协议.');
	return false;
}
if (document.domainreg.strDomain.value.length<1)
{
alert('域名不能为空');
document.domainreg.strDomain.focus();
return false;
}
if (document.domainreg.strDomainpwd.value.length<1)
{
alert('域名密码不能为空');
document.domainreg.strDomainpwd.focus();
return false;
}
if (document.domainreg.admi_pc.value.length<1)
{
alert('邮编不能为空');
document.domainreg.admi_pc.focus();
return false;
}
if (document.domainreg.years.value.length<1)
{
alert('年限不能为空');
document.domainreg.years.focus();
return false;
}
if (document.domainreg.dom_ln.value.length<1)
{
alert('域名不能为空');
document.domainreg.dom_ln.focus();
return false;
}
if (document.domainreg.admi_fax.value.length<6)
{
alert('传真不能为空,并且必须大于6位字符');
document.domainreg.admi_fax.focus();
return false;
}
if (document.domainreg.tech_fn.value.length<2)
{
alert('姓不能为空,必须大于2字符');
document.domainreg.tech_fn.focus();
return false;
}
if (document.domainreg.tech_ph.value.length<6)
{
alert('电话不能为空,并且必须大于6位字符');
document.domainreg.tech_ph.focus();
return false;
}
if (document.domainreg.bill_ct.value.length<5)
{
alert('城市不能为空,并且必须大于5位字符');
document.domainreg.bill_ct.focus();
return false;
}
if (document.domainreg.bill_em.value.length<1)
{
alert('邮件不能为空');
document.domainreg.bill_em.focus();
return false;
}
if (document.domainreg.dns_host1.value.length<1)
{
alert('dns服务器不能为空');
document.domainreg.dns_host1.focus();
return false;
}
if (document.domainreg.dns_host2.value.length<1)
{
alert('dns服务器不能为空');
document.domainreg.dns_host2.focus();
return false;
}
if (document.domainreg.dom_fn.value.length<2)
{
alert('姓不能为空,并且必须大于2个字符');
document.domainreg.dom_fn.focus();
return false;
}
if (document.domainreg.admi_co.value.length<1)
{
alert('国家不能为空');
document.domainreg.admi_co.focus();
return false;
}
if (document.domainreg.bill_ln.value.length<2)
{
alert('名不能为空,必须大于等于2个字符');
document.domainreg.bill_ln.focus();
return false;
}
if (document.domainreg.bill_fax.value.length<6)
{
alert('传真不能为空,不能小于6字符');
document.domainreg.bill_fax.focus();
return false;
}
if (document.domainreg.dns_ip1.value.length<1)
{
alert('域名服务器IP不能为空');
document.domainreg.dns_ip1.focus();
return false;
}
if (document.domainreg.dom_fax.value.length<6)
{
alert('传真不能为空或少于6字符');
document.domainreg.dom_fax.focus();
return false;
}
if (document.domainreg.admi_fn.value.length<2)
{
alert('姓不能为空或少于2字符');
document.domainreg.admi_fn.focus();
return false;
}
if (document.domainreg.admi_ph.value.length<6)
{
alert('电话不能为空,或少于6字符');
document.domainreg.admi_ph.focus();
return false;
}
if (document.domainreg.tech_st.value.length<5)
{
alert('省份不能为空,或小于5字符');
document.domainreg.tech_st.focus();
return false;
}
if (document.domainreg.tech_fax.value.length<6)
{
alert('传真不能为空,或小于6字符');
document.domainreg.tech_fax.focus();
return false;
}
if (document.domainreg.dns_ip2.value.length<1)
{
alert('域名服务器IP不能为空不能为空');
document.domainreg.dns_ip2.focus();
return false;
}
if (document.domainreg.admi_ct.value.length<5)
{
alert('城市不能为空,或小于5字符');
document.domainreg.admi_ct.focus();
return false;
}
if (document.domainreg.admi_em.value.length<1)
{
alert('邮件不能为空');
document.domainreg.admi_em.focus();
return false;
}
if (document.domainreg.dom_org.value.length<4)
{
alert('域名所有者不能为空，或小于4字符,并且不能为中文');
document.domainreg.dom_org.focus();
return false;
}
if (document.domainreg.admi_st.value.length<5)
{
alert('省份不能为空，或小于5字符');
document.domainreg.admi_st.focus();
return false;
}
if (document.domainreg.dom_co.value.length<1)
{
alert('国家不能为空');
document.domainreg.dom_co.focus();
return false;
}
if (document.domainreg.dom_ph.value.length<6)
{
alert('电话不能为空，或小于6字符');
document.domainreg.dom_ph.focus();
return false;
}
if (document.domainreg.tech_pc.value.length<6)
{
alert('邮编不能为空,并且应该是6位');
document.domainreg.tech_pc.focus();
return false;
}
if (document.domainreg.bill_co.value.length<1)
{
alert('国家不能为空');
document.domainreg.bill_co.focus();
return false;
}
if (document.domainreg.agreement.value.length<1)
{
alert('你未同意域名注册协议');
document.domainreg.agreement.focus();
return false;
}
if (document.domainreg.dom_st.value.length<5)
{
alert('省份不能为空,并且不能低于5位');
document.domainreg.dom_st.focus();
return false;
}
if (document.domainreg.dom_pc.value.length<6)
{
alert('邮编不能为空,且为6位');
document.domainreg.dom_pc.focus();
return false;
}
if (document.domainreg.dom_ct.value.length<5)
{
alert('城市不能为空,且为5位以上');
document.domainreg.dom_ct.focus();
return false;
}
if (document.domainreg.dom_adr1.value.length<6)
{
alert('地址不能为空,并且应该在6个字符以上');
document.domainreg.dom_adr1.focus();
return false;
}
if (document.domainreg.dom_em.value.length<1)
{
alert('邮局不能为空');
document.domainreg.dom_em.focus();
return false;
}
if (document.domainreg.tech_co.value.length<1)
{
alert('国家不能为空');
document.domainreg.tech_co.focus();
return false;
}
if (document.domainreg.bill_pc.value.length<6)
{
alert('邮编不能为空,并为6位');
document.domainreg.bill_pc.focus();
return false;
}
if (document.domainreg.admi_ln.value.length<2)
{
alert('名不能为空,并应2个字符以上');
document.domainreg.admi_ln.focus();
return false;
}
if (document.domainreg.admi_adr1.value.length<6)
{
alert('地址不能为空,并大于6个字符');
document.domainreg.admi_adr1.focus();
return false;
}
if (document.domainreg.tech_ct.value.length<4)
{
alert('城市不能为空,并大于4位');
document.domainreg.tech_ct.focus();
return false;
}
if (document.domainreg.tech_em.value.length<6)
{
alert('邮局不能为空,且为6位');
document.domainreg.tech_em.focus();
return false;
}
if (document.domainreg.bill_st.value.length<5)
{
alert('省份不能为空,且5位以上');
document.domainreg.bill_st.focus();
return false;
}
if (document.domainreg.bill_ph.value.length<6)
{
alert('电话不能为空,且6个字符以上');
document.domainreg.bill_ph.focus();
return false;
}
if (document.domainreg.tech_ln.value.length<2)
{
alert('名不能为空,且两个字符以上');
document.domainreg.tech_ln.focus();
return false;
}
if (document.domainreg.tech_adr1.value.length<6)
{
alert('地址不能为空,且6位以上');
document.domainreg.tech_adr1.focus();
return false;
}
if (document.domainreg.bill_fn.value.length<2)
{
alert('姓不能为空，须2个字符以上');
document.domainreg.bill_fn.focus();
return false;
}
if (document.domainreg.bill_adr1.value.length<6)
{
alert('地址不能为空,须6位以上');
document.domainreg.bill_adr1.focus();
return false;
}
if(document.domainreg.dom_org.value.length > 50)
{
	alert('域名所有者 长度不能超过50');
	document.domainreg.dom_org.focus();
	return false;
}
bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,()@&!'";
for(i = 0; i < document.domainreg.dom_org.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_org.value.substring(i,i+1))==-1)
	{
		alert('域名所有者 只能包含字母数字和-.,()\@&!');
		document.domainreg.dom_org.focus();
		return false;
	}
}

if(document.domainreg.dom_ln.value.length > 30)
{
	alert('姓 长度不能超过30');
	document.domainreg.dom_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.dom_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ln.value.substring(i,i+1))==-1)
	{
		alert('姓 只能包含字母数字和-.,()@&!');
		document.domainreg.dom_ln.focus();
		return false;
	}
}

if(document.domainreg.dom_fn.value.length > 30)
{
	alert('名 长度不能超过30');
	document.domainreg.dom_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.dom_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_fn.value.substring(i,i+1))==-1)
	{
		alert('名 只能包含字母数字和-.,()@&!');
		document.domainreg.dom_fn.focus();
		return false;
	}
}

if(document.domainreg.admi_ln.value.length > 30)
{
	alert('姓 长度不能超过30');
	document.domainreg.admi_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ln.value.substring(i,i+1))==-1)
	{
		alert('姓 只能包含字母数字和-.,()@&!');
		document.domainreg.admi_ln.focus();
		return false;
	}
}

if(document.domainreg.admi_fn.value.length > 30)
{
	alert('名 长度不能超过30');
	document.domainreg.admi_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_fn.value.substring(i,i+1))==-1)
	{
		alert('名 只能包含字母数字和-.,()@&!');
		document.domainreg.admi_fn.focus();
		return false;
	}
}

if(document.domainreg.tech_ln.value.length > 30)
{
	alert('姓 长度不能超过30');
	document.domainreg.tech_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ln.value.substring(i,i+1))==-1)
	{
		alert('姓 只能包含字母数字和-.,()@&!');
		document.domainreg.tech_ln.focus();
		return false;
	}
}

if(document.domainreg.tech_fn.value.length > 30)
{
	alert('名 长度不能超过30');
	document.domainreg.tech_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_fn.value.substring(i,i+1))==-1)
	{
		alert('名 只能包含字母数字和-.,()@&!');
		document.domainreg.tech_fn.focus();
		return false;
	}
}

if(document.domainreg.bill_ln.value.length > 30)
{
	alert('姓 长度不能超过30');
	document.domainreg.bill_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ln.value.substring(i,i+1))==-1)
	{
		alert('姓 只能包含字母数字和-.,()@&!');
		document.domainreg.bill_ln.focus();
		return false;
	}
}

if(document.domainreg.bill_fn.value.length > 30)
{
	alert('名 长度不能超过30');
	document.domainreg.bill_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_fn.value.substring(i,i+1))==-1)
	{
		alert('名 只能包含字母数字和-.,()@&!');
		document.domainreg.bill_fn.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
if(document.domainreg.admi_co.value.length < 2)
{
	alert('国家代码 两位字母 例: cn');
	document.domainreg.admi_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_co.value.substring(i,i+1))==-1)
	{
		alert('国家代码 两位字母 例: cn');
		document.domainreg.admi_co.focus();
		return false;
	}
}

if(document.domainreg.tech_co.value.length < 2)
{
	alert('国家代码 两位字母 例: cn');
	document.domainreg.tech_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_co.value.substring(i,i+1))==-1)
	{
		alert('国家代码 两位字母 例: cn');
		document.domainreg.tech_co.focus();
		return false;
	}
}

if(document.domainreg.bill_co.value.length < 2)
{
	alert('国家代码 两位字母 例: cn');
	document.domainreg.bill_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_co.value.substring(i,i+1))==-1)
	{
		alert('国家代码 两位字母 例: cn');
		document.domainreg.bill_co.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,#*@/&";
for(i = 0; i < document.domainreg.dom_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_adr1.value.substring(i,i+1))==-1)
	{
		alert('地址 只能包含字母数字和- . , # * @ / & 空格 地址如果太长的话请注意单词间适当留个空格');
		document.domainreg.dom_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_adr1.value.substring(i,i+1))==-1)
	{
		alert('地址 只能包含字母数字和- . , # * @ / & 空格 地址如果太长的话请注意单词间适当留个空格');
		document.domainreg.admi_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_adr1.value.substring(i,i+1))==-1)
	{
		alert('地址 只能包含字母数字和- . , # * @ / & 空格 地址如果太长的话请注意单词间适当留个空格');
		document.domainreg.tech_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_adr1.value.substring(i,i+1))==-1)
	{
		alert('地址 只能包含字母数字和- . , # * @ / & 空格 地址如果太长的话请注意单词间适当留个空格');
		document.domainreg.bill_adr1.focus();
		return false;
	}
}

bString = "0123456789,.+()/-&";
for(i = 0; i < document.domainreg.dom_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ph.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.dom_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.dom_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_fax.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.dom_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ph.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.admi_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_fax.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.admi_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ph.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.tech_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_fax.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.tech_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ph.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.bill_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_fax.value.substring(i,i+1))==-1)
	{
		alert('电话传真 只能包含数字和,.+()/-&');
		document.domainreg.bill_fax.focus();
		return false;
	}
}

bString = "0123456789-*";
for(i = 0; i < document.domainreg.dom_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_pc.value.substring(i,i+1))==-1)
	{
		alert('邮编 只能包含数字-*');
		document.domainreg.dom_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_pc.value.substring(i,i+1))==-1)
	{
		alert('邮编 只能包含数字-*');
		document.domainreg.admi_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_pc.value.substring(i,i+1))==-1)
	{
		alert('邮编 只能包含数字-*');
		document.domainreg.tech_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_pc.value.substring(i,i+1))==-1)
	{
		alert('邮编 只能包含数字-*');
		document.domainreg.bill_pc.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,\'";
for(i = 0; i < document.domainreg.dom_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_st.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.dom_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.dom_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ct.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.dom_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_st.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.admi_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ct.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.admi_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_st.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.tech_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ct.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.tech_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_st.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.bill_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ct.value.substring(i,i+1))==-1)
	{
		alert('省份城市 只能包含字母数字 -.,和空格');
		document.domainreg.bill_ct.focus();
		return false;
	}
}


//return confirm(s_comfirm);
return true;
}
