<!--#include virtual="/config/config.asp" -->
 <%Check_Is_Master(6)%>
<script language="javascript" src="/manager/inter_menu.js"></script>
<script language="javascript" src="/manager/menu1.js"></script>
 <SCRIPT language=javaScript>
function CheckIfEnglish(String)
{
    var Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_";
     var i;
     var c;
     for( i = 0; i < String.length; i ++ )
     {
          c = String.charAt( i );
	  if (Letters.indexOf( c ) < 0)
	     return false;
     }
     return true;
}
function checkReg()
{

     if  ((!document.regForm.u_password.value == "") && (document.regForm.u_password.value.length < 6 )) {
		alert("��ʾ��\n\n��������6λ");
		document.regForm.u_password.focus();
		return false;
	}
     if (document.regForm.u_password.value != document.regForm.u_password2.value ) {
		alert("��ʾ��\n\n���������ͬ");
		document.regForm.u_password2.focus();
		return false;
	}

	if (document.regForm.u_namecn.value == ""){
		alert ("��ʾ��\n\n����������������");
		document.regForm.u_namecn.focus();
		return false;
	}
	if (document.regForm.u_nameen.value == ""){
		alert ("��ʾ��\n\n��������Ӣ������");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") < 0 ){
		alert ("��ʾ��\n\nӢ�����б����пո��ҿո����ǵ�һλ�����һλ��");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") <= 1){
		alert ("��ʾ��\n\nӢ�����б����пո��ҿո����ǵ�һλ��");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") == document.regForm.u_nameen.value.length-1 ){
		alert ("��ʾ��\n\nӢ�����б����пո��ҿո��������һλ��");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_company.value == ""){
		alert ("��ʾ��\n\n�������빫˾���ƣ�");
		document.regForm.u_company.focus();
		return false;
	}
	if (document.regForm.u_contract.value == ""){
		alert ("��ʾ��\n\n����������ϵ�ˣ�");
		document.regForm.u_contract.focus();
		return false;
	}
	if (document.regForm.u_contry.value == ""){
		alert ("��ʾ��\n\n����������ң�");
		document.regForm.u_contry.focus();
		return false;
	}
	if (document.regForm.u_province.value == ""){
		alert ("��ʾ��\n\n��������ʡ�ݣ�");
		document.regForm.u_province.focus();
		return false;
	}
	if (document.regForm.u_city.value == ""){
		alert ("��ʾ��\n\n����������У�");
		document.regForm.u_city.focus();
		return false;
	}
	bString = "0123456789-*";
		for(i = 0; i < document.regForm.u_zipcode.value.length; i ++)
		{
			if (bString.indexOf(document.regForm.u_zipcode.value.substring(i,i+1))==-1)
			{
				alert('�ʱ� ֻ�ܰ������ּ�-*');
				document.regForm.u_zipcode.focus();
				return false;
			}
		}
	if (document.regForm.u_address.value == ""){
		alert ("��ʾ��\n\n���������ַ��");
		document.regForm.u_address.focus();
		return false;
	}
	if (document.regForm.u_telphone.value == ""){
		alert ("��ʾ��\n\n��������绰��");
		document.regForm.u_telphone.focus();
		return false;
	}



	bString = "0123456789,.+()/-&";
		for(i = 0; i < document.regForm.u_telphone.value.length; i ++)
		{
			if (bString.indexOf(document.regForm.u_telphone.value.substring(i,i+1))==-1)
			{
				alert('�绰 ֻ�ܰ������ֺ�,.+()/-&');
				document.regForm.u_telphone.focus();
				return false;
			}
		}
     if (document.regForm.u_email.value.length==0) {
                alert("��ʾ��\n\n����д���EMAIL��ַ");
				document.regForm.u_email.focus();
                return false;
             }

     else if ((document.regForm.u_email.value.indexOf("@")<0)||(document.regForm.u_email.value.indexOf("��")!=-1))
                {
                        alert("��ʾ��\n\n����д��EMAIL��Ч������дһ����Ч��EMAIL\n\n");
                        document.regForm.u_email.focus();
                        return false;
                }
}
</SCRIPT>
<%

sqlstring="select * from UserDetail where u_id="&session("u_sysid")
session("sqlcmd_VU")=sqlstring
conn.open constr
rs.open session("sqlcmd_VU") ,conn,3
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�����޸�</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' > </td>
  </tr>
