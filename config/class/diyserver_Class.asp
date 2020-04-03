<%
Class diyserver_class
	dim u_levelid,user_name,user_sysid,u_resumesum,u_usemoney,u_company,u_contract,u_telphone,u_email,qq_msg,msn_msg,u_zipcode,u_address,p_proid,u_trade,Apply,UserIP,firstlevelTime,u_renzheng
	dim cpu,ram,data,flux,room,PayMethod,renewTime,servicetype,CHOICE_OS,addServerPrice,aid,hostStart,paytype,buycount,disktype,ddos,prodtype,snapadv,snapadvprice,oldsnapadv
	dim oldcpu,oldram,olddata,oldflux,oldroom,oldservicetype,oldCHOICE_OS,oldaddServerPrice,oldcpuhz,oldramsize,oldexpiredate,h_oldprice,oldMoneyPerMonth,oldhostStart,oldddos,oldosdata,oldcc
	dim cpuhz,ramsize,sstate,isUPGRADE
	dim appObj,MoneyPerMonth,monthnum,vpsIP,vpsPassWord,RamdomPass,Maxwhiteline,starttime,differentstr,isCloud,blday,ddos_price,free_cc_roomids,allow_cc_roomids
	dim errstr,isfast,VPSOpen,blprice,bldayArr,souxvfei,all_day,leavings_day,money_daycj,newprice,oldprice,oldserverip,oldhostid,newddos
	dim cpu_price,ram_price,flux_price,data_price,fullprice
	dim hostVersion,kvmdefaultRoom,chgroomSxfei,paytestPrice,allbuytestcount
	dim newservicetype,newPayMethod,newrenewTime
	dim newroom,isupdate,MainBoardStr,MainBoard,jsondb,diy_buy_time_dis,ipprice,cc
	Private Sub Class_Initialize
		errstr="":differentstr=""
		Apply="企业经营网站"
		HostVersion="KVM"'设置开通主机的版本，多个用逗号分隔 KVM,Hyper-V
		kvmdefaultRoom=22 'kvm主机开通时默认机房
		VPSOpen=false
		isCloud=false
		isupdate=false'是否是升级		
		MoneyPerMonth=0
		isUPGRADE=false
		souxvfei=0'升级手续费
		chgroomSxfei=10'转机房手续费
		monthnum=1		
		if trim(diypaytestPrice)<>"" then
			paytestPrice=diypaytestPrice
		else
			paytestPrice=18   '试用主机价格
		end if
		allbuytestcount=5'允许直接客户试用的次数
		isfast=false'是否缓存数据快速读取true:缓存;false:时时
		buycount=1
		bldayArr=Array("0:0","1:10","2:20","3:30","4:40","5:50","6:60","7:70")'保留天数和所需价格 格式"天:钱"
		set appObj=server.CreateObject("Scripting.Dictionary")	
		jsondb=""
		ddos=0
		diy_buy_time_dis=1   'diy_buy_time_dis  
		ipprice=0
		prodtype=0   '
		snapadv=0
		snapadvprice=10

		cc=0
		free_cc_roomids=",47,"   '免费使用集群ID 
		allow_cc_roomids=",37,38,47,"  '支持的集群ID
	End Sub
	Private Sub Class_Terminate
		set appObj=nothing
	End Sub
	Public Property Let setProid(value)
        p_proid=value
		call setappdata()
		if errstr="" then	getUserinfo()	
	End Property
	public Property Let setHostid(value)
		aid=value
		oldhostid=aid
		
		if aid<>"" and (isnumeric(aid) or isip(aid)) then
			
			getUserinfo()
			
			if errstr="" then
				call gethostinfo(aid)
			end if
		else
		 
			errstr="服务器标识id错误"
		end if
		
	end Property
	public sub setappdata()
		diyserverapp=getdiyserverapp()
		 
		if diyserverapp<>"" then			
			dostring=myinstr(diyserverapp,"\b"&p_proid&"##([\:\w\;\=\>\.\r\n\-]+)\r\n")	
			for each app_item in split(dostring,vbcrlf)
				if app_item<>"" then
					apptitle=left(app_item,instr(app_item,"=>")-1)
					appcontent=mid(app_item,instr(app_item,"=>")+2)
					set appObj_=server.CreateObject("Scripting.Dictionary")	
					set appObj.item(apptitle)=appObj_
						if jsondb="" then
						jsondb=""""&apptitle&""":"""&appcontent&""""
						else
						jsondb=jsondb&","""&apptitle&""":"""&appcontent&""""
						end if
					for each str_item in split(appcontent,";")
						if str_item<>"" then
							strarr=split(str_item,":")
							a=trim(strarr(0))
							a1=trim(strarr(1))
							a2=trim(strarr(2))
							a3=trim(strarr(3))
							a4=trim(strarr(4))
							b1=trim(strarr(5))
							b2=trim(strarr(6))
							b3=trim(strarr(7))
							b4=trim(strarr(8))
							c1=trim(strarr(9))
							c2=trim(strarr(10))
							c3=trim(strarr(11))
							c4=trim(strarr(12))	
							d1=trim(strarr(13))
							d2=trim(strarr(14))
							d3=trim(strarr(15))
							d4=trim(strarr(16))	


							e=	trim(strarr(17))	
							if e=0 or IsOldSeting(apptitle,a) then
								appObj(apptitle).item(a)=array(a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4,d1,d2,d3,d4)
							end if
						end if
					next
					set appObj_=nothing
				end if
			next
		else
			errstr="读取数据出错"
		end if	
	end sub
	public function IsOldSeting(byval apptitle_,byval appItem_)
		result=false
		if isupdate then
			select case lcase(apptitle_)
			case "cpu"
				result=(oldcpuhz=appItem_)
			case "ram"
				result=(oldramsize=appItem_)
			case "data"
				result=(olddata=appItem_)
			case "flux"
				result=(oldRoom=appItem_)
			end select			
		end if
		IsOldSeting=result
	end function
	
	public sub gethostinfo(byval hostid)
		set hrs=server.CreateObject("ADODB.Recordset")
		'sql="select * from HostRental where id="& hostid & " and u_name='"& user_name &"'"
			if isip(hostid) then
			sql="select * from HostRental where AllocateIP='"& hostid & "' and u_name='"& user_name &"'"
		else
			sql="select * from HostRental where id="& hostid & " and u_name='"& user_name &"'"
		end if
	
		 
		hrs.open sql,conn,1,1
		if not hrs.eof then		
			isupdate=true	
			oldserverip=hrs("allocateip")
			aid=hrs("id")
			oldhostid=aid
			oldCHOICE_OS=hrs("OS")
			oldcpuhz=hrs("cpu")			
			oldramsize=hrs("Memory")
			oldddos=hrs("ddos")
			oldosdata=hrs("osHardDisk")
			cc=hrs("cc")
			If Not isnumeric(cc&"") Then cc=0
			If Not IsNumeric(oldddos&"") Then oldddos=0
			If Not IsNumeric(oldosdata&"") Then oldosdata=30
			oldosdata=CLng(oldosdata)
			If oldosdata<30 Then oldosdata=30
			if isnumeric(oldramsize) then oldramsize=round(cdbl(oldramsize)/1024,2)
		 
			if oldramsize<1 then oldramsize="0"&oldramsize
			 
				 select case cstr(oldramsize)
				 case "0.5"
				 ram=1
				 case "1"
				 ram=2
				 case "2"
				 ram=3
				 case "3"
				 ram=4
				 case "4"
				 ram=5
				 case "6"
				 ram=6
				 case "8"
				 ram=7
				 case "12"
				 ram=8
				 case "16"
				 ram=9
				 case "32"
				 ram=10
				 case "64"
				 ram=11
				 end select
			olddata=hrs("harddisk")
			PayMethod=hrs("PayMethod")
			oldRoom=hrs("serverRoom")
			oldflux=hrs("flux")
			'sstate=hrs("sstate")
			oldhostStart=hrs("Start")
			oldservicetype=hrs("addedServer")
			oldaddServerPrice=hrs("addServerPrice")
			oldMoneyPerMonth=hrs("MoneyPerMonth")
			p_proid=hrs("p_proid")
			alreadypay=hrs("alreadypay")
			starttime=hrs("starttime")
		'	Maxwhiteline=trim(hrs("Maxwhiteline"))	
			RamdomPass=hrs("RamdomPass")
			preday=hrs("preday")

		'	h_oldprice=hrs("oldprice")
			paytype=hrs("buytest")
			MainBoard=hrs("MainBoard")
			disktype=hrs("disktype")
			prodtype=hrs("prodtype")
			snapadv=hrs("snapadv")
			If Not isnumeric(snapadv&"") Then snapadv=0
			if MainBoard&""<>"" then MainBoardStr="("& MainBoard &")"
			if paytype&""="" or not isnumeric(paytype) then paytype=0
			if h_oldprice&""="" then h_oldprice=0
			if RamdomPass&""="" then 
				RamdomPass=GetRndPWD()
				conn.execute("update hostrental set RamdomPass='" & RamdomPass  & "' where id="& hostid)
			end if
			if preday&""="" or not isnumeric(preday) then preday=0
			if oldflux&""="" then oldflux=0
			oldexpiredate=dateadd("d",preday,DateAdd("m",alreadypay,starttime))
			if instr(oldserverip,"123.71.")>0 then bldayArr=Array("7:0")
			setProid=p_proid
			'call setappdata()	
			oldcpu=getcpuindex(oldcpuhz) 
			oldram=getramindex(oldramsize)
			oldsnapadv=snapadv
		else
			errstr="没有找到这台服务器"
		end if
		hrs.close:set hrs=nothing
	end sub
	public function getcpulist(byref cpucount)
		result=""
		cpucount=appObj("cpu").count
		lw=40
		ml=cint((470-cpucount*lw)/(cdbl(cpucount)-1))
		jsq=1
		for each cpu_item in appObj("cpu")
			 tml=ml:ta="center"
			 if jsq=1 then tml=1:ta="left"
			 if jsq=cpucount then ta="right"
			 fontcolor=""
			 if oldcpuhz<>"" and oldcpuhz=cpu_item then fontcolor="color:red;font-weight:bold;background-color:#efefef"
			 result=result&"<div style=""float:left;margin:0;text-align:"& ta &";width:"& lw &"px;padding:0;margin-left:"&tml&"px;"& fontcolor &""">"&cpu_item&"核</div>" 
			jsq=jsq+1	 
		next
		getcpulist=result
	end function
	public function getcpuval(byval requestcpu)
		result=0
		cpuhzArr=appObj("cpu").Keys		
		for c_i=1 to appObj("cpu").count
			if trim(requestcpu)=trim(c_i) then 
				result=cpuhzArr(c_i-1)				
				exit for
			end if
		next
		getcpuval=result
	end function
	public function getcpuindex(byval requestcpuhz)
		result=0
		cpuhzArr=appObj("cpu").Keys	
		for c_i=1 to appObj("cpu").count
			if trim(requestcpuhz)=trim(cpuhzArr(c_i-1)) then 
				result=c_i			
				exit for
			end if
		next
		getcpuindex=result
	end function
	public function getramlist(byref ramcount)
		result=""
		ramcount=appObj("ram").count
		lw=40
		ml=cint((470-ramcount*lw)/(cdbl(ramcount)-1))
		jsq=1
		for each ram_item in appObj("ram")
		 tml=ml:ta="center"
		 if jsq=1 then tml=1:ta="left"
		 if jsq=ramcount then ta="right"
		 fontcolor=""
		 if oldramsize<>"" and trim(oldramsize)=trim(ram_item) then fontcolor="color:red;font-weight:bold;background-color:#efefef"
         result=result&"<div style=""float:left;margin:0;text-align:"& ta &";width:"& lw &"px;padding:0;margin-left:"&tml&"px;"& fontcolor &""">"&ram_item&"G</div>" 
		 jsq=jsq+1           
		next
		getramlist=result
	end function
	public function getramval(byval requestram)
		result=0
		ramsizeArr=appObj("ram").Keys
		for r_i=1 to appObj("ram").count
			if trim(r_i)=trim(requestram) then
				result=ramsizeArr(r_i-1)
				exit for
			end if
		next
		getramval=result
	end function
	public function getramindex(byval requestramsize)
		result=0
		ramsizeArr=appObj("ram").Keys
		for r_i=1 to appObj("ram").count	
			if cdbl(ramsizeArr(r_i-1))=cdbl(requestramsize) then
				result=r_i
				exit for
			end if
		next
		getramindex=result
	end function
	public function IsAllowbuytest(byref errstr_)'试用主机限制
		result=true
			
		'2013/7/18  检查操作系统内存是否足够
		select  case trim(CHOICE_OS)
				case "win_64","win","win_clean":
					if ramsize*1024<1024 then
					errstr_="提示：您选择的操作系统最少需要1G内存！请增加内存或更换为其他操作系统！"
					result=false		
					end if
				case "win_2005","win_2008":
					if ramsize*1024<2048 then
					errstr_="提示：您选择的操作系统最少需要2G内存！请增加内存或更换为其他操作系统！"
					result=false		
					end if
				case "win_2008_64","win_2012_clean":
					if ramsize*1024<3072 then
					errstr_="提示：您选择的操作系统最少需要3G内存！请增加内存或更换为其他操作系统！"
					result=false	
					end if
		        case "":
					errstr_="选择操作系统有误"
					result=false	
		 end select
		IsAllowbuytest=result
	end function
	public function buysub(byval dotype) 
		PricMoney=getprice(dotype) 
		if not IsAllowbuytest(errstr_) then errstr=errstr_:exit function
		if VPSOpen then	 
		strContents=""
			while buycount>0
				buyordersub()	
				if errstr<>"" then exit function
				strContents=""
				strContents =strContents&"server" & vbCrLf & "add" & vbCrLf & _
							 "entityname:server" & vbCrLf & _
							 "producttype:diyserver" & vbCrlf & _
							 "p_proid:" & p_proid  & vbCrLf & _
							 "hostid:" & p_proid & vbCrLf & _
							 "prodtype:" & prodtype & vbCrLf & _
							 "choice_os:" & CHOICE_OS & vbCrLf & _
							 "apply:"& Apply & vbCrLf & _
							 "cpuhz:"& cpuhz & vbCrLf & _
							 "cpu:"& cpu & vbCrLf & _
							 "osdata:"& osdata & vbCrLf & _
							 "data:"& data & vbCrLf & _
							 "ramsize:"& ramsize & vbCrLf & _
							 "ram:"& ram & vbCrLf & _
							 "flux:"& flux & vbCrLf & _
							 "paymethod:" & PayMethod & vbCrLf & _
							 "renewtime:" & renewTime & vbcrlf & _
							 "years:"& 1 & vbCrLf & _
							 "room:"& room & vbCrLf & _
							 "disktype:"& disktype & vbCrLf & _
							 "paytype:"& paytype & vbCrLf & _
							 "isvps:" & 1 & vbCrLf & _
							 "servicetype:"& servicetype & vbCrLf & _
							 "addserverprice:"& addServerPrice & vbCrLf & _
							 "mainboard:"&  vbCrLf & _
							 "pricmoney:" & PricMoney  & vbCrLf & _
							 "isnewtype:true" & vbCrLf & _
							 "ddos:"& ddos & vbCrLf & _
							 "aid:" & aid  & vbCrLf & _
							 "memo:"& memo & vbcrlf & _	
							 "snapadv:"& snapadv & vbcrlf & _	
							 "cc:"& cc & vbcrlf & _	
							 "." & vbCrLf
							 
							 
							 							' "name:" & name & vbCrLf & _
'							 "u_trade:"& trade & vbCrLf & _
'							 "company:"& Company & vbCrLf & _
'							 "telephone:" & telphone & vbCrLf & _
'							 "address:" & address & vbCrLf & _
'							 "zip:" & zipcode & vbCrLf & _
'							 "email:"& email & vbCrLf & _
'							 "qq:"& qq & vbCrLf & _
'							 "fax:"& mobile & vbCrLf & _
							 
				'call openvpslog("------------开通--------"& user_name & vbcrlf & strContents)
			'	call doOrderlist(strContents,"")	
			    buycount=buycount-1
			    ywtype="server"
				ywname=p_proid
				call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)
			wend 		 

			
		
			'session("order") =  strContents & session("order")
			conn.close
		'	die session("order")
			Response.redirect "/bagshow/"
			response.end
		else		
			buyordersub()	
			if errstr<>"" then exit function	
			session("order_id")="server"& vbcrlf & aid
			Response.redirect "/bagshow/orderlist.asp"
			response.end	
		end if		
	end function
	public function setParam(byval pay_Item)
		if pay_item="" then exit function
		'call openvpslog("**********setparam****"&user_name & vbcrlf & pay_Item)
		mustinput="p_proid,Company,Name,u_trade,Telephone,Email,QQ,Fax,Zip,Address,HostID,cpuhz,cpu,data,ramsize,ram,flux,Years,Memo,CHOICE_OS,checkStup,servicetype,PayMethod,renewtime,Room,Apply,MainBoard,isvps,isnewtype,aid,paytype,disktype,ddos,osdata,prodtype,snapadv,cc"
		for each input_item in split(mustinput,",")
			input_item=trim(input_item)
			if input_item<>"" then
			input_item_title=input_item
			'response.Write(input_item&"=======")
				input_val=Trim(getstrReturn(pay_Item&vbCrLf,input_item))
			'response.Write(input_item&"<BR>")	
		' response.Write(input_item&"="&input_val&"<BR>")
				if input_item_title<>"" And checkRegExp(input_item_title,"^[\w]+$") then
					execute input_item_title &"=input_val"
				end if
			end if
		next
		if paytype&""="" or not isnumeric(paytype) then paytype=0
		If Not isnumeric(ddos&"") then ddos=0 
		If Not isnumeric(prodtype&"") then prodtype=0 
		If Not isnumeric(osdata&"") then osdata=30
		If Not isnumeric(snapadv&"") Then snapadv=0
		If Not isnumeric(cc&"") Then cc=0
	end function
	

	public function chgroom_chgwhitelist(byval ipaddr,byval roomid)
		ismodrr__=false
		roomsql="select top 1 * from serverRoomlist where r_typecode='"& roomid & "'"
		set roomRs=conn.execute(roomsql)
		if not roomRs.eof then
			ismodrr__=roomRs("ismodrr")
		end if
		roomRs.close
		set roomRs=nothing
					
		set wrs=server.CreateObject("ADODB.Recordset")
		set wrs1=server.CreateObject("ADODB.Recordset")
		Set objtem=CreateObject("WEST263DNS.ACT")						
		conn11.open connstrICP
		wsql="select * from whitelist where serverip='"& ipaddr &"'"
		wrs.open wsql,conn11,1,1
		do while not wrs.eof
			wstrdomain=wrs("strdomain")
			if ismodrr__ then
				call objtem.ModRR(true,true,cstr(wstrdomain),"A",cstr(ipaddr))'作内部解析
			else
				call objtem.DelRR(true,true,cstr(wstrdomain),"A")				
			end if
		wrs.movenext
		loop
		wrs.close:set wrs=nothing
		Set objtem=nothing			
	end function
	public function checkchgroom()
		'ip包含：211.149.的，　目标线路不允许设置为：　电线线路Ｂ。
		'若目标线路为　电信线路　的，　ＩＰ地址必须包含：　２１１.１４９
		result=true
		if paytype=1 then
			errstr="抱歉，试用主机不允许更换线路，请转正后再进行该操作"
			result=false
		elseif newroom=15 and instr(oldserverip,"211.149.")>0 then
			errstr="抱歉，不能更换为该线路！"
			result=false
		elseif newroom=38 and instr(oldserverip,"211.149.")=0 then
			errstr="抱歉，不能更换为该线路！"
			result=false
		end if
		checkchgroom=result
	end function
	public function chgroomSub()
		result=false
		if newroom<>oldroom then
			if not checkchgroom() then exit function
			PricMoney=ds.getchgroomprice()
			if ccur(u_usemoney)>=ccur(PricMoney) then
				oldroomname_=formatroomname(getroomname(oldroom))
				newroomname_=formatroomname(getroomname(newroom))
				set crrs=server.CreateObject("ADODB.Recordset")
				sql="select * from HostRental where u_name='"& user_name &"' and id="&aid
				crrs.open sql,conn,1,3
				if not crrs.eof then
					vpsip=crrs("AllocateIP")
					markinfo="云主机换线路:" & vpsIP &" "& oldroomname_ &"->"& newroomname_
					countid="ebs-" & left(user_name,3) & Left(Cstr(Clng(rnd()*100000)) & "00000",6)	
					if comsume(user_name,countid,PricMoney,markinfo&countstrs)=0 Then
							crrs("MoneyPerMonth")=MoneyPerMonth
							crrs("serverRoom")=newroom
							crrs.update()
							conn.Execute("insert into ServerActiolog(ServerId,ServerIP,u_name,ActionDate,Content) values (" & aid & ",'" & vpsip & "','" & user_name & "',getdate(),'用户自主换线路 "& oldroomname_ &"->"& newroomname_ &"')")
						call setServerfreedomain(aid)
						call chgroom_chgwhitelist(vpsip,newroom)
						result=true
					else
						errstr="扣款失败"
					end if
				else
					errstr="没有找到该主机"
				end if
				crrs.close:set crrs=nothing
			else
				errstr="余额不足"
			end if
		else
			errstr="您还没有选择新机房"
		end if
		chgroomSub=result
	end function
	public function dopaytest()
		dopaytest=false
		if paytype=0 then errstr="该主机是正式主机不允许再次转正":exit function
		if aid&""="" then errstr="开通失败,请重试":exit function
		PricMoney=getpaytestprice()
		proprice_=PricMoney
	  
		if not isPaymentAllow(PricMoney,errstr) then exit function

		if ccur(u_usemoney)>=ccur(PricMoney) then
			countlistkey="ebs":paytitlestr="转正"
			markinfo=countlistkey&paytitlestr & oldserverip & ",已支付"&PricMoney&"元"
			if deposit="yesneed" then
				markinfo=markinfo & ",有押金"
			else
				markinfo=markinfo & ",无押金"
			end if
 			
strContents ="server"& vbCrLf&_
             "paytest" & vbCrLf&_
			"entityname:serverdiy"& vbCrLf&_
			"serverip:"&oldserverip& vbCrLf&_
			 "servicetype:"& servicetype & vbCrLf & _
			 "addserverprice:"& addServerPrice & vbCrLf & _
			 "paymethod:" & PayMethod & vbCrLf & _
			 "renewtime:" & renewTime & vbcrlf & _
			 "pricmoney:"&PricMoney& vbCrLf&_
			 "aid:"&aid& vbCrLf&_
			"."& vbCrLf

	 
			'die PricMoney&"|"&proprice_&"||"&u_usemoney&"==="&PricMoney&"\r\n"&strContents
            
  			'return=PCommand(strContents,user_name)
			return=connectToUp(strContents)
			'die return
 			 if left(return&"",3)=200 then
 			randomize(timer())
 			countid=countlistkey&"-" & left(user_name,3) & Left(Cstr(Clng(rnd()*100000)) & "00000",6)	
  			if consume(user_name,PricMoney,false,countid,markinfo&countstrsds,p_proid,"") Then
 				sqlr="update HostRental set Start=1,MoneyPerMonth="& MoneyPerMonth &",AlreadyPay="& monthnum &",StartTime='"& now() &"',addedServer='"& servicetype &"',addServerPrice="& addServerPrice &",buytest=0,u_name='"& user_name &"' where id="& aid &""
 				conn.execute sqlr
 				dopaytest=true
			else
				errstr="扣款失败"
			end if
            else
			errstr=return
            end if
		else
			errstr="余额不足"
 		end if
 	end function

	

	public function upgrade()

	
		upgrade=0
		setpassword=RamdomPass
		differentstr=getdifferent()
		
		if not upgradecheck() then 
		upgrade=errstr
		exit function		
		end if
		needMoney=getupprice("new")
		strCmd=upToManager(needMoney)
		'die "aa"&strCmd
		proprice_=needMoney
		
	 
		if ccur(u_usemoney)>=ccur(needMoney) then
			return=connectToUp(strCmd)
			
			if left(return&"",3)=200 then
 			randomize(timer())
			markinfo=countlistkey&"升级:"& oldserverip &"->"& vpsIP &";"& differentstr & countstrs
 			countid=countlistkey&"-" & left(user_name,3) & Left(Cstr(Clng(rnd()*100000)) & "00000",6)	
					if consume(user_name,needMoney,false,countid,markinfo&countstrsds,p_proid,"") Then
						sql="select * from HostRental where id="& oldhostid
								rs11.open sql,conn,1,3
								if not rs11.eof then
									sendEmail=rs11("Email")
									sendMobile=rs11("fax")							
									'rs11("AllocateIP")=vpsIP
									rs11("MoneyPerMonth")=MoneyPerMonth
									rs11("cpu")=cpuhz					
									rs11("flux")=flux
									rs11("HardDisk")=data
									rs11("osHardDisk")=osdata
									rs11("Memory")=ramsize*1024
									'rs11("oldprice")=proprice_							
									rs11.update()							
								end if
								rs11.close
						return="200 ok"	
					else
						return="500 扣款失败"
					end if
         
            end if
		else
			return="500 余额不足"        
		end if

		upgrade=return
 	end function	
	

public function upToManager(byval needMoney)
		upToManager=false	
		proprice_=needMoney
		if cdbl(olddata)<=cdbl(data) then
				strmgrip=oldserverip                 '得到主IP	
				'处理申请程序远程序发送
					strContents ="server" & vbCrLf & "set" & vbCrLf & _
							 "entityname:upserverdiy" & vbCrLf & _
							 "serverip:"&oldserverip & vbCrlf & _
							 "p_proid:" & p_proid  & vbCrLf & _
							 "cpuhz:"& cpuhz & vbCrLf & _
							 "cpu:"& cpu & vbCrLf & _
							 "data:"& data & vbCrLf & _
							 "osdata:"& osdata & vbCrLf & _
							 "ramsize:"& ramsize & vbCrLf & _
							 "ram:"& ram & vbCrLf & _
							 "flux:"& flux & vbCrLf & _
							 "pricmoney:" & proprice_  & vbCrLf & _
							 "aid:" & aid  & vbCrLf & _
							 "memo:"& memo & vbcrlf & _						 
							 "." & vbCrLf
				upToManager=strContents
		else
			errstr="磁盘只能增加不能减小"
		end if
		 
	end function

	public function setfluxsize(byval pserverip,byval serverip,byval fluxsize)
  	  PHPURL="http://"& pserverip &"/myact.asp?act=1023&para1="& serverip &"&para2="&fluxsize
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 20000, 20000, 20000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  setfluxsize=retCode
	end function
	public function AddChgRoomRR_new(byval shost,byval dhost,byval opttimeday)
		Set task_conn=CreateObject("Adodb.connection")
		Set task_rs=CreateObject("ADODB.Recordset")
		task_conn.open connstrtask
		sql="select * from vps_task_chgroom"
		task_rs.open sql,task_conn,1,3
		task_rs.addnew()
		task_rs("shost")=shost
		task_rs("dhost")=dhost
		task_rs("opttime")=getblDate(opttimeday)
		task_rs.update()		
		task_rs.close:set task_rs=nothing
		task_conn.close:set task_conn=nothing
	end function
	public function getdifferent()
		result=""
		set newmsgObj=server.CreateObject("Scripting.Dictionary")	
		set oldmsgObj=server.CreateObject("Scripting.Dictionary")
		newmsgObj.item("CPU")=cpuhz
		newmsgObj.item("内存")=ramsize
		newmsgObj.item("带宽")=flux
		newmsgObj.item("空间")=data
		newmsgObj.item("DDoS")=ddos

		oldmsgObj.item("CPU")=oldcpuhz
		oldmsgObj.item("内存")=oldramsize
		oldmsgObj.item("带宽")=oldflux
		oldmsgObj.item("空间")=olddata
		newmsgObj.item("DDoS")=oldddos

		for each newmsg_item in newmsgObj
			newmsg=trim(newmsgObj(newmsg_item))
			oldmsg=trim(oldmsgObj(newmsg_item))
			if newmsg<>oldmsg then
				result=result&newmsg_item&":"& oldmsg &"->"& newmsg &";"
			end if
		next
		if result<>"" and right(result,1)=";" then result=left(result,len(result)-1)
		getdifferent=result
		set newmsgObj=nothing:set oldmsgObj=nothing
	end function
	
	private function resouceEnough(byval strmgrip,byref meminc,byref diskinc)
		r_memo=5000'空闲内存至少保留3G
		r_disk=30  '空闲磁盘至少30G
		resouceEnough=false
		meminc=ramsize-oldramsize
		diskinc=data-olddata		
		ava_mem=getFreeMemory(strmgrip)
		ava_disk=(getFreeSpace(strmgrip)/1024)		
		if ava_mem>0 and ava_disk>0 then
			if (ava_mem-meminc)>=r_memo and (ava_disk-diskinc)>=r_disk then
				resouceEnough=true
			end if
		
		end if
	end function
	 
 
	public function upgradecheck()
		upgradecheck=false
		if cpu="" or ram="" or flux="" or data="" then errstr="参数有错!":exit function
		if differentstr="" then  errstr="您还没有作过任何变更,不能进行升级":exit function
		if sstate=2 then errstr="状态是停止，不能转移 ，请先开机":exit function		
		if paytype=1 then errstr="试用主机不用升级，请先转正":exit function
		upgradecheck=true
	end function
 
	Function addvcprecord(cid,proid,uprice,years,content)
		dim LocalCmd
		Set LocalCmd=CreateObject("Adodb.Command")
		LocalCmd.ActiveConnection=conn
		LocalCmd.CommandType=adCmdStoredProc
		LocalCmd.CommandText="c_mode_addvcprecord"

		LocalCmd.parameters.append cmd.createParameter("cid",adInteger,adParamInput,4,cid)
		LocalCmd.parameters.append cmd.createParameter("proid",adVarChar,adParamInput,50,proid)
		LocalCmd.parameters.append cmd.createParameter("uprice",adInteger,adParamInput,4,uprice)
		LocalCmd.parameters.append cmd.createParameter("years",adInteger,adParamInput,4,years)
		LocalCmd.parameters.append cmd.createParameter("content",adVarChar,adParamInput,50,content)

		LocalCmd.execute
		Set LocalCmd=nothing
	end Function
	
	
	
	'入库并返回id
	public function buyordersub()
    '暂时缓存用户资料
	session("userinfo")="{""u_namecn"":"""&name&""",""u_company"":"""&company&""",""u_telphone"":"""&telphone&""",""u_email"":"""&email&""",""u_address"":"""&address&""",""u_fax"":"""&mobile&""",""u_trade"":"""&trade&""",""u_mobile"":"""&mobile&""",""qq_msg"":"""&qq&""",""u_zipcode"":"""&zipcode&"""};"
		if trim(user_name)&""="" then errstr="用户名信息丢失！请重登陆":exit function
		session("userinfo")=""
			Sql="Insert into HostRental (Name,u_trade,Company,Telephone,Address,Zip,Email,QQ,Fax,HostID,OS,Apply,CPU,HardDisk,Memory,PayMethod,Years,serverRoom,[Memo],SubmitTime,Start,Alert,MoneyPerMonth,AlreadyPay,UserIP,u_name,hosttype,addedServer,addServerPrice,MainBoard,p_proid,cdntype,invoiceset,flux,buytest,disktype,ddos,osHardDisk,prodtype,snapadv,cc)" & _
	 	" Values ('" & Name & "','"&trade&"','" & Company & "','" & Telephone & "','" & address & "','" & zipcode & "','" & email &"','" & qq & "9','" & mobile &"','" & p_proid &"','" & CHOICE_OS &"','" & Apply &"','" & _
		 cpuhz &"','" & data & "','" & (cdbl(ramsize)*1024) &"',"  & PayMethod & ",1,'"& room &"','" & trim(Memo) &"',"&PE_Now&",0,0,0,0,'" & UserIP & "','" & user_name & "',1,'"&servicetype&"','"&addServerPrice&"','','"& p_proid &"',0,0,'"& flux &"','"& paytype &"','"&disktype&"','"&ddos&"','"& osdata &"','"& prodtype &"','"&snapadv&"','"&cc&"')" 
		 'die sql
		conn.execute(sql)
		sql="select top 1 id from HostRental where Name='"& Name &"' and u_name='"& user_name &"' order by id desc"
		rs.open sql,conn,1,1
			aid=rs(0)
		rs.close
	end function
	
	
	
	
	public function getUpprice(byval dotype)'升级价格计算
		newcpu=cpu
		newram=ram
		newdata=data
		newflux=flux
		newCHOICE_OS=CHOICE_OS
		newroom=room
		newservicetype=servicetype
	    
		if appObj("flux").exists(oldroom) then
		   	cpu=oldcpu
			ram=oldram
			data=olddata
			flux=oldflux
			CHOICE_OS=oldCHOICE_OS
			room=oldroom
			servicetype=oldservicetype		
			call getprice(dotype)'老价
			oldprice=MoneyPerMonth
		else
			oldprice=oldMoneyPerMonth
		end if
		
		cpu=newcpu
		ram=newram
		data=newdata
		flux=newflux
		CHOICE_OS=oldCHOICE_OS
		room=oldroom
		servicetype=oldservicetype
	 
		call getprice(dotype)'新价	
		newprice=MoneyPerMonth	
		 
		''''''''''''''''''''''''''''''''''
		blprice=0:if newRoom<>oldroom then blprice=getbldayPrice(bldayArr,blday)
		start_day=dateadd("m",monthnum-monthnum*2,oldexpiredate)'开始时间
		all_day=30'总天数
		leavings_day=datediff("d",date,oldexpiredate)+1'未使用天数
		if leavings_day<=0 then leavings_day=1
		money_daycj=(cdbl(newprice)-cdbl(oldprice))/all_day'每天差价
		if money_daycj<0 then money_daycj=0
		uppriceall=round(money_daycj*leavings_day)
		if uppriceall>30 then souxvfei=0
		getUpprice=uppriceall + blprice
		if getUpprice<0 then getUpprice=0		
		getUpprice=formatNumber(getUpprice+souxvfei,0,-1,-1,-1)
		
	end function
	public function getOrderpayPrice()
		cpu=oldcpu
		ram=oldram
		data=olddata
		flux=oldflux
		CHOICE_OS=oldCHOICE_OS
		room=oldroom
		servicetype=newservicetype
		PayMethod=newPayMethod
		renewTime=newrenewTime
		getOrderpayPrice=getprice("new")
	end function
	public function getpaytestprice()
		cpu=oldcpu
		ram=oldram
		data=olddata
		flux=oldflux
		ddos=oldddos
		CHOICE_OS=oldCHOICE_OS
		room=oldroom
		servicetype=newservicetype
		PayMethod=newPayMethod
		renewTime=newrenewTime	
		paytype=0	
		getpaytestprice=getprice("new")
	end function
	public function getchgroomprice()
		cpu=oldcpu
		ram=oldram
		data=olddata
		flux=oldflux
		CHOICE_OS=oldCHOICE_OS
		servicetype=oldservicetype	
		room=oldroom
		oldchgroomprice=getprice("renew")
		room=newroom		
		newchgroomprice=getprice("renew")
		thisprice=cdbl(newchgroomprice)-cdbl(oldchgroomprice)
		if thisprice<0 then thisprice=0
		getchgroomprice=thisprice+chgroomSxfei
	end function
	public function getRenewprice()
		cpu=oldcpu
		ram=oldram
		data=olddata
		flux=oldflux
		ddos=oldddos
		CHOICE_OS=oldCHOICE_OS
		room=oldroom
		servicetype=oldservicetype		
		
	'	 die oldcpu&"|"&oldram&"|"&olddata&"|"&oldflux&"|"&oldCHOICE_OS&"|"&oldroom&"|"&oldservicetype

		
		getRenewprice=getprice("renew")
	end Function
	
	Function getbuyyesrdis(ByVal m)
		If Not isnumeric(m&"") Then Exit function
		If clng(m)=6Then 
			diy_buy_time_dis=ccur(diy_dis_6)
		ElseIf clng(m)=12 Then 
			diy_buy_time_dis=ccur(diy_dis_12)
		ElseIf clng(m)=24 Then
			diy_buy_time_dis=ccur(diy_dis_24)
		ElseIf clng(m)=36 Then
			diy_buy_time_dis=ccur(diy_dis_36) 
		ElseIF clng(m)=60 Then			
			diy_buy_time_dis=ccur(diy_dis_60)
		End if
	End Function
	
	public function getprice(byval dotype)
		result=99999
		if renewTime&""="" or not isnumeric(renewTime) then renewTime=1
		monthnum=getpaymonthnum(PayMethod)	
		Call getbuyyesrdis(monthnum*renewTime)
		call getfirstprice()'得到项目设置价	
		addServerPrice=getOtherPrice(servicetype) * monthnum  
		
		realPrice=cdbl(cpu_price) + cdbl(ram_price) + cdbl(flux_price) + cdbl(data_price) + cdbl(addServerPrice)+CDbl(ddos_price)
		if dotype="new" and  clng(PayMethod)=0 and cdbl(diyfist)<>1 then
		paymoney=realPrice*diyfist '计算折扣后的价
		else
		paymoney=getNeedVPSprice_diy(user_name,realPrice) '计算折扣后的价
		end if
		
		if 	PayMethod&""="1" then    '
			MoneyPerMonth=round(paymoney/10)
		else
			MoneyPerMonth=round(paymoney/monthnum)
		end if
		fullprice=round(cdbl(realPrice) * cdbl(renewTime) * CDbl(diy_buy_time_dis),2)
		if paytype=1 then
			result=paytestPrice
			monthnum=0
		else
			result=round(cdbl(paymoney) * cdbl(renewTime) * CDbl(diy_buy_time_dis),2)'vps价格*购买时间+总月份*服务价格
		end If
		
		If dotype="renew" Then 'otherip
			iparr=getOtherips(oldserverip) 
			ipprice=0
			For Each k In iparr
				ipprice=ccur(ipprice)+k("price")*monthnum
			next
			result=ccur(result)+ccur(ipprice)
		End if
		If snapadv>0 Then result=result+snapadvprice*monthnum
		If cc>0 Then result=ccur(result)+ccur(getbuyccprice(dotype))*monthnum 
		getprice=formatNumber(result,0,-1,-1,-1)
	end function
	
	function getfirstprice() 
		If prodtype=1 Then 
			cpuvalArr=appObj("hcpu").items 
		else
			cpuvalArr=appObj("cpu").items 
		End if
		ramvalArr=appObj("ram").items
		If prodtype=2 Then 
			datavalArr=appObj("hdata").items:datakeyArr=appObj("hdata").keys
		Else
			datavalArr=appObj("data").items:datakeyArr=appObj("data").keys
		End if
		cpuprice=cpuvalArr(cpu-1)(0)
		cpujiprice=cpuvalArr(cpu-1)(1)
		cpubanprice=cpuvalArr(cpu-1)(2)
		cpuyearprice=cpuvalArr(cpu-1)(3)
		cpu_price=getrealprice(cpuprice,cpujiprice,cpubanprice,cpuyearprice,monthnum)

		ramprice=ramvalArr(ram-1)(0)
		ramjiprice=ramvalArr(ram-1)(1)
		rambanprice=ramvalArr(ram-1)(2)
		ramyearprice=ramvalArr(ram-1)(3)
		ram_price=getrealprice(ramprice,ramjiprice,rambanprice,ramyearprice,monthnum)
		

		'高防流量大小价格
		ddosprice=0
		ddosjiprice=0
		ddosbanprice=0
		ddosyearprice=0
		ddos_price=0
		If ddos>0 Then  '只要大于0就检查
			room_ddos=room&"_"&ddos
			
			If appObj("ddos").Exists(room_ddos) Then 
				ddosprice=cdbl(appObj("ddos")(room_ddos)(0))
				ddosjiprice=cdbl(appObj("ddos")(room_ddos)(1))
				ddosbanprice=cdbl(appObj("ddos")(room_ddos)(2))
				ddosyearprice=cdbl(appObj("ddos")(room_ddos)(3))
			Else
				ddos=0
			End If		
		 ddos_price=getrealprice(ddosprice,ddosjiprice,ddosbanprice,ddosyearprice,monthnum)
		End If
		
		 


	
		
		fluxprice=cdbl(appObj("flux")(room)(0)):if fluxprice=0 then fluxprice=99999
		fluxjiprice=cdbl(appObj("flux")(room)(1)):if fluxjiprice=0 then fluxjiprice=fluxprice * 3
		fluxbanprice=cdbl(appObj("flux")(room)(2)):if fluxbanprice=0 then fluxbanprice=fluxprice * 6
		fluxyearprice=cdbl(appObj("flux")(room)(3)):if fluxyearprice=0 then fluxyearprice=fluxprice * 12
		
		fluxminprice=cdbl(appObj("flux")(room)(4)):if fluxminprice=0 then fluxminprice=fluxprice
		fluxminjiprice=cdbl(appObj("flux")(room)(5)):if fluxminjiprice=0 then fluxminjiprice=fluxminprice*3
		fluxminbanprice=cdbl(appObj("flux")(room)(6)):if fluxminbanprice=0 then fluxminbanprice=fluxminprice*6
		fluxminyearprice=cdbl(appObj("flux")(room)(7)):if fluxminyearprice=0 then fluxminyearprice=fluxminprice*12
		
		fluxmaxprice=cdbl(appObj("flux")(room)(8)):if fluxmaxprice=0 then fluxmaxprice=fluxminprice
		fluxmaxjiprice=cdbl(appObj("flux")(room)(9)):if fluxmaxjiprice=0 then fluxmaxjiprice=fluxmaxprice * 3
		fluxmaxbanprice=cdbl(appObj("flux")(room)(10)):if fluxmaxbanprice=0 then fluxmaxbanprice=fluxmaxprice * 6
		fluxmaxyearprice=cdbl(appObj("flux")(room)(11)):if fluxmaxyearprice=0 then fluxmaxyearprice=fluxmaxprice * 12

		
		fluxmax1price=cdbl(appObj("flux")(room)(12)):if fluxmax1price=0 then fluxmax1price=fluxmaxprice
		fluxmax1jiprice=cdbl(appObj("flux")(room)(13)):if fluxmax1jiprice=0 then fluxmax1jiprice=fluxmax1price * 3
		fluxmax1banprice=cdbl(appObj("flux")(room)(14)):if fluxmax1banprice=0 then fluxmax1banprice=fluxmax1price * 6
		fluxmax1yearprice=cdbl(appObj("flux")(room)(15)):if fluxmax1yearprice=0 then fluxmax1yearprice=fluxmax1price * 12


		
		'挖矿主机*1.5
		if room=41 then
		'cpu_price=cpu_price*1.5
		end if
		
		if flux<0  then flux=1
		if flux<=5 then
			fluxprice_=fluxminprice + fluxprice * (flux)
			fluxjiprice_=fluxminjiprice + fluxjiprice * (flux)
			fluxbanprice_=fluxminbanprice + fluxbanprice * (flux)
			fluxyearprice_=fluxminyearprice + fluxyearprice * (flux)
		elseif flux>5  and flux<=10 then
			fluxprice_=fluxminprice + fluxprice * 5 + fluxmaxprice * (flux-5)
			fluxjiprice_=fluxminjiprice + fluxjiprice *  5 + fluxmaxjiprice * (flux-5)
			fluxbanprice_=fluxminbanprice + fluxbanprice * 5 + fluxmaxbanprice * (flux-5)
			fluxyearprice_=fluxminyearprice + fluxyearprice * 5 + fluxmaxyearprice * (flux-5)
		Else 
			fluxprice_=fluxminprice + fluxprice * 5 + fluxmaxprice *5 + fluxmax1price * (flux-10)
			fluxjiprice_=fluxminjiprice + fluxjiprice *  5 + fluxmaxjiprice * 5 + fluxmax1jiprice * (flux-10)
			fluxbanprice_=fluxminbanprice + fluxbanprice * 5 + fluxmaxbanprice *5 + fluxmax1banprice * (flux-10)
			fluxyearprice_=fluxminyearprice + fluxyearprice * 5 + fluxmaxyearprice *5 + fluxmax1yearprice * (flux-10) 
		end if		
		flux_price=getrealprice(fluxprice_,fluxjiprice_,fluxbanprice_,fluxyearprice_,monthnum)	
'		die fluxminyearprice&"==>"&fluxyearprice&"==>"&fluxmaxyearprice&"==>"&fluxmax1yearprice
'		die fluxprice_&"==>"&fluxjiprice_&"==>"&fluxbanprice_&"==>"&fluxyearprice_&"==>"&monthnum
'	 	die flux&"==>"&fluxminprice&"==>"&fluxprice&"==>"&fluxmaxprice&"==>"&fluxmax1price&"==>"&fluxmax1jiprice&"==>"&fluxmax1banprice&"==>"&fluxmax1yearprice&"==>"&flux_price
	 
		if data>50  then
			if data>2000 then
				dataprice=cdbl(datavalArr(0)(0)) * ((data-50)/datakeyArr(0))*1.5
				datajiprice=cdbl(datavalArr(0)(1)) * ((data-50)/datakeyArr(0))*1.5
				databanprice=cdbl(datavalArr(0)(2)) * ((data-50)/datakeyArr(0))*1.5
				datayearprice=cdbl(datavalArr(0)(3)) * ((data-50)/datakeyArr(0))*1.5
			else
				dataprice=cdbl(datavalArr(0)(0)) * ((data-50)/datakeyArr(0))
				datajiprice=cdbl(datavalArr(0)(1)) * ((data-50)/datakeyArr(0))
				databanprice=cdbl(datavalArr(0)(2)) * ((data-50)/datakeyArr(0))
				datayearprice=cdbl(datavalArr(0)(3)) * ((data-50)/datakeyArr(0))
			end if
			data_price=getrealprice(dataprice,datajiprice,databanprice,datayearprice,monthnum)
		else
			data_price=0
		end if
		
		if disktype="ssd" then 
			data_price=data_price * 2
			if monthnum=12 then
				data_price=data_price+100
			else
				data_price=data_price+10 * monthnum
			end if
		end if
	'	die data_price&"<BR>"&cpu_price&"<BR>"&ram_price&"<BR>"&flux_price
	end function
	function getrealprice(byval price,byval jiprice,byval banprice,byval yearprice,byval monthnum_)
		result=0
		If price="" then price=99999
		select case monthnum_
		case 1
			result=cdbl(price)
		case 3
			result=cdbl(jiprice)
		case 6
			result=cdbl(banprice)
		case 12
			result=cdbl(yearprice)
		case else
			result=cdbl(price) * cdbl(monthnum_)
		end select
		if result="" or result=0 then
			result=cdbl(price) * cdbl(monthnum_)
		end if
		getrealprice=result
	end function
	
	'返回用户等级折扣.
	function getNeedVPSprice_diy(byval CustomerName,byval pay_Price)
	   '计算价格稍等,从配置信息返回
	   getNeedVPSprice_diy=99999999
	   
	   '获取用户等级
	   if CustomerName<>"" then
	      set u_l_rs=conn.execute("select top 1 u_level from UserDetail where u_name='"&CustomerName&"'")
			  if not u_l_rs.eof then
			  leveid=u_l_rs(0)
			  else
			  leveid=1
			  end if
			  u_l_rs.close
			  set u_l_rs=nothing
	   else
	   leveid=1
	   end if
	   
	   
	   'leveid=session("u_levelid")
	  leveid=u_levelid
	   if trim(leveid)="" then leveid=1
	   
	   
	   
	   
	   select case clng(leveid)
	   case 1
	   getNeedVPSprice_diy=diyuserlev1*pay_Price
	   case 2
	    getNeedVPSprice_diy=diyuserlev2*pay_Price
	   case 3
	    getNeedVPSprice_diy=diyuserlev3*pay_Price
	   case 4
	    getNeedVPSprice_diy=diyuserlev4*pay_Price
	   case 5
	    getNeedVPSprice_diy=diyuserlev5*pay_Price
	   end select

	   
	   
	   
	   
	   
	   
	   
	   
	   
	end function
	public function getpaymonthnum(byval payMethod)
	     
		select case payMethod
		case "0"
			getpaymonthnum=1
		case "2"
			getpaymonthnum=3
		case "3"
			getpaymonthnum=6
		case "1"
			getpaymonthnum=12
		case "4"
			getpaymonthnum=24
		end select
	end Function
	private function getOtherPrice(byval servicetype)
		result=0
		select case right(servicetype,4)
			case "基础服务"
				result=0
			case "铜牌服务"
				result=68
			case "银牌服务"
				result=98
			case "金牌服务"
				result=188
		end select 		
		getOtherPrice=result
	end function
	public function getdiyserverapp()
'		appstrings=trim(getapplication_txt("diyserverprice"))&""
		'appstrings=trim(GetRemoteUrl("http://api.west263.com/config/Application/application_diyserverprice.txt"))
        set dsjson=parseJSON(returnJson())
		appstrings="ebscloud##cpu=>"&dsjson.cpu& vbCrlf & _
		           "ram=>"&dsjson.ram& vbCrlf & _
				   "flux=>"&dsjson.flux& vbCrlf & _
				   "data=>"&dsjson.data& vbCrlf & _
				   "ddos=>"&dsjson.ddos& vbCrlf& _
				   "hcpu=>"&dsjson.hcpu& vbCrlf& _
				   "hdata=>"&dsjson.hdata& vbCrlf
	
		free_cc_roomids=dsjson.free_cc_roomids
	    allow_cc_roomids=dsjson.allow_cc_roomids
		set dsjson=nothing
				   
		
	   getdiyserverapp=appstrings	

	
	end function
	public function getserverRoom()
		   cc=0
		   echostr=""
		   for each room_item in appObj("flux")
			roomid=room_item
			checked=""
			if cc=appObj("flux").count-1 and oldroom="" then checked="checked=""checked"""
			if oldroom<>"" and oldroom=roomid then
				checked="checked=""checked"""
			'elseif trim(roomid)="37" then
				'checked="checked=""checked"""			
			end if
		 
           echostr="<div><input type=""radio"" value="""&roomid&""" name=""room"" "&checked&" /><a href=""/services/CloudHost/server_room_cloud.asp"" target=""_blank"">"&getroomname(roomid)&"</a></div>"&echostr
			   
			cc=cc+1
		   next

		getserverRoom=echostr
	end function
	public function getCHOICE_OS()	   
		getCHOICE_OS="<select name=""CHOICE_OS"" size=""1"">"
		getCHOICE_OS=getCHOICE_OS&"        <option value="""" data-image=""/images/jqtransform/win001.gif"">请选择操作系统</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win"" data-image=""/images/jqtransform/win001.gif"">Win2003 32位(预装sqlserver2000及常用软件+安全配置，推荐)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win_2005"" data-image=""/images/jqtransform/win001.gif"">Win2003 32位(预装sqlserver2005及常用软件+安全配置)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win_clean"" data-image=""/images/jqtransform/win001.gif"">Win2003 32位(纯净版)</option>"
		getCHOICE_OS=getCHOICE_OS&"	<option value=""win_64"" data-image=""/images/jqtransform/win001.gif"">Win2003 64位(纯净版)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win_2008_64"" data-image=""/images/jqtransform/win002.gif"">Win2008 64位(预装php+sql2008等网站集成环境,强烈推荐)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win_2008"" data-image=""/images/jqtransform/win002.gif"">Win2008 64位(纯净版)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""win_2012_clean"" data-image=""/images/jqtransform/win002.gif"">Win2012 64位（纯净版）</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""linux_wd"" data-image=""/images/jqtransform/linux001.gif"">Linux 32位(CentOS6.2,预装wd控制面板)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""linux_64"" data-image=""/images/jqtransform/linux001.gif"">Linux 64位(CentOS6.2,预装wd控制面板)</option>"
		getCHOICE_OS=getCHOICE_OS&"	<option value=""linux_6.4"" data-image=""/images/jqtransform/linux001.gif"">Linux 64位(CentOS6.4,纯净版)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""linux_debian64"" data-image=""/images/jqtransform/linux001.gif"">Linux 64位(Debian 7.0 纯净版)</option>"
		getCHOICE_OS=getCHOICE_OS&"       <option value=""linux_ubuntu"" data-image=""/images/jqtransform/linux001.gif"">Linux 32位(ubuntu-12.04-server,适合专业人士使用)</option>"
		getCHOICE_OS=getCHOICE_OS&"     </select>"
	end function
	public function getroomname(byval roomid)
		roomid=trim(roomid)
		getroomname=""
		if roomid="" then exit function
		roomsql="select top 1 * from serverRoomlist where r_typecode="& roomid
		set roomRs=conn.execute(roomsql)
		if not roomRs.eof then
			getroomname=trim(roomRs("r_name"))
			
				remark=trim(roomRs("r_remark")&""):remarkstr=""
				r_wb=trim(roomRs("r_wb")&""):r_wbstr=""
				r_vpsband=trim(roomRs("r_vpsband")&""):r_vpsbandstr=""
				ismodrr=roomRs("ismodrr"):ismodrrStr=""
				r_typecode=roomRs("r_typecode")
				if remark<>"" then  remarkstr=remark&""	
				if r_typecode="8" then
					ismodrrStr="独享IP一个"
				'elseif ismodrr then
					'ismodrrStr="共享IP"
				Else
					If r_typecode="36" Then
					ismodrrStr="独享IP二个"
					'Else
						'ismodrrStr="独享IP一个"
					End If				
				end if	
				RonminfoStr="("& remarkstr& ismodrrStr&")"
				getroomname=getroomname&RonminfoStr
			
		end if
		roomRs.close
		set roomRs=nothing
	end function
	function getVpsPayMethod()			
		result = "<label class=""msg""  for=""yvfu""><input type=""radio"" id=""yvfu"" name=""PayMethod"" value=""0"" /><span>按月付</span></label>"			
		result = result&"<label class=""msg""  for=""jifu""><input type=""radio"" id=""jifu"" name=""PayMethod"" value=""2""  /><span>按季付</span></label>"			
		result = result&"<label class=""msg""  for=""banlianfu""><input type=""radio"" id=""banlianfu"" name=""PayMethod"" value=""3""  /><span>按半年付</span></label>"				
		result = result&"<label class=""msg""  for=""lianfu""><input type=""radio"" id=""lianfu"" name=""PayMethod"" value=""1""  checked /><span>按年付(多年更优惠)</span></label>" 
		getVpsPayMethod=result
	end function
	public function getPostvalue()
   
		for str_i = 1 to Request.form.count
			formkey=trim(Request.form.key(str_i))
			
			formvalue=trim(Requesta(formkey))&""
		
			checkissub=checkinput(formkey,formvalue)
	' response.Write(formkey&"="&formvalue&"("&checkissub&")<BR>")
			if checkissub="" then
				if formkey<>"" And checkRegExp(formkey,"^[\w]+$") then
				execute formkey & "=formvalue"
				end if
			else
				errstr=checkissub
			end if			
		next		
		
   
 
		for str_i=1 to Request.querystring.count
			formkey=trim(Request.querystring.key(str_i))
			formvalue=trim(Requesta(formkey))&""
			checkissub=checkinput(formkey,formvalue)
			if checkissub="" then
				'response.write formkey & "="&formvalue & "<br>"
				if formkey<>"" And checkRegExp(formkey,"^[\w]+$") then
					execute formkey & "=formvalue"
				end if
			else
				errstr=checkissub
			end if			
		next
 
		

		if errstr<>"" then exit function		
		if buycount&""="" or not isnumeric(buycount) then buycount=1
		cpuhz=getcpuval(cpu)
			
		if cpuhz=0 then errstr="cpu核心计算出错":exit function
		
		ramsize=getramval(ram)
		 
	   'die ramsize
		if ramsize=0 then errstr="内存大小计算出错":exit function
		if paytype&""="" or not isnumeric(paytype) then paytype=0
		getdatasize()
		if paytype=1 then
			if ramsize>3 then
			   errstr="提示：试用主机最大允许3G内存"	
			   exit function
			elseif data>200 then
			   errstr="提示：试用主机最大允许200G硬盘"
			   exit function
            elseif flux>10 then
				errstr="提示：试用主机最大允许10M带宽"
				exit function	
            end if
		end if
		
		
		
		
		
	end Function
	
	public function getdatasize()
		if isnumeric(osdata&"") then
			if osdata<30 then
				osdata=30
			elseif osdata>200 then
				osdata=200
			end if
			data=cdbl(data)+cdbl(osdata)		
		else
			osdata=30
		end if
		if data<50 then
			data=50
		end if
	end function
	
	
	private function getUserinfo()
		if trim(user_sysid&"")<>"" then 
			sql="select top 1 * from userdetail where u_id="& user_sysid
		
			set urs=conn.execute(sql)
			if not urs.eof then
				user_name=urs("u_name")
				u_resumesum=urs("u_resumesum")
				u_usemoney=urs("u_usemoney")
				
				
				
				u_levelid=urs("u_level")
				firstlevelTime=urs("firstlevelTime")


				'u_company=urs("u_company")
				'u_contract=urs("u_contract")
				'u_trade=urs("u_trade")
				'u_telphone=urs("u_telphone")
				'u_email=urs("u_email")
