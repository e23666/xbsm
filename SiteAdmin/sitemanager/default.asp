<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/class/Page_Class.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
Check_Is_Master(6):Response.Charset="gb2312":Response.Buffer=True:act=requesta("act"):conn.open constr

if act="ywgh"  then
	if Check_as_Master(1) then
		u=trim(requesta("u"))
		set u_rs=conn.execute("select u_id,u_name from UserDetail where u_name='"&u&"'")
		if u_rs.eof then
			die "��ѯ�û�����ʧ�ܣ�"
		else
			u_id=u_rs("u_id")
			u_name=u_rs("u_name")
			u_rs.close
			set u_rs=nothing
		end if
		d_id=checkNumArray(trim(requesta("id")))
		'conn.execute("update vhhostlist set S_ownerid="&u_id&" where s_sysid in("&d_id&")")
		set hrs=Server.Createobject("adodb.recordset")
		sql="select * from vhhostlist where s_sysid in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("S_ownerid")<>u_id then
			mname=hrs("s_comment")
  			hrs("S_ownerid")=u_id
			hrs.update
			call Add_Event_logs(session("user_name"),0,mname,"�����߱����["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "Ȩ�޲���"
	 end if
end if


Set prDic = Server.CreateObject("scripting.dictionary") : init
ArrOrder=array("s_sysid","s_comment","s_bindings","s_serverip","s_siteState","s_buydate","u_name","s_ProductId")
cur = 1 : setsize = requesta("psize") : if not isnumeric(setsize&"") then setsize=15 else setsize=clng(setsize)
' --------------------------------------------------------------------------------------
ord_t=requesta("ord_t")	
if ord_t<>"asc" then ord_t="desc"
orderimg = "/images/up_sort.png" :if ord_t="desc" then orderimg = "/images/down_sort.png"

ord_f=requesta("ord_f")
searchtype=requesta("searchtype")
keywords=requesta("keywords")
if not isnumeric(ord_f&"") then ord_f=0
if int(ord_f)<0 or int(ord_f)>ubound(ArrOrder) then ord_f=0

'newsql-start
'sqlArray=Array("allck,ģ������,str","s_comment,վ����(FTP�˺�),str","s_bindings,������,str","s_serverIP,��������ַ,str","s_ProductId,��Ʒ�ͺ�,str","u_name,������Ա,str")
newsql = searchEnd(searchItem,condition,searchValue,othercode)

sitestate=requesta("sitestate")
select case sitestate
	case "ok" :newsql = newsql & " And s_buytest="&PE_False&" and s_sitestate=0"
	case "test":newsql= newsql & " And s_buytest="&PE_True&" and s_sitestate<>-2"
	case "pause":newsql=newsql & " and s_buytest="&PE_False&" and s_sitestate=1"
	case "stop" :newsql=newsql & " and s_buytest="&PE_False&" and s_sitestate=2"
	case "bad"  :newsql=newsql & " and s_sitestate=-1"
	case "outdate":newsql=newsql & " and datediff("&PE_DatePart_D&","&PE_Now&",s_expiredate)<0"
end select

quickDate=requesta("q")
startime=requesta("startime")
overtime=requesta("overtime")
freeDay=30	'ע�� ��[����/����/��̨]��������30���












select case quickDate
	case "day"
		newsql2 = " and dateDiff("&PE_DatePart_D&","&PE_Now&",s_buydate)=0"
	case "yesterday"
		newsql2 = " and dateDiff("&PE_DatePart_D&","&PE_Now&",s_buydate)=-1" 
	case "threeday"	'������
		startime=date()-2 :overtime=date()
	case "sevenday"	'������
		startime=date()-6 :overtime=date()
	case "week"		'����
		newsql2 = " and datediff("&PE_DatePart_W&","&PE_Now&",s_buydate)=0"
	case "month"	'����
		newsql2 = " and datediff("&PE_DatePart_M&","&PE_Now&",s_buydate)=0"
	case "upmonth"	'����
		newsql2 = " and datediff("&PE_DatePart_M&","&PE_Now&",s_buydate)=-1"
	case "season"
		newsql2 = " and datediff("&PE_DatePart_Q&","&PE_Now&",s_buydate)=0"
	case "upseason"
		newsql2 = " and datediff("&PE_DatePart_Q&","&PE_Now&",s_buydate)=-1"
	case "year"
		newsql2 = " and datediff("&PE_DatePart_Y&","&PE_Now&",s_buydate)=0"
	case else
		'startime=requesta("startime")'�����Ѿ���ȡ��
		'overtime=requesta("overtime")
end select
if newsql2 = "" then
	if isdate(startime) then
		newsql2 = " And dateDiff("&PE_DatePart_D&",'" & startime & "',s_buydate)>=0"
	end if
	if isdate(overtime) then
		newsql2 = newsql2 & " And dateDiff("&PE_DatePart_D&",s_buydate,'" & overtime & "')>=0"
	end If
End If
newsql = newsql & newsql2

intDays = requesta("days")
if not isnumeric(intDays&"") then intDays=30	'��ѯ30���ڵ�������ʱ��

module=requesta("module")
if module="willexpire" then
	'newsql = " And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))>=0 And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))<=" & intDays
	newsql = " And ( (dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))<=" & intDays & " And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))>0 and s_buytest="&PE_False&") or (dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_D&",7,s_buydate))<=" & intDays & " And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_D&",7,s_buydate))>0 and s_buytest="&PE_True&") )"
