<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%
response.charset="gb2312"
response.Buffer=true
conn.open constr
str=trim(requesta("str"))
if str="needprice" then
	years=requesta("years")
	u_name=requesta("u_name")
	proid=requesta("proid")
	p_name=requesta("p_name")
	if proid="" then conn.close:response.write "产品类型不正确":response.end
	if years="" then years=1
	if isnull(u_name) then u_name=""
	if isDomain(p_name&"") then 
		domainRegister=getDomUpReg(p_name)		
		needPrices=getRenewCnPrice(p_name,years)
	end if
	if needPrices&""="" then


       if proid="diymail" then
	            MailID=clng(requesta("mailid"))
                sqlstring="Select * from mailsitelist where m_sysid=" & MailID & " and m_ownerid=" & Session("u_sysid")
				
			 	rs.open sqlstring,conn,1,1
		       if rs.eof and rs.bof then die "err"
			   needPrices=getDiyMailprice(rs("m_size")/rs("m_mxuser"),rs("m_mxuser"))*years
              
	   else
			needPrices=getneedprice(u_name,proid,years,"renew")
			if p_name<>"" then
				otherip=getOtherip(p_name,session("user_name"))
				otherssl=getOtherssl(p_name,session("user_name"))
			
				if isip(otherip) then


					if lcase(left(proid,2))="tw" then
						ipproid="twaddip"
						else
						ipproid="vhostaddip"
					end if
					 
						ipprice=getneedprice(session("user_name"),ipproid,years,"renew")
					 
					if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
					needPrices=cdbl(needPrices)+cdbl(ipprice)
				else
					if trim(otherssl)="200 1" then 
						sslprice=getneedprice(session("user_name"),"vhostssl",years,"renew")
						needPrices=cdbl(needPrices)+cdbl(sslprice)
					ElseIf trim(otherssl)="200 2" Then 
						sslprice=getneedprice(session("user_name"),"gfssl",years,"renew")
						needPrices=cdbl(needPrices)+cdbl(sslprice)
					end if
				end if
			end if
		end if
	end if
	if proid="dns001" then	
		sqlstring="SELECT * FROM domainlist where userid=(select u_id from userdetail where u_name='"& u_name &"') and strdomain='"& p_name &"'"
		rs.open sqlstring,conn,1,1
		if rs.eof and rs.bof then url_return "没有找到此域名",-1
			regdate=rs("regdate")
			buyyears=rs("years")
		rs.close
		'bl_bind=isbindings(p_name,vhostyear,vhostbuydate)				
		if bl_bind then''''''''''''有绑定
				dnsExpri=dateadd("yyyy",buyyears,regdate)
				hostExpri=dateadd("yyyy",vhostyear,vhostbuydate)
				dnsrenewdate=dateadd("yyyy",years,dnsExpri)
				if datediff("yyyy",dnsrenewdate,hostExpri)>=0 then
					needPrices=0
				end if
		end if
	end if
	
	
	
	
	response.write "<b><font color=red>"& needprices & "</font></b>￥/" & years & "年"
	conn.close
	response.end

end if
%>
