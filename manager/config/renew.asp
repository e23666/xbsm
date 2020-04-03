<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/class/diyserver_Class.asp" -->
<%
Response.Buffer = True   
conn.open constr
dim renewmode
p_id=requesta("p_id")
productType=trim(requesta("productType"))
years=requesta("RenewYear")
paymethod=requesta("paymethod")
renewmode=requesta("renewmode") 'domain
'两次续费操作必须大于2分钟
s_name="isallowrenewserver_"&p_id&"_"&productType
if session(s_name)&""="" then
	session(s_name)=now()
else
   if datediff("n",session(s_name),now())<2 then
	session(s_name)=""
	echoString "操作失败！两次续费时间请超过2分钟！","e"
	die ""
   end if
end if

'die s_name&"="&session("isallowrenewserver_"& id&"_"&productType)
call checkrenew()
select case lcase(productType)
	case "domain"
			if not checkdomain(p_id,strdomain,errstr) then url_return errstr,-1
			returnstr=putRenew("domain",strdomain,years,session("user_name"))
			if left(returnstr,3)="200" then
				alterstr="域名续费成功<br>" & _
						 "域名:"& strdomain & _
						 "续费年限:" & years
										 
				echoString alterstr,"r"
			else
				echoString "域名续费失败 "& returnstr ,"e"
			end if
	case "host"
		if not checkhost(p_id,s_comment,errstr) then url_return errstr,-1
		returnstr=putRenew("vhost",s_comment,years,session("user_name"))
		if left(returnstr,3)="200" then
			alterstr="主机续费成功<br>" & _
					 "FTP名:"& s_comment & _
					 "续费年限:" & years
			call  doUserSyn("vhost",s_comment)						 
			echoString alterstr,"r"
		else
			echoString "主机续费失败 "& returnstr ,"e"
		end if
	case "mail"
		if not checkmail(p_id,m_bindname,errstr)  then url_return errstr,-1
		returnstr=putRenew("mail",m_bindname,years,session("user_name"))
		if left(returnstr,3)="200" then
			alterstr="邮局续费成功<br>" & _
					 "邮局域名:"& m_bindname & _
					 "续费年限:" & years
			call  doUserSyn("mail",m_bindname)						 
			echoString alterstr,"r"
		else
			echoString "邮局续费失败 "& returnstr ,"e"
		end if
	case "dnsdomain"
		if not checkDns(p_id,dnsdomain,errstr)  then url_return errstr,-1
		returnstr=putRenew("dnsdomain",dnsdomain,years,session("user_name"))
		if left(returnstr,3)="200" then
			alterstr="dns续费成功<br>" & _
					 "dns:"& dnsdomain & _
					 "续费年限:" & years
									 
			echoString alterstr,"r"
		else
			echoString "dns续费失败 "& returnstr ,"e"
		end if
	case "mssql"
		if not checkdata(p_id,dbname,errstr)  then url_return errstr,-1
		returnstr=putRenew("mssql",dbname,years,session("user_name"))
		if left(returnstr,3)="200" then
			alterstr="mssql续费成功<br>" & _
					 "mssql域名:"& dbname & _
					 "续费年限:" & years

			call doUserSyn("mssql",dbname)						 
			echoString alterstr,"r"
		else
			echoString "mssql续费失败 "& returnstr ,"e"
		end if
	case "server"			
		if not checkserver(p_id,paymethod,years,allocateip,TotalPrice,errstr) then url_return errstr,-1
		returnstr=putRenew("server",allocateip,years&"^|^"&paymethod,session("user_name"))
		if left(returnstr,3)="200" then
			alterstr="独立主机("& allocateip &")续费成功" & _
					  "花费:" & TotalPrice & "元"
 

			echoString alterstr,"r"
		else
			echoString "独立主机续费失败 "& returnstr ,"e"
		end if
	case else
		url_return "传递参数错误",-1
end select

function checkrenew()
	if not isnumeric(p_id) then url_return "请选择您要续费的产品",-1
	if not isnumeric(years) then url_return "请选择您要续费的年限",-1
	if productType="server" then
		if years>12 or years<1 then url_return "月份只能是1-12的整数",-1
	else
		if years>10 or years<1 then url_return "年限只能是1-10的整数",-1
	end if
end function

