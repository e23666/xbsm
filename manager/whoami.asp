<!--#include virtual="/config/config.asp" -->
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<b>
<%
						If Requesta("module")="returnme" Then
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
								
									 session("u_email")=rs("u_email")
						session("u_contract")=rs("u_contract")
						session("u_address")=rs("u_address")
						session("msn")=rs("msn_msg")

								rs.close
								conn.close
								Response.redirect SystemAdminPath&"/default.asp"
							End If
							End If
							Response.Write "您已经超时重新登陆, <a href=""/default.asp"">重新登陆</a>"
						End If
%>
</b> 