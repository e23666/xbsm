<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
if session("u_sysid")="" then 
   Response.write "<script language=javascript>alert('���ȵ�¼');top.location.href='/login.asp';</script>"
   Response.end
end if

Sql="Select * from userdetail Where u_name='" & Session("user_name") &"'"
Rs.open Sql,conn,1,1
if Rs.eof then 
  Response.write "<script language=javascript>alert('�޴��û�!');window.location.href='/login.asp';</script>"
  Response.end
end if
Sql="Select * from Fuser Where username='" & Session("user_name") & "' and L_ok="&PE_True&""
Set FRs=conn.Execute(Sql)
if FRs.eof then
  Response.write "<script language=javascript>alert('�������������Ϊ�֣ãк�ſ�ʹ�ô˹���!');window.location.href='vcp_reg.asp';</script>"
  Response.end
end if

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-�޸�VCP����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language=javascript>
function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("��Ǹ��"+text+"�����ڸ�ʽ����,��ȷ�ĸ�ʽ��yyyy-MM-dd");
	//data.value=dateObj.getUTCFullYear()+"-"+dateObj.getUTCMonth()+"-"+dateObj.getUTCDay();
	dateObj=new Date();
	data.value="2003-01-30"
	data.focus();
	data.select();
	return false;
}
else{
	return true;
	}
}

function isGreat(number,text){
		if (parseFloat(number)>9999999||parseFloat(number)<0){
			alert("��Ǹ���ύʧ�ܣ�["+text+"]��ֵ����ϵͳ��ʾ��Χ0-9999999");
			return true;
			}
	return false;
}
function isNumber(number){
var i,str1="0123456789.";
	for(i=0;i<number.value.length;i++){
	if(str1.indexOf(number.value.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function checkNull(data,text){
	if (data.value==""){
		alert("��Ǹ!�ύʧ�ܣ�"+text+"����Ϊ��!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("��Ǹ!["+text+"]����������,�����޷��ύ");
	data.focus();
	data.select();
	return false;
	}
}
return true;
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
        <li><a href="/manager/vcp/vcp_Edit.asp">�޸�VCP����</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="form1" method="post" action="vcp_saveEdit.asp" >
        <table  class="manager-table">
          <tr class='tdbg'>
            <th colspan=2>�𾴵�
              <%if FRs("ModeD") then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
              <%=name%>ģʽ������飬���ã�(<a href="vcp_Edit.asp" style="color:red;">�޸�����</a>)</th>
          </tr>
          <tr>
            <th align="right">����:</th>
            <td align="left"><%=Rs("u_namecn")%></td>
          </tr>
          <tr>
            <th align="right">ͨ�ŵ�ַ:</th>
            <td align="left"><%=Rs("u_address")%></td>
          </tr>
          <tr>
            <th align="right">�ʱ�:</th>
            <td align="left"><%=Rs("u_zipcode")%></td>
          </tr>
          <tr>
            <th align="right">QQ:</th>
            <td align="left"><%=Rs("qq_msg")%> <%=FRs("C_domain")%></td>
          </tr>
          <tr>
            <th align="right">�����ʼ�:</th>
            <td  align="left"><%=Rs("u_email")%></td>
          </tr>
          <tr>
            <th align="right">�绰:</th>
            <td align="left"><%=Rs("u_telphone")%></td>
          </tr>
          <tr>
            <th align="right">����:</th>
            <td align="left"><%=Rs("u_fax")%>&nbsp;</td>
          </tr>
          <tr>
            <th align="right">�����ʻ�:</th>
            <td align="left"><input type="text" class="manager-input s-input" name="bankNo" maxlength="50" size="25" value="<%=FRs("C_Accounts")%>"></td>
          </tr>
          <tr>
            <th align="right">��������:</th>
            <td align="left"><input type="text" class="manager-input s-input"  name="bank" maxlength="50" size="25" value="<%=FRs("C_bank")%>"></td>
          </tr>
          <tr>
            <th align="right">��ʽ:</th>
            <td align="left"><input type="radio" name="remitMode" value="��������" <% if FRs("C_remitMode")="��������" then Response.write " checked"%>>
              ��������
              <input type="radio" name="remitMode" value="��������" <% if FRs("C_remitMode")="��������" then Response.write " checked"%>>
              ��������<br>
              <input type="radio" name="remitMode" value="ũҵ����" <% if FRs("C_remitMode")="ũҵ����" then Response.write " checked"%>>
              ũҵ����
              <input type="radio" name="remitMode" value="��������" <% if FRs("C_remitMode")="��������" then Response.write " checked"%>>
              ��������<br>
              <input type="radio" name="remitMode" value="ֱ�Ӵ����ҵĻ�Ա����" <% if FRs("C_remitMode")="ֱ�Ӵ����ҵĻ�Ա����" then Response.write " checked"%>>
              ֱ�Ӵ����ҵĻ�Ա����
              <input type="radio" name="remitMode" value="֧����" <% if FRs("C_remitMode")="֧����" then Response.write " checked"%>>
              ֧���� </td>
          </tr>
          <tr>
            <th align="right">��ע��</th>
            <td align="left"><input type="text" class="manager-input s-input"  name="from" maxlength="53" size="20" value="<%=FRs("C_from")%>"></td>
          </tr>
          <tr align="center">
            <td colspan="2"><input type="submit" name="Submit"  class="manager-btn s-btn" value="�ύ[S]" id=save>
              <input type="reset" name="Submit2" class="manager-btn s-btn" value="���[C]" id=clear></td>
          </tr>
        </table>
        <label for=save AccessKey=S></label>
        <label for=clear AccessKey=C></label>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
<%
Rs.close
FRs.close
Set FRs=nothing
%>
