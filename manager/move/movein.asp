<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.Charset="gb2312"
conn.open constr
Sub writelog(errmes)
	sql="insert into ActionLog (ActionUser,Remark,AddTime,LogType)  values('" & Session("user_name") & "','" & errmes & "',now(),'other' )"
	conn.Execute(sql)
End Sub
function levelmoveSet(classp,classname)
	select case classp
		case "host"
		    sqltable="vhhostlist"
		    userc="s_ownerid"
			classz="s_comment"
		case "mail"
			sqltable="mailsitelist"
			userc="m_ownerid"
			classz="m_bindname"
		case "domain"
			sqltable="domainlist"
			userc="userid"
			classz="strDomain"
	end select
		sql="select b.u_id from "& sqltable &" a inner join userDetail b on a."& userc &"=b.u_id  where  a."& classz &"='"& classname &"' and b.u_moveSet=1"
		set rszxw=conn.execute(sql)
		if not rszxw.eof then
			levelmoveSet=false '��ֹת��
		else
			levelmoveSet=true '����
		end if
		rszxw.close
		set rszxw=nothing
		
end Function
function GetTimeRadom()
filetype=right(Fname1,3)
images_name1=now()
images_name1=replace(images_name1,"-","")
images_name1=replace(images_name1," ","")
images_name1=replace(images_name1,":","")
GetTimeRadom=images_name1
end Function

module=requesta("module")
 
If module<>""  Then

