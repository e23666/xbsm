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
call getusrinfo2()
if not isNumeric(id) then url_return "pleaes input ID",-1

sql="select * from hostrental where id=" & id & " and u_name='" & session("user_name") & "'"
rs.open sql,conn,1,1
Set ebscfg=get_cacehe_ebs_confg()
if rs.eof then url_return "无此主机",-1
if rs("P_proid")&""="" then url_return "该主机不能续费,请联系管理员",-1
if not rs("start") then url_return "主机未开通，不能续费",-1
If InStr(","&session("synok_ip")&",",","&rs("allocateip")&",")=0 Then 
	call doUserSyn("server",rs("allocateip"))
	rs.close
	rs.open sql,conn,1,1
	If Trim(session("synok_ip"))="" Then 
		session("synok_ip")=rs("allocateip")
	Else
		session("synok_ip")=session("synok_ip")&","&rs("allocateip")
	End if
End if

price=rs("moneypermonth")
RenewYear=requesta("RenewYear")
allocateip=rs("allocateip")
paymethod=requesta("paymethod") 
if paymethod&""="" then paymethod=trim(rs("paymethod"))
'if Rs("hostType")=1 then
	'paymethod=2
'end if
if act="needprice" then
	if isnumeric(RenewYear) and RenewYear<>"" then
			set sb=new buyServer_Class
			sb.setUserid=session("u_sysid")
			sb.getHostdata(allocateip)
			sb.paymethod=paymethod
			sb.renewTime=RenewYear
			call sb.getrenewPrice()
			If CDbl(sb.ipprice)>0 Then
				price="&yen; "&cdbl(sb.PricMoney)&"(<font color=red>含独立IP费用&yen; "&sb.ipprice&"</font>)"
			else
				price="&yen; "&cdbl(sb.PricMoney)
			End if
	else
		price="未知"	
	end if
	conn.close
	response.write price
	response.end
end if
sub getusrinfo2()
	sql="select fax,Email from hostrental where id="&id
	set ulrs=conn.execute(sql)
	usr_mobile=ulrs(0)
	usr_email=ulrs(1)
	ulrs.close
	set ulrs=nothing
