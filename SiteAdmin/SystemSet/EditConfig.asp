<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<%
response.charset="gb2312"
Check_Is_Master(1)
conn.open constr
If requesta("Act")="checksendmail" Then
	msg="δ֪����!"
	mail=requesta("mail")
	If InStr(mail,"@")=0 Then
		msg="��¼����ȷ�����ַ"
	else
		If sendMail(mail,"�����ʼ������Ƿ�ɹ�","�����ʼ������Ƿ�ɹ�") Then
			msg="�ʼ����ͳɹ�!"
		Else
			msg="�ʼ�����ʧ��!"
		End if
	End if
	die echojson("200",msg,"")
End if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script src="/jscripts/jq.js"></script>

<style type="text/css">
<!--
.STYLE4 {color: #0000FF}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>ϵ ͳ �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
      <br />
<!--Body Start-->

<%



Set fso = Server.CreateObject(objName_FSO)
module=Request("module")
set file=fso.opentextfile(server.mappath("/config/const.asp"),1)
MB=file.readall
file.close 
 
set file = nothing
splitAll=split(MB,VbCrLf)

Act=requesta("Act")
if Act<>"" then
	Set rea = New RegExp
	rea.IgnoreCase=true
     msgalert="�޸ĳɹ���"

	for each variables_name in request.form
	  isadd=true 
		rea.Pattern="(" & variables_name & ")\s*=\s*""([^'""\n\r]*)"""
		RequestStr=trim(request.Form(variables_name))
		
		RequestStr=replace(RequestStr,chr(34),"")
		RequestStr=replace(RequestStr,"<","&lt;")
		RequestStr=replace(RequestStr,">","&gt;")
		RequestStr=replace(RequestStr,"$","$$")
	

		'����Ƿ����ϼ�����Ʊ
		if trim(variables_name)=trim("fapiao_api") then
		   strbool=chk_fapiao_ok()
		    	
			'response.Write(RequestStr)
			'response.End()	
			if strbool=False and ucase(RequestStr)=ucase("True") then
	 	msgalert="���������Ƿ����ϼ�ע�����ṩ��Ʊ�޸�ʧ�ܣ�������ϵ������������ͨ�ù��ܣ�"    
		     RequestStr=False
              end if
			 ' RequestStr=strbool
		
		end if
		
		if trim(variables_name)=trim("webmanagespwd") then
		 
		  if trim(requesta("webmanagespwd"))<>""  then
			   companynameurl=trim(requesta("companynameurl"))
			   company_Name=trim(requesta("company_Name"))
			   webmanagespwd=trim(requesta("webmanagespwd"))
			   if companynameurl="" or company_Name="" then
			   isadd=false
			   call url_return("��վ��ַ����վ����Ϊ�ղ��ܲ���!",-1)
			   end if
			   webmanagespwdmd5=md5_16("west263!~@"&webmanagespwd&"west263!~@o;asdfOqwerJ"&webmanagesrepwd)
			   RequestStr=webmanagespwdmd5
  		  else
		   isadd=false
 
		  end if
		end if
		
		
if isadd then
		if rea.test(MB) then
			if variables_name="manager_url" And RequestStr<>"http://www.myhostadmin.net/" then
				othermsg = " ,������������ַ���Զ����"
				RequestStr = "http://www.myhostadmin.net/"
			end if
			MB=rea.replace(MB,"$1=""" & RequestStr & """")
		else
	 
			rea.pattern="(" & variables_name & ")\s*=\s*[a-zA-Z0-9]+"
            
 
			if checkRegExp(RequestStr,"^[\w]*$") then
 
				MB=rea.replace(MB,"$1=" & RequestStr)
				
			Else
				If variables_name="api_password" Then die "<hr>"&RequestStr&"<hr>"&MB
			end if
		end if
end If
	 
	Next
	
 
	set rea=nothing
	set file=fso.createtextfile(server.mappath("/config/const.asp"),true) 
	file.write MB
	file.close 
	set file = nothing 
	alert_redirect msgalert & othermsg ,"editconfig.asp"
end if
%>
<table width='100%'  border='0' align='center' cellpadding='0' cellspacing='0'>
  <tr align='center'>
    <td width="10"></td>
    <td id='TabTitle' class='title6' onClick="ShowTabs('0')">������Ϣ</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('1')">ҵ����Ϣ</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('2')">�ʼ��Ͷ���</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('3')">ϵͳ����</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('4')">����֧��</td>
   <td id='TabTitle' class='title5' onClick="ShowTabs('5')">�����ӿ�</td> 
    <td>&nbsp;</td>
  </tr>
</table>
<script>
var tID=0;
function ShowTabs(DivName)
{
	var tab=document.all("TabTitle");
    tab[tID].className='title5';
    tab[DivName].className='title6';
	tID=DivName;
	switch(DivName)
	{
		case "0":
			A1.style.display="";
			A2.style.display="none";
			A3.style.display="none";
			A4.style.display="none";
			A5.style.display="none";
			A6.style.display="none";
			break;
		case "1":
			A1.style.display="none";
			A2.style.display="";
			A3.style.display="none";
			A4.style.display="none";
			A5.style.display="none";
			A6.style.display="none";
			break;
		case "2":
			A1.style.display="none";
			A2.style.display="none";
			A3.style.display="";
			A4.style.display="none";
			A5.style.display="none";
			A6.style.display="none";
			break;
		case "3":
			A1.style.display="none";
			A2.style.display="none";
			A3.style.display="none";
			A4.style.display="";
			A5.style.display="none";
			A6.style.display="none";
			break;
		case "4":
			A1.style.display="none";
			A2.style.display="none";
			A3.style.display="none";
			A4.style.display="none";
			A5.style.display="";
			A6.style.display="none";
			break;
		case "5":
			A1.style.display="none";
			A2.style.display="none";
			A3.style.display="none";
			A4.style.display="none";
			A5.style.display="none";
			A6.style.display="";
			break;
	}
}
</script>
<div id="A1">
  <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
    <form name="form1" method="post" action="">
      <tr> 
        <td colspan="2"  class="tdbg"><strong>��վ��һЩ������Ϣ����</strong></td>
      </tr>
      <tr> 
        <td width="33%" align="right" nowrap  class="tdbg">��վ���ƣ�</td>
        <td width="67%" class="tdbg">
          <input type="text" name="companyname" id="companyname" value="<%=companyname%>">
          ��&quot;��������&quot;</td>
      </tr>
      <tr> 
        <td width="33%" align="right" nowrap  class="tdbg">��˾���ƣ�</td>
        <td width="67%" class="tdbg">
          <input type="text" name="company_Name" id="company_Name" value="<%=company_Name%>">
          ��&quot;��������&quot;&nbsp;&nbsp;�粻���ý���ʾ��վ����</td>
      </tr>
      <tr> 
        <td align="right" nowrap  class="tdbg">��ַ��</td>
        <td nowrap class="tdbg">
          <input name="companynameurl" type="text" id="companynameurl" value="<%=companynameurl%>" size="40">
          ��д����(������)url�磺http://www.sina.com</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">��˾��ַ��</td>
        <td class="tdbg">
          <input name="companyaddress" type="text" id="companyaddress" value="<%=companyaddress%>" size="40">
          
        </td>
      </tr>
         <tr>
      <td width="34%" align="right" nowrap  class="tdbg">��̨��½��֤�룺</td>
      <td width="66%" class="tdbg"><input name="webmanagespwd" type="text" id="webmanagespwd" value="" size="40">(<%
	  if trim(webmanagespwd)<>"" then
	  response.Write("<font color=green>������,��Ϊ�ռ����޸�����</font>")
	  else
	  response.Write("<font color=reg>δ��������,�����úò��������µ�½</font>")
	  end if
 	  %>)
</td>
    </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">�������룺</td>
        <td  class="tdbg">
          <input name="postcode" type="text" id="postcode" value="<%=postcode%>" size="8">        </td>
      </tr>
	    <tr> 
        <td align="right" nowrap class="tdbg">��վ�����ţ�</td>
        <td  class="tdbg">
          <input name="website_beianno" type="text" id="website_beianno" value="<%=website_beianno%>" size="20">        </td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">�ռ����Ѽ۸񱣻���</td>
        <td class="tdbg"><select name="vhost_ren_price" id="vhost_ren_price">
          <option value="true"  <%if vhost_ren_price then response.Write("selected")%>>����</option>
          <option value="false"  <%if not vhost_ren_price then response.Write("selected")%>>����</option>
        </select>
          ���ý������۳��۸�����ڳɱ��۸񽫲��ɹ���</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">�ͷ�QQ��</td>
        <td class="tdbg">
          <input name="oicq" type="text" id="oicq" value="<%=oicq%>" size="40">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Msn��ַ��</td>
        <td class="tdbg">
          <input name="msn" type="text" id="msn" value="<%=msn%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">��ϵ�绰��</td>
        <td class="tdbg">
          <input name="telphone" type="text" id="telphone" value="<%=telphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">������룺</td>
        <td class="tdbg">
          <input name="faxphone" type="text" id="faxphone" value="<%=faxphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">ҹ��ֵ��绰��</td>
        <td class="tdbg">
          <input name="nightphone" type="text" id="nightphone" value="<%=nightphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">����רԱ���䣺</td>
        <td class="tdbg">
          <input name="agentmail" type="text" id="agentmail" value="<%=agentmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">����רԱ���䣺</td>
        <td class="tdbg">
          <input name="supportmail" type="text" id="supportmail" value="<%=supportmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">����רԱ���䣺</td>
        <td class="tdbg">
          <input name="salesmail" type="text" id="salesmail" value="<%=salesmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">��Ƹ��Ϣ���䣺</td>
        <td class="tdbg">
          <input name="jobmail" type="text" id="jobmail" value="<%=jobmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">���������滻:</td>
        <td class="tdbg"><input name="roomName" type="text" id="roomName" value="<%=roomName%>" size="40">��":"ǰ����滻�ɺ����,��","�ָ�<br>
          ʾ�������Ĵ�:,����:�Ͼ���������:�����������е�&quot;�Ĵ�&quot;�滻�ɿ�,&quot;����&quot;�滻��&quot;�Ͼ�&quot;.</td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�����QQ��½��</td>
        <td class="tdbg"> <select name="qq_isLogin" id="qq_isLogin">
          <option value="True"<%if qq_isLogin then%> selected<%end if%>>True</option>
          <option value="False"<%if not qq_isLogin then%> selected<%end if%>>False</option>
        </select>
          ����<a href="http://open.qq.com/" target="_blank"><font color="red">��ͨ��ַ</font></a></td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">QQ_APPID��</td>
        <td class="tdbg"><input name="qq_AppID" type="text" id="qq_AppID" value="<%=qq_AppID%>" size="40"></td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">QQ_Keys��</td>
        <td class="tdbg"><input name="qq_AppKey" type="text" id="qq_AppKey" value="<%=qq_AppKey%>" size="40"></td>
      </tr>
      <tr style="display:none">
        <td align="right" nowrap class="tdbg">QQ_�ص���ַ��</td>
        <td class="tdbg"><input name="qq_returnUrl" type="text" id="qq_returnUrl" value="<%=qq_returnUrl%>" size="40">
        �ص���ַhttp://������ַ/reg/returnQQ.asp</td>
      </tr>
      
            <tr>
        <td align="right" nowrap class="tdbg"><p>�����������ۿ����ã�<br>
          (<font color="red">�粻����������Ϊ1.00, 9��Ϊ0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>����1
            <input name="diyuserlev1" type="text" id="diyuserlev1" value="<%=diyuserlev1%>" style="width:40px;" maxlength="4">
            
            ����2
            <input name="diyuserlev2" type="text" id="diyuserlev2" value="<%=diyuserlev2%>" style="width:40px;"  maxlength="4">
            
            ����3
            <input name="diyuserlev3" type="text" id="diyuserlev3" value="<%=diyuserlev3%>" style="width:40px;"  maxlength="4">
            
            ����4
            <input name="diyuserlev4" type="text" id="diyuserlev4" value="<%=diyuserlev4%>" style="width:40px;"  maxlength="4">
            
            ����5
            <input name="diyuserlev5" type="text" id="diyuserlev5" value="<%=diyuserlev5%>" style="width:40px;"  maxlength="4">
            <br>
          ���������������ۿ�:
          <input name="diyfist" type="text" id="diyfist" value="<%=diyfist%>" style="width:40px;" maxlength="4">
          <label style="color:red">������л�Ա����ֻ��԰����¹���������Ϊ1������Ա�����ۿ�ִ�У�</label>>
          </p></td>
      </tr>
        <tr>
        <td align="right" nowrap class="tdbg"><p>�����������ۿ����ã�<br>
          (<font color="red">�粻����������Ϊ1.00, 9��Ϊ0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>����:
            <input name="diy_dis_6" type="text" id="diy_dis_6" value="<%=diy_dis_6%>" style="width:40px;" maxlength="4">
            
             1��:
            <input name="diy_dis_12" type="text" id="diy_dis_12" value="<%=diy_dis_12%>" style="width:40px;"  maxlength="4">
            
            2��
            <input name="diy_dis_24" type="text" id="diy_dis_24" value="<%=diy_dis_24%>" style="width:40px;"  maxlength="4">
            
            3��
            <input name="diy_dis_36" type="text" id="diy_dis_36" value="<%=diy_dis_36%>" style="width:40px;"  maxlength="4">
            
            5��
            <input name="diy_dis_60" type="text" id="diy_dis_60" value="<%=diy_dis_60%>" style="width:40px;"  maxlength="4">
         
         
          <label style="color:red">������л�Ա����</label>
          </p></td>
      </tr>
	   <tr>
        <td align="right" nowrap class="tdbg"><p>���ʾ��ۿ����ã�<br>
          (<font color="red">�粻����������Ϊ1.00, 9��Ϊ0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>����1
            <input name="diyMlev1" type="text" id="diyMlev1" value="<%=diyMlev1%>" style="width:40px;" maxlength="4">
            
            ����2
            <input name="diyMlev2" type="text" id="diyMlev2" value="<%=diyMlev2%>" style="width:40px;"  maxlength="4">
            
            ����3
            <input name="diyMlev3" type="text" id="diyMlev3" value="<%=diyMlev3%>" style="width:40px;"  maxlength="4">
            
            ����4
            <input name="diyMlev4" type="text" id="diyMlev4" value="<%=diyMlev4%>" style="width:40px;"  maxlength="4">
            
            ����5
            <input name="diyMlev5" type="text" id="diyMlev5" value="<%=diyMlev5%>" style="width:40px;"  maxlength="4">

          </p></td>
      </tr>
      <tr>
			<td align="right" nowrap class="tdbg">С�������ü۸�</td>
		    <td bgcolor="#FF0000" class="tdbg"><input name="miniprogram_paytype_money" type="text" id="miniprogram_paytype_money" value="<%=miniprogram_paytype_money%>" size="40" style="width:40px;">(<font color="red">С�������ü۸�,�������д0</font>)</td>
	  </tr>
	   <tr>
			<td align="right" nowrap class="tdbg">С������ż۸�(��)</td>
		    <td bgcolor="#FF0000" class="tdbg"><input name="miniprogram_sms_money" type="text" id="miniprogram_sms_money" value="<%=miniprogram_sms_money%>" size="40"  style="width:40px;">(<font color="red">Ĭ�ϼ۸�Ϊ0.1Ԫ</font>)</td>
	  </tr>
      
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">
          <input type="submit" name="button" id="button" value=" ȷ �� �� �� ">
          <input name="Act" type="hidden" id="Act" value="base">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">&nbsp;</td>
      </tr>
    </form>
  </table>
</div>
<div id="A2" style="display:none">
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
  <form action="" method="post" name="form2" id="form2">
    <tr>
      <td colspan="2"  class="tdbg"><strong>��վҵ��������Ϣ</strong></td>
    </tr>
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">��������ƽ̨����ַ��</td>
      <td width="66%" class="tdbg"><input name="manager_url" readonly type="text" id="manager_url" value="<%=manager_url%>" size="40"> *�����޸ġ�</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">�Ƿ����ϼ�ע�����ṩ��Ʊ��</td>
      <td class="tdbg">
        <select name="fapiao_api" id="fapiao_api">
          <option value="True"<%if fapiao_api=True then%> selected<%end if%>>True</option>
          <option value="False"<%if fapiao_api=False then%> selected<%end if%>>False</option>
        </select>
          ѡ��ture���û��ķ�Ʊ���뽫��ֱ���ύ���ϼ������̡� </td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">��Ʊ����</td>
      <td class="tdbg"><input name="fapiao_cost_feilv" type="text" id="fapiao_cost_feilv" value="<%=formatnumber(fapiao_cost_feilv,2,-1,-1)%>" size="3">
        ��ϣ���ͻ��ύ��Ʊʱ����ȡ��Ӧ˰�������ã���0.06(��֧������)</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">����ṩ�Һ�/ƽ���ʼķ�Ʊ����ͽ�</td>
      <td class="tdbg">
        <input name="fapiao_cost_leve" type="text" id="fapiao_cost_leve" value="<%=fapiao_cost_leve%>" size="3">
        Ԫ ��<font color=red>���Ѳ�����ṩ��Ʊ,��ϸ��������ѯ����רԱ</font>���Һ��Ż�ƽ�Ž��շ�,�����շѽ������:</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">�Һ����շѣ�</td>
      <td class="tdbg">
        <input name="fapiao_cost_0" type="text"  value="<%=fapiao_cost_0%>" size="3">
Ԫ���û�����ķ�Ʊ�������ϱ�����ʱ���򰴴��շ�;������ͽ��ʱ����ѡ�</td>
    </tr>    
    <tr>
      <td align="right" nowrap  class="tdbg">����շѣ�</td>
      <td class="tdbg">
        <input name="fapiao_cost_1" type="text" id="fapiao_cost_1" value="<%=fapiao_cost_1%>" size="3">
Ԫ�����û�Ҫ���ݷ�Ʊʱ�������շѡ�</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">�����շѣ�</td>
      <td class="tdbg">
        <input name="fapiao_cost_2" type="text" id="fapiao_cost_2" value="<%=fapiao_cost_2%>" size="3">
        Ԫ��Ĭ�ϲ��շѣ��յ���ݺ����û����и��ѡ�</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">ƽ���շѣ�</td>
      <td class="tdbg">
        <input name="fapiao_cost_3" type="text" id="fapiao_cost_3" value="<%=fapiao_cost_3%>" size="3">
Ԫ ���û�����ķ�Ʊ��������ͽ��򰴴��շ�;��������շѽ��ʱ����ѡ�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����IP���������ۿۣ�</td>
      <td class="tdbg"><input name="firstvpsdiscount" type="text" id="firstvpsdiscount" value="<%=formatnumber(firstvpsdiscount,2,-1,-1)%>" size="3"> �粻����������Ϊ1, 9��Ϊ0.9.
          </td>
    </tr>
     <tr  style="color:red">
      <td align="right" nowrap class="tdbg">�������������ü۸�ֱ�ӿͻ�����</td>
      <td class="tdbg"><input name="diypaytestPrice" type="text" id="diypaytestPrice" value="<%=diypaytestPrice%>" size="3">
          Ԫ���粻֪���ü۸�����ѯ������������</td>
    </tr>
        <tr  style="color:red">
      <td align="right" nowrap class="tdbg">�������������ü۸񣨴���ͻ�����</td>
      <td class="tdbg"><input name="diypaytestDLPrice" type="text" id="diypaytestDLPrice" value="<%=diypaytestDLPrice%>" size="3">
          Ԫ���粻֪���ü۸�����ѯ������������</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��ͨ���������շѣ�</td>
      <td class="tdbg"><input name="demoprice" type="text" id="demoprice" value="<%=demoprice%>" size="3">
          Ԫ��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��ͨ����Mssql�շѣ�</td>
      <td class="tdbg"><input name="demomssqlprice" type="text" id="demomssqlprice" value="<%=demomssqlprice%>" size="3">
          Ԫ��</td>
    </tr>  
    <tr>
      <td align="right" nowrap class="tdbg">��ͨ�����ʾ��շѣ�</td>
      <td class="tdbg"><input name="demomailprice" type="text" id="demomailprice" value="<%=demomailprice%>" size="3">
          Ԫ��</td>
    </tr>    
    <tr>
      <td align="right" nowrap class="tdbg">Ĭ��ע��ȼ���</td>
      <td class="tdbg"><input name="reguser_level" type="text" id="reguser_level" value="<%=reguser_level%>" size="3">
          Ĭ��Ϊ1,��ʾֱ�ӿͻ���</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg" height="33">������ѯ�ӿڣ�</td>
        <td  class="tdbg" height="33">
        <select name="whoisapi">
        <option value="1" <%if whoisapi=1 then response.write "selected"%>>��������ӿ�</option>
        <option value="2" <%if whoisapi=2 then response.write "selected"%>>  �����ӿ�  </option>
        <option value="3" <%if whoisapi=3 then response.write "selected"%>>ʱ�������ӿ�</option>
        <option value="4" <%if whoisapi=4 then response.write "selected"%>>ʱ��������վ</option>
        </select>
       </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��ע����û��ܷ�ֱ�ӿ�ͨ����������</td>
      <td class="tdbg">
              <select name="reguser_try" id="reguser_try">
          <option value="True"<%if reguser_try=True then%> selected<%end if%>>ֱ�ӿ�ͨ</option>
          <option value="False"<%if reguser_try=False then%> selected<%end if%>>����˺�</option>
        </select>

      true��ʾ���Կ���false��ʾ��Ҫ����Ա��˺���ܿ�����</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����DNS1��ַ��</td>
      <td class="tdbg"><input name="ns1" type="text" id="ns1" value="<%=ns1%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����DNS1IP��</td>
      <td class="tdbg"><input name="ns1_ip" type="text" id="ns1_ip" value="<%=ns1_ip%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����DNS2��ַ��</td>
      <td class="tdbg"><input name="ns2" type="text" id="ns2" value="<%=ns2%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����DNS2IP��</td>
      <td class="tdbg"><input name="ns2_ip" type="text" id="ns2_ip" value="<%=ns2_ip%>"></td>
    </tr>
    <tr>
    <td class="tdbg">&nbsp;</td><td class="tdbg">����������[ת������]�ļ۸�(�����û��ȼ�)���벻Ҫ���˼۸����ø�[ֱ������]��һ��<br>���齫[ֱ������]�����1~5Ԫ����[ת������]�۽���1~5Ԫ��������ת����˾�ɻ�ø���ʵ�ݺ�ǿ���ܡ�</td>

    </tr>
    	<tr>
      <td align="right" nowrap class="tdbg">����Ӣ��������</td>
      <td class="tdbg"><input name="trainsin_domcom" size="7" type="text" id="trainsin_domcom" value="<%=trainsin_domcom%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">��������������</td>
      <td class="tdbg"><input name="trainsin_domhz" size="7" type="text" id="trainsin_domhz" value="<%=trainsin_domhz%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">����CN������</td>
      <td class="tdbg"><input name="trainsin_domcn" size="7" type="text" id="trainsin_domcn" value="<%=trainsin_domcn%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">��������������</td>
      <td class="tdbg"><input name="trainsin_domchina" size="7" type="text" id="trainsin_domchina" value="<%=trainsin_domchina%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">����org������</td>
      <td class="tdbg"><input name="trainsin_domorg" size="7" type="text" id="trainsin_domorg" value="<%=trainsin_domorg%>"></td>
    </tr>
        
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button2" id="button2" value=" ȷ �� �� �� ">
      <input name="Act" type="hidden" id="Act" value="info"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table></div>
<div id="A3" style="display:none">
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
  <form action="" method="post" name="form3" id="form3">
    <tr>
      <td colspan="2"  class="tdbg"><strong>��վ�ʼ��Ͷ��ŷ��Ͳ���</strong></td>
    </tr>
   
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">�����˵�ַ��</td>
      <td width="66%" class="tdbg"><input name="mailfrom" type="text" id="mailfrom" value="<%=mailfrom%>">&nbsp;&nbsp;&nbsp;������<input name="sendmailname" type="text" id="sendmailname" value="<%=sendmailname%>"><a href="http://help.west.cn/help/list.asp?unid=412" target="_blank" style="color:red">�������ð���</a></td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">SMTP��������ַ��</td>
      <td class="tdbg"><input name="mailserverip" type="text" id="mailserverip" value="<%=mailserverip%>">�˿�:<input name="mailport" type="text" id="mailport" value="<%=mailport%>"> SSL: <select name="mailssl" id="mailssl">
          <option value="True"<%if mailssl then%> selected<%end if%>>����</option>
          <option value="False"<%if not mailssl then%> selected<%end if%>>����</option>
        </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SMTP�û�����</td>
      <td class="tdbg"><input name="mailserveruser" type="text" id="mailserveruser" value="<%=mailserveruser%>">  &nbsp;&nbsp;<input type="button" value="���Է���" onclick="sendmial('<%=mailserveruser%>')"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SMTP���룺</td>
      <td  class="tdbg"><input name="mailserverpassword" type="password" id="mailserverpassword" value="<%=mailserverpassword%>"></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">������Ϣ���������������ܸ��ͻ��Զ������ʼ���Ĭ�ϵ�agentuser@west263.com�����޸Ľ��޷��Զ����ʼ���<BR><br>
<a href="http://help.west.cn/help/list.asp?unid=432" target="_blank" style="color:red">�����������Զ������ʼ�����˵����</a>
</td>
    </tr>
    <tr height=50>
    <td align="right" nowrap class="tdbg">���ʱش����ѣ�<BR>(<font color="red">��¼�������ַ</font>)</td>
    <td class="tdbg"><input type="text" name="questionMail" value="<%=questionMail%>"><span>���û��ڴ���ƽ̨��ʾ���ʱ�ʱ������Ա���������ʼ���Ϊ�ղ����ͣ�</span></td>
    </tr>
    
    
 <tr>
      <td align="right" nowrap class="tdbg">�����ʼ���</td>
      <td  class="tdbg"><input name="sendmailcc" type="text" id="sendmailcc" value="<%=sendmailcc%>"> �粻��д���������ʼ����೭���ʼ�����";"�ָ���ע�����ʼ���������һ�ݣ���</td>
    </tr>

	<tr>
        <td align="right" nowrap class="tdbg">���Žӿ����ͣ�</td>
        <td class="tdbg">
		<select name="sms_type">
			<option value="west"  <%if Trim(sms_type)="west" Then Response.write("selected") End if%>>��������</option>
			<option value="user"  <%if Trim(sms_type)="user" Then Response.write("selected") End if%>>�û��Զ���</option>
			<option value="smsbao" <%if Trim(sms_type)="smsbao" Then Response.write("selected") End if%>>���ű�(�ɹ�����(0))</option>
			<option value="chanyoo" <%if Trim(sms_type)="chanyoo" Then Response.write("selected") End if%>>��������ɹ�����(>=0)</option>
		</select> 
      </td>
    </tr>

	<tr>
        <td align="right" nowrap class="tdbg">���Ͷ��ŵ�ַ��</td>
        <td class="tdbg" >
		<input name="sms_url" type="text" id="sms_url" value="<%=sms_url%>"> {u}:api�ʺ� {p}:api����   {m}:�ֻ�����  {c} :�������� http://xx.xxx.xx/sms?u={u}&p={p}&m={m}&c={c}
      </td>
    </tr>
    
	<tr>
        <td align="right" nowrap class="tdbg">����ǩ����</td>
      <td class="tdbg"><input name="sms_sign" type="text" id="sms_sign" value="<%=sms_sign%>"> </td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�����ʺţ�</td>
      <td class="tdbg"><input name="sms_mailname" type="text" id="sms_mailname" value="<%=sms_mailname%>"> </td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�������룺</td>
      <td class="tdbg"><input name="sms_mailpwd" type="text" id="sms_mailpwd" value="<%=sms_mailpwd%>"> (ע:���ű�����Ϊmd5( ����)) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ�������֪ͨ��</td>
      <td class="tdbg">
<select name="sms_note" id="sms_note">
    <option value="True"<%if sms_note=True then%> selected<%end if%>>��</option>
    <option value="False"<%if sms_note=False then%> selected<%end if%>>��</option>
</select>
      Ĭ���Ƿ�������֪ͨ������֪ͨ���ڣ��û��һ����롢��������֪ͨ�ȵط���</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button3" id="button3" value=" ȷ �� �� �� ">
      <input name="Act" type="hidden" id="Act" value="mail"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table></div>
<div id="A4" style="display:none"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
  <form action="" method="post" name="form4" id="form4">
    <tr>
      <td colspan="2"  class="tdbg"><strong>ϵͳ����</strong></td>
    </tr>
    
 
    
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">Logo·����</td>
      <td width="66%" class="tdbg"><input name="logimgPath" type="text" id="logimgPath" value="<%=logimgPath%>" size="40"></td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">FSO������ƣ�</td>
      <td class="tdbg"><input name="objName_FSO" type="text" id="objName_FSO" value="<%=objName_FSO%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��̨����·����</td>
      <td  class="tdbg"><input name="SystemAdminPath" type="text" id="SystemAdminPath" value="<%=SystemAdminPath%>">
          ϵͳ��װʱ��д��ƽʱһ�㲻Ҫ�޸ġ� </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SiteMapXML·����</td>
      <td  class="tdbg"><input name="strXMLFilePath" type="text" id="strXMLFilePath" value="<%=strXMLFilePath%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SiteMapXSL·����</td>
      <td  class="tdbg"><input name="strXSLFilePath" type="text" id="strXSLFilePath" value="<%=strXSLFilePath%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�ϼ�API�ӿ�·����</td>
      <td class="tdbg"><input name="api_url" type="text" id="api_url" value="<%=api_url%>" size="40"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">API�û�����</td>
      <td class="tdbg"><input name="api_username" type="text" id="api_username" value="<%=api_username%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">API���룺</td>
      <td class="tdbg">
          <input name="api_password" type="password" id="api_password" value="<%=api_password%>">
          (�ڹ�������&gt;�����̹���&gt;api���� �������õ�����) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg"><font color="red">��½��֤�룺</font></td>
      <td class="tdbg">
           <select name="showsafecode">
           <option value="false" <%if not showsafecode then response.Write("selected") %>>�ر�</option>
           <option value="true" <%if showsafecode then response.Write("selected") %>>����</option>
           </select>
          (�����˹��ܺ����½����3�λ�ip��½ʧ�ܳ�20�ν�Ҫ��¼����֤��.) </td>
    </tr>
  <tr>
      <td align="right" nowrap class="tdbg"> �û��ֻ�ʵ����֤</td>
      <td class="tdbg">
           <select name="issetauthmobile">
           <option value="false" <%if not issetauthmobile then response.Write("selected") %>>�ر�</option>
           <option value="true" <%if issetauthmobile then response.Write("selected") %>>����</option>
           </select>
          (�����˹��ܺ󡣵�½�������Ļ�Ҫ���û�ʵ����֤) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Զ�ͨ��api�ӿڿ�ͨ��ҵ�����ࣺ</td>
      <td class="tdbg">
      <input name="api_autoopen" type="checkbox" id="checkbox" value="domain"<%if instr(api_autoopen,"domain")<>0 then%> checked<%end if%>>����ע��
      <input name="api_autoopen" type="checkbox" id="checkbox" value="vhost"<%if instr(api_autoopen,"vhost")<>0 then%> checked<%end if%>>��������

      <input name="api_autoopen" type="checkbox" id="checkbox" value="mail"<%if instr(api_autoopen,"mail")<>0 then%> checked<%end if%>>��ҵ����
      <input name="api_autoopen" type="checkbox" id="checkbox" value="mssql"<%if instr(api_autoopen,"mssql")<>0 then%> checked<%end if%>>MSSQL���ݿ�
      
      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ�Ϊ�¼������ṩAPI�ӿڣ�</td>
      <td class="tdbg">
<select name="api_open" id="api_open">
    <option value="True"<%if api_open=True then%> selected<%end if%>>��</option>
    <option value="False"<%if api_open=False then%> selected<%end if%>>��</option>
</select>(API�ӿڵ�ַ��http://<%=request.ServerVariables("SERVER_NAME")%>/api/main.asp)
      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��Ҫ�ύ���ϼ�ע���̵����⣺</td>
      <td class="tdbg"><select name="Qustion_Upload" size="1" multiple id="Qustion_Upload" style="height:130px">
        <option value="0102"<%if instr(Qustion_Upload,"0102")<>0 then%> selected<%end if%>>������������</option>
		 <option value="142"<%if instr(Qustion_Upload,"142")<>0 then%> selected<%end if%>>�ƽ�վ</option>
        <option value="0103"<%if instr(Qustion_Upload,"0103")<>0 then%> selected<%end if%>>��������</option>
        <option value="0104"<%if instr(Qustion_Upload,"0104")<>0 then%> selected<%end if%>>��ҵ��������</option>
        <option value="0201"<%if instr(Qustion_Upload,"0201")<>0 then%> selected<%end if%>>���ݿ�����</option>
        <option value="0202"<%if instr(Qustion_Upload,"0202")<>0 then%> selected<%end if%>>��������/�й�����</option>
        <option value="0203"<%if instr(Qustion_Upload,"0203")<>0 then%> selected<%end if%>>VPS�������</option>
        <option value="0302"<%if instr(Qustion_Upload,"0302")<>0 then%> selected<%end if%>>��վ�ƹ�����</option>
        <option value="0801"<%if instr(Qustion_Upload,"0801")<>0 then%> selected<%end if%>>����</option>
        </select>
          ��ʾ����סCtrl�������Զ�ѡ�� </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ������û�����vcp_Cģʽ����</td>
      <td class="tdbg">
<select name="vcp_c" id="vcp_c">
    <option value="True"<%if vcp_c=True then%> selected<%end if%>>��</option>
    <option value="False"<%if vcp_c=False then%> selected<%end if%>>��</option>
</select>
</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ������û�����vcp_Dģʽ����</td>
      <td class="tdbg">
<select name="vcp_d" id="vcp_d">
    <option value="True"<%if vcp_d=True then%> selected<%end if%>>��</option>
    <option value="False"<%if vcp_d=False then%> selected<%end if%>>��</option>
</select></td>
    </tr>
  <tr>
      <td colspan="2" align="center" nowrap class="tdbg">vcp�������,��ɱ���ֻ������<font color=red>0��0.5</font>������Ч</td>
      </tr>
 
     <tr>
      <td align="right" nowrap class="tdbg">��������(%)��</td>
      <td class="tdbg">
      	�¹�: <input name="vcp_vhost" type="text" id="vcp_vhost" value="<%=vcp_vhost%>" style="width:40px;"> 
        ����: <input name="vcp_rennew_vhost" type="text" id="vcp_rennew_vhost" value="<%=vcp_rennew_vhost%>" style="width:40px;"> 
      </td>
    </tr> 
 
     <tr>
      <td align="right" nowrap class="tdbg">��ҵ�ʾ�(%)��</td>
      <td class="tdbg">
      	�¹�: <input name="vcp_mail" type="text" id="vcp_mail" value="<%=vcp_mail%>" style="width:40px;"> 
        ����: <input name="vcp_rennew_mail" type="text" id="vcp_rennew_mail" value="<%=vcp_rennew_mail%>" style="width:40px;"> 
      </td>
    </tr>
 
     <tr>
      <td align="right" nowrap class="tdbg">�Ʒ�����(%)��</td>
      <td class="tdbg">
      	�¹�: <input name="vcp_server" type="text" id="vcp_server" value="<%=vcp_server%>" style="width:40px;"> 
        ����: <input name="vcp_rennew_server" type="text" id="vcp_rennew_server" value="<%=vcp_rennew_server%>" style="width:40px;"> 
      </td>
    </tr>
    
    
    
    
    
    <tr>
      <td colspan="2" align="center" nowrap class="tdbg">���Ѽ۸��Ƿ����ʼ���ʾ</td>
      </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�������Ѽ۸�</td>
      <td class="tdbg"><select name="issenddmjg" id="issenddmjg">
        <option value="True"<%if issenddmjg=True then%> selected<%end if%>>��</option>
        <option value="False"<%if issenddmjg=False then%> selected<%end if%>>��</option>
      </select> 
        &nbsp; �Ƿ���ʾ�������Ѽ۸�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����������</td>
      <td class="tdbg"><select name="issendvhjg" id="issendvhjg">
        <option value="True"<%if issendvhjg=True then%> selected<%end if%>>��</option>
        <option value="False"<%if issendvhjg=False then%> selected<%end if%>>��</option>
      </select>
&nbsp; �Ƿ���ʾ�����������Ѽ۸�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">������������VPS��</td>
      <td class="tdbg"><select name="issendvpsjg" id="issendvpsjg">
        <option value="True"<%if issendvpsjg=True then%> selected<%end if%>>��</option>
        <option value="False"<%if issendvpsjg=False then%> selected<%end if%>>��</option>
      </select>
&nbsp; �Ƿ���ʾ������������VPS���Ѽ۸�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">���ݿ⣺</td>
      <td class="tdbg"><select name="issenddbjg" id="issenddbjg">
        <option value="True"<%if issenddbjg=True then%> selected<%end if%>>��</option>
        <option value="False"<%if issenddbjg=False then%> selected<%end if%>>��</option>
      </select>
&nbsp; �Ƿ���ʾ���ݿ����Ѽ۸�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">���䣺</td>
      <td class="tdbg"><select name="issendmailjg" id="issendmailjg">
        <option value="True"<%if issendmailjg=True then%> selected<%end if%>>��</option>
        <option value="False"<%if issendmailjg=False then%> selected<%end if%>>��</option>
      </select>
&nbsp; �Ƿ���ʾ�������Ѽ۸�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button4" id="button4" value=" ȷ �� �� �� ">
      <input name="Act" type="hidden" id="Act" value="system"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table>
</div>
<div id="A5" style="display:none">
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
  <form action="" method="post" name="form5" id="form5">
    <tr>
      <td colspan="2"  class="tdbg"><strong>����֧������</strong></td>
    </tr>
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">�ϼ�ע���̵�����֧���ӿڵĵ�ַ��</td>
      <td width="66%" class="tdbg"><input name="defaultpay_url" type="text" id="defaultpay_url" value="<%=defaultpay_url%>" size="40">
          <a href="http://help.west.cn/help/list.asp?unid=364" target="_blank"><font color="#0000FF">���Ϊ�Լ����¼�����ƽ̨��ͨĬ��֧���ӿڣ�</font></a>        </td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">�Ƿ�ʹ���ϼ�ע���̵�֧���ӿڣ�</td>
      <td class="tdbg">
<select name="defaultpay" id="defaultpay">
    <option value="True"<%if defaultpay=True then%> selected<%end if%>>��</option>
    <option value="False"<%if defaultpay=False then%> selected<%end if%>>��</option>
</select>
          ���������ֱ��ʹ�ã�ϵͳ�Զ��������û���Ǯ��ͬʱ�������ϼ�ע���̵Ļ�Ա�ʺų�ֵ��ͬ�Ľ���˾����ȡ0.6%�����ѡ�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">ʹ���ϼ�ע���̵�֧���ӿڵķ��ʣ�</td>
      <td class="tdbg"><input name="defaultpay_fy" type="text" id="defaultpay_fy" value="<%=defaultpay_fy%>" size="6"> *��:ǧ��֮һ������0.001�������ðٷֺű��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td  class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="https://www.tenpay.com/" target="_blank"><font color="#0000FF">�Ƹ�ͨ</font></a>����֧����</td>
      <td class="tdbg">
      <select name="tenpay" id="tenpay">
    <option value="True"<%if tenpay=True then%> selected<%end if%>>��</option>
    <option value="False"<%if tenpay=False then%> selected<%end if%>>��</option>
</select>
<a href="http://union.tenpay.com/set_meal_charge/?Referrer=1202215301" target="_blank"><font color="#0000FF">[�����ײ�]</font></a>
<a href="http://union.tenpay.com/mch/mch_index1.shtml?sp_suggestuser=1202215301" target="_blank"><font color="#0000FF">�������</font></a>һ���Ƹ�ͨ�ʻ���֧�������ѽϵ�,ǿ��<font color="#FF0000">�Ƽ�</font>ʹ�á�</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƹ�ͨ�������ʣ�</td>
      <td class="tdbg"><input name="tenpay_fy" type="text" id="tenpay_fy" value="<%=tenpay_fy%>" size="6">  *��:ǧ��֮һ������0.001�������ðٷֺű��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ţ�</td>
      <td class="tdbg"><input name="tenpay_userid" type="text" id="yeepay_userid" value="<%=tenpay_userid%>">�Ƹ�֧ͨ���������<a href="http://help.west.cn/help/list.asp?unid=430" target="_blank" style="color:red">�������ڽ��еĽ��״�ϴ���ա�</a> ����</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="tenpay_userpass" type="text" id="tenpay_userpass" value="<%=tenpay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="http://wwww.yeepay.com" target="_blank"><font color="#0000FF">�ױ�</font></a>֧����</td>
      <td class="tdbg"><select name="yeepay" id="yeepay">
    <option value="True"<%if yeepay=True then%> selected<%end if%>>��</option>
    <option value="False"<%if yeepay=False then%> selected<%end if%>>��</option>
</select>
          ��Ҫ�ڷ�������ע���ױ���˾�ļ��������</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�ױ�֧���������ʣ�</td>
      <td class="tdbg"><input name="yeepay_fy" type="text" id="yeepay_fy" value="<%=yeepay_fy%>" size="6"> *��:ǧ��֮һ������0.001�������ðٷֺű��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ţ�</td>
      <td class="tdbg"><input name="yeepay_userid" type="text" id="yeepay_userid" value="<%=yeepay_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="yeepay_userpass" type="text" id="yeepay_userpass" value="<%=yeepay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="http://www.alipay.com.cn" target="_blank"><font color="#0000FF">֧����</font></a>��</td>
      <td class="tdbg">
          <select name="alipay" id="alipay">
            <option value="True"<%if alipay=True then%> selected<%end if%>>��</option>
            <option value="False"<%if alipay=False then%> selected<%end if%>>��</option>
          </select>
<!--             <font color="red">ֻ֧��֧����<strong>��ʱ���ʽӿ�</strong></font>
      <a href="http://www.west263.com/faq/list.asp?unid=460" target="_blank" style="color:#06F">���������������֧�����ӿ��ر�ͨ�������0.8%������</a>--></td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="https://b.alipay.com/order/signLogin.htm?action=newsign&productId=2011042200323155" target="_blank"><font color="#0000FF">֧������ݵ�½</font></a>��</td>
      <td class="tdbg">
          <select name="alipaylog" id="alipaylog">
            <option value="True"<%if alipaylog=True then%> selected<%end if%>>��</option>
            <option value="False"<%if alipaylog=False then%> selected<%end if%>>��</option>
          </select>
         ���뵽֧������������ʹ��<a href="https://b.alipay.com/order/signLogin.htm?action=newsign&productId=2011042200323155" target="_blank" style="color:#06F">�������</a></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">֧������ʾ���ƣ�</td>
      <td class="tdbg"><input name="alipayName" type="text" id="alipayName" value="<%=alipayName%>"  > *֧������ʾ������</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">֧�������ͣ�</td>
      <td class="tdbg">
	   <select name="alipay_type" id="alipay_type">
            <option value=""<%if alipay_type="" then%> selected<%end if%>>��ʱ����</option>
            <option value="SELLER_PAY"<%if alipay_type="SELLER_PAY" then%> selected<%end if%>>˫�����տ�</option>
			 <option value="DBSELLER_PAY"<%if alipay_type="DBSELLER_PAY" then%> selected<%end if%>>��������</option>

          </select>���ѡ˫���ܽӿڣ��û�ʹ�õ�������֧���ɹ�����Ҫ���ֹ����ͻ��ʺų�ֵ��ϵͳ�����Զ����ʡ�
	   </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">֧����֧���������ʣ�</td>
      <td class="tdbg"><input name="alipay_fy" type="text" id="alipay_fy" value="<%=alipay_fy%>" size="6"> *��:ǧ��֮һ������0.001�������ðٷֺű��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">֧�����ʺţ�</td>
      <td class="tdbg"><input name="alipay_account" type="text" id="alipay_account" value="<%=alipay_account%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ţ�</td>
      <td class="tdbg"><input name="alipay_userid" type="text" id="alipay_userid" value="<%=alipay_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="alipay_userpass" type="text" id="alipay_userpass" value="<%=alipay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="http://www.99bill.com" target="_blank"><font color="#0000FF">��Ǯv1.0</font></a>��</td>
      <td class="tdbg"><select name="kuaiqian" id="kuaiqian">
          <option value="True"<%if kuaiqian=True then%> selected<%end if%>>��</option>
          <option value="False"<%if kuaiqian=False then%> selected<%end if%>>��</option>
      </select>
      ��ȷ�����Ŀ�Ǯ�˺��Ƿ�֧��v1.0�汾      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��Ǯ֧���������ʣ�</td>
      <td class="tdbg"><input name="kuaiqian_fy" type="text" id="kuaiqian_fy" value="<%=kuaiqian_fy%>" size="6"> *��:ǧ��֮һ������0.001�������ðٷֺű��</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ţ�</td>
      <td class="tdbg"><input name="kuaiqian_userid" type="text" id="kuaiqian_userid" value="<%=kuaiqian_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="kuaiqian_userpass" type="text" id="kuaiqian_userpass" value="<%=kuaiqian_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="http://www.99bill.com" target="_blank"><font color="#0000FF">��Ǯv2.0</font></a>��</td>
      <td class="tdbg"><select name="kuaiqian2" id="kuaiqian2">
          <option value="True"<%if kuaiqian2=True then%> selected<%end if%>>��</option>
          <option value="False"<%if kuaiqian2=False then%> selected<%end if%>>��</option>
      </select>��ȷ�����Ŀ�Ǯ�˺��Ƿ�֧��v2.0�汾</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��Ǯ֧���������ʣ�</td>
      <td class="tdbg"><input name="kuaiqian2_fy" type="text" id="kuaiqian2_fy" value="<%=kuaiqian2_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ţ�</td>
      <td class="tdbg"><input name="kuaiqian2_userid" type="text" id="kuaiqian2_userid" value="<%=kuaiqian2_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="kuaiqian2_userpass" type="text" id="kuaiqian2_userpass" value="<%=kuaiqian2_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�������ID��</td>
      <td class="tdbg"><input name="kuaiqian2_pid" type="text" id="kuaiqian2_pid" value="<%=kuaiqian2_pid%>">��δ�Ϳ�Ǯǩ���������Э��,����Ҫ��д������</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<span class="STYLE4">����</span>��</td>
      <td class="tdbg"><select name="cncard" id="cncard">
        <option value="True"<%if cncard=True then%> selected<%end if%>>��</option>
        <option value="False"<%if cncard=False then%> selected<%end if%>>��</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">����֧���������ʣ�</td>
      <td class="tdbg"><input name="cncard_fy" type="text" id="cncard_fy" value="<%=cncard_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻���ţ�</td>
      <td class="tdbg"><input name="cncard_cmid" type="text" id="cncard_cmid" value="<%=cncard_cmid%>">
        �����̻����</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="cncard_cpass" type="text" id="cncard_cpass" value="<%=cncard_cpass%>">
        ����֧����Կ</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>

    <tr>
        <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<span class="STYLE4">΢��</span>��</td>
        <td class="tdbg"><select name="wxpay" id="wxpay">
            <option value="True"<%if wxpay=True then%> selected<%end if%>>��</option>
            <option value="False"<%if wxpay=False then%> selected<%end if%>>��</option>
        </select></td>
        </tr>
   <tr>
      <td align="right" nowrap class="tdbg">΢�������ѣ�</td>
      <td class="tdbg"><input name="wxpay_fy" type="text" id="wxpay_fy" value="<%=wxpay_fy%>" ></td>
    </tr>
        
      <tr>
      <td align="right" nowrap class="tdbg">΢��AppID��</td>
      <td class="tdbg"><input name="wxpay_appid" type="text" id="wxpay_appid" value="<%=wxpay_appid%>" ></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">΢���̻��ţ�</td>
      <td class="tdbg"><input name="wxpay_MchID" type="text" id="wxpay_MchID" value="<%=wxpay_MchID%>">
        ΢���̻���</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">΢���̻�Key��</td>
      <td class="tdbg"><input name="wxpay_MchKey" type="text" id="wxpay_MchKey" value="<%=wxpay_MchKey%>">
       �� ΢��֧����̨ \ �ʻ����� \ API��ȫ������ API��Կ ������</td>
    </tr>
	 <tr>
      <td align="right" nowrap class="tdbg">΢�Żص���ַ��</td>
      <td class="tdbg"><input name="wxpay_callback" type="text" id="wxpay_callback" value="<%=wxpay_callback%>">
       http://xxxxxx/api/weixin/return.asp</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>




    <tr>
      <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="http://www.chinabank.com.cn/" target="_blank"><span class="STYLE4">��������</span></a>��</td>
      <td class="tdbg"><select name="chinabank" id="chinabank">
        <option value="True"<%if chinabank=True then%> selected<%end if%>>��</option>
        <option value="False"<%if chinabank=False then%> selected<%end if%>>��</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">��������֧���������ʣ�</td>
      <td class="tdbg"><input name="chinabank_fy" type="text" id="chinabank_fy" value="<%=chinabank_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻���ţ�</td>
      <td class="tdbg"><input name="chinabank_cmid" type="text" id="chinabank_cmid" value="<%=chinabank_cmid%>">
        ���������̻����</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">�̻��ܳף�</td>
      <td class="tdbg"><input name="chinabank_cpass" type="text" id="chinabank_cpass" value="<%=chinabank_cpass%>">
        ��������֧����Կ</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">�Ƿ�ʹ��<a href="https://www.shengpay.com" target="_blank"><span class="STYLE4">ʢ��ͨ</span></a></td>
      <td class="tdbg"><select name="shengpay" id="shengpay">
        <option value="True"<%if shengpay=True then%> selected<%end if%>>��</option>
        <option value="False"<%if shengpay=False then%> selected<%end if%>>��</option>
      </select></td>
    </tr>
       <tr>
      <td align="right" nowrap class="tdbg">ʢ��ͨ����</td>
      <td class="tdbg"><input name="shengpay_fy" type="text" id="shengpay_fy" value="<%=shengpay_fy%>"></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">ʢ��ͨ���</td>
      <td class="tdbg"><input name="shengpay_MerId" type="text" id="shengpay_MerId" value="<%=shengpay_MerId%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">ʢ��ͨ����</td>
      <td class="tdbg"><input name="shengpay_Md5Key" type="text" id="shengpay_Md5Key" value="<%=shengpay_Md5Key%>"></td>
    </tr>
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button5" id="button5" value=" ȷ �� �� �� ">
      <input name="Act" type="hidden" id="Act" value="pay"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table>
</div>
 
<div id="A6" style="display:none">
  <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">
    <form action="" method="post" name="form6" id="form6">
      <tr> 
        <td colspan="2"  class="tdbg"><strong>ֱ��ʹ������ע����</strong></td>
      </tr>
      <tr> 
        <td colspan="2" align="right" nowrap  class="tdbg">��ʾ�������ʱ����Ҫ���ô�������������Ҫֱ��ʹ�������ȹ�˾�Ľӿڡ����úò����󣬻���Ҫ<a href="SetRegister.asp"><font color="#0000FF">���ø�������ע��ӿ�</font></a>��</td>
      </tr>
      <tr> 
        <td width="34%" align="right" nowrap  class="tdbg">�Ƿ�ʹ�����������DNS��������</td>
        <td width="66%" class="tdbg"> 
          <select name="using_dns_mgr" id="using_dns_mgr">
            <option value="True"<%if using_dns_mgr=True then%> selected<%end if%>>��</option>
            <option value="False"<%if using_dns_mgr=False then%> selected<%end if%>>��</option>
          </select>
          ʹ����������ע��ӿ�ʱ���Ƿ�ʹ����˾��DNS��������</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Ĭ��DNS1��</td>
        <td class="tdbg"> 
          <input name="default_dns1" type="text" id="default_dns1" value="<%=default_dns1%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Ĭ��DNS2��</td>
        <td class="tdbg"> 
          <input name="default_dns2" type="text" id="default_dns2" value="<%=default_dns2%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Ĭ��DNS ip1��</td>
        <td class="tdbg"> 
          <input name="default_ip1" type="text" id="default_ip1" value="<%=default_ip1%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Ĭ��DNS ip2��</td>
        <td class="tdbg"> 
          <input name="default_ip2" type="text" id="default_ip2" value="<%=default_ip2%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">&nbsp;</td>
      </tr>
     
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">&nbsp;</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg"> 
          <input type="submit" name="button5" id="button5" value=" ȷ �� �� �� ">
          <input name="Act" type="hidden" id="Act" value="pay">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">&nbsp;</td>
      </tr>
    </form>
  </table>
</div>

<script type="text/javascript">
<!--
	function sendmial(mail){
		var m_=prompt("���ȱ������ݺ��ٲ���!����д�����ʼ��������ַ,",mail)
		if (m_!=""){
			$.post("editconfig.asp",{act:"checksendmail",mail:m_},function(data){
				alert(data.msg)			
			},"json")
		}
	}
//-->
</script>
</BODY>
</HTML>
  

<!--#include virtual="/config/bottom_superadmin.asp" -->
