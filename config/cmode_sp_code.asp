<!--#include virtual="/config/T_SQL_STYLE.asp" -->

<%
'所有Args参数均是Scripting.Dictionary对象
'所有Args对象的compareMode值必须设置为1
sub sp_addsite(ByRef Args)
	'添加虚拟主机记录
	'参数表
	'@Ftp_UserName       varchar(50),
	'@P_Type          tinyint,
	'@ServerBindings     varchar(255) = '',
	'@username           varchar(20),
	'@producttype        varchar(10),
	'@FtpPassword        varchar(128),
	'@appName      varchar(50),
	'@appAdd      varchar(255),
	'@appTel      varchar(20),
	'@appEmail      varchar(300),
	'@vyears             int,
	'@result     int  output
	'@ordersysid int output 
	
	SetOption "ServerBindings","",Args '设置可省略的参数
	SetOption "defaultDoc","index.html,index.asp,index.htm,default.asp,default.htm,index.php",Args

	SetValue "result","0",Args '设置返回值

	if Gets("Ftp_UserName",Args)="" or Len(Gets("Ftp_UserName",Args))<3 then
		SetValue "result","3003",Args
		Exit sub
	end if

	if exists_sql_arg("select s_comment from vhhostlist where s_comment = @Ftp_UserName",Args) then
	  SetValue "result","3001",Args
	  exit sub
	end if

	Call select_sql("select @mxconnect=p_maxmen,@p_size=p_size,@appId=p_appid from  productlist where p_proId =@producttype and (p_test=0 or " & Gets("P_Type",Args) & "=0)",Args)

	if Gets("p_size",Args)="" then
	  SetValue "result","3003",Args
	  exit sub
	end if

	Call select_sql("select @u_id = u_id ,@u_level = u_level from Userdetail where u_name = @username",Args)

	if Gets("u_level",Args)=1 then
		Call select_sql("SELECT @u_buytestcount = count(*) FROM vhhostlist where s_buytest = "&PE_True&" and s_ownerid =  @u_id ",Args)
		if Gets("u_buytestcount",args) > 7 then
			SetValue "result","1234",Args
			exit sub
		end if
	end if

	if Gets("vyears",Args)<1 then
		Args("vyears")=1
	end if

	'从2010-7起，新开虚拟主机免费赠送一个月
nofreeid=",tw000,tw001,tw002,tw003,tw004,tw005,tw006,tw007,tw008,tw009,m000,m001,m002,m003,m005,m006,m007,m008,m009,"

if instr(nofreeid,lcase(Gets("producttype",Args)))=0 and Gets("P_Type",Args)=0 Then
'	newsql = "insert into vhhostlist(s_paytype,s_father,s_maxconnect,s_size,s_expiredate,s_buydate,s_year,s_comment,s_buytest,s_bindings,s_Defaultdoc,S_ownerid,s_ProductId,s_ftppassword,s_serverIP,s_appId,s_defaultbindings,s_servername,s_appName,s_appAdd,s_appTel,s_appEmail,s_payok)values ('year',@u_id,@mxconnect ,@p_size,  dateadd('m',1,DATEADD('yyyy',@vyears,now())) , dateadd('m',1,now()),@vyears,@Ftp_UserName,@p_Type,@ServerBindings,@defaultdoc,@u_id,@producttype,@FtpPassword,'',@appId,'','',@appName,@appAdd,@appTel,@appEmail,true)"
	newsql = "insert into vhhostlist(s_paytype,s_father,s_maxconnect,s_size,s_expiredate,s_buydate,s_year,s_comment,s_buytest,s_bindings,s_Defaultdoc,S_ownerid,s_ProductId,s_ftppassword,s_serverIP,s_appId,s_defaultbindings,s_servername,s_appName,s_appAdd,s_appTel,s_appEmail,s_payok)values ('year',@u_id,@mxconnect ,@p_size,  dateadd("&PE_DatePart_M&",1,dateadd("&PE_DatePart_Y&",@vyears,"&PE_Now&")) , dateadd("&PE_DatePart_M&",1,"&PE_Now&"),@vyears,@Ftp_UserName,@p_Type,@ServerBindings,@defaultdoc,@u_id,@producttype,'','',@appId,'','',@appName,@appAdd,@appTel,@appEmail,"&PE_True&")"
else
	newsql = "insert into vhhostlist(s_paytype,s_father,s_maxconnect,s_size,s_expiredate,s_buydate,s_year,s_comment,s_buytest,s_bindings,s_Defaultdoc,S_ownerid,s_ProductId,s_ftppassword,s_serverIP,s_appId,s_defaultbindings,s_servername,s_appName,s_appAdd,s_appTel,s_appEmail,s_payok)values ('year',@u_id,@mxconnect ,@p_size,  dateadd("&PE_DatePart_Y&",@vyears,"&PE_Now&") , "&PE_Now&",@vyears,@Ftp_UserName,@p_Type,@ServerBindings,@defaultdoc,@u_id,@producttype,'','',@appId,'','',@appName,@appAdd,@appTel,@appEmail,"&PE_True&")"
end if
Call exec_sql_arg(newsql,Args)
	
	'Call exec_sql_arg("insert into vhhostlist(s_paytype,s_father,s_maxconnect,s_size,s_expiredate,s_buydate,s_year,s_comment,s_buytest,s_bindings,s_Defaultdoc,S_ownerid,s_ProductId,s_ftppassword,s_serverIP,s_appId,s_defaultbindings,s_servername,s_appName,s_appAdd,s_appTel,s_appEmail,s_payok)values ('year',@u_id,@mxconnect ,@p_size,  dateDiff("&PE_DatePart_Y&",@vyears,"&PE_Now&") , "&PE_Now&",@vyears,@Ftp_UserName,@p_Type,@ServerBindings,@defaultdoc,@u_id,@producttype,@FtpPassword,'',@appId,'','',@appName,@appAdd,@appTel,@appEmail,"&PE_True&")",Args)
	SetValue "resultId",GetFieldValue("@@identity","vhhostlist","1","1"),Args
	SetValue "identity",Args("resultId"),Args
	Call exec_sql_arg("insert into orderlist (o_typeid,o_type,o_ok,o_ownerid ,o_producttype,o_memo) values (@resultId,@producttype,1,@u_id ,1,@Ftp_UserName)",Args)
	SetValue "resultId",GetFieldValue("@@identity","orderlist","1","1"),Args
	SetValue "ordersysid",Args("resultId"),Args
	Call exec_sql_arg("insert into [_order]  (o_key,o_moneysum,o_date) values (@ordersysid,0 ,"&PE_Now&")",Args)
	Call exec_sql_arg("update orderlist set o_key=o_id where o_id = @resultId",Args)
end sub

function ismysql(Byval proid) '判断产品是否是mysql数据库
	proid=Lcase(proid)
	Sql="select p_name from productlist where p_type=1 and p_proid='" & proid & "' and p_name like '%mysql%'"
	ismysql=exists_sql(sql)
end function

sub checkorder_site(ByRef Args)
'扣款/更正主机记录状态
'@ordersysid         varchar(10),
'@strServerIp        varchar(20),
'@freedomain  varchar(300),
'@free  varchar(200),是否是免费主机
'@intOrderStatus     int,
'@result            tinyint  output

	if Args("free")="true" then
		isFree=true
	else
		isFree=false
	end if

	select_sql "select @o_key=o_key,@vhlistId=o_typeid from orderlist where o_id=@ordersysid",Args
	select_sql "select @paytype=s_paytype,@years=s_year ,@buytest=s_buytest,@proId=s_ProductId,@vbelong=S_ownerid ,@vhostname=s_comment from vhhostlist  where s_sysid=@vhlistId",Args

'	if Args("buytest") then
'		if Args("intOrderStatus")=1 then
'			exec_sql_arg "UPDATE ORDERLIST set o_money=0,o_ok=2 where o_id=@ordersysid",Args
'			exec_sql_arg "update vhhostlist set s_sitestate =-1 , s_serverip=@strServerIp  where s_sysid=@vhlistId",Args
'			exec_sql_arg "update [_order] set o_ok=1  where o_key=@o_key",Args
'			SetValue "result",0,Args
'			Exit sub
'		end if
'
'		exec_sql_arg "UPDATE ORDERLIST set o_money=0 ,o_ok=0 , o_okdate=now() where o_id=@ordersysid",Args
'		exec_sql_arg "update vhhostlist set s_payok="&PE_False&" , s_serverName=@freedomain ,s_sitestate = 0,s_serverip=@strServerIp where s_sysid=@vhlistId",Args
'		SetValue "result",0,Args
'		Exit sub
'	end if

	select_sql "select @uname=u_name from userdetail where u_id=@vbelong",Args
	if Args("buytest") then
		if not isNumeric(demoprice) then
			NeedPrice=5
		end if
		NeedPrice=demoprice
		SetValue "l_price",NeedPrice,Args
		addInfo="[试用]"
	elseif not isFree then
		addInfo=""
		NeedPrice=GetNeedPrice(Args("uname"),Args("proId"),Args("years"),"new")
		if Args("iptype")&""="1" then

			if lcase(left(Args("proId"),2))="tw" then
				ipproid="twaddip"
				else
				ipproid="vhostaddip"
			end if
 
				ipPrice=GetNeedPrice(Args("uname"),ipproid,Args("years"),"new")
			 
			if ipPrice&""="" or not isnumeric(ipprice) then ipPrice=0
			NeedPrice=cdbl(NeedPrice)+cdbl(ipPrice)
			if cdbl(ipPrice)>0 then
				addInfo="(含独立IP:"& ipPrice &"元)"
			end if
		end if
		SetValue "l_price",NeedPrice,Args		
	else
		NeedPrice=0
		SetValue "l_price",0,Args
		addInfo="[赠品]"
	end if

	if Args("intOrderStatus")=1 then
		exec_sql_arg "UPDATE ORDERLIST set o_money=@l_price , o_ok=2 where o_id=@ordersysid",Args
		exec_sql_arg "update vhhostlist set s_sitestate =-1,s_serverip=@strServerIp where s_sysid=@vhlistId",Args
		exec_sql_arg "update [_order] set o_ok=1 ,o_moneysum = o_moneysum + @l_price where o_key=@o_key",Args
		SetValue "result",0,Args
		Exit sub
	end if

	if consume(Args("uname"),NeedPrice,true,"vh-" & Args("vhostname"),"buy host:" & Args("vhostname") & addInfo,Args("proId"),Args("ordersysid")) then
		exec_sql_arg "UPDATE ORDERLIST set o_ok=0 ,o_money=@l_price , o_okdate="&PE_Now&" where o_id=@ordersysid",Args
		'2013 8-29 虚拟主机购/续多年送时间活动 s_buydate
		'exec_sql_arg "update vhhostlist set s_payok="&PE_False&", s_serverName=@freedomain,s_sitestate = 0,s_serverip=@strServerIp,s_year=@giftyears,s_expiredate=dateadd("&PE_DatePart_Y&",@giftyears,"&PE_Now&") where s_sysid=@vhlistId",Args
		exec_sql_arg "update vhhostlist set s_payok="&PE_False&", s_serverName=@freedomain,s_sitestate = 0,s_serverip=@strServerIp,s_year=@giftyears,s_expiredate=dateadd("&PE_DatePart_Y&",@giftyears,s_buydate) where s_sysid=@vhlistId",Args
		exec_sql_arg "update [_order] set o_moneysum = o_moneysum + @l_price where o_key=@o_key",Args
		'VCP提成---------------
		if not isFree then
			Set VCPArgs=CreateObject("Scripting.Dictionary"):VCPArgs.compareMode=1
			VCPArgs.Add "cid",Args("vbelong")
			VCPArgs.Add "proid",Args("proId")
			VCPArgs.Add "uprice",NeedPrice
			VCPArgs.Add "years",Args("years")
			VCPArgs.Add "content","buyhost"
			Call sp_vcp_record(VCPArgs)
			Set VCPArgs=nothing
		end if
		
		SetValue "result",0,Args
	else
			SetValue "result","3008",Args
	end if
