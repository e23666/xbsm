<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312" 
response.Buffer=true
panel_vhost_name=session("Control_vhost_name")
conn.open constr
chargemonth=Requesta("chargemonth")
pcnt=Requesta("pcnt")

Tproid=GetTproid(panel_vhost_name)
Tprice=Gprice(Tproid)
Tsize=GetTsize(Tproid)

if isNumeric(pcnt) and pcnt<>"" and chargemonth<>"" then
	if panel_vhost_name="" or isEmpty(panel_vhost_name) or isNull(panel_vhost_name) then
			url_return "��¼��ϢʧЧ�������µ������������뱾ҳ���ֵ",-1
	end if
	Monthlist=split(chargemonth,",")
	MonthTotal=Ubound(Monthlist)+1
	pcnt=abs(Cint(pcnt))
	usedmoney= session("u_usemoney")
	paymoney=MonthTotal*pcnt*Tprice
	ttraffic=Tsize*pcnt
	if Ccur(usedmoney)<Ccur(paymoney) then
			url_return "��Ǹ���������㣬�˴γ�ֵ��Ҫ" & paymoney & "Ԫ�������������Ϊ" & usedmoney & "Ԫ!",-1
	end if

	commandstr ="vhost" & vbcrlf & _
				"traffic" & vbcrlf & _
				"entityname:add" & vbcrlf & _
				"ftpuser:" & panel_vhost_name & vbcrlf & _
				"tproid:" & Tproid & vbcrlf & _
				"monthlist:" & chargemonth & vbcrlf & _
				"pcnt:" & pcnt & vbcrlf & _
				"tsize:" & Tsize & vbcrlf & _
				"tprice:" & Tprice & vbcrlf & _
				"." & vbcrlf
	buyResult=PCommand(commandstr,session("user_name"))

	if Left(buyResult,4)="200 " then
		alert_redirect "��ϲ������ֵ�ɹ�!","add_traffic.asp"
	else
		url_return "ϵͳ����ʧ�ܣ�����ϵ����Ա��" & buyResult,-1
	end if
	response.End()
		
end if

chargeRec=GetTrafficRec(panel_vhost_name)
if chargeRec="" then chargeRec="û�г�ֵ��¼"
TCnt=GetTMenu(panel_vhost_name)
Mlist=GetMlist(panel_vhost_name)


%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-������ֵ</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
	pprice=<%=Tprice%>;
	psize=<%=Tsize%>;
function fprice(form){
	pcnt=form.pcnt.value;
	totalprice=pprice*pcnt;
	document.getElementById("showprice").innerHTML=totalprice;
	return;
}
function getMname(xdate){
	var xarr=xdate.split("-");
	return xarr[0] + "-"+xarr[1]+"��";
}

function check(form){
	scnt=0;
	showinfo='';
	if (form.chargemonth.length){
		for(i=0;i<form.chargemonth.length;i++){
			if (form.chargemonth[i].checked){
				scnt++;
				showinfo+=getMname(form.chargemonth[i].value)+',';
			}
		}
	}else
		if (form.chargemonth.checked){
			scnt++;
			showinfo=getMname(form.chargemonth.value);
		}

	if (scnt==0){
		alert('��ѡ��Ҫ��ֵ���·�!');
		return false;
	}

	if (showinfo.substr(showinfo.length-1,1)==',')
		showinfo=showinfo.substr(0,showinfo.length-1);
	return confirm('��ȷ��ҪΪ������'+showinfo+'����'+(psize*form.pcnt.value)+'G������?����'+(pprice*scnt*form.pcnt.value)+'Ԫ');

}
</script>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			    <li><a href="/Manager/sitemanager/">����������</a></li>
				<li>������ֵ</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
  <form name="form1" method="post" action="<%=Requesta("Script_name")%>" onSubmit="return check(this);">
        	<table  class="manager-table">
				      <tr >
                        <th width="100" align="right">��ֵ��¼��</th>
				        <td colspan="2" align="left"><%=chargeRec%></td>
				        </tr>
				     
				      <tr>
                        <th align="right">����������</th>
				        <td width="200" align="left"><%=TCnt%></td>
				        <td align="left">ÿ�·���:<span id=showprice><%=Tprice%></span>Ԫ  ����ǰ��<%=session("u_usemoney")%></td>
				      </tr>

                      <tr>
                        <th align="right">��ֵ�·ݣ�</th>
                        <td colspan="2"  align="left"><%=Mlist%></td>
                      </tr>
                      <tr>
                        <td align="center">&nbsp;</td>
                        <td colspan="2"><input type="submit"  class="manager-btn s-btn" name="button" id="button" value="ȷ����ֵ"></td>
                        </tr>
			
                    </table>
        </form>

<%

