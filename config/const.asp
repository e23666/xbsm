<%
'ģ��Ӧ��:
USEtemplate="Tpl_2016"

USEmanagerTpl="2"'�û���������ģ������
'logͼƬ·��
logimgPath="/images/logo.gif"
' #�������
objName_FSO="scripting.filesystemobject" 'fso���� 
InstallDir="/" 'վ�㰲װ·��
SystemAdminPath="/siteadmin" '��̨����·��


' #�ϼ�������api�ӿڵ�������Ϣ��
api_url="http://api.west263.com/api/Agent_API/main.asp"
api_username="test"
api_password="test"
api_autoopen="domain, vhost, mail, mssql"  '�Զ�ͨ��api�ӿڿ�ͨ��ҵ�����ࡣ
api_open=True '�Ƿ�Ϊ�¼������ṩapi�ӿڣ�Ĭ��Ҫ�ṩ��
vcp_c=False '�Ƿ������û�����vcp_Cģʽ����
vcp_d=False '�Ƿ������û�����vcp_Dģʽ����
Qustion_Upload="0102, 0103, 0104, 0201, 0202, 0203, 0302"

'ϵͳ��Ϣ
update_url="http://update.myhostadmin.net/"  '�����������ĵ�ַ��һ�㲻���޸ġ�
version="v10.89"

'# ��վ��һЩ������Ϣ����
telphone="028-87654321 87654321"'��ϵ�绰
faxphone="028-87654321"'����
company_Name="��վ����"'��˾����
companyname="��վ����"'��վ����
companynameurl="http://www.west.cn"'��˾��ַ
nightphone="028-87654321"'ҹ��ֵ��绰
agentmail="test@testcom"
supportmail="test@testcom"
salesmail="test@testcom"
jobmail="test@testcom"
companyaddress="���İ칫��ַ"'��ַ
postcode="610031"'�ʱ�
oicq="123456,1234567,12345678"'���QQ���ö��ŷָ�
msn="test@testcom"
admindir="admin"  '��̨����Ŀ¼ Ϊ�˰�ȫ���������޸ĺ�̨����Ŀ¼��Ĭ��ΪAdmin�����Ĺ��Ժ���Ҫ�����ô˴�
fapiao_api=False  '�Ƿ����ϼ�ע�����ṩ��Ʊ��
fapiao_cost_0=5 '�Һ����շ�
fapiao_cost_1=20 '����շ�
fapiao_cost_2=0 '�����շ�
fapiao_cost_3=2 'ƽ���շ�
fapiao_cost_leve=99999 '����ṩ�Һ�/ƽ���ʼķ�Ʊ����ͽ��
fapiao_cost_feilv="0.06" '���ô���ƽ̨����Ʊ�ķ���
manager_url="http://www.myhostadmin.net/"  '��������ƽ̨����ַ��

roomName="��������:�Ĵ�,����:����" '���������滻


'#��ҵ����ص�һЩ������Ϣ��
reguser_level=1  '�û�ע����Ĭ�ϼ۸�ȼ�
demoprice=5 '������������
firstvpsdiscount="1" '����IP���������ۿ�
demomssqlprice=5'����mssql�շ�
demomailprice=15'�����ʾ��շ�
whoisapi=1       'ʹ���ĸ�������ѯ�ӿڡ���ѡֵ1,2,3��
trainsin_domcom=80'COMӢ��
trainsin_domhz=108'��������
trainsin_domcn=68'CNӢ��
trainsin_domchina=320'��������
trainsin_domorg=80'����ORG
reguser_try=True '��ע����û��ܷ�ֱ�ӿ�ͨ���������� true��ʾ���Կ���false��ʾ��Ҫ����Ա��˺���ܿ����á�




'# �����Ƿ��ʼ��Ĳ���
mailfrom="test@test.com"  
mailfrom_name=companyname
mailserverip="127.0.0.1"
mailserveruser="test@test.com" 
mailserverpassword="test"

'#���ڶ��ŷ��͵Ĳ���,����Ķ��Ų�Ʒ���ʾ��������ʾֵĹ������롣
sms_mailname="yourmail.com" '�ʾ���
sms_mailpwd="yourpass.com"  '�ʾ�����
sms_note=False 'Ĭ���Ƿ�������֪ͨ������֪ͨ���ڣ��û��һ����롢��������֪ͨ�ȵط���

