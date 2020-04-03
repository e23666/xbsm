<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->

<%
response.Charset="gb2312"
conn.open constr

set urs=conn.execute("select top 1 isauthmobile,msn_msg,u_name from userdetail where u_id="&session("u_sysid"))
if urs.eof then  url_return "查询数据失败!",-1 
isauthmobile=urs("isauthmobile") 
msn_msg=urs("msn_msg")
u_name=urs("u_name")
urs.close:set urs=nothing
if not isnumeric(isauthmobile&"") then isauthmobile=0

act=requesta("act")
if act="sendcode" then
	if not checkRegExp(msn_msg&"","^1([\d]{10})$") then die echojson("500","手机号格式有误","")
	If Not sms_note Then die echojson("500","没有开通短信接口无法实名验证","")
	
	sendcode=createRnd(6)
	strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
	sendStrSms="您本次验证码为["&sendcode&"],30分钟内有效"
	Smsreturn=httpSendSMS(msn_msg,sendStrSms)
	if left(Smsreturn,3) ="200" Then
		code=200
		msg="验证码已经发送请注意查收,30分钟内有效!"
		Call SetHttpOnlyCookie("rzcode",strmd5,"","/",DateAdd("n",30,now()))
		die echojson("200",msg,",""issend"":0")
	Else
		msg ="手机发送失败!" 
		die echojson("500",msg&Smsreturn,",""issend"":1")
	End if

'	strcmd="other"&vbcrlf&_
'		   "get"&vbcrlf&_
'		   "entityname:auth_sendcode"&vbcrlf&_
'		   "mobile:"&msn_msg&vbcrlf&_
'		   "login:"&u_name&vbcrlf&_
'		   "."&vbcrlf 
'  	returnstr=PCommand(strcmd,u_name)
'	if left(returnstr,3)="200" then
'		issend=getReturn(returnstr,"issend")
'		if not isnumeric(issend&"") then issend=0
'		if clng(issend)=2 then
'			conn.execute("update userdetail set isauthmobile=1 where u_id="&session("u_sysid"))
'			Session("isauthmobile")=1
'			die echojson("200","从前认证过,直接成功!",",""issend"":"&issend)
'		end if
'		die echojson("200","短信发送成功",",""issend"":"&issend)
'	else
'		die echojson("500",returnstr,"")
'	end if
end if

if act="checkcode" then
	sendcode=requesta("code")
	if trim(sendcode&"")="" then die echojson("500","验证码为空","")
	if len(sendcode&"")<>6 then die echojson("500","请录入6位验证码","")
	rzcode=requesta("rzcode")
	if trim(rzcode&"")="" then die echojson("500","验证码有误","")

	'if not isnumeric(code&"") then die echojson("500","验证码格式错误","")
	if not checkRegExp(msn_msg&"","^1([\d]{10})$") then die echojson("500","手机号格式有误","")
	strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
	If Trim(LCase(rzcode))<>Trim(LCase(strmd5)) Then die echojson("500","验证码格式错误","")
	returnstr="200 ok"
'	strcmd="other"&vbcrlf&_
'		   "get"&vbcrlf&_
'		   "entityname:auth_checkcode"&vbcrlf&_
'		   "mobile:"&msn_msg&vbcrlf&_
'		   "login:"&u_name&vbcrlf&_
'		   "code:"&code&vbcrlf&_
'		   "."&vbcrlf 
	
'  	returnstr=PCommand(strcmd,u_name)
	if left(returnstr,3)="200" then
		conn.execute("update userdetail set isauthmobile=1 where u_id="&session("u_sysid"))
		Session("isauthmobile")=1
		die echojson("200","成功","")
	else
		die echojson("500",returnstr,"")
	end if
end if


