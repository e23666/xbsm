<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
response.Buffer=true
conn.open constr
 
if ishttps() then manager_url=replace(manager_url,"http://","https://")
p_id=requesta("p_id")
act=trim(requesta("act"))
if len(p_id)<=0 then url_return "��������",-1
sql="select * from domainlist where d_id="& p_id &" and userid="& session("u_sysid")
rs.open sql,conn,1,3
if rs.eof and rs.bof then rs.close:conn.close:url_return "û���ҵ��˲�Ʒ",-1
strDomain=rs("strDomain")
strDomainpwd=rs("strDomainpwd")
strReg=rs("bizcnorder")
regdate=rs("regdate")
rexpiredate=rs("rexpiredate")
dns_host1=rs("dns_host1")
dns_ip1=rs("dns_ip1")
dns_host2=rs("dns_host2")
dns_ip2=rs("dns_ip2")

rzupfile=doupfile(strDomain,"")


tomanagerdomain=trim(strdomain)&""
strDomain11=strDomain

byear=requesta("byear")
if byear="" then byear=1
byear=cint(byear)
urlproid="urlforword"
urlneedPrice=0
dim urlstate
dim url_buydate,url_buyyear
checkUrlforward()

	

if left(tomanagerdomain,4)="xn--" and (strReg="bizcn" or strReg="xinet") and len(trim(rs("s_memo"))&"")>0 then 
	tomanagerdomain=rs("s_memo")
end if
if left(tomanagerdomain,4)="xn--" and (strReg="bizcn" or strReg="xinet") then
	tomanagerdomain=Gbkcode(tomanagerdomain)
end if
if act="changepwd" then
	newpwd=requesta("p_pwd")
	
		    if isBad(session("user_name"),newpwd,errinfo) then 
				   die url_return(replace(replace(errinfo,"ftp�û���","�û���"),"�û���","�û���"),-1)
			end if	
			
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "����("& newpwd &")ӦΪ��ĸ���ֻ�_���,������5-20λ֮��",-1
	commandstr="domainname" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:domain-passwd" & vbcrlf & _
				"domainname:" & strDomain & vbcrlf & _
				"domainpwd:" & newpwd & vbcrlf & _
				"." & vbcrlf


	renewdata=pcommand(commandstr,session("user_name"))
	if left(renewdata,3)="200" then
		alert_redirect "�޸�����ɹ�",request("script_name") & "?p_id=" & p_id
	else
		alert_redirect "�޸�����ʧ��:"& left(renewdata,4) ,request("script_name") & "?p_id=" & p_id
	end if
	rs.close
	conn.close
	response.end
elseif act="syn" then
	returnstr=doUserSyn("domain",strDomain)
	if left(returnstr,3)="200" then
		alert_redirect "�������ݳɹ�",request("script_name") & "?p_id=" & p_id
	else
	 	alert_redirect "��������ʧ��" & returnstr,request("script_name") & "?p_id=" & p_id
	end if
elseif act="buyurl" then

	if session("u_usemoney") < urlneedPrice or urlneedPrice<0 then url_return "���㣬���ȳ�Ԥ���",-1
	commandstr ="domainname" & vbcrlf & _
				urlstate & vbcrlf & _
				"entityname:urlforword" & vbcrlf & _
				"domainname:" & strDomain & vbcrlf & _
				"buyyear:" & byear & vbcrlf & _
				"." & vbcrlf	

	buyResult=PCommand(commandstr,session("user_name"))

	if Left(buyResult,4)="200 " then
		ss_buydate=now()
		ss_buyyear=byear
		if urlstate="open" then
			response.Write "��ͨ�ɹ��������ڿ��Ե������߼���������ת���ˡ�"
		else
			response.Write "���ѳɹ�"
		end if
	elseif left(buyResult,11)="500 already" Then
		'����Ѿ���ͨ�����±������ݿ���Ϣ��
		tmp1=split(buyResult,vbcrlf) '���أ�������Ϣ�����ڣ����ޡ�
		ss_buydate=tmp1(1)
		ss_buyyear=tmp1(2)
		response.Write "�������Ѿ���ͨ��ת������"
	else
		response.Write "��ͨʧ�ܣ�" & buyResult
		response.End()
	end if

	on error resume next
	Err.clear
	if urlstate="open" then 
	sql="update [domainlist] set url_buydate='" & now() & "' where strDomain='" & strdomain & "'"
	conn.execute(sql)
	sql="update [domainlist] set url_buyyear=" & byear & " where strDomain='" & strdomain & "'"
	conn.execute(sql)
	elseif urlstate="reopen" then 
	sql="update [domainlist] set url_buyyear= url_buyyear + " & byear & " where strDomain='" & strdomain & "'"
	conn.execute(sql)
	end if
	if err<>0 then response.write "��<font color=red>����������Ϣ����ʧ��</font>"
	response.End()
end if

rs.close

ActionMethod=""
hiddentxt=""
MgrUrl=""
domainpwd=""
CanAccess=false

Call GetManager(tomanagerdomain,strReg,dns_host1,strDomainpwd,ActionMethod,hiddentxt,MgrUrl,CanAccess,domainpwd)


