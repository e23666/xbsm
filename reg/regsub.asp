<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/md5_16.asp" -->
<%
response.Charset="gb2312"
if reguser_try=true then '��ע����û��ܷ����á�
	Auditing=0
	else
	Auditing=1
end if
conn.open constr

	u_class=Requesta("u_class")
	u_province=trim(Requesta("u_province"))
	u_password=left(trim(Requesta("u_password")),20)
	u_passwordmail=u_password
	u_name=Requesta("u_name")
	
    if isBad(u_name,u_password,errinfo) then url_return replace(replace(errinfo,"ftp�û���","��Ա�ʺ�"),"�û���","�û���"),-1
	If not checkRegExp(u_name,"^[0-9a-zA-Z\u4e00-\u9fa5_-]{4,18}$") Then  url_return  "��¼��4-18λ�ʺ�",-1
	u_company=trim(Requesta("u_company"))
	u_address=trim(Requesta("u_address"))
	u_contry=trim(requesta("u_contry"))
	u_email=trim(requesta("u_email"))
	u_telphone=trim(requesta("u_telphone"))
	u_father=trim(session("bizbid"))
	u_namecn=trim(Requesta("u_namecn"))
	u_ip=getuserip()
	sql="select count(1) from UserDetail where datediff("&PE_DatePart_S &",u_regdate,"&PE_Now&") between -600 and 1000 and u_ip='"&u_ip&"'" 
	If CDbl(conn.execute(sql)(0))>1 Then url_return  "ip���ƽ�ע��",-1

	msn = trim(Requesta("msn"))
	
	u_city=trim(requesta("u_city"))
	u_zipcode=trim(requesta("u_zipcode"))
	u_meetonce=Trim(Requesta("u_meetonce"))
	u_nameen=trim(Requesta("u_nameen"))
	qq=trim(Requesta("qq"))
	u_fax=trim(requesta("u_fax"))
	session("ad_user")=trim(Requesta("u_know_from"))
	u_trade=trim(requesta("u_trade"))
	
	
	question=requesta("question")
	myquestion=requesta("myquestion")
	answer=requestf("answer")
	if question="�ҵ��Զ�������" then question=myquestion
	if question="" then 
		question=" "
		answer=" "
	end if
	if u_city="" then u_city=" "
	if u_zipcode="" then u_zipcode=" "
	if u_meetonce="" then u_meetonce=0
	if u_nameen="" then u_nameen=" "
	if qq="" then qq=" "
	if u_fax="" then u_fax=" "
	if u_trade="" then u_trade=" "
	
	If session("ad_user")="" Then session("ad_user")="other"
	if Session("Ads")<>"" then Session("ad_user")=Session("Ads")
	if u_class="�����û�" then 
      u_company=u_namecn
	end if
	u_contract=u_namecn
	
	
	

if ucase(left(u_name,3))=ucase("qq_") then
url_return "��Ǹ���ʺŲ�����qq_��ͷ!",-1

response.End()
end if	
	
	
	
	
	if len(u_company)<=4 and u_class<>"�����û�" then url_return "��Ǹ���û�������ѡ�񡰸����û���",-1
'--------------------------
checkHZ1 "�û�����",u_namecn,2
if u_address<>"" then
checkHZ2 "��ϸ��ַ",u_address,6
end if
'-----------------------
 DomainString=replace(Request("server_name"),"'","")
 
if inStr(DomainString,"www.")>0 then
    Start=inStr(DomainString,".")+1
  else
	Start=1
  end if
 RightString=mid(DomainString,Start)
if Lcase(RightString)="west263.com" then
	centerString="west263com"
elseif Lcase(RightString)="west263.org" then
	centerString="west263org"
elseif Lcase(RightString)="west263.com.cn" then
	centerString="cmodeuser"
elseif Lcase(RightString)="localhost" then
	centerString="west263com"
else

   centerString=left(RightString,inStr(RightString,".")-1)
   'die centerString
end if
	if session("ModeCDomain")<>"" and centerString<>"west263com" and centerString<>"cmodeuser" and centerString<>"west263org" then
		centerString=session("ModeCDomain")
	end if




	Sql="Select u_id from fuser where C_dCenter='" & centerString & "'"
	Rs.open Sql,conn,1,1
	if Session("ModeD")<>"" then
		f_id=Session("ModeD")
	elseif not Rs.eof then
		f_id=Rs("u_id")
	else
		f_id=0
	end if
	Rs.close

