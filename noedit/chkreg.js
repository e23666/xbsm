$(function(){
	//$(".registerform").Validform();  //����һ�д��룡;
	
	$("#goform").Validform({
	     showAllError:true,
		 tiptype:2,
		 btnSubmit:".z_btn-buy",
		 datatype:{
			 "typesxz":function(gets,obj,curform,regxp){
					   num=curform.find("input[name='u_class']:checked").length;
						v=curform.find("input[name='u_class']:checked").val()
									if(num>0){
										  if(v=="��˾�û�")
										  { $("#u_name_txt").html("���뵥λ��������(*)")}else
										  {
											 $("#u_name_txt").html("����(*)��") 
											  }
									return true;}else{
								return false;}
				 },
			"tel":function(gets,obj,curform,regxp)		 
				{
				    tel_=curform.find("input[name='u_telphone']");
					v=tel_.val();
					if (v!="")
					{
					if(!/^([\d]{3,4})(-)([\d]{7,8})$|^([\d]{7,8})$|^1([\d]{10})$/.test(v)){
						tel_.attr("errormsg","��ʽ����,eg:028-87654321���ֻ�����");
							return false
					}
					if(isEasystr(myinstr(v,/\-(\d+)/ig)) ){
							tel_.attr("errormsg","���벻��Ϊ�������ظ�������");
							return false
						}else{
							return true;
							}
					}
                   return true;
				 }
				 ,
			"agree":function(gets,obj,curform,regxp)
				{
					num=curform.find("input[name='agreement']:checked").length;
					if (num>0){
					return true;}else{
						alert("�����Ķ����Э�������ѡ��")
					return false;}
					
		   
				}
		
		 }
	});
})





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
