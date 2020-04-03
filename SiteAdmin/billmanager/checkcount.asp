<!--#include virtual="/config/config.asp" -->
<%

Check_Is_Master(2)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {font-weight: bold}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>财务审核</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">用户入款</a>| <a href="InActressCount.asp" target="main">优惠入款</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">还款入户</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">手工扣款</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">记录开支</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">查看流水帐</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">优惠入款</a> | <a href="OurMoney.asp">入流水帐</a></td>
  </tr>
</table><br>
<table width="100%" border=0 align=center cellpadding=3 cellspacing=0 class="border">
<FORM action="checkcount.asp" method=post>
                  <tr bgcolor=#ffffff> 
                    <td width="40%" align="right" class="tdbg"> 凭证编号：                      </td>
                    <td width="60%" class="tdbg"> 
                      <input name=module value="search" type=hidden>
                      <input name=qid1 size="20">                    </td>
    </tr>
                  <tr bgcolor=#ffffff>
                    <td align="right" class="tdbg" >款型类型： </td>
                    <td class="tdbg">
                      <input name=c_memo size="20">                    </td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg" >时间：</td>
                    <td class="tdbg">从 
                      <input name=qid2 value="2002-1-1" size="8">
                      至 
                      <input name=qid3 value="<%=date()%>" size="8">
                      (yyyy-mm-dd) </td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg">金额： </td>
                    <td class="tdbg"> 
                      <input name=qid4 size="20">
                      元</td>
                  </tr>
                  <tr bgcolor=#ffffff> 
                    
      <td align="right" class="tdbg">用户： </td>
                    <td class="tdbg"> 
                      <input name=qid5  size="20">                    </td>
                  </tr>
                  <tr bgcolor=#FFFFFF> 
                    <td  align=center class="tdbg">&nbsp; </td>
                    <td class="tdbg"><input type="submit" name="button" id="button" value=" 开始搜索 "></td>
                  </tr>
                </form>
              </table>
<br>
<%


Ident=Ucase(left(Session("user_name"),3))

Set MyRs=Server.CreateObject("ADODB.RecordSet")
module=Requesta("module")
c_id=Requesta("c_id")
ck_id=Trim(Requesta("ck_id"))
PPPP=Trim(Requesta("PPPP"))
ActID=Trim(Requesta("ActID"))
NoteContent=Trim(Requesta("NoteContent"))

conn.open constr
if module="note" then
    if  not isNumeric(ActID) or NoteContent="" then url_return "请选择要对哪条记录发送通知!,或者请输入通知内容",-1 
	Sql="Select distinct userdetail.u_email,userdetail.u_contract,countlist.u_moneysum,countlist.u_countid,countlist.c_memo,countlist.c_date from userdetail,countlist where userdetail.u_id=countlist.u_id and countlist.sysid=" & ActID
    Rs.open Sql,conn,1,1
	if not Rs.eof then
		MailBody="尊敬的用户" & Rs("u_contract") & ",您好!<p>&nbsp;&nbsp;您的一笔发生于" & formatDateTime(Rs("c_date"),1) & "的财务记录(凭证号:" & Rs("u_countid") &",涉及金额:" & Rs("u_moneysum") & ",备注:" & Rs("c_memo") & ")未能通过审核，原因是<b><font color=red>" 
		MailBody=MailBody & NoteContent & "</font></b>,请您收到邮件通知后尽快更正，否则可能将会影响业务的正常使用。"
		MailBody=MailBody & "<br>&nbsp;&nbsp;为此给您带来的不便之处敬请谅解，我们也热切期望能得到您的合作。若您对此有不清楚之处，欢迎致电我司业务部进行咨询"
		SendMail Rs("u_email"),"紧急!财务记录未被审核",MailBody
		Sql="Update countlist set c_note=c_note+1,c_noteTime="&PE_Now&" where sysid=" & ActID
		conn.Execute(Sql)
		Response.write "<script language=javascript>alert('邮件发送成功');</script>"
		module="search"
	end if
	Rs.close
End If

