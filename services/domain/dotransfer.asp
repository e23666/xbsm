<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
Response.Charset="GB2312"
if instr(api_url,"api.west263.com")=0 then Die "此功能无法使用，请联系管理员"

act=requesta("act")
u_name	 = session("user_name")

if lcase(USEtemplate)="tpl_2016" then
	domainlist=Replace(requesta("domainlist")&"","~","╂")
	domain=""
	authcode=""
	For Each line In Split(domainlist,vbcrlf)
		If InStr(line," ")>0 Then
			ipos=instr(line," ")
			If Trim(domain)	="" Then
				domain=Trim(mid(line,1,ipos))
				authcode=Trim(mid(line,ipos+1,Len(line)))
			Else
				domain=Trim(domain&vbcrlf&mid(line,1,ipos))
				authcode=Trim(authcode&vbcrlf&mid(line,ipos+1,Len(line)))
			End if
		End if
	Next
 else
	domain   = LCase(requesta("domain")) '域名
	authcode = request("authcode")		'密码
End if
chgdns		= requesta("chgdns"):if chgdns<>"1" then chgdns="0"
set session("transferdomain")=Server.CreateObject("Scripting.Dictionary")
session("chgdns")=chgdns
call checkTransferok(domain,authcode,str)
if str<>"" then
die url_return(str,-1)
end if
a=session("transferdomain").Keys
c_dm=""
c_pw=""
for i=0 to session("transferdomain").count-1
'response.Write(a(i)&":"&session("transferdomain").item(a(i))&"<BR>")
 if c_dm="" then
 c_dm=a(i)
 c_pw=session("transferdomain").item(a(i))
 else
 c_dm=c_dm&"~"&a(i)
 c_pw=c_pw&"~"&session("transferdomain").item(a(i))
 end if
next

strcmd="domainname"&vbcrlf&_
	   "transfer"&vbcrlf&_
		"entityname:check"&vbcrlf&_
		"domain:"&c_dm&""&vbcrlf&_
		"authcode:"&c_pw&""&vbcrlf&_
		"."&vbcrlf
 
 loadRet=connectToUp(strcmd)
 
' loadRet="200 ok"
 if left(loadRet,3)<>200 then
	 session("transferdomain").RemoveAll
	 %>
		
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>域名注册域名申请国际域名国内域名cn域名注册-网站名称</title>
    <meta name="description" content="网站名称是国内著名的虚拟主机和域名注册提供商，名列全国10强。独创的第6代虚拟主机管理系统，拥有在线数据恢复、Isapi自定义，木马查杀等30余项领先功能.千M硬件防火墙,为您保驾护航！双线虚拟主机确保南北畅通无阻！">
    <meta name="keywords" content="虚拟主机,网站名称,域名注册,主机租用,主机,服务器租用,域名,网站空间,主机托管,双线虚拟主机,asp空间">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/domain.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/tp2016.css">
    <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery.superslide.2.1.1.x.js"></script>
	<script type="text/javascript">
	<!--
      alert("<%=replace(loadRet,vbcrlf,"\r\n")%>");
	  history.back()
	//-->
	</script>
</head>
<body>
	 
	
</body>
</html>
 <%
 else
	response.Redirect("transfer.asp?t=input")
 end if

 
 

'检查传入的域名资料是否ok
function checkTransferok(d,p,err_str)
checkTransferok=false
d_array=split(d,vbcrlf)
p_array=split(p,vbcrlf)
err_str=""
    '密码与域名数不一致
	if ubound(d_array)<>ubound(p_array) then
		err_str="域名数与密码数不一致"
		exit function
	end if
	
	for i=0 to ubound(d_array)
	  if GetsRoot(d_array(i))<>d_array(i) then
	    err_str=d_array(i)&",请填写正确的顶级域名"
		exit function
	  end if
	 if InStr(","&DomainTransfer&",",","&GetDomainType(d_array(i))&",")=0 then
	    err_str=d_array(i)&",不支持该类型域名转入"
		exit function
	 end if 
	 '过滤重复
	 if  not session("transferdomain").Exists(d_array(i)) then
	     session("transferdomain").add d_array(i),p_array(i)
	 end if
	next
end function



%>