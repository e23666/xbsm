<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
 
<%call needregSession()
response.Charset="gb2312"
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''
dim iswestpay
iswestpay=iif(instr(api_url,"api.west263.com")>0,true,false)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-在线支付</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <script src="/jscripts/jquery.qrcode.min.js"></script>
<%
cur=0
'defaultpay,tenpay,yeepay,alipay
'fy,userid,userpass,account
paymoney=requesta("paymoney")
if not isnumeric(paymoney&"") then paymoney=""
%>
<script language=javascript> 
  <!--
   var iswestpay=<%=lcase(iswestpay)%>;
   var paybox=null;
   var timer1= null;
   var timer2= null;
   
   $(function(){
		
		$("form[name='formpay']").submit(function(){
			var payMoneyObj=$("input[name='payMoney']");
			var paytypeObj=$("input[name='paytype']:checked");
		 
			var paytype=paytypeObj.val();
			if(isNaN(payMoneyObj.val()) || $.trim(payMoneyObj.val())=="")
			{
				$.dialog.alert("请录入预付金额!");
				return false;
			}
			if(iswestpay &&  (paytype=="defaultpay" || paytype=="defaultpaywx" || paytype=="defaultpayjd" || paytype=="wxpay"))
			{	
				if(paytype=="defaultpaywx"){
					paytype="wxshaoma"
					var titlestr="微信扫码支付"
				}else if(paytype=="defaultpay"){
					paytype="alishaoma"
					var titlestr="支付宝扫码支付"
				}else if(paytype=="defaultpayjd"){
					paytype="jdshaoma"
					var titlestr="京东扫码支付"
				}else if(paytype=="wxpay"){
                    paytype="wxpay"
					var titlestr="微信扫码支持"  

                }else{
					paytype="wxshaoma"
					titlestr="微信扫码支付"
				}
				paybox=$.dialog({
					id:"DialogWx361",
					title: titlestr,
					content: '<div style="width:100px; text-align:center"><img src="onlineImg/loading.gif" alt="加载中,请稍候.."></div>',
					esc: false,
					lock: true,
					min: false,
					max: false,
					close:function(){
						 clearTimeout(timer1);
						 clearTimeout(timer2);
					}
				})
				
				showwestpay(payMoneyObj.val(),paytype,titlestr);
				return false
			}else{ 
				return true;
			}
		}) 

   })
	
   function nextpay(){
		$("form[name='formpay']").submit();   
   }

   function showwestpay(money,paytype,titlestr){
        //paybox.content(money+"||"+paytype)
          $('#qrcode_hide').empty();
		var postdata="westact=getpayinfo&payMoney="+money+"&paytype="+paytype+"&t="+Math.random()
		$.post("do.asp",postdata,function(data){
			console.log(data)
			if(data.code=="200")
			{	var orderid=data.ring;			
                var imgdata=data.uri;
                if(paytype=="wxpay"){
                    $('#qrcode_hide').qrcode(data.wxurl);
                    imgdata=$("#qrcode_hide canvas")[0].toDataURL("image/png")
                }
                
				var postdate="westact=westui&money="+money+"&paytype="+paytype+"&orderid="+orderid
					$.post("do.asp",postdate,function(webdb){
					paybox.title(titlestr+"订单号为:"+orderid)
                    paybox.content(webdb);
                    	
	                    //$('#payimg').attr("src", $("#qrcode canvas")[0].toDataURL("image/png"));
					 
					$('#J_wxQRCodeImg').attr('src',imgdata).show();
					boxinit()
				})

			
			}else{
				
				$.dialog.alert(data.msg)
				paybox.close();
			}
		
		},"json")
   }

 
  //-->
</script>
	




 

