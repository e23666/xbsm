<!--#include virtual="/config/config.asp"-->
<%
Response.buffer=false
check_is_master(1)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'> 
    <td height='30' align="center" ><strong>清理数据库</strong></td>
  </tr>
  <tr class='topbg'>
    <td height='30' align="center" >
      <div align="left">清理过期的订单记录，系统日志等以减小数据库的大小。可以安全操作。另外　\manager\question\UploadImages\和 
        \CustomerCenter\UploadImages\这二个目录里面存的有用户上传的有问必答的临时图片，可以定期清理，以减小空间占用。</div>
    </td>
  </tr>
</table>
<br />
<table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
  <tr>
    <td class="tdbg"><%
my_action=Requesta("my_action")
if my_action="" then
	Response.write "数据清理:<hr><form name=form1 method=post action=clearData.asp onSubmit=""return confirm('确信清理?')""><input type=submit name=my_action value=开始></form>"
	Response.end
end if
conn.open constr
Dim tasklist(9,1)
tasklist(0,0)="清理1个月前的付款确认记录"
tasklist(0,1)="delete from payend where dateDiff("&PE_DatePart_D&",PDate,'"&now()&"')>=30"
tasklist(1,0)="清理1个月前的域名订单记录"
tasklist(1,1)="delete from preDomain where dateDiff("&PE_DatePart_D&",regdate,'"&now()&"')>=30"
tasklist(2,0)="清理1个月前的主机订单记录"
tasklist(2,1)="delete from preHost where dateDiff("&PE_DatePart_D&",sDate,'"&now()&"')>=30"
tasklist(3,0)="清理3个月前的有问必答记录"
tasklist(3,1)="delete from question where dateDiff("&PE_DatePart_D&",q_require_time,'"&now()&"')>=90"
tasklist(4,0)="清理1个月前的在线支付订单记录"
tasklist(4,1)="delete from ring where dateDiff("&PE_DatePart_D&",ring_dt,'"&now()&"')>=30"
tasklist(5,0)="清理1个月前的_order记录"
tasklist(5,1)="delete from _order where dateDiff("&PE_DatePart_D&",o_date,'"&now()&"')>=30"
tasklist(6,0)="清理1个月前的orderlist记录"
tasklist(6,1)="delete from orderlist where dateDiff("&PE_DatePart_D&",o_mkdate,'"&now()&"')>=30"
tasklist(7,0)="清理1个月前的系统日志"
tasklist(7,1)="delete from ActionLog where dateDiff("&PE_DatePart_D&",addTime,'"&now()&"')>=30"
tasklist(8,0)="清理700天前的发票记录"
tasklist(8,1)="delete from FaPiao where dateDiff("&PE_DatePart_D&",f_date,'"&now()&"')>=700"
tasklist(9,0)="清理半年前的待手工处理记录"
tasklist(9,1)="delete from Unprocess where datediff("&PE_DatePart_M&",Odate,'"&now()&"')>=6"

response.write "清理开始:<hr>"
for i=0 to Ubound(tasklist)
	Response.write "<br>第" & i+1 & "步," & tasklist(i,0) & ":<br>"
	Response.write "执行<i>" & tasklist(i,1) & "</i>..."
	conn.Execute(tasklist(i,1))
	Response.write "完成!<br>"
next
Response.write "<hr>清理完毕!"
conn.close
%></td>
  </tr>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