'#��������ע��ʱ��dns�����ã�
ns1="ns1.myhostadmin.net"
ns1_ip="220.166.64.222"
ns2="ns2.myhostadmin.net"
ns2_ip="61.236.150.177"

'#��������֧���ӿڵ�����
defaultpay_url="http://alipay.west263.cn/manager/agentpay/SendOrder.asp"  '�ϼ�ע���̵�����֧���ӿڵĵ�ַ
defaultpay=True    '�Ƿ�ʹ���ϼ�ע���̵�֧���ӿ�
defaultpay_fy="0.00" 'ʹ���ϼ�ע���̵�֧���ӿڵķ���

tenpay=False
tenpay_fy="0.00" '��������
tenpay_userid=""  '�̻���
tenpay_userpass=""  '�̻���Կ

yeepay=False
yeepay_fy="0.01"  '��������
yeepay_userid=""  '�̻���
yeepay_userpass=""  '�̻���Կ

alipay=False
alipay_fy="0.03"  '��������
alipaylog=False '֧������ݵ�½����
alipay_account=""  '֧�����ʺ�
alipay_userid="" '�̻���
alipay_userpass=""  '�̻���Կ

cncard=False
cncard_fy="0.01"
cncard_cmid="" '�����̻����
cncard_cpass="" '����֧����Կ

kuaiqian=False
kuaiqian_fy="0.00" '��������
kuaiqian_userid=""  '��Ǯ�̻���
kuaiqian_userpass=""  '�̻���Կ

kuaiqian2=False
kuaiqian2_fy="0.00" '��������
kuaiqian2_userid=""  '��Ǯ�̻���
kuaiqian2_userpass=""  '�̻���Կ
kuaiqian2_pid=""'��Ǯ�ĺ��������˻���

chinabank=False
chinabank_fy="0.01"
chinabank_cmid="" '�����̻����
chinabank_cpass="" '����֧����Կ


strXMLFilePath="/database/siteMap.xml"
strXSLFilePath="/database/siteMap.xsl"

strXMLFile	= server.MapPath(strXMLFilePath)
strXSLFile	= server.MapPath(strXSLFilePath)

'# ����������ֱ��ͨ��ĳע����ע��ʱ��Ҫ��������Ϣ

using_dns_mgr=True '�Ƿ�ʹ���ϼ������̵�DNS������

xinet_uid="" '���������û���
xinet_pwd="" '
xinet_allowmgr=True '�Ƿ������ȡ��������

dnscn_uid="" '���������û���
dnscn_pwd="" '����������������
dnscn_allowmgr=True '�Ƿ������ȡ��������

netcn_uid="" '����id
netcn_pwd="" '��������
netcn_email="" '�ӿ�email
netcn_allowmgr=True '�Ƿ������ȡ��������

bizcn_dns1="ns1.4everdns.com"
bizcn_dns2="ns2.4everdns.com"
bizcn_ip1="218.5.77.19"
bizcn_ip2="61.151.252.240"
bizcn_allowmgr=True '�Ƿ������ȡ��������


midkeyServer="127.0.0.1" '�����й��м��������IP��ַ
midkeyPort=8001 '�����й��м���������˿�

xinet_dns1="ns.xinnetdns.com"
xinet_dns2="ns.xinnet.cn"

xinet_mns="mns.xinnet.com"

dnscn_dns1="ns1.dns.com.cn"
dnscn_dns2="ns2.dns.com.cn"
dnscn_ip1="218.244.47.5"
dnscn_ip2="218.244.47.6"

netcn_dns1="dns15.hichina.com"
netcn_dns2="dns16.hichina.com"

default_dns1="ns1.myhostadmin.net"
default_dns2="ns2.myhostadmin.net"
default_ip1="183.131.155.224"
default_ip2="120.52.19.214"





qq_AppID="" 'app ID
qq_AppKey=""  'apPKey
qq_returnUrl="" '�ص���ַhttp://������ַ/reg/returnQQ.asp
qq_isLogin=False  '�Ƿ������½

alipayName="�����������ƽ̨" '��֧ͨ����ʱ����֧����ʾ����

sendmailcc="" '�ʼ����͵�ַ���ú���Ч

