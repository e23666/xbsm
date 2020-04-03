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
			levelmoveSet=false '禁止转入
		else
			levelmoveSet=true '允许
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
			url_return "请输入主机名",-1
		end if
		movepd=levelmoveSet("host",hostname)
		if not movepd then url_return "此主机禁止转入",-1
		'==================================================================================
		'杨珂修改的
		'转入虚拟主机
		
		
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
				
		'判断虚拟主机密码是否正确并取得p_ProId
		hostpassword=requesta("hostpassword")
		if trim(hostpassword)="" then url_return "虚拟主机名或主机密码发生错误！",-1
		rs.close
		sql="select s_ProductId,s_sysid,s_mid,S_ownerid,s_expiredate,s_ftppassword,u_name from vhhostlist,UserDetail   where S_ownerid=u_id and s_comment='"&hostname&"'"
	 
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "虚拟主机名或主机密码发生错误1！",-1
		end if
		
		retstr=GetOperationPassWord(hostname,"host",rs("u_name"))
		 
		if left(retstr,3)="200" then
	 		p=getReturn(retstr,"ftppassword") 
			if trim(p)<>trim(hostpassword) then
			url_return "虚拟主机名或主机密码发生错误2！",-1
			end if
		else
			url_return "虚拟主机名或主机密码发生错误3！",-1
		end if

		

		if CheckIsBuyTestHost(hostname) then
			url_return "试用主机不能转入！",-1
		end if
		p_ProId=rs(0) '产品的proid
		s_sysid=rs(1)'id
		OldS_ownerid=rs(3)'旧的所有人id
		OldS_ownerName="未找到"

		rs.close
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if
		
		if OldS_ownerid=session("u_sysid") then
			url_return "你不能将主机从自己名下转到自己名下！",-1
		end if
		

		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "余额不足",-1
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
			writelog "虚拟主机"&hostname&"从会员 "&OldS_ownerName&" 转入到"&session("user_name") 
			alert_redirect "操作成功","movein.asp"
		else
			conn.execute("update vhhostlist  set s_ownerid="&OldS_ownerid&",m_father="&OldS_ownerid&" where m_sysid="&s_sysid&"")
			url_return "虚拟主机转入失败",-1
		end if

	  case "chgmailuser"
		mailname=requesta("mailname")
        If mailname=""  Then url_return "邮局名不能为空",-1
  		movepd=levelmoveSet("mail",mailname)
		if not movepd then url_return "此邮局禁止转入",-1
		'==================================================================================
		'杨珂修改的
		'转入邮局
		
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
		
		
		'判断邮局密码是否正确并取得p_ProId
		MailMasterPassword=requesta("MailMasterPassword")
		rs.close
		sql="select m_productId,m_sysid,m_ownerid,m_expiredate from mailsitelist where m_bindname='"&mailname&"' and  m_password='"&MailMasterPassword&"'"
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "邮局名或管理密码发生错误！",-1
		end if
		
		p_ProId=rs(0) '产品的proid
		OldS_ownerid=rs(2)'旧的所有人id
		OldS_ownerName="未找到"
		rs.close
		
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if

		
		if OldS_ownerid=session("u_sysid") then
			url_return "你不能将邮局从自己名下转到自己名下！",-1
		end if

		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "余额不足",-1
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
			writelog "企业邮局"&mailname&"从会员 "&OldS_ownerName&" 转入到"&session("user_name") 
			alert_redirect "操作成功","movein.asp"
		else
			conn.Execute("update mailsitelist set m_ownerid=" & OldS_ownerid & " where m_bindname='" & mailname & "'")	
			url_return "续费失败，转入失败",-1
		end if	
		'==================================================================================
		
	  case "chgDomainuser"
		'If requesta("DomainName")<>"" Then DomainName=checkInputType(requesta("DomainName"),"domain")
		DomainName=requesta("DomainName")
        If DomainName=""  Then url_return "域名不能为空",-1
		movepd=levelmoveSet("domain",trim(DomainName))
		if not movepd then url_return "此域名禁止转入",-1
		'---------------------------------------------------
		'==================================================================================
		'杨珂修改的
		'转入邮局
		'判断用户是否存在并取出用户的可用金额
		sql="select u_usemoney,f_id,u_name from UserDetail where u_id="&session("u_sysid")&""
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "身份不正确！",-1
		end if
		
		if int(rs(1))>0 then
			url_return "对不起，你属于VCP子用户，不能转移！",-1
		end if
		
		'判断邮局密码是否正确并取得p_ProId
		DomainPass=requesta("DomainPass")
		rs.close
		sql="select proid,userid,rexpiredate from domainlist where strDomain='"&DomainName&"' and strDomainpwd='"&DomainPass&"'"
		rs.open sql,conn,1,1
		if rs.eof then
			rs.close
			url_return "域名或管理密码发生错误！",-1
		end if
		
		p_ProId=rs(0) '产品的proid
		OldS_ownerid=rs(1)'旧的所有人id
		rexpiredate=rs("rexpiredate")
		OldS_ownerName="未找到"
		
		if OldS_ownerid=session("u_sysid") then
			url_return "你不能将域名从自己名下转到自己名下！",-1
		end if
		
		rs.close
		sql="select u_name from UserDetail where u_id="&OldS_ownerid&""
		rs.open sql,conn,1,1
		if not rs.eof then
		OldS_ownerName=rs(0)
		end if
		
		if not CheckEnoughMoney(session("user_name"),p_ProId,1,"renew",true) then
			url_return "余额不足",-1
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
			writelog "域名"&DomainName&"从会员 "&OldS_ownerName&" 转入到"&session("user_name") 
			alert_redirect "操作成功","movein.asp"
		else
			conn.execute("update domainlist set userid="& OldS_ownerid &" where strDomain='"&DomainName&"'")
			url_return "因续费失败,域名转入失败",-1
		end if