elseif module="expire" then
	newsql = " And ( (dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_Y&",s_year,s_buydate),"&PE_Now&")>0 and s_buytest="&PE_False&") or ( dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_D&",7,s_buydate),"&PE_Now&")>0 and s_buytest="&PE_True&") )"
elseif module="newbuy" then
	newsql = " And ( (s_buytest="&PE_True&" and dateDiff("&PE_DatePart_D&",s_buydate,"&PE_Now&")<=" & intDays & ") " &_
	" or (s_buytest="&PE_False&" and dateDiff("&PE_DatePart_D&",s_buydate,"&PE_Now&")<=" & intDays & ") and (left(s_ProductId,2)='tw' or left(s_ProductId,1)='m') " &_
	" or (s_buytest="&PE_False&" and dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_D&",-" & freeday & ",s_buydate),"&PE_Now&")<=" & intDays & ") and (left(s_ProductId,2)<>'tw' and left(s_ProductId,1)<>'m') )"
elseif module="dele" or module="sync" then
	Call ActStart(module)
end if
newsql=newsql&" and dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate)>-30"
isql="select a.*,b.u_id,b.u_name,c.p_name from (vhhostlist a left join userdetail b On a.S_ownerid=b.u_id) left join productlist c On a.s_ProductId=c.P_proId"
isql=isql & " where 1=1 " & newsql

if keywords<>"" then
select case trim(searchtype)
case "s_comment"
	isql=isql&" and s_comment like '%"&keywords&"%'"
case "s_bindings"
	isql=isql&" and s_bindings like '%"&keywords&"%'"
case "s_serverIP"
	isql=isql&" and s_serverIP like '%"&keywords&"%'"
case "s_ProductId"
	isql=isql&" and s_ProductId like '%"&keywords&"%'"
case "u_name"
	isql=isql&" and u_name like '%"&keywords&"%'"
case else
isql=isql&" and (s_comment like '%"&keywords&"%' or  s_bindings like '%"&keywords&"%' or s_serverIP like '%"&keywords&"%' or s_ProductId like '%"&keywords&"%' or u_name like '%"&keywords&"%' ) "

end select 
end if


isql=isql & " order by " & ArrOrder(ord_f) & " " & ord_t
'response.Write isql
rs.open isql,conn,1,1
othercode="&searchItem="& searchItem & "&condition="& condition & "&searchValue="&searchValue&"&startime=" & startime & "&overtime=" & overtime & "&q=" & quickDate & "&sitestate=" & sitestate & "&ord_f=" & ord_f & "&ord_t=" & ord_t & "&psize=" & setsize & "&module=" & module & "&days=" & intDays
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>���������б�</title>
<script type="text/javascript" src="/jscripts/check.js"></script>
<script type="text/javascript" src="/jscripts/dateinput.min.js"></script>
<link href="/jscripts/dateinput.min.css" rel="stylesheet">
<link href="../css/Admin_Style.css" rel="stylesheet">
<%Call pagescript()%>
</head>

<body style="padding:0 5px;">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='0' style="margin:1px 0">
  <tr class='topbg'>
    <th height="25" style="font-weight:bold;font-size:14px;">�� �� �� �� �� ��</th>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td ><strong>��������</strong><a href="default.asp"> ������������</a> | <a href="addnewsite.asp">�ֹ������������</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a> | <a href="syn.asp">��������ͬ�� </a></td>
  </tr>
