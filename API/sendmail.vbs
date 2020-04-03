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

'运行打开页面数据
'您的网址
geturl("http://您的域名/api/sendmail.asp")