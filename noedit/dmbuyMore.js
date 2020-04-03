//功能:此页为购买域名脚本
//时间:2012-10-18


///验证所添加脚本
$(function(){
$("input[name='dom_org_m']").on("keyup keydown change blur",function (){
		var val_=$(this).val();
		val_=val_.replace("（","(").replace("）",")")
		$(this).val(val_)
		$("input[name='dom_org']").val($(this).toPinyin());
	});
$("input[name='dom_ln_m']").on("keyup keydown change blur",function (){
		$("input[name='dom_ln']").val($(this).toPinyin());
	});
	
$("input[name='dom_fn_m']").on("keyup keydown change blur",function (){
		$("input[name='dom_fn']").val($(this).toPinyin());
	});	
	
	$("input[name='dom_ct_m']").on("keyup keydown change blur",function (){
		$("input[name='dom_ct']").val($(this).toPinyin());
	});
	$("input[name='dom_adr_m']").on("keyup keydown change blur",function (){
		$("input[name='dom_adr1']").val($(this).toPinyin());
	});	
		
	
	$("#domainreg").Validform({
		tiptype:2,
		showAllError:true,
		btnSubmit:".z_btn-buy",
		datatype:{
			"enname":function(gets,obj,curform,regxp)
				{
				/*参数gets是获取到的表单元素值，
				  obj为当前表单元素，
				  curform为当前验证的表单，
				  regxp为内置的一些正则表达式的引用。*/
				  var reg=""
                  ennameval=obj[0].value;
				  
//						  if(ennameval.indexOf(" ")>0)
//						 {
//						 return true;
//						 }else
//						 {
//						return false;
//						 }
					var reg=/^[0-9a-zA-Z\_\-\.,\s]{5,150}$/;
				 
					if(reg.test(ennameval))
					{
						return true;}
					else{
					return false;	
						}

				},
			  "enaddress":function(gets,obj,curform,regxp){
				
				var reg=/^[0-9a-zA-Z\_\-\.\s#,]{4,75}$/;
					enaddress=obj[0].value;
					if(reg.test(enaddress))
					{
					
//					chkxmName(do_org_m_cn)
					return true;}
					else{
					return false;	
						}
				},
			 "dom_org_m_cn":function(gets,obj,curform,regxp)
				{
					var reg=/^[\u4E00-\u9FA5\uf900-\ufa2d\(\)#A-Z0-9a-z]{2,50}$/;
					do_org_m_cn=obj[0].value;
					if(reg.test(do_org_m_cn))
					{
					
					//chkxmName(do_org_m_cn)
					return true;}
					else{
					return false;	
						}
				},
			"tel":function(gets,obj,curform,regxp)		 
				{
				    tel_=curform.find("input[name='dom_ph']");
					v=tel_.val();
                    if(!/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/.test(v)){
					tel_.attr("errormsg","格式错误,eg:028-87654321或手机号码");
							return false
					}
					if(isEasystr(myinstr(v,/\-(\d+)/ig)) ){
							tel_.attr("errormsg","号码不能为连续或重复的数字");
							return false
						}else{
							return true;
							}
				 },
			"fax":function(gets,obj,curform,regxp)		 
				{
				    tel_=curform.find("input[name='dom_fax']");
					v=tel_.val();
                    if(!/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/.test(v)){
					tel_.attr("errormsg","格式错误,eg:028-87654321或手机号码");
							return false
					}
					if(isEasystr(myinstr(v,/\-(\d+)/ig)) ){
							tel_.attr("errormsg","号码不能为连续或重复的数字");
							return false
						}else{
							return true;
							}
				 } ,
				"agree":function(gets,obj,curform,regxp)
				{
					num=curform.find("input[name='agreement']:checked").length;
					if (num>0){
					return true;}else{
						curform.find("input[name='agreement']").attr("errormsg","请先阅读相关协议后点击勾选！")
					return false;}
					
				}

		}
	});
	
	
})

///验证脚本结束


function docnst(pp){
	var getv=pp.options[pp.selectedIndex].innerText;	
	document.domainreg.cndom_st_m.value=getv;
	//$("select[name='dom_st']").val("SC");
	$("#dom_st_en").val( pp.options[pp.selectedIndex].value )


}


/////拼音转换域名注册时
//$(function (){
//
//	$("#dom_org_m").on("keyup keydown change blur",function (){
//		$("#dom_org").val($(this).toPinyin());
//	});
//});


function chkxmName(v)
{
  var xmdom="中国,cn"
  var checkul=$("#regdomainmsg");
   count =checkul.children("li").length;
   for(var i=0;i<count;i++)
   {
		   var   domTemp=checkul.children("li").eq(i).find(".domaintitle").html();
		   domTempArray=domTemp.split(".");
		  hzstr=domTempArray[domTempArray.length-1]
		  lrstr=domTempArray[domTempArray.length-2]
		  var selecti=checkul.children("li").eq(i).find("select").get(0).selectedIndex;
		  
		  //判断是否要检查域名
		  if(xmdom.indexOf(""+hzstr+"")>-1 && lrstr!="gov")
		  {
		    temphtml=checkul.children("li").eq(i).html()
			//$("input[name='username'] 
		  }
   }
}






function strReverse(s1){
	var s2 = "";
	s2 = s1.split('').reverse().join('');
	return s2;
}
function isEasystr(strnum){
	var result=false;
	var strAll="0123456789abcdefghijklmnopqrstuvwxyz";
	strnum=strnum.toString();
	if(strnum.length>1){		
		var revstr=strReverse(strnum);
		var revstrAll=strReverse(strAll);		
		if(strAll.toUpperCase().indexOf(strnum)>=0 || revstrAll.toUpperCase().indexOf(strnum)>=0){
			result=true;
		}else if(strnum.substr(0,strnum.length/2+1)==revstr.substr(0,revstr.length/2+1) || revstr==strnum){
			result=true;
		}
	}
	return result;
}
function myinstr(str,reg){
	if(reg.test(str)){
		return RegExp.$1;
	}else{
		return "";
	}
}
