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
				alterstr="���������ɹ�<br>" & _
						 "FTP��:"& s_comment & _
						 "<br>��<b>"& s_ProductId &"</b>������<b>" & TargetT & "</b>"
										 
				echoString alterstr,"r"
			else
				echoString "��������ʧ�� "& returnstr ,"e"
			end if
	case "mail"
	    
 
	

			if not checkmail(p_id,TargetT,m_bindname,s_ProductId,errstr) then url_return errstr,-1
				returnstr=putUP("mail",m_bindname,TargetT,updateType,session("user_name"))
				if left(returnstr,3)="200" then
					alterstr="�ʾ������ɹ�<br>" & _
							 "�ʾ�����:"& m_bindname & _
							 "<br>��<b>"& s_ProductId &"</b>������<b>" & diyshowok(TargetT) & "</b>"
											 
					echoString alterstr,"r"
				else
					echoString "�ʾ�����ʧ�� "& returnstr ,"e"
				end if
		 
	case "mssql"
		if not checkdata(p_id,TargetT,dbname,s_ProductId,errstr) then url_return errstr,-1
			returnstr=putUP("mssql",dbname,TargetT,updateType,session("user_name"))
			if left(returnstr,3)="200" then
				alterstr="MSSQL�����ɹ�<br>" & _
						 "MSSQL��:"& dbname & _
						 "<br>��<b>"& s_ProductId &"</b>������<b>" & TargetT & "</b>"
										 
				echoString alterstr,"r"
			else
				echoString "MSSQL����ʧ�� "& returnstr ,"e"
			end if
	case else
		url_return "���ݲ�������",-1
end select

function checkup()
	if not isnumeric(p_id) then url_return "��ѡ����Ҫ�����Ĳ�Ʒ",-1
	if trim(TargetT)&""="" then url_return "��ѡ������������",-1
	if updateType<>"NewupdateType" and updateType<>"OldupdateType" then url_return "��ѡ��������ʽ",-1
end function

Function checkhost(byval p_id,byval TargetT,byref s_comment,byref s_ProductId,byref errstr)
	checkhost=false
	Sql="Select * from vhhostlist where s_sysid=" & p_id & " and S_ownerid=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "δ�ҵ�������":exit function
	s_ProductId=Rs("s_ProductId")	'ԭ�ͺ�
	s_comment=rs("s_comment")		'վ����
	rs.close
	
	if TargetT=s_ProductId or TargetT="b000" then errstr = "����ѡ�������ͺ�����":exit function
	pSql="Select top 1 * from productlist where p_type=1 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "δ�ҵ�������������":exit function
    
	rs.close
	
	checkhost=true
end function
Function checkmail(byval p_id,byval TargetT,byref m_bindname,byref s_ProductId,byref errstr)
	checkmail=false
	Sql="Select * from mailsitelist where m_sysid=" & p_id & " and m_ownerid=" & Session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "δ�ҵ����ʾ�":exit function
	s_ProductId=Rs("m_productid")	'ԭ�ͺ�
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
	
	if TargetT=s_ProductId  then errstr = "����ѡ�������ͺ�����":exit function
	pSql="Select top 1 * from productlist where p_type=2 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "δ�ҵ�������������":exit function
    
	rs.close
	
	checkmail=true
end function
Function checkdata(byval p_id,byval TargetT,byref dbname,byref s_ProductId,byref errstr)
	checkdata=false
	Sql="select * from databaselist where dbsysid="& p_id &" and dbu_id=" & session("u_sysid")
	Rs.open Sql,conn,1,1
	if Rs.eof then rs.close:errstr = "δ�ҵ���mssql":exit function
	s_ProductId=Rs("dbproid")	'ԭ�ͺ�
	dbname=rs("dbname")		
	rs.close
	
	if TargetT=s_ProductId  then errstr = "����ѡ�������ͺ�����":exit function
	pSql="Select top 1 * from productlist where p_type=7 and p_proId='" & TargetT & "'"
    rs.open pSql,conn,1,1
	if rs.eof then rs.close:errstr = "δ�ҵ�������������":exit function
    
	rs.close
	
	checkdata=true
end function

function diyshowok(t)
if instr(t,":")>0 then
temp=split(t,":")
diyshowok=temp(1)&"�û�,ÿ�û�"&formatSizeText(temp(0))
else
diyshowok=t
end if
end function
%>