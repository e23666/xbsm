<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/class/weixin_pay.asp" -->
<!--#include virtual="/config/class/aspframework.asp"-->
<%
response.Charset="gb2312"
act=requesta("westact")

if trim(session("user_name"))="" then 
	die echojson(500,"no login","")
end if

select case trim(act)
	case "westpay":call westpay()
	case "westui":call westui()
	case "query":call query()
	case "getpayinfo":call getpayinfo()
	case else:die echojson(500,"error!","")
end select

sub query()
	'die "200 ok"
	orderid=requesta("orderid")
	if not isnumeric(orderid&"") then die "500 err"
	orderid=orderid-100000
	conn.open constr
	sql="select 1 from ring where ring_id="&orderid&" and  ring_ov="&PE_True&""
	set trs=conn.execute(sql)
	if not  trs.eof then 
		die "200 ok"
	else
		die "300 wait"
	end if

	
end sub

Function GetOrder(r_price,r_type,r_value)
	tmpOrderID=0
	TStamp=Now()
	newr_price=replace(r_price,",","")
	user_name=Session("user_name")
	if user_name="" then url_return "会话失效，请重新登录！",-1
	Sql="Insert into Ring (Ring_us,Ring_tp,Ring_ve,Ring_pr,Ring_dt,Ring_ov) values ('" & user_name &"'," & r_type & ",'" & r_value &"'," &newr_price& ",'"& tstamp &"',"&PE_False&")"
	conn.Execute(Sql)
	if isdbsql then
	Sql="Select top 1 Ring_id from Ring Where Ring_dt='" & TStamp &"' and Ring_us='" & user_name & "' order by ring_id desc"
	else
	Sql="Select top 1 Ring_id from Ring Where Ring_dt=#" & TStamp &"# and Ring_us='" & user_name & "' order by ring_id desc"
    end if
	Set OrderRs=conn.Execute(Sql)
	if not OrderRs.eof then
		tmpOrderID=OrderRs("Ring_id")
	else
		url_return "发生意外，请与管理员联系",-1
	end if
	OrderRs.close
	Set OrderRs=nothing
	if Clng(tmpOrderID)>9999999999999999 then 
		url_return "订单资源用完，请与管理员联系",-1
	end if
	GetOrder=100000 + tmpOrderID
end Function

sub getpayinfo()
	dim payMoney,httpstr
	httpstr="http://"
	If ishttps Then httpstr="https://"
	agentPage=httpstr& requesta("HTTP_HOST") & "/manager/onlinePay/onlinePayEnd.asp"
	payMoney=requesta("payMoney")
	paytype=requesta("paytype")
	if not isnumeric(payMoney&"") then die echojson(500,"录入金额有误!","")
	conn.open constr
	if paytype="wxpay" then
		payName="本站微信在线支的付"
		pay_fy=wxpay_fy
		payOrderID=GetOrder(payMoney,1,payName)
		payMoney=round(payMoney+payMoney*pay_fy,2)
		Set wx=New weixin_pay
		Set p=newoption()
		p.add "orderno",payOrderID
		p.add "subject","在线支的付"
		p.add "total",payMoney

		wxurl=wx.pay(p)

		If Left(wxurl,9)="weixin://" Then
			die "{""code"":200,""msg"":""订单请求成功!"",""ring"":"""&payOrderID&""",""wxurl"":"""&wxurl&"""}"
		else
			die "{""code"":500,""msg"":"""&wxurl&"!""}"
		End if
	else
		payName="系统默认支付接口"
		pay_fy=defaultpay_fy 
		payContent=""
		payOrderID=GetOrder(payMoney,1,payName)
		payMoney=round(payMoney+payMoney*pay_fy,2)
		payMoney=formatnumber(payMoney,2,-1,-1,0)
		users=session("user_name")
		payMoney=formatnumber(payMoney,2,-1,-1,0)
		agentMid5str=trim(agentPage & payOrderID & session("user_name") & api_username & payMoney & api_password)
		agentMid5 = md5_32(agentMid5str) 
		'die trim(agentPage & payOrderID & session("user_name") & api_username & payMoney & api_password)


		strdata="agentPage="&server.urlencode(agentPage)&"&agentRingnum="&payOrderID&"&users="&server.urlencode(users)&"&ring_us="&api_username&"&dj="&payMoney&"&agentMid5="&agentMid5&"&paytype="&paytype 
		a=OpenRemoteUrl("http://api.vhostgo.com/api/agentpay/",strdata) 
	end if 
	die a
end sub

