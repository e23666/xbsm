<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�û������̨-Mssql���ݿ����</title>
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />

<%
conn.open constr
p_id=requesta("p_id")
act=requesta("act")
if len(p_id)<=0 then url_return "��������",-1
sql="select * from databaselist where dbsysid="& p_id &" and dbu_id=" & session("u_sysid")
rs.open sql,conn,1,3
if rs.eof and rs.bof then rs.close:conn.close:url_return "û���ҵ��˲�Ʒ",-1
s_comment=rs("dbname")
s_ftppassword=rs("dbpasswd")
s_serverIP=rs("dbserverip")
s_buydate=rs("dbbuydate")
s_expiredate=rs("dbexpdate")
s_ProductId=rs("dbproid")
if act="changepwd" then
	newpwd=requesta("p_pwd")
	if not checkRegExp(newpwd,"^[\w]{5,20}$") then url_return "����("& newpwd &")ӦΪ��ĸ���ֻ�_���,������5-20λ֮��",-1
	commandstr="mssql" & vbcrlf & _
				"mod" & vbcrlf & _
				"entityname:chgpwd" & vbcrlf & _
				"databasename:" & s_comment & vbcrlf & _
				"databaseuser:" & s_comment & vbcrlf & _
				"dbupassword:" & newpwd & vbcrlf & _
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
	returnstr=doUserSyn("mssql",s_comment)
	if left(returnstr,3)="200" then
		alert_redirect "�������ݳɹ�",request("script_name") & "?p_id=" & p_id
	else
	 	alert_redirect "��������ʧ��" & returnstr,request("script_name") & "?p_id=" & p_id
	end if
end if

rs.close
conn.close
%>
<script language=javascript>
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
		f.target='_parent';
		f.action = '/manager/config/getFree.asp';
		f.freeident.value=v;
		f.submit();
	}
}
</script>
</head>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">Mssql���ݿ����</div>
          <div class="table_out">
         
        <table width="100%" border="0" cellpadding="4" cellspacing="1" bordercolordark="#ffffff" class="border managetable tableheight">
  <form name=form1 action="<%=request("script_name")%>" method=post>
    <tr>
      <td class="tdbg">���ݿ�/�û���:</td>
      <td class="tdbg"><%=s_comment%></td>
      <td class="tdbg">����:</td>
      <td class="tdbg"><input type=text value="<%=s_ftppassword%>" name="p_pwd">
        <input type="submit" value="�޸�����" onclick="return changepwd(this.form)">      </td>
    </tr>
    <tr>
      <td class="tdbg">IP��ַ:</td>
      <td class="tdbg"><%=s_serverIP%></td>
      <td class="tdbg">���ݿ��ͺ�:</td>
      <td class="tdbg"><%=s_ProductId%></td>
    </tr>
    <tr>
      <td class="tdbg">����ʱ��:</td>
      <td class="tdbg"><%=s_buydate%></td>
      <td class="tdbg">����ʱ��:</td>
      <td class="tdbg"><%=s_expiredate%></td>
    </tr>
    <tr>
      <td  colspan=4 align="center" class="tdbg">
      	<input type="submit" name="sub2" value="����߼�����" onclick="javascript:this.form.action='http://www.myhostadmin.net/database/checklogin.asp';this.form.target='_blank';">
         <input type="submit" name="sub3" value="   ͬ������   " onclick="javascript:this.form.action='<%=request("script_name")%>?act=syn';">
        <input type="hidden" name="dbuserid" value="<%=s_comment%>">
       	<input type="hidden" name="dbpasswd" value="<%=s_ftppassword%>">
        <input type="hidden" name="p_id" value="<%=p_id%>">
     </td>
    </tr>
    
  </form>
</table>





         
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>




</body>
</html>
