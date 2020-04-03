<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/class/diyserver_Class.asp" -->
<%
response.Charset="gb2312"
conn.open constr
id=Trim(Requesta("id"))
act=requesta("act")
dim usr_mobile
dim usr_email

if not isNumeric(id) then url_return "pleaes input ID",-1

 




p_proid="ebscloud"
 
set ds=new diyserver_class
ds.user_sysid=session("u_sysid")
ds.p_proid=p_proid
ds.setHostid=id 


act=Trim(requesta("act"))
backpage=requesta("backpage")
servicetype=trim(requesta("servicetype"))
PayMethod=trim(requesta("PayMethod"))
renewTime=trim(requesta("renewTime"))

if act="getprice" then



	ds.newservicetype=servicetype
	
	ds.newPayMethod=PayMethod
	ds.newrenewTime=renewTime
	price=ds.getpaytestprice()
	response.write price
	conn.close
	set ds=nothing
	response.End()
elseif act="sub" then
	'if datediff("d","2013-07-10",now())<0 then
		'url_return "弹性云主机暂停正式开通，预计7月10日正式上线，敬请关注，谢谢！",-1
	'end if
	ds.newservicetype=servicetype
	ds.newPayMethod=PayMethod
	ds.newrenewTime=renewTime
	if ds.dopaytest() then
		alert_redirect "恭喜，试用主机转正操作成功","/manager/servermanager/"
	elseif instr(errstr,"余额")>0 then
		alert_redirect "抱歉，余额不足！请先充值.","/manager/OnlinePay.asp?Flow=OnlinePayment"
	else
		url_return ds.errstr,-1
	end if
