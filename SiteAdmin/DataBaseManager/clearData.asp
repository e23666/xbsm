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
    <td height='30' align="center" ><strong>�������ݿ�</strong></td>
  </tr>
  <tr class='topbg'>
    <td height='30' align="center" >
      <div align="left">������ڵĶ�����¼��ϵͳ��־���Լ�С���ݿ�Ĵ�С�����԰�ȫ���������⡡\manager\question\UploadImages\�� 
        \CustomerCenter\UploadImages\�����Ŀ¼���������û��ϴ������ʱش����ʱͼƬ�����Զ��������Լ�С�ռ�ռ�á�</div>
    </td>
  </tr>
</table>
<br />
<table width="100%" border="0" cellpadding="20" cellspacing="0" class="border">
  <tr>
    <td class="tdbg"><%
my_action=Requesta("my_action")
if my_action="" then
	Response.write "��������:<hr><form name=form1 method=post action=clearData.asp onSubmit=""return confirm('ȷ������?')""><input type=submit name=my_action value=��ʼ></form>"
	Response.end
end if
conn.open constr
Dim tasklist(9,1)
tasklist(0,0)="����1����ǰ�ĸ���ȷ�ϼ�¼"
tasklist(0,1)="delete from payend where dateDiff("&PE_DatePart_D&",PDate,'"&now()&"')>=30"
tasklist(1,0)="����1����ǰ������������¼"
tasklist(1,1)="delete from preDomain where dateDiff("&PE_DatePart_D&",regdate,'"&now()&"')>=30"
tasklist(2,0)="����1����ǰ������������¼"
tasklist(2,1)="delete from preHost where dateDiff("&PE_DatePart_D&",sDate,'"&now()&"')>=30"
tasklist(3,0)="����3����ǰ�����ʱش��¼"
tasklist(3,1)="delete from question where dateDiff("&PE_DatePart_D&",q_require_time,'"&now()&"')>=90"
tasklist(4,0)="����1����ǰ������֧��������¼"
tasklist(4,1)="delete from ring where dateDiff("&PE_DatePart_D&",ring_dt,'"&now()&"')>=30"
tasklist(5,0)="����1����ǰ��_order��¼"
tasklist(5,1)="delete from _order where dateDiff("&PE_DatePart_D&",o_date,'"&now()&"')>=30"
tasklist(6,0)="����1����ǰ��orderlist��¼"
tasklist(6,1)="delete from orderlist where dateDiff("&PE_DatePart_D&",o_mkdate,'"&now()&"')>=30"
tasklist(7,0)="����1����ǰ��ϵͳ��־"
tasklist(7,1)="delete from ActionLog where dateDiff("&PE_DatePart_D&",addTime,'"&now()&"')>=30"
tasklist(8,0)="����700��ǰ�ķ�Ʊ��¼"
tasklist(8,1)="delete from FaPiao where dateDiff("&PE_DatePart_D&",f_date,'"&now()&"')>=700"
tasklist(9,0)="�������ǰ�Ĵ��ֹ������¼"
tasklist(9,1)="delete from Unprocess where datediff("&PE_DatePart_M&",Odate,'"&now()&"')>=6"

response.write "����ʼ:<hr>"
for i=0 to Ubound(tasklist)
	Response.write "<br>��" & i+1 & "��," & tasklist(i,0) & ":<br>"
	Response.write "ִ��<i>" & tasklist(i,1) & "</i>..."
	conn.Execute(tasklist(i,1))
	Response.write "���!<br>"
next
Response.write "<hr>�������!"
conn.close
%></td>
  </tr>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
