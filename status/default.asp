<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%
conn.open constr

sql="select * from ShopCart where userid="&session("u_sysid")&" and s_status=1 order by cartID asc"
set shopcart=conn.execute(sql)
 
if shopcart.eof then   errpage "出现错误,页面已过期1"
 

	call setHeaderAndfooter()
	tpl.set_file "main", USEtemplate&"/status/default.html"
	tpl.set_block "main", "startlist", "list"
    mailtxt=""
do while not shopcart.eof
			resultmsg=trim(shopcart("return_msg"))	
			cartID=shopcart("cartID")
			orderstr=trim(shopcart("cartContent"))
			if left(resultmsg,3)="200" then
               ' call del_shop_car(session("u_sysid"), cartID)   'del 成功
				succpic="cuowu.png"
				succmsg="交易成功"
				
			else
				succpic="status2.gif"
				succmsg="交易失败<br>" & succmsg
				
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
			orderid=getOrderid(productName)&"[域名]"
			content="域名"& domainname &" 实时注册成功。域名在24小时后可正常使用。<br>" & _
					"若您申请域名时,所填写的DNS是我公司的,则可使用我公司的DNS管理器进行域名解析等管理工作<br>"& _
					"操作方式：进入<a href=""/manager""><font color=#FF0000>管理中心</font></a>"& _ 
					"—业务管理－域名管理，点击该域名进入高级管理，然后点DNS解析记录管理，"& _
					"即可增加IP，完成域名解析。<br>"
			needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			mailtxt=mailtxt&"[域名]"&domainname&"    域名密码："&domainpwd&"  "&vbcrlf
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
			content="已经加到自动开通任务计划，主机约六分钟后自动开通。服务器ip:"& s_serverIP &"用户名:"&adm_u_name&" 密码:"& vpsPassWord &"。"& lxr & "<br /><a href='/manager/servermanager/'>&nbsp;<img src=""/Template/Tpl_05/newimages/site_map_path_arrow.gif"" target=_blank>服务器管理中心</a>"
			mailtxt=mailtxt&"[VPS/弹性云] 服务器ip:"& s_serverIP &"   用户名:"&adm_u_name&"   密码:"& vpsPassWord &""&vbcrlf
		Case "vhost"
			p_name=Trim(getstrReturn(orderstr & vbCrLf , "productnametemp"))
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "ftpuser"))
			ftppassword=Trim(getstrReturn(orderstr & vbCrLf , "ftppassword"))
			if instr(p_name,"mysql")>0 then
				content1="MYSQL数据库"
			else
				content1="虚拟主机"
				
			end if
			orderid=getOrderid(productName) & "["& content1 &"]"
			freeurl=Trim(getstrReturn(resultmsg & vbCrLf , "freedomain"))
			s_serverIP=Trim(getstrReturn(resultmsg & vbCrLf , "ip"))
			if instr(p_name,"mysql")>0 then
				content="您申请的"& content1 &"已经开设成功。<br>" & _
						"好了,现在就进入您的<a href=/manager>虚拟主机的控制面板</a>看看吧.<br>"
			else
						
		
			content="您申请的"& content1 &"已经开设成功。<br>" & _
					"同时系统分配您一个二级域名,您现在可以通过<a href=""http://"& freeurl &"/"" target=_blank>"& freeurl &"</a>立即投入使用。<br>"& _
					 "上传地址:"& s_serverIP &" &nbsp;FTP帐号:"& productName &"<br>" & _
					 "您可以给您的虚拟主机绑定自己的域名，请将绑定的域名做别名(Cname)至: "&freeurl&". <br>" & _
					 "好了,现在就进入您的<a href=/manager>虚拟主机的控制面板</a>看看吧.<br>"
			end if
			if isnumeric(paytype) and paytype=1 then
				needprice=demoprice
				productName=productName & "[试用]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[虚拟主机] ftp帐号:"&productName&"    FTP密码:"&ftppassword&"        上传地址:"& s_serverIP &" "&vbcrlf
		Case "corpmail"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			password=Trim(getstrReturn(orderstr & vbCrLf , "password"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "domainname"))
			orderid=getOrderid(productName)&"[邮局]"
		
			MXValue=Trim(getstrReturn(resultmsg & vbCrLf , "mailmx"))
			content=">您申请的电子邮局已开设成功。访问网址:<a href=""http://"&MXValue&"/"" target=_blank>http://"&MXValue&"</a><br>" & _
			"邮局域名:"& productName &"，点击业务管理>邮局管理，可以对企业邮局进行管理。<br>" & _
			"您可以给您的域名做邮件解析，并将其邮局域名的邮件交换记录指到别名:"&MXValue&"<br>"
			if paytype="1" then
				needprice=demomailprice
				productName=productName & "[试用]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[企业邮箱] 邮箱域名:"&productName&"    邮箱密码:"&password&""&vbcrlf
		Case "mssql"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "years"))
			paytype=Trim(getstrReturn(orderstr & vbCrLf , "paytype"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "databasename"))
			dbloguser=Trim(getstrReturn(orderstr & vbCrLf , "dbloguser"))
			dbupassword=Trim(getstrReturn(orderstr & vbCrLf , "dbupassword"))
			ip=Trim(getstrReturn(resultmsg & vbCrLf , "ip"))
			orderid=getOrderid(productName)&"[MSSQL数据库]"
			content=" 您申请的数据库已开设成功。<br>" & _
						" 数据库名:"& productName &"，数据库IP地址:"&ip&"<br>" & _
						" 数据库用户名:"& productName &"，数据库用户密码:"& dbupassword &"<br><br><a href=/manager><font color=#FF0000>进入数据库管理中心</font></a><br>"
			if paytype="1" then
				needprice=demomssqlprice
				productName=productName & "[试用]"
			else
				needprice=GetNeedPrice(session("user_name"),productid,years,"new")
			end if
			mailtxt=mailtxt&"[数据库]数据库名:"& productName &"  数据库用户密码:"& dbupassword &"   数据库IP地址:"&ip&""&vbcrlf
		case "dnsdomain"
			productid=Trim(getstrReturn(orderstr & vbCrLf , "producttype"))
			years=Trim(getstrReturn(orderstr & vbCrLf , "term"))
			productName=Trim(getstrReturn(orderstr & vbCrLf , "productnametemp"))
			orderid=getOrderid(productName)& "[DNS管理]"
			content="DNS管理"& productName &" 实时开通成功，可以立即使用<br>" & _
					"若要使DNS管理生效，需要先将您的域名的DNS更改为ns1.myhostadmin.net,ns2.myhostadmin.net！<br>" & _
					"可以进入业务管理－域名服务处添加解析记录。<br>"
			
			needprice=GetNeedPrice(session("user_name"),productid,years,"new")	
			mailtxt=mailtxt&"[DNS管理]域名："&productName&""&vbcrlf
		case "miniprogram"
			productName=getstrReturn(orderstr & vbCrLf, "appname")
			years=getstrReturn(orderstr & vbCrLf, "years")
			productid=getstrReturn(orderstr & vbCrLf, "producttype")
			paytype=getstrReturn(orderstr & vbCrLf, "paytype")
			needprice=getstrReturn(orderstr & vbCrLf, "ppricetemp")
			content="微信小程序:"&productName&" 实时开通成功,可以立即使用<BR>"&_
					"请登陆管理中心进行管理"

			mailtxt=mailtxt&"[微信小程序]："&productName&""&vbcrlf

	end select
	
	if succmsg<>"交易成功" then 
		content="非常遗憾，您申请的业务实时开通失败，错误码是(" & showerrmsg(resultmsg) & "),您可以再尝试一次，若还是发生错误，请联系我司客服。<br>如是购虚拟空间报错，请更换FTP名称再次购买!"
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
		call sendMail(session("u_email"),"您在"&companyname&"的业务开通成功!",mailbody)
	
	session("order")=""
	session("result")=""

'将购物车信息发送状态更新为2
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