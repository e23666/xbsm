<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<!--#include file="qqconnect.asp"-->
<%
response.Charset="gb2312"
   conn.open constr   

action=Requesta("action")


select case action
case "regsave"
regsave
case "noreg"
noreg
case else
other()
end select


sub other()

SET qc = New QqConnet
    CheckLogin=qc.CheckLogin()
	If CheckLogin=False Then
	   Response.Write("��¼ʧ�ܣ�")
	   Response.End()
	End If



   Session("Access_Token")=qc.GetAccess_Token()
 
   
   if Session("Access_Token")="" then
   
    Response.Write("��¼ʧ�ܣ�")
	   Response.End()
   end if
   
   
  	Session("Openid")=qc.Getopenid()
   Openid=Session("Openid")
  userinfo=qc.GetUserInfo()
 
session("qq_nickname")=qc.GetUserName(userinfo)(0)
 
 
     sql="select top 1 * from UserDetail where    qq_openid='"&Openid&"'"
   rs.open sql,conn,1,3 
   
   '��½״̬����
    if session("u_sysid")<>"" then
	
		set urs=Server.CreateObject("adodb.recordset")
		sql="select * from  UserDetail  where u_id="&session("u_sysid")
		urs.open sql,conn,1,3
		
		select case trim(session("qqbind"))
		case "1"  '���û���QQ
		'response.Write("��QQ"&rs.eof)
			if rs.eof then  '����Ƿ��Ѿ��а�
				urs("qq_Openid")=Openid
				urs.update
			end if
		case "2"  'ȡ����
		    if trim(urs("qq_Openid"))=trim(Openid) then
			urs("qq_Openid")=""
			urs.update
			end if
		
		end select
		
		
	
  	urs.close
	conn.close	
	else
	'�ǵ�½״̬
   
    
   
   
   '��½����ע��
  

		   If rs.eof Then
				
				   set crs=conn.execute("select top 1 u_name from UserDetail where u_name like 'qq[_]%' order by u_id desc")
				   if crs.eof then
				   qqcount=9999
				   else
				   qqcount=clng(replace(crs(0),"qq_",""))
				   end if
				   qqcount=qqcount+1
				   session("qqUserName")="qq_"&qqcount
				   response.Redirect("?action=noreg")
				   die ""
					
				%>	

	
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>QQ���ٵ�½ע��</title>
<style>
/* common css ============================================== */
body{margin:0 auto;	text-align:center; font: 12px/1.5 arial; color:#242424; padding:0px;}
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
<!---��֤���������������ݲ����˹��޸�-->
<link href="/noedit/check/chkcss.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript" src="/noedit/check/Validform.js"></script>
<!---��֤��������-->
</head>
<body>
<div class="main">
    	<h2 class="green" style="margin:0px;">QQ���ٵ�½ע��(������ϵ��ʽ)</h2>
        
        <form class="registerform" method="post" action="returnQQ.asp?action=regsave">
            <table width="95%" align="center" style="table-layout:fixed;">
    <tr>
      <td class="need" style="width:10px;">&nbsp;</td>
      <td style="width:70px;">qq�ǳ�</td>
      <td><%=session("qq_nickname")%><%'=session("qqUserName")%></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="8" class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td width="68" style="width:70px;">��ϵ�绰</td>
      <td width="147"><input name="u_telphone" type="text" class="inputxt" id="u_telphone" datatype="phone" errormsg="��ϵ�绰��ʽ����" nullmsg="��ϵ�绰����Ϊ��"  maxlength="20"  /></td>
      <td><div class="Validform_checktip">������ϵ����</div></td>
    </tr>
    <tr>
      <td class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td style="width:70px;">�ֻ�����</td>
      <td ><input name="msn" class="inputxt" id="msn"  ignore="ignore" datatype="m" errormsg="��������ȷ���ֻ����룡" nullmsg="�ֻ����벻��Ϊ��" maxlength="20"  /></td>
      <td><div class="Validform_checktip">�ֻ�����ϵ�绰������һ</div></td>
    </tr>
    <tr>
      <td class="need" style="width:10px;"><span class="need" style="width:10px;">*</span></td>
      <td style="width:70px;">������룺</td>
      <td><input name="u_email" type="text" class="inputxt" id="u_email"  datatype="e"  nullmsg="��������Ϊ�գ�" errormsg="���������ʽ����" /></td>
      <td><div class="Validform_checktip">�����������������ַ��</div></td>
    </tr>
    <tr style="display:none">
      <td class="need" style="width:10px;"></td>
      <td style="width:70px;">QQ���룺</td>
      <td><input name="qq_msg" type="text" class="inputxt" id="qq_msg"   ignore="ignore"   maxlength="30"    datatype="qq" errormsg="��������ȷ��QQ���룡��" /></td>
      <td><div class="Validform_checktip">������������QQ����</div></td>
    </tr>
    <tr>
                    <td colspan="4"  ><input type="submit" name="button" id="button" value="�ύ" />
                    <a href="?action=noreg" target="_top" onclick="return confirm('ע������������ϵ��ʽ���ٹ��򣬷����޷��յ���Ӧ���ѹ������Ϣ')">�Ժ���˵�������е��û���������</a></td>
                </tr>
  </table>
</form>

</div>


<script>
$(function(){
	//$(".registerform").Validform();  //����һ�д��룡;
	
	$(".registerform").Validform({
	     showAllError:true,
		 tiptype:2,
		 datatype:{
			"phone":function(gets,obj,curform,regxp){
				/*����gets�ǻ�ȡ���ı�Ԫ��ֵ��
				  objΪ��ǰ��Ԫ�أ�
				  curformΪ��ǰ��֤�ı���
				  regxpΪ���õ�һЩ������ʽ�����á�*/

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

			
					
		   Else
				   '��½״̬����
		 u_name=rs("u_name")
		 u_freeze=rs("u_freeze")
				if not u_freeze then
				  Call setuserSession(u_name)'�Զ���½
				else
				 
				%>
		<script>
		alert("�ʺű�����,�������½")
		window.close();
		</script>
				<%
				end if
				  
		   End If
		     	rs.close
	conn.close
   end if
   
   

 
	'gowithwin companynameurl & "/manager/"

%>
<script>

window.opener.location.reload();
window.close();
</script>
<%end sub

sub regsave()
userName=""
if session("qqUserName")="" then 
response.Write("<script>alert('�������������µ�½');window.opener.closeChildWindow();</script>")
response.end()
else
userName=session("qqUserName")
Openid=Session("Openid")
u_password=CreateRandomKey(6)
password = md5_16(u_password)
session("qqUserName")=""
Session("Openid")=""
end if 


u_telphone=Requesta("u_telphone")
msn=Requesta("msn")
u_email=Requesta("u_email")
qq_msg=Requesta("qq_msg")


 
sql="select top 1 * from UserDetail where u_name='"&userName&"' or qq_Openid='"&Openid&"'"
 rs.open sql,conn,1,3
  
     if rs.eof then
	
				   rs.addnew
				   u_name=userName
				   rs("u_name")=u_name
				   rs("qq_Openid")=Openid
				   rs("u_type")=0
					rs("u_password")=password
					rs("u_province")="�Ĵ�"
					rs("u_fax")=""
					rs("u_zipcode")=""
					rs("u_company")=""
					rs("u_introduce")=""
					rs("u_contract")=session("qq_nickname")
					rs("u_address")=""
					rs("u_trade")=""
					rs("u_contry")="CN"
					rs("u_email")=u_email
					rs("u_city")="�ɶ�"
					rs("u_telphone")=u_telphone
					rs("u_website")=""
					rs("u_employees")="����"
					rs("u_namecn")=""
					rs("u_nameen")=""
					rs("u_operator")=0
					rs("qq_msg")=qq_msg
					rs("msn_msg")=msn
					rs("u_ip")=""
					rs("f_id")=0
					rs("u_class")="�����û�"
					rs("u_type")=0
					rs("u_meetonce")=1
					rs("u_resumesum")=0
					rs("u_premoney")=0
					rs("u_checkmoney")=0
					rs("u_remcount")=0
				   rs.update
				 Call setuserSession(u_name)'�Զ���½

end if
					
response.Write("<script>window.opener.closeChildWindow();</script>")					%>

<script>

window.opener.location.reload();
window.close();
</script>

<%


end sub

sub noreg
userName=""
if session("qqUserName")="" then 
response.Write("<script>alert('�������������µ�½');window.opener.closeChildWindow();</script>")
response.end()
else
userName=session("qqUserName")
Openid=Session("Openid")
u_password=CreateRandomKey(6)
password = md5_16(u_password)
session("qqUserName")=""
Session("Openid")=""
end if 


u_telphone=""
msn=""
u_email=""
qq_msg=""


 
sql="select top 1 * from UserDetail where u_name='"&userName&"' or qq_Openid='"&Openid&"'"
 rs.open sql,conn,1,3
     if rs.eof then
				   rs.addnew
				   u_name=userName
				   rs("u_name")=u_name
				   rs("qq_Openid")=Openid
				   rs("u_type")=0
					rs("u_password")=password
					rs("u_province")="�Ĵ�"
					rs("u_fax")=""
					rs("u_zipcode")=""
					rs("u_company")=""
					rs("u_introduce")=""
					rs("u_contract")=session("qq_nickname")
					rs("u_address")=""
					rs("u_trade")=""
					rs("u_contry")="CN"
					rs("u_email")=u_email
					rs("u_city")="�ɶ�"
					rs("u_telphone")=u_telphone
					rs("u_website")=""
					rs("u_employees")="����"
					rs("u_namecn")=""
					rs("u_nameen")=""
					rs("u_operator")=0
					rs("qq_msg")=qq_msg
					rs("msn_msg")=msn
					rs("u_ip")=""
					rs("f_id")=0
					rs("u_class")="�����û�"
					rs("u_type")=0
					rs("u_meetonce")=1
					rs("u_resumesum")=0
					rs("u_premoney")=0
					rs("u_checkmoney")=0
					rs("u_remcount")=0
				   rs.update
				 Call setuserSession(u_name)'�Զ���½
				 %>
				' response.Redirect("/manager/usermanager/default2.asp")
<script>
window.opener.location.reload();
window.close();
</script>
                <%
end if
end sub
%>


