<%
'模板应用:
USEtemplate="Tpl_2016"

USEmanagerTpl="2"'用户管理中心模板设置
'log图片路径
logimgPath="/images/logo.gif"
' #组件设置
objName_FSO="scripting.filesystemobject" 'fso名称 
InstallDir="/" '站点安装路径
SystemAdminPath="/siteadmin" '后台管理路径


' #上级服务商api接口的配置信息：
api_url="http://api.west263.com/api/Agent_API/main.asp"
api_username="test"
api_password="test"
api_autoopen="domain, vhost, mail, mssql"  '自动通过api接口开通的业务种类。
api_open=True '是否为下级代理提供api接口，默认要提供。
vcp_c=False '是否允许用户申请vcp_C模式代理
vcp_d=False '是否允许用户申请vcp_D模式代理
Qustion_Upload="0102, 0103, 0104, 0201, 0202, 0203, 0302"

'系统信息
update_url="http://update.myhostadmin.net/"  '升级服务器的地址，一般不能修改。
version="v10.89"

'# 网站的一些基本信息配置
telphone="028-87654321 87654321"'联系电话
faxphone="028-87654321"'传真
company_Name="网站名称"'公司名称
companyname="网站名称"'网站名称
companynameurl="http://www.west.cn"'公司网址
nightphone="028-87654321"'夜间值班电话
agentmail="test@testcom"
supportmail="test@testcom"
salesmail="test@testcom"
jobmail="test@testcom"
companyaddress="您的办公地址"'地址
postcode="610031"'邮编
oicq="123456,1234567,12345678"'多个QQ号用逗号分隔
msn="test@testcom"
admindir="admin"  '后台管理目录 为了安全，您可以修改后台管理目录（默认为Admin），改过以后，需要再设置此处
fapiao_api=False  '是否由上级注册商提供发票。
fapiao_cost_0=5 '挂号信收费
fapiao_cost_1=20 '快递收费
fapiao_cost_2=0 '到付收费
fapiao_cost_3=2 '平信收费
fapiao_cost_leve=99999 '免费提供挂号/平信邮寄发票的最低金额
fapiao_cost_feilv="0.06" '设置代理平台开发票的费率
manager_url="http://www.myhostadmin.net/"  '独立管理平台的网址。

roomName="西部数码:四川,北京:北京" '机房名称替换


'#跟业务相关的一些配置信息：
reguser_level=1  '用户注册后的默认价格等级
demoprice=5 '试用主机费用
firstvpsdiscount="1" '独立IP主机首月折扣
demomssqlprice=5'试用mssql收费
demomailprice=15'试用邮局收费
whoisapi=1       '使用哪个域名查询接口。可选值1,2,3。
trainsin_domcom=80'COM英文
trainsin_domhz=108'国际中文
trainsin_domcn=68'CN英文
trainsin_domchina=320'国内中文
trainsin_domorg=80'国际ORG
reguser_try=True '新注册的用户能否直接开通试用主机。 true表示可以开，false表示需要管理员审核后才能开试用。




'# 下面是发邮件的参数
mailfrom="test@test.com"  
mailfrom_name=companyname
mailserverip="127.0.0.1"
mailserveruser="test@test.com" 
mailserverpassword="test"

'#关于短信发送的参数,购买的短信产品的邮局域名和邮局的管理密码。
sms_mailname="yourmail.com" '邮局名
sms_mailpwd="yourpass.com"  '邮局密码
sms_note=False '默认是否开启短信通知。短信通知用于：用户找回密码、过期续费通知等地方。

'#关于域名注册时的dns的配置：
ns1="ns1.myhostadmin.net"
ns1_ip="220.166.64.222"
ns2="ns2.myhostadmin.net"
ns2_ip="61.236.150.177"

'#关于在线支付接口的配置
defaultpay_url="http://alipay.west263.cn/manager/agentpay/SendOrder.asp"  '上级注册商的在线支付接口的地址
defaultpay=True    '是否使用上级注册商的支付接口
defaultpay_fy="0.00" '使用上级注册商的支付接口的费率

tenpay=False
tenpay_fy="0.00" '手续费率
tenpay_userid=""  '商户号
tenpay_userpass=""  '商户密钥

yeepay=False
yeepay_fy="0.01"  '手续费率
yeepay_userid=""  '商户号
yeepay_userpass=""  '商户密钥

alipay=False
alipay_fy="0.03"  '手续费率
alipaylog=False '支付宝快捷登陆开关
alipay_account=""  '支付宝帐号
alipay_userid="" '商户号
alipay_userpass=""  '商户密钥

cncard=False
cncard_fy="0.01"
cncard_cmid="" '云网商户编号
cncard_cpass="" '云网支付密钥

kuaiqian=False
kuaiqian_fy="0.00" '手续费率
kuaiqian_userid=""  '快钱商户号
kuaiqian_userpass=""  '商户密钥

kuaiqian2=False
kuaiqian2_fy="0.00" '手续费率
kuaiqian2_userid=""  '快钱商户号
kuaiqian2_userpass=""  '商户密钥
kuaiqian2_pid=""'快钱的合作伙伴的账户号

chinabank=False
chinabank_fy="0.01"
chinabank_cmid="" '网银商户编号
chinabank_cpass="" '网银支付密钥