function echojson(byval code,byval msg,byval other)
	echojson="{code:"&code&",msg:"""&msg&""""&other&"}"
end function


sub westpay()
	dim agentPage,agentRingnum,users,ring_us,dj,agentMid5,postdate,westtype
	agentPage=requesta("agentPage")
	agentRingnum=requesta("agentRingnum")
	users=requesta("users")
	ring_us=requesta("ring_us")
	dj=requesta("dj")
	agentMid5=requesta("agentMid5")
	westtype=requesta("westtype")
	postdate="agentPage="&server.urlencode(agentPage)&"&agentRingnum="&agentRingnum&"&users="&users&"&ring_us="&ring_us&"&dj="&dj&"&agentMid5="&agentMid5&"&paytype="&westtype
	die postdate
	a=OpenRemoteUrl("http://api.west263.com/api/agentpay/",postdate) 
	die a
end sub

sub westui()
	intmoney = requesta("money")
	paytype = requesta("paytype")
 
	orderid=requesta("orderid")
	if not isnumeric(orderid&"") then orderid=0 
    if not isnumeric(intmoney&"") then intmoney=0 
	pay_fy=defaultpay_fy 
    If paytype="wxshaoma" Then
		paytypeAct = "微信扫码"
		payimgurl="wei.jpg"
	elseif paytype="jdshaoma" Then
		paytypeAct = "京东扫码"
		payimgurl="jd.jpg"
	elseif paytype="wxpay" then
		paytypeAct = "微信扫码"
		payimgurl="wei.jpg"
		pay_fy=wxpay_fy
	else
		paytype="alishaoma"
		paytypeAct = "支付宝扫码"
		payimgurl="zhi.jpg"
	end if
	
	showintmoney=round(intmoney+intmoney*pay_fy,2)
	showintmoney=formatnumber(showintmoney,2,-1,-1,0) 
 
%>
<style>
	.pay-wrapper{
		text-align:center;
		width:662px;
	}
	.pay-wrapper .content {
		overflow: hidden;
	}
	.pay-wrapper .content .left-side{
		float: left;
		width:320px;
		margin-left: 30px;
	}
	/*标题*/
	.pay-wrapper .tit{
		color:#000;
		font-size: 24px;
		line-height: 40px;
	}
	/*价格*/
	.pay-wrapper .price{
		font-size: 26px;
		color:#ff831f;
	}
	.pay-wrapper .content .pic{
		border: 1px solid #d5d5d5;
		border-bottom: none;
		height: 220px;
		line-height: 40px;
		color: #e67726;
		font-size: 20px;
		position: relative;
	}
	.pay-wrapper .content .pic.loading-qr{
		background: url('onlineImg/loading.gif') no-repeat center;
	}
	.pay-wrapper .content .pic .qr-code{
		background: #efefef;
		height: 200px;
		width: 200px;
	}
	.pay-wrapper .content .msg{
		border: 1px solid #b1d9ff;
		padding:10px 15px 10px 82px;
		font-size: 18px;
		line-height: 30px;
		color:#0e3569;
		text-align: left;
		background: url('onlineImg/erweima.png') no-repeat 12px center #ecfbff;
		min-height: 64px;
	}
	.pay-wrapper .content .msg .time{
		color:#fff;
		background-color: #ff6d6d;
		padding:3px 5px;
	}
	.pay-wrapper .content .msg .pay-success{
		position: relative;
		top:16px;
	}
	.pay-wrapper .content .msg-desc{
		font-size: 16px;
		color: #767676;
		text-align: center;
		line-height: 40px;
		position: absolute;
		bottom: 0;
		width: 100%;
	}
	.pay-wrapper .content .paytype-pic{
		float: right;
		width: 310px;
		position: relative;
		top: 52px;
	}
	.pay-wrapper .content .pay-tips{
		display: block;
		text-align: center;
		font-size: 12px;
		font-family: 宋体;
		color: #8f8f90;
		margin-top: -4px;
	}
	.pay-wrapper .content .pay-tips:hover{
		text-decoration: underline;
	}
	/*支付宝支付 UI */
	.paytype-alishaoma-wrapper{
		width: 760px;
		position: relative;
	}
	.download-alipay{
		color:#0060d7;
		font-size: 16px;
		margin: 15px auto;
	}
	.paytype-alishaoma-wrapper .content .paytype-pic{
		width: 230px;
		float: left;
	}
	.paytype-alishaoma-wrapper .content .alipay-pic-2{
		position: absolute;
		top: -20px;
		right: -20px;
		background: #f5f5f5;
		height: 100%;
		padding-top: 20px;
		padding-bottom: 20px;
	}
	.alipay-pic-2 {
		height: 100%;
		text-align: center;
		width: 200px;
		border-left:1px solid #dedede;
	}
	.alipay-pic-2 img{
		display: block;
		margin:130px auto 12px auto;
	}
	.alipay-pic-2 a.alipay-account{
		height: 38px;
		line-height: 38px;
		padding:0 14px;
		color: #fff;
		background-color: #2086ee;
		border-radius: 0;
		font-size: 14px;
		display: inline-block;
	}
</style>
<div id="nowpaybox" class="pay-wrapper paytype-<%=paytype%>-wrapper">
	<div class="content">
		<div class="left-side">
			<div class="tit">扫一扫付款<div class="price">&yen;<%=showintmoney%>元</div></div>
			<div class="pic loading-qr">
				<img alt="支付二维码" id="J_wxQRCodeImg" class="hide qr-code">
				<div class="msg-desc">扫描后请等待10秒左右系统将自动入款！</div>
			</div>
			<div class="msg">请使用<%=paytypeAct%><br/><span class="time">117</span>秒后二维码过期</div>
			<%if paytype="alishaoma" then%>
			<div class="download-alipay"><a href="https://mobile.alipay.com/index.htm" target="_blank">(首次使用请下载手机支付宝)</a></div>
			<!--<a class="pay-tips" href="javascript:;" onclick="showPayTips();">若出现“商户收款存在异常”，点此查看解决方案</a>-->
			<a class="pos-r pay-tips" href="javascript:void(0);">
				<span class="icon-question" style="background: none;">若出现“商户收款存在异常”，点此查看解决方案</span>
				<div class="manager-tip manager-tip-center  manager-tip-reverse" style="margin-top: -128px;margin-left: 22px;width: 220px;padding: 7px 20px;">
					<ol style="line-height: 26px;">						 
						<li>1.关闭支付窗口，重试支付宝扫码支付</li>
						<li>2.关闭支付窗口，选择微信扫码支付方式</li>
					</ol>
					<i></i>
				</div>
			</a>
			<%end if%>
		</div>
		<div class="paytype-pic">
			<img src="onlineImg/<%=payimgurl%>" alt="支付步骤">
		</div>
		 
	</div>
</div>

<script>
	var picout= 200;
	var timer1= null;
	var timer2= null;
	var npayurl = "do.asp";
 
	var checkq1 = "";
	var orderid=<%=orderid%>;



	function boxinit(){
		 $('#nowpaybox div.pic').removeClass('loading-qr'); 
			 picout_dg();
			 timer2 = setTimeout(function(){
			 checkq1="&orderid="+orderid
			 status_dg(checkq1)
		 },4000);
	 }

	function status_dg(checkq1){
		if(picout<=0){return false}
		$.get(npayurl,"westact=query" + checkq1,function(result){

			if(result.substr(0,3)=="200"){
				picout=-9;
				//success()
				$('#nowpaybox div.pic').html("<img src='onlineImg/icon_success@2x.png' width='74px' class='mt-30 mb-10'/><br/>恭喜您，扫码支付成功！<br/>按ESC键关闭!");
				$('#nowpaybox div.msg').html("<span class='pay-success'><a href='/manager/useraccount/mlist.asp'>查看财务</a>&nbsp;&nbsp;<a href='/manager/onlinePay/onlinePay.asp'>继续支付</a></span>");
			}else if(result.substr(0,3)=="500"){
				picout=-9;
				//$('#nowpaybox>div.pic').html(result);
				if(result.indexOf('timeout')>-1){
					result = "<span class='redColor'>二维码已过期，请<a href='javascript:void(0)' onclick='reopenweipay()'>点这里重新获取</a></span>"
				}
				$('#nowpaybox div.msg').html( result);

			}else{
				clearTimeout(timer2);
				timer2 = setTimeout(function(){
					status_dg(checkq1)
				},2000);
			}
		})
	}

	function picout_dg(){
	 
		if(picout>0){
			picout--;
			$('#nowpaybox div.msg .time').html(picout);
			clearTimeout(timer1);
			timer1 = setTimeout("picout_dg()",1000);
		}else if(picout>=-1){
			$('#nowpaybox div.msg').html("<span class='redColor'>二维码已过期，<a href='javascript:void(0)' onclick='reopenweipay()'>请点这里重新获取</a></span>");
		}
	}
	function reopenweipay(){
		$.dialog({id:'DialogWx361'}).close();
		nextpay();
	}

	function showPayTips() {
		if(window.showPayTipsDialog){
			return;
		}
		var content = '<ol style="line-height: 26px;">\
						<li>1.关闭支付窗口，重试支付宝扫码支付</li>\
						<li>2.关闭支付窗口，选择微信扫码支付方式</li></ol>';
		window.showPayTipsDialog = $.dialog({
			title: '温馨提示',
			content: content,
			icon: 'alert.gif',
			ok: function(){
				window.showPayTipsDialog = null;
			}
		});
	}
</script>
<%end sub%>