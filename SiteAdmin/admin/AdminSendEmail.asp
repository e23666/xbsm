<!--#include virtual="/config/config.asp" -->
<%
Check_Is_Master(1)
server.ScriptTimeout=99999
Submit=request("submit")


if Submit<>"" then
conn.open constr
	MailTitle=Request("MailTitle")
	MailContent=Request("MailContent")
	UseHtml=Request("UseHtml")
	SendUser=Request("SendUser")
	SendEmail=Request("SendEmail")
	Target=Request("Target")
	
	if MailTitle="" then
		url_return "�ʼ����ⲻ��Ϊ�գ�",-1
	end if
	
	if MailContent="" then
		url_return "�ʼ����ݲ���Ϊ�գ�",-1
	end if
	
	'emails="webmaster@west263.com|edwardy2418@sohu.com|edwardy2418@163.com|"
	if Target="ALL" then
		
		sql="select distinct  u_email from userdetail"
		rs.open sql,conn,1,1
				do while not rs.eof
					email=email&rs(0)&"|"
				rs.movenext
				loop
	emails=email
	elseif Target="HOST" then
		'ȡ�ö��������û����ʼ�
		'Edward.Yang
		sql="select distinct email from hostrental"
		rs.open sql,conn,1,1
			if not rs.eof then
				do while not rs.eof
					email=rs(0)
					if email<>"" then
						if instr(emails,email)=0 then
						emails=emails&email&"|"
						end if
					end if
				rs.movenext
				loop
			end if
		rs.close

		emails=emails
	elseif Target="DOMAIN" then
		emails=GetDomainEmailADD("")
	elseif Target="AGENT" then
		emails=GetAgentEmailADD()
	elseif Target="maillist" then
		emails=Request("usermails")
	end if



'-----------------�����ǻ�ȡ�ʼ���ַ
	'if emails<>"" then
		'emails=left(emails,len(emails)-1)
'	end if
'	response.write emails
	if Target<>"maillist" then
	SplitEmail=split(emails,"|")
	else
	SplitEmail=split(emails,chr(13))
	end if
	if UseHtml="" then
		CanHTML="false"
	else
		CanHTML="true"
	end if
	for i=0 to ubound(SplitEmail)
		tomail=trim(trim(SplitEmail(i)))
		if instr(tomail,"@")>0 then
			sendHtmlMail tomail,MailTitle,MailContent,CanHTML
			response.write "."
		end if
	next
		url_return "���ͳɹ���һ��"&ubound(SplitEmail)+1&"���ʼ�!",-1
	
end if


'ȡ���������ʼ���ַ
'Edward.Yang
function GetHostEmailADD(s_comment)
	sql="Select email from icpinfo where s_comment='"&s_comment&"'"
	rs1.open sql,conn,1,1
	if not rs1.eof then
		GetHostEmailADD=rs1(0)
	end if
	rs1.close
end function

'ȡ���������ʼ���ַ
'Edward.Yang
function GetDomainEmailADD(userid)
	if userid<>"" then
		sql_user="select admi_em from domainlist where userid="&userid&" and dom_em<>'' "
	else
		sql_user="select dom_em from domainlist where dom_em<>''"
	end if
	rs1.open sql_user,conn,1,1
	
	if not rs1.eof then
		do while not rs1.eof
			thisEmail=rs1(0)
			if instr(sssstemp,thisEmail)=0 then
			sssstemp=sssstemp&thisEmail&"|"
			end if
		rs1.movenext
		loop
	end if
	rs1.close
	GetDomainEmailADD=sssstemp
end function

'ȡ�ô����̵��ʼ���ַ
'Edward.Yang
function GetAgentEmailADD()
	sql_user="select u_email from UserDetail where u_level>1 and u_email<>''"
	rs1.open sql_user,conn,1,1
	
	if not rs1.eof then
		do while not rs1.eof
			thisEmail=rs1(0)
			if instr(sssstemp,thisEmail)=0 then
			sssstemp=sssstemp&thisEmail&"|"
			end if
		rs1.movenext
		loop
	end if
	rs1.close
	GetAgentEmailADD=sssstemp
end function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�ʼ�Ⱥ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
 <form name="form1" method="post" action=""> <tr> <td width="19%" align="right" class="tdbg">Ŀ�꣺ </td><td width="81%" class="tdbg"> <input name="Target" type="radio" value="ALL" checked> 
ȫ���û� <input type="radio" name="Target" value="HOST"> ���������û� <input type="radio" name="Target" value="DOMAIN"> 
�����û� <input type="radio" name="Target" value="AGENT"> ȫ�������� <input type="radio" name="Target" value="maillist"> 
�����ʼ���ַ </td></tr> <tr> <td width="19%" align="right" class="tdbg">�ʼ����⣺</td><td width="81%" class="tdbg"> 
<input name="MailTitle" type="text" id="MailTitle" size="60"> </td></tr> <tr> 
<td width="19%" align="right" class="tdbg">&nbsp;</td><td width="81%" class="tdbg"> <input name="UseHtml" type="checkbox" id="UseHtml" value="HTML"> 
ʹ��html����</td></tr> <tr> <td width="19%" align="right" valign="top" class="tdbg">�ʼ����ݣ�</td><td width="81%" class="tdbg"> 
<textarea name="MailContent" cols="55" rows="9" wrap="VIRTUAL" id="MailContent"></textarea> 
(�����޸�) </td></tr> <tr> <td width="19%" height="36" align="right" class="tdbg">&nbsp;</td><td width="81%" height="36" class="tdbg"> 
<input type="submit" name="Submit" value="ȷ���������ʼ�  "> <input type="reset" name="Submit2" value="  ȫ����д  "> 
</td></tr> <tr> <td width="19%" align="right" class="tdbg">�ռ��˵�ַ</td><td width="81%" class="tdbg"> <textarea name="usermails" cols="55" rows="9" wrap="VIRTUAL" id="MailContent"></textarea>
    (��ѡ)</td></tr>
<tr>
  <td align="right" class="tdbg">&nbsp;</td>
  <td class="tdbg">&nbsp;</td>
</tr>
<tr>
  <td align="right" class="tdbg">&nbsp;</td>
  <td class="tdbg">&nbsp;</td>
</tr>
<tr>
  <td colspan="2" class="tdbg"><br>
    ��ʾ��ʹ��sql�����Բ�ѯĳһ�������ϵ��û���email��ַ��<br>
    ��ĳ̨�����ϵ������û���Email��ַ��<br>
    SELECT 
distinct UserDetail.u_email FROM vhhostlist INNER JOIN UserDetail ON vhhostlist.S_ownerid 
= UserDetail.u_id WHERE (vhhostlist.s_serverIP = '221.10.254.64')<br>
<a href="sqlcmd.asp"><font color="#ff0000">ִ��sql����</font></a><br>
<br></td>
  </tr>
</form></table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