'检查是否为手机号码,
if checkRegExp(msn_msg&"","^1([\d]{10})$") then
	strcmd="other"&vbcrlf&_
		   "get"&vbcrlf&_
		   "entityname:auth_check"&vbcrlf&_
		   "mobile:"&msn_msg&vbcrlf&_
		   "login:"&u_name&vbcrlf&_
		   "."&vbcrlf 
  	returnstr=PCommand(strcmd,u_name)
	if left(returnstr,3)="200" then
		isauth=getReturn(returnstr,"isauth")
		if not isnumeric(isauth&"") then isauth=0
		if clng(isauth)>0 then
			conn.execute("update userdetail set isauthmobile=1 where u_id="&session("u_sysid"))
			Session("isauthmobile")=1
			isauthmobile=1
		end if
	end if
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-手机验证</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<link href="/noedit/check/chkcss.css" rel="stylesheet" type="text/css" />
<script src="/database/cache/citypost.js"></script>
<script language="javascript" src="/noedit/check/Validform.js"></script>
 
</HEAD>
<body>
<!--#include virtual="/manager/top.asp" -->
<div id="MainContentDIV"> 
  <!--#include virtual="/manager/manageleft.asp" -->
  <div id="ManagerRight" class="ManagerRightShow">
    <div id="SiteMapPath">
      <ul>
        <li><a href="/">首页</a></li>
        <li><a href="/Manager/">管理中心</a></li>
        <li><a href="/manager/usermanager/renzheng.asp">手机验证</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
	<%if clng(isauthmobile)>0 then%>
		<img src="../images/succeed64_64.gif" width="64" height="64">
		<span style="padding-left:30px;font-size:16px;color:green"> 恭喜您！您已通过手机验证.如变更手机号请重新修改资料后重新实名认证。</span>
	<%else%>

		<table class="manager-table">
			<tr>
				<th colspan=2>手机验证</th>
			</tr>
			<tr>
				<th>手机号:</th>
				<td align=left>
				  <input type="text" name="mobile" value="<%=msn_msg%>" maxlength=11 class="manager-input s-input" id="mobile">
				  <button class="manager-btn s-btn" onclick="editmobile(this)">修改号码</button>  <button class="manager-btn s-btn"   id="sendauthcode">发送验证码</button> </td>
			</tr>
			<tr>
				<th>验证码:</th>
				<td align=left>
					<input type="text" name="code" value="" class="manager-input s-input" maxlength=6>
				</td>
			</tr>
			<tr>
				<th colspan="2"><button class="manager-btn s-btn" id="checkauthcode">确定手机验证</button></th>
			</tr>
		</table>
	<script>
		var sj=180;
		var t=0;
		function sjsendbt()
			{
				t++;
				var obj=$("#sendauthcode")
				if(t>sj){
					obj.attr("disabled",false);
					obj.html("发送验证码");
					return false;
				}
				
				obj.html((sj-t)+"秒后可以重发短信");
				setTimeout("sjsendbt()",1000)

			}
		$(function(){
			$("#sendauthcode").click(function(){
				var obj=$(this);
				obj.attr("disabled",true)
				$.dialog.confirm("请确认您填写的手机号码是否正确?",function(){
					obj.html("验证码发送中..."); 
					$.post("renzheng.asp",{"act":"sendcode"},function(data){
						 if(data.result=="200"){
							sjsendbt();
							$.dialog.alert(data.msg);
						 }else{
							$.dialog.alert(data.msg);
							obj.attr("disabled",false)
						 }
					},"json")				 
					//obj.attr("disabled",false)
				},function(){
				
					obj.attr("disabled",false)
				})
			
			})
			

			$("#checkauthcode").click(function(){
				var obj=$(this);
				var code=$("input[name='code']").val();
				if(code==""){ $.dialog.alert("验证码错误！");return false;}
				if(code.length!=6){ $.dialog.alert("验证码错误！");return false;}
				obj.attr("disabled",true)
				$.dialog.confirm("您确定要验证此手机号?",function(){
					obj.html("验证中...")
					$.post("renzheng.asp",{"act":"checkcode","code":code},function(data){
						if(data.result=="200"){
							location.reload();
						}else{
						 $.dialog.alert(data.msg);
							obj.attr("disabled",false)
						 }
					},"json")				 
				
				},function(){
				
					obj.attr("disabled",false)
				})				
			
			})
		
		
		})


		function editmobile(obj)
		{
			$.dialog.alert("请从会员资料修改手机号码!",function(){
				location.href='/manager/usermanager/default2.asp'
			})
		
			//alert(obj.value)
		}
	</script>
	<%end if%>

    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
