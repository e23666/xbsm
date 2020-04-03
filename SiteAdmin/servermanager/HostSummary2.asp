<!--#include virtual="/config/config.asp"-->
<%
Check_is_Master(6)
conn.open conStr
id=Trim(Requesta("id"))
if not isNumeric(id) then url_return "ID非数字",-1
if Requesta("Act")="ERASE" then
	Sql="select [Start] from HostRental where id=" & id
	rs.open sql,conn,1,1
	if rs.eof then url_return "抱歉,记录不存在",-1
	isOkay=Rs("Start")
	Rs.close
	if isOkay then
		if left(session("u_type"),1)<>"1" then
			url_return "权限不足",-1
		end if
	end if
	conn.Execute ( "Delete from HostRental Where id=" & id )
	Response.write "<script language=javascript>alert('删除成功');location.href='HostSummary2.asp';</script>"
	Response.end
end if
Sql="Select * from HostRental where id=" & id
Rs.open Sql,conn,1,1
if Rs.eof then
	Rs.close
	url_return "未找到此服务器",-1
end if

if Rs("Start") then
	if DateDiff("d",Now(),DateAdd("yyyy",Rs("Years"),Rs("StartTime")))<0 then
		Status="<font color=red>已过期</font>"
	else
		ExpireTime=DateAdd("m",Rs("AlreadyPay"),Rs("StartTime"))
		if DateDiff("d",Now(),ExpireTime)<0 then
			Status="<font color=Green>已欠费</font>"
		else
			Status="正常"
		end if
	end if
else
	Status="<font color=blue>未开通</font>"
end if
%>

<script language=javascript>
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


function checkForm(form){
	if (!checkNull(form.Name,"联系人")) return false;
	if (!checkNull(form.Telephone,"电话")) return false;
	if (!checkNull(form.Email,"Email地址")) return false;
	if (!checkNull(form.Zip,"邮编")) return false;
	if (!checkNull(form.Address,"地址")) return false;

	if (!checkNull(form.CPU,"服务器处理器")) return false;
	if (!checkNull(form.HardDisk,"服务器硬盘")) return false;
	if (!checkNull(form.Memory,"服务器内存")) return false;

	if (!isDate(form.StartTime,"开通日期")) return false;
	if (!isIPAddress(form.AllocateIP,"分配ＩＰ")) return false;
	if (form.Submit.value=='正 式 开 通'){
			if (confirm('是否扣除押金?')){
				form.deposit.value='yesneed';
			}
			else{form.deposit.value='notneed';}
	}

	return true;

}

function Scatter(form,id){
	if (form.Identify[id].checked)
		{
		for (i=0;i<id;i++)
			form.Identify[i].checked=true;
			form.AlreadyPay.value=id+1;
		}
	else{
		for (i=id;i<form.Identify.length;i++)
			form.Identify[i].checked=false;
			form.AlreadyPay.value=id;
		}
	return ;
}


</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>服 务 器 租 用 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">服务器/VPS管理</a> | <a href="ServerListnote.asp">查看新订单</a> | <a href="ServerWarn.asp">查看过期订单</a></td>
  </tr>
</table>
      <br />
