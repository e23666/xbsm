<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
 

sqlArray=Array("appID,APPID,int","appName,APP����,str","buyDate,��ͨ����,date","expireDate,��������,date","p_name,��Ʒ��,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

	sqlstring="select * from wx_miniprogram_app where  datediff("&PE_DatePart_D&",expireDate,"&PE_Now&")<30 and userid=" & session("u_sysid") & " "& newsql & " order by id desc" 
    rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)


	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-΢��С�������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <script type="text/javascript" src="/noedit/template.js"></script>
<style>
.hui333{
color:#666;
}
</style>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
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
			   <li>΢��С����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		  		<form action="" method="get" id="managerform" target="_blank"></form>
				 <form name="form1" action="<%=request("script_name")%>" method="post">
					 <%=searchlist%>
				 </form>

				 <table class="manager-table">
					<tr>
						<th>APPID</th>
						<th>С��������</th>
						<th>�ͺ�</th>
						<th>��ͨʱ��</th>
						<th>����ʱ��</th>
						<th>״̬</th>
						<th>����</th>
					</tr>
					<%Do While Not rs.eof and cur<=setsize
               		  		tdcolor="#ffffff"
               				if cur mod 2=0 then tdcolor="#efefef"
               		  %>
					  <tr>
						 <td><%=rs("appid")%></td>
						 <td align="left"> <%=rs("appname")%>&nbsp;&nbsp;<img src="/images/1341453609_help.gif" id="remark_app_<%=rs("appid")%>" data-id="<%=rs("appid")%>" data-txt="" style="cursor:pointer"><br><span id="remark_bak_<%=rs("appid")%>" class="hui333"><%=rs("bakAppName")%></span></td>
						 <td><%=rs("proid")%></td>
						 <td><%=rs("buyDate")%></td>
						 <td><%=rs("expireDate")%></td>
						 <td><%=iif(rs("paytype")&""="1","����","��ʽ")%></td>
						 <td>
							<a href="renew.asp?appid=<%=rs("appid")%>" onclick="renew(<%=rs("appid")%>)" class="mt-btn"> ����</a> 
							<a href="load.asp?appid=<%=rs("appid")%>&act=getmanager" class="mt-btn" target="_blank">����</a>
							<a href="javascript:;" class="mt-btn" onclick="myapppwd(<%=rs("appid")%>)">����</a>
							<a href="javascript:;" onclick="buysms(<%=rs("appid")%>)" target="_blank" class="mt-btn">���ų�ֵ</a>
							<a href="javascript:;" onclick="myapp(<%=rs("appid")%>)" class="mt-btn">���ܹ���</a>
							<a href="javascript:;" onclick="syn(<%=rs("appid")%>)" class="mt-btn">ͬ������</a>
						 </td>
					  </tr>					 
					 <%rs.movenext
               		   cur=cur+1
               		  loop %>
					 <tr align="center">
                       <td colspan="10" class="tdbg"><%=pagenumlist%></td>
                     </tr>
				 </table>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
 
<script type="text/html" id="tpl_buysms"> 
	<form method="post" id="buysmsform" onsubmit="return false" style="padding:0;margin:0 width:100%">
		<table class="manager-table" style="width:100%">
			
			<tr><th colspan="2">΢��С������Ź���</th></tr>
			<tr>
				<th>��ǰ������</th>
				<td style="color:red" align="left" id="msgcount">load...</td>
			</tr>
			<tr>
				<th>���ż۸�</th>
				<td style="color:red" align="left"><%=miniprogram_sms_money%>Ԫ/��</td>
			</tr>
			<tr>
				<th width="150">��������</th>
				<td width="350" align="left" style="line-height:35px;">
					<label><input type="radio" name="numtype" value="100" checked> 100��</label><br>
					<label><input type="radio" name="numtype" value="500"> 500��</label><br>
					<label><input type="radio" name="numtype" value="1000"> 1000��</label><br>
					<label><input type="radio" name="numtype" value="-1"> �Զ��� <input class="manager-input m-input width200" type="text" disabled="disabled" name="buysmscount" id="buysmscount"> ��</label>
				</td>
			</tr>
			<tr class="no-border">
				<td></td>
				<td align="left">
					<input type="button" value="ȷ������" class="manager-btn l-btn" onclick="buysmssure({{id}})">
				</td>
			</tr>
		</table>
	</form> 
</script>
 

<script type="text/html" id="tpl_getapppwd">
	<div style="width:250px;height:160px;">
	<table class="manager-table" style="width:100%">
		<tr><th colspan=2>�������</th></tr>
		<tr>
			<th>��½����</th>
			<td align="left" id="myapppasswordbox">{{password}}</td>
		</tr>
		<tr><th colspan=2><font color=red>����Ϊ��ʱ����������������޸�</font><bR><input type="button" class="manager-btn  mr-10" value="��������" onclick="resetpwd('{{id}}',this)"></th></tr>
	</table>
	</div>
