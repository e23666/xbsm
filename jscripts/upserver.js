$(function(){		   
		   pageStart();
});
function pageStart(){
	serverid=$("input[name='id']").val();
	oldproid=$("input[name='oldproid']").val();
	oldcdntype=$("input[name='oldcdntype']").val();
	
	var cdntypeObj=$("select[name='cdntype']");
	var serverRoomObj=$("select[name='serverRoom']");
	var bldayObj=$("select[name='blday']");
	var newproidObj=$("select[name='newproid']");
	//getroomlist();
	getcdntypelist();
	getneedprice();
	newproidObj.change(function(){									
									getroomlist();										
								});
	serverRoomObj.change(function(){									
								getcdntypelist();
								getneedprice();	
					});
	cdntypeObj.change(function(){
							   		getneedprice();
								});	
	bldayObj.change(function(){
						getneedprice();
					});	
	$("input[name='up_button']").click(function(){
						 dosub();
					});
}
function dosub(){
	if (confirm('��ȷ�����Ĳ����� ')){
		$("form[name='form_uphost']").get(0).submit();
		$("input[name='up_button']").attr("disabled",true);
	}
}
function getcdntypelist(){
	var serverRoomObj=$("select[name='serverRoom']");
	var cdntypeObj=$("select[name='cdntype']");
	cdntypeObj.empty();
	if(oldproid.indexOf("Cloud")<0 && serverRoomObj.val()==1){
		var cdntypelist={
			"0":"��ʹ��CDN:&nbsp;&nbsp;���",
			"1":"����˫��CDN(����150G/��):&nbsp;&nbsp;+50Ԫ/��"		
		}
		$.each(cdntypelist,function(i,n){	
								if($.trim(i+"")==$.trim(oldcdntype+"")){
									cdntypeObj.append("<option value=\""+ i +"\" selected>"+ n +"</option>");
								}else{
									cdntypeObj.append("<option value=\""+ i +"\">"+ n +"</option>");
								}
							});
		//cdntypeObj.val(oldcdntype);
	}else{
		cdntypeObj.append("<option value=\"-1\">��</option>");
	}

	
}
function getroomlist(){
	var newproidObj=$("select[name='newproid']");
	var newproid=newproidObj.val();
	var serverRoom=$("select[name='serverRoom']");
	var roomdivobj=$("#newroomlist label[class!='title']");
	serverRoom.remove();
	roomdivobj.html("���ڲ����ִ����..");
	$("input[name='up_button']").attr("disabled",true);
	$("select[name='newproid']").attr("disabled",true);
	$.ajax({type:"POST",url:window.location.href,cache:false,data:"id="+ serverid +"&act=roomlist&newproid="+ escape(newproid),
			error:function(a,b,c){alert(a+b+c)},
		    success:function(msg){
				roomdivobj.html(msg);	
				getcdntypelist();
				getneedprice();
				$("select[name='serverRoom']").change(function(){
										getcdntypelist();
										getneedprice();
				});
				$("input[name='up_button']").removeAttr("disabled");
				$("select[name='newproid']").removeAttr("disabled");	
		    }		   
		   });
}
function getneedprice(){
	$("input[name='up_button']").attr("disabled",true);
	$("select[name='newproid']").attr("disabled",true);
	var serverRoom=$("select[name='serverRoom']").val();
	var cdntype=$("select[name='cdntype']").val();
	var newproid=$("select[name='newproid']").val();
	var blday=$("select[name='blday']").val();
	var uppriceObj=$("#upprice label[class!='title']");
	var sxpriceObj=$("#sxprice label[class!='title']");
	var cjpriceObj=$("#cjprice label[class!='title']");
	sxpriceObj.html("���ڲ�ѯ...");
	cjpriceObj.html("���ڲ�ѯ...");
	uppriceObj.html("���ڲ�ѯ...");
	var p=String.fromCharCode(13);var cj_day="δ֪";var upprice="δ֪";var sxprice="δ֪";var ischg="";
	var datastr="id="+ serverid +"&act=needprice&serverroom="+ serverRoom + "&cdntype="+cdntype+"&newproid="+newproid+"&blday="+ blday;
	$.ajax({type:"POST",url:window.location.href,data:datastr,cache:false,
			error:function(a,b,c){alert(a+b+c);},
		    success:function(msg){
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
					   if(ischg=="chg"){
						   $("#bldaymsg").slideDown(100);
					   }else{
						   $("#bldaymsg").slideUp(100);
					   }
					   $("input[name='up_button']").removeAttr("disabled");
					   $("select[name='newproid']").removeAttr("disabled");
					}
			});

}
function getcdntypelist(){
	var serverRoomObj=$("select[name='serverRoom']");
	var cdntypeObj=$("select[name='cdntype']");
	cdntypeObj.empty();
	if(oldproid.indexOf("Cloud")<0 && serverRoomObj.val()==1){
		var cdntypelist={
			"0":"��ʹ��CDN:&nbsp;&nbsp;���",
			"1":"����˫��CDN(����150G/��):&nbsp;&nbsp;+50Ԫ/��"		
		}
		$.each(cdntypelist,function(i,n){	
								if($.trim(i+"")==$.trim(oldcdntype+"")){
									cdntypeObj.append("<option value=\""+ i +"\" selected>"+ n +"</option>");
								}else{
									cdntypeObj.append("<option value=\""+ i +"\">"+ n +"</option>");
								}
							});
		//cdntypeObj.val(oldcdntype);
	}else{
		cdntypeObj.append("<option value=\"-1\">��</option>");
	}	
}