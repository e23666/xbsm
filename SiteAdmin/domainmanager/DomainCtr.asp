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
		Response.Write("<script>alert(""����������³ɹ���"")</script>")
	else
		Response.Write("<script>alert(""�����������ʧ�ܣ�"")</script>")
	end if
elseif ACT="DEL" then
	stDom=requesta("Domain")

	sql="select d_id,strDomain from domainlist where strdomain='"&stDom&"'"
	set d_rs=Server.CreateObject("adodb.recordset")
	d_rs.open sql,conn,1,3
		do while not d_rs.eof 
			call Add_Event_logs(session("user_name"),1,d_rs("strDomain"),"���ݿ�ɾ������")
			d_rs.delete()
			d_rs.movenext
		loop
	d_rs.close
	set d_rs=nothing
	Alert_Redirect "����ɾ���ɹ���","default.asp"
elseif act="changepwd" then
	newpwd=requesta("p_pwd")
	stUser=requesta("user_name")
	strDomain=requesta("strDomain")
	  if isBad(stUser,newpwd,errinfo) then 
	  die url_return(replace(replace(errinfo,"ftp�û���","�û���"),"�û���","�û���"),-1)
	  end if	
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "����("& newpwd &")ӦΪ��ĸ���ֻ�_���,������5-20λ֮��",-1
	commandstr="domainname" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:domain-passwd" & vbcrlf & _
				"domainname:" & strDomain & vbcrlf & _
				"domainpwd:" & newpwd & vbcrlf & _
				"." & vbcrlf


	renewdata=pcommand(commandstr,stUser)
	if left(renewdata,3)="200" then
		alert_redirect "�޸�����ɹ�",request("script_name") & "?Domainid=" & Domainid
	else
		alert_redirect "�޸�����ʧ��:"& left(renewdata,4) ,request("script_name") & "?Domainid=" & Domainid
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
	url_return "����������",-1
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
		alert('����('+ v.value +')ӦΪ��ĸ���ֻ�_���,������5-20λ֮��');
		v.focus();
		return false;
	}
	f.action='<%=Request.ServerVariables("SCRIPT_NAME")%>';
	f.act.value="changepwd";
	f.target='_self';
	return confirm('ȷ���޸Ĵ�������?');

}
</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> ��������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">��������</a></span> | <a href="ModifyDomain.asp">��������У��</a> | <a href="DomainIn.asp">����ת��</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
<br />
<form name="form0" method="<%=ActionMethod%>" action="<%=MgrUrl%>" target="_blank">
  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
    <tr>
      <td width="31%" height="30" align="right" class="tdbg">��������</td>
      <td width="69%" height="30" class="tdbg"><input type="submit" name="submit1" value="���������������">
        ��ʾ:�����������������ʾ������������޸�����<a href="DomainCtr.asp?ACT=FlUSHPASS&Domain=<%=rs("strdomain")%>&User=<%=GetUserName(rs("userid"))%>&Domainid=<%=Domainid%>"><img src="/images/pic_03.gif" alt="��������" border="0"></a></td>
    </tr>
  </table>
  <%=hiddentxt%>
</form>
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
  <form name="form1" method="post" action="DomainCtr.asp?Domainid=<%=Domainid%>">
    <tr> 
      <td width="31%" align="right" class="tdbg">���ࣺ</td>
      <td width="69%" class="tdbg">
        <input type="radio" name="isreglocal" value="false" <%if not isreglocal then Response.write "checked"%>>
        ����, 
        <input type="radio" name="isreglocal" value="true" <%if isreglocal then Response.write " checked"%>>
        DNS������</td>
    </tr>
    <tr> 
      <td width="31%" align="right" class="tdbg">������</td>
      <td width="69%" class="tdbg"><%=rs("strdomain")%></td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">�������룺</td>
      <td class="tdbg">
        <table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td nowrap>
              <input type="text" name="p_pwd" value="<%=domainpwd%>" >
            </td>
            <td><a href="DomainCtr.asp?ACT=FlUSHPASS&Domain=<%=rs("strdomain")%>&User=<%=GetUserName(rs("userid"))%>&Domainid=<%=Domainid%>"><img src="/images/pic_03.gif" alt="��������" border="0"></a> 
              <input type="submit" name="adsf1" value="�޸�����" onClick="return changepwd(this.form)">
              <input type="hidden" name="user_name" value="<%=GetUserName(rs("userid"))%>">
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">����ע���̣�</td>
      <td align="left" class="tdbg">
        <select name="m_reg">
          <option value="default" <%if m_reg="default" then Response.write "selected"%>>Ĭ��ע����</option>
          <option value="bizcn" <%if m_reg="bizcn" then Response.write "selected"%>>�����й�</option>
          <option value="dnscn" <%if m_reg="dnscn" then Response.write "selected"%>>��������</option>
          <option value="netcn" <%if m_reg="netcn" then Response.write "selected"%>>����</option>
          <option value="xinet" <%if m_reg="xinet" then Response.write "selected"%>>����</option>
        </select>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">ע�����ڣ�</td>
      <td align="left" class="tdbg">
        <input name="regdate" type="text" id="regdate" value="<%=rs("regdate")%>">
      </td>
    </tr>
    <tr align="center">
      <td align="right" class="tdbg">�������ڣ�</td>
      <td align="left" class="tdbg">
        <input name="rexpiredate" type="text" id="regdate" value="<%=rs("rexpiredate")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">���ޣ�</td>
      <td align="left" class="tdbg">
        <select name="years" id="years">
          <%for i= 1 to 10%>
          <option value="<%=i%>"<%if rs("years")=i then%> selected<%end if%>><%=i%>��</option>
          <%next%>
        </select>
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNS1��</td>
      <td align="left" class="tdbg">
        <input name="dns_host1" type="text" id="dns_host1" value="<%=rs("dns_host1")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNS2��</td>
      <td align="left" class="tdbg">
        <input name="dns_host2" type="text" id="dns_host2" value="<%=rs("dns_host2")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNSip1��</td>
      <td align="left" class="tdbg">
        <input name="dns_ip1" type="text" id="dns_ip1" value="<%=rs("dns_ip1")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">DNSip2��</td>
      <td align="left" class="tdbg">
        <input name="dns_ip2" type="text" id="dns_ip2" value="<%=rs("dns_ip2")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">��Ʒ����:</td>
      <td align="left" class="tdbg"> 
        <input name="proid" type="text" id="dns_ip2" value="<%=rs("proid")%>">
      </td>
    </tr>
    <tr align="center"> 
      <td align="right" class="tdbg">ɾ��������</td>
      <td align="left" class="tdbg">
        <table border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td nowrap><a href=#  onClick="javascript:if(confirm('��ȷ��ִ��ɾ������ô��')){location.href='DomainCtr.asp?ACT=DEL&Domain=<%=rs("strdomain")%>&Domainid=<%=Domainid%>'}"><span class="STYLE4">ɾ��������</span></a></td>
            <td><a href=# onClick="javascript:if(confirm('��ȷ��ִ��ɾ������ô��')){location.href='DomainCtr.asp?ACT=DEL&Domain=<%=rs("strdomain")%>&Domainid=<%=Domainid%>'}"><img src="/images/20070730192531213.gif" alt="ɾ��" border="0"></a></td>
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
      <td align="left" class="tdbg"><span class="STYLE4">���³ɹ�</span> </td>
    </tr>
    <%end if%>
    <tr align="center"> 
      <td align="right" class="tdbg">������ע��</td>
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
        <input type="submit" name="button" id="button" value=" ȷ������������Ϣ ">
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