end sub
paymethod=trim(rs("paymethod"))
prodtype=trim(rs("prodtype"))
snapadv=Trim(rs("snapadv"))
call doUserSyn("server",allocateip) 
if paymethod>3 then paymethod=1 
iparr=getOtherips(allocateip)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-主机租用托管续费</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript"> 
$(function(){
	page_start();
});
function page_start(){
	var payObj=$("input[name='paymethod']:radio");
	var RenewYearObj=$("select[name='RenewYear']");
	var subObj=$("input[name='renew_button']");
	setPaymethod();
	payObj.click(function(){
		setPaymethod();
	});	
	RenewYearObj.change(function(){
		getprice();
	});
	subObj.click(function(){
		if (confirm("您确定要续费该主机吗?")){
			$("input[name='productType']:hidden").val("server");
			$("form[name=form1]").submit();
		}
	});
}
function setPaymethod(){
	var payObj=$("input[name='paymethod']:radio:checked");
	var timelist="";
	var dw="";
	if(payObj.val()=="0"){
		timelist="1";
		diy_msg_txt=""
		dw="个月";
	}else if(payObj.val()=="1"){
		timelist="1,2,3,4,5";
		diy_msg_txt=",,,,"
		dw="年";
	}else if(payObj.val()=="2"){
		timelist="1";
		diy_msg_txt=","
		dw="季度";
	}else if(payObj.val()=="3"){
		timelist="1";
		diy_msg_txt=","
		dw="个月"
	}
	temparraylist=diy_msg_txt.split(",")
	var RenewYearObj=$("select[name='RenewYear']");
	RenewYearObj.empty();
	$.each(timelist.split(","),function(i,n){
		var nn=n;
		if(payObj.val()=="3") nn=parseInt(n) * 6;
		RenewYearObj.append("<option value=\""+ $.trim(n) +"\">"+ nn + dw +temparraylist[n-1]+"</option>");
	});	
	getprice();
}
function getprice(){	
	var RenewYearObj=$("select[name='RenewYear']");
	var payObj=$("input[name='paymethod']:radio:checked");
	var hostidObj=$("input[name='p_id']:hidden");
	var subObj=$("input[name='renew_button']");
	$("#needprice").html("load..");
	subObj.attr("disabled",true);
	var datainfo="act=needprice&id="+ hostidObj.val() +"&PayMethod="+escape(payObj.val())+"&RenewYear="+escape(RenewYearObj.val())+"&r="+Math.random();
	//alert(datainfo)
//	$("#cs").html(datainfo)
 //document.write(datainfo)
	$.ajax({
	  type: "POST",
	  url:window.length.pathname,
	  data:datainfo,
	  cache:false,
	  success:function(data){
		 $("#needprice").html(data);
		  subObj.removeAttr("disabled");
	  }
	}); 
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li><a href="/Manager/servermanager/">独立IP主机管理</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
 <form name=form1 action="../config/renew.asp" method=post>
 <table class="manager-table">             
                <tbody>
                  <tr>
                    <th width="44%" align="right" >1. 主 机</th>
                    <td width="56%" align="left"><%=Rs("allocateip")%></td>
                  </tr>
				 
                  <tr>
                    <th align="right" ><font color="#000000">2. 
                      年 限</font></th>
                    <td align="left"><%=Rs("years")%></td>
                  </tr>
				   <tr>
					<th  align="right">额外IP</th>
					<td  align="left">
						<%
						For Each line In iparr
						ipprice=GetNeedPrice(session("user_name"),line("prodid"),1,"renew")/12
					 
						%>
							<%=line("ip")%> (<font color=red><%=iif(CDbl(line("isddos"))=1,"高防IP,","")%>&yen;<%= line("price")%>/月</font>)<BR>
						<%
						next
						%>
					</td>
				  </tr>
                  <tr>
                    <th align="right" ><p align="right">开通日期：</p></th>
                    <td align="left"><%=formatDateTime(Rs("starttime"),2)%></td>
                  </tr>
                  <tr>
                    <th align="right" > 到期日期： </th>
                    <td align="left"><%=formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",Rs("alreadypay"),Rs("starttime"))),2)%></td>
                  </tr>
                  
                  <tr>
                    <th align="right" >付款周期： </th>
                    <td align="left"><%
					if paymethod=0 then
						timelist="1,2,3,4,5,6,7,8,9,10,11,12"
						dw="个月"
						response.write "月付"
					elseif paymethod=2 then
						timelist="1,2,3,4"
						dw="季度"
						response.Write "季付"
					elseif paymethod=3 then
						timelist="1,2,3,4"
						dw="个月"
						response.write "半年付"
					elseif paymethod=1 then
						timelist="1,2,3,4"
						dw="年"
						response.write "年付"
					end if
					
					%></td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center" ><div class="redAlert_Box RedLink">为了使您能快捷、准确地收到续费通知等信息，请核实您的手机为：<span class="GreenColor"><%=usr_mobile%></span>，邮箱为：<span class="GreenColor"><%=usr_email%></span>，若不对，请及时<a href="/manager/usermanager/default2.asp" class="Link_Blue">修改</a>！ </div></td>
                  </tr>
                  
                  
                  
                  
                  
                  
    <% 
	If  rs("buytest") then
	%>       
    <tr>
      <td colspan="2">您的是试用主机不能进行续费操作,需要正式开通后才能续费<br />
        <a href="paytest.asp?id=<%=id%>"><img src="/images/Cloudhost/button2_open.gif" width="193" height="47" /></a></td></tr>      
    <%else%>           
                  
                  
                  
           
                  <tr>
					<th  align="right">产品型号:</th>
					<td align="left"><%
					 Select Case int(prodtype)
						Case 1
							Response.write "高频CPU型"
						Case Else
							Response.write "通用型"
					 End select
					%></td>
				  </tr>
                  <tr>
					<th  align="right">云快照:</th>
					<td align="left"><%
					 Select Case int(snapadv)
						Case 1
							Response.write "高级云快照（"&GetNeedPrice(session("user_name"),"snapadv01",1,"new")&"元/月）"
						Case Else
							Response.write "基础云快照（免费）"
					 End select
					%></td>
				  </tr>
				<%if CDbl(rs("cc"))>0 then%>
				<tr>
					<th  align="right">安全防护:</th>
					<td align="left">CC防护(
					<%If InStr(ebscfg("free_cc_roomids"),","&rs("serverRoom")&",")>0 then%>
						0
					<%else%>
						<%=GetNeedPrice(session("user_name"),"ccfh",1,"renew")&"元/月"%>
					<%End if%>					
					)</th>
				</tr>
				<%End if%>

                  <tr>
                    <th align="right" > 支付方式： </th>
                    <td align="left">
                    <label>
                        <input name="paymethod" type="radio" value="0" <%if paymethod=0 or paymethod=0 then response.write "checked"%> />
                        月</label>
                    <label>
                        <input name="paymethod" type="radio" value="2" <%if paymethod=2 or paymethod=0 then response.write "checked"%> />
                        季付</label>
                      <label >
                        <input name="paymethod" type="radio" value="3" <%if paymethod=3 then response.write "checked"%> />
                        半年付</label>
                      <label>
                        <input name="paymethod" type="radio" value="1" <%if paymethod=1 then response.write "checked"%> />
                        年付</label>
                      （提示：年付更优惠！）</td>
                  </tr>
                  <tr>
                    <th align="right" > 续费期限：</th>
                    <td align="left"><select name="RenewYear"></select></td>
                  </tr>
                  <tr>
                    <td align="right"> 交费金额：</td>
                    <td align="left">&nbsp; <span id="needprice" style="font-weight:bold" ></span></td>
                  </tr>
                  <tr>
                    <td colspan="2" ><input name="renew_button" type="submit" class="manager-btn s-btn"  value="　主　机　续　费　">
                      <input type="button" value="  返 回  " class="manager-btn s-btn" onClick="javascript:location.href='default.asp'">
                      <input type="hidden" value="<%=id%>" name="p_id">
          			  <input type="hidden" name="productType" /></td>
                  </tr>
     <%end if%>                
                  
                  
                </tbody>
            
            </table>  </form>






		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>