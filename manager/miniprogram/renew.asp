<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/miniprogram_class.asp" --> 
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->  
<%
response.Charset="gb2312" 
conn.open constr
appid=requesta("appid")
if not isnumeric(appid&"") then url_return "没有找到此小程序",-1 

set app=new miniprogram
app.setuid=session("u_sysid")
if trim(app.errmsg)<>"" then call url_return(app.errmsg,-1)
app.setAppid=appid
If trim(app.errmsg)<>"" Then call url_return(app.errmsg,-1) 
app.setproid=app.db_proid
If trim(app.errmsg)<>"" Then call url_return(app.errmsg,-1) 
if not  app.getproductids()  Then call url_return(app.errmsg,-1) 

dim paytype_action,paytypetxt
paytypetxt="正式"
paytype_action="renew"
if app.db_paytype&""="1" then paytype_action="new":paytypetxt="试用"
appprice=GetNeedPrice(app.user_name,app.db_proid,1,paytype_action)
 
otherids=app.db_otherproid
set otherprices=newoption()
if trim(otherids)<>"" then
	for each obj_ in app.appconfig("config")

		if instr(","&otherids&",",","&obj_("id")&",")>0 then 
			otherprices.add obj_("proid"),GetNeedPrice(app.user_name,obj_("proid"),1,paytype_action) 
		end if
	next
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-微信小程序管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <script type="text/javascript" src="/noedit/template.js"></script>
   <style>
	.money{color:red;}
   </style>
</HEAD>
<script>
	var username="<%=app.user_name%>";
	var cfg=<%=aspjsonPrint(app.appconfig)%>;
	var tcids="<%=app.db_tcproid%>";
	var otherids="<%=otherids%>";
	var appprice=<%=appprice%>;
	var usemoney="<%=app.u_usemoney%>";
	var otherprices=<%=aspjsonPrint(otherprices)%>;
	var paytypemoney=<%=miniprogram_paytype_money%>;
	var paytype=<%=app.db_paytype%>;
	$(function(){
		if(paytype=="0"){paytypemoney=0}
		init(); 
	})

	

	function init(){
		var system_app=$("#system_app");
		var other_app=$("#other_app")
		$.each(tcids.split(","),function(i,n){ 
			$.each(cfg.config,function(cfgi,cfgn){ 
					if(cfgn.id==n){
						system_app.append("<li>"+cfgn.name+"</li>");
						return false;
					} 
			})
		})	

		$.each(otherids.split(","),function(i,n){ 
			$.each(cfg.config,function(cfgi,cfgn){ 
					if(cfgn.id==n){
						other_app.append('<li><label><input type="checkbox" name="otherids" value="'+cfgn.id+'" data-pro="'+cfgn.proid+'" checked>  '+cfgn.name+'</label><span class="money" id="other_price_'+cfgn.id+'"> &yen; '+getotherprice(cfgn.proid)+' /年</span></li>');
						return false;
					} 
			})
		})	
		$("select[name='renyear']").on("change",function(){
			console.log("修改年限")
			ShowSumPrice();
		})

		$("input[name='otherids']").on("click",function(){
			ShowSumPrice();
		})
		$("input[name='C1']").on("click",function(){
			  var obj_=$(this);
			  obj_.attr("disabled","disabled");
			  obj_.val("数据提交中,请稍后...")
		      $.dialog.confirm("您确定要对此小程序进行续费操作?",function(){
					$.ajax({
						type: "POST",
						url: "load.asp",
						data: $("form[name='renewform']").serialize(),
						dataType: "JSON",
						success: function (response) {
							if (response.result=="200") {
								$.dialog.alert("续费成功!",function(){
									location.href="./"
								});
								
							}else{
								$.dialog.alert(response.msg);
							}
							
						}
					},"json");
			  },function(){
				 obj_.removeAttr("disabled");
				 obj_.val("立即续费")
			  })

		})
		ShowSumPrice();
	}

	function ShowSumPrice(){
		 var year_=$("select[name='renyear']").val() || 1;
		 var otherprice=0;
		 var obj=$("input[name='otherids']:checked")
		 $.each(obj,function(i,n){
			 	 var proid_=$(this).attr("data-pro") || '';
				 if (proid_!="") {
					 otherprice=parseFloat(otherprice)+parseFloat(getotherprice(proid_));
				 } 
		 });
		 var sumprice=((parseFloat(appprice)+parseFloat(otherprice))*parseFloat(year_))-parseFloat(paytypemoney);
		 $("#moneycodeprice_msg").html("&yen; " +sumprice)
	}

	function getotherprice(id){
		var price_=0;
		$.each(otherprices,function(i){
				if(id==i){
					price_= otherprices[i] || 0; 
					return false;
				} 
		})
		return price_;
		
	}

	
	
</script>
<body>

 <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>微信小程序</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
                <form name="renewform" method="post" action="/manager/miniprogram/renew.asp">
					 <div class="mf-title">微信小程序</div>
					 <div class="mf-search"></div>
					<table class="manager-table form-table">
						<tbody>
							<tr>
								<th align="right">套餐名称：</th>
								<td align="left">
									<%=app.p_name%>
								</td>
							</tr>
							<tr>
								<th align="right">小程序名称：</th>
								<td align="left">
									<%=app.db_appName%>
								</td>
							</tr>
							<tr>
								<th align="right" width="300">产品型号：</th>
								<td align="left"><%=app.db_proid%></td>
							</tr>
							<tr>
								<th align="right">开通时间：</th>
								<td align="left"><%=app.db_buyDate%></td>
							</tr>
							<tr>
								<th align="right">到期时间：</th>
								<td align="left"><%=app.db_expireDate%></td>
							</tr>
							<tr>
								<th  align="right">系统应用：</th>
								<td align="left">
									<ul id="system_app"></ul> 
								</td>
							</tr>
							<tr>
								<th align="right">额外程序</th>
								<td align="left">
									<ul id="other_app"></ul>
								</td>
							</tr>
							
							<tr>
								<th align="right">购买时间：</th>
								<td align="left">
									<select name="renyear" class="manager-select m-select">
										<option value="1">1/年</option>
										<option value="2">2/年</option>
										<option value="3">3/年</option>
									</select>
								</td>
							</tr>
							<tr>
								<th align="right">购买金额：</th>
								<td align="left" class="money redColor"><span id="moneycodeprice_msg"></span> 
								 
							</tr>
							<tr class="no-border">
								<td></td>
								<td align="left">
									<input type="hidden" name="act" value="renew">
									<input type="hidden" name="appid" value="<%=app.db_appid%>">
									<input name="C1" type="button" class="manager-btn l-btn" value="立即续费">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
          </div>
        </div>
    </div>
</div>
 <!--#include virtual="/manager/bottom.asp" -->

</body>
</html>