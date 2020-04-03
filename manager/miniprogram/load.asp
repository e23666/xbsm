<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/miniprogram_class.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->  
<%
response.Charset="gb2312" 
conn.open constr
dim app,act,appid
act=requesta("act")






select case trim(act)
	case "getsmscount":getsmscount()
	case "buysms":buysms()
	case "setremark":setremark()
	case "setrepwd":setrepwd()
	case "getpwd":getpwd()
	case "getmanager":getmanager()
	case "renew":renew()
	case "renewapp":renewapp()
	case "getallprice":getallprice()
	case "getproductids":getproductids()
	case "addnewproduct":addnewproduct()
	case "renewonlyapp":renewonlyapp()
	case "syn":syn()
	case else
		die echojson("500","未知操作","")
end select

sub syn()
	call setminiprogram()
	if app.synappid(0) then 
	 	die echojson(200,"ok",",""appid:"":"&app.okmsg)	
	 else
	 	die echojson("500",app.errmsg,"")
	 end if
end sub
'添加独立APP
sub addnewproduct()
	call setminiprogram()
	id=requesta("id")
	addyear=Requesta("year")
	paytype=requesta("paytype")
	if not isnumeric(id&"") or not isnumeric(addyear&"") or not isnumeric(paytype) then die echojson(500,"参数有误","")
	if app.appAddNew(id,addyear,paytype) then
		die echojson(200,"ok","")	
	else
		die echojson("500",app.errmsg,"")
	end if
end sub

sub renewonlyapp()
	call setminiprogram()
	id=requesta("id")
	addyear=1
	paytype=0
	if not isnumeric(id&"") or not isnumeric(addyear&"") or not isnumeric(paytype) then die echojson(500,"参数有误","")
	if app.appAddNew(id,addyear,paytype) then
		die echojson(200,"ok","")	
	else
		die echojson("500",app.errmsg,"")
	end if
end sub

sub getproductids()
	
	 call setminiprogram()
	 if app.getAppList() then
	 	die echojson(200,"ok",",""datas"":"&aspjsonPrint(app.okmsg))	
	 else
	 	die echojson("500",app.errmsg,"")
	 end if
end sub
sub getallprice()
	 call setminiprogram()
	 if app.getallprice() then
		die echojson(200,"ok",",""datas"":"&aspjsonPrint(app.okmsg))	
	 else
	 	die echojson("500",app.errmsg,"")
	 end If
end sub

sub renew()
 
	 call setminiprogram()
	 ids=requesta("otherids") 
	 renyear=requesta("renyear")

	if not isnumeric(renyear&"") then die echojson(500,"续费年限有误","")
	 if app.renew(renyear,ids) then
		die echojson(200,"续费成功","")
	 else
	 	die echojson("500",app.errmsg,"")
	 end if 
end sub

'单个应用续费 
sub renewapp()
	dim id,renyear
 	call setminiprogram()
	id=requesta("id")
	renyear=requesta("renyear")
	if not isnumeric(id&"") then die echojson(500,"参数错误","")
	if not isnumeric(renyear&"") then die echojson(500,"续费年限有误","")
	if app.renewapp(renyear,id) then
		die echojson(200,"ok",",""password"":"""&app.okmsg&"""")
	else
		die echojson("500",app.errmsg,"")
	end if 
end sub


'获取管理地址
Sub getmanager()
   call setminiprogram()
   if app.getmanager() then
		response.redirect(app.okmsg) 
   else
		die echojson("500",app.errmsg,"")
   end if 
End Sub

sub setminiprogram()
	appid=requesta("appid")
	if	not isnumeric(appid&"") then die echojson(500,"APPid错误","")
	set app=new miniprogram
	app.setuid=session("u_sysid")
	if trim(app.errmsg)<>"" then die echojson("500",app.errmsg,"")
	app.setAppid=appid
	If trim(app.errmsg)<>"" Then die echojson(500,app.errmsg,"") 
	 app.setproid=app.db_proid
	If trim(app.errmsg)<>"" Then die echojson(500,app.errmsg,"") 
end sub
 
Sub getpwd()
   call setminiprogram()
   if app.getpwd() then
		die echojson(200,"ok",",""password"":"""&app.okmsg&"""")
   else
		die echojson("500",app.errmsg,"")
   end if 
End Sub

Sub setrepwd()
   call setminiprogram()
   if app.setrepwd() then
		die echojson(200,"ok",",""password"":"""&app.okmsg&"""")
   else
		die echojson("500",app.errmsg,"")
   end if 
End Sub

Sub setremark()
	call setminiprogram()
	remark=requesta("remark")
	sql="update wx_miniprogram_app set bakAppName='"&remark&"' where appid="&app.db_appid&" and userid="&app.user_sysid
	conn.execute(sql)
	die echojson(200,"ok","")
End Sub

sub getsmscount()
	call setminiprogram()
	if app.getsmscount() then 
		die echojson("200","",",""count"":"&app.okmsg&"")
	else
		die echojson("500",app.errmsg,"")
	end if	
end sub


 

sub buysms()
	num=requesta("num") 
	if not isnumeric(num&"") then die echojson("500","短信数量错误","")
	call setminiprogram()
	if app.buysms(num) then 
		die echojson("200","",",""count"":"&app.okmsg&"")
	else
		die echojson("500",app.errmsg,"")
	end if	 
end sub
%> 