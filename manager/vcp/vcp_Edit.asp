<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
if session("u_sysid")="" then 
   Response.write "<script language=javascript>alert('请先登录');top.location.href='/login.asp';</script>"
   Response.end
end if

Sql="Select * from userdetail Where u_name='" & Session("user_name") &"'"
Rs.open Sql,conn,1,1
if Rs.eof then 
  Response.write "<script language=javascript>alert('无此用户!');window.location.href='/login.asp';</script>"
  Response.end
end if
Sql="Select * from Fuser Where username='" & Session("user_name") & "' and L_ok="&PE_True&""
Set FRs=conn.Execute(Sql)
if FRs.eof then
  Response.write "<script language=javascript>alert('您必须先申请成为ＶＣＰ后才可使用此功能!');window.location.href='vcp_reg.asp';</script>"
  Response.end
end if

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-修改VCP资料</title>
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
        <li><a href="/manager/vcp/vcp_Edit.asp">修改VCP资料</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="form1" method="post" action="vcp_saveEdit.asp" >
        <table  class="manager-table">
          <tr class='tdbg'>
            <th colspan=2>尊敬的
              <%if FRs("ModeD") then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
              <%=name%>模式合作伙伴，您好！(<a href="vcp_Edit.asp" style="color:red;">修改资料</a>)</th>
          </tr>
          <tr>
            <th align="right">姓名:</th>
            <td align="left"><%=Rs("u_namecn")%></td>
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
            <th align="right">QQ:</th>
            <td align="left"><%=Rs("qq_msg")%> <%=FRs("C_domain")%></td>
          </tr>
          <tr>
            <th align="right">电子邮件:</th>
            <td  align="left"><%=Rs("u_email")%></td>
          </tr>
          <tr>
            <th align="right">电话:</th>
            <td align="left"><%=Rs("u_telphone")%></td>
          </tr>
          <tr>
            <th align="right">传真:</th>
            <td align="left"><%=Rs("u_fax")%>&nbsp;</td>
          </tr>
          <tr>
            <th align="right">银行帐户:</th>
            <td align="left"><input type="text" class="manager-input s-input" name="bankNo" maxlength="50" size="25" value="<%=FRs("C_Accounts")%>"></td>
          </tr>
          <tr>
            <th align="right">开户姓名:</th>
            <td align="left"><input type="text" class="manager-input s-input"  name="bank" maxlength="50" size="25" value="<%=FRs("C_bank")%>"></td>
          </tr>
          <tr>
            <th align="right">打款方式:</th>
            <td align="left"><input type="radio" name="remitMode" value="工商银行" <% if FRs("C_remitMode")="工商银行" then Response.write " checked"%>>
              工商银行
              <input type="radio" name="remitMode" value="招商银行" <% if FRs("C_remitMode")="招商银行" then Response.write " checked"%>>
              招商银行<br>
              <input type="radio" name="remitMode" value="农业银行" <% if FRs("C_remitMode")="农业银行" then Response.write " checked"%>>
              农业银行
              <input type="radio" name="remitMode" value="建设银行" <% if FRs("C_remitMode")="建设银行" then Response.write " checked"%>>
              建设银行<br>
              <input type="radio" name="remitMode" value="直接打在我的会员号上" <% if FRs("C_remitMode")="直接打在我的会员号上" then Response.write " checked"%>>
              直接打在我的会员号上
              <input type="radio" name="remitMode" value="支付宝" <% if FRs("C_remitMode")="支付宝" then Response.write " checked"%>>
              支付宝 </td>
          </tr>
          <tr>
            <th align="right">备注：</th>
            <td align="left"><input type="text" class="manager-input s-input"  name="from" maxlength="53" size="20" value="<%=FRs("C_from")%>"></td>
          </tr>
          <tr align="center">
            <td colspan="2"><input type="submit" name="Submit"  class="manager-btn s-btn" value="提交[S]" id=save>
              <input type="reset" name="Submit2" class="manager-btn s-btn" value="清除[C]" id=clear></td>
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
