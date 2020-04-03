function page_start(){
	getCalldiv("MainContentDIV");
	var rootObj=$("#Reg_Box > form[name='regForm'] > dl > dd[class!='dd_knowfrom clearfix'][class!='rb_cart clearfix'][class!='rb_submit clearfix']");
	$.each(rootObj,function(i,n){
	//为了页面干净，用js加元素
		var inputObj=$(n).find("h1 > input:password,input:text,select[name],input:radio[name='u_class']");
		inputObj.blur(function(){
							dooldbg(this);	  
					});
		inputObj.focus(function(){
							dochgbg(this);
							
					});	
		if($(inputObj)[0]){
			$(n).find("h3:contains('')").append("<span id=\""+ inputObj.attr("name") +"_call\"></span>");
		}
	});
	//用户类型选择事件
	var uclassVal=rootObj.find("input[type='radio'][name='u_class']");
	uclassVal.click(function(){
				if($(this).attr("checked")==true){
					if($(this).val()=="公司用户"){
						$("dd.clearfix:contains('申请单位中文名称')").show(200);
						$("dd.clearfix > label:contains('联系人英文名称')").html("申请单位英文名称");
					}else{
						$("dd.clearfix:contains('申请单位中文名称')").hide(200);
						$("dd.clearfix > label:contains('申请单位英文名称')").html("联系人英文名称");
					}
				 }
			})
	//对密码添加按键事件用以验证密码强度
	var pwdobj=rootObj.find("input[name='u_password']:password");
	pwdobj.keyup(function(){
					passwordStrength($(this).val());
				})
   //对提交的button添加加车事件,如果是submit就不用添加
   $("#Reg_Box > form[name='regForm'] > dl > dd[class='rb_submit clearfix'] > input[name='submitbutton']:button").click(function(){doregsub();});
   //添加回回车事件
   $("#Reg_Box > form[name='regForm']").keydown(function(event){ 
											if(event.keyCode==13){
												doregsub();
											}	 
										});
   $("select[name='question']").change(function(){
											var myq=$("dd:contains('自定义问题'):has(input[name='myquestion'])");
											if($(this).val()=="*我的自定义问题"){
												myq.show(100);
											}else{
												myq.hide(100);	
											}
										});

}
function doregsub(){
	issub=true;
	flag = 1;
	$("form[name='regForm']").find("input[name='act']:hidden").val("");
	var inputArr=(must_input + "," + nomust_input).split(",");
	allowflag=inputArr.length;
	if($("#Reg_Box").find("input:radio[name='u_class'][checked]").val()=="个人用户")
		allowflag--;
	$.each(inputArr,function(i,n){
			var doobj=$("form[name='regForm']").find("*[name='"+ $.trim(n) +"']");
			if($(doobj)[0]){
				checkinput(doobj,true);
			}
		   });
	return false;
}
function dooldbg(v){
//离开
	if($(v).attr("name")!="u_class")
		$(v).attr("class","z_inputbox");
	checkinput(v,true);
}
function dochgbg(v){	
//得到
	if($(v).attr("name")!="u_class"){
		if(!$.browser.msie || $(v).attr("tagName")!="SELECT")
			$(v).attr("class","z_chginput");
	}
	checkinput(v,false);
}

