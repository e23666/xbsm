<%
class yunmail_class 
	public user_sysid,user_name,u_namecn,u_address,msn_msg,u_email,u_levelid,tc_name,product_ids,u_usemoney,errarr,okstr
	Dim appconfig
	dim lvdis,configDic,dbarr,mail_sysid,dbdic,lastmid
 
	'��ʼ��
	Private Sub Class_Initialize
		user_sysid=session("u_sysid")
		proid=""
		tem_level=1	
		lvdis=diyMlev1  'Ĭ���ۿ�		
		loadconfig()	 '����json����
		Set errarr=newarray()
		set dbarr=newarray()
		set dbdic=newoption()
		loadconfig()	
		lastmid=0
	end sub
	
	Private Sub Class_Terminate
		 
	End Sub

	Public Property Let setuid(value)
		getuserinfo(value)
	End property

	public sub loadconfig()
		content_ = ReadFile(Server.MapPath("/noedit/yunmail.json"))
		set configDic=aspjsonParse(content_)
	end Sub

	Public Property Let setmailid(byval Value)
		mail_sysid=value
		getmailsiteinfo()
	End Property

	function mysynmail()
		set p_=newoption()
		p_.add "para",dbdic("m_bindname")
		p_.add "isdomain",1
		call synmail(p_)
		if not isnext then exit function
	end Function

	Function chgpwd(ByVal p)
		Dim pwd,repwd,strcmd
		pwd=p("pwd")
		repwd=p("repwd")
		If Len(pwd)<6 Or Trim(pwd)<>Trim(repwd) Then  adderr("�������벻һ�»򳤶ȵ���6λ")
		Set req=newoption()
		req.add "domain",dbdic("m_bindname")
		req.add "passwd",Trim(pwd) 
		call checkinput(req)
		if not isnext then exit Function
		strcmd= "yunmail"&vbcrlf&_
				"update"&vbcrlf&_
				"entityname:pwd"&vbcrlf&_
				"domain:"&dbdic("m_bindname")&vbcrlf&_
				"passwd:"&pwd&vbcrlf&_
				"."&vbcrlf
		loadRet=connectToUp(strcmd)  
		'die strcmd
		if left(loadRet,3)<>"200" Then 
			Call adderr(loadRet&"")
		End if

	End function
	
	Function upyun()
		strcmd="yunmail"&vbcrlf&_
			 	"update"&vbcrlf&_
				"entityname:upyun"&vbcrlf&_ 
				"domain:"&dbdic("m_bindname")&vbcrlf&_
				"."&vbcrlf  
		loadRet=connectToUp(strcmd)  
		'die strcmd
		if left(loadRet,3)="200" Then
				set p_=newoption()
				p_.add "para",dbdic("m_bindname")
				p_.add "isdomain",1
				call synmail(p_)
 				okstr=loadRet
		Else
			Call adderr(loadRet&"")
		End if
	End function

	function synmail(byval p)
		isdm=p("isdomain")
		para=p("para")
		if instr(",0,1,",","&isdm&",")=0 then adderr("ͬ����������")
		if not isnext then exit function
		if clng(isdm)=1 then
			if not isdomain(para&"") then adderr("������ʽ����")
		else
			if not isnumeric(para&"") then adderr("����ID����")
		end If
 
		if not isnext then exit function
		strcmd="yunmail"&vbcrlf&_
			 	"syn"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"para:"&para&vbcrlf&_
				"isdomain:"&isdm&vbcrlf&_
				"."&vbcrlf  
		loadRet=connectToUp(strcmd)  
		if left(loadRet,3)="200" then

			objstr="{""datas"":"&mid(loadRet&"",instr(loadRet,"[")) &"}"
			set obj_=jsontodic(objstr) 
			AdminUid=getAdminUid()
			for each line_ in obj_("datas")
				lastmid=line_("m_sysid")
				set ars=Server.CreateObject("adodb.recordset")	
				sql="select top 1 * from mailsitelist  where m_bindname='" & line_("m_bindname") &"'"
			 	ars.open sql,conn,1,3
				if ars.eof then
					ars.addnew()
					ars("m_ownerid")=AdminUid
					ars("m_bindname")=line_("m_bindname")
				end If
					ars("m_serverip")=line_("m_serverip")
					ars("m_productid")=line_("m_productid")
					ars("m_buydate")=line_("m_buydate")
					ars("m_expiredate")=line_("m_expiredate")
					ars("m_serverip")=line_("m_serverip")
					ars("m_password")=line_("m_password")
					ars("m_status")=line_("m_status")
					ars("m_free")=line_("m_free")
					ars("m_buytest")=line_("m_buytest")
					ars("preday")=line_("preday")
					ars("alreadypay")=line_("alreadypay")
					ars("postnum")=line_("postnum")
					ars("m_years")=line_("m_years")
				ars.update
				ars.close
				Set ars=nothing
			next
		else
			adderr(loadRet)
		end if
	end function
	
	
	function getAdminUid()
		if clng(adminuserid)>0 then getAdminUid=adminuserid: exit function
		sql="select top 1 u_id from UserDetail where u_type='111111' order by u_id asc"
		set glrs=conn.execute(sql)
		if not glrs.eof then 
		adminuserid=glrs(0)
		end if
		glrs.close:set grlrs=nothing
		getAdminUid=adminuserid
	end function

	'���Ѳ���
	function renewsure(byval p)
		dim renewprice,strcmd
		p.add "postnum",dbdic("postnum") 
		p.add "isfree",iif(dbdic("m_free"),1,0)
		call checkinput(p)
		if not isnext then exit function
		renewprice=getneedprice(p,pricemsg)
		if cdbl(renewprice)>cdbl(u_usemoney) then  adderr("��������!"):exit Function
		strcmd= "yunmail"&vbcrlf&_
			    "renewal"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"domain:"&dbdic("m_bindname")&vbcrlf&_
				"alreadypay:"&p("alreadypay")&vbcrlf&_
				"ppricetemp:"&renewprice&vbcrlf&_
				"."&vbcrlf
		
		retstr=connectToUp(strcmd)
		'retstr="200 ok"
		if left(retstr,3)="200" then 
			if consume(user_name,renewprice,0,"renewyunmail-"&dbdic("m_bindname"),"��������["&dbdic("m_bindname")&"]["&p("alreadypay")&"]","yunmail",0) then
					set urs=server.CreateObject("adodb.recordset")
					sql="select top 1 * from mailsitelist   where m_sysid="& mail_sysid &" and m_ownerid="& user_sysid
					urs.open sql,conn,1,3
						if not urs.eof then 
							allalreadypay=cdbl(urs("alreadypay"))+cdbl(p("alreadypay"))
							urs("alreadypay")=allalreadypay
							urs("m_expiredate")=dateadd("D",dbdic("preday"),dateadd("m",allalreadypay,dbdic("m_buydate")))
							urs.update 
						end if
					urs.close
					Call Set_vcp_record("yunmail",user_sysid,renewprice,p("alreadypay"),"��������",true)
					set urs=nothing
			else 
				call adderr("�ϼ����ѳɹ�,�ۿ�ʧ��","��������["&dbdic("m_bindname")&"]["&p("alreadypay")&"]")
			end if
		else
			adderr(retstr)
		end if


	end function

	'��ȡ���Ѽ۸�
	function getrenewprice(byval  p,byref pricemsg)
		p.add "postnum",dbdic("postnum") 
		p.add "isfree",iif(dbdic("m_free"),1,0)
		call checkinput(p)
		if not isnext then exit function
		getrenewprice=getneedprice(p,pricemsg)
	end function

