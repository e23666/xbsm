<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%

response.Charset="gb2312"
Dim  orderlist
Dim ordercount
Dim orderdetail
conn.open constr
session("myshopcart")=""
'取消删除
'conn.execute("delete from ShopCart where s_status=1")
if session("w_from")<>"" then session("w_from")=""
if requesta("act")="clearallcart" then
	'只删除状态为0的数据
	conn.execute("delete from ShopCart where userid="&session("u_sysid")&" and s_status=0")
	response.redirect("/")
	die ""
end If

if requesta("act")="del" then
	'只删除状态为0的数据
	checkitem=requesta("checkitem")
	If Not  isnumeric(checkitem&"") Then checkitem=0
	If checkitem>0 then
		conn.execute("delete from ShopCart where userid="&session("u_sysid")&" and cartID="&checkitem&" and s_status=0")
			die "200 ok"
	Else
		die "500 nothing"
	End if

end If

set shopcart=conn.execute("select * from ShopCart where userid="&session("u_sysid")&"  and s_status=0")

 
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/bagshow/default.html"  
if not shopcart.eof then
						
	if trim(requesta("module"))="orderdelete" then
		cartid=Requesta("cartid")
		if not isnumeric(cartid&"") then cartid=0
		call del_shop_car(session("u_sysid"), cartid)
		Response.redirect request("script_name")
		response.end
	end if
	ProductPriceSum=0
	tpl.set_var "display","style=""display:none""",false
	tpl.set_var "displaylist","",false
	tpl.set_block "main", "orderlist", "list"
	bh=1
	do while not shopcart.eof
		'response.write replace(ordercontent,vbcrlf,"<br>")
		ordercontent=shopcart("cartContent")
		orderid=shopcart("cartid")
		pdstr=trim(left(ordercontent,instr(1,ordercontent&vbcrlf,vbCrLf)-1))
'如果是虚拟主机，计算虚拟主机的价格等。
		if pdstr="vhost" then 
			Producttype=1
			keyword=getstrReturn(ordercontent & vbCrLf, "ftpuser")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "paytype")&"")
			myvhostyears=getstrReturn(ordercontent&vbCrLf , "years")
			iptype=getstrReturn(ordercontent&vbCrLf , "iptype")
			
			isfree=getstrReturn(ordercontent&vbCrLf,"gift")
			attach_type=getstrReturn(ordercontent&vbCrLf,"attach-type")
			attach_ident=getstrReturn(ordercontent&vbCrLf,"attach-ident")
			
			call setFreeShow(pdstr,attach_type,attach_ident,orderid,ordercontent)
			if trim(isfree)="true" and paytype<>"1" then
				productprice=0
				productName=productName & "[赠品免费]"
			else
			
				If paytype="1" and trim(session("u_sysid"))&""<>"" Then
						Audsql="select top 1 u_Auditing from userDetail where u_id="& session("u_sysid")
						set Audrs=conn.execute(Audsql)
						if not Audrs.eof then
							if trim(AudRs(0))="1" then
								url_return "您需要通过管理员审核后才能开通试用主机!",-1
							end if
						end if
						Audrs.close
					if isNumeric(demoprice) then
						productprice=demoprice
					else
						productprice=5
					end if
				Else
					productprice =  GetNeedPrice(session("user_name"),productid,myvhostyears,"new")
					if iptype&""="1" then
						if lcase(left(productid,2))="tw" then
							ipproid="twaddip"
							else
							ipproid="vhostaddip"
						end if
							ipprice =  GetNeedPrice(session("user_name"),ipproid,myvhostyears,"new") 
						if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
					end if
					productprice=cdbl(productprice)+cdbl(ipprice)
				End If
			end if
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If
		if pdstr="server" then 
			keyword=getstrReturn(ordercontent & vbCrLf, "hostid")
			productid=getstrReturn(ordercontent&vbCrLf , "p_proid")
			productName=getstrReturn(ordercontent&vbCrLf  , "cpu")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "paymethod")&"")
			byserveryears=getstrReturn(ordercontent&vbCrLf , "years")
			productprice = getstrReturn(ordercontent&vbCrLf , "pricmoney")
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		end if
		'如果是企业邮局，计算企业邮局的价格等。
		If pdstr="yunmail" Then 
			Producttype=2
			keyword=getstrReturn(ordercontent & vbCrLf, "domain")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "istry")&"")
			bymailyears=getstrReturn(ordercontent&vbCrLf , "alreadypay")
			postnum=getstrReturn(ordercontent&vbCrLf , "postnum")
			productprice=getstrReturn(ordercontent&vbCrLf , "ppricetemp") 
			productName=productName&"("&postnum&"用户,"&bymailyears&"月)"
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End if
		if pdstr="corpmail" then 
			Producttype=2
			keyword=getstrReturn(ordercontent & vbCrLf, "domainname")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "paytype")&"")
			bymailyears=getstrReturn(ordercontent&vbCrLf , "years")
			
				If paytype="1" Then
						Audsql="select top 1 u_Auditing from userDetail where u_id="& session("u_sysid")
						set Audrs=conn.execute(Audsql)
						if not Audrs.eof then
							if trim(AudRs(0))="1" then
								url_return "您需要通过管理员审核后才能开通试用邮局!",-1
							end if
						end if
						Audrs.close
					if not isNumeric(demomailprice) then demomailprice=15
					productprice=demomailprice
				Else
				   if  productid="diymail" then
					   bymailmailsize=getstrReturn(ordercontent&vbCrLf , "mailsize")
					   bymailusernum=getstrReturn(ordercontent&vbCrLf , "usernum")
                       productprice=getDiyMailprice(bymailmailsize,bymailusernum)*bymailyears
                  ' die bymailmailsize&"|"&bymailusernum
				   else
					productprice=GetNeedPrice(session("user_name"),productid,bymailyears,"new")
				   end if
				End If
				

			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If

