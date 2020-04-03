<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
conn.open constr
'新增续费页，检查是否符合转移条件，不符合的则跳出。
DomainID=requesta("DomainID")
action=requesta("act")
if requesta("q")="yes" then response.Redirect "renewDomain.asp?DomainID=" & DomainID
if not isnumeric(DomainID&"") then url_return "参数传递错误a",-1


sql="select * from domainlist where userid=" &  session("u_sysid") & " and d_id=" & DomainID
rs.open sql,conn,1,1
if rs.eof and rs.bof then url_return "没有找到此域名",-1
For i=0 to rs.Fields.Count-1
	Execute( "m_" & rs.Fields(i).Name & "=rs.Fields(" &i& ").value")
Next
rs.close
strDomain=m_strdomain
register=left(m_bizcnorder,5)
up_register = getDomReg(strDomain)

if instr(",11,9,12,",","&m_tran_state&",")>0 then url_return "该域名申请的转入正在处理中，周期约为5-30天！请转成功后再续",-1
if not checkTrans then response.Redirect "renewDomain.asp?DomainID=" & DomainID



if action="sub" then
	'renin 续费转入  newin 外部转入  out  转出    ,get_reg 得到注册商 , get_state 得到转移状态
	ishelp = requesta("ishelp")
	u_name = session("user_name")
	proid  = m_proid	'GetDomainType(strDomain)
	needPrice=getNeedPrice(u_name,proid,1,"renew")	
	if ccur(session("u_usemoney"))<needprice then url_return "抱歉，余额不足，续费一年需要" & needprice & "元",-1
	if isChinese(strDomain) then strDomain=punycode(strDomain)
	if left(strDomain,4)="xn--" then bstrDomain=Gbkcode(strDomain)
	
	cmdinfo="domainname" & vbcrlf &_
		"trans" & vbcrlf &_
		"entityname:renin" & vbcrlf &_
		"domain:" & strDomain & vbcrlf &_
		"ishelp:" & ishelp & vbcrlf &_
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,3)="200" then
		whoismail=mid(retCode,instr(retCode,",")+1)
		countinfo="续费转入-" & strDomain 
		countid=left("translo-" & UCase(left(u_name,10)) & "-" &Cstr(timer()) ,20)
		if not consume(u_name,needprice,false,countid,countinfo,proid,"") then
			addRec "域名续费并转入我司问题", strDomain & "成功申请转入，但用户款未扣成功，请手工核实"		
		end if
		sql="select * from domainlist where d_id=" & domainid
		rs.open sql,conn,1,3
		rs("tran_state")=11
		if request("isbizcn")<>"" then rs("tran_state")=12
		rs("years")=rs("years")+1
		rs("rexpiredate")=dateadd("yyyy",1,rs("rexpiredate"))
		rs.update
		rs.close
		if request("isbizcn")<>"" then
			resultinfo = "恭喜您，申请提交成功，请务必按照上页所提示的转移流程来进行操作，谢谢！"
		elseif ishelp<>"" then
			resultinfo = "恭喜您，申请已经提交成功！整个过程约需5-30天左右，您以后可以在域名转入处查看进度。"
		else
			resultinfo = "我司将在一个工作日内把转移密码发送到该域名所有者信箱" & whoismail & "。请您登录邮箱获取转移密码后，立即进入管理中心-域名转入列表，点击[确认开始转移]。如果您没有进行确认，则域名不会转入也不会续费！若超过1个工作日仍未收到转移密码，请联系我们处理。"
		end if
	else
		resultinfo = "<font color=red>转入申请失败，原因（" & retcode & "），请选择直接续费，谢谢</font>"
	end if
	
end if


sub di_over(str)
	response.Write "<hr>OVER :" & str
	response.end
end sub
	

'————————————————————————————完
function checkTrans()
	checkTrans=false
	if register<>"defau" and register<>"" then exit function
	if cdate(m_regdate)>"2011-5-20" then exit function  	'如果是05/20后注册的域名--跳出/因为肯定是我们的
	if instr(lcase(api_url),"api.west263.com")=0 then exit function		'如果是子代理--跳出
	if datediff("d",m_regdate,date())<=60 then exit function			'新注册60天--跳出
	if datediff("d",m_rexpiredate,date)>=-7 then exit function			'距过期不足7天--跳出
	if m_proid<>"domcom" and m_proid<>"domnet" then exit function		'如果不是com/net域名--跳出
	sql="select 1 from countlist where u_id=" & session("u_sysid") & " and c_memo like 'renew domain%' and dateDiff("&PE_DatePart_D&",c_date,date())<60 and u_countid like '" & strDomain & "%'"
	set trs=conn.execute(sql)
	if not trs.eof then exit function
	trs.close														'最后续费于60天前--跳出
	if up_register="west2" then exit function				'如果注册商已是west2跳出，因为本地没有字段保存必须通过接口查询
	checkTrans=true