</script>

<script id="tpl_buyapp" type="text/html">
	<div style="width:700px;">
	�¼ӹ���:
	<select id="addnewproductid" class="manager-select s-select">
		{{each datas as item index}} 
			{{if item.isbuy=="0" && item.proid!="" }}
				<option value="{{item.id}}" data-name="{{item.name}}"  data-price="{{item.price}}">{{item.name}}(&yen;{{item.price}}/��)</option> 
			{{/if}}
		{{/each}}
	<select>
	��������:
				<select id="addnewyear" class="manager-select s-select">
				<option value="1" selected>1��</option>
				<option value="2">2��</option>
				<option value="3">3��</option>
			</select> 
	����ʽ:<select id="addnewpaytype" class="manager-select s-select">
				<option value="1">����</option>
				<option value="0">��ʽ</option>
			 <select>
	<input type="button" class="manager-btn  mr-10" value="ȷ������" onclick="surebuyapp('{{id}}',this)">
	<input type="button" value="ȡ��"  class="manager-btn  mr-10" onclick="buybox.close()">
	<table class="manager-table" style="width:100%" id="myapptableinfo">
		<tr><th colspan=6>�ѿ�ͨ�����б�</th></tr>
		<tr>
			<th>��Ʒ���</th>
			<th>��������</th>
			<th>�ײͰ���</th>
			<th>��Ʒ�۸�</th>
			<th>����ʱ��</th>
			<th>����</th>
			
		</tr>
		{{each datas as item index}} 
			{{if item.isbuy=="1"}}
				<tr>
					<td>{{item.id}}</td>
					<td>{{item.name}}</td>
					<td>{{if item.isdefault=="1"}}<font color=green>��</font>{{else}}<font color=red>��</font>{{/if}}</td>
					<td style="color:red">&yen; {{item.price}}</td>
					<td>{{item.expiredate}}</td>
					<td>
						{{if item.isdefault=="1"}}
							-				
						{{else}}
							<input type="button" class="manager-btn  mr-10" value="����/����" onclick="renewonlyapp('{{item.id}}','{{id}}','{{item.price}}')">
						{{/if}}
					</td>


					
				</tr>
			{{/if}}
		{{/each}}
	</table>

	</div>
</script>


