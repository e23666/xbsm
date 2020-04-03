<%
'==================================
'=�� �� �ƣ�QqConnet
'=��    �ܣ�QQ��¼ For ASP
'=��    �ߣ��IFireFox�I
'=Q      Q: 63572063
'=��    �ڣ�2012-01-02
'==================================
'ת��ʱ�뱣���������ݣ���
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
		
	QQ_SCOPE ="get_user_info,add_t,add_share,get_info" '��Ȩ�� ���磺QQ_SCOPE=get_user_info,list_album,upload_pic,do_like,add_t 
                                                '������Ĭ������Խӿ�get_user_info������Ȩ��
                                                '���������Ȩ���������ֻ�����Ҫ�Ľӿ����ƣ���Ϊ��Ȩ��Խ�࣬�û�Խ���ܾܾ������κ���Ȩ��
    End Sub
    Property Get APP_ID()    
        APP_ID = QQ_OAUTH_CONSUMER_KEY    
    End Property

	'����Session("State")����.
	Public Function MakeRandNum()
		Randomize
		Dim width : width = 6 '���������,Ĭ��6λ
		width = 10 ^ (width - 1)
		MakeRandNum = Int((width*10 - width) * Rnd() + width)
	End Function
	

	
	'Get��������url,��ȡ��������
	Private Function RequestUrl(url)
		Set XmlObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		XmlObj.open "GET",url, false
		XmlObj.send
		RequestUrl = XmlObj.responseText
		Set XmlObj = nothing
	End Function
	
	'Post��������url,��ȡ��������
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
	
	'���ɵ�¼��ַ
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
	
	
	'��ȡ access_token
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
	
	'����Ƿ�Ϸ���¼��
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
	
	'��ȡopenid
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
	
	'����һ��΢��
	Public Function Post_Webo(content)
		Dim url, params
		url = "https://graph.qq.com/t/add_t"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		params = params & "&content="&content
		Post_Webo = RequestUrl_post(url,params)
	End Function
	
	'�������ݵ�QQ�ռ�
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
	
	'��ȡ�û���Ϣ,�õ�һ��json��ʽ���ַ���
	Public Function GetUserInfo()
		Dim url, params, result
		url = "https://graph.qq.com/user/get_user_info"
		params = "oauth_consumer_key=" & QQ_OAUTH_CONSUMER_KEY
		params = params & "&access_token=" & Session("Access_Token")
		params = params & "&openid=" & Session("Openid")
		url = url & "?" & params
		GetUserInfo = RequestUrl(url)
	End Function
	
	'��ȡ��Ѷ΢����¼�û����û�����,�õ�һ��json��ʽ���ַ���
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

	
	'��ȡ�û�����,�Ա�,��json�ַ������ȡ����ַ�
	Public Function GetUserName(json)
	    Dim nickname,sex
		nickname = Split(json, "nickname"": """)(1)
		sex=Split(json, "gender"": """)(1)
		nickname = Split(nickname, """,")(0)
		sex=Split(sex, """")(0)
	    GetUserName = Array(nickname,sex)
	End Function
	
	'��ȡ��Ѷ΢����¼�û�Email,��json�ַ������ȡ����ַ�
	Public Function GetUserEmail(json)
	    Dim Email
		Email = Split(json, "email"":""")(1)
		Email = Split(Email, """,")(0)
	    GetUserEmail = Email
	End Function
End Class
%>