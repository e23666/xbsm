<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
Response.Charset="GB2312"
conn.open constr
newcheckstr="^((����)|(����)|(����)|(ת��)|(����Ա)|(�Ұ���)|(����)|(׬Ǯ)|(����)|(��ˮ)|(N\/A)|(NA)|(Domain Whois Protect)|(webmaster)|\d)$"		  'ע�����ϲ������ùؼ���(������ʽ)
checkdomainStr="aoyun,2008,89"'�������ùؼ���(���ŷָ�)
'������
If requesta("act")="sub" Then
	If trim(session("u_sysid"))&""="" Then die echojson(500,"δ��½���ܴ���","")
	if session("transferdomain").count=0 then  die echojson(500,"��¼��ת�����������","")
	strdomain=requesta("1")
	chgdns=requesta("3")
	mobanid=requesta("2")
	If Not isdomain(strdomain) Or Not isnumeric(mobanid&"") Then  die echojson(500,"��������!","")
	If chgdns&""<>"1" Then chgdns=0
	If Not session("transferdomain").Exists(strdomain&"") Then  die echojson(500,"��������!","")
    dpwd=Replace(session("transferdomain")(strdomain&""),"��","~")
	dPrice=getDnametjg(strdomain) 
	set drs=Server.CreateObject("adodb.recordset")

	 sql="select top 1 * from domainlist where strDomain='"&strdomain&"'"
	 drs.open sql,conn,1,3
	 if drs.eof then
		 'ת�������۷Ѳ���
		 if consume(session("user_name"),dPrice,true,"transfer_in("&strdomain&")","����ת��["&strdomain&"]",GetDomainType(strdomain),"") Then
			 drs.addnew
			 drs("strDomain")=strdomain
			 drs("proid")=GetDomainType(strdomain)
			 drs("rsbdate")=now()
			 drs("regdate")=now()
			 drs("years")=0
			 drs("rexpiredate")=now()
			 drs("tran_state")=0
			 drs("userid")=session("u_sysid")
			 drs.update

			 strcmd="domainname"&vbcrlf&_
					"transfer"&vbcrlf&_
					"entityname:request"&vbcrlf&_
					"domain:"&strdomain&vbcrlf&_
					"authcode:"&dpwd&vbcrlf&_
					"mobanid:"&mobanid&vbcrlf&_
					"chdns:"&chgdns&vbcrlf&_ 
					"."&vbcrlf 
			 loadRet=connectToUp(strcmd)
			  if left(loadRet,3)="200" then
				  crdate=getReturn(loadRet,"crdate")
				  exdate=getReturn(loadRet,"exdate")
				  years=getReturn(loadRet,"years")
				  sql="update  domainlist set regdate='"&crdate&"',rexpiredate='"&exdate&"',years="&years&",tran_state=1  where strDomain='"&strdomain&"' and userid="&session("u_sysid")
				  conn.execute(sql)
				  die echojson(200,"ת������ɹ�","")
			  ElseIf InStr(loadRet,"ת���������")>0 Then 
				'������Զ��ת��ʧ��
				  call addRec("������"&dname&"��ת��ʧ��,�û��ѿۿ�,ת������["&dpwd&"]",loadRet) 
				  die echojson(500,"�û��ѿۿ�,ת���������","") 
			  else
				  '������Զ��ת��ʧ��
				  call addRec("������"&dname&"��ת��ʧ��,�û��ѿۿ�,ת������["&dpwd&"]",loadRet) 
				  die echojson(200,"ת������ɹ�","")	
			  end If 
		 Else
			die echojson(500,"ת������ʧ��,�۷�ʧ��!","")

	     End If	   
	  Else
			call  addRec("������"&dname&"��ת��ʧ��","���ݿ��Ѿ����ڣ�")
			die echojson(500,"ת������ʧ��,�����Ѿ�����","")	 
	  End If 
End If

if requesta("act")="save" then
die "no used"
If trim(session("u_sysid"))&""="" Then
	response.write "<script language=javascript>parent.location.href='/login.asp';</script>"
	response.end	
