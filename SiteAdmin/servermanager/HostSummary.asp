<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<%
Check_is_Master(6)
conn.open conStr
id=Trim(Requesta("id"))
if not isNumeric(id) then url_return "ID������",-1
if Requesta("Act")="ERASE" then
	Sql="select [Start] from HostRental where id=" & id
	rs.open sql,conn,1,1
	if rs.eof then url_return "��Ǹ,��¼������",-1
	isOkay=Rs("Start")
	Rs.close
	if isOkay then
		if left(session("u_type"),1)<>"1" then
			url_return "Ȩ�޲���",-1
		end if
	end if

		sql="select AllocateIP  from HostRental where id="&id
		set d_rs=Server.CreateObject("adodb.recordset")
		d_rs.open sql,conn,1,3
		do while not d_rs.eof 
       call Add_Event_logs(session("user_name"),3,d_rs("AllocateIP"),"ɾ��Server����")
		conn.execute("delete from ServerActiolog where serverid="&id)
        d_rs.delete()
		d_rs.movenext
		loop
		d_rs.close
		set d_rs=nothing
		conn.close
		'conn.Execute ( "Delete from HostRental Where id=" & id )
		'conn.execute("delete from ServerActiolog where serverid="&id)
	Response.write "<script language=javascript>alert('ɾ���ɹ�');location.href='default.asp';</script>"
	Response.end
end if
Sql="Select * from HostRental where id=" & id
Rs.open Sql,conn,1,1
if Rs.eof then
	Rs.close
	url_return "δ�ҵ��˷�����",-1
end if

