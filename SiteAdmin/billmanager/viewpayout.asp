<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
conn.open constr
%>
<script language="javascript" src="/config/PopupCalendar.js"></script>
<script language=javascript>
function isIPAddress(data,text){
var reg=/\b([1,2]?[0-9]?[0-9]?)\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\b/
if (reg.exec(data.value)!=null) {
	return true;
	}
else {
	alert("抱歉，"+text+"格式输入错误，请输入一个有效的IP地址");
	data.focus();
	data.select();
	return false;
	}
}

function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("抱歉，"+text+"的日期格式错误,正确的格式是yyyy-MM-dd");
	//data.value=dateObj.getUTCFullYear()+"-"+dateObj.getUTCMonth()+"-"+dateObj.getUTCDay();
	dateObj=new Date();
	data.value="<%=formatDateTime(now,2)%>"
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

if (form.page.value!=""){ if (!isDigital(form.page,"页码")) return false; }
if (form.StartTime.value!="") { if (!isDate(form.StartTime,"起始日期")) return false; }
if (form.EndTime.value!="") { if (!isDate(form.EndTime,"终止日期")) return false;}
if (form.Amount.value!=""){ if (!isDigital(form.Amount,"金额")) return false; }
return true;
}

function prepage(){
 form=document.form1;
 form.page.value=parseInt(form.page.value)-1;
 form.submit();
}

function nextpage(){
 form=document.form1;
 form.page.value=parseInt(form.page.value)+1;
 form.submit();
}


</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>查看支出</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">用户入款</a>| 
      <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> 
      | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> 
      | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> 
      | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> 
      | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> 
      | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a> 
    </td>
  </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top" align="center"> <%
 if Requesta("act")="del" then
check_is_master(1)
id=Requesta("id")
sql2="delete from ourmoney where id="&id
conn.execute(sql2)
end if

page=trim(Requesta("page"))
Amount=Trim(Requesta("Amount"))
StartTime=Trim(Requesta("StartTime"))
EndTime=Trim(Requesta("EndTime"))
UserName=Trim(Requesta("UserName"))
PayMethod=Trim(Requesta("PayMethod"))

if not isNumeric(page) then page=1
BaseSQL="1=1 "
if UserName<>"" then BaseSql=BaseSql & " and username='" & UserName & "'"
if isNumeric(Amount) then BaseSql=BaseSql & " and Amount=" & Amount
if isDate(StartTime) then BaseSql=BaseSql & " and DateDiff(d,'" & StartTime & "',PayDate)>=0"
if isDate(EndTime) then   BaseSql=BaseSql & " and DateDiff(d,PayDate,'" & EndTime & "')>=0"
if PayMethod<>"" then BaseSql=BaseSql & " and PayMethod like '%" & PayMethod & "%'"

Sql="Select * from ourmoney where " & BaseSql & " and Amount<0  order by id desc"

Sql2="Select sum(Amount) as InM from ourmoney where Amount>0 and ismove=0 and " & BaseSql
Sql3="Select sum(Amount) as OutM from ourmoney where Amount<0 and ismove=0 and " & BaseSql

Sql4="Select sum(Amount) as TMoney from ourmoney where Amount>0 and ismove=0 and datediff("&PE_DatePart_D&",PayDate,'" & FormatDateTime(now(),1) & "')=0"
Sql5="Select sum(Amount) as MMoney from ourmoney where Amount>0 and ismove=0 and dateDiff("&PE_DatePart_M&",PayDate,'" & FormatDateTime(now(),1) & "')=0"

Set RsTemp=conn.Execute(sql2)
InM=0
OutM=0
OM=0
TM=0
MM=0
 if isNumeric(RsTemp("InM")) then InM=RsTemp("InM")
 RsTemp.close
 RsTemp.open Sql3,conn,1,1
 if isNumeric(RsTemp("OutM")) then OutM=RsTemp("OutM")
 RsTemp.close
 RsTemp.open Sql4,conn,1,1
 if isNumeric(RsTemp("Tmoney")) then TM=RsTemp("Tmoney")
 RsTemp.close
 RsTemp.open Sql5,conn,1,1
 if isNumeric(RsTemp("MMoney")) then MM=RsTemp("MMoney")
 RsTemp.close
 Set RsTemp=nothing

OM=InM+OutM


rs.Open sql, conn,3,2
rs.PageSize=20
pagecount=abs(cint(rs.pagecount))

page=cInt(page)
if page<1 then page=1
if page>pagecount then page=pageCount
if not Rs.eof then Rs.AbsolutePage=page

 %> <br>
      <%
if left(session("u_type"),1)="1" then

%>
      收入：￥<%=InM%> 
      <%if PayMethod="在线支付" then Response.write "×1.01=" & Round(InM*1.01,2)%>
      &nbsp;|&nbsp;<a href="viewpayout.asp"><font color="#0000FF">支出</font></a>：￥<%=Abs(OutM)%>&nbsp;|&nbsp; 
      利润：<font color="#FF0000">￥<%=OM%></font>&nbsp;<br>
      &nbsp;当日：<font color="#FF0000">￥<%=TM%></font> &nbsp;|&nbsp; 当月：<font color="#000000">￥<%=MM%></font> 
      <%end if%>
      <form name="form1" action="ViewOurMoney.asp" method=post onSubmit="return check(this);">
        <p></p>
        <table width=100% border=0 align="center" cellpadding=3 cellspacing=0 bordercolordark="#ffffff" class="border">
          <tbody> 
          <tr> 
            <td class=tdbg align="center">&nbsp;</td>
            <td class=tdbg align="center"><a href="javascript:prepage();">上一页</a></td>
            <td align="center" class="tdbg">              <a href="javascript:nextpage();">下一页</a></td>
            <td class="tdbg"> 
              <div align="center"><a href="ViewOurMoney.asp?page=<%=page+1%>&StartTime=<%=StartTime%>&EndTime=<%=EndTime%>"> 
                </a> 
                <input type="submit" name="go" value="到">
                <input type="text" name="page" maxlength="3" size="1" value=<%=page%>>
                /<font color="#FF3366"><%=pagecount
