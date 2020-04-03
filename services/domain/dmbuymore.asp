<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!-- #include virtual="/services/domain/hz2py.asp" -->
<%
response.Charset="gb2312"
response.Buffer=true
newcheckstr="^((域名)|(合作)|(出租)|(转让)|(管理员)|(我爱你)|(出售)|(赚钱)|(张三)|(游水)|(N\/A)|(NA)|(Domain Whois Protect)|(webmaster)|\d)$"		  '注册资料参数禁用关键字(正则表达式)
checkdomainStr=""'域名禁用关键字(逗号分隔)
conn.open constr

module=requesta("module")
isaddmod=requesta("isaddmod")
strdomain=trim(requesta("domain"))
isold=Trim(requesta("isold"))
dim ishkdomain:ishkdomain=false   '是否有香港域名
dim iszhdomain:iszhdomain=false   '是否有公司，网络
if strdomain<>"" and right(strdomain,1)="," then strdomain=left(strdomain,len(strdomain)-1)
'#''''''''赠品相关''''''''''''
freeid=trim(requesta("ajaxFree"))
f_content=""
f_freeproid=""
isfree=getFreedatebase(freeid,f_freeproid,f_content)
order_disabled=""
buy_disabled=" checked "
if isfree then order_disabled=" disabled ":isold=1
if  instr(api_autoopen,"domain")<=0 then order_disabled=" checked":buy_disabled=" disabled "
'#''''''''''''''''''''''''''''
call needregSession()
if not isFromWhois(strdomain) then  Alert_Redirect "抱歉.请您查询域名后再进行注册","/services/domain/newWhois.asp"
if trim(lcase(module))="addshopcart" then
	if trim(requesta("dns_host1"))=trim(requesta("dns_host2")) then url_return errinput & "域名服务器(DNS)相同，请重新录入",-1
	call dmbuyDomain()
end if
call checkdmbuydomain()
Call setDomainLeft()
call setHeaderAndfooter()
If isold="1" Then
	tpl.set_file "main", USEtemplate&"/services/domain/dmbuymore_old.html"
else
	tpl.set_file "main", USEtemplate&"/services/domain/dmbuymore.html"
End if
strdomain=Replace(strdomain," ","")
call setDomainInput()'自动填入数据
call domaintable(strdomain)	'域名下拉菜单
tpl.set_var "buy_disabled",buy_disabled,false
tpl.set_var "order_disabled",order_disabled,false
tpl.set_var "strdomain",strdomain,false
tpl.set_var "freeid",trim(freeid)&"",false
tpl.set_var "u_leveid",session("u_levelid"),false
tpl.set_var "ishkdom",ishkdomain,false
tpl.set_var "iszhdom",iszhdomain,false

tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=Nothing
If isold<>"1" Then
%>
<!--#include virtual="/config/class/tpl.asp" --> 
<%
End if

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function cnLen(str)
dim a 
For i=1 To Len(str)
 a=Mid(str,i,1)
 cnLen=cnLen+1
 If isChinese(a) Then cnLen=cnLen+1
Next
End Function

