<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(1)%>
<%
Select Case Requesta("module")
  Case "del"
	conn.open constr
	rs.open "select top 1 * from [news] where newsid="&Requesta("newsid"),conn,3
	imagefiles=rs("newpic")
	rs.close
	conn.Execute "delete from news where newsid="&Requesta("newsid")

	If imagefiles<>"" Then
		sport = instr(15,imagefiles,"/")
		imagefiles =left(imagefiles,sport-1)
		actfilpath = Server.MapPath("/")
		imagefiles = actfilpath & replace(imagefiles,"/","\")
		Set fs = server.CreateObject(objName_FSO)
		   If fs.FolderExists(imagefiles) Then
			  fs.deletefolder (imagefiles)
		   End If
		Set fs = Nothing
	End If

	rs.open "select top 6 * from news where  newsshow =0 order by newsid desc" ,conn,3
	newsjs="javastr=""""" & vbCrLf
	Do While Not rs.eof
		'newsjs=newsjs& "javastr=javastr +""<tr><td height=25 colspan=4><strong><font color=#FF9900>→</font></strong>&nbsp;<a target=_blank href=/news/list.asp?newsid="&rs("newsid")&">"&left(rs("newstitle"),25)&".<\/a></td></tr>""" & vbCrLf
		newsjs=newsjs& "javastr+=""<table width='97%' border=0 cellpadding=0 cellspacing=0><tr><td><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td width='22%'><img src=/images/Default_90.gif width=39 height=11></td><td width='78%'>"&replace(left(rs("newpubtime"),len(rs("newpubtime"))-8),"""","\""")&"</td></tr></table></td></tr><tr><td><a href='/news/list.asp?newsid="&rs("newsid")&"'>"&gotTopic(rs("newstitle"),34)&"</a><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td background=/images/Default_98.gif><img src=/images/Default_98.gif width=2 height=1></td></tr></table></td></tr></table>""" & vbCrLf
		rs.movenext
	Loop
	newsjs=newsjs & "document.write (javastr)" & vbCrLf
	

	actfilpath = Server.MapPath("/")
	newspaths=actfilpath& "\news\news.js"
	Response.Write newspaths

	Set fs = server.CreateObject(objName_FSO)
	Set WFS = fs.OpenTextFile(newspaths, 2,true)
	WFS.Write newsjs
	WFS.Close
	Set wfs= Nothing
	Set fs = Nothing
	rs.close
	conn.close


	alert_redirect "删除成功" , "default.asp"
  Case else

	conn.open constr
	conn.Execute "update news set newsshow=0 where newsid="&Requesta("newsid")
	rs.open "select top 6 * from news where  newsshow =0 order by newsid desc" ,conn,3
	newsjs="javastr=""""" & vbCrLf
	Do While Not rs.eof
		'newsjs=newsjs& "javastr=javastr +""<tr><td height=25 colspan=4><strong><font color=#FF9900>→</font></strong>&nbsp;<a target=_blank href=/news/list.asp?newsid="&rs("newsid")&">"&left(rs("newstitle"),18)&".<\/a></td></tr>""" & vbCrLf
		newsjs=newsjs& "javastr+=""<table width='97%' border=0 cellpadding=0 cellspacing=0><tr><td><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td width='22%'><img src=/images/Default_90.gif width=39 height=11></td><td width='78%'>"&replace(left(rs("newpubtime"),len(rs("newpubtime"))-8),"""","\""")&"</td></tr></table></td></tr><tr><td><a href='/news/list.asp?newsid="&rs("newsid")&"'>"&gotTopic(rs("newstitle"),34)&"</a><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td background=/images/Default_98.gif><img src=/images/Default_98.gif width=2 height=1></td></tr></table></td></tr></table>""" & vbCrLf
		rs.movenext
	Loop




	newsjs=newsjs & "document.write (javastr)" & vbCrLf

	actfilpath = Server.MapPath("/")
	newspaths=actfilpath& "\news\news.js"
	Response.Write newspaths

	Set fs = server.CreateObject(objName_FSO)
	Set WFS = fs.OpenTextFile(newspaths, 2,true)
	WFS.Write newsjs
	WFS.Close
	Set wfs= Nothing
	Set fs = Nothing
	rs.close
	conn.close
	alert_redirect "发布成功" , "default.asp"
End Select

%><!--#include virtual="/config/bottom_superadmin.asp" -->
