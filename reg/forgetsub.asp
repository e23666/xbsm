<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/md5_16.asp" -->
<%
response.Buffer=true

conn.open constr
If Requesta("module")<>"forgetpwd" Then url_return "��������",-1

					u_name=trim(requestf("u_name"))
					u_email=trim(requestf("u_email"))
					msn_msg=trim(requestf("msn_msg"))
					u_answer=trim(requestf("u_answer"))
					setsend=requesta("setSend")
					codekey=trim(requestf("codekey"))
					code=trim(requestf("code"))
					safecode=trim(requestf("safecode"))
					findcode=Trim(request.cookies("findcode"))



			
			If Trim(safecode)="" Then URL_RETURN "����д���յ�����֤��",-1
			If setsend="mail" Then
				strmd5=asp_md5(u_name&LCase(safecode)&Trim(u_email)&webmanagespwd)
			Else
				strmd5=asp_md5(u_name&LCase(safecode)&Trim(msn_msg)&webmanagespwd)
			End If 

			If not ValidCode("CSName",codekey,code) Then URL_RETURN "��Ǹ.��֤�벻��ȷ.��ˢ����֤������",-1
			
			If strmd5<>findcode Then  URL_RETURN "��¼�����յ�����Ч��֤��",-1
			
					cur=0
					if u_name<>"" then cur=cur+1
					if u_email<>"" then cur=cur+1
					if msn_msg<>"" then cur=cur+1
					
					if cur<2 then
						message = "��Ǹ.�����һ�ʧ��!����д�İ�ȫ��Ŀ����2��"
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
								message = "��Ǹ.�����һ�ʧ��!��������ֻ����벻ƥ��.����������"
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
										call sendMail(u_email,"ȡ������ɹ�!",mailbody)
									up=true
									message="��л��ʹ�ñ�����! �µ������ѷ�����ԭ������,��ע�����"
								elseif setsend="sms" then
											sql="select count(*) as abcds from SMSback where sendcontent like '%�����˺�Ϊ:"& u_name &"%' and dateDiff("&PE_DatePart_D&",sendTime,"&PE_Now&")<7"
											set myRs2=conn.execute(sql)
											if myRs2(0)>=2 then
												message= "�Բ��� ��һ�������ֻ��ʹ��2�ζ����һ����빦�ܣ���ѡ�����䷢�ͣ�"	
											else
												smsnum=msn_msg
												if IsValidMobileNo(smsnum) then
												  sendStrSms="�����˺�Ϊ:"& u_name &" ������Ϊ:"&u_passwordstring & " �뼰ʱ�޸Ĳ����Ʊ���"
													Smsreturn=httpSendSMS(smsnum,sendStrSms)
													if left(Smsreturn,3) ="200" then
														message ="��л��ʹ�ñ�����! �µ������Ѿ����͵�����ԭ�ֻ����ϣ���ע�����!"
														up=true
													else
														message ="�ֻ�����ʧ��,��ѡ�����䷢��" & Smsreturn
													end if
												  else
														message ="Ҫ���͵��ֻ��Ų���ȷ,��������ѡ�����䷢��"
												  end if						
											end if
											myRs2.close
											set myRs2=nothing
								end if
								if up then
									conn.execute"update userdetail set u_password='"& u_password &"' where u_email='"& u_email &"' and msn_msg='"& msn_msg &"' and u_name='"& u_name &"'"
									message="��ϲ.�����һسɹ�!<br>" & message
									Call SetHttpOnlyCookie("findcode","","","/",#1980-01-01 01:01:01#)
								else
									message="��Ǹ.�����һ�ʧ��!<br>"& message
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