<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Buffer=true
response.Charset="gb2312"
if requesta("str")="m" then
	mailvalue=trim(request("content"))
	if mailvalue<>"" then
		SendMail mailvalue,"�����ʼ�","�����������յ��ʼ�!"
		response.write "<font color=blue>�ʼ��Ѿ�����,������������鿴�ܷ��յ�</font>"
	else
	   response.write "<font color=red>ʧ��</font>"
	end if
	
	response.end
end if
function isselfquestion(qu)
	if len(qu)="" then isselfquestion=false:exit function
	dim getstrs
	dim stray(10)
	stray(0)="�ҾͶ��ĵ�һ��ѧУ�����ƣ�"
	stray(1)="��ʲô?�Ҹ��׵�ְҵ��"
	stray(2)="�ҵĳ������ǣ�"
	stray(3)="��ĸ�׵�ְҵ��"
	stray(4)="�ҳ��а����ε������ǣ�"
	stray(5)="������˵����֣�"
	stray(6)="�Ұְֵ����գ�"
	stray(7)="����������գ�"
	stray(8)="�Ҹ��׵�������"
	stray(9)="��ĸ�׵�������"
	stray(10)="�ҵ�ѧ��(�򹤺�)��ʲô?"
	getstrs=filter(stray,qu)
	if ubound(getstrs)<0 then	
		isselfquestion=true
	else
		isselfquestion=false
	end if
end function
%>
<script language="javascript" src="/manager/inter_menu.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript" src="/manager/menu1.js"></script>
<SCRIPT language=javaScript>
function doquestion(v){
	if(v=="�ҵ��Զ�������"){
		document.regForm.myQuestion.style.display="";
	}else{
		document.regForm.myQuestion.style.display="none";
	}
}
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
	var ii=0;
	bString="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_!@#$%^*()";
	 while (ii<document.regForm.u_password.value.length)
	 {
		if (bString.indexOf(document.regForm.u_password.value.substring(ii,ii+1))==-1)
		{
			alert("\n\n��������� a-z A-Z 0-9 ֮�����ĸ��������ϻ�!@#$%^*()��");
			document.regForm.u_password.focus();
			return false;
		}
		ii=ii+1;
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
	if (document.regForm.ipfilter.checked){

		if (document.regForm.allowIP.value==""){
		alert ("��ʾ��\n\n������������ʵ�IP�б�");
		document.regForm.allowIP.focus();
		return false;

		}
	iplist=document.regForm.allowIP.value.split(",");
	 for (j=0;j<iplist.length;j++){
	 	 ipMode=/(^\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}$)|(^\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}\/\d{1,2}$)/;
		 if (!ipMode.test(iplist[j])) {alert('��Ǹ������IP��ַ�б��ʽ����ȷ����ȷ����xxx.xxx.xxx.xxx��xxx.xxx.xxx.xxx/n');document.regForm.allowIP.focus();return false;}
		 ipRang=iplist[j].split(".");
		 for (k=0;k<ipRang.length;k++){
		 		slashPos=ipRang[k].indexOf("/");
		 		if (slashPos==-1){
						if (parseInt(ipRang[k])<1||parseInt(ipRang[k])>255){alert('IP��ַ��ʽ����ȷ��ÿһ�β��ܴ���255');document.regForm.allowIP.focus();return false;}
					}
				else{
						lastR=parseInt(ipRang[k].substring(0,slashPos));
						if (lastR>255) {alert('IP��ַ��ʽ����ȷ��ÿһ�β��ܴ���255');document.regForm.allowIP.focus();return false;}
						netNo=parseInt(ipRang[k].substring(slashPos+1))
						if (netNo<2||netNo>31){alert('��Ǹ��IP��ַ�������Ų��ܳ���31,�������1');document.regForm.allowIP.focus();return false;}
					}
		 }
	 }

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
function sendMail(){
	var mailvalue=document.regForm.u_email.value;
	var spanid=document.getElementById('Mailload');
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
	
	if (filter.test(mailvalue)){
		spanid.style.display='';
		spanid.innerHTML='<img src="/images/load.gif" border="0" id="loadimg" />�Ժ�..<br>';
		makeRequest('default.asp?str=m&content=' + mailvalue,'Mailload');
	}else{
	   	spanid.style.display='';
		spanid.innerHTML='<font color=red>���������ʽ����ȷ</font><br>';
	}
}
</SCRIPT>
<%

sqlstring="select * from UserDetail where u_id='"&session("u_sysid")&"'"
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
    <td height='30' align="center" ><strong>��Ʒ�۸�</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' ><!--#include file="../share/AgentPrice.asp"--></td>
  </tr>
