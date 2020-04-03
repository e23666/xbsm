<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/class/ebs_snap_class.asp" -->
<%
response.Charset="gb2312"
conn.open constr
act=requesta("act")
id=requesta("id")
If Not isnumeric(id&"") Then die echojson("500","err id","") 
Select Case Trim(act)
Case "getsnapinfo":getsnapinfo
Case "getsnapmountlist":getsnapmountlist
Case "setsnapmount":setsnapmount
Case "setsnapunmount":setsnapunmount
Case "buysnapadv":buysnapadv
Case "setsnapperiod":setsnapperiod
Case "setsnapbkup":setsnapbkup
Case Else
	die echojson("500","未知操作","")
End Select


Sub setsnapbkup()
	Set ebssnap=New ebs_snap_class
	disk=requesta("info")
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.setsnapbkup(disk) Then
		die echojson(200,"手工创建数据命令已经提交请稍晚点再查看!","")
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End sub

Sub setsnapperiod()
	snapperiod=requesta("snapperiod")
	If Not isnumeric(snapperiod&"") Then die echojson("500","设置周期参数有误","")
	if CLng(snapperiod)<1 Or CLng(snapperiod)>10 Then  die echojson("500","设置周期参数有误","")

	Set ebssnap=New ebs_snap_class
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"") 
	If ebssnap.setsnapperiod(snapperiod) Then
		die echojson(200,"操作成功!","")
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>1111"),"")
	End If 

End Sub

Sub getsnapinfo()
	Set ebssnap=New ebs_snap_class
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.getsnapinfo() Then
		die echojson(200,"操作成功!",",""datas"":"&aspjsonprint(ebssnap.okstr))
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End Sub

Sub getsnapmountlist()
	Set ebssnap=New ebs_snap_class
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.getmountsnap() Then
		die echojson(200,"操作成功!",",""datas"":"&aspjsonprint(ebssnap.okstr))
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End Sub
Sub setsnapmount()
	Set ebssnap=New ebs_snap_class
	os=requesta("os")
	data=requesta("data")
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.setsnapmount(os,data) Then
		die echojson(200,"挂载云镜像成功!","")
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End sub

Sub setsnapunmount()
	Set ebssnap=New ebs_snap_class
	disk=requesta("info")
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.setsnapunmount(disk) Then
		die echojson(200,"取消挂载成功","")
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End Sub

Sub buysnapadv()
	Set ebssnap=New ebs_snap_class
	ebssnap.setuid=Session("u_sysid")
	ebssnap.setid=id 
	If ebssnap.errarr.length>0 Then die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	If ebssnap.buysnapadv() Then
		die echojson(200,"操作成功!","")
	Else
		die echojson(500,ebssnap.errarr.Join("<BR>"),"")
	End If 
End sub
%>