<%
' 类名：AlipayService
' 功能：支付宝各接口构造类
' 详细：构造支付宝各接口请求参数
' 版本：3.2
' 修改日期：2011-03-31
' 说明：
' 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
' 该代码仅供学习和研究支付宝接口使用，只是提供一个参考
%>

<!--#include file="alipay_submit.asp"-->

<%
'支付宝网关地址（新）
GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?"
'支付宝网关地址（旧）
GATEWAY_OLD = "https://www.alipay.com/cooperate/gateway.do?"

Class AlipayService
	''
	' 构造快捷登录接口
	' param anti_phishing_key 防钓鱼时间戳
	' param exter_invoke_ip 用户本地电脑的IP地址
	' return 表单提交HTML信息
	Public Function Alipay_auth_authorize(anti_phishing_key, exter_invoke_ip)
		Dim sButtonValue, sHtml
		
		'构造请求参数数组
		sParaTemp = Array("service=alipay.auth.authorize","target_service=user.auth.quick.login","partner="&partner,"return_url="&return_url,"_input_charset="&input_charset,"anti_phishing_key="&anti_phishing_key,"exter_invoke_ip="&exter_invoke_ip)
		
		'确认按钮显示文字
		sButtonValue = "支付宝快捷登录"
		
		'构造表单提交HTML数据
		Set  objSubmit = New AlipaySubmit
		sHtml = objSubmit.BuildFormHtml(sParaTemp, key, sign_type, input_charset, GATEWAY_NEW, "get", sButtonValue)
		
		Alipay_auth_authorize = sHtml
	End Function

	''
	' 用于防钓鱼，调用支付宝防钓鱼接口(query_timestamp)来获取时间戳的处理函数
	' 注意：远程解析XML出错，与IIS服务器配置有关
	' return 时间戳字符串
	Public Function Query_timestamp()
		Dim sUrl, encrypt_key
		sUrl = GATEWAY_NEW&"service=query_timestamp&partner="&partner
		encrypt_key = ""
		
		Dim objHttp, objXml
		Set objHttp=Server.CreateObject("Microsoft.XMLHTTP")
		'如果Microsoft.XMLHTTP不行，那么请替换下面的两行行代码尝试
		'Set objHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		'objHttp.setOption 2, 13056
		objHttp.open "GET", sUrl, False, "", ""
		objHttp.send()
		Set objXml=Server.CreateObject("Microsoft.XMLDOM")
		objXml.Async=true
		objXml.ValidateOnParse=False
		objXml.Load(objHttp.ResponseXML)
		Set objHttp = Nothing
		
		Set objXmlData = objXml.getElementsByTagName("encrypt_key")  ' 节点的名称
		If Isnull(objXml.getElementsByTagName("encrypt_key")) Then
			encrypt_key = ""
		Else
			encrypt_key = objXmlData.item(0).childnodes(0).text
		End If

		Query_timestamp = encrypt_key
	End Function
	
	'******************若要增加其他支付宝接口，可以按照下面的格式定义******************

	''
	' 构造(支付宝接口名称)接口
	' param sPara1 请求参数1
	' param sPara2 请求参数2
	' param sParaN 请求参数3
	' return 表单提交HTML文本或者支付宝返回XML处理结果
	Public Function Alipay_interface(sPara1, sPara2, sParaN)

		'构造请求参数数组
		
		'构造给支付宝处理的请求
		Set  objSubmit = New AlipaySubmit
		'请求方式有以下三种：
		'1.构造表单提交HTML数据：
		'sHtml = objSubmit.BuildFormHtml(sParaTemp, key, sign_type, input_charset, gateway, sMethod", sButtonValue)
		'2.构造模拟远程HTTP的GET请求，获取支付宝的返回XML处理结果：
		'sHtml = objSubmit.SendGetInfo(sParaTemp, key, sign_type, input_charset, gateway)
		'请根据不同的接口特性二选一
	End Function

End Class

%>