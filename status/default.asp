<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
conn.open constr

sql="select * from ShopCart where userid="&session("u_sysid")&" and s_status=1 order by cartID asc"
set shopcart=conn.execute(sql)
 
if shopcart.eof then   errpage "���ִ���,ҳ���ѹ���1"
 

	call setHeaderAndfooter()
	tpl.set_file "main", USEtemplate&"/status/default.html"
	tpl.set_block "main", "startlist", "list"
    mailtxt=""
do while not shopcart.eof
			resultmsg=trim(shopcart("return_msg"))	
			cartID=shopcart("cartID")
			orderstr=trim(shopcart("cartContent"))
			if left(resultmsg,3)="200" then
               ' call del_shop_car(session("u_sysid"), cartID)   'del �ɹ�
				succpic="cuowu.png"
				succmsg="���׳ɹ�"
				
			else
				succpic="status2.gif"
				succmsg="����ʧ��<br>" & succmsg
				
			end if
	Ptype=Trim(getstrReturn(orderstr & vbCrLf , "entityname"))
	select case trim(lcase(Ptype))
		Case "domain"
			domainname=Trim(getstrReturn(orderstr & vbCrLf , "domainname"))
	        domainpwd=Trim(getstrReturn(orderstr & vbCrLf , "domainpwd"))
			call doupfile(domainname,"")
			productid=GetDomainType(domainname)
			years=Trim(getstrReturn(orderstr & vbCrLf , "term"))
			productName=domainname
			orderid=getOrderid(productName)&"[����]"
			content="����"& domainname &" ʵʱע��ɹ���������24Сʱ�������ʹ�á�<br>" & _
					"������������ʱ,����д��DNS���ҹ�˾��,���ʹ���ҹ�˾��DNS�������������������ȹ�����<br>"& _
					"������ʽ������<a href=""/manager""><font color=#FF0000>��������</font></a>"& _ 
					"��ҵ��������������������������߼�����Ȼ���DNS������¼����"& _
					"��������IP���������������<br>"
			needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			mailtxt=mailtxt&"[����]"&domainname&"    �������룺"&domainpwd&"  "&vbcrlf
		Case "server"
			p_name=getstrReturn(orderstr & vbCrLf, "hostid")
			productid=getstrReturn(orderstr&vbCrLf , "p_proid")
			productName=getstrReturn(orderstr&vbCrLf  , "cpu")
			paytype=trim(getstrReturn(orderstr&vbCrLf  , "paymethod")&"")
			years=getstrReturn(orderstr&vbCrLf , "years")
			orderid=getstrReturn(orderstr & vbCrLf, "aid")
			needprice = getstrReturn(orderstr&vbCrLf , "pricmoney")
			s_serverIP=Trim(getstrReturn(resultmsg & vbCrLf , "vpsIP"))
			vpsPassWord=Trim(getstrReturn(resultmsg & vbCrLf , "vpsPassWord"))
			ch_os=getstrReturn(thisorderlist&vbCrLf , "choice_os")
			if lcase(ch_os)="linux" then
				adm_u_name="root"
			else	
				adm_u_name="Administrator"
			end if
			content="�Ѿ��ӵ��Զ���ͨ����ƻ�������Լ�����Ӻ��Զ���ͨ��������ip:"& s_serverIP &"�û���:"&adm_u_name&" ����:"& vpsPassWord &"��"& lxr & "<br /><a href='/manager/servermanager/'>&nbsp;<img src=""/Template/Tpl_05/newimages/site_map_path_arrow.gif"" target=_blank>��������������</a>"
			mailtxt=mailtxt&"[VPS/������] ������ip:"& s_serverIP &"   �û���:"&adm_u_name&"   ����:"& vpsPassWord &""&vbcrlf
		Case "vhost"
			p_name=Trim(getstrReturn(orderstr & vbCrLf , "productnametemp"))
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "ftpuser"))
			ftppassword=Trim(getstrReturn(orderstr & vbCrLf , "ftppassword"))
			if instr(p_name,"mysql")>0 then
				content1="MYSQL���ݿ�"
			else
				content1="��������"
				
			end if
			orderid=getOrderid(productName) & "["& content1 &"]"
			freeurl=Trim(getstrReturn(resultmsg & vbCrLf , "freedomain"))
			s_serverIP=Trim(getstrReturn(resultmsg & vbCrLf , "ip"))
			if instr(p_name,"mysql")>0 then
				content="�������"& content1 &"�Ѿ�����ɹ���<br>" & _
						"����,���ھͽ�������<a href=/manager>���������Ŀ������</a>������.<br>"
			else
						
		
			content="�������"& content1 &"�Ѿ�����ɹ���<br>" & _
					"ͬʱϵͳ������һ����������,�����ڿ���ͨ��<a href=""http://"& freeurl &"/"" target=_blank>"& freeurl &"</a>����Ͷ��ʹ�á�<br>"& _
					 "�ϴ���ַ:"& s_serverIP &" &nbsp;FTP�ʺ�:"& productName &"<br>" & _
					 "�����Ը����������������Լ����������뽫�󶨵�����������(Cname)��: "&freeurl&". <br>" & _
					 "����,���ھͽ�������<a href=/manager>���������Ŀ������</a>������.<br>"
			end if
			if isnumeric(paytype) and paytype=1 then
				needprice=demoprice
				productName=productName & "[����]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[��������] ftp�ʺ�:"&productName&"    FTP����:"&ftppassword&"        �ϴ���ַ:"& s_serverIP &" "&vbcrlf
		Case "corpmail"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			password=Trim(getstrReturn(orderstr & vbCrLf , "password"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "domainname"))
			orderid=getOrderid(productName)&"[�ʾ�]"
		
			MXValue=Trim(getstrReturn(resultmsg & vbCrLf , "mailmx"))
			content=">������ĵ����ʾ��ѿ���ɹ���������ַ:<a href=""http://"&MXValue&"/"" target=_blank>http://"&MXValue&"</a><br>" & _
			"�ʾ�����:"& productName &"�����ҵ�����>�ʾֹ������Զ���ҵ�ʾֽ��й���<br>" & _
			"�����Ը������������ʼ��������������ʾ��������ʼ�������¼ָ������:"&MXValue&"<br>"
			if paytype="1" then
				needprice=demomailprice
				productName=productName & "[����]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[��ҵ����] ��������:"&productName&"    ��������:"&password&""&vbcrlf
		Case "mssql"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "databasename"))
			dbloguser=Trim(getstrReturn(orderstr & vbCrLf , "dbloguser"))
			dbupassword=Trim(getstrReturn(orderstr & vbCrLf , "dbupassword"))
			ip=Trim(getstrReturn(resultmsg & vbCrLf , "ip"))
			orderid=getOrderid(productName)&"[MSSQL���ݿ�]"
			content=" ����������ݿ��ѿ���ɹ���<br>" & _
						" ���ݿ���:"& productName &"�����ݿ�IP��ַ:"&ip&"<br>" & _
						" ���ݿ��û���:"& productName &"�����ݿ��û�����:"& dbupassword &"<br><br><a href=/manager><font color=#FF0000>�������ݿ��������</font></a><br>"
			if paytype="1" then
				needprice=demomssqlprice
				productName=productName & "[����]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[���ݿ�]���ݿ���:"& productName &"  ���ݿ��û�����:"& dbupassword &"   ���ݿ�IP��ַ:"&ip&""&vbcrlf
		case "dnsdomain"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "term"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "productnametemp"))
			orderid=getOrderid(productName)& "[DNS����]"
			content="DNS����"& productName &" ʵʱ��ͨ�ɹ�����������ʹ��<br>" & _
					"��ҪʹDNS������Ч����Ҫ�Ƚ�����������DNS����Ϊns1.myhostadmin.net,ns2.myhostadmin.net��<br>" & _
					"���Խ���ҵ���������������ӽ�����¼��<br>"
			
			needprice=GetNeedPrice(session("user_name"),productid,years,"new")	
			mailtxt=mailtxt&"[DNS����]������"&productName&""&vbcrlf
		case "miniprogram"
			productName=getstrReturn(orderstr & vbCrLf, "appname")
			years=getstrReturn(orderstr & vbCrLf, "years")
			productid=getstrReturn(orderstr & vbCrLf, "producttype")
			paytype=getstrReturn(orderstr & vbCrLf, "paytype")
			needprice=getstrReturn(orderstr & vbCrLf, "ppricetemp")
			content="΢��С����:"&productName&" ʵʱ��ͨ�ɹ�,��������ʹ��<BR>"&_
					"���½�������Ľ��й���"

			mailtxt=mailtxt&"[΢��С����]��"&productName&""&vbcrlf

	end select
	
	if succmsg<>"���׳ɹ�" then 
		content="�ǳ��ź����������ҵ��ʵʱ��ͨʧ�ܣ���������(" & showerrmsg(resultmsg) & "),�������ٳ���һ�Σ������Ƿ�����������ϵ��˾�ͷ���<br>���ǹ�����ռ䱨�������FTP�����ٴι���!"
	end if
	
	
	tpl.set_var "productid",productid,false
	tpl.set_var "years",years,false
	tpl.set_var "productName",productName,false
	tpl.set_var "orderid",orderid,false
	tpl.set_var "content",content,false
	tpl.set_var "needprice",needprice,false
	tpl.set_var "succmsg",succmsg,false
	tpl.set_var "succpic",succpic,false
	tpl.parse "list", "startlist", true
shopcart.movenext
loop
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing

getStr= "yewumail=" & mailtxt
		
		mailbody=redMailTemplate("buy.txt",getStr)
		call sendMail(session("u_email"),"����"&companyname&"��ҵ��ͨ�ɹ�!",mailbody)
	
	session("order")=""
	session("result")=""

'�����ﳵ��Ϣ����״̬����Ϊ2
sql="update ShopCart set s_status=2 where userid="&session("u_sysid")&" and s_status=1"
set shopcart=conn.execute(sql)


	conn.close

function getOrderid(byval productNames)
	rs11.open "select top 1 o_id from orderlist where o_memo='"& productNames &"' and o_ownerid=" & session("u_sysid"),conn,1,1
	if not rs11.eof then
		o_id=rs11("o_id")
		o_id=100000 + o_id
	else
		o_id="N" & replace(timer(),".","")
	end if
	rs11.close
	getOrderid=o_id
end function
%>

<%'=mailtxt%>