'				qq_msg=nnpws(urs("qq_msg"))
				'msn_msg=urs("msn_msg")
				'u_zipcode=urs("u_zipcode")
				'u_address=urs("u_address")
				
				
				
'				u_renzheng=urs("u_renzheng")
                 
				if clng(u_levelid)>=2 then paytestPrice=diypaytestDLPrice
				if u_renzheng&""="" then u_renzheng=false
				if not isdate(firstlevelTime) then firstlevelTime=now()
				UserIP=GetuserIp()
				snapadvprice=GetNeedPrice(user_name,"snapadv01",1,"new")
			else
				errstr="该用户不存在"
			end if
			urs.close
			set urs=nothing
		end if
	end function
	
	
	public function checkinput(byval inputkey,byval inputvalue)
		checkinput=""
		select case trim(lcase(inputkey))
			case "cpu"
				if not regCheck("\d{1,50}$",inputvalue) then
					checkinput="CPU值不正确"
				end if
			case "data"
				if not regCheck("\d{2,50}$",inputvalue) then
					checkinput="数据盘数值不正确"
				end If
			case "osdata"
				if not regCheck("\d{2,50}$",inputvalue) then
					checkinput="系统盘数值不正确"
				end If
				if int(inputvalue)<30 Then checkinput="系统盘数最小30G"
	
			case "ram"
				if not regCheck("\d{1,50}$",inputvalue) then
					checkinput="内存值不正确"
				end if
			case "flux"
				if not regCheck("[\d\.]{1,50}$",inputvalue) then
					checkinput="带宽值不正确"
				end if
			case "room"
				if not regCheck("\d{0,3}$",inputvalue) then
					checkinput="机房值不正确"
				end if
			case "servicetype"
				if not regCheck("[\u4e00-\u9fa5\.\w]{0,20}$",inputvalue) then
					checkinput="服务标准值不正确"
				end if
			case "paymethod"
				if inputvalue&""<>"" then
					if instr(",0,1,2,3,4,",","&inputvalue&",")=0 then
						checkinput="付款方式不正确"
					end if
				end if
			case "renewtime"
				if inputvalue&""<>"" then
					if not isnumeric(inputvalue) then
						checkinput="购买期限不正确"&inputvalue
					end if
				end if
			case "choice_os"
				if not regCheck("[\w\.\-]{0,20}$",inputvalue) then
					checkinput="操作系统不正确"
				end if
			case "act"
				if not regCheck("[\w]{0,20}$",inputvalue) then
					checkinput="操作类型不正确"
				end if
			case "agreement"
				if inputvalue="" or inputvalue&""<>"1" then
					checkinput="您还没有同意西部数码主机租用协议"
				end if
			case "id"
				if not regCheck("[\d]{1,20}$",inputvalue) then
					checkinput="id项格式出错"
				end if
			case "blday"
				if not regCheck("[\d]{0,20}$",inputvalue) then
					checkinput="保留天数格式不正确"
				end if
			case "paytype"
				if not regCheck("[01]{1}$",inputvalue) then
					checkinput="购买方式不正确"
				end if
			case "buycount"
				if inputvalue<>"" then
					if not regCheck("[\d]{0,2}$",inputvalue) then
						checkinput="购买台数不正确"
					end if
				end if
			case "company"
			 
			   if not regCheck("[\u4e00-\u9fa5\.\w]{2,60}$",inputvalue) and trim(inputvalue)<>"" then
					checkinput="请输入正确企业名称"
				end if
			case "name"
			   if not regCheck("[\u4e00-\u9fa5\.\w]{2,20}$",inputvalue) and trim(inputvalue)<>"" then
					checkinput="请输入正确联系人"
				end if		
			case "trade"
			   if (len(inputvalue)<4 or len(inputvalue)>30) and trim(inputvalue)<>"" then
					checkinput="请输入正确证件号码"
				end if	
			case "telephone"
			   if not regCheck("\d{3}-?\d{8}|\d{4}-?\d{7}|1[0-9]{10}",inputvalue)  and trim(inputvalue)<>"" then
					checkinput="请输入正确电话号码"
				end if	
			case "email"
			   if not regCheck("\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*",inputvalue) then
					checkinput="请输入正确邮箱地址"
				end if
			case "mobile"
			   if not regCheck("1[0-9]{10}",inputvalue) then
					checkinput="手机号码格式错误"
				end if
			case "address"
			   if len(inputvalue)>60 and trim(inputvalue)<>"" then
					checkinput="联系地址输入错误"
				end if	
			 case "zipcode"
				if inputvalue<>"" then
					   if not regCheck("[\d]{6}",inputvalue) then
							checkinput="邮政编码不正确"
						end if	
				end if
			case "qq"
				if inputvalue<>"" then
					   if not regCheck("[\d]{5,12}",inputvalue) then
							checkinput="qq号码不能为空"
						end if	
				end If
			Case "ddos"
				if not regCheck("[\d]{1,3}$",inputvalue) then
					checkinput="DDoS防护值有误"
				end if
			case "disktype"
				if instr(",ebs,local,ssd,",","&trim(inputvalue)&",")=0 then
					checkinput="存储模式项格式出错"
				end If
			Case "prodtype"
				if instr(",0,1,2,",","&trim(inputvalue)&",")=0 then
					checkinput="产品型号有误"
				end If
			Case "snapadv"
				if instr(",0,1,",","&trim(snapadv)&",")=0 then
					checkinput="产品型号有误"
				end If
			Case "cc"
				if instr(",0,1,",","&trim(snapadv)&",")=0 then
					checkinput="CC防护类型有误"
				end If
			case else
				if instr("mc_oldprice,mc_action,mc_prokey,mc_proid",inputkey)=0 then
				checkinput="未知传递项:"&inputkey&"="&inputvalue
				end if
				
		end select
	end function
	public function regCheck(byval regPattern,byval checkvalue)
	'正则判断
		Set oRegExp = new RegExp
			oRegExp.Pattern = regPattern
			oRegExp.IgnoreCase = False '不区分大小写
			oRegExp.Global = True	'全局
			regCheck = oRegExp.Test(checkvalue)
		Set oRegExp = Nothing
	end function
	public function isPaymentAllow(byval Price,byref errstr)
		result=true:errstr=""
