<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/class/diyserver_Class.asp" --> 
<%


'jsonstr="{"&trim(GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp"))&"}"
'set json=parseJSON(jsonstr)
isupdate=false

conn.open constr
response.Charset="gb2312"
'session("u_levelid")
 




set ds=new diyserver_class
jsonstr=ds.returnJson()
set json=parseJSON(jsonstr)
 
 
cpulist=json.cpulist  '.getcpulist(cpucount)
ramlist=json.ramlist            '.getramlist(ramcount)
act=requesta("act")
cpucount=json.cpucount
ramcount=json.ramcount


 


if act="buysub" then
ds.user_sysid=session("u_sysid")
ds.setProid="ebscloud"
 
ds.getPostvalue()
	ds.isfast=false
	if ds.errstr<>"" then
		 url_return ds.errstr,-1
	else
		ds.VPSOpen=true
		ds.buysub("new")
		
		if ds.errstr<>"" then 
			if instr(ds.errstr,"验证手机")>0 then
				alert_redirect ds.errstr,"/usermanager/"
			elseif instr(ds.errstr,"余额不足")>0 then
				session("needpaymoney")=ds.paytestPrice
				alert_url "抱歉，试用收费为"& ds.paytestPrice &"元，您帐号上的余额不足，请先充值，点确定后将转入充值中心","/customercenter/howpay.asp"
			else
				url_return ds.errstr,-1
			end if
		end if
	end if


end If
 
 
			call setHeaderAndfooter()
			call setcloudhostLeft()
			ishasoem=false
			sql="select 1 from productlist where left(p_proid,6)='oemyun'"
			rs.open sql,conn,1,1
			if not rs.eof then
				ishasoem=true
			end if
			rs.close
			 ishasoem=false
			if ishasoem then
				tpl.set_file "main", USEtemplate&"/services/cloudhost/default_oem.html"
			else
				tpl.set_file "main", USEtemplate&"/services/cloudhost/default.html"
			end if
			tpl.set_var "servicetype",getservicetype(true),false
			tpl.set_var "cpulist",json.cpulist,false
			tpl.set_var "cpucount",json.cpucount,false

			tpl.set_var "ramlist",ramlist,false
			tpl.set_var "ramcount",ramcount,false
			tpl.set_var "getserverRoom",json.room,false
			tpl.set_var "getCHOICE_OS",replace(json.os&"","/newimages/","/images/"),false
			tpl.set_var "getVpsPayMethod",json.payment,false
			tpl.set_var "paytestprice",json.paytestprice,false
			tpl.set_var "user_name",session("user_name"),false
			tpl.set_var "diyjson",jsonstr,false
			tpl.set_var "userinfo",getjsoninfo(),false
			tpl.set_var "getdisktype",json.disktype,false
			tpl.set_var "useripmsg",getIpAddressType_(GetuserIp(),getIpAddressMsg),false

			tpl.set_function "main","ServerName","tpl_function_name"
			tpl.set_function "main","ServerMEM","tpl_function_mem"
			tpl.set_function "main","ServerHD","tpl_function_hd"
			tpl.set_function "main","ServerRoomList","GetCloudPriceRoom"
			tpl.set_function "main","Price","tpl_function"


			tpl.parse "mains","main",false
			htmlstr=tpl.vP("mains")
			set tpl=nothing
			application("services_cloudhost_html_"&session("u_levelid"))=htmlstr
			application("services_cloudhost_sj")=now()
 

die htmlstr

function getjsoninfo()
	if trim(session("user_name"))<>"" then
	set g_rs=conn.execute("select top 1 * from UserDetail where u_name='"&session("user_name")&"'")
			if not g_rs.eof then
			j_u_name=g_rs("u_name")
			j_u_namecn=g_rs("u_namecn")
			j_u_level=g_rs("u_level")
			j_u_company=g_rs("u_company")
			j_u_telphone=g_rs("u_telphone")
			j_u_email=g_rs("u_email")
			j_u_address=g_rs("u_address")
			j_u_fax=g_rs("u_fax")
			j_u_trade=g_rs("u_trade")
			j_u_mobile=g_rs("msn_msg")
			j_qq_msg=g_rs("qq_msg")
			j_u_zipcode=g_rs("u_zipcode")
			end if
	end if
	if trim(j_u_level)="" then j_u_level=1
	

	
	if session("userinfo")<>"" then
	'die session("userinfo")
	set jsoninfo=parseJSON(session("userinfo"))
	 	
			j_u_namecn=jsoninfo.u_namecn
		 
			j_u_company=jsoninfo.u_company
			j_u_telphone=jsoninfo.u_telphone
			j_u_email=jsoninfo.u_email
			j_u_address=jsoninfo.u_address
			j_u_fax=jsoninfo.u_fax
			j_u_trade=jsoninfo.u_trade
			j_u_mobile=jsoninfo.u_mobile
			j_qq_msg=jsoninfo.qq_msg
			j_u_zipcode=jsoninfo.u_zipcode
	
	
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

function getservicetype(byval isvps)
result="  <div class=""margin5""><input type=""radio"" name=""servicetype"" value=""基础服务"" checked><a href=""/services/server/vip.asp"" target=""_blank""  title=""基础服务""><font color=""#333"">基础服务</font>&nbsp;&nbsp;免费(适合专业级客户，不提供人工技术支持)</a><a href=""/services/server/vip.asp"" class=""Link_Blue biaozhun""  target=""_blank"" title=""查看服务标准"">查看服务标准</a></div>" & _
    "<div class=""margin5""><input type=""radio"" name=""servicetype"" value=""铜牌服务"" ><a href=""/services/server/vip.asp"" target=""_blank""  title=""铜牌服务""><font color=""#333"">铜牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("铜牌服务",isvps) &"元/月(适合一般客户，提供标准技术支持)</a><a href=""/services/server/vip.asp"" class=""Link_Blue biaozhun""  target=""_blank"" title=""查看服务标准"">查看服务标准</a></div>" & _
	"<div class=""margin5""><input type=""radio"" name=""servicetype"" value=""银牌服务""><a href=""/services/server/vip.asp"" target=""_blank""  title=""银牌服务""><font color=""#333"">银牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("银牌服务",isvps) &"元/月(适合初级客户，提供优先技术支持)</a><a href=""/services/server/vip.asp"" class=""Link_Blue biaozhun""  target=""_blank"" title=""查看服务标准"">查看服务标准</a></div>" & _
    "<div class=""margin5""><input type=""radio"" name=""servicetype"" value=""金牌服务""><a href=""/services/server/vip.asp"" target=""_blank""   title=""金牌服务""><font color=""#333"">金牌服务</font>&nbsp;&nbsp;加"&  getOtherPrice("金牌服务",isvps) &"元/月(适合VIP客户，提供全方位技术支持)</a><a href=""/services/server/vip.asp"" class=""Link_Blue biaozhun""  target=""_blank"" title=""查看服务标准"">查看服务标准</a></div>"
	getservicetype=result
end function
%>