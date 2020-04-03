<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
act=requesta("act") : randomize : rndx = int(rnd*100)
domainid = requesta("DomainID")

If Not IsNumeric(domainid&"") Then url_return "参数错误",-1
oldurl	= "renewDomain.asp?domainid=" & domainid
If requesta("q")="yes" Then response.Redirect oldurl
if instr(lcase(api_url),"api.west263.com")=0 Then response.Redirect oldurl
user_name = session("user_name") : user_id  = session("u_sysid")
renewYear = 1
myauthcode = request("authcode")

conn.open constr
sql="select top 1 * from domainlist where d_id=" & domainid & " and userid=" & user_id & " and isreglocal=0"
rs.open sql,conn,1,1
If rs.eof Then Response.Redirect oldurl
For i=0 to rs.Fields.Count-1
	execute( "fo_" & rs.Fields(i).Name & "=rs.Fields(" & i & ").value")
Next
rs.close
domain  = fo_strDomain : strDomain=domain

if instr(",1,11,9,12,",","&fo_tran_state&",")>0 then url_return "该域名已申请转入，周期约为5-30天，若处理时间过长请联系管理员",-1
upState =  getDomTransState(domain)
if instr(",1,11,9,12,", ","&upState&",")>0 then url_return "该域名已申请转入，周期约为5-30天，若处理时间过长请联系管理员",-1

domtype = lcase(fo_proid)
channel = getW2Channel(domain)
if datediff("d",fo_regdate,date())<=60 then errmsg=errmsg+"<li>域名注册未满60天，为防止续费失败，请等60天后再来续费转移。</li>"'几乎不可能
 

if channel="" then  Response.Redirect oldurl	'我司不支持转移这种域名
If channel="west2" And left(domain,4)="xn--" Then bDomain = gbkcode(domain)
If channel="west2" Or channel="west3" Then needDays1=5 Else needDays1=6
whoismail=fo_dom_em :if whoismail="" then whoismail=fo_admi_en
'if whoismail="" then url_return "域名所有者邮箱错误，请先完善资料",-1

register = getDomReg(strDomain) 
if register="" or left(register,4)="west" then response.Redirect oldurl
if register="webcc" Then response.Redirect oldurl	'20150429

rexpiredate=formatDateTime(DateAdd("yyyy",fo_years,fo_regdate),2)
remainYear = datediff("yyyy",date(),rexpiredate)
leftdays = datediff("d",date(),rexpiredate):leftdays=Cdbl(leftdays)
MaxRenewDate=dateadd("d",3650,now())
MaxRenewDay=Datediff("d",rexpiredate,MaxRenewDate)
remainYear=int(MaxRenewDay/365)
if remainYear=0 then url_return "该域名已经达到最大年限，无法续费",-1

needpass=0		'新 -- 是否需要提供转移密码
if channel="west4" or channel="west5" or ( (channel="west2" or channel="west3") and register="bizcn" ) then needPass=1

checkren=False	'新要求，60天内，不能找到该域名有续费的记录
sql="select 1 from countlist where u_id=" & user_id & " and dateDiff("&PE_DatePart_D&",c_date,"&PE_Now&")<60 and c_memo like 'renew domain%' and u_countid like '%-" & domain & "'"
set trs=conn.execute(sql)
If trs.eof then checkren=true Else errmsg=errmsg+"<li>您的域名最近(60天内)有续费操作，为防止转移续费失败，请60天后执行本操作。</li>"
trs.close

'若有密码，假设国际域名到期前都可以提交, 国内域名已确定必须在6天前，若无密码，需要过期2天前
If leftdays<=0 then errmsg=errmsg+"<li>域名已经过期，请明年提前续费转移(到期前1个月)。</li>"
If leftdays<=2 And needPass=0 Then errmsg=errmsg+"<li>域名可用时间太短，来不及为您索取密码，请明年提前续费转移(到期前1个月)。</li>"
If leftdays<=needDays1 And (channel="west4" Or channel="west5") Then errmsg=errmsg+"<li>域名可用时间太短，请直接续费后明年这个时候提前1个月再转移</li>"

needPrice2 = getNeedPrice(user_name,domtype,1,"renew")	'旧价
domtype_=domtype
if domtype_="domnet" then domtype_="domcom"
needPrice = eval("trainsin_" & domtype_)	'新价

