<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
t=request("t")
n=request("n")
conn.open constr
dim u_name
if checkowner(t,n,u_name) then
  uni=ToUnixTime(now(),8)
  
  retstr=GetOperationPassWord(n,"host",u_name)
  if left(retstr,3)="200" then
	 	p=getReturn(retstr,"ftppassword")
	    sign=WestSing(n,p,uni)
		'url="http://www.myhostadmin.net/vhost/checklogin.asp?ftpname="&n&"&sign="&sign&"&time="&uni
		api_post_url="http://www.myhostadmin.net/vhost/checklogin.asp"
		if ishttps() then
			api_post_url="https://www.myhostadmin.net/vhost/checklogin.asp"
		end if


		%>
		<FORM METHOD=POST ACTION="<%=api_post_url%>" name="okform" id="okform">
			<INPUT TYPE="hidden" NAME="ftpname" value="<%=n%>"><INPUT TYPE="hidden" NAME="sign" value="<%=sign%>"><INPUT TYPE="hidden" NAME="time" value="<%=uni%>">	<%
			if instr(api_url,"api.west263.com")=0 then
			%>
			<INPUT TYPE="hidden" NAME="u" value="<%=api_username%>">
			<%end if%>
			<SCRIPT LANGUAGE="JavaScript">
			<!--
				 okform.submit()
			//-->
			</SCRIPT>
		</FORM>
		<%
		'die "<a href="""&url&""">"&url&"</a>"
		//response.redirect(url)
  else
	die "<script>alert('网络错误请稍后再试!');location.href='/'</script>"
  end if
else
die "<script>alert('您没有权限使用此操作！');location.href='/'</script>"
end if


function checkowner(byval t,byval n,u_name)
	checkowner=false
	newsql=" and vhhostlist.S_ownerid="&session("u_sysid")&""

    if not (session("u_type")="" or IsNull(session("u_type")) or session("u_type")&""="0") then newsql=""
	select case trim(t)
		case "vhost"
			sql="select top 1 u_name   from  userdetail inner join vhhostlist on userdetail.u_id=vhhostlist.S_ownerid where  vhhostlist.s_comment='"&n&"'"&newsql
			set u_rs=conn.execute(sql)
			if not u_rs.eof then
				u_name=u_rs(0)
				checkowner=true
			end if
			u_rs.close 
	end select
end function
%>