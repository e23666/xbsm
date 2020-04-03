<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->
<%
xmlpath=server.MapPath("/database/data.xml")
page_main=server.URLEncode("/manager/onlinepay/onlinePay.asp")
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/customercenter/howpay.html"
tpl.set_file "left", USEtemplate&"/config/customercenterleft/CustomerCenterLeft.html"
tpl.set_var "page_main",page_main,false

tpl.set_block "main", "bankPararLists", "a"
tpl.set_block "bankPararLists", "bankItemLists", "b"

	
		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		set myobjNode = isNodes("bankcount","",xmlpath,0,objDoms)
		for each myitems in myobjNode.childNodes
			rootid=myitems.Attributes.getNamedItem("id").NodeValue
			rootparid=myitems.Attributes.getNamedItem("parid").NodeValue
			roottitle=myitems.Attributes.getNamedItem("title").NodeValue
			if trim(rootparid)="0" then
				tpl.set_var "roottitle",roottitle,false
				tpl.unset_var "b"
			
			''''''''''''''''''for2''''''''''''''''
				for each itemNode1 in myobjNode.childNodes
					id=itemNode1.Attributes.getNamedItem("id").nodeValue'id
					title=itemNode1.Attributes.getNamedItem("title").nodeValue'标题
					parid=itemNode1.Attributes.getNamedItem("parid").nodeValue'实别id
					'''''''''''''''''''''''''''''''
					logo=itemNode1.Attributes.getNamedItem("logo").nodeValue'图片
					bankname=itemNode1.Attributes.getNamedItem("bankname").nodeValue'开户银行
					bankcode=itemNode1.Attributes.getNamedItem("bankcode").nodeValue'开户银行
					banknum=itemNode1.Attributes.getNamedItem("banknum").nodeValue'账号
					account=itemNode1.Attributes.getNamedItem("account").nodeValue'账户名
					if trim(bankcode)&""<>"" then bankname=bankname & "<br>邮编:" & bankcode
					if trim(parid)<>"0" and trim(parid)=trim(rootid) then
							tpl.set_var "title",title,false
							tpl.set_var "logo",logo,false
							tpl.set_var "bankname",bankname,false
							'tpl.set_var "bankcode",bankcode,false
							tpl.set_var "banknum",banknum,false
							tpl.set_var "account",account,false
					
							tpl.parse "b", "bankItemLists", true
					end if
			    next
			''''''''''''''''''''''''''''''''''''''
				tpl.parse "a", "bankPararLists", true
			end if
		next
		


tpl.parse "#CustomerCenterLeft.html","left",false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
set myobjNode=nothing
set objDoms=nothing
%>