end if



	'���ת�������Ƿ����
	if not isobject(session("transferdomain")) then
	    die url_return("��¼��ת�����������1",-2)
	else
		if session("transferdomain").count=0 then 
		die url_return("��¼��ת�����������",-2)	
		end if
	end if
	chgdns=session("chgdns")
	     dom_org=CheckInputType(trim(Requesta("dom_org")),"^[\w\.\,\s]{4,100}$","Ӣ������������",false)
		dom_fn=CheckInputType(trim(Requesta("dom_fn")),"^[\w\.\s]{2,30}$","Ӣ����",false)
		dom_ln=CheckInputType(trim(Requesta("dom_ln")),"^[\w\.\s]{2,30}$","Ӣ����",true)
		 dom_org_m=domainChinese(trim(requesta("dom_org_m")),2,100,"����������")
		dom_fn_m=CheckInputType(trim(Requesta("dom_fn_m")),"^[\u4e00-\u9fa5]{1,4}$","������",true)
		dom_ln_m=CheckInputType(trim(Requesta("dom_ln_m")),"^[\u4e00-\u9fa5]{1,6}$","������",true)
		dom_em=CheckInputType(trim(Requesta("dom_em")),"^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$","�������",false)
		'ת������:���-->�۷�-->��״̬--->�ϴ�����-->��״̬
		
	a=session("transferdomain").Keys
	for i=0 to session("transferdomain").count-1
         dname=trim(a(i))    'ת������
		 dPrice=getDnametjg(a(i))    'ת��۸�
		 dpwd=session("transferdomain").item(replace(a(i)&"","��","~"))
		 
		 set drs=Server.CreateObject("adodb.recordset")
		 sql="select top 1 * from domainlist where strDomain='"&dname&"'"
		 drs.open sql,conn,1,3
		 '�����ڼ�¼����������
		 if drs.eof then
				 'ת�������۷Ѳ���
				 if consume(session("user_name"),dPrice,true,"transfer_in("&dname&")","����ת��["&dname&"]",GetDomainType(dname),"") then
				 
				 drs.addnew
					 drs("strDomain")=dname
					 drs("proid")=GetDomainType(dname)
					 drs("dom_org")=dom_org
					 drs("dom_fn")=dom_fn
					 drs("dom_ln")=dom_ln
					 drs("dom_org_m")=dom_org_m
					 drs("dom_fn_m")=dom_fn_m
					 drs("dom_ln_m")=dom_ln_m
					 drs("dom_em")=dom_em
					 drs("rsbdate")=now()
					 drs("regdate")=now()
					 drs("years")=0
					 drs("rexpiredate")=now()
					 drs("tran_state")=0
					 drs("userid")=session("u_sysid")
				     drs.update 
 					 strcmd="domainname"&vbcrlf&_
							"transfer"&vbcrlf&_
							"entityname:request"&vbcrlf&_
							"domain:"&dname&vbcrlf&_
							"authcode:"&dpwd&vbcrlf&_
							"chdns:"&chgdns&vbcrlf&_
							"dom_org_m:"&dom_org_m&vbcrlf&_
							"dom_ln_m:"&dom_ln_m&vbcrlf&_
							"dom_fn_m:"&dom_fn_m&vbcrlf&_
							"dom_org:"&dom_org&vbcrlf&_
							"dom_ln:"&dom_ln&vbcrlf&_
							"dom_fn:"&dom_fn&vbcrlf&_
							"dom_em:"&dom_em&vbcrlf&_
							"."&vbcrlf
				          loadRet=connectToUp(strcmd)
						  if left(loadRet,3)="200" then
						  crdate=getReturn(loadRet,"crdate")
						  exdate=getReturn(loadRet,"exdate")
						  years=getReturn(loadRet,"years")
						  sql="update  domainlist set regdate='"&crdate&"',rexpiredate='"&exdate&"',years="&years&",tran_state=1  where strDomain='"&dname&"' and userid="&session("u_sysid")
						  conn.execute(sql)
						  msg=msg&"��"&dname&"��ת������ɹ�!\n"
 						  else
						  '������Զ��ת��ʧ��
						  call addRec("������"&dname&"��ת��ʧ��,�û��ѿۿ�",loadRet)
						  msg=msg&"��"&dname&"��ת������ɹ�!\n"
						  end if
    				 
				 else
    			 msg=msg&"��"&dname&"��ת������ʧ��,�۷�ʧ��!\n"
				 end if
		 
		else
		  call  addRec("������"&dname&"��ת��ʧ��","���ݿ��Ѿ����ڣ�")
		  msg=msg&"��"&dname&"��ת������ʧ��,�����Ѿ�����!\n"
		end if 
	next 
		
		
    
 die Alert_Redirect(msg&"\n�������������Ա","/services/domain/transfer.asp")
end if


dim iszr
iszr=false
if request.QueryString("t")<>"input" then
	myMoban=USEtemplate&"/services/domain/transfer.html"
else
	myMoban=USEtemplate&"/services/domain/transfer_data.html"
	if not isobject(session("transferdomain")) then
	    die url_return("��¼��ת�����������1",-2)
	else
		if session("transferdomain").count=0 then 
		die url_return("��¼��ת�����������",-2)	
		end if
	end if
	iszr=true
end if

call setHeaderAndfooter()
call setdomainLeft()
tpl.set_file "main", myMoban
tpl.set_var "mydomain",domain,false
tpl.set_var "myauthcode",authcode,false
tpl.set_var "mychgdns",chgdns,false
tpl.set_var "myoldregistrar",oldregistrar,false
tpl.set_var "transferTable",getTransfertable,false

