<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
				  <%
						module=Requesta("module")
						Select Case module
						  Case "enter"
							username=Requesta("username")
							conn.open constr
							rs.open "select * from UserDetail where u_name='"& username &"' and u_type =0 and f_id=" & Session("u_sysid") ,conn,3
						
							If Not rs.eof  Then
								session("vcp_user")=session("user_name")
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
								rs.close
								conn.close
								Response.write "<script language=javascript>top.location.href='/manager';</script>"
								Response.end
							End If
							rs.close
							conn.close
							url_return "权限不足或用户未找到",-1

						  Case "returnme"
							If session("vcp_user")<>"" Then
							conn.open constr
							rs.open "select * from UserDetail where u_name='"& session("vcp_user") &"'" ,conn,3
							If Not rs.eof  Then
								session("vcp_user")=""
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
								Response.redirect "/vcp/vcp_index.asp"
							End If
						End If
							Response.Write "您已经超时重新登陆, <a href=""/default.asp"">重新登陆</a>"
						End Select
%><!--#include virtual="/config/bottom_superadmin.asp" -->
