<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/uphost_class.asp" -->
<%
response.Buffer=true
response.Charset="gb2312"
hostid=requesta("hostid")
conn.open constr
act=requesta("act")
set up=new uphost_class:up.u_sysid=session("u_sysid"):up.setHostid=hostid
if up.istostatepage and instr(requesta("script_name"),"uphost_state.asp")=0 then 
	gowithwin "uphost_state.asp?hostid="&hostid
elseif not up.istostatepage and instr(requesta("script_name"),"uphost.asp")=0 then
	'response.Write("aaa")
	gowithwin "uphost.asp?hostid="&hostid	 
end if


if act="sub" then
	new_proid=requesta("new_proid")
	new_room=requesta("new_room")
	ismovedata=requesta("ismovedata")
	new_osver=requesta("osver")
	isnewip=requesta("newromipdata")
	pmver=requesta("pmver")
	up.newmysqlver=pmver
	call up.getUpInfo(new_proid,new_room,new_osver,ismovedata)
	if up.isLimitMove="true" then ismovedata=0
	if trim(isnewip&"")="1" then
	up.setGoOnip=true
	else
	up.setGoOnip=false
	end if
	if up.dosub(new_proid,new_room,new_osver,ismovedata,errstr) then								 
			alert_redirect "��ϲ�������ɹ�",requesta("script_name")&"?hostid="&hostid
	else
			alert_redirect errstr,requesta("script_name")&"?hostid="&hostid
	end if
	conn.close
	response.end
elseif act="getroom" then
	proid=requesta("proid")
	call up.getUpInfo(proid,0,0,0)	
	response.write up.selectroomlist
	conn.close:set up=nothing
	response.end
elseif act="getosver" then
	new_proid=requesta("proid")
	new_room=requesta("room")
	call up.getUpInfo(new_proid,new_room,0,0)
	response.write up.oslist
	conn.close:set up=nothing
	response.end
elseif act="getmovedata" then
	new_proid=requesta("new_proid")
	new_room=requesta("new_room")
	new_osver=requesta("new_osver")
	call up.getUpInfo(new_proid,new_room,new_osver,0)
	ismovedataStr=lcase(up.isLimitMove)
	response.write ismovedataStr
	conn.close:set up=nothing
	response.end
elseif act="checkprice" then
	new_room=requesta("new_room")
	new_proid=requesta("new_proid")
	ismovedata=requesta("ismovedata")
	new_osver=requesta("new_osver")
	isnewip=requesta("isnewip")
	movestr=""	

	call up.getUpInfo(new_proid,new_room,new_osver,ismovedata)
	if trim(isnewip&"")="1" then
	up.setGoOnip=true
	else
	up.setGoOnip=false
	end if
 	if lcase(up.isLimitMove)="true" then 
		ismovedata=0
		if new_room<>up.s_room then			
			movestr="������Ҫ���Լ����ز�Ǩ�����ݣ�ԭ�����������ݱ�����"& up.clearDate &"�գ��뼰ʱǨ�ƣ����ں�ϵͳ���Զ������Ǩ�ƺ�󶨵���������գ���Ҫ���°�"
		end if
	elseif instr(up.new_proname,"��Ⱥ")>0 and instr(s_proname,"��Ⱥ")=0 then
		movestr="��������Ⱥ������󶨵���������գ���Ҫ���°�"	
	end if
	needPrice=up.getupNeedPrice(new_proid,new_room,ismovedata)
	cbstr=""
	if cdbl(up.cb_price)=cdbl(needprice) and cdbl(needprice)>0 then
		cbstr="(�ɱ���)"
	end if
	if cdbl(up.new_otheripPrice)>0	then new_otheripstr="+"&fmtPrice(up.new_otheripPrice)
	if cdbl(up.old_otheripPrice)>0	then old_otheripstr="+"&fmtPrice(up.old_otheripPrice)
    if up.getGoOnip then
		result="ÿ����["& fmtPrice(up.everydayPrice) &"]��ʣ������["& up.dayHave &"]+������["& fmtPrice(up.upShouXuFei) &"]=<span class=""price"">"& needPrice & "Ԫ</span>"& cbstr &"^|^" & _
		"(�¼۸�["& fmtPrice(up.newPrice)&new_otheripstr &"]-ԭ�۸�["& fmtPrice(up.oldPrice)&old_otheripstr &"])��������["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & _
		"^|^�ͺ�������["& fmtPrice(up.ProShouXuFei) &"]+ת������["& fmtPrice(up.RoomShouXuFei) &"]+����IP������["& fmtPrice(up.getGoOnIPMoney) &"]=" & fmtPrice(up.upShouXuFei) & _
		"^|^"&movestr
	else
		result="ÿ����["& fmtPrice(up.everydayPrice) &"]��ʣ������["& up.dayHave &"]+������["& fmtPrice(up.upShouXuFei) &"]=<span class=""price"">"& needPrice & "Ԫ</span>"& cbstr &"^|^" & _
		"(�¼۸�["& fmtPrice(up.newPrice)&new_otheripstr &"]-ԭ�۸�["& fmtPrice(up.oldPrice)&old_otheripstr &"])��������["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & _
		"^|^�ͺ�������["& fmtPrice(up.ProShouXuFei) &"]+ת������["& fmtPrice(up.RoomShouXuFei) &"]=" & fmtPrice(up.upShouXuFei) & _
		"^|^"&movestr
	end if
	response.write result
	conn.close:set up=nothing
	response.end
