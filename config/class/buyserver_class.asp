<%
Class buyServer_Class
	dim act,u_levelid,user_name,user_sysid,u_resumesum,u_usemoney,u_company,u_contract,u_telphone,u_email,qq_msg,msn_msg,u_zipcode,u_address,UserIP,p_proid,cdnType,firstlevelTime
	dim isvps,addServerPrice,rPrice,newvpstype,isnewtype,MoneyPerMonth,PricMoney,aid,VPSOpen,paymonthnum,serverdiy,vpsip,vpsPassWord,servicetypePrice
	dim Company,Name,u_trade,Telephone,Email,QQ,Fax,Zip,Address,HostID,CPU,HardDisk,Memory,Years,Memo,CHOICE_OS,checkStup,servicetype,PayMethod,serverRoom,Apply,MainBoard
	dim svr_0,svr_1,svr_2,svr_3,svr_4,svr_5,svr_1_pmore,svr_2_pmore,svr_3_pmore,svr_4_pmore,svr_0_p,svr_1_p,svr_2_p,svr_3_p,svr_4_p,svr_5_p
	dim oldpaymethod,oldexpiredate,oldRoom,oldcdn,oldproid,newRoom,newcdn,newproid,blday,oldprice,all_day,leavings_day,newprice,blprice,bldayArr,RamdomPass,Maxwhiteline
	dim oldserverip,sstate,start,oldhostid,starttime,isCloud,money_daycj,oldPricMoney,flux,invoiceset
	dim uphost_countstrs,isUPGRADE,souxvfei,renewTime,allocateip
	dim up_selectroomlist,up_proidlist,up_s_room,up_cb_price,up_ProShouXuFei,up_baoliuday,upstate,ipprice
	
	Private Sub Class_Initialize
		addServerPrice=0
		MoneyPerMonth=0
		PricMoney=0
		PayMethod=1'默认年付
		monthnum=1
		souxvfei=30'升级手续费
		cdnType=""
		newcdn=""
		renewTime=1
		buycount=1
		uphost_countstrs=""
		vcppricezhe=0.95'被推荐人折扣
		VPSOpen="order"
		ipprice=0
	End Sub
	
	
	Public Property Let setUserid(value)
		upstate=0
        user_sysid=value
		if user_sysid="" then user_sysid=0
		getUserinfo()
 	End Property
	private function getUserinfo()
		if trim(user_sysid&"")="" or not isnumeric(user_sysid) then url_return "请重新登陆",-1
		sql="select top 1 * from userdetail where u_id="& user_sysid
		set urs=conn.execute(sql)
		if not urs.eof then
			user_name=urs("u_name")
			u_resumesum=urs("u_resumesum")
			u_usemoney=urs("u_usemoney")
			u_levelid=urs("u_level")
			firstlevelTime=urs("firstlevelTime")
			u_company=urs("u_company")
			u_contract=urs("u_contract")
			'u_trade=urs("u_trade")
			u_telphone=urs("u_telphone")
			u_email=urs("u_email")
			msn_msg=urs("msn_msg")
			u_zipcode=urs("u_zipcode")
			u_address=urs("u_address")
			UserIP=GetuserIp()
			if not isdate(firstlevelTime) then firstlevelTime=now()
		end if
		urs.close
		set urs=nothing 
	end function
	public function upgrade(byval this_proid,byval this_roomid,byval cdntype,byval baoliuday,byref resultstr)
		commandstr="server"& vbcrlf & _
				   "set"& vbcrlf & _
				   "entityname:upserver" & vbcrlf & _
				   "serverip:" & allocateip & vbcrlf & _
				   "cdntype:" & cdntype & vbcrlf & _
				   "newproid:" & this_proid & vbcrlf & _
				   "newroomid:" & this_roomid & vbcrlf & _
				   "baoliuday:"& baoliuday & vbcrlf & _
				   "." & vbcrlf	  
		resultstr=pcommand(commandstr,user_name)		
		if left(resultstr,3)="200" then									 
			upgrade=true
		else
			upgrade=false
		end if
	end function
	public function modifyInfo()
		commandstr="server"& vbcrlf & _
				   "set"& vbcrlf & _
				   "entityname:modinfo" & vbcrlf & _
				   "serverip:" & allocateip & vbcrlf & _
				   "UserName:" &Name  & vbcrlf & _
				   "telephone:" & telephone & vbcrlf & _
				   "address:" & address & vbcrlf & _
				   "Email:"& Email & vbcrlf & _
				   "QQ:"& QQ & vbcrlf & _
				   "fax:"& fax & vbcrlf & _
				   "RamdomPass:"& RamdomPass & vbcrlf & _
				   "name:"& vbcrlf & _
				   "." & vbcrlf 
