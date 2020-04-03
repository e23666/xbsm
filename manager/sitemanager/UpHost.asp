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
			alert_redirect "恭喜，升级成功",requesta("script_name")&"?hostid="&hostid
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
			movestr="升级需要您自己下载并迁移数据，原服务器的数据保留至"& up.clearDate &"日，请及时迁移，过期后系统会自动清除。迁移后绑定的域名将清空，需要重新绑定"
		end if
	elseif instr(up.new_proname,"集群")>0 and instr(s_proname,"集群")=0 then
		movestr="升级到集群主机后绑定的域名将清空，需要重新绑定"	
	end if
	needPrice=up.getupNeedPrice(new_proid,new_room,ismovedata)
	cbstr=""
	if cdbl(up.cb_price)=cdbl(needprice) and cdbl(needprice)>0 then
		cbstr="(成本价)"
	end if
	if cdbl(up.new_otheripPrice)>0	then new_otheripstr="+"&fmtPrice(up.new_otheripPrice)
	if cdbl(up.old_otheripPrice)>0	then old_otheripstr="+"&fmtPrice(up.old_otheripPrice)
    if up.getGoOnip then
		result="每天差价["& fmtPrice(up.everydayPrice) &"]×剩余天数["& up.dayHave &"]+手续费["& fmtPrice(up.upShouXuFei) &"]=<span class=""price"">"& needPrice & "元</span>"& cbstr &"^|^" & _
		"(新价格["& fmtPrice(up.newPrice)&new_otheripstr &"]-原价格["& fmtPrice(up.oldPrice)&old_otheripstr &"])÷总天数["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & _
		"^|^型号手续费["& fmtPrice(up.ProShouXuFei) &"]+转移数据["& fmtPrice(up.RoomShouXuFei) &"]+独立IP手续费["& fmtPrice(up.getGoOnIPMoney) &"]=" & fmtPrice(up.upShouXuFei) & _
		"^|^"&movestr
	else
		result="每天差价["& fmtPrice(up.everydayPrice) &"]×剩余天数["& up.dayHave &"]+手续费["& fmtPrice(up.upShouXuFei) &"]=<span class=""price"">"& needPrice & "元</span>"& cbstr &"^|^" & _
		"(新价格["& fmtPrice(up.newPrice)&new_otheripstr &"]-原价格["& fmtPrice(up.oldPrice)&old_otheripstr &"])÷总天数["& up.dayCount &"]="& fmtPrice(up.everydayPrice) & _
		"^|^型号手续费["& fmtPrice(up.ProShouXuFei) &"]+转移数据["& fmtPrice(up.RoomShouXuFei) &"]=" & fmtPrice(up.upShouXuFei) & _
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
<title>用户管理后台-虚拟主机升级</title>
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			    <li><a href="/Manager/sitemanager/">虚拟管理管理</a></li>
				<li>虚拟主机升级</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
  <form name="form_uphost" action="<%=requesta("script_name")%>" method="post">



		<table class="manager-table">
		<tbody>
			<tr>
				<th colspan=2>虚拟主机升级</th>
			</tr>
			<tr>
				 <th align="right" width="30%">站点名称:</th>
				 <td align="left"><%=up.s_comment%></td>
			</tr>
			<tr>
				 <th align="right">使用时间:</th>
				 <td align="left"><%=up.s_buydate%>～<%=up.s_expiredate%>&nbsp;&nbsp;剩余天数:<%=up.dayHave%>天</td>
			</tr>
			<tr>
				 <th align="right">当前型号:</th>
				 <td align="left"><%=up.s_roomname%></td>
			</tr>
			<tr>
				 <th align="right">当前机房:</th>
				 <td align="left"><%=up.s_ProductName%>(<%=up.s_productid%>)</td>
			</tr>
			<tr>
				 <th align="right">当前系统:</th>
				 <td align="left"><%=up.s_osver%>)</td>
			</tr>
			<tr>
				 <th align="right">Mysql:</th>
				 <td align="left"><%=up.mysqlver%></td>
			</tr>
			<tr>
				 <th align="right">升级到的新型号:</th>
				 <td align="left"><%=up.selectproidlist%></td>
			</tr>
			<tr id="newroomlist">
				 <th align="right">升级到的机房:</th>
				 <td align="left"><label><%=up.selectroomlist%></label></td>
			</tr>
			<tr  id="osverlist">
				 <th align="right">操作系统:</th>
				 <td align="left"><label><%=up.oslist%></label></td>
			</tr>
			<tr id="mysqlverlist">
				 <th align="right">MySql版本:</th>
				 <td align="left"><label></label> <span id="mysqlmsg"></span></td>
			</tr>
			<tr id="ipaddr" style="display:none">
				 <th align="right">新机房独立IP:</th>
				 <td align="left"><label > <input name="newromipdata" type="radio" value="1" />是 (<font color="red" id="ipdatamsg">变更为新IP，+<%=chgroomipmoney%>元</font>) <input name="newromipdata" type="radio" value="0" />否 (<font color="red">取消使用独立IP</font>)</label>
            </dd></td>
			</tr>
			<tr id="movedatalist" style="display:none">
				 <th align="right">自动转移数据:</th>
				 <td  align="left"><label style="width:60px">
        <input value="1" type="radio" name="ismovedata" checked />
        是 </label>
      <label style="width:60px">
        <input value="0" type="radio" name="ismovedata" />
        否 </label></td>
			</tr>

			<tr id="priceMethod">
				 <th align="right">每天差价:</th>
				 <td  align="left"><label></label></td>
			</tr>
			<tr id="priceShouXuFei">
				 <th align="right">手续费:</th>
				 <td  align="left"><label></label></td>
			</tr>
			<tr id="needPrice">
				 <th align="right">合计:</th>
				 <td align="left"><label></label></td>
			</tr>
 <tr>
	<th colspan=2>
      <input type="button" value="确定升级" class="manager-btn s-btn" name="subbtton" />
      <div id="loadsubinfo" style="display:none"><img src="/images/mallload.gif">正在执行中,请勿刷新或关闭该页面..</div>
    </th>
	</tr>
	<tr>
	<td colspan=2 align="left">