End Select

End If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-业务转入</title>
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
			   <li><a href="/manager/move/movein.asp">业务转入</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 


<form name="host" action="movein.asp" method="post" onSubmit="return conFirmAmount()">
<table class="manager-table">
                            <tr>
                              <th>
                                  虚拟主机转入
						     </th>
                            </tr>
                            <tr>
                              <td > 
                                  <input type="hidden" name="module" value="chghostuser">
                                  主机名:
                                  <input name="hostname" type=text class="manager-input s-input" size =20>
                                  主机密码:
                                  <input name="hostpassword" type=password class="manager-input s-input" size =20>
                                  &nbsp;
                                  <script language="JavaScript">
										function checkhost()
										{
											if(host.hostname.value=="")
											{
												alert("请输入主机名！");
												host.hostname.focus();
												return false;
											}
											if(host.hostpassword.value=="")
											{
												alert("请输入主机密码！");
												host.hostpassword.focus();
												return false;
											}
											
											if (confirm('您是否确定将此主机转入到您的用户名下并自动续费一年？'))
											{
												host.submit();
											}
											
										}
									</script>
                                  <input name="sub2" type=button class="manager-btn s-btn" value="转入" onClick="return checkhost()" >
                              </td>
                            </tr>
                          </form>
                          <form name="Mail" action="movein.asp" method="post" onSubmit="return conFirmAmount()">
                            <tr>
                              <th>邮局客户转入</th>
                            </tr>
                            <tr>
                              <td >
                                  <input type="hidden" name="module" value="chgmailuser">
                                  邮局名:
                                  <input name="mailname" type=text class="manager-input s-input" id="mailname" size =20>
                                  邮局密码:
                                  <input name="MailMasterPassword" type=password class="manager-input s-input" size =20>
                                  &nbsp;
                                  <input name="sub" type=button class="manager-btn s-btn" id="sub" value="转入" onClick="return checkMail()" >
                                  <script language="JavaScript">
										function checkMail()
										{
											if(Mail.mailname.value=="")
											{
												alert("请输入邮局域名！");
												Mail.mailname.focus();
												return false;
											}
											if(Mail.MailMasterPassword.value=="")
											{
												alert("请输入邮局密码！");
												Mail.MailMasterPassword.focus();
												return false;
											}
											
											if (confirm('您是否确定将此邮局转入到您的用户名下？'))
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
                              <th>域名转入</th>
                            </tr>
                            <tr>
                              <td>
                                  <input name="module" type="hidden" id="module" value="chgDomainuser">
                                  域　名:
                                  <input name="DomainName" type=text class="manager-input s-input" id="DomainName" size =20>
                                  域名密码:
                                  <input name="DomainPass" type=password class="manager-input s-input" id="DomainPass" size =20>
                                  &nbsp;
                                  <input name="sub" type=button class="manager-btn s-btn" id="sub" value="转入" onClick="return checkDomain()" >
                                  <script language="JavaScript">
										function checkDomain()
										{
											if(Domain.DomainName.value=="")
											{
												alert("请输入域名！");
												Domain.DomainName.focus();
												return false;
											}
											if(Domain.DomainPass.value=="")
											{
												alert("请输入域名密码！");
												Domain.DomainPass.focus();
												return false;
											}
											
											if (confirm('您是否确定将此域名转入到您的用户名下并自动续费一年？'))
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
            <span>说明</span>
        </div>
       <p>这个栏目是用于您将<%=companyname%>会员的或通过<%=companyname%>其他代理注册的域名或虚拟主机转入到您的管理中心来进行管理。请在转入确认前仔细阅读以下转入条款：<br>
                                           1、您必须是域名所有人或已获得域名所有人委托许可，委托管理域名或网址。因域名转换所有权引起的纠纷由操作方承担，发生纠纷时<%=companyname%>保留将域名分配给原来的注册人并重新审理域名的所有权的权利;<%=companyname%>保留按仲裁结果分配域名的权利。<br>
                                           2、该域名或者虚拟主机必须是通过<%=companyname%>注册的才可以通过该功能转入。<br>
                                           3、域名处于正常状态，没有任何争议，没有费用拖欠问题。<br>
                                           4、域名注册成功超过60天，或域名续费成功超过60天，未到60天的不允许操作。<br>
                                           5、您将业务转入您代理界面时必须同时为该业务续交一年的注册费，费用按您的代理购买价格直接从您的预付款中扣除。<br>
                                           6、虚拟主机一旦转入成功，其伴随的企业邮局服务也会自动转移过来。<br>
                                           7、您可通过与域名所有人（代理、会员）联系得到域名密码，如果他们忘记密码请在业务管理中心栏目中查询该业务的密码。 <br>
                                         8、所有业务不能转入到VCP C模式及D模式的子用户下。
</p>
    </div>


		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>






 