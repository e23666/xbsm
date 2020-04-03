<!--#include file="common.asp"-->
<!--#include virtual="/config/const.asp" -->
<%
Const NetName="虚拟主机域名注册-常见问题"        '站点名称
Const NetUrl="/"        '站点网址
Const Logo="<img src='/images/logo.jpg' border='0'>"        '站点LOGO
Const Ads="<img src='/images/westlogo.gif' border='0'>"        '顶部广告
Const Smtp="sendmail.asdfsfd.cn"        'SMTP Server地址
Const Email="webmaster@sadf3.com"        '管理员Email
Const accredit="{companyname}"        '授权信息
Const EmailFlag=1        '发送邮件组件
Const PageCount=10        '分页显示数
Const MaxFileSize=500        '上传文件大小限制
Const SaveUpFilesPath="Upfiles"        '存放上传文件的目录
Const UpFileType="gif,jpg,doc,swf,rar,zip,exe"        '允许的上传文件类型
Const AddAuditing=false        '是否开启审核功能
Const MenuFlag=true        '是否显示栏目下拉菜单
Const CssDir="image/skin/7/"          '前台样式设定
Const AddNewPic=true        '是否显示最新图片文章
Const AddNav=false        '是否显示文章栏目导航
Const AddComment=false        '是否显示文章评论功能
Const AddOpenWin="_self"        '文章浏览时是否弹开新窗口
Const AddWriter=true        '文章浏览时是否显示作者
Const AddScroll=true        '文章浏览时是否支持滚屏功能
Const AddFavorite=true        '文章浏览时是否显示加入收藏功能
Const AddPrint=true        '文章浏览时是否显示加入打印功能
Const AddClose=true        '文章浏览时是否显示加入关闭功能
Const AddPopedom=true        '文章浏览时是否支持权限浏览
Const copyright="Copyright (c) 2003-2008 All Rights Reserved."
'Const Version="NEWS Version"
Const kind=2        '首页调用类型
Const maxLen=29        '主题最多显示字数，字母算一个汉字算两个
Const listNum=10        '显示多少个文章标题
Const bullet="<img src='image/skin/1/bullet.gif' align=absmiddle>"        '标题前的图片或符号
Const hitColor="#FF0000"        '点击数的颜色
Const new_color="#FF0000"        '新文章日期的颜色
Const old_color="#999999"        '旧文章日期的颜色
Const showNclass=true        '是否显示栏目连接
Const DisPicico=true        '是否显示图文标志
Const regStatement="为维护网上公共秩序和社会稳定，请您自觉遵守以下条款： </P><P>                                                          一、不得利用本站危害国家安全、泄露国家秘密，不得侵犯国家社会集体的和公民的合法权益，不得利用本站制作、复制和传播下列信息：</P><P>                                                          （一）煽动抗拒、破坏宪法和法律、行政法规实施的；<BR>                                                          （二）煽动颠覆国家政权，推翻社会主义制度的；<BR>                                                          （三）煽动分裂国家、破坏国家统一的；<BR>                                                          （四）煽动民族仇恨、民族歧视，破坏民族团结的；<BR>                                                          （五）捏造或者歪曲事实，散布谣言，扰乱社会秩序的；<BR>                                                          （六）宣扬封建迷信、淫秽、色情、赌博、暴力、凶杀、恐怖、教唆犯罪的；<BR>                                                          （七）公然侮辱他人或者捏造事实诽谤他人的，或者进行其他恶意攻击的；<BR>                                                          （八）损害国家机关信誉的；<BR>                                                          （九）其他违反宪法和法律行政法规的；<BR>                                                          （十）进行商业广告行为的。 <BR>                                                          二、互相尊重，对自己的言论和行为负责。"     '会员注册信息
Const stopreg=true        '是否暂时停止会员注册
Const LoadFiles=true    '是否支持文件上传
Const Pwidth=135    '推荐文章图片宽度
Const Pheight=97    '推荐文章图片长度
%>