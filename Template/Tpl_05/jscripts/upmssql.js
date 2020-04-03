$(function(){$.ajaxSetup({url: window.location.pathname+"?id="+$("input[name='id']:hidden").val(),cache:false,timeout:10000,type: "POST",error:function (XMLHttpRequest, textStatus, errorThrown){alert("出错:"+textStatus+" "+errorThrown);}});pageStart()});
function pageStart(){	
	dbproid=$("input[name='dbproid']:hidden").val();
	dbroom=$("input[name='dbroom']:hidden").val();
	getRoomlist();
	$("select[name='new_proid']").change(function(){
		getRoomlist();
	});
	$("input[name='subbtton']").click(function(){dosub()});
}
function dosub(){
	var new_room=$("select[name='new_room']").val();
	var new_proid=$("select[name='new_proid']").val();
	if(dbproid==new_proid&&new_room==dbroom){
		alert("抱歉，您还没有选择升级条件")
	}else{
		if(confirm("确定立即升级该MSSQL数据库?")){
			$("form[name='form_uphost'] input[name='subbtton']:button").fadeOut(0,function(){$("#loadsubinfo").fadeIn(500)});
			$("form[name='form_uphost'] input[name='act']:hidden").val("sub");
			$("form[name='form_uphost']").submit();
		}
	}
}
function getRoomlist(){
	var datainfo="act=getroomlist&new_proid="+ escape($("select[name='new_proid']").val());
	$("#newroomlist label[class!='title']").html("<img src=\"/images/mallload.gif\">");
	$.ajax({
		data:datainfo,
		success:function(data){
			$("#newroomlist label[class!='title']").html(data);
			getNeedprice();
			$("select[name='new_room']").change(function(){
				getNeedprice();
			});
		}
	});
}
function getNeedprice(){
	var bubbleboxObj=$("ul[class='z_bubblebox'] #bubbleContent");
	var datainfo="act=getneedprice&new_proid="+ escape($("select[name='new_proid']").val())+"&new_room="+$("select[name='new_room']").val();
	$("#priceMethod label[class!='title']").html("<img src=\"/images/mallload.gif\">");
	$("#priceShouXuFei label[class!='title']").html("<img src=\"/images/mallload.gif\">");
	$("#needPrice label[class!='title']").html("<img src=\"/images/mallload.gif\">");
	$.ajax({
		data:datainfo,
		success:function(data){
			if(data.indexOf("^|^")>=0){
				dataArr=data.split("^|^");
				var needprice=dataArr[0];
				var pricemethod=dataArr[1];
				var shouxufei=dataArr[2];
				var movestr=$.trim(dataArr[3]);
				$("#movetitle").remove();
				$("#priceMethod label[class!='title']").html(pricemethod);
				$("#priceShouXuFei label[class!='title']").html(shouxufei);
				$("#needPrice label[class!='title']").html(needprice);
				if(movestr==""){
					$("#bubbleContent").html("");
					$("#bubbleContent").hide(0);
				}else{
					$("#bubbleContent").html(movestr);
					$("#bubbleContent").show(0);
				}
				
			}
		}
	});
}
