<!--#include virtual="/config/ParseCommand.asp" -->
<%
'glbSetup_sub_Question 'ȫ�����ã����ʱش��Ƿ������ύ
'glbSetup_sub_Invoice 'ȫ�����ã���Ʊ�Ƿ������ύ

function ToParseAPICommand(ByVal cmdString)
	'ͳһ������������
	intPos=instr(cmdString,vbcrlf)
	ACT_PRODUCT=left(cmdString,intPos-1) '��ȡ���
	intPosJ=instr(intPos+1,cmdString,vbcrlf)
	ACT_TYPE=mid(cmdString,intPos+2,intPosJ-intPos-2) '��ȡ����
	ACT_ENTITY=getInputAPI("entityname") '��ȡʵ��

	select case ACT_PRODUCT
	case "other"
		select case ACT_TYPE
			case "get"
				select case ACT_ENTITY
					case "tablecontent"
							ToParseAPICommand=api_other_get_tablecontent() '��ȡ��Ʒ�б�
					case "usemoney"
							ToParseAPICommand=api_other_get_usemoney() '��ȡ���ý��
					case "pricecompare"
							ToParseAPICommand=api_other_get_compare()	'��ȡ�ɱ���
					
					case else
						ToParseAPICommand=PCommand(cmdString,userid)
				end select		
			case "sync"
					select case ACT_ENTITY
						case "vhost"
							ToParseAPICommand=api_other_sync_vhost()'ͬ����������
						case "domain"
							ToParseAPICommand=api_other_sync_domain()'ͬ����������
						case "mail"
							ToParseAPICommand=api_other_sync_mail()'ͬ���ʾ�����
						case "database"
							ToParseAPICommand=api_other_sync_database()'ͬ�����ݿ�
						case "server"
							ToParseAPICommand=api_other_sync_server()'ͬ��������
						case "allpassword"
							ToParseAPICommand=api_other_sync_allpassword()'ͬ����������
						case else
							ToParseAPICommand=PCommand(cmdString,userid)
					end select
			case else
				ToParseAPICommand=PCommand(cmdString,userid)
		end select
	case else
		ToParseAPICommand=PCommand(cmdString,userid)
	end select
end function
function api_other_sync_server()

	field_list=getInputAPI("fdlist")
	rrset_exclude=getInputAPI("exclude")
	return_rrset=getSyncData("hostrental",field_list,"u_name",rrset_exclude)
	api_other_sync_server="200 ok" & vbcrlf & _
					"fdlist:" & field_list & vbcrlf& _
					"recordset:" & return_rrset & vbcrlf& _
					"." & vbcrlf
end function
function api_other_get_productlist()
	'��ȡ��Ʒ�б�
	'��ȡ��Ʒ�б�
	'===�����ʽ
	'other<CRLF>
	'get<CRLF>
	'entityname:tablecontent<CRLF>
	'tbname:pricelist/productlist<CRLF>
	'fieldlist:fd1,fd2,fd3����<CRLF>

	'==���ظ�ʽ
	'200 info<CRLF>
	'fieldlist:fd1,fd3����<CRLF>
	'recordset:
	'va1,va3<CRLF>
	'va1,va3<CRLF>
	'.<CRLF>

	AllowGet=Array("productlist","pricelist","protofree") '�����ȡȫ�����ݵı���
	
	tbname=Lcase(getInput("tbname"))
	if not inArray(AllowGet,tbname) then
		api_other_get_productlist="500 ����ı���"
		exit function
	end if
	
	fdlist=Lcase(getInput("fieldlist"))
	fdlist_array=split(fdlist,",")

	qstate="select * from " & tbname & " where 1=2"
	Set localRs=conn.Execute(qstate)

	fdlist=""
	for i= 0 to Ubound(fdlist_array)
		ifound=false
		for k=0 to localRs.fields.count-1
			if lcase(localRs.fields(k).name)=fdlist_array(i) then
				ifound=true
				exit for
			end if
		next
		if ifound then
			fdlist=fdlist & fdlist_array(i) & ","
		end if
	next

	localRs.close
	Set localRs=nothing

	if instr(fdlist,",")=0 then
		api_other_get_productlist="500 invalid fieldlist" & vbcrlf
		exit function
	end if

	fdlist=left(fdlist,len(fdlist)-1)

	sql="select " & fdlist & " from " & tbname
	Set localRs=conn.Execute(sql)
	strRecord=localRs.getString(,,"~|~",vbcrlf & "$","")
	localRs.close:Set localRs=nothing

	api_other_get_productlist="200 ok" & vbcrlf
	api_other_get_productlist =  api_other_get_productlist & "fieldlist:" & fdlist & vbcrlf
	api_other_get_productlist =  api_other_get_productlist & "recordset:" & strRecord & vbcrlf & "." & vbcrlf