<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr valign="top"> 
    <td > <span class="fontSize"></span> 
      <form name=form1 method="post" action="SaveHost2.asp" onSubmit="return checkForm(this);">
        <fieldset class="border"><legend>联系人信息</legend> 
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr> 
            <td height="124"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="4">
                <tr> 
                  <td width="16%" class="tdbg">公司名称：</td>
                  <td class="tdbg"> 
                    <input type="text" name="Company" maxlength="255" size="25" value="<%=Rs("Company")%>">
                  </td>
                  <td class="tdbg">用户:</td>
                  <td class="tdbg">
                    <input type="text" name="u_name" maxlength="50" size="15" value="<%=Rs("u_name")%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">联系人:</td>
                  <td width="37%" class="tdbg"> 
                    <input type="text" name="Name" maxlength="50" size="15" value="<%=Rs("Name")%>">
                    * </td>
                  <td width="14%" class="tdbg">电话:</td>
                  <td width="33%" class="tdbg"> 
                    <input type="text" name="Telephone" maxlength="50" size="15" value="<%=Rs("Telephone")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">Email:</td>
                  <td width="37%" class="tdbg"> 
                    <input type="text" name="Email" maxlength="100" size="15" value="<%=Rs("Email")%>">
                    * </td>
                  <td width="14%" class="tdbg">QQ:</td>
                  <td width="33%" class="tdbg"> 
                    <input type="text" name="QQ" maxlength="50" size="15" value="<%=Rs("QQ")%>">
		    <%
		    if Rs("qq")<>"" then
		%>
	<a target=blank href=http://wpa.qq.com/msgrd?V=1&Uin=<%= Rs("qq")%>&Menu=yes><img border="0" SRC=http://wpa.qq.com/pa?p=1:<%=Rs("qq")%>:4 alt="点击发送消息给对方"> <%=Rs("qq")%></a> 
		<%
		    end if
		    %>
                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">手机:</td>
                  <td width="37%" class="tdbg"> 
                    <input type="text" name="Fax" maxlength="100" size="15" value="<%=Rs("Fax")%>">
                  </td>
                  <td width="14%" class="tdbg">邮编:</td>
                  <td width="33%" class="tdbg"> 
                    <input type="text" name="Zip" maxlength="6" size="6" value="<%=Rs("Zip")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">地址：</td>
                  <td colspan="3" class="tdbg"> 
                    <input type="text" name="Address" maxlength="100" size="50" value="<%=Rs("Address")%>">
                    * <a href="ServerList.asp"><font color="#FF0000">返回</font></a></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        </fieldset> <br />
        <fieldset class="border"><legend>服务器相关信息 <font color="#FF0000">以下项目只有管理员可以进行修改</font></legend> 
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr> 
            <td>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
                <tr> 
                  <td width="16%" class="tdbg">主机类型:</td>
                  <td class="tdbg" width="37%"> 
                    <input type="text" name="HostID" maxlength="100" size="15" value="<%=Rs("HostID")%>">
                  </td>
                  <td class="tdbg" width="14%">操作系统:</td>
                  <td class="tdbg" width="33%"><%=Rs("OS")%></td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">主机用途:</td>
                  <td colspan="3" class="tdbg"> 
                    <input type="text" name="Apply" maxlength="100" size="15" value="<%=Rs("Apply")%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">CPU:</td>
                  <td width="37%" class="tdbg"> 
                    <input type="text" name="CPU" maxlength="100" size="15" value="<%=Rs("CPU")%>">
                    * </td>
                  <td width="14%" class="tdbg">硬盘:</td>
                  <td width="33%" class="tdbg"> 
                    <input type="text" name="HardDisk" maxlength="100" size="15" value="<%=Rs("HardDisk")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">内存:</td>
                  <td class="tdbg" width="37%"> 
                    <input type="text" name="Memory" maxlength="100" size="15" value="<%=Rs("Memory")%>">
                    * </td>
                  <td class="tdbg" width="14%">主板:</td>
                  <td class="tdbg" width="33%"> 
                    <input type="text" name="MainBoard" maxlength="100" size="15" value="<%=Rs("MainBoard")%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="tdbg">备注:</td>
                  <td colspan="3" class="tdbg"> 
                    <textarea name="Memo" rows="6" cols="50"><%=Rs("Memo")%></textarea>
                    <input type="submit" name="upmemo" value="更新备注">
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        </fieldset> <br>
        <div align="center">
<%
if Rs("Start") then
	Message="保 存 修 改"
else
	Message="正 式 开 通"
end if
%>
		  <input type="hidden" name="AlreadyPay" value="<%=Rs("AlreadyPay")%>">
          <input type="hidden" name="id" value="<%=id%>">
          <%
if not Rs("Start") then Response.write "<input type=Hidden name=""Act"" value=""Start"">"
	%>
          <input type="hidden" name="deposit">
          <br>
        </div>
      </form>
</td>
  </tr>
</table>
</body>
</html>
<%
Rs.close
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
