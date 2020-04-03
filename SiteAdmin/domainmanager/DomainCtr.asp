<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)%>
<%

Function FindDomainUser(Byval domainname,byref regcode)
	set lrs=conn.Execute("select a.u_name,b.bizcnorder from userdetail as a inner join domainlist as b on a.u_id=b.userid where b.strdomain='" & domainname & "'")
	if not lrs.eof then
		FindDomainUser=lrs(0)
		regcode=lrs(1)
	else
		FindDomainUser=""
		regcode=""
	end if
	lrs.close:set lrs=nothing
end Function

conn.open constr
Domainid=requesta("Domainid")
ACT=requesta("ACT")
if ACT="Memo" then
	Remark=requesta("Remark")
	sql="select * from domainlist where d_id="&Domainid
	rs.open sql,conn,1,3
	rs("s_memo")=Remark
	rs("regdate")=requesta("regdate")
	rs("rexpiredate")=requesta("rexpiredate")
	rs("years")=requesta("years")
	rs("dns_host1")=requesta("dns_host1")
	rs("dns_host2")=requesta("dns_host2")
	rs("dns_ip1")=requesta("dns_ip1")
	rs("dns_ip2")=requesta("dns_ip2")
	rs("bizcnorder")=requesta("m_reg")
	rs("proid")=requesta("proid")
	rs("isreglocal")=requesta("isreglocal")
	rs.update
	rs.close
elseif ACT="FlUSHPASS" then
	stDom=requesta("Domain")
	stUser=requesta("User")
	if left(GetOperationPassWord(stDom,"domain",stUser),3)="200" then
		Response.Write("<script>alert(""域名密码更新成功！"")</script>")
	else
		Response.Write("<script>alert(""域名密码更新失败！"")</script>")
	end if
elseif ACT="DEL" then
	stDom=requesta("Domain")

	sql="select d_id,strDomain from domainlist where strdomain='"&stDom&"'"
	set d_rs=Server.CreateObject("adodb.recordset")
	d_rs.open sql,conn,1,3
		do while not d_rs.eof 
			call Add_Event_logs(session("user_name"),1,d_rs("strDomain"),"数据库删除操作")
			d_rs.delete()
			d_rs.movenext
		loop
	d_rs.close
	set d_rs=nothing
	Alert_Redirect "域名删除成功！","default.asp"
elseif act="changepwd" then
	newpwd=requesta("p_pwd")
	stUser=requesta("user_name")
	strDomain=requesta("strDomain")
	  if isBad(stUser,newpwd,errinfo) then 
	  die url_return(replace(replace(errinfo,"ftp用户名","用户名"),"用户名","用户名"),-1)
	  end if	
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "密码("& newpwd &")应为字母数字或_组成,长度在5-20位之间",-1
	commandstr="domainname" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:domain-passwd" & vbcrlf & _
				"domainname:" & strDomain & vbcrlf & _
				"domainpwd:" & newpwd & vbcrlf & _
				"." & vbcrlf


	renewdata=pcommand(commandstr,stUser)
	if left(renewdata,3)="200" then
		alert_redirect "修改密码成功",request("script_name") & "?Domainid=" & Domainid
	else
		alert_redirect "修改密码失败:"& left(renewdata,4) ,request("script_name") & "?Domainid=" & Domainid
	end if
	rs.close
	conn.close
	response.end
end if

sql="select * from domainlist where d_id="&Domainid
rs.open sql,conn,1,3
if rs.eof or rs.bof then
	rs.close
	conn.close
	url_return "域名不存在",-1
end if

