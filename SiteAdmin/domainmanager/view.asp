<!--#include virtual="/config/config.asp" -->

<%Check_Is_Master(6)%><html>
<head> 
<title>whois��ѯ</title>
<meta name="description" content="��������-���ϵ���������������������ע�ᡢ���������÷����̣�20�����������������ƣ�30000�û��Ĺ�ͬѡ��!���ȵ�������������,���NAS�洢�豸��ddos����ǽ��Ϊ�������Լ۱���ߵ���������!ȫ�����ȵ�˫��·�����������ϱ���ͨ���裡Cn����58Ԫ��">
<meta name="keywords" content="��������-��������,,����ע��,��������,����,���������ã���ҳ�ռ�,��վ�ռ�,�����й�,����,asp�ռ�">
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
		alert("��������Ҫ��ѯ��Ӣ��������");
		document.frmsearchInt.searchedDomainName.focus();
		return false;
	}

if (!CheckIfEnglish(document.frmsearchInt.searchedDomainName.value )) {
		alert("�ڲ�ѯӢ������Ӧ����Ӣ�Ĳ����������ļ��Ƿ��ַ���");
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
		alert("��������Ҫ��ѯ������������");
		theform.domain_name.focus();
		return false;
	}

	if (! CheckIfChinese(theform.domain_name.value)) 
	{
		alert("�ڲ�ѯ��������Ӧ����������Ӣ�Ĳ�������Ƿ��ַ���");
		theform.domain_name.focus();
		return false;
	}

	if (CheckIfSpace(theform.domain_name.value)) 
	{
		alert("�ڲ�ѯ��������Ӧ����������Ӣ�Ĳ�������ո�");
		theform.domain_name.focus();
		return false;
	}
	
	if (CheckIfEnglish(theform.domain_name.value)) 
	{
		alert("�ڲ�ѯ��������Ӧ����������Ӣ�Ĳ�������ȫΪӢ�ģ�");
		theform.domain_name.focus();
		return false;
	}
	
	var i=0;
    for (i=0;i<theform.suffix.length;i++){
		if (theform.suffix[i].checked) break;
	
 }
	if (i==theform.suffix.length){
		alert('��Ǹ,��ѡ������������');
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
        <p>����whois��ѯ 
          <input type="text" name="domain">
          <input type="submit" name="Submit" value="��ѯ">
        </p>
      </form>
      <br>
      <table width="95%" border="0" align="center">
        <tr> 
          <td> 
            <%
domain=Trim(requesta("domain"))
if not isdomain(domain) then url_return "������Ч����",-1
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

