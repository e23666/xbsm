<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><HEAD><TITLE>��������</TITLE>
<meta name="description" content="���ڴ������������,רҵ�ṩ��������,����ע��,��ҵ�ʾ�,��վ�ƹ�,����ʵ������ҵ��������֧������֧����ʵʱע�ᣬʵʱ��ͨ����������"><meta name="keywords" content="��������,��ҳ����,����ע��,����,��ҵ�ʾ�,��ҳ�ռ�,������ҳ,����ʵ��,�����й�,��վ����,����"><META content="text/html; charset=gb2312" http-equiv=Content-Type>


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