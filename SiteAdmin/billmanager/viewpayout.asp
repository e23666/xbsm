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

if (form.page.value!=""){ if (!isDigital(form.page,"ҳ��")) return false; }
if (form.StartTime.value!="") { if (!isDate(form.StartTime,"��ʼ����")) return false; }
if (form.EndTime.value!="") { if (!isDate(form.EndTime,"��ֹ����")) return false;}
if (form.Amount.value!=""){ if (!isDigital(form.Amount,"���")) return false; }
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
    <td height='30' align="center" ><strong>�鿴֧��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| 
      <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> 
      | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> 
      | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> 
      | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> 
      | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> 
      | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a> 
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
      ���룺��<%=InM%> 
      <%if PayMethod="����֧��" then Response.write "��1.01=" & Round(InM*1.01,2)%>
      &nbsp;|&nbsp;<a href="viewpayout.asp"><font color="#0000FF">֧��</font></a>����<%=Abs(OutM)%>&nbsp;|&nbsp; 
      ����<font color="#FF0000">��<%=OM%></font>&nbsp;<br>
      &nbsp;���գ�<font color="#FF0000">��<%=TM%></font> &nbsp;|&nbsp; ���£�<font color="#000000">��<%=MM%></font> 
      <%end if%>
      <form name="form1" action="ViewOurMoney.asp" method=post onSubmit="return check(this);">
        <p></p>
        <table width=100% border=0 align="center" cellpadding=3 cellspacing=0 bordercolordark="#ffffff" class="border">
          <tbody> 
          <tr> 
            <td class=tdbg align="center">&nbsp;</td>
            <td class=tdbg align="center"><a href="javascript:prepage();">��һҳ</a></td>
            <td align="center" class="tdbg">              <a href="javascript:nextpage();">��һҳ</a></td>
            <td class="tdbg"> 
              <div align="center"><a href="ViewOurMoney.asp?page=<%=page+1%>&StartTime=<%=StartTime%>&EndTime=<%=EndTime%>"> 
                </a> 
                <input type="submit" name="go" value="��">
                <input type="text" name="page" maxlength="3" size="1" value=<%=page%>>
                /<font color="#FF3366"><%=pagecount
%></font></div>            </td>
            <td class=tdbg colspan="3"> 
              <p>���: 
                <input type="text" name="Amount" size="5" maxlength="12" value="<%=Amount%>">
                <select name="PayMethod">
                  <option value="">ȫ������</option>
                  <option value="����֧��" <%if PayMethod="����֧��" then Response.write "selected"%>>����֧��</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>��������</option>
                  <option value="ũ" <%if PayMethod="ũ" then Response.write "selected"%>>ũҵ����</option>
                  <option value="ũҵ����2" <%if PayMethod="ũҵ����2" then Response.write "selected"%>>ũҵ����2</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>��������</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>֧����֧��</option>
                  <option value="��˾ת��2" <%if PayMethod="��˾ת��2" then Response.write "selected"%>>��˾ת��2</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>��������</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>��˾ת��</option>
                  <option value="����" <%if PayMethod="����" then Response.write "selected"%>>�������</option>
                  <option value="��" <%if PayMethod="��" then Response.write "selected"%>>�������ۻ��</option>
                  <option value="����" <%if PayMethod="����" then Response.write "selected"%>>���Ž���</option>
                  <option value="����" <%if PayMethod="����" then Response.write "selected"%>>����֧��</option>
                  <option value="��Ǯ" <%if PayMethod="��Ǯ" then Response.write "selected"%>>��Ǯ֧��</option>
                  <option value="�Ƹ�" <%if PayMethod="�Ƹ�" then Response.write "selected"%>>�Ƹ�֧ͨ��</option>
                  <option value="Ĭ��" <%if PayMethod="Ĭ��" then Response.write "selected"%>>Ĭ������֧��</option>

                </select>
              </p>            </td>
          </tr>
          <tr> 
            <td class=tdbg align="center">��ʼ����:</td>
            <td class=tdbg align="center"> 
              <input type="text" name="StartTime" size="12" maxlength="12" value="<%=StartTime%>" onClick="getDateString(this,oCalendarChs)">            </td>
            <td class="tdbg" align="center">��������:</td>
            <td class="tdbg"> 
              <input type="text" name="EndTime" size="12" maxlength="12" value="<%=EndTime%>" onClick="getDateString(this,oCalendarChs)">            </td>
            <td class=tdbg align="center" colspan="3"> 
              �û���: 
              <input type="text" name="UserName" size="5" maxlength="12" value="<%=UserName%>">
              <input type="submit" name="Submit" value="ȷ��">            </td>
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
            ����            </strong></td>
          <td class="Title"><strong> 
            �û���</strong></td>
          <td class="Title"><strong> 
            ������            </strong></td>
          <td class="Title"><strong>�������</strong></td>
          <td class="Title"><strong> 
            ���</strong></td>
          <td class="Title"><strong>��ʽ</strong></td>
          <td class="Title"><strong> 
            ��ע</strong></td>
          <td class="Title"><strong> 
            ɾ��</strong></td>
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
if rs("ismove") then response.write "<font color=#FF0000>�ڲ�</font>"
%>
              
            <%=rs("PayMethod")%></td>
          <td class="tdbg"> 
            <%=rs("Memo")%></td>
          <td class="tdbg"> 
            <a href="#" onClick="if (confirm('��ȷ��Ҫɾ������Ŀ��ɾ���󲻿ɻָ�!')) location.href='viewourmoney.asp?act=del&id=<%=rs("id")%>'">ɾ��</a></td>
        </tr>
        <% 
	'  end if
     rs.movenext   '����ǰ���ݼ�¼�Ƶ���һ��   
     i=i+1  
   loop
Rs.close

   '��ʼ��һѭ��                
  %> 
      </table>
    </td>
  </tr>
</table>
  

<!--#include virtual="/config/bottom_superadmin.asp" -->
