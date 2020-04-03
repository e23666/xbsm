<object runat="server" id="conn" scope="page" progid="ADODB.Connection"></object>

<object runat="server" id="rs" scope="page" progid="ADODB.Recordset"></object>
<object runat="server" id="rs1" scope="page" progid="ADODB.Recordset"></object>
<object runat="server" id="cmd" scope="page" progid="ADODB.Command"></object>

<object runat="server" id="conn11" scope="page" progid="ADODB.Connection"></object>
<object runat="server" id="rs11" scope="page" progid="ADODB.Recordset"></object>
<!--#include virtual="/config/const.asp"-->
<!--#include virtual="/config/conn.asp"-->
<!--#include virtual="/config/usercomm.asp"-->
<!--#include virtual="/config/newasp_md5.asp"-->
<!--#include virtual="/config/class/aspjsonclass.asp"-->
<!--#include virtual="/config/asp_md5class.asp"-->
<%
dim iswhoischeck
iswhoischeck=false
Function Requesta(strRequest)
	Requesta = sqlincode(Request(strRequest))	
End Function
Function Requestf(strRequest)
	Requestf = sqlincode(Request.Form(strRequest))	
End Function

function Alert_Redirect(this_string,this_url)
%>
  <script language="JavaScript">
         alert('<%=this_string%>');
         window.location='<%=this_url%>';
  </script>
<%
  response.end
end function

function url_return(this_string,this_skip)
%>
  <script language="JavaScript">
         alert('<%=this_string%>');
         window.history.go(<%=this_skip%>);
  </script>
<%
  response.end
end function
function errpage(errstr)
	response.redirect "/error.asp?errstr="& server.URLEncode(errstr)
	response.end
end function
''''''''''''''''''''''朱小维''''''''''手机号实别'''''''''''''''
Function IsValidMobileNo(sInput)
  	Dim oRegExp
	if trim(sInput)&""="" then IsValidMobileNo=false:exit function
	Set oRegExp = new RegExp
	oRegExp.Pattern = "^0?1\d{10}$"
	oRegExp.IgnoreCase = false
	oRegExp.Global = True
	IsValidMobileNo = oRegExp.Test(sInput)
	Set oRegExp = Nothing
End Function 
function isIp(ipadd)
 isIp=false
 set oReg=new RegExp
 oReg.IgnoreCase=true
 ipadd=ipadd&""
 oReg.global=true
 oReg.Pattern="^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$"
 if oReg.test(ipadd) then isIp=true
 set oReg=nothing
end function
function isDomain(byval strdomain)
	isDomain=false
	dim oRegExp:Set oRegExp = new RegExp
	oRegExp.Pattern = "^([\u4e00-\u9fa5a-z0-9\-]+)\.([\u4e00-\u9fa5a-z]+)(\.([a-z]+))*$"
	oRegExp.IgnoreCase = True
	oRegExp.Global = True
	isDomain = oRegExp.Test(strdomain)
	Set oRegExp = Nothing
end function
function checkRegExp(byval v,byval e)
	Set oRegExp = new RegExp
	oRegExp.Pattern =e
	oRegExp.IgnoreCase = true 
	oRegExp.Global = True
	checkRegExp = oRegExp.Test(v)
	Set oRegExp = Nothing
end function
function CloseObject(thisObj)
  if(isObject(thisObj))then
    set thisObj = Nothing
  end if
end function
function getVpsprice(byval username,byval proid,byval room,byval paytype,byval cdntype,byval dotype)
	result=999999
	set vpsRs=server.CreateObject("ADODB.Recordset")
	sql="select top 1 v_monthPrice,v_seasonPrice,v_halfyearPrice,v_yearPrice from vps_price where p_proid='"& proid  &"' and v_room="& room
	vpsRs.open sql,conn,1,1
	if not vpsRs.eof then
		v_monthPrice=vpsRs("v_monthPrice")&""
		v_seasonPrice=vpsRs("v_seasonPrice")&""
		v_halfyearPrice=vpsRs("v_halfyearPrice")&""
		v_yearPrice=vpsRs("v_yearPrice")&""
		paymonthnum=getpaymonthnum(paytype)
		'response.Write(v_yearPrice&"|"&v_monthPrice&"|"&v_halfyearPrice&"||"&v_seasonPrice&"||"&paymonthnum&"=")
		if isnumeric(v_monthPrice) or v_monthPrice<>"" then
			if paytype=0 then
	 
				result=v_monthPrice
			elseif paytype=2 then
				if v_seasonPrice="" then
					result=cdbl(v_monthPrice)*paymonthnum
				else
					result=v_seasonPrice
				end if
			elseif paytype=3 then
				if v_halfyearPrice="" then
					result=cdbl(v_monthPrice)*paymonthnum
				else
					result=v_halfyearPrice
				end if
			elseif paytype=1 then
				if v_halfyearPrice="" then
					result=cdbl(v_monthPrice)*paymonthnum
				else
					result=v_yearPrice
				end if
			elseif paytype=4 then
 
			    if v_halfyearPrice="" then
					result=cdbl(v_monthPrice)*paymonthnum*0.75
				else
						result=v_yearPrice*1.5
				end if
			elseif paytype=5 then
 
			    if v_halfyearPrice="" then
					result=cdbl(v_monthPrice)*paymonthnum
				else
						result=v_yearPrice*2
				end if
			end if			
		end if
	
		set cRs=server.CreateObject("ADODB.Recordset")
		a_discount=1
		sql="select a_discount from vps_agentprice where p_proid='"& proid &"' and a_level=(select u_level from userdetail where u_name='"& username &"')"
		crs.open sql,conn,1,1
		if not crs.eof then
			if isnumeric(trim(crs("a_discount")))then
				a_discount=cdbl(trim(crs("a_discount")))
			end if
		end if
		crs.close:set crs=nothing
		firstvpsdiscount=trim(firstvpsdiscount)
		if firstvpsdiscount&""="" or not isnumeric(firstvpsdiscount) then firstvpsdiscount=1
		if paytype=0 and dotype="new" and cdbl(firstvpsdiscount)<cdbl(a_discount) then
			a_discount=firstvpsdiscount
		end if
		result=cdbl(result) * cdbl(a_discount)
		'if a_discount=1 then
			'if paytype=0 and dotype="new" and isnumeric(firstvpsdiscount) then
				'result=cdbl(result) * cdbl(firstvpsdiscount)
			'end if
		'else
			'result=cdbl(result) * cdbl(a_discount)
		'end if		
		if not isnumeric(cdntype) or cdntype="" then cdntype=0
			if cdntype=0 then
				cdnmoney=0
			elseif cdntype=1 then
				cdnmoney=50
			elseif cdntype=2 then
				cdnmoney=100
			elseif cdntype=3 then
				cdnmoney=100
			elseif cdntype=4 then
				cdnmoney=150
			end if
		PricMoney=cdbl(result)+cdnmoney*paymonthnum
	end if
	result=PricMoney
	vpsRs.close:set vpsRs=nothing
	getVpsprice=round(result)
end function
function getpaymonthnum(byval payMethod)
		select case payMethod
		case 0
			getpaymonthnum=1
		case 2
			getpaymonthnum=3
		case 3
			getpaymonthnum=6
		case 1
			getpaymonthnum=12
		case 4
			getpaymonthnum=24
		case 5
			getpaymonthnum=24
		end select
		getpaymonthnum=getpaymonthnum
end function
function getOtherPrice(byval servicetype,byval isvps)
	addServerPrice=0
	if isvps then
		select case right(servicetype,4)
			case "基础服务"
				addServerPrice=0
			case "铜牌服务"
				addServerPrice=68
			case "银牌服务"
				addServerPrice=98
			case "金牌服务"
				addServerPrice=188
		end select 
	else
		select case right(servicetype,4)
			case "基础服务"
				addServerPrice=0
			case "铜牌服务"
				addServerPrice=68
			case "银牌服务"
				addServerPrice=98
			case "金牌服务"
				addServerPrice=188
		end select 
	end if
	getOtherPrice=addServerPrice
end function
Function addDFApplication(strval)
	nowtimekey = strtonum(intnowval())
	If strval="" Then addDFApplication= nowtimekey :exit function
	If instr( "," &  strval& ",","," & nowtimekey  & "," )>0 Then
		addDFApplication=strval
	  else
		addDFApplication= nowtimekey & "," & strval
		expirespot = instr( "," & addDFApplication & ",","," & nowtimekey-2 & ",")
		If expirespot>0 Then
			addDFApplication = left(addDFApplication,expirespot-2)
		End If
	End If
End Function
Function intnowval()
	intnowval = day(now)*24*6 + hour(now)* 6 + int(minute(now)/10 + 0.5)
End Function
function StrToNum(this_string)
        if isnull(this_string) then
               this_string=""
        end if
        this_string=trim("" & this_string)
        if isnumeric(this_string) then
           StrToNum=clng(this_string)
        else
           StrToNum=0
	end if
end function
Function connnectstrings(stringsall,substrings)
	actions = 0
	if stringsall="" then connnectstrings = substrings : exit function
	If substrings="" Then connnectstrings = stringsall : exit function
	spot = instr(1,"," & stringsall& ",","," & substrings & ",")
	If spot>0 Then  connnectstrings = stringsall : exit function
	connnectstrings = substrings  & "," & stringsall
End Function

Function addDFApplication(strval)
	nowtimekey = strtonum(intnowval())
	If strval="" Then addDFApplication= nowtimekey :exit function
	If instr( "," &  strval& ",","," & nowtimekey  & "," )>0 Then
		addDFApplication=strval
	  else
		addDFApplication= nowtimekey & "," & strval
		expirespot = instr( "," & addDFApplication & ",","," & nowtimekey-2 & ",")
		If expirespot>0 Then
			addDFApplication = left(addDFApplication,expirespot-2)
		End If
	End If
End Function

Function deletesubstring( stringsall,substrings)
	actions = 0
	if stringsall="" then   deletesubstring ="" : exit function
	If substrings="" Then  deletesubstring =stringsall : exit function
	spot = instr(1,"," & stringsall& ",","," & substrings & ",")
	If spot=0 Then deletesubstring =stringsall : exit function
	lengthstr = len(stringsall)
	lengthsub = len(substrings)
	If stringsall=substrings And actions = 0  Then actions = 1
	If instr(1,stringsall,substrings)=1 And actions = 0 Then actions = 2
	If lengthsub + spot -1  = lengthstr And actions = 0 Then actions = 3
	stringsall = lcase( stringsall)
	substrings = lcase(substrings)
	Select Case actions
	  Case 1 '相等
		deletesubstring = ""
	  Case 2 '在第一位
		deletesubstring = right( stringsall , lengthstr - lengthsub-1)
	  Case 3 '在最后
		deletesubstring = left( stringsall , lengthstr - lengthsub-1)
	  Case 0 '在中间
		deletesubstring = left(stringsall,spot-1) & right(stringsall,lengthstr- spot - lengthsub)
	End Select
End Function

'**************************************************
'过程名：WriteErrMsg
'作  用：显示错误提示信息
'参  数：无
'**************************************************
Sub WriteErrMsg(sErrMsg, sComeUrl)
    Response.Write "<html><head><title>错误信息</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbCrLf
    Response.Write "<link href='" & strInstallDir & "images/Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbCrLf
    Response.Write "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbCrLf
    Response.Write "  <tr align='center' class='title'><td height='22'><strong>错误信息</strong></td></tr>" & vbCrLf
    Response.Write "  <tr class='tdbg'><td height='100' valign='top'><b>产生错误的可能原因：</b>" & sErrMsg & "</td></tr>" & vbCrLf
    Response.Write "  <tr align='center' class='tdbg'><td>"
    If sComeUrl <> "" Then
        Response.Write "<a href='javascript:history.go(-1)'><< 返回上一页</a>"
    Else
        Response.Write "<a href='javascript:window.close();'>【关闭】</a>"
    End If
    Response.Write "</td></tr>" & vbCrLf
    Response.Write "</table>" & vbCrLf
    Response.Write "</body></html>" & vbCrLf
End Sub

'**************************************************
'过程名：WriteSuccessMsg
'作  用：显示成功提示信息
'参  数：无
'**************************************************
Sub WriteSuccessMsg(sSuccessMsg, sComeUrl)
    Response.Write "<html><head><title>成功信息</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbCrLf
    Response.Write "<link href='" & strInstallDir & "images/Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbCrLf
    Response.Write "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbCrLf
    Response.Write "  <tr align='center' class='title'><td height='22'><strong>恭喜你！</strong></td></tr>" & vbCrLf
    Response.Write "  <tr class='tdbg'><td height='100' valign='top'><br>" & sSuccessMsg & "</td></tr>" & vbCrLf
    Response.Write "  <tr align='center' class='tdbg'><td>"
    If sComeUrl <> "" Then
        Response.Write "<a href='" & sComeUrl & "'><< 返回上一页</a>"
    Else
        Response.Write "<a href='javascript:window.close();'>【关闭】</a>"
    End If
    Response.Write "</td></tr>" & vbCrLf
    Response.Write "</table>" & vbCrLf
    Response.Write "</body></html>" & vbCrLf
End Sub

Sub OpenConn()
    'On Error Resume Next
    Dim ConnStr
    If SystemDatabaseType = "SQL" Then
        ConnStr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlHostIP & ";"
    Else
        ConnStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & DBPath
    End If
    Set Conn = Server.CreateObject("ADODB.Connection")
    Conn.open ConnStr
    If Err Then
		'response.Write(err.number)_
        Err.Clear
        Set Conn = Nothing
        Response.Write "数据库连接出错，请检查Conn.asp文件中的数据库参数设置。"
        Response.End
    End If
    If SystemDatabaseType = "SQL" Then
        PE_True = "1"
        PE_False = "0"
        PE_Now = "GetDate()"
        PE_OrderType = " desc"
        PE_DatePart_D = "d"
        PE_DatePart_Y = "yyyy"
        PE_DatePart_M = "m"
        PE_DatePart_W = "ww"
        PE_DatePart_H = "hh"
    Else
        PE_True = "True"
        PE_False = "False"
        PE_Now = "Now()"
        PE_OrderType = " asc"
        PE_DatePart_D = "'d'"
        PE_DatePart_Y = "'yyyy'"
        PE_DatePart_M = "'m'"
        PE_DatePart_W = "'ww'"
        PE_DatePart_H = "'h'"
    End If
End Sub


Sub CloseConn()
    On Error Resume Next
    If IsObject(Conn) Then
        Conn.Close
        Set Conn = Nothing
    End If
    Set regEx = Nothing
    Set PE_Cache = Nothing
End Sub



