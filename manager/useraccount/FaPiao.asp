<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
module=Requesta("module")
sql = "select u_usemoney+u_resumesum as totalsum ,* from userdetail where u_id=" & session("u_sysid") & ""
rs.open sql,conn,1,1
if rs.eof then url_return "��¼ʧЧ�������µ�¼",-1
Company=rs("u_company")
namecn=rs("u_namecn")
Telphone_u=rs("u_telphone")
Address=rs("u_address")
ZipCode=rs("u_zipcode")

availM=Ccur(rs("totalsum"))-Ccur(rs("u_invoice"))

if len(Company&"")=0 then Company=namecn
rs.close
conn.close

if clng(fapiao_cost_0)>0 then tp3price="(" & fapiao_cost_0 & "Ԫ)"
if clng(fapiao_cost_3)>0 then tp1price="(" & fapiao_cost_3 & "Ԫ)"
if clng(fapiao_cost_1)>0 then tp2price="(" & fapiao_cost_1 & "Ԫ)"
%>
<script language="javascript" src="/config/PopupCalendar.js"></script>

<script language=javascript>
function isDate(data,text){
var reg=/\b(((19|20)\d{2})-((0?[1-9])|(1[012]))-((0?[1-9])|([12]\d)|(3[01])))\b/
if (reg.exec(data.value)==null) {
	alert("��Ǹ��"+text+"�����ڸ�ʽ����,��ȷ�ĸ�ʽ��yyyy-MM-dd");
	//data.value=dateObj.getUTCFullYear()+"-"+dateObj.getUTCMonth()+"-"+dateObj.getUTCDay();
	dateObj=new Date();
	data.value="2003-01-30"
	data.focus();
	data.select();
	return false;
}
else{
	return true;
	}
}