</table>
<br />
<table width="100%" height="218" cellpadding="0" cellspacing="0"   bordercolor="#FFFFFF" id="AutoNumber3" style="border-collapse�� collapse">
                    <form name=regForm onSubmit="return checkReg()" action="success.asp" method=post>
                      <tr> 
                        <td height="175" width="550" valign="top"> <%= msg %> 
                          ��˵��:Ϊ���Ͽͻ�Ȩ�棬��˾���Ƽ����������޸ģ���Ҫ�޸ģ��봫��Ӫҵִ�ո�ӡ�������˴������֤��ӡ����028-86264041����ע����<font color="#FF0000">�޸��û�����</font>�� 
                          �� 
                          <table width="520" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#e3e3e3">
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right">�û�����</td>
                              <td height="30" colspan="3"> 
                                <input type=hidden value="u_modi" name=module>
                                &nbsp;<%=rs("u_name")%></td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> �����룺</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_password  type=password class="box" style="font-size: 12px"  value="" size=20>
                              </td>
                              <td width="77" height="30" align="right"> ȷ�������룺</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_password2  type=password class="box" style="font-size: 12px"  value="" size=20>
                              </td>
                            </tr>
                             <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> �������⣺</td>
                              <td width="152" height="30" valign="top">
                              <%
							  question=trim(rs("u_question")&"")
							  mylo=false
							  myqu=""
							  if isselfquestion(question) then 
							  	mylo=true
								myqu=question
							  end if
							  answer=rs("u_answer")
							  %>
                                <select id="question" name="question" class="text" title="���뱣������" onChange="doquestion(this.value)">
                               	  <%if not mylo and question<>"" then%><option value="<%=question%>" selected><%=question%></option><%end if%>
                                    <option value="">==��ѡ��һ������==</option>
                                    <option value="�ҾͶ��ĵ�һ��ѧУ�����ƣ�">�ҾͶ��ĵ�һ��ѧУ�����ƣ�</option>
                                    <option value="�ҵ�ѧ��(�򹤺�)��ʲô?">�ҵ�ѧ��(�򹤺�)��ʲô?</option>
                                    <option value="�Ҹ��׵�������">�Ҹ��׵�������</option>
                                    <option value="�Ҹ��׵�ְҵ��">�Ҹ��׵�ְҵ��</option>
                                    <option value="�ҵĳ������ǣ�">�ҵĳ������ǣ�</option>
                                    <option value="��ĸ�׵�������">��ĸ�׵�������</option>
                                    <option value="��ĸ�׵�ְҵ��">��ĸ�׵�ְҵ��</option>
                                    <option value="�ҳ��а����ε������ǣ�">�ҳ��а����ε������ǣ�</option>
                                    <option value="������˵����֣�">������˵����֣�</option>
                                    <option value="�Ұְֵ����գ�">�Ұְֵ����գ�</option>
                                    <option value="����������գ�">����������գ�</option>
                                    <option <%if mylo then response.write "selected"%> value="�ҵ��Զ�������">*�ҵ��Զ�������</option>
                               </select>
        <input id="myQuestion" name="myQuestion" type="text" class="inputbox" title="�Զ�������" <%if not mylo then%>style="display:none"<%end if%> maxlength="30" value="<%=myqu%>" />
                              </td>
                              <td width="77" height="30" align="right">����𰸣�</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name="answer"  type="text" class="box" style="font-size: 12px"  size=20 value="<%=answer%>">
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> ��ϵ�ˣ�</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_contract class="box" style="font-size: 9pt"  value="<%=rs("u_contract")%>"  size=20 >
                              </td>
                              <td width="77" height="30" align="right"> ��˾��</td>
                              <td width="200" height="30"> &nbsp; 
                                <%
								   if rs("u_company")="" or isnull(rs("u_company")) then
   	mycompany=rs("u_namecn")
   else
   	mycompany=rs("u_company")
   end if
if Session("priusername")="" then 
   Session("u_namecn")=Rs("u_namecn")
   Session("u_company")=rs("u_company")

   
%>
                                <input name=u_company class="box" style="font-size: 9pt"  value="<%=mycompany%>"  size=20 readonly>
                                <%
