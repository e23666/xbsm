Sub geturl(ByVal strURL)
Set objxml=CreateObject("WinHttp.WinHttpRequest.5.1")
objxml.SetTimeOuts 500000, 500000, 500000, 1000000
objxml.open "GET",strURL,false
	objxml.send()

	if objxml.status=200 then
		GetRemoteUrl=true
	else
		GetRemoteUrl=false
	end if
	Set objxml=nothing
End Sub

'���д�ҳ������
'������ַ
geturl("http://��������/api/sendmail.asp")