function isGreat(number,text){
		if (parseFloat(number)>99999||parseFloat(number)<0){
			alert("��Ǹ���ύʧ�ܣ�["+text+"]��ֵ����ϵͳ��ʾ��Χ0-99999");
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
 var checkReg=/[a-zA-Z0-9]/;
 var countfp=<%=chk_ly_num(availM)%>;

 if (!checkNull(form.subject,'��Ʊ̧ͷ')) return false;
 if (form.subject.value.length<5) {alert('��������д��Ʊ̧ͷ.������д����������������д��������֯/����/��˾���ƣ������п����޷��յ���Ʊ');form.subject.focus();return false;}
// if (checkReg.test(form.subject.value)){alert("��Ʊ̧ͷ������дӢ�Ļ�����");return false;}
 if (!checkNull(form.fundamount,'��Ʊ���')) return false;
 if (!isDigital(form.fundamount,'��Ʊ���')) return false;
 if (!checkNull(form.purpose,'��Ʊ����')) return false;
 if (!checkNull(form.address,'�ʼĵ�ַ')) return false;
 if (!checkNull(form.postcode,'�ʱ�')) return false;
 if (!checkNull(form.receiver,'�ռ���')) return false;



var pcost0=<%=chk_ly_num(fapiao_cost_0)%>;
var	pcost1=<%=chk_ly_num(fapiao_cost_1)%>;
var	pcost2=<%=chk_ly_num(fapiao_cost_2)%>;
var	pcost3=<%=chk_ly_num(fapiao_cost_3)%>;
var fpfl=<%=chk_ly_num(fapiao_cost_feilv)%>;
var yf=0

var fpmoney=form.fundamount.value;

if(fpmoney>countfp)
{
alert("�������󣡳������Ʊ�ɿ���");
form.fundamount.focus();
return false;
}

var fpsxf=fpmoney*fpfl
 //����ȷ��
 var _sendtype=document.getElementsByName("sendtype");
 for(var i=0;i<_sendtype.length;i++)
{
	 if(_sendtype[i].checked)
	 {
		var _sendtypev=_sendtype[i].value;
	    switch(_sendtypev)
   ����{
����   case "0":
 ����   yf=pcost0
 ����    break
����   case "1":
����    yf=pcost1
����     break
����   default:
����    yf=0
����   }
	 }
}
	if(confirm("��ȷ���ύ���η�Ʊ������ ���ν��۳��ʼķ�"+yf.toFixed(2)+"Ԫ��������"+fpsxf.toFixed(2)+"Ԫ������"+(yf+fpsxf).toFixed(2)+"Ԫ��"))
	{return true;}else{return false;}

}


function calCost(form){
	var fmoney,pcost0,pcost1,pcost2,pcost3;
	fmoney=Number(form.fundamount.value);
	pcost0='<%=fapiao_cost_0%>';
	pcost1="<%=fapiao_cost_1%>";
	pcost2="<%=fapiao_cost_2%>";
	pcost3="<%=fapiao_cost_3%>";

	if (fmoney>=<%=fapiao_cost_leve%>){
		xA="<%=fapiao_cost_0%>";
		xB="<%=fapiao_cost_1%>";
		xC="0";
		xD="0";
	}else{
		xA=pcost0;
		xB=pcost1;
		xC=pcost2;
		xD=pcost3;
	}

	if (xA=="0")
		xA="���";
	else
		xA+="Ԫ";
	if (xB=="0")
		xB="���";
	else
		xB+="Ԫ";
	if (xC=="0")
		xC="����";
	else
		xC+="Ԫ";
	if (xD=="0")
		xD="���";
	else
		xD+="Ԫ";

	document.getElementById("pcost0").innerHTML="("+xA+")";
	document.getElementById("pcost1").innerHTML="("+xB+")";
//	document.getElementById("pcost2").innerHTML="("+xC+")";
	document.getElementById("pcost3").innerHTML="("+xD+")";
}


</script>

<HEAD>
<title>�û������̨-��Ʊ��ȡ</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li>��Ʊ��ȡ</li>
			 </ul>
		  </div>

		  <div class="manager-right-bg">
		          <script>
                 function ftypechange(v)
                 {

                 		if(v==1){
                 			$(".ptfp").hide(30)
                 			$("#zzfp").show(30)
                 		}else{
                 			$("#zzfp").hide(30)
                 			$(".ptfp").show(30)
                 		}
                 	}

                 	</script>
                 	  <form action="FaPiao_P.asp" method="post" onSubmit="return check(this);" name="form1">
                     <table class="manager-table">
					 <tr>
						<th colspan="2">��Ʊ��ȡ</th>
					 </tr>
                      <tr>
                        <td width="26%" height="35" align="right">��Ʊ���ͣ�</td>

                        <td align="left"><input name="ftype" type="radio" value="0" checked="checked" onclick="ftypechange(this.value)" /> ��ֵ˰��ͨ��Ʊ(С��ģ��˰��)  &nbsp;<input name="ftype" type="radio" value="1"  onclick="ftypechange(this.value)" />  ��ֵ˰ר�÷�Ʊ(һ����˰��)</td>
                      </tr>
                      <tr class="ptfp">
                      
                             <td width="26%" align="right" valign="center" class="tdbg">��Ʊ̧ͷ��</td>
                                <td width="74%" align="left" valign="center" class="tdbg">
                                <input  name="subject" size="20" maxlength="100" class="manager-input s-input" value="<%=Company%>">
                                  **<br>
                                  (�繫˾���ơ�ѧУ���ơ���֯������,��������������� </td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg"><span id="lianxi">��Ʊ��</span></td>
                                                            <td align="left" valign="center" class="tdbg"><input  class="manager-input s-input" size="28" name="fundamount" value="<%=availM%>" onChange="calCost(this.form)">
                                                            (�ɿ����:<%=availM%>Ԫ <%if chk_ly_num(fapiao_cost_feilv)>0 then%>,����Ʊ����Ϊ:<%=chk_ly_num(fapiao_cost_feilv)%><%end if%>)**</td>
                                                            </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" class="tdbg">��Ʊ���ݣ�<br>
                                                            (���𳬹�120����)</td>
                                                            <td align="left" valign="center" ><textarea  class="manager-textarea" name="purpose" cols="26" readonly>��������</textarea>
                                                            ** </td>
                                                            </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">�ռ�����ַ��</td>
                                                            <td align="left" valign="center" class="tdbg"><input class="manager-input s-input" class="form" size="50" name="address" value="<%=address%>">
                                                              **<br>
                                                            <font color="#FF0033">(�������д����[ʡ���ؽֵ�����]��������ַ����ϸ��ɲ����յ���Ʊ�ģ����ǲ������ؼģ�) </font></td>
                                                            </tr>
														 <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">ͳһ������ô��루����˰ʶ��ţ�:</td>
                                                            <td align="left" valign="center" class="tdbg"><input class="manager-input s-input" type="text" name="taxcode">
                                                           
��˾�û�������д</td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">�ռ���˾����</td>
                                                            <td align="left" valign="center" class="tdbg"><input class="manager-input s-input" type="text" name="receive_cp">
                                                            (������д)������д��ݵ���Һ���</td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">�������룺</td>
                                                            <td align="left" valign="center" class="tdbg"><input name="postcode" class="manager-input s-input" size="20" value="<%=zipcode%>">
                                                            ** </td>
                                                            </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">�ռ��ˣ�</td>
                                                            <td align="left" valign="center" class="tdbg"><input class="manager-input s-input"  class="form" class="manager-input s-input" name="receiver" size="20" value="<%=namecn%>">
                                                            ** </td>
                                                            </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">��ϵ�绰��</td>
                                                            <td align="left" valign="center" class="tdbg"><input class="manager-input s-input"  class="form" class="manager-input s-input" name="telephone" size="20" value="<%=Telphone_u%>">                                          </td>
                                                            </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">��ע��</td>
                                                            <td align="left" valign="center" class="tdbg"><input name="memo" class="manager-input s-input" type="text" id="memo" size="50"></td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td align="right" valign="center" class="tdbg">�ʼķ�ʽ:</td>
                                                            <td align="left" valign="center" class="tdbg">
                                    <label style="display:none"><input name="sendtype" type="radio" id="radio" value="0" disabled="disabled">�Һ�<span id="pcost0"></span></label>
                                    <label style="display:none"><input type="radio" name="sendtype" id="radio2" value="3" >ƽ��<span id="pcost3"></span></label>
                                    <label><input type="radio" name="sendtype" id="radio3" value="1" checked>���<span id="pcost1"></span></label>
                                    <!--,<input type="radio" name="sendtype" id="radio4" value="2">��ݵ���<span id="pcost2"></span>--></td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td colspan="2" align="center" class="tdbg">
                                                              <input type="submit" value=" �� �� ȷ �� " name="submit" class="manager-btn s-btn">
                                                              <input type="reset" value=" �� �� �� д " name="reset" class="manager-btn s-btn">                                          </td>
                                                          </tr>
                                                          <tr  class="ptfp">
                                                            <td colspan="2" class="tdbg">
                    ��ʾ�� ����������⣬����ѯ��˾���񲿡�</td>
                                                          </tr>
                                    
                      <tr  id="zzfp" style="display:none">
                        <td align="center" colspan=2 style="color:#F00; font-weight:bold; font-size:16px; line-height:300%">����ֵ˰ר�÷�Ʊ(һ����˰��)����ϵ����Ա</td>
                      </tr>
                    </table>

                 </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>