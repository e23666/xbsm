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
<table bgColor="#cdcdcd" border="0" cellPadding="0" cellSpacing="0" width="685" height="1">
<tbody>
  <tr align="middle">
	<td height="1">
	<div align="center">
	  <table bgcolor="#FFFFFF" border="0" cellPadding="5" cellSpacing="0" width="683" height="1">
		<tbody>
		<tr>
		  <td height="219" width="138" valign="top">
		  <div align="left">
			<table border="1" borderColor="#5785B2" cellPadding="0" cellSpacing="0" id="AutoNumber3" style="border-collapse: collapse" width="130" height="118">
			<tbody>
			  <tr>
				<td width="124" height="12" align="center">
				</td>
			  </tr>
			</tbody>
			</table>
		  </div>
		  </td>
		  </center>
		  <td height="4" width="525" valign="top" bgcolor="#FFFFFF">
			<!--身体主要内容开始-->
			<table   borderColor="#5785B2" cellPadding="0" cellSpacing="0" id="AutoNumber3" style="border-collapse: collapse" width="130" height="118">
			  </tbody>
			  <tr>
				<td height="4" width="527" valign="top" bgcolor="#FFFFFF">
				  <img border="0" src="/images/manage/allline.gif" width="458" height="13"><br>
				  <b><%
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

								rs.close
								conn.close
								Response.redirect "default.asp"
							End If
							End If
							Response.Write "您已经超时重新登陆, <a href=""/default.asp"">重新登陆</a>"
						End If
%>
				  </b><br>
				  <img border="0" src="/images/manage/allline.gif" width="458" height="13">
			    </td>
			  </tr>
 			</tbody>
			</table>
			<!--身体主要内容结束-->
		  </td>
		</tr>
	  </tbody>
	  </table>
    </div>
	</td>
  </tr>
</tbody>
</table>





