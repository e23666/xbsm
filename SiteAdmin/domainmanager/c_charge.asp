<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<script src="/config/mouse_on_title.js"></script>
<html>
<head>
<title>虚拟主机续费管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
td {  font-size: 9pt}
-->

</style>
<script>

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
	data.value="2002-11-30"
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

function ReTitle(form,buttonValue){
form.Direction.value=1-parseInt(form.Direction.value);
form.OrderItem.value=buttonValue;
form.submit();
}

function Process(Form,PType,HostId,Memo)
{
Form.Operator.value=PType ;
Form.OperatorID.value=HostId;
Form.Memo.value=Memo;
Form.submit();
}


function SearchHost(form){

if (form.all.one.checked) {

			if (form.SearchItem.value=="s_buydate"||form.SearchItem.value=="s_expiredate"){
								if (form.Signal.value=="$"&&form.SearchValue.value!="") {
															alert('错误，日期不能执行包含操作');
															form.Signal.focus();
															return false;
													}
								if (form.SearchValue.value!="") if (!isDate(form.SearchValue,form.SearchItem.value)) return false;
			
					}

				if (form.SearchItem.value=="s_serverIP"){
								if (form.Signal.value!="eq") {
															alert('错误，IP地址只能执行等于操作');
															form.Signal.value="eq"
															form.Signal.focus();
															return false;
												
													}


					if (form.SearchValue.value!="") if (!isIPAddress(form.SearchValue,"服务器IP地址")) return false;
					}
		}
if (form.all.two.checked) {
	if (!checkNull(form.DaysNow,"距今天数")) return false;
	if (!isDigital(form.DaysNow,"距今天数")) return false;
}
form.submit();
}

function TBoxAll(form,UserCheck){
for (i=0;i<form.elements.length;i++){
strName=form.elements[i].name;
if (strName=="T_Orders") form.elements[i].checked=UserCheck;
}
return true;
}

function DBoxAll(form,UserCheck){
for (i=0;i<form.elements.length;i++){
strName=form.elements[i].name;
if (strName=="D_Orders") form.elements[i].checked=UserCheck;
}
return true;
}

function ReBoxAll(form,StrName){

for (i=0;i<form.elements.length;i++){
strName=form.elements[i].name;
if (strName==StrName) form.elements[i].checked=!form.elements[i].checked;
}
return true;

}
function rexlook(v)
{
	var vv=document.getElementById(v);
	if(vv.style.display=='none'){
		vv.style.display='';
	}else{
		vv.style.display='none';
	}
	
}
function onstaple(v,f,i){
	if(v!=''){
		if(confirm('确定添加备注吗?')){
				
				Process(f,'Mark',i,v);
		}
	}
}

</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域名续费管理(今天日期：<%=formatDateTime(now(),2)%>)</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="../sitemanager/c_charge.asp">主机续费通知</a> | <a href="../mailmanager/c_chage.asp">邮局续费通知</a> | <a href="c_charge.asp">域名续费通知</a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<form name="form1" method="post" action="">
  <tr>
    <td width="46%" align="right" class="tdbg">查找剩余日期小于
      <input name="Exddate" type="text" id="Exddate" value="30" size="3">
      天的站点</td>
    <td width="54%" class="tdbg"><input type="submit" name="button" id="button" value=" 开始查找 ">
      <input name="Act" type="hidden" id="Act" value="S"></td>
  </tr>
    </form>
</table>
<br>

<table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
  <tr align="center"> 
    <td nowrap class="Title"><strong><font color="#FFFFFF">绑定域名</font></strong></td>
    <td nowrap class="Title"><strong><font color="#FFFFFF">用户名</font></strong></td>
    <td nowrap class="Title"><strong><font color="#FFFFFF">产品型号</font></strong></td>
    <td nowrap class="Title"><strong>产品名称</strong></td>
    <td nowrap class="Title"><strong>开通时间</strong></td>
    <td nowrap class="Title"><strong>购买年限</strong></td>
    <td nowrap class="Title"><strong>到期日期</strong></td>
    <td nowrap class="Title"><strong>剩余天数</strong></td>
  </tr>
  <%
  conn.open constr
  Action=requesta("Act")
