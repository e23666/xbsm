<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/class/diyserver_Class.asp" -->
<%
response.Charset="gb2312"
conn.open constr
id=Trim(Requesta("id"))
act=requesta("act")
dim usr_mobile
dim usr_email

if not isNumeric(id) then url_return "pleaes input ID",-1

 




p_proid="ebscloud"
 
set ds=new diyserver_class
ds.user_sysid=session("u_sysid")
ds.p_proid=p_proid
ds.setHostid=id 


act=Trim(requesta("act"))
backpage=requesta("backpage")
servicetype=trim(requesta("servicetype"))
PayMethod=trim(requesta("PayMethod"))
renewTime=trim(requesta("renewTime"))

if act="getprice" then



	ds.newservicetype=servicetype
	
	ds.newPayMethod=PayMethod
	ds.newrenewTime=renewTime
	price=ds.getpaytestprice()
	response.write price
	conn.close
	set ds=nothing
	response.End()
elseif act="sub" then
	'if datediff("d","2013-07-10",now())<0 then
		'url_return "������������ͣ��ʽ��ͨ��Ԥ��7��10����ʽ���ߣ������ע��лл��",-1
	'end if
	ds.newservicetype=servicetype
	ds.newPayMethod=PayMethod
	ds.newrenewTime=renewTime
	if ds.dopaytest() then
		alert_redirect "��ϲ����������ת�������ɹ�","/manager/servermanager/"
	elseif instr(errstr,"���")>0 then
		alert_redirect "��Ǹ�����㣡���ȳ�ֵ.","/manager/OnlinePay.asp?Flow=OnlinePayment"
	else
		url_return ds.errstr,-1
	end if
