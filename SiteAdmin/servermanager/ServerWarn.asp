<!--#include virtual="/config/config.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>服 务 器 租 用 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">服务器/VPS管理</a> | <a href="ServerListnote.asp">查看新订单</a> | <a href="ServerWarn.asp">查看过期订单</a></td>
  </tr>
</table>
<br />
      <table width="100%" border="0" cellpadding="2" cellspacing="0" class="border">
        <tr>
          <td><%
   check_is_master(6)
   conn.open constr
	Sql="Select fax,Name,QQ,Telephone,AllocateIP,StartTime,AlreadyPay,Years,MoneyPerMonth,u_name from HostRental where Start="&PE_True&""
	Rs.open Sql,conn,1,1
	ServerAlert=False
	do while not Rs.eof
		suffix=""
		if Rs("QQ")<>"" then
			suffix="," & "<a target=blank href=http://wpa.qq.com/msgrd?V=1&Uin=" & Rs("QQ") & "&Site=&Menu=yes><img border=0 SRC=http://wpa.qq.com/pa?p=1:" & Rs("QQ") & ":4 alt=点击发送消息给对方>" & Rs("qq") & "</a>"
'			suffix="," & "<a target=blank href=http://wpa.qq.com/msgrd?V=1&Uin=" & Rs("QQ") & "&Site=west263.com&Menu=yes>" & Rs("qq") & "</a>"
		end if
		if Rs("Telephone")<>"" then
			suffix=suffix & "," & Rs("Telephone")
		end if
		if Rs("Fax")<>"" then
			suffix=suffix & "," & Rs("Fax")&" <a href=" & SystemAdminPath & "/sendSMS/index.asp?sendNum="&Rs("Fax")&" target=_blank>发短信</a>" 
		end if
		if DateDiff("d",Now,DateAdd("yyyy",Rs("Years"),Rs("StartTime")))<0 then
			ServerAlert=true
			AlertString=AlertString & "<br><li>"&GetPricePic(Rs("u_name"),Rs("MoneyPerMonth"))&"<font color=red>独立主机" & Rs("AllocateIP") &"过期,联系人:" & Rs("Name") & suffix & "</font></li>"
		elseif DateDiff("d",Now,DateAdd("m",Rs("AlreadyPay"),Rs("StartTime")))<0 then
			ServerAlert=true
			AlertString=AlertString & "<br><li>"&GetPricePic(Rs("u_name"),Rs("MoneyPerMonth"))&"<font color=green>独立主机" & Rs("AllocateIP") &"欠费,联系人:" & Rs("Name")	& suffix & "</font></li>"
		elseif DateDiff("d",Now,DateAdd("m",Rs("AlreadyPay"),Rs("StartTime")))<=5 then
			ServerAlert=true
			AlertString=AlertString & "<br><li>"&GetPricePic(Rs("u_name"),Rs("MoneyPerMonth"))&"独立主机" & Rs("AllocateIP") &"离欠费仅剩" &  DateDiff("d",Now,DateAdd("m",Rs("AlreadyPay"),Rs("StartTime"))) & "天,联系人:" & Rs("Name") & suffix &"</li>"	
		end if
	Rs.moveNext
	Loop
	Rs.close



	Response.write AlertString




function GetPricePic(PUserName,PMoneyPerMonth)
	set rs_pic=server.CreateObject("adodb.Recordset")
	sql_pic="select u_usemoney from UserDetail where u_name='"&PUserName&"'"
	rs_pic.open sql_pic,conn,1,1
	if not rs_pic.eof then
		tempStr=rs_pic(0)
		if Ccur(tempStr)>Ccur(PMoneyPerMonth) then
			GetPricePic="(有余额)"
		else
			GetPricePic=""
		end if
	else
			GetPricePic=""
	end if
	
	rs_pic.close
	set rs_pic=nothing
	
end function

conn.close



%></td>
        </tr>
      </table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
