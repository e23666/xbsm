<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>后台管理首页</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="/manager/css/Admin_Style.css" rel=stylesheet>
<META content="MSHTML 6.00.6000.16525" name=GENERATOR>
<style type="text/css">
<!--
.STYLE5 {
	color: #999999
}
.fil {
	position:absolute;
	filter:dropshadow(color=#cccccc, offx=1, offy=1);
	font-size:12px;
	font-weight:bold;
	color:#2a7fbc;
	left: 26px;
}
.STYLE7 {
	color: #FFFFFF;
	font-weight: bold;
}
.STYLE9 {
	font-weight: bold;
	color: #FFBA32;
}
.STYLE10 {
	color: #FF3E3E;
	font-weight: bold;
}
.STYLE11 {
	color: #666666;
}
-->
</style>
<script language="javascript">
function noSeamMarquee(obj,max,t,h){
  if(h==0)
    cont=obj.innerHTML;  
  obj.innerHTML+=cont;

  if(h>max)
    eval('clearTimeout(timer_'+obj.id+')');
  h++;
  eval('timer_'+obj.id+'=setTimeout("noSeamMarquee('+obj.id+','+max+','+t+','+h+')",'+t*1000+');');
}
function border_left(tabpage,left_tabid){
var oItem = window.parent.document.getElementById(tabpage).getElementsByTagName("li"); 

    for(var i=0; i<oItem.length; i++){
        var x = oItem[i];    
        x.className = "";
}
	window.parent.document.getElementById(left_tabid).className = "Selected";
	var dvs=window.parent.document.getElementById("left_menu_cnt").getElementsByTagName("ul");
	for (var i=0;i<dvs.length;i++){
	  if (dvs[i].id==('d'+left_tabid))
	    dvs[i].style.display='block';
	  else
  	  dvs[i].style.display='none';
	}
}
function doopenpage(tabpage,left_tabid,title,tabid,tourl){
		border_left(tabpage,left_tabid);
		var objtab=window.parent.document.getElementById(tabid);
		go_cmdurl(title,objtab);
		window.parent.frames['content3'].location.href=tourl;

}
function go_cmdurl(title,tabid){
	show_title(title);
	switchTab('TabPage1','Tab3');
	menu(window.parent.document.getElementById('Tab3')); 
	dleft_tab_active('TabPage3',tabid);
}
function show_title(str){
	window.parent.document.getElementById("dnow99").innerHTML=str;
}
function dleft_tab_active(tabpage,activeid){
	var obj=activeid;
	var oItem = window.parent.document.getElementById(tabpage).getElementsByTagName("a"); 
		for(var i=0; i<oItem.length; i++){
			var x = oItem[i];    
			x.className = "";
	}
		obj.className = "Selected";
}
function menu(tab){
	if(tab.style.display=='block')tab.style.display='block';
	else tab.style.display='block';
}
function switchTab(tabpage,tabid){
var oItem = window.parent.document.getElementById(tabpage).getElementsByTagName("li");

    for(var i=0; i<oItem.length; i++){
        var x = oItem[i];    
        x.className = "";
}
	window.parent.document.getElementById(tabid).className = "Selected";
	var dvs=window.parent.document.getElementById("cnt").getElementsByTagName("div");
	for (var i=0;i<dvs.length;i++){
	  if (dvs[i].id==('d'+tabid))
	    dvs[i].style.display='block';
	  else
  	  dvs[i].style.display='none';
	}
}
</script>
</HEAD>
<BODY topMargin=0 marginheight="0">
<%
conn.open constr
sql="select [notice] from systemvar"
rs.open sql,conn,1,1
if not rs.eof then info=trim(rs("notice"))
rs.close
isdisplay=""
if info="" then isdisplay="none"
%>
<table width="801" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left"><table width="100%" align='left' cellpadding='0' cellspacing='0' style="border: 1px solid #99bbdd;" height="30">
        <tr>
          <td width="50%" align="left" background="/manager/images/style/win_top.png" nowrap ><span class="STYLE7"> &nbsp;用户名称:<%=session("user_name")%>&nbsp;&nbsp;
            可使用金额:<%= session("u_usemoney") %>元&nbsp;&nbsp;
            已消费金额:<%= session("u_resumesum") %>元&nbsp;&nbsp; </span></td>
          <td width="50%"  align="left" nowrap background="/manager/images/style/win_top.png" style=" display:<%=isdisplay%>"><span class="STYLE9"><img src="/manager/images/style/tan_12.gif" width="16" height="16" border="0">&nbsp;紧急通知:</span>
            <marquee scrolldelay="120">
            <span class="STYLE9"><%=info%></span>
            </marquee>
            </div>
          </td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="1" background="/manager/images/style/bg_dot.gif"></td>
  </tr>
  <tr>
    <td><table width="95%" border="0" cellpadding="3" cellspacing="0">
        <tr>
          <td><a href="/services/domain/" target="_blank"><img src="/manager/images/Style/button_1.jpg" width="117" height="19" border=0></a></td>
          <td><a href="/services/webhosting/" target="_blank"><img src="/manager/images/Style/button_2.jpg" width="117" height="19" border=0></a></td>
          <td><a href="#" onClick="border_left('TabPage2','left_tab2')"><img src="/manager/images/Style/button_3.jpg" width="117" height="19" border=0></a></td>
          <td><a href="/customercenter/howpay.asp" target="_blank"><img src="/manager/images/Style/button_5.jpg" width="117" height="19" border=0></a></td>
          <td><a href=# onClick="doopenpage('TabPage2','left_tab5','有问必答','question11','/manager/question/subquestion.asp')"><img src="/manager/images/Style/button_6.jpg" width="117" height="19" border=0></a></td>
          <td><a href="/faq/" target="_blank"><img src="/manager/images/Style/button_4.jpg" width="117" height="19" border=0></a></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="1" background="/manager/images/style/bg_dot.gif"></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="7">
        <tr>
          <td width="50%" valign="top" ><table width="100%" cellpadding="0" cellspacing="0" style="border: 1px solid #99bbdd;">
              <tr>
                <td width="90%" height="28" nowrap background="/manager/images/Style/news_bg.gif"><strong>&nbsp;·&nbsp;新闻中心</strong></td>
                <td width="10%" nowrap background="/manager/images/Style/news_bg.gif"><a href="/news/default.asp" target="_blank" class="STYLE11"> More..</a></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="24%" valign="top"><img src="/manager/images/Style/diploma.png" width="100" height="100" ></td>
                      <td width="76%" valign="top"><ul>
                          <%
	  sql="select top 5 * from news order by newsid desc"
	  rs.open sql,conn,1,3
		xx=0
	  if not rs.eof then
		  do while not rs.eof
		  %>
                          <li><a href="<%=InstallDir%>news/list.asp?newsid=<%=rs("newsid")%>" target="_blank"><%= gotTopic(rs("newstitle"),15) %></a> <span class="STYLE5">[<%=formatdatetime(rs("newpubtime"),2)%>]</span></li>
                          <%
			xx=xx+1
		  rs.movenext
		 if xx=6 then exit do
		  loop
	  else
	  %>
                          <li>....暂无新闻....</li>
                          <%
	 end if
	  %>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td width="50%" valign="top" ><table width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" style="border: 1px solid #99bbdd;">
              <tr>
                <td nowrap  background="/manager/images/Style/news_bg.gif" height="28" colspan=2><strong> 常见问题</strong></td>
              </tr>
              <tr>
                <td width="23%" valign="top"><img src="/manager/images/style/chat.png" width="100" height="100"  border=0> </td>
                <td width="77%"><ul>
                    <li><a href="/faq/list.asp?unid=6" target="_bank">怎么添加二级域名? </a></li>
                    <li><a href="/faq/list.asp?unid=19" target="_bank">如何将域名和虚拟主机绑定？</a></li>
                    <li><a href="/faq/list.asp?unid=18" target="_bank">如何将我的文件上传到服务器？ </a></li>
                    <li><a href="/faq/list.asp?unid=14" target="_bank">如何用asp的jmail发邮件？</a></li>
                    <li><a href="/faq/list.asp?unid=4" target="_bank">什么是域名解析？</a> </li>
                  </ul></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="1" background="/manager/images/style/bg_dot.gif"></td>
  </tr>
  <tr>
    <td height="0" align="center" valign="top"><table width="671" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0">
              <tr valign="middle">
                <td width="58"><img src="/manager/images/style/cs3.gif" width="58" height="44" border="0"> </td>
                <td width="102" align="left" nowrap><ul>
                    <li><a href=# onClick=" doopenpage('TabPage2','left_tab3','发票索取','fapiao11','/manager/useraccount/fapiao.asp')" >发票索取</a></li>
                    <li><a href=# onClick=" doopenpage('TabPage2','left_tab3','财务明细','mlist11','/manager/useraccount/mlist.asp')">财务明细</a></li>
                    <li><a href="/customercenter/howpay.asp" target="_blank">预付款支付</a></li>
                  </ul></td>
              </tr>
            </table></td>
          <td><table border="0" cellpadding="0" cellspacing="0">
              <tr valign="middle">
                <td width="58"><img src="/manager/images/style/cs4.gif" width="58" height="44" border="0"></td>
                <td width="96" align="left" nowrap><ul>
                    <li><a href=# onClick=" doopenpage('TabPage2','left_tab1','域名管理','domain11','/manager/domainmanager/default.asp')">域名管理</a></li>
                    <li><a href=# onClick=" doopenpage('TabPage2','left_tab1','空间管理','host11','/manager/sitemanager/default.asp')">空间管理</a></li>
                    <li><a href=# onClick=" doopenpage('TabPage2','left_tab1','邮局管理','mail11','/manager/mailmanager/default.asp')">邮局管理</a></li>
                  </ul></td>
              </tr>
            </table></td>
          <td ><table border="0" cellpadding="0" cellspacing="0">
              <tr valign="middle">
                <td width="55"><img src="/manager/images/style/cs5.gif" width="55" height="43" border="0"> </td>
                <td align="left" nowrap><ul>
                    <li><a href="/customercenter/buystep.asp" target="_blank">业务开通流程</a></li>
                    <li><a href=# onClick="doopenpage('TabPage2','left_tab2','域名订单','domainorder11','/manager/ordermanager/domain/default.asp')">域名订单查询</a></li>
                    <li><a href=# onClick="doopenpage('TabPage2','left_tab2','主机订单','hostorder11','/manager/ordermanager/vhost/default.asp')">主机订单查询</a></li>
                  </ul></td>
              </tr>
            </table></td>
          <td ><table border="0" cellpadding="0" cellspacing="0">
              <tr valign="middle">
                <td width="55"><img src="/manager/images/style/cs6.gif" width="58" height="44" border="0"> </td>
                <td align="left" nowrap><ul>
                    <li><a href=# onClick="doopenpage('TabPage2','left_tab6','修改资料','userpage11','/manager/usermanager/default2.asp')">个人资料修改</a></li>
                    <li><a href="/bagshow/" target="_blank">购物车</a></li>
                    <li class="STYLE10"><a href="<%=manager_url%>" target="_blank">独立控制面板</a></li>
                  </ul></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td><hr size=1 color="#99bbdd" width=98%></td>
  </tr>
  <tr>
    <td><table width="98%" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr align="center">
          <td align="left"><a href="/agent/" target="_blank"><img src="/Template/Tpl_01/images/Default_107.gif" border=0></a></td>
          <td><a href="/services/domain/" target="_blank"><img src="/Template/Tpl_01/images/ad_061214_02.gif" border=0></a></td>
          <td align="right"><a href="/services/domain/defaultcn.asp" target="_blank"><img src="/Template/Tpl_01/images/ad_061214_03.gif" border=0></a></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td><hr size=1 color="#99bbdd" width=98%></td>
  </tr>
  <tr>
    <td align="center"><table width="98%" border="0" cellpadding="0" cellspacing="0" >
        <tr>
          <td width="98%" height="27" align="left" nowrap ><img src="/manager/images/style/dot.jpg">公司名称：<a href="<%=companynameurl%>" target="_blank"><%=companyname%></a></td>
        </tr>
        <tr>
          <td colspan=2 background="/manager/images/style/bg_dot.gif" height="1"></td>
        </tr>
        <tr>
          <td width="98%" height="27" align="left" nowrap ><img src="/manager/images/style/dot.jpg">公司地址：<%=companyaddress%></td>
        </tr>
        <tr>
          <td colspan=2 background="/manager/images/style/bg_dot.gif" height="1"></td>
        </tr>
        <tr>
          <td width="98%" height="27" nowrap><img src="/manager/images/style/dot.jpg">电话号码：<%=telphone%></td>
        </tr>
        <tr>
          <td colspan=2 background="/manager/images/style/bg_dot.gif" height="1"></td>
        </tr>
        <tr>
          <td nowrap><img src="/manager/images/style/dot.jpg">QQ：
            <%
	for each qqstr in split(oicq,",")
		if isnumeric(qqstr) then
	%>
            <a target=blank href=tencent://message/?uin=<%=qqstr%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=qqstr%>:4 alt="点击发送消息给对方"><%=qqstr%></a>
            <%end if
	next
	%>
          </td>
        </tr>
      </table></td>
  </tr>
</table>
</BODY>
</HTML>
