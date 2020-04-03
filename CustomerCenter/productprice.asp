<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
call setHeaderAndfooter()
conn.open constr
tpl.set_file "main", USEtemplate&"/customercenter/productprice.html"
tpl.set_file "left", USEtemplate&"/config/customercenterleft/CustomerCenterLeft.html"
tpl.parse "#CustomerCenterLeft.html","left",false
 

tpl.set_block "main", "productlist", "myprolist"
If isdbsql Then
		sql="select productlist.p_type,productlist.P_proId, productlist.p_price, productlist.p_memo, productlist.p_name, producttype.pt_name, productlist.p_size,pricelist.p_price,pricelist.p_firstprice  from productlist   inner join producttype   on productlist.p_type = producttype.pt_id inner join pricelist   on  productlist.p_proid= pricelist.p_proid where p_u_level=1 and  productlist.p_type not in (4,6)   order by productlist.p_type,pricelist.p_price asc"
Else
	sql="select t.*,(b.p_price) as p_price  from (select  productlist.p_type,productlist.P_proId, productlist.p_price, productlist.p_memo, productlist.p_name, producttype.pt_name, productlist.p_size  from productlist   inner join producttype   on productlist.p_type = producttype.pt_id) as t inner join  pricelist as b   on  b.p_proid= t.p_proid  where p_u_level=1 and  p_type not in (4,6) order by p_type asc,b.p_price asc"
End if
rs.open sql,conn,1,3
if not rs.eof then
	do while not rs.eof
		renewprice=rs("p_price")
		tpl.set_var "productname", rs("p_name"),false
		tpl.set_var "productprice",  "<span class='price'>" & renewprice & "元</span>",false
		tpl.set_var "productsize", Swichunit(rs("pt_name"),rs("p_size")),false
		tpl.set_var "productclass", replace(rs("pt_name"),"VPS服务器","服务器"),false
		tpl.set_var "productbuylink", GetProByStr(rs("pt_name"),rs("P_proId")),false

		tpl.parse "myprolist", "productlist", true
	rs.movenext
	loop
end if
rs.close

tpl.parse "mains","main",false
tpl.p "mains" 
		
set tpl=nothing


function SwichDomainTypePrice(pid,pprice)
	if instr("domcom,domnet,domorg",rs("P_proId"))<>0 then
		SwichDomainTypePrice="首年 <span class='price'>55</span> 元,续费 <span class='price'>80</span> 元"
	elseif instr("domcn,domcomcn,domnetcn,domorgcn",rs("P_proId"))<>0 then
		SwichDomainTypePrice="<span class='price'>"&dom_cn_price_page&"</span> 元,续费 <span class='price'>80</span> 元"
	else
		SwichDomainTypePrice="<span class='price'>"&pprice&"</span> 元"
	end if
end function

function Swichunit (pt_name,pt_size)
	if pt_name="空间" or pt_name="邮局" or pt_name="数据库" then
		Swichunit=pt_size&"MB"
	end if
end function


function GetProByStr(pt,proid)
	select case pt 
		case "空间"
			if proid<>"b050" then
				GetProByStr="<a href='/services/webhosting/buy.asp?productid="&proid&"'>详情/购买</a>"
			else
				GetProByStr="<a href='/services/webhosting/'>详情/购买</a>"
			end if	
		case "域名"
			GetProByStr="<a href='/services/domain/'>详情/购买</a>"
		case "邮局"
			GetProByStr="<a href='/services/mail/buy.asp?productid="&proid&"'>详情/购买</a>"
		case "搜索引擎"
			GetProByStr="<a href='/services/search/'>详情/购买</a>"
		case "DNS管理"
			GetProByStr="<a href='/services/domain/dns.asp'>详情/购买</a>"
		case "数据库"
			GetProByStr="<a href='/services/webhosting/database.asp'>详情/购买</a>"
		case "套餐"
			GetProByStr="<a href='/services/Package/'>详情/购买</a>"
	end select
end function



%>