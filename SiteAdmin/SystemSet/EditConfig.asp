<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/md5_16.asp" -->
<%
response.charset="gb2312"
Check_Is_Master(1)
conn.open constr
If requesta("Act")="checksendmail" Then
	msg="未知操作!"
	mail=requesta("mail")
	If InStr(mail,"@")=0 Then
		msg="请录入正确邮箱地址"
	else
		If sendMail(mail,"测试邮件发送是否成功","测试邮件发送是否成功") Then
			msg="邮件发送成功!"
		Else
			msg="邮件发送失败!"
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
    <td height='30' align="center" ><strong>系 统 设 置</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
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
     msgalert="修改成功！"

	for each variables_name in request.form
	  isadd=true 
		rea.Pattern="(" & variables_name & ")\s*=\s*""([^'""\n\r]*)"""
		RequestStr=trim(request.Form(variables_name))
		
		RequestStr=replace(RequestStr,chr(34),"")
		RequestStr=replace(RequestStr,"<","&lt;")
		RequestStr=replace(RequestStr,">","&gt;")
		RequestStr=replace(RequestStr,"$","$$")
	

		'检查是否由上级开发票
		if trim(variables_name)=trim("fapiao_api") then
		   strbool=chk_fapiao_ok()
		    	
			'response.Write(RequestStr)
			'response.End()	
			if strbool=False and ucase(RequestStr)=ucase("True") then
	 	msgalert="发生错误！是否由上级注册商提供发票修改失败，请先联系您的渠道经理开通该功能！"    
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
			   call url_return("网站地址或网站名称为空不能操作!",-1)
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
				othermsg = " ,独立控制面板地址已自动变更"
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
    <td id='TabTitle' class='title6' onClick="ShowTabs('0')">基本信息</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('1')">业务信息</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('2')">邮件和短信</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('3')">系统设置</td>
    <td id='TabTitle' class='title5' onClick="ShowTabs('4')">在线支付</td>
   <td id='TabTitle' class='title5' onClick="ShowTabs('5')">域名接口</td> 
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
        <td colspan="2"  class="tdbg"><strong>网站的一些基本信息配置</strong></td>
      </tr>
      <tr> 
        <td width="33%" align="right" nowrap  class="tdbg">网站名称：</td>
        <td width="67%" class="tdbg">
          <input type="text" name="companyname" id="companyname" value="<%=companyname%>">
          如&quot;环球数码&quot;</td>
      </tr>
      <tr> 
        <td width="33%" align="right" nowrap  class="tdbg">公司名称：</td>
        <td width="67%" class="tdbg">
          <input type="text" name="company_Name" id="company_Name" value="<%=company_Name%>">
          如&quot;环球数码&quot;&nbsp;&nbsp;如不设置将显示网站名称</td>
      </tr>
      <tr> 
        <td align="right" nowrap  class="tdbg">网址：</td>
        <td nowrap class="tdbg">
          <input name="companynameurl" type="text" id="companynameurl" value="<%=companynameurl%>" size="40">
          填写完整(非中文)url如：http://www.sina.com</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">公司地址：</td>
        <td class="tdbg">
          <input name="companyaddress" type="text" id="companyaddress" value="<%=companyaddress%>" size="40">
          
        </td>
      </tr>
         <tr>
      <td width="34%" align="right" nowrap  class="tdbg">后台登陆验证码：</td>
      <td width="66%" class="tdbg"><input name="webmanagespwd" type="text" id="webmanagespwd" value="" size="40">(<%
	  if trim(webmanagespwd)<>"" then
	  response.Write("<font color=green>已设置,如为空即不修改密码</font>")
	  else
	  response.Write("<font color=reg>未设置设置,请设置好参数后重新登陆</font>")
	  end if
 	  %>)