if not isnumeric(needPrice&"") then needPrice=needPrice2
needPrice=ccur(needPrice) : needPrice2=ccur(needPrice2)

if needPrice<1 or needPrice2<1  then response.Write "价格有错误，请联系管理员" : response.End()

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>续费转入</title>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style>
#resultdiv{
	border:1px solid #39F;
	padding:10px;
	margin:10px auto;
	width:750px;
}
a:link,a:visited{
	color:#0080C0;
	text-decoration:underline;
}
a:hover{
	color:red;
	text-decoration:none
}
</style>
</head>

<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" >域名转入并续费</td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' ><!--#include file="../share/AgentPrice.asp"--></td>
  </tr>
</table>

<div id="resultdiv"> 
<div style="color:#004080">
<p>　　友情提示： 
<%if domtype="domcn" or domtype="domchina" then%>
<%=companyname%>已于2011年5月正式通过CNNIC认证
<%else%>
<%=companyname%>已于2011年10月正式通过互联网域名体系最高管理机构ICANN认证
<%end if%>，成为顶级域名注册商。您的域名是在我司通过认证以前通过代理其他域名注册商申请的。为了便于管理，我司强烈建议您将域名转移注册商为我司，转移成功后域名会自动续费一年。</p>
<p>　　我司为此设计了较为优化的流程，您仅需按以下流程进行配合即可轻松将域名转移成功。转移成功后您的域名将获得更低的续费价格和更便捷的服务。</p>
</div>
<hr />

<%if act="" then%>

<form method="post" name="form1" id="form1" onSubmit="return check1()">
<%if errmsg<>"" then%>
	<div style="background:#FFEEF7;padding:10px;">
	<h4 style="color:red;">该域名不符合续费转移条件：</h4>
	<%=errmsg%>
    </div>
<%elseif (domtype="domcn" or domtype="domchina") then%>
<div class="nopassbox">
	<div style="margin-bottom:15px;font-weight:bold"><span style="font-size:14px"><font color="#FF0000">请先按以下流程索取域名转移密码，获取转移密码后即可办理续费转移：<br></font>国内域名"获取转移密码"的基本条件：</span><br />域名注册后已满60日，距该域名到期日25日以上，距域名最后一次转移注册商或续费满60日</div>
<%If leftdays<25 then%>
	<span class='bred'>您的域名距过期时间太短，已经来不及索取密码，如果您已经索取到密码，请直接在下面提交</span>
	<%If leftdays<=needDays1+1 then%>
	<br><span class='bred'>域名即将过期，转移过程中可能会有域名中断访问的现象</span>
	<%End if%>
<%elseif register="xinet" then%>
            <div class="tit">原注册商为新网的域名"索取转移密码"应提交的材料：</div>
　1) 承办人身份证复印件。<br />
　2) 加盖公章或签名的《<a href="http://www.myhostadmin.net/Customercenter/doc/新网CN域名转出申请表.doc" target="_blank">国内域名转移注册商（转出新网）申请表</a>》原件。<br />
　3) 域名所有者公司营业执照副本复印件或者域名所有人身份证复印件。<br />
　4) 加盖公章或签名的《<a href="http://www.myhostadmin.net/Customercenter/doc/新网域名转出授权委托书.doc">授权委托书</a>》原件
<div class="tit">需要注意：</div>
二代身份证需提供正反两面复印件；<br />
营业执照副本复印件或组织机构代码证需盖有效的年检章；<br />
所盖公章内容需与whois域名所有人的中文信息一致；<br />
如果公司为国外企业,无中文信息,或者为国外公司驻中国办事机构,无独立营业执照。请到公司所在国家的中国大使馆开具证明资料。<br />
<hr />
邮寄地址：四川成都市万和路90号天象大厦4楼5号　　收件人：彭蕾　　邮编：610031<br />
公司名称：成都西维数码科技有限公司　　电话：028-86263960－204<br />
            <br />
<strong>A转出确认：</strong>新网收到合格的转出材料后，将向域名的管理人邮箱发送域名转出确认函，如无异议，用户需在规定期限内回复邮件确认同意域名转出。<br />
<strong>B发送转移密码：</strong>新网收到同意转出的确认函后，会在5个工作日内发出域名转移密码至申请表格上所填写邮箱,请注意查收。

<%elseif register="bizcn" then%>
            <div class="tit">原注册商为"商务中国"的际域名转移流程：</div>
