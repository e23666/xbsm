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
if trim(ds.errstr)<>"" then url_return ds.errstr,-1
cpulist=ds.getcpulist(cpucount)
ramlist=ds.getramlist(ramcount)
if act="getprice" then	 
	ds.getPostvalue()
	if ds.errstr<>"" then
		response.write ds.errstr
	else
		upprice=ds.getUpprice("new")
		money_daycj=round(ds.money_daycj,2)
		if money_daycj<1 and money_daycj>0 then money_daycj=formatnumber(money_daycj,2,-1)
		blmsgstr="":if ds.blprice>0 then blmsgstr="�����ݱ�����["& ds.blprice &"]"
		response.write "(�¼۸�[��"& ds.newprice &"/��]-ԭ�۸�[��"& ds.oldprice &"/��])��30�죽��"& money_daycj  & vbcrlf
		response.write "��"&ds.souxvfei & vbcrlf
		response.write "ÿ����[��"& money_daycj &"]��ʣ������["& ds.leavings_day &"��]"& blmsgstr &"+������[��"& ds.souxvfei &"]��<font id=""moneycodeprice_msg"" class=""price_red"" style=""font-size:20px"">" & upprice & "</font>" & vbcrlf		
		if ds.Room<>ds.oldRoom then response.write "chg"
	end if
	conn.close
	response.End()
elseif act="buysub" then

	ds.getPostvalue()
	ds.isfast=false
	if ds.errstr<>"" then
		 url_return ds.errstr,-1
	else
		result=ds.upgrade()

		if trim(left(result,3))="200" then		
		    alert_redirect "�����ɹ�:"& result ,"updatediy.asp?id="&id
			 
		else
		   if ds.errstr<>"" then result=ds.errstr 
			alert_redirect "����ʧ��:"&result ,"updatediy.asp?id="& id
		end if
	end if
	conn.close
	response.End()
end if
leavings_day=datediff("d",date(),ds.oldexpiredate)+1 'δʹ������
if leavings_day<=0 then leavings_day=1

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

<link href="/images/CloudHost/jqtransform.css" rel="stylesheet" type="text/css" />
<link href="/images/CloudHost/cloud.css" rel="stylesheet" type="text/css" />
<link href="/images/CloudHost/diyserver.css" rel="stylesheet" type="text/css" />


<script language="javascript" src="/jscripts/check.js"></script>
<script language="javascript" src="/jscripts/inputrange.js"></script>
<script language="javascript" src="/jscripts/jquery.jqtransform.js"></script>






