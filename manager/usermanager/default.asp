<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Buffer=true
response.Charset="gb2312"
if requesta("str")="m" then
	mailvalue=trim(request("content"))
	if mailvalue<>"" then
		SendMail mailvalue,"测试邮件","您的邮箱能收到邮件!"
		response.write "<font color=blue>邮件已经发送,请进入你的邮箱查看能否收到</font>"
	else
	   response.write "<font color=red>失败</font>"
	end if
	
	response.end
end if
function isselfquestion(qu)
	if len(qu)="" then isselfquestion=false:exit function
	dim getstrs
	dim stray(10)
	stray(0)="我就读的第一所学校的名称？"
	stray(1)="是什么?我父亲的职业？"
	stray(2)="我的出生地是？"
	stray(3)="我母亲的职业？"
	stray(4)="我初中班主任的名字是？"
	stray(5)="我最爱的人的名字？"
	stray(6)="我爸爸的生日？"
	stray(7)="我妈妈的生日？"
	stray(8)="我父亲的姓名？"
	stray(9)="我母亲的姓名？"
	stray(10)="我的学号(或工号)是什么?"
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
	if(v=="我的自定义问题"){
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
	var ii=0;
	bString="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_!@#$%^*()";
	 while (ii<document.regForm.u_password.value.length)
	 {
		if (bString.indexOf(document.regForm.u_password.value.substring(ii,ii+1))==-1)
		{
			alert("\n\n密码必须是 a-z A-Z 0-9 之间的字母和数字组合或!@#$%^*()。");
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
	if (document.regForm.ipfilter.checked){

		if (document.regForm.allowIP.value==""){
		alert ("提示：\n\n请输入允许访问的IP列表！");
		document.regForm.allowIP.focus();
		return false;

		}
	iplist=document.regForm.allowIP.value.split(",");
	 for (j=0;j<iplist.length;j++){
	 	 ipMode=/(^\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}$)|(^\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}\/\d{1,2}$)/;
		 if (!ipMode.test(iplist[j])) {alert('抱歉，您的IP地址列表格式不正确，正确的是xxx.xxx.xxx.xxx或xxx.xxx.xxx.xxx/n');document.regForm.allowIP.focus();return false;}
		 ipRang=iplist[j].split(".");
		 for (k=0;k<ipRang.length;k++){
		 		slashPos=ipRang[k].indexOf("/");
		 		if (slashPos==-1){
						if (parseInt(ipRang[k])<1||parseInt(ipRang[k])>255){alert('IP地址格式不正确，每一段不能大于255');document.regForm.allowIP.focus();return false;}
					}
				else{
						lastR=parseInt(ipRang[k].substring(0,slashPos));
						if (lastR>255) {alert('IP地址格式不正确，每一段不能大于255');document.regForm.allowIP.focus();return false;}
						netNo=parseInt(ipRang[k].substring(slashPos+1))
						if (netNo<2||netNo>31){alert('抱歉，IP地址中子网号不能超过31,并需大于1');document.regForm.allowIP.focus();return false;}
					}
		 }
	 }

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
function sendMail(){
	var mailvalue=document.regForm.u_email.value;
	var spanid=document.getElementById('Mailload');
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
	
	if (filter.test(mailvalue)){
		spanid.style.display='';
		spanid.innerHTML='<img src="/images/load.gif" border="0" id="loadimg" />稍候..<br>';
		makeRequest('default.asp?str=m&content=' + mailvalue,'Mailload');
	}else{
	   	spanid.style.display='';
		spanid.innerHTML='<font color=red>您的邮箱格式不正确</font><br>';
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
    <td height='30' align="center" ><strong>产品价格</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' ><!--#include file="../share/AgentPrice.asp"--></td>
  </tr>
</table>
<br />
<table width="100%" height="218" cellpadding="0" cellspacing="0"   bordercolor="#FFFFFF" id="AutoNumber3" style="border-collapse： collapse">
                    <form name=regForm onSubmit="return checkReg()" action="success.asp" method=post>
                      <tr> 
                        <td height="175" width="550" valign="top"> <%= msg %> 
                          　说明:为保障客户权益，公司名称及姓名不可修改，若要修改，请传真营业执照复印件，个人传真身份证复印件到028-86264041，并注明“<font color="#FF0000">修改用户资料</font>” 
                          。 
                          <table width="520" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#e3e3e3">
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right">用户名：</td>
                              <td height="30" colspan="3"> 
                                <input type=hidden value="u_modi" name=module>
                                &nbsp;<%=rs("u_name")%></td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 新密码：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_password  type=password class="box" style="font-size: 12px"  value="" size=20>
                              </td>
                              <td width="77" height="30" align="right"> 确认新密码：</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_password2  type=password class="box" style="font-size: 12px"  value="" size=20>
                              </td>
                            </tr>
                             <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 机密问题：</td>
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
                                <select id="question" name="question" class="text" title="密码保护问题" onChange="doquestion(this.value)">
                               	  <%if not mylo and question<>"" then%><option value="<%=question%>" selected><%=question%></option><%end if%>
                                    <option value="">==请选择一个问题==</option>
                                    <option value="我就读的第一所学校的名称？">我就读的第一所学校的名称？</option>
                                    <option value="我的学号(或工号)是什么?">我的学号(或工号)是什么?</option>
                                    <option value="我父亲的姓名？">我父亲的姓名？</option>
                                    <option value="我父亲的职业？">我父亲的职业？</option>
                                    <option value="我的出生地是？">我的出生地是？</option>
                                    <option value="我母亲的姓名？">我母亲的姓名？</option>
                                    <option value="我母亲的职业？">我母亲的职业？</option>
                                    <option value="我初中班主任的名字是？">我初中班主任的名字是？</option>
                                    <option value="我最爱的人的名字？">我最爱的人的名字？</option>
                                    <option value="我爸爸的生日？">我爸爸的生日？</option>
                                    <option value="我妈妈的生日？">我妈妈的生日？</option>
                                    <option <%if mylo then response.write "selected"%> value="我的自定义问题">*我的自定义问题</option>
                               </select>
        <input id="myQuestion" name="myQuestion" type="text" class="inputbox" title="自定义问题" <%if not mylo then%>style="display:none"<%end if%> maxlength="30" value="<%=myqu%>" />
                              </td>
                              <td width="77" height="30" align="right">问题答案：</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name="answer"  type="text" class="box" style="font-size: 12px"  size=20 value="<%=answer%>">
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 联系人：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_contract class="box" style="font-size: 9pt"  value="<%=rs("u_contract")%>"  size=20 >
                              </td>
                              <td width="77" height="30" align="right"> 公司：</td>
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
                              <td width="86" height="30" align="right"> 姓名(中文)：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input  name=u_namecn class="box" style="font-size: 12px" value="<%=rs("u_namecn")%>" size=20 <%if Session("priusername")="" then Response.write " ReadOnly"%>>
                              </td>
                              <td width="77" height="30" align="right"> 姓名(拼音)：</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name="u_nameen" type="text" class="box" style="font-size: 9pt" value="<%=rs("u_nameen")%>" size=20>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 国家：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name="u_contry" class="box"  style="font-size: 12px" value="<%=rs("u_contry")%>" size="20" maxlength="2">
                              </td>
                              <td width="77" height="30" align="right"> 省份：</td>
                              <td width="200" height="30"> &nbsp; 
                                <select name=u_province size="1" class="box" style="font-size: 9pt">
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
                                </select>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 城市：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_city class="box" style="font-size: 12px" value="<%=rs("u_city")%>" size=20>
                              </td>
                              <td width="77" height="30" align="right"> 邮编：</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_zipcode class="box" style="font-size: 12px" value="<%=rs("u_zipcode")%>" size=20  >
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 电话：</td>
                              <td width="152" height="30"> &nbsp; 
                                <input name=u_telphone class="box" style="font-size: 12px"  value="<%=rs("u_telphone")%>" size=20>
                              </td>
                              <td width="77" height="30" align="right"> 传真：</td>
                              <td width="200" height="30"> &nbsp; 
                                <input name=u_fax class="box" style="font-size: 12px"  value="<%=rs("u_fax")%>" size=20  >
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 地址：</td>
                              <td height="30" colspan="3"> &nbsp; 
                                <input name=u_address class="box" style="font-size: 12px" value="<%=rs("u_address")%>" size=40>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 电子邮件：</td>
                              <td height="30" colspan="3"> &nbsp; 
							  <span id="Mailload" style="display:none"></span>
                                <input name=u_email class="box" style="font-size: 12px" value="<%=rs("u_email")%>" size=30><input type="button" value="测试能否接收邮件" onClick="sendMail()">
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> 移动电话：</td>
                              <td height="30" colspan="3"> &nbsp; 
                                <input name=msn class="box" style="font-size: 12px" value="<%=rs("msn_msg")%>" size=30>
                                填写手机号以便收到续费通知。</td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="86" height="30" align="right"> QQ号：</td>
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
                          &nbsp;其他资料</td>
                      </tr>
                      <tr> 
                        <td height="5" width="100%" valign="top">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="45" width="100%" valign="top"> 
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#e3e3e3">
                            <tr bgcolor="#FFFFFF"> 
                              <td width="104" height="30" align="right"> 有效证件号：</td>
                              <td height="30"> &nbsp; &nbsp; 
                                <input name=u_trade class="box"  style="font-size: 12px" value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" and Session("priusername")=""  then Response.write " readonly"%>>
                              </td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="104" height="7" align="right" valign="middle"> 
                                信息来源：</td>
                              <td height="7"> &nbsp; &nbsp;您如何知道我们的站点 --> <font color=red><%=rs("u_know_from")%></font> 
                                <input type="hidden" name="u_know_from" value="<%=rs("u_know_from")%>">
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="25" width="520" valign="middle" bgcolor="#D9EEFD"> 
                          &nbsp;IP过滤</td>
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
                              <td width="116" height="30" align="right"> 启用IP过滤</td>
                              <td width="29" height="30"> 
                                <div align="center">
                                  <input type="checkbox" name="ipfilter" value="yes" <%if ipfilter then Response.write " checked" %> onClick="if (this.checked) {this.form.allowIP.disabled=false;this.form.allowIP.focus();this.form.allowIP.style.background='#FFFFFF';} else {this.form.allowIP.disabled=true;this.form.allowIP.style.background='#E2E2E2';}">
                                </div>
                              </td>
                              <td width="442" height="30">只允许通过下面的IP地址登录管理中心<font color="#FF0000"><br>
                                提醒：如果您使用拔号上网（动态ip)，请谨慎设置！</font></td>
                            </tr>
                            <tr bgcolor="#FFFFFF"> 
                              <td width="116" height="62" align="right" valign="middle">IP地址列表：</td>
                              <td height="62" colspan="2">
                                <input type="text" name="allowIP" size="50" value="<%=allowIP%>" <% if not ipfilter then Response.write "style=""background-color: #E2E2E2""  disabled "%>>

                                <input type="button" name="Button" value="我的IP" onClick="this.form.allowIP.value='<%=Request("Remote_Addr")%>';" >
                                <br>
                                (多个IP请用逗号隔开,支持xxx.xxx.xxx.xxx/n代表一个网段)<br>
                                <br>
                                例<br>
                                61.139.22.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;表示只有IP地址61.139.22.1才可以登录.<br>
                                61.139.22.1/24&nbsp;&nbsp;表示只有IP地址以61.139.22开头的才可登录.<br>
                                61.139.22.1/16&nbsp;&nbsp;表示只有IP地址以61.139开头的才可以登录.<br>
                                61.139.22.1/8&nbsp;&nbsp;&nbsp;表示只有IP地址以61开头的才可以登录.<br>
                                <br>
                                其中61.139.22.1可以换为您的IP地址，后面的数字请参考上边的例子,一般同一个城市ADSL上网的IP地址前16位是相同的，即可用xxx.xxx.xxx.xxx/16表示</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="24" width="520" valign="middle" align="center" > 
                          <input name="ok2" type="submit" class="box" style="font-size: 12px" value="更 新">
                          <input name="reset2" type="reset" class="box" style="font-size: 12px" value="重 填">
                        </td>
                      </tr>
                    </form>
                  </table>