end if
call doUserSyn("vhost",up.s_comment)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-������������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script>
	var s_other_ip="<%=up.s_other_ip%>";
	var old_room=<%=up.s_room%>;
	var chgroomipmoney="<%=chgroomipmoney%>";
	var old_mysqlver="<%=up.mysqlver%>";
</script>
<script language="javascript" src="/jscripts/uphost.js?a=2016"></script>
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
				<li>������������</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
  <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">



		<table class="manager-table">
		<tbody>
			<tr>
				<th colspan=2>������������</th>
			</tr>
			<tr>
				 <th align="right" width="30%">վ������:</th>
				 <td align="left"><%=up.s_comment%></td>
			</tr>
			<tr>
				 <th align="right">ʹ��ʱ��:</th>
				 <td align="left"><%=up.s_buydate%>��<%=up.s_expiredate%>&nbsp;&nbsp;ʣ������:<%=up.dayHave%>��</td>
			</tr>
			<tr>
				 <th align="right">��ǰ�ͺ�:</th>
				 <td align="left"><%=up.s_roomname%></td>
			</tr>
			<tr>
				 <th align="right">��ǰ����:</th>
				 <td align="left"><%=up.s_ProductName%>(<%=up.s_productid%>)</td>
			</tr>
			<tr>
				 <th align="right">��ǰϵͳ:</th>
				 <td align="left"><%=up.s_osver%>)</td>
			</tr>
			<tr>
				 <th align="right">Mysql:</th>
				 <td align="left"><%=up.mysqlver%></td>
			</tr>
			<tr>
				 <th align="right">�����������ͺ�:</th>
				 <td align="left"><%=up.selectproidlist%></td>
			</tr>
			<tr id="newroomlist">
				 <th align="right">�������Ļ���:</th>
				 <td align="left"><label><%=up.selectroomlist%></label></td>
			</tr>
			<tr  id="osverlist">
				 <th align="right">����ϵͳ:</th>
				 <td align="left"><label><%=up.oslist%></label></td>
			</tr>
			<tr id="mysqlverlist">
				 <th align="right">MySql�汾:</th>
				 <td align="left"><label></label> <span id="mysqlmsg"></span></td>
			</tr>
			<tr id="ipaddr" style="display:none">
				 <th align="right">�»�������IP:</th>
				 <td align="left"><label > <input name="newromipdata" type="radio" value="1" />�� (<font color="red" id="ipdatamsg">���Ϊ��IP��+<%=chgroomipmoney%>Ԫ</font>) <input name="newromipdata" type="radio" value="0" />�� (<font color="red">ȡ��ʹ�ö���IP</font>)</label>
            </dd></td>
			</tr>
			<tr id="movedatalist" style="display:none">
				 <th align="right">�Զ�ת������:</th>
				 <td  align="left"><label style="width:60px">
        <input value="1" type="radio" name="ismovedata" checked />
        �� </label>
      <label style="width:60px">
        <input value="0" type="radio" name="ismovedata" />
        �� </label></td>
			</tr>

			<tr id="priceMethod">
				 <th align="right">ÿ����:</th>
				 <td  align="left"><label></label></td>
			</tr>
			<tr id="priceShouXuFei">
				 <th align="right">������:</th>
				 <td  align="left"><label></label></td>
			</tr>
			<tr id="needPrice">
				 <th align="right">�ϼ�:</th>
				 <td align="left"><label></label></td>
			</tr>
 <tr>
	<th colspan=2>
      <input type="button" value="ȷ������" class="manager-btn s-btn" name="subbtton" />
      <div id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">����ִ����,����ˢ�»�رո�ҳ��..</div>
    </th>
	</tr>
	<tr>
	<td colspan=2 align="left">
