<%
Class uphost_class
	dim u_sysid,s_comment,hostid,u_name,u_usemoney
	dim s_buydate,s_ftppassword,s_expiredate,s_year,s_room,s_siteState,s_buytest,s_productid,s_serverip,s_ProName,s_roomname,new_roomlist,s_mid,s_ProNameClass,s_mysqlversion,s_defaultbindings,s_name,s_url,s_ServerName,haveMysql,s_mysqlpassword,s_islinux,mssql_pre,s_Servertype,isLimitMove,new_proname,clearDate,s_productname,istostatepage,dayHave,dayCount,movestate,old_serverip,old_islinux,targetip,mysqlver
	dim selectroomlist,selectproidlist,proidlist,ismovedata,s_osver,oslist
	dim new_roomname,cb_price,ProShouXuFei,RoomShouXuFei,everydayPrice,upShouXuFei,newPrice,oldPrice,s_other_ip,isGoOnIP,GoOnIPMoney,old_otheripPrice,new_otheripPrice,newmysqlver
	Private Sub Class_Initialize
		ismovedata=0
		s_islinux=false
		istostatepage=false
		GoOnIPMoney=chgroomipmoney
		isGoOnIP=false
		old_otheripPrice=0
		new_otheripPrice=0
		newmysqlver=""
	End sub

	Public Property Let setGoOnip(v)
        isGoOnIP=v 
    End Property
	
	Public Property get getGoOnip()
        getGoOnip=isGoOnIP		
    End Property
	Public Property get getGoOnIPMoney()
	   getGoOnIPMoney=GoOnIPMoney
	end Property

	Public Property Let setHostid(value)
        hostid=value		
		getHostInfo()
    End Property
	public function dosub(byval new_proid,byval new_room,byval new_osver,byval ismovedata,byref resultstr)
		commandstr="vhost"& vbcrlf & _
			   "set"& vbcrlf & _
			   "entityname:upvhost" & vbcrlf & _
			   "hostname:" & s_comment & vbcrlf & _
			   "new_proid:" & new_proid & vbcrlf & _
			   "new_room:" & new_room & vbcrlf & _
			   "new_osver:"& new_osver & vbcrlf & _
			   "ismovedata:" & ismovedata & vbcrlf & _
			   "updateType:OldupdateType"& vbcrlf & _
			   "keepip:"&isGoOnIP& vbcrlf & _
			   "mysqlver:"&newmysqlver& vbcrlf & _
			   "." & vbcrlf
			   'die commandstr
		resultstr=pcommand(commandstr,u_name)		
		if left(resultstr,3)="200" then									 
			dosub=true
		else
			dosub=false
		end if
	end function
	public function getHostInfo()
		if hostID<>"" and isnumeric(hostID) then
			Sql="Select * from vhhostlist where s_sysid=" & hostID & " and S_ownerid=" & u_sysid
			rs1.open sql,conn,1,1
			if not rs1.eof then
				s_comment=rs1("s_comment")
				s_buydate=formatdatetime(rs1("s_buydate"),2):s_year=rs1("s_year"):s_siteState=rs1("s_siteState"):s_buytest=rs1("s_buytest")
				s_expiredate=formatdatetime(dateadd("yyyy",s_year,s_buydate),2):s_productid=rs1("s_productid"):s_serverip=rs1("s_serverip")
				s_mid=rs1("s_mid")
				s_defaultbindings=rs1("s_defaultbindings")
				s_ServerName=rs1("s_ServerName"):s_mysqlpassword=trim(rs1("s_mysqlpassword")&"")
				mssql_pre=rs1("pre4")&"":if mssql_pre="" or not isnumeric(mssql_pre) then mssql_pre=0
				'if rs1("s_others")="mysql" or (rs1("u_mysqlsize")<>"" and Clng(rs1("u_mysqlsize"))>0) then haveMysql=true
				s_ftppassword=trim(rs1("s_ftppassword"))
				if not isip(targetip&"") then targetip=s_serverip
				s_productname=getProname(s_productid)
				dayCount=datediff("d",s_buydate,s_expiredate):if dayCount<0 then dayCount=0
				dayHave=datediff("d",date(),s_expiredate):if dayHave<0 then dayHave=0					
				getUserinfo
				getUpInfo s_productid,0,0,0
				selectproidlist=getselectproidlist
				s_islinux=(instr(s_proname,"linux") or instr(s_proname,"java"))
			else
				url_return "抱歉，没有找到该主机",-1
			end if
			rs1.close
		else
			url_return "传递参数错误",-1
		end if
	end function
	public function getProname(byval proid)
		result=""
		sql="select * from productlist where p_proid='"& proid &"'"
		rs11.open sql,conn,1,1
		if not rs11.eof then
			result=rs11("p_name")
			p_size=rs11("p_size")
			p_maxmen=rs11("p_maxmen")
			p_appid=rs11("p_appid")
			p_server=rs11("p_server")
		end if
		rs11.close
		getProname=result
	end function
	public function getupNeedPrice(byval newProid,byval newRoom,byval ismovedata)
		oldPrice=cdbl(GetNeedPrice(u_name,s_productid,s_year,"new")):if oldPrice<0 then oldPrice=0
		newPrice=cdbl(GetNeedPrice(u_name,newProid,s_year,"new")):if newPrice<0 then newPrice=0

		if s_other_ip<>"" and newRoom<>s_room then
			
			if lcase(left(newProid,2))="tw" then
				ipproid="twaddip"
			else
				ipproid="vhostaddip"
			end if

			old_otheripPrice=GetNeedPrice(u_name,ipproid,s_year,"new")'得到主机相关的独立Ip价格	
			'oldPrice=cdbl(oldPrice)+cdbl(old_otheripPrice)
			if isGoOnIP then
				'newotherip=getRoomotherip(newRoom)
				'if isip(newotherip) then
					new_otheripPrice=old_otheripPrice
					'newPrice=cdbl(newPrice)+cdbl(new_otheripPrice)
				'end if
			end if
		end if


		everydayPrice=((newPrice+cdbl(new_otheripPrice))-(oldPrice+cdbl(old_otheripPrice)))/dayCount:if everydayPrice<0 then everydayPrice=0
		upShouXuFei=cdbl(ProShouXuFei)+cdbl(RoomShouXuFei)
		needPrice=Round(everydayPrice * dayHave + upShouXuFei)
		

		if isGoOnIP then
		    upShouXuFei=upShouXuFei+GoOnIPMoney
			 needPrice=needPrice+GoOnIPMoney
		end if
		if needPrice>0 and needPrice<10 then 
			needPrice=10
		elseif needPrice<0 then
			needPrice=0
		end if		
		
		if cdbl(needPrice)<cdbl(cb_price) then needPrice=cdbl(cb_price)
	
		getupNeedPrice=needPrice
	end function
	private function getUserinfo()
		if trim(u_sysid&"")="" or not isnumeric(u_sysid) then url_return "请重新登陆",-1
		sql="select top 1 * from userdetail where u_id="& u_sysid
		set urs=conn.execute(sql)
		if not urs.eof then
			u_name=urs("u_name")
			u_resumesum=urs("u_resumesum")
			u_usemoney=urs("u_usemoney")
			u_levelid=urs("u_level")
			u_company=urs("u_company")
			u_contract=urs("u_contract")
			u_trade=urs("u_trade")
			u_telphone=urs("u_telphone")
			u_email=urs("u_email")
			qq_msg=urs("qq_msg")			
		end if
		urs.close
		set urs=nothing 
	end function
	public function getUpInfo(byval this_proid,byval this_roomid,byval this_osver,byval ismovedata)
		commandstr="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:uphostinfo"& vbcrlf & _
				   "sitename:"& s_comment & vbcrlf & _
				   "new_proid:"& this_proid & vbcrlf & _
				   "new_roomid:"& this_roomid & vbcrlf & _
				   "new_osver:"& this_osver & vbcrlf & _
				   "ismovedata:"& ismovedata & vbcrlf & _				   
				   "." & vbcrlf	
		 '		   die commandstr
		 returnstr=pcommand(commandstr,u_name)		
		 if left(returnstr,3)="200" then
		 	selectroomlist = chgroomName(getReturn_rrset(returnstr,"roomlist"))
			oslist=getReturn_rrset(returnstr,"oslist")
			proidlist=getReturn_rrset(returnstr,"proidlist")
			s_room=getReturn_rrset(returnstr,"s_room")
			s_roomname=chgroomName(getReturn_rrset(returnstr,"s_roomname"))
			new_roomname=chgroomName(getReturn_rrset(returnstr,"new_roomname"))
			cb_price=getReturn_rrset(returnstr,"cb_price")
			ProShouXuFei=getReturn_rrset(returnstr,"pro_sxf")
			RoomShouXuFei=getReturn_rrset(returnstr,"room_sxf")
			isLimitMove=getReturn_rrset(returnstr,"isLimitMove")
			s_proname=lcase(getReturn_rrset(returnstr,"s_proname"))
			new_proname=lcase(getReturn_rrset(returnstr,"new_proname"))
			clearDate=getReturn_rrset(returnstr,"clearDate")
			istostatepage=getReturn_rrset(returnstr,"istostatepage")
			movestate=getReturn_rrset(returnstr,"movestate")
			old_serverip=getReturn_rrset(returnstr,"old_serverip")
			targetip=getReturn_rrset(returnstr,"targetip")
			s_osver=getReturn_rrset(returnstr,"s_osver")
			s_other_ip=getReturn_rrset(returnstr,"old_s_other_ip")
			mysqlver=getReturn_rrset(returnstr,"mysqlver")
			if proidlist="" then
				url_return "该主机类型禁止升级",-1
			end if
		 else
		 	url_return "获取升级信息失败,请联系管理员"& returnstr,-1
		 end if
	end function
	public function getselectproidlist()
		result="<select name=""new_proid"">"	
		sql="select * from Productlist where P_proId in ("& formatSqlstr(proidlist) &") order by P_proId asc"
		rs11.open sql,conn,1,1
		do while not rs11.eof
			new_p_name=rs11("p_name")
			new_p_proid=trim(rs11("p_proid"))
			if not (isSmaller(u_name) and instr(new_p_name,"集群")>0) then
				selectstr="":if lcase(s_productid)=lcase(new_p_proid) then selectstr="selected=""selected"""
				result=result&"<option value="""& new_p_proid &""" "& selectstr &">"& new_p_proid & " "& new_p_name &"</option>"
			end if
		rs11.movenext
		loop
		result=result&"</select>"
		rs11.close
		getselectproidlist=result
	end function
	public function formatSqlstr(byval strlist)
		result=""
		for each str_item in split(strlist,",")
			if trim(str_item)&""<>"" then
				result=result&"'"& lcase(trim(str_item)) & "',"
			end if
		next
		if right(result,1)="," then result=left(result,len(result)-1)
		formatSqlstr=result
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
End Class
%>