end sub


sub sp_vcp_record(Args)
'添加VCP提成记录
'@cid int,
'@proid varchar(50),
'@uprice int,
'@years int,
'@content varchar(50)
	isrenew=false
	if Args("uprice")<=0 then
		Exit sub
	end if

	if Args("years")<1 then
		Args("years")=1
	end if
	
	select_sql "select @fid = f_id,@ulevel=u_level  from userdetail where u_id= @cid",Args

   ' die Args("uprice")&"==>"& Args("fid")&"==>"& Args("ulevel")
	if Args("fid")="" then Exit sub
	if isNull(Args("fid")) then  Exit sub
	if Cint(Args("fid"))=0 then  Exit Sub 
	if Args("ulevel")>1 then Exit Sub

	
	vcp_proid_vcp_royalty=proid_vcp_royalty(Args("proid"),isrenew)

'	AgentUser="AgentUserVCP"
'	AgentPrice=GetNeedPrice(AgentUser,Args("proid"),Args("years"),"new")
	if CDbl(vcp_proid_vcp_royalty)<=0 Then Exit Sub
	If CDbl(vcp_proid_vcp_royalty)>0.5 Then Exit Sub	
	royalty=CDbl(Args("uprice"))*CDbl(vcp_proid_vcp_royalty)
	if royalty<=0 then
		Exit sub
	end if

	SetValue "royalty",royalty,Args


	exec_sql_arg "insert into vcp_record(v_fid,v_cid,v_proid,v_price,v_years,v_royalty,v_content) values(@fid,@cid,@proid,@uprice,@years,@royalty,@content)",Args
end sub

sub setftppwd(Args)
'修改FTP密码
'@ServerComment      varchar(50),
'@username			 varchar(50),
'@newpwd            varchar(128),
'@result        tinyint  output 
	select_sql "select @uid=u_id from userdetail where u_name=@username",Args
	if not exists_sql_arg("select s_sysid from vhhostlist where s_comment=@ServerComment and s_ownerid=@uid",Args) then
		SetValue "result","3001",Args
	else
		'del 2016-3-23 exec_sql_arg "update vhhostlist set s_ftppassword=@newpwd where s_comment=@ServerComment",Args
		SetValue "result",0,Args
	end if
end sub

sub renewvhost(Args)
'虚拟主机续费
'@sitename		varchar(100),
'@u_name		    varchar(50),
'@buyyears       int,
'@result  		int output
	select_sql "select @u_id = u_id  from Userdetail where u_name = @u_name",Args
	if not exists_sql_arg("select * from vhhostlist  where s_comment =@sitename and S_ownerid=@u_id",Args) then
		SetValue "result",3003,Args
		Exit Sub
	end if
	select_sql "select @vmailname=s_defaultbindings  ,@sysid=s_sysid ,@proId=s_ProductId,@vhostname=s_comment,@ss_Buytest=s_buytest,@s_ssl=s_ssl from vhhostlist  where s_comment =@sitename and S_ownerid=@u_id",Args
	
	if Args("ss_Buytest") then
		SetValue "result",3004,Args
		exit sub
	end if
	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"renew")
	if isip(Args("otherip")) then

		if lcase(left(Args("proId"),2))="tw" then
			ipproid="twaddip"
			else
			ipproid="vhostaddip"
		end if
            ipprice=getneedprice(Args("u_name"),ipproid,Args("buyyears"),"renew")
		 
		if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
		NeedPrice=cdbl(NeedPrice)+cdbl(ipprice)
		if ipprice>0 then
			consstr="(含独立IP:"& ipprice &"元)"
		end if
	else
		sslprice=0
		s_ssl=Args("s_ssl")
		if not isnumeric(s_ssl&"") then s_ssl=0
		if cdbl(s_ssl)>0 then			
			sslprice=getneedprice(Args("u_name"),"vhostssl",Args("buyyears"),"renew")
			NeedPrice=cdbl(NeedPrice)+cdbl(sslprice)
			consstr=consstr&"(含独SSL,"& sslprice &"元)"
		end if
	end if
	
	if Args("Giftyear")>0 then
	consstr=consstr&"[赠送"&Args("Giftyear")&"年时间]"
	end if
	
	if consume(Args("u_name"),NeedPrice,true,"renew-" & Args("sitename"),"renew host:" & Args("sitename")&consstr ,Args("proId"),"") then
		exec_sql_arg "update vhhostlist set s_year=s_year + @buyyears+@Giftyear ,s_updatedate = "&PE_Now&" ,s_expiredate = dateDiff("&PE_DatePart_Y&",@buyyears+@Giftyear,s_expiredate), s_buytest="&PE_False&" where s_sysid=@sysid",Args
		exec_sql_arg "update mailsitelist set m_years=m_years + @buyyears+@Giftyear ,m_updatedate = "&PE_Now&" ,m_expiredate = dateDiff("&PE_DatePart_Y&",@buyyears+@Giftyear,m_expiredate)  where m_bindname=@vmailname and m_free="&PE_True&"",Args
		
		'自动续费赠品
		Set GiftArgs=CreateObject("Scripting.Dictionary"):GiftArgs.CompareMode=1
		GiftArgs.Add "username",Args("u_name")
		GiftArgs.Add "sysid",Args("sysid")
		GiftArgs.Add "years",Args("buyyears")+Args("Giftyear")
		GiftArgs.Add "type","vhost"
		Call GiftRenew(GiftArgs)
		'------------
		
		SetValue "result",0,Args
	else
		SetValue "result",3005,Args
	end if
end sub

Sub PayDemoHost(Args)
'试用主机转正
'@sitename		varchar(100),
'@u_name		varchar(50),
'@result  		int output,

	select_sql "select @u_id = u_id  from Userdetail where u_name = @u_name",Args
	if  not exists_sql_arg ("select * from vhhostlist  where s_comment =@sitename and S_ownerid=@u_id and s_buytest ="&PE_True&"",Args) then
		SetValue "result",3001,Args
		exit sub
	end if

	select_sql "select @sysid=s_sysid ,@buyyears=s_year,@proId=s_ProductId,@vhostname=s_comment from vhhostlist  where s_comment =@sitename and S_ownerid=@u_id",Args
	'

	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"new")
	
	if isNumeric(demoprice) then
		NeedPrice=NeedPrice-demoprice
	end if
	
	'转正试用时间优惠计算
	select case clng(Args("buyyears"))
		case 2
		gift_year=3
		case 3
		gift_year=5
		case 5
		gift_year=8
		case 10
		gift_year=20
		case else
		gift_year=clng(Args("buyyears"))
	end select

	if consume(Args("u_name"),NeedPrice,true,"payDemo-" & Args("sitename"),"paydemo host:" & Args("sitename") ,Args("proId"),"") then

	  '从2010-7起，新开虚拟主机免费赠送一个月
	  nofreeid=",tw000,tw001,tw002,tw003,tw004,tw005,tw006,tw007,tw008,tw009,m000,m001,m002,m003,m005,m006,m007,m008,m009,"
	  if instr(nofreeid,lcase(Gets("proId",Args)))=0 then
		  newsql="update vhhostlist set s_buydate=dateDiff("&PE_DatePart_M&",1,s_buydate),s_expiredate=dateDiff("&PE_DatePart_Y&","&gift_year&",dateDiff("&PE_DatePart_M&",1,s_expiredate)) ,s_buytest="&PE_False&" where s_sysid=@sysid"
	  else
		  newsql="update vhhostlist set s_buytest="&PE_False&",s_expiredate = dateDiff("&PE_DatePart_Y&","&gift_year&",s_expiredate) where s_sysid=@sysid"
	  end if
 
	  exec_sql_arg newsql,Args
'		exec_sql_arg "update vhhostlist set s_buytest="&PE_False&" where s_sysid=@sysid",Args
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
end sub

