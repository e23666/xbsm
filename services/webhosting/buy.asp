<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" -->   
<%
response.charset="gb2312"
conn.open constr
productid=trim(Requesta("productid"))
freeid=requesta("freeid")
isfree=getFreedatebase(freeid,f_freeproid,f_content)
room=trim(requesta("room"))
iptype=trim(requesta("iptype"))
if isfree then productid=f_freeproid
if iptype&""="" or not isnumeric(iptype) or isfree then iptype=0
module=trim(requesta("module"))
isAgent=false
newisMysql=false
ischecked=""
dim selectclassstr:selectclassstr=""
if lcase(USEtemplate)="tpl_2016" then
	selectclassstr="common-select std-width common-validate"
end if
if isnumeric(session("u_levelid")) and session("u_levelid")>1 then isAgent=true

SELECT CASE module
	   CASE "checkftpname"'���ftp�û���
			call checkftpname()
	   CASE "addshopcart" '����/�¶���
	         ftppwd=requesta("ftppassword")
			 ftpaccount=requesta("ftpaccount") 

			 pwderrstr=checkpwdcpx(ftppwd,ftpaccount,"FTP",8,50,5) 
			 If Trim(pwderrstr)<>"" Then issimple="true":die url_return(pwderrstr,-1) 
	   		call buyhost()
	   case "getneedprice"
	   		response.write buyHostpriceList()
			conn.close()
			response.End()
	   Case "getoslist"
		  
	      response.Write(setosList(room,productid))
          response.End()
	   case "getmysqllist"
		   osver=requesta("osver")
		   response.Write(setmysqlList(room,productid,osver))
          response.End()
END SELECT
tpl.set_unknowns "remove"
call setHeaderAndfooter()
call setwebhostingLeft()

If isdbsql Then
	sql="select top 1 *  from productlist where p_type=1 and p_proid='"& productID &"'"
else
	sql="select top 1 *  from productlist where p_type=1 and p_proid='"& productID &"' and iif(isNull(p_proid),0,1)<>0"
End if

rs.open sql,conn,1,1
if rs.eof and rs.bof then rs.close:conn.close:errpage "��Ǹ���ò�Ʒ������"
productName=rs("p_name")
p_size=rs("p_size")
p_iis=rs("p_maxmen")
p_traffic=rs("p_traffic")
p_test=rs("p_test")
p_picture = rs("p_picture")
if p_test="" or isnull(p_test) then p_test=1
if rs("p_server")=10 or rs("p_server")=14 or instr(productName,"mysql")>0 then newisMysql=true
if isSmaller(session("user_name")) and instr(productName,"��Ⱥ")>0 then url_return "��Ǹ�������û����ܹ���Ⱥ������Ʒ���빺����˾������Ʒ��лл��",-1
rs.close

 Sql="Select productlist.p_size as pf_size,productlist.p_maxmen as pf_user from productlist,protofree where productlist.p_proID=protofree.freeproid and protofree.proid='" & productid & "'"
Set MailRs=conn.Execute(Sql)
p_MailSize=0
p_MailUser=0
if not MailRs.eof then p_MailSize=MailRs("pf_size"):p_MailUser=MailRs("pf_user")
MailRs.close
Set MailRs=nothing
dim os_roomid
os_roomid=0
Dim buyinfo
buyinfo=Replace(aspjsonprint(get_cache_product_info(productid)),"{","{"&vbcrlf)
'die productid&"==>"&buyinfo
'''''''''''''''''''ģ��'''''''''''''''''''''''''''''''''
tpl.set_file "main", USEtemplate&"/services/webhosting/buy.html"
tpl.set_var "ismysql",newisMysql,false
tpl.set_var "productname",productName,false
tpl.set_var "productid",productid,false
tpl.set_var "freeid",freeid,false
tpl.set_var "p_mailsize",p_MailSize,False
if lcase(USEtemplate)="tpl_2016" then
'	tpl.set_var "setroomlist",setRoom(productid),False
'	tpl.set_var "xltinxing",xltinxing(),false
	'"<div style=""background-color:#ffc;margin:0"">"&xltinxing()&"</div>"&
else
	tpl.set_var "setroomlist","<div style=""background-color:#ffc;margin:0"">"&xltinxing()&"</div>"&setRoom(productid),False
End if
'tpl.set_var "setoslist",setosList(os_roomid,productid),false

