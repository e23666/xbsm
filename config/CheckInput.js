function CheckInput(companyname) {
var s_comfirm='����ȷ����ť�󽫿�ʼע��; �������ע��ɹ�,���������ʻ��п۳���Ӧ�Ŀ���. '
//var s_comfirm='Click the Submit button for registrating so that responsibile item will be costed from your account';
if (!document.domainreg.agreement.checked)
{
	alert('����δ�Ķ�������'+companyname+'������ע��Э��.');
	return false;
}
if (document.domainreg.strDomain.value.length<1)
{
alert('��������Ϊ��');
document.domainreg.strDomain.focus();
return false;
}
if (document.domainreg.strDomainpwd.value.length<1)
{
alert('�������벻��Ϊ��');
document.domainreg.strDomainpwd.focus();
return false;
}
if (document.domainreg.admi_pc.value.length<1)
{
alert('�ʱ಻��Ϊ��');
document.domainreg.admi_pc.focus();
return false;
}
if (document.domainreg.years.value.length<1)
{
alert('���޲���Ϊ��');
document.domainreg.years.focus();
return false;
}
if (document.domainreg.dom_ln.value.length<1)
{
alert('��������Ϊ��');
document.domainreg.dom_ln.focus();
return false;
}
if (document.domainreg.admi_fax.value.length<6)
{
alert('���治��Ϊ��,���ұ������6λ�ַ�');
document.domainreg.admi_fax.focus();
return false;
}
if (document.domainreg.tech_fn.value.length<2)
{
alert('�ղ���Ϊ��,�������2�ַ�');
document.domainreg.tech_fn.focus();
return false;
}
if (document.domainreg.tech_ph.value.length<6)
{
alert('�绰����Ϊ��,���ұ������6λ�ַ�');
document.domainreg.tech_ph.focus();
return false;
}
if (document.domainreg.bill_ct.value.length<5)
{
alert('���в���Ϊ��,���ұ������5λ�ַ�');
document.domainreg.bill_ct.focus();
return false;
}
if (document.domainreg.bill_em.value.length<1)
{
alert('�ʼ�����Ϊ��');
document.domainreg.bill_em.focus();
return false;
}
if (document.domainreg.dns_host1.value.length<1)
{
alert('dns����������Ϊ��');
document.domainreg.dns_host1.focus();
return false;
}
if (document.domainreg.dns_host2.value.length<1)
{
alert('dns����������Ϊ��');
document.domainreg.dns_host2.focus();
return false;
}
if (document.domainreg.dom_fn.value.length<2)
{
alert('�ղ���Ϊ��,���ұ������2���ַ�');
document.domainreg.dom_fn.focus();
return false;
}
if (document.domainreg.admi_co.value.length<1)
{
alert('���Ҳ���Ϊ��');
document.domainreg.admi_co.focus();
return false;
}
if (document.domainreg.bill_ln.value.length<2)
{
alert('������Ϊ��,������ڵ���2���ַ�');
document.domainreg.bill_ln.focus();
return false;
}
if (document.domainreg.bill_fax.value.length<6)
{
alert('���治��Ϊ��,����С��6�ַ�');
document.domainreg.bill_fax.focus();
return false;
}
if (document.domainreg.dns_ip1.value.length<1)
{
alert('����������IP����Ϊ��');
document.domainreg.dns_ip1.focus();
return false;
}
if (document.domainreg.dom_fax.value.length<6)
{
alert('���治��Ϊ�ջ�����6�ַ�');
document.domainreg.dom_fax.focus();
return false;
}
if (document.domainreg.admi_fn.value.length<2)
{
alert('�ղ���Ϊ�ջ�����2�ַ�');
document.domainreg.admi_fn.focus();
return false;
}
if (document.domainreg.admi_ph.value.length<6)
{
alert('�绰����Ϊ��,������6�ַ�');
document.domainreg.admi_ph.focus();
return false;
}
if (document.domainreg.tech_st.value.length<5)
{
alert('ʡ�ݲ���Ϊ��,��С��5�ַ�');
document.domainreg.tech_st.focus();
return false;
}
if (document.domainreg.tech_fax.value.length<6)
{
alert('���治��Ϊ��,��С��6�ַ�');
document.domainreg.tech_fax.focus();
return false;
}
if (document.domainreg.dns_ip2.value.length<1)
{
alert('����������IP����Ϊ�ղ���Ϊ��');
document.domainreg.dns_ip2.focus();
return false;
}
if (document.domainreg.admi_ct.value.length<5)
{
alert('���в���Ϊ��,��С��5�ַ�');
document.domainreg.admi_ct.focus();
return false;
}
if (document.domainreg.admi_em.value.length<1)
{
alert('�ʼ�����Ϊ��');
document.domainreg.admi_em.focus();
return false;
}
if (document.domainreg.dom_org.value.length<4)
{
alert('���������߲���Ϊ�գ���С��4�ַ�,���Ҳ���Ϊ����');
document.domainreg.dom_org.focus();
return false;
}
if (document.domainreg.admi_st.value.length<5)
{
alert('ʡ�ݲ���Ϊ�գ���С��5�ַ�');
document.domainreg.admi_st.focus();
return false;
}
if (document.domainreg.dom_co.value.length<1)
{
alert('���Ҳ���Ϊ��');
document.domainreg.dom_co.focus();
return false;
}
if (document.domainreg.dom_ph.value.length<6)
{
alert('�绰����Ϊ�գ���С��6�ַ�');
document.domainreg.dom_ph.focus();
return false;
}
if (document.domainreg.tech_pc.value.length<6)
{
alert('�ʱ಻��Ϊ��,����Ӧ����6λ');
document.domainreg.tech_pc.focus();
return false;
}
if (document.domainreg.bill_co.value.length<1)
{
alert('���Ҳ���Ϊ��');
document.domainreg.bill_co.focus();
return false;
}
if (document.domainreg.agreement.value.length<1)
{
alert('��δͬ������ע��Э��');
document.domainreg.agreement.focus();
return false;
}
if (document.domainreg.dom_st.value.length<5)
{
alert('ʡ�ݲ���Ϊ��,���Ҳ��ܵ���5λ');
document.domainreg.dom_st.focus();
return false;
}
if (document.domainreg.dom_pc.value.length<6)
{
alert('�ʱ಻��Ϊ��,��Ϊ6λ');
document.domainreg.dom_pc.focus();
return false;
}
if (document.domainreg.dom_ct.value.length<5)
{
alert('���в���Ϊ��,��Ϊ5λ����');
document.domainreg.dom_ct.focus();
return false;
}
if (document.domainreg.dom_adr1.value.length<6)
{
alert('��ַ����Ϊ��,����Ӧ����6���ַ�����');
document.domainreg.dom_adr1.focus();
return false;
}
if (document.domainreg.dom_em.value.length<1)
{
alert('�ʾֲ���Ϊ��');
document.domainreg.dom_em.focus();
return false;
}
if (document.domainreg.tech_co.value.length<1)
{
alert('���Ҳ���Ϊ��');
document.domainreg.tech_co.focus();
return false;
}
if (document.domainreg.bill_pc.value.length<6)
{
alert('�ʱ಻��Ϊ��,��Ϊ6λ');
document.domainreg.bill_pc.focus();
return false;
}
if (document.domainreg.admi_ln.value.length<2)
{
alert('������Ϊ��,��Ӧ2���ַ�����');
document.domainreg.admi_ln.focus();
return false;
}
if (document.domainreg.admi_adr1.value.length<6)
{
alert('��ַ����Ϊ��,������6���ַ�');
document.domainreg.admi_adr1.focus();
return false;
}
if (document.domainreg.tech_ct.value.length<4)
{
alert('���в���Ϊ��,������4λ');
document.domainreg.tech_ct.focus();
return false;
}
if (document.domainreg.tech_em.value.length<6)
{
alert('�ʾֲ���Ϊ��,��Ϊ6λ');
document.domainreg.tech_em.focus();
return false;
}
if (document.domainreg.bill_st.value.length<5)
{
alert('ʡ�ݲ���Ϊ��,��5λ����');
document.domainreg.bill_st.focus();
return false;
}
if (document.domainreg.bill_ph.value.length<6)
{
alert('�绰����Ϊ��,��6���ַ�����');
document.domainreg.bill_ph.focus();
return false;
}
if (document.domainreg.tech_ln.value.length<2)
{
alert('������Ϊ��,�������ַ�����');
document.domainreg.tech_ln.focus();
return false;
}
if (document.domainreg.tech_adr1.value.length<6)
{
alert('��ַ����Ϊ��,��6λ����');
document.domainreg.tech_adr1.focus();
return false;
}
if (document.domainreg.bill_fn.value.length<2)
{
alert('�ղ���Ϊ�գ���2���ַ�����');
document.domainreg.bill_fn.focus();
return false;
}
if (document.domainreg.bill_adr1.value.length<6)
{
alert('��ַ����Ϊ��,��6λ����');
document.domainreg.bill_adr1.focus();
return false;
}
if(document.domainreg.dom_org.value.length > 50)
{
	alert('���������� ���Ȳ��ܳ���50');
	document.domainreg.dom_org.focus();
	return false;
}
bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,()@&!'";
for(i = 0; i < document.domainreg.dom_org.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_org.value.substring(i,i+1))==-1)
	{
		alert('���������� ֻ�ܰ�����ĸ���ֺ�-.,()\@&!');
		document.domainreg.dom_org.focus();
		return false;
	}
}