Sub UpgradeVhost(Args)
'升级虚拟主机
'@s_comment     varchar(50),
'@username      varchar(50),
'@t_productid     varchar(20),
'@updateType  varchar(20),OldupdateType/NewupdateType
'@resultStr varchar(100) output,
'@result int output

	select_sql "select @uid=u_id,@ulevel=u_level from userdetail where u_name=@username",Args
	select_sql "select @s_sysid=s_sysid,@proid=s_productid,@s_buyDate=s_buydate,@s_year=s_year,@mid=s_mid from vhhostlist where s_ownerid=@uid and s_comment=@s_comment",Args
	if Args("s_year")="" then
		SetValue "result",3001,Args
		Exit sub
	end if

	if Args("s_year")=1 then
		oneYear=true
	else
		oneYear=false
	end if

	if not oneYear then SetValue "updateType","OldupdateType",Args

	UsedDays=DateDiff("d",Args("s_buydate"),Now)
	leftDays=DateDiff("d",Now,DateAdd("yyyy",Args("s_year"),Args("s_buydate")))
	TotalDays=UsedDays+LeftDays
	
'	select_sql "select @oldprice=p_price from pricelist where p_proid=@proid and p_u_level=@ulevel",Args
	select_sql "select @newsize=p_size,@newmax=p_maxmen from productlist where p_type=1 and p_proid=@t_productid",Args
'	select_sql "select @newprice=p_price from pricelist where p_proid=@t_productid and p_u_level=@ulevel",Args
	
	
	'if Args("newprice")="" or Args("oldprice")="" then
'		SetValue "result",3002,Args
'		Exit sub
'	end if

'	if Args("updateType")="OldupdateType" then
'		 NeedCost=Cint(Ccur(Args("newprice"))/365*LeftDays-(Ccur(Args("oldprice"))*Args("s_year"))*(1-UsedDays/TotalDays))
'	else
'		 NeedCost=Cint(Ccur(Args("newprice"))-Ccur(Args("oldprice"))*(1-UsedDays/365.0))
'	end if
'	
	set up=new uphost_class:up.u_sysid=Args("uid"):up.setHostid=Args("s_sysid")
	call up.getUpInfo(Args("t_productid"),Args("new_room"),Args("new_osver"),Args("ismovedata"))
	up.setGoOnip=Args("keepip")
	NeedCost=up.getupNeedPrice(Args("t_productid"),Args("new_room"),Args("ismovedata"))	
	keepipmsg=""
	if isip(up.s_other_ip) then
		if Args("keepip") then
		keepipmsg="更换机房保留IP"
		else
		keepipmsg="升级机房取消独立ip"
		END IF
	end if
	if consume(Args("username"),NeedCost,true,"upgrade-" & Args("s_comment"),"upgrade host:" & Args("proid") & "("& up.s_roomname& up.s_osver &")->" & Args("t_productid") & "("& up.new_roomname& up.s_osver &")"&keepipmsg ,Args("t_productid"),"") then
		select_sql "select @mailproid=freeproid from protofree where proid=@t_productid",Args
		if Args("mailproid")<>"" and isNumeric(Args("mid")) then
			select_sql "select @msize=p_size,@mmaxmen=p_maxmen from productlist where p_proid=@mailproid",Args
			'if Args("updateType")="OldupdateType" then
				exec_sql_arg "update mailsitelist set m_productid=@mailproid,m_size=@msize,m_mxuser=@mmaxmen where m_sysid=@mid",Args
			'else
				'exec_sql_arg "update mailsitelist set m_buydate=now(),m_expireDate=dateDiff("&PE_DatePart_Y&",m_years,"&PE_Now&"),m_productid=@mailproid,m_size=@msize,m_mxuser=@mmaxmen where m_sysid=@mid",Args
			'end if
		end if
		'if Args("updateType")="OldupdateType" then
			exec_sql_arg "update vhhostlist set s_size=@newsize,s_ProductId=@t_productid,s_maxconnect=@newmax  where s_sysid=@s_sysid",Args
		'else
			'exec_sql_arg "update vhhostlist set s_buydate=now(),s_updatedate = now() ,s_expiredate = dateDiff("&PE_DatePart_Y&",s_year,"&PE_Now&"),s_size=@newsize,s_ProductId=@t_productid,s_maxconnect=@newmax  where s_sysid=@s_sysid",Args		
		'end if
		
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
	set up=nothing
end Sub

sub addnewdomain(Args)
'新加域名记录
'@username           varchar(20),
'@strDomain varchar(100),
'@strDomainpwd varchar(100),
'@admi_pc varchar(100),
'@years int,
'@dom_ln varchar(100),
'@admi_fax varchar(100),
'@tech_fn varchar(100),
'@tech_ph varchar(100),
'@bill_ct varchar(100),
'@bill_em varchar(100),
'@dns_host1 varchar(100),
'@dns_host2 varchar(100),
'@dom_fn varchar(100),
'@admi_co varchar(100),
'@bill_ln varchar(100),
'@bill_fax varchar(100),
'@dns_ip1 varchar(100),
'@dom_fax varchar(100),
'@admi_fn varchar(100),
'@admi_ph varchar(100),
'@tech_st varchar(100),
'@tech_fax varchar(100),
'@dns_ip2 varchar(100),
'@admi_ct varchar(100),
'@admi_em varchar(100),
'@dom_org varchar(100),
'@admi_st varchar(100),
'@dom_co varchar(100),
'@dom_ph varchar(100),
'@tech_pc varchar(100),
'@bill_co varchar(100),
'@dom_st varchar(100),
'@dom_pc varchar(100),
'@dom_ct varchar(100),
'@dom_adr1 varchar(100),
'@dom_em varchar(100),
'@tech_co varchar(100),
'@bill_pc varchar(100),
'@admi_ln varchar(100),
'@admi_adr1 varchar(100),
'@tech_ct varchar(100),
'@tech_em varchar(100),
'@bill_st varchar(100),
'@bill_ph varchar(100),
'@tech_ln varchar(100),
'@tech_adr1 varchar(100),
'@bill_fn varchar(100),
'@bill_adr1 varchar(100),
'@dom_org_m         varchar(255),
'@dom_fn_m         varchar(255),
'@dom_ln_m         varchar(255),
'@dom_adr_m         varchar(255),
'@dom_ct_m         varchar(255),
'@dom_st_m         varchar(255),
'@admi_org_m         varchar(255),
'@admi_fn_m         varchar(255),
'@admi_ln_m         varchar(255),
'@admi_adr_m         varchar(255),
'@admi_ct_m         varchar(255),
'@admi_st_m         varchar(255),
'@free				varchar(255),
'@register			varchar(255),
'@s_memo
'@result  int output


	if Args("free")="true" then
		isFree=true
	else
		isFree=false
	end if

	select_sql "select @uid=u_id from userdetail where u_name=@username",Args
	if Args("uid")="" then
		SetValue "result",1003,Args
		Exit sub
	end if

	if exists_sql_arg("select 1 from domainlist where strDomain=@strDomain",Args) then
		'SetValue "result",1003,Args
		'Exit sub
		addRec "域名问题",Args("strDomain") & "在本地数据库中冲突，请务必删除一个不正常的"
	end if

	proid=GetDomainType(Args("strDomain"))
	SetValue "proid",proid,Args
	if isFree then
		NeedPrice=0
		addInfo="[赠送]"
	else
		NeedPrice=GetNeedPrice(Args("username"),proid,Args("years"),"new")
	end if

'扣费移前
'	if consume(Args("username"),NeedPrice,false,"domain-" & Args("strDomain"),"buy domain:" & Args("strDomain") & addInfo ,proid,"") then
			if not isFree then
				'VCP提成----------------
				Set VCPArgs=CreateObject("Scripting.Dictionary"):VCPArgs.compareMode=1
				VCPArgs.Add "cid",Args("uid")
				VCPArgs.Add "proid",Args("proId")
				VCPArgs.Add "uprice",NeedPrice
				VCPArgs.Add "years",Args("years")
				VCPArgs.Add "content","buydomain"
				Call sp_vcp_record(VCPArgs)
				Set VCPArgs=nothing
				'-----------------------
			end if

		exec_sql_arg "insert into domainlist (bizcnorder,regok,proid,userid,fatherid,regdate,rexpiredate,rsbdate,strDomain,strDomainpwd,admi_pc,years,dom_ln,admi_fax,tech_fn,tech_ph,bill_ct,bill_em,dns_host1,dns_host2,dom_fn,admi_co,bill_ln,bill_fax,dns_ip1,dom_fax,admi_fn,admi_ph,tech_st,tech_fax,dns_ip2,admi_ct,admi_em,dom_org,admi_st,dom_co,dom_ph,tech_pc,bill_co,  dom_st,dom_pc,dom_ct,dom_adr1,dom_em,tech_co,bill_pc ,admi_ln,admi_adr1,tech_ct,tech_em,bill_st,bill_ph,tech_ln,tech_adr1,bill_fn,bill_adr1,dom_org_m,dom_fn_m,dom_ln_m,dom_adr_m,dom_ct_m,dom_st_m,admi_org_m,admi_fn_m,admi_ln_m,admi_adr_m,admi_ct_m,admi_st_m,s_memo) values  (@register,"&PE_False&",@proid,@uid,@uid, "&PE_Now&",dateAdd("&PE_DatePart_Y&",@years,"&PE_Now&"), "&PE_Now&",@strDomain,@strDomainpwd,@admi_pc,@years,@dom_ln,@admi_fax,@tech_fn,@tech_ph,@bill_ct,@bill_em,@dns_host1,@dns_host2,@dom_fn,@admi_co,@bill_ln,@bill_fax,@dns_ip1,@dom_fax,@admi_fn,@admi_ph,@tech_st,@tech_fax,@dns_ip2,@admi_ct,@admi_em,@dom_org,@admi_st,@dom_co,@dom_ph,@tech_pc,@bill_co,@dom_st,@dom_pc,@dom_ct,@dom_adr1,@dom_em,@tech_co,@bill_pc ,@admi_ln,@admi_adr1,@tech_ct,@tech_em,@bill_st,@bill_ph,@tech_ln,@tech_adr1,@bill_fn,@bill_adr1,@dom_org_m,@dom_fn_m,@dom_ln_m,@dom_adr_m,@dom_ct_m,@dom_st_m,@admi_org_m,@admi_fn_m,@admi_ln_m,@admi_adr_m,@admi_ct_m,@admi_st_m,@s_memo)",Args

		SetValue "identity",GetFieldValue("@@identity","domainlist","1","1"),Args
		SetValue "result",0,Args
'	else
'		SetValue "result",3003,Args
'	end if	
end sub