function checkinput(v,p){
	if(p){
		$("#titletext").html("");
		$("#titlemsg").css("display","none");
		var info="act=check&inputname="+ $.trim($(v).attr("name")) +"&inputvalue=" + $.trim(escape($(v).val()));
		if($(v).attr("name")=="u_province" || $(v).attr("name")=="u_city" || $(v).attr("name")=="u_citym")
			info="act=check&inputname=proandcity&inputvalue=" + $.trim(escape($("select[name='u_province']").val())) + "," + $.trim(escape($("select[name='u_city']").val())) + $.trim(escape($("select[name='u_citym']").val()));
		else if($(v).attr("name")=="u_company")
			info +="," + $.trim(escape($("input:radio[name='u_class'][checked]").val()));
		else if($(v).attr("name")=="myquestion"){
			if($("select[name='question']").val()=="*我的自定义问题")
			var info="act=check&inputname=question&inputvalue=" + $.trim(escape($(v).val()));
			else
			Completion("",v);
		}else if($(v).attr("name")=="u_password2"){
			if($("form[name='regForm']").find("input[name='u_password']:password").val()==$(v).val())
				Completion("",v);	
			else
				Completion("两次密码输入不相同",v);
			return ;
		}
	$.ajax({
		   type: "POST",
		   url:"/reg/default.asp",
		   timeout:10000,
		   data:info,
			   error:function(request, settings){
					 Completion("出错",v);
			   },
			   success:function(date){
				   Completion(date,v);
			   }
		   })
	}else{
		var calltitle=getcalltitle(v);
		/* 控件不同位置不同 */
		if($(v).attr("name")=="u_class" && $(v).val()=="公司用户")
			doouttitlemsg(v,calltitle,"","",200);
		else if($(v).attr("name")=="u_class" && $(v).val()=="个人用户")
			doouttitlemsg(v,calltitle,"","",120);
		else if($(v).attr("name")=="u_province")
			doouttitlemsg(v,calltitle,"","",249);
		else if($(v).attr("name")=="u_city")
			doouttitlemsg(v,calltitle,"","",147);
		else if($(v).attr("name")=="u_telphone")
			doouttitlemsg(v,calltitle,"",60,25);
		else
			doouttitlemsg(v,calltitle,"","",25);

		var callspanObj=$("#" + $(v).attr("name") + "_call");
		callspanObj.html("");
		callspanObj.css("display","none");
		if($.trim($(v).attr("name"))=="u_password")
			passwordStrength($(v).val());
	}
}
function getcalltitle(v){
	var inputname=$.trim($(v).attr("name"));
	var input_json={
		u_name:"登陆账号,由数字,字母,下划线，. 组成,字符数3～60位",
		u_company:"所属单位的名称,注册后不可修改,必须包含汉字,字符数2～100位",
		u_class:"选择注册用户类型，如果是企业请选择“企业用户”,避免员工离职引起纠纷",
		u_namecn:"我司联系您时对您的称呼,必须包含汉字,字符数2～10位",
		u_password:"密码字符数6～20位<br><div id=\"passwordDescription\">请输入密码</div><div id=\"passwordStrength\" class=\"strength0\"></div>",
		u_password2:"再次输入密码，与上面的密码一致",
		u_province:"您所在的省份",
		u_city:"您所在的城市",
		u_citym:"您所在的区域",
		u_address:"您的详细通信地址,发票邮寄,信件等需用到,字符数6～200位",
		u_telphone:"能联系到您的坐机电话,以便及时收到我们的通知,格式:由数字或减号组成,字符数7～12位<br>如:028-86262244",
		msn:"能联系到您的手机,以便及时收到我们的业务过期等短信通知,邮数字组成,字符数11位",
		u_email:"您的电子邮箱,以便及时收到我们的通知信息",
		u_zipcode:"您通信地址的邮政编码,由6位数字组成",
		qq:"您的QQ号，建议填写，我们会随时通过它联系您",
		question:"您的密码保护问题，当密码丢失或忘记时方便找回",
		myquestion:"请输入您自己设置的问题,当密码丢失或忘记时方便找回，字符数4～50位",
		answer:"您的密码保护答案，当密码丢失或忘记时方便找回,格式:字母或数字或下划线或汉字,字符数2～50位",
		u_nameen:"您的单位的英文名称。格式2～50位",
		u_trade:"请填写您的<font color=#0066cc>身份证或营业执照</font>号码,建议填写,当出现账号纠纷时，方便我们核实处理",
		u_fax:"您的传真号码",
		moneycode:"输入您得到的现金券码.如果没有可以不填"};
	var returnstr="";
	$.each(input_json,function(i,n){
				if($.trim($(v).attr("name"))==$.trim(i)){
					returnstr=$.trim(n);
					return false;
				}			   
		  });
	return returnstr;
}
function Completion(date,v){
	if($(v).attr("name")=="u_city" || $(v).attr("name")=="u_citym")
		var callspanObj=$("#u_province_call");
	else
		var callspanObj=$("#" + $(v).attr("name") + "_call");
	if(date==""){
		callspanObj.css("display","block");
		callspanObj.attr("class","oktitle");
		callspanObj.html("");
		if(issub){
			
			if(flag==allowflag){
				 
				if($("input[name='agreement']:checkbox").attr("checked")){
					$("form[name='regForm']").find("input[name='act']:hidden").val("act");
					document.forms["regForm"].submit();
					issub=false;
				}else{
					alert("您还没有同意服务条款总章");
					issub=false;
					flag = 1;
				}
			}
			flag++;
		}
	}else{
		callspanObj.css("display","block");
		callspanObj.attr("class","errtitle");
		callspanObj.html(date);
		issub=false;
		flag = 1;
		
		var scrtop=$(v).offset().top;
		if($("html,body").scrollTop()>scrtop+30)
			$("html,body").animate({scrollTop:scrtop-60},"slow");
	}
}


