<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/upload_5xsoft.inc" -->
<%
DomainString=Request("server_name")
set fileobj=Server.CreateObject(objName_FSO)
set upload=New upload_5xsoft
SaveFolder=Server.MapPath(".") & "\UploadImages"
if not fileobj.FolderExists(SaveFolder) then fileobj.CreateFolder SaveFolder
FileName=Session.SessionID &"_" & right(Cstr(Round(Timer())),6)
OriginalFile="uploadFile"

Set oFile=upload.File(OriginalFile)

if oFile.FileSize=0 then 
	Response.write "上传失败，请选择要上传的文件名&nbsp;<a href=javascript:history.back()>返回</a>"
	Response.end
end if

Fext=Lcase(oFile.FileExt)

if inStr(",jpg,jpeg,gif,","," & Fext & ",")=0 then
	Response.write "上传失败，无效的扩展名&nbsp;<a href=javascript:history.back()>返回</a>"
	Response.end
end if

FileName=FileName & "." & Fext
oFile.saveAS SaveFolder & "\" & FileName
Set oFile=nothing
set upload=nothing

DomainString="http://"& Request.ServerVariables("SERVER_NAME")
if fileobj.FileExists(SaveFolder & "\" & FileName) then
	path_info=Request.ServerVariables("Path_info")
	slashPos=inStrRev(path_info,"/")
	url_path=left(path_info,slashPos) & "UploadImages/" 
	session("upfileFileName")=DomainString& url_path & FileName
	Response.write "<script language=javascript>parent.document.getElementById(""uploadFileName"").value='" &DomainString& url_path & FileName & "';parent.document.getElementById(""uploadLabel"").innerHTML='上传成功,文件名:" & FileName & "';</script>"
else
	Response.write "上传失败<a href=javascript:history.back()>返回</a>"
end if
%>