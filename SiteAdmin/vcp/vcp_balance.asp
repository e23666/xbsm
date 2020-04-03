<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(6)%>
<%


conn.open constr
sub echo(strMessage)
  Response.write "<script language=javascript>alert('" & strMessage & "');window.close();</script>"
  Response.end
end sub

id=Trim(Requesta("id"))
if not isNumeric(id) then
  echo "非法调用"
end if

Dim Money,Tmoney,Smoney
	Tmoney=Trim(Requesta("Tmoney"))
    PMoney=Trim(Requesta("Money"))
	TotalMoney=Trim(Requesta("TotalMoney"))
   if PMoney<>"" then
	Tmoney=Ccur(Tmoney)
    PMoney=Ccur(PMoney)
	TotalMoney=Ccur(TotalMoney)
    if not isNumeric(Tmoney) or not isNumeric(PMoney) or not isNumeric(TotalMoney) then 
       echo "错误的调用"
    end if
    if PMoney>Tmoney then
      Response.write "<script language=javascript>alert('错误，实付金额(" & PMoney & ")必须小于可付金额(" & Tmoney & ")');history.back();</script>"
      Response.end
    end if
    Sql="update fuser set D_end=GetDate(),N_total=N_total+" & PMoney & ",N_remain=" & Tmoney-PMoney & ",N_Ptotal=" & TotalMoney &" Where id=" & id
    conn.Execute(sql)
    Sql="Select u_id from fuser where id=" & id
    Set RsTemp=conn.Execute(Sql)
    if RsTemp.eof then
       echo "发生错误"
    else
       u_id=RsTemp("u_id")
    end if
    RsTemp.close
	Sql="Select u_namecn,u_email from userdetail where u_id=" & u_id
	RsTemp.open Sql,conn,1,1
	u_namecn=RsTemp("u_namecn")
	u_email=RsTemp("u_email")
	RsTemp.close

	MailBody="尊敬的" & u_namecn & "<br>&nbsp;&nbsp;您好！<p>&nbsp;&nbsp;感谢您成为我司的ＶＣＰ模式合作伙伴，您现在的利润总额已达" & Tmoney & "元，我们已经将" & PMoney & "元现金汇到了您在填写VCP资料的时候留下的银行帐户(邮政地址)上，请注意查收，若有不清楚之处，也欢迎您与我司联系"

	SendMail u_email,"VCP结算通知",MailBody


 	Sql="insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck , c_type) values (" & u_id & " ," & Pmoney & " ,0,  " & Pmoney & " ,'vcp-" & Cstr(formatDateTime(Now,2)) & "','VCP结算',0,getdate(),getdate(),getdate(),10)"
	conn.Execute(Sql)
    Response.write "<script language=javascript>alert('结算成功');opener.location.reload();window.close();</script>"
    Response.end
else
   Sql="Select * from fuser where id=" & id
   Rs.open Sql,conn,1,1
   if Rs.eof then alert_return "无此用户",-1
   Sql="Select sum(u_resumesum+u_usemoney) as Tmoney from userdetail where f_id=" & Rs("u_id") & " and u_id<>" &  Rs("u_id")
   Set RRs=conn.Execute(Sql)
   TotalMoney=0
   if not isNull(RRs("Tmoney")) then TotalMoney=RRs("Tmoney")
   RRs.close
   Set RRs=nothing
   Prate=Csng(Rs("C_AgentType"))/100
   TotalMoney=Ccur(TotalMoney)
   Smoney=(TotalMoney-Rs("N_Ptotal"))*Prate
   Sql="Select * from userdetail where u_id=" & Rs("u_id")
   Set URS=conn.Execute(Sql)
end if
%>
<html>
<head>
<title>客户结算</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="vcp_style.css" type="text/css">
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

function subcal(form){
if (!isDate(form.balanceTime,"结算日期")) return false;
form.submit();
}

function check(form){
if (!checkNull(form.Money,"实付金额")) return false;
if (!isDigital(form.Money,"实付金额")) return false;
if (form.Money.value><%=Smoney+Rs("N_remain")%>){
  alert("实付金额必须小于等于可付金额");
  form.Money.focus();
  form.Money.select();
  return false;
	}
form.StartB.value="Start";
return true;
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="window.moveTo(140,20);" topmargin="10">
<form name="form1" method="post" action="vcp_balance.asp" onSubmit="return check(this);">
  <table width="355" border="1" cellspacing="0" cellpadding="4" height="58" bordercolor="#006699" bordercolordark="#FFFFFF">
    <tr> 
      <td width="55">用户名:</td>
      <td width="94"><%=Rs("username")%></td>
      <td width="54">姓名:</td>
      <td width="110"><%=URs("u_namecn")%></td>
    </tr>
    <tr> 
      <td width="55">地址:</td>
      <td colspan="3"><%=URs("u_address")%></td>
    </tr>
    <tr> 
      <td width="55">邮编:</td>
      <td width="94"><%=URs("u_zipcode")%></td>
      <td width="54">帐号:</td>
      <td width="110"><%=Rs("C_Accounts")%>&nbsp;</td>
    </tr>
    <tr> 
      <td width="55">开户行:</td>
      <td colspan="3"><%=Rs("C_bank")%> &nbsp;</td>
    </tr>
    <tr> 
      <td width="55">付款方式:</td>
      <td width="94"><%=Rs("C_remitMode")%> </td>
      <td width="54">上次结算:</td>
      <td width="110"><%=formatDateTime(Rs("D_End"),1)%></td>
    </tr>
    <tr> 
      <td width="55">结算时间:</td>
      <td colspan="2"><%=formatDateTime(now,2)%> </td>
      <td width="110">&nbsp; </td>
    </tr>
    <tr>
      <td width="55">上次余额:</td>
      <td><%=formatNumber(Rs("N_remain"),2,-1)%></td>
      <td>本次利润</td>
      <td width="110"><%=formatNumber(sMoney,2,-1)%></td>
    </tr>
    <tr> 
      <td width="55">可付金额:</td>
      <td><%=formatNumber(Rs("N_remain")+sMoney,2,-1)%></td>
      <td>实付金额:</td>
      <td width="110"> 
        <input type="text" name="Money" maxlength="6" size="5">
      </td>
    </tr>
    <tr align="center"> 
      <td colspan="4" height="49"> 
        <input type="submit" name="Submit" value="确认[O]" id=ok >
        <input type="button" name="Submit2" value="取消[C]" onClick="window.close();" id=cancel>
        <label for=ok AccessKey=O></label><label for=cancel AccessKey=C> 
        <input type="hidden" name="id" value="<%=id%>">
        <input type="hidden" name="Tmoney" value="<%=Rs("N_remain")+sMoney%>">
        <input type="hidden" name="TotalMoney" value="<%=TotalMoney%>">

        </label> </td>
    </tr>
  </table>
  <p>注:可付金额＝上次余额+本次利润</p>
</form>
</body>
</html>
<%
Rs.close
URs.close
Set URs=nothing
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
