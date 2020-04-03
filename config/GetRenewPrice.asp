<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="../css/Admin_Style.css">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
</head>
<style type="text/css">
<!--
body {
	background-color: #efefef;
	padding:0px;
	margin:0px;
}
-->
</style>
<body>
<%

conn.open constr
user_name=requesta("user_name")
ProId=requesta("proid")
years=requesta("years")
p_name=requesta("p_name")&""
p_prices=GetNeedPrice(user_name,ProId,years,"renew")
if p_name<>"" and not isDomain(p_name&"") then
		otherip=getOtherip(p_name,user_name)
		if isip(otherip) then
			ipprice=getneedprice(user_name,"vhostaddip",years,"renew")
			if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
			p_prices=cdbl(p_prices)+cdbl(ipprice)
		end if
end if

response.Write(p_prices)
conn.close
%>
</body>
</html>