Select Case module
	 case "chghostuser"
		If requesta("hostname")<>"" Then
		    hostname=requesta("hostname")
		else
			url_return "������������",-1
		end if
		movepd=levelmoveSet("host",hostname)
		if not movepd then url_return "��������ֹת��",-1
		'==================================================================================
		'�����޸ĵ�
		'ת����������
		
		
		'�ж��û��Ƿ���ڲ�ȡ���û��Ŀ��ý��
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "��ݲ���ȷ��",-1
		end if
		
		if int(rs(1))>0 then
			url_return "�Բ���������VCP���û�������ת�ƣ�",-1
		end if
				
		'�ж��������������Ƿ���ȷ��ȡ��p_ProId
		hostpassword=requesta("hostpassword")
		if trim(hostpassword)="" then url_return "�������������������뷢������",-1
		rs.close
		sql="select s_ProductId,s_sysid,s_mid,S_ownerid,s_expiredate,s_ftppassword,u_name from vhhostlist,UserDetail   where S_ownerid=u_id and s_comment='"&hostname&"'"
	 
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "�������������������뷢������1��",-1
		end if
		
		retstr=GetOperationPassWord(hostname,"host",rs("u_name"))
		 
		if left(retstr,3)="200" then
	 		p=getReturn(retstr,"ftppassword") 
			if trim(p)<>trim(hostpassword) then
			url_return "�������������������뷢������2��",-1
			end if
		else
			url_return "�������������������뷢������3��",-1
		end if

		

		if CheckIsBuyTestHost(hostname) then
			url_return "������������ת�룡",-1
		end if
		p_ProId=rs(0) '��Ʒ��proid
		s_sysid=rs(1)'id
		OldS_ownerid=rs(3)'�ɵ�������id
		OldS_ownerName="δ�ҵ�"

		rs.close
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if
		
		if OldS_ownerid=session("u_sysid") then
			url_return "�㲻�ܽ��������Լ�����ת���Լ����£�",-1
		end if
		

		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "����",-1
		end if
	
		

		Xcmd="vhost" & vbcrlf
		Xcmd=Xcmd & "renewal" & vbcrlf
		Xcmd=Xcmd & "entityname:vhost" & vbcrlf
		Xcmd=Xcmd & "sitename:" &hostname & vbcrlf
		Xcmd=Xcmd & "years:1" & vbcrlf
		Xcmd=Xcmd & "." & vbcrlf
		
		loadret=Pcommand(Xcmd,Session("user_name"))
		
		if success(loadret) then
			conn.execute("update vhhostlist  set s_ownerid="&session("u_sysid")&" where s_sysid="&s_sysid)
			writelog "��������"&hostname&"�ӻ�Ա "&OldS_ownerName&" ת�뵽"&session("user_name") 
			alert_redirect "�����ɹ�","movein.asp"
		else
			conn.execute("update vhhostlist  set s_ownerid="&OldS_ownerid&",m_father="&OldS_ownerid&" where m_sysid="&s_sysid&"")
			url_return "��������ת��ʧ��",-1
		end if

	  case "chgmailuser"
		mailname=requesta("mailname")
        If mailname=""  Then url_return "�ʾ�������Ϊ��",-1
  		movepd=levelmoveSet("mail",mailname)
		if not movepd then url_return "���ʾֽ�ֹת��",-1
		'==================================================================================
		'�����޸ĵ�
		'ת���ʾ�
		
		'�ж��û��Ƿ���ڲ�ȡ���û��Ŀ��ý��
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "��ݲ���ȷ��",-1
		end if
		
		if int(rs(1))>0 then
			url_return "�Բ���������VCP���û�������ת�ƣ�",-1
		end if
		
		
		'�ж��ʾ������Ƿ���ȷ��ȡ��p_ProId
		MailMasterPassword=requesta("MailMasterPassword")
		rs.close
		sql="select m_productId,m_sysid,m_ownerid,m_expiredate from mailsitelist where m_bindname='"&mailname&"' and  m_password='"&MailMasterPassword&"'"
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "�ʾ�����������뷢������",-1
		end if
		
		p_ProId=rs(0) '��Ʒ��proid
		OldS_ownerid=rs(2)'�ɵ�������id
		OldS_ownerName="δ�ҵ�"
		rs.close
		
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if

		
		if OldS_ownerid=session("u_sysid") then
			url_return "�㲻�ܽ��ʾִ��Լ�����ת���Լ����£�",-1
		end if

		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "����",-1
		end if

		conn.Execute("update mailsitelist set m_ownerid=" & session("u_sysid") & " where m_bindname='" & mailname & "'")	

		Xcmd="corpmail" & vbcrlf
		Xcmd=Xcmd & "renewal" & vbcrlf
		Xcmd=Xcmd & "entityname:corpmail" & vbcrlf
		Xcmd=Xcmd & "domainname:" &mailname & vbcrlf
		Xcmd=Xcmd & "years:1" & vbcrlf
		Xcmd=Xcmd & "." & vbcrlf
		
		loadret=Pcommand(Xcmd,Session("user_name"))
		
		if success(loadret) then
			writelog "��ҵ�ʾ�"&mailname&"�ӻ�Ա "&OldS_ownerName&" ת�뵽"&session("user_name") 
			alert_redirect "�����ɹ�","movein.asp"
		else
			conn.Execute("update mailsitelist set m_ownerid=" & OldS_ownerid & " where m_bindname='" & mailname & "'")	
			url_return "����ʧ�ܣ�ת��ʧ��",-1
		end if	
		'==================================================================================
		
	  case "chgDomainuser"
		'If requesta("DomainName")<>"" Then DomainName=checkInputType(requesta("DomainName"),"domain")
		DomainName=requesta("DomainName")
        If DomainName=""  Then url_return "��������Ϊ��",-1
		movepd=levelmoveSet("domain",trim(DomainName))
		if not movepd then url_return "��������ֹת��",-1
		'---------------------------------------------------
		'==================================================================================
		'�����޸ĵ�
		'ת���ʾ�
		'�ж��û��Ƿ���ڲ�ȡ���û��Ŀ��ý��
		sql="select u_usemoney,f_id,u_name from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "��ݲ���ȷ��",-1
		end if
		
		if int(rs(1))>0 then
			url_return "�Բ���������VCP���û�������ת�ƣ�",-1
		end if
		
		'�ж��ʾ������Ƿ���ȷ��ȡ��p_ProId
		DomainPass=requesta("DomainPass")
		rs.close
		sql="select proid,userid,rexpiredate from domainlist where strDomain='"&DomainName&"' and strDomainpwd='"&DomainPass&"'"
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "������������뷢������",-1
		end if
		
		p_ProId=rs(0) '��Ʒ��proid
		OldS_ownerid=rs(1)'�ɵ�������id
		rexpiredate=rs("rexpiredate")
		OldS_ownerName="δ�ҵ�"
		
		if OldS_ownerid=session("u_sysid") then
			url_return "�㲻�ܽ��������Լ�����ת���Լ����£�",-1
		end if
		
		rs.close
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if
		
		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "����",-1
		end if

		UNeedMoney=GetNeedPrice(session("user_name"),p_ProId,1,"renew")

		conn.execute("update domainlist set userid="&session("u_sysid")&" where strDomain='"&DomainName&"'")

		Xcmd="domainname" & vbcrlf
		Xcmd=Xcmd & "renew" & vbcrlf
		Xcmd=Xcmd & "entityname:domain" & vbcrlf
		Xcmd=Xcmd & "domain:" &DomainName & vbcrlf
		Xcmd=Xcmd & "term:1" & vbcrlf
		Xcmd=Xcmd & "expiredate:"&rexpiredate&"" & vbcrlf
		Xcmd=Xcmd & "ppricetemp:"&UNeedMoney&"" & vbcrlf
		Xcmd=Xcmd & "." & vbcrlf
		
		loadret=Pcommand(Xcmd,Session("user_name"))

		if success(loadret) then
			writelog "����"&DomainName&"�ӻ�Ա "&OldS_ownerName&" ת�뵽"&session("user_name") 
			alert_redirect "�����ɹ�","movein.asp"
		else
			conn.execute("update domainlist set userid="& OldS_ownerid &" where strDomain='"&DomainName&"'")
			url_return "������ʧ��,����ת��ʧ��",-1
		end if
End Select

End If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-ҵ��ת��</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
 <script language='JavaScript'>
function conFirmAmount()
{	
	var stConFirm = '�����ٴ�ȷ���˲�����\n';
	return confirm(stConFirm);
}
</script> 

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/manager/move/movein.asp">ҵ��ת��</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 


