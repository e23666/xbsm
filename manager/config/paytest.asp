<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.buffer=true
response.charset="gb2312"
conn.open constr
p_id=requesta("p_id")
productType=trim(requesta("productType"))
call checktest()
select case lcase(productType)
	case "vhost"
		if not checktesthost(p_id,s_comment,errstr) then url_return errstr,-1
		call testhost(s_comment)
	case "mail"
		if not checktestmail(p_id,m_bindname,errstr) then url_return errstr,-1
		call testmail(m_bindname)
	case "mssql"
		if not checktestmssql(p_id,dbname,errstr) then url_return errstr,-1
		call testmssql(dbname)
	case else
		url_return "���ݲ�������",-1
end select
function checktest()
	if not isnumeric(p_id) or p_id="" then url_return "��ѡ����Ҫת���Ĳ�Ʒ",-1
end function
Function checktesthost(byval p_id,byref s_comment,byref errstr)
	checktesthost=false
	sqlstring="SELECT * FROM vhhostlist where s_buytest="&PE_True&" and S_ownerid=" &  session("u_sysid") & " and s_sysid=" & p_id
	
	rs.open sqlstring,conn,1,3
	if rs.eof and rs.bof then rs.close:errstr="û���ҵ���Ҫת������������":exit function
	s_year=requesta("buy_year")
if not isnumeric(s_year) or s_year="" or s_year<1 then s_year=1
	rs("s_year")=s_year
	rs.update
	s_comment=rs("s_comment")
	checktesthost=true
end function
function testhost(byval s_comment)
s_year=requesta("buy_year")
if not isnumeric(s_year) or s_year="" or s_year<1 then s_year=1
	commandstr= "vhost" & vbcrlf & _
				"paytest" & vbcrlf & _
				"entityname:vhost" & vbcrlf & _
				"sitename:"& s_comment &vbcrlf & _
				"s_year:"& s_year &vbcrlf & _
				"."& vbcrlf
				
				'die commandstr
		 
	returnstr=pcommand(commandstr,session("user_name"))
	if left(returnstr,3)="200" then
		alterstr="����ת���ɹ�<br>" & _
				 "FTP��:"& s_comment 
								 
		echoString alterstr,"r"
	else
		echoString "����ת��ʧ�� "& returnstr ,"e"
	end if
end function
Function checktestmssql(byval p_id,byref m_bindname,byref errstr)
	checktestmssql=false
	sqlstring="Select * from databaselist where dbbuytest="&PE_True&" and dbsysid=" & p_id & " and dbu_id=" & Session("u_sysid")
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="û���ҵ���Ҫת��������mssql":exit function
	m_bindname=rs("dbname")
	checktestmssql=true
end function
Function checktestmail(byval p_id,byref m_bindname,byref errstr)
	checktestmail=false
	sqlstring="Select * from mailsitelist where m_buytest="&PE_True&" and m_sysid=" & p_id & " and m_ownerid=" & Session("u_sysid")
	rs.open sqlstring,conn,1,1
	if rs.eof then rs.close:errstr="û���ҵ���Ҫת���������ʾ�":exit function
	m_bindname=rs("m_bindname")
	checktestmail=true
end function
function testmssql(byval dbdname)
	commandstr= "other" & vbcrlf & _
				"paytest" & vbcrlf & _
				"entityname:mssql" & vbcrlf & _
				"dbname:"& dbname &vbcrlf & _
				"."& vbcrlf
	returnstr=pcommand(commandstr,session("user_name"))
	if left(returnstr,3)="200" then
		alterstr="mssqlת���ɹ�<br>" & _
				 "mssql��:"& dbname								 
		echoString alterstr,"r"
	else
		echoString "mssqlת��ʧ�� "& returnstr ,"e"
	end if
end function
function testmail(byval m_bindname)
	commandstr= "other" & vbcrlf & _
				"paytest" & vbcrlf & _
				"entityname:mail" & vbcrlf & _
				"domain:"& m_bindname &vbcrlf & _
				"."& vbcrlf
	returnstr=pcommand(commandstr,session("user_name"))
	if left(returnstr,3)="200" then
		alterstr="�ʾ�ת���ɹ�<br>" & _
				 "�ʾ�����:"& m_bindname
								 
		echoString alterstr,"r"
	else
		echoString "�ʾ�ת��ʧ�� "& returnstr ,"e"
	end if
end function
%>
<body>
</body>
</html>