'		if u_levelid>1 and datediff("d",firstlevelTime,date())<=30 then'如果新成为代理30天内
'			payment=getlevelPayment(u_levelid)
'			if cdbl(u_usemoney)<cdbl(Price)+payment then'用户可用金额<服务器价格+预付款
'				if not isBuyServer(firstlevelTime) then'没有买过服务器(第一次买)
'					result=false
'					errstr="成为代理30天内首次买vps/云主机,可用金额必须>=代理预付款("& payment &")+当前产品价("& price &"),当前可用金额("& u_usemoney &")不足,请充值"
'				end if
'			end if
'		end if
		isPaymentAllow=result
	end function
	public function isBuyServer(byval begindate)'在指定时间内是否买过服务器
		result=false
		sql="select 1 from hostrental where u_name='"& user_name &"' and datediff(day,StartTime,'"& begindate &"')<=0"
		rs11.open sql,conn,1,1
		if not rs11.eof then
			result=true
		end if
		rs11.close
		isBuyServer=result
	end function
	public function getlevelPayment(byval levelid)
		result=0
		sql="select * from levellist where l_level='"& levelid &"'"
		rs1.open sql,conn,1,1
		if not rs1.eof then
			result=cdbl(rs1("payment"))
		end if
		rs1.close
		getlevelPayment=result
	end function
	private function vpsIsShare(byval vpsroom)
			vpsroom=cstr(vpsroom)
			if vpsroom="29" or vpsroom="30" Or vpsroom="32" Or vpsroom="34" then
				vpsIsShare=true
			else
				vpsIsShare=false
			end if
	end function
	public function getbldayPrice(byval thisblArr,byval thisblday)
		getbldayPrice=0
		for each bl_item in thisblArr
			blitemArr=split(bl_item,":")
			itemDay=trim(blitemArr(0))
			itemMoney=trim(blitemArr(1))
			if itemDay=trim(thisblday) then
				getbldayPrice=itemMoney
			end if
		next
	end function
	public function getblDate(byval baoliuday)
		if baoliuday>7 then baoliuday=7
		if baoliuday<0 then baoliuday=0
		'if baoliuday=0 then baoliuday=1 '如果用户选择不保留数据.程序还是会为他保留一天,防止意外情况
		tmpdays=7-baoliuday-1
		getblDate=dateadd("d",tmpdays-2*tmpdays,date()&" 01:00:00")
	end function
	 
	public function formatroomname(byval roomname)		
		kindex=instr(roomname,"(")
		if kindex>0 then roomname=mid(roomname,1,kindex-1)
		formatroomname=roomname
	end function
	
	
	'获取数据
	public function returnJson()
		Dim retdic_
		Set retdic_=get_cacehe_ebs_confg()
		retdic_.add "diy_dis",Array(diy_dis_6,diy_dis_12,diy_dis_24,diy_dis_36,diy_dis_60)
		retdic_("paytestprice")=diypaytestPrice

		if isnumeric(session("u_levelid")&"") Then 
			if clng(session("u_levelid"))>=2 Then retdic_("paytestprice")=diypaytestDLPrice
		End If
		'die aspjsonprint(retdic_)
		returnJson=aspjsonprint(retdic_)