SUB dmbuyDomain()
		d_years_price=Requesta("years")''单域名,年限,价格,型号,说明

		if len(d_years_price)<=0 or instr(d_years_price,"|")<=0 then url_return "参数错误1",-1
		paytype=CheckInputType(Requesta("Ptype"),"^[1-2]{1}$","购买方式",false)
		strDomainpwd=CheckInputType(trim(Requesta("strDomainpwd")),"^[\w\d\-]{4,15}$","域名密码",false)
		dom_org=CheckInputType(trim(Requesta("dom_org")),"^[\w\.\,\s]{4,150}$","英文域名所有者制150字符内",false)
		dom_fn=CheckInputType(trim(Requesta("dom_fn")),"^[\w\.\s]{2,30}$","英文名",false)
		dom_ln=CheckInputType(trim(Requesta("dom_ln")),"^[\w\.\s]{2,30}$","英文姓",true)
		dom_adr1=CheckInputType(trim(Requesta("dom_adr1")),"^[\w\.\,\s#,\-]{7,75}$","英文地址限制75字符内",false)
		dom_ct=CheckInputType(trim(Requesta("dom_ct")),"^[\w\.\s]{1,30}$","英文城市",false)
		dom_st=CheckInputType(trim(Requesta("dom_st")),"^[\w\.\s]{1,30}$","英文省份",false)
		dom_co=CheckInputType(trim(Requesta("dom_co")),"^[\w\.\s]{1,30}$","国家代码",false)
		dom_pc=CheckInputType(trim(Requesta("dom_pc")),"^[\d]{6}$","邮编",false)
		dom_ph=CheckInputType(trim(Requesta("dom_ph")),"^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$","电话号码",false)
		'if IsValidMobileNo(dom_ph) then
		'	url_return "电话号码不能是手机号!",-1
		'end if
		
	
		
			  if isBad(session("user_name"),strDomainpwd,errinfo) then 
				   die url_return(replace(replace(errinfo,"ftp用户名","用户名"),"用户名","用户名"),-1)
			end if	
		
		
		dom_fax=CheckInputType(trim(Requesta("dom_fax")),"^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$","传真号码",false)
		dom_em=CheckInputType(trim(Requesta("dom_em")),"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$","邮箱号码",false)
	    dom_org_m=domainChinese(trim(requesta("dom_org_m")),2,100,"中文所有者")
		dom_fn_m=CheckInputType(trim(Requesta("dom_fn_m")),"^[\u4e00-\u9fa5]{1,4}$","中文姓",true)
		dom_ln_m=CheckInputType(trim(Requesta("dom_ln_m")),"^[\u4e00-\u9fa5]{1,6}$","中文名",true)
		dom_adr1_m=domainChinese(trim(Requesta("dom_adr_m")),7,100,"中文地址")
		dom_ct_m=CheckInputType(trim(Requesta("dom_ct_m")),"^[\u4e00-\u9fa5]{1,60}$","中文城市",false)
		dom_st_m=CheckInputType(trim(Requesta("dom_st_m")),"^[\u4e00-\u9fa5]{1,10}$","中文省份",false)
		dns_host1=CheckInputType(requesta("dns_host1"),"^[\w\.\-]{2,60}$","DNS1",false)
		dns_host2=CheckInputType(requesta("dns_host2"),"^[\w\.\-]*$","DNS2",false)
		If Trim(requesta("dns_ip1"))<>"" then
			dns_ip1=CheckInputType(requesta("dns_ip1"),"^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$","DNS1的ip1",false)
		End If
		If  Trim(requesta("dns_ip2"))<>"" then
			dns_ip2=CheckInputType(requesta("dns_ip2"),"^[\d\.]*$","DNS2的ip2",false)
		End if
		if instr(dom_org_m,"先生")>0 or  instr(dom_org_m,"女士")>0  or  instr(dom_org_m,"小姐")>0  then
		url_return "域名所有者不能带称谓如(先生|小姐|女士)等",-1
		end if

		cndom_st_m=dom_st_m 'trim(requesta("cndom_st_m"))
		
	domext=lcase(mid(strdomain,instrrev(strdomain,".")))
	'dompa1=mid(strdomain,instr(strdomain,"."))
	'if domext=".cn" or domext=".中国" then
	'		if cnLen(dom_org_m)<8 then  url_return "请注意，中文国内域名的所有者必须是单位名，个人不能注册！",-1
	'end if
	
	if domext=".cn" or domext=".中国" then
	dom_adr1=CheckInputType(trim(Requesta("dom_adr1")),"^[\w\.\,\s]{7,62}$","长度超出62位，英文地址",false)
	end if

	'
	if domext=".hk" then
	   reg_contact_type=CheckInputType(trim(Requesta("reg_contact_type")),"^[0|1]$","HK注册人类型错误",false)
	   custom_reg2=trim(Requesta("custom_reg2"))
	   ishkregok=false
	   select case trim(reg_contact_type&"")
		   case "0"
			    if instr(",OTHID,HKID,PASSNO,BIRTHCERT,",","&custom_reg2&",")>0 then ishkregok=true
		   case "1"
                if instr(",CI,BR,",","&custom_reg2&",")>0 then ishkregok=true 
		end select 
		if not ishkregok then url_return "HK域名证件类型有误!",-1
		custom_reg1=CheckInputType(requesta("custom_reg1"),"^[\w\.\-\(\)]{2,60}$","证件号码",false)
		if custom_reg2="OTHID" then
           if len(custom_reg1)<>15 and len(custom_reg1)<>18 then
			url_return "HK域名证件号码有误!"&LEN(custom_reg1),-1
		   end if
		end if
	end if

	if domext=".公司" or domext=".网络" then
		 dom_idtype=trim(Requesta("dom_idtype"))
	     dom_idnum=trim(Requesta("dom_idnum"))
		 if instr(",ORG,SFZ,",","&dom_idtype&",")=0 then
			url_return "证件类型有误!"&LEN(custom_reg1),-1
		 end if

		 if len(dom_idnum)<4 or  len(dom_idnum)>20 then
			url_return "证件号码有误!"&LEN(custom_reg1),-1
		 end if

	end if
	
	
	'是否添加模板
	if isaddmod="add" then
		set mrs=Server.CreateObject("adodb.recordset")
		sql="select top 1 * from domainTemp where dom_org_m='"&dom_org_m&"' and u_name='"&session("user_name")&"'"
		mrs.open sql,conn,1,3
		if mrs.eof then
		mrs.addnew
		end if
		mrs("u_name")=session("user_name")
		mrs("dns_host1")=dns_host1
		mrs("dns_ip1")=dns_ip1
		mrs("dns_host2")=dns_host2
		mrs("dns_ip2")=dns_ip2
		mrs("dom_org_m")=dom_org_m
		mrs("dom_ln_m")=dom_ln_m
		mrs("dom_fn_m")=dom_fn_m
		mrs("dom_st_m")=dom_st_m
		mrs("cndom_st_m")=cndom_st_m
		mrs("dom_ct_m")=dom_ct_m
		mrs("dom_adr_m")=dom_adr1_m
		mrs("dom_org")=dom_org
		mrs("dom_ln")=dom_ln
		mrs("dom_fn")=dom_fn
		mrs("dom_co")=dom_co
		mrs("dom_st")=dom_st
		mrs("dom_ct")=dom_ct
		mrs("dom_adr1")=dom_adr1
		mrs("dom_pc")=dom_pc
		mrs("dom_ph")=dom_ph
		mrs("dom_fax")=dom_fax
		mrs("dom_em")=dom_em
		mrs.update
	end if
	SELECT CASE paytype
		CASE 1'-------------------------正式购买----------------------------
			 FOR EACH dypstr IN split(d_years_price,",")
			 	if trim(dypstr)<>"" then
					dypArray=split(dypstr,"|")
					if ubound(dypArray)<4 then url_return "有错误,请联系管理员.",-1
					domain=trim(dypArray(0))
				      if isdomain(domain) or (not isInbagshow(domain,"domain")) then
								years=dypArray(1)
								if not isnumeric(years) or years<1 then years=1
								price=dypArray(2)
							
								p_ProId=trim(dypArray(3))
								productName=trim(dypArray(4))
								
								if p_ProID="domxm" then
			                      if trim(Requesta("dom_org_m"))<>trim(trim(Requesta("dom_ln_m"))&trim(Requesta("dom_fn_m"))) then
							       die url_return("域名所有者资料有误",-1)
		                            end if
								end if

												
							if p_ProId="domcn" or p_ProId="domchina"  then dom_st_m=cndom_st_m
							strContents = "domainname" + vbcrlf+ "add"+vbcrlf+"entityname:domain"+vbcrlf
							strContents =strContents+  "domainname:" + lcase(domain) +vbcrlf
							strContents =strContents& "dmtype:ENG" & vbcrlf
							strContents =strContents+ "term:"+ years+vbcrlf
							strContents =strContents+ "dns_host1:" + dns_host1+vbcrlf
							strContents =strContents+ "dns_ip1:"+ dns_ip1 +vbcrlf
							strContents =strContents+ "dns_host2:" + dns_host2 +vbcrlf
							strContents =strContents+ "dns_ip2:" + dns_ip2 +vbcrlf
							strContents =strContents+ "dom_org:" + dom_org +vbcrlf
							strContents =strContents+ "dom_fn:" + dom_fn+vbcrlf
							strContents =strContents+ "dom_ln:" + dom_ln+vbcrlf
							strContents =strContents+ "dom_adr1:" + dom_adr1+vbcrlf
							strContents =strContents+ "dom_ct:" + dom_ct+vbcrlf
							strContents =strContents+ "dom_st:" +dom_st+vbcrlf
							strContents =strContents+ "dom_co:" +dom_co+vbcrlf
							strContents =strContents+ "dom_pc:" + dom_pc +vbcrlf
							strContents =strContents+ "dom_ph:" + dom_ph+vbcrlf
							strContents =strContents+ "dom_fax:" + dom_fax+vbcrlf
							strContents =strContents+ "dom_em:" + dom_em+vbcrlf
							
							strContents =strContents+ "admi_org:" + dom_org+vbcrlf
							strContents =strContents+ "admi_fn:" + dom_fn+vbcrlf
							strContents =strContents+ "admi_ln:" +dom_ln+vbcrlf
							strContents =strContents+ "admi_adr1:" + dom_adr1+vbcrlf
							strContents =strContents+ "admi_ct:" + dom_ct+vbcrlf
							strContents =strContents+ "admi_st:" + dom_st+vbcrlf
							strContents =strContents+ "admi_co:" + dom_co+vbcrlf
							strContents =strContents+ "admi_pc:" + dom_pc+vbcrlf
							strContents =strContents+ "admi_ph:" + dom_ph+vbcrlf
							strContents =strContents+ "admi_fax:" + dom_fax+vbcrlf
							strContents =strContents+ "admi_em:" + dom_em+vbcrlf
							
							strContents =strContents+ "tech_fn:" + dom_fn+vbcrlf
							strContents =strContents+ "tech_ln:" + dom_ln+vbcrlf
							strContents =strContents+ "tech_adr1:" +dom_adr1+vbcrlf
							strContents =strContents+ "tech_ct:" + dom_ct+vbcrlf
							strContents =strContents+ "tech_st:" +dom_st+vbcrlf
							strContents =strContents+ "tech_co:" + dom_co+vbcrlf
							strContents =strContents+ "tech_pc:" +dom_pc+vbcrlf
							strContents =strContents+ "tech_ph:" +dom_ph+vbcrlf
							strContents =strContents+ "tech_fax:" +dom_fax+vbcrlf
							strContents =strContents+ "tech_em:" + dom_em+vbcrlf
							
							strContents =strContents+ "bill_fn:" + dom_fn+vbcrlf
							strContents =strContents+ "bill_ln:" + dom_ln+vbcrlf
							strContents =strContents+ "bill_adr1:" +dom_adr1+vbcrlf
							strContents =strContents+ "bill_ct:" + dom_ct+vbcrlf
							strContents =strContents+ "bill_st:" + dom_st+vbcrlf
							strContents =strContents+ "bill_co:" + dom_co+vbcrlf
							strContents =strContents+ "bill_pc:" + dom_pc+vbcrlf
							strContents =strContents+ "bill_ph:" + dom_ph+vbcrlf
							strContents =strContents+ "bill_fax:" + dom_fax+vbcrlf
							strContents =strContents+ "bill_em:" + dom_em+vbcrlf
						
							strContentS =strContentS+ "dom_org_m:" + dom_org_m + vbcrlf
							strContentS =strContentS+ "dom_fn_m:" + dom_fn_m + vbcrlf
							strContentS =strContentS+ "dom_ln_m:" + dom_ln_m + vbcrlf
							strContentS =strContentS+ "dom_adr_m:" + dom_adr1_m + vbcrlf
							strContentS =strContentS+ "dom_ct_m:" + dom_ct_m + vbcrlf
							strContentS =strContentS+ "dom_st_m:" +dom_st_m+ vbcrlf
							
							strContentS =strContentS+ "admi_org_m:" +dom_org_m+ vbcrlf
							strContentS =strContentS+ "admi_fn_m:" + dom_fn_m + vbcrlf
							strContentS =strContentS+ "admi_ln_m:" +dom_ln_m+ vbcrlf
							strContentS =strContentS+ "admi_adr_m:" +dom_adr1_m+ vbcrlf
							strContentS =strContentS+ "admi_ct_m:" +dom_ct_m+ vbcrlf
							strContentS =strContentS+ "admi_st_m:" +dom_st_m + vbcrlf
									
							strContents = strContents+ "domainpwd:" + strDomainpwd+vbcrlf
							strContents = strContents + "producttype:" + p_ProId + vbCrLf
							strContents = strContents + "ppricetemp:" + price + vbCrLf
							strContents = strContents + "productnametemp:" + productName + vbCrLf
							if lcase(p_ProId)="domhk" then
								strContents = strContents + "reg_contact_type:" + reg_contact_type + vbCrLf
								strContents = strContents + "custom_reg1:" + custom_reg1 + vbCrLf
								strContents = strContents + "custom_reg2:" + custom_reg2 + vbCrLf
								strContents = strContents + "adm_contact_type:" + reg_contact_type + vbCrLf
								strContents = strContents + "custom_adm1:" + custom_reg1 + vbCrLf
								strContents = strContents + "custom_adm2:" + custom_reg2 + vbCrLf
								strContents = strContents + "tec_contact_type:" + reg_contact_type + vbCrLf
								strContents = strContents + "custom_tec1:" + custom_reg1 + vbCrLf
								strContents = strContents + "custom_tec2:" + custom_reg2 + vbCrLf
								strContents = strContents + "bil_contact_type:" + reg_contact_type + vbCrLf
								strContents = strContents + "custom_bil1:" + custom_reg1 + vbCrLf
								strContents = strContents + "custom_bil2:" + custom_reg2 + vbCrLf
							end if
							if lcase(p_ProId)="domgs" or lcase(p_ProId)="domwl" then
								strContents = strContents + "dom_idtype:" + dom_idtype + vbCrLf
								strContents = strContents + "dom_idnum:" + dom_idnum + vbCrLf
							end if
							strContents = strContents + f_content
							strContents = strContents + "." & vbCrLf
							ywtype="domain"
							ywname=lcase(domain)
							 call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)			
						'	session("order") =  strContents & session("order")
				end if
			  end if
			NEXT
					Response.redirect "/bagshow/"
		CASE 2'-------------------------下订单------------------------------
			if isfree then url_return "赠品不允许下订单",-1
			FOR EACH dypstr IN split(d_years_price,",")
				if trim(dypstr)<>"" then
						dypArray=split(TRIM(dypstr),"|")
						if ubound(dypArray)<4 then url_return "有错误,请联系管理员.",-1
						domain=lcase(trim(dypArray(0)))
					if isdomain(domain) then
							years=dypArray(1)
							price=dypArray(2)
							p_ProId=trim(dypArray(3))
							productName=trim(dypArray(4))
							
							if not checkorderNum(domain) then conn.close:url_return "抱歉，系统中已经有3个相同的订单号，不能再提交",-1
						  set PreRs=server.CreateObject("adodb.recordset")
						   PreRs.open "select * from PreDomain",conn,1,3
						   PreRs.AddNew
					'-----------------
							TimeS=Now
							PreRs("proid")=p_ProId
							PreRs("username")=Session("user_name")
							PreRs("regdate")=TimeS
							PreRs("strDomain")=domain
							PreRs("strDomainpwd")=strDomainpwd
							PreRs("admi_pc")=dom_pc
							PreRs("years")=years
							PreRs("dom_ln")=dom_ln
							PreRs("admi_fax")=dom_fax
							PreRs("tech_fn")=dom_fn
							PreRs("bill_ct")=dom_ct
							PreRs("bill_em")=dom_em
							PreRs("dns_host1")=dns_host1
							PreRs("dns_host2")=dns_host2
							PreRs("dom_fn")=dom_fn
							PreRs("admi_co")=dom_co
							PreRs("bill_ln")=dom_ln
							PreRs("bill_fax")=dom_fax
							PreRs("dns_ip1")= dns_ip1
							PreRs("dom_fax")=dom_fax
							PreRs("admi_fn")=dom_fn
							PreRs("admi_ph")=dom_ph
							PreRs("tech_st")=dom_st
							PreRs("tech_fax")=dom_fax
							PreRs("dns_ip2")=dns_ip2
							PreRs("admi_ct")=dom_ct
							PreRs("admi_em")=dom_em
							PreRs("dom_org")=dom_org
							PreRs("admi_st")=dom_st
							PreRs("dom_co")=dom_co
							PreRs("dom_ph")=dom_ph
							PreRs("tech_pc")=dom_pc
							PreRs("bill_co")=dom_co
							PreRs("dom_st")=dom_st
							PreRs("dom_pc")=dom_pc
							PreRs("dom_ct")=dom_ct
							PreRs("dom_adr1")=dom_adr1
							PreRs("dom_em")=dom_em
							PreRs("tech_co")=dom_co
							PreRs("tech_ph")=dom_ph
							PreRs("bill_pc")=dom_pc
							PreRs("admi_ln")=dom_ln
							PreRs("admi_adr1")=dom_adr1
							PreRs("tech_ct")=dom_ct
							PreRs("tech_em")=dom_em
							PreRs("bill_st")=dom_st
							PreRs("bill_ph")=dom_ph
							PreRs("tech_ln")=dom_ln
							PreRs("tech_adr1")=dom_adr1
							PreRs("bill_fn")=dom_fn
							PreRs("bill_adr1")=dom_adr1
							PreRs("dom_org_m")=dom_org_m
							PreRs("dom_fn_m")=dom_fn_m
							PreRs("dom_ln_m")=dom_ln_m
							PreRs("dom_adr_m")=dom_adr1_m
							PreRs("dom_ct_m")=dom_ct_m
							if p_ProId="domcn" then
								PreRs("dom_st_m")=cndom_st_m
							else
								PreRs("dom_st_m")=dom_st_m
							end if
							PreRs("admi_org_m")=dom_org_m
							PreRs("admi_fn_m")=dom_fn_m
							PreRs("admi_ln_m")=dom_ln_m
							PreRs("admi_adr_m")=dom_adr1_m
							PreRs("admi_ct_m")=dom_ct_m
							PreRs("admi_org")= dom_org
							if p_ProId="domcn" then
								PreRs("admi_st_m")=cndom_st_m
							else
								PreRs("admi_st_m")=dom_st_m
							end if

							if p_ProId="domhk" then
							PreRs("reg_contact_type")= reg_contact_type
							PreRs("custom_reg1")= custom_reg1
							PreRs("custom_reg2")= custom_reg2
							end if

							if lcase(p_ProId)="dom公司" or lcase(p_ProId)="dom网络" then
							PreRs("dom_idnum")= dom_idnum
							PreRs("dom_idtype")= dom_idtype
							end if
							
					
							PreRs("price")=price
							PreRs("productName")=productName
							PreRs("opened")=0
					'----------------
					
						   PreRs.update
						   PreRs.close
						   set PreRs=nothing
					Sql="Select top 1 d_id from PreDomain Where strDomain='" & lcase(domain) & "' and dateDiff("&PE_DatePart_M&",regDate,'" & TimeS & "')=0 order by d_id desc"
					
					Rs.open Sql,conn,1,1
					if not Rs.eof then
						OrderID=Rs(0)
						OrderIDlist=OrderIDlist & OrderID & ","
					end if
					RS.close
					
				   end if
			end if
		NEXT
					if OrderIDlist<>"" then
						if right(OrderIDlist,"1")="," then OrderIDlist=left(OrderIDlist,len(OrderIDlist)-1)
						   conn.close
						   Response.redirect "/bagshow/orderlist.asp?orderid="& server.urlEncode(OrderIDlist) & "&productType=domain"
						  
					else
						url_return "域名不合法域没有选择域名",-1
					end if 

	END SELECT
	response.end	
