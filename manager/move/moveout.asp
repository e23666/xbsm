<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr

Sub writelog(errmes)
	sql="insert into ActionLog (ActionUser,Remark,AddTime,LogType)  values('" & Session("user_name") & "','" & errmes & "',"&PE_Now&",'other' )"
	conn.Execute(sql)
End Sub


function GetTimeRadom()
filetype=right(Fname1,3)
images_name1=now()
images_name1=replace(images_name1,"-","")
images_name1=replace(images_name1," ","")
images_name1=replace(images_name1,":","")
GetTimeRadom=images_name1
end function


module=requesta("module") 
If module<>""  Then
Select Case module
		case "chghostuser"
		
		hostusername=trim(requestf("hostusername"))
		hostusermail=trim(requestf("hostusermail"))
		hostname=Trim(requestf("hostname"))
        If hostname=""  Then url_return "����������Ϊ��",-1
		'�ж��û��Ƿ���ڲ�ȡ���û��Ŀ��ý��
		if hostusername=session("user_name") then url_return "�����Լ�ת���Լ�",-1
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "��ݲ���ȷ��",-1
		end if
		
		if int(rs(1))>0 then
			url_return "�Բ���������VCP���û�������ת�ƣ�",-1
		end if
		rs.close
		'�����ǲ����ҵ�
		 
		sql="select s_sysid,s_mid,s_buydate,s_expiredate from vhhostlist where s_comment='"& hostname &"' and s_ownerid ="& session("u_sysid")
		rs.open sql,conn,1,1
		if not rs.eof then
			if CheckIsBuyTestHost(hostname) then
				url_return "������������ת����",-1
			end if
			if dateDiff("d",rs("s_buydate"),date())<=15 then url_return "����������Ҫ����15�����ת����",-1
			if dateDiff("d",date(),rs("s_expiredate"))<=15 then url_return "����ǰ15�첻��ת����",-1
			s_sysid=trim(rs("s_sysid"))
			MailSiteId=trim(rs("s_mid"))
		else
			url_return "�������������ģ�",-1
		end if
		rs.close
		'ת�����û����Ƿ����
		sql="select u_id from userDetail where u_name='"& hostusername &"' and u_email='"& hostusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "û���ҵ�Ҫת����û�",-1
		end if
		rs.close
		'��������������
		
		conn.execute("update vhhostlist set S_ownerid="& tou_id &" where s_sysid="& s_sysid &"")
		
		'�����ʾֵ�������
		if MailSiteId<>"" then
			conn.execute("update mailsitelist set m_ownerid="& tou_id &",m_father="& tou_id &" where m_sysid="& MailSiteId &"")
				
		end if
	conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&tou_id&",0,0,'"&GetTimeRadom()&"','������"&hostname&"�ӻ�Ա "&session("user_name")&" ת�������Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")
	conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','������"&hostname&"�ӻ�Ա "&session("user_name")&" ת����"& hostusername &"�Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")
	writelog "��������"&hostname&"�ӻ�Ա "&session("user_name")&" ת�뵽"&hostusername 
	alert_redirect "�����ɹ�","moveout.asp"
		'==================================================================================

	  case "chgmailuser"
	  	mailusername=trim(requestf("mailusername"))
		mailusermail=trim(requestf("mailusermail"))
		mailname=trim(requestf("mailname"))
        If mailname=""  Then url_return "�ʾ�������Ϊ��",-1
		if mailusername=session("user_name") then url_return "�����Լ�ת���Լ�",-1
	
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
		rs.close
		sql="select m_sysid,m_buydate,m_expiredate from mailsitelist where m_bindname='"&mailname&"' and  m_ownerid="&session("u_sysid")
		rs.open sql,conn,1,1
		if not rs.eof then
	
			if dateDiff("d",rs("m_buydate"),date())<=15 then url_return "������Ҫ����15�����ת����",-1
			if dateDiff("d",date(),rs("m_expiredate"))<=15 then url_return "����ǰ15�첻��ת����",-1
			m_sysid=trim(rs("m_sysid"))
			
		else
			url_return "���ʾֲ������ģ�",-1
		end if
		rs.close
		'ת�����û����Ƿ����
		sql="select u_id from userDetail where u_name='"& mailusername &"' and u_email='"& mailusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "û���ҵ�Ҫת����û�",-1
		end if
		rs.close

		
		'���ʾ�������
		conn.execute("update mailsitelist set m_ownerid="& tou_id &",m_father="& tou_id &" where m_sysid="& m_sysid &"")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("& tou_id &",0,0,'"&GetTimeRadom()&"','���ʾ�"&mailname&"�ӻ�Ա "&session("user_name")&" ת���������Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','���ʾ�"&mailname&"�ӻ�Ա "&session("user_name")&" ת����"& mailusername &"�Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")
		writelog "��ҵ�ʾ�"&mailname&"�ӻ�Ա "&session("user_name")&" ת����"&mailusername

		alert_redirect "�����ɹ�","moveout.asp"
		
		
		'==================================================================================
		
	  case "chgDomainuser"
		'If requesta("DomainName")<>"" Then DomainName=checkInputType(requesta("DomainName"),"domain")
		domainusername=trim(requestf("domainusername"))
		domainusermail=trim(requestf("domainusermail"))
		DomainName=requesta("DomainName")
        If DomainName=""  Then url_return "��������Ϊ��",-1
		if domainusername=session("user_name") then url_return "�����Լ�ת���Լ�",-1
		'--------------ת������-----------------------------
		if trim(session("user_name"))="yanzhou_chen" then
			url_return "���˺Ų�����ת��������",-1
		end if
		'---------------------------------------------------
		'==================================================================================

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
		rs.close
		sql="select d_id,userid,regdate,rexpiredate from domainlist where strDomain='"&DomainName&"' and userid="&session("u_sysid")
	
		rs.open sql,conn,1,1
		if not rs.eof then
			if dateDiff("d",rs("regdate"),date())<=15 then url_return "������Ҫ����15�����ת����",-1
			if dateDiff("d",date(),rs("rexpiredate"))<=15 then url_return "����ǰ15�첻��ת����",-1
			d_id=trim(rs("d_id"))
			
		else
			url_return "�������������ģ�",-1
		end if
		rs.close
		
		'ת�����û����Ƿ����
		sql="select u_id from userDetail where u_name='"& domainusername &"' and u_email='"& domainusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "û���ҵ�Ҫת����û�",-1
		end if
		rs.close
		
		'��������������
		conn.execute("update domainlist set userid="& tou_id &" where d_id="& d_id)

		'д������¼
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("& tou_id &",0,0,'"&GetTimeRadom()&"','������"&DomainName&"�ӻ�Ա "&session("user_name")&" ת���������Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','������"&DomainName&"�ӻ�Ա "&session("user_name")&" ת����"& domainusername &"�Ļ�Ա����','"&now()&"','"&now()&"','"&now()&"',0)")

		writelog "����"&DomainName&"�ӻ�Ա "& session("user_name") &" ת����"&  domainusername

		alert_redirect "�����ɹ�","moveout.asp"
		'==================================================================================


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
			   <li><a href="/manager/move/moveout.asp">ҵ��ת��</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


      
<table class="manager-table">
<form name="host" action="moveout.asp" method="post" onSubmit="return conFirmAmount()">
	<tr>
		<th>��������ת��</th>
	</tr>
	<tr>
	  <td valign="top"  >
	  <input type="hidden" name="module" value="chghostuser">
		 <table  class="manager-table">
		  <tr>
			<th width="28%" align="right">�ҵ�������:</th>
			<td width="72%" align="left"><input name="hostname" type=text class="manager-input s-input" size =20 maxlength="20"></td>
		  </tr>
		  <tr>
			<th align="right">Ҫת�����û���:</th>
			<td align="left"><input name="hostusername" type=text class="manager-input s-input" size =20 maxlength="20"></td>
		  </tr>
		  <tr>
			<th align="right">Ҫת�����û�����:</th>
			<td align="left"><input name="hostusermail" type="text" class="manager-input s-input" size =20 maxlength="60"></td>
		  </tr>
		  <tr>
			<td colspan="2"><input name="sub2" type=button class="manager-btn s-btn" value="ת��" onClick="return checkhost()"></td>
		  </tr>
		</table>
	 
		<script language="JavaScript">
				function checkhost()
				{
					if(host.hostname.value=="")
					{
						alert("��������������");
						host.hostname.focus();
						return false;
					}
					if(host.hostusername.value=="")
					{
						alert("�������û�����");
						host.hostusername.focus();
						return false;
					}
					if(host.hostusermail.value=="")
					{
						alert("�������û����䣡");
						host.hostusermail.focus();
						return false;
					}
					if (confirm('���Ƿ�ȷ����������ת��?'))
					{
						host.submit();
					}
					
				}
			</script>
	   </td>
</tr>
  </form>

  <form name="Mail" action="moveout.asp" method="post" onSubmit="return conFirmAmount()">
	<tr>
		<th>�ʾֿͻ�ת�� </th>
	</tr>
	<tr>
	  <td>
	  <input type="hidden" name="module" value="chgmailuser">
	  <table class="manager-table">
	  <tr>
		  <th align="right">�ҵ��ʾ���:</th>
		  <td width="73%" align="left"><input name="mailname" type=text class="manager-input s-input" id="mailname" size =20 maxlength="20">						  </td>
	  </tr>
	  <tr>
		  <th align="right">Ҫת�����û���:</th>
	      <td align="left"> <input name="mailusername" type=text class="manager-input s-input" size =20 maxlength="20"> </td>
	  </tr>
	  <tr>
		  <th align="right">Ҫת�����û�����:</th>
		  <td align="left"><input name="mailusermail" type="text" class="manager-input s-input" size =20 maxlength="60"></td>
	  </tr>
	  <tr><td colspan="2" > <input name="sub" type=button class="manager-btn s-btn"  id="sub" value="ת��" onClick="return checkMail()"></td></tr>
	  </table>
		<script language="JavaScript">
				function checkMail()
				{
					if(Mail.mailname.value=="")
					{
						alert("�������ʾ�����");
						Mail.mailname.focus();
						return false;
					}
					if(Mail.mailusername.value=="")
					{
						alert("�������û�����");
						Mail.mailusername.focus();
						return false;
					}
					if(Mail.mailusermail.value=="")
					{
						alert("�������û����䣡");
						Mail.mailusermail.focus();
						return false;
					}
					if (confirm('���Ƿ�ȷ�������ʾ�ת��?'))
					{
						Mail.submit();
					}
					
				}
			</script>                              </td>
	</tr>
  </form>
  <form name="Domain" action="moveout.asp" method="post" onSubmit="return conFirmAmount()">
 <tr> 	  
   <th> ����ת�� </th>
 </tr>
	<tr>
	  <td valign="top"  > 
		  <input name="module" type="hidden" id="module" value="chgDomainuser">
		   <table class="manager-table">
		   <tr><th align="right">����</th>
		   <td width="74%"  align="left"> <input name="DomainName" type=text class="manager-input s-input" id="DomainName" size =20 maxlength="40"></td></tr>
		   <tr>
		   <th align="right"> Ҫת�����û���:</th>
		   <td  align="left"><input name="domainusername" type=text class="manager-input s-input" size =20 maxlength="20"> 								  </td></tr>
		   <tr>
			   <th  align="right">Ҫת�����û�����:</th>
			   <td align="left"><input name="domainusermail" type="text" class="manager-input s-input" size =20 maxlength="60"> </td></tr>
			   <tr><td colspan="2"><input name="sub" type=button class="manager-btn s-btn"  id="sub" value="ת��" onClick="return checkDomain()"></td>
		   </tr>
		</table>
										 
		<script language="JavaScript">
				function checkDomain()
				{
					if(Domain.DomainName.value=="")
					{
						alert("������������");
						Domain.DomainName.focus();
						return false;
					}
					if(Domain.domainusername.value=="")
					{
						alert("�������û���");
						Domain.domainusername.focus();
						return false;
					}
					
					if(Domain.domainusermail.value=="")
					{
						alert("�������û����䣡");
						Domain.domainusermail.focus();
						return false;
					}
					if (confirm('���Ƿ�ȷ����������ת��?'))
					{
						Domain.submit();
					}
				}
			</script>                              </td>
	</tr>

  </form>
</table>

<div class="product-detail-desc manager-sm mt-30">
        <div class="title">
            <span>˵��</span>
        </div>
       <p>�����Ŀ�����������Լ��ʺ��µ�ҵ��ת��<%=companyname%>��������Ա������ʺŽ��й����ʺ��ڴ����̽�ҵ��ת��ֱ�ӿͻ����ɿͻ��Լ�����������<br>
            <br>
            ����ת��ȷ��ǰ��ϸ�Ķ�����ת�����<br>
          		1�������������������˻��ѻ������������ί����ɣ�ί�й�����������ַ��������ת������Ȩ����ľ����ɲ������е�����������ʱ<%=companyname%>���������������ԭ����ע���˲�������������������Ȩ��Ȩ��;<%=companyname%>�������ٲý������������Ȩ����<br>
          		2��������������������������ͨ��<%=companyname%>ע��Ĳſ���ͨ���ù���ת�롣<br>
          		3��������������״̬��û���κ����飬û�з�����Ƿ���⡣<br>
            4��ҵ��տ�ͨ15���ڻ��ҵ��������ڲ���15��ģ���ֹת��������<br>
            5��ת��ҵ��ʱ��ֻ�����ҵ��������ˣ������Զ����ѡ� <br>
            6������ҵ����ת�뵽VCP Cģʽ��Dģʽ�����û��¡�
</p>
    </div>
         
         
         
       












		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>



 