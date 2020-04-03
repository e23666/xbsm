<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><HEAD><TITLE>帮助中心</TITLE>
<meta name="description" content="国内大型网络服务商,专业提供虚拟主机,域名注册,企业邮局,网站推广,网络实名等企业上网服务。支持在线支付，实时注册，实时开通，自主管理。"><meta name="keywords" content="虚拟主机,网页制作,域名注册,主机,企业邮局,主页空间,个人主页,网络实名,主机托管,网站建设,域名"><META content="text/html; charset=gb2312" http-equiv=Content-Type>


<%If LCase(USEtemplate)="tpl_2016" then%>
<link href="/template/Tpl_2016/css/faq.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/tp2016.css">
<link href="/template/Tpl_2016/css/Customercenter.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

</head>

<body class="min990">
<%else%>
<link href="/Template/Tpl_05/css/Global.css" rel="stylesheet" type="text/css">
<link href="/Template/Tpl_05/css/faq.css" rel="stylesheet" type="text/css">
<link href="/Template/Tpl_05/css/weiyanlover.css" rel="stylesheet" type="text/css">
</head>

<body id="thrColEls">
<div class="Style2009">

<%End if%>


<script language="JavaScript" type="text/JavaScript">
<!--

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<%
server.execute "/faq/top.asp"
%>