<!--#include virtual="/config/config.asp" --> 
<!--#include virtual="/config/Template.inc.asp" -->
<%
If inStr(request("HTTP_REFERER"),Request("HOST_NAME"))=0 Then url_return "请勿从站外查询",-1

domain=Trim(requesta("domain"))
if not isdomain(domain) then url_return "不是有效域名",-1
Xinfo=getwhois(domain)

call setHeaderAndfooter()
call setdomainLeft()
tpl.set_file "main", USEtemplate&"/services/domain/whois.html"
tpl.set_var "whoisinfo",Xinfo,false
tpl.parse "mains","main",false
tpl.p "mains"


 
function getwhois(domain)
	apiurl="http://api.west263.com/api/aWhois.asp"
	getwhois=getHttp(apiurl,"d=" & server.urlencode(domain))
end function

Function getHttp(ByVal urlstr , ByVal postdata ) 
    on error resume next
    Set ajaxHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    With ajaxHttp
    .setTimeouts 10000, 10000, 10000, 10000
    .Open "POST", urlstr, false
    .SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    .send (postdata)
    If .Status = "200" Then
     getHttp = BytesToBstr(.responseBody,"GB2312")
    Else
      getHttp = "500 error."
    End If
    End With
    Set ajaxHttp = Nothing
End Function
 
Function BytesToBstr(body,cchar)
  Dim objstream
  Set objstream = CreateObject("adodb.stream")
  objstream.Type = 1
  objstream.Mode = 3
  objstream.Open
  objstream.write body
  objstream.Position = 0
  objstream.Type = 2
  objstream.CharSet = cchar
  BytesToBstr = objstream.ReadText
  objstream.Close
  Set objstream = Nothing
End Function


	%>
