$(function(){		   
		   pageStart();
});
function pageStart(){	
	hostid=$("input[name='hostid']:hidden").val();
	s_productid=$("input[name='s_productid']:hidden").val();
	s_room=$("input[name='s_room']:hidden").val();
	s_osver=$("input[name='s_osver']:hidden").val();
	$("input[name='subbtton']:button").click(function(){dosub()});
	$("select[name='new_proid']").change(function(){
		setRoomElement($(this).val());
	});
	$("select[name='new_room']").change(function() { 
	
		setOsverElement();
	});
   $("select[name='osver']").change(function(){
		setMysqlElement()
		getPrice();
		getLookMdatalist();
	});
	$("input[name='ismovedata']:radio").click(function() {
		getPrice();
	})
	$("input[name='newromipdata']:radio").click(function() {
                getPrice();
            })
	setMysqlElement();
	getPrice();
}
function dosub(){
	var new_room=$("select[name='new_room']").val();
	var new_proid=$("select[name='new_proid']").val();
	var new_osver=$("select[name='osver']").val();
	var new_mysqlver=$("select[name='pmver']").val().toLowerCase();
	if(s_productid==new_proid &&  new_room==s_room && new_osver==s_osver && old_mysqlver==new_mysqlver){
		alert("抱歉，您还没有选择升级条件");
	}else{
		if(old_mysqlver=="mysql5.6" &&  old_mysqlver!=new_mysqlver)
		{
			alert("很遗憾!您所有升级的主机msql版本不一致不能升级");
			return false
		}


		if(confirm("提示：虚拟主机升级后不可撤销！若需要还原至原型号或原线路需要重新升级、费用不退，若只是想测试新的机房的速度，请先在新机房开一个试用主机或联系客服发该机房的案例，测试满意后再升级。确认继续升级吗？")){
			if(confirm("警告：当前正在操作虚拟主机的升级操作，升级后不可撤销，若需要更换回原机房原线路，需要重新升级，费用不退，确认继续吗？"))
			{
			$("form[name='form_uphost'] input[name='subbtton']:button").fadeOut(0,function(){$("#loadsubinfo").fadeIn(500);});		
			$("form[name='form_uphost'] input[name='act']:hidden").val("sub");
			$("form[name='form_uphost']").submit();
			}
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
		  timeout:30000,
		  data:info,
		  error:function(a,b,c){alert(a+b+c)},
		  success:function(data){
			 roommsg.html(data);
			 get_s_other_ip();
			 setOsverElement();
			 $("select[name='new_room']").change(function() {   			
				setOsverElement();
			 });
		  }
		});
}

function setMysqlElement(){ 
	var new_proid = $("select[name='new_proid']").val();
	var mysqlvermsg = $("#mysqlverlist label[class!='title']"); 
	postdate="module=getmysqllist&productid="+new_proid+"&room="+escape($("select[name='new_room']").val())+"&osver="+escape($("select[name='osver']").val())+""
    mysqlvermsg.html("<img src=\"/images/mallload.gif\">");
	$.post("/services/webhosting/buy.asp",postdate,function(data){
		 
		 mysqlvermsg.html(data);		 
	     $("select[name='pmver'] option:first").remove();
		 mysqlcheck()
		 $("select[name='pmver']").change(function(){mysqlcheck()})
		
	})
}
function mysqlcheck(){
		myver=$("select[name='pmver']").val().toLowerCase()
	    $("#mysqlmsg").html("");
		 if(myver!=old_mysqlver)
		 {
				$("#mysqlmsg").html("<font color=red>Mysql版本不一致，可能出现升级错误</font>");
		 }
		 if(myver!=old_mysqlver && old_mysqlver=="mysql5.6")
		 {
			$("#mysqlmsg").html("<font color=red>请选择相同型号mysql版</font>");
		 }
}
function setOsverElement(){	
	get_s_other_ip();
	var new_proid = $("select[name='new_proid']").val();
	var info = "act=getosver&hostid=" + hostid+"&proid="+ escape($.trim(new_proid)) +"&room="+ escape($("select[name='new_room']").val());
    var osvermsg = $("#osverlist label[class!='title']");
    osvermsg.html("<img src=\"/images/mallload.gif\">");
    $.ajax({
        url: window.location.pathname,
        cache: false,
        type: "POST",
        timeout: 10000,
        data: info,
        success: function(data) {
           osvermsg.html(data);		   
			$("select[name='osver']").change(function(){
				setMysqlElement()
				getPrice();
				getLookMdatalist();
			});
		  setMysqlElement();
		   getLookMdatalist();	
		   
		   getPrice()	   
        }
    })
}
function getLookMdatalist(){
	var new_proid=$("select[name='new_proid']").val();
	var new_room=$("select[name='new_room']").val();
	var new_osver=$("select[name='osver']").val();
	var info="act=getmovedata&hostid="+ hostid +"&new_proid="+escape(new_proid)+"&new_room="+escape(new_room)+"&new_osver="+escape(new_osver);
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
		$("#movedatalist").slideDown(0);
	}
}
function getPrice(){
	var new_proid=$("select[name='new_proid']").val();
	var new_room=$("select[name='new_room']").val();
	var new_osver=$("select[name='osver']").val();
	var ismovedata=$("input[name='ismovedata']:radio:checked").val();
	var bubbleboxObj=$("#bubbleContent");
	var isnewip=$("input[name='newromipdata']:radio:checked").val();
	var info="act=checkprice&hostid="+ hostid +"&new_proid="+ escape(new_proid) +"&new_room="+ escape(new_room)+"&new_osver="+ escape(new_osver) +"&ismovedata="+ ismovedata+"&isnewip="+isnewip+"&r="+Math.random();
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
		  timeout:30000,
		  data:info,
		  error:function(a,b,c){alert("getPrice"+a+b+c)},
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

function get_s_other_ip()
{

	if (s_other_ip!="")
	{ $("#ipaddr").show();

        new_room_ip=$("select[name='new_room'] option:selected").attr("title");
		new_room=$("select[name='new_room'] option:selected").val();
		if (old_room!=new_room)
		{
				if(new_room_ip=="true")
				{
						$("input[name='newromipdata'][value='1']").attr("disabled",false);
						$("#ipdatamsg").html("变更为新IP，+"+chgroomipmoney+"元");
						$("input[name='newromipdata'][value='1']").attr("checked",true);
				}else{
						$("input[name='newromipdata'][value='1']").attr("disabled",true);
						$("#ipdatamsg").html("目标机房无独立IP");
						$("input[name='newromipdata'][value='0']").attr("checked",true);
				}
		}else{
		$("input[name='newromipdata'][value='0']").attr("checked",false);
		$("input[name='newromipdata'][value='1']").attr("checked",false);
		if(new_room_ip=="true"){$("#ipdatamsg").html("变更为新IP，+"+chgroomipmoney+"元");$("input[name='newromipdata'][value='1']").attr("disabled",false);}else{$("#ipdatamsg").html("目标机房无独立IP");}
		$("#ipaddr").hide()
		}
	}else{
	 $("#ipaddr").hide()
	}
}