Function GetTproid(Byval s_comment)
	Qstr="select b.p_name,b.p_proid from vhhostlist a inner join productlist b on a.s_productid=b.p_proid where a.s_comment='" & s_comment & "'"
	set lrs=conn.Execute(Qstr)
	if not lrs.eof then
		rname=lrs(0)
		proid=lcase(lrs(1))
		isBGP=BGPLinux(s_comment)
		if isBGP or instr(rname,"˫��")>0 or instr(proid,"tw")>0 or instr(proid,"m")>0 or instr(proid,"c")>0 then
			GetTproid="T002"
		else
			GetTproid="T001"
		end if
	else
		GetTproid="T001"
	end if
	lrs.close:set lrs=nothing
end Function

function BGPLinux(byval s_comment)
	BGPLinux=False
	cmdstr="other" & vbcrlf
	cmdstr=cmdstr & "get" & vbcrlf
	cmdstr=cmdstr & "entityname:bgplinux" & vbcrlf
	cmdstr=cmdstr & "sitename:" & s_comment & vbcrlf &  "." & vbcrlf
	Result=PCommand(cmdstr,session("user_name"))

	If Left(Result,3)="200" Then
		If Trim(Mid(Result,5))="true" Then
			BGPLinux=true
		End if
	End If
end function

Function Gprice(Byval gproid)
	Qstr="select p_price from pricelist where p_proid='" & gproid & "' and p_u_level=" & session("u_levelid")
	Set lrs=conn.Execute(Qstr)
	if not lrs.eof then
		Gprice=lrs(0)
	else
		Gprice=30
	end if
	lrs.close:set lrs=nothing
end function
Function GetTSize(Byval gproid)
	Qstr="select p_traffic from productlist where p_proid='" & gproid & "'"
	Set lrs=conn.Execute(Qstr)
	if not lrs.eof then
		GetTSize=lrs(0)
	else
		GetTSize=0
	end if
	lrs.close:set lrs=nothing
end Function

function GetTrafficRec(Byval s_comment)
	GetTrafficRec=""
	Qstr="select ttraffic,tdate from app_traffic where s_comment='" & s_comment & "' order by tdate asc"
	Set lrs=conn.Execute(Qstr)

	if not lrs.eof then lastRec=lrs("tdate")
	lastSum=0
	
	do while not lrs.eof
		curRec=lrs("tdate")
		
		if DateDiff("m",lastRec,curRec)<>0 then
			Mstr=datepart("m",lastRec)
			Mtra=lastSum
			lastSum=lrs("ttraffic")
			GetTrafficRec=GetTrafficRec & datepart("yyyy",lastRec) & "/" & Mstr & "��:" & Mtra & "G��"
		else
			lastSum=lastSum+lrs("ttraffic")	
		end if
		lastRec=curRec
		lrs.moveNext
		if lrs.eof then
			GetTrafficRec=GetTrafficRec & datepart("yyyy",lastRec) & "/" & DatePart("m",lastRec) & "��:" & lastSum & "G"
		end if
	loop
	lrs.close:set lrs=nothing
end function

Function GetTMenu(Byval s_comment)
	Tproid=GetTproid(s_comment)
	Tsize=GetTSize(Tproid)
	GetTMenu="<select name=pcnt onChange='fprice(this.form);' class='manager-select s-select'>"
	For i=1 to 50
		GetTMenu=GetTMenu & vbcrlf & "<Option value=""" & i & """>" & Tsize & "G��" & i & "</option>"
	next
	GetTMenu=GetTMenu & "</select>"
end Function

Function GetMlist(Byval s_comment)
	sDate=date()
	Qstr="select dateadd("&PE_DatePart_Y&",s_year,s_buydate) as expdate from vhhostlist where s_comment='" & s_comment & "'"
	Set lrs=conn.Execute(Qstr)
	if not lrs.eof then
		expdate=lrs(0)
	else
		GetMlist="�޴�����"
		exit function
	end if
	lrs.close:set lrs=nothing
	lyear=year(sDate)
	GetMlist="<u><font color=green><b>" & lyear & "��</b></font></u><BR>"
	do while datediff("m",sDate,expdate)>=0
		if lyear<>year(sDate) then
			if right(GetMlist,1)="," then GetMlist=left(GetMlist,len(GetMlist)-1)
			GetMlist=GetMlist & "<BR><u><font color=green><b>" & year(sDate) & "��</b></font></u><BR>"
			lyear=year(sDate)
		end if
		mNumber=month(sDate)
		GetMlist=GetMlist & vbcrlf & "&nbsp;<input type=checkbox name=chargemonth value=""" & replace(sDate,"/","-") & """>" & mNumber & "��,"
		sDate=dateadd("m",1,sDate)
	loop
	if right(GetMlist,1)="," then GetMlist=left(GetMlist,len(GetMlist)-1)
end Function
%>







		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>