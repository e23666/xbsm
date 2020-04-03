<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
response.charset="gb2312"
conn.open constr
module=lcase(trim(Requesta("module")))
Select Case module
	   Case "checkmailname"
	   		mailname=trim(requesta("mailname"))
	   		if not checkmailnameIn(mailname,errstr2) then
				response.write toerrStr(errstr2)
				response.write "<input type='hidden' name='isftppd' id='isftppd' value='0'>"
			else
				response.write torightStr("恭喜,此邮局域名可以注册")
				response.write "<input type='hidden' name='isftppd' id='isftppd' value='1'>"
			end if
			response.end
	   Case "addshopcart"
			call needregsession()
			productid=requesta("productid")'产品型号
			paytype=0 'CheckInputType(requesta("paytype"),"^[01]{1}$","购买方式")''购买方式
			vyears=CheckInputType(Requesta("years"),"^[0-9]{1,2}$","购买期限")'年限
			m_bindname=trim(Requesta("m_bindname"))'绑定域名
			m_password=CheckInputType(trim(Requesta("m_password")),"^[\w\-\.]{5,15}$","邮局密码")'密码
			
			  if isBad(session("user_name"),m_password,errinfo) then 
				   die url_return(replace(replace(errinfo,"ftp用户名","用户名"),"用户名","用户名"),-1)
			end if	
			
			room=requesta("room")'机房
	
			if not ischeckmail(m_bindname,productid,vyears,paytype,productName,errstr1) then conn.close:url_return errstr1,-1
				if paytype=1 then
					price=10
				else
					Price=GetNeedPrice(session("user_name"),productid,1,"new")				
				end if
				strContents = strContents & "corpmail" & vbCrLf
				strContents = strContents & "add" & vbCrLf
				strContents = strContents & "entityname:corpmail" & vbCrLf
				strContents = strContents & "producttype:" & productid & vbCrLf
				strContents = strContents & "domainname:" & m_bindname & vbCrLf
				strContents = strContents & "mailmaster:post3master" & vbCrLf
				strContents = strContents & "password:" & m_password & vbCrLf
				strContents = strContents & "paytype:" & paytype & vbCrLf '''''购买方式
				strContents = strContents & "room:" & room & vbCrLf'''''''''机房
				strContents = strContents & "years:" & vyears & vbCrLf
				strContents = strContents & "ppricetemp:" & Price & vbCrLf
				strContents = strContents & "productnametemp:" & productName & vbCrLf
				strContents = strContents & "." & vbCrLf

				  ywtype="mail"
				ywname=m_bindname
				call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)	
				'session("order") =  strContents & session("order")
				Response.redirect "/bagshow/"