end If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-主机租用托管管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<style>
#loadsubinfo{ display:none; width:auto; text-align:center; color:#000; font-size:14px; }
</style>
<script language="javascript">
var id=<%=id%>;
var backpage="/manager/servermanager/";
$(function(){
	setrenewtime();
	getprice();
	$("input[name='servicetype']:radio").click(function(){getprice();});
	$("input[name='PayMethod']:radio").click(function(){setrenewtime();getprice();});
	$("input[name='subbtton']:button").click(function(){dosub();});
	$("input[name='subbtton_bak']:button").click(function(){ window.location.href=backpage;});
});
function dosub(){
	if(confirm("确定将试用主机转为正式主机吗?")){
		$("input[name='act']:hidden").val("sub");
		$("#subinfo").slideUp(50,function(){$("#loadsubinfo").slideDown();});		
		 $("form[name='form1']").submit();
				
	}
}
function setrenewtime(){
	$("#renewtime_msg").html("<select name=\"renewTime\" style=\"width:200px;\"></select>");	
	
	var renewTimeObj=$("select[name='renewTime']");
		var payObj=$("input[name='PayMethod']:radio:checked");
		renewTimeObj.empty();
		var timelist="";
		var dw="";
		if(payObj.val()=="0"){
			timelist="1";
				diy_msg_txt=""
			dw="个月";
		}else if(payObj.val()=="1"){
			timelist="1,2,3,4,5";
			diy_msg_txt=",,,,"
			dw="年";
		}else if(payObj.val()=="2"){
			timelist="1,2,3,4";
			diy_msg_txt=",,,"
			dw="季度";
		}else if(payObj.val()=="3"){
			timelist="1,2,3,4";
			diy_msg_txt=",,,"
			dw="个月"
		}
temparraylist=diy_msg_txt.split(",")
			$.each(timelist.split(","),function(i,n){
				var nn=n;
				if(payObj.val()=="3") nn=parseInt(n) * 6;
				renewTimeObj.append("<option value=\""+ $.trim(n) +"\">"+ nn + dw +temparraylist[n-1]+"</option>");
			});	
			
		
		renewTimeObj.change(function(){getprice();});
		getpreday();
}
function getpreday(){
	var payObj=$("input[name='PayMethod']:radio:checked");
	var renewTimeObj=$("select[name='renewTime'] option");
	var renewTime="";var preyear=0;var nndw="";
	$.each(renewTimeObj,function(i,n){renewTime+=$(n).val()+",";});
	$.post("/services/Server/Order.asp","act=getpreday&PayMethod="+ escape(payObj.val())+"&renewTime="+escape(renewTime),function(msg){
		predayArr=msg.split(',');
		$.each(renewTimeObj,function(i,n){
			if(predayArr[i]>0){
				preyear=predayArr[i]/360+"年";
				nndw=$(n).text();
				$(n).text(nndw+" (买"+ nndw +"赠送"+(preyear=="0.5年"?"半年":preyear)+")");
			}
		}); 
	})
}
function getprice(){
	var servicetype=$("input[name='servicetype']:radio:checked").val();
	var PayMethod=$("input[name='PayMethod']:radio:checked").val();
	var renewTime=$("select[name='renewTime'] option:selected").val();
	$("#moneycodeprice_msg").css({"color":"#ccc"});
	$.post(window.location.mappath,"id="+ id +"&act=getprice&servicetype="+ escape(servicetype)+"&PayMethod="+ escape(PayMethod)+"&renewTime="+renewTime,function(data){
		$("#moneycodeprice_msg").html("￥"+data);
		$("#moneycodeprice_msg").css({"color":"red"});
		$("input[name='mc_oldprice']:hidden").val(data);
		//getMoneycodeprice();
	})
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/Manager/servermanager/">独立IP主机管理</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
 
   
<form name="form1" action="<%=Requesta("script_name")%>" method="post">
 <table class="manager-table">             
	<tbody>
		<tr><th colspan=2>试用主机转正</th></tr>
		<tr>
			<th align="right">服务器IP地址:</th>
			<td align="left"><%=ds.oldserverip%></td>
		</tr>
		<tr>
			<th align="right">服务标准:<br />
                <a href="/services/server/vip.asp" target="_blank" style="font-size:12px; color:#06c; font-weight:normal;" title="查看服务标准">(查看服务标准)</a></th>
			<td align="left"> <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>基础服务">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>基础服务</a>&nbsp;&nbsp;免费(适合专业级客户,服务器内部问题单项收费) </label><BR>
              <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>铜牌服务" checked>
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>铜牌服务</a>&nbsp;&nbsp;加68元/月(适合一般客户,提供标准技术支持) </label><BR>
              <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>银牌服务">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>银牌服务</a>&nbsp;&nbsp;加98元/月(适合初级客户,提供优先技术支持) </label><BR>
              <label class="msg">
                <input type="radio" name="servicetype" value="<%=companyname%>金牌服务">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>金牌服务</a>&nbsp;&nbsp;加188元/月(适合VIP客户,提供全方位技术支持) </label>
              </label></td>
		</tr>
		<tr>
			<th align="right">付费方式:</th>
			<td align="left"><%=ds.getVpsPayMethod()%></td>
		</tr>
		<tr>
			<th align="right">购买时长:</th>
			<td align="left" id="renewtime_msg" >1</td>
		</tr>

		<tr  id="needPrice">
			<th align="right">所需费用:</th>
			<td align="left" id="renewtime_msg" >1</td>
		</tr>
		<tr>
			<th align="right">所需费用:</th>
			<td align="left"> <label class="msg" id="moneycodeprice_msg" style="width:auto;font-weight:bold">￥0</label>
              <label class="msg" style="width:auto"></label>
                <input type="hidden" name="mc_proid" value="<%=p_proid%>" />
                <input type="hidden" name="mc_prokey" value="<%=id%>" />
                <input type="hidden" name="mc_action" value="new" />
                <input type="hidden" name="mc_oldprice" /></td>
		</tr>
		<tr>
		 <td colspan=2>
		 <div id="subinfo">
		 <input type="button" class="manager-btn s-btn" name="subbtton" value="确定转正" />
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="manager-btn s-btn" name="subbtton_bak" value="返回" />
		</div>
			   <div id="loadsubinfo"><img src="/images/mallload.gif"> 数据正在处理中.请勿刷新或关闭浏览器...</div>
			    <input type="hidden" value="<%=id%>" name="id" />
			    <input type="hidden" name="act" />
			  </td>
		</tr>
	</tbody>
</table>
  



       
      
      </form>
   
   











		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>