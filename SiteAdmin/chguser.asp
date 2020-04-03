<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<!--#include virtual="/config/uercheck.asp" -->
<%
						module=Requesta("module")
						Select Case module
						  Case "chguser"
							If strtonum(session("u_type"))>=1 Then
							username=Requesta("username")
							conn.open constr
							if strtonum(session("u_type"))=111111 then
							    rs.open "select * from UserDetail where u_name='"& username &"'" ,conn,3
							else
							      rs.open "select * from UserDetail where u_name='"& username &"'  and u_type='0'" ,conn,3
							end if
							If Not rs.eof  Then
								session("priusername")=session("user_name")
								session("u_sysid")=rs("u_id")
								session("user_name")=rs("u_name")
								session("u_levelid")=rs("u_level")
								session("u_level")=rs("U_levelName")
								session("u_remcount")=rs("u_remcount")
								session("u_borrormax")=rs("u_borrormax")
								session("u_resumesum")=rs("u_resumesum")
								session("u_checkmoney")=rs("u_checkmoney")
								session("u_usemoney")=rs("u_usemoney")
								session("u_type")= rs("u_type")
								session("u_email")=rs("u_email")
								session("bizbid") = rs("u_father")
								
								 session("u_email")=rs("u_email")
								session("u_contract")=rs("u_contract")
								session("u_address")=rs("u_address")
								session("msn")=rs("msn_msg")
								isauthmobile=rs("isauthmobile")
								if trim(session("priusername"))<>"" then isauthmobile=1
								if instr(lcase(api_url)&"","api.west263.com")=0 then isauthmobile=1
								Session("isauthmobile")=isauthmobile
								rs.close
								conn.close
								response.redirect InstallDir&"manager/default.asp"
							End If
							rs.close
							conn.close
							Response.Write username & "用户不存在,或者你没有权限切换 <a href=""default.asp"">请你退回</a>"
						  End If
						  Case "returnme"
							If session("priusername")<>"" Then
							conn.open constr
							rs.open "select * from UserDetail where u_name='"& session("priusername") &"'" ,conn,3
							If Not rs.eof  Then
								session("priusername")=""
								session("u_sysid")=rs("u_id")
								session("user_name")=rs("u_name")
								session("u_levelid")=rs("u_level")
								session("u_level")=rs("U_levelName")
								session("u_remcount")=rs("u_remcount")
								session("u_borrormax")=rs("u_borrormax")
								session("u_resumesum")=rs("u_resumesum")
								session("u_checkmoney")=rs("u_checkmoney")
								session("u_usemoney")=rs("u_usemoney")
								session("u_type")=rs("u_type")
								session("u_email")=rs("u_email")
								session("bizbid") = rs("u_father")
								rs.close
								conn.close
								Response.redirect "default.asp"
							End If
						End If
							Response.Write "您已经超时重新登陆, <a href="&InstallDir&"""default.asp"">重新登陆</a>"
						End Select
%>