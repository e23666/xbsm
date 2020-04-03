$(function(){$.ajaxSetup({url: window.location.pathname+"?id="+$("input[name='id']:hidden").val(),cache:false,timeout:10000,type: "POST",error:function (XMLHttpRequest, textStatus, errorThrown){alert("出错:"+textStatus+" "+errorThrown);}});pageStart();});
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
	$("#newroomlist  [class!='title']").html("<img src=\"/images/mallload.gif\">");
	$.ajax({
		data:datainfo,
		success:function(data){
			$("#newroomlist  [class!='title']").html(data);
			getNeedprice();
			getver();
			$("select[name='new_room']").change(function(){
				
				getNeedprice();
				getver();
			});
		}
	});
}
function getNeedprice(){
	var bubbleboxObj=$("ul[class='z_bubblebox'] #bubbleContent");
	var datainfo="act=getneedprice&new_proid="+ escape($("select[name='new_proid']").val())+"&new_room="+$("select[name='new_room']").val();
	$("#priceMethod  [class!='title']").html("<img src=\"/images/mallload.gif\">");
	$("#priceShouXuFei  [class!='title']").html("<img src=\"/images/mallload.gif\">");
	$("#needPrice  [class!='title']").html("<img src=\"/images/mallload.gif\">");
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
				$("#priceMethod [class!='title']").html(pricemethod);
				$("#priceShouXuFei [class!='title']").html(shouxufei);
				$("#needPrice [class!='title']").html(needprice);
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



function getver()
{
	roomid=$("select[name='new_room']").val();
	oldrid=$("input[name='dbroom']").val();
	oldver=$("input[name='dbver']").val();
	$.post("/services/mssql/buy.asp","module=ver&roomid="+roomid,function(d){
	   if(d!="err")
	   {
		  temp=d.split(",");
		  verobj=$("select[name='dbversion']");
		  verobj.empty();
		  tempstr="<option value=''>请选择数据库版本</option>";
		  for(var i=0;i<temp.length;i++)
		  {
		    if(oldver==temp[i]) 
			{
		    tempstr+="<option value='"+temp[i]+"' selected>MSSQL "+temp[i]+"</option>"
			}else
			{
			tempstr+="<option value='"+temp[i]+"'>MSSQL "+temp[i]+"</option>"
			}
		  }
		 
		  verobj.append(tempstr);
	   }
	})
}