　<div style="line-height:25px;">
我司每月1号会主动将40天内到期的域名的转移密码发到域名所有者邮箱，密码15天内有效，建议您收到密码后立即办理续费转移操作，否则密码失效后需要联系商务中国提交各种资料才能获取密码。<br>
		<font color=red>请提前确保您的whois信息中域名所有者邮箱是正确的！</font><br>
		如果没有收到密码，您可使用所有者邮箱，直接发邮件给 trans@west263.com，邮件标题写 商务中国xxx.xxx域名申请转移到西部数码的密码。我司工作人员会直接重发密码。<br><br>
		</div>

<%elseif register="dnscn" then%>
            <div class="tit">原注册商为"新网互联"的际域名转移流程：</div>
 <div style="line-height:25px;">
		<font color=red>请提前确保您的whois信息中域名所有者邮箱是正确的！</font><br>
		 您可使用所有者邮箱，直接发邮件给 trans@west263.com，邮件标题写 商务中国xxx.xxx域名申请转移到西部数码的密码。我司工作人员会直接重发密码。<br><br>
		</div>
<%else%>
	注册商不明确，请联系管理员 <%=register%><br />
<%end if%>
</div>

<%elseif register="bizcn" then%>
	<div class="bizcninfo">
	        <h3>原注册商为"商务中国"的际域名转移流程：</h3>
	<%If leftdays<=7 then%>
        <span class='bred'>您的域名距过期时间太短，已经来不及索取密码，如果您已经索取到密码，请直接在下面提交</span>
        <%If leftdays<=needDays1 then%>
		<br><span class='bred'>域名即将过期，转移过程中可能会有域名中断访问的现象</span>
		<%End if%>
    <%else%>
		 <div style="line-height:25px;">我司每月1号会主动将40天内到期的域名的转移密码发到域名所有者邮箱，密码15天内有效，建议您收到密码后立即办理续费转移操作，否则密码失效后需要联系商务中国提交各种资料才能获取密码。<br>
		<font color=red>请提前确保您的whois信息中域名所有者邮箱是正确的！</font><br>
		如果没有收到密码，您可使用所有者邮箱，直接发邮件给 trans@west263.com，邮件标题写 商务中国xxx.xxx域名申请转移到西部数码的密码。我司工作人员会直接重发密码。<br><br>
		</div>
    <%End if%>
	</div>
<%elseif register="dnscn" then%>
	<div class="bizcninfo">
	        <h3>原注册商为"新网互联"的际域名转移流程：</h3>
	<%If leftdays<=7 then%>
        <span class='bred'>您的域名距过期时间太短，已经来不及索取密码，如果您已经索取到密码，请直接在下面提交</span>
        <%If leftdays<=needDays1 then%>
		<br><span class='bred'>域名即将过期，转移过程中可能会有域名中断访问的现象</span>
		<%End if%>
    <%else%>
		 <div style="line-height:25px;">
		<font color=red>请提前确保您的whois信息中域名所有者邮箱是正确的！</font><br>
		 您可使用所有者邮箱，直接发邮件给 trans@west263.com，邮件标题写 商务中国xxx.xxx域名申请转移到西部数码的密码。我司工作人员会直接重发密码。<br><br>
		</div>
    <%End if%>
	</div>
<%else%>

<div class="choose onchoose"><label class="x"><input type="radio" name="auth" value="yes" checked>方案一：若所有者信箱 <%=whoismail%> 无法接收邮件，您可授权我司全程操作。系统将临时修改您域名的所有人邮箱为trans@west263.com，转移成功后会自动还原为您目前的邮箱。(如果域名转入失败，则将按原价格为您续费，且保持域名原注册商不变)</label>
	<%if register="dnscn" and 1=2 then%>
    <span style="color:red">因新网互联的域名转移流程比较复杂，为方便用户，提高转移效率，请选择授权我司全程操作。</span>
    <%end if%>
</div>
<%end if%>
<div class="fgx"></div>
<div style="padding:10px;font-size:14px;line-height:180%;border-top:1px dashed #B5C5D0;">
<strong>提示：从提交成功的时间起，转入约需<%=needDays1%>天，期间不会影响网站访问。</strong><br />
<%if errmsg<>"" then
	check1="disabled" : check2="checked":needpass=0
else
	check1="checked"  :	check2=""
