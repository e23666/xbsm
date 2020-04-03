<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" -->  
<%
 
response.charset="gb2312"
'新加
Select Case Trim(requesta("act"))
Case "sendcode"
conn.open constr
	u_name=requesta("u_name")
	sendtype=requesta("sendtype")
	val_=requesta("val")
	sql="select top 1 u_email,msn_msg from userdetail where u_name='"&u_name&"'"
	Set urs=conn.execute(sql)
	code="500"
	msg=""
	If urs.eof Then
		msg="会员名错误"
		urs.close
	Else
		u_email=urs("u_email")
		msn_msg=urs("msn_msg")
		urs.close
		Select Case LCase(Trim(sendtype))
		Case "mail"
			If InStr(u_email&"","@")=0 Then
				msg="很遗憾您没有填写邮箱不能找回密码!"
			else
				If Trim(u_email)<>val_ Or Trim(u_email)="" Then
					msg="您填写的邮箱不正确!"
				Else
					sendcode=createRnd(6)
					strmd5=asp_md5(u_name&sendcode&Trim(u_email)&webmanagespwd)
					m_title="["&companyname&"]找回密码验证码"
					m_body="您本次找回密码的验证码为["&sendcode&"],30分钟内有效"
					if sendMail(u_email,m_title,m_body) Then
						code=200
						msg="验证码已经发送到您的邮箱请注意查收,30分钟内有效!"
						Call SetHttpOnlyCookie("findcode",strmd5,"","/",DateAdd("n",30,now()))
					Else
						msg="很遗憾发送验证码失败,请联系管理员!"
					End if
				End If
			End if
		Case "sms"
			If not sms_note Then
				msg="很遗憾本站暂不支持手机找回密码!"
			Else
				If  Not IsValidMobileNo(msn_msg) Or Not IsValidMobileNo(val_) Or Trim(msn_msg)<>Trim(val_)  Then
					msg="很遗憾您还没有设置手机号码/或录入手机号码有误,请联系管理员!"
				Else
					sendcode=createRnd(6)
					strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
					sendStrSms="您本次找回密码的验证码为["&sendcode&"],30分钟内有效"
					Smsreturn=httpSendSMS(msn_msg,sendStrSms)
					if left(Smsreturn,3) ="200" Then
						code=200
						msg="验证码已经发送到您的邮箱请注意查收,30分钟内有效!"
						Call SetHttpOnlyCookie("findcode",strmd5,"","/",DateAdd("n",30,now()))
					Else
						msg ="手机发送失败,请选择邮箱发送" 
					End if
				End if				
			End if	

		Case Else
		msg="验证码发送方式错误!"
		End select
	End if
		die "{""code"":"&code&",""msg"":"""&msg&"""}"
End Select

 



 						  Randomize
                          MyValue = Int(((999-100+1)*rnd)+100)
                          codeKey = Int(Timer()*10) + MyValue
					sms_disabled=""  
					if not sms_note then sms_disabled="disabled=""disabled"""
					Call setwebhostingLeft()
					call setHeaderAndfooter()
					call setregsubLeft()
					tpl.set_file "main", USEtemplate&"/reg/forget.html"
					tpl.set_var "codeKey",codeKey,false
					tpl.set_var "sms_disabled",sms_disabled,false
					tpl.parse "mains","main",false
					tpl.p "mains" 
					set tpl=nothing
					'rs.close

%>