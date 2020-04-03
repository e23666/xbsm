<%
class miniprogram 
	public user_sysid,user_name,u_namecn,u_address,msn_msg,u_email,u_levelid,tc_name,product_ids,u_usemoney
	Dim P_proId,p_name
	Dim errmsg,okmsg,priceListArr,payTextPrice,smsprice,min_smscount
	Dim db_id,db_userid,db_appName,db_paytype,db_buyYear,db_buyDate,db_expireDate,db_appid,db_proid,db_bakAppName,db_productIds
	dim appconfig,db_tcproid,db_otherproid
	dim paytype,paytypeprice,buymaxyear,adminuserid
	
	'miniprogram_paytype_money,miniprogram_sms_money
	'��ʼ��
	Private Sub Class_Initialize
		user_sysid=session("u_sysid")
		proid=""
		tem_level=1			
		loadconfig()	 '����json����
		paytypeprice=miniprogram_paytype_money   '���ü۸�
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

	'��ȡapp��Ϣ
	public function getappinfo(byval val_)
		getappinfo=false
		if not isnumeric(val_&"") then errmsg="appID��ʽ����":exit function
		sql="select top 1 * from wx_miniprogram_app where userid=" & user_sysid &" and appid ="&val_&"" 
		set dbrs=conn.execute(sql)
			if not dbrs.eof then
				for i=0 to dbrs.Fields.Count-1
				execute("db_"&dbrs.Fields(i).Name & "=dbrs.Fields(" & i & ").value")
			Next
			getappinfo=true
		else
			errmsg="��Ȩ���������ݲ�ѯʧ��"
		end if
		dbrs.close:set dbrs=nothing		
	end function

	'��ȡ��Ʒ��Ϣ
	public function getproductinfo()
		If Trim(P_proId)="" Then errmsg="û���ҵ��˲�Ʒ�ͺ�":Exit Function		
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
			errmsg="û���ҵ��˲�Ʒ�ͺ�":Exit Function		
		end if
	End Function

	
	'��ȡ�û���Ϣ
	Public Function getuserinfo(ByVal user_sysid_)
		getuserinfo=false
		If Not IsNumeric(user_sysid_&"") Then errmsg="��Ա�������":Exit Function
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
	
	'��ӹ��ﳵ
	function addbagshow(byval appname_,byval year_,byval paytype_)
		addbagshow=false
		dim ppricetemp
		if instr(",1,2,3,",","&year_&",")=0 then errmsg="������������":Exit Function
		if instr(",0,1,",","&paytype_&",")=0 then errmsg="���ò�������":Exit Function
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

	'��ȡapp����
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

	'��ת��½
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


	'����app����
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

	'��ȡ���ſ�������
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

	'��ȡ��ǰapp��ƷID
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

	'��ȡ���м۸�
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

	'�����������
	function buysms(byval num)
		buysms=false
		dim sumprice
		if not isnumeric(num&"") then errmsg="������������":Exit Function
		if clng(num)<clng(min_smscount) then errmsg="���������������"&min_smscount&"��":Exit Function
		sumprice=ccur(num)*ccur(miniprogram_sms_money) 
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="��������["&sumprice&"]["&u_usemoney&"]":Exit Function
		if consume(user_name,sumprice,0,"buyapp-sms","С���������["&db_appid&"]["&num&"]","buyappsms",db_id) then
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
			errmsg="�ۿ�ʧ��"
		end if
	end function


	'�ײ�����
	function renew(byval renyear,byval otherids)
		renew=false
		if not isnumeric(renyear&"") then errmsg="������������":exit function
		if renyear<1 then  errmsg="������������":exit function
		if clng(renyear)>clng(buymaxyear) then  errmsg="�����������Ϊ"&buymaxyear&",��ǰΪ"&renyear&"��":exit function
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
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="��������["&sumprice&"]["&u_usemoney&"]":Exit Function	
		if consume(user_name,sumprice,0,"renew-"&db_appid,"С��������["&db_appid&"]["&otherids&"]["&otherprice&"]","renew-xcx",db_id) then
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
				call addRec("΢��С����۷ѳɹ�������ʧ��",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="�ۿ�ʧ��,����ϵ����Ա"
		end if 
	end function


	'����С����
	function create(byval strContents)
		create=false
		appname=getReturn(strContents,"appname")
		producttype=getReturn(strContents,"producttype")
		years=getReturn(strContents,"years")
		paytype=getReturn(strContents,"paytype")
		ppricetemp=getReturn(strContents,"ppricetemp") 
		buytypetxt="С������"
		if trim(appname)="" then errmsg="APP��������!":exit function
		if not isnumeric(years&"") then errmsg="��ͨ��������!":exit function
		if instr(",0,1,",","&paytype&",")=0 then errmsg="���ò�������":Exit Function
		if not isnumeric(ppricetemp&"") then  errmsg="��ͨ�۸�����":Exit Function 
		If CLng(paytype)=1 Then buytypetxt="С��������"
		sumprice=ppricetemp
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="��������["&sumprice&"]["&u_usemoney&"]":Exit Function	
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
				call addRec("΢��С����������ӹ���ʧ�ܿ��Ѿ���["&producttype&"]["&user_name&"]",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="�ۿ�ʧ��,����ϵ����Ա"
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


	'����app����
	function appAddNew(byval id_,byval addyear,byval paytype)
		appAddNew=false
		if not isnumeric(id_&"") then errmsg="��ƷID����":exit function
		if not isnumeric(addyear&"") then errmsg="��ͨ/������������":exit function
		if addyear<1 then  errmsg="��ͨ/������������":exit function
		if clng(addyear)>clng(buymaxyear) then  errmsg="�����������Ϊ"&buymaxyear&",��ǰΪ"&addyear&"��":exit function
		if instr(",0,1,",","&paytype&",")=0 then errmsg="���ò�������":Exit Function
		dim newproid,buytypetxt
		newproid=""
		buytypetxt="С�����¹�"
		for each line_ in appconfig("config")
			if clng(line_("id"))=clng(id_) then
				newproid=line_("proid")
				exit for
			end if
		next
		if trim(newproid)="" then errmsg="��Ʒ��ѯ�ͺ�����,����ϵ����Ա":Exit Function
		if clng(db_paytype)=1 then  'δ��ʽ��ͨ��ֻ������
			price_=0
			buytypetxt="С��������"
		else
			if clng(paytype)=1 then
				price_=0
				buytypetxt="С��������" 
			else
				price_=GetNeedPrice(user_name,newproid,addyear,"new")
			end if
		end if
		sumprice=price_
		if ccur(sumprice)>ccur(u_usemoney) then  errmsg="��������["&sumprice&"]["&u_usemoney&"]":Exit Function	
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
				call addRec("΢��С����������ӹ���ʧ�ܿ��Ѿ���["&db_appid&"]["&id_&"]",loadRet)
				errmsg=loadRet
			end if  
		else
			errmsg="�ۿ�ʧ��,����ϵ����Ա"
		end if  
	end function  
end class
%>