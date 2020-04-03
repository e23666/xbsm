<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%Check_Is_Master(3)%>
<script>

function check()
{

	if(formincount.sid4.options[formincount.sid4.selectedIndex].value=="上门交费x" || formincount.sid4.options[formincount.sid4.selectedIndex].value=="邮政汇款x"|| formincount.sid4.options[formincount.sid4.selectedIndex].value=="在线支付x")
	{
		if (PatternMatch(formincount.sid)){
			if (formincount.sid.value=='no-000'){
				alert('请输入编号');
				formincount.sid.focus();
				return false;
			}
			return true;
			}
		else
			return false;
	}


	//PatternMatch(formincount.sid)
}


function PatternMatch(Str){
	var reg=/^no-\d+/;
	if (reg.exec(Str.value)==null){
		alert("模式错误，正确为:no-XXX(其中XXX为数字)");
		Str.value='no-000';
		Str.focus();
		Str.select();
		return false;
		}
	return true;
}
/*
if (formincount.sid.value.indexOf("门")!=-1)
{
	if (!PatternMatch(formincount.sid))
		{
			return false;
		}
}
*/
</script>
<%
'on error resume next
Ident=Ucase(left(Session("user_name"),3)) & "-"

substrings="<input type=submit name=Submit1 value=确定 onClick=""javascript:document.formincount.module.value='incount';"">"
module=Requesta("module")
if module="PayEnd" then
	c_date=Requesta("PayTime")
	If Not isdate(c_date&"") Then c_date=now()
else
	c_date=now()
end if
ssmsg=""
conn.open constr
If module="incount" Then
		isAgent=Requesta("isAgent")
 		u_countid_2=Requesta("sid")
		u_name=Requesta("sid2")

'---------防止同时处理一笔订单。
'response.Write "oldapplication="&Application("incount")
 if instr(Application("incount"),u_name)<>0 then
		mytemp=split(Application("incount"),":")
		
		if session("user_name")<>mytemp(1) then
		response.Write("<script>alert(""其他同事"&mytemp(1)&"正在对该用户入款，请暂时放弃对该用户的入款操作！"");history.back();</script>")
		end if
end if

Application("incount")=Requesta("sid2")&":"&session("user_name")


'---------防止同时处理一笔订单。

		u_countid=Ident & u_countid_2
		u_in=Requesta("sid3")

		u_out=0
		c_date=Requesta("sid5")
		If Not isdate(c_date&"") Then c_date=now()
		c_memo=Requesta("sid4")
		If u_out="" Then u_out=0
		If u_in="" Then u_in=0
		Sql="Select countlist.sysid,countlist.c_dateinput from countlist,userdetail where countlist.u_in=" & u_in & " and countlist.u_id=userdetail.u_id and userdetail.u_name='" & u_name & "' order by countlist.c_dateinput desc"
'		Response.write Sql
  		Rs.open Sql,conn,1,1
			
			
		if not Rs.eof then
		
			Msg2="警告!此用户[" & formatDateTime(Rs("c_dateinput"),2) & "]日已经有一笔相同款项入帐，请检查是否重复处理<br>"
		end if
		Rs.close
'---------检查

		Sql="Select * from ourmoney where PayMethod='" & Requesta("sid4") &"' and Amount=" & u_in & " and datediff("&PE_DatePart_D&",PayDate,'" & Requesta("sid5") & "')=0"
		Rs.open Sql,conn,1,1

		if not Rs.eof then
			AlertMessage="<font color=red><b>警告!</b>" & Requesta("sid4") & "的" & u_in & "元在"&Requesta("sid5")&"已经入过"&rs.RecordCount&"次，如果有"&rs.RecordCount+1&"个"& u_in&"元到帐，再继续入款!"
		end if
		Rs.close
