<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/class/yunmail_class.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.Charset="gb2312" 
conn.open constr
u_sysid=session("u_sysid")
If Not isnumeric(u_sysid&"") Then u_sysid=0
act=requesta("act")
Select Case Trim(act)
Case "getprice":getprice
Case "addshopcart":addshopcart
Case Else
	Call checkpara()
End Select

Sub addshopcart()
	postnum=requesta("postnum")
	alreadypay=requesta("alreadypay")
	domain=requesta("domain")
	passwd=requesta("passwd")
	istry=requesta("istry")
	If CDbl(u_sysid)=0 Then die echojson("500","���½�����","")
	If Not isnumeric(postnum&"") Then die echojson("500","�ʺ���������","")
	If Not isnumeric(alreadypay&"") Then die echojson("500","����ʱ�����","")
	If CLng(postnum)<5 Then die echojson("500","���5���û�","")
	If CLng(alreadypay)<6 Then die echojson("500","���6����ʹ��ʱ��","")	
	If Trim(passwd)="" Then die echojson("500","������������","")
	istry=0
	Set yun=new yunmail_class 
	yun.setuid=u_sysid
	Set optdic=newoption()
	optdic.add "domain",domain
	optdic.add "passwd",passwd
	optdic.add "alreadypay",alreadypay
	optdic.add "postnum",postnum
    optdic.add "istry",istry 
	yun.addshopcart(optdic)
	if yun.isnext Then
		die echojson("200","ok","")
	Else
		die echojson("500",yun.errarr.join(","),"")
	End if
End sub

Sub getprice()
	postnum=requesta("postnum")
	alreadypay=requesta("alreadypay")
	If Not isnumeric(postnum&"") Then die echojson("500","�ʺ���������","")
	If Not isnumeric(alreadypay&"") Then die echojson("500","����ʱ�����","")
	If CLng(postnum)<5 Then die echojson("500","���5���û�","")
	If CLng(alreadypay)<3 Then die echojson("500","���3����ʹ��ʱ��","")	
	Set yun=new yunmail_class 
	If CDbl(u_sysid)>0 Then yun.setuid=u_sysid
	set optdic=newoption()  
	optdic.add "alreadypay",alreadypay
	optdic.add "postnum",postnum
	optdic.add "istry","0" 
	price=yun.getneedprice(optdic,priceMsg)
	if yun.isnext Then
		die echojson("200","ok",",""price"":"&price&",""pricemsg"":"""&priceMsg&"""")
	Else
		die echojson("500",yun.errarr.join(","),"")
	End if
End Sub

Sub checkpara()
	param=requesta("param")
	name=requesta("name")
	Select Case Trim(name)
	Case "domain":
		 Set yun=new yunmail_class
		 If yun.existsdomain(param) Then
			die "y"
		 Else
			die "�����Ѿ����ڲ�����ͨ!"
		 End If
	Case "passwd":
		Set yun=new yunmail_class
		Set chkdic=newoption()
		chkdic.add "passwd",param
		yun.checkinput(chkdic)
		 If  yun.isnext()  Then
			die "y"
		 Else
			die yun.errarr.join(",")
		 End If
	Case Else
		die "δ֪����"
	End select
End sub
%>