sub setdomainpwd(Args)
'修改域名密码
'@strDomain      varchar(50),
'@username
'@domainpwd            varchar(128),
'@result        tinyint  output 

	select_sql "select @uid=u_id from userdetail where u_name=@username",Args

	if not exists_sql_arg("select d_id from domainlist where strDomain=@strDomain and userid=@uid",Args) then
		SetValue "result","3001",Args
	else
		exec_sql_arg "update domainlist  set strDomainpwd=@domainpwd where strDomain=@strDomain",Args
		SetValue "result",0,Args
	end if
end sub

sub sp_renewDomain(Args)
'续费域名
'@strDomain     varchar(100),
'@username      varchar(20),
'@years         int,
'@result  int output

	select_sql "select @u_id=u_id from userdetail where u_name =@username",Args
	if not exists_sql_Arg("select * from domainlist where ( strdomain=@strDomain  or s_memo=@strDomain ) and userid=@u_id",Args) then
		SetValue "result",3001,Args
		exit sub
	end if

	select_sql "select @proid=proid,@isreglocal=isreglocal from domainlist where strdomain=@strdomain and userid=@u_id",Args
	if Args("isreglocal") then 
		proid=Args("proid")
	else
		proid=GetDomainType(Args("strdomain"))
	end if
	NeedPrice=getRenewCnPrice(Args("strdomain"),Args("years"))
	if NeedPrice="" then	
		NeedPrice=GetNeedPrice(Args("username"),proid,Args("years"),"renew")
	end if

	'if consume(Args("username"),NeedPrice,false,"renew-" & Args("strDomain"),"renew domain:" & Args("strDomain") ,proid,"") then
		exec_sql_arg "update domainlist set   years=years + @years,rexpiredate=dateadd("&PE_DatePart_Y&",@years,rexpiredate) where strDomain =  @strDomain or s_memo=@strDomain",Args
		SetValue "result",0,Args
	'else
	'	SetValue "result",3003,Args
	'end if
end sub

sub addmssql(Args)
'@databaseuser         varchar(50),
'@databasename         varchar(50),
'@dbupassword          varchar(50),
'@proid                varchar(10),
'@username	          varchar(50),
'@p_type			是否试用,
'@years                int,
'@ordersysid		varchar(10)   output ,
'@result             int output

	if exists_sql_arg("select dbname from databaselist where  dbname = @databasename or dbloguser=@databaseuser",Args) then
		SetValue "result",3001,Args
		Exit Sub
	end if

	if Args("databaseuser")="" or Args("databasename")="" then 
		SetValue "result",3002,Args
		Exit Sub
	end if
	select_sql "select @server_type=p_server, @dbsize=p_size   from  productlist where p_proId =@proid",Args
	select_sql "select @u_id = u_id from userdetail where u_name=@username",Args
	exec_sql_arg "insert into databaselist (dbsize,dbproid,dbname,dbloguser,dbpasswd,dbbuydate,dbexpdate, dbyear,dbf_id,dbu_id,dbbuytest) values (@dbsize,@proid,@databasename,@databaseuser,@dbupassword,"&PE_Now&",DATEADD("&PE_DatePart_Y&",@years,"&PE_Now&")   ,@years ,@u_id,@u_id,@p_type)",Args
	SetValue "resultId",GetFieldValue("@@identity","databaselist","1","1"),Args
	SetValue "identity",Args("resultId"),Args
	exec_sql_arg "insert into orderlist (o_typeid,o_type,o_ok,o_ownerid,o_producttype,o_memo) values (@resultId,@proid,'1',@u_id,2,@databasename)",Args
	SetValue "resultId",GetFieldValue("@@identity","orderlist","1","1")	,Args
	SetValue "ordersysid",Args("resultId"),Args
	exec_sql_arg "insert into [_order]  (o_key,o_moneysum,o_date) values(@ordersysid,0 ,"&PE_Now&")",Args
	exec_sql_arg "update orderlist set o_key=o_id where o_id = @resultId",Args
	
	SetValue "result",0,Args
end sub


sub checkorder_mssql(Args)
'@ordersysid         varchar(10),
'@strServerIp        varchar(20),
'@free				是否免费数据库
'@result            tinyint  output

	if Args("free")="true" then
		isFree=true
	else
		isFree=false
	end if

	select_sql "select @o_key=o_key,@dblistid=o_typeid from orderlist where o_id=@ordersysid",Args
	select_sql "select @years=dbyear,@proId=dbproid,@vbelong=dbu_id,@dbname=dbname,@buytest=dbbuytest from databaselist where dbsysid=@dblistid",Args
	select_sql "select @uname=u_name from userdetail where u_id=@vbelong",Args
	if Args("strServerIp")="no" then
		exec_sql_arg "UPDATE ORDERLIST set o_money=0 , o_ok=2 where o_id=@ordersysid",Args
		exec_sql_arg "update databaselist set  dbserverip='-1' where dbsysid=@dblistid",Args
		exec_sql_arg "update [_order] set o_ok=1 ,o_moneysum = o_moneysum + 0 where o_key=@o_key",Args
		SetValue "result",0,Args
		exit sub
	end if

	if isFree then
		NeedPrice=0
		addInfo="[赠送]"
	elseif Args("buytest") then
		if not isNumeric(demomssqlprice) then
			demomssqlprice=5
		end if
		NeedPrice=demomssqlprice
	else
		NeedPrice=GetNeedPrice(Args("uname"),Args("proID"),Args("years"),"new")
	end if

	SetValue "l_price",NeedPrice,Args

	if consume(Args("uname"),NeedPrice,true,"buy-" & Args("dbnmae"),"buy database:" & Args("dbname") & addInfo ,Args("proID"),Args("ordersysid")) then
		if not isFree and  not Args("buytest") then
			'VCP提成----------------
			Set VCPArgs=CreateObject("Scripting.Dictionary"):VCPArgs.compareMode=1
			VCPArgs.Add "cid",Args("vbelong")
			VCPArgs.Add "proid",Args("proId")
			VCPArgs.Add "uprice",NeedPrice
			VCPArgs.Add "years",Args("years")
			VCPArgs.Add "content","buydatabase"

			Call sp_vcp_record(VCPArgs)
			Set VCPArgs=nothing

			'------------------------
		end if

			exec_sql_arg "UPDATE ORDERLIST set o_ok=0 ,o_money=@l_price , o_okdate="&PE_Now&" where o_id=@ordersysid",Args
			exec_sql_arg "update databaselist set  dbstatus=0, dbserverip=@strServerIp where dbsysid=@dblistid",Args
			exec_sql_arg "update [_order] set o_moneysum = o_moneysum + @l_price where o_key=@o_key",Args
			SetValue "result",0,Args
	else
		SetValue "result",3003,Args
	end if
end sub

sub setdbpwd(Args)
'修改数据库密码
'@dbname      varchar(50),
'@dbpasswd            varchar(128),
'@username
'@result        tinyint  output 

	select_sql "select @uid=u_id from userdetail where u_name=@username",Args

	if not exists_sql_arg("select dbsysid from databaselist where dbname=@dbname and dbu_id=@uid",Args) then
		SetValue "result","3001",Args
	else
		exec_sql_arg "update databaselist  set dbpasswd=@dbpasswd where dbname=@dbname",Args
		SetValue "result",0,Args
	end if
end sub

sub Renewmssql(Args)
'数据库续费
'@databasename		varchar(100),
'@u_name		     varchar(50),
'@buyyears         int,
'@result  		  int output

	select_sql "select @u_id = u_id  from Userdetail where u_name = @u_name",Args
	if not exists_sql_arg("select dbsysid from databaselist where dbname=@databasename and dbu_id=@u_id",Args) then
		Setvalue "result",3001,Args
		Exit sub
	end if
	select_sql "select @sysid=dbsysid , @proId=dbproid from databaselist  where dbname = @databasename",Args
	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"renew")

	if consume(Args("u_name"),NeedPrice,true,"renew-" & Args("databasename"),"renew database:" & Args("databasename") ,Args("proId"),"") then
		exec_sql_arg "update databaselist  set dbyear = dbyear + @buyyears ,  dbexpdate = DATEADD("&PE_DatePart_Y&",@buyyears,dbexpdate)   where dbname = @databasename",Args
		Setvalue "result",0,Args
	else
		Setvalue "result",3001,Args
	end if
end sub

sub addnewmail(Args)
'开通新邮局
'm_mastername       varchar(20),
'@m_bindname         varchar(100),
'@username           varchar(20),
'@m_productId        varchar(10),
'@m_password         varchar(50),
'@m_years            int,
'@p_type			是否试用,
'@identity         varchar(10)   output ,
'@ordersysid         varchar(10)   output ,
'@result             int output

	if Args("m_bindname")="" then
		SetValue "result",3001,Args
		Exit sub
	end if

	if exists_sql_arg("select m_bindname from mailsitelist where m_bindname=@m_bindname",Args) then
		SetValue "result",3002,Args
		Exit sub		
	end if
	select_sql "select @u_id = u_id,@u_level = u_level from userdetail where u_name=@username",Args
    if Args("m_productId")="diymail" then
      Args("m_size")=Args("mailsize")
	  Args("p_maxmen")=Args("usernum")
	else
	select_sql "select @server_type=p_server, @m_size=p_size,@p_maxmen=p_maxmen  from  productlist where p_proId =@m_productId",Args
	end if
	if Args("m_size")="" then
		SetValue "result",3003,Args
		exit sub
	end if
	if trim(Args("m_productId"))="diymail" then
		Args("m_size")=Args("mailsize")*Args("usernum")
		Args("p_maxmen")=Args("usernum")
	end if

	exec_sql_arg "insert into mailsitelist (m_father,m_size,m_expiredate,m_buydate,m_years,m_mxuser,m_password,m_mastername,m_bindname,m_ownerid,m_productid,m_buytest) values (@u_id, @m_size,DATEADD("&PE_DatePart_Y&",@e_years,"&PE_Now&") , "&PE_Now&",@e_years,@p_maxmen,@m_password,@m_mastername,@m_bindname,@u_id,@m_productid,@p_type)",Args
	SetValue "resultId",GetFieldValue("@@identity","mailsitelist","1","1"),Args	
	SetValue "identity",Args("resultId"),Args
	exec_sql_arg "insert into orderlist (o_typeid,o_type,o_ok,o_ownerid,o_producttype,o_memo) values (@resultId,@m_productId,'1',@u_id,2,@m_bindname)",Args
	SetValue "ordersysid",GetFieldValue("@@identity","orderlist","1","1"),Args	
	SetValue "resultId",Args("ordersysid")	,Args
	exec_sql_arg "insert into [_order]  (o_key,o_moneysum,o_date) values(@ordersysid,0 ,"&PE_Now&")",Args
	exec_sql_arg "update orderlist set o_key=o_id where o_id = @resultId",Args
	SetValue "result",0,Args
