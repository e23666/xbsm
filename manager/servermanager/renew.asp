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
if rs.eof then url_return "�޴�����",-1
if rs("P_proid")&""="" then url_return "��������������,����ϵ����Ա",-1
if not rs("start") then url_return "����δ��ͨ����������",-1
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
				price="&yen; "&cdbl(sb.PricMoney)&"(<font color=red>������IP����&yen; "&sb.ipprice&"</font>)"
			else
				price="&yen; "&cdbl(sb.PricMoney)
			End if
	else
		price="δ֪"	
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
<title>�û������̨-���������й�����</title>
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
		if (confirm("��ȷ��Ҫ���Ѹ�������?")){
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
		dw="����";
	}else if(payObj.val()=="1"){
		timelist="1,2,3,4,5";
		diy_msg_txt=",,,,"
		dw="��";
	}else if(payObj.val()=="2"){
		timelist="1";
		diy_msg_txt=","
		dw="����";
	}else if(payObj.val()=="3"){
		timelist="1";
		diy_msg_txt=","
		dw="����"
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
 <form name=form1 action="../config/renew.asp" method=post>
 <table class="manager-table">             
                <tbody>
                  <tr>
                    <th width="44%" align="right" >1. �� ��</th>
                    <td width="56%" align="left"><%=Rs("allocateip")%></td>
                  </tr>
				 
                  <tr>
                    <th align="right" ><font color="#000000">2. 
                      �� ��</font></th>
                    <td align="left"><%=Rs("years")%></td>
                  </tr>
				   <tr>
					<th  align="right">����IP</th>
					<td  align="left">
						<%
						For Each line In iparr
						ipprice=GetNeedPrice(session("user_name"),line("prodid"),1,"renew")/12
					 
						%>
							<%=line("ip")%> (<font color=red><%=iif(CDbl(line("isddos"))=1,"�߷�IP,","")%>&yen;<%= line("price")%>/��</font>)<BR>
						<%
						next
						%>
					</td>
				  </tr>
                  <tr>
                    <th align="right" ><p align="right">��ͨ���ڣ�</p></th>
                    <td align="left"><%=formatDateTime(Rs("starttime"),2)%></td>
                  </tr>
                  <tr>
                    <th align="right" > �������ڣ� </th>
                    <td align="left"><%=formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",Rs("alreadypay"),Rs("starttime"))),2)%></td>
                  </tr>
                  
                  <tr>
                    <th align="right" >�������ڣ� </th>
                    <td align="left"><%
					if paymethod=0 then
						timelist="1,2,3,4,5,6,7,8,9,10,11,12"
						dw="����"
						response.write "�¸�"
					elseif paymethod=2 then
						timelist="1,2,3,4"
						dw="����"
						response.Write "����"
					elseif paymethod=3 then
						timelist="1,2,3,4"
						dw="����"
						response.write "���긶"
					elseif paymethod=1 then
						timelist="1,2,3,4"
						dw="��"
						response.write "�긶"
					end if
					
					%></td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center" ><div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div></td>
                  </tr>
                  
                  
                  
                  
                  
                  
    <% 
	If  rs("buytest") then
	%>       
    <tr>
      <td colspan="2">�����������������ܽ������Ѳ���,��Ҫ��ʽ��ͨ���������<br />
        <a href="paytest.asp?id=<%=id%>"><img src="/images/Cloudhost/button2_open.gif" width="193" height="47" /></a></td></tr>      
    <%else%>           
                  
                  
                  
           
                  <tr>
					<th  align="right">��Ʒ�ͺ�:</th>
					<td align="left"><%
					 Select Case int(prodtype)
						Case 1
							Response.write "��ƵCPU��"
						Case Else
							Response.write "ͨ����"
					 End select
					%></td>
				  </tr>
                  <tr>
					<th  align="right">�ƿ���:</th>
					<td align="left"><%
					 Select Case int(snapadv)
						Case 1
							Response.write "�߼��ƿ��գ�"&GetNeedPrice(session("user_name"),"snapadv01",1,"new")&"Ԫ/�£�"
						Case Else
							Response.write "�����ƿ��գ���ѣ�"
					 End select
					%></td>
				  </tr>
				<%if CDbl(rs("cc"))>0 then%>
				<tr>
					<th  align="right">��ȫ����:</th>
					<td align="left">CC����(
					<%If InStr(ebscfg("free_cc_roomids"),","&rs("serverRoom")&",")>0 then%>
						0
					<%else%>
						<%=GetNeedPrice(session("user_name"),"ccfh",1,"renew")&"Ԫ/��"%>
					<%End if%>					
					)</th>
				</tr>
				<%End if%>

                  <tr>
                    <th align="right" > ֧����ʽ�� </th>
                    <td align="left">
                    <label>
                        <input name="paymethod" type="radio" value="0" <%if paymethod=0 or paymethod=0 then response.write "checked"%> />
                        ��</label>
                    <label>
                        <input name="paymethod" type="radio" value="2" <%if paymethod=2 or paymethod=0 then response.write "checked"%> />
                        ����</label>
                      <label >
                        <input name="paymethod" type="radio" value="3" <%if paymethod=3 then response.write "checked"%> />
                        ���긶</label>
                      <label>
                        <input name="paymethod" type="radio" value="1" <%if paymethod=1 then response.write "checked"%> />
                        �긶</label>
                      ����ʾ���긶���Żݣ���</td>
                  </tr>
                  <tr>
                    <th align="right" > �������ޣ�</th>
                    <td align="left"><select name="RenewYear"></select></td>
                  </tr>
                  <tr>
                    <td align="right"> ���ѽ�</td>
                    <td align="left">&nbsp; <span id="needprice" style="font-weight:bold" ></span></td>
                  </tr>
                  <tr>
                    <td colspan="2" ><input name="renew_button" type="submit" class="manager-btn s-btn"  value="���������������ѡ�">
                      <input type="button" value="  �� ��  " class="manager-btn s-btn" onClick="javascript:location.href='default.asp'">
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