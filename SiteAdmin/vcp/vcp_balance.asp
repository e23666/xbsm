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
  echo "�Ƿ�����"
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
       echo "����ĵ���"
    end if
    if PMoney>Tmoney then
      Response.write "<script language=javascript>alert('����ʵ�����(" & PMoney & ")����С�ڿɸ����(" & Tmoney & ")');history.back();</script>"
      Response.end
    end if
    Sql="update fuser set D_end=GetDate(),N_total=N_total+" & PMoney & ",N_remain=" & Tmoney-PMoney & ",N_Ptotal=" & TotalMoney &" Where id=" & id
    conn.Execute(sql)
    Sql="Select u_id from fuser where id=" & id
    Set RsTemp=conn.Execute(Sql)
    if RsTemp.eof then
       echo "��������"
    else
       u_id=RsTemp("u_id")
    end if
    RsTemp.close
	Sql="Select u_namecn,u_email from userdetail where u_id=" & u_id
	RsTemp.open Sql,conn,1,1
	u_namecn=RsTemp("u_namecn")
	u_email=RsTemp("u_email")
	RsTemp.close

	MailBody="�𾴵�" & u_namecn & "<br>&nbsp;&nbsp;���ã�<p>&nbsp;&nbsp;��л����Ϊ��˾�ģ֣ã�ģʽ������飬�����ڵ������ܶ��Ѵ�" & Tmoney & "Ԫ�������Ѿ���" & PMoney & "Ԫ�ֽ�㵽��������дVCP���ϵ�ʱ�����µ������ʻ�(������ַ)�ϣ���ע����գ����в����֮����Ҳ��ӭ������˾��ϵ"

	SendMail u_email,"VCP����֪ͨ",MailBody


 	Sql="insert into countlist (u_id,u_moneysum,u_in,u_out,u_countId,c_memo,c_check,c_date,c_dateinput,c_datecheck , c_type) values (" & u_id & " ," & Pmoney & " ,0,  " & Pmoney & " ,'vcp-" & Cstr(formatDateTime(Now,2)) & "','VCP����',0,getdate(),getdate(),getdate(),10)"
	conn.Execute(Sql)
    Response.write "<script language=javascript>alert('����ɹ�');opener.location.reload();window.close();</script>"
    Response.end
else
   Sql="Select * from fuser where id=" & id
   Rs.open Sql,conn,1,1
   if Rs.eof then alert_return "�޴��û�",-1
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
<title>�ͻ�����</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="vcp_style.css" type="text/css">
<script language=javascript>
function isIPAddress(data,text){
var reg=/\b([1,2]?[0-9]?[0-9]?)\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\.([1,2]?[0-9]?[0-9])\b/
if (reg.exec(data.value)!=null) {
	return true;
	}
else {
	alert("��Ǹ��"+text+"��ʽ�������������һ����Ч��IP��ַ");
	data.focus();
	data.select();
	return false;
	}
}

function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("��Ǹ��"+text+"�����ڸ�ʽ����,��ȷ�ĸ�ʽ��yyyy-MM-dd");
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

function subcal(form){
if (!isDate(form.balanceTime,"��������")) return false;
form.submit();
}

function check(form){
if (!checkNull(form.Money,"ʵ�����")) return false;
if (!isDigital(form.Money,"ʵ�����")) return false;
if (form.Money.value><%=Smoney+Rs("N_remain")%>){
  alert("ʵ��������С�ڵ��ڿɸ����");
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
      <td width="55">�û���:</td>
      <td width="94"><%=Rs("username")%></td>
      <td width="54">����:</td>
      <td width="110"><%=URs("u_namecn")%></td>
    </tr>
    <tr> 
      <td width="55">��ַ:</td>
      <td colspan="3"><%=URs("u_address")%></td>
    </tr>
    <tr> 
      <td width="55">�ʱ�:</td>
      <td width="94"><%=URs("u_zipcode")%></td>
      <td width="54">�ʺ�:</td>
      <td width="110"><%=Rs("C_Accounts")%>&nbsp;</td>
    </tr>
    <tr> 
      <td width="55">������:</td>
      <td colspan="3"><%=Rs("C_bank")%> &nbsp;</td>
    </tr>
    <tr> 
      <td width="55">���ʽ:</td>
      <td width="94"><%=Rs("C_remitMode")%> </td>
      <td width="54">�ϴν���:</td>
      <td width="110"><%=formatDateTime(Rs("D_End"),1)%></td>
    </tr>
    <tr> 
      <td width="55">����ʱ��:</td>
      <td colspan="2"><%=formatDateTime(now,2)%> </td>
      <td width="110">&nbsp; </td>
    </tr>
    <tr>
      <td width="55">�ϴ����:</td>
      <td><%=formatNumber(Rs("N_remain"),2,-1)%></td>
      <td>��������</td>
      <td width="110"><%=formatNumber(sMoney,2,-1)%></td>
    </tr>
    <tr> 
      <td width="55">�ɸ����:</td>
      <td><%=formatNumber(Rs("N_remain")+sMoney,2,-1)%></td>
      <td>ʵ�����:</td>
      <td width="110"> 
        <input type="text" name="Money" maxlength="6" size="5">
      </td>
    </tr>
    <tr align="center"> 
      <td colspan="4" height="49"> 
        <input type="submit" name="Submit" value="ȷ��[O]" id=ok >
        <input type="button" name="Submit2" value="ȡ��[C]" onClick="window.close();" id=cancel>
        <label for=ok AccessKey=O></label><label for=cancel AccessKey=C> 
        <input type="hidden" name="id" value="<%=id%>">
        <input type="hidden" name="Tmoney" value="<%=Rs("N_remain")+sMoney%>">
        <input type="hidden" name="TotalMoney" value="<%=TotalMoney%>">

        </label> </td>
    </tr>
  </table>
  <p>ע:�ɸ����ϴ����+��������</p>
</form>
</body>
</html>
<%
Rs.close
URs.close
Set URs=nothing
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
