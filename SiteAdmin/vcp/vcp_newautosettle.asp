<%
function GetTimeRadom()
	filetype=right(Fname1,3)
	images_name1=now()
	images_name1=replace(images_name1,"-","")
	images_name1=replace(images_name1," ","")
	images_name1=replace(images_name1,":","")
	GetTimeRadom=images_name1
end function

sub settleover()
			MailBody="尊敬的" & Rs("u_namecn") & "<br>&nbsp;&nbsp;您好！<p>&nbsp;&nbsp;感谢您成为我司的ＶＣＰ模式合作伙伴，您现在的利润总额已达" & Utotal & "元，我们已经将" & Utotal & "元现金汇到了您在填写VCP资料的时候留下的银行帐户(邮政地址或会员帐号)上，请注意查收.部分用户由于提供的汇款方式有误，没有汇款成功，请及时与财务部联系，ＱＱ：" & oicq& "　电话："& telphone & " .若有不清楚之处，也欢迎您与我司联系"
			MailBody=MailBody & "，<p>&nbsp;&nbsp;&nbsp;致<p>礼<p>" & companyname & "<br>网址:" & companynameurl & "<br>" & formatDateTime(now,1)
			sendHtmlMail Rs("u_email"),"VCP结算通知",MailBody,true
end sub

Response.Buffer=false
%>
<!--#include virtual="/config/config.asp" --><%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>新闻管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="vcp_newautoSettle.asp">自动结算</a> | <a href="adver.asp">广告管理</a> | <a href="settlelist.asp">查看打款记录</a></td>
  </tr>
</table> <br>
<%
Server.ScriptTimeOut=99999
%>
<%Check_Is_Master(6)%>
<%

conn.open constr
set MyRs=Server.CreateObject("ADODB.RecordSet")

Start=Trim(Requesta("Start"))
TotalSum=0
dotcount=0

Response.write "<html><head><title>自动结算..</title></head><body>"
if Start<>"" then
	Response.write "==开始自动结算(仅结算利润大于等于100元的用户)==<hr>"
	Sql="Select  f.*,u.u_namecn,u.u_email from fuser as f inner join userdetail as u on f.u_id=u.u_id where f.L_ok="&PE_True&" order by f.id asc"
	Rs.open Sql,conn,1,1
	do while not Rs.eof 
		set lrs=conn.Execute("select sum(v_royalty) as Utotal from vcp_record where v_start=0 and v_fid=" & rs("u_id"))
		if not lrs.eof then
			if not isnull(lrs(0)) then
				Utotal=Ccur(lrs(0))
			else
				Utotal=0
			end if

			if Utotal>=100 then
				dotcount=dotcount+1
				Response.write dotcount & ".&nbsp;&nbsp;用户:" & rs("username") & ",利润:" & Utotal & "元,"
				if rs("C_RemitMode")<>"会员冲值" then
					Response.write "银行:" & rs("C_RemitMode") & ",帐号:" & rs("C_Accounts") & ",户名:" & rs("C_bank")
				else
					conn.Execute("update userdetail set u_usemoney=u_usemoney+" &Utotal & " where u_id=" & rs("u_id"))
					conn.execute("INSERT INTO countlist (u_id, u_moneysum, u_in,u_out, u_countId, c_memo, c_date, c_dateinput, c_datecheck, c_check) VALUES ("&rs("u_id")&"," & Utotal & "," & Utotal & ",0,'"&GetTimeRadom()&"','VCP提成','"&now()&"','"&now()&"','"&now()&"',0)")
					Response.write "会员冲值(已成功)"
				end if
				
				Response.write "<BR><BR>"
				conn.Execute("update vcp_record set v_start=1 where v_start=0 and v_fid=" & rs("u_id"))
				conn.Execute("update fuser set N_total=N_total+" & Utotal & ",D_end="&PE_Now&" where u_id=" & rs("u_id"))
				conn.Execute("insert into vcp_settlelist(s_userid,s_date,s_money) values("& rs("u_id") &",now(),"& Utotal &")")
				TotalSum=TotalSum+Utotal
				Call settleover()
			end if
		end if
		lrs.close: set lrs=nothing
		Rs.moveNext
	loop
	Rs.close
	Response.write "<hr>全部完成!共计:<b><font color=red>" & TotalSum & "</font></b>元(<b>特别提醒:请将以上信息复制下来，并按提示给用户汇款</>)"
else
	Response.write "<form action=""" & Request("script_name") & """ name=form1><input type=submit name=Start value=开始></form>"
end if
%><!--#include virtual="/config/bottom_superadmin.asp" -->