'-------------结束检查

		Sql="Select u_checkmoney,u_contract,u_telphone,u_address,u_memo,u_levelName,u_level,f_id,u_regdate from userdetail where u_name='" & u_name & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then 
			Msg2="警告!未找到此用户"
		else
		''''''''''''''''''''''''''''''''''
			if trim(c_memo)="上门交费" and rs("f_id")>0 then
				'if rs("f_id")>0 then url_return "此用户为vcp用户,不允许采用“上门交费”这种方式",-1
				if isdate(rs("u_regdate")) then
					if datediff("d",rs("u_regdate"),"2007-11-20")=<0 then
						url_return "新注册的VCP子用户,不允许采用“上门交费”这种方式，建议在高级管理>脱离VCP 中脱离后再入款！",-1
					end if
				end if
			end if
		''''''''''''''''''''''''''''''''''
			if Ccur(Rs("u_checkmoney"))>0 then Msg2=Msg2 & "警告!此用户还有" & Rs("u_checkmoney") & "元未审核的金额，看是否有欠款"
			agentLevel=Rs("u_level")
			if Rs("u_level")>1 then
				innerRed="<font color=red>"
				innerRed2="</font>"
			else
				innerRed="":innerRed2=""
			end if
			Mes3="联系人:" & Rs("u_contract") & "<br>电话:" & Rs("u_telphone") & "<br>地址:" & Rs("u_address") & "<br>级别:"& innerRed & rs("u_levelName")  & innerRed2
			userinfo=Rs("u_memo")
		end if
		Rs.close
		
		
		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		
		sql="SELECT countlist.u_moneysum, countlist.u_in, countlist.u_out, countlist.sysid, countlist.c_date FROM (countlist INNER JOIN UserDetail ON countlist.u_id = UserDetail.u_id) WHERE UserDetail.u_name = '"&u_name&"' AND countlist.c_check ="&PE_True&" AND countlist.c_memo = '借款' ORDER BY countlist.c_dateinput DESC"
		
		Rs.open sql,conn,1,1
		
		if not Rs.eof then
			do while not Rs.eof
				Msg4_edward=Msg4_edward & "<input type='checkbox' name='q_money_sysid' value='"&Rs(3)&"' checked>&nbsp;此用户在<font color=ff0000><strong>["& Rs(4) &"]</strong></font>有<font color=ff0000><strong>"&Rs(0)&"</strong></font>元欠款未结<input type='hidden' name='"&Rs(3)&"' value='"&Rs(0)&"'><br>"
			Rs.movenext
			loop
		end if
		
		Rs.close
		'------------------------------------------
		
		
		substrings="<input type=submit name=Submit1 value=款项二次确认 onClick=""javascript:document.formincount.module.value='check';"">"