</table>
<br />
<form method="post" action="?" name="frmsearch">
<table  width="100%" border=0 align=center cellpadding="2" cellspacing=1 class="border1">
<tr><td class="tdbg">
<strong>�߼�ɸѡ��</strong>
<select name="q" title="��ʱ�佫��[ʹ�ÿ�ʼ����]Ϊ׼,�ⲻ����������,��Ϊ�󲿷�����������30��">
    <option value="">�Զ�������</option>
    <option value="day">������</option>
    <option value="yesterday">������</option>
    <option value="threeday">��������</option>
    <option value="sevenday">��������</option>
    <option value="week">������</option>
    <option value="month">������</option>
    <option value="upmonth">������</option>
    <option value="season">������</option>
    <option value="upseason">���ϼ�</option>
    <option value="year">������ </option>
</select>
<input type="input" name="startime" size="10" value="<%=startime%>" />-<input type="input" name="overtime" size="10" value="<%=overtime%>" />&nbsp;
<select name="sitestate">
    <option value="">����״̬</option>
    <option value="ok">��ʽ����</option>
    <option value="test">����</option>
    <option value="pause">��ͣ</option>
    <option value="stop">ϵͳֹͣ</option>
    <option value="bad">����ʧ��</option>
<option value="outdate">��������</option>
</select>

<select name="searchtype">
<option value="all">ģ������</option>
<option value="s_comment">վ����(FTP�˺�)</option>
<option value="s_bindings">������</option>
<option value="s_serverIP">��������ַ</option>
<option value="s_ProductId">��Ʒ�ͺ�</option>
<option value="u_name">������Ա</option>
</select>