end sub

sub checkorder_mail(Args)
'检测邮局订单
'@ordersysid         varchar(10),
'@strServerIp        varchar(20),
'@free				是否赠送邮局
'@result            tinyint  output
	if Args("free")="true" then
		isFree=true
	else
		isFree=false
	end if

	select_sql "select @o_key=o_key,@vmlistId=o_typeid from orderlist where o_id=@ordersysid",Args
	select_sql "select @years = m_years  ,@proId=m_ProductId,@vbelong=m_ownerid ,@vmailname=m_bindname,@buytest=m_buytest from mailsitelist  where m_sysid=@vmlistId",Args
	select_sql "select @uname=u_name from userdetail where u_id=@vbelong",Args

	if isFree then
		NeedPrice=0
		addInfo="[赠送]"
	elseif Args("buytest") then
		if not isnumeric(demomailprice) then
			demomailprice=15
		end if
		NeedPrice=demomailprice
	else
	    if trim(Args("proId"))="diymail" then
		NeedPrice=getDiyMailprice(Args("mailsize"),Args("usernum"))*Args("years")
		else
		NeedPrice=GetNeedPrice(Args("uname"),Args("proId"),Args("years"),"new")
		end if
	end if

	SetValue "l_price",NeedPrice,Args
	if Args("strServerIp")="no" then
		exec_sql_arg "UPDATE ORDERLIST set o_money=@l_price , o_ok=2 where o_id=@ordersysid",Args
		exec_sql_arg "update mailsitelist set  m_serverip='-1' where m_sysid=@vmlistId",Args
		exec_sql_arg "update [_order] set o_ok=1 ,o_moneysum = o_moneysum + @l_price where o_key=@o_key",Args
		SetValue "result",0,Args
		Exit sub
	end if

	if consume(Args("uname"),NeedPrice,true,"buy-" & Args("vmailname"),"buy mail" & Args("vmailname") & addInfo ,Args("proID"),Args("ordersysid")) then
		if not isFree and not Args("buytest") then
			'VCP提成----------------
			Set VCPArgs=CreateObject("Scripting.Dictionary"):VCPArgs.compareMode=1
			VCPArgs.Add "cid",Args("vbelong")
			VCPArgs.Add "proid",Args("proId")
			VCPArgs.Add "uprice",NeedPrice
			VCPArgs.Add "years",Args("years")
			VCPArgs.Add "content","buymail"

			Call sp_vcp_record(VCPArgs)
			Set VCPArgs=nothing

			'------------------------	
		end if
		
		select case Args("years")
		case 2
			Args("years")=Args("years")+1
		case 3
			Args("years")=Args("years")+2
		case 5
			Args("years")=Args("years")+5
		case 10
			Args("years")=Args("years")+10
		end select 



		exec_sql_arg "UPDATE ORDERLIST set o_ok=0 ,o_money=@l_price , o_okdate="&PE_Now&" where o_id=@ordersysid",Args
		exec_sql_arg "update mailsitelist set  m_status=0, m_serverip=@strServerIp,m_years=@years where m_sysid=@vmlistId",Args
		exec_sql_arg "update [_order] set o_moneysum = o_moneysum + @l_price where o_key=@o_key",Args
		SetValue "result",0,Args
	else
		SetValue "result",3003,Args
	end if	
end sub


sub setmailpwd(Args)
'修改邮局密码
'@m_bindname      varchar(50),
'@mailpasswd            varchar(128),
'@username
'@result        tinyint  output 

	select_sql "select @uid=u_id from userdetail where u_name=@username",Args

	if not exists_sql_arg("select m_sysid from mailsitelist where m_bindname=@m_bindname and m_ownerid=@uid",Args) then
		SetValue "result","3001",Args
	else
		exec_sql_arg "update mailsitelist set m_password=@mailpasswd where m_bindname=@m_bindname",Args
		SetValue "result",0,Args
	end if
end sub

sub Renewmail(Args)
'续费邮局
'@mailname		varchar(100),
'@u_name		    varchar(50),
'@buyyears       int,
'@result  		int output

	select_sql "select @u_id = u_id  from Userdetail where u_name = @u_name",Args
	if not exists_sql_arg ("select * from mailsitelist where m_bindname = @mailname and m_ownerid=@u_id",Args) then
		SetValue "result","3001",Args
		exit sub		
	end if

	select_sql "select @sysid=m_sysid , @proId=m_productId,@m_size=m_size,@m_mxuser=m_mxuser from mailsitelist  where m_bindname = @mailname and m_ownerid=@u_id",Args
    if Args("proId")="diymail" then
	NeedPrice=getDiyMailprice(Args("m_size")/Args("m_mxuser"),Args("m_mxuser"))*Args("buyyears")
	else
	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"renew")
	end if
	dim hdstr
	hdstr=""
	select case cint(Args("buyyears"))
	case 3
	e_year=4
	hdstr="【买3送1】"
	case 5
	e_year=8
	hdstr="【买5送3】"
	case 10
	e_year=15
	hdstr="【买10送5】"
		case else
	e_year=Args("buyyears")
	end select
 
'	die e_year
	if consume(Args("u_name"),NeedPrice,true,"renew-" & Args("mailname"),"renew mail" & hdstr & Args("mailname"),Args("proID"),"") then
		exec_sql_arg "update mailsitelist  set m_years = m_years  + "&e_year&" ,m_updatedate = "&PE_Now&" ,m_expiredate = DATEADD("&PE_DatePart_Y&","&e_year&",m_expiredate)   where m_bindname = @mailname and m_ownerid=@u_id",Args

		'自动续费赠品
		Set GiftArgs=CreateObject("Scripting.Dictionary"):GiftArgs.CompareMode=1
		GiftArgs.Add "username",Args("u_name")
		GiftArgs.Add "sysid",Args("sysid")
		GiftArgs.Add "years",Args("buyyears")
		GiftArgs.Add "type","mail"
		Call GiftRenew(GiftArgs)
		'------------
		
		SetValue "result",0,Args
	else
		SetValue "result","3002",Args
	end if
end sub

sub updateProduct(Args)
'同步数据库中的表个表内容
'@fdlist fd1,fd2,fd3
'@recordset,x1~|~x2<CRLF>$
'@tbname input
'@update input
'@result output
	
	fdlist=Args("fdlist")
	xupdate=Args("update")
	rrset=Args("recordset")
	tbname=Args("tbname")
	fdlist_array=split(fdlist,",")

	select case tbname
		case "pricelist"
			Pkey="p_proid"	
		case "productlist"
			Pkey="p_proid"
		Case "protofree"
			Pkey="proid"
		case "serverroomlist"
			Pkey="r_id"
		case "vps_price"
			Pkey="p_proid"
		case else
			SetValue "result",3000,Args
			Exit sub
	end select

	PkeyIndex=-1
	P2Key=-1
	P3Key=-1

	if tbname="pricelist" then
		for i=0 to Ubound(fdlist_array)
			fdName=lcase(fdlist_array(i))
			if fdname="p_u_level" then
				P2Key=i
				exit for
			end if
		next
	end if
	if tbname="vps_price" then
		for i=0 to Ubound(fdlist_array)
			fdName=lcase(fdlist_array(i))
			if fdname="v_room" then
				P3Key=i
				exit for
			end if
		next
	end if

	for i=0 to Ubound(fdlist_array)
		fdName=lcase(fdlist_array(i))
		if fdname=Pkey then
			PkeyIndex=i
			exit for
		end if
	next

	if PkeyIndex<0 then
		SetValue "result",3001,Args
		exit sub
	end if

	if tbname="pricelist" and P2Key=-1 then
		SetValue "result",3001,Args
		exit sub
	end if
	if tbname="vps_price" and P3Key=-1 then
		SetValue "result",3001,Args
		exit sub
	end if
	rrset_array=split(rrset,vbcrlf & "$")

	'
	if xupdate<>"true" Then
		Set deldic=CreateObject("Scripting.Dictionary")
		For Each line In rrset_array
			fields=split(line,"~|~") 
			if Ubound(fields)=Ubound(fdlist_array) Then
				strSeek=fields(PkeyIndex)
				If Not deldic.Exists(strSeek) Then 
					if tbname="pricelist" then
						sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "'"
					elseif tbname="vps_price" then
						sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "' and v_room=" & fields(P3Key)
					elseif tbname="serverroomlist" then
						sql="delete from " & tbname & " where " & Pkey & "=" & strSeek 
					else
						sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "'"
					end If
					deldic.add strSeek,sql
				End If 
			End if
		Next
		For Each k In deldic
			exec_sql deldic(k)
		next
	End if

	for j=0 to Ubound(rrset_array)
		fields=split(rrset_array(j),"~|~")

		if Ubound(fields)=Ubound(fdlist_array) then
			strSeek=fields(PkeyIndex)
			value_list=""
			for z=0 to Ubound(fields)
				SetValue fdlist_array(z),fields(z),Args
				value_list=value_list & "@" & fdlist_array(z) & ","
			next

			value_list=left(value_list,len(value_list)-1)

			if xupdate<>"true" then
