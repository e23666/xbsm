<!--#include virtual="/config/config.asp" -->
<%if alipaylog Then%>
		document.write('<a href="/reg/alipaylog.asp" target="_blank" class="login-link"><i class="zfb"></i></a>');
<%end If
if qq_isLogin Then
%>
	document.write('<a href="javascript:toQzoneLogin()" class="login-link" title="QQ¿ì½ÝµÇÂ¼"><i class="qq"></i></a>');
	var childWindow;	function toQzoneLogin()	{		childWindow = window.open("/reg/redirect.asp","TencentLogin","width=450,height=320,menubar=0,scrollbars=1, resizable=1,status=1,titlebar=0,toolbar=0,location=1");	} 		function closeChildWindow()	{		childWindow.close();window.location.reload()	}
<%	 
End If
%>