'	if application("server_diy_config_sj")="" or application("server_diy_config")="" then
'		application("server_diy_config")="{"&trim(GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp"))&",""now"":"""&now()&""",""diy_dis"":["&diy_dis_6&","&diy_dis_12&","&diy_dis_24&","&diy_dis_36&","&diy_dis_60&"]}"
'		application("server_diy_config_sj")=now()
'		else
'		if datediff("s",application("server_diy_config_sj"),now())>259200 then
'		application("server_diy_config")="{"&trim(GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp"))&",""now"":"""&now()&""",""diy_dis"":["&diy_dis_6&","&diy_dis_12&","&diy_dis_24&","&diy_dis_36&","&diy_dis_60&"]}"
'		application("server_diy_config_sj")=now()
'		end if
'    end if
'	    '对试用价格进行设置
'		
'		if trim(session("u_levelid"))="" then
'		returnJson=regReplace(application("server_diy_config"),"\""paytestprice\"":\""(\d+)\""","""paytestprice"":"""&diypaytestPrice&"""")	
'        else
'		   if clng(session("u_levelid"))>=2 then
'		   returnJson=regReplace(application("server_diy_config"),"\""paytestprice\"":\""(\d+)\""","""paytestprice"":"""&diypaytestDLPrice&"""")	
'		   else
'		   returnJson=regReplace(application("server_diy_config"),"\""paytestprice\"":\""(\d+)\""","""paytestprice"":"""&diypaytestPrice&"""")	
'		   end if
'		end if
' 
	end function









	'2013-7-8cpu内存转换
	public function zh_cpuandram()
		
	if buycount&""="" or not isnumeric(buycount) then buycount=1
		cpuhz=getcpuval(cpu)
		if cpuhz=0 then errstr="cpu核心计算出错":exit function
		ramsize=getramval(ram)
	
		if ramsize=0 then errstr="内存大小计算出错":exit function
		if paytype&""="" or not isnumeric(paytype) then paytype=0		
		if disktype&""="" then disktype="ebs"
		if paytype=1 then
			if cpuhz>4 then
				errstr="提示：试用主机最大允许4核CPU"	
			   exit function
			elseif ramsize>3 then
			   errstr="提示：试用主机最大允许3G内存"	
			   exit function
			elseif data>200 then
			   errstr="提示：试用主机最大允许200G硬盘"
			   exit function
            elseif flux>10 then
				errstr="提示：试用主机最大允许10M带宽"
				exit function	
            end if
		end if
	
	end Function
	
	Function getbuyccprice(ByVal buytype)
		getbuyccprice=0
		if instr(free_cc_roomids,","&room&",")>0 then
			getbuyccprice=0
		Else
			if trim(user_name)<>"" then 
				getbuyccprice=GetNeedPrice(user_name,"ccfh",1,buytype)
			end if 
		end If
			
	End function


End Class


%>