ElseIf module="check" Then


	isAgent=Requesta("isAgent")
	substrings="<input type=submit name=Submit1 value=再次确认 onClick=""javascript:document.formincount.module.value='check';"">"
	u_countid_2=Requesta("sid")
	u_countid=Ident & u_countid_2
	u_in=Requesta("sid3")
	u_name=Requesta("sid2")
	u_out=Requesta("u_out")
	c_date=Requesta("sid5")
	If Not isdate(c_date&"") Then c_date=now()
	c_memo=Requesta("sid4")
		
		if not isdate(c_date) then
			response.Write("<script>alert(""日期格式错误"");history.back();</script>")
			response.End()
		end if

		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		if c_memo<>"借款" then
			sq_money_sysid=Requesta("q_money_sysid")
			'response.Write(sq_money_sysid)
			'response.End()
			if sq_money_sysid<>"" then
			
			CheckedUnPay=0
			
				sq_money_sysid=replace(sq_money_sysid," ","")
				
				if instr(sq_money_sysid,",")>0 then
					SysId_array=split(sq_money_sysid,",")
					for i=0 to ubound(SysId_array)
						CheckedUnPay=CheckedUnPay+Ccur(Requesta(SysId_array(i)))
					next
				else
					CheckedUnPay=Ccur(Requesta(sq_money_sysid))
				end if
				if CCur(u_in)<CheckedUnPay then
					response.Write("<script>alert(""本次入款金额不够冲抵所选未结金额！"");history.back()</script>")
					response.End()
				end if
			end if
		end if
		
		'response.Write(u_in & "----" &CheckedUnPay)
		'------------------------------------------



	If u_out="" Then u_out=0
	If u_in="" Then u_in=0
	
	sql="select u_countid from countlist where u_countid = '"&u_countid&"'"
	rs.open sql,conn,1,3
	if not rs.eof then
		rs.close
		url_return "凭证编号重复",-1
	end if
	rs.close
	
	if not isdate(c_date) then
		url_return "日期格式错误",-1
	end if
	
	sql="select u_id from userdetail where u_name = '"&u_name&"'"
	rs.open sql,conn,1,3
	if rs.eof then
		rs.close
		url_return "错误用户失败",-1
	else
		u_id=rs("u_id")
	end if
	rs.close
	
	'加款开始
	sql="update Userdetail set u_usemoney = u_usemoney + "&u_in&" - "&u_out&" , u_checkmoney = u_checkmoney  + "&u_in&" - "&u_out&"  where u_name = '"&u_name&"'"
	conn.execute(sql)
	u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&u_name&"'")(0)
	
	Sql="insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput,c_type,o_id,p_proid,u_Balance) values (" & u_id & "," & u_in-u_out & "," & u_in & "," & u_out & ",'" & u_countid & "' , '" & c_memo & "','" & c_date & "',"&PE_Now&" ,8,null,'',"&u_Balance&")"
	conn.execute(sql)



	'加款结束

	'-----如果是在线支付，将该用户在线支付表中的相关记录更改为已处理
		'if c_memo="在线支付" or c_memo="云网支付" or c_memo="支付宝支付" or c_memo="财付通支付" or c_memo="快钱支付" then
			sql="update ring set ring_ov=1 where ring_us='" & u_name & "' and ring_ov=0"
			conn.Execute(Sql)
		'end if

		ssmsg =  "入款成功"
		substrings="<input type=submit name=Submit1 value=确定 onClick=""javascript:document.formincount.module.value='';"">"
		Sql="Select u_email,u_contract from userdetail where u_name='" & u_name & "'"
		Rs.open Sql,conn,1,1
		if not Rs.eof then
			
			getStr="user_name="&u_name&","& _
					"dateTime="&formatDateTime(c_date,1)&","& _
					"paytype="&c_memo&","& _
					"incount="&u_in
			
			mailbody=redMailTemplate("payConfirm.txt",getStr)
			call sendMail(Rs("u_email"),"您的汇款已收到!",mailbody)
			ssmsg = ssmsg & ",并已发送邮件通知"
		end if
		Rs.close
		

		Application("incount")="over"

		'------------------------
		'Edward 2006-6-1
		'写入流水帐
		if c_memo<>"借款" then
			if A_name="" then 
				A_name=Requesta("sid2")
			end if
			Sql="Insert into OurMoney([Name],[UserName],[Paymethod],[Amount],[PayDate],[Orders],[Memo],ismove) values('" & A_name &"','" & Requesta("sid2") &"','" & Requesta("sid4") & "'," & Requesta("sid3") & ",'" & Requesta("sid5") & "','" & Requesta("Orders") & "','" & Requesta("sid4") &"',"&Requesta("ismove")&")"
			conn.Execute(Sql)
		  if isNumeric(Requesta("PayendID")) and Requesta("PayendID")<>"" then
				Sql="Update PayEnd Set P_state=1 Where id=" & Requesta("PayendID")
				conn.Execute(Sql)
		  end if
		end if

		'------------------------------------------
		'Modify By Edward.Yang on 2006-3-1
		if c_memo<>"借款" then
			sq_money_sysid=Requesta("q_money_sysid")
			'response.Write(sq_money_sysid)
			'response.End()
			if sq_money_sysid<>"" then
			
			'Response.Write(u_name)
			'response.End()
			sql="SELECT u_id FROM UserDetail where u_name='"&u_name&"'"
			Rs.open sql,conn,1,1
			if not Rs.eof then
				edward_u_id=Rs(0)
					
				CheckedUnPay=0
				
					sq_money_sysid=replace(sq_money_sysid," ","")
					
					if sq_money_sysid<>"" then
						SysId_array=split(sq_money_sysid,",")
						for i=0 to ubound(SysId_array)
							CheckedUnPay=Requesta(SysId_array(i))
							'更新表用户表
					
							conn.execute("update userdetail set u_usemoney=u_usemoney-" & CheckedUnpay & ",u_checkmoney=u_checkmoney-" & CheckedUnPay & " where u_id=" & edward_u_id)
							
							'插入一条财务记录
							DateRadom=GetDateRadom()
							sql="INSERT INTO countlist (u_id, u_moneysum, u_in, u_out, u_countId, c_memo, c_check, c_date, c_dateinput, c_datecheck, c_type, o_id, p_proid, c_note) VALUES ("&edward_u_id&","&CheckedUnPay&",0,"&CheckedUnPay&",'"&DateRadom&"','支付欠款',0,'"&now()&"','"&now()&"','"&now()&"',1,4735,'FR001',0)"
							conn.execute(sql)
							
							'将借款记录改为已审核
							sql="UPDATE countlist SET c_check =0 WHERE sysid="&SysId_array(i)&""
							conn.execute(sql)
						next
					end if
				'	response.End()
				else
					Rs.close
					url_return "未找到用户信息",-1
					'response.Write("未找到用户信息")
					'response.End()
				end if
			end if
		
		'response.Write(u_in & "----" &CheckedUnPay)
		'------------------------------------------
		
	End If
		u_name=""
		u_countid=""
		u_in=""
		u_out=""
		c_date=now()
		c_memo=""
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 付款确认</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table>
      <br />
