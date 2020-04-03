<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/md5_16.asp" -->
<%
response.Buffer=true

conn.open constr
If Requesta("module")<>"forgetpwd" Then url_return "参数错误",-1

					u_name=trim(requestf("u_name"))
					u_email=trim(requestf("u_email"))
					msn_msg=trim(requestf("msn_msg"))
					u_answer=trim(requestf("u_answer"))
					setsend=requesta("setSend")
					codekey=trim(requestf("codekey"))
					code=trim(requestf("code"))
					safecode=trim(requestf("safecode"))
					findcode=Trim(request.cookies("findcode"))



			
			If Trim(safecode)="" Then URL_RETURN "请填写您收到的验证码",-1
			If setsend="mail" Then
				strmd5=asp_md5(u_name&LCase(safecode)&Trim(u_email)&webmanagespwd)
			Else
				strmd5=asp_md5(u_name&LCase(safecode)&Trim(msn_msg)&webmanagespwd)
			End If 

			If not ValidCode("CSName",codekey,code) Then URL_RETURN "抱歉.验证码不正确.请刷新验证码重试",-1
			
			If strmd5<>findcode Then  URL_RETURN "请录入您收到的有效验证码",-1
			
					cur=0
					if u_name<>"" then cur=cur+1
					if u_email<>"" then cur=cur+1
					if msn_msg<>"" then cur=cur+1
					
					if cur<2 then
						message = "抱歉.密码找回失败!您填写的安全项目少于2项"
					else
							
							sql="select top 1 * from userdetail where u_freeze="&PE_False&" and  ("
							if u_email<>"" and msn_msg<>"" then sql=sql&"(u_email='"& u_email &"' and msn_msg='"& msn_msg &"') and "
							If isdbsql Then
								if u_name<>"" and msn_msg<>"" then sql=sql&" (msn_msg='"& msn_msg &"' and u_name='"& u_name &"' and isnull(msn_msg,'')<>'')  and "
								if u_name<>"" and u_email<>"" then sql=sql&" (u_email='"& u_email &"' and u_name='"& u_name &"' and isnull(u_email,'')<>'' ) and "
								sql=sql&" 1=1)"
							
							else
								if u_name<>"" and msn_msg<>"" then sql=sql&" (msn_msg='"& msn_msg &"' and u_name='"& u_name &"' and iif(isnull(msn_msg),'',msn_msg)<>'')  and "
								if u_name<>"" and u_email<>"" then sql=sql&" (u_email='"& u_email &"' and u_name='"& u_name &"' and iif(isnull(u_email),'',u_email)<>'' ) and "
								sql=sql&" 1=1)"
							End if
							rs.open sql,conn,1,1
							if rs.eof and rs.bof then
								message = "抱歉.密码找回失败!您邮箱或手机号码不匹配.请重新输入"
							else
								u_name=trim(rs("u_name"))
								u_email=trim(rs("u_email"))
								msn_msg=trim(rs("msn_msg"))
								up=false
								u_passwordstring =CreateRandomKey(6)
								u_password = trim(md5_16(u_passwordstring))
								
								
								if setsend="mail" then
										user_name=u_name
										
										getStr="u_passwordstring="& u_passwordstring
											 
										mailbody=redMailTemplate("forgetsub.txt",getStr)
										call sendMail(u_email,"取回密码成功!",mailbody)
									up=true
									message="感谢您使用本服务! 新的密码已发到您原邮箱上,请注意查收"
								elseif setsend="sms" then
											sql="select count(*) as abcds from SMSback where sendcontent like '%您的账号为:"& u_name &"%' and dateDiff("&PE_DatePart_D&",sendTime,"&PE_Now&")<7"
											set myRs2=conn.execute(sql)
											if myRs2(0)>=2 then
												message= "对不起 ，一周内最多只能使用2次短信找回密码功能！请选择邮箱发送！"	
											else
												smsnum=msn_msg
												if IsValidMobileNo(smsnum) then
												  sendStrSms="您的账号为:"& u_name &" 新密码为:"&u_passwordstring & " 请及时修改并妥善保管"
													Smsreturn=httpSendSMS(smsnum,sendStrSms)
													if left(Smsreturn,3) ="200" then
														message ="感谢您使用本服务! 新的密码已经发送到您的原手机号上，请注意查收!"
														up=true
													else
														message ="手机发送失败,请选择邮箱发送" & Smsreturn
													end if
												  else
														message ="要发送的手机号不正确,请检查号码或选择邮箱发送"
												  end if						
											end if
											myRs2.close
											set myRs2=nothing
								end if
								if up then
									conn.execute"update userdetail set u_password='"& u_password &"' where u_email='"& u_email &"' and msn_msg='"& msn_msg &"' and u_name='"& u_name &"'"
									message="恭喜.密码找回成功!<br>" & message
									Call SetHttpOnlyCookie("findcode","","","/",#1980-01-01 01:01:01#)
								else
									message="抱歉.密码找回失败!<br>"& message
								end if
								
							end if
					end if
					Call setwebhostingLeft()
					call setHeaderAndfooter()
					call setregsubLeft()
					tpl.set_file "main", USEtemplate&"/reg/forgetsub.html"
					tpl.set_var "message",message,false
					tpl.parse "mains","main",false
					tpl.p "mains" 
					set tpl=nothing
					rs.close
					conn.close
					response.end
Function ValidCode(pSN,k,c)
	Dim s,i
	s = Session(pSN)
	k = ";"&k&":"
	ValidCode = False
	i = InStr(s,k)
	If i > 0 Then
		If InStr(s,k&c&";") > 0 Then ValidCode = True
		Session(pSN) = Left(s,i) & Right(s,Len(s)-InStr(i+1,s,";"))
	End If
End Function
 
%>