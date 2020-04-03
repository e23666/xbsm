<%
'微信支付
Class weixin_pay
	Dim orderAPI,actionName,callbackUrl,errarr,okobj

	 public sub Class_Initialize()
		orderAPI="https://api.mch.weixin.qq.com/pay/unifiedorder" 
		Set errarr=newarray()
	 End Sub
	 
	 public sub Class_Terminate()
		actionName  = "action"
     end Sub
     
	 Function adderr(ByVal errmsg)
		errarr.push(errmsg)		
	 End function
	 
	 '
	 Function pay(ByVal p)
		orderno=p("orderno") '订单号'
        subject=p("subject")  '标题'
        body=p("body") '端口描述'
        total_fee=p("total")'总金额分'
        if trim(orderno)="" or trim(subject)="" or not isnumeric(total_fee&"") then adderr("参数有误"):exit Function
		total_fee=total_fee*100
        trade_type = "NATIVE"    'JSAPI 公众号支付 NATIVE 扫码支付 APP APP支付'
		nonce_str = "eiffslk21l" 'CreateRandomKey(10)
		Set OrderArr=newarray()
		OrderArr.push("body=" & subject)
		OrderArr.push("total_fee=" & total_fee)
		OrderArr.push("out_trade_no=" & orderno)
		OrderArr.push("notify_url=" & wxpay_callback)
		OrderArr.push("spbill_create_ip=" & getuserip())
		OrderArr.push("trade_type=" & trade_type)
		OrderArr.push("appid=" & wxpay_appid)
		OrderArr.push("mch_id=" & wxpay_MchID)
		OrderArr.push("nonce_str=" & nonce_str)
		 
		xmlInfo ="<?xml version=""1.0"" encoding=""utf-8"" ?><xml>"
     
		For Each line In OrderArr.sort()
            if instr(line, "=") > 0 then
                xmlInfo = xmlInfo & paraToXML(line)
            end if
        next
         xmlInfo = xmlInfo & paraToXML("sign=" & Sign(OrderArr.sort()))
        xmlInfo = xmlInfo & "</xml>" 
       /// xmlInfo=Ba64EnCode(xmlInfo) 
        if left(actionInfo, 1) = "&" then actionInfo = mid(actionInfo, 2)  
       set result = XMLToArr(getHttpspostHtml(orderAPI, xmlInfo))

       
        if result("return_code") <> "SUCCESS" and result("return_msg")<> "OK" then
            resultInfo = result("return_msg")
        else
            returnsign = sortParadicsign(result)
            if returnsign = result("sign") then
                resultInfo = result("code_url")
            else
                resultInfo = "Sign Error," & result("err_code_des")
            end if
        end if

        Pay = resultInfo
	 End Function 

     public function GetNotify()
         GetNotify=false

        '必须通过二进制获取，这是一个大坑
        '二进制获取，只能获取一次
        '   如果需要读取获取的XML，在调用GetNotify之前增加 dim RESULT_XML
        '   然后通过 RESULT_XML 即可获取 请求的XML
        Set xmldom = Server.CreateObject("MSXML2.DOMDocument")
		xmldom.resolveExternals = false
        xmldom.load Request.BinaryRead(Request.TotalBytes)
        RESULT_XML = xmldom.xml
        Set xmldom = Nothing
		 
		'Call WriteToFile_FSO("/API/weixin/t.txt",RESULT_XML)
        set result = XMLToArr(RESULT_XML) 
		return_msg=""
		If result.Exists("return_msg") Then return_msg=result("return_msg")
        if result("return_code") <> "SUCCESS" and return_msg <> "OK" then
            adderr(return_msg) 
        else
            returnsign = sortParadicsign(result)
            if returnsign= result("sign") then
                set okobj=result
                GetNotify=true
            else
                adderr("Sign Error")
            end if
        end if
    end function


     function sortParadicsign(byval p)       
        Set tempArr=newarray()
        for each l in p
           str_=l&"="&p(l) 
            tempArr.push(str_)
        Next
      
        sortParadicsign=Sign(tempArr.sort())
     end function

  
     '将XML转换为 【请求参数】
    private function XMLToArr(byval xmlDoc)
         set line_=newoption()
        Set objXml = Server.CreateObject("MSXML2.DOMDocument")
		'xmldom.resolveExternals = false
        objXml.loadxml xmlDoc
        set objParent = objXml.SelectNodes("//xml")
        if objParent.length > 0 then 
           
            for i = 0 to objParent(0).childNodes.length - 1
                name_=objParent(0).childNodes(i).nodeName
                value_=objParent(0).childNodes(i).text
                
                line_.add name_,value_ 
            next
        end if
       set XMLToArr = line_
    end function

    '将  【请求参数】 转换为 XML
    private function paraToXML(byval paraItem)
        if instr(paraItem, "=") > 0 then
            nodeName = mid(paraItem, 1, instr(paraItem, "=") - 1)
            nodeValue = mid(paraItem, instr(paraItem, "=") + 1)
            paraToXML = "<" & nodeName & "><![CDATA[" & nodeValue & "]]></" & nodeName & ">"
        else
            paraToXML = ""
        end if
    end function

	 Function getHttpspostHtml(ByVal url_,ByVal postdata) 
        strdata="url="&Server.URLEncode(url_)&"&postdb=" &urlencode_js(postdata)& "&token=xlsvjKdjroakdoifwjdfowsdflsdafpdsfnngPJKdwksdfoswkewoe"
        getHttpspostHtml=sendHttpData("http://panel.myhostadmin.net/api/jump/",strdata)		 
    End Function

    function md5(byval str)
        set aspfram=new aspframework
        aspfram.Charset="utf-8"
        md5=aspfram.MD5(str)
    end function

    Function sendHttpData(ByVal apiurl,byval data)
        On Error Resume Next : Err.Clear
        sendHttpData=""      
        dim sendstype:sendstype="POST"
        if data="" then sendstype="GET"         
        Dim h : Set h = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
        With h
            .Open sendstype,apiurl,False
            .Option(4) = 13056
            .setTimeouts 30000, 30000, 30000, 120000
            .SetRequestHeader "Content-Type","application/x-www-form-urlencoded;charset=utf-8"
            .Send data
            If Err.number=0 Then sendHttpData = .ResponseText
        End With 
        Set h=Nothing
        Err.Clear
    End Function

	 '签名
    private function Sign(byval paraArr)
        dim signInfo
        for Each line_ In paraArr
            if instr(line_, "=") > 0 then
                if left(line_, 5) <> "sign=" then signInfo = signInfo & "&" & line_
            end if
        next
        signInfo = signInfo & "&key=" & wxpay_MchKey
        signInfo = mid(signInfo, 2) 
        Sign = UCase(md5(signInfo))
   
    end function
 


     '二进制流转换为 XML，这个也是抄的
    private function bin2str(byval binstr)
        Const adTypeBinary = 1
        Const adTypeText = 2
        Dim BytesStream,StringReturn
        Set BytesStream = Server.CreateObject("ADODB.Stream")
        With BytesStream
            .Type = adTypeText
            .Open
            .WriteText binstr
            .Position = 0
            .Charset = "UTF-8"
            .Position = 2
            StringReturn = .ReadText
            .close
        End With
        Set BytesStream = Nothing
        bin2str = StringReturn
    end function
End Class

%>