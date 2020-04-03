<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%conn.open constr
response.Charset="gb2312"
%>
var username="<%=session("user_name")%>";
var userinfo=<%=getjsoninfo()%>;<%
function getjsoninfo()
	if trim(session("user_name"))<>"" then
	set g_rs=conn.execute("select top 1 * from UserDetail where u_name='"&session("user_name")&"'")
			if not g_rs.eof then
			j_u_name=g_rs("u_name")
			j_u_namecn=g_rs("u_namecn")
			j_u_level=g_rs("u_level")
			j_u_company=g_rs("u_company")
			j_u_telphone=Trim(g_rs("u_telphone"))
			j_u_email=Trim(g_rs("u_email"))
			j_u_address=Trim(g_rs("u_address"))
			j_u_fax=Trim(g_rs("u_fax"))
			j_u_trade=Trim(g_rs("u_trade"))
			j_u_mobile=Trim(g_rs("msn_msg"))
			j_qq_msg=Trim(g_rs("qq_msg"))
			j_u_zipcode=Trim(g_rs("u_zipcode"))
			end if
	end if
	if trim(j_u_level)="" then j_u_level=1
	

	
	if session("userinfo")<>"" then
	'die session("userinfo")
	set jsoninfo=parseJSON(session("userinfo"))
			j_u_namecn=Trim(jsoninfo.u_namecn)	 
			j_u_company=Trim(jsoninfo.u_company)
			j_u_telphone=Trim(jsoninfo.u_telphone)
			j_u_email=Trim(jsoninfo.u_email)
			j_u_address=Trim(jsoninfo.u_address)
			j_u_fax=Trim(jsoninfo.u_fax)
			j_u_trade=Trim(jsoninfo.u_trade)
			j_u_mobile=Trim(jsoninfo.u_mobile)
			j_qq_msg=Trim(jsoninfo.qq_msg)
			j_u_zipcode=Trim(jsoninfo.u_zipcode)
	end if
	
	select case clng(j_u_level)
	case 1
	userzk=diyuserlev1
	case 2
	userzk=diyuserlev2
	case 3
	userzk=diyuserlev3
	case 4
	userzk=diyuserlev4
	case 5
	userzk=diyuserlev5
	case 6
	userzk=diyuserlev6
	case 7
	userzk=diyuserlev7
	case else
	userzk=200
	end select
	
	
	
	
	
	
getjsoninfo="{""u_name"":"""&j_u_name&""",""u_namecn"":"""&j_u_namecn&""",""u_level"":"""&j_u_level&""",""u_company"":"""&j_u_company&""",""u_telphone"":"""&j_u_telphone&""",""u_email"":"""&j_u_email&""",""u_address"":"""&j_u_address&""",""u_fax"":"""&j_u_fax&""",""u_trade"":"""&j_u_trade&""",""u_mobile"":"""&j_u_mobile&""",""qq_msg"":"""&j_qq_msg&""",""u_zipcode"":"""&j_u_zipcode&""",""userzk"":"""&userzk&""",""diyfist"":"""&diyfist&"""}"
end function
%>