end If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���������йܹ���</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<style>
#loadsubinfo{ display:none; width:auto; text-align:center; color:#000; font-size:14px; }
</style>
<script language="javascript">
var id=<%=id%>;
var backpage="/manager/servermanager/";
$(function(){
	setrenewtime();
	getprice();
	$("input[name='servicetype']:radio").click(function(){getprice();});
	$("input[name='PayMethod']:radio").click(function(){setrenewtime();getprice();});
	$("input[name='subbtton']:button").click(function(){dosub();});
	$("input[name='subbtton_bak']:button").click(function(){ window.location.href=backpage;});
});
function dosub(){
	if(confirm("ȷ������������תΪ��ʽ������?")){
		$("input[name='act']:hidden").val("sub");
		$("#subinfo").slideUp(50,function(){$("#loadsubinfo").slideDown();});		
		 $("form[name='form1']").submit();
				
	}
}
function setrenewtime(){
	$("#renewtime_msg").html("<select name=\"renewTime\" style=\"width:200px;\"></select>");	
	
	var renewTimeObj=$("select[name='renewTime']");
		var payObj=$("input[name='PayMethod']:radio:checked");
		renewTimeObj.empty();
		var timelist="";
		var dw="";
		if(payObj.val()=="0"){
			timelist="1";
				diy_msg_txt=""
			dw="����";
		}else if(payObj.val()=="1"){
			timelist="1,2,3,4,5";
			diy_msg_txt=",,,,"
			dw="��";
		}else if(payObj.val()=="2"){
			timelist="1,2,3,4";
			diy_msg_txt=",,,"
			dw="����";
		}else if(payObj.val()=="3"){
			timelist="1,2,3,4";
			diy_msg_txt=",,,"
			dw="����"
		}
temparraylist=diy_msg_txt.split(",")
			$.each(timelist.split(","),function(i,n){
				var nn=n;
				if(payObj.val()=="3") nn=parseInt(n) * 6;
				renewTimeObj.append("<option value=\""+ $.trim(n) +"\">"+ nn + dw +temparraylist[n-1]+"</option>");
			});	
			
		
		renewTimeObj.change(function(){getprice();});
		getpreday();
}
function getpreday(){
	var payObj=$("input[name='PayMethod']:radio:checked");
	var renewTimeObj=$("select[name='renewTime'] option");
	var renewTime="";var preyear=0;var nndw="";
	$.each(renewTimeObj,function(i,n){renewTime+=$(n).val()+",";});
	$.post("/services/Server/Order.asp","act=getpreday&PayMethod="+ escape(payObj.val())+"&renewTime="+escape(renewTime),function(msg){
		predayArr=msg.split(',');
		$.each(renewTimeObj,function(i,n){
			if(predayArr[i]>0){
				preyear=predayArr[i]/360+"��";
				nndw=$(n).text();
				$(n).text(nndw+" (��"+ nndw +"����"+(preyear=="0.5��"?"����":preyear)+")");
			}
		}); 
	})
}
function getprice(){
	var servicetype=$("input[name='servicetype']:radio:checked").val();
	var PayMethod=$("input[name='PayMethod']:radio:checked").val();
	var renewTime=$("select[name='renewTime'] option:selected").val();
	$("#moneycodeprice_msg").css({"color":"#ccc"});
	$.post(window.location.mappath,"id="+ id +"&act=getprice&servicetype="+ escape(servicetype)+"&PayMethod="+ escape(PayMethod)+"&renewTime="+renewTime,function(data){
		$("#moneycodeprice_msg").html("��"+data);
		$("#moneycodeprice_msg").css({"color":"red"});
		$("input[name='mc_oldprice']:hidden").val(data);
		//getMoneycodeprice();
	})
}
</script>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
 
   
<form name="form1" action="<%=Requesta("script_name")%>" method="post">
 <table class="manager-table">             
	<tbody>
		<tr><th colspan=2>��������ת��</th></tr>
		<tr>
			<th align="right">������IP��ַ:</th>
			<td align="left"><%=ds.oldserverip%></td>
		</tr>
		<tr>
			<th align="right">�����׼:<br />
                <a href="/services/server/vip.asp" target="_blank" style="font-size:12px; color:#06c; font-weight:normal;" title="�鿴�����׼">(�鿴�����׼)</a></th>
			<td align="left"> <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>��������">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>��������</a>&nbsp;&nbsp;���(�ʺ�רҵ���ͻ�,�������ڲ����ⵥ���շ�) </label><BR>
              <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>ͭ�Ʒ���" checked>
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>ͭ�Ʒ���</a>&nbsp;&nbsp;��68Ԫ/��(�ʺ�һ��ͻ�,�ṩ��׼����֧��) </label><BR>
              <label class="msg" >
                <input type="radio" name="servicetype" value="<%=companyname%>���Ʒ���">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>���Ʒ���</a>&nbsp;&nbsp;��98Ԫ/��(�ʺϳ����ͻ�,�ṩ���ȼ���֧��) </label><BR>
              <label class="msg">
                <input type="radio" name="servicetype" value="<%=companyname%>���Ʒ���">
                <a href="/services/server/vip.asp" target="_blank" style="color:#333"><%=companyname%>���Ʒ���</a>&nbsp;&nbsp;��188Ԫ/��(�ʺ�VIP�ͻ�,�ṩȫ��λ����֧��) </label>
              </label></td>
		</tr>
		<tr>
			<th align="right">���ѷ�ʽ:</th>
			<td align="left"><%=ds.getVpsPayMethod()%></td>
		</tr>
		<tr>
			<th align="right">����ʱ��:</th>
			<td align="left" id="renewtime_msg" >1</td>
		</tr>

		<tr  id="needPrice">
			<th align="right">�������:</th>
			<td align="left" id="renewtime_msg" >1</td>
		</tr>
		<tr>
			<th align="right">�������:</th>
			<td align="left"> <label class="msg" id="moneycodeprice_msg" style="width:auto;font-weight:bold">��0</label>
              <label class="msg" style="width:auto"></label>
                <input type="hidden" name="mc_proid" value="<%=p_proid%>" />
                <input type="hidden" name="mc_prokey" value="<%=id%>" />
                <input type="hidden" name="mc_action" value="new" />
                <input type="hidden" name="mc_oldprice" /></td>
		</tr>
		<tr>
		 <td colspan=2>
		 <div id="subinfo">
		 <input type="button" class="manager-btn s-btn" name="subbtton" value="ȷ��ת��" />
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="manager-btn s-btn" name="subbtton_bak" value="����" />
		</div>
			   <div id="loadsubinfo"><img src="/images/mallload.gif"> �������ڴ�����.����ˢ�»�ر������...</div>
			    <input type="hidden" value="<%=id%>" name="id" />
			    <input type="hidden" name="act" />
			  </td>
		</tr>
	</tbody>
</table>
  



       
      
      </form>
   
   











		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>