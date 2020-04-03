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
	If CDbl(u_sysid)=0 Then die echojson("500","请登陆后操作","")
	If Not isnumeric(postnum&"") Then die echojson("500","帐号数量错误","")
	If Not isnumeric(alreadypay&"") Then die echojson("500","购买时间错误","")
	If CLng(postnum)<5 Then die echojson("500","最低5个用户","")
	If CLng(alreadypay)<6 Then die echojson("500","最低6个月使用时间","")	
	If Trim(passwd)="" Then die echojson("500","管理密码有误","")
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
	If Not isnumeric(postnum&"") Then die echojson("500","帐号数量错误","")
	If Not isnumeric(alreadypay&"") Then die echojson("500","购买时间错误","")
	If CLng(postnum)<5 Then die echojson("500","最低5个用户","")
	If CLng(alreadypay)<3 Then die echojson("500","最低3个月使用时间","")	
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
			die "邮箱已经存在不允许开通!"
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
		die "未知操作"
	End select
End sub
%>