sub GetManager(Byval strDomain,Byval Register,Byval dns1,Byval dftpwd,Byref ActionMethod,Byref hiddentxt,Byref MgrUrl,Byref CanAccess,ByRef domainpwd)
	if default_dns1=dns1 then
			domainpwd=dftpwd	
			CanAccess=true
			ActionMethod="POST"
			MgrUrl=manager_url&"domain/checklogin.asp"
			hiddentxt="<input type=hidden name=""domainname"" value=""" & strDomain & """>"
			hiddentxt=hiddentxt & "<input type=hidden name=""password"" value=""" & domainpwd & """>"		
	else
			GetPass="other" & vbcrlf & "get" & vbcrlf & "entityname:domainpassword" & vbcrlf & "domainname:" & strDomain11 & vbcrlf & "." & vbcrlf
			LoadRet=PCommand(GetPass,Session("user_name"))
			if left(LoadRet,3)="200" then
				domainpwd=getReturn(LoadRet,"domainpassword")
			else
				domainpwd="********"
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
					MgrUrl=manager_url&"domain/checklogin.asp"
					hiddentxt="<input type=hidden name=""domainname"" value=""" & strDomain & """>"
					hiddentxt=hiddentxt & "<input type=hidden name=""password"" value=""" & domainpwd & """>"
			end select
	end if
	
end sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
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
			   <li>��������</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		   <form name="form1" action="<%=MgrUrl%>" method=<%=ActionMethod%>>
              <table  class="manager-table"> 
                <tr>
                  <th align="right">������</th>
                  <td align="left"> <%=domainlook(strDomain)%></td>
                  <th align="right">���룺</th>
                  <td align="left"> <%if canAccess then%>
                    <input type=text value="<%=domainpwd%>" name="p_pwd" class="manager-input s-input">
                    <input type="submit" value="�޸�����" class="manager-btn s-btn" onClick="return changepwd(this.form)">
                    <%else%>
                    ********
                    <%end if%></td>
                </tr>
                <tr>
                  <th align="right">����ʱ�䣺</th>
                  <td align="left"> <%=regdate%></td>
                  <th align="right">����ʱ�䣺</th>
                  <td align="left"> <%=rexpiredate%></td>
                </tr>
                <tr>
                  <th align="right">DNS1��</th>
                  <td align="left"><%=dns_host1%><br />
                   </td>
                  <th align="right">DNS2��</th>
                  <td align="left"><%=dns_host2%><br />
                   </td>
                </tr>
                <tr>
                  <td  colspan=4 align="center" class="tdbg"><input type="submit" class="manager-btn s-btn" value="����߼�����" onClick="this.form.target='_blank';" <%if not CanAccess then Response.write "disabled"%>>
                    <%
		if CanAccess then
			Response.write hiddentxt
		end if
	%>
                    <input type="submit" class="manager-btn s-btn" name="sub3" value="   ͬ������   " onClick="javascript:this.form.action='<%=request("script_name")%>?act=syn';">
                    <input type="button" class="manager-btn s-btn" value="<%if urlstate="reopen" then
		tmpa="����URLת��"
		elseif urlstate="open" then
		tmpa="��ͨURLת��"
		else
		tmpa="ERR"
		end if
		response.Write tmpa
		%>"  onClick="document.getElementById('urlpay').style.display='block';">
                    <input type="hidden" name="p_id" value="<%=p_id%>">
                    <input type="hidden" name="act"></td>
                </tr>
                <tr>
                  <td  colspan=4 align="center" class="tdbg"><img src="/Template/Tpl_01/images/!.GIF" width="27" height="33">��ʾ:�������߼�������ʾ������������޸����롣</td>
                </tr>
             
            </table>
			 </form>
            <div id="urlpay" style="display:<%if act="" then response.Write "none"%>;background:#FFC;padding:15px;">
              <form name="form2" method="get">
                URLת������ͨ�ڣ�<%=url_buydate & "[����=" & url_buyyear & "]"%>����������<span class="redb"><%=strDomain%></span>�����ޣ�
                <select name="byear" onChange="btn1.disabled='disabled';act.value='v';form2.submit()">
                  <% for i=1 to 10'changemenu(this.value)
if cint(byear)=cint(i) then sel="selected" else sel=""
response.Write  "<option value='" & i & "' " & sel & ">" & i & "��</option>"
next%>
                </select>
                �۸�<span class="redb"><%=urlneedPrice%></span> Ԫ��
                <%if urlstate="error" then%>
                <font color=red>������������ϵ����Ա����ƽ̨��</font>
                <%else%>
                <input type="button" name="btn1" value=" ȷ �� " class="manager-btn s-btn" onClick="act.value='buyurl';form2.submit()">
                <%end if%>
                <input type="hidden" name="act" value="">
                <input type="hidden" name="p_id" value="<%=p_id%>">
              </form>
              <%
sub checkUrlforward()
'on error resume next
sql="select * from productlist  where p_proid='"  & urlproid & "'"
set rss2=conn.execute(sql)
if not rss2.eof then
	rss2.close
	urlstate="open"
	urlneedPrice=getNeedPrice(session("user_name"),urlproid,byear,"new")	
	sql="select url_buydate,url_buyyear from domainlist where strDomain='" & strDomain & "'"
	set rss2=conn.execute(sql)	
	url_buydate=rss2(0)
	url_buyyear=rss2(1)
	if err=0 and isdate(url_buydate) then
		url_passdate=dateadd("yyyy",url_buyyear,url_buydate)
		if now() < url_passdate then 
			urlstate="reopen"	'����Ƿ�ͨ��
			urlneedPrice=getNeedPrice(session("user_name"),urlproid,byear,"renew")'ȡ���˼۸�
		end if
	end if		
else
	urlstate="error"	'û�����ֲ�Ʒ
end if
	rss2.close
end sub
conn.close
%>
</div>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>