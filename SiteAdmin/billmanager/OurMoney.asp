<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(5)%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>����ˮ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
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
//	var reg=/^����-\d+/;
//	if (reg.exec(Str.value)==null){
//		alert("ģʽ������ȷΪ:����-XXX(����XXXΪ����)");
//		Str.focus();
//		Str.select();
//		return false;
//		}
//	return true;

//}


function isDate(data,text){
var reg=/\b(((19|20)\d{2})(-|\/)((0?[1-9])|(1[012]))(-|\/)((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("��Ǹ��"+text+"�����ڸ�ʽ����,��ȷ�ĸ�ʽ��yyyy-MM-dd");
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
			alert("��Ǹ���ύʧ�ܣ�["+text+"]��ֵ����ϵͳ��ʾ��Χ0-9999999");
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

if (!checkNull(form.Name,"����")) return false;
if (!checkNull(form.UserName,"�û���")) return false;
if (!checkNull(form.Amount,"�����")) return false;
if (!isDigital(form.Amount,"�����")) return false;
if (!isDate(form.PayTime,"�������")) return false;
/*
if (form.PayMethod.value.indexOf("��")!=-1)
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
	if Requesta("submessage")="�ύ" then
		submessage="�������ȷ��"
		Sql="Select id from ourmoney where UserName='" & Requesta("UserName") &"' and Amount=" & Amount & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("PayTime") & "')=0"
		Rs.open Sql,conn,1,1
		if not Rs.eof then
			AlertMessage="<font color=red><b>����!</b>���û���" & Requesta("PayTime") & "����" & Requesta("Amount") & "Ԫ���ʣ�����Ƿ��ظ�����!"
		end if
		Rs.close
		Sql="Select * from ourmoney where PayMethod='" & Requesta("PayMethod") &"' and Amount=" & Amount & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("PayTime") & "')=0"
		Rs.open Sql,conn,1,1

		if not Rs.eof then
			AlertMessage="<font color=red><b>����!</b>" & Requesta("PayMethod") & "��" & Requesta("Amount") & "Ԫ��"&Requesta("PayTime")&"�Ѿ����"&rs.RecordCount&"�Σ������"&rs.RecordCount+1&"��"& Requesta("Amount") &"Ԫ���ʣ��ټ������!"
		end if
		Rs.close
	elseif Requesta("submessage")="�������ȷ��" then
	  Sql="Insert into OurMoney ([Name],[UserName],Paymethod,Amount,PayDate,Orders,[Memo],ismove) values('" & Requesta("Name") &"','" & Requesta("UserName") &"','" & Requesta("PayMethod") & "'," & Requesta("Amount") & ",'" & Requesta("PayTime") & "','" & Requesta("Orders") & "','" & Requesta("Memo") &"','"&Requesta("ismove")&"')"
response.write sql	
  conn.Execute(Sql)
	  if isNumeric(Requesta("id")) then
		    Sql="Update PayEnd Set P_state=1 Where id=" & Requesta("id")
		    conn.Execute(Sql)
	  end if
%>

   <script language=javascript>
    alert("���ʳɹ�");
    window.location.href="incount.asp?UserName=<%=Requesta("UserName")%>&Amount=<%=Requesta("Amount")%>&Paymethod=<%=Requesta("PayMethod")%>";
    </script>
 
<%
	Response.end
	end if
else 
    submessage="�ύ"
end if
%> 
                      <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#ffffff" class="border">
                        <tr valign="middle"> 
                          <td colspan="2" class="tdbg">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="32%" align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            ��������</td>
                          <td width="68%" class="tdbg">                            <input type="text" name="Name" value="<%=Requesta("name")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            ������ʺţ�</td>
                          <td class="tdbg">                            <input type="text" name="UserName" value="<%=Requesta("username")%>">
                            (�ڱ�վע����û����� </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            ��ʽ��</td>
            <td class="tdbg">                            <select name="PayMethod" id="PayMethod">
                              <option value="���Ž���"<%if PayMethod="���Ž���" then%> selected<%end if%>>���Ž���</option>
                              
                               <option value="�������"<%if PayMethod="�������" then%> selected<%end if%>>�������</option>
                              <option value="��������"<%if PayMethod="��������" then%> selected<%end if%>>��������</option>
                              <option value="����2��"<%if PayMethod="����2��" then%> selected<%end if%>>����2��</option>
                              <option value="��ͨ����"<%if PayMethod="��ͨ����" then%> selected<%end if%>>��ͨ����</option>
                              <option value="��������"<%if PayMethod="��������" then%> selected<%end if%>>��������</option>
                              <option value="��������"<%if PayMethod="��������" then%> selected<%end if%>>��������</option>
                              <option value="���̽�"<%if PayMethod="���̽�" then%> selected<%end if%>>���̽�</option>
                              <option value="֧����֧��"<%if PayMethod="֧����֧��" then%> selected<%end if%>>֧����֧��</option>
                              <option value="��Ǯ֧��"<%if PayMethod="��Ǯ֧��" then%> selected<%end if%>>��Ǯ֧��</option>
                              <option value="�Ƹ�֧ͨ��"<%if PayMethod="�Ƹ�֧ͨ��" then%> selected<%end if%>>�Ƹ�֧ͨ��</option>
                                          <option value="����֧��"<%if PayMethod="����֧��" then%> selected<%end if%>>����֧��</option>
                              <option value="ũҵ����"<%if PayMethod="ũҵ����" then%> selected<%end if%>>ũҵ����</option>
                              <option value="����֧��"<%if PayMethod="����֧��" then%> selected<%end if%>>����֧��</option>
                              <option value="��˾ת��"<%if PayMethod="��˾ת��" then%> selected<%end if%>>��˾ת��</option>
                              <option value="�������ʻ��"<%if PayMethod="�������ʻ��" then%> selected<%end if%>>�������ʻ��</option>
                              <option value="��˾ת��2"<%if PayMethod="��˾ת��2" then%> selected<%end if%>>��˾ת��2</option>
                              <option value="�������ۻ��"<%if PayMethod="�������ۻ��" then%> selected<%end if%>>�������ۻ��</option>
                                                       </select>                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            ����</td>
                          <td class="tdbg">                            <input type="text" name="Amount" value="<%=Amount%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            �����ţ�</td>
                          <td class="tdbg">                            <input type="text" name="Orders" value="<%=Requesta("Orders")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg">��ע��</td>
                          <td class="tdbg">                            <input type="text" name="Memo" size="30" value="<%=request("memo")%>">                            </td>
                        </tr>
                        <tr> 
                          <td align="right" bgcolor="#D2EAFB" class="tdbg"> 
                            ������ڣ�</td>
                          <td class="tdbg">                            <input type="text" name="PayTime" size="30" value="<%=PayTime%>">                            </td>
                        </tr>
                        <tr>
                          <td align="right" bgcolor="#D2EAFB" class="tdbg">�Ƿ����ڲ�ת�ʣ�</td>
                          <td class="tdbg"> 
<%
if request("ismove")<>"" then
ismove=request("ismove")
else
ismove=0
end if

%>

                            <input type="radio" name="ismove" value="0" <%if ismove=0 then response.write "checked"%>>
                            �� 
                            <input type="radio" name="ismove" value="1" <%if ismove=1 then response.write "checked"%>>
                            �� (������ֽ�浽��˾�ʺţ���ѡ���ǡ�����</td>
                        </tr>
                        <%if len(AlertMessage)>5 then%>
                        <tr align="center"> 
                          <td colspan="2" bgcolor="#D2EAFB" class="tdbg"><%=AlertMessage%></td>
                        </tr>
                        <%end if%>
                        <tr> 
                          <td colspan="2" align="center" class="tdbg"> 
                            <input type="submit" name="submessage" value="<%=submessage%>">
                            <input type="button" name="Submit2" value="�� ��">
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