%></font></div>            </td>
            <td class=tdbg colspan="3"> 
              <p>金额: 
                <input type="text" name="Amount" size="5" maxlength="12" value="<%=Amount%>">
                <select name="PayMethod">
                  <option value="">全部银行</option>
                  <option value="在线支付" <%if PayMethod="在线支付" then Response.write "selected"%>>在线支付</option>
                  <option value="招" <%if PayMethod="招" then Response.write "selected"%>>招商银行</option>
                  <option value="农" <%if PayMethod="农" then Response.write "selected"%>>农业银行</option>
                  <option value="农业银行2" <%if PayMethod="农业银行2" then Response.write "selected"%>>农业银行2</option>
                  <option value="工" <%if PayMethod="工" then Response.write "selected"%>>工商银行</option>
                  <option value="宝" <%if PayMethod="宝" then Response.write "selected"%>>支付宝支付</option>
                  <option value="公司转帐2" <%if PayMethod="公司转帐2" then Response.write "selected"%>>公司转帐2</option>
                  <option value="建" <%if PayMethod="建" then Response.write "selected"%>>建设银行</option>
                  <option value="公" <%if PayMethod="公" then Response.write "selected"%>>公司转帐</option>
                  <option value="政汇" <%if PayMethod="政汇" then Response.write "selected"%>>邮政汇款</option>
                  <option value="存" <%if PayMethod="存" then Response.write "selected"%>>邮政存折汇款</option>
                  <option value="上门" <%if PayMethod="上门" then Response.write "selected"%>>上门交费</option>
                  <option value="云网" <%if PayMethod="云网" then Response.write "selected"%>>云网支付</option>
                  <option value="快钱" <%if PayMethod="快钱" then Response.write "selected"%>>快钱支付</option>
                  <option value="财富" <%if PayMethod="财富" then Response.write "selected"%>>财富通支付</option>
                  <option value="默认" <%if PayMethod="默认" then Response.write "selected"%>>默认在线支付</option>

                </select>
              </p>            </td>
          </tr>
          <tr> 
            <td class=tdbg align="center">开始日期:</td>
            <td class=tdbg align="center"> 
              <input type="text" name="StartTime" size="12" maxlength="12" value="<%=StartTime%>" onClick="getDateString(this,oCalendarChs)">            </td>
            <td class="tdbg" align="center">结束日期:</td>
            <td class="tdbg"> 
              <input type="text" name="EndTime" size="12" maxlength="12" value="<%=EndTime%>" onClick="getDateString(this,oCalendarChs)">            </td>
            <td class=tdbg align="center" colspan="3"> 
              用户名: 
              <input type="text" name="UserName" size="5" maxlength="12" value="<%=UserName%>">
              <input type="submit" name="Submit" value="确定">            </td>
          </tr>
          </tbody> 
        </table>
      </form>
      <div align="center"> </div>
      <div align="center"></div>
      <div align="center"></div>
      <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" bordercolorlight="#000000" bordercolordark="#FFFFFF" class="border">
        <tr align="center"> 
          <td class="Title"><strong> 
            id</strong></td>
          <td class="Title"><strong> 
            姓名            </strong></td>
          <td class="Title"><strong> 
            用户名</strong></td>
          <td class="Title"><strong> 
            订单号            </strong></td>
          <td class="Title"><strong>汇款日期</strong></td>
          <td class="Title"><strong> 
            金额</strong></td>
          <td class="Title"><strong>方式</strong></td>
          <td class="Title"><strong> 
            备注</strong></td>
          <td class="Title"><strong> 
            删除</strong></td>
        </tr>
        <%
i=1
do while not rs.eof and i<=20                 
             
  'if rs("Amount")>=0 then             
%> 
        <tr> 
          <td class="tdbg"> 
            <font color="#FF0000"><a href=moneylistedit.asp?id=<%=rs("id")%>><%=rs("id")%></a></font> </td>
          <td class="tdbg"> 
            <a href="<%=otherlink%>"> </a><%=rs("Name")%>           </td>
          <td class="tdbg"> 
            <%=rs("UserName")%></td>
          <td class="tdbg"> 
            <%=rs("Orders") & "&nbsp;"%></td>
          <td class="tdbg"> 
            <%=rs("PayDate")%></td>
          <td class="tdbg"> 
            <%=rs("Amount")%></td>
          <td class="tdbg">
            <%
if rs("ismove") then response.write "<font color=#FF0000>内部</font>"
%>
              
            <%=rs("PayMethod")%></td>
          <td class="tdbg"> 
            <%=rs("Memo")%></td>
          <td class="tdbg"> 
            <a href="#" onClick="if (confirm('你确信要删除此帐目？删除后不可恢复!')) location.href='viewourmoney.asp?act=del&id=<%=rs("id")%>'">删除</a></td>
        </tr>
        <% 
	'  end if
     rs.movenext   '将当前数据记录移到下一条   
     i=i+1  
   loop
Rs.close

   '开始下一循环                
  %> 
      </table>
    </td>
  </tr>
</table>
  

<!--#include virtual="/config/bottom_superadmin.asp" -->
