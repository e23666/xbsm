<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��ҵ�ʾ�</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
</HEAD>
<%
conn.open constr
p_id=requesta("p_id")
act=requesta("act")
if len(p_id)<=0 then url_return "��������",-1
sql="select * from mailsitelist where m_sysid="& p_id &" and m_ownerid=" & session("u_sysid")
rs.open sql,conn,1,3
if rs.eof and rs.bof then rs.close:conn.close:url_return "û���ҵ��˲�Ʒ",-1
s_comment=rs("m_bindname")
s_ftppassword=rs("m_password")
s_serverIP=rs("m_serverip")
s_buydate=rs("m_buydate")
s_expiredate=rs("m_expiredate")
s_ProductId=rs("m_productId")

If s_ProductId="yunmail" Then rs.close:Response.redirect("info.asp?m_id="&p_id)




if act="changepwd" then
	newpwd=requesta("p_pwd")
		    if isBad(session("user_name"),newpwd,errinfo) then
				   die url_return(replace(replace(errinfo,"ftp�û���","�û���"),"�û���","�û���"),-1)
			end if
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "����("& newpwd &")ӦΪ��ĸ���ֻ�_���,������5-20λ֮��",-1
	commandstr="corpmail" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:mmasterpass" & vbcrlf & _
				"domainname:" & s_comment & vbcrlf & _
				"upassword:" & newpwd & vbcrlf & _
				"." & vbcrlf

	renewdata=pcommand(commandstr,session("user_name"))
	if left(renewdata,3)="200" then
		alert_redirect "�޸�����ɹ�",request("script_name") & "?p_id=" & p_id
	else
		alert_redirect "�޸�����ʧ��:"& renewdata ,request("script_name") & "?p_id=" & p_id
	end if
	rs.close
	conn.close
	response.end
elseif act="syn" then
	returnstr=doUserSyn("mail",s_comment)
	if left(returnstr,3)="200" then
		alert_redirect "�������ݳɹ�",request("script_name") & "?p_id=" & p_id
	else
	 	alert_redirect "��������ʧ��" & returnstr,request("script_name") & "?p_id=" & p_id
	end if
end if
''''''''''''''''''''''''''''''''''''''��Ʒ���''''''''''''''''''''''''''''''''''''
 set prs=server.CreateObject("adodb.recordset")
 domainFree=false
 hostFree=false
 mssqlFree=false
 mysqlFree=false
 preSql="select top 1 a.*,b.pre1,b.pre2,b.pre3,b.pre4 from protofree a inner join mailsitelist b on (b.m_buytest="&PE_False&" and a.proid=b.m_productId and b.m_ownerid=" & session("u_sysid") & " and b.m_sysid=" & p_id & " and a.type='mail') where not exists(select sysid from protofree where b.m_productid in (freeproid1,freeproid2,freeproid3,freeproid4) and type='mail')"
 prs.open preSql,conn,3
 if not prs.eof then

 	if len(trim(prs("pre1")&""))=0 and len(prs("freeproid1")&"")>0 and dateDiff("d",s_buydate,date)<=15 and isgetFreeProduct("mail",s_comment,prs("freeproid1")) then	domainFree=true
	if len(trim(prs("pre2")&""))=0 and len(prs("freeproid2")&"")>0 and isgetFreeProduct("mail",s_comment,prs("freeproid2"))  then hostFree=true
	if len(trim(prs("pre3")&""))=0 and len(prs("freeproid3")&"")>0 and isgetFreeProduct("mail",s_comment,prs("freeproid3"))  then mysqlFree=true
	if len(trim(prs("pre4")&""))=0 and len(prs("freeproid4")&"")>0 and isgetFreeProduct("mail",s_comment,prs("freeproid4"))  then mssqlFree=true
 end if
 prs.close
 set prs=nothing
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
rs.close
conn.close

%>
<script language=javascript>
var m_id=<%=p_id%>;
function changepwd(f){
	var v=f.p_pwd;
	var regv=/^[\w]{5,20}$/;

	if (!regv.test(v.value)){
		alert('����('+ v.value +')ӦΪ��ĸ���ֻ�_���,������5-20λ֮��');
		v.focus();
		return false;
	}
	f.action += '?act=changepwd';
	return confirm('ȷ���޸Ĵ�������?');

}
function buyfree(f,v){
	if(v!=''){
		f.target="_parent";
		f.action = '/manager/config/getFree.asp';
		f.freeident.value=v;
		f.submit();
	}
}