Function CreateMultiFolder(ByVal strPath)
    On Error Resume Next
    Dim strCreate
    If strPath = "" Or IsNull(strPath) Then CreateMultiFolder = False: Exit Function
    strPath = Replace(strPath, "\", "/")
    If Right(strPath, 1) <> "/" Then strPath = strPath & "/"
    Do While InStr(2, strPath, "/") > 1
        strCreate = strCreate & Left(strPath, InStr(2, strPath, "/") - 1)
        strPath = Mid(strPath, InStr(2, strPath, "/"))
        If Not fso.FolderExists(Server.MapPath(strCreate)) Then
            fso.CreateFolder Server.MapPath(strCreate)
        End If
        If Err Then Err.Clear: CreateMultiFolder = False: Exit Function
    Loop
    CreateMultiFolder = True
End Function

Function ReadFileContent(sFileName)
    On Error Resume Next
    Dim hf
    If Not fso.FileExists(Server.MapPath(sFileName)) Then
        ReadFileContent = ""
        Exit Function
    End If
    Set hf = fso.OpenTextFile(Server.MapPath(sFileName), 1)
    If Not hf.AtEndOfStream Then
        ReadFileContent = hf.ReadAll
    End If
    hf.Close
    Set hf = Nothing
End Function

Sub WriteToFile(WriteToFileName, WriteToFileContent)
    Dim ErrMsg
    ErrMsg = WriteToFile_FSO(WriteToFileName, WriteToFileContent)
    If ErrMsg <> "" Then
        ErrMsg = WriteToFile_ADO(WriteToFileName, WriteToFileContent)
        If ErrMsg <> "" Then
            Response.Write "<li>生成 " & WriteToFileName & " 时出错。出错原因：" & ErrMsg & "</li>"
        End If
    End If
End Sub

'=================================================
'函数名：WriteToFile
'作  用：写入相应的内容到指定的文件
'参  数：WriteToFileName ---- 写入文件的文件名
'        WriteToFileContent ---- 写入文件的内容
'=================================================
Function WriteToFile_FSO(WriteToFileName, WriteToFileContent)
    On Error Resume Next
    Err.Clear
    Dim hf
    Set hf = fso.OpenTextFile(Server.MapPath(WriteToFileName), 2, True)
    hf.Write WriteToFileContent
    hf.Close
    Set hf = Nothing
    If Err Then
        WriteToFile_FSO = Err.Description
        Err.Clear
    Else
        WriteToFile_FSO = ""
    End If
End Function

Function WriteToFile_ADO(WriteToFileName, WriteToFileContent)
    On Error Resume Next
    Err.Clear
    Dim stream
    Set stream = Server.CreateObject("ADODB.Stream")
	stream.Type = 2
    stream.Mode = 3
    stream.Open
    stream.Position = 0
    stream.WriteText WriteToFileContent
    stream.SaveToFile Server.MapPath(WriteToFileName), 2
    stream.Close
    Set stream = Nothing
    If Err Then
        WriteToFile_ADO = Err.Description
        Err.Clear
    Else
        WriteToFile_ADO = ""
    End If
End Function

Sub DelSerialFiles(ByVal strFiles)
    On Error Resume Next
    fso.DeleteFile strFiles
End Sub

Sub DelFiles(strUploadFiles)
    On Error Resume Next
    If Trim(strUploadFiles) = "" Or ObjInstalled_FSO <> True Then Exit Sub
    
    Dim arrUploadFiles, strFileName, i
    If InStr(strUploadFiles, "|") > 0 Then
        arrUploadFiles = Split(strUploadFiles, "|")
        For i = 0 To UBound(arrUploadFiles)
            If Trim(arrUploadFiles(i)) <> "" Then
                strFileName = InstallDir & ChannelDir & "/" & arrUploadFiles(i)
                Response.Write strFileName & "<br>"
                If fso.FileExists(Server.MapPath(strFileName)) Then
                    fso.DeleteFile (Server.MapPath(strFileName))
                End If
            End If
        Next
    Else
        strFileName = InstallDir & ChannelDir & "/" & strUploadFiles
        If fso.FileExists(Server.MapPath(strFileName)) Then
            fso.DeleteFile (Server.MapPath(strFileName))
        End If
    End If
End Sub

Sub ClearAspFile(strFilePath)
    Dim TrueDir
    Dim fs, f
    TrueDir = Server.MapPath(strFilePath)
    If fso.FolderExists(TrueDir) Then
        Set fs = fso.GetFolder(TrueDir)
        For Each f In fs.Files
            If CheckFileExt(NoAllowExt, GetFileExt(f.Name)) = True Then
                f.Delete
            End If
        Next
        Set fs = Nothing
    End If
End Sub
'取得文件路径
Function GetFilePath(FullPath)
    If FullPath <> "" Then
        GetFilePath = Trim(Left(FullPath, InStrRev(FullPath, "\")))
    Else
        GetFilePath = ""
    End If
End Function

'取得文件名
Function GetFileName(FullPath)
    If FullPath <> "" Then
        GetFileName = Trim(Mid(FullPath, InStrRev(FullPath, "\") + 1))
    Else
        GetFileName = ""
    End If
End Function

'取得文件的后缀名
Function GetFileExt(FullPath)
    Dim strFileExt
    If FullPath <> "" Then
        strFileExt = ReplaceBadChar(Trim(LCase(Mid(FullPath, InStrRev(FullPath, ".") + 1))))
        If Len(strFileExt) > 10 Then
            GetFileExt = Left(strFileExt, 3)
        Else
            GetFileExt = strFileExt
        End If
    Else
        GetFileExt = ""
    End If
End Function

Function CheckFileExt(strArr, str1)
    CheckFileExt = False
    If strArr = "" Or IsNull(strArr) Then Exit Function
    Dim arrFileExt, i
    arrFileExt = Split(strArr, "|")
    For i = 0 To UBound(arrFileExt)
        If Trim(str1) = Trim(arrFileExt(i)) Then
            CheckFileExt = True
            Exit For
        End If
    Next
End Function
'--------------------------
'作用:读取头部和底部模板
'说明:每一个文件需有{#top.html} 和{#bottom.html} 这两件标签用此过程才有效且必包含template类文件
'在调用页面输出
'朱小维 2008-4-15
sub setHeaderAndfooter()
    if right(InstallDir,1)="/" or right(InstallDir,1)="\" then newInstallDir=left(InstallDir,len(InstallDir)-1)
	managerurl=newInstallDir & "/manager"'用户管理中心地址
	If session("u_type")<>"0" Then
		managerurl=SystemAdminPath
	End If
	tpl.set_file "my_header", USEtemplate&"/config/top.html"
	tpl.set_file "my_footer", USEtemplate&"/config/bottom.html"
	tpl.set_file "mappath", USEtemplate&"/config/mappath.html"
	'tpl.set_function "mappath","sitemappath","siteMappath"
	
	
	if len(session("user_name"))<=0 then call check_is_cookie()
	if len(session("user_name"))>0 then
		tpl.set_file "my_header_login", USEtemplate&"/config/toplogin.html"  
        '201310-30  qq登陆显示昵称
		if session("u_contract")<>"" and  session("qq_openid")<>"" then
		tpl.set_var "user_name", session("u_contract"),false
		else
 		tpl.set_var "user_name", session("user_name"),false
	    end if
		tpl.set_var "u_level", session("u_level"),false
		tpl.set_var "managerurl",managerurl,false
		tpl.parse "topIslogin", "my_header_login",false 
		tpl.set_file "my_usermoney",USEtemplate&"/config/userMoney.html"
		tpl.set_var "u_usemoney",session("u_usemoney"),false
		tpl.set_var "u_resumesum",session("u_resumesum"),false
		tpl.parse "#usermoney.html", "my_usermoney",false 
		tpl.set_var "alipaylog","",false
	else
		tpl.set_file "my_header_nologin", USEtemplate&"/config/topNologin.html" 
		tpl.parse "topIslogin", "my_header_nologin",false
		if alipaylog then
			tpl.set_var "alipaylog","<li><a href=""/reg/alipaylog.asp"" target=""_blank""><img src=""/images/alipay/alipay_button.gif"" /></a></li>",false
		else
			tpl.set_var "alipaylog","",false
		end if
	end if
		tpl.set_var "quicklogin",getQuickLogin(),false
		tpl.set_var "logimgPath",logimgPath,false
		tpl.set_var "companyname",companyname,false
		tpl.set_var "companyaddress",companyaddress,false
		tpl.set_var "postcode",postcode,false
		tpl.set_var "nightphone",nightphone,false
		tpl.set_var "telphone",telphone,false
		tpl.set_var "faxphone",faxphone,false
		tpl.set_var "supportmail",supportmail,false
		tpl.set_var "msn",msn,false
		tpl.set_var "agentmail",agentmail,false
		tpl.set_var "jobmail",jobmail,false
		tpl.set_var "version",version,false
		tpl.set_var "msn",msn,false
		tpl.set_var "companynameurl",companynameurl,False
		tpl.set_var "website_beianno",website_beianno,false
		tpl.set_block "my_footer","oicqlist","qqlists"
	for each oicqitem in split(oicq,",")
		tpl.set_var "oicq", oicqitem,false
		tpl.parse "qqlists", "oicqlist", true
	next 
	tpl.set_var "flashurl",GetFlashURL(),false
	tpl.parse "#top.html","my_header",false
	tpl.parse "#mappath.html","mappath",false
	tpl.parse "#bottom.html","my_footer",false
end sub

sub setwebhostingLeft()
	tpl.set_file "hostLeft", USEtemplate&"/config/webhostingLeft/webhostingLeft.html" 
	tpl.parse "#webhostingleft.html","hostLeft",false
end sub
sub setwebhostingtop()
	tpl.set_file "hosttop", USEtemplate&"/config/webhostingLeft/webhosttop.html" 
	tpl.parse "#webhosttop.html","hosttop",false
end sub
sub setvpsserverLeft()
	tpl.set_file "vpsLeft", USEtemplate&"/config/VPSserver/vpsleft.html" 
	tpl.parse "#vpsleft.html","vpsLeft",false
end sub
sub setcloudhostLeft()
	tpl.set_file "vpsLeft", USEtemplate&"/config/cloudhostleft/cloudhostleft.html" 
	tpl.parse "#cloudhostleft.html","vpsLeft",false
end sub

sub setserverLeft()
	tpl.set_file "serverLeft", USEtemplate&"/config/serverleft/serverleft.html" 
	tpl.parse "#ServerLeft.html","serverLeft",false
end sub
sub setMailLeft()
	tpl.set_file "mailLeft", USEtemplate&"/config/Mailleft/mailleft.html" 
	tpl.parse "#mailleft.html","mailLeft",false
end sub
sub setagentLeft()
	tpl.set_file "agentLeft", USEtemplate&"/config/agentleft/agentleft.html" 
	tpl.parse "#agentleft.html","agentLeft",false
end sub
sub setregsubLeft()
	tpl.set_file "regLeft", USEtemplate&"/config/regleft/regleft.html" 
	tpl.parse "#RegLeft.html","regLeft",false
end sub
sub setDomainLeft()
	tpl.set_file "DomainLeft", USEtemplate&"/config/domainleft/DomainLeft.html" 
	tpl.parse "#DomainLeft.html","DomainLeft",false
end sub
'**************************************************
'函数名：IsObjInstalled
'作  用：检查组件是否已经安装
'参  数：strClassString ----组件名
'返回值：True  ----已经安装
'        False ----没有安装
'**************************************************
Function IsObjInstalled(strClassString)
    On Error Resume Next
    IsObjInstalled = False
    Err = 0
    Dim xTestObj
    Set xTestObj = CreateObject(strClassString)
    If Err.Number = 0 Then IsObjInstalled = True
    Set xTestObj = Nothing
    Err = 0
End Function
'去掉重复
'参数x:要过滤的字符串
'y:字符串间的分隔符
function delRepeatStr(x,y)
	 if trim(x)&""<>"" then
		  dim   A,S,tag,aaa   
		  S = ""   
		  A = split(x,y)   
		  for each aaa in A     
			if instr(y & S,y & aaa & y)<1 then S= S & aaa & y 
		  next
			F = trim(replace(S," ",""))
			if right(F,1)=y then F=left(F,len(F)-1)
	 else
	 	F=x
	 end if
	delRepeatStr=F
end   function
function GetDomainType(strdomain)
	domain_proid=""
	if len(strdomain)>0 then
	domain_suffix=trim(mid(strdomain,instrRev(strdomain,".")+1))
		if lcase(left(strdomain,4))="xn--" or isChinese(strdomain) then
			select case domain_suffix
					case "biz"
					 domain_proid="bizchina"
					case "cc" 
					 domain_proid="chinacc"
					case "tv" 
					 domain_proid="chinatv"
					case "公司" 
					 domain_proid="domgs"
					case "中国" 
					 domain_proid="domchina"
					case "网络" 
					 domain_proid="domwl"
					case "com" 
					 domain_proid="domhzcom"
					case "net" 
					 domain_proid="domhznet"
					case "cn"
					domain_proid="domhzcn"
					case "tm"
					domain_proid="chinatm"
					case "biz"
					domain_proid="bizchina"
					case "tel"
					domain_proid="chinatel"
					case "wang"
					domain_proid="domwang"
					case "我爱你"
					domain_proid="domlove"
					case "集团"
					domain_proid="domjt"
					case "top"
					domain_proid="domtop"
					case "世界"
					domain_proid="domsj"
					 case "网店"
					domain_proid="domcnwd"
					case "在线"
					domain_proid="domzx"
					case "网址"
					domain_proid="domwz"
					case "网络"
					domain_proid="domwl"
					case "广东"
					domain_proid="domgd"
					case "佛山"
					domain_proid="domfs"
					case "中文网"
					domain_proid="domzww"
					case "信息"
					domain_proid="domxx"
					case "企业"
					domain_proid="domcnqy"
					case else  
					domain_proid="domchina"		
			end select
		else
			select case domain_suffix
				   case "biz"
				   		domain_proid="dmbiz"
				   case "love"
				   		domain_proid="domenlove"
				   case "gs"
				   		domain_proid="domengs"
				   case else
				   		domain_proid="dom" & domain_suffix
		    end select
			if domain_proid="domcn" and mid(strdomain,instr(strdomain,".")+1)="gov.cn" then
				domain_proid="domgovcn"
			end if

			if domain_proid="domcom" and mid(strdomain,instr(strdomain,".")+1)="cn.com" then
				domain_proid="domcncom"
			end if

			if domain_proid="domhk" and mid(strdomain,instr(strdomain,".")+1)="com.hk" then
				domain_proid="domcomhk"
			end if

		end if
	end if
	GetDomainType=domain_proid
end function
'--------汉字的叛断
Function isChinese(para) 
       On Error Resume Next
       Dim str
       Dim i
       Dim c
       If IsNull(para) Then
          isChinese = False
          Exit Function
       End If
       str = CStr(para)
       If Trim(str) = "" Then
          isChinese = False
          Exit Function
       End If
       For i = 1 To Len(str)
       c = Asc(Mid(str, i, 1))
             If c < 0 Then
                isChinese = True
                Exit Function
           End If
       Next
	   if left(trim(str),4)="xn--" then isChinese = True:exit function
       isChinese = False
       If Err.Number <> 0 Then Err.Clear
End Function

function bstr(Byval Rbody)
	set xado=CreateObject("Adodb.Stream")
	xado.mode=3
	xado.type=1
	xado.open
	xado.write(Rbody)
	xado.position=0
	xado.type=2
	xado.charset="GB2312"
	bstr=xado.readtext()
	xado.close
	set xado=nothing
end function

'获得当前使用哪个域名查询接口。
function GetWhoisFrom()
		select case whoisapi
			   case 1
			   	GetWhoisFrom="west263"
			   case 2
			   	GetWhoisFrom="netcn"
			   case 3
			   	GetWhoisFrom="nowcn"
			   case 4
			    GetWhoisFrom="nowcn1"
			   case 5
			   	GetWhoisFrom="xinet"
			   case else
			   	GetWhoisFrom="west263"
		end select
end function
'邮件发送
'参数:主题,内容
'zxw
function sendMail(byval u_email,byval title,byval content)
		on error resume Next
		sendMail=False

		Const cdoSendUsingMethod="http://schemas.microsoft.com/cdo/configuration/sendusing" 
		Const cdoSendUsingPort=2 
		Const cdoSMTPServer="http://schemas.microsoft.com/cdo/configuration/smtpserver" 
		Const cdoSMTPServerPort="http://schemas.microsoft.com/cdo/configuration/smtpserverport" 
		Const cdoSMTPConnectionTimeout="http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout" 
		Const cdoSMTPAuthenticate="http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" 
		Const cdoBasic=1 
		Const cdoSendUserName="http://schemas.microsoft.com/cdo/configuration/sendusername" 
		Const cdoSendPassword="http://schemas.microsoft.com/cdo/configuration/sendpassword" 
		Const cdossl="http://schemas.microsoft.com/cdo/configuration/smtpusessl" '是否启用ssl
		Dim objConfig 
		Dim objMessage  
		Dim Fields
		If Not isNumeric(mailport&"") Then mailport=25
		Set objConfig = CreateObject("CDO.Configuration") 
		Set Fields = objConfig.Fields 
		With Fields 
		.Item(cdoSendUsingMethod) = cdoSendUsingPort 
		.Item(cdoSMTPServer) = mailserverip
		.Item(cdoSMTPServerPort) = mailport                  
		.Item(cdoSMTPConnectionTimeout) = 10     
		.Item(cdoSMTPAuthenticate) = cdoBasic 
		.Item(cdoSendUserName) = mailfrom
		.Item(cdoSendPassword) = mailserverpassword
		.Item(cdossl) = mailssl
		.Update 
		End With 

		Set objMessage = CreateObject("CDO.Message") 
		Set objMessage.Configuration = objConfig 

		objMessage.BodyPart.Charset = "GBK"
		objMessage.To=u_email
		objMessage.From=sendmailname&"<"&mailfrom&">"
		objMessage.Subject=title 
		objMessage.TextBody=content 
		objMessage.Cc=sendmailcc
		objMessage.Send

		Set Fields = Nothing 
		Set objMessage = Nothing 
		Set objConfig = Nothing
		m_status=Err.Description
		If Err.Number = 0 Then
			sendMail=True
			m_status="成功" 
		End IF
 
		sql="insert into maillog(m_title,m_mail,m_status) values('"&title&"','"&u_email&"','"&m_status&"')"
		conn.execute(sql)

end function

'邮件发送
'参数:主题,内容
'zxw
function sendHtmlMail(byval u_email,byval title,byval content,byval IsHtml)
		on error resume Next
		sendHtmlMail=false
		Const cdoSendUsingMethod="http://schemas.microsoft.com/cdo/configuration/sendusing" 
		Const cdoSendUsingPort=2 
		Const cdoSMTPServer="http://schemas.microsoft.com/cdo/configuration/smtpserver" 
		Const cdoSMTPServerPort="http://schemas.microsoft.com/cdo/configuration/smtpserverport" 
		Const cdoSMTPConnectionTimeout="http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout" 
		Const cdoSMTPAuthenticate="http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" 
		Const cdoBasic=1 
		Const cdoSendUserName="http://schemas.microsoft.com/cdo/configuration/sendusername" 
		Const cdoSendPassword="http://schemas.microsoft.com/cdo/configuration/sendpassword" 
		Const cdossl="http://schemas.microsoft.com/cdo/configuration/smtpusessl" '是否启用ssl
		Dim objConfig 
		Dim objMessage  
		Dim Fields
		If Not isNumeric(mailport&"") Then mailport=25
		Set objConfig = CreateObject("CDO.Configuration") 
		Set Fields = objConfig.Fields 
		With Fields 
		.Item(cdoSendUsingMethod) = cdoSendUsingPort 
		.Item(cdoSMTPServer) = mailserverip
		.Item(cdoSMTPServerPort) = mailport                  
		.Item(cdoSMTPConnectionTimeout) = 10     
		.Item(cdoSMTPAuthenticate) = cdoBasic 
		.Item(cdoSendUserName) = mailfrom
		.Item(cdoSendPassword) = mailserverpassword
		.Item(cdossl) = mailssl
		.Update 
		End With 
		Set objMessage = CreateObject("CDO.Message") 
		Set objMessage.Configuration = objConfig 		
		objMessage.BodyPart.Charset = "GBK"
		objMessage.To=u_email
		objMessage.From=sendmailname&"<"&mailfrom&">"
		objMessage.Subject=title
		If IsHtml then
			objMessage.HtmlBody=content
		Else
			objMessage.TextBody=content
		End if
		objMessage.Cc=sendmailcc
		objMessage.Send
		Set Fields = Nothing 
		Set objMessage = Nothing 
		Set objConfig = Nothing
		m_status="失败"
		If Err.Number = 0 Then
			sendHtmlMail=True
			m_status="成功"
		End IF
		sql="insert into maillog(m_title,m_mail,m_status) values('"&title&"','"&u_email&"','"&m_status&"')"
		conn.execute(sql)
end function

'读取邮件模板内容并替换标记
'参数:模板名,替换参数
'getStr格式: 标记1=值1,标记2=值2
'zxw
function redMailTemplate(byval templateName,byval getStr)
		
		senduser_name=user_name
		senduser_level=u_level
		if len(trim(senduser_name))=0 then senduser_name=session("user_name")
		if len(trim(senduser_level))=0 then senduser_level=session("u_level")
		set m_tpl=new Template
		m_tpl.set_root("/")
		m_tpl.set_file "mailtpl", "mailmodel/"& templateName
		m_tpl.set_var "user_name", senduser_name,false
		m_tpl.set_var "u_level", senduser_level,false
		m_tpl.set_var "companyname",companyname,false
		m_tpl.set_var "companyaddress",companyaddress,false
		m_tpl.set_var "postcode",postcode,false
		m_tpl.set_var "nightphone",nightphone,false
		m_tpl.set_var "telphone",telphone,false
		m_tpl.set_var "supportmail",supportmail,false
		m_tpl.set_var "companynameurl",companynameurl,false
		m_tpl.set_var "oicq",oicq,false
		
	for each pstr in split(getStr,",")
		if pstr<>"" then
			pArray=split(pstr,"=")
			if ubound(pArray)>=1 then
				p=trim(pArray(0))
				v=trim(pArray(1))
				m_tpl.set_var p,v,false
			end if
	 	end if
	next
	
	m_tpl.parse "mailtpls","mailtpl",false
	mailtplStr=m_tpl.vp("mailtpls")
	set m_tpl=nothing
	redMailTemplate=mailtplStr
end function
'===================
'列出指定产品10年的价格(节约资源)
'参数:用户名,产品id
'返回值:用|分隔的价格
'zxw
'07-11-23
function getpricelist(byval username,byval productid)
	pp=""
	for cur111=1 to 10
			pp=pp & GetNeedPrice(username,productid,cur111,"new")& "|"
	next
	'if right(pp,1)="|" then pp=left(pp,len(pp)-1)
	getpricelist=pp

end function
'''''''''''''''''''''''''''''
'参数:recordset,每页条数,其它参数(跟在pageNo后),返回总页数,返回总条数
'函数返回值为显示的操作按钮
'zxw 08-3-11
function GetPageClass(myrs,pageSizes,othercode,byref pageCounts,byref sUsers)
		 pageNo=request("pageNo")
		 if not isNumeric(pageNo) then pageNo=1
		 if pageNo<1 then PageNo=1
		 myrs.pageSize=pageSizes
		 if pageSizes>0 then myrs.CacheSize=pageSizes '记录缓存
		 pageCounts=myrs.pageCount
		 sUsers=myrs.RecordCount
		 if clng(pageNo)>clng(pageCounts) then pageNo=pageCounts
		 if not myrs.eof then myrs.AbsolutePage=pageNo
		 forstr1=clng(pageNo)-5
		 forstr2=clng(pageNo)+5
		 if forstr1<1 then forstr1=1
		 if forstr2>pageCounts then forstr2=pageCounts
		 pagestr=""

		 for ii=forstr1 to forstr2
		 	if clng(ii)<>clng(pageNo) then
				pagestr=pagestr & "<a href='"&request("script_name")&"?pageNo="& ii & othercode &"' class=""z_next_page"">"& ii & "</a> "
			else
				pagestr=pagestr &"<b><a href=""javascript:void(0)"" class=""z_this_page"">"& ii &"</a></b> "
			end if
		 next

		 if forstr1>1 then lookother1="<a href='"&request("script_name")&"?pageNo="& (forstr1-(1+5)) & othercode &"'><b>...</b></a> "
		 if forstr2<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+5)) & othercode &"'><b>...</b></a> "
		 
		 netstring="<a href='"& request("script_name") &"?pageNo=1"& othercode &"'  class=""z_next_page"">首页</a>&#160;"
    	 netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& (clng(pageNo)-1) & othercode &"'  class=""z_next_page"">上一页</a>&#160;"
    	netstring=netstring & lookother1 & pagestr & lookother2 & "&#160;"
   		netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& (clng(pageNo)+1) & othercode &"'  class=""z_next_page"">下一页</a>&#160;"
    	netstring=netstring & "<a href='"& request("script_name") &"?pageNo="& pageCounts & othercode &"'  class=""z_next_page"">尾页</a>"
		netstring=netstring & "&#160;每页:"& pageSizes & "条&nbsp;&nbsp;&nbsp;"
		netstring=netstring & "&#160;总页数:"& pageCounts & "页&nbsp;&nbsp;&nbsp;"
		netstring=netstring & "&#160;总条数:"& sUsers & "条&nbsp;&nbsp;&nbsp;"
		netstring=netstring & "&#160;第&nbsp;<input id=""netpagetonum"" type=text size=3 value="""& pageNo &""">&nbsp;页<input type=button value='跳转' onclick=""javascript:location.href='"& request("script_name") &"?pageNo=' + document.getElementById('netpagetonum').value + '"& othercode &"';"" class=""mf-page-btn"">"
		GetPageClass=netstring
end function
'计算产品一年的价格
'参数:产品id
'zxw 08-4-17
function tpl_function(v)
	tpl_sql="select p_price from productlist where p_proId='"& trim(v) &"'"
	set tpl_rs=conn.execute(tpl_sql)
	if not tpl_rs.eof then
		tpl_function=GetNeedPrice(session("user_name"),trim(v),1,"new")
	else
	tpl_function="--"	
	end if
	tpl_rs.close
	set tpl_rs=nothing
end function
'产品名称
'参数:产品id
'zxw 08-4-17
function tpl_function_name(v)
	tpl_sql="select p_name from productlist where p_proId='"& trim(v) &"'"

	set tpl_rs=conn.execute(tpl_sql)
	if not tpl_rs.eof then
		tpl_function_name=tpl_rs(0)
	else
		tpl_function_name="--"	
	end if
	tpl_rs.close
	set tpl_rs=nothing
end function
'产品内存
'参数:产品id
'zxw 08-4-17
function tpl_function_mem(v)
	tpl_sql="select p_maxmen from productlist where p_proId='"& trim(v) &"'"
 
	set tpl_rs=conn.execute(tpl_sql)
	if not tpl_rs.eof then
		tpl_function_mem=tpl_rs(0)
	else
		tpl_function_mem="--"	
	end if
	tpl_rs.close
	 
  
	set tpl_rs=nothing
end function
'产品硬盘
'参数:产品id
'zxw 08-4-17
function tpl_function_hd(v)
	tpl_sql="select p_size from productlist where p_proId='"& trim(v) &"'"
	set tpl_rs=conn.execute(tpl_sql)
	if not tpl_rs.eof then
		tpl_function_hd=tpl_rs(0)
	else
		tpl_function_hd="--"	
	end if
	tpl_rs.close
	set tpl_rs=nothing
end function
function tpl_function_size(byval v)
	result=tpl_function_hd(v)
	if result<>"" and isnumeric(result) then
		if cdbl(result)>=1000 then
		    select case cdbl(result)
			case 1000
			result="1G"
			case 2000
			result="2G"
			case 3000
			result="3G"
			case 4000
			result="4G"
			case 5000
			result="5G"
			case 6000
			result="6G"
			case 7000
			result="7G"
			case 8000
			result="8G"
			case 9000
			result="9G"
			case 10000
			result="10G"
			case 11000
			result="1G"
			case 12000
			result="12G"
			case 13000
			result="13G"
			case 14000
			result="14G"
			case 15000
			result="15G"
			case 16000
			result="16G"
			case else			
			result=round(cdbl(result) / 1024,1) & "G"
			end select
		else
			result=result & "M"
		end if
	end if
	tpl_function_size=result
end function
''产品机房以及价格
''参数:产品id
''zxw 08-4-17
'function tpl_function_RoomPrice(v)
'	tpl_sql="select p_size from productlist where p_proId='"& trim(v) &"'"
'	set tpl_rs=conn.execute(tpl_sql)
'	if not tpl_rs.eof then
'		tpl_function_RoomPrice=tpl_rs(0)
'	else
'		tpl_function_RoomPrice="--"	
'	end if
'	tpl_rs.close
'	set tpl_rs=nothing
'end function

function toerrStr(byval errstr)
	toerrStr="<div style=""border:ccff99 solid 1px; background:#ffffcc""><img src=""/Template/Tpl_01/images/new/stop_zxw.gif"" border=0>"& errstr &"</div>"
end function
function torightStr(byVal rightstr)
	torightStr="<div style=""border:efefef solid 1px; background:#ffffff""><img src=""/Template/Tpl_01/images/new/ok_zxw.gif"" border=0><font color=""#336600"">"& rightstr &"</font></div>"
end function
ObjInstalled_FSO = IsObjInstalled(objName_FSO)

set fso=server.CreateObject(objName_FSO)

'2009-4-3
'朱小维
'根据产品型号操作方式来取得所需要的价格
' 用户名,产品id,购买年限,购买方式new或renew
'2013 8-26 是否为空间
function GetNeedPrice(byval u_name,byval Proid,byval buyyear,byval buytype)
		u_level=1
		u_id=0
		needPrice=0
		firstPrice=0
		ishost=false
		'2013 8-29 虚拟主机购/续多年送时间活动(是否为空间 )
		set h_rs=conn.execute("select count(p_id) from productlist where P_proId='"&Proid&"' and p_type=1")
		if clng(h_rs(0))>0 then

        ishost=true
		end if
		if Proid="" or buyyear="" or buytype="" then exit function
		if not isnumeric(buyyear) or buyyear<=0 then buyyear=1
		u_name=trim(u_name)&""
		usersql="select u_id,u_level from userdetail where u_name<>'' and u_name='"& u_name &"'"
		set urs=conn.execute(usersql)
		if not urs.eof then
			u_id=urs("u_id")
			u_level=urs("u_level")
		end if
		urs.close
		set urs=nothing
		if isnumeric(buyyear) then buyyear=ccur(buyyear)
			select case buytype
				case "new"
						If isdbsql Then
							set prs=conn.execute("select isnull(proPrice,0) from UserPrice where u_id<>0 and proid='"& Proid &"' and u_id="& u_id)
						else
							set prs=conn.execute("select iif(isnull(proPrice),0,proPrice) from UserPrice where u_id<>0 and proid='"& Proid &"' and u_id="& u_id)
						End if
						if not prs.eof then
							firstPrice=ccur(prs(0))
						end if
					
						prs.close
						set prs=nothing
						if firstPrice<=0 Then
						     If isdbsql Then
								 set prs0=conn.execute("select top 1 isnull(p_firstPrice,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							 else
								 set prs0=conn.execute("select top 1 iif(isnull(p_firstPrice),0,p_firstPrice) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							 End if
							  if not prs0.eof then
									firstPrice=ccur(prs0(0))
							  end if
							  prs0.close
							  set prs0=nothing
						end if
					
					
					  if buyyear>1 or (firstPrice=0 and buyyear=1) then
						if firstPrice>0 then buyyear=buyyear-1
						
						if not ishost then
					 
								If isdbsql Then
									set prs=conn.execute("select isnull(newPrice,0) from RegisterDomainPrice where  User_name<>'' and User_name='"& u_name &"' and ProId='"& proid &"' and NeedYear>1 and NeedYear="& buyyear)
								else
									set prs=conn.execute("select iif(isnull(newPrice),0,newPrice) from RegisterDomainPrice where  User_name<>'' and User_name='"& u_name &"' and ProId='"& proid &"' and NeedYear>1 and NeedYear="& buyyear)
							    End if

								 if not prs.eof then
									price=ccur(prs(0))
									if price>0 then
										needPrice=firstPrice + price
									end if
								 end if
								'  die buyyear&"||"&ishost&"||"&needPrice
								 prs.close
								 set prs=nothing
								 if needPrice<=0 Then
									 If isdbsql Then
										set prs0=conn.execute("select top 1 isnull(newPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and NeedYear>1 and ProId='"& ProId &"'")
									 else
										set prs0=conn.execute("select top 1 iif(isnull(newPrice),0,newPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and NeedYear>1 and ProId='"& ProId &"'")
									 End if
									if not prs0.eof then
										price=ccur(prs0(0))
										if price>0 then
											needPrice=firstPrice + price
										end if
									end if
									prs0.close
									set prs0=nothing
								 end if
						end if

						
						 if needPrice=0 Then
							If isdbsql Then
								set prs1=conn.execute("select top 1 isnull(p_price,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							else
								set prs1=conn.execute("select top 1 iif(isnull(p_price),0,p_price) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							End if
							if not prs1.eof then
								price=ccur(prs1(0))
								if price>0 then
									needPrice=firstPrice + price * buyyear
								end if
							end if
							 
								prs1.close
							set prs1=nothing
							if needPrice<=0 Then
								If isdbsql Then
									set prs0=conn.execute("select isnull(p_price,0) from productlist where p_proId='"& proid &"'")
								else
									set prs0=conn.execute("select iif(isnull(p_price),0,p_price) from productlist where p_proId='"& proid &"'")
								End if
								if not prs0.eof then
									price=ccur(prs0(0))
									if price>0 then
										needPrice=firstPrice + price * buyyear
									end if
								else
									Response.write "500 没有这种类型的产品["&proid&"]"
									Response.end
								end if
								prs0.close
								set prs0=nothing
							end if
						end if
		  
					 else
					 	needPrice=firstPrice
					 end if
					case "renew"
						If isdbsql Then
							set prs=conn.execute("select top 1 isnull(p_firstPrice_renew,0),isnull(p_wfirstPrice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
						else
							set prs=conn.execute("select top 1 iif(isnull(p_firstPrice_renew),0,p_firstPrice_renew),iif(isnull(p_wfirstPrice_renew),0,p_wfirstPrice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
						End if
					  if not prs.eof then
							firstPrice=ccur(prs(0))
							if (left(lcase(domainRegister),4)="west" or left(lcase(domainRegister),5)="rclub") and prs(1)>0 then
							firstPrice=ccur(prs(1))
							end if
					  end if
					  prs.close
					  set prs=nothing
					  if buyyear>1 or (firstPrice=0 and buyyear=1) then
							if firstPrice>0 then buyyear=buyyear-1

							If isdbsql Then
								set prs=conn.execute("select isnull(RenewPrice,0),isnull(wRenewPrice,0) from RegisterDomainPrice where User_name<>'' and User_name='"& u_name &"' and ProId='"& proid &"' and NeedYear>1 and NeedYear="& buyyear)
							else
								set prs=conn.execute("select iif(isnull(RenewPrice),0,RenewPrice),iif(isnull(wRenewPrice),0,wRenewPrice) from RegisterDomainPrice where User_name<>'' and User_name='"& u_name &"' and ProId='"& proid &"' and NeedYear>1 and NeedYear="& buyyear)
							End if
							if not prs.eof then
								price=ccur(prs(0))
								if (left(lcase(domainRegister),4)="west" or left(lcase(domainRegister),5)="rclub")  and prs(1)>0 then
								price=ccur(prs(1))
								end if
								if price>0 then
									needPrice=firstPrice + price
								end if								
							end if
							prs.close
							set prs=nothing
							if not ishost then
									if needPrice<=0 Then
										If isdbsql Then
											set prs0=conn.execute("select top 1 isnull(RenewPrice,0),isnull(wRenewPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and NeedYear>1 and ProId='"& proid &"'")
										else
											set prs0=conn.execute("select top 1 iif(isnull(RenewPrice),0,RenewPrice),iif(isnull(wRenewPrice),0,wRenewPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and NeedYear>1 and ProId='"& proid &"'")
										End if
										if not prs0.eof then
											price=ccur(prs0(0))
											if (left(lcase(domainRegister),4)="west" or left(lcase(domainRegister),5)="rclub")  and prs0(1)>0 then
											price=ccur(prs0(1))
											end if
											if price>0 then
												needPrice=firstPrice + price
											end if
										end if
										prs0.close
										set prs0=nothing
									end if
							end if
							if needPrice=0 Then
								If isdbsql Then
									set prs1=conn.execute("select top 1 isnull(p_price_renew,0),isnull(p_wprice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
								else
									set prs1=conn.execute("select top 1 iif(isnull(p_price_renew),0,p_price_renew),iif(isnull(p_wprice_renew),0,p_wprice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
								End if
								if not prs1.eof then
									price=ccur(prs1(0))
									if (left(lcase(domainRegister),4)="west" or left(lcase(domainRegister),5)="rclub")  and prs1(1)>0 then
									price=ccur(prs1(1))
									end if
									if price>0 then
										needPrice=firstPrice + price * buyyear
									end if
								end if
								prs1.close
								set prs1=nothing
								if needPrice<=0 Then
								    If  isdbsql Then
										set prs1=conn.execute("select top 1 isnull(p_price,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
									else
										set prs1=conn.execute("select top 1 iif(isnull(p_price),0,p_price) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
									End if
									if not prs1.eof then
										price=ccur(prs1(0))
										if price>0 then
											needPrice=firstPrice + price * buyyear
										end if
									end if
									prs1.close
									set prs1=nothing
									if needPrice<=0 Then
										If  isdbsql Then
												set prs0=conn.execute("select isnull(p_price,0) from productlist where p_proId='"& proid &"'")
										else
											set prs0=conn.execute("select iif(isnull(p_price),0,p_price) from productlist where p_proId='"& proid &"'")
										End if
										if not prs0.eof then
											price=ccur(prs0(0))
											if price>0 then
												needPrice=firstPrice + price * buyyear
											end if
										else
											Response.write "500 没有这种类型的产品"
											Response.end
										end if
										prs0.close
										set prs0=nothing
									end if
								end if
							end if
					  else
					 	needPrice=firstPrice
					  end if
		   end select
		   
		   needPrice=round2(needPrice)
		   GetNeedPrice=FormatNumber(needPrice,0,,,0)
end function
'2009-1-8
'朱小维
'得到用户cn域名一年续费的价格
function getRenewCnPrice(byval DomainStr,byval BuyYears)
	getRenewCnPrice=""
	if trim(DomainStr)="" or instr(DomainStr,".")=0 then  exit function
	ProductID=GetDomainType(DomainStr)
	if trim(lcase(ProductID))<>"domcn" or BuyYears>1 then exit function
	xmlpath=server.MapPath("/database/data.xml")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobjNode = isNodes("pageset","renewCnPrice",xmlpath,true,objDoms)
		startDate="":endDate="":exitDate="":setPrice="":cnrenewlevel="":isopen="0"
		set isopenobj=myobjNode.Attributes.getNamedItem("isopen")
		if not isopenobj is nothing then isopen=isopenobj.nodeValue
		if isopen="1" then
			set startDateobj=myobjNode.Attributes.getNamedItem("startDate")
			set endDateobj=myobjNode.Attributes.getNamedItem("endDate")
			set exitDateobj=myobjNode.Attributes.getNamedItem("exitDate")
			set setPriceobj=myobjNode.Attributes.getNamedItem("setPrice")
			set cnrenewlevelobj=myobjNode.Attributes.getNamedItem("cnrenewlevel")
			
			if not startDateobj is nothing then startDate=startDateobj.nodeValue
			if not endDateobj is nothing then endDate=endDateobj.nodeValue
			if not exitDateobj is nothing then exitDate=exitDateobj.nodeValue
			if not setPriceobj is nothing then setPrice=setPriceobj.nodeValue
			if not cnrenewlevelobj is nothing then cnrenewlevel=cnrenewlevelobj.nodeValue
			if isDate(startDate) and isDate(endDate) and isDate(exitDate) and isnumeric(setPrice) and setPrice>0 then
			  levelsql=" and exists (select u_name from userdetail where u_id=domainlist.userid and u_level="& cnrenewlevel &")"	
			  if trim(cnrenewlevel)&""="" then levelsql=""
			  sqlrenew="select top 1 * from domainlist where dateDiff("&PE_DatePart_D&",regdate,'"& startDate &"')<=0 and dateDiff("&PE_DatePart_D&",regdate,'"& endDate &"')>=0 and dateDiff("&PE_DatePart_D&",dateDiff("&PE_DatePart_Y&",years,regdate),'"& exitDate &"')>=0 and strDomain='"& DomainStr &"'" & levelsql		
			  
			  set cnRs=conn.execute(sqlrenew)	
			  if not cnRs.eof then
			  	getRenewCnPrice=setPrice
			  end if
			  cnRs.close
			  set cnRs=nothing
			end if
		end if
	set myobjNode=nothing
	set objDoms=nothing
end function

'2007-7-26
'edwardyang
'判断用户余额是否足够，不够返回false
'                     用户名,产品id,购买年限,购买方式new或renew,UseCoupons 是否使用优惠券
function CheckEnoughMoney(CustomerName,ProductID,BuyYears,BuyType,UseCoupons)
	CheckEnoughMoney=false
	
	set u_rs=server.CreateObject("adodb.recordset")
	u_sql="select u_usemoney,u_premoney from UserDetail where u_name='"&CustomerName&"'"
	u_rs.open u_sql,conn,1,3
	if u_rs.eof or u_rs.bof then
		CheckEnoughMoney=false
		exit function
	else
		u_usemoney=u_rs("u_usemoney")
		u_premoney=u_rs("u_premoney")
	end if
	u_rs.close
	set u_rs=nothing
	
	NeedMoney=GetNeedPrice(CustomerName,ProductID,BuyYears,BuyType)
	
	if UseCoupons then
		u_usemoney=u_usemoney+u_premoney
	end if

	if ccur(u_usemoney)<ccur(NeedMoney) then
		CheckEnoughMoney=false
	else
		CheckEnoughMoney=true
	end if
end function

 

'登陆时需要放入的session值,因为多处调用方便修改
'zxw 08-4-21
sub setuserSession(byval u_name)
	sqluser="select * from userdetail where  u_name='"& trim(u_name) &"'"
	cclose=false
	if conn.state=0 then 
		cclose=true
		conn.open constr
	end if
	set userRs=conn.execute(sqluser)
	 if not userRs.eof Then
		'通用模板缓存取消
		session("mylb_lbload")=""
		session("mylb_islbbody")=""
		session("mb_getcfg_history")=""
		'通用模板缓存取消 over
		session("u_sysid")=userRs("u_id")
		session("user_name")=userRs("u_name")
		session("u_levelid")=userRs("u_level")
		session("u_level")=userRs("U_levelName")
		session("u_remcount")=userRs("u_remcount")
		session("u_borrormax")=userRs("u_borrormax")
		session("u_resumesum")=FormatNumber(userRs("u_resumesum"),-1,-1)
		session("u_checkmoney")=FormatNumber(userRs("u_checkmoney"),-1,-1)
		session("u_usemoney")=FormatNumber(userRs("u_usemoney"),-1,-1)
		session("u_premoney")=FormatNumber(userRs("u_premoney"),-1,-1)
		session("u_operator")=userRs("u_operator")
		session("u_type")=userRs("u_type")
		session("u_email")=userRs("u_email")
		session("u_contract")=userRs("u_contract")
		session("u_address")=userRs("u_address")
		session("msn")=userRs("msn_msg")
		session("qq_openid")=userRs("qq_openid")
		session("result")=""
		Session("Rver")=getRemoteVer()
		safecode=md5_16(webmanagesrepwd&getUserIP())
		Session("safecode")=safecode
		isauthmobile=userRs("isauthmobile")
		if trim(session("priusername"))<>"" then isauthmobile=1
		if instr(lcase(api_url)&"","api.west263.com")=0 then isauthmobile=1
		if not issetauthmobile then isauthmobile=1
		Session("isauthmobile")=isauthmobile

		
		Call SetHttpOnlyCookie("user_name",session("user_name"),"","/",0)
		newpassword=session("user_name")&webmanagesrepwd&userRs("u_password")&getUserIP()
		Call SetHttpOnlyCookie("user_pwd",md5_16(newpassword),"","/",0)
		Call SetHttpOnlyCookie("safecode",Session("safecode"),"","/",0)

'		Response.Cookies("user_name")=session("user_name")
'		newpassword=session("user_name")&webmanagesrepwd&userRs("u_password")&getUserIP()
'		'Response.Cookies("user_pwd")=userRs("u_password")
'		Response.Cookies("user_pwd")=md5_16(newpassword) 'userRs("u_password")
'		Response.Cookies("safecode")=Session("safecode")
		
		conn.execute("update userdetail set LostLogTime='"&now()&"' where u_name='"& trim(u_name) &"'")
	 end if
	 userRs.close
	 set userRs=nothing

	 if cclose and conn.state=1 then conn.close

end sub
Function getstrReturn(funstrReturn,partname)
	funstrReturn=lcase(funstrReturn)
    partname = lcase(partname) & ":"

	if not instr(vbcrlf & funstrReturn,vbcrlf & partname)>0 then
		getstrReturn="********"
	else

		tmpstr =mid(funstrReturn,instr(vbcrlf &funstrReturn,vbcrlf &partname))
		tmpstr =mid(tmpstr,len(partname)+1, instr(tmpstr, chr(13)) - len(partname))
		tmpstr =Replace(tmpstr, chr(13),"")
		getstrReturn = Replace(tmpstr, vbCrLf  ,"")
	end if
End Function
'功能:得到页面的传递值
'参数:post,get,all
'zxw 08-04-21
function getRequestStr(byval types)
	questStr=""
	if types="post" or types="all" then
		for str_i = 1 to Request.form.count
				formkey=trim(Request.form.key(str_i))
				formvalue=trim(Request.form(str_i))
				if formvalue<>"" then
					questStr=questStr & formkey & "=" & formvalue & "&"
				end if
		next
	end if
	if types="get" or types="all" then
		for get_i=1 to  request.queryString.count
			getKey=trim(Request.querystring.key(get_i))
			getvalue=trim(Request.QueryString(get_i))
			if getvalue<>"" then
				questStr=questStr & getKey & "=" & getvalue & "&"
			end if
		next
	end if
	if right(questStr,1)="&" then questStr=left(questStr,len(questStr)-1)
	getRequestStr=trim(delRepeatStr(questStr,"&"))
end function
'功能:当需要session时返回登陆页,登陆成功后返回操作
'zxw 08-4-21
sub needregSession()
	if session("u_sysid")="" or isnull(session("u_sysid")) or isEmpty(session("u_sysid")) then
		if not check_is_cookie then
			pageStr=request.ServerVariables("SCRIPT_NAME")
			session("w_from")=getRequestStr("all")
			response.write "<script language=javascript>location.href='/login.asp?pageStr="& pageStr &"';</script>"
			response.end
		end if
	else
		session("w_from")=""
		set moneyconn=server.CreateObject("adodb.connection")
		moneyconn.open constr
		set moneyRs=moneyconn.execute("select u_usemoney,u_resumesum from userdetail where u_id=" & session("u_sysid"))
		if not moneyRs.eof then
			session("u_usemoney")=FormatNumber(moneyRs("u_usemoney"),-1,-1)
			session("u_resumesum")=FormatNumber(moneyRs("u_resumesum"),-1,-1)
		end if
		moneyRs.close
		set moneyRs=nothing
		moneyconn.close
		set moneyconn=nothing
	end if
end sub
'返回搜索到的字符串
'参数:字符串,正则
'zxw 08-04-21
function myinstr(byval mystring, byval regstr)
			itm1=""
			set m_RegExp1 = New RegExp	
			m_RegExp1.Pattern=regstr
			set regExplist1=m_RegExp1.execute(mystring)
			for each vv1 in regExplist1
				itm1=vv1.subMatches(0)
			next
			set m_RegExp1=nothing
			myinstr=itm1
end function
'得到xml文件节点
'不存在节点就创建
'zxw 08-04-21
function isNodes(rootNodes,nodesname,xmlpath,getRoot,byref objDoms)'判断节点存不存在,不存在就创建(父节点,子节点,xml文件位置,true/false是否得到子对像,返回的对像),并得到父节点对像
		p="n"
		objDoms.async = false
		objDoms.load(xmlpath)
		if objDoms.ParseError.ErrorCode = 0 then
			 Set objroot = objDoms.documentElement
			 set myrootnodes=objDoms.selectSingleNode("//"& rootNodes)
			 if myrootnodes is nothing then
			 	set rootelement= objDoms.createelement(rootNodes)
				objroot.appendChild rootelement
				set myrootnodes=rootelement
				p="y"
			 end if
			  if trim(nodesname)<>"" then 
			 	  set mynodes=myrootnodes.selectSingleNode(trim(nodesname))
				  if mynodes is Nothing  then 
					'节点不存在就建
					set mynodes= objDoms.createelement(trim(nodesname))
					myrootnodes.appendChild mynodes
					p="y"
				  end if 
				  if getRoot then
					set isNodes=mynodes
					
				  else
					set isNodes=myrootnodes
				  end if
			  else
			  	set isNodes=myrootnodes
			  end if
			  if p="y" then
			  	objDoms.save(xmlpath)
			  end if
	  else
	 	Response.Write objDoms.ParseError.Reason
	  end if

end function
function check_is_master(this_level)

  if(session("u_type")="" or IsNull(session("u_type"))) then
  	if not check_is_cookie then
		Alert_Redirect "对不起，您还没有登陆或者闲置时间太久了，请重新登陆！","/default.asp"
	end if
  end if
  
  if(mid(session("u_type"),this_level,1)<>"1") then
     response.Redirect "/error.asp?errstr=没有权限!"
     response.end
  end if

 
  if trim(webmanagespwd)="" then
    r_url=""&SystemAdminPath&"/in_check.asp"
	  response.Redirect r_url
	  response.end
  end if
  if trim(session("pss"))="" then
  	  secpass=trim(sqlincode(request.Cookies("secpass")))
	  if trim(secpass)="" or trim(webmanagespwd&year(now())&month(now()))<>trim(secpass) then
		  r_url=""&SystemAdminPath&"/check.asp"
		  response.Redirect r_url
		  response.end
	  else
	  session("pss")=1111
	  end if
  end if
end function
function check_is_cookie()
	check_is_cookie=false
	c_user_name=trim(sqlincode(request.Cookies("user_name")))
	c_user_pwd=trim(sqlincode(request.Cookies("user_pwd")))
	if len(c_user_name)>0 and len(c_user_pwd)>0 then
			ccclose=false
			if conn.state=0 then
				ccclose=true
				conn.open constr
			end if
			set c_Rs=conn.execute("select top 1 u_name,u_password from UserDetail where u_name='"& c_user_name &"'")
			if not c_Rs.eof then
				newpassword=c_rs("u_name")&webmanagesrepwd&c_rs("u_password")&getUserIP()
			    if trim(c_user_pwd)=trim(md5_16(newpassword)) then
					check_is_cookie=true
					call setuserSession(c_user_name)
				end if
			end if
			c_Rs.close
			set c_Rs=nothing
			if ccclose and conn.state=1 then conn.close

	end if
end function
function check_as_master(this_level)
  if(session("u_type")="" or IsNull(session("u_type"))) then
  	if not check_is_cookie then
     check_as_master = false
     exit function
	end if
  end if
  if(mid(session("u_type"),this_level,1)<>"1") then
     check_as_master = false
  else
     check_as_master = true
  end if
end function

'sjwxl
'通用扣款程序
'uname 会员名
'lPrice 扣款金额
'isChit 是否使用优惠券
'CountID 凭证号
'memo 备注
'Proid 产品ID
'OrderID 订单号
'2013添加用户扣款后余额显示
function consume(ByVal uname,ByVal lPrice,ByVal isChit,ByVal CountID,ByVal Memo,ByVal Proid,ByVal OrderID)

	consume=false
	Set myrs=conn.Execute("select u_id,u_usemoney,u_premoney from userdetail where u_name='" & uname & "'")
	
	if myrs.eof then
		exit function
	end if
	u_usemoney=Ccur(myrs("u_usemoney"))
	u_premoney=Ccur(myrs("u_premoney"))
	lPrice=ccur(lPrice)
	u_id=myrs("u_id")
	u_Balance=u_usemoney
	myrs.close:set myrs=nothing

	if OrderID="" then
		OrderID="0"
	end if
	

	if not isChit or u_premoney=0 then

		if u_usemoney<lPrice then
			exit function
		end if
		u_premoney=0

	else
		if u_usemoney+u_premoney < lPrice then
			exit function
		end if
		
		if u_premoney>=lPrice then
			u_premoney=lPrice
			lPrice=0
		else
			lPrice=lPrice-u_premoney
		end if

		Memo=Memo & ",优惠券消费:" & u_premoney
	end If
	u_Balance=u_Balance-lPrice

	conn.Execute("update userdetail set u_usemoney=u_usemoney-(" & lPrice & "),u_resumesum=u_resumesum+(" & lPrice & "),u_accumulate=u_accumulate+1,u_remcount=u_remcount-(" & lPrice & "),u_premoney=u_premoney-(" & u_premoney & ") where u_name='" & uname & "'")
	conn.Execute("insert into countlist (u_id,u_moneysum,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck ,c_type,o_id,p_proid,u_Balance) values (" & u_id & "," & lPrice +u_premoney & "," & lPrice+u_premoney & ",'" & CountID & "','" & memo & "',"&PE_False&","&PE_Now&","&PE_Now&","&PE_Now&",1," & orderId & ",'" & proid & "',"&u_Balance&")")
	consume=true	
end function

function IsLinuxServer(BeCheckIPStr)
	IsLinuxServer=true
end function
'设置siteMap
'参数:间隔符
'没有的页面在/database/siteMap.xml添加
'zxw 08-4-22
function siteMappath(byval invl)
	if trim(invl)&""="" then invl=">"
	theFilePath=replace(request.ServerVariables("SCRIPT_NAME"),"\","/")
	
	if left(theFilePath,1)="/" then theFilePath=right(theFilePath,len(theFilePath)-1)
	selectStr="//siteMapNode[@url='"& lcase(theFilePath) &"']"
	  if theFilePath <>"" then

		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		nodesname="xsl:variable"
		siteMapStr=""
		set myobjNode=isNodes(nodesname,"",strXSLFile,false,objDoms)
		xslName=myobjNode.Attributes.getNamedItem("name").nodeValue
		if xslName="MyNodes" then
				myobjNode.setAttribute "select",selectStr
				objDoms.save(strXSLFile)
		end if
		set myobjNode=nothing	
	  end if
	set objDoms=nothing
	siteMappath=loadXmlStr(invl)
end function
Function loadXMLFile() 

	set objXML = Server.CreateObject("Microsoft.XMLDOM") 
	 objXML.async = false 
	objXML.load(strXMLFile) 
	set objXSL = Server.CreateObject("Microsoft.XMLDOM") 
	objXSL.async = false 
	objXSL.load(strXSLFile) 
	loadXMLFile=objXML.transformNode(objXSL)
	set objXSL=nothing
 	set objXML =nothing
End Function 
function loadXmlStr(byval invl)
	loadXmlStr=""
	xmlStr="<?xml version=""1.0"" encoding=""gb2312""?>" & loadXMLFile()
		set objXML = Server.CreateObject("Microsoft.XMLDOM") 
		objXML.async = false 
		objXML.loadXML(xmlStr)
		if objXML.ParseError.ErrorCode = 0 then
			Set objroot = objXML.documentElement
			mapstr=""
			call blchilde(objroot,mapstr,invl)
			if right(mapstr,len(invl))=invl then mapstr=left(mapstr,len(mapstr)-len(invl))
			loadXmlStr=mapstr
		end if
	set objXml=nothing
end function
function blchilde(byval objroots,byref mapstr,byval invl)
	if isobject(objroots) then
		for each objitem in objroots.childNodes
			itemurl=objitem.Attributes.getNamedItem("url").nodeValue
			itemtitle=objitem.Attributes.getNamedItem("title").nodeValue
			itemdescription=objitem.Attributes.getNamedItem("description").nodeValue
			mapstr=mapstr & "<a href='/"& itemurl &"' title='"& itemdescription &"'>"& itemtitle & "</a>" & invl
			call blchilde(objitem,mapstr,invl)
		next
	else
		exit function
	end if
end function
'取得一个随机函数
'edwardyang
'2007-12-12
'LengthNum 数字，要生成字符串的长度
Function CreateRandomKey(LengthNum) 
	dim char_array(50) 
	char_array(0) = "1" 
	char_array(1) = "1" 
	char_array(2) = "2" 
	char_array(3) = "3" 
	char_array(4) = "4" 
	char_array(5) = "5" 
	char_array(6) = "6" 
	char_array(7) = "7" 
	char_array(8) = "8" 
	char_array(9) = "9" 
	char_array(10) = "A" 
	char_array(11) = "B" 
	char_array(12) = "C" 
	char_array(13) = "D" 
	char_array(14) = "E" 
	char_array(15) = "F" 
	char_array(16) = "G" 
	char_array(17) = "H" 
	char_array(18) = "I" 
	char_array(19) = "J" 
	char_array(20) = "K" 
	char_array(21) = "L" 
	char_array(22) = "M" 
	char_array(23) = "N" 
	char_array(24) = "P" 
	char_array(25) = "P" 
	char_array(26) = "Q" 
	char_array(27) = "R" 
	char_array(28) = "S" 
	char_array(29) = "T" 
	char_array(30) = "U" 
	char_array(31) = "V" 
	char_array(32) = "W" 
	char_array(33) = "X" 
	char_array(34) = "Y" 
	char_array(35) = "Z" 
	
	randomize 
	do while len(output) < LengthNum 
	num = char_array(Int((35 - 0 + 1) * Rnd + 0)) 
	output = output + num 
	loop 
	
	CreateRandomKey = lcase(output) 
End Function
'查看是否在购物车中存在
'参数:产品名称,类型
'zxw 08-4-23
function isInbagshow(byref productName,byref productType)
	isInbagshow=false
	csql=""
	
	if productName="" then exit function
    if productType="host" then
		csql="select count(*) from shopcart where  ywType='vhost' and ywName='"&productName&"'"
	elseif productType="domain" then
		csql="select count(*) from shopcart where  ywType='domain' and ywName='"&productName&"'"
	elseif productType="mail" then
		csql="select count(*) from shopcart where  ywType='mail' and ywName='"&productName&"'"
    elseif productType="database" then
		csql="select count(*) from shopcart where   ywType='mssql' and ywName='"&productName&"'"
	end if
'die productName&"|||"&productType&"||"&csql
	if csql="" then exit function
  
	set chkcrs=conn.execute(csql)
	if clng(chkcrs(0))>0 then
		isInbagshow=true
	end if
	chkcrs.close:set chkcrs=nothing
end function

Function URLEncode(vstrIn) 

    strReturn = "" 
    For i = 1 To Len(vstrIn) 
        ThisChr = Mid(vStrIn,i,1) 
		' 	Response.write(ThisChr&"<hr>")
		ascii=Asc(ThisChr)
			ascii=Asc(ThisChr)
	
        If Abs(ascii)< &HFF Then 
				if (ascii>47 and ascii<58) or ( ascii>64 and ascii<91 ) or (ascii>96 and ascii <123) then
					theChar=chr(ascii)
				elseif ascii=32 then
					theChar= "+"
				else
					If ascii < 16 Then
						theChar=  "%0" & Hex(ascii)
					Else
						theChar=  "%" & Hex(ascii)
					End If			
				end if 
				strReturn = strReturn & theChar
        Else 
            If ascii < 0 Then 
                ascii = ascii + &H10000 
            End If 
            Hight8 = (ascii  And &HFF00)\ &HFF 
            Low8 = ascii And &HFF 
            strReturn = strReturn & "%" & Hex(Hight8) &  "%" & Hex(Low8) 
        End If 
    Next 
    URLEncode = strReturn 
End Function 

Function OpenRemoteUrl(ByVal strURL,ByVal strParam)
    if trim(strParam)="" then
		strParam="?version="&version
	else
		strParam=strParam&"&version="&version
	end if
	Set objxml=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	objxml.SetTimeOuts 500000, 500000, 500000, 1000000
	objxml.open "POST",strURL,false
	objxml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	objxml.send(strParam)
	if objxml.status=200 then
		OpenRemoteUrl=bstr(objxml.ResponseBody)
	else
		'OpenRemoteUrl=bstr(objxml.ResponseBody) '当调试的时候，可启用该行
		OpenRemoteUrl="599 API连接打开失败" & objxml.responseText
	end if
	Set objxml=nothing
end function
Function GetRemoteUrl(ByVal strURL)
	Set objxml=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	objxml.open "GET",strURL,false
	objxml.send()

	if objxml.status=200 then
		GetRemoteUrl=bstr(objxml.ResponseBody)
	else
		GetRemoteUrl=""
	end if
	Set objxml=nothing
end function

function decodehtml(fString)
if fString<>"" and not isnull(fstring) then
	fString = replace(fString, ">", ">")
	fString = replace(fString, "<", "<")
	fString = Replace(fString, "&#160;", chr(32))
	fString = Replace(fString, "<P>", CHR(10))
	fString = Replace(fString, "<BR>", CHR(10))
	decodehtml=fString
else
	decodehtml=""
end if
end function
function GetsRoot(ByVal whichDomain)
	whichDomain=Lcase(whichDomain)
	Exts=".bj.cn,.sh.cn,.tj.cn,.cq.cn,.he.cn,.sx.cn,.nm.cn,.ln.cn,.jl.cn,.hl.cn,.js.cn,.zj.cn,.ah.cn," & _
	".fj.cn,.jx.cn,.sd.cn,.ha.cn,.hb.cn,.hn.cn,.gd.cn,.gx.cn,.hi.cn,.sc.cn,.gz.cn,.yn.cn,.xz.cn,.sn.cn," & _
	".gs.cn,.qh.cn,.nx.cn,.xj.cn,.tw.cn,.hk.cn,.mo.cn,.vc,.org.uk," & _
	".sh,.net.au,.mobi,.ac.cn,.com.cn,.net.cn,.org.cn,.gov.cn,.edu.cn,.com,"& _
	".net,.org,.biz,.cn,.info,.tv,.cc,.tw,.name,.ws,.in,.hk,.tw,.us,.au,.ac,.ca," & _
	".travel,.us,.asia,.org.tw,.idv.tw,.com.tw,.ph,.com.ph,.org.ph,.net.ph,.la"
	AllTop=split(Exts,",")
	if len(whichDomain)>3 then
		for z=0 to Ubound(AllTop)
			extLen=len(AllTop(z))
			if right(whichDomain,extLen)=AllTop(z) then
				prefix=left(whichDomain,len(whichDomain)-extLen)
				dotPos=inStrRev(prefix,".")
				if dotPos>0 then
					whichDomain=mid(prefix,dotPos+1) & AllTop(z)
				end if
				exit for
			end if
		next
	end if
	GetsRoot=whichDomain
end function


Function IsBlank(Str)
	If Str="" or IsEmpty(Str) then
		IsBlank=True
	Else
		IsBlank=False
	End If
End Function

function finduserid(ByVal uname)
	Set localRs=conn.Execute("select u_id from userdetail where u_name='" & uname & "'")
	if not localRs.eof then
		finduserid=localRs("u_id")
	else
		finduserid=0
	end if
	localRs.close:set localRs=nothing
end function

Function bstr_new(vIn)
	Dim strReturn,i,ThisCharCode,innerCode,Hight8,Low8,NextCharCode
	strReturn = ""
	For i = 1 To LenB(vIn)
	ThisCharCode = AscB(MidB(vIn,i,1))
	If ThisCharCode < &H80 Then
	strReturn = strReturn & Chr(ThisCharCode)
	Else
	NextCharCode = AscB(MidB(vIn,i+1,1))
	strReturn = strReturn & Chr(CLng(ThisCharCode) * &H100 + CInt(NextCharCode))
	i = i + 1
	End If
	Next
	bstr_new = strReturn
End Function

sub addRec(s_title,s_mark)
'在待手工处理表中添加记录
 sql="insert into unprocess (Otype,U_name,Omoney,[Memo],Odate,Mark) values ('提醒','admin',0,'"&s_title&"',"&PE_Now&",'"&left(s_mark&"",240)&"')"
 conn.Execute(sql)
end sub
function round2(num)'进一法取整
		dim numint,numfot
		numint=int(num)
		numfot=num-numint
		if numfot>0 then 
		round2=numint+1
		else
		round2=numint
		end if
end function

function httpSendSMS(SmsPhoneNum,Content) 
		if not sms_note then httpSendSMS="404 系统没有开启短信功能"
		sendsize=60'设定每次发送的字符个数
		Content=sms_sign&Content
		Select Case Trim(LCase(sms_type))
			Case "user"
				httpSendSMS=usercomm_sendsmshttp(SmsPhoneNum,Content)      'usercomm_sendsmshttp 请自行在usercomm.asp 页面添加 function 否则会被更新
			Case "chanyoo"
				if right(SmsPhoneNum,1)="," then SmsPhoneNum=left(SmsPhoneNum,len(SmsPhoneNum)-1) 
					 
					sendcontents=Content
					sms_sendurl=Replace(sms_url,"{u}",sms_mailname)
					sms_sendurl=Replace(sms_sendurl,"{p}",sms_mailpwd)
					sms_sendurl=Replace(sms_sendurl,"{m}",SmsPhoneNum)
					sms_sendurl=Replace(sms_sendurl,"{c}",sendcontents)
					sms_api_sendurl=Split(sms_sendurl,"?")(0)
					sms_api_snedpost=Mid(sms_sendurl,Len(sms_api_sendurl)+2)
				'	die sms_api_sendurl&"<BR>"&sms_api_snedpost
					set xmlhttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")   
					xmlhttp.Open   "POST",sms_api_sendurl,False
					xmlhttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=utf-8"
					xmlhttp.send(sms_api_snedpost)
					If  xmlhttp.Status = 200 Then
						returnStr=bstr_new(xmlhttp.ResponseBody)
						Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
						xmlDoc.loadXML(returnStr) 
						retcode=xmlDoc.getElementsByTagName("response").Item(0).childNodes(0).Text 
						If CDbl(retcode) > 0  then '返回200 为发送成功
							httpSendSMS="200.ok"
						else
							httpSendSMS="402:" & returnStr
						end if
			
					else	
					  httpSendSMS="502.unknow error" 
					End If
					if len(SmsPhoneNum)>11 then 
						SmsPhoneNum="群发"
					end If
					
					Randomize
					MyValue = Int(((999-100+1)*rnd)+100)
					Randomize
					myvalue1=int(((99-10+1)*rnd)+10)
					Randomize
					myvalue2=int(((99-10+1)*rnd)+10)
					MyRand="HT"&Trim(right(timer()*100,7) & myvalue & myvalue1 & myvalue2)
					
					conn.execute "insert into SMSback(marker,sendcontent,senduser) values('"& MyRand &"','"& SmsPhoneNum & "|" & Content &"','"& session("user_name") &"')"
			Case "smsbao"
				if right(SmsPhoneNum,1)="," then SmsPhoneNum=left(SmsPhoneNum,len(SmsPhoneNum)-1) 
			 
					sendcontents=Content
					sms_sendurl=Replace(sms_url,"{u}",sms_mailname)
					sms_sendurl=Replace(sms_sendurl,"{p}",sms_mailpwd)
					sms_sendurl=Replace(sms_sendurl,"{m}",SmsPhoneNum)
					sms_sendurl=Replace(sms_sendurl,"{c}",sendcontents)
					sms_api_sendurl=Split(sms_sendurl,"?")(0)
					sms_api_snedpost=Mid(sms_sendurl,Len(sms_api_sendurl)+2)
				'	die sms_api_sendurl&"<BR>"&sms_api_snedpost
					set xmlhttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")   
					xmlhttp.Open   "POST",sms_api_sendurl,False
					xmlhttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=utf-8"
					xmlhttp.send(sms_api_snedpost)
					If  xmlhttp.Status = 200 Then
						returnStr=bstr_new(xmlhttp.ResponseBody)
						if Trim(returnStr&"")="0" then '返回200 为发送成功
							httpSendSMS="200.ok"
						else
							httpSendSMS="402:" & returnStr
						end if
			
					else	
					  httpSendSMS="502.unknow error" 
					End If
					if len(SmsPhoneNum)>11 then 
						SmsPhoneNum="群发"
					end If
					
					Randomize
					MyValue = Int(((999-100+1)*rnd)+100)
					Randomize
					myvalue1=int(((99-10+1)*rnd)+10)
					Randomize
					myvalue2=int(((99-10+1)*rnd)+10)
					MyRand="HT"&Trim(right(timer()*100,7) & myvalue & myvalue1 & myvalue2)
					
					conn.execute "insert into SMSback(marker,sendcontent,senduser) values('"& MyRand &"','"& SmsPhoneNum & "|" & Content &"','"& session("user_name") &"')"
				 
			Case Else
					'SmsPhoneNum 手机号 多个手机号可以用","分隔 如:13188888888,13888888888(不能超过1000个手机号)
					'Content 手机内容,不能超过60个字符
					
					md5str=asp_md5(sms_mailname & sms_mailpwd)'对邮局名和密码加密
					if right(SmsPhoneNum,1)="," then SmsPhoneNum=left(SmsPhoneNum,len(SmsPhoneNum)-1)				
					ii_zxwjj=1
					for i_zxwjj=1 to round2(len(Content)/sendSize)
							sendcontents=mid(Content,ii_zxwjj,sendSize)
							sendcontents=Server.URLEncode(sendcontents)
							poststr="muser="& sms_mailname &"&mpwd="& sms_mailpwd &"&mobilelist="& SmsPhoneNum &"&smsinfo="& sendcontents &"&md5str="& md5str'组成字付串准备post
							
							set xmlhttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")   
							xmlhttp.Open   "POST","http://www.myhostadmin.net/manager/agentpay/sendsms.asp?temcod="& timer,False
							xmlhttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
							xmlhttp.send(URLEncoding(poststr))
							If  xmlhttp.Status = 200 Then
								returnStr=bstr_new(xmlhttp.ResponseBody)
								if left(trim(returnStr),3)="200" then '返回200 为发送成功
									httpSendSMS="200.ok"
								else
									httpSendSMS="402:" & returnStr
								end if
					
							else	
							  httpSendSMS="502.unknow error" 
							End If
						
						set xmlhttp=nothing

						if len(SmsPhoneNum)>11 then 
							SmsPhoneNum="群发"
						end if

						Randomize
						MyValue = Int(((999-100+1)*rnd)+100)
						Randomize
						myvalue1=int(((99-10+1)*rnd)+10)
						Randomize
						myvalue2=int(((99-10+1)*rnd)+10)
						MyRand="HT"&Trim(right(timer()*100,7) & myvalue & myvalue1 & myvalue2)
						
						conn.execute "insert into SMSback(marker,sendcontent,senduser) values('"& MyRand &"','"& SmsPhoneNum & "|" & Content &"','"& session("user_name") &"')"
						ii_zxwjj=ii_zxwjj+sendSize 
					Next 
		End Select 

	 
end function
Function URLEncoding(vstrIn)
    strReturn = ""
    For i = 1 To Len(vstrIn)
        ThisChr = Mid(vStrIn,i,1)
        If Abs(Asc(ThisChr)) < &HFF Then
            strReturn = strReturn & ThisChr
        Else
            innerCode = Asc(ThisChr)
            If innerCode < 0 Then
                innerCode = innerCode + &H10000
            End If
            Hight8 = (innerCode  And &HFF00)\ &HFF
            Low8 = innerCode And &HFF
            strReturn = strReturn & "%" & Hex(Hight8) &  "%" & Hex(Low8)
        End If
    Next
    URLEncoding = strReturn
End Function

function Gbkcode(byval strdomain)
	on error resume next
  	   PHPURL="http://beianmii.gotoip1.com/idna/api.php?a=decode&p="&strdomain& "&pasd="& timer()
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 10000, 10000, 10000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  Gbkcode=retCode'myinstr(retCode,":\s+([\w\.\-]+)\s*</pre>")
end function

function setRoom(productid00)'设置机房的下拉菜单
	commandstr="other" & vbcrlf & _
			   "get" & vbcrlf & _
			   "entityname:roomlist"& vbcrlf & _
			   "productid:" & productid00 & vbcrlf & _
			   "." & vbcrlf
			
	 returnstr=pcommand(commandstr,"AgentUserVCP")
 	 if left(returnstr,3)="200" then

		roomlist = getReturn_rrset(returnstr,"roomlist")
        if trim(os_roomid)="0" then
			roomstring="<select name=""room"" onchange=""getoslist(this.value,'"&productid00&"')"">"
		else
			roomstring="<select name=""room"">"
		end if
		
		for each roomitem in split(roomlist,vbcrlf)
			if roomitem<>"" then
			roomarray=split(roomitem,",")
			if ubound(roomarray)>=2 then
				roomv=roomarray(0)
				roomt=chgroomName(roomarray(1))
				rooms=roomarray(2)
				selectstr=""
				if cint(os_roomid)=0 then
				os_roomid=roomv
				end if
				titlestr=""
				if ubound(roomarray)>2 then
					titlestr="title="""&roomarray(3)&""""
				end if
					if cint(rooms)=1 then 
					 selectstr=" selected "
					 os_roomid=roomv
					end if
				 roomstring=roomstring & "<option value="""& roomv & """ "& selectstr& " "& titlestr &">"& roomt & "</option>" & vbcrlf
				end if
			end if
		next
		roomstring=roomstring& "</select>"
	 	setRoom=roomstring
	 end if
end function


function setosList(roomid,productid00)'设置机房的下拉菜单

		Xcmd= "other" & vbcrlf
		Xcmd=Xcmd & "get" & vbcrlf
		Xcmd=Xcmd & "entityname:oslist" & vbcrlf
		Xcmd=Xcmd & "productid:"&productid00 & vbcrlf
		Xcmd=Xcmd & "roomid:"&roomid& vbcrlf
		Xcmd=Xcmd & "." & vbcrlf

	 returnstr=pcommand(Xcmd,"AgentUserVCP")
	 if left(returnstr,3)="200" then

 		oslist = getReturn_rrset(returnstr,"oslist")
		if lcase(USEtemplate)="tpl_2016" then
			osstring="<select name=""oslist""  class=""common-select std-width common-validate"">"
		else
			osstring="<select name=""oslist"">"
		end if
		
		
		
		
		
		
	for each ositem in split(oslist,vbcrlf)
	
			if ositem<>"" then
				osarray=split(ositem,",")
					
				if ubound(osarray)>=1 then
				
					osv=osarray(0)
					osn=osarray(1)

				 osstring=osstring & "<option value="""& osv & """ >"& osn & "</option>" & vbcrlf  
				 end if
				
			end if
		next
		
		
		
		
		
		 
	 
		osstring=osstring& "</select>"
		'response.Write(osstring)
	 	setosList=osstring
	 end if
end function


function chgroomName(byval roomnames)
	newRoomNamestr=roomnames
	if roomName<>"" then

		for each roomitem in split(roomName,",")
			if roomitem<>"" and instr(roomitem,":")>0 then
				roomarr=split(roomitem,":")
				if ubound(roomarr)>0 then
					oldroomnames=trim(roomarr(0))
					newroomnames=trim(roomarr(1))
					
					if oldroomnames<>"" then
						newRoomNamestr=replace(newRoomNamestr,oldroomnames,newroomnames)
					end if
				end if
			end if
		next
	end if
	chgroomName=newRoomNamestr
		
end function
'sjwxl
'验证是否将有问必答提交上级服务商
function blSubmitQuestion(ByVal Qtype)
	blSubmitQuestion=false
	if Qustion_Upload<>"" and isNumeric(Qtype) then
		QtypeArray=split(Qustion_Upload,",")
		for z=0 to Ubound(QtypeArray)
			if isNumeric(Trim(QtypeArray(z))) then
				ANum=Cint(Trim(QtypeArray(z)))
				BNum=Cint(Qtype)

				if ANum=BNum then
						blSubmitQuestion=true
						exit function
				end if
			end if
		next
	end if
end function

'2008-5-4
'edwardyang
'取得业务密码
function GetOperationPassWord(OperationKeyWord,OperationType,UserName)
	select case OperationType
		case "domain"
			strContent=""
			strContent=strContent&"other"&vbcrlf
			strContent=strContent&"get"&vbcrlf
			strContent=strContent&"entityname:domainpassword"&vbcrlf
			strContent=strContent&"domainname:"&OperationKeyWord&vbcrlf
			strContent=strContent&"."&vbcrlf
		case "host"
			strContent=""
			strContent=strContent&"other"&vbcrlf
			strContent=strContent&"get"&vbcrlf
			strContent=strContent&"entityname:ftppassword"&vbcrlf
			strContent=strContent&"sitename:"&OperationKeyWord&vbcrlf
			strContent=strContent&"."&vbcrlf
		case "mail"
			strContent=""
			strContent=strContent&"other"&vbcrlf
			strContent=strContent&"get"&vbcrlf
			strContent=strContent&"entityname:mailpassword"&vbcrlf
			strContent=strContent&"domainname:"&OperationKeyWord&vbcrlf
			strContent=strContent&"."&vbcrlf
		case "database"
			strContent=""
			strContent=strContent&"other"&vbcrlf
			strContent=strContent&"get"&vbcrlf
			strContent=strContent&"entityname:mssqlpassword"&vbcrlf
			strContent=strContent&"databasename:"&OperationKeyWord&vbcrlf
			strContent=strContent&"."&vbcrlf
	end select
	
	GetOperationPassWord=PCommand(strContent,UserName)
end function

function GetUserName(u_id)
	set u_rs=server.CreateObject("adodb.recordset")
	sql="select u_name from UserDetail where u_id="&u_id
	u_rs.open sql,conn,1,3
	if not u_rs.eof then
		GetUserName=u_rs(0)
	end if
	u_rs.close
	set u_rs=nothing
end function

'2007-7-26
'edwardyang
'根据主机名判断是否是试用主机，如果是返回true，不是返回false
function CheckIsBuyTestHost(s_Comment)
	set BuyTestHostRS=server.CreateObject("adodb.recordset")
	sql="select s_buytest from vhhostlist where s_comment='"&s_Comment&"'"
	BuyTestHostRS.open sql,conn,1,1
	if not BuyTestHostRS.eof then
		CheckIsBuyTestHost=BuyTestHostRS(0)
	else
		CheckIsBuyTestHost=false
	end if
	BuyTestHostRS.close
end function

function getRegister(ByVal strDomain)
	d_proid=GetDomainType(strDomain)
	Set lrs=conn.Execute("select register from registermap where domaintype='" & d_proid & "'")
	if not lrs.eof then
		getRegister=lrs("register")
	else
		getRegister="default"
	end if
	lrs.close:Set lrs=nothing
end function

Dim producturl(9)
producturl(1)=InstallDir&"services/webhosting/buy.asp" 
producturl(2)=InstallDir&"services/mail/buy.asp"
producturl(3)=InstallDir&"services/domain/buymore.asp"
producturl(4)= InstallDir&"services/search/buy.asp"
producturl(5)= InstallDir&"services/domain/dns.asp"
producturl(7)= InstallDir&"services/mssql/buy.asp"
producturl(8)=InstallDir&"services/mssql/buy.asp"

'取得用户的产品自定义价格
'2006-12-20
'Edward.Yang
function GetUserCustomProPrice(UserID,ProID)
	set CustomPriceRS=server.CreateObject("adodb.recordset")
	sql="select ProPrice from UserPrice where u_id="&UserID&" and ProId='"&ProID&"'"
	CustomPriceRS.open sql,conn,1,1
	if not CustomPriceRS.eof then
		GetUserCustomProPrice=cint(CustomPriceRS(0))
	else
		GetUserCustomProPrice=""
	end if
	CustomPriceRS.close
end function
function gotTopic(str,strlen)
	dim l,t,c,i
	l=len(str)
	t=0
	for i=1 to l
	c=Abs(Asc(Mid(str,i,1)))
	if c>255 then
	t=t+2
	else
	t=t+1
	end if
	if t>=strlen then
	gotTopic=left(str,i)&".."
	exit for
	else
	gotTopic=str&""
	end if
	next
end function

function getfreedomainsuffix(byval freeid,byref isfree)
isfree=false
'allsuffix=".com,.net,.org,.cn,.com.cn,.net.cn,.gov.cn,.org.cn,.tv,.cc,.info,.biz,.mobi,.name,.me,.ws,.es,.in,.co,.pw,.xyz,.club,.la,.tm,.us,.hk,.wang,.website,.pro,.top,.ren,.space,.press,.host,.wiki,.ink,.design,.site,.love,.ooo,.club,[save]"
allsuffix=".top,.cc,.com,.cn,.net,.wang,.mobi,.ren,.com.cn,.net.cn,.org,.site,.info,.biz,.pro,.red,.kim,.shop,.ink,.vip,.club,.tv,.xyz,.online,.store,.tech,.fun ,.space,.press,.host,.website,[save]"

	if freeid<>"" then
		newsuffix=""
		sqlfree="select * from free where f_randid='"& freeid &"' and f_isget="&PE_False&""
	 
		rs11.open sqlfree,conn,1,1
		if not rs11.eof then
			freesuffix=trim(rs11("f_freeproid"))
			if len(freesuffix)>0 then
				for each all_s in split(allsuffix,",")
					all_s=trim(all_s)
					 
					if all_s<>"" and left(all_s,1)="." then
						all_type=trim(getDomaintype(all_s))

						for each free_s in split(freesuffix,",")
							free_s=trim(free_s)							
							if all_type=free_s then							 
								newsuffix=newsuffix & all_s & ","
							end if
						next
					end if
				next
				if right(newsuffix,1)="," then newsuffix=left(newsuffix,len(newsuffix)-1)
				isfree=true
			end if
		end if
		
		rs11.close
	end if
		if isfree then
			getFreedomainsuffix=newsuffix
		else
			getFreedomainsuffix=allsuffix
		end if
		
end function
function getFreedatebase(byval freeid,byref f_freeproid,byref f_content)
	getFreedatebase=false
	if freeid<>"" then
		call needregSession()
		
		sql="select top 1 * from free where f_randid='"& freeid &"' and f_username='"& session("user_name") &"' and f_isget="&PE_False&""
		rs11.open sql,conn,1,1
		if not rs11.eof then
			f_freeproid=lcase(rs11("f_freeproid"))
			f_content=rs11("f_content")
			f_type=rs11("f_type")
			f_freeName=rs11("f_freeName")
			
			select case trim(lcase(f_type))
				case "host"
			 		preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4,b.s_comment,b.s_buydate from protofree a inner join vhhostlist b on (b.s_buytest="&PE_False&" and a.proid=b.s_productId and b.s_ownerid=" & session("u_sysid") & " and b.s_comment='" & f_freeName & "' and a.type='host') where not exists(select sysid from protofree where b.s_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='host') and not exists(select * from free where f_randid='"& freeid &"' and f_isget="&PE_True&")"
				case "mail"
					preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4 from protofree a inner join mailsitelist b on (b.m_buytest="&PE_False&" and a.proid=b.m_productId and b.m_ownerid=" & session("u_sysid") & " and b.m_bindname='" & f_freeName & "' and a.type='mail') where not exists(select sysid from protofree where b.m_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='mail') and not exists(select * from free where f_randid='"& freeid &"'  and f_isget="&PE_True&")"
			end select 
			if PreSql<>"" and not isNull(PreSql) then 
				set prs=server.CreateObject("adodb.recordset")
				prs.open preSql,conn,1,1
				if not Prs.eof then
					getFreedatebase=true
				end if
				prs.close
				set prs=nothing
			end if
		end if
		rs11.close
	end if
	
end function
function isgetFreeProduct(byval f_type,byval f_freeName,byval freetype)
	isgetFreeProduct=false
	if len(freetype)>0 then
		newfreesql="select * from free where f_type='" & f_type & "' and f_freeName='"& f_freeName &"' and f_freeproid='"& freetype &"'"
		set newrs=conn.execute(newfreesql)
		if newrs.eof and newrs.bof then
			isgetFreeProduct=true
		else
			this_f_isget=newRs("f_isget")
			if not this_f_isget then isgetFreeProduct=true
		end if
		newrs.close
		set newRs=nothing
	end if
end function
'判断是否需要运行安装程序
sub checkInstall()
	instFile=Server.MapPath("/Install.asp")
	if Server.MapPath("/")<>server.MapPath(".") then
		Response.write "警告!本程序只能运行于网站的根目录，不能运行于子目录"
		Response.end
	end if
	set ofso=createobject("Scripting.FileSystemObject")
	if ofso.fileExists(instFile) then
		Response.Redirect("/Install.asp")
	end if
end sub

function showerrmsg(result)
'将返回的域名错误信息进行汉化．
	tempmsg=lcase(result)
	tempmsg=replace(tempmsg,"the contactor info contains inhibitive keywords","域名信息中含有不正确的输入值，请修改:")
	tempmsg=replace(tempmsg,"dom_org_m","域名所有人中文信息")
	tempmsg=replace(tempmsg,"dom_fn_m","中文名字")
	tempmsg=replace(tempmsg,"dom_ln_m","中文姓")
	tempmsg=replace(tempmsg,"dom_adr_m","中文地址")
	tempmsg=replace(tempmsg,"dom_ct_m","中文城市名称")
	tempmsg=replace(tempmsg,"dom_st_m","中文省份名称")
	tempmsg=replace(tempmsg,"dom_org","域名所有人英文信息")
	tempmsg=replace(tempmsg,"dom_adr1","英文地址信息")
	tempmsg=replace(tempmsg,"dom_pc","邮编号码")
	tempmsg=replace(tempmsg,"dom_ph","电话号码")
	tempmsg=replace(tempmsg,"dom_fax","传真号码")
	tempmsg=replace(tempmsg,"dom_em","Email地址")
	tempmsg=replace(tempmsg,"dom_fax","传真号码")
	tempmsg=replace(tempmsg,"admi_fax","传真号码")
	tempmsg=replace(tempmsg,"admi_pc","邮编号码")
	tempmsg=replace(tempmsg,"admi_ph","电话号码")
	tempmsg=replace(tempmsg,"invalid attribute","错误的值")


	showerrmsg=tempmsg
end function

Function sqlincode(byval strRequest)
	sqlincode=strRequest
	If Not isNumeric(sqlincode) and sqlincode<>"" Then
		Set oRegExp_ = new RegExp		
		oRegExp_.IgnoreCase = True
		oRegExp_.Global = True	
		oRegExp_.MultiLine = True
		sqlincode=replace(sqlincode,"'",chr(-10065))	
		sqlincode=replace(sqlincode,">","&gt;")	
		sqlincode=replace(sqlincode,"<","&lt;")
		sqlincode= Replace(sqlincode, """", "&quot;")
		' sqlincode = Replace(sqlincode, "expression", "e&shy;xpression")
		Request_tmp=sqlincode
		BadWord="exec,execute,master,user,cmd.exe,insert,xp_cmdshell,mid,update,select,delete,drop,database,db_name,union," & _
				"char,unicode,asc,left,or,where,backup,chr,nchar,cast,substring,/*,set,from,into,values,and,declare,exists," & _
				"truncate,join,create,--,convert,db_name,schema,executeglobal,eval,script,applet,object,alter,rename,modify,@@,varchar,sp_executesql"
		wordCount=0:HaveBadWord=false
		BadWordArr=split(BadWord,",")
		for each word_item in BadWordArr
			if trim(word_item)<>"" then
				oRegExp_.Pattern="^\w+$"
				if oRegExp_.Test(word_item) then
					'oRegExp_.Pattern="\b"& word_item &"\b"
					'oRegExp_.Pattern="[^xn]\b"& word_item &"\b[^\.]"
					oRegExp_.Pattern="[^a-zA-Z\.\d]?"& word_item &"[^a-zA-Z\.\d]"
					if oRegExp_.Test(sqlincode) then
						wordCount=wordCount+1
						Request_tmp=replace(Request_tmp,word_item,"sqlin",1,-1,1)
					end if
				elseif instr(1,LCase(sqlincode),word_item)>0 then
						wordCount=wordCount+1
						Request_tmp=replace(Request_tmp,word_item,"sqlin",1,-1,1)
				end if
				if wordCount>=2 then
					HaveBadWord=true
				end if
			end if
		next
		if HaveBadWord then
			'call zxw_writelog("sqlincode",getuserip()&"  "&request.ServerVariables("SCRIPT_NAME")&vbcrlf&strRequest&vbcrlf&string(10,"*")&Request_tmp)
			sqlincode=Request_tmp
		end if
		Set oRegExp_ = Nothing
		sqlincode=trim(sqlincode)
	end if	
End Function




function getRemoteVer()
	on error resume next
	xmlSavePath="/update/server/"
	xmlUpdate="http://update.myhostadmin.net/update/server/patch_list.xml"
	Set ohttp=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	verUrl=getHost(xmlUpdate) & xmlSavePath & "GetVer.asp?1=" & api_username & "&2=" & Server.UrlEncode(api_url) & "&3=" & companynameurl & "&4=" & timer()
	ohttp.open "GET",verUrl,false
	ohttp.send
	if ohttp.status=200 then
		getRemoteVer=ohttp.ResponseText
	else
		getRemoteVer="0.0"
	end if
	Set ohttp=nothing
end function
function getHost(content)
	Set oReg=new RegExp
	oReg.IgnoreCase=true
	oReg.Pattern="(http://[\w\-\.]+)(/.+)?"
	if oReg.test(content) then
		Set oMatch=oReg.Execute(content)
		getHost=oMatch(0).subMatches(0)
	end if
	set oReg=nothing
end function
'价格获取函数''''''''''''''''''''''''''''
function getlevelPrice(byval Proid,byval u_level,byval buyyear,byval buytype)
		needPrice=0
		firstPrice=0
		if Proid="" or u_level="" or buyyear="" or buytype="" then exit function
		if isnumeric(buyyear) then buyyear=ccur(buyyear)
			select case buytype
				case "new"
				      If isdbsql Then
						  set prs=conn.execute("select top 1 isnull(p_firstPrice,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
					  else
						  set prs=conn.execute("select top 1 iif(isnull(p_firstPrice),0,p_firstPrice) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
					  End if
					  if not prs.eof then
							firstPrice=ccur(prs(0))
					  end if
					  prs.close
					  set prs=nothing
					  if buyyear>1 or (firstPrice=0 and buyyear=1) then
						if firstPrice>0 then buyyear=buyyear-1 
						If isdbsql Then
							set prs0=conn.execute("select top 1 isnull(newPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'")
						else
							set prs0=conn.execute("select top 1 iif(isnull(newPrice),0,newPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'")
						End if
						if not prs0.eof then
						    price=ccur(prs0(0))
							if price>0 then
								needPrice=firstPrice + price
							end if
						end if
						prs0.close
						set prs0=nothing
						if needPrice=0 Then
							If isdbsql Then
							   set prs1=conn.execute("select top 1 isnull(p_price,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							else
								set prs1=conn.execute("select top 1 iif(isnull(p_price),0,p_price) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							End if
							if not prs1.eof then
								price=ccur(prs1(0))
								if price>0 then
									needPrice=firstPrice + price * buyyear
								end if
							end if
							prs1.close
							set prs1=nothing
						end if
					 else
					 	needPrice=firstPrice
					 end if
				case "renew"
					  If isdbsql Then
					    set prs=conn.execute("select top 1 isnull(p_firstPrice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
					  else
						set prs=conn.execute("select top 1 iif(isnull(p_firstPrice_renew),0,p_firstPrice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
					  End if
					  if not prs.eof then
							firstPrice=ccur(prs(0))
					  end if
					  prs.close
					  set prs=nothing
					  if buyyear>1 or (firstPrice=0 and buyyear=1) then
							if firstPrice>0 then buyyear=buyyear-1 
							If isdbsql Then
			                    set prs0=conn.execute("select top 1 isnull(RenewPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'")
							else
								set prs0=conn.execute("select top 1 iif(isnull(RenewPrice),0,RenewPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'")
							End if
							if not prs0.eof then
								price=ccur(prs0(0))
								if price>0 then
									needPrice=firstPrice + price
								end if
							end if
							prs0.close
							set prs0=nothing
							if needPrice=0 Then
								If isdbsql Then
									set prs1=conn.execute("select top 1 isnull(p_price_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
								else
									set prs1=conn.execute("select top 1 iif(isnull(p_price_renew),0,p_price_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'")
							    End if
								if not prs1.eof then
									price=ccur(prs1(0))
									if price>0 then
										needPrice=firstPrice + price * buyyear
									end if
								end if
								prs1.close
								set prs1=nothing
							end if
					  else
					 	needPrice=firstPrice
					  end if
		   end select
		   getlevelPrice=needPrice
end function
Function checkwebPost(ByVal strserverurl, ByVal postinfo)
		Dim getreturnstr
		Dim newurlstr
		Dim posttypes
		Dim xmlhttp
		newurlstr = "&tmptimer=" & Timer()
		If InStr(strserverurl, "?") = 0 Then newurlstr = "?tmptimer=" & Timer()
		checkwebPost = ""
		
		Set xmlhttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		posttypes = "POST"
		If Trim(postinfo) & "" = "" Then posttypes = "GET"
		xmlhttp.setTimeouts 10000, 10000, 10000, 300000
		xmlhttp.Open posttypes, strserverurl & newurlstr, False
		xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xmlhttp.setRequestHeader "Referer", strserverurl
		xmlhttp.send (postinfo)
		
		If Err.Number = 0 Then
			If xmlhttp.status = 200 Then
				getreturnstr = bstr_new(xmlhttp.responseBody)
				checkwebPost = getreturnstr
	
			End If
		End If
		Set xmlhttp = Nothing
End Function
function GetFlashURL()
	hostURL = request.ServerVariables("URL")
	if instr(hostURL,"/services/domain/") then
		GetFlashURL="/flash/DomainFlashList.swf"
	elseif  instr(hostURL,"/services/webhosting/") then
		GetFlashURL="/flash/WebhostingFlashList.swf"
	elseif  instr(hostURL,"/services/domain/defaultcn") then
		GetFlashURL="/flash/cndomain.swf"
	elseif  instr(hostURL,"/services/domain/whoisCN.asp") then
		GetFlashURL="/flash/cndomain.swf"
	elseif  instr(hostURL,"/services/mail/") then
		GetFlashURL="/flash/MailHost.swf"
	elseif  instr(hostURL,"/services/server/") then
		GetFlashURL="/flash/ServerFlashViewer.swf"
	elseif  instr(hostURL,"/services/server/") then
		GetFlashURL="/flash/ServerFlashViewer.swf"
	elseif  instr(hostURL,"/services/vpsserver/") then
		GetFlashURL="/Template/Tpl_04/flash/VPS.swf"
	elseif  instr(hostURL,"/agent/") then
		GetFlashURL="/flash/agent.swf"
	elseif  instr(hostURL,"/customercenter/") then
		GetFlashURL="/Template/Tpl_04/images/top_main_2_cc.gif"
	elseif  instr(hostURL,"/login.asp") then
		GetFlashURL="/Template/Tpl_04/images/top_main_2_login.jpg"
	elseif  instr(hostURL,"/aboutus/contact.asp") then
		GetFlashURL="/Template/Tpl_04/images/top_main_contact.gif"
	elseif  instr(hostURL,"/aboutus/default.asp") then
		GetFlashURL="/Template/Tpl_04/images/top_main_aboutus.gif"
	else
		GetFlashURL="/Template/Tpl_04/flash/FlashViewer.swf"
	end if
end function
function gowithwin(byval this_go)
%>
  <script language="JavaScript">
         window.location='<%=this_go%>';
  </script>
<%
  response.end
end function
function doupfile(byval orderlist,byval topage)
	domainlist=""
	if isDomain(orderlist) then
		if getRegister(orderlist)="default" then
			domainlist=orderlist
		end if
	end if
	if domainlist<>"" then		
		checkpage=manager_url&"services/domain/tocheck_new.asp"
		sql="select strdomainpwd from domainlist where strdomain='"& domainlist &"' or s_memo='"& domainlist &"'"
		set drs=server.CreateObject("ADODB.Recordset")
		drs.open sql,conn,1,1
		if not drs.eof then
			dompwd=trim(drs("strdomainpwd"))
			hashcode=asp_md5(domainlist&dompwd)
			if topage="" then
				topage=GetUrl()
			end if
			postinfo="domain="& server.URLEncode(domainlist) & "&hashcode="& hashcode & "&topage="& server.URLEncode(topage)&"&cpname="& server.URLEncode(companyname)
			upresult=checkwebPost(checkpage,postinfo)
			 if left(upresult,3)<>"" then
				doupfile=upresult
				exit function
			 
			 end if
		end if
		drs.close:set drs=nothing
	end if
end function
Function GetUrl()
	topage="http://"&request.ServerVariables("HTTP_HOST")&request.ServerVariables("SCRIPT_NAME") 
	if(len(trim(request.ServerVariables("QUERY_STRING")))>0) then 
		topage=topage & "?" & request.ServerVariables("QUERY_STRING") 
	end if 
	GetUrl=topage
end function

public function isStrsame(byval strnum)
		isStrsame=false
		if strnum="" then exit function
		if left(strnum,clng(len(strnum)/2)+1)=right(strnum,clng(len(strnum)/2)+1) and StrReverse(strnum)=strnum then isStrsame=true
end function

function ckbadWord(byval word)
	ckbadWord=false
	word=lcase(word)
	Words=Array("1q2w3e4r5t","q1w2e3r4","112233","abcdef","abcabc","aaa111","qwerty","qweasd","passwd","1q2w3e4r","q1w2e3","1q2w3e","1qaz2wsx","P@ssw0rd","A1b2c3","a1b2c3","ABC567","c3b2a1","a2b2c2","abc123","123123","123321","abcd1234","admin888","12345678","123456","888888","1q2w3e","987654","888999","a123456","a12345","110110","5201314","1314520","987654321","54321","001","002","007","008","10th","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","100","101","108","133","163","166","188","233","266","350","366","450","466","136","137","138","139","158","168","169","192","198","200","222","233","234","258","288","300","301","333","345","388","400","433","456","458","500","555","558","588","600","666","598","668","678","688","888","988","999","1088","1100","1188","1288","1388","1588","1688","1888","1949","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1997","1999","2000","2001","2002","2088","2100","2188","2345","2588","3000","3721","3888","4567","4728","5555","5678","5888","6666","6688","6789","6888","7788","8899","9988","9999","23456","34567","45678","88888","654321","737","777","1111","2222","3333","4321","computer","cpu","memory","disk","soft","y2k","software","cdrom","rom","admin","master","card","pci","lock","ascii","knight","creative","modem","internet","intranet","web","www","isp","unlock","ftp","telnet","ibm","intel","microsoft","dell","compaq","toshiba","acer","info","aol","56k","server","dos","windows","win95","win98","office","word","excel","access","unix","linux","password","file","program","mp3","mpeg","jpeg","gif","bmp","billgates","chip","silicon","sony","link","word97","office97","network","ram","sun","yahoo","excite","hotmail","yeah","sina","pcweek","mac","apple","robot","key","monitor","win2000","office2000","word2000","net","virus","company","tech","technology","print","coolweb","guest","printer","superman","hotpage","enter","myweb","download","cool","coolman","coolboy","coolgirl","netboy","netgirl","log","login","connect","email","hyperlink","url","hotweb","java","cgi","html","htm","home","homepage","icq","mykey","c++","basic","delphi","pascal","anonymous","crack","hack","hacker","chinese","vcd","chat","chatroom","mud","cracker","happy","hello","room","english","user","netizen","frontpage","agp","netwolf","acdsee","usa","hot","site","address","mail","news","topcool","win98","qq2000","mylove","loveyou")
	for each str_word in Words
		if str_word=word then
			ckbadWord=true
			exit for
		end if
	next
end function

function isSameChar(strchar)
	Dim cntA,cntB,cntC,i,xchar
	
	isSameChar=false
	for i=1 to len(strchar)
		xchar=asc(lcase(mid(strchar,i,1)))
		if xchar>=97 and xchar<=122 then
			cntA=cntA+1 '字母
		elseif xchar>=48 and xchar<=57 then
			cntB=cntB+1 '数字
		else
			cntC=cntC+1
		end if
	next

	if cntA>0 and cntB=0 and cntC=0 then
		isSameChar=false '全是字母
		exit function
	end if

	if cntB>0 and cntA=0 and cntC=0 then
		isSameChar=true '全是数字
		exit function
	end if
end function

function isBad(byval ftpname,byval ftppassword,byref binfo)
	isBad=false
	
	if len(ftppassword)<6 then
		binfo="密码低于6位"
		isBad=true
		exit function		
	end if

'	if isSameChar(ftppassword) then
'		binfo="密码全是数字或字母"
'		isBad=true
'		exit function			
'	end if

	if ftppassword="a123456" then
		binfo="密码不能是a123456"
		isBad=true
		exit function		
	end if

	if ftppassword="a12345" then
		binfo="密码不能是a12345"
		isBad=true
		exit function		
	end if

	if ckbadWord(ftppassword) then
		binfo="密码是简单单词"
		isBad=true
		exit function		
	end if

	if isStrsame(ftppassword) then
		binfo="密码相同"
		isBad=true
		exit function
	end if
	
	if instr("9876543210",ftppassword)>0 then
		binfo="密码是递减数字"
		isBad=true
		exit function
	end if

	if instr("0123456789",ftppassword)>0 then
		binfo="密码是递增数字"
		isBad=true
		exit function
	end if

	if instr(ftppassword,ftpname)>0 then
		binfo="密码不能含用户名"
		isBad=true
		exit function	
	end if


	if instr(ftpname,ftppassword)>0 then
		binfo="密码与帐户相似"
		isBad=true
		exit function	
	end if



	if ftpname=ftppassword then
		binfo="密码与ftp用户名相同"
		isBad=true
		exit function		
	end if
	
	ftp_len=len(ftpname)

	if left(ftppassword,ftp_len)=ftpname then
		p_b=mid(ftppassword,ftp_len+1)

		if instr("0123456789",p_b)>0 then
			binfo="密码是ftp用户名+顺序数字"
			isBad=true
			exit function				
		end if
		
		if instr("9876543210",p_b)>0 then
			binfo="密码是ftp用户名+顺序数字"
			isBad=true
			exit function				
		end if
		
		if instr(",.com,.net,.org,.cn,","," & p_b & ",")>0 then
			binfo="密码是ftp用户名+(.com/net/org/cn)"
			isBad=true
			exit function				
		end if

		if isStrsame(p_b) then
			binfo="密码是ftp用户名+相同数字"
			isBad=true
			exit function
		end if
		
		if p_b=ftpname then
			binfo="密码是ftp用户名(重复)"
			isBad=true
			exit function			
		end if

		if ckbadWord(p_b) then
			binfo="密码是ftp用户名+简单单词"
			isBad=true
			exit function
		end if
	end if
end function

Function checkPassStrw(byval password)
	Dim str_p : checkPassStrw=False : password=LCase(password)
	str_p="abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+-=<>,./?:|{};\[]"
	For i=1 To Len(password)
	If InStr(str_p,Mid(password,i,1))=0 Then
		checkPassStrw=True
		Exit Function
	End If
	Next
End Function 
function GetuserIp()
  Dim strIPAddr 
  If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" OR InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then 
    strIPAddr = Request.ServerVariables("REMOTE_ADDR") 
  ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then 
    strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",")-1) 
  ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then 
    strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";")-1) 
  Else 
    strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
  End If
  GetuserIp = Trim(Mid(strIPAddr, 1, 30))
  if not isip(GetuserIp) then GetuserIp=""
end function
function isSmaller(byval username)
	resultstr=false
	if len(username)>0 then
		set localrs=server.CreateObject("adodb.recordset")
		If isdbsql Then
			sql="select 1 from userdetail where u_name='"& username &"' and u_level=1 and (u_class='个人用户' or isnull(u_class,'')='')"
		else
			sql="select 1 from userdetail where u_name='"& username &"' and u_level=1 and (u_class='个人用户' or iif(isnull(u_class),'',u_class)='')"
		End if
		localrs.open sql,conn,1,1
		if not localrs.eof then
			resultstr=true
		end if
		localrs.close:set localrs=nothing
	end if
	isSmaller=resultstr
end function
function getIpAddressType_po(byval ipAddress)
		result=""	
		ipsUrl="http://whois.pconline.com.cn/jsAlert.jsp?ip="& server.URLEncode(ipAddress)
		Set xmlhttp1 = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		xmlhttp1.setTimeouts 10000, 5000, 10000, 5000
		xmlhttp1.Open "GET", ipsUrl, False
		xmlhttp1.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=gb2312"	
		xmlhttp1.send()
		If xmlhttp1.status = 200 Then
			getTxt=bstr_new(xmlhttp1.ResponseBody)
			result=trim(myinstr(getTxt,"alert\('\s?(.*)\s?'\);"))
		end if	
		getIpAddressType_po=result
		Set xmlhttp1=nothing
end function
function getIpAddressType(byval ipAddress,byref getIpAddressMsg)
	On Error Resume Next
	result="电信"	
	if isip(ipAddress) then
		if trim(request.Cookies(ipAddress)&"")<>"" then
			getIpAddressMsg=request.Cookies(ipAddress)
		else
			getIpAddressMsg=getIpAddressType_i8(ipAddress)
			If Err <> 0  or getIpAddressMsg="" Then getIpAddressMsg=getIpAddressType_po(ipAddress)
			Response.Cookies(ipAddress)=getIpAddressMsg
		end if		
		if getIpAddressMsg<>"" then
			if instr(getIpAddressMsg,"网通")>0 then
				result="联通"
			elseif instr(getIpAddressMsg,"联通")>0 then
				result="联通"
			elseif instr(getIpAddressMsg,"铁通")>0 then
				result="铁通"
			end if
		end if
	end if
	getIpAddressType=result	
	err.clear()		
end function

function getIpAddressType_(byval ipAddress,byref getIpAddressMsg)
	On Error Resume Next
	result="网通"	
	if isip(ipAddress) then
		if trim(request.Cookies(ipAddress)&"")<>"" then
			getIpAddressMsg=request.Cookies(ipAddress)
		else
			getIpAddressMsg=getIpAddressType_i8(ipAddress)
			If Err <> 0  or getIpAddressMsg="" Then getIpAddressMsg=getIpAddressType_po(ipAddress)
			Response.Cookies(ipAddress)=getIpAddressMsg
		end if		
		if getIpAddressMsg<>"" then
			if instr(getIpAddressMsg,"电信")>0 then
				result="电信"
			end if
		end if
	end if
	getIpAddressType_=result	
	err.clear()		
end function

function getIpAddressType_i8(byval ipAddress)
		result=""	
		ipsUrl="http://www.ip138.com/ips.asp?action=2&t="&timer()&"&ip="& server.URLEncode(ipAddress)
		Set xmlhttp1 = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		xmlhttp1.setTimeouts 10000, 5000, 10000, 5000
		xmlhttp1.Open "GET", ipsUrl, False
		xmlhttp1.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=gb2312"	
		xmlhttp1.send()

		If xmlhttp1.status = 200 Then
			getTxt=bstr_new(xmlhttp1.ResponseBody)
			getmsgbox=myinstr(getTxt,"<li>本站主数据：\s?(.*)\s?<\/li>")
			for each iplist in split(getmsgbox,"</li><li>")
				result1=iplist
				if result1<>"" then					
					a=instr(result1,"：")
					if isChinese(result1) then
						result=trim(mid(result1,a+1))
						exit for
					end if
				end if
			next					
		end if	
		Set xmlhttp1=nothing
		getIpAddressType_i8=result		
end function
function punycode(strdomain)
  on error resume next

	  PHPURL="http://beianmii.gotoip1.com/idna/api.php?a=encode&p="&server.URLEncode(strdomain) & "&pasd="& timer()
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 10000, 10000, 10000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  punycode=retCode'myinstr(retCode,":\s+([\w\.\-]+)\s*</pre>")
end function

'/*_根据域名查.属于我司的哪个注册通道[非我司域名返回空]
Function getW2Channel(ByVal domain)
	getW2Channel=""
	If Not isdomain(domain) Then Exit Function
	Select Case LCase(getDomaintype(domain)&"")
	Case "domcom","domnet","domhzcom","domhznet":getW2Channel="west2"
	Case "domorg"	:getW2Channel="west3"
	Case "domcn","domgovcn"	:getW2Channel="west4"
	Case "domchina"	:getW2Channel="west5"
	End Select
End Function

'/*_代替response.end的函数
Sub Die(ByVal strng)
	On error resume next
	conn.close:conn11.close
	rs.close:rs11.close
	response.Write strng
	response.End()
End Sub

'/*_正则测试正则替换
Function regTest(ByVal strng,ByVal patng)
	Dim oreg:Set oreg=New RegExp
	oreg.Global=True:oreg.IgnoreCase=True
	oreg.Pattern=patng
	regTest=oreg.Test(strng)
	Set oreg=Nothing
End Function
Function regReplace(strng,patng,newstr)
	On Error Resume Next
	Dim oreg:Set oreg=New RegExp
	oreg.Global=True:oreg.IgnoreCase=True
	oreg.Pattern=patng
	regReplace=oreg.Replace(strng,newstr)
	Set oreg=Nothing
End Function

sub getusrinfo()
	sql="select msn_msg,u_email from userdetail where u_id="&session("u_sysid")
	set ulrs=conn.execute(sql)
	usr_mobile=ulrs(0)
	usr_email=ulrs(1)
	ulrs.close
	set ulrs=nothing
end sub
function getcacheRoom(byval p_proid)
	isincache=false
	serverroomcache=application("serverroomcache_"& p_proid)&""
	cacheArray=split(serverroomcache,"~|^")
	if ubound(cacheArray)>=1 then
		if datediff("h",cacheArray(0),now())>=24 then
			isincache=true
		else
			roomcache__=trim(cacheArray(1))
		end if
	else
		isincache=true
	end if
	if isincache then
	'取消同步机房
		'call doUserSyn_vps(p_proid,false)
		roomcache__= getserverRoom(p_proid)
		appstrs=now & "~|^" & roomcache__
		application.Lock()
		application("serverroomcache_"& p_proid)=appstrs
		application.UnLock()
	end if
	getcacheRoom=roomcache__
end function
function GetCloudPriceRoom(byval p_proid)	
	username=session("user_name")
	if len(username)=0 then username="AgentUserVCP"	
	sql="select * from vps_price where p_proid='"& p_proid &"' and room_isStop="&PE_False&" order by v_room"
	ishascheck=false
	resulttitle="<input type=""hidden"" name=""pname_"& p_proid &""" value="""& tpl_function_name(p_proid) &"""><div class='mzpx'>默认根据销量高低和推荐级别排序</div>"
	rs11.open sql,conn,1,1
	do while not rs11.eof
		room_isStop=rs11("room_isStop")
		month_isStop=rs11("month_isStop")
		season_isStop=rs11("season_isStop")
		halfyear_isStop=rs11("halfyear_isStop")
		year_isStop=rs11("year_isStop")
		v_room=trim(rs11("v_room"))&""
		flux_month=trim(rs11("flux_month"))
		if flux_month="" or not isnumeric(flux_month) then flux_month=0
		if not month_isStop then monthprice= "<span class='price'>"& getVpsprice(username,p_proid,v_room,0,0,"new")&"</span>元/月&nbsp;&nbsp;"	
		if not season_isStop then seasonprice= "<span class='price'>"&getVpsprice(username,p_proid,v_room,2,0,"new")&"</span>元/季&nbsp;&nbsp;"
		if not halfyear_isStop then halfyearprice= "<span class='price'>"&getVpsprice(username,p_proid,v_room,3,0,"new")&"</span>元/半年&nbsp;&nbsp;"
		if not year_isStop then yearprice= "<span class='price'>"&getVpsprice(username,p_proid,v_room,1,0,"new")&"</span>元/年"
		disprice="style='display:none;'"
		roomname__=getroomname_(v_room,p_proid,resultcommand)
		r_vpsband=getReturn(resultcommand,"r_vpsband")
		r_vpsband_yun=getReturn(resultcommand,"r_vpsband_yun")
		ismodrr=getReturn(resultcommand,"ismodrr")
		r_remark=getReturn(resultcommand,"r_remark")		
		r_sort=getReturn(resultcommand,"r_sort")	
		disSize=getReturn(resultcommand,"disSize")
		memSize=getReturn(resultcommand,"memSize")	
		if r_remark<>"" then r_remark="("& r_remark &")"
		if r_vpsband&""="" then
			r_vpsband="100M共享"			
		else
			r_vpsband=r_vpsband&"M"
		end if	
		if cdbl(flux_month)>0 then r_vpsband=r_vpsband & "&nbsp;"&flux_month&"G/月"
		if lcase(ismodrr&"")="true" then
			ismodrr="CDN加速,共享IP"
		else
			ismodrr="独享IP一个"
		end if
		if instr(lcase(p_proid),"yun")>0 or instr(lcase(p_proid),"cloud")>0 then
			r_vpsband=r_vpsband_yun&"M"
		end if
		systeminfo="<input type='hidden' name='r_vpsband_"& p_proid &"_"& v_room &"' value='"& r_vpsband &"'>" & _
				   "<input type='hidden' name='ismodrr_"& p_proid &"_"& v_room &"' value='"& ismodrr &"'>" & _
				   "<input type='hidden' name='dissize_"& p_proid &"_"& v_room &"' value='"& disSize &"'>" & _
				   "<input type='hidden' name='memsize_"& p_proid &"_"& v_room &"' value='"& memSize &"'>"
		resultroom=r_sort&"=><div><input type='radio' name='S_radio_"& p_proid &"' value="""& v_room &""" /><span class='GreenColor B'>"& roomname__ & r_remark  &"</span></div>"&vbcrlf&resultroom
		resultprice="<div class=""ppl"" style='display:none;' id=""S_price_"& p_proid &"_"& v_room &""">"& monthprice & seasonprice & halfyearprice & yearprice &"</div>"&resultprice & systeminfo
	rs11.movenext
	loop
	rs11.close
	GetCloudPriceRoom="<div class='ccl arrowMouse'>"&resulttitle&sortroomlist(resultroom) & "</div>" & resultprice 
end function
Function doroomSort(ary)
	KeepChecking = TRUE 
		Do Until KeepChecking = FALSE 
			KeepChecking = FALSE 
			For ss = 0 to UBound(ary) 
				If ss = UBound(ary) Then Exit For 
				arya=ary(ss)
				aryb=ary(ss+1)
				roomArray__a=split(arya&"","=>")
				arya_=trim(roomArray__a(0))&""
				if arya_="" then arya_=0
				roomArray__b=split(aryb&"","=>")
				aryb_=trim(roomArray__b(0))&""
				if aryb_="" then aryb_=0
				If cdbl(arya_) > cdbl(aryb_) Then 
					FirstValue = ary(ss) 
					SecondValue = ary(ss+1) 
					ary(ss) = SecondValue 
					ary(ss+1) = FirstValue					
					KeepChecking = TRUE 
				End If 
			Next 
		Loop 
	doroomSort = ary 
End Function 
function sortroomlist(byval roomlist__)
	resultroom="":ishascheck=false
	if right(roomlist__,2)=vbcrlf then roomlist__=left(roomlist__,len(roomlist__)-2)	
	for each roomitem_ in doroomSort(split(roomlist__&"",vbcrlf))
		roomArray__=split(roomitem_&"","=>")
		if ubound(roomArray__)>=1 then
			roominfo=trim(roomArray__(1))
			if not ishascheck then
				roominfo=replace(roominfo,"type='radio'","type='radio' checked='checked' ")
				ishascheck=true
			end if			
			resultroom=resultroom&roominfo
		end if
	next
	sortroomlist=resultroom
end function
function Get_r_remark(remark)
	if remark<>"" then
		Get_r_remark="("&remark&")"
	else
		Get_r_remark=""
	end if
end function
function getserverRoom(byval productid)
	result="--系统默认--"
	commandstr="other" & vbcrlf & _
			   "get" & vbcrlf & _
			   "entityname:server_roomlist"& vbcrlf & _
			   "productid:" & productid & vbcrlf & _
				"." & vbcrlf

	 returnstr=pcommand(commandstr,"AgentUserVCP")
	 if left(returnstr,3)="200" then	 		
		result= getReturn_rrset(returnstr,"roomlist")
	 end if
	 getserverRoom=result
end function

Public Function createRnd(n1)
    Call Randomize(Timer)
    Dim a1,a2,aa,i 
    a1 = "abcdefghkmnpqrstuvwxyz": a2 = "23456789"
    For i = 1 To n1
        If i Mod 2 = 0 Then aa = a2 Else aa = a1
        createRnd = createRnd & Mid(aa, Int(Rnd * Len(aa)) + 1, 1)
    Next
End Function

Sub htmlEnCode_(strng)
	strng = strng & ""
	strng = Replace(strng,"<","&lt1;")
	strng = Replace(strng,">","&gt1;")
	strng = Replace(strng,"'","&#391;")
	strng = Replace(strng,"""","&quot1;")
	strng = Replace(strng," ","&nbsp1;")
	strng = Replace(strng,vbcrlf,"<br />")
End Sub
Sub htmlDeCode_(strng)
	strng = strng & ""
	strng = Replace(strng,"&lt1;","<")
	strng = Replace(strng,"&gt1;",">")
	strng = Replace(strng,"&#391;","'")
	strng = Replace(strng,"&quot1;","""")
	strng = Replace(strng,"&nbsp1;"," ")
End Sub

function doUserSyn_vps(byval p_proid,byval isprice)
		fiedlist="v_room,v_monthprice,v_seasonprice,v_halfyearprice,v_yearprice,room_isstop,month_isstop,season_isstop,halfyear_isstop,year_isstop,flux_month"		
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:tmptablecontent" & vbcrlf
		optCode=optCode & "tbname:vps_price" & vbcrlf
		optCode=optCode & "tbproid:"& p_proid & vbcrlf
		optCode=optCode & "fieldlist:"&fiedlist& vbcrlf & "." & vbcrlf		
		retCode=Pcommand(optCode,"AgentUserVCP")
		'response.Write(retCode)
		if left(retcode,3)="200" then
			fieldlist_=getReturn(retcode,"fieldlist")
			recordset_=getReturn_rrset(retcode,"recordset")
			fieldlistArr=split(fieldlist_,",")
			recordsetArr=split(recordset_,"$")
			for i=0 to ubound(recordsetArr)
				recordsetitem=trim(recordsetArr(i))
				if recordsetitem<>"" then				
					recordsetItemArr=split(recordsetitem,"~|~")
					for ii=0 to ubound(recordsetItemArr)
						key=trim(fieldlistArr(ii))
						val=trim(recordsetItemArr(ii))
						'if key<>"" And checkRegExp(key,"^[\w]+$") then
							execute "g_"&key&"=val"
						'end if
					next		
					sql="select * from vps_price where v_room="& g_v_room &" and p_proId='"& p_proid &"'"
					rs1.open sql,conn,1,3
				'	call sys_roomname_(g_v_room,p_proid)
					if rs1.eof then
						rs1.addnew()
						rs1("v_room")=g_v_room	
						rs1("p_proId")=p_proid
						isprice=true								
					end if
					if isprice then
						rs1("v_monthprice")=g_v_monthprice
						rs1("v_seasonprice")=g_v_seasonprice
						rs1("v_halfyearprice")=g_v_halfyearprice
						rs1("v_yearprice")=g_v_yearprice	
					end if
						if g_flux_month="" or not isnumeric(g_flux_month) then g_flux_month=0
						rs1("room_isstop")=iif(isdbsql,iif(g_room_isstop=-1,1,g_room_isstop),g_room_isstop) 'g_room_isstop
						rs1("month_isstop")=iif(isdbsql,iif(g_month_isstop=-1,1,g_month_isstop),g_month_isstop) 'g_month_isstop
						rs1("season_isstop")=iif(isdbsql,iif(g_season_isstop=-1,1,g_season_isstop),g_season_isstop)  'g_season_isstop
						rs1("halfyear_isstop")=iif(isdbsql,iif(g_halfyear_isstop=-1,1,g_halfyear_isstop),g_halfyear_isstop)  'g_halfyear_isstop
						rs1("year_isstop")=iif(isdbsql,iif(g_year_isstop=-1,1,g_year_isstop),g_year_isstop)  'g_year_isstop
						rs1("flux_month")=g_flux_month
						rs1.update()
					rs1.close
					
				end if
			next
			
		end if
end function


'缓存数据表
function set_cache_table(byval roomid,byval proid,byref val)
set cache_rs=Server.CreateObject("adodb.recordset")
cache_name="serverroominfocache_"& proid & "_" & roomid
sql="select top 1 name,value,type,addTime from cache_app where name='"&cache_name&"'"
cache_rs.open sql,conn,1,3
   '缓存不存在
	if cache_rs.eof then
    cache_rs.addnew
	cache_rs("name")=cache_name
	end if
	cache_rs("addTime")=now()
	cache_rs("value")=val
	cache_rs("type")="vps"
	cache_rs.update
	cache_rs.close()
set cache_rs=nothing

end function

function get_cache_table(byval roomid,byval proid)
cache_name="serverroominfocache_"& proid & "_" & roomid
set cache_rs=conn.execute("select name,value,type from cache_app  where name='"&cache_name&"'")
	if cache_rs.eof then
	get_cache_table=null
	else
	get_cache_table=cache_rs(1)
	end if
end function


 

function getroomname_(byval roomid,byval proid,byref commandresult)
	isincache=false
	commandresult=""
	'serverroomcache=application("serverroominfocache_"& proid & "_" & roomid)&""
	serverroomcache=get_cache_table(roomid,proid)
	if not isnull(serverroomcache) then
	cacheArray=split(serverroomcache,"~|^")
	commandresult=chgroomName(trim(cacheArray(1)))  '替换机房
	else
	commandstr="other" & vbcrlf & _
					   "get" & vbcrlf & _
					   "entityname:get_roomlistname"& vbcrlf & _
					   "roomid:" & roomid & vbcrlf & _
					   "toproidlist:" & proid & vbcrlf & _
						"." & vbcrlf
			 commandresult=pcommand(commandstr,"AgentUserVCP")			 
			 if left(commandresult,3)="200" then
				appstrs=now & "~|^" & commandresult
				'application.Lock()
				'application("serverroominfocache_"& proid & "_" & roomid)=appstrs
				call set_cache_table(roomid,proid,appstrs)
			'	application.UnLock()
			 end if
	
	end if
	'if ubound(cacheArray)>=1 then
'		if isdate(trim(cacheArray(0))) then
'			if datediff("h",trim(cacheArray(0)),now())>=24 then
'				isincache=true
'			else
				
'			end if
'		else
'			isincache=true
'		end if
'	else
'		isincache=true
'	end if
	'if isincache then
'		if isnumeric(roomid) and roomid&""<>"" then
'			commandstr="other" & vbcrlf & _
'					   "get" & vbcrlf & _
'					   "entityname:get_roomlistname"& vbcrlf & _
'					   "roomid:" & roomid & vbcrlf & _
'					   "toproidlist:" & proid & vbcrlf & _
'						"." & vbcrlf
'			 commandresult=pcommand(commandstr,"AgentUserVCP")			 
'			 if left(commandresult,3)="200" then
'				appstrs=now & "~|^" & commandresult
'				'application.Lock()
'				'application("serverroominfocache_"& proid & "_" & roomid)=appstrs
'				call set_cache_table(roomid,proid,appstrs)
'			'	application.UnLock()
'			 end if
'			 	
'		 else
'			result=roomid
'		 end if
'	end if
	result= getReturn(commandresult,"roomlist")
	getroomname_=result
end function

function getDomUpReg(domain)
	dim cmdinfo,retCode
	if not isdomain(domain) then exit function
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_reg" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
		
	retCode=connectToUp(cmdinfo)
	if left(retCode,4)="200 " then
		getDomUpReg=lcase(left(mid(retCode,5),5))
	end if
end function

'2012-8-16
'数字反回，非数字反加0
function chk_ly_num(str)
     If  IsNumeric(str)=False Or IsNull(str)  Then
			chk_ly_num=0
			Else
			chk_ly_num=str
			End If
end function
'得到虚机独立IP
function getOtherip(byval s_comment,byval u_name)
		commandstr="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:getotherip"& vbcrlf & _
				   "ftpuser:"& s_comment & vbcrlf & _				  			   
				   "." & vbcrlf		 
		 getOtherip=pcommand(commandstr,u_name)		
end function
'得到虚机独立IP
function getOtherssl(byval s_comment,byval u_name)
		commandstr="other" & vbcrlf & _
				   "get" & vbcrlf & _
				   "entityname:getotherssl"& vbcrlf & _
				   "ftpuser:"& s_comment & vbcrlf & _				  			   
				   "." & vbcrlf		 
		 getOtherssl=pcommand(commandstr,u_name)		
end function
'20128-30
'js新闻转换
function tpl_getnewslist(ArrayList)
dim tpl_array,tpl_num,tpl_lenstr,tpl_temp
tpl_array=split(ArrayList,",")
if ubound(tpl_array)<1 then
'错误参数据返回空
tpl_getnewslist=""
else
tpl_num=tpl_array(0)
tpl_lenstr=tpl_array(1)
if not isNumeric(tpl_num) then tpl_num=5
if not isNumeric(tpl_lenstr) then tpl_lenstr=40


tpl_sql="select top "&tpl_num&" newstitle,newpubtime,newsid from news where  newsshow =0 order by newsid desc"
'response.Write(tpl_sql)
set tpl_rs=conn.execute(tpl_sql)
do while not tpl_rs.eof

tpl_temp=tpl_temp&"<table width='97%' border=0 cellpadding=0 cellspacing=0><tr><td><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td width='22%'><img src=/images/Default_90.gif width=39 height=11></td><td width='78%'>"&left(tpl_rs("newpubtime"),len(tpl_rs("newpubtime"))-8)&"</td></tr></table></td></tr><tr><td><a href='/news/list.asp?newsid="&tpl_rs("newsid")&"'>"&gotTopic(tpl_rs("newstitle"),clng(tpl_lenstr))&".</a><table width=100% border=0 cellspacing=0 cellpadding=0><tr><td background=/images/Default_98.gif><img src=/images/Default_98.gif width=2 height=1></td></tr></table></td></tr></table>" & vbCrLf
tpl_rs.movenext
loop


tpl_getnewslist=tpl_temp
end if


end Function


function getDateTimeNumber()
    dingdan=now()
	dingdan=replace(trim(dingdan),"-","")
	dingdan=replace(dingdan,":","")
	dingdan=replace(dingdan," ","")
	dingdan=replace(dingdan,"AP","")
	dingdan=replace(dingdan,"PM","")
	dingdan=replace(trim(dingdan),"上午","")
	dingdan=replace(trim(dingdan),"下午","")
getDateTimeNumber=dingdan
end function

function check_is_masterlogin()
 if(session("u_type")="" or IsNull(session("u_type"))) then
  	if not check_is_cookie then
		Alert_Redirect "对不起，您还没有登陆或者闲置时间太久了，请重新登陆！","/default.asp"
	end if
  end if
end function


'2012-10-22
'快速登陆添加
function getQuickLogin()

isQuickLogin=false
    '判断是否登陆
	if len(session("user_name"))>0 then
    getQuickLogin="<div id=""quickLink"">       <UL>          <br>        </UL>      </div>"	
	else
	
	getQuickLogin="<div style=""clear:both; line-height:35px;height:35px; color:#666;width:640px;float:right;""><span style=""display:block;height:35px;line-height:35px; width:70px; float:left;"">快速登录：</span>"
	
	if alipaylog then
	getQuickLogin=getQuickLogin&"<a href=""/reg/alipaylog.asp"" target=""_blank""><img src=""/images/alipay_button.gif""  align=""absmiddle"" style=""margin-top:5px;""  /></a>"
	isQuickLogin=true
	end if
	
	if qq_isLogin then
	getQuickLogin=getQuickLogin&"&nbsp;&nbsp;<a href=""#"" onclick='toQzoneLogin()'><img src=""/images/qq_login.png"" border=""0""  align=""absmiddle"" style=""margin-top:5px;""></a><script type=""text/javascript"">	var childWindow;	function toQzoneLogin()	{		childWindow = window.open(""/reg/redirect.asp"",""TencentLogin"",""width=450,height=320,menubar=0,scrollbars=1, resizable=1,status=1,titlebar=0,toolbar=0,location=1"");	} 		function closeChildWindow()	{		childWindow.close();window.location.reload()	}</script>"
	isQuickLogin=true
	 end if
	 if isQuickLogin then
	 getQuickLogin=getQuickLogin&"</div>"
	 else
	 getQuickLogin=" <div id=""quickLink"">       <UL>          <br>        </UL>      </div>"
	 end if
	end if
end function


function   checkip(checkstring)'用正则判断IP是否合法
dim   re1
set   re1=new   RegExp
re1.pattern="^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$"
re1.global=false
re1.Ignorecase=false
checkip=re1.test(checkstring)
set   re1=nothing
end   function


function   get_cli_ip()'取真实IP函数，先 HTTP_CLIENT_IP 再 HTTP_X_FORWARDED_FOR 再 REMOTE_ADDR
dim client_ip
if checkip(Request.ServerVariables("HTTP_CLIENT_IP"))=true then
         get_cli_ip = checkip(Request.ServerVariables("HTTP_CLIENT_IP"))
else
         MyArray = split(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),",")
         if ubound(MyArray)>=0 then
                   client_ip = trim(MyArray(0))
                   if checkip(client_ip)=true then 
                            get_cli_ip = client_ip
                            exit function
                   end if
         end if
         get_cli_ip = Request.ServerVariables("REMOTE_ADDR")
end if
end   function




'JSon数据返回处理
Dim scriptCtrl
Function parseJSON(str)
If Not IsObject(scriptCtrl) Then
Set scriptCtrl = Server.CreateObject("MSScriptControl.ScriptControl")
scriptCtrl.Language = "JScript"
scriptCtrl.AddCode "function ActiveXObject() {}" ' 覆盖 ActiveXObject
scriptCtrl.AddCode "function GetObject() {}" ' 覆盖 ActiveXObject
scriptCtrl.AddCode "Array.prototype.get = function(x) { return this[x]; }; var result = null;"
End If
  On Error Resume Next
'  jsontemp=split(str,chr(10))
 ' str=jsontemp(1)
 ' die ubound(jsontemp)
  
scriptCtrl.ExecuteStatement "result = " & str & ";"
Set parseJSON = scriptCtrl.CodeObject.result
  If Err Then
Err.Clear
Set parseJSON = Nothing
  End If
End Function



function getapplication_txt(byval name_)
	appresult=""
	appfilepath="/database/application/application_"& name_ &".txt"
	set appfso=server.CreateObject("Scripting.FileSystemObject")
	filepath=server.MapPath(appfilepath)
	if appfso.fileexists(filepath) then
		Set OutStream1 = appfso.OpenTextFile(filepath)
			appresult = OutStream1.ReadAll
		set OutStream1=nothing
	end if
	set appfso=nothing
	getapplication_txt=appresult
end function
function setapplication_txt(byval name_,byval val_)
	appfolderpath="/database/application"
	set appfso=server.CreateObject("Scripting.FileSystemObject")
	folderpath=server.MapPath(appfolderpath)
	filepath=folderpath&"/application_"& name_ &".txt"
	if datediff("n",date&" 22:00:00",now)>=0 then'删除老文件
		if appfso.folderexists(folderpath) then
			Set erasefolder=appfso.getfolder(folderpath)
			for each file_ in erasefolder.files
				if left(file_.name,12)="application_" and right(file_,4)=".txt" then
					if datediff("d",file_.dateCreated,now)>30 then  
						file_.delete true
					end if
				end if
			next	
			Set erasefolder=nothing
		end if
	end if
	if trim(val_)&""="" then
		if appfso.fileexists(filepath) then
			Set erasefile=appfso.getfile(filepath)
				erasefile.delete true
			set erasefile=nothing
		end if
	else
		Set objHander=appfso.openTextFile(filepath,2,true)
		objHander.write(val_)
		objHander.close:Set objHander=nothing		
	end if	
	set appfso=nothing
	setapplication_txt=val_
end function

'获取转入价格
function getDnameTransfer(proid,leve)
getDnameTransfer=99999
set grs=conn.execute("select * from pricelist where p_proid='"&proid&"' and p_u_level="&leve&"")
if grs.eof then
getDnameTransfer=999999
else
  if trim(grs("Transfer"))="" or cdbl(grs("Transfer"))=0 then
     if trim(grs("p_price_renew"))="" or cdbl(grs("p_price_renew"))=0 then
	 getDnameTransfer=grs("p_price")
	 else
	 getDnameTransfer=grs("p_price_renew")
	 end if    
  else
  getDnameTransfer=grs("Transfer")
  end if
   
end if
grs.close
end function

'域名获取转入价格
function getDnametjg(dname)
dtype=GetDomainType(dname)
'die dtype&","&session("u_level")
getDnametjg=getDnameTransfer(dtype,session("u_levelid"))
end function

function Domaintransferinfo(u_id)
    Domaintransferinfo=false
	if u_id>0 then
	   sql="select strDomain from domainlist where tran_state<>5 and userid="&u_id
	else
	   sql="select strDomain from domainlist where tran_state<>5"
	end if
	set drs=conn.execute(sql)
	strDomain=""
	do while not drs.eof
	 if trim(strDomain)="" then
	 strDomain=drs(0)
	 else
	 strDomain=strDomain&","&drs(0)
	 end if
	drs.movenext
	loop
	if strDomain="" then  exit function
	strCmd="domainname"&vbcrlf&_
	       "transfer"&vbcrlf&_
		   "entityname:status"&vbcrlf&_
		   "domain:"&strDomain&vbcrlf&_
		   "."&vbcrlf
		   
	 loadRet=connectToUp(strCmd)
	'  response.Write(loadRet)
	  
	'  die str&"<hr>"
	  if left(loadRet,3)=200 then
	  str=mid(loadRet,instr(loadRet,"recordset:")+10,len(loadRet))
	  stra=split(str,vbcrlf&"$")
		  for i=0 to ubound(stra)-1
		  dstr=split(stra(i),"~|~")
		  
		  select case clng(dstr(1))
		  case 5   '操作成功添加1年时间		 
		    sql="update domainlist set tran_state="&dstr(1)&",rexpiredate=dateDiff("&PE_DatePart_Y&",1,rexpiredate),years=years+1 where strDomain='"&dstr(0)&"'"
		  case 14  '转移失败退款并删除域名
		    If isdbsql Then
				sql="delete from domainlist where isnull(tran_state,0)>0 and  strDomain='"&dstr(0)&"'"
			else
				sql="delete from domainlist where iif( isnull(tran_state),0,tran_state)>0 and  strDomain='"&dstr(0)&"'"
		    End if
			 dname=dstr(0)    '转入域名
			 dPrice=getDnametjg(dname)    '转入价格
			  '转入域名扣费操作
			
			set c_rs=conn.execute("select strDomain,userid from domainlist where strDomain='"&dstr(0)&"'")

			if c_rs.eof then
				call addRec("域名【"&dname&"】转入失败,",",未退款给用户("&-dPrice&"),没有找到记录")
			else
				call consume(GetUserName(c_rs("userid")),-dPrice,false,"transfer_err("&dname&")","域名["&dname&"]转入失败退费",GetDomainType(dname),"")
				call addRec("域名【"&dname&"】转入失败,",",已退款("&-dPrice&")给用户,并删除数据库记录")
			end if
			c_rs.close
		  case else
         sql="update domainlist set tran_state="&dstr(1)&" where strDomain='"&dstr(0)&"'"
		  end select
 		  conn.execute(sql)		  
		  next  
		  Domaintransferinfo=true    
	  else
	  
	  end if
end function

function getdiymailconfig()
	if trim(application("mail_diy_config_sj"))="" or trim(application("mail_diy_config"))="" then

		application("mail_diy_config")=trim(GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp?act=diymail"))
		application("mail_diy_config_sj")=now()
		else
		 
		if datediff("s",application("mail_diy_config_sj"),now())>0 then
		
		application("mail_diy_config")=trim(GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp?act=diymail"))
		application("mail_diy_config_sj")=now()
		end if
    end if		
		getdiymailconfig=application("mail_diy_config")
end function

function mymailzk()
 select case trim(session("u_levelid"))
 case "1"
 mymailzk=diyMlev1
 case "2"
 mymailzk=diyMlev2
 case "3"
 mymailzk=diyMlev3
 case "4"
 mymailzk=diyMlev4
 case "5"
 mymailzk=diyMlev5
 case else
 mymailzk=diyMlev1
 end select
end function
'获取diy邮局大小
function getDiyMailprice(mailsize,mailnum)
	getDiyMailprice=999999999
	if isnumeric(mailsize) and  isnumeric(mailnum) then
		str=","&getdiymailconfig&","
		reg=","&mailsize&":([\d]+),"
		 DiyMailprice=myinstr(str,reg)
		 if isnumeric(DiyMailprice) then
		  getDiyMailprice=clng(DiyMailprice)*mymailzk()*mailnum
		 end if
	end if
end function

'单价检查*年限检查余额
function CheckEnoughMoneydiy(CustomerName,Money,BuyYears,UseCoupons)
	CheckEnoughMoneydiy=false
	set u_rs=server.CreateObject("adodb.recordset")
	u_sql="select u_usemoney,u_premoney from UserDetail where u_name='"&CustomerName&"'"
	u_rs.open u_sql,conn,1,3
	if u_rs.eof or u_rs.bof then
		CheckEnoughMoneydiy=false
		exit function
	else
		u_usemoney=u_rs("u_usemoney")
		u_premoney=u_rs("u_premoney")
	end if
	u_rs.close
	set u_rs=nothing
	NeedMoney=Money*BuyYears

	if UseCoupons then
		u_usemoney=u_usemoney+u_premoney
	end if
	if ccur(u_usemoney)<ccur(NeedMoney) then
		CheckEnoughMoneydiy=false
	else
		CheckEnoughMoneydiy=true
	end if
end function


function formatSizeText(byval sizeNum)
		if sizeNum<>"" and isnumeric(sizeNum) then
			sizeNum=clng(sizeNum)
			if sizeNum>=1048576 then
				sizeNum=round(sizeNum/1024/1024,2) & "T"
			elseif sizeNum>=1024 then
				sizeNum=round(sizeNum/1024,2) & "G"
			elseif sizeNum<1 then
				sizeNum=round(sizeNum*1024,2) & "K"
			else
				sizeNum=round(sizeNum,2) & "M"
			end if
		end if
		formatSizeText=sizeNum
	end function



function getAudit(Au)
        select case clng(Au)
		  case "0"
			 Explain="待上传资料"
		  case"1"
			 Explain="资料审核中"
		  case "2"
			 Explain="资料被拒绝"
		  case "3"
			 Explain="域名审核中"
		  case "4"
			 Explain="域名被拒绝"
		  case "5"
			 Explain="等待备案"
		  case "6"
			 Explain="正常使用"
		  case else
		     Explain="可能删除"
	   end select
	   getAudit=Explain
end function

'生成签名密码
function WestSignMd5(byval yw_N,byval yw_P)
	useNowPage = "http://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("PATH_INFO")
   ' sign_tempstr=api_username&api_password&useNowPage&yw_N&yw_P
	if ishttps() then
		useNowPage = "https://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("PATH_INFO")
	end if
    sign_tempstr=yw_N & useNowPage & yw_P
	'response.write sign_tempstr&"<BR>"
	WestSignMd5=asp_md5(sign_tempstr)
end Function


function WestSing(byval yw_N,byval yw_p,byval yw_i)
	useNowPage = "http://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("PATH_INFO")
	if ishttps() then
		useNowPage = "https://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("PATH_INFO")
	end if
	sign_tempstr=api_username&yw_N & useNowPage & yw_P&yw_i
	WestSing=asp_md5(sign_tempstr)
end function

function Add_Event_logs(u,t,n,e)
't 0--vhost ,1--domain ,2 mail ,3 ---server ,4---db, 5--money

conn.execute("insert into Event_logs(e_uname,e_type,ywname,e_Event,e_addtime) values('"&u&"',"&t&",'"&n&"','"&e&"','"&now()&"')")
end function

function add_shop_cart(u_id,ywtype_,ywname_,strContents_)
add_shop_cart=false
ischeckcart=true
if instr("domain,vhost,mail,mssql",ywtype_)>0 then
cartincount=conn.execute("select count(*) from ShopCart where userid="&u_id&" and ywtype='"&ywtype_&"' and ywname='"&ywname_&"' and s_status=0")(0)
	if clng(cartincount)>0 then
	ischeckcart=false
	exit function
	end if
end if

if ischeckcart then
sql="insert into ShopCart(userid,sessionid,ywtype,ywname,cartContent) values("&u_id&",'','"&ywtype_&"','"&ywname_&"','"&strContents_&"')" 
conn.execute(sql)
add_shop_cart=true
end if
end function

function del_shop_car(u_id,byval cartid)
conn.execute("delete from ShopCart where userid="&u_id&" and cartid="&cartid)
end function

function update_shopcar(byval cartid,byval return_msg,byval s_stuatus)
sql="select top 1 * from ShopCart where cartid="&cartid
rs.open sql,conn,1,3
if not rs.eof then
	rs("return_msg")=return_msg
	rs("s_status")=s_stuatus
	rs.update
end if
rs.close()
end function

Function ToUnixTime(strTime, intTimeZone)        
    If IsEmpty(strTime) or Not IsDate(strTime) Then strTime = Now        
    If IsEmpty(intTimeZone) or Not isNumeric(intTimeZone) Then intTimeZone = 0        
     ToUnixTime = DateAdd("h",-intTimeZone,strTime)        
     ToUnixTime = DateDiff("s","1970-1-1 0:0:0", ToUnixTime)        
End Function
Function FromUnixTime(intTime, intTimeZone)        
    If IsEmpty(intTime) Or Not IsNumeric(intTime) Then       
         FromUnixTime = Now()        
        Exit Function       
    End If       
    If IsEmpty(intTime) Or Not IsNumeric(intTimeZone) Then intTimeZone = 0        
     FromUnixTime = DateAdd("s", intTime, "1970-1-1 0:0:0")        
     FromUnixTime = DateAdd("h", intTimeZone, FromUnixTime)        
End Function

'2015-7-31
function getmssqlver(byval rid)
		commandstr="other" & vbcrlf & _
			   "get" & vbcrlf & _
			   "entityname:mssqlver"& vbcrlf & _
			   "roomid:" & rid & vbcrlf & _
			   "." & vbcrlf 
		returnstr=pcommand(commandstr,"AgentUserVCP")

		 
 	    if left(returnstr,6)="200 ok" then
		getmssqlver=mid(returnstr,7,len(returnstr))
		else
		getmssqlver=""
		end if

end function



function setmysqlList(roomid,productid00,osver)'设置机房的下拉菜单

		Xcmd= "other" & vbcrlf
		Xcmd=Xcmd & "get" & vbcrlf
		Xcmd=Xcmd & "entityname:mysqlver" & vbcrlf
		Xcmd=Xcmd & "productid:"&productid00 & vbcrlf
		Xcmd=Xcmd & "roomid:"&roomid& vbcrlf
		Xcmd=Xcmd & "osver:"&osver& vbcrlf
		Xcmd=Xcmd & "." & vbcrlf
	 if lcase(USEtemplate)="tpl_2016" then
		mysqlstring="<select name=""pmver"" class=""common-select std-width common-validate"">"
	 else
		mysqlstring="<select name=""pmver"">"
	 end if
	 mysqlstring=mysqlstring & "<option value="""" >默认值</option>" & vbcrlf  
	 returnstr=pcommand(Xcmd,"AgentUserVCP")
	 if left(returnstr,3)="200" then
 		mysqllist = mid(returnstr,4)
		
		for each mysqlver in split(mysqllist,",") 
					 mysqlstring=mysqlstring & "<option value="""& trim(mysqlver) & """ >"& trim(mysqlver) & "</option>" & vbcrlf  
		next
	 end if
     mysqlstring=mysqlstring& "</select>"
   	 setmysqlList=mysqlstring
end function


'Call SetHttpOnlyCookie("cookieOnly1","onlyValue","","/",now()+10)
Function SetHttpOnlyCookie(cookieName,cookieValue,domain,path,expDate)
	Dim cookie
	cookie=cookieName & "=" & Server.URLEncode(cookieValue) & "; path=" & path
	If expDate <> 0 Then
	cookie=cookie & "; expires=" & DateToGMT(expDate)
	End If 
	If domain <> "" Then
	cookie=cookie & "; domain=" & domain
	End If 
	cookie=cookie & "; HttpOnly" 
	Call Response.AddHeader ("Set-Cookie", cookie)
End Function
'————-getGMTTime————
'参数: sDate 需要转换成GMT的时间
'———————————
Function DateToGMT(sDate)
	Dim dWeek,dMonth
	Dim strZero,strZone
	strZero="00"
	strZone="+0800"
	dWeek=Array("Sun","Mon","Tue","Wes","Thu","Fri","Sat")
	dMonth=Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	DateToGMT = dWeek(WeekDay(sDate)-1)&", "&Right(strZero&Day(sDate),2)&" "&dMonth(Month(sDate)-1)&" "&Year(sDate)&" "&Right(strZero&Hour(sDate),2)&":"&Right(strZero&Minute(sDate),2)&":"&Right(strZero&Second(sDate),2)&" "&strZone
End Function

function ishttps()
	ishttps=false
	if lcase(request.servervariables("HTTPS"))="on" or lcase(request.servervariables("HTTP_FROM_HTTPS")&"")="on" or lcase(request.servervariables("HTTP_X_CLIENT_SCHEME")&"")="https" then
		ishttps=true
	end if

end function

Function IIF(express, rYes, rNo)
	IIF = rNo
	If VarType(express)=11 Or CStr(express)="True" Then
		If express Then IIF=rYes
	End If
End Function

function echojson(byval code,byval msg,byval otherjson)
	dim result
	result="{""result"":"""& code &""",""msg"":"""& jsencode_min(msg) &""""& otherjson &"}"
	echojson=result
end function
function jsencode_more(byval fString)
	fstring=trim(fstring)&""
	if fString&""<>"" then
		fString = replace(fString, chr(9), " ")
		fString = Replace(fString, chr(32), "  ")
		fString = Replace(fString, CHR(10), " ")
		fString = Replace(fString, CHR(13), " ")		
		fString = Replace(fString,";", "\;")
		fString = Replace(fString,"\", "\\")
		fString = Replace(fString,"""", "\""")
		fString = Replace(fString,"'", "\'")
		fString = Replace(fString,"[", "\[")
		fString = Replace(fString,"]", "\]")
		fString = Replace(fString,"{", "\{")
		fString = Replace(fString,"}", "\}")
		jsencode_more=fString
	else
		jsencode_more=""
	end if
end Function
function jsencode_min(byval fString)
	fstring=trim(fstring)&""
	if fString&""<>"" then
		fString = Replace(fString, CHR(10), " ")
		fString = Replace(fString, CHR(13), " ")	
		fString = Replace(fString, CHR(9), " ")
		fString = Replace(fString,"\", "\\")
		fString = Replace(fString,"""", "\""")
		fString = Replace(fString,"'", "\'")
		jsencode_min=fString
	else
		jsencode_min=""
	end if
end function
function Arrpush_js(byval lineArr,byval arritem)'支持多维数组
	dim thisindex
	if typename(lineArr)<>"Variant()" then lineArr=array()		
	thisindex=ubound(lineArr)+1:ReDim Preserve lineArr(thisindex)	
	if typename(arritem)="Dictionary" then			
		set lineArr(thisindex)=arritem	
	else		
		lineArr(thisindex)=arritem
	end if	
	Arrpush_js=lineArr
end function
function Arrpush(byref lineArr,byval arritem)'如果两个数组则返回一个一维数组
	dim thisindex,arritem_,lineArr_
	if typename(lineArr)="JScriptTypeInfo" then 
		lineArr_=array()	
		for each arritem_ in lineArr			
			call Arrpush(lineArr_,arritem_)
		next
		lineArr=lineArr_
	end if	
	if typename(lineArr)<>"Variant()" then lineArr=array()		
	if typename(arritem)="Dictionary" then	
		thisindex=ubound(lineArr)+1:ReDim Preserve lineArr(thisindex)		
		set lineArr(thisindex)=arritem
	elseif  typename(arritem)="Variant()" or typename(arritem)="JScriptTypeInfo" then		
		for each arritem_ in arritem			
			thisindex=Arrpush(lineArr,arritem_)
		next
	else
		thisindex=ubound(lineArr)+1:ReDim Preserve lineArr(thisindex)		
		lineArr(thisindex)=arritem
	end if	
	Arrpush=thisindex
end function
function instrArr(byval arr,byval val)'查询数组(和instr一样)，0：没找到,>=1：找到的第几个
	dim result,it,farr
	result=0
	farr=filter(arr,val)
	for it=0 to ubound(farr)
		if trim(farr(it))=val then
			result=it+1
			exit for
		end if
	next
	instrArr=result
end function
Function evaljson(strjson) '将json字串解析为json对象
	On Error Resume Next : Err.clear
	Dim obj:Set obj = CreateObject("MSScriptControl.ScriptControl")
	obj.Language = "JScript"  
	obj.ExecuteStatement "var result=" & strjson & ";"
	Set evaljson = obj.CodeObject.result
	Set obj=Nothing
	If Err.number <> 0 Then Set evaljson=Nothing
End Function
%>
<script language="JScript" runat="server" >
	function jsontodic(s){	
		var jsoneach=function(json){
			 var dic=Server.CreateObject("Scripting.Dictionary");	
			 var arr=dic.Keys();	 	
			 if(Object.prototype.toString.call(json) === "[object Array]"){	
				for(var o in json){							
					if(typeof json[o]=="object"){											
						arr=Arrpush_js(arr,jsoneach(json[o]));												
					}else{
						arr=Arrpush_js(arr,json[o]);
					}
				}	
				return arr;	
			 }else{			 	
				 for(var o in json){
					if(typeof json[o]=="object"){	
						if(json[o]==null){						
							dic.add(o,null);
						}else{
							dic.add(o,jsoneach(json[o]));
						}
					}else{
						dic.add(o,json[o]);
					}
				 }		
				 return dic;
			 }			 
		}
		return jsoneach(evaljson(s));    
	   // return dic
	}
	function getTimer(){//取1970时间戳
		var d = new Date();
		return d.getTime();
	}
</script>
<%
function dicTojson(byval dicData,byval echostr)'zxw 字典转json ,外层首次调用echostr传空
	dim dic_key,isarr
	isarr=(isArray(dicData) Or isJScriptTypeInfo(dicData))
	if echostr="" then
		if isarr  then echostr="[" else echostr="{"
	end if
	if isarr then
		for each dic_key in dicData	
			'if VarType(dic_key)=8 or VarType(dic_key)=3  then				
			if isArray(dic_key) Or isJScriptTypeInfo(dic_key) then
				echostr=echostr&dicTojson(dic_key,"[")&","	
			elseif IsObject(dic_key) then	
				echostr=echostr&dicTojson(dic_key,"{")&","
			else
				echostr=echostr & """" & jsencode_min(dic_key)&""","
			end if					
		next
	else
		for each dic_key in dicData.keys	
			dic_key=jsencode_min(dic_key)
			if isArray(dicData(dic_key)) Or isJScriptTypeInfo(dicData(dic_key)) then
				echostr=echostr&dicTojson(dicData(dic_key),""""&trim(dic_key)&""":["	)&","
			elseif IsObject(dicData(dic_key)) then	
				echostr=echostr&dicTojson(dicData(dic_key),""""&trim(dic_key)&""":{"	)&","
			else
				echostr=echostr & """" & trim(dic_key)&""":"""& jsencode_min(dicData(dic_key)) &""","		
			end if
		next
	end if
	if right(echostr,1)="," then echostr=left(echostr,len(echostr)-1)
	if isarr then echostr=echostr&"]" else echostr=echostr&"}"	
	dicTojson=echostr
end Function
function isJScriptTypeInfo(byval str)
	isJScriptTypeInfo=false
	if vartype(str)=9 then
		if TypeName(str)="JScriptTypeInfo" then
			isJScriptTypeInfo=true			
		end if
	end if
end function

'是否要重新认证
function isrenauthmobile(byval u_id_,byval mobile_)
	isrenauthmobile=false
	if isnumeric(u_id_&"") then 
		sql="select count(1) from userdetail where u_id="&u_id_&" and msn_msg='"&trim(mobile_)&"'"
		if clng(conn.execute(sql)(0))=0 then
			isrenauthmobile=true
		end if
	end if
end function

function md5_32(byval str_)
	dim M
    Set M = New Md5class 
	md5_32 = M.MD5(str_)
	set M = nothing
end function


function getfirstrstodic(byval rs_)
	set getfirstrstodic=newoption()
	if not rs_.eof then
		for z=0 to rs_.Fields.Count-1
			fieldsname=lcase(rs_.Fields(z).Name)			
			getfirstrstodic.add fieldsname,trim(rs_(z))			
		next
	end if
 
end function
'类型转字典
function getrstodic(byval rs_)
	set getrstodic=newarray()
	do while not rs_.eof
		set tmpdic=newoption()
		for z=0 to rs_.Fields.Count-1
			fieldsname=lcase(rs_.Fields(z).Name)			
			tmpdic.add fieldsname,trim(rs_(z))			
		next
		getrstodic.push(tmpdic)
		set tmpdic=nothing
	rs_.movenext
	loop	
 
end Function


function setloastdmid(idname,id)
	setloastdmid=id
	xmlpath=server.mappath("/database/data.xml")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobject=isnodes("pageset","loastsynid",xmlpath,1,objDoms)
	set mytype=myobject.selectSingleNode("@"&idname)
	'if mytype is nothing then
			myobject.setAttribute idname,id
			objDoms.save(xmlpath)
	'end if
	set myobject=nothing
	set objDoms=Nothing
	'isDatenow=true
end function

function getloastdmid(idname)
	getloastdmid="0"
	xmlpath=server.mappath("/database/data.xml")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobject=isnodes("pageset","loastsynid",xmlpath,1,objDoms)
	set mytype=myobject.selectSingleNode("@"&idname)
	getloastdmid=myobject.attributes.getNamedItem(idname).nodeValue
	 
	set myobject=nothing
	set objDoms=Nothing
	'isDatenow=true
end Function
	Function inArray(arr,item)
		inArray = False
		For i=0 To UBound(arr)
			If arr(i)=item Then
				inArray=True
				Exit For
			End If
		Next
	End Function


Public Function getOtherips(ByVal ip)
	Dim cache_otheripstr
	cache_otheripstr=session("cache_otheripstr_"&ip)
	If Trim(cache_otheripstr)="" Then 
		Set otheripdic=aspjsonParse(get_server_otherip(ip))
		Set iparr=newarray()
		For Each line In otheripdic("body")
			If line("free")="1" Then
				ipprice=0
			Else
				ipprice=GetNeedPrice(session("user_name"),line("prodid"),1,"renew")/12 
			End if
			line.add "price",ipprice
			iparr.push(line)
		next
		cache_otheripstr=aspjsonprint(iparr)
		session("cache_otheripstr_"&ip)=cache_otheripstr
	End If 
	getOtherips=aspjsonParse(cache_otheripstr) 
End Function 

'vcp 提成百分比
Function proid_vcp_royalty(ByVal proid,ByVal isrenew)
	Dim p_type
	p_type=0
	proid_vcp_royalty=0
	sql="select top 1 p_type from productlist where p_proid='"&proid&"'"
	Set prs=conn.execute(sql)
	If Not prs.eof Then p_type=prs(0)
	Select Case CLng(p_type)
	Case 1,7
		proid_vcp_royalty=IIF(isrenew,vcp_rennew_vhost,vcp_vhost)   '虚拟主机
	Case 2
		proid_vcp_royalty=IIF(isrenew,vcp_rennew_mail,vcp_mail)   '邮局
	Case 9,11,13,14
		proid_vcp_royalty=IIF(isrenew,vcp_rennew_server,vcp_server)  '服务器
	End select
End Function
 

'vcp提成记录 型号,用户ID,价格,业务ID,说明
sub Set_vcp_record(ByVal vcp_proid,ByVal vcp_uid,ByVal vcp_price,ByVal vcp_years,ByVal vcp_content,ByVal isrenew) 
	Call writelogs("vcp","proid:"&vcp_proid&"	,	uid:"&vcp_uid&"	,	price:"&price&"	,	wy_id:"&wy_id&"	,	content:"&content)
	If CDbl(vcp_price)<=0 Then Exit Sub
	If Not isnumeric(vcp_uid&"") Then vcp_uid=0
	If Not isnumeric(vcp_years&"") Then vcp_years=0
	Dim f_id,vcp_proid_vcp_royalty,royalty
	f_id=0 
	vcp_proid_vcp_royalty=0
	royalty=0




	Set vcprs=conn.execute("select top 1 f_id from userdetail where u_level=1 and u_id="&vcp_uid) 
	If Not vcprs.eof Then f_id=vcprs("f_id")
	vcprs.close:Set vcprs=Nothing 

	If Not isnumeric(f_id&"") Then Exit Sub
	if Cint(f_id)=0 then  Exit Sub 
	vcp_proid_vcp_royalty=proid_vcp_royalty(vcp_proid,isrenew)
	if CDbl(vcp_proid_vcp_royalty)<=0 Then Exit Sub
	If CDbl(vcp_proid_vcp_royalty)>0.5 Then Exit Sub
	If CDbl(vcp_years)<1 Then vcp_years=1
	royalty=CDbl(vcp_price)*CDbl(vcp_proid_vcp_royalty)
	
	if royalty<=0 then
		Exit sub
	end If
	sql="insert into vcp_record(v_fid,v_cid,v_proid,v_price,v_years,v_royalty,v_content) values("&f_id&","&vcp_uid&",'"&vcp_proid&"','"&vcp_price&"',"&vcp_years&","&royalty&",'"&vcp_content&"')"
 	conn.execute(sql) 
End sub


Sub writelogs(ByVal keyname,ByVal logmsg)
	On Error Resume Next
	Dim fileFolder_root,filename
	fileFolder_root=Server.MapPath("/database/logs")
	filename=fileFolder_root & "/"& keyname & "_" & day(date) &".txt"
	set fileobj=server.createobject("scripting.FileSystemObject") 
	set filehander =fileobj.opentextfile(filename,8,true)
	filehander.writeline string(10,"-")&  now & string(10,"-")& vbcrlf & logmsg
	filehander.close 
	set filehander=nothing
	set fileobj=nothing
End sub

Function get_cache_product_west_save()
	On Error Resume Next:Err.clear
	get_cache_product_west_save=GetRemoteUrl("https://api.west.cn/API/other/cache_products_config.asp")
	If Trim(get_cache_product_west_save)<>"" Then Call WriteToFile_FSO("/noedit/product.json",get_cache_product_west_save)
	If Err.Number<>0 Then get_cache_product_west_save=""
End function
function get_cache_product_west()
	On Error Resume Next:Err.clear
	Dim retdic_,west_expdatetime
	allfile=ReadFileContent("/noedit/product.json")
	Set retdic_=aspjsonparse(allfile)
	west_expdatetime=retdic_("expdate")
	If Not isdate(west_expdatetime&"") Then  '
		allfile=get_cache_product_west_save()
	End If
	

	If datediff("S",west_expdatetime,now())>0 Then  '
		allfile=get_cache_product_west_save()
	End If
	Set retdic_=aspjsonparse(allfile)

	Set get_cache_product_west=newoption() 
	Set get_cache_product_west=retdic_
End Function

Function get_cache_product_info(ByVal proid)
	On Error Resume Next:Err.clear
	Set p_cache_=get_cache_product_west()
	Set get_cache_product_info=newoption() 
	Set get_cache_product_info =p_cache_("products")(LCase(proid))("server")
	If Err.Number<>0 Then Set get_cache_product_info=newoption() 
End Function

Function get_cache_westpay_info()
	'On Error Resume Next:Err.clear
	Set p_cache_=get_cache_product_west()  
	get_cache_westpay_info =p_cache_("westpay")
	If Err.Number<>0 Then Set get_cache_westpay_info=newarray() 
End Function

Function get_cache_ebs_west_save()
	On Error Resume Next:Err.clear
	Dim http_returnstr
	http_returnstr=GetRemoteUrl("http://api.west263.com/api/Agent_API/getdiyconfig.asp")
	If Trim(http_returnstr)<>"" Then http_returnstr="{""expdate"":"""&dateadd("D",1,Now())&""",""ebsconfig"":{"&http_returnstr&"}}":get_cache_ebs_west_save=http_returnstr:Call WriteToFile_FSO("/noedit/ebsconfig.json",http_returnstr)
	If Err.Number<>0 Then get_cache_ebs_west_save=""
End Function

Function get_cacehe_ebs_confg()
	On Error Resume Next:Err.clear
	On Error Resume Next:Err.clear
	Dim retdic_,west_expdatetime
	allfile=ReadFileContent("/noedit/ebsconfig.json")
	
	Set retdic_=aspjsonparse(allfile)
	west_expdatetime=retdic_("expdate")
	If Not isdate(west_expdatetime&"") Then  '
		allfile=get_cache_ebs_west_save()
		Set retdic_=aspjsonparse(allfile)
	End If 
	If datediff("S",west_expdatetime,now())>0 Then  '
		allfile=get_cache_ebs_west_save()
		Set retdic_=aspjsonparse(allfile)
	End If 
	Set get_cacehe_ebs_confg=newoption()
	Set get_cacehe_ebs_confg=retdic_("ebsconfig")
End Function

function hascontinuityStr(byval str,byval maxcount)'zxw 是否含有相同字符 字符串,相同个数
	dim i,oldstrasc,cur0,cur1,cur2,ishas,str_
	ishas=false:cur0=1:cur1=1:cur2=1
	for i=1 to len(trim(str))
		str_=mid(str,i,1):strasc=asc(str_)		
		if oldstrasc&""<>"" then
			if oldstrasc+1=strasc then
				cur0=cur0+1
			else
				cur0=1
			end if
			if oldstrasc-1=strasc then			
				cur1=cur1+1
			else
				cur1=1
			end if
			if oldstrasc=strasc then			
				cur2=cur2+1
			else
				cur2=1
			end if
		end if
		if cur0>=maxcount or cur1>=maxcount  or cur2>=maxcount then  ishas=true:exit for
		oldstrasc=strasc
	next
	hascontinuityStr=ishas
end Function

%> 

<script language="jscript" runat="server">
var unurlcode=function(source){return unescape(source.replace(/\\/g,'%'))}
var urlencode_js=function(str){return encodeURIComponent(str)}
var urldecode_js=function(str){return decodeURIComponent(str)} 
var newarray=function(){return new Array()}
var arrayrnd_js=function(arr){return arr[Math.floor(Math.random()*arr.length)];}
function ishasjspara(para){return (typeof para!="undefined" && typeof para!="unknown" && para!=null)}
function checkpwdcpx(pwd,proname,protxt,minlen,maxlen,lxlen,ismin){var errinfo="";if(!ishasjspara(pwd)){pwd=""}if(!ishasjspara(minlen)){minlen=8}if(!ishasjspara(maxlen)){maxlen=50}if(!ishasjspara(lxlen)){lxlen=4}if(!ishasjspara(ismin)){ismin=0}if(ishasjspara(proname)){if(!ishasjspara(protxt)){protxt="账号"}if(proname==pwd){errinfo="密码不能和"+protxt+"相同"}else{if(pwd.substr(0,proname.length)==proname){errinfo="密码不能用"+protxt+"开头"}else{if(pwd.substr(pwd.length-proname.length,proname.length)==proname){errinfo="密码不能用"+protxt+"结尾"}}}}if(!eval("/^.{"+minlen+","+maxlen+"}$/ig").test(pwd)){errinfo="密码需要"+minlen+"-"+maxlen+"位的字符"}else{if(ismin==0&&/(^\d+$)|(^[a-zA-Z]+$)/ig.test(pwd)){errinfo="密码不能是纯数字或纯字母"}else{if(hascontinuityStr(pwd,lxlen)){errinfo="密码不能有连续或相同的"+lxlen+"位字符"}else{if(ckbadWord(pwd)){errinfo="密码是弱密码，易被黑客破解，请使用复杂密码"}}}}return errinfo};
</script>