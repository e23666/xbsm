<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%
response.charset="gb2312"
userid=session("u_sysid")
If Not isnumeric(userid&"") Then userid=0
If CLng(userid)=0 Then
	Call nologin()
Else
    Call myshopcar()
End If
Sub nologin()
%>{"result":"200","msg":"","shopcart":{"count":"0","sum":"0","datas":[]}}
<%End Sub
Sub myshopcar()
	If Trim(session("myshopcart"))="" then
		conn.open constr
		sql="select  ywType,ywName,cartContent,cartID from shopcart where s_status=0 and UserID="&userid&" order by cartID desc"
		Set trs=conn.execute(sql)
		tj_count=0
		tj_sum=0
		tj_str=""
		Do While Not trs.eof
			cartID=trs("cartID")
			ywType=trs("ywType")
			ywName=trs("ywName")
			cartContent=trs("cartContent")
			If ywType="server" Then  '
				price=getstrReturn(cartContent,"pricmoney")
				proid=getstrReturn(cartContent,"p_proid")
			else
				price=getstrReturn(cartContent,"ppricetemp")
				proid=getstrReturn(cartContent,"producttype")
			End if
		
			

			If Not isnumeric(price&"") Then price=0
			If tj_count<5 then
				If Trim(tj_str)="" Then
					tj_str="{""name"": """&ywName&""", ""price"": """&price&""", ""proid"": """&proid&""", ""id"": """&cartID&"""}"
				Else
					tj_str=tj_str&",{""name"": """&ywName&""", ""price"": """&price&""", ""proid"": """&proid&""", ""id"": """&cartID&"""}"
				End If
			End if
			tj_count=tj_count+1
			tj_sum=tj_sum+price
		trs.movenext
		Loop
		conn.close
		session("myshopcart")="{""result"":""200"",""msg"":"""",""shopcart"":{""count"":"""&tj_count&""",""sum"":"""&tj_sum&""",""datas"":["&tj_str&"]}}"
	End if
%><%=session("myshopcart")%>
<%End sub%>