'tpl.set_var "setmysqllist","<select name=""pmver"" class="""&selectclassstr&"""><option value="""" >Ĭ��ֵ</option></select>",false

tpl.set_var "agentJscript",agentjsscriptstr,false
tpl.set_var "p_size",p_size,false
tpl.set_var "buyHostpriceList",buyHostpriceList,false
tpl.set_var "isdisabled",isdisabledStr(newisMysql,buyischecked),false
tpl.set_var "ischecked",buyischecked,false
tpl.set_var "isTestDisabled",isTestDisabled(p_test),false
tpl.set_var "alertmessage",isdishost(productid),false
tpl.set_var "rndpass",createRnd(8),false
tpl.set_var "appname",session("u_contract"),false
tpl.set_var "appadd",session("u_address"),false
tpl.set_var "apptel",session("msn"),false
tpl.set_var "appEmail",session("u_email"),false











if isNumeric(demoprice) then
tpl.set_var "demoprice",demoprice,false
end if
'call setagentbuytable(isagent)

tpl.set_var "buyinfo",buyinfo,false

tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing

function isdishost(proid)
	if lcase(left(proid,1))<>"c" then
		isdishost="<strong><font color='#FF0000'>��ʾ</font></strong>��Ŀǰ������������<a href='http://BeiAn.vhostgo.com/' target='_blank'><strong><font color='green'>������</font></strong></a>��һ����Ҫ20��30���ʱ�䣬�󲿷�ʡ��Ҫ���ʼ���վ�������鵥ԭ�������迪ͨ��վ����ñ����鷳�Ŀͻ��Ƽ�����<a href='twhost.asp' target='_blank'><strong><font color='green'>��̨����</font></strong></a>�������á��Żݻ�����ڿռ��������һ����ʹ��ʱ�䣬��������URLת������Ͷ���������"
	else
		isdishost="<strong><font color='#FF0000'>֣����ʾ��</font></strong>Ϊ�˱�֤����Ⱥ�����ķ���Ʒ�ʣ���˾��Ⱥ������������ҵ�û����򣬸����û��빺����˾������Ʒ����Ⱥ�����ڰ�����ʱ������֤������������˾����ϵͳ�����ɹ��������쵥λ����Ϊ��ҵ�Ĳ��������������ֹ��ҡ�˽����Ϸ�����ܹ�������վ���򣬷������ùرղ����˿"
	end if
end function


function isTestDisabled(byVal myp_test)
	if isfree or instr(api_autoopen,"vhost")<=0 then
		isTestDisabled=" disabled "
	elseif instr(productName,"��Ⱥ")>0 then
		isTestDisabled=" disabled "
	else
		if myp_test=0 then
			isTestDisabled=" "
		else
			isTestDisabled=" disabled "
		end if
	end if
end function
function isdisabledStr(byval newisMysql,byref buyischecked)
	if  instr(api_autoopen,"vhost")<=0 then
		isdisabledStr=" checked "
		buyischecked= " disabled "
	else
		if isfree then
				isdisabledStr=" disabled "
				buyischecked=" checked "
		else
			if newisMysql then
				isdisabledStr=" disabled "
				buyischecked=" checked "
			else
				isdisabledStr="  "
				buyischecked=" checked"
			end if
		end if
	end if
end function
sub setagentbuytable(byval isagent)
	if isagent then
		tpl.set_file "agentbuytable",USEtemplate&"/config/webhostingLeft/agentbuytable.html"
		tpl.parse "#agentbuytable.html","agentbuytable",false
	end if
end sub
function agentjsscriptstr()
		jsStr = "if(document.form1.appEmail.value!=''){" & vbcrlf & _
				"if(!isEmail(document.form1.appEmail.value)){" & vbcrlf & _
				"alert ('\n\n��ϵ�û��������ʽ����');" & vbcrlf & _
				"document.form1.appEmail.focus();"& vbcrlf & _
				"return false;}}" & vbcrlf & _
				"if(document.form1.appTel.value!=''){" & vbcrlf & _
				"if(!isMobile(document.form1.appTel.value)){" & vbcrlf & _
				"alert ('\n\n��ϵ�û����ֻ������ʽ����');" & vbcrlf & _
				"document.form1.appTel.focus();" & vbcrlf & _
				"return false;}}" & vbcrlf & _
			
		agentjsscriptstr=jsStr
