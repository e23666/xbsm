<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" -->  
<%
 
response.charset="gb2312"
'�¼�
Select Case Trim(requesta("act"))
Case "sendcode"
conn.open constr
	u_name=requesta("u_name")
	sendtype=requesta("sendtype")
	val_=requesta("val")
	sql="select top 1 u_email,msn_msg from userdetail where u_name='"&u_name&"'"
	Set urs=conn.execute(sql)
	code="500"
	msg=""
	If urs.eof Then
		msg="��Ա������"
		urs.close
	Else
		u_email=urs("u_email")
		msn_msg=urs("msn_msg")
		urs.close
		Select Case LCase(Trim(sendtype))
		Case "mail"
			If InStr(u_email&"","@")=0 Then
				msg="���ź���û����д���䲻���һ�����!"
			else
				If Trim(u_email)<>val_ Or Trim(u_email)="" Then
					msg="����д�����䲻��ȷ!"
				Else
					sendcode=createRnd(6)
					strmd5=asp_md5(u_name&sendcode&Trim(u_email)&webmanagespwd)
					m_title="["&companyname&"]�һ�������֤��"
					m_body="�������һ��������֤��Ϊ["&sendcode&"],30��������Ч"
					if sendMail(u_email,m_title,m_body) Then
						code=200
						msg="��֤���Ѿ����͵�����������ע�����,30��������Ч!"
						Call SetHttpOnlyCookie("findcode",strmd5,"","/",DateAdd("n",30,now()))
					Else
						msg="���ź�������֤��ʧ��,����ϵ����Ա!"
					End if
				End If
			End if
		Case "sms"
			If not sms_note Then
				msg="���ź���վ�ݲ�֧���ֻ��һ�����!"
			Else
				If  Not IsValidMobileNo(msn_msg) Or Not IsValidMobileNo(val_) Or Trim(msn_msg)<>Trim(val_)  Then
					msg="���ź�����û�������ֻ�����/��¼���ֻ���������,����ϵ����Ա!"
				Else
					sendcode=createRnd(6)
					strmd5=asp_md5(u_name&sendcode&Trim(msn_msg)&webmanagespwd)
					sendStrSms="�������һ��������֤��Ϊ["&sendcode&"],30��������Ч"
					Smsreturn=httpSendSMS(msn_msg,sendStrSms)
					if left(Smsreturn,3) ="200" Then
						code=200
						msg="��֤���Ѿ����͵�����������ע�����,30��������Ч!"
						Call SetHttpOnlyCookie("findcode",strmd5,"","/",DateAdd("n",30,now()))
					Else
						msg ="�ֻ�����ʧ��,��ѡ�����䷢��" 
					End if
				End if				
			End if	

		Case Else
		msg="��֤�뷢�ͷ�ʽ����!"
		End select
	End if
		die "{""code"":"&code&",""msg"":"""&msg&"""}"
End Select

 



 						  Randomize
                          MyValue = Int(((999-100+1)*rnd)+100)
                          codeKey = Int(Timer()*10) + MyValue
					sms_disabled=""  
					if not sms_note then sms_disabled="disabled=""disabled"""
					Call setwebhostingLeft()
					call setHeaderAndfooter()
					call setregsubLeft()
					tpl.set_file "main", USEtemplate&"/reg/forget.html"
					tpl.set_var "codeKey",codeKey,false
					tpl.set_var "sms_disabled",sms_disabled,false
					tpl.parse "mains","main",false
					tpl.p "mains" 
					set tpl=nothing
					'rs.close

%>