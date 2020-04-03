<%
dologout=true
If trim(session("u_sysid"))&""="" or trim(Session("safecode"))<>trim(sqlincode(request.Cookies("safecode"))) Then
	dologout=not check_is_cookie() 
	
else
	
    conn.open constr
	rs.open "select u_usemoney,u_resumesum,u_premoney from userdetail where u_id=" & session("u_sysid"),conn,1,1
	if not rs.eof then
		dologout=false
		session("u_usemoney")=FormatNumber(rs("u_usemoney"),-1,-1)
		session("u_resumesum")=FormatNumber(rs("u_resumesum"),-1,-1)
		session("u_premoney")=rs("u_premoney")'сех╞
	end if
	rs.close
	conn.close
End If
if dologout then
	response.write "<script language=javascript>parent.location.href='/login.asp';</script>"
	response.end
end if
if USEtemplate="Tpl_01" then
	managercss1="/Template/Tpl_01/css/css.css"
	managercss2="/manager/css/new_default01.css"
elseif USEtemplate="Tpl_02" then
	managercss1="/Template/Tpl_02/css/css.css"
	managercss2="/manager/css/new_default01.css"
elseif USEtemplate="Tpl_03" then
	managercss1="/Template/Tpl_03/css/css.css"
	managercss2="/manager/css/new_default01.css"
elseif USEtemplate="Tpl_04" then
	managercss1="/Template/Tpl_04/css/css.css"
	managercss2="/manager/css/new_default02.css"
elseif USEtemplate="Tpl_05" then
	managercss1="/Template/Tpl_05/css/Global.css"
	managercss2="/manager/css/new_default.css"
end if
 %>