<div align="left">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td valign="top"> 
        <table width="100%" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
          <tr> 
            <td valign="top" align="center"> <%
						Response.Write ssmsg
						%> 
              <form action="incount.asp" method=post name=formincount onSubmit="return check()">
                <table width=100% border=0 align=center cellpadding=3 cellspacing=0 bordercolordark=#FFFFFF class="border">
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg"> 
                      <input name=module type=hidden value=incount>
                      <input name=name type=hidden value=<%=requesta("name")%>>
                      <input name=Orders type=hidden value=<%=requesta("Orders")%>>
                      <input name=PayendID type=hidden value=<%=requesta("PayendID")%>>
                      　凭证编号：</td>
                    <td width="504" class="tdbg"> 
                      <%
randomize timer
 





if Requesta("module")="" then
  u_name=Requesta("UserName")
'  u_countid_2=left(u_name,4) & "-" & month(date())&"."&day(date())&"-"&regjm
    u_countid_2=left(u_name,4)&"-"&getDateTimeNumber()
	
  u_in=Requesta("Amount")
  c_memo=Requesta("Paymethod")
elseif Requesta("module")="PayEnd" then
  u_name=Requesta("UserName")
 'y u_countid_2=left(u_name,4) & "-" & month(date())&"."&day(date())&"-"&regjm
  u_countid_2=left(u_name,4) & "-" &getDateTimeNumber()
  u_in=Requesta("money")
  c_memo=Requesta("hktype")
end if
 
%>
                      <%=Ident%> 
                      <input name=sid size="20" value="<%=u_countid_2%>" maxlength="17" >
                      　(总长不超过20位,否则出错)</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">　用 户：</td>
                    <td width="504" class="tdbg"> 
                      <input name=sid2 size="20"  value="<%=u_name%>">
                      　<font color="#CC0000"><b></b></font><font size="2"></font></td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">　入 款：</td>
                    <td width="504" class="tdbg"> 
                      <input name=sid3 size="20"  value="<%=u_in%>">
                      元　<font color="#CC0000"><b><font color="#FF0000"><%="<br>" & Msg2%></font></b></font></td>
                  </tr>
                  <%
				  	if Msg4_edward<>"" then
				  %>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">　自动还借款：</td>
                    <td width="504" class="tdbg"><%=Msg4_edward%></td>
                  </tr>
                  <%
				  	end if
				  %>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">款项类型：</td>
                    <td width="504" class="tdbg"> 
                      <select name="sid4" id="sid4">
          		                <option value="招商银行"<%if c_memo="招商银行" then%> selected<%end if%>>招商银行</option>
			            <option value="财付通支付"<%if c_memo="财付通支付" then%> selected<%end if%>>财付通支付</option>
                        <option value="云网支付"<%if c_memo="云网支付" then%> selected<%end if%>>云网支付</option>    
                        <option value="交通银行"<%if c_memo="交通银行" then%> selected<%end if%>>交通银行</option>
                        <option value="建设银行"<%if c_memo="建设银行" then%> selected<%end if%>>建设银行</option>
                        <option value="工商银行"<%if c_memo="工商银行" then%> selected<%end if%>>工商银行</option>
                        <option value="农业银行"<%if c_memo="农业银行" then%> selected<%end if%>>农业银行</option>
                        <option value="在线支付"<%if c_memo="在线支付" then%> selected<%end if%>>在线支付</option>
                        <option value="默认在线支付"<%if c_memo="默认在线支付" then%> selected<%end if%>>默认在线支付</option>
                        <option value="公司转帐"<%if c_memo="公司转帐" then%> selected<%end if%>>公司转帐</option>
                        <option value="上门交费"<%if c_memo="上门交费" then%> selected<%end if%>>上门交费</option>
                        <option value="支付宝支付"<%if c_memo="支付宝支付" then%> selected<%end if%>>支付宝支付</option>
                        <option value="西联国际汇款"<%if c_memo="西联国际汇款" then%> selected<%end if%>>西联国际汇款</option>
                        <option value="公司转帐2"<%if c_memo="公司转帐2" then%> selected<%end if%>>公司转帐2</option>
                        <option value="邮政存折汇款"<%if c_memo="邮政存折汇款" then%> selected<%end if%>>邮政存折汇款</option>
                        <option value="借款"<%if c_memo="借款" then%> selected<%end if%>>借款</option>
                        <option value="农业银行2"<%if c_memo="农业银行2" then%> selected<%end if%>>农业银行2</option>
                        <option value="快钱支付"<%if c_memo="快钱支付" then%> selected<%end if%>>快钱支付</option>
                        <option value="邮政汇款"<%if c_memo="邮政汇款" then%> selected<%end if%>>邮政汇款</option>
                      </select> *若用户是在线支付的,请不要选择了某银行
					</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg"><font color="#FF0000">实际到款日期:</font></td>
                    <td width="504" class="tdbg"> 
                      <input name=sid5 size="20"  value="<%=c_date%>">
                      (yyyy-mm-dd)　</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">代理公司汇款:</td>
                    <td width="504" class="tdbg"> 
                      <input type="checkbox" name="isAgent" value="OHYES" <%if isAgent<>"" or (agentLevel>1 and inStr(c_memo,"公司")>0) then Response.write " checked"%>>
                      如果这用户是代理商并且通过公司汇款，则必须选中</td>
                  </tr>
                  <tr bordercolordark="#ffffff"> 
                    <td width="102" height="19" bgcolor="#D2EAFB" class="tdbg">是否是内部转帐</td>
                    <td width="504" height="19" class="tdbg"> 
                      <%
