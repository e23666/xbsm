function page_start(){
	getCalldiv("MainContentDIV");
	var rootObj=$("#Reg_Box > form[name='regForm'] > dl > dd[class!='dd_knowfrom clearfix'][class!='rb_cart clearfix'][class!='rb_submit clearfix']");
	$.each(rootObj,function(i,n){
	//Ϊ��ҳ��ɾ�����js��Ԫ��
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
	//�û�����ѡ���¼�
	var uclassVal=rootObj.find("input[type='radio'][name='u_class']");
	uclassVal.click(function(){
				if($(this).attr("checked")==true){
					if($(this).val()=="��˾�û�"){
						$("dd.clearfix:contains('���뵥λ��������')").show(200);
						$("dd.clearfix > label:contains('��ϵ��Ӣ������')").html("���뵥λӢ������");
					}else{
						$("dd.clearfix:contains('���뵥λ��������')").hide(200);
						$("dd.clearfix > label:contains('���뵥λӢ������')").html("��ϵ��Ӣ������");
					}
				 }
			})
	//��������Ӱ����¼�������֤����ǿ��
	var pwdobj=rootObj.find("input[name='u_password']:password");
	pwdobj.keyup(function(){
					passwordStrength($(this).val());
				})
   //���ύ��button��Ӽӳ��¼�,�����submit�Ͳ������
   $("#Reg_Box > form[name='regForm'] > dl > dd[class='rb_submit clearfix'] > input[name='submitbutton']:button").click(function(){doregsub();});
   //��ӻػس��¼�
   $("#Reg_Box > form[name='regForm']").keydown(function(event){ 
											if(event.keyCode==13){
												doregsub();
											}	 
										});
   $("select[name='question']").change(function(){
											var myq=$("dd:contains('�Զ�������'):has(input[name='myquestion'])");
											if($(this).val()=="*�ҵ��Զ�������"){
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
	if($("#Reg_Box").find("input:radio[name='u_class'][checked]").val()=="�����û�")
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
//�뿪
	if($(v).attr("name")!="u_class")
		$(v).attr("class","z_inputbox");
	checkinput(v,true);
}
function dochgbg(v){	
//�õ�
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
			if($("select[name='question']").val()=="*�ҵ��Զ�������")
			var info="act=check&inputname=question&inputvalue=" + $.trim(escape($(v).val()));
			else
			Completion("",v);
		}else if($(v).attr("name")=="u_password2"){
			if($("form[name='regForm']").find("input[name='u_password']:password").val()==$(v).val())
				Completion("",v);	
			else
				Completion("�����������벻��ͬ",v);
			return ;
		}
	$.ajax({
		   type: "POST",
		   url:"/reg/default.asp",
		   timeout:10000,
		   data:info,
			   error:function(request, settings){
					 Completion("����",v);
			   },
			   success:function(date){
				   Completion(date,v);
			   }
		   })
	}else{
		var calltitle=getcalltitle(v);
		/* �ؼ���ͬλ�ò�ͬ */
		if($(v).attr("name")=="u_class" && $(v).val()=="��˾�û�")
			doouttitlemsg(v,calltitle,"","",200);
		else if($(v).attr("name")=="u_class" && $(v).val()=="�����û�")
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
		u_name:"��½�˺�,������,��ĸ,�»��ߣ�. ���,�ַ���3��60λ",
		u_company:"������λ������,ע��󲻿��޸�,�����������,�ַ���2��100λ",
		u_class:"ѡ��ע���û����ͣ��������ҵ��ѡ����ҵ�û���,����Ա����ְ�������",
		u_namecn:"��˾��ϵ��ʱ�����ĳƺ�,�����������,�ַ���2��10λ",
		u_password:"�����ַ���6��20λ<br><div id=\"passwordDescription\">����������</div><div id=\"passwordStrength\" class=\"strength0\"></div>",
		u_password2:"�ٴ��������룬�����������һ��",
		u_province:"�����ڵ�ʡ��",
		u_city:"�����ڵĳ���",
		u_citym:"�����ڵ�����",
		u_address:"������ϸͨ�ŵ�ַ,��Ʊ�ʼ�,�ż������õ�,�ַ���6��200λ",
		u_telphone:"����ϵ�����������绰,�Ա㼰ʱ�յ����ǵ�֪ͨ,��ʽ:�����ֻ�������,�ַ���7��12λ<br>��:028-86262244",
		msn:"����ϵ�������ֻ�,�Ա㼰ʱ�յ����ǵ�ҵ����ڵȶ���֪ͨ,���������,�ַ���11λ",
		u_email:"���ĵ�������,�Ա㼰ʱ�յ����ǵ�֪ͨ��Ϣ",
		u_zipcode:"��ͨ�ŵ�ַ����������,��6λ�������",
		qq:"����QQ�ţ�������д�����ǻ���ʱͨ������ϵ��",
		question:"�������뱣�����⣬�����붪ʧ������ʱ�����һ�",
		myquestion:"���������Լ����õ�����,�����붪ʧ������ʱ�����һأ��ַ���4��50λ",
		answer:"�������뱣���𰸣������붪ʧ������ʱ�����һ�,��ʽ:��ĸ�����ֻ��»��߻���,�ַ���2��50λ",
		u_nameen:"���ĵ�λ��Ӣ�����ơ���ʽ2��50λ",
		u_trade:"����д����<font color=#0066cc>���֤��Ӫҵִ��</font>����,������д,�������˺ž���ʱ���������Ǻ�ʵ����",
		u_fax:"���Ĵ������",
		moneycode:"�������õ����ֽ�ȯ��.���û�п��Բ���"};
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
					alert("����û��ͬ�������������");
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


