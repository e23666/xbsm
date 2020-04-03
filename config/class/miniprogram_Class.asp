<%
class miniprogram 
	public user_sysid,user_name,u_namecn,u_address,msn_msg,u_email,u_levelid,tc_name,product_ids,u_usemoney
	Dim P_proId,p_name
	Dim errmsg,okmsg,priceListArr,payTextPrice,smsprice,min_smscount
	Dim db_id,db_userid,db_appName,db_paytype,db_buyYear,db_buyDate,db_expireDate,db_appid,db_proid,db_bakAppName,db_productIds
	dim appconfig,db_tcproid,db_otherproid
	dim paytype,paytypeprice,buymaxyear,adminuserid
	
	'miniprogram_paytype_money,miniprogram_sms_money
	'初始化
	Private Sub Class_Initialize
		user_sysid=session("u_sysid")
		proid=""
		tem_level=1			
		loadconfig()	 '加载json配置
		paytypeprice=miniprogram_paytype_money   '试用价格
		Set priceListArr=newarray() 
		min_smscount=1
		buymaxyear=3
		adminuserid=0
	end sub
	
	Private Sub Class_Terminate
		 
	End Sub

	public sub loadconfig()
		content_ = ReadFile(Server.MapPath("/noedit/app.json"))
		set appconfig=aspjsonParse(content_)
	end sub

	Public Property Let setproid(value)
		P_proId=value
		getproductinfo()
	End Property

	Public Property Let setuid(value)
		getuserinfo(value)
	End property

	public Property Let setAppid(value)
		 call getappinfo(value)
	end property

	'获取app信息
	public function getappinfo(byval val_)
		getappinfo=false
		if not isnumeric(val_&"") then errmsg="appID格式错误":exit function
		sql="select top 1 * from wx_miniprogram_app where userid=" & user_sysid &" and appid ="&val_&"" 
		set dbrs=conn.execute(sql)
			if not dbrs.eof then
				for i=0 to dbrs.Fields.Count-1
				execute("db_"&dbrs.Fields(i).Name & "=dbrs.Fields(" & i & ").value")
			Next
			getappinfo=true
		else
			errmsg="无权操作或数据查询失败"
		end if
		dbrs.close:set dbrs=nothing		
	end function

	'获取产品信息
	public function getproductinfo()
		If Trim(P_proId)="" Then errmsg="没有找到此产品型号":Exit Function		
		ispackage=false
		for each line_ in appconfig("package")
			if line_("proid")=P_proId then
				ispackage=true
				p_name=line_("name")
				p_name=line_("name")
				product_ids=line_("product_ids")
			end if
		next
		if trim(product_ids)="" then
			errmsg="没有找到此产品型号":Exit Function		
		end if
	End Function

	
	'获取用户信息
	Public Function getuserinfo(ByVal user_sysid_)
		getuserinfo=false
		If Not IsNumeric(user_sysid_&"") Then errmsg="会员编号有误":Exit Function
		if trim(user_sysid_&"")="" then 
			sql="select top 1 u_name from userdetail where u_level="& tem_level
			set urs=conn.execute(sql)
			if not urs.eof then
				user_name=urs("u_name")
			end if
			urs.close
			set urs=nothing 
		Else
			sql="select top 1 * from userdetail where u_id="& user_sysid_
			set urs=conn.execute(sql)
			if not urs.eof then
				user_name=urs("u_name")
				u_namecn=urs("u_namecn")
				u_address=urs("u_address")
				msn_msg=urs("msn_msg")
				u_email=urs("u_email")
				u_levelid=urs("u_level")
				user_sysid=urs("u_id")
				u_usemoney=urs("u_usemoney")
				user_sysid=urs("u_id")
			end if
			urs.close
			set urs=nothing		
		End if
		getuserinfo=true
	End function
	
	'添加购物车
	function addbagshow(byval appname_,byval year_,byval paytype_)
		addbagshow=false
		dim ppricetemp
		if instr(",1,2,3,",","&year_&",")=0 then errmsg="年限设置有误":Exit Function
		if instr(",0,1,",","&paytype_&",")=0 then errmsg="试用参数错误":Exit Function
		ppricetemp=miniprogram_paytype_money
		if clng(paytype_)=0 then
			ppricetemp=GetNeedPrice(user_name,P_proId,year_,"new")
		end if 
		strContents="miniprogram"&vbcrlf&_
			 "add"&vbcrlf&_
			 "entityname:miniprogram"&vbcrlf&_
			 "appname:"& appname_ &""&vbcrlf&_
			 "producttype:"&P_proId&vbcrlf&_
			 "years:"& year_ &vbcrlf&_
			 "paytype:"& paytype_ &vbcrlf&_
			 "ppricetemp:"& ppricetemp &vbcrlf&_
			 "."&vbcrlf

		  call add_shop_cart(user_sysid,"miniprogram",appname_,strContents)		
		addbagshow=true
	end function

	'获取app密码
	function getpwd()
	 	dim strContents,loadRet
		getpwd=false
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:pwd"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
		loadRet=connectToUp(strContents) 
		if left(loadRet,3)="200" then 
			okmsg=getReturn(loadRet,"password")
			getpwd=true
		else
			errmsg=loadRet
		end if 
	end function

	'跳转登陆
	function getmanager()
		dim strContents,loadRet
		getmanager=false
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:manager"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
		loadRet=connectToUp(strContents) 
		if left(loadRet,3)="200" then 
			okmsg=getReturn(loadRet,"url")
			getmanager=true
		else
			errmsg=loadRet
		end if 		 
	end function


	'设置app密码
	function setrepwd()
		dim strContents,loadRet
		setrepwd=false
		strContents="miniprogram"&vbcrlf&_
					"set"&vbcrlf&_
					"entityname:pwd"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
		loadRet=connectToUp(strContents) 
		if left(loadRet,3)="200" then 
			okmsg=getReturn(loadRet,"password")
			setrepwd=true
		else
			errmsg=loadRet
		end if 		 
	end function

	'获取短信可用条数
	function getsmscount()
		dim strContents,loadRet
		getsmscount=false 
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:sms"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
	 
		loadRet=connectToUp(strContents) 
		if left(loadRet,3)="200" then 
			okmsg=getReturn(loadRet,"count")
			getsmscount=true
		else
			errmsg=loadRet
		end if 
	end function 

	'获取当前app产品ID
	Public Function getproductids()
		dim strContents,loadRet
		getproductids=false
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:productids"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
	 
		loadRet=connectToUp(strContents) 
		if left(loadRet,3)="200" then 
			db_tcproid=getReturn(loadRet,"tcid")
			db_otherproid=getReturn(loadRet,"otherid")
			getproductids=true
		else
			errmsg=loadRet
		end if 
	End Function

	'获取所有价格
	function getAllPrice()
		getAllPrice=false
		set allpricedic=Server.CreateObject("Scripting.Dictionary")		
 
		for each line_ in appconfig("config")
			if trim(line_("proid"))<>"" then
				allpricedic.add line_("id"),array(line_("name"),line_("proid"),GetNeedPrice(user_name,line_("proid"),1,"new"),GetNeedPrice(user_name,line_("proid"),1,"renew"))
			else
					allpricedic.add line_("id"),array(line_("name"),line_("proid"),0,0)
			end if
		next
		set okmsg=allpricedic
		getAllPrice=true
	end function

	function getAppList()
		getAppList=false
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:list"&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf 
		loadRet=connectToUp(strContents)	 
		if left(loadRet,3)="200" then 
		dim fdlist_,recordset_
			fdlist_=getReturn(loadRet,"fdlist")
			recordset_=getReturn_rrset(loadRet,"recordset")
			set lineArr=newarray()
			for each line_ in split(recordset_,vbcrlf)
				temp_=split(line_,"~|~")
				set linedic=newoption()
				index_=0
				for each title_ in split(fdlist_,",")
					linedic.add title_,temp_(index_)
					index_=index_+1
				next
				lineArr.push(linedic)
			next			
			set okmsg=lineArr
			getAppList=true
		else			
			errmsg=loadRet
		end if  			
	
		 
	end function

	'购买短信条数
	function buysms(byval num)
		buysms=false
		dim sumprice
		if not isnumeric(num&"") then errmsg="短信数量错误":Exit Function
		if clng(num)<clng(min_smscount) then errmsg="短信数量必须大于"&min_smscount&"条":Exit Function
		sumprice=ccur(num)*ccur(miniprogram_sms_money) 
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="可用余额不足["&sumprice&"]["&u_usemoney&"]":Exit Function
		if consume(user_name,sumprice,0,"buyapp-sms","小程序购买短信["&db_appid&"]["&num&"]","buyappsms",db_id) then
			strContents="miniprogram"&vbcrlf&_
						"add"&vbcrlf&_
						"entityname:buysms"&vbcrlf&_
						"appid:"&db_appid&vbcrlf&_
						"count:"&num&vbcrlf&_
						"ppricetemp:"&FormatNumber(sumprice,2,-1,,0)&vbcrlf&_
						"."&vbcrlf
			
			loadRet=connectToUp(strContents) 
			if left(loadRet,3)="200" then 
				buysms=true
			else
				
				errmsg=loadRet
			end if  
		else
			errmsg="扣款失败"
		end if
	end function


	'套餐续费
	function renew(byval renyear,byval otherids)
		renew=false
		if not isnumeric(renyear&"") then errmsg="续费年限有误":exit function
		if renyear<1 then  errmsg="续费年限有误":exit function
		if clng(renyear)>clng(buymaxyear) then  errmsg="最大续费年限为"&buymaxyear&",当前为"&renyear&"年":exit function
		dim otherprice,tcprice,paytype_action 
		paytype_action="renew"
		tcprice=GetNeedPrice(user_name,db_proid,renyear,"renew")  
		if db_paytype&""="1" then 
			 tcprice= ccur(GetNeedPrice(user_name,db_proid,renyear,"new"))-ccur(miniprogram_paytype_money)
			 paytype_action="new"
		end if
		otherprice=0 
		set ids=newarray() 
		if trim(otherids)<>"" then
			for each id_ in split(otherids,",")
				if isnumeric(id_&"") then ids.push(id_)
			next 
		end if
		otherids=ids.join(",")
		if trim(otherids)<>"" then
			for each cfg in appconfig("config")
				if instr(","&otherids&",",","&cfg("id")&",")>0 then
					otherprice=ccur(otherprice)+ccur(GetNeedPrice(user_name,cfg("proid"),renyear,paytype_action))
				end if
			next
		end if
		sumprice=ccur(otherprice)+ccur(tcprice) 
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="可用余额不足["&sumprice&"]["&u_usemoney&"]":Exit Function	
		if consume(user_name,sumprice,0,"renew-"&db_appid,"小程序续费["&db_appid&"]["&otherids&"]["&otherprice&"]","renew-xcx",db_id) then
			strContents="miniprogram"&vbcrlf&_
						"renew"&vbcrlf&_
						"entityname:app"&vbcrlf&_
						"appid:"&db_appid&vbcrlf&_
						"years:"&renyear&vbcrlf&_
						"productids:"&otherids&vbcrlf&_ 
						"ppricetemp:"&sumprice&vbcrlf&_
						"."&vbcrlf
			loadRet=connectToUp(strContents)
			if left(loadRet,3)="200" then		 
				sql="update wx_miniprogram_app set expireDate=dateadd("&PE_DatePart_Y&","&renyear&",expireDate),buyYear=(buyYear+"&renyear&"),paytype=0 where id="&db_id 
				conn.execute(sql)
				renew=true				
			else 
				call addRec("微信小程序扣费成功但续费失败",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="扣款失败,请联系管理员"
		end if 
	end function


	'创建小程序
	function create(byval strContents)
		create=false
		appname=getReturn(strContents,"appname")
		producttype=getReturn(strContents,"producttype")
		years=getReturn(strContents,"years")
		paytype=getReturn(strContents,"paytype")
		ppricetemp=getReturn(strContents,"ppricetemp") 
		buytypetxt="小程序购买"
		if trim(appname)="" then errmsg="APP名称有误!":exit function
		if not isnumeric(years&"") then errmsg="开通年限有误!":exit function
		if instr(",0,1,",","&paytype&",")=0 then errmsg="试用参数错误":Exit Function
		if not isnumeric(ppricetemp&"") then  errmsg="开通价格有误":Exit Function 
		If CLng(paytype)=1 Then buytypetxt="小程序试用"
		sumprice=ppricetemp
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="可用余额不足["&sumprice&"]["&u_usemoney&"]":Exit Function	
		if consume(user_name,sumprice,0,"create-xcx",buytypetxt&"["&producttype&"]","create-xcx","") then
			loadRet=connectToUp(strContents)		 
			if left(loadRet,3)="200" then	
				appid=getReturn(loadRet,"appid")
				if paytype=1 then
				   buyYear=0
				   expireDate=dateadd("D",7,now())
				Else
				   buyYear=years
				   expireDate=dateadd("YYYY",buyYear,now())
				end if	 
				sql="insert into wx_miniprogram_app(userid,appName,paytype,buyYear,expireDate,appid,proid) values("&user_sysid&",'"&appname&"',"&paytype&","&buyYear&",'"&expireDate&"',"&appid&",'"&producttype&"')"
				conn.execute(sql)
				create=true				
			else 
				call addRec("微信小程序额外增加功能失败款已经扣["&producttype&"]["&user_name&"]",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="扣款失败,请联系管理员"
		end if 
	 end function
 

	function synappid(byval islist_)
		synappid=false
		if trim(islist_)&""<>"1" then islist_="0"
		strContents="miniprogram"&vbcrlf&_
					"get"&vbcrlf&_
					"entityname:syn"&vbcrlf&_
					"islist:"&islist_&vbcrlf&_
					"appid:"&db_appid&vbcrlf&_
					"."&vbcrlf
		loadRet=connectToUp(strContents)
		if left(loadRet,3)="200" then	
			dim objstr
			appid=0
			objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}"
			set obj_=jsontodic(objstr) 
			for each line_ in obj_("datas")	
				appid=line_("appid")
				if islist_&""="0"  then
					sql="update wx_miniprogram_app set appName='"&line_("appname")&"',paytype='"&line_("paytype")&"',buyYear='"&line_("buyyear")&"',buyDate='"&line_("buydate")&"',	expireDate='"&line_("expiredate")&"' where appid="&appid
					conn.execute(sql)
				else
					sql="select * from wx_miniprogram_app where appid="&appid
					set ars=Server.CreateObject("adodb.recordset")
					ars.open sql,conn,1,3
					if ars.eof then 
					   ars.addnew
					   ars("userid")=getAdminUid()
					   ars("appid")=appid
	 
					end if
					ars("appName")=line_("appname")
					ars("paytype")=line_("paytype")
					ars("buyYear")=line_("buyyear")
					ars("buyDate")=line_("buydate")
					ars("expireDate")=line_("expiredate")
					ars("appName")=line_("appname")
					ars("proid")=line_("proid")
					ars.update
				end if
			next
			synappid=true	
			okmsg=appid	  
		else 
			errmsg=loadRet
		end if  
	end function
	

	function getAdminUid()
		if clng(adminuserid)>0 then getAdminUid=adminuserid: exit function
		sql="select top 1 u_id from UserDetail where u_type='111111' order by u_id asc"
		set glrs=conn.execute(sql)
		if not glrs.eof then 
		adminuserid=glrs(0)
		end if
		glrs.close:set grlrs=nothing
		getAdminUid=adminuserid
	end function


	'单个app续费
	function appAddNew(byval id_,byval addyear,byval paytype)
		appAddNew=false
		if not isnumeric(id_&"") then errmsg="产品ID有误":exit function
		if not isnumeric(addyear&"") then errmsg="开通/续费年限有误":exit function
		if addyear<1 then  errmsg="开通/续费年限有误":exit function
		if clng(addyear)>clng(buymaxyear) then  errmsg="最大续费年限为"&buymaxyear&",当前为"&addyear&"年":exit function
		if instr(",0,1,",","&paytype&",")=0 then errmsg="试用参数错误":Exit Function
		dim newproid,buytypetxt
		newproid=""
		buytypetxt="小程序新购"
		for each line_ in appconfig("config")
			if clng(line_("id"))=clng(id_) then
				newproid=line_("proid")
				exit for
			end if
		next
		if trim(newproid)="" then errmsg="产品查询型号有误,请联系管理员":Exit Function
		if clng(db_paytype)=1 then  '未正式开通的只能试用
			price_=0
			buytypetxt="小程序试用"
		else
			if clng(paytype)=1 then
				price_=0
				buytypetxt="小程序试用" 
			else
				price_=GetNeedPrice(user_name,newproid,addyear,"new")
			end if
		end if
		sumprice=price_
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="可用余额不足["&sumprice&"]["&u_usemoney&"]":Exit Function	
		if consume(user_name,sumprice,0,"addnew-xcx-"&db_appid,buytypetxt&"["&db_appid&"]["&id_&"]["&sumprice&"]","addnew-xcx",db_id) then
			strContents="miniprogram"&vbcrlf&_
						"add"&vbcrlf&_
						"entityname:other"&vbcrlf&_
						"appid:"&db_appid&vbcrlf&_
						"productid:"&id_&vbcrlf&_
						"paytype:"&paytype&vbcrlf&_
						"years:"&addyear&vbcrlf&_ 
						"ppricetemp:"&sumprice&vbcrlf&_
						"."&vbcrlf 
			loadRet=connectToUp(strContents)
			if left(loadRet,3)="200" then	
			   
				appAddNew=true				
			else 
				call addRec("微信小程序额外增加功能失败款已经扣["&db_appid&"]["&id_&"]",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="扣款失败,请联系管理员"
		end if  
	end function  
end class
%>