</table>
<br />
<table width="100%" height="218" cellpadding="0" cellspacing="0"   bordercolor="#FFFFFF" class="border" id="AutoNumber3" style="border-collapse�� collapse">
<form name=regForm onSubmit="return checkReg()" action="success.asp" method=post>
                      <tr> 
                        
      <td height="175" valign="top" class="tdbg"> 
        <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="tdbg">
                      <tr> 
                        <td height="25" valign="middle" colspan="4" class="Title"> 
                          <strong>��������</strong></td>
    </tr>
                            <tr> 
                              <td align="right">�û�����</td>
                              <td colspan="3"> 
                                <input type=hidden value="u_modi" name=module>
                                &nbsp;<%=rs("u_name")%></td>
                            </tr>
                            <tr> 
                              <td align="right"> �����룺</td>
                              <td> &nbsp; 
                                <input name=u_password  type=password  value="" size=20>                              </td>
                              <td align="right"> ȷ�������룺</td>
                              <td> &nbsp; 
                                <input name=u_password2  type=password  value="" size=20>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> ��ϵ�ˣ�</td>
                              <td> &nbsp; 
                                <input name=u_contract  value="<%=rs("u_contract")%>"  size=20 >                              </td>
                              <td align="right"> ��˾��</td>
                              <td> &nbsp; 
                                <input name=u_company  value="<%=rs("u_company")%>"  size=20>
                            </tr>
                            <tr> 
                              <td align="right"> ����(����)��</td>
                              <td> &nbsp; 
                                <input  name=u_namecn value="<%=rs("u_namecn")%>" size=20>                              </td>
                              <td align="right"> ����(ƴ��)��</td>
                              <td> &nbsp; 
                                <input name="u_nameen" type="text" value="<%=rs("u_nameen")%>" size=20>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> ���ң�</td>
                              <td> &nbsp; 
                                <input name="u_contry" value="<%=rs("u_contry")%>" size="20" maxlength="2">                              </td>
                              <td align="right"> ʡ�ݣ�</td>
                              <td> &nbsp; 
                                <select name=u_province size="1">
                                  <option value="<%=rs("u_province")%>"><%=rs("u_province")%></option>
                                  <option value=Anhui>����</option>
                                  <option value=Macao>����</option>
                                  <option value=Beijing>����</option>
                                  <option value=Chongqing>����</option>
                                  <option value=Fujian>����</option>
                                  <option value=Gansu>����</option>
                                  <option value=Guangdong>�㶫</option>
                                  <option value=Guangxi>����</option>
                                  <option value=Guizhou>����</option>
                                  <option value=Hainan>����</option>
                                  <option value=Hebei>�ӱ�</option>
                                  <option value=Heilongjiang>������</option>
                                  <option value=Henan>����</option>
                                  <option value=Hongkong>���</option>
                                  <option value=Hunan>����</option>
                                  <option value=Hubei>����</option>
                                  <option value=Jiangsu>����</option>
                                  <option value=Jiangxi>����</option>
                                  <option value=Jilin>����</option>
                                  <option value=Liaoning>����</option>
                                  <option value=Neimenggu>���ɹ�</option>
                                  <option value=Ningxia>����</option>
                                  <option value=Qinghai>�ຣ</option>
                                  <option value=Sichuan>�Ĵ�</option>
                                  <option value=Shandong>ɽ��</option>
                                  <option value=Shan1xi>ɽ��</option>
                                  <option value=Shan2xi>����</option>
                                  <option value=Shanghai>�Ϻ�</option>
                                  <option value=Taiwan>̨��</option>
                                  <option value=Tianjin>���</option>
                                  <option value=Xinjiang>�½�</option>
                                  <option value=Xizang>����</option>
                                  <option value=Yunnan>����</option>
                                  <option value=Zhejiang>�㽭</option>
                                  <option value=Others>����</option>
                                </select>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> ���У�</td>
                              <td> &nbsp; 
                                <input name=u_city value="<%=rs("u_city")%>" size=20>                              </td>
                              <td align="right"> �ʱࣺ</td>
                              <td> &nbsp; 
                                <input name=u_zipcode value="<%=rs("u_zipcode")%>" size=20  >                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> �绰��</td>
                              <td> &nbsp; 
                                <input name=u_telphone  value="<%=rs("u_telphone")%>" size=20>                              </td>
                              <td align="right"> ���棺</td>
                              <td> &nbsp; 
                                <input name=u_fax  value="<%=rs("u_fax")%>" size=20  >                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> ��ַ��</td>
                              <td colspan="3"> &nbsp; 
                                <input name=u_address value="<%=rs("u_address")%>" size=40>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> �����ʼ���</td>
                              <td colspan="3"> &nbsp; 
                                <input name=u_email value="<%=rs("u_email")%>" size=30>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> �ƶ��绰��</td>
                              <td colspan="3"> &nbsp; 
                                <input name=msn value="<%=rs("msn_msg")%>" size=30>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> QQ�ţ�</td>
                              <td colspan="3"> &nbsp; 
                                <input name=qq value="<%=rs("qq_msg")%>" size=30>                              </td>
                            </tr>
                          </table>                        </td>
    </tr>
                      <tr> 
                        <td height="25" valign="middle" class="Title"> 
                          &nbsp;<strong>��������</strong></td>
    </tr>
                      <tr> 
                        <td height="5" valign="top" class="tdbg"> 
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="104" height="30" align="right"> ��Ч֤���ţ�</td>
                              <td height="30"> &nbsp; &nbsp; 
                                <input name=u_trade value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" then Response.write " readonly"%>>                              </td>
                            </tr>
                            <tr> 
                              <td width="104" height="62" align="right" valign="middle"> 
                                ��Ϣ��Դ��</td>
                              <td height="62"> &nbsp; &nbsp;�����֪�����ǵ�վ�� --> <font color=red><%=rs("u_know_from")%></font> 
                                <input type="hidden" name="u_know_from" value="<%=rs("u_know_from")%>">                              </td>
                            </tr>
                          </table>                        </td>
    </tr>
                      <tr> 
                        <td height="45" align="center" valign="middle" class="tdbg" > 
                          <input name="ok2" type="submit" value="�� ��">
                          <input name="reset2" type="reset" value="�� ��">                        </td>
    </tr>
                    </form>
                  </table>
