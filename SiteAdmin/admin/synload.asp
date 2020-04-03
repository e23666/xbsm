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
	case "synvhostlist":synvhostlist()
	Case "syndatabase":syndatabase()
	Case "synserver":synserver()
	case else
		die echojson(500,"未知操作!","")
end Select 


Sub synserver()
	serverid=requesta("serverid")
	if not isnumeric(serverid&"") then die echojson("500","参数错误","")
	strcmd="other"&vbcrlf&_
			"get"&vbcrlf&_
			"entityname:syn"&vbcrlf&_
			"ywname:server"&vbcrlf&_
			"islist:1"&vbcrlf&_
			"id:"&serverid&vbcrlf&_
			"."&vbcrlf 
	loadRet=connectToUp(strcmd)  
	 
	if left(loadRet,3)="200" Then
		objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}"  
		set obj_=jsontodic(objstr) 
		adminUname=getAdminUname()
		set ars=Server.CreateObject("adodb.recordset")
		lastvhostid=0
		for each line_ in obj_("datas")
			lastvhostid=line_("id")
 		    sql="select top 1 * from HostRental  where AllocateIP='" & line_("allocateip") &"'"
			ars.open sql,conn,1,3
			if ars.eof then
				ars.addnew()
				ars("u_name")=adminUname 
				ars("AllocateIP")=line_("allocateip")
			end If
				ars("HostID")=line_("hostid")
				ars("OS")=line_("os")
				ars("CPU")=line_("cpu")
				ars("MainBoard")=line_("mainboard")
				ars("HardDisk")=line_("harddisk")
				ars("Memory")=line_("memory")
				ars("SubmitTime")=line_("submittime")
				ars("StartTime")=line_("starttime")
				ars("Years")=line_("years")
				ars("Start")=IIF(line_("start")="True",PE_True,PE_False)
				ars("PayMethod")=line_("paymethod") 
				ars("hosttype")=line_("hosttype") 
				ars("RamdomPass")=line_("ramdompass") 
				ars("addedServer")=line_("addedserver") 
				ars("p_proid")=line_("p_proid") 
				ars("preday")=line_("preday") 
				ars("flux")=line_("flux") 
				ars("disktype")=line_("disktype") 
				ars("buytest")=line_("buytest")
				ars("AlreadyPay")=line_("alreadypay")
				ars("serverRoom")=line_("serverroom")
				ars("MoneyPerMonth")=line_("moneypermonth")
				ars("osharddisk")=iif(Not isnumeric(line_("osharddisk")&""),30,line_("osharddisk"))
				ars("prodtype")=line_("prodtype")
			ars.update
			ars.close 

		Next
			If CDbl(lastvhostid)>0 Then Call setloastdmid("serverid",lastvhostid) 
		die echojson("200","执行成功",",""serverid"":"&lastvhostid&"")
	Else
		die echojson("500",loadRet,"")
	End If 
End Sub

Sub syndatabase()
	databaseid=requesta("databaseid")
	if not isnumeric(databaseid&"") then die echojson("500","参数错误","")
	strcmd="other"&vbcrlf&_
			"get"&vbcrlf&_
			"entityname:syn"&vbcrlf&_
			"ywname:database"&vbcrlf&_
			"islist:1"&vbcrlf&_
			"id:"&databaseid&vbcrlf&_
			"."&vbcrlf 
	loadRet=connectToUp(strcmd)  
	if left(loadRet,3)="200" Then
		objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}" 
		set obj_=jsontodic(objstr)  
		AdminUid=getAdminUid()
		set ars=Server.CreateObject("adodb.recordset")
		lastvhostid=0
		for each line_ in obj_("datas")
			lastvhostid=line_("dbsysid")
 			sql="select top 1 * from databaselist  where dbname='" & line_("dbname") &"'"
			ars.open sql,conn,1,3
			if ars.eof then
				ars.addnew()
				ars("dbu_id")=AdminUid
				ars("dbname")=line_("dbname")
			end If
				ars("dbloguser")=line_("dbloguser")
				ars("dbsize")=line_("dbsize")
				ars("dbpasswd")=line_("dbpasswd")
				ars("dbbuydate")=line_("dbbuydate")
				ars("dbexpdate")=line_("dbexpdate")
				ars("dbproid")=line_("dbproid")
				ars("dbyear")=line_("dbyear")
				ars("dbstatus")=line_("dbstatus")
				ars("dbserverip")=line_("dbserverip") 
				ars("dbbuytest")=IIF(line_("dbbuytest")="True",PE_True,PE_False)
			ars.update
			ars.close 

		Next
			If CDbl(lastvhostid)>0 Then Call setloastdmid("dbid",lastvhostid) 
		die echojson("200","执行成功",",""databaseid"":"&lastvhostid&"")
	Else
		die echojson("500",loadRet,"")
	End If 

End sub

'同步虚拟主机
sub synvhostlist()
	vhostid=requesta("vhostid")
	if not isnumeric(vhostid&"") then die echojson("500","参数错误","")

	strcmd="other"&vbcrlf&_
			"get"&vbcrlf&_
			"entityname:syn"&vbcrlf&_
			"ywname:vhhost"&vbcrlf&_
			"islist:1"&vbcrlf&_
			"id:"&vhostid&vbcrlf&_
			"."&vbcrlf

	loadRet=connectToUp(strcmd)  
 
	if left(loadRet,3)="200" Then
		objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}" 
		set obj_=jsontodic(objstr) 
		AdminUid=getAdminUid()
		set ars=Server.CreateObject("adodb.recordset")
		lastvhostid=0
		for each line_ in obj_("datas")
				lastvhostid=line_("s_sysid")
				sql="select top 1 * from vhhostlist  where s_comment='" & line_("s_comment") &"'"
			 	ars.open sql,conn,1,3
				if ars.eof then
					ars.addnew()
					ars("S_ownerid")=AdminUid
					ars("s_comment")=line_("s_comment")
				end If
					ars("s_bindings")=line_("s_bindings")
					ars("s_ProductId")=line_("s_productid")
					ars("s_year")=line_("s_year")
					ars("s_buydate")=line_("s_buydate")
					ars("s_expiredate")=line_("s_expiredate")
					ars("s_SiteState")=line_("s_sitestate")
					ars("s_buydate")=line_("s_buydate")
					ars("s_cert")=line_("s_cert")
					ars("s_ssl")=line_("s_ssl")
					ars("s_sslset")=line_("s_sslset")
					ars("s_serverIP")=line_("s_serverip")
					ars("s_serverName")=line_("s_servername")
					ars("s_other_ip")=line_("s_other_ip")
					ars("s_buytest")=IIF(line_("s_buytest")="True",PE_True,PE_False)
				ars.update
				ars.close 
		Next
		If CDbl(lastvhostid)>0 Then  Call   setloastdmid("vhostid",lastvhostid)  
		die echojson("200","执行成功",",""vhostid"":"&lastvhostid&"")
	Else
		die echojson("500",loadRet,"")
	End If 
end Sub 

function getAdminUid()
	 
		sql="select top 1 u_id from UserDetail where u_type='111111' order by u_id asc"
		set glrs=conn.execute(sql)
		if not glrs.eof then 
		adminuserid=glrs(0)
		end if
		glrs.close:set grlrs=nothing
		getAdminUid=adminuserid
	end Function
function getAdminUname()
 
	sql="select top 1 u_name from UserDetail where u_type='111111' order by u_id asc"
	set glrs=conn.execute(sql)
	if not glrs.eof then 
	getAdminUname=glrs(0)
	end if
	glrs.close:set grlrs=nothing
	getAdminUname=getAdminUname
end function
%>