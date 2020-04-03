<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/miniprogram_class.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->  
<%
if not Check_as_Master(6) then die echojson(500,"无权操作","")
response.Charset="gb2312" 
dim act,appid,userid,app
conn.open constr
act=requesta("act")

select case trim(act)
    case "getsmscount":getsmscount()  
	case "getpwd":getpwd()
	case "getmanager":getmanager()
	case "guohu":guohu()
	case "synlist":synlist()
	Case "del":del()
	case else
		die echojson(500,"未知操作!","")
end select
function formatnum(byval str)
	set arr_=newarray()
	for each k in split(str)
		if isnumeric(k&"") then
			arr_.push(k)
		end if
	next
	formatnum=arr_.join(",")
end function

Sub del()
	appid=requesta("appid")
	if not isnumeric(appid&"") then die echojson(500,"APPID有误!","")
	conn.execute("delete from wx_miniprogram_app where appid="&appid&"")
	 die echojson(500,"操作成功!","")
End sub
sub synlist()
	appid=requesta("appid")
	if not isnumeric(appid&"") then die echojson(500,"APPID有误!","")
	set app=new miniprogram  
	app.setuid=session("u_sysid")
	if trim(app.errmsg)<>"" then die echojson("500",app.errmsg,"")
	app.db_appid=appid
	if app.synappid(1) then
		die echojson(200,"ok",",""appid"":"&app.okmsg)
	else
		die echojson("500",app.errmsg,"")
	end if
end sub
sub guohu()
	appids=formatnum(requesta("appids"))
	gh_u_name=requesta("gh_u_name")
	set chkrs=conn.execute("select top 1 u_id from userdetail where u_name='"&gh_u_name&"'")
	if chkrs.eof then  chkrs.close:die echojson(500,"未找到过户会员 ","") 
	u_id=chkrs("u_id"):chkrs.close
	if trim(appids&"")="" then die echojson(500,"过户APPID有误["&appids&"]","") 
	set ars=Server.createObject("adodb.recordset")
	sql="select * from wx_miniprogram_app where userid<>"&u_id&" and appid in("&appids&")"
	ars.open sql,conn,1,3
	do while not ars.eof
		olduserid=ars("userid")
		dbappid=ars("appid")
		ars("userid")=u_id
		call Add_Event_logs(session("user_name"),5,dbappid,"所有者变更到["&gh_u_name&"]["&olduserid&"]")
	ars.movenext
	loop
	ars.close:set ars=nothing
	die echojson(200,"操作成功","")
end sub

sub checkapp()
	appid=requesta("appid")
	if not isnumeric(appid&"") then die echojson(500,"APPID有误!","")
	set ars=conn.execute("select top 1 * from wx_miniprogram_app where appid="&appid)
	if ars.eof then die echojson(500,"无权操作 ","")
	userid=ars("userid")
	ars.close:set ars=nothing
	set app=new miniprogram
	app.setuid=userid
	if trim(app.errmsg)<>"" then die echojson("500",app.errmsg,"")
	app.setAppid=appid
	If trim(app.errmsg)<>"" Then die echojson(500,app.errmsg,"") 
		app.setproid=app.db_proid
	If trim(app.errmsg)<>"" Then die echojson(500,app.errmsg,"") 
end sub

sub getsmscount() 
	call checkapp()
	if app.getsmscount() then 
		die echojson("200","",",""count"":"&app.okmsg&"")
	else
		die echojson("500",app.errmsg,"")
	end if	
end sub

Sub getpwd()
 	call checkapp()
   if app.getpwd() then
		die echojson(200,"ok",",""password"":"""&app.okmsg&"""")
   else
		die echojson("500",app.errmsg,"")
   end if 
End Sub

sub getmanager()
	call checkapp()
    if app.getmanager() then
		response.redirect(app.okmsg) 
   else
		die echojson("500",app.errmsg,"")
   end if 
end sub 
%>