if PPPP<>"" and ck_id<>"" then
	ar_ck_id=split(ck_id,",")
	for each sid in ar_ck_id
		sid=Trim(sid)
		Sql="Select u_id,u_moneysum,u_countId from countlist where sysid=" & sid
		Rs.open Sql,conn,1,1
		if not rs.eof then
			'if Ucase(left(Rs("u_countId"),3))<>Ident then
				if left(Rs("u_countId"),5)="(OL)-" then
					Sql="update Userdetail set u_checkmoney = u_checkmoney - " & Rs("u_moneysum") & " , u_remcount = u_remcount + " & Rs("u_moneysum") & ",u_usemoney=u_usemoney+" & Rs("u_moneysum") & "  where u_id=" & Rs("u_id")					
				else
					Sql="update Userdetail set u_checkmoney = u_checkmoney - " & Rs("u_moneysum") & " , u_remcount = u_remcount + " & Rs("u_moneysum") & "  where u_id=" & Rs("u_id")
				end if
				conn.Execute(Sql)
				Sql="update  countlist set c_check="&PE_False&" , c_datecheck="&PE_Now&"  where   sysid  = " & sid
				conn.Execute(Sql)
			'end if
		end if
		Rs.close
	next
end if
%>

<script language=javascript>
function Gather(form,ActID){
   noteContent=prompt("请输入不审核原因:","因为您在我司注册会员时填写的用户资料（姓名，地址，电话等）不真实或不完整");
   if (noteContent!=null){
		form.module.value='note';
		form.NoteContent.value=noteContent;
		form.ck_id.value='';
		form.ActID.value=ActID;
		form.submit();
	}
	return true;
}
</script>
<table width="100%" height="218" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
          <tr> 
            <td height="175" valign="top"> 
 <%
