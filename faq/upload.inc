<%
'----------------------------------------------------------------------
'转发时请保留此声明信息,这段声明不并会影响你的速度!
'*******************   无惧上传类 V1.0  *********************************
'作者:梁无惧
'网站:http://www.25cn.com
'电子邮件:yjlrb@21cn.com
'版权声明:版权所有,源代码公开,各种用途均可免费使用,但是修改后必须把修改后的文件
'发送一份给作者.
'***********************************************************************
'***********************************************************************
'上传类强化记录
'修改者：Fssunwin
'----------------------------------------------------------------------
'添加以下属性：
'InceptFileType 允许上传的文件类型，以英文逗号“,”分隔。
'添加以下方法：
'FileWidth		图片宽度
'FileHeight		图片高度
'----------------------------------------------------------------------
'***********************************************************************

Dim oUpFileStream

Class UpFile_Class
	Public Form,File,Version,Err
	Private CHK_FileType,CHK_MaxSize

	Private Sub Class_Initialize
		Version = "无惧上传类 Version V1.0"
		Err = -1
		CHK_FileType = ""
		CHK_MaxSize = -1
		Set Form = Server.CreateObject ("Scripting.Dictionary")
		Set File = Server.CreateObject ("Scripting.Dictionary")
		Set oUpFileStream = Server.CreateObject ("Adodb.Stream")
		Form.CompareMode = 1
		File.CompareMode = 1
		oUpFileStream.Type = 1
		oUpFileStream.Mode = 3
		oUpFileStream.Open
	End Sub

	Private Sub Class_Terminate  
		'清除变量及对像
		Form.RemoveAll
		Set Form = Nothing
		File.RemoveAll
		Set File = Nothing
		oUpFileStream.Close
		Set oUpFileStream = Nothing
	End Sub

	Public Property Get InceptFileType
		InceptFileType = CHK_FileType
	End Property
	Public Property Let InceptFileType(Byval vType)
		CHK_FileType = vType
	End Property

	Public Property Get MaxSize
		MaxSize = CHK_MaxSize
	End Property
	Public Property Let MaxSize(vSize)
		If IsNumeric(vSize) Then CHK_MaxSize = Int(vSize)
	End Property

	Public Sub GetDate()
	   '定义变量
	  Dim RequestBinDate,sSpace,bCrLf,sInfo,iInfoEnd,tStream,iStart,oFileInfo
	  Dim sFormValue,sFileName,sFormName,RequestSize
	  Dim iFindStart,iFindEnd,iFormStart,iFormEnd,FileBlag
	   '代码开始
	  RequestSize = Int(Request.TotalBytes)
	  If  RequestSize < 1 Then
		Err = 1
		Exit Sub
	  End If
	  Set tStream = Server.CreateObject ("Adodb.Stream")
	  oUpFileStream.Write Request.BinaryRead (RequestSize)
	  oUpFileStream.Position = 0
	  RequestBinDate = oUpFileStream.Read
	  iFormEnd = oUpFileStream.Size
	  
	  bCrLf = ChrB (13) & ChrB (10)
	  '取得每个项目之间的分隔符
	  sSpace = MidB (RequestBinDate,1, InStrB (1,RequestBinDate,bCrLf)-1)
	  iStart = LenB  (sSpace)
	  iFormStart = iStart+2
	  '分解项目
	  Do
	    iInfoEnd = InStrB (iFormStart,RequestBinDate,bCrLf & bCrLf)+3
	    tStream.Type = 1
	    tStream.Mode = 3
	    tStream.Open
	    oUpFileStream.Position = iFormStart
	    oUpFileStream.CopyTo tStream,iInfoEnd-iFormStart
	    tStream.Position = 0
	    tStream.Type = 2
	    tStream.CharSet = "gb2312"
	    sInfo = tStream.ReadText
	    '取得表单项目名称
	    iFormStart = InStrB (iInfoEnd,RequestBinDate,sSpace)-1
	    iFindStart = InStr(22,sInfo,"name=""",1)+6
	    iFindEnd = InStr(iFindStart,sInfo,"""",1)
	    sFormName = Mid(sinfo,iFindStart,iFindEnd-iFindStart)
	    '如果是文件
		If InStr(45,sInfo,"filename=""",1) > 0 Then
			Set oFileInfo = new FileInfo_Class
			'取得文件属性
			iFindStart = InStr(iFindEnd,sInfo,"filename=""",1)+10
			iFindEnd = InStr(iFindStart,sInfo,"""",1)
			sFileName = Mid(sinfo,iFindStart,iFindEnd-iFindStart)
			oFileInfo.FileName = Mid(sFileName,InStrRev(sFileName, "\")+1)
			oFileInfo.FilePath = Left(sFileName,InStrRev(sFileName, "\"))
			oFileInfo.FileExt = Lcase(Mid(sFileName,InStrRev(sFileName, ".")+1))
			iFindStart = InStr (iFindEnd,sInfo,"Content-Type: ",1)+14
			iFindEnd = InStr (iFindStart,sInfo,vbCr)
			oFileInfo.FileType = Ucase(Mid(sinfo,iFindStart,iFindEnd-iFindStart))
			oFileInfo.FileStart = iInfoEnd
			oFileInfo.FileSize = iFormStart -iInfoEnd -2
			oFileInfo.FormName = sFormName
			If Instr(oFileInfo.FileType,"IMAGE/") Or Instr(oFileInfo.FileType,"FLASH") Then
				FileBlag = GetImageSize
				oFileInfo.FileExt = FileBlag(0)
				oFileInfo.FileWidth = FileBlag(1)
				oFileInfo.FileHeight = FileBlag(2)
				FileBlag = Empty
			End If
			If CHK_MaxSize > 0 Then
				If oFileInfo.FileSize > CHK_MaxSize Then
					Err = 2
					Exit Sub
				End If
			End If
			If CheckErr(oFileInfo.FileExt) = False Then
				Exit Sub
			End If
			File.Add sFormName,oFileInfo
		Else
			'如果是表单项目
			tStream.Close
			tStream.Type = 1
			tStream.Mode = 3
			tStream.Open
			oUpFileStream.Position = iInfoEnd 
			oUpFileStream.CopyTo tStream,iFormStart-iInfoEnd-2
			tStream.Position = 0
			tStream.Type = 2
			tStream.CharSet = "gb2312"
			sFormValue = tStream.ReadText
			If Form.Exists (sFormName) Then _
				Form (sFormName) = Form (sFormName) & ", " & sFormValue _
			Else _
				Form.Add sFormName,sFormValue
		End If
		tStream.Close
		iFormStart = iFormStart+iStart+2
	  '如果到文件尾了就退出
	  Loop Until  (iFormStart+2) = iFormEnd
	  RequestBinDate = ""
	  Set tStream = Nothing
	End Sub

	'====================================================================
	'验证上传类型
	'====================================================================
	Private Function CheckErr(Byval ChkExt)
		CheckErr=False
		If CHK_FileType = "" Then CheckErr=True : Exit Function
		Dim ChkStr
		ChkStr = ","&Lcase(CHK_FileType)&","
		If Instr(ChkStr,","&ChkExt&",")>0 Then
			CheckErr=True
		Else
			Err = 3
		End If
	End Function
	'====================================================================
	'图像宽高类型读取
	'====================================================================
	Private Function Bin2Str(Byval Bin)
		Dim i, Str, Sclow
		For i = 1 To LenB(Bin)
			Sclow = MidB(Bin,i,1)
			If ASCB(Sclow)<128 Then
				Str = Str & Chr(ASCB(Sclow))
			Else
				i = i+1
				If i <= LenB(Bin) Then Str = Str & Chr(ASCW(MidB(Bin,i,1)&Sclow))
			End If
		Next 
		Bin2Str = Str
	End Function

	Private Function Num2Str(Byval num,Byval Base,Byval Lens)
		Dim ImageSize
		ImageSize = ""
		While(num>=Base)
			ImageSize = (num mod Base) & ImageSize
			num = (num - num mod Base)/Base
		Wend
		Num2Str = Right(String(Lens,"0") & num & ImageSize,Lens)
	End Function

	Private Function Str2Num(Byval str,Byval Base)
		Dim ImageSize,i
		ImageSize = 0
		For i=1 To Len(str)
			ImageSize = ImageSize *Base + Cint(Mid(str,i,1))
		Next
		Str2Num = ImageSize
	End Function

	Private Function BinVal(Byval bin)
		Dim ImageSize,i
		ImageSize = 0
		For i = lenb(bin) To 1 Step -1
			ImageSize = ImageSize *256 + ASCB(Midb(bin,i,1))
		Next
		BinVal = ImageSize
	End Function

	Private Function BinVal2(Byval bin)
		Dim ImageSize,i
		ImageSize = 0
		For i = 1 To Lenb(bin)
			ImageSize = ImageSize *256 + ASCB(Midb(bin,i,1))
		Next
		BinVal2 = ImageSize
	End Function

	Private Function GetImageSize() 
		Dim ImageSize(2),bFlag
		bFlag = oUpFileStream.Read(3)

		Select Case Hex(BinVal(bFlag))
			Case "4E5089":
				oUpFileStream.Read(15)
				ImageSize(0) = "png"
				ImageSize(1) = BinVal2(oUpFileStream.Read(2))
				oUpFileStream.Read(2)
				ImageSize(2) = BinVal2(oUpFileStream.Read(2))
			Case "464947":
				oUpFileStream.Read(3)
				ImageSize(0) = "gif"
				ImageSize(1) = BinVal(oUpFileStream.Read(2))
				ImageSize(2) = BinVal(oUpFileStream.Read(2))
			Case "535746":
				Dim BinData,sConv,nBits
				oUpFileStream.Read(5)
				BinData = oUpFileStream.Read(1)
				sConv = Num2Str(ASCB(BinData),2 ,8)
				nBits = Str2Num(Left(sConv,5),2)
				sConv = Mid(sConv,6)
				While(Len(sConv)<nBits*4)
					BinData = oUpFileStream.Read(1)
					sConv = sConv&Num2Str(ASCB(BinData),2 ,8)
				Wend
				ImageSize(0) = "swf"
				ImageSize(1) = Int(ABS(Str2Num(Mid(sConv,1*nBits+1,nBits),2)-Str2Num(Mid(sConv,0*nBits+1,nBits),2))/20)
				ImageSize(2) = Int(ABS(Str2Num(Mid(sConv,3*nBits+1,nBits),2)-Str2Num(Mid(sConv,2*nBits+1,nBits),2))/20)
			Case "535743":'flashmx
				ImageSize(0) = "swf"
				ImageSize(1) = 0
				ImageSize(2) = 0
			Case "FFD8FF":
				Dim p1
				Do 
					Do: p1 = BinVal(oUpFileStream.Read(1)): Loop While p1 = 255 And Not oUpFileStream.EOS
					If p1>191 and p1<196 Then Exit Do Else oUpFileStream.Read(BinVal2(oUpFileStream.Read(2))-2)
					Do:p1 = BinVal(oUpFileStream.Read(1)):Loop While p1<255 And Not oUpFileStream.EOS
					Loop While True
					oUpFileStream.Read(3)
					ImageSize(0) = "jpg"
					ImageSize(2) = BinVal2(oUpFileStream.Read(2))
					ImageSize(1) = BinVal2(oUpFileStream.Read(2))
			Case Else:
				If Left(Bin2Str(bFlag),2) = "BM" Then
					oUpFileStream.Read(15)
					ImageSize(0) = "bmp"
					ImageSize(1) = BinVal(oUpFileStream.Read(4))
					ImageSize(2) = BinVal(oUpFileStream.Read(4))
				Else
					ImageSize(0) = "(UNKNOWN)"
				End If
		End Select
		GetImagesize = ImageSize
	End Function
End Class

'文件属性类
Class FileInfo_Class
	Public FormName,FileName,FilePath,FileSize,FileType,FileStart,FileExt,FileWidth,FileHeight
	Private Sub Class_Initialize
		FileWidth=0
		FileHeight=0
	End Sub
	'保存文件方法
	Public Sub SaveToFile (Byval Path)
		Dim Ext,oFileStream
		Ext = LCase(Mid(Path, InStrRev(Path, ".") + 1))
		If Ext <> FileExt Then Exit Sub
		If Trim(Path)="" or FileStart=0 or FileName="" or Right(Path,1)="/" Then Exit Sub
		'On Error Resume Next
		Set oFileStream = CreateObject ("Adodb.Stream")
		oFileStream.Type = 1
		oFileStream.Mode = 3
		oFileStream.Open
		oUpFileStream.Position = FileStart
		oUpFileStream.CopyTo oFileStream,FileSize
		oFileStream.SaveToFile Path,2
		oFileStream.Close
		Set oFileStream = Nothing 
	End Sub
	'取得文件数据
	Public Function FileData
		oUpFileStream.Position = FileStart
		FileData = oUpFileStream.Read (FileSize)
	End Function
End Class
%>