END SUB
function checkorderNum(byval orderdomain)
		checkorderNum=true
		orderNumsql="select count(*) as OrderNum from predomain where strDomain='" & lcase(orderdomain) & "'"
		set orderNumRs=conn.execute(orderNumsql)
		OrderNum=0
		if not isNull(orderNumRs("OrderNum")) then OrderNum=cint(orderNumRs("OrderNum"))
		orderNumRs.close
		set orderNumRs=nothing
		if OrderNum>=3 then
			checkorderNum=false
		end if
end function
function CheckInputType(byval values,byval reglist,byval errinput,byval pd)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "格式错误",-1
	else
		
		if pd then
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
		
	end if
	CheckInputType=values
end function
function domainChinese(byval values,byval flen,byval llen,byval errinput)
	if len(values)<=llen and len(values)>=flen then
		if not ischinese(values) then
			conn.close
			url_return errinput & "需含有中文",-1
		else
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "不能含有禁用关键字",-1
			end if
		end if
	else
		conn.close
		url_return errinput & "字符长度应在" & flen & "-" & llen & "之间",-1
	end if
	domainChinese=values
end function
sub checkdmbuydomain()'安全检验
	if not isAlldomain(strdomain,errstr1) then url_return errstr1,-1
end sub

function isAlldomain(byval domainList,byref errstr)
	isAlldomain=false
	cur=1
	if trim(domainList)="" then errstr="域名不能为空":exit function
	for each strdoaminitems in split(domainList,",")
		strdoaminitems=trim(strdoaminitems)
		if strdoaminitems<>"" then
			if not isdomain(strdoaminitems) then
				errstr=strdoaminitems & "格式有错"
				exit function
			else
				if right(strdoaminitems,3)=".cn" then
					domAr=split(strdoaminitems,".")
					checkD=trim(domAr(0))
					for each cheStr in split(checkdomainStr,",")
						if instr(checkD,trim(cheStr))>0 then
							errstr= strdoaminitems & "有禁用关键字"
							exit function
						end if
					next
				end if
			end if
			cur=cur+1
		end if
	next
	if cur>101 then errstr="域名一次最多注册100个":exit function
	isAlldomain=true