sqlstring="SELECT UserDetail.u_name, UserDetail.u_bizbid AS Expr2,countlist.*, UserDetail.u_operator AS u_operator, UserDetail.u_mode AS u_mode, UserDetail.u_nameEn AS u_nameEn, UserDetail.u_namecn AS u_namecn,UserDetail.u_province AS u_province FROM countlist LEFT OUTER JOIN UserDetail ON countlist.u_id = UserDetail.u_id where countlist.sysid > 0 and left(countlist.u_countid,5)<>'(OL)-' "
if Requesta("module")="" then sqlstring= sqlstring & " and c_check="&PE_True&""
If module="" Then module="search"
If module="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))

		rs.open session("sqlsearch") ,conn,3
	  else
		date1=Requesta("qid2")
		u_moneysum=Requesta("qid4")
		u_countid=Requesta("qid1")
		c_memo=Requesta("c_memo")
		date2=Requesta("qid3")
		u_name=Requesta("qid5")
		sqllimit=""
		If u_countid<>"" Then sqllimit= sqllimit & " and countlist.u_countid like'%"&u_countid&"%'"
		if c_memo<>"" then sqllimit= sqllimit & " and countlist.c_memo like '%" & c_memo & "%'"
		If date1<>"" Then  sqllimit= sqllimit & " and countlist.c_date >=#"&date1&"#"
		If date1<>"" Then  sqllimit= sqllimit & " and countlist.c_date <=#"&date2&"#"
		If u_moneysum<>"" Then  sqllimit= sqllimit & " and countlist.u_moneysum ="&u_moneysum
		If u_name<>"" Then sqllimit= sqllimit & " and UserDetail.u_name = '"&u_name&"'"
		sqlcmd= sqlstring & sqllimit
		'重新查找  分别需要定义 传上来的参数等等求出


		session("sqlsearch")=sqlcmd & " order by countlist.c_check desc , countlist.sysid desc"
		
		rs.open session("sqlsearch"),conn,3
	End If

	%> <%
	If Not (rs.eof And rs.bof) Then
	    Rs.PageSize = 10
	    rsPageCount = rs.PageCount
	    flag = pages - rsPageCount
	    If pages < 1 or flag > 0 then pages = 1
	    Rs.AbsolutePage = pages
	%> 
              <form action="checkcount.asp" method=post>
                <TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
                  <TR align=center> 
                    <TD valign="bottom" nowrap class="Title"><strong>凭证号</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>发生金额</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>入账</strong></TD>
                    <TD valign="bottom" nowrap class="Title"><strong>出账</strong></TD>
                    <TD valign="bottom" nowrap class="Title"><strong>时间</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>用户名</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>代管</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>款项类型</strong></TD>
                    <TD valign="bottom" nowrap class="Title" ><strong>状态</strong></TD>
                    <TD valign="bottom" nowrap class="Title" > 
                      <input name="PPPP" type="submit" class="STYLE4" value="审核">                    </TD>
                    <TD valign="bottom" nowrap class="Title" ><strong> 
                    <input type="hidden" name="ActID">
                    <input type="hidden" name="module">
                    <input type="hidden" name="NoteContent">
				    <input type="hidden" name="pages" value="<%=pages%>">                    
				    </strong></TD>
                  </TR>
                  <%
		Do While Not rs.eof And i<11
			Sql="Select u_namecn,u_name,u_contract,u_address,u_telphone,u_city from userdetail where u_id=" & rs("u_id")
			MyRs.open Sql,conn,1,1
			TitleString=""
			u_name=""
			if not  MyRs.eof then
				u_name=MyRs("u_name")
				TitleString=TitleString & "用户名:      " & u_name & VbCrLF
				TitleString=TitleString & "姓名/公司名: " & MyRs("u_namecn") & VbCrLf
				TitleString=TitleString & "联系人:      " & MyRs("u_contract")& VbCrLf
				TitleString=TitleString & "城市:        " & MyRs("u_city")& VbCrLf
				TitleString=TitleString & "详细地址:    " & MyRs("u_address")& VbCrLf
				TitleString=TitleString & "电话:        " & MyRs("u_telphone") & VbCrLf
				TitleString=TitleString & "拒审通知次数:" & Rs("c_note") & VbCrLf
 			 	if Rs("c_note")>0 then
				TitleString=TitleString & "邮件发送时间:" & FormatDateTime(Rs("c_noteTime"),2)
				end if
			end if
			MyRs.close	
		%>
                  <TR align=middle title="<%=TitleString%>"> 
                    <TD valign="center" class="tdbg"><%=rs("u_countId")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_moneysum")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_in")%></TD>
                    <TD valign="center" class="tdbg"><%=rs("u_out")%></TD>
                    <TD valign="center" class="tdbg"><%=formatdatetime(rs("c_date"),2)%></TD>
                    <TD valign="center" class="tdbg" ><a href="../usermanager/detail.asp?u_id=<%=Rs("u_id")%>" target="_blank"><font color="#0000FF"><%=u_name%></font></a></TD>
                    <td align="center" nowrap bgcolor="#EAF5FC" class="tdbg" width="4%"><a href="../chguser.asp?module=chguser&username=<%=u_name%>"><font color="#0000FF">代管</font></a></td>
                    <TD valign="center" class="tdbg"><%=rs("c_memo")%></TD>
                    <td valign="center" class="tdbg"  >                      <%
									If rs("c_check") Then  
											Response.Write "未审核"
										else
											Response.Write "已"
									End If
									%>                     </td>
                    <td align="center" valign="center" class="tdbg"  > 
                      
                      <input type="checkbox" name="ck_id"  value="<%=rs("sysid")%>" <% if not rs("c_check") then Response.write " disabled"%>>
               
                    <td align="center" valign="center" class="tdbg"  >
                      <input type="button" name="PPPP2" value="拒审" onClick="Gather(this.form,<%=Rs("sysid")%>);">                    </td>
                  </TR>
                  <%
			rs.movenext
			i=i+1
		Loop
		rs.close
		%>
                  <tr bgcolor="#FFFFFF"> 
                    <td colspan =11 align="center" bgcolor="#FFFFFF">                       <a href="checkcount.asp?module=search&pages=1">第一页</a> 
                      &nbsp; <a href="checkcount.asp?module=search&pages=<%=pages-1%>">前一页</a>&nbsp; 
                      <a href="checkcount.asp?module=search&pages=<%=pages+1%>">下一页</a>&nbsp; 
                      <a href="checkcount.asp?module=search&pages=<%=rsPageCount%>">共<%=rsPageCount%>页</a>&nbsp; 
                      第<%=pages%>页</td>
                  </TR>
                </table>
              </form>
              <br>
              <%
	  else
		rs.close
	End If

End If
%> 
              
            </td>
          </tr>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