end function

function api_other_get_usemoney()
	'��ȡ���ý��
	'===�����ʽ
	'other<CRLF>
	'get<CRLF>
	'entityname:usemoney<CRLF>
	'.<CRLF>

	'===������ʽ
	'200 ok<CRLF>
	'usemoney:���ý��<CRLF>
	'.<CRLF>

	u_money=getFieldValue("u_usemoney","userdetail","u_name",userid)
	if u_money="" then
		api_other_get_usemoney="500 invalid username" & vbcrlf 
	else
		api_other_get_usemoney="200 ok" & vbcrlf
		api_other_get_usemoney=api_other_get_usemoney  & "usemoney:" & u_money & vbcrlf & "." & vbcrlf	
	end if
end function

function getSyncData(Byval tbname,ByRef fdlist,Byval fdowner,Byval exclude)
	u_id=u_sysid

	select case tbname
		case "vhhostlist"
			ident_field="s_comment"
		case "domainlist"
			ident_field="strdomain"
		case "mailsitelist"
			ident_field="m_bindname"
		case "databaselist"
			ident_field="dbname"
		case "hostrental"
			u_id=u_name
			ident_field="allocateip"
	end select

	fdlist_new=""
	fdlist_array=split(Lcase(fdlist),",")
	if not inArray(fdlist_array,ident_field) then
		Call Die("��Ч���ֶ��б�")
	end if


	QState="select * from " & tbname & " where 1=2"
	Set tmRs=conn.Execute(QState)

	for i=0 to Ubound(fdlist_array)
		iFound=false
		fdname=fdlist_array(i)

		for z=0 to tmRs.fields.count-1
			if Lcase(tmRs.fields(z).name)=fdname then
				iFound=true
				exit for
			end if
		next
		if iFound and fdname<>"bizcnorder" then
			fdlist_new=fdlist_new & fdname & ","
		end if
	next

	if fdlist_new="" then
		Call Die("��Ч���ֶ��б�!")
	end if

	fdlist_new=left(fdlist_new,len(fdlist_new)-1)
	if lcase(trim(tbname))<>"hostrental" then
	Sql="select " & fdlist_new & " from " & tbname & " where " & fdowner  & "=" & u_id
	else
	Sql="select " & fdlist_new & " from " & tbname & " where " & fdowner  & "='" & u_id &"'"
	end if

	Set productRs=conn.Execute(Sql)
	if productRs.eof then
		productRs.close
		Set productRs=nothing
		Call Die("�����ݿ�ͬ��")
	end if
	
	blQuick=(exclude="") 

	if not blQuick then
		exclude_array=split(exclude,",")
	end if

	rrSet=""
	do while not productRs.eof
		blExclude=false
		record_line=""

		for r_index=0 to productRs.fields.count-1
			fd_value=productRs.fields(r_index).value
			fd_name=Lcase(productRs.fields(r_index).name)

			if fd_name=ident_field then
				if not blQuick then
					if inArray(exclude_array,fd_value) then
						blExclude=true
						exit for
					end if
				end if
			end if

			if fd_value<>"" then
				fd_value=replace(fd_value,"~|~","")
				fd_value=replace(fd_value,vbcrlf,"<BR>")
			end if
			record_line=record_line & fd_value & "~|~"
		next
		
		if not blExclude then
			record_line=left(record_line,len(record_line)-3)
			rrSet=rrSet & record_line & vbcrlf
		end if
		
		productRs.moveNext
	Loop
	productRs.close
	set productRs=nothing

	fdlist=fdlist_new
	if rrSet="" then
		Call Die("�����ݿ�ͬ��")
	end if

	getSyncData=rrSet
