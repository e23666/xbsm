<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(5)%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>入流水帐</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table><br>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
          <tr> 
            <td valign="top"> 
              <table width="99%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2" height="49" > 
                    <form name="formSignUp" method="post" action="ourmoney.asp" onSubmit="return check(this);">
                      <script language="javascript">
<!--//
//function PatternMatch(Str){
//	var reg=/^上门-\d+/;
//	if (reg.exec(Str.value)==null){
//		alert("模式错误，正确为:上门-XXX(其中XXX为数字)");
//		Str.focus();
//		Str.select();
//		return false;
//		}
//	return true;

//}


function isDate(data,text){
var reg=/\b(((19|20)\d{2})(-|\/)((0?[1-9])|(1[012]))(-|\/)((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("抱歉，"+text+"的日期格式错误,正确的格式是yyyy-MM-dd");
	//data.value=dateObj.getUTCFullYear()+"-"+dateObj.getUTCMonth()+"-"+dateObj.getUTCDay();
	dateObj=new Date();
	data.value="<%=formatDateTime(now,1)%>"
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
var i,str1="0123456789.-";
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

if (!checkNull(form.Name,"姓名")) return false;
if (!checkNull(form.UserName,"用户名")) return false;
if (!checkNull(form.Amount,"汇款金额")) return false;
if (!isDigital(form.Amount,"汇款金额")) return false;
if (!isDate(form.PayTime,"汇款日期")) return false;
/*
if (form.PayMethod.value.indexOf("门")!=-1)
	if (!PatternMatch(form.PayMethod))
		return false;
*/
return true;
}
//-->
</script>
                      <%
PayMethod=Requesta("PayMethod")
if PayMethod="" then PayMethod=Requesta("hktype")
Amount=Requesta("Amount")
if Amount="" then Amount=Requesta("money")
PayTime=Requesta("PayTime")
if PayTime="" then PayTime=formatdatetime(date(),2)

if Requesta("submessage")<>"" then
	  conn.open constr
	if Requesta("submessage")="提交" then
		submessage="款项二次确认"
		Sql="Select id from ourmoney where UserName='" & Requesta("UserName") &"' and Amount=" & Amount & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("PayTime") & "')=0"
		Rs.open Sql,conn,1,1
		if not Rs.eof then
			AlertMessage="<font color=red><b>警告!</b>此用户在" & Requesta("PayTime") & "已有" & Requesta("Amount") & "元入帐，检查是否重复处理!"
		end if
		Rs.close
		Sql="Select * from ourmoney where PayMethod='" & Requesta("PayMethod") &"' and Amount=" & Amount & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("PayTime") & "')=0"
		Rs.open Sql,conn,1,1

		if not Rs.eof then
			AlertMessage="<font color=red><b>警告!</b>" & Requesta("PayMethod") & "的" & Requesta("Amount") & "元在"&Requesta("PayTime")&"已经入过"&rs.RecordCount&"次，如果有"&rs.RecordCount+1&"个"& Requesta("Amount") &"元到帐，再继续入款!"
		end if
		Rs.close
	elseif Requesta("submessage")="款项二次确认" then
	  Sql="Insert into OurMoney ([Name],[UserName],Paymethod,Amount,PayDate,Orders,[Memo],ismove) values('" & Requesta("Name") &"','" & Requesta("UserName") &"','" & Requesta("PayMethod") & "'," & Requesta("Amount") & ",'" & Requesta("PayTime") & "','" & Requesta("Orders") & "','" & Requesta("Memo") &"','"&Requesta("ismove")&"')"
response.write sql	
  conn.Execute(Sql)
	  if isNumeric(Requesta("id")) then
		    Sql="Update PayEnd Set P_state=1 Where id=" & Requesta("id")
		    conn.Execute(Sql)
	  end if
%>

   <script language=javascript>
    alert("入帐成功");
    window.location.href="incount.asp?UserName=<%=Requesta("UserName")%>&Amount=<%=Requesta("Amount")%>&Paymethod=<%=Requesta("PayMethod")%>";
    </script>
 
<%
	Response.end
	end if
else 
    submessage="提交"
end if
%> 
                      <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#ffffff" class="border">
                        <tr valign="middle"> 
                          <td colspan="2" class="tdbg">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="32%" align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            姓名：　</td>
                          <td width="68%" class="tdbg">                            <input type="text" name="Name" value="<%=Requesta("name")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            汇款人帐号：</td>
                          <td class="tdbg">                            <input type="text" name="UserName" value="<%=Requesta("username")%>">
                            (在本站注册的用户名） </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            汇款方式：</td>
            <td class="tdbg">                            <select name="PayMethod" id="PayMethod">
                              <option value="上门交费"<%if PayMethod="上门交费" then%> selected<%end if%>>上门交费</option>
                              
                               <option value="邮政汇款"<%if PayMethod="邮政汇款" then%> selected<%end if%>>邮政汇款</option>
                              <option value="招商银行"<%if PayMethod="招商银行" then%> selected<%end if%>>招商银行</option>
                              <option value="招行2号"<%if PayMethod="招行2号" then%> selected<%end if%>>招行2号</option>
                              <option value="交通银行"<%if PayMethod="交通银行" then%> selected<%end if%>>交通银行</option>
                              <option value="建设银行"<%if PayMethod="建设银行" then%> selected<%end if%>>建设银行</option>
                              <option value="工商银行"<%if PayMethod="工商银行" then%> selected<%end if%>>工商银行</option>
                              <option value="工商金卡"<%if PayMethod="工商金卡" then%> selected<%end if%>>工商金卡</option>
                              <option value="支付宝支付"<%if PayMethod="支付宝支付" then%> selected<%end if%>>支付宝支付</option>
                              <option value="快钱支付"<%if PayMethod="快钱支付" then%> selected<%end if%>>快钱支付</option>
                              <option value="财富通支付"<%if PayMethod="财富通支付" then%> selected<%end if%>>财富通支付</option>
                                          <option value="云网支付"<%if PayMethod="云网支付" then%> selected<%end if%>>云网支付</option>
                              <option value="农业银行"<%if PayMethod="农业银行" then%> selected<%end if%>>农业银行</option>
                              <option value="在线支付"<%if PayMethod="在线支付" then%> selected<%end if%>>在线支付</option>
                              <option value="公司转帐"<%if PayMethod="公司转帐" then%> selected<%end if%>>公司转帐</option>
                              <option value="西联国际汇款"<%if PayMethod="西联国际汇款" then%> selected<%end if%>>西联国际汇款</option>
                              <option value="公司转帐2"<%if PayMethod="公司转帐2" then%> selected<%end if%>>公司转帐2</option>
                              <option value="邮政存折汇款"<%if PayMethod="邮政存折汇款" then%> selected<%end if%>>邮政存折汇款</option>
                                                       </select>                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            汇款金额：</td>
                          <td class="tdbg">                            <input type="text" name="Amount" value="<%=Amount%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            订单号：</td>
                          <td class="tdbg">                            <input type="text" name="Orders" value="<%=Requesta("Orders")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg">备注：</td>
                          <td class="tdbg">                            <input type="text" name="Memo" size="30" value="<%=request("memo")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            汇款日期：</td>
                          <td class="tdbg">                            <input type="text" name="PayTime" size="30" value="<%=PayTime%>">                            </td>
                        </tr>
                        <tr>
                          <td align="right" bgcolor="#D2EAFB" class="tdbg">是否是内部转帐：</td>
                          <td class="tdbg"> 
<%
if request("ismove")<>"" then
ismove=request("ismove")
else
ismove=0
end if

%>

                            <input type="radio" name="ismove" value="0" <%if ismove=0 then response.write "checked"%>>
                            否 
                            <input type="radio" name="ismove" value="1" <%if ismove=1 then response.write "checked"%>>
                            是 (比如从现金存到公司帐号，请选择“是”。）</td>
                        </tr>
                        <%if len(AlertMessage)>5 then%>
                        <tr align="center"> 
                          <td colspan="2" bgcolor="#D2EAFB" class="tdbg"><%=AlertMessage%></td>
                        </tr>
                        <%end if%>
                        <tr> 
                          <td colspan="2" align="center" class="tdbg"> 
                            <input type="submit" name="submessage" value="<%=submessage%>">
                            <input type="button" name="Submit2" value="清 除">
                            <input type="hidden" name="id" value="<%=Requesta("id")%>">                          </td>
                        </tr>
                      </table>
                      </form>
</td>
                </tr>
                <tr> 
                  <td colspan="2" height="34" > 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td align="right" colspan="2"> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
