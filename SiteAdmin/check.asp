<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<%
password=Request.Form("password")
LocalPass = webmanagespwd&year(now())&month(now())
if password<>"" Then
password=md5_16("west263!~@"&password&"west263!~@o;asdfOqwerJ"&webmanagesrepwd)&year(now())&month(now())
	If password<>LocalPass Then
	    Call SetHttpOnlyCookie("secpass","","","/",#1980-1-1#)
		response.Redirect "/"
	Else
	    session("pss")=password
		Call SetHttpOnlyCookie("secpass",password,"","/",date()+30)
		response.Redirect "./"
	end if
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="/css/Global.css" rel="stylesheet" type="text/css" />
<link href="/css/Manager.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	background-color: #fff;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	font-size:12px;
}
body,td,th {
	color: #000;
	text-align:center;
}
#password{ height:20px; line-height:20px; color:red; width:200px; text-align:center;}
h1{ font-size:18px;}
</style>
<title>请输入口令</title>
<script type="text/javascript">
if ( top.location !== self.location ) 
{ 
top.location=self.location; 
  
} 

</script>
</head>

<body id="thrColEls">
<div id="MainContentDIV">
	<div class="Table_Div_line" style=" width:400px; margin:auto;margin-top:200px; border:solid 1px #ccc;background-color:#efefef">
<form name="form1" method="post" action="?">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
     
        <tr>
          <td height="25"  align="center">&nbsp;&nbsp;<h1 style="color:#0000ff">警告非工作人员请勿登陆！</h1><font color=red>(↓请输入后台专属登陆密码↓)</font><br /></td>
        </tr>
       
        <tr>
  
          <td height="80" align="center" style="line-height:45px;"> 
            <input type="password" name="password" id="password" title="请输入后台专属登陆密码！" /></td>
        </tr>
        <tr>
    
          <td align="center"  height="30"><input name="button" type="submit" class="button_gary" id="button" value="   提 交   "  /><BR><BR>
          &nbsp;</td>
        </tr>
      </table>
</form>
	</div>
</div></body>
</html>
