
<!--#include file="conn.asp"-->
<!--#include file="upload.inc"-->
<!--#include file="const.asp"-->
<%Check_Is_Master(6)%>

<html>
<head>
<title>�ļ��ϴ�</title>
<link href="image/style.css" rel="stylesheet" type="text/css">
</head>

<body text="#000000" leftmargin="0" topmargin="0" bgcolor="#F4EEE4" class="Utu">
<script>
parent.document.forms[0].Submit.disabled=false;
parent.document.forms[0].Submit2.disabled=false;
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#CCCCCC">
  <tr> 
    <td width="388" align="center" valign="middle"> 
      <%


Set Upload = New UpFile_Class
Upload.InceptFileType = UpFileType
Upload.MaxSize = Int(MaxFileSize*1024)
Upload.GetDate()


methods = Upload.form("methods")


If Upload.Err > 0 Then
		Select Case Upload.Err
			Case 1 : Response.Write "����ѡ����Ҫ�ϴ����ļ���[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]"
			Case 2 : Response.Write "ͼƬ��С���������� "&MaxFileSize&"K��[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]"
			Case 3 : Response.Write "���ϴ����Ͳ���ȷ��[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]"
		End Select
		response.end
Else
		For Each FormName in Upload.file		''�г������ϴ��˵��ļ�
					 Set File = Upload.File(FormName)	''����һ���ļ�����
					 If File.Filesize<10 Then
				 		Response.Write "����ѡ����Ҫ�ϴ���ͼƬ��[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]"
						response.end
			 		End If
					FileExt	= FixName(File.FileExt)
					
					
		 			If Not ( CheckFileExt(FileExt) and CheckFileType(File.FileType) ) Then
		 				Response.Write "�ļ���ʽ����ȷ��[ <a href=# onclick=history.go(-1)>�����ϴ�</a> ]"
						response.end
					End If
					
					FormPath = SaveUpFilesPath
					
					if right(FormPath,1)<>"/" then FormPath = FormPath &"/"
					
		 			FileName=FormPath & UserFaceName(FileExt)
		 			
		 			If File.FileSize>0 Then   ''��� FileSize > 0 ˵�����ļ�����
						File.SaveToFile Server.mappath(FileName)   ''�����ļ�
						if methods = 1 then
								response.write "<script>parent.WBTB_Composition.document.body.innerHTML+='<br><a href="& FileName &"><img border=0 src=image/"&FileExt&".gif>�������������ļ�"& FileName &"</a>'</script>"
						else
								response.write "<script>parent.WBTB_Composition.document.body.innerHTML+='<br><img border=0 src="&FileName&">'</script>"
						end if
						if methods <> 1 then
							response.write "<script>parent.document.form1.DefaultPic.value='<img src="&FileName&" width=120 height=90 vspace=5 border=0>'</script>"
						end if
												
						if methods <> 1 then
							Response.Write "<a href=admin_upload.asp><span class=14p>�ϴ��ɹ� ����</span></a>"
						else
							Response.Write "<a href=admin_uploadF.asp><span class=14p>�ϴ��ɹ� ����</span></a>"
						end if
		 			End If
		 			Set File=Nothing
		Next
End If
Set Upload=Nothing
	


Function FixName(UpFileExt)
	If IsEmpty(UpFileExt) Then Exit Function
	FixName = Lcase(Trim(UpFileExt))
	FixName = Replace(FixName,Chr(0),"")
	FixName = Replace(FixName,".","")
	FixName = Replace(FixName,"asp","")
	FixName = Replace(FixName,"asa","")
	FixName = Replace(FixName,"aspx","")
	FixName = Replace(FixName,"cer","")
	FixName = Replace(FixName,"cdx","")
	FixName = Replace(FixName,"htr","")
End Function

Private Function UserFaceName(FileExt)
	Dim RanNum
	Randomize
	RanNum = Int(90000*rnd)+10000
 	UserFaceName = Year(now)&Month(now)&Day(now)&Hour(now)&Minute(now)&Second(now)&RanNum&"."&FileExt
End Function

Private Function CheckFileExt(FileExt)
	Dim ForumUpload,i
	ForumUpload=UpFileType
	ForumUpload=Split(ForumUpload,",")
	CheckFileExt=False
	For i=0 to UBound(ForumUpload)
		If LCase(FileExt)=Lcase(Trim(ForumUpload(i))) Then
			CheckFileExt=True
			Exit Function
		End If
	Next
End Function

Private Function CheckFileType(FileType)
	CheckFileType = False
	If Left(Cstr(Lcase(Trim(FileType))),6)="image/" Then CheckFileType = True
End Function
%>
    </td>
  </tr>
</table>
</body>
</html>
