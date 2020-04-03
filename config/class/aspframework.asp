<%
'sunpage 2018
Class AspFramework
	Private codingname
	
	Private Sub Class_Initialize()
		codingname = "gbk"
	End Sub

	Public Property Let Charset(value)
		If inArray(Array("utf-8","utf8","gbk","gb2312","ascii","unicode"),value) Then
			codingname = LCase(value)
		End If
	End Property

	Function MD5(message)
		Dim obj,texthash,bytes
		Set obj = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
		texthash = GetTextHash(message)
		bytes = obj.ComputeHash_2((texthash))
		MD5 = HexToString(bytes)
		Set obj=Nothing
	End Function

	Function Base64(message)
		texthash = GetTextHash(message)
		Base64 = ConvertBase64(texthash,true)
	End Function

	Function FromeBase64(b64code)
		bytes = ConvertBase64(b64code,false)
		FromeBase64 = GetHashText(bytes)		
	End Function

	Function HmacSha1(message,seckey)
		texthash = GetTextHash(message)
		seckeyhash = GetTextHash(seckey)
		Set enc = CreateObject("System.Security.Cryptography.HMACSHA1")
		enc.Key = (seckeyhash)
		bytes = enc.ComputeHash_2((texthash))
		HmacSha1 = ConvertBase64(bytes,true)
	End Function
	

	'-------------------
	Function GetEncodecom()
		GetEncodecom = "System.Text." & Replace(codingname,"-","") & "Encoding"
	End Function
	Function GetTextHash(sString)
		If codingname="gbk" Or codingname="gb2312" Then
			With CreateObject("ADODB.Stream")
				.Mode = 3:.Type = 2:.open:.Charset = codingname
				.WriteText sString
				.position = 0:.Type = 1
				GetTextHash = .Read
				.Close
			End With
		Else
			GetTextHash = CreateObject(GetEncodecom).GetBytes_4(sString)
		End If
	End Function
	Function GetHashText(sStream)
		If codingname="gbk" Or codingname="gb2312" Then
			With CreateObject("ADODB.Stream")
				.Mode = 3:.Type = 1:.open:.Write sStream
				.position = 0:.Type = 2:.Charset = codingname
				GetHashText = .ReadText
				.Close
			End With
		Else
			GetHashText = CreateObject(GetEncodecom).GetString((sStream))
		End If
	End Function
	Function HexToString(vIn)
		With CreateObject("MSXML2.DomDocument").CreateElement("root")
			.dataType = "bin.Hex"
			.nodeTypedValue = vIn
			HexToString = Replace(.Text,vblf,"")
		End With
	End Function
	Function ConvertBase64(value,isencode)
		With CreateObject("MSXML2.DomDocument").CreateElement("root")
			.dataType = "bin.base64"
			If isencode Then 
				.nodeTypedValue = value
				ConvertBase64 = Replace(.Text,vblf,"")
			Else
				.Text = value
				ConvertBase64 = .nodeTypedValue
			End If
		End With
	End Function
End Class
%>