else
%>
                                <input name=u_company class="box" style="font-size: 9pt"  value="<%=mycompany%>"  size=20 >
                                <%end if%>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> ����(����)��</td>
                              <td width="152" height="30"> &nbsp; 
                                <input  name=u_namecn class="box" style="font-size: 12px" value="<%=rs("u_namecn")%>" size=20 <%if Session("priusername")="" then Response.write " ReadOnly"%>>
                              </td>
                              <td width="77" height="30" align="right"> ����(ƴ��)��</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name="u_nameen" type="text" class="box" style="font-size: 9pt" value="<%=rs("u_nameen")%>" size=20>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> ���ң�</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name="u_contry" class="box"  style="font-size: 12px" value="<%=rs("u_contry")%>" size="20" maxlength="2">
                              </td>
                              <td width="77" height="30" align="right"> ʡ�ݣ�</td>
                              <td width="200" height="30"> &nbsp; 
                                <select name=u_province size="1" class="box" style="font-size: 9pt">
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
                                </select>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> ���У�</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_city class="box" style="font-size: 12px" value="<%=rs("u_city")%>" size=20>
                              </td>
                              <td width="77" height="30" align="right"> �ʱࣺ</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_zipcode class="box" style="font-size: 12px" value="<%=rs("u_zipcode")%>" size=20  >
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> �绰��</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_telphone class="box" style="font-size: 12px"  value="<%=rs("u_telphone")%>" size=20>
                              </td>
                              <td width="77" height="30" align="right"> ���棺</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_fax class="box" style="font-size: 12px"  value="<%=rs("u_fax")%>" size=20  >
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> ��ַ��</td>
                              <td height="30" colspan="3"> &nbsp; 
                                <input name=u_address class="box" style="font-size: 12px" value="<%=rs("u_address")%>" size=40>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> �����ʼ���</td>
                              <td height="30" colspan="3"> &nbsp; 
							  <span id="Mailload" style="display:none"></span>
                                <input name=u_email class="box" style="font-size: 12px" value="<%=rs("u_email")%>" size=30><input type="button" value="�����ܷ�����ʼ�" onClick="sendMail()">
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> �ƶ��绰��</td>
                              <td height="30" colspan="3"> &nbsp; 
                                <input name=msn class="box" style="font-size: 12px" value="<%=rs("msn_msg")%>" size=30>
                                ��д�ֻ����Ա��յ�����֪ͨ��</td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> QQ�ţ�</td>
                              <td height="30" colspan="3"> &nbsp; 
                                <input name=qq class="box" style="font-size: 12px" value="<%=nnPws(rs("qq_msg"))%>" size=30>
                              </td>
                            </tr>
                          </table>
                          <br>
                        </td>
                      </tr>
                      <tr> 
                        <td height="25" width="520" valign="middle" bgcolor="#D9EEFD"> 
                          &nbsp;��������</td>
                      </tr>
                      <tr> 
                        <td height="5" width="100%" valign="top">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="45" width="100%" valign="top"> 
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#e3e3e3">
                            <tr bgcolor="#FFFFFF"> 
                              <td width="104" height="30" align="right"> ��Ч֤���ţ�</td>
                              <td height="30"> &nbsp; &nbsp; 
                                <input name=u_trade class="box"  style="font-size: 12px" value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" and Session("priusername")=""  then Response.write " readonly"%>>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="104" height="7" align="right" valign="middle"> 
                                ��Ϣ��Դ��</td>
                              <td height="7"> &nbsp; &nbsp;�����֪�����ǵ�վ�� --> <font color=red><%=rs("u_know_from")%></font> 
                                <input type="hidden" name="u_know_from" value="<%=rs("u_know_from")%>">
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="25" width="520" valign="middle" bgcolor="#D9EEFD"> 
                          &nbsp;IP����</td>
                      </tr>
                      <tr> 
                        <td height="5" width="100%" valign="top">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="5" width="100%" valign="top"> 
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#e3e3e3">
                            <tr bgcolor="#FFFFFF"> 
                              <%
ipFilter=rs("ipfilter")
allowIP=rs("allowIP")
rs.close
%>
                              <td width="116" height="30" align="right"> ����IP����</td>
                              <td width="29" height="30"> 
                                <div align="center">
                                  <input type="checkbox" name="ipfilter" value="yes" <%if ipfilter then Response.write " checked" %> onClick="if (this.checked) {this.form.allowIP.disabled=false;this.form.allowIP.focus();this.form.allowIP.style.background='#FFFFFF';} else {this.form.allowIP.disabled=true;this.form.allowIP.style.background='#E2E2E2';}">
                                </div>
                              </td>
                              <td width="442" height="30">ֻ����ͨ�������IP��ַ��¼��������<font color="#FF0000"><br>
                                ���ѣ������ʹ�ðκ���������̬ip)����������ã�</font></td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="116" height="62" align="right" valign="middle">IP��ַ�б�</td>
                              <td height="62" colspan="2">
                                <input type="text" name="allowIP" size="50" value="<%=allowIP%>" <% if not ipfilter then Response.write "style=""background-color: #E2E2E2""  disabled "%>>

                                <input type="button" name="Button" value="�ҵ�IP" onClick="this.form.allowIP.value='<%=Request("Remote_Addr")%>';" >
                                <br>
                                (���IP���ö��Ÿ���,֧��xxx.xxx.xxx.xxx/n����һ������)<br>
                                <br>
                                ��<br>
                                61.139.22.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ʾֻ��IP��ַ61.139.22.1�ſ��Ե�¼.<br>
                                61.139.22.1/24&nbsp;&nbsp;��ʾֻ��IP��ַ��61.139.22��ͷ�Ĳſɵ�¼.<br>
                                61.139.22.1/16&nbsp;&nbsp;��ʾֻ��IP��ַ��61.139��ͷ�Ĳſ��Ե�¼.<br>
                                61.139.22.1/8&nbsp;&nbsp;&nbsp;��ʾֻ��IP��ַ��61��ͷ�Ĳſ��Ե�¼.<br>
                                <br>
                                ����61.139.22.1���Ի�Ϊ����IP��ַ�������������ο��ϱߵ�����,һ��ͬһ������ADSL������IP��ַǰ16λ����ͬ�ģ�������xxx.xxx.xxx.xxx/16��ʾ</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="24" width="520" valign="middle" align="center" > 
                          <input name="ok2" type="submit" class="box" style="font-size: 12px" value="�� ��">
                          <input name="reset2" type="reset" class="box" style="font-size: 12px" value="�� ��">
                        </td>
                      </tr>
                    </form>
                  </table>
