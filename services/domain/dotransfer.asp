<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
Response.Charset="GB2312"
if instr(api_url,"api.west263.com")=0 then Die "�˹����޷�ʹ�ã�����ϵ����Ա"

act=requesta("act")
u_name	 = session("user_name")

if lcase(USEtemplate)="tpl_2016" then
	domainlist=Replace(requesta("domainlist")&"","~","��")
	domain=""
	authcode=""
	For Each line In Split(domainlist,vbcrlf)
		If InStr(line," ")>0 Then
			ipos=instr(line," ")
			If Trim(domain)	="" Then
				domain=Trim(mid(line,1,ipos))
				authcode=Trim(mid(line,ipos+1,Len(line)))
			Else
				domain=Trim(domain&vbcrlf&mid(line,1,ipos))
				authcode=Trim(authcode&vbcrlf&mid(line,ipos+1,Len(line)))
			End if
		End if
	Next
 else
	domain   = LCase(requesta("domain")) '����
	authcode = request("authcode")		'����
End if
chgdns		= requesta("chgdns"):if chgdns<>"1" then chgdns="0"
set session("transferdomain")=Server.CreateObject("Scripting.Dictionary")
session("chgdns")=chgdns
call checkTransferok(domain,authcode,str)
if str<>"" then
die url_return(str,-1)
end if
a=session("transferdomain").Keys
c_dm=""
c_pw=""
for i=0 to session("transferdomain").count-1
'response.Write(a(i)&":"&session("transferdomain").item(a(i))&"<BR>")
 if c_dm="" then
 c_dm=a(i)
 c_pw=session("transferdomain").item(a(i))
 else
 c_dm=c_dm&"~"&a(i)
 c_pw=c_pw&"~"&session("transferdomain").item(a(i))
 end if
next

strcmd="domainname"&vbcrlf&_
	   "transfer"&vbcrlf&_
		"entityname:check"&vbcrlf&_
		"domain:"&c_dm&""&vbcrlf&_
		"authcode:"&c_pw&""&vbcrlf&_
		"."&vbcrlf
 
 loadRet=connectToUp(strcmd)
 
' loadRet="200 ok"
 if left(loadRet,3)<>200 then
	 session("transferdomain").RemoveAll
	 %>
		
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>����ע�������������������������cn����ע��-��վ����</title>
    <meta name="description" content="��վ�����ǹ�����������������������ע���ṩ�̣�����ȫ��10ǿ�������ĵ�6��������������ϵͳ��ӵ���������ݻָ���Isapi�Զ��壬ľ���ɱ��30�������ȹ���.ǧMӲ������ǽ,Ϊ�����ݻ�����˫����������ȷ���ϱ���ͨ���裡">
    <meta name="keywords" content="��������,��վ����,����ע��,��������,����,����������,����,��վ�ռ�,�����й�,˫����������,asp�ռ�">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/domain.css">
    <link rel="stylesheet" href="/template/Tpl_2016/css/tp2016.css">
    <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery.superslide.2.1.1.x.js"></script>
	<script type="text/javascript">
	<!--
      alert("<%=replace(loadRet,vbcrlf,"\r\n")%>");
	  history.back()
	//-->
	</script>
</head>
<body>
	 
	
</body>
</html>
 <%
 else
	response.Redirect("transfer.asp?t=input")
 end if

 
 

'��鴫������������Ƿ�ok
function checkTransferok(d,p,err_str)
checkTransferok=false
d_array=split(d,vbcrlf)
p_array=split(p,vbcrlf)
err_str=""
    '��������������һ��
	if ubound(d_array)<>ubound(p_array) then
		err_str="����������������һ��"
		exit function
	end if
	
	for i=0 to ubound(d_array)
	  if GetsRoot(d_array(i))<>d_array(i) then
	    err_str=d_array(i)&",����д��ȷ�Ķ�������"
		exit function
	  end if
	 if InStr(","&DomainTransfer&",",","&GetDomainType(d_array(i))&",")=0 then
	    err_str=d_array(i)&",��֧�ָ���������ת��"
		exit function
	 end if 
	 '�����ظ�
	 if  not session("transferdomain").Exists(d_array(i)) then
	     session("transferdomain").add d_array(i),p_array(i)
	 end if
	next
end function



%>