end if%>
<span class="bluefont">请确认是否转移：</span><label><input type="radio" name="q" value="" <%=check1%> >转移并续费一年<font color="red">[强烈推荐]</font><%=needprice%>元/年</label>&nbsp;&nbsp;&nbsp;<label><input type="radio" name="q" value="yes" <%=check2%>>直接续费不转移</label> <%=needprice2%>元/年。 
<%if needpass=1 then %>
<br /><span class="bluefont">请填写转移密码：</span><input size="25" type="text" name="authcode" style="background:#FFE" />
            <span style="font-size:12px;">*务必填写正确的转移密码，若不知道请先按提示索取转移密码。</span> 
            <%end if%>
          </div>

<div style="text-align:center;padding:20px 10px;">
<input type="submit" value="下一步"  />
<input type="hidden" name="act" value="sub" />
</div>
</form>
<%
Else '————————————————————如果提交了的处理过程——————————

	If needpass=1 And myauthcode = "" Then url_return "必须提供正确的转移密码",-1
	if ccur(session("u_usemoney")) < needPrice  Then url_return "您的余额不足,本次操作需要:" & needPrice & "元",-1

'开始向上提交  -- +预检查
	ishelp = "disabled"
	cmdinfo="domainname" & vbcrlf &_
		"trans" & vbcrlf &_
		"entityname:renin" & vbcrlf &_
		"domain:" & strDomain & vbcrlf &_
		"ishelp:" & ishelp & vbcrlf &_
		"authcode:" & replace(myauthcode,"'","&quot;") & vbcrlf &_
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	retCodestr = replace(retCode,vbcrlf,"")
	if left(retCode,3)<>"200" then url_return "提交失败 " & retCodestr,-1
	
'开始扣费
	randomize:countid="transinD3-" & left(user_name,3) & Replace(Timer&"",".","")
	if not consume(user_name,needprice,false,countid,"转入并续费-"&domain,domtype,"") then
		addRec "域名转入","扣款失败，需手工扣除" & user_name & ", 费用" & needPrice & "元, 域名 " & domain
	end if

'都提前加一年进去
	sql="select years,rexpiredate,tran_state from domainlist where userid=" & user_id & " and d_id=" & domainid
	rs.open sql,conn,1,3
	if not rs.eof then
		rs("years")=rs("years")+1
		rs("rexpiredate")=dateadd("yyyy",1,rs("rexpiredate"))
		rs("tran_state")=11	'标记下他状态为11
		rs.update
	end if
	rs.close
	
%>
    <div class="oksuccess">恭喜您，申请已经提交成功！整个过程约需<%=needDays1%>天左右，您可以在管理中心--业务管理--域名转移列表中查看处理进度，转移成功后系统会邮件通知。<br />如果域名转入失败，则将按原价格为您续费，且保持域名原注册商不变。
    </div>
    <input type="button" value="返回域名管理" onClick="location='/manager/domainmanager/'" /><br /><br />
<%
end if
leftdaystr=leftdays : If leftday<=5 Then leftdaystr="<span class='bred'>" & leftdays & "</span>"
%>
</div>
<center>您的域名(<%If bDomain<>"" Then response.write bDomain Else response.write strDomain%>)距过期还有<%=leftdaystr%>天</center>
<script language="javascript">
	$("#resultdiv label.x").mouseover(function(){
		$(this).css("color","#333");
	}).mouseout(function(){
		$(this).css("color","");
	}).click(function(){
		$(this).parent().addClass("onchoose").siblings().removeClass('onchoose');
	});
function check1(){
	if (form1.q[0].checked){
		<%if (leftdays<=0) then%>
		alert("抱歉，域名已经过期，请明年提前一个月办理转移，谢谢！");
		return false;
		<%elseif not checkren then%>
		alert("抱歉，域名续费后需要满60天才能办理转移，请满60天以后再来办理，谢谢！");
		return false;
		<%elseif needpass=1 then%>
		if (form1.authcode.value=="") {
			alert("请填写域名转移密码，如果不知道请先按说明索取或联系我司客服");
			return false;
		}
		<%end if%>
		if (!confirm('请核实您已经仔细阅读了页面上的相关说明，确认继续吗？')) return false;
	}
	return true;

}
</script>
</body>
</html>


<%
function getDomReg(byval domain)
	if not isdomain(domain) then exit function
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_reg" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,4)="200 " then
		getDomReg=lcase(left(mid(retCode,5),5))
	end if
end function

function getDomTransState(byval domain)
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_state" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	getDomTransState=retCode
end function
%>