if requesta("ismove")<>"" then
ismove=requesta("ismove")
else
ismove=0
end if

%>
                      <input type="radio" name="ismove" value="0" <%if ismove=0 then response.write "checked"%>>
                      否 
                      <input type="radio" name="ismove" value="1" <%if ismove=1 then response.write "checked"%>>
                      是 (比如财务将公司的现金存到公司帐号，请选择“是”。)</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">用户信息：</td>
                    <td width="504" class="tdbg"><%=Mes3%> &nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="102" bgcolor="#D9EEFD" class="tdbg">用户备注：</td>
                    <td width="504" class="tdbg"><%=userinfo%>&nbsp;<%=AlertMessage%></td>
                  </tr>
                  <tr> 
                    <td colspan=2 align=center class="tdbg"> <%=substrings%> </td>
                  </tr>
                  <tr> 
                    <td colspan=2 align=center class="tdbg"> 
                      <div align="left">功能说明：<br>
                        入款: 用户汇款后，将款加到会员帐号上。用户可用金额增加。<font color="#FF0000">（常用）</font><br>
                        扣款：用户申请退款，将款从会员帐号中扣除。用户可用金额减少。<br>
                        还款入户：用户申请业务失败，但已经扣款。通过这个功能将款项退回。用户可用金额增加，总金额不变。<br>
                        消费扣款：用户购买推广等产品，需要手工扣款的，用户可用金额减少。<br>
                        优惠入款：用户购买产品多年的，需要将打折优惠的款加到用户帐号上，会导致可用金额增加，总金额不变。<br>
                        借款：入款的时候款项类型选择为“借款”即可，除非特殊情况，一般不借款。<br>
                        还借款：入款的时候，系统如果发现该用户有借款未还，会自动启动还借款程序，在自动还借款的复选框上打勾，入款后就自动完成了还借款的过程。<br>
                        <font color="#FF0000">实际到款日期:</font>比如招行280元用户于28号汇的，但是30号才来确认，这里要填28号。凭证编号处的日期不能改了，这跟原来的处理办法不一样，请注意。<br>
                        是否是内部转帐:平时入款都选择为默认的“否”，财务在内部帐务处理时使用。</div>                    </td>
                  </tr>
                </table>
              </form>
            </td>
          </tr>
        </table>
        <!--  BODY END -->
        <p><br>
        </p>
        </td>
    </tr>
  </table>
  
</div>

<%
function GetCountID(strDomain)
	Randomize
	GetCountID=strDomain & "-" & Right(Cstr(Rnd()*999999),6)
end function
function GetDateRadom()
	TimeStr=now()
	TimeStr=replace(TimeStr," ","")
	TimeStr=replace(TimeStr,":","")
	TimeStr=replace(TimeStr,"-","")
	regma=int(rnd*899+100)
	GetDateRadom=TimeStr&regma
end function
%><!--#include virtual="/config/bottom_superadmin.asp" -->
