<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/patch_inc.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<%
lockregcount=5'用户登陆锁定次数
lockregtime=10'单位分钟,锁定间隔时间
session("free_zxw")=""
mydomain=Request.ServerVariables("HTTP_HOST")
caplogin=requesta("caplogin")
s_caplogin=session("caplogin")
session("caplogin")=""
If Requesta("u_name")<>"" And Requesta("u_password")<>"" Then
	strUname = replace(Requesta("u_name"),"'","''")
	strPassword    = md5_16(replace(Requesta("u_password"),"'","''"))
	If not checkRegExp(strUname,"^[0-9a-zA-Z\u4e00-\u9fa5_-]{2,16}$") Then  url_return  "请录入正确的登陆帐号",-1
	conn.open constr 
	if showSafeCode then
		session("chkcode_u_name")=""
		session("chkcode_u_password")=""
		if chkIPcount() then
			iscode=false
			if caplogin<>""  then
				if lcase(caplogin)=lcase(s_caplogin) then 
				iscode=true
				else
				errpage "验证码录入错误请重新录入."
				end if
			end if
			
			if not iscode then
				'验证码录入
				session("chkcode_u_name")=Requesta("u_name")
				session("chkcode_u_password")=Requesta("u_password")

				'response.redirect("/inputcode.asp")
				die "<script>location.replace('/inputcode.asp')</script>"
			end if
		end if
	end if
	if islockuser(trim(strUname)) then
		conn.close
		errpage "此账号错误登陆超过"& lockregcount &"次,已被锁定,"&lockregtime&"分钟后将解锁."
	end if
	
	rs.open "select * from UserDetail where u_name='"& strUname&"' and u_freeze="&PE_False&" and u_password='"& strPassword &"'" ,conn,3
	If rs.eof And rs.bof Then
		call dolockuser(strUname)
		rs.close
		conn.close
		errpage "账号或密码错误!"
	else
			call check_login_ip(rs("ipfilter"),rs("allowIP"))
			application.lock
			Application("tmpftpUser") = addDFApplication(Application("tmpftpUser"))
			Application("tmpDomain") = addDFApplication(Application("tmpDomain"))
			Application("tmpMailDomain") = addDFApplication(Application("tmpMailDomain"))
			Application("tmpsiteDomain") = addDFApplication(Application("tmpsiteDomain"))
			oldonline=	Application("online")
			Application("online")=connnectstrings(oldonline,strUname)
			
		application.unlock
		
		call setuserSession(strUname)

		call dellockuser(trim(rs("u_id")))

		ipAddress=rs("u_ip")
		
 
		
		if isNull(ipAddress) or trim(ipAddress)="" then
		 ipAddress="0.0.0.0|1900-01-01 00:00 00,"&get_cli_ip()& "|" & Now()
		 else
		 ipAddress=ipAddress & "," &get_cli_ip()& "|" & Now()
		end if
 		
		tempip=split(ipAddress,",")
		if ubound(tempip)>5 then
		  dim ip_
		  ip_=""
		  for i=1 to ubound(tempip)
		  if ip_="" then
		  ip_=tempip(i)
		  else
		   ip_=ip_&","&tempip(i)
		  end if
		  next	
		  
		  ipAddress=ip_	
		end if
		
		
		
		

		Sql="Update UserDetail Set u_ip='" & ipAddress & "' Where u_name='" & session("user_name") & "'"
		conn.Execute(Sql)
		
		if trim(requestf("back_path2"))<>"" then
				tourlStr=trim(session("w_from"))
				backpath=requesta("back_path2")
				if tourlStr & ""<>"" then 
					if instr(backpath,"?")>0 then 
						backpath=backpath & "&" & tourlStr
					else
						backpath=backpath & "?" & tourlStr
					end if
					
				end if
				if instr(backpath,"?")>0 then
					newpath=myinstr(backpath,"(.+)\?") & "?" & delRepeatStr(myinstr(backpath,"\?(.+)"),"&")
					if right(newPath,1)="?" then newPath=left(newPath,len(newPath)-1)
				else
					newPath=backpath
				end if
				if newPath<>"" then
					rs.close :conn.close
					response.redirect  newpath
					response.end
				end if
		end if
		If rs("u_type")>0 Then 
			if ckbadWord(Requesta("u_password")) then
				astr="alert('您的密码是弱口令，黑客会盗用您的资产，请在后台用户管理处修改');"
			end if
			rs.close :conn.close
			response.Write "<script>" & astr & "document.location.href='" & SystemAdminPath & "/';</script>"
			response.End()
		end if
		rs.close
		Sql="Select id from fuser where u_id=" & Session("u_sysid") & " and L_ok="&PE_True&""
		Rs.open Sql,conn,1,1
		vcp_return=false
		if not Rs.eof then vcp_return=true
		Rs.close
		conn.close
		Session("vcp")=vcp_return 'vcp用户
		response.redirect "/Manager/"
	End If

else
	errpage "请录入您要登陆的帐号密码."
End If

function chkIPcount()
   chkIPcount=false
   set chkiprs=conn.execute("select sum(l_regcount) from lockuser where l_ip='"&getUserIP()&"'")
   if not chkiprs.eof then
        if not isnull(chkiprs(0)) then
			if cdbl(chkiprs(0))>2 then
			chkIPcount=true
			end if
		end if
   end if