if(document.domainreg.dom_ln.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.dom_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.dom_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ln.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.dom_ln.focus();
		return false;
	}
}

if(document.domainreg.dom_fn.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.dom_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.dom_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_fn.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.dom_fn.focus();
		return false;
	}
}

if(document.domainreg.admi_ln.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.admi_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ln.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.admi_ln.focus();
		return false;
	}
}

if(document.domainreg.admi_fn.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.admi_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_fn.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.admi_fn.focus();
		return false;
	}
}

if(document.domainreg.tech_ln.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.tech_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ln.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.tech_ln.focus();
		return false;
	}
}

if(document.domainreg.tech_fn.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.tech_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_fn.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.tech_fn.focus();
		return false;
	}
}

if(document.domainreg.bill_ln.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.bill_ln.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_ln.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ln.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.bill_ln.focus();
		return false;
	}
}

if(document.domainreg.bill_fn.value.length > 30)
{
	alert('�� ���Ȳ��ܳ���30');
	document.domainreg.bill_fn.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_fn.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_fn.value.substring(i,i+1))==-1)
	{
		alert('�� ֻ�ܰ�����ĸ���ֺ�-.,()@&!');
		document.domainreg.bill_fn.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
if(document.domainreg.admi_co.value.length < 2)
{
	alert('���Ҵ��� ��λ��ĸ ��: cn');
	document.domainreg.admi_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.admi_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_co.value.substring(i,i+1))==-1)
	{
		alert('���Ҵ��� ��λ��ĸ ��: cn');
		document.domainreg.admi_co.focus();
		return false;
	}
}

