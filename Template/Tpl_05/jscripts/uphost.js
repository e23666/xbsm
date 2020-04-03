$(function(){
		   pageStart();
});
function pageStart(){
	hostid=$("input[name='hostid']:hidden").val();
	s_productid=$("input[name='s_productid']:hidden").val();
	s_room=$("input[name='s_room']:hidden").val();
	$("input[name='subbtton']:button").click(function(){dosub()});
	$("select[name='new_proid']").change(function(){
		setRoomElement($(this).val());
	});
	setRoomElement(s_productid);
}
function dosub(){
	var new_room=$("select[name='new_room']").val();
	var new_proid=$("select[name='new_proid']").val();
	if(s_productid==new_proid &&  new_room==s_room){
		alert("抱歉，您还没有选择升级条件");
	}else{
		if(confirm("确定立即升级该主机?")){
			$("form[name='form_uphost'] input[name='subbtton']:button").fadeOut(0,function(){$("#loadsubinfo").fadeIn(500);});		
			$("form[name='form_uphost'] input[name='act']:hidden").val("sub");
			$("form[name='form_uphost']").submit();
		}
	}
}
function setRoomElement(proid){
	var info="act=getroom&hostid="+ hostid +"&proid="+escape(proid);
	var roommsg=$("#newroomlist label[class!='title']");
	roommsg.html("<img src=\"/images/mallload.gif\">");
	$.ajax({
		  url: window.location.pathname,
		  cache:false,
		  type: "POST",
		  timeout:10000,
		  data:info,
		  success:function(data){
			 roommsg.html(data);			 
			 getLookMdatalist();	 
			 getPrice();
			 $("select[name='new_room']").change(function(){				
				 getPrice();
				 getLookMdatalist();
			 });
			 $("input[name='ismovedata']:radio").click(function(){
				 getPrice();
			 });
		  }
		});
}
function getLookMdatalist(){
	var new_proid=$("select[name='new_proid']").val();
	var new_room=$("select[name='new_room']").val();
	var info="act=getmovedata&hostid="+ hostid +"&new_proid="+escape(new_proid)+"&new_room="+escape(new_room);
	$.ajax({
		  url: window.location.pathname,
		  cache:false,
		  type: "POST",
		  timeout:10000,
		  data:info,
		  success:function(data){
			 setmovedatalist(data);			
		  }
	});
}
function setmovedatalist(p){
	if(p=="true"){			
		$("#movedatalist").slideUp(0);
	}else{
		$("#movedatalist").slideDown(100);
	}
}
function getPrice(){
	var new_proid=$("select[name='new_proid']").val();
	var new_room=$("select[name='new_room']").val();
	var ismovedata=$("input[name='ismovedata']:radio:checked").val();
	var bubbleboxObj=$("#bubbleContent");
	var info="act=checkprice&hostid="+ hostid +"&new_proid="+ escape(new_proid) +"&new_room="+ escape(new_room) +"&ismovedata="+ ismovedata;
	var needPriceObj=$("#needPrice label[class!='title']");
	var priceMethodObj=$("#priceMethod label[class!='title']");
	var priceShouXuFeiObj=$("#priceShouXuFei label[class!='title']");
	needPriceObj.html("<img src=\"/images/mallload.gif\">");
	priceMethodObj.html("<img src=\"/images/mallload.gif\">");
	priceShouXuFeiObj.html("<img src=\"/images/mallload.gif\">");
	$.ajax({
		  url: window.location.pathname,
		  type: "POST",
		  cache:false,
		  timeout:10000,
		  data:info,
		  success:function(data){
			  if(data.indexOf("^|^")>=0){
				  var dataArr=data.split("^|^");
				  var needPrice=dataArr[0];
				  var priceMethod=dataArr[1];
				  var priceShouXuFei=dataArr[2];
				  var movestr=$.trim(dataArr[3]);
				  if(movestr!=""){
					$("#bubbleContent").slideDown(0);
				  	$("#bubbleContent").html(movestr);
				  }else{
					 $("#bubbleContent").slideUp(0);
					 $("#bubbleContent").html(""); 
				  }
				  needPriceObj.html(needPrice);
				  priceMethodObj.html(priceMethod);
				  priceShouXuFeiObj.html(priceShouXuFei);  
			  }else{
				  alert(data);
			  }
		  }
		});	
}