'				if tbname="pricelist" then
'					sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "' and p_u_level=" & fields(P2Key)
'				elseif tbname="vps_price" then
'					sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "' and v_room=" & fields(P3Key)
'				elseif tbname="serverroomlist" then
'					sql="delete from " & tbname & " where " & Pkey & "=" & strSeek 
'				else
'					sql="delete from " & tbname & " where " & Pkey & "='" & strSeek & "'"
'				end if
'				exec_sql sql
				QState="insert into " & tbname & " (" & fdlist & ") values (" & value_list & ")"
				exec_sql_arg QState,Args
			else
				ex_sql="select " & Pkey & " from " & tbname & " where " & Pkey & "='" & strSeek & "'"
				if tbname="pricelist" then
					ex_sql=ex_sql & " and p_u_level=" & fields(P2Key)
				elseif tbname="vps_price" then
					ex_sql=ex_sql & " and v_room=" & fields(P3Key)
				end if
				
				if not exists_sql(ex_sql) then
					QState="insert into " & tbname & " (" & fdlist & ") values (" & value_list & ")"
					exec_sql_arg QState,Args
				end if
			end if

		end if
	next
	SetValue "result",0,Args
end sub


Sub UpgradeMail(Args)
'升级企业邮局
'@m_bindname     varchar(50),
'@username      varchar(50),
'@t_productid     varchar(20),
'@updateType  varchar(20),OldupdateType/NewupdateType
'@result int output

	select_sql "select @uid=u_id,@ulevel=u_level from userdetail where u_name=@username",Args
	select_sql "select @m_sysid=m_sysid,@proid=m_productid,@m_buyDate=m_buydate,@m_years=m_years,@m_size=m_size,@m_mxuser=m_mxuser from mailsitelist where m_ownerid=@uid and m_bindname=@m_bindname",Args
	if Args("m_years")="" then
		SetValue "result",3001,Args
		Exit sub
	end if

	if Args("m_years")=1 then
		oneYear=true
	else
		oneYear=false
	end if

	if not oneYear then SetValue "updateType","OldupdateType",Args

	UsedDays=DateDiff("d",Args("m_buydate"),Now)
	leftDays=DateDiff("d",Now,DateAdd("yyyy",Args("m_years"),Args("m_buydate")))
	TotalDays=UsedDays+LeftDays
	
    if Args("proid")="diymail" then
	  nt=split(Args("t_productid"),":")
      Args("oldprice")=getDiyMailprice(Args("m_size")/Args("m_mxuser"),Args("m_mxuser"))
      Args("newprice")=getDiyMailprice(nt(0),nt(1))
	  Args("newsize")=nt(0)*nt(1)
	  Args("newmax")=nt(1)
	  Args("t_productid")="diymail"
    else
		select_sql "select @oldprice=p_price from pricelist where p_proid=@proid and p_u_level=@ulevel",Args
		select_sql "select @newsize=p_size,@newmax=p_maxmen from productlist where p_type=2 and p_proid=@t_productid",Args
		select_sql "select @newprice=p_price from pricelist where p_proid=@t_productid and p_u_level=@ulevel",Args
    end if
	if Args("newprice")="" or Args("oldprice")="" then
		SetValue "result",3002,Args
		Exit sub
	end if

	if Args("updateType")="OldupdateType" then
		' NeedCost=Cint(Ccur(Args("newprice"))/365*LeftDays-(Ccur(Args("oldprice"))*Args("m_years"))*(1-UsedDays/TotalDays))
		NeedCost=(Ccur(Args("newprice"))-Ccur(Args("oldprice")))/365*leftDays
	else
		 NeedCost=Cint(Ccur(Args("newprice"))-Ccur(Args("oldprice"))*(1-UsedDays/365.0))
	end if
	
	if NeedCost<50 then NeedCost=50

	if consume(Args("username"),NeedCost,true,"upgrade-" & Args("m_bindname"),"upgrade mail " & Args("proid") & "->" & Args("t_productid") ,Args("t_productid"),"") then
		if Args("updateType")="OldupdateType" then
			exec_sql_arg "update mailsitelist set m_size=@newsize,m_ProductId=@t_productid,m_mxuser=@newmax  where m_sysid=@m_sysid",Args
		else
			exec_sql_arg "update mailsitelist set m_buydate="&PE_Now&",m_expiredate = DATEADD("&PE_DatePart_Y&",m_years,"&PE_Now&"),m_size=@newsize,m_ProductId=@t_productid,m_mxuser=@newmax  where m_sysid=@m_sysid",Args		
		end if
		
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
	
end Sub

Sub UpgradeMssql(Args)
'升级数据库
'@dbname     varchar(50),
'@username      varchar(50),
'@t_productid     varchar(20),
'@updateType  varchar(20),OldupdateType/NewupdateType
'@result int output

	select_sql "select @uid=u_id,@ulevel=u_level from userdetail where u_name=@username",Args
	select_sql "select @dbsysid=dbsysid,@proid=dbproid,@buyDate=dbbuydate,@years=dbyear from databaselist where dbu_id=@uid and dbname=@dbname",Args
	if Args("years")="" then
		SetValue "result",3001,Args
		Exit sub
	end if

	'if Args("years")=1 then
		'oneYear=true
	'else
		'oneYear=false
	'end if

	'if not oneYear then SetValue "updateType","OldupdateType",Args
'
	'UsedDays=DateDiff("d",Args("buydate"),Now)
	'leftDays=DateDiff("d",Now,DateAdd("yyyy",Args("years"),Args("buydate")))
	'TotalDays=UsedDays+LeftDays
	
	'select_sql "select @oldprice=p_price from pricelist where p_proid=@proid and p_u_level=@ulevel",Args
	select_sql "select @newsize=p_size,@newmax=p_maxmen from productlist where p_type=7 and p_proid=@t_productid",Args
	'select_sql "select @newprice=p_price from pricelist where p_proid=@t_productid and p_u_level=@ulevel",Args

	'if Args("newprice")="" or Args("oldprice")="" then
		'SetValue "result",3002,Args
		'Exit sub
	'end if

	'if Args("updateType")="OldupdateType" then
		' NeedCost=Cint(Ccur(Args("newprice"))/365*LeftDays-(Ccur(Args("oldprice"))*Args("years"))*(1-UsedDays/TotalDays))
	'else
		 'NeedCost=Cint(Ccur(Args("newprice"))-Ccur(Args("oldprice"))*(1-UsedDays/365.0))
	'end if
	
	'if NeedCost<50 then NeedCost=50
	set up=new upmssql_class:up.u_sysid=Args("uid"):up.setdataid=Args("dbsysid")
	
	NeedCost=up.getupNeedPrice(Args("t_productid"),Args("new_room"))
	set up=nothing
	if consume(Args("username"),NeedCost,true,"upgrade-" & Args("dbname"),"upgrade database " & Args("proid") & "->" & Args("t_productid") ,Args("t_productid"),"") then
		'if Args("updateType")="OldupdateType" then
			exec_sql_arg "update databaselist set dbsize=@newsize,dbproid=@t_productid  where dbsysid=@dbsysid",Args
		'else
			'exec_sql_arg "update databaselist set dbbuydate="&PE_Now&",dbexpdate = dateDiff("&PE_DatePart_Y&",dbyear,"&PE_Now&"),dbsize=@newsize,dbproid=@t_productid  where dbsysid=@dbsysid",Args		
		'end if
		
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
end Sub

sub	subInvoice(Args)
'申请发票
'@username
'@subject 抬头
'@fundamount 金额
'@purpose 发票内容
'@address 地址
'@postcode 邮编
'@receiver 收信人
'@telephone 电话
'@sendtype 邮寄方式
'invoiceid output
'@result output
	pcost=0
	if  Ccur(Args("fundamount"))>=fapiao_cost_leve then
		select case Args("sendtype")
			case 3,2
				pcost=0
			case 0
			pcost=fapiao_cost_0
			case 1
				pcost=fapiao_cost_1
			case else
				pcost=5
		end select
	else
		select case Args("sendtype")
			case 0
				pcost=fapiao_cost_0
			case 1
				pcost=fapiao_cost_1
			case 2
				pcost=fapiao_cost_2
			case 3
				pcost=fapiao_cost_3
			case else
				pcost=5
		end select
	end if
	
	
	fpflstr="邮寄费"&formatnumber(pcost,2,-1,-1)&"元"
	
	if chk_ly_num(fapiao_cost_feilv)>0 then
	dim fpflss,fpflstr
	fpflss=Args("fundamount")*chk_ly_num(fapiao_cost_feilv)
	fpflstr=" 开发票手续费"&formatnumber(fpflss,2,-1,-1)&"元 "
	pcost=pcost+fpflss
 
	end if
	
	
	'response.Write( Args("sendtype")&"<BR>"&pcost)
	'response.End()
	if pcost>0 then
		select_sql "select @u_usemoney=u_usemoney from userdetail where u_name=@username",Args
		if Ccur(Args("u_usemoney"))<pcost then
			Setvalue "result",3000,Args
			Exit sub
		end if
	end if
	
	select_sql "select @total=u_usemoney+u_resumesum,@invoice=u_invoice from userdetail where u_name=@username",Args
	if Args("total")="" then
		Setvalue "result",3001,Args
		Exit sub
	end if
	valid_charge=Args("total")-Args("invoice")
	if Ccur(Args("fundamount"))>valid_charge then
		Setvalue "result",3002,Args
		Exit sub
	end if

	if pcost>0 then
		cid="fapaio-" & round(timer())
		if not consume(Args("username"),pcost,false,cid,fpflstr&"","","") then
			Setvalue "result",3000,Args
			Exit sub
		end if
	end if
	
	
	exec_sql_arg "Insert Into FaPiao (f_username,f_title,f_money,f_content,f_address,f_zip,f_receive,f_telphone,f_status,f_Date,f_special,f_sendtype,f_memo,f_receive_cp,f_taxcode) values (@username,@subject,@fundamount,@purpose,@address,@postcode,@receiver,@telephone,0,"&PE_Now&","&PE_False&",@sendtype,@memo,@receive_cp,@taxcode)",Args
	SetValue "invoiceid",GetFieldValue("@@identity","fapiao","1","1"),Args
	exec_sql_arg "update userdetail set u_invoice=u_invoice+@fundamount where u_name=@username",Args

	SetValue "result",0,Args
end sub