'如果是mssql数据库，计算mssql的价格等。

	   If pdstr="mssql" then 
			Producttype=8
			keyword=getstrReturn(ordercontent&vbCrLf , "databasename")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			bymssqlyears=getstrReturn(ordercontent&vbCrLf , "years")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "paytype")&"")
			isfree=getstrReturn(ordercontent&vbCrLf,"gift")
			attach_type=getstrReturn(ordercontent&vbCrLf,"attach-type")
			attach_ident=getstrReturn(ordercontent&vbCrLf,"attach-ident")
			
			call setFreeShow(pdstr,attach_type,attach_ident,orderid,ordercontent)
			if trim(isfree)="true" then
				productprice=0
				productName=productName & "[赠品免费]"
			elseIf paytype="1" Then
						Audsql="select top 1 u_Auditing from userDetail where u_id="& session("u_sysid")
						set Audrs=conn.execute(Audsql)
						if not Audrs.eof then
							if trim(AudRs(0))="1" then
								url_return "您需要通过管理员审核后才能开通试用mssql!",-1
							end if
						end if
						Audrs.close
					if not isNumeric(demomssqlprice) then demomssqlprice=5
					productprice=demomssqlprice
			Else
				productprice=GetNeedPrice(session("user_name"),productid,bymssqlyears,"new")
			end if
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If
'如果是域名注册，计算域名的价格等。

		If pdstr="domainname" or pdstr="chinesedomain" Then 
			Producttype=3
			keyword=getstrReturn(ordercontent& vbCrLf, "domainname")
			If right(keyword,3)=".cn" Then 	Producttype=5
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			bydomainyears=getstrReturn(ordercontent&vbCrLf , "term")
			
			isfree=getstrReturn(ordercontent&vbCrLf,"gift")
			attach_type=getstrReturn(ordercontent&vbCrLf,"attach-type")
			attach_ident=getstrReturn(ordercontent&vbCrLf,"attach-ident")
			
			call setFreeShow(pdstr,attach_type,attach_ident,orderid,ordercontent)
			if trim(isfree)="true" then
				productprice=0
				productName=productName & "[赠品免费]"
			else

					productprice=GetNeedPrice(session("user_name"),productid,bydomainyears,"new")
				
			end if
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
			

		End If