1.升级主机型号可以获得更大的空间和更多的系统资源。<font color=red><b>升级完成后不可撤销，升级费用不退</b></font>，请谨慎操作！<br />
  
  2.升级后主机的到期日期不变，升级费用为：新旧主机型号每天的差价*主机剩余的天数。升级费用不足30元的，按30元计算。<br />
  3.主机升级后对应的企业邮局自动升级，但是新型号如果有域名赠品，则无法获取。<br />
  4.集群主机只接收企业用户，个人用户请勿升级为分布式集群主机，否则无法绑定域名。<br>
  5.智能建站主机，如果跨机房升级，刚数据不能被保留，需要重建网站!如果原来的主机不支持asp.net，而升级后需要使用asp.net功能的，请联系客服增加&quot;network 
  service&quot;权限。<br />
  6.如果选择了"自动转移数据"，则需要等数据迁移完成后，系统再完成域名解析、变更服务器IP等操作;如果不需要数据，则是实时生效。电信和网通机房之间速度很慢，如果数据量太大，可能需要相当长的转移时间，甚至转移失败。<br />
  7.升级不享受购买时的优惠活动，主机型号降级第一次手续费10元，第二次起每次收费30元; 购买超过20天的主机首次从港台机房升为国内机房时，升级价低于30元时免费。 通过套餐开通的主机在30天内不能升级变更主机型号。<font color="red">主机降级不退差价. </font><br />
<font color="red">  8.如果此虚拟主机申请有独立IP地址.  因独立IP与机房密切相关，所以开通独立IP后若主机更换机房，则独立IP将回收，且费用不退还,如要撤销升级,则将收取一定费用。详询有问必答 </font><br />
9.独立IP若因政策调整，我司有权提前回收独立IP地址，但会提前通知客户并退还相关剩余服务费用。 <br /> 
10.购买超过7天的主机，变更型号、机房、线路、操作系统，会有额外手续费产生。
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