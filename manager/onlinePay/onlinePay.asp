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
<title>�û������̨-����֧��</title>
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
				$.dialog.alert("��¼��Ԥ�����!");
				return false;
			}
			if(iswestpay &&  (paytype=="defaultpay" || paytype=="defaultpaywx" || paytype=="defaultpayjd" || paytype=="wxpay"))
			{	
				if(paytype=="defaultpaywx"){
					paytype="wxshaoma"
					var titlestr="΢��ɨ��֧��"
				}else if(paytype=="defaultpay"){
					paytype="alishaoma"
					var titlestr="֧����ɨ��֧��"
				}else if(paytype=="defaultpayjd"){
					paytype="jdshaoma"
					var titlestr="����ɨ��֧��"
				}else if(paytype=="wxpay"){
                    paytype="wxpay"
					var titlestr="΢��ɨ��֧��"  

                }else{
					paytype="wxshaoma"
					titlestr="΢��ɨ��֧��"
				}
				paybox=$.dialog({
					id:"DialogWx361",
					title: titlestr,
					content: '<div style="width:100px; text-align:center"><img src="onlineImg/loading.gif" alt="������,���Ժ�.."></div>',
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
					paybox.title(titlestr+"������Ϊ:"+orderid)
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/manager/onlinePay/onlinePay.asp">����֧��</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">


 <form name="formpay" id="formpay" action="onlinePayMore.asp" method="post" >
     <table  class="manager-table">
		<tr>
			<td align="left">
			
			<strong class="font14">������Ԥ����</strong>
			
			<input name="payMoney" class="manager-input s-input input_pri" type="text"   onkeyup="this.value=this.value.replace(/\D/g,'')" size="10" maxlength="10" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=paymoney%>"">
              Ԫ <span style="color:#FF0000; font-weight:bold;">( Ԥ����Ϊ�ͻ���Ը���룬�����˻�. )</span>
			</td>
		</tr>
		<tr>
			<th>��ѡ��֧����ʽ:</th>
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
					   <dt><input type="radio" name="paytype" value="<%= payobj("val")%>"  <%=IIF(isfirst,checked,"")%> id="pay_<%= payobj("val")%>"><label for="pay_<%= payobj("val")%>"><img src="<%= payobj("img")%>" width="96" height="37" alt="<%= payobj("name")%>" title="<%= payobj("name")%>" /><span>������:<%=returnbfb(defaultpay_fy)%>%</span></label>
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
				   <dt><input type="radio" name="paytype" value="tenpay" <%=checked%> id="pay_tenpay"><label for="pay_tenpay"><img src="onlineImg/3.gif" alt="�Ƹ�֧ͨ��" title="�Ƹ�֧ͨ��" /><span>������:<%=returnbfb(tenpay_fy)%>%</span></label>
				   </dt>
				</dl>
				<%end if%>
				<%if yeepay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1

				%>
				<dl>
				   <dt><input type="radio" name="paytype" value="yeepay" <%=checked%> id="pay_yeepay"><label for="pay_yeepay"><img src="onlineImg/1.jpg" alt="�ױ�֧��" title="�ױ�֧��" />
				<span>������:<%=returnbfb(yeepay_fy)%>%</span></label>
					</dt>
				</dl>
				<%end if%>
				<%if alipay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="alipay" <%=checked%> id="pay_alipay"><label for="pay_alipay"><img src="onlineImg/2.gif" width="96" height="37" alt="֧����֧��" title="֧����֧��" /><span>������:<%=returnbfb(alipay_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if kuaiqian then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="kuaiqian" <%=checked%> id="pay_kuaiqian"><label for="pay_kuaiqian"><img src="onlineImg/4.jpg" title="��Ǯ֧��v1.0" alt="��Ǯ֧��v1.0"/><span>������:<%=returnbfb(kuaiqian_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if kuaiqian2 then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="kuaiqian2" <%=checked%> id="pay_kuaiqian2"><label for="pay_kuaiqian2"><img src="onlineImg/4.jpg" alt="��Ǯ֧��v2.0" title="��Ǯ֧��v2.0" /><span>������:<%=returnbfb(kuaiqian2_fy)%>%</span></label>
				</dt>
				</dl>
				<%end if%>
				<%if cncard then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="cncard" <%=checked%> id="pay_cncard"><label for="pay_cncard"><img src="onlineImg/5.jpg" title="����֧��" alt="����֧��" /> 
				 <span>������:<%=returnbfb(cncard_fy)%>%</span></label>
				 </dt>
				</dl>
				<%end if%>
				<%if chinabank then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="chinabank" <%=checked%> id="pay_chinabank"><label for="pay_chinabank"><img src="onlineImg/6.jpg" alt="��������֧��" title="��������֧��" /><span>������:<%=returnbfb(chinabank_fy)%>%</span></label></dt>
				</dl>
				<%end if%>

				<%if shengpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="shengpay" <%=checked%> id="pay_shengpay"><label for="pay_shengpay"><img src="onlineImg/7.jpg" alt="ʢ��֧ͨ��" title="ʢ��֧ͨ��" /><span>������:<%=returnbfb(shengpay_fy)%>%</span></label></dt>
				</dl>
				<%end if%>

                <%if wxpay then
				checked=""
				if cur=0 then checked=" checked "
				cur=cur+1
				%>
				<dl>
				<dt><input type="radio" name="paytype" value="wxpay" <%=checked%> id="pay_wxpay"><label for="pay_wxpay"><img src="onlineImg/weixin.png" alt="΢��֧��" title="΢��֧��" /><span>������:<%=returnbfb(wxpay_fy)%>%</span></label></dt>
				</dl>
				<%end if%>
			
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="������һ��" class="manager-btn s-btn" ></td>
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
					title=itemNode1.Attributes.getNamedItem("title").nodeValue'����
					parid=itemNode1.Attributes.getNamedItem("parid").nodeValue'ʵ��id
					'''''''''''''''''''''''''''''''
					logo=itemNode1.Attributes.getNamedItem("logo").nodeValue'ͼƬ
					bankname=itemNode1.Attributes.getNamedItem("bankname").nodeValue'��������
					bankcode=itemNode1.Attributes.getNamedItem("bankcode").nodeValue'��������
					banknum=itemNode1.Attributes.getNamedItem("banknum").nodeValue'�˺�
					account=itemNode1.Attributes.getNamedItem("account").nodeValue'�˻���
					if trim(bankcode)&""<>"" then bankname=bankname & "<br>�ʱ�:" & bankcode


					


					if trim(parid)<>"0" and trim(parid)=trim(rootid) then
						isshow=true
						Tempstr=Tempstr&"<tr><td rowspan=3 class=""tdimg""><img alt="""&title&""" style=""border:1 #efefef solid"" border=""0"" src="""&logo&""" ></td><td>������:"&bankname&"</td></tr><tr>"
						Tempstr=Tempstr&" <td>�˺�:"&banknum&"</td></tr><tr><td>�˻���:"&account&"</td> </tr>"

					end if
			    next
              Tempstr=Tempstr&"</table>"

			  if isshow then
			  response.write(Tempstr)
			  end if
			end if
			
		next
	     
		%>

 










˵���� 
            <div> ��˾�ṩ������ֱ����֧����֧�����Ƹ�֧ͨ���ȶ���������ع��ͻ�ѡ��<br>
              <br>
              ֧��ƽ̨֧��ȫ����ʮ�ִ�����ÿ�������֧�����磺����һ��ͨ�����г��ǽ�ǿ�������ĵ����ͨ�������������ȣ�����֧�������ɸ����в�����ȫ������ʽʵ�֣���ȫ�ɿ���<br>
              <br>
              1������֧��-ʢ��ͨ���������µ�֧��ƽ̨���ܹ�ʹ�õ�֧�������������˺ܶࡣ<br>
              2�������ʹ��ʵʱ֧���Ŀ���������֧������Ӧ��������̵�ʱ���ڼ�������Ӧ�Ĵ���Ԥ�����У�һ��ʱ�䲻����10���ӣ�����ʹ�õĲ���ʵʱ֧���Ŀ�����Ӧ����24-48Сʱ�ڼ�������Ӧ�Ĵ���Ԥ�����С� <br>
              3���������Ҫ��ȡ��Ʊ������ȡ��Ӧ��˰�㡣 </div>


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






 
 
 