end function

function api_other_sync_vhost()
	'��������ҵ��ͬ��,��ͬ���ϼ�������ڣ������ز����ڵ�ҵ��,����fdlist���ֶ���,exclude�Ǳ��ش��ڵ�ftp�û����б��ö��Ÿ���,��ʡ�ԣ�
	'===�����ʽ
	'other<CRLF>
	'sync<CRLF>
	'entityname:vhost<CRLF>
	'fdlist:fd1,fd2,fd3,fd4,fd5����<CRLF>
	'exclude:sitename1,sitename2,sitename3,sitename4,sitename5����<CRLF>
	'.<CRLF>

	'������ʽ,fdlist����Ч���ֶ���,ͬʱ���ݼ�¼Ҳ����˳��������зָ���~|~,�зָ���<CRLF>
	'200 ok<CRLF>
	'fdlist:fd1,fd3,fd5,fd6<CRLF>
	'recordset:
	'va1~|~va3~|~va5~|~va6<CRLF>
	'va1~|~va3~|~va5~|~va6<CRLF>
	'.<CRLF>

	field_list=getInputAPI("fdlist")
	rrset_exclude=getInputAPI("exclude")
	
	return_rrset=getSyncData("vhhostlist",field_list,"s_ownerid",rrset_exclude)

	api_other_sync_vhost="200 ok" & vbcrlf
	api_other_sync_vhost=api_other_sync_vhost & "fdlist:" & field_list & vbcrlf
	api_other_sync_vhost=api_other_sync_vhost & "recordset:" & return_rrset & vbcrlf
	api_other_sync_vhost=api_other_sync_vhost & "." & vbcrlf
end function

function api_other_sync_domain()
	'����ҵ��ͬ��,��ͬ���ϼ�������ڣ������ز����ڵ�ҵ��,����fdlist���ֶ���,exclude�Ǳ��ش��ڵ������б��ö��Ÿ���,��ʡ�ԣ�
	'===�����ʽ
	'other<CRLF>
	'sync<CRLF>
	'entityname:domain<CRLF>
	'fdlist:fd1,fd2,fd3,fd4,fd5����<CRLF>
	'exclude:domain1,domain2,domain3,domain4,domain5����<CRLF>
	'.<CRLF>

	'������ʽ,fdlist����Ч���ֶ���,ͬʱ���ݼ�¼Ҳ����˳��������зָ���~|~,�зָ���<CRLF>
	'200 ok<CRLF>
	'fdlist:fd1,fd3,fd5,fd6<CRLF>
	'recordset:
	'va1~|~va3~|~va5~|~va6<CRLF>
	'va1~|~va3~|~va5~|~va6<CRLF>
	'.<CRLF>

	field_list=getInputAPI("fdlist")
	rrset_exclude=getInputAPI("exclude")
	
	return_rrset=getSyncData("domainlist",field_list,"userid",rrset_exclude)

	api_other_sync_domain="200 ok" & vbcrlf
	api_other_sync_domain=api_other_sync_domain & "fdlist:" & field_list & vbcrlf
	api_other_sync_domain=api_other_sync_domain & "recordset:" & return_rrset & vbcrlf
	api_other_sync_domain=api_other_sync_domain & "." & vbcrlf
end function