<script type="text/javascript">
<!--
	var smsprice=<%=miniprogram_sms_money%>; 
	var buybox=null;
	var cfg={};
	
	$(function(){ 
		
		$("[id^='remark_app_']").on("click",function(){
			var self=$(this)
			var id=$(this).attr("data-id")
			var txt=$(this).attr("data-txt") 
			$.dialog.prompt("����д����ע��Ϣ��",function(remark){				 
					$.post("load.asp",{act:"setremark",appid:id,remark:remark},function(data){
						if(data.result=="200"){
							self.attr("data-txt",remark);
							$("#remark_bak_"+id).text(remark);
							$.dialog.tips("�����ɹ�");
						}else{
							$.dialog.alert(data.msg)	
						}					
					},"json")				
				 
			},txt)
		}) 
	})

	function syn(id){
			$.post("load.asp",{act:"syn",appid:id},function(data){
						if(data.result=="200"){ 
							$.dialog.tips("ͬ�����ݳɹ�");
						}else{
							$.dialog.alert(data.msg)	
						}					
					},"json")	
	}
	function buysmssure(id){
		var num=$("input[name='numtype']:checked").val();
		if(num<0){
			num=$("#buysmscount").val();
		} 
		if(!isNaN(num) && num!=""){
			$.dialog.confirm("��ȷ��Ҫ��ֵ<font color=red>"+num+"</font>������,����<font color=red>"+(num*smsprice)+"</font>Ԫ",function(){
				$.post("load.asp",{appid:id,act:"buysms",num:num,r:Math.random()},function(data){
					var msg_=data.msg;
					if (msg_=="����")
					{
						msg_="��Ǹ���������㣬<a href='/manager/OnlinePay.asp' target='_blank'>������ֵ</a>��"
					}
					$.dialog.alert(msg_)	
					buybox.close();
				},"json")			
			})
			
		}else{
			$.dialog.alert("��¼���ֵ��������")
		}
	}
	function buysms(id)
	{
		 

		buybox=$.dialog({
			title:"���Ź���",
				content:template("tpl_buysms",{id:id}),
				width:"500px",
				height:"240px",
			})

			$("input[name='numtype']").on("click",function(){
				$("#buysmscount").attr("disabled","disabled")
				if($(this).val()=="-1"){
					$("#buysmscount").removeAttr("disabled")
				}
			})
		$.post("load.asp",{act:"getsmscount",appid:id},function(data){
			$("#msgcount").text(data.count);		
		},"json")
		
	}
	function myapp(id)
	{
		if(!cfg.allprice){
			$.post("load.asp",{appid:id,act:"getallprice"},function(data){
				cfg.allprice=data.datas;
				buyaddnewbox(id)
			},"json")
		}else{
			buyaddnewbox(id)
		}
	}

	function buyaddnewbox(id){
		if(!cfg.allprice){
			$.dialog.alert("��������");
			return false
		}else{ 
				$.post("load.asp",{appid:id,act:"getproductids"},function(data){

				var applist=[];
				$.each(cfg.allprice,function (i,n) {
					var line_={}
					line_.id=i;
					line_.name=n[0];
					line_.porid=n[1];
					line_.price=n[2];
					line_.renewprice=n[3];
					line_.isbuy=0
					line_.isdefault=0;
					line_.expiredate="";

					$.each(data.datas,function (ii,nn) {
						if(nn.productid==i){
							line_.isbuy=1;
							line_.isdefault=nn.isdefault;
							line_.expiredate=nn.expiredate;
							if(nn.isdefault=="1"){
								line_.price=0;
							}
							return false
						}
					})

					applist.push(line_)

				})
			var obj={datas:applist,id:id}
			console.log(obj)
			 buybox=$.dialog({
				title:"�������ӹ���", 
				content:template("tpl_buyapp",obj)
			 })

			   
				 $.each(data.datas,function(i,n){
						$("#addnewproductid").find("option[value='"+n.productid+"']").remove();
						$("#buy_expdate_"+n.productid).html(n.expiredate)
				 }) 
 
			},"json")
	}
	}

	function surebuyapp(appid,obj)
	{
		$(obj).attr("disabled","disabled")
		var appobj=$("#addnewproductid");
		var id=appobj.val();
		var appprice=appobj.find("option:selected").attr("data-price");
		var appname=appobj.find("option:selected").attr("data-name");
		var apppaytype=$("#addnewpaytype").val();
		var buy_year=$("#addnewyear").val(); 
		if(apppaytype=="1"){appprice=0;}
		var msg="��ȷ��Ҫ����΢��С������?<BR>��������:<font color=red>"+appname+"</font><br>����ʱ�䣺<font color=red>"+buy_year+"��</font> <BR>���ܼ۸�:<font color=red>&yen;"+(appprice*buy_year)+"</font><br><font color=blue>֧��7���������</font>"
		$.dialog.confirm(msg,function(){
		
			$.post("load.asp",{appid:appid,id:id,year:buy_year,act:"addnewproduct",paytype:apppaytype},function(data){
				if (data.result=="200")
				{
					$("#addnewproductid").find("option[value='"+id+"']").remove();
					
					$.each(cfg.allprice,function(i,n){
						 if(i==id){
							var trstr=""
							trstr+="<tr>"
							trstr+="<td>"+i+"</td>"
							trstr+="<td>"+n[0]+"</td>"
							trstr+="<td><font color=red>��</font></td>"
							trstr+='<td>&yen; <font color=red>'+n[2]+'</font></td><td></td><td><input type="button" class="manager-btn  mr-10" value="����/����" onclick="renewonlyapp('+i+','+appid+','+n[2]+')"></td></tr>'

							$("#myapptableinfo").append(trstr);
							return false;		 
						 }
					 })
					 $.dialog.alert("������ӳɹ���")
				}else{
					$.dialog.alert(data.msg)
				}
				$(obj).removeAttr("disabled")
			},"json") 
			
		},function(){
			$(obj).removeAttr("disabled")
		
		}) 
	}

	function renewonlyapp(id,appid,price){
		$.dialog.confirm("��ȷ��Ҫ������Դ˹�������1��,���:<font color=red>&yen; "+price+"</font>?",function(){
			$.post("load.asp",{appid:appid,id:id,act:"renewonlyapp"},function(data){
				$.dialog.alert(data.msg)
			},"json")		
		})	
	}

	function myapppwd(id){
		$.post("load.asp",{appid:id,act:"getpwd"},function(data){ 
			buybox=$.dialog({
			title:"APP��½�������",
				content:template("tpl_getapppwd",{id:id,password:data.password}),
				width:"300px",
				height:"140px",
				id:"getpwdbox"
			})  
		},"json")
	}

	function resetpwd(id,obj){
		$(obj).attr("disabled","disabled")
		$(obj).val("����������,���Ժ�...")
		$.post("load.asp",{appid:id,act:"setrepwd"},function(data)
		{ 
			if(data.result=="200"){
				$("#myapppasswordbox").text(data.password);
			}else{
				
			}
		$(obj).val("��������")
			$(obj).removeAttr("disabled")
		},"json")
	}

	function getmanager(id) {
		$.post("load.asp",{appid:id,act:"getmanager"},function(data)
		{ 
			if(data.result=="200"){
				var obj=$("#managerform")
				obj.attr("action",data.url);
				obj.submit();
			//s	obj.attr("action","");
			}else{
				$.dialog.alert(data.msg);
			}
		},"json")
		
	}



-->
</script>

</body>
</html>

