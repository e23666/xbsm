<!--#include virtual="/config/config.asp"-->
<%

Check_Is_Master(1)

conn.open constr

UserName=Requesta("UserName")
Domain=Requesta("Domain")
Password=Requesta("Password")
Proid=Requesta("Proid")
ServerIP=Requesta("ServerIP")
BuyDate=Requesta("BuyDate")
Years=Requesta("Years")
s_comment=Requesta("s_comment")

if requesta("ACT")<>"" then
  Sql="Select u_id from userdetail where u_name='" & UserName & "'"
  Rs.open Sql,conn,1,1
  if Rs.eof then url_return "用户名未找到",-1
  u_id=Rs("u_id")
  Rs.close
  Sql="Select * from productlist where p_proid='" & Proid & "'"
  Rs.open Sql,conn,1,1
  if Rs.eof then url_return "不可能呀，断言失败",-1

'm_sysid m_ownerid m_bindname m_aliases m_productId m_buydate m_expiredate m_updatedate m_bizbid m_serverip m_mastername m_password m_size m_mxuser m_years m_status m_father 
  Sql="insert into MailSiteList (m_ownerid,m_bindname,m_productId,m_buydate,m_expireDate,m_updatedate,m_bizbid,m_serverip,m_mastername,m_password,m_size,m_mxuser,m_years,m_status,m_father) values ("
  Sql=Sql & u_id &",'" & Domain & "','" & Proid & "','" & BuyDate & "','" & DateAdd("yyyy",Years,BuyDate) & "',now(),1,'" & ServerIP & "','webmaster','" & Password &"'," & rs("p_size") & "," & Rs("p_maxmen") &"," & Years & ",0," & u_id &")"
  conn.Execute(Sql)
  if s_comment<>"" then
	sql="select m_sysid from mailsitelist where m_bindname='" & Domain & "'"
	rs1.open sql,conn,1,1
	if not rs1.eof then
	  sql="update mailsitelist set m_free=1 where m_sysid=" & rs1("m_sysid")
	  conn.Execute(Sql)
	  sql="update vhhostlist set s_mid=" & rs1("m_sysid") & ",s_defaultbindings='" & domain & "' where s_comment='" & s_comment & "'"
	  conn.Execute(Sql)
	end if
	rs1.close
  end if
  url_return "邮局添加成功，请手工扣款",-1  
else
	Sql="Select p_proid from productlist where p_type=2 order by p_proid"
	Rs.open Sql,conn,1,1
	do while not Rs.eof
		ProString=ProString & "<option value=" & Rs("p_proid") & ">" & Rs("p_proid") &"</option>"
	Rs.moveNext
	loop
	Rs.close
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 企业邮局管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">企业邮局管理</a> | <a href="MailAdd.asp">手工添加企业邮局</a> 
      | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
  <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="border">
<form name="form1" method="post" action="MailAdd.asp">
    <tr> 
      <td align="right" class="tdbg">所属用户：</td>
      <td class="tdbg"> 
      <input type="text" name="UserName" value="<%=UserName%>" size="10">      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">域名：</td>
      <td class="tdbg"> 
      <input type="text" name="Domain" value="<%=Domain%>">      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">管理密码：</td>
      <td class="tdbg"> 
      <input type="text" name="PassWord" value="<%=PassWord%>" size="10">      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">邮局类型：</td>
      <td class="tdbg"> 
        <select name="Proid">
          <%=ProString%> 
        </select>      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">服务器IP：</td>
      <td class="tdbg"> 
      <input type="text" name="ServerIP" value="<%=ServerIP%>" size="15">      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">开通时间：</td>
      <td class="tdbg"> 
        <input type="text" name="BuyDate" value="<%=BuyDate%>" size="12">
      (yyyy-MM-dd)</td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">年限：</td>
      <td class="tdbg"> 
      <input type="text" name="Years" value="<%=Years%>" size="6">      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">对应虚拟主机：</td>
      <td class="tdbg"> 
        <input type="text" name="s_comment" size="15">
        <br>
        如果为空，收费邮局<br>
      如果不为空，免费邮局</td>
    </tr>
    <tr> 
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg"><input name="Submit" type="submit" value="　确认添加　">
      <input name="ACT" type="hidden" id="ACT" value="ADD"></td>
    </tr>
  </form>
</table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