'-----------------------

	rs.open "select * from UserDetail where u_name='"& u_name &"'" ,conn,3
	If not rs.eof Then
			rs.close
			conn.close
		Alert_Redirect "�Բ��𣬴��û��ѱ�ע�ᣬ��ѡ���������û�����","javascript:history.back()"
	end if
	rs.close
	
	u_password =md5_16(u_password)

	If u_name="" Then Response.Write "�������"&u_name:Response.End
	 sql="select * from userdetail where u_name='"& u_name &"'"
	 rs.open sql,conn,1,3
	 if rs.eof and rs.bof then
	 	rs.addnew
	 	rs("u_password")=u_password
		rs("u_province")=u_province
		rs("u_fax")=u_fax
		rs("u_name")=u_name
		rs("u_zipcode")=u_zipcode
		rs("u_company")=u_company
		rs("u_introduce")=u_introduce
		rs("u_contract")=u_contract
		rs("u_address")=u_address
		rs("u_trade")=u_trade
		rs("u_contry")=u_contry
		rs("u_email")=u_email
		rs("u_city")=u_city
		rs("u_telphone")=u_telphone
		rs("u_website")=u_website
		rs("u_employees")=u_employees
		rs("u_know_from")=session("ad_user")
		rs("u_namecn")=u_namecn
		rs("u_nameen")=u_nameen
		rs("u_operator")=u_operator
		rs("qq_msg")=qq
		rs("msn_msg")=msn'�ֻ���
		rs("u_ip")=u_ip
		rs("f_id")=f_id
		rs("u_class")=u_class
		rs("u_meetonce")=u_meetonce
		rs("u_question")=u_question
		rs("u_answer")=u_answer
		rs("u_type")=0
		rs("u_level")=reguser_level '��ע����û��ļ���
		rs("u_levelname")=getlevelname(reguser_level)
		rs("u_Auditing")=Auditing '��ע����û��ܷ�����
		

		rs.update
	 else
	 	url_return "���û���ע��,������ѡ��һ���û���",-1
	 end if
	 rs.close
		
  		user_name=u_name
		getStr="password=" & u_passwordmail & "," & _
			  "companyname=" & companyname & "," & _
			  "user_name=" & user_name & "," & _
			  "companynameurl=" & companynameurl & "," & _
			  "companyaddress=" & companyaddress & "," & _
			  "supportmail=" & supportmail & "," & _
			  "postcode=" & postcode & "," & _
			  "telphone=" & telphone & "," & _
			  "oicq=" & oicq
		mailbody=redMailTemplate("regsub.txt",getStr)
		call setuserSession(u_name)
		call sendMail(u_email,"ע��ɹ�! ��ӭ����Ϊ"&companyname&"�û�!",mailbody)
		call setuserDomaincnPrice() '��ע���û��ؼ�
		
		'''''''''''''''''''''''''''''''''''����ģ��'''''''''''''''''
			Call setwebhostingLeft()
			call setHeaderAndfooter()
			call setregsubLeft()
			tpl.set_file "main", USEtemplate&"/reg/regsub.html"
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
		
conn.close


function getlevelname(byval levelid)
	'on error resume next
	getlevelname="ֱ�ӿͻ�"
	levelid=clng(levelid)
	sql="select l_name from levellist where l_level=" & levelid
	set trs=conn.execute(sql)
	if not trs.eof then getlevelname=trs("l_name")
	trs.close
end function

Function getradpassword()
	Dim i, intNum, intUpper, intLower, intRand, strPartPass, genPassword
	genPassword = ""
	'�����������;
	Randomize
	For i = 1 to 8
		intNum = Int(10 * Rnd + 48)
		intUpper = Int(26 * Rnd + 65)
		intLower = Int(26 * Rnd + 97)
		intRand = Int(3 * Rnd + 1)
		Select Case intRand
		  Case 1
			strPartPass = Chr(intNum)
		  Case 2
			strPartPass = Chr(intUpper)
		  Case 3
			strPartPass = Chr(intLower)
		End Select
		genPassword = genPassword & strPartPass
	Next
	getradpassword = genPassword
End Function
Sub checkHZ1(strTitle,message,minLen)
     if len(message)<minLen then
		Response.write "<script language=javascript>alert('����" & strTitle & "Ҫ�������" & minLen & "���ַ�����,����������');history.back();</script>"
		Response.end
	 end if
	for i=1 to len(message)
	tempChar=mid(message,i,1)
	if Abs(asc(tempChar))<=127 then 
		Response.write "<script language=javascript>alert('����" & strTitle & "Ҫ�����ȫ���Ǻ���,����������');history.back();</script>"
		Response.end
	end if
    next
end Sub

Sub checkHZ2(strTitle2,message2,minLen2)
     if len(message2)<minLen2 then
		Response.write "<script language=javascript>alert('����" & strTitle2 & "Ҫ�������" & minLen2 & "���ַ�����,����������');history.back();</script>"
		Response.end
	 end if
		hasHZ=false
		for i=1 to len(message2)
			if Abs(asc(mid(message2,i,1)))>127 then
				 hasHZ=true
				 exit for
			end if
		next
		if not hasHZ then 
			Response.write "<script language=javascript>alert('����" & strTitle2 & "Ҫ�������д����,����������');history.back();</script>"
			Response.end
		end if
end Sub

function setuserDomaincnPrice()
		set urs=conn.execute("select top 1 u_id from userdetail where u_name='"& trim(u_name) &"'")
		if not urs.eof then
			u_id=urs("u_id")
			
			
			psql="select * from Pricelevellist where p_level="& reguser_level
			set pRs=conn.execute(psql) 
			if not pRs.eof then
				do while not pRs.eof
					p_proid=pRs("p_proid")
					p_price=pRs("p_price")
					conn.execute "insert into userprice(proid,proprice,u_id) values('"& p_proid &"','"& p_price &"',"& u_id &")"
				pRs.movenext
				loop
			end if
			pRs.close
			set pRs=nothing
			
		end if
		urs.close
		set urs=nothing
end function
%>