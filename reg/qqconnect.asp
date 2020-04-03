<%
'==================================
'=类 名 称：QqConnet
'=功    能：QQ登录 For ASP
'=作    者：㊣FireFox㊣
'=Q      Q: 63572063
'=日    期：2012-01-02
'==================================
'转载时请保留以上内容！！
Class QqConnet
    Private QQ_OAUTH_CONSUMER_KEY
    Private QQ_OAUTH_CONSUMER_SECRET
	Private QQ_CALLBACK_URL
	Private QQ_SCOPE
        
    Private Sub Class_Initialize    
	httpstr="http://"
	If ishttps Then httpstr="https://"
	qq_RuntenBalck=httpstr&Request.ServerVariables("HTTP_HOST")&"/reg/returnQQ.asp"
        QQ_OAUTH_CONSUMER_KEY =qq_AppID  'APP ID
        QQ_OAUTH_CONSUMER_SECRET =qq_AppKey 'APP KEY
        QQ_CALLBACK_URL = qq_RuntenBalck 'REDIRECT_URI
	'	response.Write(QQ_OAUTH_CONSUMER_KEY&"<BR>"&QQ_OAUTH_CONSUMER_SECRET&"<BR>"&QQ_CALLBACK_URL)
		
	QQ_SCOPE ="get_user_info,add_t,add_share,get_info" '授权项 例如：QQ_SCOPE=get_user_info,list_album,upload_pic,do_like,add_t 
                                                '不传则默认请求对接口get_user_info进行授权。
                                                '建议控制授权项的数量，只传入必要的接口名称，因为授权项越多，用户越可能拒绝进行任何授权。
    End Sub
    Property Get APP_ID()    
        APP_ID = QQ_OAUTH_CONSUMER_KEY    
    End Property

	'生成Session("State")数据.
	Public Function MakeRandNum()
		Randomize
		Dim width : width = 6 '随机数长度,默认6位
		width = 10 ^ (width - 1)
		MakeRandNum = Int((width*10 - width) * Rnd() + width)
	End Function
	

	
	'Get方法请求url,获取请求内容
	Private Function RequestUrl(url)
		Set XmlObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		XmlObj.open "GET",url, false
		XmlObj.send
		RequestUrl = XmlObj.responseText
		Set XmlObj = nothing
	End Function
	
	'Post方法请求url,获取请求内容
	Private Function RequestUrl_post(url,data)
		Set XmlObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		XmlObj.open "POST", url, false
		'XmlObj.setrequestheader "POST","/t/add_t HTTP/1.1"
		XmlObj.setrequestheader "Host"," graph.qq.com "
		XmlObj.setrequestheader "content-length ",len(data)   
        XmlObj.setrequestheader "content-type ", "application/x-www-form-urlencoded "
		XmlObj.setrequestheader "Connection"," Keep-Alive"
        XmlObj.setrequestheader "Cache-Control"," no-cache"
        XmlObj.send(data)
		RequestUrl_post = XmlObj.responseText
		Set XmlObj = nothing
	End Function
	
	'生成登录地址
	Public Function GetAuthorization_Code()
		Dim url, params
		url = "https://graph.qq.com/oauth2.0/authorize"
		params = "client_id=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&redirect_uri=" & QQ_CALLBACK_URL
		params = params & "&response_type=code"
		params = params & "&scope="&QQ_SCOPE
		params = params & "&state="&Session("State")
		url = url & "?" & params
		GetAuthorization_Code = (url)
	End Function
	
	
	'获取 access_token
	Public Function GetAccess_Token()
		Dim url, params,Temp
		Url="https://graph.qq.com/oauth2.0/token"
	    params = "client_id=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&client_secret=" & QQ_OAUTH_CONSUMER_SECRET
		params = params & "&redirect_uri=" & QQ_CALLBACK_URL
		params = params & "&grant_type=authorization_code"
		params = params & "&code="&Session("Code")
		params = params & "&state="&Session("State")
		url = Url & "?" & params
		Temp=RequestUrl(url)
		toTemp=split(Temp,"&")
		if ubound(toTemp)=0 then
		GetAccess_Token=""
		else		
      	Temp=toTemp(0)
		Temp=replace(Temp,"access_token=","")
		GetAccess_Token=Temp
		end if
	End Function
	
	'检测是否合法登录！
	Public Function CheckLogin()
		Dim Code,mState
		Code=Trim(Request.QueryString("code"))
		mState=Trim(Request.QueryString("state"))
		If Code<>"" Then
			CheckLogin = True
			Session("Code")=Code
		Else
			CheckLogin = False
		End If
	End Function
	
	'获取openid
	Public Function Getopenid()
		Dim url, params,Temp
		url = "https://graph.qq.com/oauth2.0/me"
		params = "access_token="&Session("Access_Token")
		url = Url & "?" & params
		Temp=RequestUrl(url)
		Temp=split(Temp,"openid"":""")(1)
		Temp=split(Temp,"""}")(0)
		Getopenid=Temp
	End Function
	
	'发送一条微博
	Public Function Post_Webo(content)
		Dim url, params
		url = "https://graph.qq.com/t/add_t"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		params = params & "&content="&content
		Post_Webo = RequestUrl_post(url,params)
	End Function
	
	'分享内容到QQ空间
	Public Function Post_Share(title,turl,comment,summary,images)
		Dim url, params
		url = "https://graph.qq.com/share/add_share"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		params = params & "&title="&title
		params = params & "&url="&turl
		params = params & "&title="&title
		params = params & "&comment="&comment
		params = params & "&summary="&summary
		params = params & "&images="&images
		params = params & "&format=json"
		Post_Share = RequestUrl_post(url,params)
	End Function
	
	'获取用户信息,得到一个json格式的字符串
	Public Function GetUserInfo()
		Dim url, params, result
		url = "https://graph.qq.com/user/get_user_info"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		url = url & "?" & params
		GetUserInfo = RequestUrl(url)
	End Function
	
	'获取腾讯微博登录用户的用户资料,得到一个json格式的字符串
	Public Function Get_Info()
		Dim url, params, result
		url = "https://graph.qq.com/user/get_info"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		params = params & "&format=json"
		url = url & "?" & params
		Get_Info = RequestUrl(url)
	End Function

	
	'获取用户名字,性别,从json字符串里截取相关字符
	Public Function GetUserName(json)
	    Dim nickname,sex
		nickname = Split(json, "nickname"": """)(1)
		sex=Split(json, "gender"": """)(1)
		nickname = Split(nickname, """,")(0)
		sex=Split(sex, """")(0)
	    GetUserName = Array(nickname,sex)
	End Function
	
	'获取腾讯微博登录用户Email,从json字符串里截取相关字符
	Public Function GetUserEmail(json)
	    Dim Email
		Email = Split(json, "email"":""")(1)
		Email = Split(Email, """,")(0)
	    GetUserEmail = Email
	End Function
End Class
%>