<style>
.b_table{width:100%;margin:0 auto; margin-bottom:20px; overflow: hidden;border-top:1px #eeeeee solid; border-left:1px #eeeeee solid; }
.b_table tr{  }
.b_table td{border-right:1px #eeeeee solid; border-bottom:1px #eeeeee solid; margin:0 auto; padding-left:20px; line-height:45px;}
.tj {
text-align: center;
clear: both;
}
.TableTitle{float:left;background:#fefefe;
	background:-moz-linear-gradient(top, #fefefe, #ededed);	
	background:-o-linear-gradient(left top,left bottom, from(#fefefe), to(#ededed));
	background:-webkit-gradient(linear,left top,left bottom, from(#fefefe), to(#ededed)); 
	line-height:45px;
	font-size:16px; font-weight: 700;
	width:99%;
	}
.tdimg{ width:30%; text-align:center;}
.mypaytabbox{position:relative; width:98%;border:2px solid #eeeeee; margin:40px auto 0 auto;}
.mypaytabbox #tabmenu{ width:100%;padding:0;margin:0px;position:absolute; z-index:100; top:-39px; height:40px;}
.mypaytabbox #tabmenu li{float:left;background:#fefefe;
	background:-moz-linear-gradient(top, #fefefe, #ededed);	
	background:-o-linear-gradient(left top,left bottom, from(#fefefe), to(#ededed));
	background:-webkit-gradient(linear,left top,left bottom, from(#fefefe), to(#ededed));
	border:2px solid #eeeeee;
	padding:5px 0;
	text-align:center;
	margin-left:-1px; 
	margin-left: 20px;
	width: 114px;
	display: inline-block;
    font-size: 16px;
	font-weight: bold;
	height:25px;
	line-height:25px;
	cursor:pointer; 
	
	}
.mypaytabbox #tabmenu li.cur{
	
	background:#fff;
	width: 114px;
	margin-left: 20px;
	display: inline-block;
	border-bottom:2px #fff solid;
	color: #06C;
	}
#tabcon li{
    opacity:0;
	filter:alpha(opacity=0);
	
	padding:25px;
	}
#tabcon li.cur{
	opacity:1;
	filter:alpha(opacity=100);
}
.pay_title {
padding-bottom: 10px;
border-bottom: 1px solid #e3e3e3;
font-size: 14px;
font-weight: bold;
margin: 25px 0 0px 0;
}
.Pay_type dl {float: left;
width: 220px;
display: inline-block;
margin-top: 20px;
}
 .Pay_type dl input {
float: left;
margin-top: 15px;
margin-right: 8px;
}
 .Pay_type dl span {
float: right;
display: inline-block;
padding-right: 5px;
line-height: 40px;
}
 .Pay_type dl label{background: #fff;
width: 180px;
height: 42px;
border: 1px solid #e3e3e3;
display: inline-block;
cursor: pointer;
float: left;}
</style>
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
			   <li><a href="/manager/onlinePay/onlinePay.asp">在线支付</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">


 <form name="formpay" id="formpay" action="onlinePayMore.asp" method="post" >
     <table  class="manager-table">
		<tr>
			<td align="left">
			
			<strong class="font14">请填入预付金额：</strong>
			
			<input name="payMoney" class="manager-input s-input input_pri" type="text"   onkeyup="this.value=this.value.replace(/\D/g,'')" size="10" maxlength="10" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=paymoney%>"">
              元 <span style="color:#FF0000; font-weight:bold;">( 预付款为客户自愿存入，不可退还. )</span>
			</td>
		</tr>
		<tr>
			<th>请选择支付方式:</th>
		</tr>
		<tr>
			<td>
			 <div class="Pay_type">
				<%if defaultpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				
			 
				if iswestpay Then
				
				    westpay=get_cache_westpay_info()
					isfirst=true
					For pi=0 To ubound(westpay)
						Set payobj=westpay(pi)
						If payobj("isopen")&""="1" then
				%>
					<dl>
					   <dt><input type="radio" name="paytype" value="<%= payobj("val")%>"  <%=IIF(isfirst,checked,"")%> id="pay_<%= payobj("val")%>"><label for="pay_<%= payobj("val")%>"><img src="<%= payobj("img")%>" width="96" height="37" alt="<%= payobj("name")%>" title="<%= payobj("name")%>" /><span>手续费:<%=returnbfb(defaultpay_fy)%>%</span></label>
					   </dt>
					</dl>
				<%	
					isfirst=false
						End If
					next
				 %> 
				<%end if%>
				<%end if%>
				<%if tenpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1

				%>
				<dl>
				   <dt><input type="radio" name="paytype" value="tenpay" <%=checked%> id="pay_tenpay"><label for="pay_tenpay"><img src="onlineImg/3.gif" alt="财付通支付" title="财付通支付" /><span>手续费:<%=returnbfb(tenpay_fy)%>%</span></label>
				   </dt>
				</dl>
				<%end if%>
				<%if yeepay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1

				%>
				<dl>
				   <dt><input type="radio" name="paytype" value="yeepay" <%=checked%> id="pay_yeepay"><label for="pay_yeepay"><img src="onlineImg/1.jpg" alt="易宝支付" title="易宝支付" />
				<span>手续费:<%=returnbfb(yeepay_fy)%>%</span></label>
					</dt>
				</dl>
				<%end if%>
				<%if alipay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="alipay" <%=checked%> id="pay_alipay"><label for="pay_alipay"><img src="onlineImg/2.gif" width="96" height="37" alt="支付宝支付" title="支付宝支付" /><span>手续费:<%=returnbfb(alipay_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if kuaiqian then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="kuaiqian" <%=checked%> id="pay_kuaiqian"><label for="pay_kuaiqian"><img src="onlineImg/4.jpg" title="快钱支付v1.0" alt="快钱支付v1.0"/><span>手续费:<%=returnbfb(kuaiqian_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if kuaiqian2 then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="kuaiqian2" <%=checked%> id="pay_kuaiqian2"><label for="pay_kuaiqian2"><img src="onlineImg/4.jpg" alt="快钱支付v2.0" title="快钱支付v2.0" /><span>手续费:<%=returnbfb(kuaiqian2_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if cncard then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="cncard" <%=checked%> id="pay_cncard"><label for="pay_cncard"><img src="onlineImg/5.jpg" title="云网支付" alt="云网支付" /> 
				 <span>手续费:<%=returnbfb(cncard_fy)%>%</span></label>
				 </dt>
				</dl>
				<%end if%>
				<%if chinabank then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="chinabank" <%=checked%> id="pay_chinabank"><label for="pay_chinabank"><img src="onlineImg/6.jpg" alt="网银在线支付" title="网银在线支付" /><span>手续费:<%=returnbfb(chinabank_fy)%>%</span></label></dt>
				</dl>
				<%end if%>

				<%if shengpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="shengpay" <%=checked%> id="pay_shengpay"><label for="pay_shengpay"><img src="onlineImg/7.jpg" alt="盛付通支付" title="盛付通支付" /><span>手续费:<%=returnbfb(shengpay_fy)%>%</span></label></dt>
				</dl>
				<%end if%>

                <%if wxpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="wxpay" <%=checked%> id="pay_wxpay"><label for="pay_wxpay"><img src="onlineImg/weixin.png" alt="微信支付" title="微信支付" /><span>手续费:<%=returnbfb(wxpay_fy)%>%</span></label></dt>
				</dl>
				<%end if%>
			
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="继续下一步" class="manager-btn s-btn" ></td>
		</tr>
	 </table>




 
		<%
		xmlpath=server.MapPath("/database/data.xml")
		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		set myobjNode = isNodes("bankcount","",xmlpath,0,objDoms)
		for each myitems in myobjNode.childNodes
			rootid=myitems.Attributes.getNamedItem("id").NodeValue
			rootparid=myitems.Attributes.getNamedItem("parid").NodeValue
			roottitle=myitems.Attributes.getNamedItem("title").NodeValue
			
			

			Tempstr=""
			isshow=false

			if trim(rootparid)="0" Then 
			Tempstr=Tempstr&"<table  class=""manager-table""><tr><th colspan=2>"&roottitle&"</th></tr>"
			''''''''''''''''''for2''''''''''''''''
				for each itemNode1 in myobjNode.childNodes
					id=itemNode1.Attributes.getNamedItem("id").nodeValue'id
					title=itemNode1.Attributes.getNamedItem("title").nodeValue'标题
					parid=itemNode1.Attributes.getNamedItem("parid").nodeValue'实别id
					'''''''''''''''''''''''''''''''
					logo=itemNode1.Attributes.getNamedItem("logo").nodeValue'图片
					bankname=itemNode1.Attributes.getNamedItem("bankname").nodeValue'开户银行
					bankcode=itemNode1.Attributes.getNamedItem("bankcode").nodeValue'开户银行
					banknum=itemNode1.Attributes.getNamedItem("banknum").nodeValue'账号
					account=itemNode1.Attributes.getNamedItem("account").nodeValue'账户名
					if trim(bankcode)&""<>"" then bankname=bankname & "<br>邮编:" & bankcode


					


					if trim(parid)<>"0" and trim(parid)=trim(rootid) then
						isshow=true
						Tempstr=Tempstr&"<tr><td rowspan=3 class=""tdimg""><img alt="""&title&""" style=""border:1 #efefef solid"" border=""0"" src="""&logo&""" ></td><td>开户行:"&bankname&"</td></tr><tr>"
						Tempstr=Tempstr&" <td>账号:"&banknum&"</td></tr><tr><td>账户名:"&account&"</td> </tr>"

					end if
			    next
              Tempstr=Tempstr&"</table>"

			  if isshow then
			  response.write(Tempstr)
			  end if
			end if
			
		next
	     
		%>

 










说明： 
            <div> 我司提供：银行直联、支付宝支付、财付通支付等多个银行网关供客户选择。<br>
              <br>
              支付平台支持全国几十种储蓄卡信用卡的在线支付（如：招行一卡通，中行长城借记卡，工行牡丹灵通卡，建行龙卡等，在线支付过程由各银行采用完全加密形式实现，安全可靠。<br>
              <br>
              1、银联支持-盛付通采用了最新的支付平台，能够使用的支付卡种类增加了很多。<br>
              2、如果您使用实时支付的卡进行在线支付，相应金额会在最短的时间内加入您相应的代理预付款中，一般时间不超过10分钟；如您使用的不是实时支付的卡，相应金额将于24-48小时内加入您相应的代理预付款中。 <br>
              3、如果您需要索取发票，会收取相应的税点。 </div>


</div>








		  </div>
	 </div>

  </div>



<div id="qrcode_hide" style="display:none;"></div>
 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
<%
function returnbfb(byval sxf)
	returnbfb=sxf*100
	if left(returnbfb&"",1)="." then returnbfb="0"&returnbfb 
end function
%>






 
 
 