<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->

<%
response.Charset="gb2312"
conn.open constr

set urs=conn.execute("select top 1 isauthmobile,msn_msg,u_name from userdetail where u_id="&session("u_sysid"))
if urs.eof then  url_return "��ѯ����ʧ��!",-1 
isauthmobile=urs("isauthmobile") 
msn_msg=urs("msn_msg")
u_name=urs("u_name")
urs.close:set urs=nothing
if not isnumeric(isauthmobile&"") then isauthmobile=0

act=requesta("act")
if act="sendcode" then
	if not checkRegExp(msn_msg&"","^1([\d]{10})$") then die echojson("500","�ֻ��Ÿ�ʽ����","")
	If Not sms_note Then die echojson("500","û�п�ͨ���Žӿ��޷�ʵ����֤","")
	
	sendcode=createRnd(6)
	strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
	sendStrSms="��������֤��Ϊ["&sendcode&"],30��������Ч"
	Smsreturn=httpSendSMS(msn_msg,sendStrSms)
	if left(Smsreturn,3) ="200" Then
		code=200
		msg="��֤���Ѿ�������ע�����,30��������Ч!"
		Call SetHttpOnlyCookie("rzcode",strmd5,"","/",DateAdd("n",30,now()))
		die echojson("200",msg,",""issend"":0")
	Else
		msg ="�ֻ�����ʧ��!" 
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
'			die echojson("200","��ǰ��֤��,ֱ�ӳɹ�!",",""issend"":"&issend)
'		end if
'		die echojson("200","���ŷ��ͳɹ�",",""issend"":"&issend)
'	else
'		die echojson("500",returnstr,"")
'	end if
end if

if act="checkcode" then
	sendcode=requesta("code")
	if trim(sendcode&"")="" then die echojson("500","��֤��Ϊ��","")
	if len(sendcode&"")<>6 then die echojson("500","��¼��6λ��֤��","")
	rzcode=requesta("rzcode")
	if trim(rzcode&"")="" then die echojson("500","��֤������","")

	'if not isnumeric(code&"") then die echojson("500","��֤���ʽ����","")
	if not checkRegExp(msn_msg&"","^1([\d]{10})$") then die echojson("500","�ֻ��Ÿ�ʽ����","")
	strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
	If Trim(LCase(rzcode))<>Trim(LCase(strmd5)) Then die echojson("500","��֤���ʽ����","")
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
		die echojson("200","�ɹ�","")
	else
		die echojson("500",returnstr,"")
	end if
end if


'����Ƿ�Ϊ�ֻ�����,
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
<title>�û������̨-�ֻ���֤</title>
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
        <li><a href="/">��ҳ</a></li>
        <li><a href="/Manager/">��������</a></li>
        <li><a href="/manager/usermanager/renzheng.asp">�ֻ���֤</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
	<%if clng(isauthmobile)>0 then%>
		<img src="../images/succeed64_64.gif" width="64" height="64">
		<span style="padding-left:30px;font-size:16px;color:green"> ��ϲ��������ͨ���ֻ���֤.�����ֻ����������޸����Ϻ�����ʵ����֤��</span>
	<%else%>

		<table class="manager-table">
			<tr>
				<th colspan=2>�ֻ���֤</th>
			</tr>
			<tr>
				<th>�ֻ���:</th>
				<td align=left>
				  <input type="text" name="mobile" value="<%=msn_msg%>" maxlength=11 class="manager-input s-input" id="mobile">
				  <button class="manager-btn s-btn" onclick="editmobile(this)">�޸ĺ���</button>  <button class="manager-btn s-btn"   id="sendauthcode">������֤��</button> </td>
			</tr>
			<tr>
				<th>��֤��:</th>
				<td align=left>
					<input type="text" name="code" value="" class="manager-input s-input" maxlength=6>
				</td>
			</tr>
			<tr>
				<th colspan="2"><button class="manager-btn s-btn" id="checkauthcode">ȷ���ֻ���֤</button></th>
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
					obj.html("������֤��");
					return false;
				}
				
				obj.html((sj-t)+"�������ط�����");
				setTimeout("sjsendbt()",1000)

			}
		$(function(){
			$("#sendauthcode").click(function(){
				var obj=$(this);
				obj.attr("disabled",true)
				$.dialog.confirm("��ȷ������д���ֻ������Ƿ���ȷ?",function(){
					obj.html("��֤�뷢����..."); 
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
				if(code==""){ $.dialog.alert("��֤�����");return false;}
				if(code.length!=6){ $.dialog.alert("��֤�����");return false;}
				obj.attr("disabled",true)
				$.dialog.confirm("��ȷ��Ҫ��֤���ֻ���?",function(){
					obj.html("��֤��...")
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
			$.dialog.alert("��ӻ�Ա�����޸��ֻ�����!",function(){
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