ActionMethod=""
hiddentxt=""
MgrUrl=""
domainpwd=""
CanAccess=false
strDomain=rs("strdomain")
strReg=rs("bizcnorder")
s_memo=rs("s_memo")
dns_host1=rs("dns_host1")
strDomainpwd=rs("strDomainpwd")
m_reg=rs("bizcnorder")
isreglocal=rs("isreglocal")
call doupfile(strDomain,"")
Call GetManager(strDomain,strReg,dns_host1,strDomainpwd,ActionMethod,hiddentxt,MgrUrl,CanAccess,domainpwd)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #FF0000
}
-->
</style>
<script language=javascript>
function changepwd(f){
	var v=f.p_pwd;
	var regv=/^[\w]{5,20}$/;
	
	if (!regv.test(v.value)){
		alert('密码('+ v.value +')应为字母数字或_组成,长度在5-20位之间');
		v.focus();
		return false;
	}
	f.action='<%=Request.ServerVariables("SCRIPT_NAME")%>';
	f.act.value="changepwd";
	f.target='_self';
	return confirm('确定修改此密码吗?');

}
</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 域名管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">域名管理</a></span> | <a href="ModifyDomain.asp">域名日期校正</a> | <a href="DomainIn.asp">域名转入</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
<br />
<form name="form0" method="<%=ActionMethod%>" action="<%=MgrUrl%>" target="_blank">
  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
    <tr>
      <td width="31%" height="30" align="right" class="tdbg">域名管理：</td>
      <td width="69%" height="30" class="tdbg"><input type="submit" name="submit1" value="点击进入域名管理">
        提示:如果进入域名管理提示密码错误，请先修改密码<a href="DomainCtr.asp?ACT=FlUSHPASS&Domain=<%=rs("strdomain")%>&User=<%=GetUserName(rs("userid"))%>&Domainid=<%=Domainid%>"><img src="/images/pic_03.gif" alt="更新密码" border="0"></a></td>
    </tr>
  </table>
  <%=hiddentxt%>
</form>
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
  <form name="form1" method="post" action="DomainCtr.asp?Domainid=<%=Domainid%>">
    <tr> 
      <td width="31%" align="right" class="tdbg">种类：</td>
      <td width="69%" class="tdbg">
        <input type="radio" name="isreglocal" value="false" <%if not isreglocal then Response.write "checked"%>>
        域名, 
        <input type="radio" name="isreglocal" value="true" <%if isreglocal then Response.write " checked"%>>
        DNS管理器</td>
    </tr>
    <tr> 
      <td width="31%" align="right" class="tdbg">域名：</td>
      <td width="69%" class="tdbg"><%=rs("strdomain")%></td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">域名密码：</td>
      <td class="tdbg">
        <table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td nowrap>
              <input type="text" name="p_pwd" value="<%=domainpwd%>" >
            </td>
            <td><a href="DomainCtr.asp?ACT=FlUSHPASS&Domain=<%=rs("strdomain")%>&User=<%=GetUserName(rs("userid"))%>&Domainid=<%=Domainid%>"><img src="/images/pic_03.gif" alt="更新密码" border="0"></a> 
              <input type="submit" name="adsf1" value="修改密码" onClick="return changepwd(this.form)">
              <input type="hidden" name="user_name" value="<%=GetUserName(rs("userid"))%>">
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">所属注册商：</td>
      <td align="left" class="tdbg">
        <select name="m_reg">
          <option value="default" <%if m_reg="default" then Response.write "selected"%>>默认注册商</option>
          <option value="bizcn" <%if m_reg="bizcn" then Response.write "selected"%>>商务中国</option>
          <option value="dnscn" <%if m_reg="dnscn" then Response.write "selected"%>>新网互联</option>
          <option value="netcn" <%if m_reg="netcn" then Response.write "selected"%>>万网</option>
          <option value="xinet" <%if m_reg="xinet" then Response.write "selected"%>>新网</option>
        </select>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">注册日期：</td>
      <td align="left" class="tdbg">
        <input name="regdate" type="text" id="regdate" value="<%=rs("regdate")%>">
      </td>
    </tr>
    <tr align="center">
      <td align="right" class="tdbg">到期日期：</td>
      <td align="left" class="tdbg">
        <input name="rexpiredate" type="text" id="regdate" value="<%=rs("rexpiredate")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">年限：</td>
      <td align="left" class="tdbg">
        <select name="years" id="years">
          <%for i= 1 to 10%>
          <option value="<%=i%>"<%if rs("years")=i then%> selected<%end if%>><%=i%>年</option>
          <%next%>
        </select>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNS1：</td>
      <td align="left" class="tdbg">
        <input name="dns_host1" type="text" id="dns_host1" value="<%=rs("dns_host1")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNS2：</td>
      <td align="left" class="tdbg">
        <input name="dns_host2" type="text" id="dns_host2" value="<%=rs("dns_host2")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNSip1：</td>
      <td align="left" class="tdbg">
        <input name="dns_ip1" type="text" id="dns_ip1" value="<%=rs("dns_ip1")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNSip2：</td>
      <td align="left" class="tdbg">
        <input name="dns_ip2" type="text" id="dns_ip2" value="<%=rs("dns_ip2")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">产品类型:</td>
      <td align="left" class="tdbg"> 
        <input name="proid" type="text" id="dns_ip2" value="<%=rs("proid")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">删除域名：</td>
      <td align="left" class="tdbg">
        <table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td nowrap><a href=#  onClick="javascript:if(confirm('您确认执行删除操作么？')){location.href='DomainCtr.asp?ACT=DEL&Domain=<%=rs("strdomain")%>&Domainid=<%=Domainid%>'}"><span class="STYLE4">删除该域名</span></a></td>
            <td><a href=# onClick="javascript:if(confirm('您确认执行删除操作么？')){location.href='DomainCtr.asp?ACT=DEL&Domain=<%=rs("strdomain")%>&Domainid=<%=Domainid%>'}"><img src="/images/20070730192531213.gif" alt="删除" border="0"></a></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="center"> 
      <td align="center" class="tdbg">&nbsp;</td>
      <td align="left" class="tdbg">&nbsp;</td>
    </tr>
    <%if ACT="Memo" then%>
    <tr align="center"> 
      <td align="center" class="tdbg">&nbsp;</td>
      <td align="left" class="tdbg"><span class="STYLE4">更新成功</span> </td>
    </tr>
    <%end if%>
    <tr align="center"> 
      <td align="right" class="tdbg">域名备注：</td>
      <td align="left" class="tdbg">
        <textarea name="Remark" cols="50" rows="4" id="Remark"><%=rs("s_memo")%></textarea>
        <input name="act" type="hidden" id="act" value="Memo">
        <input type="hidden" name="Domainid" value="<%=Domainid%>">
        <input type="hidden" name="strDomain" value="<%=rs("strdomain")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="center" class="tdbg">&nbsp;</td>
      <td align="left" class="tdbg"> 
        <input type="submit" name="button" id="button" value=" 确定更新域名信息 ">
      </td>
    </tr>
  </form>