</td>
    </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">邮政编码：</td>
        <td  class="tdbg">
          <input name="postcode" type="text" id="postcode" value="<%=postcode%>" size="8">        </td>
      </tr>
	    <tr> 
        <td align="right" nowrap class="tdbg">网站备案号：</td>
        <td  class="tdbg">
          <input name="website_beianno" type="text" id="website_beianno" value="<%=website_beianno%>" size="20">        </td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">空间续费价格保护：</td>
        <td class="tdbg"><select name="vhost_ren_price" id="vhost_ren_price">
          <option value="true"  <%if vhost_ren_price then response.Write("selected")%>>启用</option>
          <option value="false"  <%if not vhost_ren_price then response.Write("selected")%>>禁用</option>
        </select>
          启用将传递售出价格，如底于成本价格将不成功！</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">客服QQ：</td>
        <td class="tdbg">
          <input name="oicq" type="text" id="oicq" value="<%=oicq%>" size="40">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">Msn地址：</td>
        <td class="tdbg">
          <input name="msn" type="text" id="msn" value="<%=msn%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">联系电话：</td>
        <td class="tdbg">
          <input name="telphone" type="text" id="telphone" value="<%=telphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">传真号码：</td>
        <td class="tdbg">
          <input name="faxphone" type="text" id="faxphone" value="<%=faxphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">夜间值班电话：</td>
        <td class="tdbg">
          <input name="nightphone" type="text" id="nightphone" value="<%=nightphone%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">代理专员邮箱：</td>
        <td class="tdbg">
          <input name="agentmail" type="text" id="agentmail" value="<%=agentmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">服务专员邮箱：</td>
        <td class="tdbg">
          <input name="supportmail" type="text" id="supportmail" value="<%=supportmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">销售专员邮箱：</td>
        <td class="tdbg">
          <input name="salesmail" type="text" id="salesmail" value="<%=salesmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">招聘信息邮箱：</td>
        <td class="tdbg">
          <input name="jobmail" type="text" id="jobmail" value="<%=jobmail%>">        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">机房名称替换:</td>
        <td class="tdbg"><input name="roomName" type="text" id="roomName" value="<%=roomName%>" size="40">将":"前面的替换成后面的,用","分隔<br>
          示例：＂四川:,北京:南京＂　作用:将机房名称中的&quot;四川&quot;替换成空,&quot;北京&quot;替换成&quot;南京&quot;.</td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">是否启用QQ登陆：</td>
        <td class="tdbg"> <select name="qq_isLogin" id="qq_isLogin">
          <option value="True"<%if qq_isLogin then%> selected<%end if%>>True</option>
          <option value="False"<%if not qq_isLogin then%> selected<%end if%>>False</option>
        </select>
          申请<a href="http://open.qq.com/" target="_blank"><font color="red">开通地址</font></a></td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">QQ_APPID：</td>
        <td class="tdbg"><input name="qq_AppID" type="text" id="qq_AppID" value="<%=qq_AppID%>" size="40"></td>
      </tr>
      <tr>
        <td align="right" nowrap class="tdbg">QQ_Keys：</td>
        <td class="tdbg"><input name="qq_AppKey" type="text" id="qq_AppKey" value="<%=qq_AppKey%>" size="40"></td>
      </tr>
      <tr style="display:none">
        <td align="right" nowrap class="tdbg">QQ_回调地址：</td>
        <td class="tdbg"><input name="qq_returnUrl" type="text" id="qq_returnUrl" value="<%=qq_returnUrl%>" size="40">
        回调地址http://网名地址/reg/returnQQ.asp</td>
      </tr>
      
            <tr>
        <td align="right" nowrap class="tdbg"><p>弹性云主机折扣设置：<br>
          (<font color="red">如不打折请设置为1.00, 9折为0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>级别1
            <input name="diyuserlev1" type="text" id="diyuserlev1" value="<%=diyuserlev1%>" style="width:40px;" maxlength="4">
            
            级别2
            <input name="diyuserlev2" type="text" id="diyuserlev2" value="<%=diyuserlev2%>" style="width:40px;"  maxlength="4">
            
            级别3
            <input name="diyuserlev3" type="text" id="diyuserlev3" value="<%=diyuserlev3%>" style="width:40px;"  maxlength="4">
            
            级别4
            <input name="diyuserlev4" type="text" id="diyuserlev4" value="<%=diyuserlev4%>" style="width:40px;"  maxlength="4">
            
            级别5
            <input name="diyuserlev5" type="text" id="diyuserlev5" value="<%=diyuserlev5%>" style="width:40px;"  maxlength="4">
            <br>
          弹性云主机首月折扣:
          <input name="diyfist" type="text" id="diyfist" value="<%=diyfist%>" style="width:40px;" maxlength="4">
          <label style="color:red">针对所有会员级别，只针对按月新购买（如设置为1将按会员级别折扣执行）</label>>
          </p></td>
      </tr>
        <tr>
        <td align="right" nowrap class="tdbg"><p>弹性云主机折扣设置：<br>
          (<font color="red">如不打折请设置为1.00, 9折为0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>半年:
            <input name="diy_dis_6" type="text" id="diy_dis_6" value="<%=diy_dis_6%>" style="width:40px;" maxlength="4">
            
             1年:
            <input name="diy_dis_12" type="text" id="diy_dis_12" value="<%=diy_dis_12%>" style="width:40px;"  maxlength="4">
            
            2年
            <input name="diy_dis_24" type="text" id="diy_dis_24" value="<%=diy_dis_24%>" style="width:40px;"  maxlength="4">
            
            3年
            <input name="diy_dis_36" type="text" id="diy_dis_36" value="<%=diy_dis_36%>" style="width:40px;"  maxlength="4">
            
            5年
            <input name="diy_dis_60" type="text" id="diy_dis_60" value="<%=diy_dis_60%>" style="width:40px;"  maxlength="4">
         
         
          <label style="color:red">针对所有会员级别</label>
          </p></td>
      </tr>
	   <tr>
        <td align="right" nowrap class="tdbg"><p>云邮局折扣设置：<br>
          (<font color="red">如不打折请设置为1.00, 9折为0.9</font>)<br>
          </p></td>
        <td bgcolor="#FF0000" class="tdbg">
          <p>级别1
            <input name="diyMlev1" type="text" id="diyMlev1" value="<%=diyMlev1%>" style="width:40px;" maxlength="4">
            
            级别2
            <input name="diyMlev2" type="text" id="diyMlev2" value="<%=diyMlev2%>" style="width:40px;"  maxlength="4">
            
            级别3
            <input name="diyMlev3" type="text" id="diyMlev3" value="<%=diyMlev3%>" style="width:40px;"  maxlength="4">
            
            级别4
            <input name="diyMlev4" type="text" id="diyMlev4" value="<%=diyMlev4%>" style="width:40px;"  maxlength="4">
            
            级别5
            <input name="diyMlev5" type="text" id="diyMlev5" value="<%=diyMlev5%>" style="width:40px;"  maxlength="4">

          </p></td>
      </tr>
      <tr>
			<td align="right" nowrap class="tdbg">小程序试用价格</td>
		    <td bgcolor="#FF0000" class="tdbg"><input name="miniprogram_paytype_money" type="text" id="miniprogram_paytype_money" value="<%=miniprogram_paytype_money%>" size="40" style="width:40px;">(<font color="red">小程序试用价格,免费请填写0</font>)</td>
	  </tr>
	   <tr>
			<td align="right" nowrap class="tdbg">小程序短信价格(条)</td>
		    <td bgcolor="#FF0000" class="tdbg"><input name="miniprogram_sms_money" type="text" id="miniprogram_sms_money" value="<%=miniprogram_sms_money%>" size="40"  style="width:40px;">(<font color="red">默认价格为0.1元</font>)</td>
	  </tr>
      
      <tr> 
        <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">
          <input type="submit" name="button" id="button" value=" 确 定 修 改 ">
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
      <td colspan="2"  class="tdbg"><strong>网站业务配置信息</strong></td>
    </tr>
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">独立管理平台的网址：</td>
      <td width="66%" class="tdbg"><input name="manager_url" readonly type="text" id="manager_url" value="<%=manager_url%>" size="40"> *不可修改。</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">是否由上级注册商提供发票：</td>
      <td class="tdbg">
        <select name="fapiao_api" id="fapiao_api">
          <option value="True"<%if fapiao_api=True then%> selected<%end if%>>True</option>
          <option value="False"<%if fapiao_api=False then%> selected<%end if%>>False</option>
        </select>
          选择ture则用户的发票申请将会直接提交至上级服务商。 </td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">发票费率</td>
      <td class="tdbg"><input name="fapiao_cost_feilv" type="text" id="fapiao_cost_feilv" value="<%=formatnumber(fapiao_cost_feilv,2,-1,-1)%>" size="3">
        若希望客户提交发票时，收取相应税率请设置，如0.06(不支持提现)</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">免费提供挂号/平信邮寄发票的最低金额：</td>
      <td class="tdbg">
        <input name="fapiao_cost_leve" type="text" id="fapiao_cost_leve" value="<%=fapiao_cost_leve%>" size="3">
        元 。<font color=red>现已不免费提供发票,详细费率请咨询渠道专员</font>，挂号信或平信将收费,具体收费金额如下:</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">挂号信收费：</td>
      <td class="tdbg">
        <input name="fapiao_cost_0" type="text"  value="<%=fapiao_cost_0%>" size="3">
元。用户申请的发票金额低于上边设置时，则按此收费;高于最低金额时则免费。</td>
    </tr>    
    <tr>
      <td align="right" nowrap  class="tdbg">快递收费：</td>
      <td class="tdbg">
        <input name="fapiao_cost_1" type="text" id="fapiao_cost_1" value="<%=fapiao_cost_1%>" size="3">
元。当用户要求快递发票时，按此收费。</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">到付收费：</td>
      <td class="tdbg">
        <input name="fapiao_cost_2" type="text" id="fapiao_cost_2" value="<%=fapiao_cost_2%>" size="3">
        元。默认不收费，收到快递后由用户自行付费。</td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">平信收费：</td>
      <td class="tdbg">
        <input name="fapiao_cost_3" type="text" id="fapiao_cost_3" value="<%=fapiao_cost_3%>" size="3">
元 。用户申请的发票金额低于最低金额，则按此收费;高于最低收费金额时则免费。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">独立IP主机首月折扣：</td>
      <td class="tdbg"><input name="firstvpsdiscount" type="text" id="firstvpsdiscount" value="<%=formatnumber(firstvpsdiscount,2,-1,-1)%>" size="3"> 如不打折请设置为1, 9折为0.9.
          </td>
    </tr>
     <tr  style="color:red">
      <td align="right" nowrap class="tdbg">弹性云主机试用价格（直接客户）：</td>
      <td class="tdbg"><input name="diypaytestPrice" type="text" id="diypaytestPrice" value="<%=diypaytestPrice%>" size="3">
          元，如不知试用价格请咨询您的渠道经理</td>
    </tr>
        <tr  style="color:red">
      <td align="right" nowrap class="tdbg">弹性云主机试用价格（代理客户）：</td>
      <td class="tdbg"><input name="diypaytestDLPrice" type="text" id="diypaytestDLPrice" value="<%=diypaytestDLPrice%>" size="3">
          元，如不知试用价格请咨询您的渠道经理</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">开通试用主机收费：</td>
      <td class="tdbg"><input name="demoprice" type="text" id="demoprice" value="<%=demoprice%>" size="3">
          元。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">开通试用Mssql收费：</td>
      <td class="tdbg"><input name="demomssqlprice" type="text" id="demomssqlprice" value="<%=demomssqlprice%>" size="3">
          元。</td>
    </tr>  
    <tr>
      <td align="right" nowrap class="tdbg">开通试用邮局收费：</td>
      <td class="tdbg"><input name="demomailprice" type="text" id="demomailprice" value="<%=demomailprice%>" size="3">
          元。</td>
    </tr>    
    <tr>
      <td align="right" nowrap class="tdbg">默认注册等级：</td>
      <td class="tdbg"><input name="reguser_level" type="text" id="reguser_level" value="<%=reguser_level%>" size="3">
          默认为1,表示直接客户。</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg" height="33">域名查询接口：</td>
        <td  class="tdbg" height="33">
        <select name="whoisapi">
        <option value="1" <%if whoisapi=1 then response.write "selected"%>>西部数码接口</option>
        <option value="2" <%if whoisapi=2 then response.write "selected"%>>  万网接口  </option>
        <option value="3" <%if whoisapi=3 then response.write "selected"%>>时代互联接口</option>
        <option value="4" <%if whoisapi=4 then response.write "selected"%>>时代互联网站</option>
        </select>
       </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">新注册的用户能否直接开通试用主机：</td>
      <td class="tdbg">
              <select name="reguser_try" id="reguser_try">
          <option value="True"<%if reguser_try=True then%> selected<%end if%>>直接开通</option>
          <option value="False"<%if reguser_try=False then%> selected<%end if%>>须审核后</option>
        </select>

      true表示可以开，false表示需要管理员审核后才能开试用</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">域名DNS1地址：</td>
      <td class="tdbg"><input name="ns1" type="text" id="ns1" value="<%=ns1%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">域名DNS1IP：</td>
      <td class="tdbg"><input name="ns1_ip" type="text" id="ns1_ip" value="<%=ns1_ip%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">域名DNS2地址：</td>
      <td class="tdbg"><input name="ns2" type="text" id="ns2" value="<%=ns2%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">域名DNS2IP：</td>
      <td class="tdbg"><input name="ns2_ip" type="text" id="ns2_ip" value="<%=ns2_ip%>"></td>
    </tr>
    <tr>
    <td class="tdbg">&nbsp;</td><td class="tdbg">请设置域名[转入续费]的价格(不分用户等级)，请不要将此价格设置跟[直接续费]价一样<br>建议将[直接续费]价提高1~5元。或[转入续费]价降低1~5元，将域名转入我司可获得更多实惠和强大功能。</td>

    </tr>
    	<tr>
      <td align="right" nowrap class="tdbg">国际英文域名：</td>
      <td class="tdbg"><input name="trainsin_domcom" size="7" type="text" id="trainsin_domcom" value="<%=trainsin_domcom%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">国际中文域名：</td>
      <td class="tdbg"><input name="trainsin_domhz" size="7" type="text" id="trainsin_domhz" value="<%=trainsin_domhz%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">国内CN域名：</td>
      <td class="tdbg"><input name="trainsin_domcn" size="7" type="text" id="trainsin_domcn" value="<%=trainsin_domcn%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">国内中文域名：</td>
      <td class="tdbg"><input name="trainsin_domchina" size="7" type="text" id="trainsin_domchina" value="<%=trainsin_domchina%>"></td>
    </tr>
        <tr>
      <td align="right" nowrap class="tdbg">国际org域名：</td>
      <td class="tdbg"><input name="trainsin_domorg" size="7" type="text" id="trainsin_domorg" value="<%=trainsin_domorg%>"></td>
    </tr>
        
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button2" id="button2" value=" 确 定 修 改 ">
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
      <td colspan="2"  class="tdbg"><strong>网站邮件和短信发送参数</strong></td>
    </tr>
   
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">发件人地址：</td>
      <td width="66%" class="tdbg"><input name="mailfrom" type="text" id="mailfrom" value="<%=mailfrom%>">&nbsp;&nbsp;&nbsp;别名：<input name="sendmailname" type="text" id="sendmailname" value="<%=sendmailname%>"><a href="http://help.west.cn/help/list.asp?unid=412" target="_blank" style="color:red">邮箱设置帮助</a></td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">SMTP服务器地址：</td>
      <td class="tdbg"><input name="mailserverip" type="text" id="mailserverip" value="<%=mailserverip%>">端口:<input name="mailport" type="text" id="mailport" value="<%=mailport%>"> SSL: <select name="mailssl" id="mailssl">
          <option value="True"<%if mailssl then%> selected<%end if%>>启用</option>
          <option value="False"<%if not mailssl then%> selected<%end if%>>禁用</option>
        </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SMTP用户名：</td>
      <td class="tdbg"><input name="mailserveruser" type="text" id="mailserveruser" value="<%=mailserveruser%>">  &nbsp;&nbsp;<input type="button" value="测试发送" onclick="sendmial('<%=mailserveruser%>')"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SMTP密码：</td>
      <td  class="tdbg"><input name="mailserverpassword" type="password" id="mailserverpassword" value="<%=mailserverpassword%>"></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
        <td class="tdbg">以上信息必须配置正常才能给客户自动发送邮件，默认的agentuser@west263.com若不修改将无法自动发邮件！<BR><br>
<a href="http://help.west.cn/help/list.asp?unid=432" target="_blank" style="color:red">独立服务器自动发送邮件配置说明！</a>
</td>
    </tr>
    <tr height=50>
    <td align="right" nowrap class="tdbg">有问必答提醒：<BR>(<font color="red">请录入邮箱地址</font>)</td>
    <td class="tdbg"><input type="text" name="questionMail" value="<%=questionMail%>"><span>当用户在代理平台提示有问必时给管理员发送提醒邮件，为空不发送！</span></td>
    </tr>
    
    
 <tr>
      <td align="right" nowrap class="tdbg">抄送邮件：</td>
      <td  class="tdbg"><input name="sendmailcc" type="text" id="sendmailcc" value="<%=sendmailcc%>"> 如不填写将不抄送邮件，多抄送邮件请用";"分隔（注所有邮件都将抄送一份）！</td>
    </tr>

	<tr>
        <td align="right" nowrap class="tdbg">短信接口类型：</td>
        <td class="tdbg">
		<select name="sms_type">
			<option value="west"  <%if Trim(sms_type)="west" Then Response.write("selected") End if%>>西部数码</option>
			<option value="user"  <%if Trim(sms_type)="user" Then Response.write("selected") End if%>>用户自定义</option>
			<option value="smsbao" <%if Trim(sms_type)="smsbao" Then Response.write("selected") End if%>>短信宝(成功返回(0))</option>
			<option value="chanyoo" <%if Trim(sms_type)="chanyoo" Then Response.write("selected") End if%>>畅友网络成功返回(>=0)</option>
		</select> 
      </td>
    </tr>

	<tr>
        <td align="right" nowrap class="tdbg">发送短信地址：</td>
        <td class="tdbg" >
		<input name="sms_url" type="text" id="sms_url" value="<%=sms_url%>"> {u}:api帐号 {p}:api密码   {m}:手机号码  {c} :发送内容 http://xx.xxx.xx/sms?u={u}&p={p}&m={m}&c={c}
      </td>
    </tr>
    
	<tr>
        <td align="right" nowrap class="tdbg">短信签名：</td>
      <td class="tdbg"><input name="sms_sign" type="text" id="sms_sign" value="<%=sms_sign%>"> </td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">短信帐号：</td>
      <td class="tdbg"><input name="sms_mailname" type="text" id="sms_mailname" value="<%=sms_mailname%>"> </td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">短信密码：</td>
      <td class="tdbg"><input name="sms_mailpwd" type="text" id="sms_mailpwd" value="<%=sms_mailpwd%>"> (注:短信宝密码为md5( 密码)) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">是否开启短信通知：</td>
      <td class="tdbg">
<select name="sms_note" id="sms_note">
    <option value="True"<%if sms_note=True then%> selected<%end if%>>是</option>
    <option value="False"<%if sms_note=False then%> selected<%end if%>>否</option>
</select>
      默认是否开启短信通知。短信通知用于：用户找回密码、过期续费通知等地方。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button3" id="button3" value=" 确 定 修 改 ">
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
      <td colspan="2"  class="tdbg"><strong>系统设置</strong></td>
    </tr>
    
 
    
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">Logo路径：</td>
      <td width="66%" class="tdbg"><input name="logimgPath" type="text" id="logimgPath" value="<%=logimgPath%>" size="40"></td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">FSO组件名称：</td>
      <td class="tdbg"><input name="objName_FSO" type="text" id="objName_FSO" value="<%=objName_FSO%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">后台管理路径：</td>
      <td  class="tdbg"><input name="SystemAdminPath" type="text" id="SystemAdminPath" value="<%=SystemAdminPath%>">
          系统安装时填写，平时一般不要修改。 </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SiteMapXML路径：</td>
      <td  class="tdbg"><input name="strXMLFilePath" type="text" id="strXMLFilePath" value="<%=strXMLFilePath%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">SiteMapXSL路径：</td>
      <td  class="tdbg"><input name="strXSLFilePath" type="text" id="strXSLFilePath" value="<%=strXSLFilePath%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">上级API接口路径：</td>
      <td class="tdbg"><input name="api_url" type="text" id="api_url" value="<%=api_url%>" size="40"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">API用户名：</td>
      <td class="tdbg"><input name="api_username" type="text" id="api_username" value="<%=api_username%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">API密码：</td>
      <td class="tdbg">
          <input name="api_password" type="password" id="api_password" value="<%=api_password%>">
          (在管理中心&gt;代理商管理&gt;api配置 里面设置的密码) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg"><font color="red">登陆验证码：</font></td>
      <td class="tdbg">
           <select name="showsafecode">
           <option value="false" <%if not showsafecode then response.Write("selected") %>>关闭</option>
           <option value="true" <%if showsafecode then response.Write("selected") %>>开启</option>
           </select>
          (开启此功能后。如登陆错误3次或ip登陆失败超20次将要求录入验证码.) </td>
    </tr>
  <tr>
      <td align="right" nowrap class="tdbg"> 用户手机实名认证</td>
      <td class="tdbg">
           <select name="issetauthmobile">
           <option value="false" <%if not issetauthmobile then response.Write("selected") %>>关闭</option>
           <option value="true" <%if issetauthmobile then response.Write("selected") %>>开启</option>
           </select>
          (开启此功能后。登陆管理中心会要求用户实名认证) </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">自动通过api接口开通的业务种类：</td>
      <td class="tdbg">
      <input name="api_autoopen" type="checkbox" id="checkbox" value="domain"<%if instr(api_autoopen,"domain")<>0 then%> checked<%end if%>>域名注册
      <input name="api_autoopen" type="checkbox" id="checkbox" value="vhost"<%if instr(api_autoopen,"vhost")<>0 then%> checked<%end if%>>虚拟主机

      <input name="api_autoopen" type="checkbox" id="checkbox" value="mail"<%if instr(api_autoopen,"mail")<>0 then%> checked<%end if%>>企业邮箱
      <input name="api_autoopen" type="checkbox" id="checkbox" value="mssql"<%if instr(api_autoopen,"mssql")<>0 then%> checked<%end if%>>MSSQL数据库
      
      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">是否为下级代理提供API接口：</td>
      <td class="tdbg">
<select name="api_open" id="api_open">
    <option value="True"<%if api_open=True then%> selected<%end if%>>是</option>
    <option value="False"<%if api_open=False then%> selected<%end if%>>否</option>
</select>(API接口地址：http://<%=request.ServerVariables("SERVER_NAME")%>/api/main.asp)
      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">需要提交到上级注册商的问题：</td>
      <td class="tdbg"><select name="Qustion_Upload" size="1" multiple id="Qustion_Upload" style="height:130px">
        <option value="0102"<%if instr(Qustion_Upload,"0102")<>0 then%> selected<%end if%>>虚拟主机问题</option>
		 <option value="142"<%if instr(Qustion_Upload,"142")<>0 then%> selected<%end if%>>云建站</option>
        <option value="0103"<%if instr(Qustion_Upload,"0103")<>0 then%> selected<%end if%>>域名问题</option>
        <option value="0104"<%if instr(Qustion_Upload,"0104")<>0 then%> selected<%end if%>>企业邮箱问题</option>
        <option value="0201"<%if instr(Qustion_Upload,"0201")<>0 then%> selected<%end if%>>数据库问题</option>
        <option value="0202"<%if instr(Qustion_Upload,"0202")<>0 then%> selected<%end if%>>主机租用/托管问题</option>
        <option value="0203"<%if instr(Qustion_Upload,"0203")<>0 then%> selected<%end if%>>VPS相关问题</option>
        <option value="0302"<%if instr(Qustion_Upload,"0302")<>0 then%> selected<%end if%>>网站推广问题</option>
        <option value="0801"<%if instr(Qustion_Upload,"0801")<>0 then%> selected<%end if%>>其他</option>
        </select>
          提示：按住Ctrl键，可以多选。 </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">是否允许用户申请vcp_C模式代理：</td>
      <td class="tdbg">
<select name="vcp_c" id="vcp_c">
    <option value="True"<%if vcp_c=True then%> selected<%end if%>>是</option>
    <option value="False"<%if vcp_c=False then%> selected<%end if%>>否</option>
</select>
</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">是否允许用户申请vcp_D模式代理：</td>
      <td class="tdbg">
<select name="vcp_d" id="vcp_d">
    <option value="True"<%if vcp_d=True then%> selected<%end if%>>是</option>
    <option value="False"<%if vcp_d=False then%> selected<%end if%>>否</option>
</select></td>
    </tr>
  <tr>
      <td colspan="2" align="center" nowrap class="tdbg">vcp提成设置,提成比例只能设置<font color=red>0到0.5</font>超出无效</td>
      </tr>
 
     <tr>
      <td align="right" nowrap class="tdbg">虚拟主机(%)：</td>
      <td class="tdbg">
      	新购: <input name="vcp_vhost" type="text" id="vcp_vhost" value="<%=vcp_vhost%>" style="width:40px;"> 
        续费: <input name="vcp_rennew_vhost" type="text" id="vcp_rennew_vhost" value="<%=vcp_rennew_vhost%>" style="width:40px;"> 
      </td>
    </tr> 
 
     <tr>
      <td align="right" nowrap class="tdbg">企业邮局(%)：</td>
      <td class="tdbg">
      	新购: <input name="vcp_mail" type="text" id="vcp_mail" value="<%=vcp_mail%>" style="width:40px;"> 
        续费: <input name="vcp_rennew_mail" type="text" id="vcp_rennew_mail" value="<%=vcp_rennew_mail%>" style="width:40px;"> 
      </td>
    </tr>
 
     <tr>
      <td align="right" nowrap class="tdbg">云服务器(%)：</td>
      <td class="tdbg">
      	新购: <input name="vcp_server" type="text" id="vcp_server" value="<%=vcp_server%>" style="width:40px;"> 
        续费: <input name="vcp_rennew_server" type="text" id="vcp_rennew_server" value="<%=vcp_rennew_server%>" style="width:40px;"> 
      </td>
    </tr>
    
    
    
    
    
    <tr>
      <td colspan="2" align="center" nowrap class="tdbg">续费价格是否在邮件显示</td>
      </tr>
    <tr>
      <td align="right" nowrap class="tdbg">域名续费价格：</td>
      <td class="tdbg"><select name="issenddmjg" id="issenddmjg">
        <option value="True"<%if issenddmjg=True then%> selected<%end if%>>是</option>
        <option value="False"<%if issenddmjg=False then%> selected<%end if%>>否</option>
      </select> 
        &nbsp; 是否显示域名续费价格</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">虚拟主机：</td>
      <td class="tdbg"><select name="issendvhjg" id="issendvhjg">
        <option value="True"<%if issendvhjg=True then%> selected<%end if%>>是</option>
        <option value="False"<%if issendvhjg=False then%> selected<%end if%>>否</option>
      </select>
&nbsp; 是否显示虚拟主机续费价格</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">独立服务器或VPS：</td>
      <td class="tdbg"><select name="issendvpsjg" id="issendvpsjg">
        <option value="True"<%if issendvpsjg=True then%> selected<%end if%>>是</option>
        <option value="False"<%if issendvpsjg=False then%> selected<%end if%>>否</option>
      </select>
&nbsp; 是否显示独立服务器或VPS续费价格</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">数据库：</td>
      <td class="tdbg"><select name="issenddbjg" id="issenddbjg">
        <option value="True"<%if issenddbjg=True then%> selected<%end if%>>是</option>
        <option value="False"<%if issenddbjg=False then%> selected<%end if%>>否</option>
      </select>
&nbsp; 是否显示数据库续费价格</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">邮箱：</td>
      <td class="tdbg"><select name="issendmailjg" id="issendmailjg">
        <option value="True"<%if issendmailjg=True then%> selected<%end if%>>是</option>
        <option value="False"<%if issendmailjg=False then%> selected<%end if%>>否</option>
      </select>
&nbsp; 是否显示邮箱续费价格</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button4" id="button4" value=" 确 定 修 改 ">
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
      <td colspan="2"  class="tdbg"><strong>在线支付设置</strong></td>
    </tr>
    <tr>
      <td width="34%" align="right" nowrap  class="tdbg">上级注册商的在线支付接口的地址：</td>
      <td width="66%" class="tdbg"><input name="defaultpay_url" type="text" id="defaultpay_url" value="<%=defaultpay_url%>" size="40">
          <a href="http://help.west.cn/help/list.asp?unid=364" target="_blank"><font color="#0000FF">如何为自己的下级代理平台开通默认支付接口？</font></a>        </td>
    </tr>
    <tr>
      <td align="right" nowrap  class="tdbg">是否使用上级注册商的支付接口：</td>
      <td class="tdbg">
<select name="defaultpay" id="defaultpay">
    <option value="True"<%if defaultpay=True then%> selected<%end if%>>是</option>
    <option value="False"<%if defaultpay=False then%> selected<%end if%>>否</option>
</select>
          无需申请可直接使用，系统自动给您的用户加钱，同时给您在上级注册商的会员帐号充值相同的金额，我司将收取0.6%手续费。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">使用上级注册商的支付接口的费率：</td>
      <td class="tdbg"><input name="defaultpay_fy" type="text" id="defaultpay_fy" value="<%=defaultpay_fy%>" size="6"> *例:千分之一，则填0.001，不能用百分号表达</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td  class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="https://www.tenpay.com/" target="_blank"><font color="#0000FF">财付通</font></a>在线支付：</td>
      <td class="tdbg">
      <select name="tenpay" id="tenpay">
    <option value="True"<%if tenpay=True then%> selected<%end if%>>是</option>
    <option value="False"<%if tenpay=False then%> selected<%end if%>>否</option>
</select>
<a href="http://union.tenpay.com/set_meal_charge/?Referrer=1202215301" target="_blank"><font color="#0000FF">[购买套餐]</font></a>
<a href="http://union.tenpay.com/mch/mch_index1.shtml?sp_suggestuser=1202215301" target="_blank"><font color="#0000FF">免费申请</font></a>一个财付通帐户，支付手续费较低,强烈<font color="#FF0000">推荐</font>使用。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">财富通手续费率：</td>
      <td class="tdbg"><input name="tenpay_fy" type="text" id="tenpay_fy" value="<%=tenpay_fy%>" size="6">  *例:千分之一，则填0.001，不能用百分号表达</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户号：</td>
      <td class="tdbg"><input name="tenpay_userid" type="text" id="yeepay_userid" value="<%=tenpay_userid%>">财付通支付：如出现<a href="http://help.west.cn/help/list.asp?unid=430" target="_blank" style="color:red">“您正在进行的交易存较大风险”</a> 帮助</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="tenpay_userpass" type="text" id="tenpay_userpass" value="<%=tenpay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="http://wwww.yeepay.com" target="_blank"><font color="#0000FF">易宝</font></a>支付：</td>
      <td class="tdbg"><select name="yeepay" id="yeepay">
    <option value="True"<%if yeepay=True then%> selected<%end if%>>是</option>
    <option value="False"<%if yeepay=False then%> selected<%end if%>>否</option>
</select>
          需要在服务器上注册易宝公司的加密组件。</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">易宝支付手续费率：</td>
      <td class="tdbg"><input name="yeepay_fy" type="text" id="yeepay_fy" value="<%=yeepay_fy%>" size="6"> *例:千分之一，则填0.001，不能用百分号表达</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户号：</td>
      <td class="tdbg"><input name="yeepay_userid" type="text" id="yeepay_userid" value="<%=yeepay_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="yeepay_userpass" type="text" id="yeepay_userpass" value="<%=yeepay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="http://www.alipay.com.cn" target="_blank"><font color="#0000FF">支付宝</font></a>：</td>
      <td class="tdbg">
          <select name="alipay" id="alipay">
            <option value="True"<%if alipay=True then%> selected<%end if%>>是</option>
            <option value="False"<%if alipay=False then%> selected<%end if%>>否</option>
          </select>
<!--             <font color="red">只支持支付宝<strong>即时到帐接口</strong></font>
      <a href="http://www.west263.com/faq/list.asp?unid=460" target="_blank" style="color:#06F">点此申请西部数码支付宝接口特别通道，最低0.8%手续费</a>--></td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="https://b.alipay.com/order/signLogin.htm?action=newsign&productId=2011042200323155" target="_blank"><font color="#0000FF">支付宝快捷登陆</font></a>：</td>
      <td class="tdbg">
          <select name="alipaylog" id="alipaylog">
            <option value="True"<%if alipaylog=True then%> selected<%end if%>>是</option>
            <option value="False"<%if alipaylog=False then%> selected<%end if%>>否</option>
          </select>
         必须到支付宝申请后才能使用<a href="https://b.alipay.com/order/signLogin.htm?action=newsign&productId=2011042200323155" target="_blank" style="color:#06F">点此申请</a></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">支付宝显示名称：</td>
      <td class="tdbg"><input name="alipayName" type="text" id="alipayName" value="<%=alipayName%>"  > *支付宝显示的名称</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">支付宝类型：</td>
      <td class="tdbg">
	   <select name="alipay_type" id="alipay_type">
            <option value=""<%if alipay_type="" then%> selected<%end if%>>即时到帐</option>
            <option value="SELLER_PAY"<%if alipay_type="SELLER_PAY" then%> selected<%end if%>>双功能收款</option>
			 <option value="DBSELLER_PAY"<%if alipay_type="DBSELLER_PAY" then%> selected<%end if%>>担保交易</option>

          </select>如果选双功能接口，用户使用担保交易支付成功，需要您手工给客户帐号充值，系统不会自动入帐。
	   </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">支付宝支付手续费率：</td>
      <td class="tdbg"><input name="alipay_fy" type="text" id="alipay_fy" value="<%=alipay_fy%>" size="6"> *例:千分之一，则填0.001，不能用百分号表达</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">支付宝帐号：</td>
      <td class="tdbg"><input name="alipay_account" type="text" id="alipay_account" value="<%=alipay_account%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户号：</td>
      <td class="tdbg"><input name="alipay_userid" type="text" id="alipay_userid" value="<%=alipay_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="alipay_userpass" type="text" id="alipay_userpass" value="<%=alipay_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="http://www.99bill.com" target="_blank"><font color="#0000FF">快钱v1.0</font></a>：</td>
      <td class="tdbg"><select name="kuaiqian" id="kuaiqian">
          <option value="True"<%if kuaiqian=True then%> selected<%end if%>>是</option>
          <option value="False"<%if kuaiqian=False then%> selected<%end if%>>否</option>
      </select>
      请确认您的快钱账号是否支持v1.0版本      </td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">快钱支付手续费率：</td>
      <td class="tdbg"><input name="kuaiqian_fy" type="text" id="kuaiqian_fy" value="<%=kuaiqian_fy%>" size="6"> *例:千分之一，则填0.001，不能用百分号表达</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户号：</td>
      <td class="tdbg"><input name="kuaiqian_userid" type="text" id="kuaiqian_userid" value="<%=kuaiqian_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="kuaiqian_userpass" type="text" id="kuaiqian_userpass" value="<%=kuaiqian_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" nowrap class="tdbg">是否使用<a href="http://www.99bill.com" target="_blank"><font color="#0000FF">快钱v2.0</font></a>：</td>
      <td class="tdbg"><select name="kuaiqian2" id="kuaiqian2">
          <option value="True"<%if kuaiqian2=True then%> selected<%end if%>>是</option>
          <option value="False"<%if kuaiqian2=False then%> selected<%end if%>>否</option>
      </select>请确认您的快钱账号是否支持v2.0版本</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">快钱支付手续费率：</td>
      <td class="tdbg"><input name="kuaiqian2_fy" type="text" id="kuaiqian2_fy" value="<%=kuaiqian2_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户号：</td>
      <td class="tdbg"><input name="kuaiqian2_userid" type="text" id="kuaiqian2_userid" value="<%=kuaiqian2_userid%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="kuaiqian2_userpass" type="text" id="kuaiqian2_userpass" value="<%=kuaiqian2_userpass%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">合作伙伴ID：</td>
      <td class="tdbg"><input name="kuaiqian2_pid" type="text" id="kuaiqian2_pid" value="<%=kuaiqian2_pid%>">如未和快钱签订代理合作协议,不需要填写本参数</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">是否使用<span class="STYLE4">云网</span>：</td>
      <td class="tdbg"><select name="cncard" id="cncard">
        <option value="True"<%if cncard=True then%> selected<%end if%>>是</option>
        <option value="False"<%if cncard=False then%> selected<%end if%>>否</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">云网支付手续费率：</td>
      <td class="tdbg"><input name="cncard_fy" type="text" id="cncard_fy" value="<%=cncard_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户编号：</td>
      <td class="tdbg"><input name="cncard_cmid" type="text" id="cncard_cmid" value="<%=cncard_cmid%>">
        云网商户编号</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="cncard_cpass" type="text" id="cncard_cpass" value="<%=cncard_cpass%>">
        云网支付密钥</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>

    <tr>
        <td align="right" nowrap class="tdbg">是否使用<span class="STYLE4">微信</span>：</td>
        <td class="tdbg"><select name="wxpay" id="wxpay">
            <option value="True"<%if wxpay=True then%> selected<%end if%>>是</option>
            <option value="False"<%if wxpay=False then%> selected<%end if%>>否</option>
        </select></td>
        </tr>
   <tr>
      <td align="right" nowrap class="tdbg">微信手续费：</td>
      <td class="tdbg"><input name="wxpay_fy" type="text" id="wxpay_fy" value="<%=wxpay_fy%>" ></td>
    </tr>
        
      <tr>
      <td align="right" nowrap class="tdbg">微信AppID：</td>
      <td class="tdbg"><input name="wxpay_appid" type="text" id="wxpay_appid" value="<%=wxpay_appid%>" ></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">微信商户号：</td>
      <td class="tdbg"><input name="wxpay_MchID" type="text" id="wxpay_MchID" value="<%=wxpay_MchID%>">
        微信商户号</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">微信商户Key：</td>
      <td class="tdbg"><input name="wxpay_MchKey" type="text" id="wxpay_MchKey" value="<%=wxpay_MchKey%>">
       在 微信支付后台 \ 帐户中心 \ API安全，设置 API密钥 中设置</td>
    </tr>
	 <tr>
      <td align="right" nowrap class="tdbg">微信回调地址：</td>
      <td class="tdbg"><input name="wxpay_callback" type="text" id="wxpay_callback" value="<%=wxpay_callback%>">
       http://xxxxxx/api/weixin/return.asp</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>




    <tr>
      <td align="right" nowrap class="tdbg">是否使用<a href="http://www.chinabank.com.cn/" target="_blank"><span class="STYLE4">网银在线</span></a>：</td>
      <td class="tdbg"><select name="chinabank" id="chinabank">
        <option value="True"<%if chinabank=True then%> selected<%end if%>>是</option>
        <option value="False"<%if chinabank=False then%> selected<%end if%>>否</option>
      </select></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">网银在线支付手续费率：</td>
      <td class="tdbg"><input name="chinabank_fy" type="text" id="chinabank_fy" value="<%=chinabank_fy%>" size="6"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户编号：</td>
      <td class="tdbg"><input name="chinabank_cmid" type="text" id="chinabank_cmid" value="<%=chinabank_cmid%>">
        网银在线商户编号</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">商户密匙：</td>
      <td class="tdbg"><input name="chinabank_cpass" type="text" id="chinabank_cpass" value="<%=chinabank_cpass%>">
        网银在线支付密钥</td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">是否使用<a href="https://www.shengpay.com" target="_blank"><span class="STYLE4">盛付通</span></a></td>
      <td class="tdbg"><select name="shengpay" id="shengpay">
        <option value="True"<%if shengpay=True then%> selected<%end if%>>是</option>
        <option value="False"<%if shengpay=False then%> selected<%end if%>>否</option>
      </select></td>
    </tr>
       <tr>
      <td align="right" nowrap class="tdbg">盛付通费率</td>
      <td class="tdbg"><input name="shengpay_fy" type="text" id="shengpay_fy" value="<%=shengpay_fy%>"></td>
    </tr>
     <tr>
      <td align="right" nowrap class="tdbg">盛付通编号</td>
      <td class="tdbg"><input name="shengpay_MerId" type="text" id="shengpay_MerId" value="<%=shengpay_MerId%>"></td>
    </tr>
    <tr>
      <td align="right" nowrap class="tdbg">盛付通密码</td>
      <td class="tdbg"><input name="shengpay_Md5Key" type="text" id="shengpay_Md5Key" value="<%=shengpay_Md5Key%>"></td>
    </tr>
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    
    <tr>
      <td align="right" nowrap class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button5" id="button5" value=" 确 定 修 改 ">
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
        <td colspan="2"  class="tdbg"><strong>直接使用域名注册商</strong></td>
      </tr>
      <tr> 
        <td colspan="2" align="right" nowrap  class="tdbg">提示：大多数时候不需要设置此栏，除非您需要直接使用万网等公司的接口。设置好参数后，还需要<a href="SetRegister.asp"><font color="#0000FF">设置各域名的注册接口</font></a>。</td>
      </tr>
      <tr> 
        <td width="34%" align="right" nowrap  class="tdbg">是否使用西部数码的DNS管理器：</td>
        <td width="66%" class="tdbg"> 
          <select name="using_dns_mgr" id="using_dns_mgr">
            <option value="True"<%if using_dns_mgr=True then%> selected<%end if%>>是</option>
            <option value="False"<%if using_dns_mgr=False then%> selected<%end if%>>否</option>
          </select>
          使用其他域名注册接口时，是否使用我司的DNS管理器。</td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">默认DNS1：</td>
        <td class="tdbg"> 
          <input name="default_dns1" type="text" id="default_dns1" value="<%=default_dns1%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">默认DNS2：</td>
        <td class="tdbg"> 
          <input name="default_dns2" type="text" id="default_dns2" value="<%=default_dns2%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">默认DNS ip1：</td>
        <td class="tdbg"> 
          <input name="default_ip1" type="text" id="default_ip1" value="<%=default_ip1%>">
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="tdbg">默认DNS ip2：</td>
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
          <input type="submit" name="button5" id="button5" value=" 确 定 修 改 ">
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
		var m_=prompt("请先保存数据后再操作!请填写接收邮件的邮箱地址,",mail)
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
