<%
'�ƿ��ղ���
Class ebs_snap_class
	Dim  dbuserinfo,ebsdbinfo,errarr,okstr,snapproid,snapadvprice
	'��ʼ��
	Private Sub Class_Initialize
		Set errarr=newarray()
		snapproid="snapadv01"
		snapadvprice=99999
		
	End Sub
	Private Sub Class_Terminate
		 
	End Sub

	Public Property Let setuid(value)
		getuserinfo(value)
	End Property
	
	'
	Public Property Let setid(value)
		 
		If errarr.length=0 Then Call getebsinfo(value)
	End Property


	Function buysnapadv()
		buysnapadv=false
		If getsnapinfo() Then 
			if okstr("snapadv")="False" then
				If okstr("snappolicy")="0" Then
					leftmonth=okstr("leftmonth")
			 
					If Not isnumeric(leftmonth&"") Or Not isnumeric(snapadvprice&"") Then adderr("��ȡ��������,����ϵ����Ա!"):Exit Function
					buymoney=leftmonth*snapadvprice
					If ccur(snapadvprice)>ccur(dbuserinfo("u_usemoney")) Then adderr("��������"):Exit Function
					If consume(dbuserinfo("u_name"),snapadvprice,false,"buy-snapadv","��ͨ�ƿ��ո߼�����["&ebsdbinfo("allocateip")&"]["&leftmonth&"]",snapproid,"") then
						strcmd="server"&vbcrlf&_
							   "add"&vbcrlf&_
							   "entityname:snapads"&vbcrlf&_
							   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
							   "pricmoney:"&snapadvprice&vbcrlf&_
							   "."&vbcrlf
						ret=connectToUp(strcmd)
						If Left(ret,3)="200" Then
							buysnapadv=true
						Else
							Call addRec("��ͨ�߼��ƿ���,�����ѿ�,�ϼ�����ʧ��",ret)
							adderr(ret)
						End If 
					Else
					adderr("�۷�ʧ������ϵ����Ա!")
					End if
				Else
					adderr("�˷�����������ͨ�߼��ƿ���!")
				End If
			Else
				adderr("�Ѿ���ͨ�߼���������ͨ!")
			End if
		Else
			adderr("��ȡ������������!")
		End if
	End Function
	
	Function setsnapperiod(ByVal period)
		setsnapperiod=false
		If Not isnumeric(period&"") Then adderr("���ò�������"):Exit function
		if CLng(period)<1 Or CLng(period)>10 Then  adderr("���ò�������"):Exit function
		strcmd="server"&vbcrlf&_
			   "set"&vbcrlf&_
			   "entityname:snapperiod"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "period:"&period&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd) 
		If Left(ret,3)="200" Then
			setsnapperiod=true
		Else
			adderr(ret)
		End If 
	End Function
	

	Function setsnapbkup(ByVal disk)
		setsnapbkup=False
		If InStr(",data,os,",","&disk&",")=0 Then  adderr("�ֹ��������ղ�������"):Exit Function
		strcmd="server"&vbcrlf&_
			   "set"&vbcrlf&_
			   "entityname:snapbkup"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "disk:"&disk&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd)
		If Left(ret,3)="200" Then
			setsnapbkup=true
		Else
			adderr(ret)
		End If 
	End function
	Function setsnapunmount(ByVal disk)
		setsnapunmount=False
		If InStr(",os,data,",","&disk&",")=0 Then  adderr("ȡ�����ز�������"):Exit Function
		strcmd="server"&vbcrlf&_
			   "set"&vbcrlf&_
			   "entityname:snapunmount"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "disk:"&disk&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd)
		If Left(ret,3)="200" Then
			setsnapunmount=true
		Else
			adderr(ret)
		End If 
	End function
	
	Function setsnapmount(ByVal os,ByVal data)
		setsnapmount=False
		If Not isnumeric(os&"") then os=-1
		If Not isnumeric(data&"") then data=-1
		If CLng(os)<0 And CLng(data)<0 then adderr("���ز�������"):Exit Function
		If CLng(os)>5 or CLng(data)>5 then adderr("���ز�������"):Exit Function
		strcmd="server"&vbcrlf&_
			   "set"&vbcrlf&_
			   "entityname:snapmount"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "os:"&os&vbcrlf&_
			   "data:"&data&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd)
		If Left(ret,3)="200" Then
			setsnapmount=true
		Else
			adderr(ret)
		End if		
	End function
	
	
	'
	Function getsnapinfo()
		getsnapinfo=false
		strcmd="server"&vbcrlf&_
			   "get"&vbcrlf&_
			   "entityname:snapinfo"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd)
		If Left(ret,3)="200" Then
			Set okstr=aspjsonParse(Mid(ret,InStr(ret,"{")))
			okstr("snapadvprice")=snapadvprice
			okstr("usemoney")=dbuserinfo("u_usemoney")
			okstr("serverip")=ebsdbinfo("allocateip")
			getsnapinfo=true
		Else
			adderr(ret)
		End if		
	End Function
	Function getmountsnap()
		getmountsnap=false
		strcmd="server"&vbcrlf&_
			   "get"&vbcrlf&_
			   "entityname:mountsnap"&vbcrlf&_
			   "serverip:"&ebsdbinfo("allocateip")&vbcrlf&_
			   "."&vbcrlf
		ret=connectToUp(strcmd)
		If Left(ret,3)="200" Then
			Set okstr=aspjsonParse(Mid(ret,InStr(ret,"{"))) 
			getmountsnap=true
		Else
			adderr(ret)
		End if		
	End Function

	
	Public Function getebsinfo(ByVal value)
		If Trim(value)<>"" Then
			If IsNumeric(value&"") Then 
				sql="select top 1 * from HostRental where u_name='"&dbuserinfo("u_name")&"' and id="&value
			Else
				sql="select top 1 * from HostRental where u_name='"&dbuserinfo("u_name")&"' and AllocateIP='"&value&"'"
			End If 
			If Not getrsonedic(sql,ebsdbinfo) Then adderr("��������ѯʧ��"):Exit Function	
			snapadvprice=GetNeedPrice(dbuserinfo("u_name"),snapproid,1,"new")
		Else
			adderr("��������ѯʧ��")
		End if		
	End Function 
	Private Sub adderr(ByVal value)
		errarr.push(value)
	End sub
	
	Public Function getuserinfo(ByVal value)
		getuserinfo=false
		If Not IsNumeric(value&"") Then adderr("��Ա�������"):Exit Function
		sql="select top 1 * from userdetail where u_id="& value	 
		If Not getrsonedic(sql,dbuserinfo) Then adderr("��Ա��ѯʧ��"):Exit Function
		getuserinfo=True 
	End Function
	

End class
%>