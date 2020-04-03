<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%Check_Is_Master(1)%> 
<%
Response.CodePage=936
Response.Charset="gb2312"
conn.open constr
action=requesta("action")

select case action

case "clearall"
clearall()
case "njg"
 
njg()
end select 

sub clearall()
conn.execute("delete from pricelist")
conn.execute("delete from RegisterDomainPrice")
Response.Write("<script>alert('价格清除完成，请先同步产品价格后操作');location.href='syncPro.asp'</script>")
end sub


sub njg()
conn.execute("delete  from pricelist where p_u_level<>1 and u_id=0")
conn.execute("delete from RegisterDomainPrice")
sql="select * from pricelist where p_u_level=1 and u_id=0"
rs.open sql,conn,1,3
rs1.open sql,conn,1,3
do while not rs.eof

if isnull(rs("p_price_renew"))  or rs("p_price_renew")=0 then
rs("p_price_renew")=rs("p_price")
p_price_renew=rs("p_price")
rs.update
else
p_price_renew=rs("p_price_renew")
end if


	for i=2 to 7
		rs1.addnew
		rs1("p_u_level")=i
		rs1("u_id")=0
		rs1("p_father")=1
		rs1("p_proid")=rs("p_proid")
		rs1("p_price")=rs("p_price")
		rs1("p_price_renew")=p_price_renew
		rs1("p_sysid")=rs("p_sysid")
		rs1("p_firstPrice")=rs("p_firstPrice")
		rs1("p_firstPrice_renew")=rs("p_firstPrice_renew")
		rs1("p_wfirstPrice_renew")=rs("p_wfirstPrice_renew")
		rs1("p_wprice_renew")=rs("p_wprice_renew")
		rs1.update
	next
rs.movenext
loop

Response.Write("<script>alert('价格操作完成，现在进入打折页面');location.href='adjustPrice.asp'</script>")
end sub
%>