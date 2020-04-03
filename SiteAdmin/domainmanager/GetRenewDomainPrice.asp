<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<style type="text/css">
<!--
body {
	background-color: #efefef;
}
-->
</style></head>
<body>
<%

conn.open constr
user_name=requesta("u_name")
u_level=requesta("u_level")
ProId=requesta("proid")
years=requesta("years")
domreg=requesta("domreg")
strdo=requesta("strdo")

if years="" then
	p_prices=""
else
	p_prices=GetNeedPrice(user_name,ProId,years,"renew")
	sql="select regdate,years from domainlist where strdomain='"&strdo&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		regdate=rs(0)
		buyyear=rs(1)
	end if
end if

if datediff("s","2007-3-7 12:00:00",regdate)>=0 and datediff("s","2008-1-1 00:00:00",regdate)<0 and years=1 and ProId="domcn" and datediff("s","2008-1-10 00:00:00",now())>0 and datediff("s","2009-1-1 00:00:00",now())<0 and buyyear=1 then
	if u_level="1" then
		p_prices="10"
	else
		p_prices="1"
	end if
end if


response.Write(p_prices)
conn.close
%>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
