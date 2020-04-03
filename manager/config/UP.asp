<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<%
response.buffer=true
response.charset="gb2312"
conn.open constr
TargetT=lcase(trim(requesta("TargetT")))
p_id=requesta("p_id")
productType=lcase(trim(requesta("productType")))
updateType=trim(requesta("updateType"))
 

	if trim(requesta("MailSize"))<>"" and trim(requesta("userNum"))<>"" then
		 MailSize=trim(requesta("MailSize"))
		 userNum=trim(requesta("userNum"))
		 TargetT=MailSize&":"&userNum
		end if

call checkup()
select case lcase(productType)
	case "host"
		if not checkhost(p_id,TargetT,s_comment,s_ProductId,errstr) then url_return errstr,-1
			returnstr=putUP("vhost",s_comment,TargetT,updateType,session("user_name"))
			if left(returnstr,3)="200" then
				alterstr="主机升级成功<br>" & _
						 "FTP名:"& s_comment & _
						 "<br>从<b>"& s_ProductId &"</b>升级到<b>" & TargetT & "</b>"
										 
				echoString alterstr,"r"
			else
				echoString "主机升级失败 "& returnstr ,"e"
			end if
	case "mail"
	    
 
	

			if not checkmail(p_id,TargetT,m_bindname,s_ProductId,errstr) then url_return errstr,-1
				returnstr=putUP("mail",m_bindname,TargetT,updateType,session("user_name"))
				if left(returnstr,3)="200" then
					alterstr="邮局升级成功<br>" & _
							 "邮局域名:"& m_bindname & _
							 "<br>从<b>"& s_ProductId &"</b>升级到<b>" & diyshowok(TargetT) & "</b>"
											 
					echoString alterstr,"r"
				else
					echoString "邮局升级失败 "& returnstr ,"e"
				end if
		 
	case "mssql"
		if not checkdata(p_id,TargetT,dbname,s_ProductId,errstr) then url_return errstr,-1
			returnstr=putUP("mssql",dbname,TargetT,updateType,session("user_name"))
			if left(returnstr,3)="200" then
				alterstr="MSSQL升级成功<br>" & _
						 "MSSQL名:"& dbname & _
						 "<br>从<b>"& s_ProductId &"</b>升级到<b>" & TargetT & "</b>"
										 
				echoString alterstr,"r"
			else
				echoString "MSSQL升级失败 "& returnstr ,"e"
			end if
	case else
		url_return "传递参数错误",-1
end select

function checkup()
	if not isnumeric(p_id) then url_return "请选择您要升级的产品",-1
	if trim(TargetT)&""="" then url_return "请选择新主机类型",-1
	if updateType<>"NewupdateType" and updateType<>"OldupdateType" then url_return "请选择升级方式",-1
end function

Function checkhost(byval p_id,byval TargetT,byref s_comment,byref s_ProductId,byref errstr)
	checkhost=false
	Sql="Select * from vhhostlist where s_sysid=" & p_id & " and S_ownerid=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "未找到此主机":exit function
	s_ProductId=Rs("s_ProductId")	'原型号
	s_comment=rs("s_comment")		'站点名
	rs.close
	
	if TargetT=s_ProductId or TargetT="b000" then errstr = "不能选择自身型号升级":exit function
	pSql="Select top 1 * from productlist where p_type=1 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "未找到升级到的类型":exit function
    
	rs.close
	
	checkhost=true
end function
Function checkmail(byval p_id,byval TargetT,byref m_bindname,byref s_ProductId,byref errstr)
	checkmail=false
	Sql="Select * from mailsitelist where m_sysid=" & p_id & " and m_ownerid=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "未找到此邮局":exit function
	s_ProductId=Rs("m_productid")	'原型号
	m_bindname=rs("m_bindname")	
	'm_productId=rs("m_productId")
	rs.close
	if s_ProductId="diymail" then
    t=split(TargetT,":")
    mjg=getDiyMailprice(t(0),t(1))
	if mjg>0 and mjg<>999999999 then
     checkmail=true
	end if
    exit function
	end if
	
	if TargetT=s_ProductId  then errstr = "不能选择自身型号升级":exit function
	pSql="Select top 1 * from productlist where p_type=2 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "未找到升级到的类型":exit function
    
	rs.close
	
	checkmail=true
end function
Function checkdata(byval p_id,byval TargetT,byref dbname,byref s_ProductId,byref errstr)
	checkdata=false
	Sql="select * from databaselist where dbsysid="& p_id &" and dbu_id=" & session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "未找到此mssql":exit function
	s_ProductId=Rs("dbproid")	'原型号
	dbname=rs("dbname")		
	rs.close
	
	if TargetT=s_ProductId  then errstr = "不能选择自身型号升级":exit function
	pSql="Select top 1 * from productlist where p_type=7 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "未找到升级到的类型":exit function
    
	rs.close
	
	checkdata=true
end function

function diyshowok(t)
if instr(t,":")>0 then
temp=split(t,":")
diyshowok=temp(1)&"用户,每用户"&formatSizeText(temp(0))
else
diyshowok=t
end if
end function
%>