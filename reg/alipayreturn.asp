<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/alipay_class/alipay_notify.asp"-->
<!--#include virtual="/config/Template.inc.asp" -->
<%
conn.open constr
 
partner         = alipay_userid
key   			= alipay_userpass
return_url      = companynameurl & "/reg/alipayreturn.asp"
input_charset	= "gbk"
sign_type       = "MD5"

Set objNotify = New AlipayNotify
sVerifyResult = objNotify.VerifyReturn()

action=Requesta("action")
select case action
case "regsave"
regsave
case else
other()
end select


sub other()

If sVerifyResult Then

    user_id = requesta("user_id")	'支付宝用户id
    token	= requesta("token")		'授权令牌
	email =requesta("email")
	u_name=user_id
	if instr(email,"@")>0 then u_name=email
	
	session("token")=token
	Response.Cookies("token")=token
	sql="select * from userdetail where    alipay_userid='"& user_id &"'"
	rs.open sql,conn,1,3
	if rs.eof then
		'rs.close
		'conn.close
		'gowithwin "alipaywl.asp?token="& token	
		user_id = user_id	'支付宝用户id
		session("user_ID")=user_id
		'新用户填写基本资料
		%>
        
        
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>支付宝快速登陆注册</title>
<style>
/* common css ============================================== */
body{margin:0 auto;	text-align:center; font: 12px/1.5 arial; color:#242424; padding:0px;}
td{font-size:12px;}
div{text-align:left;}
:focus{outline:none;}
h4,h3,h2,h1{font-size:14px; margin:0;}
form,ul,ol,dl,dd,p{margin:0; padding:0;}
li{list-style-type:none;}
img{border:none; vertical-align:middle;}
button,input,select,textarea{font-size:1em;	margin:0; font-family:tahoma, arial, simsun, sans-serif; color:#484848;}
a{color:#f27f02; text-decoration:none;}
a:hover{text-decoration:underline;}
sup{vertical-align:text-top;}
sub{vertical-align:text-bottom;}
del{color:#686868;}
table{border-collapse:collapse; border-spacing:0;}
/* for font & text & tag =================================== */
.red{
	color:red!important;
}
.gray{
	color:#686868!important;
}
.hasDefaultText{color:#999;}
.orange{
	color:#f60!important;
}
.green{
	color:#79a605!important;
}
.blue{
	color:#0057b0!important;
}
b{font-weight:normal; display:inline-block; margin:0 8px; color:#f27f02;}
/* for margin & padding | width & height =================== */
.mb10{
	margin-bottom:10px;
}
.mb18{margin-bottom:18px;}
.mb22{margin-bottom:22px;}
.mt10{
	margin-top:10px;
}
.mr20{
	margin-right:20px;
}
.p10{padding:10px;}
.tl { text-align: left}
.tr { text-align: right}
.tc { text-align: center}
.ml10 {margin-left: 10px;}
.mr10 {margin-right: 10px;}
/* class css ============================ class css ======== */
.fl{
	float:left;
	display:inline;
}
.fr{
	float:right;
	display:inline;
}
.clear{clear:both; height:0; overflow:hidden;}
.lireset li {
    background: url("../images/arrow1.gif") no-repeat left 8px;
    margin-bottom: 4px;
    padding-left: 15px;
}
.lireset2 li {
    background: url("../images/arrow2.gif") no-repeat left 8px;
    margin-bottom: 4px;
    padding-left: 15px;
}
.download{
	padding:6px 0 6px 70px;
	line-height:26px;
	height:64px;
	font-size:16px;
	font-family:"microsoft yahei";
	background:url(../images/download.png) no-repeat;
}
.donate{
	padding:15px 5px 6px 72px;
	height:55px;
	width:213px;
	display:block;
	color:#8b6300;
	border:5px solid #F27F02;
	background:url(../images/donate.png) 3px center no-repeat #fae4ae;
}
.donate:hover{
	text-decoration:none;
	background-color:#fff79f;
}
/*--find height for float elements --------------------------*/
.cls:after{content:"";font-size:0;display:block;height:0;clear:both;visibility:hidden;}
* html .cls{ zoom: 1; } /* IE6 */
*:first-child+html .cls{ zoom: 1; } /* IE7 */

.wraper{
	width:100%;
	margin-left:auto;
	margin-right:auto;
}
.header{background:url(../images/header-bg.gif) repeat-x left bottom;}
.header h1 {
	font-size:34px;
	line-height:52px;
	font-weight:normal;
	padding:6px 0 8px 0;
}
.header h1 a{color:#fff;}
.header .wraper{height:72px; position:relative;}

.header .nav {
	position:absolute;
	right:-1px;
	top:0;
	font-family:"microsoft yahei";
}
.header .nav li {
	float:left;
}
.header .nav li a {
	font-size:20px;
	color:#fff;
	height:67px;
	line-height:67px;
	text-decoration:none;
	padding-left:15px;
	padding-right:15px;
	text-align:center;
	float:left;
	margin-right:1px;
	background:url(../images/navbg.gif) repeat-x;
}
.header .nav li a.current, .header .nav li a:hover {
	border-bottom:5px solid #f27f02;
}
.gallery{
	height:496px;
	overflow:hidden;
	background:url(../images/gallerry-bg.gif) 0 0 repeat-x #ccc;
	border-bottom:5px solid #EAEAEA; 
}
.gallery li{background-color:#fff; overflow:hidden;}
.roundabout-holder  { 
	width:646px;
	height:496px;
	margin:0 auto;
}
.roundabout-moveable-item {
	width: 646px;
	height: 416px;
	cursor: pointer;
	border:3px solid #ccc;
	border:3px solid rgba(255,255,255,0.5);
	border-radius:4px;
	-moz-border-radius:4px;
	-webkit-border-radius:4px;
}
.roundabout-moveable-item img{
	width:100%;
}
.roundabout-in-focus {
	cursor:default;
	border:3px solid rgba(255,255,255,0.8);
}
.main{background-color:#fff; color:#424242;line-height:22px;}
.aside{width:300px;}
.main h3,
.main h2{
	color: #212222;
    font-size:26px;
    font-weight: normal;
    line-height: 1.2em;
    margin-bottom: 22px;
	font-family:"microsoft yahei";
}
.main h3 span,
.main h2 span{
    color: #888;
}
.content{width:650px;}
.main p{
    margin-bottom: 18px;
}
.latestcomment li{max-height:36px; line-height:18px; overflow:hidden; margin-bottom:16px; color:#000;}
.latestcomment a{
	color:#8a8a8a;
	text-decoration:underline;
}
.latestcomment a:hover{text-decoration:none;}

.footer {
	color:#fff;
	height:20px;
	padding:20px 0 22px 0;
	border-top:5px solid #eee;
}

.commentlist cite, .commentlist em {
    font-style: normal;
}
.comment .tit {
    border-bottom: 1px dashed #CCCCCC;
    font-weight: bold;
    margin-bottom: 10px;
    padding-bottom: 6px;
}
.comment .tit span.gray {
    font-weight: normal;
}
.comment .comment-meta a{color:#999; cursor:default;}
.comment .comment-meta a:hover{text-decoration:none;}
.commentlist p {
    color: #333333;
    line-height: 23px;
    margin: 8px 0;
}
.commentlist li {
    color: #666666;
    float: none;
    height: auto;
    margin: 0;
    min-height: 50px;
    padding: 10px 10px 10px 72px;
    position: relative;
    width: 898px;
}
.commentlist li.graybg {
    background-color: #eee;
}
.commentlist li img {
    border: 1px solid #DDDDDD;
    height: 32px;
    left: 10px;
    padding: 4px;
    position: absolute;
    top: 13px;
    width: 32px;
}
.commentlist li .said {
    margin: 10px 0;
}
.sendcomment li {
    padding: 5px 0;
}
.sendcomment .inputxt {
    border: 1px solid #CCCCCC;
    padding: 5px;
    width: 230px;
}
.sendcomment textarea {
    border: 1px solid #CCCCCC;
    height: 160px;
    overflow: auto;
    padding: 5px;
    width: 566px;
}
.sendcomment .btn_sub {
    cursor: pointer;
    padding: 8px 20px;
}

.pagenav{
	padding:10px 0;
}
.pagenav a{
	display:inline-block;
	border:1px solid #ddd;
	padding:0 4px 1px;
}
.pagenav b{
	color:red;
}
.pagenav *{
	margin-right:6px;
}

.wp_syntax{margin-bottom:22px!important;}
.post p{margin-bottom:8px;}

.questionlist dt,
.questionlist dd{padding:3px 15px;}
.questionlist dt{
	margin-bottom:10px;
	background:url("../images/arrow1.gif") no-repeat 5px 12px;
}
.questionlist .now{margin-bottom:4px;}
.questionlist .now a{font-weight:bold; color:#f27f02}
.questionlist dt a{color:#79a605;}
.questionlist dd{display:none; background-color:#f1f1f1; padding:6px 15px 8px; margin-bottom:10px;}
.questionlist p{margin:8px 0;}
.fz12{font-size:12px;}
input{padding: 8px 20px; vertical-align:middle;}

.main h1,
.main h2,
.main h3{padding-left:10px;}
.main h1{text-align:center;color: #212222; font-family: "microsoft yahei"; font-size: 36px; font-weight: normal; line-height: 2em; margin-bottom: 36px;}
.main h2{background-color:#eee; line-height:2!important;}
.main h3{font-size:20px; margin-bottom:10px;}
.lireset2{padding-left:10px;}
.registerform{margin:0 10px 40px 10px;;}
.registerform .need{
	width:10px;
	color:#b20202;
}
.registerform td{
	padding:5px 0;
	vertical-align:top;
	text-align:left;
}
.registerform .inputxt,.registerform textarea{
	border:1px solid #a5aeb6;
	width:136px;
	padding:4px 2px;
}
.registerform textarea{
	height:75px;
}
.registerform label{
	margin:0 15px 0 4px;
}
.registerform .tip{
	line-height:20px;
	color:#5f6a72;
}
.registerform select{
	width:202px;
}
.registerformalter select{
	width:124px;
}
.swfupload{
	vertical-align:top;
}
.passwordStrength{

}
.passwordStrength b{
	font-weight:normal;
}
.passwordStrength b,.passwordStrength span{
	display:inline-block; 
	vertical-align:middle;
	line-height:16px;
	line-height:18px\9;
	height:16px;
}
.passwordStrength span{
	width:45px; 
	text-align:center; 
	background-color:#d0d0d0; 
	border-right:1px solid #fff;
}
.passwordStrength .last{
	border-right:none;
}
.passwordStrength .bgStrength{
	color:#fff;
	background-color:#71b83d;
}
#demo1 .passwordStrength{
	margin-left:8px;
}
.tipmsg{
	padding:0 10px;
}
textarea{
	overflow:auto;
	resize:none;
}



.wp_syntax {
  color: #100;
  background-color: #f9f9f9;
  border: 1px solid #e1e1e1;
  margin: 0 0 8px 0;
  overflow: auto;
}

/* IE FIX */
.wp_syntax {
  overflow-x: auto;
  overflow-y: hidden;
  padding-bottom: expression(this.scrollWidth > this.offsetWidth ? 15 : 0);
}

.wp_syntax table {
  border-collapse: collapse;
}

.wp_syntax div, .wp_syntax td {
  vertical-align: top;
  padding: 2px 4px;
}

.wp_syntax .line_numbers {
  text-align: right;
  background-color: #def;
  color: gray;
  overflow: visible;
}

/* potential overrides for other styles */
.wp_syntax pre {
  margin: 0;
  width: auto;
  float: none;
  clear: none;
  overflow: visible;
  font-size: 12px;
  line-height: 1.333;
  white-space: pre;
}
</style>
<!---验证必须引用以下内容不允人工修改-->
<link href="/noedit/check/chkcss.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript" src="/noedit/check/Validform.js"></script>
<!---验证必须引用-->
</head>
<body>
<div class="main">
    	<h2 class="green" style="margin:0px;">支付宝快速登陆注册(完善联系方式)</h2>
        
        <form class="registerform" method="post" action="alipayreturn.asp?action=regsave">
            <table width="95%" align="center" style="table-layout:fixed;">
    <tr>
      <td class="need" style="width:10px;">&nbsp;</td>
      <td style="width:70px;">会员帐号</td>
      <td><%=session("user_id")%></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="8" class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td width="68" style="width:70px;">联系电话</td>
      <td width="147"><input name="u_telphone" type="text" class="inputxt" id="u_telphone" datatype="phone" errormsg="联系电话格式错误！" nullmsg="联系电话不能为空"  maxlength="20"  /></td>
      <td><div class="Validform_checktip">您的联系座机</div></td>
    </tr>
    <tr>
      <td class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td style="width:70px;">手机号码</td>
      <td ><input name="msn" class="inputxt" id="msn"  ignore="ignore" datatype="m" errormsg="请输入正确的手机号码！" nullmsg="手机号码不能为空" maxlength="20"  /></td>
      <td><div class="Validform_checktip">手机与联系电话必填其一</div></td>
    </tr>
    <tr>
      <td class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td style="width:70px;">邮箱号码：</td>
      <td><input name="u_email" type="text" class="inputxt" id="u_email"  datatype="e"  nullmsg="电子邮箱为空！" errormsg="电子邮箱格式错误！" /></td>
      <td><div class="Validform_checktip">请输入您常用邮箱地址！</div></td>
    </tr>
    <tr>
      <td class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td style="width:70px;">QQ号码：</td>
      <td><input name="qq_msg" type="text" class="inputxt" id="qq_msg"  maxlength="30"    datatype="qq" errormsg="请输入正确的QQ号码！！" /></td>
      <td><div class="Validform_checktip">可以输入您的</div></td>
    </tr>
    <tr>
                    <td colspan="4"  ><input type="submit" name="button" id="button" value="提交" /></td>
                </tr>
  </table>
</form>

</div>


<script>
$(function(){
	//$(".registerform").Validform();  //就这一行代码！;
	
	$(".registerform").Validform({
	     showAllError:true,
		 tiptype:2,
		 datatype:{
			"phone":function(gets,obj,curform,regxp){
				/*参数gets是获取到的表单元素值，
				  obj为当前表单元素，
				  curform为当前验证的表单，
				  regxp为内置的一些正则表达式的引用。*/

				var reg1=regxp["m"],
					reg2=regxp["tel"],
					mobile=curform.find("#msn");
				
				if(reg1.test(mobile.val())){return true;}
				if(reg2.test(gets)){return true;}
				
				return false;
			}	
		}
	});
})
</script>
</body>
</html>
	
					
					
					
					
					
					
					
					
					
					
							
					
					
					
					
					
					
					
					
				<%
				response.End()
		
		
		
		
		
		
		
		
		'
'		
'		
'		
'		
'		
'		
'		
'		
'		u_class="个人用户"
'		if Province="" then Province="四川"
'		if city="" then city="成都市"
'		if firm_name="" then firm_name=real_name		
'		'执行商户的业务程序
'			u_password=CreateRandomKey(6)
'			password = md5_16(u_password)
'			rs.addnew()
'			rs("alipay_userid")=user_id
'			rs("u_name")=u_name
'			rs("u_password")=password
'			rs("u_province")="四川"
'			rs("u_fax")=""
'			rs("u_zipcode")=""
'			rs("u_company")=""
'			rs("u_introduce")=""
'			rs("u_contract")=""
'			rs("u_address")=""
'			rs("u_trade")=""
'			rs("u_contry")="CN"
'			rs("u_email")=email
'			rs("u_city")="成都"
'			rs("u_telphone")=""
'			rs("u_website")=""
'			rs("u_employees")="其它"
'			rs("u_namecn")=""
'			rs("u_nameen")=""
'			rs("u_operator")=0
'			rs("qq_msg")=""
'			rs("msn_msg")=""
'			rs("u_ip")=""
'			rs("f_id")=0
'			rs("u_class")=u_class
'			rs("u_type")=0
'			rs("u_meetonce")=1
'			rs("u_resumesum")=0
'			rs("u_premoney")=0
'			rs("u_checkmoney")=0
'			rs("u_remcount")=0
'			rs.update()
'			Call setuserSession(u_name)'自动登陆
'		  if email<>"" then		   
'			getStr="username_cn="& real_name & "," & _		
'				   "password=" & u_password & "," & _
'				   "companyname=" & companyname & "," & _
'				   "username=" & email & "," & _
'				   "companynameurl=" & companynameurl & "," & _
'				   "companyaddress=" & companyaddress & "," & _
'				   "supportmail=" & supportmail & "," & _
'				   "postcode=" & postcode & "," & _
'				   "telphone=" & telphone & "," & _
'				   "oicq=" & oicq
'			mailbody=redMailTemplate("regalipaysub.txt",getStr)
'			call SendMail(email,"注册成功! 欢迎您成为"&companyname&"用户!" ,mailbody)
'		  end if
'		  if USEmanagerTpl="2" then
'		  	gowithwin "/manager/tpl_manager/default.asp?page_main=" & server.URLEncode("/manager/usermanager/default2.asp")
'		  else
'		    gowithwin "/manager/default.asp?page_main=" & server.URLEncode("/manager/usermanager/default2.asp")
'		  end if
'		  ' gowithwin companynameurl &"/manager/"
			
	else
		 if not rs("u_freeze") then
			 Call setuserSession(rs("u_name"))'自动登陆
		 else
			alert_redirect "登陆失败",companynameurl & "/login.asp"
		 end if
	end if
	rs.close
	conn.close
	 gowithwin companynameurl & "/manager/"

else
	alert_redirect "登陆失败",companynameurl & "/login.asp"
end if

end sub





sub regsave()
userName=""
if session("user_ID")="" then 
response.Write("<script>alert('参数错误请重新登陆2');location.href='alipaylog.asp'</script>")
response.end()
else
userName=session("user_ID")
alipay_userid=session("user_ID")
u_password=CreateRandomKey(6)
password = md5_16(u_password)
session("user_ID")=""
end if 


u_telphone=Requesta("u_telphone")
msn=Requesta("msn")
u_email=Requesta("u_email")
qq_msg=Requesta("qq_msg")


 
sql="select top 1 * from UserDetail where u_name='"&userName&"' or alipay_userid='"&userName&"'"
 rs.open sql,conn,1,3
  
     if rs.eof then
	
				   rs.addnew
				   u_name=userName
				   rs("u_name")=u_name
				   rs("alipay_userid")=u_name
				   rs("u_type")=0
					rs("u_password")=password
					rs("u_province")="四川"
					rs("u_fax")=""
					rs("u_zipcode")=""
					rs("u_company")=""
					rs("u_introduce")=""
					rs("u_contract")=""
					rs("u_address")=""
					rs("u_trade")=""
					rs("u_contry")="CN"
					rs("u_email")=u_email
					rs("u_city")="成都"
					rs("u_telphone")=u_telphone
					rs("u_website")=""
					rs("u_employees")="其它"
					rs("u_namecn")=""
					rs("u_nameen")=""
					rs("u_operator")=0
					rs("qq_msg")=qq_msg
					rs("msn_msg")=msn
					rs("u_ip")=""
					rs("f_id")=0
					rs("u_class")="个人用户"
					rs("u_type")=0
					rs("u_meetonce")=1
					rs("u_resumesum")=0
					rs("u_premoney")=0
					rs("u_checkmoney")=0
					rs("u_remcount")=0
				   rs.update
				 Call setuserSession(u_name)'自动登陆
				 
				  gowithwin companynameurl & "/manager/"
				  response.End()

end if
					
response.Write("<script>alert('参数错误请重新登陆');location.href='alipaylog.asp'</script>")
				

end sub




%>
</body>
</html>