end Select
		productid=trim(Requesta("productid"))
	
		rs.open "select top 1 * from productlist where p_type=2 and P_proId='" & lcase(productid) &"' ",conn,3
 
		If rs.eof And rs.bof Then rs.close : conn.close : errpage "报谦,该产品不存在"
		productName=rs("p_name")
		p_maxmen=rs("p_maxmen")
		p_size = rs("p_size")
		p_picture =  rs("p_picture")
		p_test=rs("p_test")
		vyears=1
		rs.close
		Price=GetNeedPrice(session("user_name"),ProductID,1,"new")
		'''''''''''''''''''''模板''''''''''''''''''''''''''''''''
		call setHeaderAndfooter()
		call setmailLeft()
		tpl.set_file "main", USEtemplate & "/services/mail/buy.html"
		tpl.set_var "productName",productName,false
		tpl.set_var "productid",productid,false
		tpl.set_var "price",Price,false
		tpl.set_var "p_size",p_size,false
		tpl.set_var "p_maxmen",p_maxmen,false
		tpl.set_var "setroomlist",setRoom(Productid),false
		tpl.set_var "buyHostpriceList",buyHostpriceList,false
		tpl.set_var "demomailprice",demomailprice,false
		tpl.set_var "rndpass",createRnd(8),false
		tpl.parse "mains","main",false
		tpl.p "mains" 
		set tpl=nothing
		conn.close
		 
function buyHostpriceList()
	  islook=true
 	  selstr = getpricelist(session("user_name"),productid)
	  if selstr<>"" then
		strArray=split(selstr,"|")
   	 	if ubound(strArray)>=10 then
		    islook=false
			oneyearsprice=strArray(0)
   					hostpricelist ="<select name=""years"" size=""1"">" & vbcrlf

				for ii=0 to 9
					needPrice=strArray(ii)
					savePrice=oneyearsprice*(ii+1)-needPrice
					saveStr=""
				'	if savePrice>0 then saveStr="【节省:"& FormatNumber(savePrice,2,,,0) & "元】"
				if ii=1 then
				saveStr="【买二年送一年】"
 				elseif ii=2 then
				saveStr="【买三年送二年】"
				elseif ii=4 then
				saveStr="【买五年送五年】"
				elseif ii=9 then
				saveStr="【买十年送十年】"
				end if
		 			hostpricelist = hostpricelist & "<option value="""& (ii+1) &""">"& FormatNumber(needPrice,2,,,0) & "元/" & (ii+1)& "年"& saveStr &"</option>" & vbcrlf
					
				next
					hostpricelist = hostpricelist & "</select>"

   					if trim(session("user_name"))&""="" then hostpricelist = hostpricelist & "<font color=""#999999"">您没有登陆,按直接客户身份计算价格</font>"
		end if
	  end if
    buyHostpriceList=hostpricelist

end function
function ischeckmail(byval mailname,byval productid,byval vyear,byval paytype,byref p_name,byref errstr)
		errstr=""
		ischeckmail=false
		if trim(productid)&""="" or len(productid)>10 then errstr="产品型号错误":exit function
		if not isnumeric(vyear) then errstr="年限错误":exit function
		
		if vyear>10 or vyear<1 then errstr="年限应是1-10年之间":exit function
		if not checkmailnameIn(mailname,mailerrstr) then errstr=mailerrstr:exit function
	    if paytype<>0 then
		
				Audsql="select top 1 u_Auditing from userDetail where u_id="& session("u_sysid")
				set Audrs=conn.execute(Audsql)
				if not Audrs.eof then
					if trim(AudRs(0))=1 then
						errstr="您需要通过管理员审核后才能开通试用主机!"
					end if
				end if
				Audrs.close
				set audrs=nothing
			if session("u_levelid")=1 then 
				setcountline=4
			else
				setcountline=20
			end if
			sql="select count(*) as fdsfs from vhhostlist where S_ownerid="& session("u_sysid") &" and s_buytest=1"
			set testCountRS=conn.execute(sql)
			if testCountRS(0)>=setcountline then
				errstr="对不起 ，您最多只能申请"& setcountline &"个试用主机！"
				testCountRS.close
				exit function
			end if
			testCountRS.close
		 end if
	psql="select top 1 *  from productlist where p_type=2 and P_proId='"& productid &"'"
	set prs=conn.execute(psql)
	if not prs.eof then
		p_name=prs("p_name")
		p_maxmen=prs("p_maxmen")
		p_size=prs("p_size")
		p_test=prs("p_test")'是否试用 0试用
		if p_test<>0 and paytype then 
			errstr="此类型主机不允许试用"
		else
			ischeckmail=true
		end if
	else
		errstr="没有此主机类型"
	end if
	prs.close
	set prs=nothing
end function
function checkmailnameIn(byval mailname,byref errstr)
	checkmailnameIn=false
	errstr=""
	
	hostcheckstr="mysql,root,mssql,sqlserver,sa,domainname,dnsresolve,system,administrator,pcj,fancy,TsInternetUser,service,network,replicator,client,guests,batch,dialup,interactive,everyone"
	if not isdomain(mailname) then errstr="邮局域名格式不正确":exit function
	if len(mailname)<5 or len(mailname)>60 then errstr="邮局名长度应在５-60位之间":exit function
	if instr(","& lcase(hostcheckstr) &",",","& lcase(mailname) &",")>0 then errstr="邮局名有禁用关键字":exit function
 		sqls="select m_sysid from mailsitelist where m_bindname='"& mailname &"'"
		set rszxw=conn.execute(sqls)
		if not rszxw.eof then
			errstr="此邮局域名已经存在"
		else
			if isInbagshow(mailname,"mail") then
				errstr="些邮局域名已存在于购物车中"
			else
				checkmailnameIn=true
			end if
		end if
		rszxw.close
		set rszxw=nothing
end function
function CheckInputType(byval values,byval reglist,byval errinput)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "格式错误",-1
	end if
	CheckInputType = values
end function

%>
