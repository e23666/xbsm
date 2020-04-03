<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
If Session("user_name")="" then
  Session("w_from")="vcp"
  Response.write "<script language=javascript>alert('要申请此服务,您必须首先注册成我们的会员,并登录后才可!');window.location.href='/login.asp';</script>"
  Response.end
else
  Session("w_from")=""
end if
Sql="Select * from userdetail Where u_name='" & Session("user_name") &"'"
Rs.open Sql,conn,1,1
if Rs.eof then 
  Response.write "<script language=javascript>alert('无此用户!');window.location.href='login.asp?from=vcp';</script>"
  Response.end
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-主机租用托管管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language=javascript>
function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("抱歉，"+text+"的日期格式错误,正确的格式是yyyy-MM-dd");
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
			alert("报歉！提交失败，["+text+"]数值超过系统表示范围0-9999999");
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
		alert("抱歉!提交失败，"+text+"不能为空!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("抱歉!["+text+"]必须是数字,否则无法提交");
	data.focus();
	data.select();
	return false;
	}
}
return true;
}

function check(form){
if (!checkNull(form.domain,"域名")) return false;
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
        <li><a href="/">首页</a></li>
        <li><a href="/Manager/">管理中心</a></li>
        <li><a href="/Manager/servermanager/">独立IP主机管理</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
        <tr class='topbg'>
          <td height='30' align="center" ><strong>VCP用户管理</strong></td>
        </tr>
      </table>
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
        <tr class='tdbg'>
          <td width='91' height='30' align="center" >&nbsp;</td>
          <td width="771">尊敬的
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>模式合作伙伴，您好！(<a href="vcp_Edit.asp">修改资料</a>)</td>
        </tr>
      </table>
      <br>
      <form name="form1" method="post" action="vcp_savereg.asp" onSubmit="return check(this);">
        <table   class="manager-table">
          <tr>
            <th align="right">姓名:</th>
            <td align="left"><%=Rs("u_namecn")%></td>
          </tr>
          <tr>
            <th align="right"> 网站域名: </th>
            <td align="left" > http://
              <input type="text" name="domain" class="manager-input s-input" maxlength="53" size="15">
              <br>
              (如：www.west263.com)*必须填写(以后不可更改)<br>
              为了与我们的品牌保持一致，建议申请<br>
              www.west520.com www.westdns.cn www.westisp.cn www.westbiz.cn等域名。<br>
              如果你还没有注册域名，请先去<a href="/services/domain" target="_blank">注册一个域名</a>；<br>
              如果你在其他公司注册的域名，请将该域名的DNS设置为：dns.bizcn.com dns.cnmsn.net <br></td>
          </tr>
          <tr>
            <th align="right">通信地址:</th>
            <td align="left"><%=Rs("u_address")%></td>
          </tr>
          <tr>
            <th align="right">邮编:</th>
            <td align="left"><%=Rs("u_zipcode")%></td>
          </tr>
          <tr>
            <td align="right">QQ:</td>
            <td align="left"><%=Rs("qq_msg")%> &nbsp;</td>
          </tr>
          <tr>
            <th align="right">电子邮件:</th>
            <td align="left"><%=Rs("u_email")%></td>
          </tr>
          <tr>
            <th align="right">电话:</th>
            <td align="left"><%=Rs("u_telphone")%></td>
          </tr>
          <tr>
            <th align="right">传真:</th>
            <td align="left"><%=Rs("u_fax")%>&nbsp; </td>
          </tr>
          <tr>
            <th align="right">银行帐号:</th>
            <td align="left"><input type="text" name="bankNo" maxlength="50" size="15"  class="manager-input s-input">
              <input type="hidden" name="ReferenceID" value="<%=U_id%>"></td>
          </tr>
          <tr>
            <th align="right">开户姓名:</th>
            <td align="left"><input type="text" name="bank" maxlength="50" size="15"  class="manager-input s-input"></td>
          </tr>
          <tr >
            <th align="right">打款方式:</th>
            <td align="left"><input type="radio" name="remitMode" value="工商银行" checked>
              工商银行电汇
              <input type="radio" name="remitMode" value="招商银行">
              招商银行电汇<br>
              <input type="radio" name="remitMode" value="建设银行">
              建设银行电汇
              <input type="radio" name="remitMode" value="农业银行">
              农业银行电汇 <br>
              <input type="radio" name="remitMode" value="会员冲值">
              直接打在我的会员号上</td>
          </tr>
          <tr>
            <th align="right">何处得知:</th>
            <td align="left"><input type="text" name="from" maxlength="53" size="20"  class="manager-input s-input"></td>
          </tr>
          <tr>
            <td colspan="2" ><input type="submit" name="Submit" value="提交[S]" id=save class="manager-btn s-btn">
              <input type="reset" name="Submit2" value="清除[C]" id=clear  class="manager-btn s-btn"></td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
