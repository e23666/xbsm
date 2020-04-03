<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%
response.Charset="gb2312"
call needregsession()
conn.open constr
act=requesta("act")
set sb=new buyServer_Class
sb.getPostvalue()
sb.setUserid=session("u_sysid")

if act="getVpsPayMethod" then
	response.write sb.getVpsPayMethod()
	conn.close
	response.end
elseif act="getvpsprice" then
	otherStr=""
	If trim(requesta("PayMethod"))="0" And firstvpsdiscount<1 Then
     otherStr="<font color=color:""#f0f"">(йвтб"&firstvpsdiscount*10&"ушль╩щ)</font>"
	 End if
	call sb.getServerPrice("new")
	response.write sb.PricMoney&otherStr
	conn.close
	response.end
elseif act="buysub" then
	sb.buysub()
	conn.close
	response.end
end if
'==================================================================================





%>