</script>
<script src="upyun.js" type="text/javascript" ></script>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			    <li><a href="/Manager/mailmanager/">��ҵ�ʾ�</a></li>
			   <li>��ҵ�ʾֹ���</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		   <form name=form1 action="<%=request("script_name")%>" method=post>
              <table class="manager-table">
                  <tr>
                    <th width="10%" class="Title">�ʾ�����:</th>
                    <td width="33%"><%=s_comment%></td>
                    <th width="16%" class="Title">����:</th>
                    <td width="41%"><input type=text value="<%=s_ftppassword%>" name="p_pwd" class="manager-input s-input">
                      <input type="submit" value="�޸�����" onclick="return changepwd(this.form)" class="manager-btn s-btn" >
                    </td>
                  </tr>
                  <tr>
                    <th class="Title">IP��ַ:</th>
                    <td><%=s_serverIP%></td>
                    <th class="Title">�ʾ��ͺ�:</th>
                    <td><%=s_ProductId%></td>
                  </tr>
                  <tr>
                    <th class="Title">����ʱ��:</th>
                    <td><%=s_buydate%></td>
                    <th class="Title">����ʱ��:</th>
                    <td><%=s_expiredate%></td>
                  </tr>
                  <tr>
                    <td  colspan=4 align="center"><input type="submit" value="����߼�����" class="manager-btn s-btn" onclick="javascript:this.form.action='<%=manager_url%>mail/checklogin.asp';this.form.target='_blank';">
                     <input type="submit" class="manager-btn s-btn" name="sub3" value="   ͬ������   " onclick="javascript:this.form.action='<%=request("script_name")%>?act=syn';">
					
					 <input type="button" value="һ�����������ʾ�" onclick="upyun(this)"  class="manager-btn s-btn">


                      <input type="hidden" name="userid" value="<%=s_comment%>">
                     	<input type="hidden" name="passwd" value="<%=s_ftppassword%>">
                      <input type="hidden" name="p_id" value="<%=p_id%>">
                      <input type="hidden" name="freetype" value="mail">
                      <input type="hidden" name="freeident" value="">
                      <br>
                    </td>
                  </tr>
                  <tr>
                     <td align="center" height="21" colspan=4><img src="/Template/Tpl_01/images/!.GIF" width="27" height="33">��ʾ:�������߼�������ʾ������������޸����롣</td>
                  </tr>
              </table>
               <table class="manager-table">

                                      <tr>
                                        <td align="center" bgcolor="#efefef" colspan=4>�� ȡ �� Ʒ</td>
                                      </tr>
                                      <tr>
                                        <td align="center">������Ʒ:
                                          <input type="button" value=" ��ȡ���� "  onclick="buyfree(this.form,'domain')" <%if not domainFree then response.write " disabled=""disabled"""%>>
                                        </td>
                                        <td align="center">������Ʒ:
                                          <input type="button" value=" ��ȡ���� " onclick="buyfree(this.form,'vhost')" <%if not hostFree then response.write " disabled=""disabled"""%>>
                                        </td>
                                        <td align="center">MSSQL��Ʒ:
                                          <input type="button" value=" ��ȡMSSQL "  onclick="buyfree(this.form,'mssql')" <%if not mssqlFree then response.write " disabled=""disabled"""%>>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td align="left" colspan=4> *ע:
                                          <ul>
                                            <li>������Ʒ��ʹ������Ϊһ��</li>
                                            <li>��Ʒʹ�����޺͹����Ʒ��ͬ(��������Ʒ��Ч)</li>
                                            <li>�Բ�Ʒ����ʱҲ������Ʒ�Զ�����ͬ����(������Ʒ����һ��)</li>
                                            <li>�ڲ�Ʒ�������Ӧ����Ʒ�Զ�����ϵͳ������ȡ�κη���</li>
                                            <li>��Ʒ�����󽫲����ٻ����Ʒ</li>
                                            <li>����ò�Ʒ����Ʒ,�������ٻ����Դ˲�Ʒ����Ʒ.</li>
                                            <li>�ڹ���������Ʒ����15�컹û�л�ȡ������Ʒ�Ľ�ȡ����������Ʒ�Ļ�ȡ������Ʒ����</li>
                                            <li>�����Ʒʱ������ȡ�κη���</li>
                                          </ul>
                                        </td>
                                      </tr>
                                    </table>
            </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
