<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(6)%>
<%
conn.open constr
sub echo(strMessage)
  Response.write "<script language=javascript>alert('" & strMessage & "');window.close();</script>"
  Response.end
end sub

function is_dname(ByVal ckVal)
	dmRegStr="^([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]?\.)+([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]\.?)$"
	Set RegObj=New RegExp
	RegObj.Pattern=dmRegStr
	RegObj.ignoreCase=true
	is_dname=RegObj.test(ckVal)
	Set RegObj=nothing
end function

function is_self(domains)
	xdms="west263.com,west263.net,west263.cn,westdata.cn,west3721.com,west999.com,netinter.cn,west263.com.cn"
	xdms_list=split(xdms,",")
	for k=0 to Ubound(xdms_list)
		if domains=xdms_list(k) then
			is_self=true
			exit function
		end if
	next
	is_self=false
end function



id=Trim(Requesta("id"))
agentType=Trim(Requesta("agentType"))
domain=Trim(Requesta("domain"))

if not isNumeric(id) then
  echo "�������"
end if

if isNumeric(id) and agentType<>"" then
  if domain="" then
     Response.write "<script language=javascript>alert('����������');history.back();</script>"
     Response.end
   end if
  if not isNumeric(agentType) then url_return "��������ȷ��������",-1

  Sql="Select username from fuser where id=" & id
  Set RsTemp=conn.Execute(Sql)
  if RsTemp.eof then
   echo "����ĵ���"
  end if
  username=RsTemp("username")
  RsTemp.close
  Set RsTemp=nothing

if not is_dname(domain) then
  Response.write "<script language=javascript>alert('��������Ч������!');history.back();</script>"
  Response.end
end if

if left(domain,4)="www." then 
	Cdomain=mid(domain,5)
else
	Cdomain=domain
end if

if is_self(Cdomain) then url_return "����������˾��������" & Cdomain,-1

  Sql="Select id from fuser where C_dCenter='" & Cdomain &"' and id<>" & id
  Set RsTp=conn.Execute(Sql)
  if Not RsTp.eof then
     Response.write "<script language=javascript>alert('���󣬴������Ѿ�����ʹ��');history.back();</script>"
     Response.end
  end if
  RsTp.close
  Set RsTp=nothing

  Sql="update fuser set C_agentType=" & agentType & ",C_domain='" & domain & "',C_dCenter='" & Cdomain & "' Where id=" & id
  conn.Execute(Sql)
  Response.write "<script language=javascript>alert('�����޸ĳɹ�');opener.location.reload();window.close();</script>"
  Response.end
else
  Sql="Select * from fuser where id=" & id
	Rs.open Sql,conn,1,1
  if Rs.eof then
    echo "�޴�ID" 
  end if
  agentType=Rs("C_agentType")
end if
%>
<html>
<head>
<title>�û�����</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="vcp_style.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="5" topmargin="5" onLoad="window.moveTo(150,20);">
<form name="form1" method="post" action="vcp_level.asp">
  <table width="348" border="1" cellspacing="0" cellpadding="4" height="147" bordercolor="#006699" bordercolordark="#FFFFFF">
    <tr> 
      <td width="42" height="34">�û���:</td>
      <td width="82" height="34"><%=Rs("username")%></td>
      <td width="66" height="34">�ʻ�:</td>
      <td width="88" height="34"><%=Rs("C_Accounts")%>&nbsp;</td>
    </tr>
    <tr> 
      <td width="42" height="29">������:</td>
      <td width="82" height="29"><%=Rs("C_bank")%>&nbsp;</td>
      <td width="66" height="29">��ʽ:</td>
      <td width="88" height="29"><%=Rs("C_remitMode")%></td>
    </tr>
    <tr> 
      <td width="42" height="37">����:</td>
      <td width="82" height="37">
        <input type="text" name="domain" maxlength="60" size="15" value="<%=Rs("C_domain")%>">
      </td>
      <td width="66" height="37">������:</td>
      <td width="88" height="37">
        <input type="text" name="AgentType" size="3" maxlength="5" value="<%=Rs("C_AgentType")%>">
        % </td>
    </tr>
    <tr align="center"> 
      <td colspan="4" height="34"> 
        <input type="submit" name="Submit" value="ȷ��">
        <input type="button" name="Submit2" value="ȡ��" onClick="window.close();">
        <input type="hidden" name="id" value="<%=id%>">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
