<%
Class upmssql_class
	dim u_sysid,dataid,newProidlist,u_name,u_usemoney
	dim dbname,dbloguser,dbserverip,dbpasswd,dbyear,dbbuydate,dbproid,dbexpiredate,dayHave,dayCount,everydayPrice,dbRoomName,dbstatus,dbbuytest,dbroom,roomlist
	dim p_size,p_maxmen,p_appid,p_name,p_server
	dim dbp_size,dbp_maxmen,dbp_appid,dbp_name,dbp_server
	dim newp_size,newp_maxmen,newp_appid,newp_name,newp_server,newRoomName
	dim roomNameArray,RoomShouXuFei,oldPrice,newPrice,needPrice
	dim new_s_ip,new_s_name,new_s_url,newproid,cb_price,dbver
	Public Property Let setdataid(value)
        dataid=value		
		getDbInfo()
    End Property
	public function getDbInfo()	
		if dataid="" or not isnumeric(dataid) then url_return "缺少数据库ID",-1
		getUserinfo()
		Sql="select * from databaselist where dbsysid="& dataID &" and dbu_id="& u_sysid
		rs11.open sql,conn,1,1
		if not rs11.eof then			
			dbname=Rs11("dbname")
			if not session("isdosyn_"&dbname) then
				rs11.close				
				call doUserSyn("mssql",dbname):session("isdosyn_"&dbname)=true				
				getDbInfo()
				exit function
			end if			
			dbserverip=Rs11("dbserverip")
			dbloguser=rs11("dbloguser")
			dbyear=rs11("dbyear")
			dbbuydate=formatdatetime(rs11("dbbuydate"),2)
			dbstatus=rs11("dbstatus")
			dbbuytest=rs11("dbbuytest")
			dbpasswd=rs11("dbpasswd")
			dbproid=lcase(trim(rs11("dbproid")&""))
			dbexpiredate=formatdatetime(dateadd("yyyy",dbyear,dbbuydate),2)
			dayHave=datediff("d",date(),dbexpiredate):if dayHave<0 then dayHave=0
			dayCount=datediff("d",dbbuydate,dbexpiredate):if dayCount<0 then dayCount=0
			call getProInfo(dbproid,0):dbp_name=p_name
		else
			url_return "未找到此数据库",-1
		end if
		rs11.close
	end function
	public function dosub(byval newproid,byval newroom,byref errstr)		   
		commandstr="other"& vbcrlf & _
			   "upgrade"& vbcrlf & _
			   "entityname:mssql" & vbcrlf & _
			   "databasename:" & dbname & vbcrlf & _
			   "TargetProductid:" & newproid & vbcrlf & _
			   "new_room:" & newroom & vbcrlf & _
			   "dbversion:"&dbver & vbcrlf& _
			   "." & vbcrlf
			
		resultstr=pcommand(commandstr,u_name)	
		if left(resultstr,3)="200" then									 
			dosub=true
		else
			dosub=false
		end if
	end function
	private function doupgrade(byval newproid,byval newroom,byref errstr)
		result=true		
		doupgrade=result
	end function
	private function getUserinfo()
		if trim(u_sysid&"")="" or not isnumeric(u_sysid) then url_return "请重新登陆"&u_sysid&"!",-1
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
		end if
		urs.close
		set urs=nothing 
	end function
	public function getProInfo(byval proid,byval roomid)		
	   commandstr="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:upmssqlinfo"& vbcrlf & _
				   "dbname:"& dbname & vbcrlf & _
				   "proid:"& proid & vbcrlf & _
				   "roomid:"& roomid & vbcrlf & _   
				   "." & vbcrlf
		 returnstr=pcommand(commandstr,u_name)	
		 
		 if left(returnstr,3)="200" then
		 	roomlist=getReturn_rrset(returnstr,"roomlist")
			newProidlist=getReturn_rrset(returnstr,"proidlist")
			dbroom=getReturn_rrset(returnstr,"dbroom")
			RoomShouXuFei=getReturn_rrset(returnstr,"shouxufei")
			dbRoomName=getReturn_rrset(returnstr,"dbroomname")
		 	cb_price=getReturn_rrset(returnstr,"cb_price")
			dbp_server=getReturn_rrset(returnstr,"dbp_server")
			newp_server=getReturn_rrset(returnstr,"newp_server")
			dbver=getReturn_rrset(returnstr,"dbver")
			sql="select * from productlist where p_ProID='"& proid &"'"
			set urs=conn.execute(sql)
			if not urs.eof then
				p_name=URs("p_name")
			else
				url_return "未知的类型",-1
			end if
			urs.close:set urs=nothing
		 else
		 	url_return "服务端没有找到该的类型",-1
		 end if	
	end function
	public function getupNeedPrice(byval newProid,byval newRoom)
		call getProInfo(newproid,newRoom):newp_name=p_name
		oldPrice=cdbl(GetNeedPrice(u_name,dbproid,dbyear,"new")):if oldPrice<0 then oldPrice=0
		newPrice=cdbl(GetNeedPrice(u_name,newProid,dbyear,"new")):if newPrice<0 then newPrice=0
		everydayPrice=(newPrice-oldPrice)/dayCount:if everydayPrice<0 then everydayPrice=0
		needPrice=Round(everydayPrice * dayHave + RoomShouXuFei)		
		if needPrice>0 and needPrice<30 then needPrice=30
		if needPrice<0 then needPrice=10   '最低收费10元
		if cdbl(needPrice)<cdbl(cb_price) then needPrice=cdbl(cb_price)
		getupNeedPrice=needPrice		
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