if Action="" then
	sql="SELECT dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate)) as exDate,dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate) as extime,domainlist.strDomain, domainlist.regdate, domainlist.rexpiredate, productlist.p_name, domainlist.years, UserDetail.u_name FROM (domainlist INNER JOIN productlist ON domainlist.proid = productlist.P_proId) INNER JOIN UserDetail ON domainlist.userid = UserDetail.u_id WHERE dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate))>=0 and dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate))<=30"
else
	Exddate=requesta("Exddate")
	if not isnumeric(Exddate) then
		url_return "输入值只能为整数。",-1
	end if
	sql="SELECT dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate)) as exDate,dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate) as extime,domainlist.strDomain, domainlist.regdate, domainlist.rexpiredate, productlist.p_name, domainlist.years, UserDetail.u_name FROM (domainlist INNER JOIN productlist ON domainlist.proid = productlist.P_proId) INNER JOIN UserDetail ON domainlist.userid = UserDetail.u_id WHERE dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate))>=0 and dateDiff("&PE_DatePart_D&",'"&now()&"',dateadd("&PE_DatePart_Y&",domainlist.years,domainlist.regdate))<="&Exddate
end if

rs.open sql,conn,1,3
Dim PageNo
PageNo=Request.QueryString("PageNo")
rs.PageSize=30 '每页记录数
rs.CacheSize=rs.PageSize '记录缓存
If IsBlank(PageNo) or not IsNumeric(PageNo) then PageNo=1 '如果PageNo为空,则PageNo等于1
PageNo=CLng(PageNo)
If PageNo<1 then PageNo=1 '如果PageNo小于1,则PageNo等于1
If PageNo>rs.PageCount then PageNo=rs.PageCount '如果PageNo大小总页数,则PageNo等于总页数
Dim i,n
i=(PageNo-1)*rs.PageSize '序号
If not rs.Eof then
rs.AbsolutePage=PageNo '设置当前页
For n=1 to rs.PageSize
i=i+1
%>
  <tr> 
    <td nowrap class="tdbg"><%=rs("m_bindname")%></td>
    <td nowrap class="tdbg"><a href="../usermanager/detail.asp?u_id=<%=rs("m_ownerid")%>" target="_blank"><%=rs("u_name")%></a></td>
    <td nowrap class="tdbg"><%=rs("s_productid")%></td>
    <td nowrap class="tdbg"><%=rs("p_name")%></td>
    <td align="center" nowrap class="tdbg"><%=formatdatetime(rs("m_buydate"),1)%></td>
    <td align="center" nowrap class="tdbg"><%=rs("m_years")%></td>
    <td align="center" nowrap class="tdbg"><%=formatdatetime(rs("extime"),1)%></td>
    <td align="center" nowrap class="tdbg"><%=rs("exDate")%></td>
  </tr>
  <%
	rs.MoveNext
	If rs.EOF then Exit For
	Next
	else
%>
  <tr align="center" bgcolor="ffffff"> 
    <td colspan="8">没有记录</td>
  </tr>
  <%end if%>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr> 
    <td align="center"> 
      <%
Function GotoStr()
	Dim P
	For n=1 to rs.PageCount
		If PageNo=n then P=" Selected" Else P=""
		GotoStr=GotoStr & vbCrlf & "<Option value="&n&""&P&"&Action="&Action&"&Class="&CClass&"&KeyWord="&KeyWord&">第" & n & "页</Option>" & vbCrlf
	Next
End Function


response.Write("共有 <strong><font color=ff0000>"&rs.pagecount&"</font></strong> 页")

response.Write(" <a href=?pageno=1&Action="&Action&"&Class="&CClass&"&KeyWord="&KeyWord&">首页</a> <a href=?pageno="&pageno - 1&"&Action="&Action&"&Class="&CClass&"&KeyWord="&KeyWord&">上一页</a> <a href=?pageno="&pageno + 1&"&Action="&Action&"&Class="&CClass&"&KeyWord="&KeyWord&">下一页</a> <a href=?pageno="&rs.pagecount&"&Action="&Action&"&Class="&CClass&"&KeyWord="&KeyWord&">尾页</a>")

response.Write("&nbsp; 转到：<select name=GoTo class=input-box onchange=Goto(this) ID=Select1>" & GotoStr & "</select>")
	rs.close
		%>
    </td>
  </tr>
</table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->