<input name="keywords" type="text" value="" size="20" maxlength="100" class="inputbox">
<input type="submit" name="serarchsubmit" value=" ��ѯ " class="btn_mini">
<%'=searchlist%>
<input type="hidden" name="ord_f" value="<%=ord_f%>" /><input type="hidden" name="ord_t" value="<%=ord_t%>" />
<input type="hidden" name="module" value="<%=module%>" />
<input type="hidden" name="days" value="<%=intDays%>" />
</td>
</tr>
</table>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
<tr>
<td>
<label><input type="checkbox" onClick="selectItem('sysid')" />��ѡ</label> 
[<a href="javascript:void(0)" title="��ɾ�����ݿ���Ϣ" onClick="Actstart('dele')">ɾ��ѡ��</a>] [<a href="javascript:void(0)" title="ͬ��ѡ�е�����" onClick="Actstart('sync')">ͬ��ѡ��</a>] [<a href="?module=willexpire&days=<%=intDays%>"<%if module="willexpire" then response.Write " class='focus'"%>>��<%=intDays%>�콫��������</a>] [<a href="?module=expire"<%if module="expire" then response.Write " class='focus'"%>>�����ѹ�������</a>] [<a href="?module=newbuy&days=<%=intDays%>"<%if module="newbuy" then response.Write " class='focus'"%>>��<%=intDays%>���¹���</a>] [<a href="<%=request.ServerVariables("SCRIPT_NAME")%>">��������</a>]
<span style="color:red" id="actresult"></span>
</td>
<td align="right">
<select name="pageNo"><%for i=1 to rs.pagecount:response.Write "<option value=""" & i & """>��" & i & "ҳ</option>":next%></select>
<select name="psize"><option value="5">ÿҳ5��</option><option value="10">ÿҳ10��</option><option value="15">ÿҳ15��</option><option value="20">ÿҳ20��</option><option value="25">ÿҳ25��</option><option value="30">ÿҳ30��</option></select>
</td>
</tr>
</table>
</form>


<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border" id="datalist">
<thead>
<tr class="Title">
    <th>վ���� <img tag="1" src="<%=orderimg%>" align="absmiddle"></th>
    <th>������ <img tag="2" src="<%=orderimg%>" align="absmiddle"></th>
    <th>�ϴ���ַ <img tag="3" src="<%=orderimg%>" align="absmiddle"></th>
    <th>״̬ <img tag="4" src="<%=orderimg%>" align="absmiddle"></th>
    <th>ʹ������ <img tag="5" src="<%=orderimg%>" align="absmiddle"></th>
    <th>�� �� <img tag="6" src="<%=orderimg%>" align="absmiddle"></th>
    <th><span class="black">�� ��</span></th>
    <th><span class="black">�� ��</span></th>
    <th>��Ʒ�� <img tag="7" src="<%=orderimg%>" align="absmiddle"></th>
    <th><span class="black">����/����</span></th>
</tr>
</thead>
<tbody><%
while not rs.eof and cur<=setsize
	for i=0 to Rs.Fields.Count-1:execute( "i_" & rs.Fields(i).Name & "=rs.Fields(" & i & ").value"):next
	if i_s_bindings&""="" then
		i_s_bindings="&nbsp;"
	elseif instr(lcase(i_p_name),"mysql")>0 then
		i_s_bindings = "Mysql���ݿ�"
	else
		i_s_bindings=replace(i_s_bindings&"",",","<br />")
	end if
	i_buydateInfo= formatdatetime(i_s_buydate,2) & "��"
	If i_s_buytest then
	i_buydateInfo= i_buydateInfo & FormatDateTime(DateAdd("d",6,i_s_buydate),2)
	Else
	i_buydateInfo= i_buydateInfo & Formatdatetime(i_s_expiredate,2)
	End if
%><tr>
    <td height="25"><div><span class="checkbx"><input type="checkbox" name="sysid" value="<%=i_s_sysid%>" /></span> <a href="m_default.asp?hostid=<%=i_s_sysid%>" class="ftpname"><%=i_s_comment%></a></div></td>
    <td><div style='line-height:100%'><%=i_s_bindings%></div></td>
    <td><div><%=i_s_serverip%></div></td>
    <td><%=showstatus(i_s_siteState, i_s_buytest, i_s_expiredate)%></td>
    <td><%=i_buydateInfo%></td>
    <td><%if i_u_name&""="" then%><span class="bred">�޴˻�Ա</span><%else%><a href="../usermanager/detail.asp?u_id=<%=i_s_ownerid%>" target="_blank" class="blue"><%=i_u_name%></a><%end if%></td>
    <td><a href="../chguser.asp?module=chguser&username=<%=i_u_name%>" class="blue">����</a></td>
    <td><a href="../billmanager/Mlist.asp?username=<%=i_u_name%>&module=serach" target="_blank"><img src="../images/finance.gif" width="16" height="16" alt="�鿴���û��Ĳ����¼"></a></td>
    <td><span title="<%=i_p_name%>"><%="["& i_s_ProductId &"]"%></span></td>
    <td><a href="m_default.asp?hostid=<%=i_s_sysid%>">����</a>|<a href="renewHost.asp?hostid=<%=i_s_sysid%>">����</a>|<a href="UpHost.asp?hostID=<%=i_s_sysid%>">����</a></td>
</tr><%
	cur=cur+1
	rs.movenext
wend
rs.close
%>
	<tr>
	<td colspan="12" style="text-align:left; padding:5px;"><form>��ѡ��ҵ�������:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="ȷ������" onclick="ywgh()"></form></td>
	</tr>
</tbody>
</table>

<div class="pagenav"><center><%=pagenumlist%></center></div>
<table border="0" cellpadding="0" cellspacing="1" width="100%" bgcolor="#999999" height="45">
	<tr>
	<td bgcolor="#C2E3FC" height="21">&nbsp;��������״̬ͼ��˵��:</td>
	</tr>
	<tr>
	<td bgcolor="#ffffff" align="center" height="25"><img src="/images/green1.gif" align="absmiddle">��������&nbsp;&nbsp; <img src="/images/green2.gif"  align="absmiddle">������ͣ&nbsp;&nbsp; <img src="/images/yell1.gif"  align="absmiddle">��������&nbsp;&nbsp; <img src="/images/yell2.gif"  align="absmiddle">����ֹͣ&nbsp;&nbsp; <img src="/images/fei1.gif"  align="absmiddle">��վ�ѹ���&nbsp;&nbsp; <img src="/images/sysstop.gif" align="absmiddle">��ϵͳֹͣ <img src="/manager/images/nodong.gif" align="absmiddle">δ����ɹ� </td>
	</tr>
</table>
<script>
function ywgh()
{
domstr=""
obj=$("input[name='sysid']:checkbox")
u=$("input[name=gh_u_name]");
if(u.val()==="")
{
alert("ҵ�������Ϊ��!")
u.focus()
return false;
}
 for(var i=0;i<obj.length;i++)
 {
    if(obj[i].checked)
	{
	   if(domstr==="")
	   {
		   domstr=obj[i].value;
	   }else{
	      domstr+=","+obj[i].value;
	   }
	}
 }
 if(domstr==="")
 {
 alert("��ѡ��Ҫ����������!")
 return false;
 }
  if(confirm("���붨Ҫ��ѡ��ҵ���Ƶ�["+u.val()+"]�ʻ��£�"))
  
  {

		 url="?act=ywgh&u="+u.val()+"&id="+domstr

		 $.get(url,"",function(date){
			  if(date=="200")
			  {
			  location.reload()
			  }else
			  {
			  alert(date);
			  }
		 })
}
}  
</script>
</body>
</html><%

Sub ActStart(module)
	sysids = requesta("sysids")
	if not regtest(sysids&"," , "^(\d+\,)+$") then Die "����Ĳ�������"
	if module="dele" then
		conn.execute("delete from vhhostlist where s_sysid in(" & sysids & ")")
		result = "��ѡ�ļ�¼�Ѿ�ɾ����<a href='javascript:void(0)' onclick='location.reload()'>������ˢ��</a>"
	elseif module="sync" then
		for each hostid in split(sysids,",")
			if  isnumeric(hostid&"") then
				rets = rets & startUpsync(hostid)
			end if
		next
		if instr(rets,"200 ok")>0 then
			result="ͬ���ɹ�"
		elseif instr(rets,"������")>0 then
			result="�����ݿ�ͬ��"
		else
			result="ͬ��ʧ�� " & left(rets,12)
		end if
	end if
	die result
End Sub

'/*���ϼ�ͬ��һ��������ֻ��id����*/
Function startUpsync(hostid)
	dim sql,trs,i_table,i_field,u_name
	sql="select b.u_name,a.* from vhhostlist a inner join userdetail b On a.s_ownerid=b.u_id where a.s_sysid=" & hostid
	set trs=conn.execute(sql)
	if not trs.eof then
		i_table = "vhhostlist"
		u_name = trs("u_name")
		s_comment = trs("s_comment")
		for i=1 to trs.Fields.Count-1
			i_field = i_field & trs.Fields(i).Name & ","
		next
		i_field = left(i_field,len(i_field)-1)
		cmdstr = "other" & vbcrlf & _
				"sync" & vbcrlf & _
				"entityname:record" & vbcrlf & _
				"tbname:" & i_table & vbcrlf & _
				"fdlist:" & i_field & vbcrlf & _
				"ident:" & s_comment & vbcrlf & _
				"." & vbcrlf
		startUpsync=pcommand(cmdstr,u_name)
	else
		startUpsync="500 Not Found"
	end if
	trs.close
End function

Function showstatus(svalues,buytest,expiredate )
	if cdate(expiredate) < date() then msg="<img src=/images/fei1.gif>"
	If not buytest Then
		Select Case svalues
		  Case 0:showstatus="<img src=../images/green1.gif>" & msg '����
		  Case 1:showstatus="<img src=../images/green2.gif>"   & msg'��ͣ
		  case 2:showstatus="<img src=../images/sysstop.gif>"   & msg'����Աֹͣ
		  case -1:showstatus="<img src=../images/nodong.gif>"   & msg'δ����
		  Case -2:showstatus="<img src=../images/delvho.gif>"   & msg'�Ѿ�ɾ��
		  case -4:showstatus="<img src=../images/nodong.gif>"   & msg'״̬δȷ��
		End Select
	else
		Select Case svalues
		  Case 0:showstatus="<img src=/images/yell1.gif>"   & msg'����
		  Case 1:showstatus="<img src=/images/yell2.gif>"   & msg'��ͣ
		  case 2:showstatus="<img src=/images/sysstop.gif>"  & msg'����Աֹͣ
		  case -1:showstatus="<img src=/images/nodong.gif>"   & msg'δ����
		  Case -2:showstatus="<img src=/images/delvho.gif>"   & msg'�Ѿ�ɾ��
		  case -4:showstatus="<img src=/images/nodong.gif>"   & msg'״̬δȷ��
		End Select
	End If
End Function
Sub init()
'	dim trs,p_proid,p_name
'	set trs=conn.execute("select p_proid,p_name from productlist")
'	while not trs.eof
'	p_proid=trim(lcase(trs("p_proid")&""))
'	p_name =trim(lcase(trs("p_name")&""))
'	prDic.add p_proid,p_name
'	trs.movenext
'	wend
'	trs.close
End Sub
	
'if Rs("s_icpstatus")=0 then
'	 bgcolor="#FF0000"
'	 mess="δ����"
'elseif Rs("s_icpStatus")=1 then
'	 bgcolor="#FFFF00"
'	 mess="��ί��"
'elseif Rs("s_icpStatus")=2 then
'	bgcolor="#009933"
'	 mess="�ѱ���"
'elseif Rs("s_icpStatus")=3 then
'	bgcolor="#66ccff"
'	 mess="�Լ���"
'elseif Rs("s_icpStatus")=4 then
'	bgcolor="#ff00ff"
'	mess="���ܾ�"
'elseif Rs("s_icpStatus")=5 then
'	bgcolor="#cccccc"
'	mess="��˾�ܾ�"
'end if
sub pagescript()%>
<script type="text/javascript">
$(function(){
	var fs=document.frmsearch;
	$("#datalist tbody tr:odd").addClass("ghbg");
	$("input[name=startime],input[name=overtime]").dateinput({
		format: 'yyyy-mm-dd',selectors: true,speed: '',	firstDay: 0
	}).addClass("inputbox");
	$("#datalist .Title img").click(function(){
		fs.ord_f.value = $(this).attr("tag");
		if (fs.ord_t.value==""||fs.ord_t.value=="desc"){
			fs.ord_t.value="asc";
		}else{
			fs.ord_t.value="desc";
		}
		fs.submit();
	});
	$(fs.q).val("<%=quickDate%>").change(function(){
		if (this.value!=""){
			fs.startime.disabled=true;
			fs.overtime.disabled=true;
		}else{
			fs.startime.disabled=false;
			fs.overtime.disabled=false;
		}
	});
	$(fs.pageNo).val("<%=pageNo%>").change(function(){
		fs.submit();
	});
	$(fs.psize).val("<%=setsize%>").change(function(){
		fs.submit();
	});	
	$(fs.sitestate).val("<%=sitestate%>");
	$(fs).find(":submit").click(function(){
		fs.pageNo.value=1;
		fs.module.value="";
	});
	

});	
function Actstart(module){
	var sysids = getcheckval("sysid");
	if (sysids=="") {
		alert("��ѡ��Ҫ��������");
	}else{
		if (module=="dele"){if (!confirm("ȷ��ɾ��?")) return false;}
		var post="module="+module+"&sysids="+sysids;
		$("#actresult").html("<img src='/images/ajax001.gif'> ����ִ��...");
		$.post("?",post,function(xml){
			$("#actresult").html(xml);
		})
	}
}
function getcheckval(nm){
	var chk_value =[];    
	var obj=$("input[name='" + nm + "']:checkbox:checked").each(function(){    
		chk_value.push($(this).val());    
	});
	return chk_value;
}
function selectItem(nm){
	$(':checkbox[name=' + nm + ']').each(function(){
		this.checked= !this.checked;
	})
}
</script>
<style type="text/css">
a.ftpname:link,a.ftpname:visited{
	color:#ff6600;
	font-size:12px;
	font-family: Verdana, Microsoft YaHei, Arial, Helvetica, sans-serif;
}
a.ftpname:hover{text-decoration:underline;color:#000;}
#datalist tbody td{text-align:center}
#datalist tbody td div{text-align:left;}
#datalist tbody tr:hover{color:#00F}
#datalist thead th{
	font-size:12px;
	height:25px;
	color:#fff;
}
#datalist .Title img{cursor:pointer}
a.focus:link,a.focus:visited{background:#B0D8FF}
.black{color:#000000;}
.ghbg{background-color:#EAF5FC}
.bred{color:red;font-weight:bold;}
</style>
<%end sub


function checkNumArray(str)
   temparray=split(str,",")
   newArray=""
   for i=0 to ubound(temparray)
      if isnumeric(temparray(i)&"") then
	  		if newArray="" then
				newArray=temparray(i)
			else
				newArray=newArray&","&temparray(i)
			end if
	  end if
   next
   if newArray="" then newArray=0
   checkNumArray=newArray
end function
%>

