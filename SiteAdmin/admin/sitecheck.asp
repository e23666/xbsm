<!--#include virtual="/config/config.asp" -->
<%'Check_Is_Master(1)%>
<%
response.charset="GBK"
server.scriptTimeout=9999
response.Buffer=true
response.expires=-1

echo "现在时间：" & Now()
Set fso = CreateObject("scripting.filesystemobject")
Set doc=CreateObject("microsoft.xmldom")
Set localDic = CreateObject("scripting.dictionary")
Set remoteDic= CreateObject("scripting.dictionary")
StartPath=server.mappath("\")
Remotepath="http://update.myhostadmin.net/sitexml.xml"
nocheck_Exp="(\.log|acmd|\.lck|\.txt|\.css|\.swf|\.gif|\.jpg|\.png|thumbs\.db|\\template(.*?)\.html)+$"
starttime=Now()
echo "正在加载远程文件"
Call loadremotefile(Remotepath)
echo "Count: " & remotedic.count
echo "正在加载本地文件"
Call loadlocalfile(StartPath)
echo "Count: " & localdic.count 
echo "<hr>"
For Each lfile In localDic.Keys
	If remoteDic.Exists(lfile) Then
		errstr=""
		lvalue=Split( localdic(lfile),"|" )
		rvalue=Split( remoteDic(lfile),"|" )
		'If CDate(lvalue(0))<>CDate(rvalue(0)) Then errstr=errstr & "日期不正确,"
		If CDbl(lvalue(1))<>CDbl(rvalue(1)) Then errstr=errstr & " 大小错误,修改距今" & datediff("d",CDate(lvalue(0)),now()) & "天"
		If errstr<>"" Then
			echo lfile & Chr(9) & errstr
		End If
		localdic.Remove (lfile)
		Remotedic.Remove (lfile)
	End If
Next

For Each rfile In remotedic.Keys
	echo "本地缺少的文件: " & rfile
	lfile=rfile
Next

For each lfile in localdic.keys
	echo "本地多余文件: " & lfile
Next
echo "<hr>"
echo "完成，耗时：" & DateDiff("s",starttime,Now()) & " 秒"

Set fso=Nothing
Set doc=Nothing
Set localdic=Nothing
Set remotedic=Nothing






Sub loadremotefile(urlstr)
	On Error Resume Next : Err.clear
	Set xmlhttp = CreateObject("Microsoft.xmlhttp")
	xmlhttp.Open "GET", urlstr, False
	xmlhttp.setRequestHeader "Content-Type","text/xml"
	xmlhttp.send()
'	If xmlhttp.readyState<>4 Then Exit Sub
	Set oXML = xmlhttp.responseXML	
	Set objnodes = oXML.getElementsByTagName("myfile")
	For Each element In objnodes
		g_path=element.getAttribute("path")
		g_time=element.getAttribute("time")
		g_size=element.getAttribute("size")
		path_=CStr(LCase(g_path))
		If Not remoteDic.Exists(path_) and not regTest(path_,nocheck_Exp) Then
			remoteDic.Add path_,g_time & "|" & g_size
		End If
	Next
	If Err.number<>0 Then echo "ERROR: " & xmlhttp.state
	Set xmlhttp=Nothing 
End Sub
Sub getallfolder(path)
	Set objfolder=fso.GetFolder(path)
	Set objSubFolders=objFolder.SubFolders :  Set objfolder=Nothing
	For Each objSubFolder In objSubFolders 
		nowpath=path & "\" & objSubFolder.name
		Call getallfolder(nowpath)
		Call getallfile(nowpath)
	Next
End Sub
Sub getallfile(fold)
	Set objfiles=fso.GetFolder(fold)
	For Each objfile In objfiles.Files
		path_=CStr(LCase(Mid(objfile.Path,Len(StartPath)+1)))
		If Not localDic.Exists(path_) and not regTest(path_,nocheck_Exp) Then
			localDic.Add path_,objfile.DateLastModified & "|" & objfile.Size
		End If
	Next
	Set objfiles=Nothing
End Sub
Sub loadlocalfile(strpath)
	Call getallfile(strpath)
	Call getallfolder(strpath)
End Sub
Sub echo(strng)
	dim colorstr
	ffExt=right(lfile,4)
	if ffExt=".asp" Or ffExt=".php" Or ffExt="aspx" Or ffExt=".asa" then colorstr="red"
	If ffExt=".css" Or ffExt=".xml" Or ffExt=".txt" Or Right(lfile,3)=".js" Then colorstr="#666666"
	If Left(strng,1)="<" Then
		response.write strng
	Else
		response.write "<li onmouseover=""this.style.background='#f5f5f5'"" onmouseout=""this.style.background=''"" style='color:" & colorstr & "'>" & strng & "</li>"
	End if
	response.Flush()
End Sub 
Function regTest(strng,patng)
	Set oreg=New RegExp
	oreg.Global=True
	oreg.IgnoreCase=True
	oreg.Pattern=patng
	regTest=oreg.Test(strng)
	Set oreg=Nothing
End Function
%>