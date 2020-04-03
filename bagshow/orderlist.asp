<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
tpl.set_unknowns "remove"
productType=requesta("productType")
orderid=requesta("orderid")
if orderid="" then url_return "参数错误",-1
conn.open constr
call setHeaderAndfooter()


SELECT CASE lcase(trim(productType))
	CASE "host"
		sql="select a.*,b.p_name from PreHost a inner join Productlist b on (a.proid=b.p_proid)  where a.OrderNo='"& orderid & "' and a.u_name='"& session("user_name") &"'"
		
		rs.open sql,conn,1,1
		
		if not rs.eof then
			productid=rs("proid")
			vyears=rs("years")
			domainstr=rs("domains")
			ftpaccount=rs("ftpAccount")
			ftppassword=rs("ftppassword")
			price=rs("price")
			productName=rs("p_name")
			sDate=rs("sDate")
			allprice= GetNeedPrice(session("user_name"),productid,vyears,"new")
		else
			url_return "没有找到您的订单号",-1
		end if
		rs.close
		if isnumeric(OrderID) and OrderID<>"" then OrderID=100000 + clng(OrderID)
		call setwebhostingLeft()
		tpl.set_file "orderlist",USEtemplate&"/config/webhostingLeft/orderlisttxt.html"
		tpl.set_file "main", USEtemplate&"/bagshow/orderlist.html"
		tpl.set_var "domainstr",domainstr,false
		tpl.set_var "productname",ftpaccount & "[" & productid & "]",false
		tpl.set_var "price",price,false
		tpl.set_var "vyears",vyears,false
		tpl.set_var "OrderID",OrderID,false
		tpl.parse "#orderlisttxt.html","orderlist",false	
		tpl.parse "mains","main",false
		tpl.p "mains" 
		call host_sendMail()
	CASE "domain"
		sql="Select * from PreDomain Where d_id in (" & orderid & ") and username='" & session("user_name") &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
			call setDomainLeft()
			tpl.set_file "orderlist", USEtemplate&"/config/DomainLeft/orderlisttxt.html"
			tpl.set_file "main", USEtemplate&"/bagshow/orderlist.html"
			tpl.set_block "main", "bagshoworderlist", "list"
			newdomainname=""
			do while not rs.eof
				newordid=clng(rs("d_id")) + 100000
				productname=rs("strDomain")
				newdomainname=newdomainname & rs("strDomain") & " "
				price=rs("price")
				vyears=rs("years")
				sDate=rs("regdate")
				productid=rs("proid")
				allprice=GetNeedPrice(session("user_name"),productid,vyears,"new")
				password=rs("strDomainpwd")
				
				tpl.set_var "productname",productname,false
				tpl.set_var "price",price,false
				tpl.set_var "vyears",vyears,false
				tpl.parse "list", "bagshoworderlist", true
				call domain_sendMail()
			rs.movenext
			loop
		else
			url_return "没有找到域名订单",-1
		end if
		rs.close
		OrderIDlist=""
		for each neworderid in split(orderid,",")
			if neworderid<>"" and isnumeric(neworderid) then
				OrderIDlist=OrderIDlist & (100000 + clng(newOrderID)) & "   "
			end if
		next
		
		tpl.set_var "domainstr",newdomainname,false
		tpl.set_var "OrderID",OrderIDlist,false
		tpl.parse "#orderlisttxt.html","orderlist",false	
		tpl.parse "mains","main",false
		tpl.p "mains" 
	case "server"
		sql="select * from HostRental where id="& orderid &" and u_name='"& session("user_name") &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
			tpl.set_file "orderlist", "Tpl_05/config/server/orderlisttxt.html"
			tpl.set_file "main", USEtemplate&"/bagshow/orderlist.html"
			p_proid=rs("p_proid")
			price=requesta("PricMoney")
			vyears=rs("Years")
			hosttype=rs("hosttype")
			if not hosttype then
				p_proid="服务器租用"
				price="待联系"
			end if
		else
			url_return "没有找到订单",-1
		end if
		rs.close
		tpl.set_var "productname",p_proid ,false
		tpl.set_var "price",price,false
		tpl.set_var "vyears",vyears,false
		tpl.set_var "OrderID",orderid,false
		tpl.parse "#orderlisttxt.html","orderlist",false	
		tpl.parse "mains","main",false
		tpl.p "mains" 
	case else
		url_return "参数错误",-1
END SELECT



set tpl=nothing
conn.close



sub host_sendMail()
	if trim(domainstr)&""="" then domainstr="暂没绑定" 
	getStr= "domainstr=" & domainstr & "," & _
			"productid=" & productid &"," & _
			"vyears=" & vyears & "," & _
			"ftpaccount=" & ftpaccount & "," & _
			"ftppassword=" & ftppassword & "," & _
			"price=" & price & "," & _
			"allprice=" & allprice & "," & _
			"productName=" & productName & "," & _
			"OrderID=" & OrderID & "," & _
			"now=" & sDate
			
	mailbody=redMailTemplate("webhostorderlist.txt",getStr)
	call sendMail(session("u_email"),"主机订单提交成功!",mailbody)
end sub
sub domain_sendMail()
	getStr= "productid=" & productid &"," & _
			"vyears=" & vyears & "," & _
			"domainpassword=" & password & "," & _
			"price=" & price & "," & _
			"allprice=" & allprice & "," & _
			"productName=" & productName & "," & _
			"OrderID=" & newordid & "," & _
			"now=" & sDate
	mailbody=redMailTemplate("domainorderlist.txt",getStr)
	call sendMail(session("u_email"),"域名订单提交成功!",mailbody)
end sub
%>