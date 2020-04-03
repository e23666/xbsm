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
        If hostname=""  Then url_return "主机名不能为空",-1
		'判断用户是否存在并取出用户的可用金额
		if hostusername=session("user_name") then url_return "不能自己转给自己",-1
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "身份不正确！",-1
		end if
		
		if int(rs(1))>0 then
			url_return "对不起，你属于VCP子用户，不能转移！",-1
		end if
		rs.close
		'主机是不是我的
		 
		sql="select s_sysid,s_mid,s_buydate,s_expiredate from vhhostlist where s_comment='"& hostname &"' and s_ownerid ="& session("u_sysid")
		rs.open sql,conn,1,1
		if not rs.eof then
			if CheckIsBuyTestHost(hostname) then
				url_return "试用主机不能转出！",-1
			end if
			if dateDiff("d",rs("s_buydate"),date())<=15 then url_return "主机购买日要超过15天才能转出！",-1
			if dateDiff("d",date(),rs("s_expiredate"))<=15 then url_return "到期前15天不能转出！",-1
			s_sysid=trim(rs("s_sysid"))
			MailSiteId=trim(rs("s_mid"))
		else
			url_return "此主机不是您的！",-1
		end if
		rs.close
		'转到的用户名是否存在
		sql="select u_id from userDetail where u_name='"& hostusername &"' and u_email='"& hostusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "没有找到要转入的用户",-1
		end if
		rs.close
		'跟改主机所有人
		
		conn.execute("update vhhostlist set S_ownerid="& tou_id &" where s_sysid="& s_sysid &"")
		
		'跟改邮局的所有人
		if MailSiteId<>"" then
			conn.execute("update mailsitelist set m_ownerid="& tou_id &",m_father="& tou_id &" where m_sysid="& MailSiteId &"")
				
		end if
	conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&tou_id&",0,0,'"&GetTimeRadom()&"','将主机"&hostname&"从会员 "&session("user_name")&" 转出到您的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")
	conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','将主机"&hostname&"从会员 "&session("user_name")&" 转出到"& hostusername &"的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")
	writelog "虚拟主机"&hostname&"从会员 "&session("user_name")&" 转入到"&hostusername 
	alert_redirect "操作成功","moveout.asp"
		'==================================================================================

	  case "chgmailuser"
	  	mailusername=trim(requestf("mailusername"))
		mailusermail=trim(requestf("mailusermail"))
		mailname=trim(requestf("mailname"))
        If mailname=""  Then url_return "邮局名不能为空",-1
		if mailusername=session("user_name") then url_return "不能自己转给自己",-1
	
		'判断用户是否存在并取出用户的可用金额
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "身份不正确！",-1
		end if
		
		if int(rs(1))>0 then
			url_return "对不起，你属于VCP子用户，不能转移！",-1
		end if
		rs.close
		sql="select m_sysid,m_buydate,m_expiredate from mailsitelist where m_bindname='"&mailname&"' and  m_ownerid="&session("u_sysid")
		rs.open sql,conn,1,1
		if not rs.eof then
	
			if dateDiff("d",rs("m_buydate"),date())<=15 then url_return "购买日要超过15天才能转出！",-1
			if dateDiff("d",date(),rs("m_expiredate"))<=15 then url_return "到期前15天不能转出！",-1
			m_sysid=trim(rs("m_sysid"))
			
		else
			url_return "此邮局不是您的！",-1
		end if
		rs.close
		'转到的用户名是否存在
		sql="select u_id from userDetail where u_name='"& mailusername &"' and u_email='"& mailusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "没有找到要转入的用户",-1
		end if
		rs.close

		
		'跟邮局所有人
		conn.execute("update mailsitelist set m_ownerid="& tou_id &",m_father="& tou_id &" where m_sysid="& m_sysid &"")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("& tou_id &",0,0,'"&GetTimeRadom()&"','将邮局"&mailname&"从会员 "&session("user_name")&" 转出到了您的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','将邮局"&mailname&"从会员 "&session("user_name")&" 转出到"& mailusername &"的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")
		writelog "企业邮局"&mailname&"从会员 "&session("user_name")&" 转出到"&mailusername

		alert_redirect "操作成功","moveout.asp"
		
		
		'==================================================================================
		
	  case "chgDomainuser"
		'If requesta("DomainName")<>"" Then DomainName=checkInputType(requesta("DomainName"),"domain")
		domainusername=trim(requestf("domainusername"))
		domainusermail=trim(requestf("domainusermail"))
		DomainName=requesta("DomainName")
        If DomainName=""  Then url_return "域名不能为空",-1
		if domainusername=session("user_name") then url_return "不能自己转给自己",-1
		'--------------转出限制-----------------------------
		if trim(session("user_name"))="yanzhou_chen" then
			url_return "此账号不允许转出域名！",-1
		end if
		'---------------------------------------------------
		'==================================================================================

		'判断用户是否存在并取出用户的可用金额
		sql="select u_usemoney,f_id from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "身份不正确！",-1
		end if
		
		if int(rs(1))>0 then
			url_return "对不起，你属于VCP子用户，不能转移！",-1
		end if
		rs.close
		sql="select d_id,userid,regdate,rexpiredate from domainlist where strDomain='"&DomainName&"' and userid="&session("u_sysid")
	
		rs.open sql,conn,1,1
		if not rs.eof then
			if dateDiff("d",rs("regdate"),date())<=15 then url_return "购买日要超过15天才能转出！",-1
			if dateDiff("d",date(),rs("rexpiredate"))<=15 then url_return "到期前15天不能转出！",-1
			d_id=trim(rs("d_id"))
			
		else
			url_return "此域名不是您的！",-1
		end if
		rs.close
		
		'转到的用户名是否存在
		sql="select u_id from userDetail where u_name='"& domainusername &"' and u_email='"& domainusermail &"'"
		rs.open sql,conn,1,1
		if not rs.eof then
		  tou_id=trim(rs("u_id"))
		else
		  url_return "没有找到要转入的用户",-1
		end if
		rs.close
		
		'跟改狱名所有人
		conn.execute("update domainlist set userid="& tou_id &" where d_id="& d_id)

		'写入财务记录
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("& tou_id &",0,0,'"&GetTimeRadom()&"','将域名"&DomainName&"从会员 "&session("user_name")&" 转出到了您的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")
		conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&session("u_sysid")&",0,0,'"&GetTimeRadom()&"','将域名"&DomainName&"从会员 "&session("user_name")&" 转出到"& domainusername &"的会员号下','"&now()&"','"&now()&"','"&now()&"',0)")

		writelog "域名"&DomainName&"从会员 "& session("user_name") &" 转出到"&  domainusername

		alert_redirect "操作成功","moveout.asp"
		'==================================================================================


End Select

End If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-业务转出</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language='JavaScript'>
function conFirmAmount()
{	
	var stConFirm = '请您再次确定此操作！\n';
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/manager/move/moveout.asp">业务转出</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


      
<table class="manager-table">
<form name="host" action="moveout.asp" method="post" onSubmit="return conFirmAmount()">
	<tr>
		<th>虚拟主机转出</th>
	</tr>
	<tr>
	  <td valign="top"  >
	  <input type="hidden" name="module" value="chghostuser">
		 <table  class="manager-table">
		  <tr>
			<th width="28%" align="right">我的主机名:</th>
			<td width="72%" align="left"><input name="hostname" type=text class="manager-input s-input" size =20 maxlength="20"></td>
		  </tr>
		  <tr>
			<th align="right">要转到的用户名:</th>
			<td align="left"><input name="hostusername" type=text class="manager-input s-input" size =20 maxlength="20"></td>
		  </tr>
		  <tr>
			<th align="right">要转到的用户邮箱:</th>
			<td align="left"><input name="hostusermail" type="text" class="manager-input s-input" size =20 maxlength="60"></td>
		  </tr>
		  <tr>
			<td colspan="2"><input name="sub2" type=button class="manager-btn s-btn" value="转出" onClick="return checkhost()"></td>
		  </tr>
		</table>
	 
		<script language="JavaScript">
				function checkhost()
				{
					if(host.hostname.value=="")
					{
						alert("请输入主机名！");
						host.hostname.focus();
						return false;
					}
					if(host.hostusername.value=="")
					{
						alert("请输入用户名！");
						host.hostusername.focus();
						return false;
					}
					if(host.hostusermail.value=="")
					{
						alert("请输入用户邮箱！");
						host.hostusermail.focus();
						return false;
					}
					if (confirm('您是否确定将此主机转出?'))
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
		<th>邮局客户转出 </th>
	</tr>
	<tr>
	  <td>
	  <input type="hidden" name="module" value="chgmailuser">
	  <table class="manager-table">
	  <tr>
		  <th align="right">我的邮局名:</th>
		  <td width="73%" align="left"><input name="mailname" type=text class="manager-input s-input" id="mailname" size =20 maxlength="20">						  </td>
	  </tr>
	  <tr>
		  <th align="right">要转到的用户名:</th>
	      <td align="left"> <input name="mailusername" type=text class="manager-input s-input" size =20 maxlength="20"> </td>
	  </tr>
	  <tr>
		  <th align="right">要转到的用户邮箱:</th>
		  <td align="left"><input name="mailusermail" type="text" class="manager-input s-input" size =20 maxlength="60"></td>
	  </tr>
	  <tr><td colspan="2" > <input name="sub" type=button class="manager-btn s-btn"  id="sub" value="转出" onClick="return checkMail()"></td></tr>
	  </table>
		<script language="JavaScript">
				function checkMail()
				{
					if(Mail.mailname.value=="")
					{
						alert("请输入邮局名！");
						Mail.mailname.focus();
						return false;
					}
					if(Mail.mailusername.value=="")
					{
						alert("请输入用户名！");
						Mail.mailusername.focus();
						return false;
					}
					if(Mail.mailusermail.value=="")
					{
						alert("请输入用户邮箱！");
						Mail.mailusermail.focus();
						return false;
					}
					if (confirm('您是否确定将此邮局转出?'))
					{
						Mail.submit();
					}
					
				}
			</script>                              </td>
	</tr>
  </form>
  <form name="Domain" action="moveout.asp" method="post" onSubmit="return conFirmAmount()">
 <tr> 	  
   <th> 域名转出 </th>
 </tr>
	<tr>
	  <td valign="top"  > 
		  <input name="module" type="hidden" id="module" value="chgDomainuser">
		   <table class="manager-table">
		   <tr><th align="right">域　名</th>
		   <td width="74%"  align="left"> <input name="DomainName" type=text class="manager-input s-input" id="DomainName" size =20 maxlength="40"></td></tr>
		   <tr>
		   <th align="right"> 要转到的用户名:</th>
		   <td  align="left"><input name="domainusername" type=text class="manager-input s-input" size =20 maxlength="20"> 								  </td></tr>
		   <tr>
			   <th  align="right">要转到的用户邮箱:</th>
			   <td align="left"><input name="domainusermail" type="text" class="manager-input s-input" size =20 maxlength="60"> </td></tr>
			   <tr><td colspan="2"><input name="sub" type=button class="manager-btn s-btn"  id="sub" value="转出" onClick="return checkDomain()"></td>
		   </tr>
		</table>
										 
		<script language="JavaScript">
				function checkDomain()
				{
					if(Domain.DomainName.value=="")
					{
						alert("请输入域名！");
						Domain.DomainName.focus();
						return false;
					}
					if(Domain.domainusername.value=="")
					{
						alert("请输入用户！");
						Domain.domainusername.focus();
						return false;
					}
					
					if(Domain.domainusermail.value=="")
					{
						alert("请输入用户邮箱！");
						Domain.domainusermail.focus();
						return false;
					}
					if (confirm('您是否确定将此域名转出?'))
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
            <span>说明</span>
        </div>
       <p>这个栏目是用于您将自己帐号下的业务转至<%=companyname%>的其他会员或代理帐号进行管理。适合于代理商将业务转给直接客户，由客户自己管理的情况。<br>
            <br>
            请在转入确认前仔细阅读以下转入条款：<br>
          		1、您必须是域名所有人或已获得域名所有人委托许可，委托管理域名或网址。因域名转换所有权引起的纠纷由操作方承担，发生纠纷时<%=companyname%>保留将域名分配给原来的注册人并重新审理域名的所有权的权利;<%=companyname%>保留按仲裁结果分配域名的权利。<br>
          		2、该域名或者虚拟主机必须是通过<%=companyname%>注册的才可以通过该功能转入。<br>
          		3、域名处于正常状态，没有任何争议，没有费用拖欠问题。<br>
            4、业务刚开通15天内或距业务过期日期不足15天的，禁止转出操作。<br>
            5、转出业务时，只变更该业务的所有人，不会自动续费。 <br>
            6、所有业务不能转入到VCP C模式及D模式的子用户下。
</p>
    </div>
         
         
         
       












		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>



 