<!--#include virtual="/config/config.asp" -->

<%Check_Is_Master(6)%><html>
<head> 
<title>whois查询</title>
<meta name="description" content="域名服务-西南地区最大的虚拟主机、域名注册、服务器租用服务商！20项虚拟主机领先优势，30000用户的共同选择!领先的虚拟主机技术,配合NAS存储设备、ddos防火墙，为您打造性价比最高的虚拟主机!全国领先的双线路虚拟主机，南北畅通无阻！Cn域名58元起！">
<meta name="keywords" content="域名服务-虚拟主机,,域名注册,主机租用,主机,服务器租用，主页空间,网站空间,主机托管,域名,asp空间">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language=javascript1.2>
function CheckIfEnglish( String )
{
    var Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";
     var i;
     var c;
      if(String.charAt( 0 )=='-')
	return false;
      if( String.charAt( String.length - 1 ) == '-' )
          return false;
     for( i = 0; i < String.length; i ++ )
     {
          c = String.charAt( i );
	  if (Letters.indexOf( c ) < 0)
	     return false;
     }
     return true;
}


function CheckIfChinese( String )
{ 
     var Letters = "`=~!@#$%^&*()_+[]{}\\|/?.>,<;:'\"";
     var i;
     var c;
     for( i = 0; i < String.length; i ++ )
     {
         c = String.charAt( i );
	     if (Letters.indexOf( c ) >= 0)
	       return false;
     }
     return true;
}

function CheckIfSpace(String)
{
	 var i;
     for( i = 0; i < String.length; i ++ )
     {
	 	  if(String.charAt(i) == ' ')
		   	 return true;
     }
     return false;
}


function submitchecken() {

	if (document.frmsearchInt.searchedDomainName.value == "") {
		alert("请输入您要查询的英文域名。");
		document.frmsearchInt.searchedDomainName.focus();
		return false;
	}

if (!CheckIfEnglish(document.frmsearchInt.searchedDomainName.value )) {
		alert("在查询英文域名应输入英文不能输入中文及非法字符！");
		document.frmsearchInt.searchedDomainName.focus();
		return false;
	}
	document.frmsearchInt.searchType.value = "IntDomain";
	return true;
}

function submitcheckcn(theform) 
{

	if (theform.domain_name.value == "") 
	{
		alert("请输入您要查询的中文域名。");
		theform.domain_name.focus();
		return false;
	}

	if (! CheckIfChinese(theform.domain_name.value)) 
	{
		alert("在查询中文域名应输入中文与英文不能输入非法字符！");
		theform.domain_name.focus();
		return false;
	}

	if (CheckIfSpace(theform.domain_name.value)) 
	{
		alert("在查询中文域名应输入中文与英文不能输入空格！");
		theform.domain_name.focus();
		return false;
	}
	
	if (CheckIfEnglish(theform.domain_name.value)) 
	{
		alert("在查询中文域名应输入中文与英文不能输入全为英文！");
		theform.domain_name.focus();
		return false;
	}
	
	var i=0;
    for (i=0;i<theform.suffix.length;i++){
		if (theform.suffix[i].checked) break;
	
 }
	if (i==theform.suffix.length){
		alert('抱歉,请选择域名的类型');
		return false;
		}
	return true;
}
</script>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#707070">
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr> 
    <td valign="top" width="2"><img src="/images/spacer.gif" width="2" height="2"></td>
    <td align="center" valign="top"> 
      <form name="form1" method="post" action="">
        <p>域名whois查询 
          <input type="text" name="domain">
          <input type="submit" name="Submit" value="查询">
        </p>
      </form>
      <br>
      <table width="95%" border="0" align="center">
        <tr> 
          <td> 
            <%
domain=Trim(requesta("domain"))
if not isdomain(domain) then url_return "不是有效域名",-1
Xinfo=getwhois(domain)
response.Write Xinfo


function getwhois(domain)
	apiurl="http://api.west263.com/api/aWhois.asp"
	getwhois=getHttp(apiurl,"d=" & domain)
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
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