<form name="host" action="movein.asp" method="post" onSubmit="return conFirmAmount()">
<table class="manager-table">
                            <tr>
                              <th>
                                  ��������ת��
						     </th>
                            </tr>
                            <tr>
                              <td > 
                                  <input type="hidden" name="module" value="chghostuser">
                                  ������:
                                  <input name="hostname" type=text class="manager-input s-input" size =20>
                                  ��������:
                                  <input name="hostpassword" type=password class="manager-input s-input" size =20>
                                  &nbsp;
                                  <script language="JavaScript">
										function checkhost()
										{
											if(host.hostname.value=="")
											{
												alert("��������������");
												host.hostname.focus();
												return false;
											}
											if(host.hostpassword.value=="")
											{
												alert("�������������룡");
												host.hostpassword.focus();
												return false;
											}
											
											if (confirm('���Ƿ�ȷ����������ת�뵽�����û����²��Զ�����һ�ꣿ'))
											{
												host.submit();
											}
											
										}
									</script>
                                  <input name="sub2" type=button class="manager-btn s-btn" value="ת��" onClick="return checkhost()" >
                              </td>
                            </tr>
                          </form>
                          <form name="Mail" action="movein.asp" method="post" onSubmit="return conFirmAmount()">
                            <tr>
                              <th>�ʾֿͻ�ת��</th>
                            </tr>
                            <tr>
                              <td >
                                  <input type="hidden" name="module" value="chgmailuser">
                                  �ʾ���:
                                  <input name="mailname" type=text class="manager-input s-input" id="mailname" size =20>
                                  �ʾ�����:
                                  <input name="MailMasterPassword" type=password class="manager-input s-input" size =20>
                                  &nbsp;
                                  <input name="sub" type=button class="manager-btn s-btn" id="sub" value="ת��" onClick="return checkMail()" >
                                  <script language="JavaScript">
										function checkMail()
										{
											if(Mail.mailname.value=="")
											{
												alert("�������ʾ�������");
												Mail.mailname.focus();
												return false;
											}
											if(Mail.MailMasterPassword.value=="")
											{
												alert("�������ʾ����룡");
												Mail.MailMasterPassword.focus();
												return false;
											}
											
											if (confirm('���Ƿ�ȷ�������ʾ�ת�뵽�����û����£�'))
											{
												Mail.submit();
											}
										}
									</script>
                                </td>
                            </tr>
                          </form>
                          <form name="Domain" action="movein.asp" method="post" onSubmit="return conFirmAmount()">
                            <tr>
                              <th>����ת��</th>
                            </tr>
                            <tr>
                              <td>
                                  <input name="module" type="hidden" id="module" value="chgDomainuser">
                                  ����:
                                  <input name="DomainName" type=text class="manager-input s-input" id="DomainName" size =20>
                                  ��������:
                                  <input name="DomainPass" type=password class="manager-input s-input" id="DomainPass" size =20>
                                  &nbsp;
                                  <input name="sub" type=button class="manager-btn s-btn" id="sub" value="ת��" onClick="return checkDomain()" >
                                  <script language="JavaScript">
										function checkDomain()
										{
											if(Domain.DomainName.value=="")
											{
												alert("������������");
												Domain.DomainName.focus();
												return false;
											}
											if(Domain.DomainPass.value=="")
											{
												alert("�������������룡");
												Domain.DomainPass.focus();
												return false;
											}
											
											if (confirm('���Ƿ�ȷ����������ת�뵽�����û����²��Զ�����һ�ꣿ'))
											{
												Domain.submit();
											}
										}
									</script>
                              </td>
                            </tr>

                          </form>
</table>


<div class="product-detail-desc manager-sm mt-30">
        <div class="title">
            <span>˵��</span>
        </div>
       <p>�����Ŀ����������<%=companyname%>��Ա�Ļ�ͨ��<%=companyname%>��������ע�����������������ת�뵽���Ĺ������������й�������ת��ȷ��ǰ��ϸ�Ķ�����ת�����<br>
                                           1�������������������˻��ѻ������������ί����ɣ�ί�й�����������ַ��������ת������Ȩ����ľ����ɲ������е�����������ʱ<%=companyname%>���������������ԭ����ע���˲�������������������Ȩ��Ȩ��;<%=companyname%>�������ٲý������������Ȩ����<br>
                                           2��������������������������ͨ��<%=companyname%>ע��Ĳſ���ͨ���ù���ת�롣<br>
                                           3��������������״̬��û���κ����飬û�з�����Ƿ���⡣<br>
                                           4������ע��ɹ�����60�죬���������ѳɹ�����60�죬δ��60��Ĳ����������<br>
                                           5������ҵ��ת�����������ʱ����ͬʱΪ��ҵ������һ���ע��ѣ����ð����Ĵ�����۸�ֱ�Ӵ�����Ԥ�����п۳���<br>
                                           6����������һ��ת��ɹ�����������ҵ�ʾַ���Ҳ���Զ�ת�ƹ�����<br>
                                           7������ͨ�������������ˣ�������Ա����ϵ�õ��������룬�������������������ҵ�����������Ŀ�в�ѯ��ҵ������롣 <br>
                                         8������ҵ����ת�뵽VCP Cģʽ��Dģʽ�����û��¡�
</p>
    </div>


		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>






 