sub subQuestion(Args)
'提交有问必答
'@username
'@subject:问题标题
'@content:问题内容
'@domain:相关域名
'@fid:上一个问题
'@pic:图片地址
'@type:类别
'@type:问题类别
'@result output
'@qid	output
	if Args("subject")="" or Args("content")="" then
		SetValue "result",3001,Args
		exit sub
	end If

	Args("content")=Replace(Args("content"),vbcrlf,"<br>")
	Args("content")=Replace(Args("content")," ","&nbsp;")
	Args("content")=Replace(Args("content"),"《br》","<br>")

	sql="select * from question where q_id=0"
	rs11.open sql,conn,3,3
	rs11.addnew()
	rs11("q_user_name")=Args("username")
	rs11("q_fid")=Args("fid")
	rs11("q_user_domain")=Args("domain")
	rs11("q_subject")=Args("subject")
	rs11("q_content")=Args("content")
	rs11("q_type")=Args("type")
	rs11("q_reg_time")=Now()
	rs11("q_require_time")=Now()
	rs11("q_status")=PE_True
	rs11("q_from")=""
	rs11("q_pic")=Args("pic")
	rs11.update
	rs11.close
'	exec_sql_arg "insert into question (q_user_name,q_fid,q_user_domain,q_subject,q_content,q_type,q_reg_time,q_require_time,q_status,q_from,q_pic) values (@username,@fid,@domain,@subject,@content,@type,now(),now(),true,'',@pic)",Args
	SetValue "qid",GetFieldValue("@@identity","question","1","1"),Args
	SetValue "result",0,Args
end sub
Sub PayDemoMssql(Args)
'试用mssql转正
'@dbname		varchar(100),
'@u_name		varchar(50),
'@result  		int output,

	select_sql "select @u_id=u_id  from Userdetail where u_name = @u_name",Args
	if  not exists_sql_arg ("select * from databaselist  where dbname =@dbname and dbu_id=@u_id and dbbuytest ="&PE_True&"",Args) then
		SetValue "result",3001,Args
		exit sub
	end if

	select_sql "select @sysid=dbsysid ,@buyyears=dbyear,@proId=dbProid from databaselist where dbname =@dbname and dbu_id=@u_id",Args
	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"new")

	if consume(Args("u_name"),NeedPrice,true,"payDemo-" & Args("dbname"),"paydemo mssql:" & Args("dbname") ,Args("proId"),"") then
		exec_sql_arg "update databaselist set dbbuytest="&PE_False&" where dbsysid=@sysid",Args
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
end sub
Sub PayDemoMail(Args)
'试用邮局转正
'@m_bindname		varchar(100),
'@u_name		varchar(50),
'@result  		int output,

	select_sql "select @u_id=u_id  from Userdetail where u_name = @u_name",Args
	if  not exists_sql_arg ("select * from mailsitelist  where m_bindname =@m_bindname and m_ownerid=@u_id and m_buytest ="&PE_True&"",Args) then
		SetValue "result",3001,Args
		exit sub
	end if

	select_sql "select @sysid=m_sysid ,@buyyears=m_years,@proId=m_ProductId from mailsitelist  where m_bindname =@m_bindname and m_ownerid=@u_id",Args
	NeedPrice=GetNeedPrice(Args("u_name"),Args("proId"),Args("buyyears"),"new")

	if consume(Args("u_name"),NeedPrice,true,"payDemo-" & Args("m_bindname"),"paydemo mail:" & Args("m_bindname") ,Args("proId"),"") then
		exec_sql_arg "update mailsitelist set m_buytest="&PE_False&" where m_sysid=@sysid",Args
		SetValue "result",0,Args
	else
		SetValue "result",3004,Args
	end if
end sub

sub SynData(Args)
'同步所有业务
'@ownername 所有业务同步到该用户下
'@tbname 表名
'@fdlist 字段名
'@recordset 信息
'result
	
	select_sql "select @uid=u_id from userdetail where u_name=@ownername",Args
	if Args("uid")="" then
		SetValue "result",3001,Args
		Exit sub
	end if

	select case Args("tbname")
		case "vhhostlist"
			Pkeyname="s_comment"
			fd_owner="s_ownerid"
		case "mailsitelist"
			Pkeyname="m_bindname"
			fd_owner="m_ownerid"
		case "domainlist"
			Pkeyname="strdomain"
			fd_owner="userid"
		case "databaselist"
			Pkeyname="dbname"	
			fd_owner="dbu_id"
		case "hostrental"
			Pkeyname="allocateip"
			fd_owner="u_name"
		case else
			Setvalue "result",3001,Args
			Exit sub
	end select

	Pkeyindex=-1
	Pownerindex=-1

	fdlist_array=split(Args("fdlist"),",")
	fdlist_quota=""

	for i=0 to Ubound(fdlist_array)
		fdname=Lcase(fdlist_array(i))
		if fdname=Pkeyname then
			Pkeyindex=i
		end if

		if fdname=fd_owner then
			Pownerindex=i
		end if
	next

	if Pkeyindex=-1 or Pownerindex=-1 then
		Setvalue "result",3002,Args
		exit sub
	end if

	rrset=split(Args("recordset"),vbcrlf)
	for j=0 to Ubound(rrset)
		fields=split(rrset(j),"~|~")
		if Ubound(fields)=Ubound(fdlist_array) then
			strSeek=fields(Pkeyindex)
			Sql_where=Pkeyname & "='" & strSeek & "'"
			ck_sql="select " & Pkeyname & " from " & Args("tbname") & " where " & Sql_where
			
			if not exists_sql(ck_sql) then
				value_list=""
				for z=0 to Ubound(fields)
					SetValue fdlist_array(z),fields(z),Args
					value_list=value_list & "@" & fdlist_array(z) & ","
					if z=Pownerindex then
						if Args("tbname")="hostrental" then
						SetValue fdlist_array(z),Args("ownername"),Args
						else
						SetValue fdlist_array(z),Args("uid"),Args
						end if
					end if
				next
				value_list=left(value_list,len(value_list)-1)
				QState="insert into " & Args("tbname") & " (" & Args("fdlist") & ") values (" & value_list & ")"
				'response.Write(QState&"<br>")
				exec_sql_arg QState,Args
			end if
		end if
	next
	SetValue "result",0,Args
end sub

sub synPasswd(Args)
'同步所有业务密码
'@recordset
'@result
	rrset=split(Args("recordset"),vbcrlf)
	for i=0 to Ubound(rrset)
		fields=split(rrset(i),"~|~")

		if Ubound(fields)=2 then
			select case fields(0)
				case "vh"
					tbname="vhhostlist"
					fdname="s_comment"
					fdpwd="s_ftppassword"
				case "dm"
					tbname="domainlist"
					fdname="strdomain"
					fdpwd="strdomainpwd"
				case "ma"
					tbname="mailsitelist"
					fdname="m_bindname"
					fdpwd="m_password"
				case "db"
					tbname="databaselist"
					fdname="dbname"
					fdpwd="dbpasswd"
				case else
					tbname="NONE"
			end select

			if tbname<>"NONE" then
				Qstate="update " & tbname & " set " & fdpwd & "='" & fields(2) & "' where " & fdname & "='" & fields(1) & "'"
				exec_sql Qstate
			end if
		end if
	next
	
	SetValue "result",0,Args
end sub

sub GiftRenew(Args)
'赠品续费
'@username
'@sysid
'@years
'@type
'@result
	select_sql "select @uid=u_id from userdetail where u_name=@username",Args
	select case Args("type")
		case "mail"
			select_sql "select @pre1=pre1,@pre2=pre2,@pre3=pre3,@pre4=pre4,@proid=m_productid from mailsitelist where m_sysid=@sysid and m_ownerid=@uid",Args
		case "vhost"
			select_sql "select @pre1=pre1,@pre2=pre2,@pre3=pre3,@pre4=pre4,@proid=s_productid from vhhostlist where s_sysid=@sysid and s_ownerid=@uid",Args
		case else
			SetValue "result",3001,Args
			exit sub
	end select

	if Args("proid")="" then
			SetValue "result",3002,Args
			exit sub
	end if

	select_sql "select @Flag=addTime from protofree where proid=@proid",Args
	if Args("Flag")="" then
			SetValue "result",3003,Args
			exit sub
	end if

	Flags=split(Args("Flag"),",")

	if Flags(0)="1" and isNumeric(Args("pre1")) then
		select_sql "select @strdomain=strdomain from domainlist where d_id=@pre1",Args

		if Args("strdomain")<>"" then
			exec_sql_arg "update domainlist set set years=years+1,rexpiredate=DATEADD("&PE_DatePart_Y&",1,rexpiredate) where strdomain=@strdomain",Args
			Call consume(Args("username"),0,false,"renew-" & Args("strdomain"),"renew domain:" & Args("strdomain") & "[赠品]","","")
		end if
	end if

	if Flags(1)="1" and isNumeric(Args("pre2")) then
		select_sql "select @s_comment=s_comment from vhhostlist where s_sysid=@pre2",Args
		
		if Args("s_comment")<>"" then
			exec_sql_arg "update vhhostlist set s_updatedate="&PE_Now&",s_year=s_year+@years,s_expiredate=DATEADD("&PE_DatePart_Y&",@years,s_expiredate) where s_comment=@s_comment",Args
			Call consume(Args("username"),0,false,"renew-" & Args("s_comment"),"renew vhost:" & Args("s_comment") & "[赠品]","","")
		end if
	end if
	
	if Flags(2)="1" and isNumeric(Args("pre3")) then
		select_sql "select @mysqlname=s_comment from vhhostlist where s_sysid=@pre3",Args
		
		if Args("mysqlname")<>"" then
			exec_sql_arg "update vhhostlist set s_updatedate="&PE_Now&",s_year=s_year+@years,s_expiredate=DATEADD("&PE_DatePart_Y&",@years,s_expiredate) where s_comment=@mysqlname",Args
			Call consume(Args("username"),0,false,"renew-" & Args("mysqlname"),"renew mysql:" & Args("mysqlname") & "[赠品]","","")
		end if
		
	end if

	if Flags(3)="1" and isNumeric(Args("pre4")) then
		select_sql "select @dbname=dbname from databaselist where dbsysid=@pre4",Args
		
		if Args("dbname")<>"" then
			exec_sql_arg "update databaselist set dbyear=dbyear+@years,dbexpdate=DATEADD("&PE_DatePart_Y&",@years,dbexpdate) where dbname=@dbname",Args
			Call consume(Args("username"),0,false,"renew-" & Args("dbname"),"renew mssql:" & Args("dbname") & "[赠品]","","")
		end if
	end if

	SetValue "result",0,Args