if Rs("Start") then
	if DateDiff("d",Now(),DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime"))))<0 then
		Status="<font color=red>�ѹ���</font>"
	else
		ExpireTime=DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime")))
		if DateDiff("d",Now(),ExpireTime)<0 then
			Status="<font color=Green>��Ƿ��</font>"
		else
			Status="����"
		end if
	end if
else
	Status="<font color=blue>δ��ͨ</font>"
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�� �� �� �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">������/VPS����</a> | <a href="ServerListnote.asp">�鿴�¶���</a> | <a href="ServerWarn.asp">�鿴���ڶ���</a></td>
  </tr>
</table>
      <br />

<script language=javascript>
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
function freesub()
{
    if(document.form1.Submit4.value=='�� ͨ �� ��')
	{
	    if(document.form1.MoneyPerMonth.value=='' || document.form1.MoneyPerMonth.value==0)
		{
		   alert('����Ѳ���Ϊ0');
		   return false;
		}
		else
		{
	   		if (confirm('��ͨ���ý����۳��κη���,�Ƿ�ͨ?')){
				document.form1.zxws.value="freehost";
				document.form1.submit();
				return true;
			}else{return false;}
		}
	}
}

function checkForm(form){
	if (!checkNull(form.Name,"��ϵ��")) return false;
	if (!checkNull(form.Telephone,"�绰")) return false;
	if (!checkNull(form.Email,"Email��ַ")) return false;
	if (!checkNull(form.Zip,"�ʱ�")) return false;
	if (!checkNull(form.Address,"��ַ")) return false;

	if (!checkNull(form.CPU,"������������")) return false;
	if (!checkNull(form.HardDisk,"������Ӳ��")) return false;
	if (!checkNull(form.Memory,"�������ڴ�")) return false;

	if (!isDate(form.StartTime,"��ͨ����")) return false;
	if (!isIPAddress(form.AllocateIP,"����ɣ�")) return false;

	if (!checkNull(form.RadomPass,"����")) return false;
	if (isNaN(parseInt(form.MoneyPerMonth.value))) {
			alert('�������¸����');
			return false;
			}
	if (parseInt(form.MoneyPerMonth.value)<=0){
			alert('�¸������������');
			return false;
	}

//	if (form.Submit.value=='�� ʽ �� ͨ'){
//			form.zxws.value="";
//			if (confirm('�Ƿ�۳�Ѻ��?')){
//			
//				form.deposit.value='yesneed';
//			}
//			else{form.deposit.value='notneed';}
//	}

	if (form.Submit.value=='�� ʽ �� ͨ'){

		if(form.RadomPass.value=="")
		{
			alert("���������룬��������ͨ��ʹ�ô�����Ϊ��ʼ����!");
			form.RadomPass.focus();
			return false;
		}
	
	}
	return true;

}

function Scatter(form,id){
	if (form.Identify[id].checked)
		{
		for (i=0;i<id;i++)
			form.Identify[i].checked=true;
			form.AlreadyPay.value=id+1;
		}
	else{
		for (i=id;i<form.Identify.length;i++)
			form.Identify[i].checked=false;
			form.AlreadyPay.value=id;
		}
	return ;
}


</script>

<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr valign="top"> 
    <td > <span class="fontSize"></span> 
      <form name=form1 method="post" action="SaveHost.asp" onSubmit="return checkForm(this);">
        <fieldset class="border">
        <legend>��ϵ����Ϣ</legend> 
        <table width="100%" border="0" cellpadding="2" cellspacing="0" class="tdbg">
          <tr> 
            <td height="124"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="4" style="border-color: #999999 #9C9A9C #9C9A9C; border-style: dotted; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px">
                <tr> 
                  <td width="16%" class="dotline">��˾���ƣ�</td>
                  <td class="dotline"> 
                    <input type="text" name="Company" maxlength="255" size="25" value="<%=Rs("Company")%>">                  </td>
                  <td width="54%" colspan="2" rowspan="10" valign="top" class="dotline">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">��ϵ��:</td>
                  <td width="30%" class="dotline"> 
                    <input type="text" name="Name" maxlength="50" size="15" value="<%=Rs("Name")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">Email:</td>
                  <td width="30%" class="dotline"> 
                    <input type="text" name="Email" maxlength="100" size="15" value="<%=Rs("Email")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">�ֻ�:</td>
                  <td width="30%" class="dotline"> 
                    <input type="text" name="Fax" maxlength="100" size="15" value="<%=Rs("Fax")%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">��ַ��</td>
                  <td class="dotline"> 
                    <input type="text" name="Address" maxlength="100" size="25" value="<%=Rs("Address")%>">
                    * <a href="ServerList.asp"></a></td>
                </tr>
                <tr>
                  <td class="dotline">�û�:</td>
                  <td class="dotline"><input type="text" name="u_name" maxlength="50" size="15" value="<%=Rs("u_name")%>"></td>
                </tr>
                <tr>
                  <td class="dotline">�绰:</td>
                  <td class="dotline"><input type="text" name="Telephone" maxlength="50" size="15" value="<%=Rs("Telephone")%>"></td>
                </tr>
                <tr>
                  <td class="dotline">QQ:</td>
                  <td class="dotline"><input type="text" name="QQ" maxlength="50" size="15" value="<%=Rs("QQ")%>">
                    <%
		    if Rs("qq")<>"" then
		%>
                    <a target=blank href=http://wpa.qq.com/msgrd?V=1&Uin=<%= Rs("qq")%>&Site=.com&Menu=yes><img border="0" SRC=http://wpa.qq.com/pa?p=1:<%=Rs("qq")%>:4 alt="���������Ϣ���Է�"> 
                    <%=Rs("qq")%></a> 
                    <%
		    end if
		    %>
                  </td>
                </tr>
                <tr>
                  <td class="dotline">�ʱ�:</td>
                  <td class="dotline"><input type="text" name="Zip" maxlength="6" size="6" value="<%=Rs("Zip")%>">
* </td>
                </tr>
                <tr>
                  <td class="dotline">����:</td>
                  <td class="dotline"><%=getroomname_(rs("serverroom"),"","")%></td>
                </tr>
              </table>            </td>
          </tr>
        </table>
        </fieldset> 
        <br />
        <fieldset class="border"><legend>�����������Ϣ <font color="#FF0000">������Ŀֻ�й���Ա���Խ����޸�</font></legend> 
        <table width="100%" border="0" cellpadding="2" cellspacing="0" class="tdbg">
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="4" style="border-color: #999999 #9C9A9C #9C9A9C; border-style: dotted; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px">
                <tr> 
                  <td width="16%" class="dotline">��������:</td>
                  <td class="dotline" width="37%"> 
                    <input type="text" name="HostID" maxlength="100" size="15" value="<%=Rs("HostID")%>">                  </td>
                  <td class="dotline" width="14%">����ϵͳ:</td>
                  <td class="dotline" width="33%"><%=Rs("OS")%></td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">������;:</td>
                  <td  class="dotline"> 
                    <input type="text" name="Apply" maxlength="100" size="15" value="<%=Rs("Apply")%>">&nbsp;                  </td>
                    <td>����ʱ��:</td>
                    <td><span class="dotline">
                      <input type="text" name="preday" maxlength="100" size="15" value="<%if isnull(Rs("preday")) Or Rs("preday")="" then response.Write(0) 		  else		response.Write(clng(Rs("preday")))	  end if%>"		 >
                    ��</span></td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">CPU:</td>
                  <td width="37%" class="dotline"> 
                    <input type="text" name="CPU" maxlength="100" size="15" value="<%=Rs("CPU")%>">
                    * </td>
                  <td width="14%" class="dotline">Ӳ��:</td>
                  <td width="33%" class="dotline"> 
                    <input type="text" name="HardDisk" maxlength="100" size="15" value="<%=Rs("HardDisk")%>">
                    * </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">�ڴ�:</td>
                  <td class="dotline" width="37%"> 
                    <input type="text" name="Memory" maxlength="100" size="15" value="<%=Rs("Memory")%>">
                    * </td>
                  <td class="dotline" width="14%">����:</td>
                  <td class="dotline" width="33%"> 
                    <input type="text" name="MainBoard" maxlength="100" size="15" value="<%=Rs("MainBoard")%>">                  </td>
                </tr>
                <tr>
                  <td class="dotline">����:</td>
                  <td colspan="3" class="dotline"><input type="text" name="flux" maxlength="100" size="15" value="<%=Rs("flux")%>">
                    *</td>
                </tr>
                <tr>
                  <td width="16%" class="dotline"></td>
                  <td colspan="3" class="dotline">
                    <%=Rs("weihulist")%>                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">��ע:</td>
                  <td colspan="3" class="dotline"> 
                    <textarea name="Memo" rows="6" cols="50"><%=Rs("Memo")%></textarea>                  </td>
                </tr>
              </table>            </td>
          </tr>
        </table>
        </fieldset> <br>
        <fieldset class="border"><legend>����ѡ��</legend>
         
        <table width="100%" border="0" cellpadding="2" cellspacing="0" class="tdbg">
          <tr> 
            <td height="116"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="4" style="border-color: #999999 #9C9A9C #9C9A9C; border-style: dotted; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px">
                <tr> 
                  <td width="16%" class="dotline" height="23">����״̬��</td>
                  <td class="dotline" height="23"><b><%=Status%></b></td>
                  <td class="dotline" height="23">����ѣ�</td>
                  <td class="dotline" height="23"> 
                    <input type="text" name="MoneyPerMonth" maxlength="6" size="4" value="<%=Rs("MoneyPerMonth")%>" onBlur="calMoney(this.form,'m');">
                    (ÿ�� 
                    <input type="text" name="YearTotal" maxlength="6" size="5" value="<%=Rs("MoneyPerMonth")*12%>" onBlur="calMoney(this.form,'y');">
                    Ԫ,ÿ��
                    <input type="text" name="QuarterTotal" maxlength="6" size="5" value="<%=Ccur(Rs("MoneyPerMonth")*3)%>" onBlur="calMoney(this.form,'q');">
                    Ԫ) </td>
                  <script language=javascript>
function calMoney(form,selector){
	switch(selector){
		case 'm':
			form.YearTotal.value=parseInt(form.MoneyPerMonth.value)*12;
			form.QuarterTotal.value=parseInt(form.MoneyPerMonth.value)*3;
			break;
		case 'y':
			form.MoneyPerMonth.value=parseInt(form.YearTotal.value)/12;
			form.QuarterTotal.value=parseInt(form.YearTotal.value)/4;
			break;
		case 'q':
			form.MoneyPerMonth.value=parseInt(form.QuarterTotal.value)/3;
			form.YearTotal.value=parseInt(form.QuarterTotal.value)*4;
			break;
	}
	return ;
}


</script>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">���ѷ�ʽ:</td>
                  <td width="34%" class="dotline"> 
                    <%
if Rs("PayMethod")=0 then
	Response.write "���¸�"
elseif Rs("PayMethod")=1 then
	Response.write "���긶"
elseif Rs("PayMethod")=2 then
	Response.write "����"
end if
%>
                    <font color="#0000FF">ѡ�񸶷ѷ�ʽ</font>: 
                    <select name="PayMethod">
					<option value="0" <%if trim(Rs("PayMethod"))=0 then response.write "selected"%> >���¸�</option>
					<option value="2" <%if trim(Rs("PayMethod"))=2 then response.write "selected"%>>������</option>
					<option value="1" <%if trim(Rs("PayMethod"))=1 then response.write "selected"%>>���긶</option>
                    <option value="3" <%if trim(Rs("PayMethod"))=3 then response.write "selected"%>>���긶</option>
                    
				  </select>               </td>
                  <td width="15%" class="dotline">��ͨʱ��:</td>
                  <td width="35%" class="dotline"> 
                    <input type="text" name="StartTime" maxlength="100" size="15" value="<%
if Rs("Start") then
	Response.write formatDateTime(Rs("StartTime"),2)
else
	Response.write formatDateTime(Now(),2)
end if
%>"></td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">��������:</td>
                  <td width="34%" class="dotline">
                    <input name="BuyYear" type=text value="<%=Rs("Years")%>" size="2" maxlength="2">                  </td>
                  <td width="15%" class="dotline">����ʱ��:</td>
                  <td width="35%" class="dotline">
                    <%
		  
if isnull(Rs("preday")) Or Rs("preday")="" then 
		  preday=0
		  else
		  preday=clng(Rs("preday"))
		  end if
		  
					
if Rs("Start") then
	ExpireTime=DateAdd("m",Rs("AlreadyPay"),Rs("StartTime"))
	Response.write formatDateTime(ExpireTime,2) & "/" & formatDateTime(DateAdd("d",preday,DateAdd("m",rs("alreadypay"),rs("starttime"))),2)
else
	Response.write "&nbsp;"
end if
%>                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">�������:</td>
                  <td colspan="3" class="dotline"> 
                    <table width="65%" border="0" cellspacing="0" cellpadding="2">
                      <tr align="center"> 
                        <%
color1="#99CCFF"
color2="#CCCCCC"
color3="#FF0000"

if Rs("Start") then
 StartTime=Rs("StartTime")
	for i=0 to (12*Rs("Years"))-1
		TempVar=DateAdd("m",i,StartTime)
			if DateDiff("m",TempVar,Now)>=0 then
				color=color1
			else


				color=color2
			end if
			Response.write "<td bgcolor=" & color &">" & Month(TempVar) &"</td>"
	next
end if
%>
                      </tr>
                      <tr align="center"> 
                        <%
	for j=1 to Rs("Years")*12
%>
                        <td <%
	if Rs("Start") then
		if DateDiff("m",DateAdd("m",j-1,Rs("StartTime")),now)=0 then	Response.write " bgcolor=RED"
	end if
%>> 
                          <input type="checkbox" name="Identify" <% if j<=Rs("AlreadyPay") then Response.write " checked"%> onClick="Scatter(this.form,<%=j-1%>)">                        </td>
                        <%
	next
%>
                      </tr>
                      <tr align="center"> 
                        <%
	for k=1 to Rs("Years")*12
		if k<=Rs("AlreadyPay") then
			color=color1
		else
			color=color2
		end if
				Response.write " <td bgcolor=" & color & ">" & k & "</td>"
	next
%>
                      </tr>
                    </table>                  </td>
                </tr>
                <tr> 
                  <td width="16%" class="dotline">����IP:</td>
                  <td width="34%" class="dotline"> 
                    <input type=text name="AllocateIP" value="<%=Rs("AllocateIP")%>"> *���ֹ�����                  </td>
                  <td width="15%" class="dotline">&nbsp;</td>
                  <td width="35%" class="dotline">&nbsp;</td>
                </tr>
                <tr>
                  <td width="16%" class="dotline">��������:</td>
                  <td width="34%" class="dotline">
                    <select name="hosttype">
                      <option value="0" <%if rs("hosttype")=0 then Response.write " selected"%>>��������</option>
                      <option value="1" <%if rs("hosttype")=1 then Response.write " selected"%>>VPS����</option>
                      <option value="2" <%if rs("hosttype")=2 then Response.write " selected"%>>�����й�</option>
                    </select>                  </td>
                  <td width="15%" class="dotline"><label></label></td>
                  <td width="35%" class="dotline">���룺
                    <label>
                    <input name="RadomPass" type="text" id="RadomPass" size="8" value="<%=rs("RamdomPass")%>"> *���ֹ�����
                  </label>
                 </td>
                </tr>
              </table>            </td>
          </tr>
        </table>
        </fieldset> 
        <div align="center">
<%
if Rs("Start") then
	Message="�� �� �� ��"
else
	Message="�� ʽ �� ͨ"
	Message1="�� ͨ �� ��"
    submitstrs="<input type='button' name='Submit4' value='"& Message1 &"' onclick='return freesub()'>"
end if
%>
    	  <input type="hidden" name="zxws" vlaue="">
		  <input type="hidden" name="AlreadyPay" value="<%=Rs("AlreadyPay")%>">
          <input type="submit" name="Submit" value="<%=Message%>">
          <input type="button" name="Submit2" value="ɾ �� �� ¼" onClick="if (confirm('��ȷ��ɾ���˼�¼?')){window.location.href='HostSummary.asp?id=<%=id%>&Act=ERASE';}">
          <%=submitstrs%>
		  <input type="hidden" name="id" value="<%=id%>">
          <%
if not Rs("Start") then Response.write "<input type=Hidden name=""Act"" value=""Start"">"
	%>
          <input type="hidden" name="deposit" value="notneed">
          <br>
        </div>
        <hr noshade size="1" />
      </form>
</td>
  </tr>
</table>
</body>
</html>
<%
Rs.close
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