Function checkdomain(byval p_id,byref strdomain,byref errstr)
	checkdomain=false
	sqlstring="SELECT top 1 * FROM domainlist where userid=" &  session("u_sysid") & " and d_id=" & p_id
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="没有找到您要续费的域名":exit function
		strdomain=trim(rs("strdomain"))
	checkdomain=true
	rs.close
end Function
Function checkhost(byval p_id,byref s_comment,byref errstr)
	checkhost=false
	sqlstring="SELECT * FROM vhhostlist where s_buytest=0 and S_ownerid=" &  session("u_sysid") & " and s_sysid=" & p_id
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="没有找到您要续费的主机":exit function
	s_comment=rs("s_comment")
	checkhost=true
	rs.close
end function
Function checkdata(byval p_id,byref dbname,byref errstr)
	checkdata=false
	sqlstring="select * from databaselist where dbsysid="& P_id &" and dbu_id=" & session("u_sysid")
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="没有找到您要续费的mssql数据库":exit function
	dbname=rs("dbname")
	checkdata=true
	rs.close
end function
function checkserver(byval p_id,byval paytype,byval sdate,byref allocateip,byref TotalPrice,byref errs)
	checkserver=false
	sql="select * from hostrental where id=" & p_id & " and u_name='" & session("user_name") & "'"
	rs.open sql,conn,1,1
	if rs.eof then rs.close:errs ="无此主机":exit function
	if not rs("start") then errs ="主机未开通，不能续费":exit function
	allocateip=rs("allocateip")
	if paytype&""="" then paytype=rs("paymethod")	
	rs.close
	sdate=Abs(Cint(sdate))
	if sdate<=0 then errs="请选择交费月份":exit function	
	set sb=new buyServer_Class
	sb.setUserid=session("u_sysid")
	sb.getHostdata(allocateip)
	sb.paymethod=paytype
	sb.renewTime=sdate
	call sb.getrenewPrice()
	price=cdbl(sb.PricMoney)	
	if price<=0 then errs = "对不起，续费价格记算有错，请重新操作再试":exit function
	TotalPrice=price
	if ccur(session("u_usemoney"))<CCur(TotalPrice) then errs = "对不起，您的预付款不足，请先充值后再续费":exit function
	checkserver=true
end function
function renewServer_bak(byval tprice,byval sdate,byval allocateip)
	content=allocateip &"续费" & sdate & "月"
	randomize(timer())
	countid="server-" & left(session("user_name"),3) & Left(Cstr(Clng(rnd()*100000)) & "00000",6)
	conn.execute "update Userdetail set u_remcount =  u_remcount - "& tprice &" , u_usemoney = u_usemoney  -"& tprice &" ,u_resumesum=u_resumesum + "& tprice &"  where u_name = '" & session("user_name") &"'"
	conn.execute "insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput ,c_datecheck,c_check,c_type) values ("& session("u_sysid") &","& tprice &", 0,"& tprice &", '"& countid &"' , '"& content &"',now,now, now,0,9)"
	
	conn.Execute("update hostrental set alreadypay=alreadypay+" & sdate & " where id=" & p_id)
	conn.Execute("update userdetail set u_invoice=u_invoice+" & tprice & " where u_name='" & session("user_name") & "'")
	
	renewServer="200 ok"
end function
Function checkmail(byval p_id,byref m_bindname,byref errstr)
	checkmail=false
sqlstring="Select * from mailsitelist where m_sysid=" & p_id & " and m_ownerid=" & Session("u_sysid")
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="没有找到您要续费的邮局":exit function
	m_bindname=rs("m_bindname")
	checkmail=true
end function

Function checkdns(byval p_id,byref strdomain,byref errstr)
	checkdns=false
	sqlstring="SELECT top 1 * FROM domainlist where userid=" &  session("u_sysid") & " and d_id=" & p_id
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="没有找到您要续费的dns":exit function
		strdomain=trim(rs("strdomain"))
		regdate=rs("regdate")
		if lcase(trim(rs("proid")))="dns001" then '''''''''免费dns
					dnsbind=isbindings(strdomain,byear,regdate)
					if dnsbind then''''''''''''没有绑定
						if cint(byear)<cint(RenewYear) then
							rs.close:errstr="此DNS的续费年限不能大于"&byear&"年":exit function
						end if
						'p_prices=0
					end if
		end if
		checkdns=true
	rs.close
end Function

%>