end function
sub dolockuser(u_name)
		if u_name<>"" then
				set rszxw=conn.execute("select top 1 u_id from userdetail where u_name='"& u_name &"'")
				if not rszxw.eof then
					sqllock="select * from lockuser where u_id="& rszxw("u_id") &""
					rs11.open sqllock,conn,1,3
					if not rs11.eof then
						if rs11("l_lockup")=1 then
							if datediff("n",rs11("l_regtime"),now())>=lockregtime then
								rs11.addnew()
								rs11("u_id")=rszxw("u_id")
								rs11("l_regcount")=1
								rs11("l_regtime")=now()
								rs11("l_ip")=getUserIP()
							end if
						else
							if rs11("l_regcount")>lockregcount then
								rs11("l_ip")=getUserIP()
								rs11("l_lockup")=1
							else
								rs11("l_regcount")=rs11("l_regcount")+1
								rs11("l_ip")=getUserIP()
								rs11("l_regtime")=now()
							end if
						end if
					else
						rs11.addnew()
						rs11("u_id")=rszxw("u_id")
						rs11("l_regcount")=1
						rs11("l_ip")=getUserIP()
						rs11("l_regtime")=now()
					end if
					rs11.update()
					rs11.close
				else
					sqllock="select * from lockuser where u_id=0 and  l_ip='"&getUserIP()&"'"
					rs11.open sqllock,conn,1,3
					if not rs11.eof then
						if rs11("l_lockup")=1 then
						 
							if datediff("n",rs11("l_regtime"),now())>=lockregtime then
								rs11.addnew()
								rs11("u_id")=0
								rs11("l_regcount")=1
								rs11("l_regtime")=now()
								rs11("l_ip")=getUserIP()
							end if
						else
							if rs11("l_regcount")>20 then
								rs11("l_ip")=getUserIP()
								rs11("l_lockup")=1
							else
								rs11("l_regcount")=rs11("l_regcount")+1
								rs11("l_ip")=getUserIP()
								rs11("l_regtime")=now()
							end if
						end if
					else
						rs11.addnew()
						rs11("u_id")=0
						rs11("l_regcount")=1
						rs11("l_ip")=getUserIP()
						rs11("l_regtime")=now()
					end if
					rs11.update()
					rs11.close
				end if
				rszxw.close
				set rszxw=nothing
		end if
end sub
function islockuser(u_name)
	islockuser=false
	set rszxw=conn.execute("select top 1 * from lockuser where (u_id=(select u_id from userdetail where u_name='"& u_name &"') or (l_ip='"&getUserIP()&"' and u_id=0)) and l_lockup=1")
	if not rszxw.eof then
		if datediff("n",rszxw("l_regtime"),now())>=lockregtime then
			conn.execute "delete from lockuser where u_id="& trim(rszxw("u_id"))
		else
		islockuser=true '是锁定的
		end if
	end if
	rszxw.close
	set rszxw=nothing


	
end function
sub dellockuser(u_id)
	if u_id <> "" then
		conn.execute "delete from lockuser where u_id="&u_id
		conn.execute "delete from lockuser where u_id=0 and datediff("&PE_DatePart_D&",l_regtime,"&PE_Now&")>0" 
	end if
end sub
sub check_login_ip(needcheck,iplist)
		if not needcheck then
			exit sub
		end if
		currentip=get_cli_ip 'Request.ServerVariables("Remote_Addr")
		collection_ips=split(iplist,",")
		allow_login=false
		for each ip in collection_ips
			ip=trim(ip)
			if isIp(ip) then
				slashPos=inStr(ip,"/")
				if slashPos=0 then
					if ip=currentip then
						allow_login=true
						exit for
					end if
				else
					netRang=mid(ip,slashPos+1)
					if not isNumeric(netRang) then
						allow_login=true
						exit for
					end if
					netRang=cint(netRang)
					if netRang>31 then
						allow_login=true
						exit for
					end if
					ipsets=split(currentip,".")
					C_IP_BIN=pad(oct2bin(ipsets(0))) & pad(oct2bin(ipsets(1))) & pad(oct2bin(ipsets(2))) & pad(oct2bin(ipsets(3)))
					ipsets=split(ip,".")
					sPos=instr(ipsets(3),"/")
					if sPos=0 then
						allow_login=true
						exit for
					end if
					ipsets(3)=left(ipsets(3),sPos-1)
					S_IP_BIN=pad(oct2bin(ipsets(0))) & pad(oct2bin(ipsets(1))) & pad(oct2bin(ipsets(2))) & pad(oct2bin(ipsets(3)))
					if left(C_IP_BIN,netRang) = left(S_IP_BIN,netRang) then
					  allow_login=true
					  exit for
					end if
				end if
			end if
		next
		
		if not allow_login then
			Response.write "<script language=javascript>alert('登录失败，该用户拒绝从您的IP地址" & currentip &"登录!\n\n注:如果您设置了IP过滤，需通过www.west263.com登录');history.back();</script>"
			Response.end
		end if
end sub

function oct2bin(octNumber)
 vara=octNumber
 do 
  oct2bin=cstr(vara mod 2) & oct2bin
  vara=vara \ 2
 loop until vara=0
end function


function pad(str)
 pad=right("00000000" & str,8)
end function


%>