1.���������ͺſ��Ի�ø���Ŀռ�͸����ϵͳ��Դ��<font color=red><b>������ɺ󲻿ɳ������������ò���</b></font>�������������<br />
  
  2.�����������ĵ������ڲ��䣬��������Ϊ���¾������ͺ�ÿ��Ĳ��*����ʣ����������������ò���30Ԫ�ģ���30Ԫ���㡣<br />
  3.�����������Ӧ����ҵ�ʾ��Զ��������������ͺ������������Ʒ�����޷���ȡ��<br />
  4.��Ⱥ����ֻ������ҵ�û��������û���������Ϊ�ֲ�ʽ��Ⱥ�����������޷���������<br>
  5.���ܽ�վ�������������������������ݲ��ܱ���������Ҫ�ؽ���վ!���ԭ����������֧��asp.net������������Ҫʹ��asp.net���ܵģ�����ϵ�ͷ�����&quot;network 
  service&quot;Ȩ�ޡ�<br />
  6.���ѡ����"�Զ�ת������"������Ҫ������Ǩ����ɺ�ϵͳ������������������������IP�Ȳ���;�������Ҫ���ݣ�����ʵʱ��Ч�����ź���ͨ����֮���ٶȺ��������������̫�󣬿�����Ҫ�൱����ת��ʱ�䣬����ת��ʧ�ܡ�<br />
  7.���������ܹ���ʱ���Żݻ�������ͺŽ�����һ��������10Ԫ���ڶ�����ÿ���շ�30Ԫ; ���򳬹�20��������״δӸ�̨������Ϊ���ڻ���ʱ�������۵���30Ԫʱ��ѡ� ͨ���ײͿ�ͨ��������30���ڲ���������������ͺš�<font color="red">�����������˲��. </font><br />
<font color="red">  8.������������������ж���IP��ַ.  �����IP�����������أ����Կ�ͨ����IP�����������������������IP�����գ��ҷ��ò��˻�,��Ҫ��������,����ȡһ�����á���ѯ���ʱش� </font><br />
9.����IP�������ߵ�������˾��Ȩ��ǰ���ն���IP��ַ��������ǰ֪ͨ�ͻ����˻����ʣ�������á� <br /> 
10.���򳬹�7�������������ͺš���������·������ϵͳ�����ж��������Ѳ�����
	</td>
	</tr>
</tbody>
</table>
  <input type="hidden" name="hostid" value="<%=hostid%>" />
  <input type="hidden" name="act" />
  <input type="hidden" name="s_productid" value="<%=up.s_productid%>" />
  <input type="hidden" name="s_room" value="<%=up.s_room%>" />
  <input type="hidden" name="s_osver" value="<%=up.s_osver%>" />
  <input type="hidden" name="islimitmove" />
</form>



 


<%
function fmtPrice(byval numstr)
	if numstr<>"" and isnumeric(numstr) then
	 fmtPrice=formatnumber(Round(numstr,2),2,-1,-2,0)
	else
		fmtPrice=0.00
	end if
end function
%>



		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>