$.ajaxSetup({
			cache:false,
			timeout:20000,
			error: function(a,b,c){
				alert(a+b+c);
			}
});
$(function(){
	vps=$("input[name='vps']:hidden").val();
	getmethod();
	if(vps=="okay")
	{
		$("select[name='serverRoom']").change(function(){
			getmethod();
            changecdntype();
		    setrenewtime();
		});	
	}
	else	
	{
		$("#needprice").parents("dd.clearfix").slideUp(0);
		$("#needprice").parent("tr").slideUp(0);
		$("input[name='VPSOpen']:radio").parents("dd.clearfix").slideUp(0);
		$("input[name='VPSOpen']:radio").parent("label").slideUp(0);
	}
	setrenewtime();
	changecdntype();
	
});
function getmethod(){	
	//$("#PayMethod").html("load..");
//	if(vps=="okay")
//	{
		var serverroom=$("select[name='serverRoom']");
		var p_proid=$("input[name='p_proid']:hidden").val();
		//if(serverroom.get(0)){		
//			var info="act=getVpsPayMethod&serverroom="+serverroom.val()+"&p_proid="+ escape(p_proid);
//			$.post("/services/server/SaveHost.asp",info,function(data){
//				$("#PayMethod").html(data);
//             
//				getvpsprice();
				$("input[name='PayMethod']:radio").click(function(){
					setrenewtime()
					getvpsprice();
				});
				$("input[name='servicetype']:radio").click(function(){
					getvpsprice();
				});
				$("select[name='cdntype']").change(function(){
					getvpsprice();
				});
	
		//	});
	//	}
	//}else
//	{
//		$("#PayMethod").html(" <input type=\"radio\" name=\"PayMethod\" value=\"0\" checked />���¸�\r\n" +
//                			 "<input type=\"radio\" name=\"PayMethod\" value=\"2\" />������\r\n" + 
//                 			 "<input type=\"radio\" name=\"PayMethod\" value=\"3\" />�����긶\r\n" +
//                			 "<input type=\"radio\" name=\"PayMethod\" value=\"1\" />���긶\r\n" +
//                			 "<input type=\"radio\" name=\"PayMethod\" value=\"5\" />��2�긶\r\n");	
//	}
	
}




function setrenewtime() {

var p_proidc=$("input[name='p_proid']:hidden").val();
  
	if (p_proidc!="")
	{
	
    $("#renewtime_msg").html("<select name=\"renewTime\" style=\"width:200px;\"></select>");
    var renewTimeObj = $("select[name='renewTime']");
    var payObj = $("input[name='PayMethod']:radio:checked");
	
    renewTimeObj.empty();
    var timelist = "";
    var dw = "";
    if (payObj.val() == "0") {
        timelist = "1";
		diy_msg_txt=""
        dw = "����"
    } else if (payObj.val() == "1") {
        timelist = "1,2,3,4,5";
		diy_msg_txt="����1����3�¡�,����2��1�꡿,����3����2�꡿,,����5����3�꡿"
        dw = "��"
    } else if (payObj.val() == "2") {
        timelist = "1,2,3,4";
		diy_msg_txt=",����6����1�¡�,,����1����3�¡�"
        dw = "����"
    } else if (payObj.val() == "3") {
        timelist = "1,2,3,4";
		diy_msg_txt="����6����1�¡�,����1����3�¡�,,����2��1�꡿"
        dw = "����"
    }
	temparraylist=diy_msg_txt.split(",")
    $.each(timelist.split(","),
    function(i, n) {
        var nn = n;
        if (payObj.val() == "3") nn = parseInt(n) * 6;
		
		
        renewTimeObj.append("<option value=\"" + $.trim(n) + "\">" + nn + dw +temparraylist[n-1]+"</option>")
    });
    renewTimeObj.change(function() {
      getvpsprice();
    });
   getvpsprice();
	}else{
	$("#renewtime_msg").html("")
	}
}










function getvpsprice(){
	var serverRoomObj=$("select[name='serverRoom']");
	var PayMethodObj=$("input[name='PayMethod']:radio:checked");
	var p_proid=$("input[name='p_proid']:hidden").val();
	var servicetype=$("input[name='servicetype']:radio:checked");	
	var cdntypeObj=$("select[name='cdntype']");
	var YesrObj=$("select[name='Years']");
	var renewTime=$("select[name='renewTime']");
	renewTimeval=renewTime.val();
	if (renewTime.val()==undefined)
	{
	renewTimeval=1
	}
 
	if(PayMethodObj.val()=="4")
	{
	YesrObj[0].selectedIndex = 1;
	}else{
	YesrObj[0].selectedIndex = 0;
	}
	$("#needprice").html("load..");
	var info="act=getvpsprice&serverroom="+serverRoomObj.val()+"&PayMethod="+PayMethodObj.val()+"&p_proid="+ escape(p_proid) +"&cdntype="+  cdntypeObj.val() + "&servicetype="+ escape(servicetype.val())+"&vps="+vps+"&renewTime="+renewTimeval;
	//document.write(info)
		$.post("/services/server/SaveHost.asp",info,function(data){			
			$("#needprice").html("��"+data);
	});
}
function isNumber(number){
var i,str1="0123456789.";
	for(i=0;i<number.value.length;i++){
	if(str1.indexOf(number.value.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function checkNull(data,text){
	if (data.value==""){
		alert("��Ǹ!�ύʧ�ܣ�"+text+"����Ϊ��!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("��Ǹ!["+text+"]����������,�����޷��ύ");
	data.focus();
	data.select();
	return false;
	}
}
return true;
}

function checkForm(form){
	if (!checkNull(form.Name,"��ϵ��")) return false;
	if (!checkNull(form.Telephone,"�绰")) return false;
	if (!checkNull(form.Email,"Email��ַ")) return false;
	if (!checkNull(form.Zip,"�ʱ�")) return false;
	if (!checkNull(form.Address,"��ַ")) return false;

	if (!checkNull(form.CPU,"������������")) return false;
	if (!checkNull(form.HardDisk,"������Ӳ��")) return false;
	if (!checkNull(form.Memory,"�������ڴ�")) return false;
	$("input[name='act']:hidden").val("buysub");
	return true;

}

function changecdntype()
{
	var cdn_=$("select[name='cdntype']");
		    cdn_.find("option[value='1']").remove()
			if($("select[name='serverRoom']").val()==1)
			{
			  cdn_.append("<option value=\"1\">����˫��CDN:&nbsp;&nbsp;+50Ԫ/��</option>")
			}
}