end function 
'得到账号资料或头次注册内容注入数据方便用户录入
function setDomainInput()

	domainsql="select top 1 * from domainlist where userid = "& session("u_sysid") &" order by d_id desc"
	set domainRs=conn.execute(domainsql)
	If not domainRs.eof Then
		for Ri=0 to domainRs.fields.count-1
			tplname=trim(lcase(domainRs.Fields(Ri).Name))
			tplvalue=trim(domainRs(Ri))
			if left(tplname,3)="dom" then
				tpl.set_var tplname,tplvalue&"",false
			end if
		next
	else
		usersql="select top 1 * from UserDetail where u_id = "& session("u_sysid")

		set userRs=conn.execute(usersql)
		if not userRs.eof then
					dom_pc=userRs("u_zipcode") & ""
					dom_ph=replace(userRs("u_telphone")&"","-0","")
					dom_fax=replace(userRs("u_telphone")&"","-0","")
					dom_ph=replace(userRs("u_telphone")&"","-","")
					dom_fax=replace(userRs("u_telphone")&"","-","")
					dom_em=userRs("u_email")&""
					dom_fn_m=replace(userRs("u_contract")&"",left(userRs("u_contract"),1),"")
					dom_ln_m=left(userRs("u_contract")&" ",1)
					dom_org_m=userRs("u_company")&""
					dom_adr_m=userRs("u_address")&""
					dom_ct_m=userRs("u_city")&""
					dom_fn=ChineseToPinyin(dom_fn_m)&""
					dom_ln=ChineseToPinyin(dom_ln_m)&""
					dom_org=ChineseToPinyin(setTrimStr(dom_org_m))&""
					dom_ct=ChineseToPinyin(setTrimStr(dom_ct_m))&""
					dom_adr1=ChineseToPinyin(setTrimStr(dom_adr_m))&""
					dom_st=""
					dom_st_m=""
				
		end if
					tpl.set_var "dom_pc",trim(dom_pc)&"",false
					tpl.set_var "dom_ph",trim(dom_ph)&"",false
					tpl.set_var "dom_fax",trim(dom_fax)&"",false
					tpl.set_var "dom_em",trim(dom_em)&"",false
					tpl.set_var "dom_fn_m",trim(dom_fn_m)&"",false
					tpl.set_var "dom_ln_m",trim(dom_ln_m)&"",false
					tpl.set_var "dom_org_m",trim(dom_org_m)&"",false
					tpl.set_var "dom_st",trim(dom_st)&"",false
					
					tpl.set_var "dom_adr_m",trim(dom_adr_m)&"",false
					tpl.set_var "dom_st_m",trim(dom_st_m)&"",false
					tpl.set_var "dom_ct_m",trim(dom_ct_m)&"",false
					tpl.set_var "dom_fn",trim(dom_fn)&"",false
					tpl.set_var "dom_ln",trim(dom_ln)&"",false
					tpl.set_var "dom_org",trim(dom_org)&"",false
					tpl.set_var "dom_ct",trim(dom_ct)&"",false
					tpl.set_var "dom_adr1",trim(dom_adr1)&"",false
		userRs.close
		set userRs=nothing
	end if
	domainRs.close
	set domainRs=nothing
					tpl.set_var "dns_host1",ns1,false
					tpl.set_var "dns_ip1",ns1_ip,false
					tpl.set_var "dns_host2",ns2,false
					tpl.set_var "dns_ip2",ns2_ip,false
					tpl.set_var "strdomainpwd",lcase(CreateRandomKey(6)),false