'��ӹ��ﳵ
	function addshopcart(byval p)
		call checkinput(p)
		if not isnext then exit function
		needprice=getneedprice(p,priceMsg)
		dim strcmd
		strcmd="yunmail"&vbcrlf&_
				"add"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"producttype:yunmail"&vbcrlf&_
				"domain:"&p("domain")&vbcrlf&_
				"passwd:"&p("passwd")&vbcrlf&_
				"alreadypay:"&p("alreadypay")&vbcrlf&_
				"postnum:"&p("postnum")&vbcrlf&_
				"ppricetemp:"&needprice&vbcrlf&_
				"istry:0"&vbcrlf&_
				"productnametemp:���ʾ�"&vbcrlf&_
				"."&vbcrlf
		call add_shop_cart(user_sysid,"yunmail","���ʾ�",strcmd)
	end function

	'�������ʾ�
	function buyyunmail(byval p)'���򼰿�ͨ����
		if not islogin then adderr("�����¼����ܲ���"):exit function
		call checkinput(p)
		dim ppricetemp,needprice,priceMsg
		if not isnext then exit function	
		needprice=getneedprice(p,priceMsg)
		if not isnext then exit Function
		ppricetemp=getdicval(p,"ppricetemp")
		If isnumeric(ppricetemp&"") Then  'api�۸񱣻�
			If cdbl(ppricetemp)<cdbl(needprice) Then adderr("����۸����("&ppricetemp&"),����ϵ����Ա"):exit function
		End if

		if cdbl(upprice)>cdbl(u_usemoney) then  adderr("��������!"):exit Function
		set trs=server.CreateObject("adodb.recordset")
		sql="select top 1 * from mailsitelist where m_bindname='"&p("domain")&"'"
		trs.open sql,conn,3,3
		if not trs.eof then trs.close():set trs=nothing:adderr("�ʾ��Ѿ��ڱ��ش���,����ϵ����Ա����"):exit function
		
		strcmd= "yunmail"&vbcrlf&_
				"add"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"producttype:yunmail"&vbcrlf&_
				"domain:"&p("domain")&vbcrlf&_
				"passwd:"&p("passwd")&vbcrlf&_
				"alreadypay:"&p("alreadypay")&vbcrlf&_
				"postnum:"&p("postnum")&vbcrlf&_
				"istry:0"&vbcrlf
		if p.exists("s_comment") then
			strcmd=strcmd&"s_comment"&vbcrlf&_
						  "isfree:1"&vbcrlf
		else
			strcmd=strcmd&"isfree:0"&vbcrlf
		end if
			strcmd=strcmd&"ppricetemp:"&needprice&vbcrlf&_
						 "."&vbcrlf
		retstr=connectToUp(strcmd)
 
		if consume(user_name,needprice,0,"buyyunmail-"&p("domain"),"��ͨ����["&p("domain")&"]["&p("postnum")&"]["&p("alreadypay")&"]","yunmail",0) then
			if left(retstr,3)="200" then 
						if trs.eof then 
							trs.addnew()
							trs("m_ownerid")=user_sysid
							trs("m_bindname")=p("domain")
							trs("m_productid")="yunmail"
							trs("m_buydate")=now()
							trs("m_expiredate")=dateadd("m",p("alreadypay"),now())
							trs("alreadypay")=p("alreadypay")
							trs("m_serverip")="192.168.1.1"
							trs("m_password")=p("passwd")
							trs("m_free")=IIF(p("m_free")=1,PE_True,PE_False)
							trs("m_buytest")=IIF(p("istry")=1,PE_True,PE_False)
							trs("preday")=0
							trs("postnum")=p("postnum")
							trs("m_status")=2
							trs.update
							Call Set_vcp_record("yunmail",user_sysid,needprice,p("alreadypay"),"��ͨ����",false)
						else
							adderr("�ʾ��Ѿ�����!")
						end if 
				Else
					adderr("�ۿ�ɹ�,���ʾֿ�ͨʧ��["&needprice&"],����ϵ����Ա")
					call addRec("���ʾֿ�ͨʧ��,�ۿ�ɹ�","["&user_name&"]["&p("domain")&"]["&p("postnum")&"]["&p("alreadypay")&"][&yen;"&needprice&"]"&retstr)
				end if
		else
			adderr("�ۿ�ʧ��,����ϵ����Ա")
		end if
					
		trs.close():set trs=nothing
	end function

	'��ȡ��������
	function getmailsiteinfo()
		dim sql,rs,dic,exidate,m_password,m_password_old,m_years
		if not islogin then adderr("�����¼����ܲ���"):exit function
		if not isnumeric(mail_sysid&"") then adderr("��������") 
		if not isnext then exit function
		sql="select top 1 m_sysid,m_ownerid,m_bindname,m_productid,m_buydate,m_expiredate,m_updatedate,m_years,m_serverip,m_password,m_free,m_buytest,preday,alreadypay,postnum from mailsitelist   where m_sysid="& mail_sysid &" and m_ownerid="& user_sysid
		set rs=conn.execute(sql)
		if rs.eof then adderr("�ʾֲ�ѯʧ��"):exit Function
		Set dbdic=getfirstrstodic(rs) 
		rs.close:set rs=nothing
	end function

	'�������ʺ�
	function upsure(byval p)
		call checkinput(p)
		if not isnext then exit function
		dim upprice,uppricemsg
		upprice=getupgradeprice(p,uppricemsg)
		if not isnext then exit function
		if cdbl(upprice)>cdbl(u_usemoney) then  adderr("��������!"):exit Function
		strcmd="yunmail"&vbcrlf&_
				"update"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"domain:"&dbdic("m_bindname")&vbcrlf&_
				"postnum:"&p("postnum")&vbcrlf&_
				"isfree:"&p("m_free")&vbcrlf&_
				"ppricetemp:"&upprice&vbcrlf&_
				"."&vbcrlf
		retstr=connectToUp(strcmd)
		'retstr="200 ok"
		if left(retstr,3)="200" then 
			if consume(user_name,upprice,0,"upyunmail-"&dbdic("m_bindname"),"��������["&dbdic("m_bindname")&"]["&p("postnum")&"]["&p("m_free")&"]==>["&dbdic("postnum")&"]["&dbdic("m_free")&"]","yunmail",0) then

				set urs=server.CreateObject("adodb.recordset")
				sql="select top 1 * from mailsitelist   where m_sysid="& mail_sysid &" and m_ownerid="& user_sysid
				urs.open sql,conn,1,3
					if not urs.eof then 
						urs("postnum")=p("postnum")
						urs("m_free")=IIF(p("m_free")=1,PE_True,PE_False)
						urs.update 
					end if
				urs.close
				set urs=nothing
			else
				call adderr("�����ɹ�,�ۿ�ʧ��","��������["&p("domain")&"]["&p("postnum")&"]["&p("m_free")&"]==>["&dbdic("postnum")&"]["&dbdic("m_free")&"]")
			end if
		else
			adderr(retstr)
		end if 
	end function

	'��ȡ�����۸�
	function getupgradeprice(byval p,byref pricemsg)
		dim newpricemsg,oldpriceMsg,price,newprice,oldprice,allday,allprice
		getupgradeprice=9999999
		call checkinput(p)			 
		if not isnext then exit function 
		set olddic=newoption()
		set newdic=newoption() 
		olddic.add "postnum",dbdic("postnum")
		olddic.add "alreadypay",dbdic("alreadypay")
		olddic.add "isfree",IIF(dbdic("m_free")="False","0","1")
		olddic.add "istry",0
		
		newdic.add "postnum",p("postnum")
		newdic.add "alreadypay",dbdic("alreadypay")
		newdic.add "isfree",p("m_free")
		newdic.add "istry",0 
		newprice=getneedprice(newdic,newpricemsg) 
		oldprice=getneedprice(olddic,oldpriceMsg)
		if not isnext then exit function
		allprice=cdbl(newprice)-cdbl(oldprice)	
	    allday=datediff("d",dbdic("m_buydate"),dbdic("m_expiredate"))
		reday=datediff("d",date(),dbdic("m_expiredate"))
		price=round(allprice/allday*reday,2)		
		if price<0 then price=0		
		pricemsg="(�¼۸�("& newprice &"Ԫ)-ԭ�۸�("& oldprice &"Ԫ))��������("& allday &"��)��ʣ������("&reday&"��)="& fmtPrice(price) &"Ԫ"
		getupgradeprice=price
	end function
	 
	 
 

	'�����������
	function checkupgrade(byval reqdic)
		dim resultdic 
		set resultdic=copydic(ClassRet("data"))
		call checkinput(resultdic)	
		if not isnext then exit function		
		if  dbdic.count<=0 then adderr("�ʾּ�¼�쳣����������"):exit function
		if cdbl(dbdic("m_status"))<=0 then adderr("�ʾ�״̬���ԣ�����������"):exit function
		if cdbl(dbdic("m_buytest"))=1 then adderr("�����ʾֲ���������"):exit function
		if dbdic("m_expiredate")<-10 then adderr("�ʾֵ���ʱ�����10�����������"):exit function				
		if dbdic("isfree")&""="0" and reqdic("isfree")&""="1" then adderr("�շ��ʾֲ���������������ʾ�"):exit function		
		set ClassRet=retdicdata(resultdic)
	end function

	'��ȡ�۸�
	function getneedprice(byval reqdic,byref priceMsg)
		dim postnum,alreadypay,dic_
		dim thisdic,timeprice,freepricedis
		if reqdic.exists("istry") then
			if reqdic("istry")&""="1" then 
				priceMsg="�������"
				getneedprice=0
				exit function'����
			end if
		end If

		'������������ʾ�
		if reqdic.exists("s_comment") And reqdic.exists("isfree") Then
			priceMsg="��������("&reqdic("s_comment")&")("&vhost_id&")����ʾ�"
			getneedprice=0
			exit function'����
		End If

		getneedprice=9999999'�Է���һ		
		postnum=reqdic("postnum")
		alreadypay=reqdic("alreadypay")	 
		call checkinput(reqdic)			 
		if not isnext then exit function 

		for each dic_ in configDic("price")
			if isnumeric(dic_("beginnum")&"") and dic_("state")&""="1" then
				if cdbl(postnum)>=cdbl(dic_("beginnum")) then
					set thisdic=dic_
				end if	
			end if
		next
		set dic_=nothing
		if not isobject(thisdic) then adderr("�۸��ȡʧ��,�˺�����������("& postnum &")"):exit function
		if isnext then
			timeprice=alreadypayprice(thisdic,alreadypay,priceMsg)
			if isnext then 
				getneedprice=timeprice	* postnum
				priceMsg="��"&priceMsg&"����"& postnum &"�˺�" 
				getneedprice=getneedprice*lvdis
				priceMsg=priceMsg&"���ۿ�("& fmtPrice(lvdis) &")"  
				if reqdic("isfree")&""="1" then 
					freepricedis=configDic("seting")("freepricedis")
					getneedprice=getneedprice*freepricedis
					priceMsg=priceMsg&"�������ۿ�("& freepricedis &")"
				end if

			end if
		end if			

	end function

	 '��ʽ�����
	function fmtPrice(byval numstr)
        numstr=Trim(numstr)
        if numstr<>"" and isnumeric(numstr) then
        fmtPrice=formatnumber(Round(numstr,2),2,-1,-2,0)
        else
            fmtPrice=0.00
        end if
    end function

	'�Ƿ��½
	function islogin()
		dim result
		result=true
		if not isnumeric(user_sysid&"") then	
			if check_is_cookie then
				user_sysid=session("u_sysid") 
			else
				result=false	
			end if
		end if
		islogin=result
	end function

	function alreadypayprice(byval priceDic,byval alreadypay,byref priceMsg)'�۸����䣬�۸���ʱ�����۸����˵��
		dim otyhernum,needprice,price12,price3,price1
		dim yftime,jftime,nfcount,jfcount
		needprice=0
		alreadypay=cdbl(alreadypay)
		price12=cdbl(priceDic("price12"))
		price3=cdbl(priceDic("price3"))
		price1=cdbl(priceDic("price1"))
		nfcount=int(alreadypay / 12)
		if nfcount>0 then 
			needprice=price12*nfcount
			jftime=alreadypay mod 12
			priceMsg="�긶��("&price12&"Ԫ)��"& nfcount &"��"
		else
			jftime=alreadypay
		end if		
		jfcount=int(jftime/3)
		if jfcount>0 then 
			needprice=needprice+price3*jfcount
			yftime=jftime mod 3
			priceMsg=iif(priceMsg&""="","",priceMsg&"��")&"������("&price3&"Ԫ)��"& jfcount &"��"
		else
			yftime=jftime
		end if
		if yftime>0 then 
			needprice=needprice+price1*yftime	
			priceMsg=iif(priceMsg&""="","",priceMsg&"��")&"�¸���("&price1&"Ԫ)��"& yftime &"��"
		end if		
		if needprice<=0 then adderr("�۸��ȡʧ��,����ʱ��������("& alreadypay &")"):exit function
		
		alreadypayprice=round(needprice,2)		
	end function
	
	'�����ֵ�
	function copydic(byval dic)
		dim dic_k,rdic
		set rdic=server.CreateObject("Scripting.Dictionary")
		for each dic_k in dic.keys
			rdic.add dic_k,dic(dic_k)
		next
		set copydic=rdic
		set dic=nothing
	end function

	'��ȡ�û���Ϣ
	Public Function getuserinfo(ByVal user_sysid_)
		getuserinfo=false
		If Not IsNumeric(user_sysid_&"") Then errmsg="��Ա�������":Exit Function
		if trim(user_sysid_&"")="" then 
			sql="select top 1 u_name from userdetail where u_level="& tem_level
			set urs=conn.execute(sql)
			if not urs.eof then
				user_name=urs("u_name")
			end if
			urs.close
			set urs=nothing  
		Else
			sql="select top 1 * from userdetail where u_id="& user_sysid_
			set urs=conn.execute(sql)
			if not urs.eof then
				user_name=urs("u_name")
				u_namecn=urs("u_namecn")
				u_address=urs("u_address")
				msn_msg=urs("msn_msg")
				u_email=urs("u_email")
				u_levelid=urs("u_level")
				user_sysid=urs("u_id")
				u_usemoney=urs("u_usemoney") 
				select case clng(u_levelid)
					case 1:lvdis=diyMlev1
					case 2:lvdis=diyMlev2
					case 3:lvdis=diyMlev3
					case 4:lvdis=diyMlev4
					case 5:lvdis=diyMlev5 
					case else:lvdis=1
				end select 
				if not isnumeric(lvdis&"") then lvdis=1
				lvdis=fmtPrice(lvdis)
			end if
			urs.close
			set urs=nothing		
		End if
		getuserinfo=true
	End Function


	'��������Ƿ����
	function existsdomain(byval domain)
		existsdomain=False
		If Not isdomain(domain&"") then adderr(" �ʾ�������ʽ���� ��"):Exit Function
		apicmd_="yunmail"&vbcrlf&_
				"check"&vbcrlf&_
				"entityname:yunmail"&vbcrlf&_
				"domain:"&Trim(domain)&vbcrlf&_
				"."&vbcrlf
		retunstr=connectToUp(apicmd_)
		If Left(retunstr,3)="200" Then
			existsdomain=True
		Else
			adderr(retunstr)
		End If
		
	end function
	'��Ӵ�����Ϣ
	function adderr(byval msg)
		errarr.push(msg)
	End function

	'�����˳�
	function isnext()
		isnext=(errarr.length=0)
	end function

	'
	function isinpricedata(byval newdic)
		dim priceItem,beginnum,beginnum_,isfind,state,state_,i
		for i=0 to ubound(configDic("price"))	
			isfind=true		
			if newdic.exists("index") then
				if cdbl(newdic("index"))=i then isfind=false
			end if
			if isfind then
				set priceItem=configDic("price")(i)
				beginnum=cdbl(priceItem("beginnum"))				
				beginnum_=cdbl(newdic("beginnum"))
				state=	cdbl(priceItem("state"))
				state_=	cdbl(newdic("state"))				
				if beginnum_=beginnum and state=1 and state_=1 then
					adderr("��ʼ����("& beginnum_ &")���Ѵ��ڣ�����������ύ")
					exit for
				end if				
			end if
		next
	end function

	'������
	function hascontinuityStr(byval str,byval maxcount)'�Ƿ�����ͬ�ַ� �ַ���,��ͬ����
		dim i,oldstrasc,cur0,cur1,cur2,ishas,str_
		ishas=false:cur0=1:cur1=1:cur2=1
		for i=1 to len(trim(str))
			str_=mid(str,i,1):strasc=asc(str_)		
			if oldstrasc&""<>"" then
				if oldstrasc+1=strasc then
					cur0=cur0+1
				else
					cur0=1
				end if
				if oldstrasc-1=strasc then			
					cur1=cur1+1
				else
					cur1=1
				end if
				if oldstrasc=strasc then			
					cur2=cur2+1
				else
					cur2=1
				end if
			end if
			if cur0>=maxcount or cur1>=maxcount  or cur2>=maxcount then  ishas=true:exit for
			oldstrasc=strasc
		next
		hascontinuityStr=ishas
	end function
	
	'���¼�����
	function checkinput(byval dic)
		dim item_,maildomain,mailpwd,binfo,ischks 
		if dic.exists("beginnum") then		
			call isinpricedata(dic)
		end if
		if dic.exists("postnum") then		
			if not regtest(dic("postnum"),"^\d+$") then
				adderr("�˺�������������")
			elseif cdbl(dic("postnum"))<cdbl(configDic("seting")("minmailcount")) or cdbl(dic("postnum"))>cdbl(configDic("seting")("maxmailcount")) then
				adderr("�˺�����������"& configDic("seting")("minmailcount") &"��"& configDic("seting")("maxmailcount") &"������")
			end if
		end if
		if dic.exists("domain") and not dic.exists("passwd") then
			maildomain=trim(dic("domain"))
			if not isdomain(maildomain) then
				adderr("����������")
			elseif getsroot(maildomain)<>maildomain then
				adderr("�����Ƕ�������"&dic("act"))
			elseif isChinese(maildomain) then
				adderr("��֧����������")			
			elseif mail_sysid=0 then'������¹���
				if instrarr(othermaildomain,dic("domain"))>0 then
					adderr(dic("domain")&"��ֹע��")
				elseif existsdomain(dic("domain")) then
					adderr("�������ѿ�ͨ���ʾ֣��뻻һ������")
				elseif existstrydomain(dic("domain")) then
					adderr("�������������������У��뻻һ������")
				end if
			end if
		end if	
	 
		if dic.exists("passwd") then			
			ischks=true
			if mail_sysid>0 then'������޸�����Ϊ��
				ischks=false
				if dic("passwd")<>"" then
					dic("domain")=dbdic("m_bindname")
					ischks=true
				end if
			end If
		
			if ischks then
				mailpwd=trim(dic("passwd"))
				if dic.exists("domain") then	
					maildomain=trim(dic("domain"))
				End if
				if not regtest(mailpwd,"^.{6,50}$") then
					adderr("������Ҫ6-50λ���ַ�")
				elseif regtest(mailpwd,"(^\d+$)|(^[a-zA-Z]+$)") then
					adderr("���벻���Ǵ����ֻ���ĸ") 
				elseif checkPassStrw(mailpwd) then 
					adderr("�����к��в�������ַ�")
				elseif maildomain=mailpwd then
					adderr("���벻�ܺ�����������ͬ")
				elseif instr(maildomain,mailpwd)>0 Then
					If Trim(maildomain)<>"" Then 	adderr("�������˺�����")
				elseif instr(mailpwd,myinstr(maildomain,"^([^\.]+)\."))>0 then
					If Trim(maildomain)<>"" Then  adderr("�������˺�����.")				
				elseif ckbadWord(mailpwd) then
					adderr("�����Ǽ򵥵���")	
				elseif hascontinuityStr(mailpwd,4)	then
					adderr("���벻������������ͬ��4λ�ַ�")				
				end if
			end if
		end if
		if dic.exists("alreadypay") then
			if not regtest(dic("alreadypay"),"^\d+$") then
				adderr("ʱ�������Ǵ���0������")
			elseif cdbl(dic("alreadypay"))<3 then
				adderr("ʱ������3����")		
			end if
		end if
		if dic.exists("u_contract") then
			if not regtest(dic("u_contract"),"^[\w\-\u4e00-\u9fa5]{2,50}$") then
				adderr("��ϵ�˳�ν��ʽ����")
			elseif not ischinese(dic("u_contract")) then
				adderr("��ϵ�˳�ν���뺬������")
			end if
		end if
		if dic.exists("u_mobile") then
			if dic("u_mobile")<>"" then
				if not regtest(dic("u_mobile"),"^[\d\-]{8,12}$") then
					adderr("��ϵ�˵绰���ֻ��Ÿ�ʽ����")			
				end if
			end if
		end if
		if dic.exists("u_email") then
			if dic("u_email")<>"" then
				if not isemailAddr(dic("u_email")) then
					adderr("��ϵ�������ʽ����")			
				end if
			end if
		end if	
		if dic.exists("expdate") then
			if isdate(dic("expdate")) then
				if datediff("d", dic("expdate"),date)>0 then
					adderr("ͨ������ʱ�������Ĺ���ʱ�䲻��ȷ")			
				end if
			else
				adderr("����ʱ���ʽ����ȷ��������ȷ�����ڸ�ʽ")	
			end if		
		end if
		if dic.exists("istry") then
			if instr(",0,1,",","& dic("istry") &",")=0 then
				adderr("�Ƿ�����("& dic("istry") &")�Ĳ�������")
			end if
		end if
		if dic.exists("y_sysid") then
			if not isnumeric(dic("y_sysid")) then
				adderr("y_sysid("& dic("y_sysid") &")�Ĳ�������")
			end if
		end if
		if dic.exists("remark") then
			if trim(dic("remark"))="" then
				adderr("�ܾ�ԭ����Ϊ��")
			end if
		end if
		if dic.exists("preday") then
			if not regtest(dic("preday"),"^\d+$") then
				adderr("preday������>=0������")
			end if
		end if
		if dic.exists("isfree") then
			if not regtest(dic("isfree"),"^[01]$") then
				adderr("isfree������0��1")
			end if
		end If
		
		if dic.exists("s_comment") And dic.exists("isfree") Then '����������ͨ������isfree	
			 Set vrs=conn.execute("select a.s_sysid from vhhostlist as a inner join view_protofree as b on a.s_ProductId=b.P_proId where  a.s_comment='"&sqlincode(Trim(dic("s_comment")))&"' and a.S_ownerid='"&userid&"' and isnull(a.s_mid,0)=0 and isnull(a.s_buytest,0)=0 and isnull(b.freeproid,'')!=''")
			 If vrs.eof then			 
				adderr("�ѿ�ͨ����Ȩ��ͨ��")
			 Else
				vhost_id=vrs("s_sysid")
			 End If
			 
			 vrs.close:Set vrs=nothing
		end If

	end function
	
	Public Function getdicval(ByVal p_,ByVal k_)
		If Not p_.exists(k_) Then 
			getdicval=""
		Else
			getdicval=Trim(p_(k_))
		End if
	End function
end class
%>