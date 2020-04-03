<% '本文件为全站公共处理，限添加类文件，一定不要改错，逐渐把asp_config中的移过来
Class aspjsonClass
	Dim isencode
	Dim quota

	Private Sub Class_Initialize()
		quota = True
	End Sub

	Function parse(objs) '将json字串或json对象转换为字典
		Dim J,isrearr,retobj
		If TypeName(objs)="String" Then
			If Left(objs,1)="[" Then isrearr = "1":objs = "{""_vbarray_"":" & objs & "}"
			Set J = parsejson(objs)
		Else
			Set J = objs
		End If
		Set retobj = json_to_dict(J)
		If isrearr = "1" Then 
			parse = retobj("_vbarray_")
		Else
			Set parse = retobj
		End If
	End Function

	Function parsejson(strjson) '将json字串解析为json对象
		On Error Resume Next : Err.clear
		Dim obj:Set obj = CreateObject("MSScriptControl.ScriptControl")
		obj.Language = "JScript"  
		obj.ExecuteStatement "var result=" & strjson & ";"
		Set parsejson = obj.CodeObject.result
		Set obj=Nothing
		If Err.number <> 0 Then Set parsejson=Nothing
	End Function

	Function print(objs) '将字典或json对象反解析为字符串
		Dim result,line(),ix, oo,vbtp,jstp,vbtpid :ix=0 : oo=""""
		vbtpid = VarType(objs)
		If vbtpid=14 Then
			vbtp = "Numeric"
		Else
			vbtp = TypeName(objs)
		End If

		If vbtp = "JScriptTypeInfo" Then
			jstp = "object"
			If isJsArray(objs) Then jstp = "array"
		End If

		If vbtp="Nothing" Then
			result = oo & "Null" & oo
		ElseIf jstp = "object" Then
			result = print_json(objs)
		ElseIf vbtp="Dictionary" Then
			For Each strKey In objs.Keys
				redim preserve line(ix)
				line(ix) = oo & strKey & oo & ":" & print(objs(strKey)):ix=ix+1
			Next
			result = "{" & Join(line,",") & "}"
		ElseIf vbtp = "Variant()" Or jstp = "array" Then
			For Each strVal In objs
				redim preserve line(ix)
				line(ix) = print(strVal):ix=ix+1
			Next
			result = "[" & Join(line,",") & "]"
		ElseIf vbtp = "String" Or vbtp="Date" Then
			result = oo & encode(objs) & oo
		ElseIf quota=False And (vbtp="Boolean" Or vbtp="Integer" Or vbtp="Double" Or vbtp="Float" Or vbtp="Long" Or vbtp="Single" Or vbtp="Numeric") Then
			If vbtp="Boolean" Then objs=LCase(objs)
			result = objs
		Else
			If vbtp="Boolean" Then objs=LCase(objs)
			result = oo & objs  & oo				
		End If
		print = result
	End Function

	Private Function json_to_dict(jsjson) 'json对象转字典
		Dim str,obj : Set obj = CreateObject("MSScriptControl.ScriptControl")
		str = str & "function json_to_dict(J){"
		str = str & "var dic = new ActiveXObject('Scripting.Dictionary'),ipos = 0;"
		str = str & "if( Object.prototype.toString.call(J) === '[object Array]' ){"
		str = str & "	for(var cur in J){"
		str = str & "	if(typeof J[cur]=='object'){"
		str = str & "		dic.add(ipos,json_to_dict(J[cur]));"
		str = str & "	}else{"
		str = str & "		dic.add(ipos,J[cur]);"
		str = str & "	}ipos++}dic = dic.Items();"
		str = str & "}else{"
		str = str & "	for (var strkey in J){"
		str = str & "	if(typeof J[strkey]=='object'){"
		str = str & "		dic.add(strkey, json_to_dict(J[strkey]));"
		str = str & "	}else{"
		str = str & "		dic.add(strkey, J[strkey])"
		str = str & "	}}"
		str = str & "}return dic;}"
		obj.Language = "JScript"
		obj.AddCode str
		Set json_to_dict = obj.Run("json_to_dict", jsjson)
		Set obj=Nothing
	End Function

	Private Function isJsArray(objarr) '是不是js数组
		On Error Resume Next
		Dim str,obj : Set obj = CreateObject("MSScriptControl.ScriptControl")
		str = str & "function isArray(obj){"
		str = str & "  return Object.prototype.toString.call(obj) === '[object Array]';"
		str = str & "}"		
		obj.Language = "JScript"
		obj.AddCode str
		isJsArray = obj.Run("isArray", objarr)
		Set obj=Nothing
	End Function

	Private	Function print_json(jsjson) '反解析json对象
		On Error Resume Next : Err.clear
		Dim str,obj : Set obj = CreateObject("MSScriptControl.ScriptControl")
		str = str & "function print_json(objs){"
		str = str & "	var line = [], oo='\""',result='';"
		str = str & "   if(!objs){"
		str = str & "       result = oo + 'Null' + oo;"
		str = str & "	}else if(Object.prototype.toString.call(objs) === '[object Array]'){"
		str = str & "		  for (var i in objs) {"
		str = str & "			  line.push( print_json( objs[i] ) );"
		str = str & "		  }result = '[' + line.join(',') + ']';"
		str = str & "	}else if(typeof(objs)=='object'){"
		str = str & "		for (var obj in objs) {"
		str = str & "			line.push(oo + obj + oo + ':' + print_json( objs[obj] ));"
		str = str & "		}result = '{' + line.join(',') + '}';"
		str = str & "	}else{"
		str = str & "		result = oo + encode(objs) + oo;"
		str = str & "	}return result;"
		str = str & "}"
		str = str & "function encode(value){"
		str = str & "	value = value.replace(/\f/g,'\\f');"
		str = str & "	value = value.replace(/\n/g,'\\n');"
		str = str & "	value = value.replace(/\r/g,'\\r');"
		str = str & "	value = value.replace(/\t/g,'\\t');"
		str = str & "	value = value.replace(/\p/g,'\\p');"
		str = str & "	value = value.replace(/""/g,'\\""');"
		str = str & "	return value;"
		str = str & "}"
		obj.Language = "JScript"
		obj.AddCode str
		print_json = obj.Run("print_json", jsjson)
		Set obj=Nothing
	End Function

	Private Function encode(ByVal value)
		value = Trim(value & "")
		value = Replace(value, "\", "\\")
		value = Replace(value, """", "\""")
		value = Replace(value, "/", "\/")
		value = Replace(value, Chr(8), "\b")
		value = Replace(value, Chr(12), "\f")
		value = Replace(value, Chr(10), "\n")
		value = Replace(value, Chr(13), "\r")
		encode = Replace(value, Chr(9), "\t")
	End Function
End Class

Function GetRows(conn,sql) '适合小数据使用
	Dim arrline,idx,trs,line,i
	arrline=Array():idx=0
	Set trs=conn.execute(sql)
	While Not trs.eof
		redim preserve arrline(idx)
		Set line = newoption()
		For i=0 to trs.fields.count-1
			strkey = LCase(trs.fields(i).name)
			strval = trs.fields(i).value
			line(strkey)=strval
		Next
		Set arrline(idx) = line
		idx=idx+1
		trs.movenext
	Wend : trs.close
	GetRows=arrline
End Function


Function Ba64EnCode(sString)
	If sString&""="" Then Exit Function
	Dim xml_dom, Node
	Set xml_dom = CreateObject("Microsoft.XMLDOM")
	xml_dom.loadXML ("<?xml version='1.0' ?> <root/>")
	Set Node = xml_dom.createElement("MyText")
	Node.dataType = "bin.base64"
	Node.nodeTypedValue = Gb2312_Stream(sString)
	Ba64EnCode = Node.Text
	xml_dom.documentElement.appendChild Node
	Set xml_dom = Nothing
End Function

Function Ba64DeCode(sString)
	If sString&""="" Then Exit Function
	Dim xml_dom, Node
	Set xml_dom = CreateObject("Microsoft.XMLDOM")
	xml_dom.loadXML ("<?xml version='1.0' ?> <root/>")	
	Set Node = xml_dom.createElement("MyText")
	Node.dataType = "bin.base64"
	Node.Text = sString
	Ba64DeCode = Stream_GB2312(Node.nodeTypedValue)	
	xml_dom.documentElement.appendChild Node
	Set xml_dom = Nothing
End Function

Function Gb2312_Stream(sString)
	Dim dr : Set dr = Server.CreateObject("ADODB.Stream")
	With dr
		.Mode = 3:.Type = 2:.open:.Charset = "gb2312"
		.WriteText sString
		.position = 0:.Type = 1
		Gb2312_Stream = .Read
		.Close
	End With
	Set dr = Nothing
End Function

Function Stream_GB2312(sStream)
	Dim dr : Set dr = Server.CreateObject("ADODB.Stream")
	With dr
		.Mode = 3:.Type = 1:.open:.Write sStream
		.position = 0:.Type = 2:.Charset = "gb2312"
		Stream_GB2312 = .ReadText
		.Close
	End With
	Set dr = Nothing
End Function

Function NewOption()
	Dim oDic : Set oDic = CreateObject("scripting.dictionary")
	Set NewOption = oDic
End Function 


Function aspjsonPrint(objs) '可以是数组或字典
	dim json:Set json = new aspjsonClass
	aspjsonPrint = json.print(objs)
	set json=nothing
End Function

Function aspjsonParse(strng) '字符串转字典
	dim json:Set json = new aspjsonClass
	if left(strng,1)="[" then
		aspjsonParse = json.parse(strng)
	else
		set aspjsonParse = json.parse(strng)
	end if
	set json=nothing
End Function
  

Function ReadFile(sFile)
	Dim fso : Set fso = CreateObject("scripting.filesystemobject")
	If fso.FileExists(sFile) Then
		Dim f : Set f=fso.OpenTextFile(sFile,1,False)
		ReadFile = f.ReadAll
		f.Close
	End If
End Function

Function WriteFile(sFile,content)
	Dim fso,f : Set fso = CreateObject("scripting.filesystemobject")
	Set f=fso.OpenTextFile(sFile, 2,True)
	f.Write content
	f.Close
End Function

Function AppendFile(sFile,content)
	Dim fso,f : Set fso = CreateObject("scripting.filesystemobject")
	Set f=fso.OpenTextFile(sFile, 8,True)
	f.WriteLine content
	f.Close
End Function

Function ReadFile_utf8(strFile)
	ReadFile_utf8 = ""
	On Error Resume Next : Err.Clear
	Dim s : Set s=CreateObject("adodb.stream")
	s.Type=2 : s.Mode=3 
	s.Charset="UTF-8"
	s.Open
	s.LoadFromFile strFile
	ReadFile_utf8=s.readtext
	s.Close : Set s=Nothing
End Function

Function WriteFile_utf8(strFile,strBody)
	On Error Resume Next : Err.Clear
	Dim s : Set s=CreateObject("adodb.stream")
	s.Type=2 : s.mode=3
	s.Charset="UTF-8"
	s.Open
	s.WriteText strBody
	s.SaveToFile strFile,2 
	s.Flush : s.Close : Set s=Nothing
	WriteFile_utf8 = (Err.Number=0)
End Function

Function BytesToBstr(bin,iChar)
	on error Resume Next : Err.Clear
	Dim s : Set s = CreateObject("adodb.stream")
	With s
		.Type=1 : .Mode = 3 : .Open
		.Write bin
		.Position = 0 : .Type = 2 : .CharSet = iChar
		BytesToBstr=.ReadText : .Close
	End With
	Set s = Nothing
End Function

Function CutStringbuild(text,str1,str2)
	Dim pos,pos2
	pos = InStr(text,str1)
	If pos>0 Then
		pos = pos+Len(str1)
		pos2 = InStr(pos,text,str2)
		If pos2>0 Then
			CutStringbuild = Mid(text,pos,pos2-pos)
		End If
	End If	
End Function
 

Function StringToBin(strng)
	Dim stream
	Set stream = CreateObject("ADODB.Stream")
	With stream 
		.Type = 2
		.Open
		.Charset = "GB2312"
		.WriteText = strng
		.Position = 0
		.Type=1
		StringToBin = .Read
	End With
	Set stream = Nothing
End Function

Function GetUnixTime(value)
	Dim t1:t1 = "1970-1-1 8:0:0"
	If IsDate(value) Then
		GetUnixTime=DateDiff("s",t1,value)
	Else
		GetUnixTime=DateAdd("s",value,t1)
	End If
End Function 

Function getrsonedic(ByVal sql_,ByRef ret_)
	getrsonedic=false
	Set ret_=newoption()
	Set rs_=conn.execute(sql_)
	If Not rs_.eof Then 
		for i=0 to rs_.Fields.Count-1
			name_=LCase(rs_.Fields(i).Name)
			value_=rs_.Fields(i).value
			If not ret_.exists(name_) Then ret_.add name_,value_
			'execute("db_"&dbrs.Fields(i).Name & "=dbrs.Fields(" & i & ").value")
		Next
		getrsonedic=true
	End If
	rs_.close
	Set rs_=nothing
End function
%><script language="jscript" runat="server">
var unurlcode=function(source){return unescape(source.replace(/\\/g,'%'))}
var urlencode_js=function(str){return encodeURIComponent(str)}
var urldecode_js=function(str){return decodeURIComponent(str)}
var newarray=function(){return new Array()}
var arrayrnd_js=function(arr){return arr[Math.floor(Math.random()*arr.length)];}
</script>