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
		alert("提示：\n\n密码至少6位");
		document.regForm.u_password.focus();
		return false;
	}
     if (document.regForm.u_password.value != document.regForm.u_password2.value ) {
		alert("提示：\n\n密码必须相同");
		document.regForm.u_password2.focus();
		return false;
	}

	if (document.regForm.u_namecn.value == ""){
		alert ("提示：\n\n必须输入中文名！");
		document.regForm.u_namecn.focus();
		return false;
	}
	if (document.regForm.u_nameen.value == ""){
		alert ("提示：\n\n必须输入英文名！");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") < 0 ){
		alert ("提示：\n\n英文名中必须有空个且空格不能是第一位和最后一位！");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") <= 1){
		alert ("提示：\n\n英文名中必须有空个且空格不能是第一位！");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_nameen.value.indexOf(" ") == document.regForm.u_nameen.value.length-1 ){
		alert ("提示：\n\n英文名中必须有空个且空格不能是最后一位！");
		document.regForm.u_nameen.focus();
		return false;
	}
	if (document.regForm.u_company.value == ""){
		alert ("提示：\n\n必须输入公司名称！");
		document.regForm.u_company.focus();
		return false;
	}
	if (document.regForm.u_contract.value == ""){
		alert ("提示：\n\n必须输入联系人！");
		document.regForm.u_contract.focus();
		return false;
	}
	if (document.regForm.u_contry.value == ""){
		alert ("提示：\n\n必须输入国家！");
		document.regForm.u_contry.focus();
		return false;
	}
	if (document.regForm.u_province.value == ""){
		alert ("提示：\n\n必须输入省份！");
		document.regForm.u_province.focus();
		return false;
	}
	if (document.regForm.u_city.value == ""){
		alert ("提示：\n\n必须输入城市！");
		document.regForm.u_city.focus();
		return false;
	}
	bString = "0123456789-*";
		for(i = 0; i < document.regForm.u_zipcode.value.length; i ++)
		{
			if (bString.indexOf(document.regForm.u_zipcode.value.substring(i,i+1))==-1)
			{
				alert('邮编 只能包含数字及-*');
				document.regForm.u_zipcode.focus();
				return false;
			}
		}
	if (document.regForm.u_address.value == ""){
		alert ("提示：\n\n必须输入地址！");
		document.regForm.u_address.focus();
		return false;
	}
	if (document.regForm.u_telphone.value == ""){
		alert ("提示：\n\n必须输入电话！");
		document.regForm.u_telphone.focus();
		return false;
	}



	bString = "0123456789,.+()/-&";
		for(i = 0; i < document.regForm.u_telphone.value.length; i ++)
		{
			if (bString.indexOf(document.regForm.u_telphone.value.substring(i,i+1))==-1)
			{
				alert('电话 只能包含数字和,.+()/-&');
				document.regForm.u_telphone.focus();
				return false;
			}
		}
     if (document.regForm.u_email.value.length==0) {
                alert("提示：\n\n请填写你的EMAIL地址");
				document.regForm.u_email.focus();
                return false;
             }

     else if ((document.regForm.u_email.value.indexOf("@")<0)||(document.regForm.u_email.value.indexOf("：")!=-1))
                {
                        alert("提示：\n\n您填写的EMAIL无效，请填写一个有效的EMAIL\n\n");
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
    <td height='30' align="center" ><strong>资料修改</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' > </td>
  </tr>
</table>
<br />
<table width="100%" height="218" cellpadding="0" cellspacing="0"   bordercolor="#FFFFFF" class="border" id="AutoNumber3" style="border-collapse： collapse">
<form name=regForm onSubmit="return checkReg()" action="success.asp" method=post>
                      <tr> 
                        
      <td height="175" valign="top" class="tdbg"> 
        <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="tdbg">
                      <tr> 
                        <td height="25" valign="middle" colspan="4" class="Title"> 
                          <strong>基本资料</strong></td>
    </tr>
                            <tr> 
                              <td align="right">用户名：</td>
                              <td colspan="3"> 
                                <input type=hidden value="u_modi" name=module>
                                &nbsp;<%=rs("u_name")%></td>
                            </tr>
                            <tr> 
                              <td align="right"> 新密码：</td>
                              <td> &nbsp; 
                                <input name=u_password  type=password  value="" size=20>                              </td>
                              <td align="right"> 确认新密码：</td>
                              <td> &nbsp; 
                                <input name=u_password2  type=password  value="" size=20>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 联系人：</td>
                              <td> &nbsp; 
                                <input name=u_contract  value="<%=rs("u_contract")%>"  size=20 >                              </td>
                              <td align="right"> 公司：</td>
                              <td> &nbsp; 
                                <input name=u_company  value="<%=rs("u_company")%>"  size=20>
                            </tr>
                            <tr> 
                              <td align="right"> 姓名(中文)：</td>
                              <td> &nbsp; 
                                <input  name=u_namecn value="<%=rs("u_namecn")%>" size=20>                              </td>
                              <td align="right"> 姓名(拼音)：</td>
                              <td> &nbsp; 
                                <input name="u_nameen" type="text" value="<%=rs("u_nameen")%>" size=20>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 国家：</td>
                              <td> &nbsp; 
                                <input name="u_contry" value="<%=rs("u_contry")%>" size="20" maxlength="2">                              </td>
                              <td align="right"> 省份：</td>
                              <td> &nbsp; 
                                <select name=u_province size="1">
                                  <option value="<%=rs("u_province")%>"><%=rs("u_province")%></option>
                                  <option value=Anhui>安徽</option>
                                  <option value=Macao>澳门</option>
                                  <option value=Beijing>北京</option>
                                  <option value=Chongqing>重庆</option>
                                  <option value=Fujian>福建</option>
                                  <option value=Gansu>甘肃</option>
                                  <option value=Guangdong>广东</option>
                                  <option value=Guangxi>广西</option>
                                  <option value=Guizhou>贵州</option>
                                  <option value=Hainan>海南</option>
                                  <option value=Hebei>河北</option>
                                  <option value=Heilongjiang>黑龙江</option>
                                  <option value=Henan>河南</option>
                                  <option value=Hongkong>香港</option>
                                  <option value=Hunan>湖南</option>
                                  <option value=Hubei>湖北</option>
                                  <option value=Jiangsu>江苏</option>
                                  <option value=Jiangxi>江西</option>
                                  <option value=Jilin>吉林</option>
                                  <option value=Liaoning>辽宁</option>
                                  <option value=Neimenggu>内蒙古</option>
                                  <option value=Ningxia>宁夏</option>
                                  <option value=Qinghai>青海</option>
                                  <option value=Sichuan>四川</option>
                                  <option value=Shandong>山东</option>
                                  <option value=Shan1xi>山西</option>
                                  <option value=Shan2xi>陕西</option>
                                  <option value=Shanghai>上海</option>
                                  <option value=Taiwan>台湾</option>
                                  <option value=Tianjin>天津</option>
                                  <option value=Xinjiang>新疆</option>
                                  <option value=Xizang>西藏</option>
                                  <option value=Yunnan>云南</option>
                                  <option value=Zhejiang>浙江</option>
                                  <option value=Others>其它</option>
                                </select>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 城市：</td>
                              <td> &nbsp; 
                                <input name=u_city value="<%=rs("u_city")%>" size=20>                              </td>
                              <td align="right"> 邮编：</td>
                              <td> &nbsp; 
                                <input name=u_zipcode value="<%=rs("u_zipcode")%>" size=20  >                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 电话：</td>
                              <td> &nbsp; 
                                <input name=u_telphone  value="<%=rs("u_telphone")%>" size=20>                              </td>
                              <td align="right"> 传真：</td>
                              <td> &nbsp; 
                                <input name=u_fax  value="<%=rs("u_fax")%>" size=20  >                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 地址：</td>
                              <td colspan="3"> &nbsp; 
                                <input name=u_address value="<%=rs("u_address")%>" size=40>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 电子邮件：</td>
                              <td colspan="3"> &nbsp; 
                                <input name=u_email value="<%=rs("u_email")%>" size=30>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> 移动电话：</td>
                              <td colspan="3"> &nbsp; 
                                <input name=msn value="<%=rs("msn_msg")%>" size=30>                              </td>
                            </tr>
                            <tr> 
                              <td align="right"> QQ号：</td>
                              <td colspan="3"> &nbsp; 
                                <input name=qq value="<%=rs("qq_msg")%>" size=30>                              </td>
                            </tr>
                          </table>                        </td>
    </tr>
                      <tr> 
                        <td height="25" valign="middle" class="Title"> 
                          &nbsp;<strong>其他资料</strong></td>
    </tr>
                      <tr> 
                        <td height="5" valign="top" class="tdbg"> 
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="104" height="30" align="right"> 有效证件号：</td>
                              <td height="30"> &nbsp; &nbsp; 
                                <input name=u_trade value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" then Response.write " readonly"%>>                              </td>
                            </tr>
                            <tr> 
                              <td width="104" height="62" align="right" valign="middle"> 
                                信息来源：</td>
                              <td height="62"> &nbsp; &nbsp;您如何知道我们的站点 --> <font color=red><%=rs("u_know_from")%></font> 
                                <input type="hidden" name="u_know_from" value="<%=rs("u_know_from")%>">                              </td>
                            </tr>
                          </table>                        </td>
    </tr>
                      <tr> 
                        <td height="45" align="center" valign="middle" class="tdbg" > 
                          <input name="ok2" type="submit" value="更 新">
                          <input name="reset2" type="reset" value="重 填">                        </td>
    </tr>
                    </form>
                  </table>
