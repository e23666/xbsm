<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<%
conn.open constr
On Error Resume Next
if not iscolumnname("pricelist","p_wfirstPrice_renew") then
	conn.execute "alter table pricelist add column p_wfirstPrice_renew Currency default 0"
end if
if not iscolumnname("pricelist","p_wprice_renew") then
	conn.execute "alter table pricelist add column p_wprice_renew Currency default 0"
end if
if not iscolumnname("registerDomainPrice","wRenewPrice") then
	conn.execute "alter table registerDomainPrice add column wRenewPrice Currency default 0"
end if
conn.execute("update productlist set P_size=500 where p_proId='tw001'")
conn.execute("update productlist set P_size=600 where p_proId='tw002'")
conn.execute("update productlist set P_size=700 where p_proId='tw003'")
conn.execute("update productlist set P_size=3000 where p_proId='tw006'")
conn.execute("update productlist set P_size=5000 where p_proId='tw007'")
function iscolumnname(byval tabel,byval columnname)
	iscolumnname=false
	sql="select top 1 * from "& tabel
	rs11.open sql,conn,1,1
	for i=0 to rs11.fields.count-1
		if trim(columnname)=trim(rs11.fields(i).name) then
			iscolumnname=true
			exit for
		end if
	next
	rs11.close
end function
conn.close
%>