end function

function buyHostpriceList() 	
	 if isfree then
	  	hostpricelist=  "<select name=""years"" size=""1""  class="""&selectclassstr&""">" & vbcrlf & _
						"<option value=""1"">��Ʒ���/1��</option>" & vbcrlf & _
						"</select>"
	 else		 
			  selstr = getpricelist(session("user_name"),productid)
			  
			  if selstr<>"" then
				strArray=split(selstr,"|")
				if ubound(strArray)>=10 then
					
					oneyearsprice=strArray(0)
							hostpricelist ="<select name=""years"" size=""1""  class="""&selectclassstr&""">" & vbcrlf
		        dim  showtxt,xzli,ismypro
				xzli=0
				ismypro=false
				if instr(lcase(productid),"my_")=1 then
				ismypro=true
				end if
				showArray=split("2,��2����1��|3,��3����2��|5,��5����5��|10,��10����10��","|")
						  for each ii in split("0,1,2,4,9",",") 
							needPrice=strArray(ii)
							ipprice=0
							if iptype&""="1" then
							ipi=0
							     select case ii
								 case 1
								 ipi=2
								 case 2
								 ipi=3
								 case 4
								 ipi=5
								 case 9
								 ipi=10
								 case else
								 ipi=ii+1
								 end select
							
								if lcase(left(productid,2))="tw" then
									ipproid="twaddip"
									else
									ipproid="vhostaddip"
								end if

								 
									ipprice = GetNeedPrice(session("user_name"),ipproid,ipi,"new")
								 

								if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
								needPrice=cdbl(needPrice)+cdbl(ipprice)
								if ipprice>0 then saveStr="������IP"&ipprice&","&ipi&"��"
							end if
							savePrice=oneyearsprice*(ii+1)+ipprice-needPrice
							saveStr=""
							if savePrice>0 then saveStr="����ʡ:"& FormatNumber(savePrice,2,,,0) & "Ԫ��"	
							
							if not ismypro then   '�Զ���Ʒ��ʹ�û
								if xzli<=ubound(showArray) then
								showtemp=split(showArray(xzli),",")
									if clng(showtemp(0))=clng(ii+1) then
									showtxt="["&showtemp(1)&"]"
									xzli=xzli+1
									else
									showtxt=""
									end if
								end if
                            end if
							
'							if cstr(session("u_levelid"))="1" and clng(ii)=2 then
'							
'								if not ismypro then
'								hostpricelist = hostpricelist & "<option value="""& (ii+1) &""" selected style=""color:red"">"& FormatNumber(needPrice,2,,,0) & "Ԫ/" & (ii+1)& "��"& saveStr &""&showtxt&"��ǿ���Ƽ���</option>" & vbcrlf
'								else
'								hostpricelist = hostpricelist & "<option value="""& (ii+1) &""" >"& FormatNumber(needPrice,2,,,0) & "Ԫ/" & (ii+1)& "��"& saveStr &""&showtxt&"</option>" & vbcrlf
'								end if
'							else
							hostpricelist = hostpricelist & "<option value="""& (ii+1) &""">"& FormatNumber(needPrice,2,,,0) & "Ԫ/" & (ii+1)& "��"& saveStr &""&showtxt&"</option>" & vbcrlf	
						'	end if					
						next
							hostpricelist = hostpricelist & "</select>"
							if trim(session("user_name"))&""="" then hostpricelist = hostpricelist & "<div><font color=""#999999"">��û�е�½,��ֱ�ӿͻ���ݼ���۸�</font></div>"
				end if
			  end if
	 end if
 
  buyHostpriceList=hostpricelist
end function
sub checkftpname()
	if lcase(USEtemplate)="tpl_2016" then
		ftpname=trim(requesta("param"))
	Else
		ftpname=trim(requesta("ftpname"))
	End if
	ftpname=LCase(ftpname)
	
	if not checkhostnameIn(ftpname,errstr2) then
		
		if lcase(USEtemplate)="tpl_2016" then
			response.write errstr2
		Else
			response.write toerrStr(errstr2)
		response.write "<input type='hidden' name='isftppd' id='isftppd' value='0'>"
		End if
	
	Else
		if lcase(USEtemplate)="tpl_2016" then
			die "y"
		Else
			response.write torightStr("��ϲ,��ftp����ע��")
			response.write "<input type='hidden' name='isftppd' id='isftppd' value='1'>"
		End if
		
		
	end if
	response.end
end sub

sub buyhost()

dim ywtype,tyname


		newisMysql=false
		vyears=trim(Requesta("years"))
		ftpaccount=Lcase(trim(Requesta("ftpaccount")))
		ftppassword=trim(Requesta("ftppassword"))
		ftppassword1=trim(Requesta("ftppassword1"))
		domainnametop=trim(Requesta("domainnametop"))
		domainname=trim(Requesta("domainname"))
		pmver=trim(Requesta("pmver"))
		paytype=Requesta("paytype")
		room=requesta("room")
		oslist=requesta("oslist")
		newisMysql=Requesta("ismysql")
		domainall=domainnametop & "." & domainname

		pwderrstr=checkpwdcpx(ftppassword,ftpaccount,"FTP",8,50,5) 
		if Trim(pwderrstr)<>"" then url_return pwderrstr,-1

		if checkPassStrw(ftppassword) then url_return "�����к��в���ʶ����ַ������������á�",-1
		'������վ����Ϊ��ҵȫΪ
		cdntype=requesta("cdntype")
		cdntype=1
		if cdntype="" then
		'	url_return "��ѡ��������վ����",-1
		end if
		
		'if not checkRegExp(ftppassword,"^[\w]{5,20}$") then url_return "����ӦΪ��ĸ���ֻ�_���,������5-20λ֮��",-1
	  	'===================��ϵ��ʽ==================
		dllstr=""
	'	if isAgent then
		 s_appName=trim(requesta("appName"))
		 s_appAdd=trim(requesta("appAdd"))
		 s_appTel=trim(requesta("appTel"))
		 s_appEmail=trim(requesta("appEmail"))
		' dllstr="settouch:" & s_appName & "|" & s_appAdd & "|" &s_appTel & "|" & s_appEmail & vbcrlf
	'	end if

ywtype="vhost"
ywname=ftpaccount
		call needregSession()
		if not ischeckhost(ftpaccount,productid,vyears,paytype,errstr,p_name,p_maxmen,p_size,cdntype) then url_return errstr,-1		
		if paytype=2 then
				itemPrice=GetNeedPrice(session("user_name"),productid,1,"new")
				if isfree then url_return "��Ʒ���ܹ��¶���",-1
				Sql="Select MAX(id) as OrderID from PreHost"
				Rs.open Sql,conn,1,1
				if not isNumeric(Rs("OrderID")) then 
					OrderID=1
				else
					OrderID=Rs("OrderID")+1
				end if
				Rs.close
				Sql="Insert into PreHost (OrderNo,U_name,ftpAccount,ftpPassword,domains,years,proid,price,opened,sDate,s_appName,s_appAdd,s_appTel,s_appEmail,pmver,room,osvar) values ('" & OrderID &"','"& Session("user_name") & "','"& ftpaccount & "','" & ftppassword &"','" & domainall &"'," & vyears & ",'" & productid & "'," & itemPrice & ",0,"&PE_Now&",'" & s_appName & "','" & s_appAdd & "','" & s_appTel & "','" & s_appEmail & "','" & pmver & "','"& room &"','"&oslist&"')"
				conn.Execute Sql
				conn.close
				Response.redirect "/bagshow/orderlist.asp?orderid="& server.urlEncode(OrderID) & "&productType=host"
				response.end
		else
				if paytype="1" then domainall="":iptype=0
				if isInbagshow(ftpaccount,"vhost") then url_return "��ftp�����ڹ��ﳵ�д���,���ڹ��ﳵ��ɾ��",-1
				itemPrice=GetNeedPrice(session("user_name"),productid,vyears,"new")
				strContents = strContents & "vhost" & vbCrLf
				strContents = strContents & "add" & vbCrLf
				strContents = strContents & "entityname:vhost" & vbCrLf
				strContents = strContents & "producttype:" & productid & vbCrLf
				strContents = strContents & "years:" & vyears & vbCrLf
				strContents = strContents & "ftpuser:" & ftpaccount & vbCrLf
				strContents = strContents & "ftppassword:" & ftppassword & vbCrLf
				strContents = strContents & "cdntype:" & cdntype & vbCrLf
				strContents = strContents & "paytype:" & paytype & vbCrLf
				strContents = strContents & "domain:" & domainall & vbCrLf
				strContents = strContents & "room:" & room & vbCrLf''''''''''����
				strContents = strContents & "osver:" & oslist & vbCrLf''''''''''����ϵͳ
				strContents = strContents & "iptype:" & iptype & vbCrLf''''''''''ip��ַ
				strContents = strContents & "pmver:" & pmver & vbCrLf''''''''''����
				strContents = strContents & dllstr''''''''''''''����������û���ϵ��ʽ
				strContents = strContents & "userip:" & GetuserIp() & vbcrlf '�û��ͻ���IP
				strContents = strContents & "productnametemp:" & p_name & vbCrLf
				strContents = strContents & "ppricetemp:" & itemPrice & vbCrLf
				strContents = strContents & "appname:" & s_appName & vbCrLf
				strContents = strContents & "appadd:" & s_appAdd & vbCrLf
				strContents = strContents & "apptel:" & s_appTel & vbCrLf
				strContents = strContents & "appemail:" & s_appEmail & vbCrLf
				strContents = strContents & f_content
				strContents = strContents & "." & vbCrLf
				
				
'	update_User_Info(s_appName,s_appAdd,s_appTel,s_appEmail)
				
userinfo=""		
if session("u_contract")="" then
if userinfo="" then
userinfo=userinfo&" u_contract='"&s_appName&"'"
else
userinfo=userinfo&",u_contract='"&s_appName&"'"
end if

session("u_contract")=s_appName
end if
if session("u_address")="" then
if userinfo="" then
userinfo=userinfo&" u_address='"&s_appAdd&"'"
else
userinfo=userinfo&",u_address='"&s_appAdd&"'"
end if
session("u_address")=s_appAdd
end if

if session("msn")="" then
if userinfo="" then
userinfo=userinfo&" msn_msg='"&s_appTel&"'"
else
userinfo=userinfo&",msn_msg='"&s_appTel&"'"
end if
session("msn")=s_appTel
end if




if session("u_email")="" then
	if userinfo="" then
	userinfo=userinfo&" u_email='"&s_appEmail&"'"
	else
	userinfo=userinfo&",u_email='"&s_appEmail&"'"
	end if
session("u_email")=s_appEmail
end if

if userinfo<>"" and session("u_sysid")<>"" then
'response.Write("update userdetail set "&userinfo&" where u_id="&session("u_sysid")&"<BR>")
conn.execute("update userdetail set "&userinfo&" where u_id="&session("u_sysid"))

end if

 		        'add_cart
		        call add_shop_cart(session("u_sysid"),ywtype,ywname,strContents)		
				'response.Write(strContents)
				'response.End()
'				session("order") =  strContents & session("order")
				Response.redirect "/bagshow/"
				
				
		end if
end sub

function ischeckhost(byval webname,byval productid,byval vyear,byval buytest,byref errstr,byref p_name,byref p_maxmen,byref p_size,byval cdntype)
	errstr=""
	ischeckhost=false
	if trim(productid)&""="" or len(productid)>10 or trim(productid)="b000" then errstr="��Ʒ�ͺŴ���":exit function
	if not isnumeric(vyear) then errstr="���޴���":exit function
	if vyear>10 or vyear<1 then errstr="����Ӧ��1-10��֮��":exit function
	if not checkhostnameIn(webname,hosterrstr) then errstr=hosterrstr:exit function
	if lcase(productid)="auto000" then
		if vyears<>1 then errstr="��������ֻ�ܹ���һ��":exit function
		if session("u_levelid")=1 then errstr="���������ֱ�ӿͻ������ܹ�������������":exit function
		set ed_rs=conn.execute("select * from vhhostlist where s_ProductId='Auto000' and S_ownerid="&session("u_sysid"))
		if not ed_rs.eof then errstr = "���Ѿ�������һ������������":set ed_rs=nothing:exit function
	end if
	if buytest=1 and trim(session("u_sysid"))&""<>"" then
			Audsql="select top 1 u_Auditing from userDetail where u_id="& session("u_sysid")
			set Audrs=conn.execute(Audsql)
			if not Audrs.eof then
				if trim(AudRs(0))="1" then
					errstr="����Ҫͨ������Ա��˺���ܿ�ͨ��������!"
					Audrs.close
					exit function
				end if
			end if
			Audrs.close
		if session("u_levelid")=1 then 
			setcountline=4
		else
			setcountline=20
		end if
			sql="select count(*) as fdsfs from vhhostlist where S_ownerid="& session("u_sysid") &" and s_buytest=1"
			set testCountRS=conn.execute(sql)
			if testCountRS(0)>=setcountline then
				errstr="�Բ��� �������ֻ������"& setcountline &"������������"
				testCountRS.close
				exit function
			end if
			testCountRS.close
		
	end if
	psql="select top 1 *  from productlist where p_type=1 and P_proId='"& productid &"'"
	set prs=conn.execute(psql)
	if not prs.eof then
		p_name=prs("p_name")
		p_maxmen=prs("p_maxmen")
		p_size=prs("p_size")
		p_test=prs("p_test")'�Ƿ����� 0����
		if p_test<>0 and buytest=1 then 
			errstr="��������������������"
		elseif (cdntype=2 or cdntype=3) and instr(p_name,"��Ⱥ")>0 then 
			errstr="��Ⱥ����������ҵ��վ�����빺����˾������Ʒ"
		else
			ischeckhost=true
		end if		
	else
		errStr="û�д���������"
	end if
	prs.close
	set prs=nothing
end function
function checkhostnameIn(ftpname,byref errstr)
	checkhostnameIn=false
	errstr=""
	hostcheckstr="mysql,root,mssql,sqlserver,sa,domainname,dnsresolve,system,administrator,pcj,fancy,TsInternetUser,service,network,replicator,client,guests,batch,dialup,interactive,everyone"
	'die checkRegExp(ftpname,"^[a-zA-Z][a-z0-9A-Z]{3,14}$")&"|"&ftpname
	if not checkRegExp(ftpname,"^[a-z][a-z0-9A-Z]{3,14}$") then errstr="ftp����ʽ����,ֻ������ĸ����������Ҳ��������ֿ�ͷ":exit function
	if len(ftpname)<4 then errstr="ftp������С��4λ":exit function
	if len(ftpname)>15 then errstr="ftp�����ܴ���15λ":exit function
	
	if instr(","& lcase(hostcheckstr) &",",","& lcase(ftpname) &",")>0 then	errstr="ftp���н��ùؼ���":exit function

		Xcmd="other" & vbcrlf
		Xcmd=Xcmd & "get" & vbcrlf
		Xcmd=Xcmd & "entityname:vhostexists" & vbcrlf
		Xcmd=Xcmd & "sitename:" & ftpname & vbcrlf & "." & vbcrlf
		chk_userstr=Session("user_name")
		if len(Session("user_name"))<=0 then chk_userstr="AgentUserVCP"
		loadRet=Pcommand(Xcmd,chk_userstr)
		if success(loadRet) then
			Xstatus=getReturn(loadRet,"status")
			if Xstatus="yes" then
				errstr="��ftp���Ѿ�����"
				exit function
			end if
		end if
			sqls="select s_sysid from vhhostlist where s_comment='"& ftpname &"'"
			set rszxw=conn.execute(sqls)
			if not rszxw.eof then
				errstr="��ftp���Ѿ�����"
			else
				checkhostnameIn=true
			end if
			rszxw.close
			set rszxw=nothing

end function
function xltinxing()
	 
	thisuserip=GetuserIp()
	ipaddresstype=getIpAddressType(thisuserip,getIpAddressMsg)
	titlestr="<span style=""color:red"">��ʾ��</span>����IP("& thisuserip &")���� "& getIpAddressMsg
	if instr(productName,"����")>0 or instr(productName,"˫��")>0 then
 		if ipaddresstype="��ͨ" or ipaddresstype="��ͨ" then
		  otherstr="������ѡ��"&chgroomName("BGP����")
		else
		  otherstr="������ѡ��"&chgroomName("���������������Ļ���")
		end if
	else
	  if instr(productName,"��̨")=0 and instr(productName,"��Ⱥ")=0 and instr(productName,"����")=0 then
		if ipaddresstype="��ͨ" or ipaddresstype="��ͨ" then
			otherstr="������ѡ��"&chgroomName("�й���ͨ����")
		else
			otherstr="������ѡ��"&chgroomName("�й����Ż���")
		end if
	  end if
	end if
	xltinxing=titlestr & otherstr
end function


 
%>