<script language="javascript">
var ttt;
var prodtype=<%=ds.prodtype%>
$(function(){	
 
	// getCalldiv("MainContentDIV");
	 tuijian();	
 
	$("input[name='subbtton']:button").click(function(){
		if(Number(<%=(ds.olddata)%>)<=Number($("input[name='data']:range").val()+$("input[name='osdata']:range").val())){
			if($("input[name='agreement']:checkbox").prop("checked")){
				if(confirm("��ʾ��ϵͳ�����ύ���������5����������ϵͳ���������������ȷ����Ҫ����������")){
				$("input[name='act']:hidden").val("buysub");
				$("form[name='buyform']").submit();
				}
			}else{
				alert("����û��ͬ����������Э��");
			}
		}else{
			alert("����Ӳ�̲���С��ԭ���̴�С:"+<%=ds.olddata%>+"G");
		}
		
	});
})
function getbldayinfo(v,bldayval){
	var bldayObj=$("select[name='blday']");
	var datastr="id=<%=id%>&act=getbldaymsg&blday="+ escape(bldayObj.val());
	$.post(window.location.href,datastr,function(msg){
		if(msg!=""){
				//$("#bldaymsg").slideDown(100);
				$("#bldaymsg_txt").html(msg);											   
			}
	});
}
function oldsetmod(){
//	$("input[name='servicetype'][value='<%=ds.oldservicetype%>']:radio").prop("checked","checked");
//	var osdd=$("select[name='CHOICE_OS']").msDropdown().data("dd");	
//	osdd.setIndexByValue("<%=ds.oldCHOICE_OS%>")
//	$("input[name='room'][value='<%=ds.oldroom%>']:radio").prop("checked","checked");
	
}
function tuijian(){
	var tjArr=[{title:"ԭ����",content:{cpu:<%=ds.oldcpu%>,ram:<%=ds.oldram%>,odata:<%=ds.oldosdata%>,data:<%=ds.olddata%>,flux:<%=ds.oldflux%>}},
				{title:"������",content:{cpu:2,ram:2,osdata:30,data:60,flux:2}},
			    {title:"��׼��",content:{cpu:2,ram:3,osdata:30,data:80,flux:3}},
				{title:"������",content:{cpu:3,ram:5,osdata:30,data:100,flux:4}},
				{title:"������",content:{cpu:3,ram:5,osdata:30,data:200,flux:5}},
				{title:"��ҵ��",content:{cpu:4,ram:7,osdata:30,data:300,flux:8}},
				{title:"������",content:{cpu:5,ram:8,osdata:30,data:500,flux:10}}];
			
	$("#tuijian_msg").empty();
 
	var buttonstr="";
	$.each(tjArr,function(i,n){		
		$("#tuijian_msg").append("<input type=\"button\" name=\"tuijian_btn_"+ i +"\" value=\""+ n.title +"\" class=\"btn_page_\" style=\"margin-top:3px;\" />&nbsp;&nbsp;");
		var thisbutton=$("input[name='tuijian_btn_"+ i +"']");
		thisbutton.click(function(){
			if(i==0) oldsetmod();
			dotuijians(thisbutton,n.content);
			
		});			
		if(i==0){
			dotuijians(thisbutton,n.content);
		}
	});	
	//$("#tuijian_msg").html(buttonstr);
	//alert(buttonstr);
}
function setbuttonrangeval(osdata,data,flux){//�����мӼ��ŵ�range
	$("#data_range").html("<input type=\"range\" name=\"data\" min=\"20\" max=\"2000\" step=\"10\" value=\""+data+"\" /><div style=\"float:left; margin-top:7px\">GB</div>");
	$("#osdata_range").html("<input type=\"range\" name=\"osdata\" min=\"30\" max=\"200\" step=\"10\" value=\""+osdata+"\" /><div style=\"float:left; margin-top:7px\">GB</div>");
 
	$("#flux_range").html("<input type=\"range\" name=\"flux\" min=\"1\" max=\"200\" step=\"1\"  value=\""+flux+"\" /><div style=\"float:left; margin-top:7px\">Mbps</div>");
 
	var objs=$("input[name='flux']:range,input[name='data']:range,input[name='osdata']:range");
	objs.rangeinput({
		progress: true,		
		change: function(e, i) {
				getprice();
		}
	});	
	$("#flux_range .slider,#data_range .slider,#osdata_range .slider").before("<a class='slider-leftbutton'></a>");
	$("#flux_range .slider,#data_range .slider,#osdata_range .slider").after("<a class='slider-rightbutton'></a>");
	$(".range").blur(function(){
		getprice()
	})
	
	var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);
	//------------------data------------------------
	
	$("#data_range .slider-leftbutton").click(function(){		
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		if(dataval><%=ds.olddata%>){
			setbuttonrangeval(osdataval,dataval-10,fluxval);
			getprice();
		}
	});	
	$("#data_range .slider-rightbutton").click(function(){
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		setbuttonrangeval(osdataval,dataval+10,fluxval);		
		getprice();
	});

	$("#osdata_range .slider-leftbutton").click(function(){		
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		if(dataval><%=ds.olddata%>){
			setbuttonrangeval(osdataval-10,dataval,fluxval);
			getprice();
		}
	});	
	$("#osdata_range .slider-rightbutton").click(function(){
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		setbuttonrangeval(osdataval+10,dataval,fluxval);		
		getprice();
	});
	//-----------------flux----------------------	
	$("#flux_range .slider-leftbutton").click(function(){	
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);	
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		setbuttonrangeval(osdataval,dataval,fluxval-1);
		getprice();
	});	
	$("#flux_range .slider-rightbutton").click(function(){
		var dataval=$.trim($("input[name='data']:range").val());
		dataval=isNaN(dataval)?50:Number(dataval)
		var fluxval=$.trim($("input[name='flux']:range").val());
		fluxval=isNaN(fluxval)?1:Number(fluxval);	
		var osdataval=$.trim($("input[name='osdata']:range").val());
		osdataval=isNaN(osdataval)?30:Number(osdataval);
		setbuttonrangeval(osdataval,dataval,fluxval+1);
		getprice();		
	});

}
function dotuijians(v,content){	
	
	$("input[name^='tuijian_btn_']").removeClass();
	$("input[name^='tuijian_btn_']").addClass("btn_page_");
	$("#cpu_range").html("<input type=\"range\" name=\"cpu\" min=\"1\" max=\"<%=cpucount%>\" value=\""+content.cpu+"\" step=\"1\" />");
	//console.log("["+content.cpu+"]")
	//$("input[name='cpu']").val(content.cpu);
	$("#ram_range").html("<input type=\"range\" name=\"ram\" min=\"1\" value=\""+content.ram+"\"  max=\"<%=ramcount%>\" step=\"1\"/>");
	//$("input[name='ram']:range").val(content.ram);
	var objs=$("input[name='cpu']:range,input[name='ram']:range");
	objs.rangeinput({
		progress: true,		
		change: function(e, i) {
			getprice()
		}
	});	
	setbuttonrangeval(content.odata,(content.data-content.odata),content.flux);

		$(v).addClass("btn_page_1");
	
	getprice();

}
function getprice(){	

	<%if ds.paytype=1 then response.write "return;"%>

	var cpu=$("input[name='cpu']:range").val();
	var ram=$("input[name='ram']:range").val();
	var flux=$("input[name='flux']:range").val();
	var data=$("input[name='data']:range").val();
	var osdata=$("input[name='osdata']:range").val();
	var room=$("input[name='room']:radio:checked").val();
	var renewTime=$("select[name='renewTime']").val();
	var PayMethod=$("input[name='PayMethod']:radio:checked").val();
	var servicetype=$("input[name='servicetype']:radio:checked").val();
	var blday=$("select[name='blday']").val();	
 
	if(data<<%=ds.olddata-ds.oldosdata%>){
		window.clearTimeout(ttt);
		setbuttonrangeval(osdata,<%=ds.olddata-ds.oldosdata%>,flux);
		data=<%=ds.olddata-ds.oldosdata%>;
		$("#datatishi").fadeIn("slow");		
		ttt=window.setTimeout(function(){$("#datatishi").fadeOut("slow");},3200);
	}else{
		$("#datatishi").fadeOut("slow");
	}

	if(osdata<<%=ds.oldosdata%>){
		window.clearTimeout(ttt);
		setbuttonrangeval(<%=ds.oldosdata%>,data,flux);
		osdata=<%=ds.oldosdata%>;
		$("#datatishi").fadeIn("slow");		
		ttt=window.setTimeout(function(){$("#osdatatishi").fadeOut("slow");},3200);
	}else{
		$("#osdatatishi").fadeOut("slow");
	}
	var info="id=<%=ds.aid%>&act=getprice&cpu="+ cpu +"&ram="+ ram +"&flux="+ flux +"&data="+ data +"&osdata="+osdata+"&room="+ room +"&blday="+ blday +"&servicetype="+ escape(servicetype);
//	document.write(info);
	$("#moneycodeprice_msg").css("color","#ccc");

	$("input[name='subbtton']:button").attr("disabled",true);

	var uppriceObj=$("#upprice");
	var sxpriceObj=$("#sxprice");
	var cjpriceObj=$("#cjprice");	
	
	var p=String.fromCharCode(13);var cj_day="δ֪";var upprice="δ֪";var sxprice="δ֪";var ischg="";

	$.post(window.location.mappath,info,function(msg){
	 
					   var msgArr=msg.split(p);
					   if(msgArr.length>=3){
						   cj_day=$.trim(msgArr[0]);
						   sxprice=$.trim(msgArr[1]);
						   upprice=$.trim(msgArr[2]);
						   ischg=$.trim(msgArr[3]);
					   }
					  
					   cjpriceObj.html(cj_day);
					   sxpriceObj.html(sxprice);
					   uppriceObj.html(upprice);
					 	
					   var price=$.trim($("#moneycodeprice_msg").html());
					   $("#moneycodeprice_msg").html("��"+price);
					  
					   $("input[name='mc_oldprice']:hidden").val(price);
					    if(ischg=="chg"){
						   getbldayinfo();
						   $("#bldaymsg").slideDown(100);						   
					   }else{
						   $("#bldaymsg").slideUp(100);
					   }
					     
			 
	
		$("#pricelist").html(msg);
		$("#moneycodeprice_msg").css("color","red");
		$("input[name='subbtton']:button").attr("disabled",false);
	});
}