</table>
<p>&nbsp;</p>
</body>
</html>
<%
conn.close
sub GetManager(Byval strDomain,Byval Register,Byval dns1,Byval dftpwd,Byref ActionMethod,Byref hiddentxt,Byref MgrUrl,Byref CanAccess,ByRef domainpwd)
	if default_dns1=dns1 then
			domainpwd=dftpwd	
			CanAccess=true
			ActionMethod="POST"
			MgrUrl=manager_url&"domain/checklogin.asp"
			hiddentxt="<input type=hidden name=""domainname"" value=""" & strDomain & """>"
			hiddentxt=hiddentxt & "<input type=hidden name=""password"" value=""" & domainpwd & """>"		
	else
			GetPass="other" & vbcrlf & "get" & vbcrlf & "entityname:domainpassword" & vbcrlf & "domainname:" & strDomain & vbcrlf & "." & vbcrlf
			LoadRet=PCommand(GetPass,FindDomainUser(strDomain,regcode))
			if left(LoadRet,3)="200" then
				domainpwd=getReturn(LoadRet,"domainpassword")
			else
				domainpwd="********"
			end if
			if left(strDomain,4)="xn--" and (Register="xinet" or Register="bizcn") then
				strDomain=s_memo
			end if
			select case Register
				case "xinet"
					ActionMethod="POST"
					CanAccess=xinet_allowmgr
					MgrUrl="http://dcp.xinnet.com/domainLogin.do?method=domainEnter"
					hiddentxt="<input type=hidden name=domainName value=""" & strDomain & """>" & vbcrlf
					hiddentxt=hiddentxt & "<input type=hidden name=password value=""" & domainpwd & """>"
				case "bizcn"
					ActionMethod="POST"
					CanAccess=bizcn_allowmgr
					MgrUrl="http://cache.cdncache.net/domainportal"
					hiddentxt="<input type=hidden name=""module"" value=""login"">"
					hiddentxt=hiddentxt & "<input type=hidden name=""domainname"" value=""" & strDomain & """>"
					hiddentxt=hiddentxt & "<input type=hidden name=""password"" value=""" & domainpwd & """>"
				case "netcn"
					ActionMethod="GET"
					CanAccess=netcn_allowmgr
					MgrUrl="http://diy.hichina.com/"
					hiddentxt=""
				case "dnscn"
					ActionMethod="GET"
					CanAccess=dnscn_allowmgr
					MgrUrl="http://mgt.dns.com.cn"
					hiddentxt=""
				case else
					CanAccess=true
					ActionMethod="POST"
					MgrUrl=manager_url&"domain/checkloginsign.asp"
					hiddentxt="<input type=hidden name=""domainname"" value=""" & strDomain & """>"
					hiddentxt=hiddentxt & "<input type=hidden name=""sign"" value=""" &WestSignMd5(strDomain,domainpwd) & """>"
			end select
	end if
	
end sub


%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