if(document.domainreg.tech_co.value.length < 2)
{
	alert('���Ҵ��� ��λ��ĸ ��: cn');
	document.domainreg.tech_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.tech_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_co.value.substring(i,i+1))==-1)
	{
		alert('���Ҵ��� ��λ��ĸ ��: cn');
		document.domainreg.tech_co.focus();
		return false;
	}
}

if(document.domainreg.bill_co.value.length < 2)
{
	alert('���Ҵ��� ��λ��ĸ ��: cn');
	document.domainreg.bill_co.focus();
	return false;
}
for(i = 0; i < document.domainreg.bill_co.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_co.value.substring(i,i+1))==-1)
	{
		alert('���Ҵ��� ��λ��ĸ ��: cn');
		document.domainreg.bill_co.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,#*@/&";
for(i = 0; i < document.domainreg.dom_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_adr1.value.substring(i,i+1))==-1)
	{
		alert('��ַ ֻ�ܰ�����ĸ���ֺ�- . , # * @ / & �ո� ��ַ���̫���Ļ���ע�ⵥ�ʼ��ʵ������ո�');
		document.domainreg.dom_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_adr1.value.substring(i,i+1))==-1)
	{
		alert('��ַ ֻ�ܰ�����ĸ���ֺ�- . , # * @ / & �ո� ��ַ���̫���Ļ���ע�ⵥ�ʼ��ʵ������ո�');
		document.domainreg.admi_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_adr1.value.substring(i,i+1))==-1)
	{
		alert('��ַ ֻ�ܰ�����ĸ���ֺ�- . , # * @ / & �ո� ��ַ���̫���Ļ���ע�ⵥ�ʼ��ʵ������ո�');
		document.domainreg.tech_adr1.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_adr1.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_adr1.value.substring(i,i+1))==-1)
	{
		alert('��ַ ֻ�ܰ�����ĸ���ֺ�- . , # * @ / & �ո� ��ַ���̫���Ļ���ע�ⵥ�ʼ��ʵ������ո�');
		document.domainreg.bill_adr1.focus();
		return false;
	}
}

bString = "0123456789,.+()/-&";
for(i = 0; i < document.domainreg.dom_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ph.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.dom_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.dom_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_fax.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.dom_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ph.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.admi_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_fax.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.admi_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ph.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.tech_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_fax.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.tech_fax.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_ph.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ph.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.bill_ph.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_fax.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_fax.value.substring(i,i+1))==-1)
	{
		alert('�绰���� ֻ�ܰ������ֺ�,.+()/-&');
		document.domainreg.bill_fax.focus();
		return false;
	}
}

bString = "0123456789-*";
for(i = 0; i < document.domainreg.dom_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_pc.value.substring(i,i+1))==-1)
	{
		alert('�ʱ� ֻ�ܰ�������-*');
		document.domainreg.dom_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_pc.value.substring(i,i+1))==-1)
	{
		alert('�ʱ� ֻ�ܰ�������-*');
		document.domainreg.admi_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_pc.value.substring(i,i+1))==-1)
	{
		alert('�ʱ� ֻ�ܰ�������-*');
		document.domainreg.tech_pc.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_pc.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_pc.value.substring(i,i+1))==-1)
	{
		alert('�ʱ� ֻ�ܰ�������-*');
		document.domainreg.bill_pc.focus();
		return false;
	}
}

bString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -.,\'";
for(i = 0; i < document.domainreg.dom_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_st.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.dom_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.dom_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.dom_ct.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.dom_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_st.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.admi_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.admi_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.admi_ct.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.admi_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_st.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.tech_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.tech_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.tech_ct.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.tech_ct.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_st.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_st.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.bill_st.focus();
		return false;
	}
}

for(i = 0; i < document.domainreg.bill_ct.value.length; i ++)
{
	if (bString.indexOf(document.domainreg.bill_ct.value.substring(i,i+1))==-1)
	{
		alert('ʡ�ݳ��� ֻ�ܰ�����ĸ���� -.,�Ϳո�');
		document.domainreg.bill_ct.focus();
		return false;
	}
}


//return confirm(s_comfirm);
return true;
}
