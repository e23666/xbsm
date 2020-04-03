<!--#include file="alipay_md5.asp"-->
<%
If Right(companynameurl,1)<>"/" Then 
	If ishttps Then
		companynameurl="https://"& requesta("HTTP_HOST")&"/"
	else
		companynameurl="http://"& requesta("HTTP_HOST")&"/"
	end if
end if
'合作身份者ID，以2088开头的16位纯数字
partner         = alipay_userid
'安全检验码，以数字和字母组成的32位字符
key   			= alipay_userpass
'签约支付宝账号或卖家支付宝帐户
seller_email    = alipay_account

'交易过程中服务器通知的页面 要用 http://格式的完整路径，不允许加?id=123这类自定义参数
'notify_url      = companynameurl & "manager/onlinePay/onlinePayEnd.asp"
'付完款后跳转的页面 要用 http://格式的完整路径，不允许加?id=123这类自定义参数
return_url      = companynameurl & "manager/onlinePay/alipayend.asp"
notify_url      = companynameurl & "manager/onlinePay/onlinePayEnd.asp"
'网站商品的展示地址，不允许加?id=123这类自定义参数
show_url        = companynameurl
'收款方名称，如：公司名称、网站名称、收款人姓名等
mainname		= "收款方名称"
'字符编码格式 目前支持 gbk 或 utf-8
input_charset	= "gbk"
'签名方式 不需修改
sign_type       = "MD5"



'买家选择的支付方式
paymethod    = "directPay"
'pay_mode	 = request.Form("pay_bank")
'if pay_mode = "directPay" then
'	paymethod    = "directPay"	'默认支付方式，四个值可选：bankPay(网银); cartoon(卡通); directPay(余额); CASH(网点支付)
'	defaultbank	 = ""
'else
'	paymethod    = "bankPay"	'默认支付方式，四个值可选：bankPay(网银); cartoon(卡通); directPay(余额); CASH(网点支付)
'	defaultbank  = pay_mode		'默认网银代号，代号列表见http://club.alipay.com/read.php?tid=8681379
'end if
defaultbank=""
'商户自行定制的数据
extra_common_param = "" 


exter_invoke_ip   = ""			'获取客户端的IP地址，建议：编写获取客户端IP地址的程序
anti_phishing_key = ""			'防钓鱼时间戳

buyer_email		   = ""			'默认买家支付宝账号

royalty_type		= ""		'提成类型，该值为固定值：10，不需要修改
royalty_parameters	= ""		'提成信息集











sub WriteLog(Xinfo)
	Exit sub
	AlipayLog="D:\tmp\alipay.txt"
	Dim fso:set fso=CreateObject("scripting.FileSystemObject")
	set oFile=fso.openTextFile(AlipayLog,8,true)
	Xline=now & " " & Xinfo 
	oFile.writeline(Xline)
	oFile.close
	set oFile=nothing:Set fso=nothing
end sub

'　×××××××××××××××××××××××××××××××××××××××××××××××××××××

'对notify_url的认证
'输出 验证结果：true/false
function notify_verify()
	notify_verify = false
	responseTxt = get_http()			'判断消息是不是支付宝发出	
	sGetArray = GetRequestPost()		'获取支付宝POST过来通知消息，并以"参数名=参数值"的形式组成数组

	if IsArray(sGetArray) then			'验证是否有数组传来
		sArray = para_filter(sGetArray)	'对所有POST反馈回来的数据去空格
		sort_para = arg_sort(sArray)	'对所有POST反馈回来的数据排序
		mysign  = build_mysign(sort_para,key,sign_type,input_charset)	'生成签名结果		
		'sWord = "responseTxt="& responseTxt &"\n return_url_log:sign="&request.Form("sign")&"&mysign="&mysign&"&"&create_linkstring(sort_para)
		if mysign = request.Form("sign") and responseTxt = "true" then
			notify_verify = true
		end if
	end if
end function

'********************************************************************************

'对return_url的认证
'输出 验证结果：true/false
function return_verify()
	return_verify = false
	responseTxt = get_http()			'判断消息是不是支付宝发出
	sGetArray = GetRequestGet()			'获取支付宝GET过来通知消息，并以"参数名=参数值"的形式组成数组

	if IsArray(sGetArray) then			'验证是否有数组传来
		sArray = para_filter(sGetArray)	'对所有GET反馈回来的数据去空格
		sort_para = arg_sort(sArray)	'对所有GET反馈回来的数据排序
		mysign  = build_mysign(sort_para,key,sign_type,input_charset)	'生成签名结果
		'sWord = "responseTxt="& responseTxt &"\n return_url_log:sign="&request.QueryString("sign")&"&mysign="&mysign&"&"&create_linkstring(sort_para)
		if mysign = request.QueryString("sign") and responseTxt = "true" then
			return_verify = true
		end if	
	end if
end function

'********************************************************************************

'获取支付宝GET过来通知消息，并以"参数名=参数值"的形式组成数组
'输出 request回来的信息组成的数组
function GetRequestGet()
	dim sArray()
	i = 0
	For Each varItem in Request.QueryString
		Redim Preserve sArray(i)
		sArray(i) = varItem&"="&Request(varItem) 
		i = i + 1
	Next 
	if i = 0 then	'验证是否有数组传来
		GetRequestGet = ""
	else
		GetRequestGet = sArray
	end if
	
end function

'********************************************************************************

'获取支付宝POST过来通知消息，并以"参数名=参数值"的形式组成数组
'输出 request回来的信息组成的数组
function GetRequestPost()
	dim sArray()
	i = 0
	For Each varItem in Request.Form
		Redim Preserve sArray(i)
		sArray(i) = varItem&"="&Request(varItem) 
		i = i + 1
	Next 
	if i = 0 then	'验证是否有数组传来
		GetRequestPost = ""
	else
		GetRequestPost = sArray
	end if