function seetitle(v,f,w,h){

	if(	w==""){w=200}
	if(h==""){h=100}
		doouttitlemsg(v,"<span style=\"color:#000\">"+f+"</span>",w,h,1);

}
function closetitlebox(){	

		$("#titletext").html("");
		$("#titlemsg").css("display","none");	
}

$(function(){
		 $('#tuijian_msg input').hover(function(){
		 var inuptindex = $(this).index();
		 
		 if(inuptindex>0){
			$(".fitall").removeClass("show");
						var fitall=$(".fit"+inuptindex);
						fitall.addClass("show");
					
						//fitall.fadeIn();
			}
			 },function(){
				 
				 $(".fitall").removeClass("show");
				// $(".fitall").fadeOut();
				 
				 }
			 )
			 
		})
		
		
</script>

<style type="text/css">
.selectform2 {
	padding-top: 15px;
	position: relative;
}
.fit .description_arrow {
	margin-top: -12px;
}
.fit1 {
	border: 1px solid #dddddd;
	width: 170px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 160px;
*left:150px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit2 {
	border: 1px solid #dddddd;
	width: 200px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 260px;
*left:250px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit3 {
	border: 1px solid #dddddd;
	width: 170px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 350px;
*left:340px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit4 {
	border: 1px solid #dddddd;
	width: 200px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 370px;
*left:360px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit5 {
	border: 1px solid #dddddd;
	width: 240px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 445px;
*left:435px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit5 .description_arrow {
	margin-left: 110px;
}
.fit6 {
	border: 1px solid #dddddd;
	width: 220px;
	height: 20px;
	line-height: 20px;
	text-indent: 15px;
	position: absolute;
	left: 490px;
*left:480px;
	top: 70px;
	background: #fff;
	z-index: 90;
	clear: both;
	color: #333;
}
.fit6 .description_arrow {
	margin-left: 160px;
}
.description_arrow {
	background: url(/images/CloudHost/cloudall.jpg) no-repeat -372px 0px;
	width: 14px;
	height: 13px;
	position: absolute;
	top: 0;
	margin-left: 20px;
}
.descriptionall, .fitall {
	display: none;
}
.show {
	display: block;
}
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
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   <li>������������</li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 




    <div style="width:706px;">
            <div id="titlemsg" style="width: 210px; top: 706px; left: 1021px; display: none;">
            <div id="titletext" style="width: 180px; height: 60px;"><span style="color:#000"></span></div>
            <div id="top_left" style="width: 200px;"></div>
            <div id="top_right"></div>
            <div id="bottom_left" style="width: 200px; height: 50px;"></div>
            <div id="bottom_right" style="height: 50px;"></div>
            <div class="clearbottom"></div>
          </div>
          <div class="qrlayout selectformqr">
          <div class="qrtop"><img src="/images/CloudHost/ebscloud/qrtop.gif" width="700" height="24"></div>
          <div class="qrmain">
          <dl class="linebox " id="rebox"></dl></div>
          <div class="qrbottom"><img src="/images/CloudHost/ebscloud/qrbottom.gif" width="700" height="27"></div></div>

    
    <div class="selectform2">
        <form name="buyform" method="post" action="<%=request.ServerVariables("SCRIPT_NAME")%>">
          <div class="clearfix" style=" margin:10px auto; text-align:center" id="tuijian_msg"></div>
          <div class="fit">
            <div class="fitall fit1">
              <div class="description_arrow"></div>
              <span>��������С��ҵչʾ����վ</span> </div>
            <div class="fitall fit2">
              <div class="description_arrow"></div>
              <span>��������ҵ�ٷ���վ������վ��</span> </div>
            <div class="fitall fit3">
              <div class="description_arrow"></div>
              <span>�����ڵط�/��ҵ�Ż���վ</span> </div>
            <div class="fitall fit4">
              <div class="description_arrow"></div>
              <span>�����������̳ǡ��Ź���վ��</span> </div>
            <div class="fitall fit5">
              <div class="description_arrow"></div>
              <span>����������SNS/��̳/ERP/OACRM��</span> </div>
            <div class="fitall fit6">
              <div class="description_arrow"></div>
              <span>������������Ϸ�������߶�Ӧ�õ�</span> </div>
          </div>
          <div class="z_buymsg clearfix" style="padding:20px 0 0 0; ">
            <dl class="linebox1" id="upbox" style="width:700px;">
              <dd CLASS=" ddline clearfix" style="margin-bottom:0; height:15px;" ></dd>
              <dd class="clearfix" id="cpumsg">
                <label class="cpu_label">CPU<span ><img src="/images/CloudHost/ebscloud/help.jpg" onMouseOver="javascript:seetitle(this,'CPUԽ�࣬�����ٶ�Խ�졣<br \/>����վ�������ϴ����վ���Ƽ�ʹ��4�˻�8��CPU��',320,32)" onMouseOut="javascript:closetitlebox()"  style="cursor:pointer; margin-left:3px;" /></span></label>
                <div class="cpu_icon"></div>
                <label class="msg"  for=" ">
                <div class="clearfix width540" id="cpu_range"> </div>
                <div  class="clearfix width540" id="cpuvalue"><%=cpulist%></div>
                <!--<div style="width:500px; clear:both"><span>1��</span><span  style="margin-left:134px">2��</span><span style="margin-left:131px">4��</span><span style="margin-left:132px">8��</span></div>-->
                </label>
              </dd>
              <dd class="clearfix" id="rammsg">
                <label class="ram_label">�ڴ�<span ><img src="/images/CloudHost/ebscloud/help.jpg" onMouseOver="javascript:seetitle(this,'�ڴ�Խ���ٶ�Խ�죻<br \/>Ϊ��֤���õ����飬512M�ڴ治�ṩwindows����ϵͳ��',350,32)" onMouseOut="javascript:closetitlebox()"  style="cursor:pointer; margin-left:3px;" /></span></label>
                <div class="ram_icon"></div>
                <label class="msg"  for=" ">
                <div class="clearfix width540" id="ram_range"> </div>
                <div  class="clearfix width540" id="ramvalue"><%=ramlist%></div>
				  <div style="clear:both; padding-left:150px;margin-top: 30px" class="clearfix"> ϵͳ�̷����СΪ30G-200G </div>
                </label>
              </dd>

			   <dd class="clearfix" id="datamsg" style="margin-bottom:30px;" >
                <div id="osdatatishi" style="background-color:#FFC; clear:both; border:1px solid #FC3; width:340px; margin-left:190px; text-align:center; display:none">����ʱ,Ӳ�̴�Сֻ�����Ӳ�����С</div>
                <label class="data_label">ϵͳ��<span ><img src="/images/CloudHost/ebscloud/help.jpg" onMouseOver="javascript:seetitle(this,'����ṩ50GӲ�̣�����ϵͳ�̷����СΪ30GB��������Ĭ��Ϊ20GB����������10G������',300,32)" onMouseOut="javascript:closetitlebox()"  style="cursor:pointer; margin-left:3px;" /></span></label>
                <div class="data_icon"></div>
                <label class="msg"    for=" ">
                <div style="width:520px;" id="osdata_range"></div>
                <div style="width:520px;clear:both" class="clearfix">
                  <div style="float:left; display:inline;line-height:10px;margin:0;margin-left:30px; width:40px; text-align:left">30G</div>
                  <div  style=" float:left;margin:0;display:inline;line-height:10px; width:40px; margin-left:280px; text-align:right">200G</div>
                  <div style="float:left; width:80px;line-height:10px; margin-left:25px;display:inline;">(10GB����)</div>
                </div>
               <div style="clear:both; padding-left:150px;margin-top: 50px" class="clearfix"> ��������С20G </div>
                </label>
              </dd>


              <dd class="clearfix" id="datamsg" style="margin-bottom:30px;" >
                <div id="datatishi" style="background-color:#FFC; clear:both; border:1px solid #FC3; width:340px; margin-left:190px; text-align:center; display:none">����ʱ,Ӳ�̴�Сֻ�����Ӳ�����С</div>
                <label class="data_label">������<span ><img src="/images/CloudHost/ebscloud/help.jpg" onMouseOver="javascript:seetitle(this,'����ṩ50GӲ�̣�����ϵͳ�̷����СΪ30GB��������Ĭ��Ϊ20GB����������10G������',300,32)" onMouseOut="javascript:closetitlebox()"  style="cursor:pointer; margin-left:3px;" /></span></label>
                <div class="data_icon"></div>
                <label class="msg"    for=" ">
                <div style="width:520px;" id="data_range"></div>
                <div style="width:520px;clear:both" class="clearfix">
                  <div style="float:left; display:inline;line-height:10px;margin:0;margin-left:30px; width:40px; text-align:left">50G</div>
                  <div  style=" float:left;margin:0;display:inline;line-height:10px; width:40px; margin-left:280px; text-align:right">1000G</div>
                  <div style="float:left; width:80px;line-height:10px; margin-left:25px;display:inline;">(10GB����)</div>
                </div>
               
                </label>
              </dd>
              <dd class="clearfix" id="fluxmsg">
                <label class="flux_label">����<span ><img src="/images/CloudHost/ebscloud/help.jpg" onMouseOver="javascript:seetitle(this,'����Խ���ٶ�Խ�졢֧�ֵ�ͬʱ�����������ࡣ<br \/>1M������ʺ��ڲ��ԡ��һ���Ӧ�ã���վӦ������2M���Ƽ�3M���ϴ���',440,32)" onMouseOut="javascript:closetitlebox()"  style="cursor:pointer; margin-left:3px;" /></span></label>
                <div class="flux_icon"></div>
                <label class="msg" for=" ">
                <div  class="clearfix width540" id="flux_range"></div>
                <div  class="clearfix width540">
                  <div style="float:left;margin:0;display:inline; width:40px;margin-left:30px; text-align:left">1M</div>
                  <div  style=" float:left;margin:0;display:inline; width:40px; margin-left:282px; text-align:right;">200M</div>
                  <div style="float:left; width:80px;display:inline; margin-left:24px ">(1Mbps����)</div>
                </div>
                </label>
              </dd>
              <%if ds.paytype=1 then%>
              <dd class="clearfix" style="border:none">
                <div >
                  <div style="text-align:center; color:red; font-size:16px; background-color:#FFC">�����������������ܽ����������, ����ʽ��ͨ</div>
                  <div style="text-align:center"><a href=#### onClick="javascript:document.buyform.action='/manager/servermanager/paytest.asp?id=<%=id%>';document.buyform.submit();"><img src="/images/Cloudhost/button2_open.gif" width="193" height="47" border="0"></a>
                    <input type="hidden" name="backpage" value="/manager/server/setMod_diysj.asp?id=<%=ds.aid%>" />
                    <input type="hidden" value="<%=ds.aid%>" name="id">
                  </div>
                </div>
              </dd>
              <%else%>
              <dd class="clearfix mindd1" style="margin-top: 60px;clear: both">
                <label>ԭIP:</label>
                <label class="msg clearfix" for=" "> <%=ds.oldserverip%>  </label>
              </dd>
              <dd class="clearfix mindd1">
                <label>ʹ��ʱ��:</label>
                <label class="msg clearfix" for=" " > <%=formatdatetime(ds.starttime,2)%>��<%=formatdatetime(ds.oldexpiredate,2)%>&nbsp;&nbsp;ʣ��<%=leavings_day%>�� </label>
              </dd>
              <dd class="clearfix mindd1">
                <label>ÿ����:</label>
                <label class="msg clearfix" for=" " id="cjprice"> </label>
              </dd>
			  <%
				if ds.PayMethod="1" And 1=2 then 
				%>
				<dd class="clearfix mindd1">
                <label>�ر�˵��:</label>
                <label class="msg clearfix" for=" " >
				 <font color=red>�簴��֧����������ʱÿ�¼۸����긶���/10���м۲���㡣�˼۸��������Ч</font> 
				</label>
              </dd>
			  <%				end if%>
              <dd class="clearfix mindd1">
                <label>������:</label>
                <label class="msg clearfix" for=" " id="sxprice"> </label>
				
              </dd>
              <dd class="clearfix mindd1">
                <label>�ϼ�:</label>
                <label class="msg clearfix" for=" " id="upprice"> </label>
                <input type="hidden" name="mc_proid" value="<%=ds.p_proid%>" />
                <input type="hidden" name="mc_prokey" value="<%=ds.aid%>" />
                <input type="hidden" name="mc_action" value="upgrade" />
                <input type="hidden" name="mc_oldprice" />
              </dd>
              <dd CLASS="mindd clearfix" style="border-bottom:none; text-align:center; width:667px; border-top:1px solid #dddddd">
                <label style="display:inline; width:auto; float:none; line-height:25px; height:25px" for="agreement">
                  <input name="agreement" id="agreement" type="checkbox"  value="1" />
                  �����Ķ���ͬ��</label>
                <a href="/customercenter/yunxiyi.asp" target="_blank" style="color:#06c"><%=companyname%>����������Э��</a> </dd>
              <dd class="mindd" style="border-bottom:none; width:667px; text-align:center;">
                <input type="button" class="z_btn-submit-sj" name="subbtton" disabled="disabled" />
                <div id="loadsubinfo">�������ڴ�����.����ˢ�»�ر������...</div>
                <input type="hidden" name="act" />
                <input type="hidden" name="id" value="<%=id%>" />
              </dd>
              <%end if%>
            </dl>
          </div>
        </form>
      </div>
    
</div> 



















		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>