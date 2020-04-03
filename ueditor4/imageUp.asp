<!--#include FILE="upload.inc"-->
<%
	if mid(session("u_type"),1,1)<>"1" then response.end
    dim upload,file,formName,title,state,picSize,picType,uploadPath,fileExt,fileName,prefix

	'如果日期前面的目录不存在将发生错误
    uploadPath = "/CustomerCenter/UploadImages/" & Year(date) & Right("0"&Month(date),2) & "/"
    picSize = 500
	picType = ".jpg,.gif,.png"
	uploadPath_=server.mappath(uploadPath)
	Set fso = CreateObject("scripting.filesystemobject")
	If Not fso.FolderExists(uploadPath_) Then Call fso.CreateFolder(uploadPath_)
	set fso=nothing
	state="SUCCESS"

    set upload=new upload_5xSoft
    title = htmlspecialchars(upload.form("pictitle"))

    for each formName in upload.file
        set file=upload.file(formName)

        if file.filesize > picSize*1024 then
            state="文件大小错误"
        end if

        fileExt = lcase(mid(file.FileName, instrrev(file.FileName,".")))
        if instr(picType, fileExt)=0 then
            state = "文件类型错误"
        end If

        prefix = int(900000*Rnd)+1000
        if state="SUCCESS" then
            fileName = uploadPath & "A_" & CreateRndFile() & fileExt
            file.SaveAs Server.mappath( fileName)
        end if

        response.Write "{'url':'" & FileName & "','title':'"& title &"','state':'"& state &"'}"
        set file=Nothing
        Exit For
    next
    set upload=Nothing

Function CreateRndFile()
	Dim t
	t=Now() : randomize
	CreateRndFile= Day(t) & Hour(t) & Minute(t) & Second(t) & Int(Rnd*100)
End Function

Function htmlspecialchars(someString)
	htmlspecialchars = replace(replace(replace(replace(someString, "&", "&amp;"), ">", "&gt;"), "<", "&lt;"), """", "&quot;")
End Function

%>