function api_other_sync_mail()
	'��ҵ�ʾ�ҵ��ͬ��,��ͬ���ϼ�������ڣ������ز����ڵ�ҵ��,����fdlist���ֶ���,exclude�Ǳ��ش��ڵ��ʾ������б��ö��Ÿ���,��ʡ�ԣ�
	'===�����ʽ
	'other<CRLF>
	'sync<CRLF>
	'entityname:mail<CRLF>
	'fdlist:fd1,fd2,fd3,fd4,fd5����<CRLF>
	'exclude:domain1,domain2,domain3,domain4,domain5����<CRLF>
	'.<CRLF>

	'������ʽ,fdlist����Ч���ֶ���,ͬʱ���ݼ�¼Ҳ����˳��������зָ���~|~,�зָ���<CRLF>
	'200 ok<CRLF>
	'fdlist:fd1,fd3,fd5,fd6<CRLF>
	'recordset:
	'va1~|~va3~|~va5~|~va6<CRLF>
	'va1~|~va3~|~va5~|~va6<CRLF>
	'.<CRLF>

	field_list=getInputAPI("fdlist")
	rrset_exclude=getInputAPI("exclude")
	
	return_rrset=getSyncData("mailsitelist",field_list,"m_ownerid",rrset_exclude)

	api_other_sync_mail="200 ok" & vbcrlf
	api_other_sync_mail=api_other_sync_mail & "fdlist:" & field_list & vbcrlf
	api_other_sync_mail=api_other_sync_mail & "recordset:" & return_rrset & vbcrlf
	api_other_sync_mail=api_other_sync_mail & "." & vbcrlf
end function

function api_other_sync_database()
	'���ݿ�ҵ��ͬ��,��ͬ���ϼ�������ڣ������ز����ڵ�ҵ��,����fdlist���ֶ���,exclude�Ǳ��ش��ڵ����ݿ��б��ö��Ÿ���,��ʡ�ԣ�
	'===�����ʽ
	'other<CRLF>
	'sync<CRLF>
	'entityname:database<CRLF>
	'fdlist:fd1,fd2,fd3,fd4,fd5����<CRLF>
	'exclude:database1,database2,database3,database4,database5����<CRLF>
	'.<CRLF>

	'������ʽ,fdlist����Ч���ֶ���,ͬʱ���ݼ�¼Ҳ����˳��������зָ���~|~,�зָ���<CRLF>
	'200 ok<CRLF>
	'fdlist:fd1,fd3,fd5,fd6<CRLF>
	'recordset:
	'va1~|~va3~|~va5~|~va6<CRLF>
	'va1~|~va3~|~va5~|~va6<CRLF>
	'.<CRLF>

	field_list=getInputAPI("fdlist")
	rrset_exclude=getInputAPI("exclude")
	
	return_rrset=getSyncData("databaselist",field_list,"dbu_id",rrset_exclude)

	api_other_sync_database="200 ok" & vbcrlf
	api_other_sync_database=api_other_sync_database & "fdlist:" & field_list & vbcrlf
	api_other_sync_database=api_other_sync_database & "recordset:" & return_rrset & vbcrlf
	api_other_sync_database=api_other_sync_database & "." & vbcrlf
end function

function api_other_sync_allpassword()
	'ͬ������ҵ�������,ÿ���ֶη������֣�ҵ������~|~ҵ���ʶ~|~ҵ�����룬(vh:��������,dm:����,ma:�ʾ�,db:���ݿ�)
	'===�����ʽ
	'other<CRLF>
	'sync<CRLF>
	'entityname:allpassword<CRLF>
	'.<CRLF>

	'===������ʽ
	'200 ok<CRLF>
	'recordset:
	'vh~|~sitea~|~passwd<CRLF>
	'dm~|~dmname~|~passwd<CRLF>
	'ma~|~mailname~|~passwd<CRLF>
	'db~|~dbname~|~passwd<CRLF>
	'.<CRLF>

	tblist=Array(Array("vhhostlist","s_ftppassword","s_ownerid","s_comment","vh"),Array("domainlist","strDomainpwd","userid","strdomain","dm"),Array("mailsitelist","m_password","m_ownerid","m_bindname","ma"),Array("databaselist","dbpasswd","dbu_id","dbname","db"))
	u_id=u_sysid
	rrset_return=""
	Flag="~|~"

	for i=0 to Ubound(tblist)
		tbname=tblist(i)(0)
		pwdname=tblist(i)(1)
		fdname=tblist(i)(2)
		identname=tblist(i)(3)
		sig=tblist(i)(4)

		QState="select " & identname & "," &  pwdname & " from " & tbname & " where " & fdname & "=" & u_sysid
		Set localRs=conn.Execute(QState)
		do while not localRs.eof 
			rrset_return=rrset_return & sig & Flag & localRs(identname) & Flag & localRs(pwdname) & vbcrlf
			localRs.moveNext
		loop
		localRs.close
		Set localRs=nothing
	next

	if rrset_return="" then
		api_other_sync_allpassword="500 ��ҵ���ͬ��"
	else
		api_other_sync_allpassword="200 ok" & vbcrlf & rrset_return & "." & vbcrlf
	end if