'如果是搜索引擎产品，处理。
		If pdstr="search" then 
			Producttype=4
			keyword=getstrReturn(ordercontent&vbCrLf , "account")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			bysearchyears=getstrReturn(ordercontent&vbCrLf , "years")
			productprice=GetNeedPrice(session("user_name"),productid,bysearchyears,"new")
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If
		if pdstr="dnsresolve" then
			Producttype=5
			keyword=getstrReturn(ordercontent&vbCrLf , "domainname")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "productnametemp")
			bydnsyears=getstrReturn(ordercontent&vbCrLf , "term")
			productprice=GetNeedPrice(session("user_name"),productid,bydnsyears,"new")
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If

		if pdstr="miniprogram" then
			Producttype=17
			keyword=getstrReturn(ordercontent&vbCrLf , "appname")
			productid=getstrReturn(ordercontent&vbCrLf , "producttype")
			productName=getstrReturn(ordercontent&vbCrLf  , "appname")
			bydnsyears=getstrReturn(ordercontent&vbCrLf , "years")
			paytype=trim(getstrReturn(ordercontent&vbCrLf  , "paytype")&"")
			if paytype&""="1" then
				productprice=miniprogram_paytype_money
			else
				productprice=GetNeedPrice(session("user_name"),productid,bydnsyears,"new")
			end if
			ProductPriceSum=cdbl(ProductPriceSum) + cdbl(productprice)
		End If
		
		

	tpl.set_var "product_id_name",bh&"、"& productid & "-" & productName, false
	tpl.set_var "keyword",keyword,false
	tpl.set_var "productprice",formatnumber(productprice,0,-1,-1,0),false
    ordersumcount=ordersumcount+formatnumber(productprice,0,-1,-1,0)
	
	tpl.set_var "delhref",request("script_name")&"?module=orderdelete&cartid="& orderid,false
    tpl.parse "list", "orderlist", true
	bh=bh+1
	shopcart.movenext
	loop
	session("ordermoneysum")=ProductPriceSum
	tpl.set_var "serviceorder","/serviceorder/default.asp?ordermoneysum="& ProductPriceSum,false
else
	tpl.set_var "display","",false
	tpl.set_var "displaylist","style=""display:none""",false
	tpl.set_var "serviceorder","##",false
End If
   'die session("u_usemoney")&"|"&cdbl(ProductPriceSum)
    me_use=cdbl(ProductPriceSum)-cdbl(session("u_usemoney"))
  ' me_use=cdbl(ProductPriceSum)
	tpl.set_var "u_usemoney",me_use,False
	
	tpl.set_var "ProductPriceSum",ProductPriceSum,False
	if clng(bh)>0 then
		tpl.set_var "Productcount",(bh-1),False
	else
		tpl.set_var "Productcount",0,False
	end if
 
tpl.parse "mains","main",false
tpl.p "mains"
set tpl=nothing

function delorder(byval ywtype,byval ywname)
	'set shopcart=conn.execute("delete from ShopCart where userid="&session("u_sysid")&" and ywtype='"&ywtype&"' and ywname='"&ywname&"'")
end function
function setFreeShow(byval pdstr,byval attach_type,byval attach_ident,byval cartid,byval carcontent)
  'die pdstr&"|"&attach_type&"|"&attach_ident
	if isfree="true" then
		presql="select * from free where f_type='"& trim(attach_type) &"' and f_freeName='"& trim(attach_ident) &"' and f_isget="&PE_False&""
	'	die presql
		rs11.open presql,conn,1,1
		if not rs11.eof then
				cur1=0
					attach_types=getstrReturn(carcontent&vbCrLf,"attach-type")
					attach_idents=getstrReturn(carcontent&vbCrLf,"attach-ident")
					pdstrs=trim(left(carcontent,instr(1,carcontent&vbcrlf,vbCrLf)-1))
					'die pdstrs
					if trim(attach_types)=trim(attach_type) and trim(attach_idents)=trim(attach_ident) and trim(pdstr)=trim(pdstrs) then
						cur1=cur1+1
						if cur1>1 then
							conn.execute("delete from ShopCart where userid="&session("u_sysid")&" and cartid="&cartid)
							Response.redirect request("script_name")
							response.end
						end if
						
					end if
		else
			isfree="false"
		conn.execute("delete from ShopCart where userid="&session("u_sysid")&" and cartid="&cartid)
			Response.redirect request("script_name")
			response.end
		end if
		rs11.close
	end if
	
end function

%>
<%'=session("order")%>