issenddmjg=False      '�����۸���ʾ

issendvhjg=False      '���������۸���

issenddbjg=False      '���ݿ�۸�

issendvpsjg=False     '�������������Ѽ۸���

issendmailjg=False    '�Ƿ����ʾ�����

diyuserlev1="1.00" '�����������ܼ��ۿۼ���1
diyuserlev2="1.00" '�����������ܼ��ۿۼ���2
diyuserlev3="1.00" '�����������ܼ��ۿۼ���3
diyuserlev4="1.00" '�����������ܼ��ۿۼ���4
diyuserlev5="1.00" '�����������ܼ��ۿۼ���5
diyuserlev6="1.00" '�����������ܼ��ۿۼ���6
diyuserlev7="1.00" '�����������ܼ��ۿۼ���7

webmanagesrepwd="" '�����

webmanagespwd="" 'password

vhost_ren_price=true '�ռ����Ѽ۸񱣻�����

diyfist="1" '��԰���֧����ҳ�ۿ�,������Ϊ1��������Ч

DomainTransfer="domcom,domcn,domnet,domhzcom,domhznet,domhzcn,domorg,domchina,domhk,domcc,chinacc,domwang"          '��������ת������

shengpay=False          'ʢ��ͨ���Ƿ�����
shengpay_fy="0.00"          'ʢ��ͨ����
shengpay_MerId="00000"          'ʢ��ͨ���ʺ�
shengpay_Md5Key="000000"          'ʢ��ͨ����

diyMlev1="1.00" 'DIY�ʾ��ܼ��ۿۼ���1
diyMlev2="1.00" 'DIY�ʾ��ܼ��ۿۼ���2
diyMlev3="1.00" 'DIY�ʾ��ܼ��ۿۼ���3
diyMlev4="1.00" 'DIY�ʾ��ܼ��ۿۼ���4
diyMlev5="1.00" 'DIY�ʾ��ܼ��ۿۼ���5

questionMail=""  ' ���ʱش���ʾ����

diypaytestPrice="18"  '�������������ü۸�

diypaytestDLPrice="5"  '�������������ü۸�

showsafecode=true      '�Ƿ�ʹ����֤��!

isdbsql=false  ' ���ݿ�����

SqlUsername="sa"  ' ��½�ʺ�

SqlPassword=""  ' ��½����

SqlDatabaseName="AgentDb"  ' ���ݿ�����

SqlHostIP="."  ' ���ӵ�ַ

chgroomipmoney="30"  ' ���������������ж���ip����ʹ��������

alipay_type=""         ' ֧����֧������

issetauthmobile=true      '�Ƿ���ʵ����֤

miniprogram_paytype_money="5"  'С�������ü۸�
miniprogram_sms_money="0.15"     'С������Ź���۸�

mailport="25"  '�ʾֶ˿�
mailssl="false"     '�Ƿ�����ssl

sendmailname="��վ����"  '�����˱���

wxpay=False '΢��֧��
wxpay_fy="0" '������
wxpay_appid="" 'wxappid
wxpay_MchID="" 'wxpay_MchID
wxpay_MchKey=""  '�� ΢��֧����̨ \ �ʻ����� \ API��ȫ������ API��Կ ������
wxpay_callback="" '�ص���ַ  /api/weixin/return.asp

diy_dis_6="1"  '�����ƶ����ۿ۵�����6���ۿ�
diy_dis_12="1"  '�����ƶ����ۿ۵�����1���ۿ�
diy_dis_24="1"  '�����ƶ����ۿ۵�����2���ۿ�
diy_dis_36="1"  '�����ƶ����ۿ۵�����3���ۿ�
diy_dis_60="1"  '�����ƶ����ۿ۵�����5���ۿ� 

sms_type="west"  '���Žӿ�����
sms_url=""  '����api�ӿڵ�ַ

website_beianno=""  '��վ������

vcp_vhost="0"    '��������vcp��ɰٷֱ�
vcp_rennew_vhost="0" '
vcp_server="0"   '������vcp��ɰٷֱ�
vcp_rennew_server="0" 
vcp_mail="0"	 '�ʾ�vcp��ɰٷֱ� 
vcp_rennew_mail="0" 



sms_sign="��������"    '����ǩ��
%>