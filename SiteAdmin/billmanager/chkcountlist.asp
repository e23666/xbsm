<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<%Check_Is_Master(3)
conn.open constr
%>
  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style>
td{color:#FFF;}
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> ����ȷ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="/SiteAdmin/billmanager/incount.asp" target="main">�û����</a>| <a href="InActressCount.asp" target="main">�Ż����</a><a href="outcount.asp"></a> | <a href="returncount.asp" target="main">�����뻧</a><a href="returncount.asp"></a> | <a href="comsume.asp" target="main">�ֹ��ۿ�</a><a href="comsume.asp"></a> | <a href="outOurMoney.asp" target="main">��¼��֧</a><a href="checkcount.asp"></a> | <a href="ViewOurMoney.asp" target="main">�鿴��ˮ��</a><a href="checkmoney.asp"></a> | <a href="InActressCount.asp">�Ż����</a> | <a href="OurMoney.asp">����ˮ��</a></td>
  </tr>
</table>
      <br />
<div align="left">
<div><a href="?daytype=0">3��������</a> | <a href="?daytype=1">һ��������</a> | <a href="?daytype=2">1����������</a></div>

<%
startime=formatdatetime(now-3,2)
endtime=formatdatetime(now,2)
select case trim(requesta("daytype"))
case "1"
startime=formatdatetime(now-7,2)
endtime=formatdatetime(now,2)
case "2"
startime=formatdatetime(dateAdd("m",-1,now()),2)
endtime=formatdatetime(now,2)
end select
response.Write("<h3>"&startime &" �� "& endtime&" �ڼ�����������������������Ѽ�¼�Ա�</h3>")

 Set dic = CreateObject("Scripting.Dictionary") 
Call getSCountlist(startime,endtime)
sql="select * from countlist where  datediff("&PE_DatePart_D&",'"&startime&"',c_date)>=0 and  datediff("&PE_DatePart_D&",'"&endtime&"',c_date)>=0 and (c_memo like 'buy host%' or c_memo like 'buy domain%' or c_memo like 'renew domain%' or c_memo like 'renew host%')"
Set c_rs=conn.execute(sql)
 
%>
<TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
 <tr>
	<td class="Title">���</td>
	<td class="Title">ҵ������</td>
	<td class="Title">ҵ���¼�</td>
	<td class="Title">����ʱ��</td>
	<td class="Title">�Ƿ�ȶ�</td>
 </tr>
 <%
 cur=1
 Do While Not c_rs.eof
tempstr=Split(c_rs("c_memo"),":")
If ubound(tempstr)>=1 Then
 ywcomm=trim(tempstr(0))
 ywname=Trim(tempstr(1))
 If InStr(ywname,"[")>0 Then
    ywname=left(ywname,InStr(ywname,"[")-1)
 End if
End if
isshow=chkyw(ywcomm,ywname,c_rs("c_date"))
 %>
 <tr style="background-color:<%If isshow Then Response.write("green") Else Response.write("red")%>;color:#fffff">
	<td><%=cur%></td>
	<td><%=ywcomm%></td>
	<td><%=ywname%></td>
	<td><%=c_rs("c_date")%></tD>
	<td><%%></td>
 </tr>
 <%
 cur=cur+1
 c_rs.movenext
 loop
 %>
 </table>

 

<%
a=dic.Keys
'for i=0 to dic.Count-1
'  Response.Write(a(i))
 ' Response.Write("<br />")
'next
%>
 <div><h3>��������Ϊ��վ���ڴ���ƽ̨����������(<%=dic.Count%>)</h3></div>

 <TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
 <tr>
	<td class="Title">���</td>
	<td class="Title">ҵ������</td>
	<td class="Title">ҵ���¼�</td>
	<td class="Title">����ʱ��</td>
 
 </tr>
 <%
	a=dic.Keys
	for i=0 to dic.Count-1
    dicn=a(i)
	temps=Split(dicn,"_")
	c=temps(0)
	n=temps(1)
 %>
 <tr style="background-color:#D84F36;color:#fffff">
	<td><%=i+1%></td>
	<td><%=c%></td>
	<td><%=n%></td>
	<td><%=dic.item(dicn)%></td>
</tr>
  <%next%>
 
 </table>
 

 <%
 Function getSCountlist(stime,etime)
 dic.RemoveAll
 cmdstr="other"&vbcrlf&_
		"get"&vbcrlf&_
		"entityname:countlist"&vbcrlf&_
		"stardate:"&FormatDateTime(stime,2)&""&vbcrlf&_
		"enddate:"&FormatDateTime(etime,2)&""&vbcrlf&_
		"."&vbcrlf
returnstr=connectToUp(cmdstr)
returnstr=Mid(returnstr,instr(cmdstr,"enddate:"))
if len(returnstr)>6 then
returnstr=Left(returnstr,Len(returnstr)-6)
temps=Split(returnstr,vbcrlf&"$")
For i=0 To ubound(temps)
tempa=Split(temps(i),"~|~")
sj=month(tempa(2))&day(tempa(2))
newName=tempa(1)&"_"&Trim(tempa(3))&"_"&sj
'Response.write(LCase(newName)&"="&tempa(2)&"<BR>")
if dic.Exists(LCase(Trim(newName))) then
dic.item(LCase(Trim(newName)))=dic.item(LCase(Trim(newName)))&","&tempa(2)
else
dic.add LCase(Trim(newName)),tempa(2)
end if
Next  
end if
End Function


Function chkyw(t,n,s)
chkyw=False
sj=month(s)&day(s)
name=Trim(LCase(Replace(t," ","")&"_"&n))&"_"&sj
if dic.Exists(name)=true then
	t2=dic.item(name)
	If Trim(t2)<>"" Then
	   n_t=Split(t2,",")
	   new_t=""
       For li=0 To ubound(n_t)
   
			sjc=datediff("s",s,n_t(li))
			
			If sjc>=-900 And sjc<=900 Then
			
			Else
			If new_t="" Then
			new_t=n_t(li)
			Else
			new_t=new_t&","&n_t(li)
			End if
			End if
			chkyw=True
	   next
	     If new_t="" then
		  dic.Remove(name&"")
		  else
		  dic.item(name&"")=new_t
		 End if
		 'Response.write(name&"_____delok<BR>")
		
		
	chkyw=chkyw
	End if
End if
End function
 %>
 </div>
 <!--#include virtual="/config/bottom_superadmin.asp" -->
