<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
If Session("user_name")="" then
  Session("w_from")="vcp"
  Response.write "<script language=javascript>alert('Ҫ����˷���,����������ע������ǵĻ�Ա,����¼��ſ�!');window.location.href='/login.asp';</script>"
  Response.end
else
  Session("w_from")=""
end if
Sql="Select * from userdetail Where u_name='" & Session("user_name") &"'"
Rs.open Sql,conn,1,1
if Rs.eof then 
  Response.write "<script language=javascript>alert('�޴��û�!');window.location.href='login.asp?from=vcp';</script>"
  Response.end
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���������йܹ���</title>
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

function check(form){
if (!checkNull(form.domain,"����")) return false;
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
        <li><a href="/Manager/servermanager/">����IP��������</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
        <tr class='topbg'>
          <td height='30' align="center" ><strong>VCP�û�����</strong></td>
        </tr>
      </table>
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
        <tr class='tdbg'>
          <td width='91' height='30' align="center" >&nbsp;</td>
          <td width="771">�𾴵�
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>ģʽ������飬���ã�(<a href="vcp_Edit.asp">�޸�����</a>)</td>
        </tr>
      </table>
      <br>
      <form name="form1" method="post" action="vcp_savereg.asp" onSubmit="return check(this);">
        <table   class="manager-table">
          <tr>
            <th align="right">����:</th>
            <td align="left"><%=Rs("u_namecn")%></td>
          </tr>
          <tr>
            <th align="right"> ��վ����: </th>
            <td align="left" > http://
              <input type="text" name="domain" class="manager-input s-input" maxlength="53" size="15">
              <br>
              (�磺www.west263.com)*������д(�Ժ󲻿ɸ���)<br>
              Ϊ�������ǵ�Ʒ�Ʊ���һ�£���������<br>
              www.west520.com www.westdns.cn www.westisp.cn www.westbiz.cn��������<br>
              ����㻹û��ע������������ȥ<a href="/services/domain" target="_blank">ע��һ������</a>��<br>
              �������������˾ע����������뽫��������DNS����Ϊ��dns.bizcn.com dns.cnmsn.net <br></td>
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
            <td align="right">QQ:</td>
            <td align="left"><%=Rs("qq_msg")%> &nbsp;</td>
          </tr>
          <tr>
            <th align="right">�����ʼ�:</th>
            <td align="left"><%=Rs("u_email")%></td>
          </tr>
          <tr>
            <th align="right">�绰:</th>
            <td align="left"><%=Rs("u_telphone")%></td>
          </tr>
          <tr>
            <th align="right">����:</th>
            <td align="left"><%=Rs("u_fax")%>&nbsp; </td>
          </tr>
          <tr>
            <th align="right">�����ʺ�:</th>
            <td align="left"><input type="text" name="bankNo" maxlength="50" size="15"  class="manager-input s-input">
              <input type="hidden" name="ReferenceID" value="<%=U_id%>"></td>
          </tr>
          <tr>
            <th align="right">��������:</th>
            <td align="left"><input type="text" name="bank" maxlength="50" size="15"  class="manager-input s-input"></td>
          </tr>
          <tr >
            <th align="right">��ʽ:</th>
            <td align="left"><input type="radio" name="remitMode" value="��������" checked>
              �������е��
              <input type="radio" name="remitMode" value="��������">
              �������е��<br>
              <input type="radio" name="remitMode" value="��������">
              �������е��
              <input type="radio" name="remitMode" value="ũҵ����">
              ũҵ���е�� <br>
              <input type="radio" name="remitMode" value="��Ա��ֵ">
              ֱ�Ӵ����ҵĻ�Ա����</td>
          </tr>
          <tr>
            <th align="right">�δ���֪:</th>
            <td align="left"><input type="text" name="from" maxlength="53" size="20"  class="manager-input s-input"></td>
          </tr>
          <tr>
            <td colspan="2" ><input type="submit" name="Submit" value="�ύ[S]" id=save class="manager-btn s-btn">
              <input type="reset" name="Submit2" value="���[C]" id=clear  class="manager-btn s-btn"></td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