end function

'********************************************************************************

'获取远程服务器ATN结果
'输出 服务器ATN结果字符串
function get_http()
	gateway = gateway &"partner=" & partner & "&notify_id=" & request("notify_id")
	Set Retrieval = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
    Retrieval.setOption 2, 13056 
    Retrieval.open "GET", gateway, False, "", "" 
    Retrieval.send()
    ResponseTxt = Retrieval.ResponseText
	Set Retrieval = Nothing
	get_http = ResponseTxt
end function

'　×××××××××××××××××××××××××××××××××××××××××××××××××××××




'构造函数
'从配置文件及入口文件中初始化变量
'inputPara 需要签名的参数数组
function alipay_service(inputPara)
	gateway = "https://mapi.alipay.com/gateway.do?"
	sPara = para_filter(inputPara)
	
	sort_para = arg_sort(sPara)		'得到从字母a到z排序后的签名参数数组
	'获得签名结果
	mysign = build_mysign(sort_para,key,sign_type,input_charset)
end function

'除去数组中的空值和签名参数
'sArray 签名参数组
'输出 去掉空值与签名参数后的新签名参数组
function para_filter(sArray)
	dim para()
	nCount = ubound(sArray)
	dim j
	j = 0
	for i = 0 to nCount
		'把sArray的数组里的元素格式：变量名=值，分割开来
		pos = Instr(sArray(i),"=")			'获得=字符的位置
		nLen = Len(sArray(i))				'获得字符串长度
		itemName = left(sArray(i),pos-1)	'获得变量名
		itemValue = right(sArray(i),nLen-pos)'获得变量的值
		
		if itemName <> "sign" and itemName <> "sign_type" and itemValue <> "" then
			Redim Preserve para(j)
			para(j) = sArray(i)
			j = j + 1
		end if
	next
	
	para_filter = para
end function

'对数组排序
'sArray 排序前的数组
'输出 排序后的数组
function arg_sort(sArray)
	nCount = ubound(sArray)
	For i = nCount TO 0 Step -1
		minmax = sArray( 0 )
    	minmaxSlot = 0
    	For j = 1 To i
            mark = (sArray( j ) > minmax)
        	If mark Then 
            	minmax = sArray( j )
            	minmaxSlot = j
        	End If
    	Next
		If minmaxSlot <> i Then 
			temp = sArray( minmaxSlot )
			sArray( minmaxSlot ) = sArray( i )
			sArray( i ) = temp
		End If
	Next
	arg_sort = sArray
end function

'生成签名结果
'sArray 要签名的数组
'key 安全校验码
'sign_type 签名类型
'输出 签名结果字符串
function build_mysign(sArray, key, sign_type,input_charset)
	prestr = create_linkstring(sArray)
	nLen = Len(prestr)
	prestr = left(prestr,nLen-1)
    prestr = prestr & key
    mysign = sign(prestr,sign_type,input_charset)
    build_mysign = mysign
end function

'把数组所有元素，按照"参数=参数值"的模式用"&"字符拼接成字符串
'sArray 需要拼接的数组
'输出 拼接完成以后的字符串
function create_linkstring(sArray)
	nCount = ubound(sArray)
	dim prestr
	for i = 0 to nCount
		prestr = prestr & sArray(i) & "&"
	next
	create_linkstring = prestr
end function

'签名字符串
'prestr 需要签名的字符串
'sign_type 签名类型
'输出 签名结果
function sign(prestr,sign_type,input_charset)
	dim sResult
	if sign_type = "MD5" then
		sResult = md5(prestr,input_charset)
	else 
		sResult = ""
	end if
	sign = sResult
end function

'构造表单提交HTML
'输出 表单提交HTML文本
function build_form()
	'GET方式传递
	'POST方式传递（GET与POST二必选一）
	'sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='"& gateway &"_input_charset="&input_charset&"' method='post'>"
	nCount = ubound(sPara)
	for i = 0 to nCount
		'把sArray的数组里的元素格式：变量名=值，分割开来
		pos = Instr(sPara(i),"=")			'获得=字符的位置
		nLen = Len(sPara(i))				'获得字符串长度
		itemName = left(sPara(i),pos-1)		'获得变量名
		itemValue = right(sPara(i),nLen-pos)'获得变量的值		
		sHtml = sHtml & "<input type='hidden' name='"& itemName &"' value='"& itemValue &"'/>"
	next
	sHtml = sHtml & "<input type='hidden' name='sign' value='"& mysign &"'/>"
	sHtml = sHtml & "<input type='hidden' name='sign_type' value='"& sign_type &"'/>"
	'submit按钮控件请不要含有name属性 '
	'sHtml = sHtml & "<input type=""submit"" value=""支付宝确认付款"">"
	build_form = sHtml
end Function


'双功能发货接口
function sendfh()
	nCount = ubound(sPara)
	newPara=""
    sendfh=false
	for i = 0 to nCount
		'把sArray的数组里的元素格式：变量名=值，分割开来
		pos = Instr(sPara(i),"=")			'获得=字符的位置
		nLen = Len(sPara(i))				'获得字符串长度
		itemName = left(sPara(i),pos-1)		'获得变量名
		itemValue = right(sPara(i),nLen-pos)'获得变量的值		
		newPara=newPara&itemName&"="&itemValue&"&"
	next

		sURl=gateway&newPara&"sign="&mysign&"&sign_type="&sign_type
       'sendfh=newPara
	    returnxml=GetRemoteUrl(sURl) 
		if instr(returnxml,"<is_success>T</is_success>")>0 then
		sendfh=true
		end if
		 
end function
%>

