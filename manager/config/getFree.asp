<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>获取赠品</title>
</head>
<%
freetype=requestf("freetype")	'mail/host
freeident=requestf("freeident") '赠品类别
p_id=requestf("p_id")			'产品id
conn.open constr
	 domainFree=false
	 hostFree=false
	 mssqlFree=false
	 
if not checkFreeall(errstr1,freeName,freeproid1,freeproid2,freeproid3,freeproid4) then url_return errstr1,-1
select case Trim(lcase(freeident))
case "domain"
		if not domainFree then url_return FreeName & "-没有赠品或已获得赠品",-1
		f_content=  "gift:true" & vbcrlf & _
			    	"attach-type:" & freetype & vbcrlf & _
					"attach-ident:" & freeName & vbcrlf
		call setdatabase(freetype,freeName,freeproid1,f_content,randid)
		response.redirect "/services/domain/default.asp?freeid="& randid
		response.end
case "vhost"
		if not hostFree then url_return FreeName & "-没有赠品或已获得赠品",-1
		f_content=  "gift:true" & vbcrlf & _
			    	"attach-type:" & freetype & vbcrlf & _
					"attach-ident:" & freeName & vbcrlf
		call setdatabase(freetype,freeName,freeproid2,f_content,randid)
		response.redirect "/services/webhosting/buy.asp?freeid="& randid
		response.end
case "mssql"
		if not mssqlFree then url_return FreeName & "-没有赠品或已获得赠品",-1
		f_content=  "gift:true" & vbcrlf & _
			    	"attach-type:" & freetype & vbcrlf & _
					"attach-ident:" & freeName & vbcrlf
		call setdatabase(freetype,freeName,freeproid4,f_content,randid)
		response.redirect "/services/mssql/buy.asp?freeid="& randid
		response.end
end select

function checkFreeall(byref errstr,byref freeName,byref freeproid1,byref freeproid2,byref freeproid3,byref freeproid4)
	checkFreeall=false
	if freetype="" then errstr="赠品依附类型错误":conn.close:exit function
	if freeident="" then errstr="赠品依附产品标识错误":conn.close:exit function
	if p_id="" or not isnumeric(p_id) then errstr="产品ID错误":conn.close:exit function
	 
	select case lcase(trim(freetype))
		case "host"'关于主机的赠品
			 preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4,b.s_comment,b.s_buydate from protofree a inner join vhhostlist b on (b.s_buytest="&PE_False&" and a.proid=b.s_productId and b.s_ownerid=" & session("u_sysid") & " and b.s_sysid=" & p_id & " and a.type='host') where not exists(select sysid from protofree where b.s_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='host')"
			rs.open preSql,conn,1,1
			if rs.eof and rs.bof then errstr="没有找到此产品":rs.close:conn.close:exit function
			freeName=rs("s_comment")
			s_buydate=rs("s_buydate")
		case "mail"
			preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4,b.m_bindname,b.m_buydate from protofree a inner join mailsitelist b on (b.m_buytest="&PE_False&" and a.proid=b.m_productId and b.m_ownerid=" & session("u_sysid") & " and b.m_sysid=" & p_id & " and a.type='mail') where not exists(select sysid from protofree where b.m_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='mail')"
			rs.open preSql,conn,1,1
			if rs.eof and rs.bof then errstr="没有找到此产品":rs.close:conn.close:exit function
			freeName=rs("m_bindname")
			s_buydate=rs("m_buydate")
		case else
			errstr="赠品依附类型暂不支持":conn.close:exit function
	end select

			if len(trim(rs("pre1")&""))=0 and len(rs("freeproid1")&"")>0 and dateDiff("d",s_buydate,date)<=15 and isgetFreeProduct(trim(freetype),freeName,rs("freeproid1")) then	domainFree=true
			if len(trim(rs("pre2")&""))=0 and len(rs("freeproid2")&"")>0 and isgetFreeProduct(trim(freetype),freeName,rs("freeproid2"))  then hostFree=true
			if len(trim(rs("pre3")&""))=0 and len(rs("freeproid3")&"")>0 and isgetFreeProduct(trim(freetype),freeName,rs("freeproid3"))  then mysqlFree=true
			if len(trim(rs("pre4")&""))=0 and len(rs("freeproid4")&"")>0 and isgetFreeProduct(trim(freetype),freeName,rs("freeproid4"))  then mssqlFree=true
			freeproid1=rs("freeproid1")
			freeproid2=rs("freeproid2")
			freeproid3=rs("freeproid3")
			freeproid4=rs("freeproid4")
			rs.close

	checkFreeall=true
end function

function setdatabase(byval freetype,byval freeName,byval freeproid,byval f_content,byref randid)
	nowTime=now()
	randid=year(nowTime)& month(nowTime) & day(nowTime) & hour(nowTime) & minute(nowTime) & second(nowTime) & session.sessionid & Round(timer())
	f_content=f_content & "attach-randid:" & randid & vbcrlf
	conn.execute "delete from free where f_username='"& session("user_name") &"' and f_isget="&PE_False&""
	conn.execute "insert into free (f_type,f_freeName,f_freeproid,f_randid,f_content,f_username) values ('"& freetype &"','"& freeName &"','"& freeproid &"','"& randid &"','"& f_content &"','"& session("user_name") &"')"
end function
%>
<body>
</body>
</html>