strXMLFilePath="/database/siteMap.xml"
strXSLFilePath="/database/siteMap.xsl"

strXMLFile	= server.MapPath(strXMLFilePath)
strXSLFile	= server.MapPath(strXSLFilePath)

'# 以下是域名直接通过某注册商注册时需要的连接信息

using_dns_mgr=True '是否使用上级服务商的DNS管理器

xinet_uid="" '新网代理用户名
xinet_pwd="" '
xinet_allowmgr=True '是否允许获取管理密码

dnscn_uid="" '新网互联用户名
dnscn_pwd="" '新网互联连接密码
dnscn_allowmgr=True '是否允许获取管理密码

netcn_uid="" '万网id
netcn_pwd="" '万网密码
netcn_email="" '接口email
netcn_allowmgr=True '是否允许获取管理密码

bizcn_dns1="ns1.4everdns.com"
bizcn_dns2="ns2.4everdns.com"
bizcn_ip1="218.5.77.19"
bizcn_ip2="61.151.252.240"
bizcn_allowmgr=True '是否允许获取管理密码


midkeyServer="127.0.0.1" '商务中国中间件服务器IP地址
midkeyPort=8001 '商务中国中间件服务器端口

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
qq_returnUrl="" '回调地址http://网名地址/reg/returnQQ.asp
qq_isLogin=False  '是否允许登陆

alipayName="西部数码分销平台" '开通支付宝时在线支付显示名称

sendmailcc="" '邮件抄送地址设置后生效

issenddmjg=False      '域名价格显示

issendvhjg=False      '虚拟主机价格发送

issenddbjg=False      '数据库价格

issendvpsjg=False     '独立服务器续费价格发送

issendmailjg=False    '是否发送邮局续费

diyuserlev1="1.00" '弹性云主机总价折扣级别1
diyuserlev2="1.00" '弹性云主机总价折扣级别2
diyuserlev3="1.00" '弹性云主机总价折扣级别3
diyuserlev4="1.00" '弹性云主机总价折扣级别4
diyuserlev5="1.00" '弹性云主机总价折扣级别5
diyuserlev6="1.00" '弹性云主机总价折扣级别6
diyuserlev7="1.00" '弹性云主机总价折扣级别7

webmanagesrepwd="" '随机数

webmanagespwd="" 'password

vhost_ren_price=true '空间续费价格保护开关

diyfist="1" '针对按月支付首页折扣,如设置为1将不会生效

DomainTransfer="domcom,domcn,domnet,domhzcom,domhznet,domhzcn,domorg,domchina,domhk,domcc,chinacc,domwang"          '允许域名转入类型

shengpay=False          '盛付通帐是否启用
shengpay_fy="0.00"          '盛付通费率
shengpay_MerId="00000"          '盛付通帐帐号
shengpay_Md5Key="000000"          '盛付通密码

diyMlev1="1.00" 'DIY邮局总价折扣级别1
diyMlev2="1.00" 'DIY邮局总价折扣级别2
diyMlev3="1.00" 'DIY邮局总价折扣级别3
diyMlev4="1.00" 'DIY邮局总价折扣级别4
diyMlev5="1.00" 'DIY邮局总价折扣级别5

questionMail=""  ' 有问必答提示邮箱

diypaytestPrice="18"  '弹性云主机试用价格

diypaytestDLPrice="5"  '弹性云主机试用价格

showsafecode=true      '是否使用验证码!

isdbsql=false  ' 数据库类型

SqlUsername="sa"  ' 登陆帐号

SqlPassword=""  ' 登陆密码

SqlDatabaseName="AgentDb"  ' 数据库名称

SqlHostIP="."  ' 连接地址

chgroomipmoney="30"  ' 升级虚拟主机如有独立ip继续使用手续费

alipay_type=""         ' 支付宝支付类型

issetauthmobile=true      '是否开启实名认证

miniprogram_paytype_money="5"  '小程序试用价格
miniprogram_sms_money="0.15"     '小程序短信购买价格

mailport="25"  '邮局端口
mailssl="false"     '是否启用ssl

sendmailname="网站名称"  '发件人别名

wxpay=False '微信支付
wxpay_fy="0" '手续费
wxpay_appid="" 'wxappid
wxpay_MchID="" 'wxpay_MchID
wxpay_MchKey=""  '在 微信支付后台 \ 帐户中心 \ API安全，设置 API密钥 中设置
wxpay_callback="" '回调地址  /api/weixin/return.asp

diy_dis_6="1"  '弹性云多年折扣调整，6月折扣
diy_dis_12="1"  '弹性云多年折扣调整，1年折扣
diy_dis_24="1"  '弹性云多年折扣调整，2年折扣
diy_dis_36="1"  '弹性云多年折扣调整，3年折扣
diy_dis_60="1"  '弹性云多年折扣调整，5年折扣 

sms_type="west"  '短信接口类型
sms_url=""  '短信api接口地址

website_beianno=""  '网站备案号

vcp_vhost="0"    '虚拟主机vcp提成百分比
vcp_rennew_vhost="0" '
vcp_server="0"   '服务器vcp提成百分比
vcp_rennew_server="0" 
vcp_mail="0"	 '邮局vcp提成百分比 
vcp_rennew_mail="0" 



sms_sign="【西数】"    '短信签名
%>