end function
Function api_other_get_compare()
'��ȡ�ɱ���
	getProduct=getInputAPI("getproduct")
	select case getProduct
		case "all_product"
			P_sql="select proid,proPrice from UserPrice where u_id="& u_sysid
			set localRs=conn.execute(p_sql)
			otherStr=""
			if not localRs.eof then
				do while not localRs.eof
					otherStr=otherStr & trim(localRs("proid"))&":"&trim(localRs("proPrice"))&"|"'�ؼ��ִ�
				localRs.movenext
				loop
			end if
			localRS.close
			set localRs=nothing
			if len(otherStr)>0 then
				if right(otherStr,1)="|" then otherStr=left(otherStr,len(otherStr)-1)
			end if
			p_sql="select p_proId,p_price from pricelist where p_u_level="& u_level
			set localRs=conn.execute(p_sql)
			returnStr=""
			if not localRs.eof then
				do while not localRs.eof
					p_proid=trim(localRs("p_proid"))
					p_price=trim(localRs("p_price"))
					setstr=p_proid & ":" & p_price
					if instr("|"&trim(otherStr)&"|","|"&trim(setstr)&"|")<=0 then
						returnStr=returnStr & setstr & "|"
					end if
				localRs.movenext
				loop
			end if
			localRs.close
			set localRs=nothing
			returnStr=returnStr & otherStr
			if len(returnstr)>0 then
				if right(returnstr,1)="|" then returnstr=left(returnstr,len(returnstr)-1)
				returnStr="200 "& returnStr
			else
				returnstr="404 product is err"
			end if
		case else
			returnstr="200 "&getProduct &":"& GetNeedPrice(u_name,getProduct,1,"new")
	end select
	api_other_get_compare=returnstr
End Function
Function api_other_get_tablecontent()
	AllowGet=Array("productlist","pricelist","protofree","vps_price","serverroomlist") '�����ȡȫ�����ݵı���
	
	tbname=Lcase(getInputAPI("tbname"))
	if not inArray(AllowGet,tbname) then
		api_other_get_tablecontent="501 ����ı���"
		exit function
	end if
	
	fdlist=Lcase(getInputAPI("fieldlist"))
	fdlist_array=split(fdlist,",")

	qstate="select * from " & tbname & " where 1=2"
	Set localRs=conn.Execute(qstate)

	fdlist=""
	for i= 0 to Ubound(fdlist_array)
		ifound=false
		for k=0 to localRs.fields.count-1
			if lcase(localRs.fields(k).name)=fdlist_array(i) and "p_costprice"<>lcase(localRs.fields(k).name) then
				ifound=true
				exit for
			end if
		next
		if ifound then
			fdlist=fdlist & fdlist_array(i) & ","
		end if
	next

	localRs.close
	Set localRs=nothing

	if instr(fdlist,",")=0 then
		api_other_get_tablecontent="500 invalid fieldlist" & vbcrlf
		exit function
	end if

	fdlist=left(fdlist,len(fdlist)-1)

	sql="select " & fdlist & " from " & tbname
	Set localRs=conn.Execute(sql)
	strRecord=localRs.getString(,,"~|~",vbcrlf & "$","")
	localRs.close:Set localRs=nothing

	api_other_get_tablecontent="200 ok" & vbcrlf
	api_other_get_tablecontent =  api_other_get_tablecontent & "fieldlist:" & fdlist & vbcrlf
	api_other_get_tablecontent =  api_other_get_tablecontent & "recordset:" & strRecord & vbcrlf & "." & vbcrlf	
end Function
%>