'Response.Write(commandstr)
'response.End()
		modifyInfo=pcommand(commandstr,user_name)		
		
	end function
	public function getUpInfo(byval this_proid,byval this_roomid,byval baoliuday)
		commandstr1_="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:upserverinfo"& vbcrlf & _
				   "serverip:"& allocateip & vbcrlf & _
				   "cdntype:"& cdntype & vbcrlf & _
				   "new_proid:"& this_proid & vbcrlf & _
				   "new_roomid:"& this_roomid & vbcrlf & _	
				   "baoliuday:"& baoliuday & vbcrlf & _	   
				   "." & vbcrlf		
		 returnstr=pcommand(commandstr1_,user_name)		
		 if left(returnstr,3)="200" then 
		 	up_selectroomlist = chgroomName(getReturn_rrset(returnstr,"roomlist"))
			up_proidlist=getReturn_rrset(returnstr,"proidlist")
			up_s_room=getReturn_rrset(returnstr,"s_room")
			up_cb_price=getReturn_rrset(returnstr,"cb_price")
			souxvfei=getReturn_rrset(returnstr,"pro_sxf")	
			up_baoliuday=getReturn_rrset(returnstr,"baoliuday")	
			blprice=getReturn_rrset(returnstr,"blprice")	
			upstate=getReturn_rrset(returnstr,"upstate")	
			if up_proidlist="" then
				url_return "该主机类型禁止升级",-1
			end if
		 else
		 	url_return "获取升级信息失败,请联系管理员"& returnstr,-1
		 end if
	end function
	public function getReturn_rrset(ByVal inputStr,ByVal fdname)
		result=""
		for each line_item in split(inputStr,vbcrlf)
			pot=instr(line_item,":")
			if pot>0 then
				keyname=mid(line_item,1,pot-1)
				keyval=mid(line_item,pot+1)
				if keyname=fdname then
					result=keyval
					exit for
				end if
			end if
		next
		getReturn_rrset=result
	end function
	public function getHostdata(byval allocateip_)
		if isip(allocateip_) then
			sql="select * from HostRental where u_name='"& user_name &"' and allocateip='"& allocateip_ &"'"
		elseif isnumeric(allocateip_) and  allocateip_&""<>"" then
			sql="select * from HostRental where u_name='"& user_name &"' and id="& allocateip_
		else
			url_return "参数出错",-1
		end if
		rs1.open sql,conn,1,1
		if not rs1.eof then
			For f=0 To rs1.fields.count-1
			 field_name=trim(rs1.fields(f).name)
			 if field_name<>"" And checkRegExp(field_name,"^[\w]+$") then
				 execute field_name&"=rs1("""& field_name &""")"
			 end if
			Next
		else 
			url_return "没有找到该主机",-1 
		end if
		rs1.close
		'die p_proid
		oldserverip=AllocateIP
		oldproid=p_proid
		oldRoom=serverroom
		oldcdn=cdntype
		if isnull(preday) then preday=0
		oldexpiredate=formatDateTime(DateAdd("d",preday,DateAdd("m",alreadypay,starttime)),2)
		'oldexpiredate=DateAdd("m",alreadypay,starttime)
	 
	end function
	public function buyordersub()
		if trim(user_name)&""="" then url_return "用户名信息丢失！请重试",-1
		sql="select * from HostRental"
		rs.open sql,conn,1,3
		rs.addnew()
		rs("Name")=name
		rs("u_trade")=u_trade
		rs("Company")=Company
		rs("Telephone")=Telephone
		rs("Address")=Address
		rs("Zip")=Zip
		rs("Email")=Email
		rs("QQ")=QQ
		rs("Fax")=Fax
		rs("HostId")=HostId
		rs("OS")=CHOICE_OS
		rs("Apply")=Apply
		rs("CPU")=cpu
		rs("HardDisk")=HardDisk
		rs("Memory")=Memory
		rs("PayMethod")=PayMethod
		rs("Years")=Years
		rs("serverRoom")=serverRoom
		rs("Memo")=Memo
		rs("SubmitTime")=now()
		rs("Start")=0
		rs("Alert")=0
		rs("MoneyPerMonth")=0
		rs("AlreadyPay")=0
		rs("UserIP")=UserIP
		rs("u_name")=user_name
		rs("hosttype")=isvps
		rs("addedServer")=servicetype
		rs("addServerPrice")=addServerPrice
		rs("MainBoard")=MainBoard
		rs("p_proid")=p_proid
		rs("cdntype")=cdntype
		rs("invoiceset")=invoiceset
		rs.update()
		rs.close()	
		sql="select top 1 id from HostRental where Name='"& Name &"' and u_name='"& user_name &"' order by id desc"
		rs.open sql,conn,1,1
			aid=rs(0)
		rs.close
	end function
	public function getServerPrice(byval dotype)
        
	    if trim(dotype)="renew" and clng(PayMethod)=0 then
		PricMoney=getVpsprice(user_name,p_proid,serverroom,1,cdntype,dotype)/10
		else
		PricMoney=cdbl(getVpsprice(user_name,p_proid,serverroom,PayMethod,cdntype,dotype))
    	end if
		 
		servicetypePrice=getOtherPrice(servicetype,isvps)
       
		paymonthnum=getpaymonthnum(PayMethod) 
	 
		MoneyPerMonth=round((PricMoney/paymonthnum)+servicetypePrice)
	'	if clng(PayMethod)=4 then
'		PricMoney=PricMoney+paymonthnum * servicetypePrice*0.75
'		else
		PricMoney=(PricMoney+paymonthnum * (servicetypePrice+getServersMoney))*renewtime
        'end if
		'die renewtime&"|"&PricMoney*renewtime&"|"&servicetypePrice&"|"&paymonthnum
		
	end function
	public function getrenewPrice()
	
	'添加云主机升级判断
     if trim(p_proid)="ebscloud" then
	        set ds=new diyserver_class
			ds.user_sysid=user_sysid
			ds.p_proid=p_proid	
			ds.setHostid=id	
			ds.PayMethod=PayMethod
			ds.renewTime=renewTime
			PricMoney=ds.getRenewprice()
			paymonthnum=ds.monthnum
			ipprice=ds.ipprice
			PricMoney=PricMoney
			set ds=nothing
	 else
		getServerPrice("renew")
		PricMoney=PricMoney
	'	PricMoney=Round(cdbl(PricMoney)*renewTime+cdbl(getServersMoney)*renewTime)	
  	 end if

	end function
	public function getupneedprice()
		p_proid=oldproid
		serverRoom=oldRoom
		cdntype=oldcdn
		call getServerPrice("renew")
		oldprice=PricMoney
		p_proid=newproid
		serverRoom=newRoom
		cdntype=newcdn
		call getServerPrice("renew")
		newprice=PricMoney
		
		start_day=dateadd("m",paymonthnum-paymonthnum*2,oldexpiredate)'开始时间
		all_day=datediff("d",start_day,oldexpiredate)'总天数
		leavings_day=datediff("d",date,oldexpiredate)'未使用天数
		money_daycj=(cdbl(newprice)-cdbl(oldprice))/all_day'每天差价
		if money_daycj<0 then money_daycj=0
		getupneedprice=round(money_daycj*leavings_day) + blprice
		if getupneedprice<0 then getupneedprice=0
		getupneedprice=getupneedprice+souxvfei
		if getupneedprice<cdbl(up_cb_price) then getupneedprice=cdbl(up_cb_price)
	end function
	function isXtoV(byval newproid,byval oldproid)'是否是 星云主机<<=>>vps
		results=false
		if left(lcase(oldproid),5)="xclou" and left(lcase(newproid),5)<>"xclou" then
			results=true
		elseif left(lcase(oldproid),5)<>"xclou" and left(lcase(newproid),5)="xclou" then
			results=true
		end if
		isXtoV=results
	end function
	public function buysub()	

		getServerPrice("new")	
		buyordersub()
		if VPSOpen="open" then 
			strContents ="server" & vbCrLf & "add" & vbCrLf & _
						 "entityname:server" & vbCrLf & _
						 "producttype:vpsserver" & vbCrlf & _
						 "p_proid:" & p_proid  & vbCrLf & _
						 "cdntype:" & cdntype & vbcrlf & _
						 "name:" & Name & vbCrLf & _
						 "u_trade:"& u_trade & vbCrLf & _
						 "company:"& Company & vbCrLf & _
						 "telephone:" & Telephone & vbCrLf & _
						 "address:" & Address & vbCrLf & _
						 "zip:" & Zip & vbCrLf & _
						 "email:"& Email & vbCrLf & _
						 "qq:"& QQ & vbCrLf & _
						 "fax:"& Fax & vbCrLf & _
						 "hostid:" & HostID & vbCrLf & _
						 "choice_os:" & CHOICE_OS & vbCrLf & _
						 "apply:"& Apply & vbCrLf & _
						 "cpu:"& CPU & "-" & CreateRandomKey(6) & vbCrLf & _
						 "harddisk:"& HardDisk & vbCrLf & _
						 "memory:"& Memory & vbCrLf & _
						 "paymethod:" & PayMethod & vbCrLf & _
						 "renewTime:" & renewTime & vbCrLf & _
						 "years:"& Years & vbCrLf & _
						 "serverroom:"& serverRoom & vbCrLf & _
						 "isvps:" & isVps & vbCrLf & _
						 "servicetype:"& servicetype & vbCrLf & _
						 "addserverprice:"& addServerPrice & vbCrLf & _
						 "mainboard:"& MainBoard & vbCrLf & _
						 "pricmoney:" & PricMoney  & vbCrLf & _
						 "isnewtype:" & isnewtype  & vbCrLf & _
						 "aid:" & aid  & vbCrLf & _
						 "memo:"& server.HTMLEncode(replace(replace(Memo,vbcrlf,CHR(10)),":","：")) & vbcrlf & _						 
						 "." & vbCrLf
			ywtype="server"
            ywname=p_proid
			call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)		
			'session("order") =  strContents & session("order")
			conn.close
			Response.redirect "/bagshow/"
			response.end
		else				
			session("order_id")="server"& vbcrlf & aid
			Response.redirect "/bagshow/orderlist.asp?orderid="& aid &"&productType=server&PricMoney="& PricMoney
			response.end	
		end if	 
	end function
	
	public function getPostvalue()		
		for str_i = 1 to Request.form.count
			formkey=sqlincode(trim(Request.form.key(str_i)))
			if allowkey(formkey) then
				formvalue=trim(Requesta(formkey))&""				 
				
				' response.Write(formkey&"=========>"&formvalue&"<BR>")
				
				
				checkissub=checkinput(formkey,formvalue)
				if left(formkey,4)="svr_" then
					if formvalue="" then url_return "请将所有设备选择完整",-1
				end if
				
 
				
				if checkissub="" then
					formvalue=server.HTMLEncode(replace(replace(formvalue,chr(13),""),chr(10),""))
					if formkey<>"" And checkRegExp(formkey,"^[\w]+$") then
						execute formkey & "=formvalue"
					end if
 				else
					url_return checkissub,-1
				end if
			end if
		next
		if invoiceset&""="" or not isnumeric(invoiceset) then invoiceset=0
		if requesta("vps")="okay" then
			isvps=1
		else
			isvps=0
			VPSOpen="order"
		end if
		
		addServerPrice=getOtherPrice(servicetype,isvps)
		Memo=Memo & vbcrlf & checkStup & "【" & rPrice & "】 增值服务：" & servicetype
		isnewtype = (instr(newvpstype,HostID & ",")>0)
		'response.End()
	end function
	public function allowkey(byval key)
		keystr="Company,Name,u_trade,Telephone,Email,QQ,Fax,Zip,Address,HostID,CHOICE_OS,Apply,CPU,HardDisk,Memory,Years,serverRoom,cdntype,checkStup,servicetype,PayMethod,Memo,VPSOpen,p_proid,RamdomPass,renewTime"
		if instr(","&lcase(keystr)&",",","&lcase(key)&",")>0 then
			allowkey=true
		else
			allowkey=false
		end if
	end function
	public function checkinput(byval inputkey,byval inputvalue)
		checkinput=""
	 
		select case trim(lcase(inputkey))
			case "cdntype"
				if inputvalue<>"" then
					if not isNumeric(inputvalue) then
						checkinput="cdn出口类型不正确"
					end if
				end if
			case "company"
				if inputvalue<>"" then
					if not regCheck("^[\u4e00-\u9fa5\w\.\-\(\)]{3,60}$",inputvalue) then
						checkinput="公司名格式不正确"
					end if
				end if
			case "name"
				if not regCheck("^[\u4e00-\u9fa5\w\.]{2,4}$",inputvalue) then
					checkinput="联系人姓名不正确"
				end if
			case "u_trade"
			 	if not regCheck("^.{4,50}$",inputvalue) then
					checkinput="证件号格式不正确"
				end if
			case "telephone"
				if not regCheck("^[\d\-]{7,20}$",inputvalue) then
					checkinput="电话号码格式不正确"
				end if
			case "email"
				if not regCheck("^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$",inputvalue) then
					checkinput="邮箱号码格式错误"
				elseif len(inputvalue)>50 then
					checkinput="邮箱号码长度应不超过50位"
				end if 
			case "qq"
				if not regCheck("^[\d]{5,15}$",inputvalue) then
					checkinput="QQ号码格式不正确"
				end if
			case "fax"
				if not IsValidMobileNo(inputvalue) then
					checkinput="手机号码格式错误"
				end if
			case "zip"
				if not regCheck("^[\d]{6}$",inputvalue) then
					checkinput="邮编格式不正确"
				end if
			case "address"
				if not regCheck("^[\u4e00-\u9fa5\w\.\-\,，\(\)]{5,50}$",inputvalue) then
					checkinput="联系人详细通信地址格式错误,长度为5-50位,不能有特殊字符"
				end if
			case "hostid"
				if not regCheck("^.{2,50}$",inputvalue) then
					checkinput="服务器类型格式不正确"
				end if
			case "cpu"
				if not regCheck("^.{2,50}$",inputvalue) then
					checkinput="处理器不正确"
				end if
			case "harddisk"
				if not regCheck("^.{2,50}$",inputvalue) then
					checkinput="硬盘格式不正确"
				end if
			case "memory"
				if not regCheck("^.{2,50}$",inputvalue) then
					checkinput="内存格式不正确"
				end if
			case "memo"
				if inputvalue<>"" then
					if not regCheck("^[\s\S]{5,180}$",inputvalue) then
						checkinput="备注字符需5～180个字符之间"
					end if
				end if
			case "paymethod"
				if instr(",0,1,2,3,4,5,",","&inputvalue&",")=0 then
					checkinput="付款方式不正确"
				end if
			case "ramdompass"
				if not regCheck("^.{6,20}$",inputvalue) then
					checkinput="服务器密码需6到50位"
				end if
			case "renewtime"
			    
			 	if  inputvalue<1 then
					checkinput="服务年限错误"
				end if
		end select
	end function
	function getVpsPayMethod()
		result="出错"
		commandstr="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:server_paymethod"& vbcrlf & _
				   "productid:" & p_proid & vbcrlf & _
				   "serverroom:"& serverroom & vbcrlf & _
					"." & vbcrlf
		 returnstr=pcommand(commandstr,"AgentUserVCP")
		 if left(returnstr,3)="200" then	 		
			result= getReturn_rrset(returnstr,"PayMethod")
		 end if
		 getVpsPayMethod=result
	end function
	function getpaymethodName(byval payid)
		select case payid
		case 0
			result="月付"
		case 2
			result="季付"
		case 3
			result="半年付"
		case 1
			result="年付"
		end select
		getpaymethodName=result
	end function

	function getServersMoney()
    getServersMoney=0
   if instr(addedServer,"基础服务")>0 then getServersMoney=0
   if instr(addedServer,"铜牌服务")>0 then getServersMoney=68
   if instr(addedServer,"银牌服务")>0 then getServersMoney=88
   if instr(addedServer,"金牌服务")>0 then getServersMoney=188
	end function 
End Class
%>