<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr
sub echo(strMessage)
  Response.write "<script language=javascript>alert('" & strMessage & "');history.back();</script>"
  Response.end
end sub

pageNo=Trim(Requesta("PageNo"))
if not isNumeric(pageNo) then pageNo=1
pageNo=cint(pageNo)
if pageNo<1 then pageNo=1
pageSize=15
Sql="Select * from fuser where L_ok="&PE_False&" order by D_date desc"

uUsers=0
Rs.open Sql,conn,3,3
Rs.pageSize=pageSize
pageCount=Rs.pageCount
if pageNo>pageCount then pageNO=pageCount
if not Rs.eof then Rs.absolutePage=pageNo
Sql="Select count(*) as uTotal from fuser where L_ok="&PE_False&""
Set RsTemp=conn.Execute(Sql)
if isNumeric(RsTemp("uTotal")) then uUsers=RsTemp("uTotal")
RsTemp.close
Set RsTemp=nothing
%>
<script language=javascript>
<!--
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

function checkGo(form)
{
  if (!checkNull(form.page_No,"ҳ��")) return false;
  if (!isDigital(form.page_No,"ҳ��")) return false;
  form.pageNo.value=form.page_No.value;
  form.submit();
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>VCPģʽ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border">
<form name="form1" method="post" action="vcp_verify.asp">
                      <tr align="center"> 
                        <td height="20" class="Title"><strong><font color="#FFFFFF">���</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">�û���</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">����</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">����</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">�ʻ�</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">������</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">��ʽ</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">����</font></strong></td>
                        <td height="20" class="Title"><strong><font color="#FFFFFF">��������</font></strong></td>
                        <td height="20" colspan="2" class="Title"><strong><font color="#FFFFFF">���</font></strong></td>
                      </tr>
                      <%
i=1
do while not Rs.eof and i<=pageSize
Sql="Select u_name,u_namecn from userdetail where u_id=" & Rs("u_id")
Set RsTemp=conn.Execute(Sql)
if not RsTemp.eof then
		name=RsTemp("u_namecn")
		username=RsTemp("u_name")
		%>
							  <tr> 
								<td class="tdbg"><%=(pageNo-1)*pageSize+i%></td>
								<td class="tdbg"><%=username%></td>
								<td class="tdbg"><%=name%></td>
								<td class="tdbg"><%=Rs("C_domain")%> </td>
								<td class="tdbg"><%=Rs("C_accounts")%>&nbsp;</td>
								<td class="tdbg"><%=Rs("C_bank")%>&nbsp;</td>
								<td class="tdbg"><%=Rs("C_remitMode")%></td>
								<td class="tdbg"><%=Rs("C_from")%>&nbsp;</td>
								<td class="tdbg"><%=formatDateTime(Rs("D_date"),2)%></td>
								<td align="center" class="tdbg"><a href="javascript:MM_openBrWindow('vcp_ver.asp?id=<%=Rs("id")%>&Act=Pass','','resizable=yes,width=380,height=320')">ͨ��</a></td>
								<td align="center" class="tdbg"><a href="javascript:MM_openBrWindow('vcp_ver.asp?id=<%=Rs("id")%>&Act=NoPass','','resizable=yes,width=380,height=320')">����</a></td>
							  </tr>
							  <%
end if
RsTemp.close
Set RsTemp=nothing

i=i+1
Rs.moveNext
Loop
Rs.close
%>
                      <tr bgcolor="#D2EAFB">
                        <td colspan="11" align="center" bgcolor="#D2EAFB" class="tdbg"><a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">��ҳ</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">��һҳ</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">��һҳ</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">δҳ</a>
    ��ҳ��:<%=pageCount%>&nbsp;<input type="hidden" name="pageNo" value="<%=pageNo%>"></td>
    </tr>
</form>
  </table>              
</body>
</html>
