<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->

<HTML><HEAD><TITLE><%=NetName%> (<%=NetUrl%>)</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<meta name=keywords content="�ഴ,asp,qcsky,qcdn,QCDN_NEWS">
<link href="<%=CssDir%>style.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY text=#000000 vLink=#0000ff aLink=#ff0000 link=#0000ff leftMargin=0 
topMargin=0 marginwidth="0" marginheight="0">
<br><br>
<%
if EmailFlag = 0 then
	Errmsg = "Ŀǰϵͳ��֧�ַ����ʼ����ܡ�"
	call Qcdn.Err_List(errmsg,3)
	Response.end
end if
If Request("method") = 1 then
Unid=Request("Unid")
if  not isnumeric(Unid) then
Unid=0
end if


	if clng(Unid) = 0 then
		Errmsg = "<li>�����쳣����<li>������Ϊ: error 110��<li>�������������ϵ������⡣"
		FoundErr = true
	else
		Unid = Unid
		Unid = qcdn.sqlcheck(Unid)
	end if

	if Trim(Request.Form("YouName")) = "" then
		Errmsg = Errmsg +"<li>����������������"
		FoundErr = true
	else
		YouName = Trim(Request.Form("YouName"))
		YouName = qcdn.sqlcheck(YouName)
	end if

	if Trim(Request.Form("YouMail")) = "" then
		Errmsg = Errmsg +"<li>�������������䡣"
		FoundErr = true
	elseif Qcdn.IsValidEmail(Trim(Request.Form("YouMail"))) = false then
		Errmsg = Errmsg +"<li>������������ȷ�����ַ��"
		FoundErr = true
	else
		YouMail = Trim(Request.Form("YouMail"))
		YouMail = qcdn.sqlcheck(YouMail)
	end if

	if Trim(Request.Form("SendEmail")) = "" then
		Errmsg = Errmsg + "<li>������Ҫ���͵����䡣"
		FoundErr = true
	elseif Qcdn.IsValidEmail(Trim(Request.Form("SendEmail"))) = false then
		Errmsg = Errmsg + "<li>������Ҫ���͵���ȷ�����ַ��"
		FoundErr = true
	else
		SendEmail = Trim(Request.Form("SendEmail"))
		SendEmail = qcdn.sqlcheck(SendEmail)
	end if

	if FoundErr then
		call Qcdn.Err_List(errmsg,1)
		Response.end
	end if

	Sql = "Select title,Content from article_info where Unid = " & Unid
	Set Rs = Conn.Execute(Sql)
	if Rs.eof and Rs.bof then
		Errmsg = "<li>�����쳣����<li>�������Ϊ��error 111��<li>�������������ϵ������⡣"
		call Qcdn.Err_List(errmsg,1)
		Response.end
	else
		title = YouName & "���������߸��������ġ�" & Rs(0) & "����Ϣ��"
		Content = Rs(1)
	end if
	rs.close : set rs = nothing
	Dim MailStr
		Emailbody=Emailbody &"<style type=text/css>"
		Emailbody=Emailbody &"<!--"
		Emailbody=Emailbody &"TD{FONT-SIZE:9PT;}"
		Emailbody=Emailbody &"-->"
		Emailbody=Emailbody &"</style>"
		Emailbody=Emailbody &"<body leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>"
		Emailbody=Emailbody & "<p><br>"
		Emailbody=Emailbody &"<table width=100% border=1 cellspacing=0 cellpadding=3 align=center bordercolorlight=#cccccc bordercolordark=#FFFFFF>"
		Emailbody=Emailbody &"  <tr>"
		Emailbody=Emailbody &"    <td align=center bgcolor=#FFCC00 height=30>"& title &"</td>"
		Emailbody=Emailbody &"  </tr>"
		Emailbody=Emailbody &"  <tr>"
		Emailbody=Emailbody &"    <td>"&Qcdn.UBBCode(content)&"</td>"
		Emailbody=Emailbody &"  </tr>"
		Emailbody=Emailbody &"  <tr align=center>"
		Emailbody=Emailbody &"<td align=center>"& copyright &"</td>"
		Emailbody=Emailbody &"    </tr>"
		Emailbody=Emailbody &"  <tr align=center>"
		Emailbody=Emailbody &"<td align=center>"& Version &"</td>"
		Emailbody=Emailbody &"    </tr>"
		Emailbody=Emailbody &"</table>"

	Select Case EmailFlag
			Case 0
				Response.write "<script>alert(""��֧�ַ����ʼ�"");window.close();</script>"
				Response.End
			Case 1
				Call Qcdn.Jmail(YouMail,SendEmail,title,Emailbody)
			Case 2
				Call Qcdn.Cdonts(YouMail,SendEmail,title,Emailbody)
			Case 3
				Call Qcdn.aspemail(YouMail,SendEmail,title,Emailbody)
		End Select 

		if MailStr <> "OK" then
			Response.Write "<script>alert(""����ʧ��"");window.close();</script>"
		else
			Response.Write "<script>alert(""���ͳɹ�"");window.close();</script>"
		end if
		Response.End
	
end if
if clng(Unid) = 0 then
	Errmsg = "<li>�����쳣����<li>������Ϊ: error 110��<li>�������������ϵ������⡣"
	call Qcdn.Err_List(errmsg,1)
	Response.end
else
	Unid = clng(Unid)
end if
%>



	<table width="400" align="center" cellspacing=0 cellpadding=0>
	<tr>
	<td class="mframe-t-left"></td>
	<td class="mframe-t-mid">
		<span class="mframe-t-text">�Ƽ����¸�����</span>
	</td>
	<td class="mframe-t-right"></td>
	</tr>
	</table>
	<table width="400" align="center" cellspacing=0 cellpadding=0>
	<tr>
	<td class="mframe-m-left"></td>
	<td class="mframe-m-mid" align=left style="padding-left:30px">
		<span id="myLabel" style="width:100%;"></span>
		<form name="form1" method="post" action="">
  <input type="hidden" value="<%=Unid%>" name="Unid">
����������&nbsp;<input type="text" name="YouName" size="30" maxlength="30">
<br><br>
�������䣺&nbsp;<input type="text" name="YouMail" size="30" maxlength="30">
<br><br>
�������䣺&nbsp;<input type="text" name="SendEmail" size="30" maxlength="30">
<br><br>
    <input type="submit" name="submit" value=" �� �� ">
    <input type="hidden" name="method" value="1">
	</form>
	</td>
	<td class="mframe-m-right"></td>
	</tr>
	</table>
	<table width="400" align="center" cellspacing=0 cellpadding=0 >
	<tr>
	<td class="mframe-b-left"></td>
	<td class="mframe-b-mid">&nbsp;</td>
	<td class="mframe-b-right"></td>
	</tr>
	</table>

</body>
</html>