end sub

sub getFdlistAndExclude(Args)
'获取字段列表，已有产品列表，用于业务同步
'@tbname 表名
'@result output
'@fdlist output
'@exclude output

	select case Args("tbname")
		case "vhhostlist"
			fd_sys="s_sysid"
			fd_ident="s_comment"
		case "domainlist"
			fd_sys="d_id"
			fd_ident="strdomain"
		case "mailsitelist"
			fd_sys="m_sysid"
			fd_ident="m_bindname"
		case "databaselist"
			fd_sys="dbsysid"
			fd_ident="dbname"
		case "hostrental"
			fd_sys="id"
			fd_ident="allocateip"
		case else
			SetValue "result",3001,Args
			exit sub
	end select

	fdindex=-1
	fdlist=""

	Set localRs=conn.Execute("select * from " & Args("tbname") & " where 1=2")
	for i=0 to localRs.fields.count-1
		fdname=Lcase(localRs.fields(i).name)
		if fdname<>fd_sys then
			fdlist=fdlist & fdname & ","
		else
			fdindex=i
		end if
	next

	localRs.close:set localRs=nothing

	if fdindex=-1 then
			SetValue "result",3001,Args
			exit sub
	end if

	fdlist=left(fdlist,len(fdlist)-1)

	Set localRs=conn.Execute("select " & fd_ident & " from " & Args("tbname"))
	if localRs.eof then
		SetValue "fdlist",fdlist,Args
		Setvalue "exclude","",Args
		SetValue "result",0,Args
		exit sub
	end if

	exclude_str=localRs.GetString(,,,",","")
	localRs.close:set localRs=nothing
	
	if right(exclude_str,1)="," then exclude_str=left(exclude_str,len(exclude_str)-1)

	SetValue "fdlist",fdlist,Args
	Setvalue "exclude",exclude_str,Args
	SetValue "result",0,Args
end sub

function getTableFdlist(ByVal tbname,ByVal sysfd)
	'获取表的字段名，用于产品同步,tbname表名,sysfd id字段名
	Set localRs=conn.Execute("select * from " & tbname & " where 1=2")
	fdlist=""
	for i=0 to localRs.fields.count-1
		if localRs.fields(i).name<>sysfd then
			fdlist=fdlist & localRs.fields(i).name
			if i<localRs.fields.count-1 then
				fdlist=fdlist & ","
			end if
		end if
	next
	localRs.close:Set localRs=nothing
	getTableFdlist=fdlist
end function

sub SynData_record(Args)
	'同步单笔业务
	'@ownername 所有业务同步到该用户下
	'@tbname 表名
	'@ident 标识
	'@fdlist 字段名
	'@recordset 信息
	'result

	tbname=Args("tbname")
	select case tbname
		case "vhhostlist"
			ident_fields="s_comment"
			fdowner="s_ownerid"
			fd_sys="s_sysid"
		case "domainlist"
			ident_fields="strdomain"
			fdowner="userid"
			fd_sys="d_id"
		case "mailsitelist"
			ident_fields="m_bindname"
			fdowner="m_ownerid"
			fd_ident="m_bindname"
			fd_sys="m_sysid"
		case "databaselist"
			ident_fields="dbname"
			fdowner="dbu_id"
			fd_sys="dbsysid"
		case "hostrental"
			ident_fields="allocateip"
			fdowner="u_name"
			fd_sys="id"
		case else
			SetValue "result",2002,Args
			exit sub
	end select	
	Set lrs=CreateObject("Adodb.RecordSet")
	if tbname="hostrental" then
		QState="select * from " & tbname & " where " & ident_fields & "='" & Args("ident") & "' and " & fdowner & "='" & Args("ownername") &"'"
	else
		select_sql "select @uid=u_id from userdetail where u_name=@ownername",Args		
		QState="select * from " & tbname & " where " & ident_fields & "='" & Args("ident") & "' and " & fdowner & "=" & Args("uid")
	end if
	lrs.open QState,conn,3,3
	if lrs.eof then
		Setvalue "result",3001,Args
		exit sub
	end If
	
	fdlistarr=split(Args("fdlist"),",")
	fdvalue=split(Args("recordset"),"~|~")
	'Response.write Args("fdlist")&"<BR>"&Args("recordset")
	if Ubound(fdlistarr)<>Ubound(fdvalue) then
		SetValue "result",3002,Args
		exit sub
	end if

	for iIndex=0 to Ubound(fdlistarr)
	     fvalue=fdvalue(iIndex)
		 if fdlistarr(iIndex)="s_bindings" and trim(fvalue)="" then
		 fvalue="-"
		 end if
	
		if fdlistarr(iIndex)<>fdowner and fdlistarr(iIndex)<>ident_fields and fdlistarr(iIndex)<>fd_sys and fvalue<>"" then
		
		 '过滤业务电话不同步
		 if trim(tbname)="hostrental" then
				if trim(ucase(fdlistarr(iIndex)))=trim(ucase("Name")) or trim(ucase(fdlistarr(iIndex)))=trim(ucase("telephone"))  or ucase(fdlistarr(iIndex))=ucase("address") or ucase(fdlistarr(iIndex))=ucase("Email")  or ucase(fdlistarr(iIndex))=ucase("qq")  or ucase(fdlistarr(iIndex))=ucase("fax") or ucase(fdlistarr(iIndex))=ucase("Company") then
				'不更新
				
				
				Else
					If "snapadv"=LCase(fdlistarr(iIndex)) Then 
						lrs(fdlistarr(iIndex))=iif(fdvalue(iIndex),1,0)
					else
						 lrs(fdlistarr(iIndex))=fdvalue(iIndex)
					End if
				  'response.write(fdlistarr(iIndex)&"="&fdvalue(iIndex)&"<BR>")
				end if
		 else
		     lrs(fdlistarr(iIndex))=fdvalue(iIndex)
		 end if
		 
		 
		end if
	next
'response.End()
	lrs.update
	lrs.close
	Set lrs=nothing
	setValue "result",0,Args
end sub



'时间同步函数
'2012-8-24
'ly
function syn_server_time(ptype,synret)
on error resume next
syn_server_time=true

for each sysli in split(synret,vbcrlf)
   if sysli<>"" then
     				templi=split(sysli,",")
		if ubound(templi)>=2 then
				
				sql=""			
				select case ptype
				case "vh"
			    sql="update vhhostlist set s_buydate='"&templi(1)&"',s_expiredate='"&DateAdd("yyyy",templi(2),templi(1))&"',s_year="&templi(2)&" where s_comment='"&templi(0)&"'"
				case "dm"
				sql="update domainlist set regdate='"&templi(1)&"',rexpiredate='"&DateAdd("yyyy",templi(2),templi(1))&"',years="&templi(2)&" where strDomain='"&templi(0)&"'"
				case "vm"
				sql="update mailsitelist set m_buydate='"&templi(1)&"',m_expiredate='"&DateAdd("yyyy",templi(2),templi(1))&"',m_years="&templi(2)&" where m_bindname='"&templi(0)&"'"
			 case "svr"
			 stime=year(templi(1))&"/"&month(templi(1))&"/"&day(templi(1))
			 years=clng(templi(2)/12+0.5)
			preday=clng(templi(3))
		 sql="update hostrental set StartTime='"&stime&"',AlreadyPay="&templi(2)&",Years="&years&",preday="&preday&" where allocateip='"&templi(0)&"'"
 
				case "db"
	sql="update databaselist set dbbuydate='"&templi(1)&"',dbexpdate='"&DateAdd("yyyy",templi(2),templi(1))&"',dbyear="&templi(2)&" where dbname='"&templi(0)&"'"
				
			end select
					
					
				if sql<>"" then
				 '   response.Write("<hr>"&sql&"</hr>")
					conn.execute(sql)
				end if 			
		 end if
	end if
	
	
next

if err then
syn_server_time=false
err.clear
end if
				
end function



'2012-08-22
'按时间取产品名称
'ly
sub getProductName(Args)
wheredb=""
plnum=100

	select case Args("ptype")
		case "vh"
			fd_db="s_comment"
			tbname="vhhostlist"
			wheredb=" and dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate)<"&Args("sysDay")
		case "dm"
	        fd_db="strDomain"
			tbname="domainlist"
			wheredb=" and dateDiff("&PE_DatePart_D&","&PE_Now&",rexpiredate)<"&Args("sysDay")
		case "vm"
			fd_db="m_bindname"
			tbname="mailsitelist"
			wheredb=" and dateDiff("&PE_DatePart_D&","&PE_Now&",m_expiredate)<"&Args("sysDay")
		case "db"
			fd_db="dbname"
			tbname="databaselist"
			wheredb=" and dateDiff("&PE_DatePart_D&","&PE_Now&",dbexpdate)<"&Args("sysDay")
		case "svr"
			fd_db="allocateip"
			tbname="hostrental"
		case else
			SetValue "result",3001,Args
			exit sub
	end select
 
	fdlist=""
	
	if clng(Args("sysDay"))>0 then
	   sql="select "&fd_db&" from " &tbname & " where  "&fd_db&"<>'' "&wheredb
	   else
	 sql="select "&fd_db&" from " &tbname & " where  "&fd_db&"<>''"  
	   end if
 '   response.Write(sql&"<hr>")
	Set localRs=conn.Execute(sql)
	num=0
	do while not localRs.eof
	num=num+1
	  if fdlist="" then
	  fdlist=localRs(0)
	  else
	  fdlist=fdlist&","&localRs(0)
	  end if
	  
	  if num mod plnum=0 then
	  fdlist=fdlist&"|$$|"
	  end if
	  
	localRs.movenext
	loop

'	response.Write("<hr>"&fdlist&"<hr>")
	if fdlist<>"" then
	    SetValue "fdlist",fdlist,Args
		SetValue "result",0,Args
		else
	    SetValue "result",100,Args
	end if


end sub


%>