if iszr then
'�����滻
if trim(session("chgdns"))="1" then
tpl.set_var "dns_host1",ns1,false
tpl.set_var "dns_ip1",ns1_ip,false
tpl.set_var "dns_host2",ns2,false
tpl.set_var "dns_ip2",ns2_ip,false
else
tpl.set_var "dns_host1","",false
tpl.set_var "dns_ip1","",false
tpl.set_var "dns_host2","",false
tpl.set_var "dns_ip2","",false
end if

'�����滻����

'ת�������ͼ۸���ʾ
	tpl.set_block "main","dnamelistzr","dnamelist"
	a=session("transferdomain").Keys
	sumprice=0
	for i=0 to session("transferdomain").count-1
		price=getDnametjg(a(i))
		sumprice=ccur(sumprice)+ccur(price)
		tpl.set_var "bh",i+1,false
		tpl.set_var "dname", a(i),false
		tpl.set_var "dnamejg",price,false
		tpl.parse "dnamelist", "dnamelistzr", true
	next 
	
tpl.set_var "sumprice",sumprice,false
end if

tpl.parse "mains","main",false
tpl.p "mains" 
%>
<!--#include virtual="/config/class/tpl.asp" --> 
<%
set tpl=nothing


 

function getTransfertable()
getTransfertable="ss"
getTransfertable="<table width=""100%"" border=0 align=center cellPadding=3 cellSpacing=1 class=""border""> <tr>"&vbcrlf
getTransfertable=getTransfertable&"<td align=""center"" valign=""middle"" class=""Title"">ת��������Ʒ����</td>"&vbcrlf
getTransfertable=getTransfertable&"<td align=""center"" valign=""middle"" class=""Title"">��Ʒ���</td>"&vbcrlf
  '  set lrs=conn.execute("select top 5 * from levellist order by l_level asc")
'	do while not lrs.eof 
 '  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"" >"&lrs("l_name")&"</td>"&vbcrlf
   
'	lrs.movenext
'	loop
'	lrs.close
  
  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"" >����ת��۸�</td>"&vbcrlf
  i=1
  set prs=conn.execute("select p_name,P_proId from productlist where P_proId in('"&replace(DomainTransfer,",","','")&"')")
  do while not prs.eof
 
 if i mod 2=0 then
 tbg="bgcolor=""#EAF5FC"""
 else
 tbg=""
 end if
 
 getTransfertable=getTransfertable&" <tr "&tbg&">"&vbcrlf
    getTransfertable=getTransfertable&"  <td align=""center"" valign=""middle"">"&prs("p_name")&" </td>"&vbcrlf
     getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&prs("P_proId")&"</td>"&vbcrlf
	 
	 if session("u_levelid")<>"" then
	 getTransfertable=getTransfertable&" <td align=""center"" valign=""middle""><span class=""price"">"&getDnameTransfer(prs("P_proId"),session("u_levelid"))&"</span>   Ԫ</td>"&vbcrlf
	 else
	getTransfertable=getTransfertable&" <td align=""center"" valign=""middle""><span class=""price"">"&getDnameTransfer(prs("P_proId"),1)&"   </span>Ԫ</td>"&vbcrlf 
	 end if
	 
    '  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),1)&"   Ԫ</td>"&vbcrlf
'    getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),2)&"   Ԫ</td>"&vbcrlf
'	 getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),3)&"   Ԫ</td>"&vbcrlf
'	  getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),4)&"   Ԫ</td>"&vbcrlf
'	   getTransfertable=getTransfertable&" <td align=""center"" valign=""middle"">"&getDnameTransfer(prs("P_proId"),5)&"   Ԫ</td>"&vbcrlf
  	   getTransfertable=getTransfertable&"</tr>"
 
  i=i+1
  prs.movenext
  loop
  	   getTransfertable=getTransfertable&" </table>"

end function



function CheckInputType(byval values,byval reglist,byval errinput,byval pd)
	if not checkRegExp(values,reglist) then
		conn.close
		url_return errinput & "��ʽ����",-1
	else
		
		if pd then
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "���ܺ��н��ùؼ���",-1
			end if
		end if
		
	end if
	CheckInputType=values
end function
function domainChinese(byval values,byval flen,byval llen,byval errinput)
	if len(values)<=llen and len(values)>=flen then
		if not ischinese(values) then
			conn.close
			url_return errinput & "�躬������",-1
		else
			if checkRegExp(values,newcheckstr) then
				conn.close
				url_return errinput & "���ܺ��н��ùؼ���",-1
			end if
		end if
	else
		conn.close
		url_return errinput & "�ַ�����Ӧ��" & flen & "-" & llen & "֮��",-1
	end if
	domainChinese=values
end function
sub checkdmbuydomain()'��ȫ����
	if not isAlldomain(strdomain,errstr1) then url_return errstr1,-1
end sub
%>