end function

function getDomReg(byval domain)
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_reg" & vbcrlf & _
		"domain:" & domain & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
	if left(retCode,4)="200 " then getDomReg=mid(retCode,5)
end function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
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

<%if resultinfo="" then%>

<table WIDTH="99%" BORDER="0" align="center" CELLPADDING="6" CELLSPACING="0" class="border">
<form name="form1" action="/manager/domainmanager/renewDomain_new.asp" method="post">
    <tr >
      <td height="63" class="tdbg"><p style="font-size:12px;font-weight:bold;line-height:180%;">　　友情提示：您的域名是在我司通过认证以前通过代理其他域名注册商申请的。为了便于管理，我司强烈建议您将域名转移注册商为我司，转移成功后域名会自动续费一年。<br>
　　我司为此设计了较为优化的流程，您仅需按以下流程进行配合即可轻松将域名转移成功。 转移成功后您的域名将获得更低的续费价格和更便捷的服务。</p></td>
    </tr>
<%if up_register="bizcn" then%>
<tr>
<td>
<div style="padding-top:10px;color:#00F;font-size:14px;font-weight:bold">商中域名转移流程：</div>
　　1. 下载并填写<a href="http://www.west263.com/customercenter/doc/商务中国域名转移注册商申请表.doc" target="_blank">《商务中国域名转移注册商申请表》</a>，打印后盖章或签字，然后再扫描为图片。<br />
　　2. 扫描域名所有者的证件(个人扫描身份证，企业的扫描营业执照或组织机构代码证)。<br />
　　3. 将以上资料用域名所有者的邮箱发邮件至：mzhtang@bizcn.com ，邮件抄送写1309890865@qq.com，邮件标题写：索取国际域名转移密码！<br />
　　4. 商务中国收到后会发邮件给域名所有者邮箱询问是否同意转出，请及时回复邮件以同意转出。<br />
　　5. 商务中国会在1个工作日左右发转移密码到域名所有者邮箱。获得转移密码后，进行"转移并续费一年"的操作,然后进入管理中心-业务管理-域名转入列表，点击"确认开始转移"，输入转移密码后即可立即开始转移，转移成功后会自动续费一年。 <br />
<br />

<font color="red">特别提示：最好先联系商务中国(www.bizcn.com)成功获得转移密码后再进行"<b>转移并续费一年</b>"的操作</font>。<br />
如果商务中国不积极配合发送转移密码，请电话联系商务中国：0592-2577888 转2308 汤小姐<br />
或者按 <a href="http://www.im286.com/thread-6549097-1-1.html" target="_blank">http://www.im286.com/thread-6549097-1-1.html</a> 的流程对商务中国进行投诉。<br /><input type="hidden" name="isbizcn" value="yes">
</td>
</tr>
<%else%>
    <tr >
      <td class="tdbg">　　<label style="width:70%"><input value="" <%=que1%> type="radio" name="ishelp">        方案一：域名所有人自行收邮件确认：我司将在一个工作日内把转移密码发送到该域名所有者信箱。请您登录邮箱获取转移密码后，立即进入管理中心-业务管理-域名转入列表，点击"确认开始转移"，输入转移密码后即可立即开始转移，转移成功后会自动续费一年。</label></td>
    </tr>
    <tr >
      <td class="tdbg">　　<label style="width:70%"><input value="yes" <%=que2%> type="radio" name="ishelp">
方案二：若域名所有者邮箱无法接收邮件，您可授权我司全程操作。系统将临时修改您域名的所有人邮箱，转移成功后会自动还原为您目前的邮箱。(如果域名转入失败，则将按原价格为您续费，且保持域名原注册商不变)</label></td>
    </tr>
<%end if%>
    <tr >
      <td class="tdbg" style="border-top:1px dashed #4AC5FF">　　请确认是否转移：
          <label>
            <input value="" checked type="radio" name="q">
            转移并续费一年(强烈推荐)</label>
          <label>
            <input value="yes" type="radio" name="q">
            直接续费不转移</label>
       </td>
    </tr>
    <tr >
      <td align="center" class="tdbg"><input type="submit" value="下一步"><input type="hidden" name="act" value="sub"><input type="hidden" name="DomainID" value="<%=DomainID%>"></td>
    </tr>
  </form>
</table>

<%else%>

<center><div style="margin:20px auto;width:500px;border:1px dashed red;padding:20px;color:green;font-weight:bold;">	<%=resultinfo%> <br>
<input type="button" value=" 返回 " onClick="history.back()"></center>

<%end if%>

<!--#include virtual="/config/bottom_superadmin.asp" -->
</body>