end function
function setTrimStr(byval str)
	str=trim(str)
	setTrimStr=""
	if str<>"" then
		newStr=""
		for i=1 to len(str)
			newStr=newStr & mid(str,i,1)&" "
		next
	end if
	setTrimStr=trim(newstr)
end function
function domaintable(byval strdomainlist)
		tpl.set_block "main","domaintable", "a"
		tpl.set_block "domaintable","domainselect", "b"
	 if isfree then
	 	if instr(strdomainlist,",")>0 then
			url_return "赠品只允许注册一个",-1
		else
			free_proid=GetDomainType(strdomainlist)
			if instr(trim(f_freeproid),trim(lcase(free_proid)))=0 then 
				url_return "赠品允许类型不正确",-1
			end if
		end if
	 end if 
	
	 FOR EACH domain IN split(strdomainlist,",")
					p_proid=GetDomainType(domain)

					if p_proid="domgovcn" then
						tpl.set_var "govcnstr","<a href=""http://agentsys.cn/help/list.asp?unid=378"" target=""_blank"">【政府域名注册须知】</a><script language=javascript>window.setTimeout('alert(""您注册的有gov.cn政府域名,需要邮寄资料,详见右侧说明"")',2000);</script>",false
						'response.write "<script language=javascript>alert('您注册的有gov.cn政府域名,需要邮寄资料,详见右侧说明');</script>"
					else
						tpl.set_var "govcnstr","",false
					end if
					tpl.set_var "domain",trim(domain),false
					tpl.unset_var "b"	
				  	selstr=getpricelist(session("user_name"),p_ProId)
					strArray=split(selstr,"|")
					if isfree then
							domainselectvalue=trim(domain) & "|" & 1 & "|" & 0 & "|" & p_ProId & "|" & "域名" & p_proid
							
							domainselecttext="赠品免费"
							tpl.set_var "domainselectvalue",domainselectvalue,false
							tpl.set_var "domainselecttext",domainselecttext,false
							tpl.parse "b","domainselect", true
					else
					 if ubound(strArray)>=10 then
					 endcount=9
					  if  lcase(right(domain,3))=".tm" then 
					   si=9
					  else
					   si=0
					  end if

					  if lcase(right(domain,3))=".hk" or lcase(right(domain,3))=".tw"  then
						si=0
						endcount=4
						
					  end if
					  if lcase(right(domain,3))=".hk" then
						ishkdomain=true
					  end if
					  if lcase(right(domain,3))=".公司" or lcase(right(domain,3))=".网络" then
						iszhdomain=true
					  end if 
 

					 
						for ii=si to endcount
						  if instr(domain,".Pasia")>0 then ii=ii+1 '最少注册二年的域名。

						    if lcase(right(domain,3))=".hk" and ii=3 then

							Else
								If isold="1" Then
									domainselectvalue=trim(domain) & "|" & (ii+1) & "|" & strArray(ii) & "|" & p_ProId & "|" & "域名" & p_proid
								else
									domainselectvalue=trim(domain) & "|" & (ii+1) '& "|" & strArray(ii) & "|" & p_ProId & "|" & "域名" & p_proid
								End if
								domainselecttext=FormatNumber((strArray(ii)),2,,,0)&"元/" & (ii+1) &"年"
								tpl.set_var "domainselectvalue",domainselectvalue,false
								tpl.set_var "domainselecttext",domainselecttext,false
								tpl.parse "b","domainselect", true
								end if
						next
					 
					 end if
					end if
				tpl.parse "a", "domaintable", true
     NEXT

end function

function isFromWhois(byval getDomain)
	isFromWhois=False
 	if session("whoisValue")<>"" and getDomain<>"" Then
		getDomain=replace(","&getDomain&","," ","")
		for each whoisDomain in split(session("whoisValue"),"|")
			whoisDomain=trim(whoisDomain)
			if whoisDomain<>"" then
				if instr(getDomain,","&whoisDomain&",")>0 then
					isFromWhois=true
					exit function
				end if
			end if
		next
	end if
end function

%>
