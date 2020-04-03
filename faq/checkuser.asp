<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<!--#include file="md5.asp"-->
<%
if Request("method") = "login" then
	username = Qcdn.checkStr(Trim(Request("username")))
	password = md5(Qcdn.checkStr(Trim(Request("password"))),16)
	usercookies = Request("usercookies")

	dim cookies_path_s
	dim cookies_path_d
	
	cookies_path_s=split(Request.ServerVariables("PATH_INFO"),"/")
	cookies_path_d=ubound(cookies_path_s)
	cookiepath="/"
	for i=1 to cookies_path_d-1
		cookiepath=cookiepath&cookies_path_s(i)&"/"
	next

	sql = "Select Unid,[password],username from article_User where username = '"& username &"'"
	set rs = conn.execute(sql)
	if rs.eof and rs.bof then
		Response.write "<script>alert(""填写的信息有误"");history.back();</script>"
		rs.close 
		Response.end()
	else
		if cstr(password) <> cstr(rs(1)) then
			Response.write "<script>alert(""填写的信息有误"");history.back();</script>"
			set rs = close
			Response.end()
		else
			select case usercookies
	       	 	case 0
  				Response.Cookies("qcdn")("usercookies") = usercookies
	        	case 1
	        	Response.Cookies("qcdn").Expires=Date+1
  				Response.Cookies("qcdn")("usercookies") = usercookies
	        	case 2
	        	Response.Cookies("qcdn").Expires=Date+31
  				Response.Cookies("qcdn")("usercookies") = usercookies
	        	case 3
	        	Response.Cookies("qcdn").Expires=Date+365
  				Response.Cookies("qcdn")("usercookies") = usercookies
	        end select
			Response.Cookies("qcdn")("user_name") = rs("username")
			Response.Cookies("qcdn")("password") = rs("password")
			Response.Write("<script>alert(""登陆成功"");location.href=""index.asp"";</script>")
			
		end if
	end if

end if
%>