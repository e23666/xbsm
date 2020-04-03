<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/yunmail_class.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->  
<%
if not Check_as_Master(6) then die echojson(500,"无权操作","")
response.Charset="gb2312" 
dim act,appid,userid,app
conn.open constr
act=requesta("act")

select case trim(act)
	case "del":delmail()
	case "syn":syn()
	case "update":update()
	case "synlist":synlist()
	Case "upyun":upyun()
	case else
		die echojson(500,"未知操作!","")
end Select 

sub syn()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","参数错误","")
	set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	if not  yun.isnext then die echojson("500",yun.errarr(0),"")
	yun.setmailid=m_id
	if not  yun.isnext then die echojson("500",yun.errarr(0),"")
	call yun.mysynmail
	if yun.isnext then
		die echojson("200","同步数据成功","")
	Else
		die echojson("500",yun.errarr(0),"")
	end if
end sub
sub update()
	m_productid=requesta("m_productid")
	alreadypay=requesta("alreadypay")
	preday=requesta("preday")
	m_years=requesta("m_years")
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","参数错误","")
	if m_productid="yunmail" then
		if not isnumeric(alreadypay&"") or not isnumeric(preday&"") then die echojson("500","参数错误","")
		if alreadypay<0 or preday<0 then die echojson("500","参数错误","")
		sql="update mailsitelist set alreadypay="&alreadypay&",preday="&preday&",m_expiredate=dateadd("&PE_DatePart_D&","&preday&",dateadd("&PE_DatePart_M&","&alreadypay&",m_buydate)) where m_sysid="&m_id
	else
		if not isnumeric(m_years&"") then die echojson("500","参数错误","")
		if m_years<0 then die echojson("500","参数错误","")
		sql="update mailsitelist set m_years="&m_years&",m_expiredate=dateadd("&PE_DatePart_Y&","&m_years&",m_buydate) where m_sysid="&m_id
	end if
	conn.execute(sql)
	 die echojson(200,"执行成功!","")
end sub

sub delmail()
	m_id=requesta("m_id")
	userid=requesta("userid")
	if not isnumeric(m_id&"") then die echojson("500","参数错误","")
	if not isnumeric(userid&"") then die echojson("500","参数错误","")
	conn.execute("delete from mailsitelist where m_sysid="&m_id&" and m_ownerid="&userid)
    die echojson(200,"执行成功!","")
end sub

Sub upyun()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","参数错误","")
	set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	if not  yun.isnext then die echojson("500",yun.errarr(0),"")
	yun.setmailid=m_id
	yun.upyun()
	if yun.isnext then
		die echojson("200","执行成功","")
	Else
		die echojson("500",yun.errarr(0),"")
	end if

End sub
sub synlist()
	m_id=requesta("m_id")
	if not isnumeric(m_id&"") then die echojson("500","参数错误","")
	set yun=new yunmail_class
	yun.setuid=session("u_sysid")
	if not  yun.isnext then die echojson("500",yun.errarr(0),"")
	set p=newoption()
	p.add "para",m_id
	p.add "isdomain",0

	yun.synmail(p)
	if yun.isnext Then
		If CDbl(yun.lastmid)>0 Then Call setloastdmid("mailid",yun.lastmid) 
		die echojson("200","执行成功",",""m_id"":"&yun.lastmid&"")
	Else
		die echojson("500",yun.errarr(0),"")
	end if
end Sub 
%>