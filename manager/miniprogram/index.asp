<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
 

sqlArray=Array("appID,APPID,int","appName,APP名称,str","buyDate,开通日期,date","expireDate,过期日期,date","p_name,产品名,str")
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
<title>用户管理后台-微信小程序管理</title>
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
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>微信小程序</li>
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
						<th>小程序名称</th>
						<th>型号</th>
						<th>开通时间</th>
						<th>到期时间</th>
						<th>状态</th>
						<th>操作</th>
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
						 <td><%=iif(rs("paytype")&""="1","试用","正式")%></td>
						 <td>
							<a href="renew.asp?appid=<%=rs("appid")%>" onclick="renew(<%=rs("appid")%>)" class="mt-btn"> 续费</a> 
							<a href="load.asp?appid=<%=rs("appid")%>&act=getmanager" class="mt-btn" target="_blank">管理</a>
							<a href="javascript:;" class="mt-btn" onclick="myapppwd(<%=rs("appid")%>)">密码</a>
							<a href="javascript:;" onclick="buysms(<%=rs("appid")%>)" target="_blank" class="mt-btn">短信充值</a>
							<a href="javascript:;" onclick="myapp(<%=rs("appid")%>)" class="mt-btn">功能管理</a>
							<a href="javascript:;" onclick="syn(<%=rs("appid")%>)" class="mt-btn">同步数据</a>
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
			
			<tr><th colspan="2">微信小程序短信购买</th></tr>
			<tr>
				<th>当前短信数</th>
				<td style="color:red" align="left" id="msgcount">load...</td>
			</tr>
			<tr>
				<th>短信价格</th>
				<td style="color:red" align="left"><%=miniprogram_sms_money%>元/条</td>
			</tr>
			<tr>
				<th width="150">购买条数</th>
				<td width="350" align="left" style="line-height:35px;">
					<label><input type="radio" name="numtype" value="100" checked> 100条</label><br>
					<label><input type="radio" name="numtype" value="500"> 500条</label><br>
					<label><input type="radio" name="numtype" value="1000"> 1000条</label><br>
					<label><input type="radio" name="numtype" value="-1"> 自定义 <input class="manager-input m-input width200" type="text" disabled="disabled" name="buysmscount" id="buysmscount"> 条</label>
				</td>
			</tr>
			<tr class="no-border">
				<td></td>
				<td align="left">
					<input type="button" value="确定购买" class="manager-btn l-btn" onclick="buysmssure({{id}})">
				</td>
			</tr>
		</table>
	</form> 
</script>
 

<script type="text/html" id="tpl_getapppwd">
	<div style="width:250px;height:160px;">
	<table class="manager-table" style="width:100%">
		<tr><th colspan=2>密码管理</th></tr>
		<tr>
			<th>登陆密码</th>
			<td align="left" id="myapppasswordbox">{{password}}</td>
		</tr>
		<tr><th colspan=2><font color=red>密码为空时请点击重置密码进行修改</font><bR><input type="button" class="manager-btn  mr-10" value="重置密码" onclick="resetpwd('{{id}}',this)"></th></tr>
	</table>
	</div>
</script>

<script id="tpl_buyapp" type="text/html">
	<div style="width:700px;">
	新加功能:
	<select id="addnewproductid" class="manager-select s-select">
		{{each datas as item index}} 
			{{if item.isbuy=="0" && item.proid!="" }}
				<option value="{{item.id}}" data-name="{{item.name}}"  data-price="{{item.price}}">{{item.name}}(&yen;{{item.price}}/年)</option> 
			{{/if}}
		{{/each}}
	<select>
	购买年限:
				<select id="addnewyear" class="manager-select s-select">
				<option value="1" selected>1年</option>
				<option value="2">2年</option>
				<option value="3">3年</option>
			</select> 
	购买方式:<select id="addnewpaytype" class="manager-select s-select">
				<option value="1">试用</option>
				<option value="0">正式</option>
			 <select>
	<input type="button" class="manager-btn  mr-10" value="确定购买" onclick="surebuyapp('{{id}}',this)">
	<input type="button" value="取消"  class="manager-btn  mr-10" onclick="buybox.close()">
	<table class="manager-table" style="width:100%" id="myapptableinfo">
		<tr><th colspan=6>已开通功能列表</th></tr>
		<tr>
			<th>产品编号</th>
			<th>功能名称</th>
			<th>套餐包含</th>
			<th>产品价格</th>
			<th>到期时间</th>
			<th>操作</th>
			
		</tr>
		{{each datas as item index}} 
			{{if item.isbuy=="1"}}
				<tr>
					<td>{{item.id}}</td>
					<td>{{item.name}}</td>
					<td>{{if item.isdefault=="1"}}<font color=green>是</font>{{else}}<font color=red>否</font>{{/if}}</td>
					<td style="color:red">&yen; {{item.price}}</td>
					<td>{{item.expiredate}}</td>
					<td>
						{{if item.isdefault=="1"}}
							-				
						{{else}}
							<input type="button" class="manager-btn  mr-10" value="购买/续费" onclick="renewonlyapp('{{item.id}}','{{id}}','{{item.price}}')">
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
			$.dialog.prompt("请填写您备注信息？",function(remark){				 
					$.post("load.asp",{act:"setremark",appid:id,remark:remark},function(data){
						if(data.result=="200"){
							self.attr("data-txt",remark);
							$("#remark_bak_"+id).text(remark);
							$.dialog.tips("操作成功");
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
							$.dialog.tips("同步数据成功");
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
			$.dialog.confirm("您确定要充值<font color=red>"+num+"</font>条短信,共计<font color=red>"+(num*smsprice)+"</font>元",function(){
				$.post("load.asp",{appid:id,act:"buysms",num:num,r:Math.random()},function(data){
					var msg_=data.msg;
					if (msg_=="余额不足")
					{
						msg_="抱歉，您的余额不足，<a href='/manager/OnlinePay.asp' target='_blank'>立即充值</a>。"
					}
					$.dialog.alert(msg_)	
					buybox.close();
				},"json")			
			})
			
		}else{
			$.dialog.alert("请录入充值短信条数")
		}
	}
	function buysms(id)
	{
		 

		buybox=$.dialog({
			title:"短信购买",
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
			$.dialog.alert("参数错误");
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
				title:"额外增加功能", 
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
		var msg="您确定要增加微信小程序功能?<BR>功能名称:<font color=red>"+appname+"</font><br>购买时间：<font color=red>"+buy_year+"年</font> <BR>功能价格:<font color=red>&yen;"+(appprice*buy_year)+"</font><br><font color=blue>支持7天免费试用</font>"
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
							trstr+="<td><font color=red>否</font></td>"
							trstr+='<td>&yen; <font color=red>'+n[2]+'</font></td><td></td><td><input type="button" class="manager-btn  mr-10" value="购买/续费" onclick="renewonlyapp('+i+','+appid+','+n[2]+')"></td></tr>'

							$("#myapptableinfo").append(trstr);
							return false;		 
						 }
					 })
					 $.dialog.alert("功能添加成功！")
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
		$.dialog.confirm("您确定要单独针对此功能续费1年,金额:<font color=red>&yen; "+price+"</font>?",function(){
			$.post("load.asp",{appid:appid,id:id,act:"renewonlyapp"},function(data){
				$.dialog.alert(data.msg)
			},"json")		
		})	
	}

	function myapppwd(id){
		$.post("load.asp",{appid:id,act:"getpwd"},function(data){ 
			buybox=$.dialog({
			title:"APP登陆密码管理",
				content:template("tpl_getapppwd",{id:id,password:data.password}),
				width:"300px",
				height:"140px",
				id:"getpwdbox"
			})  
		},"json")
	}

	function resetpwd(id,obj){
		$(obj).attr("disabled","disabled")
		$(obj).val("密码重置中,请稍后...")
		$.post("load.asp",{appid:id,act:"setrepwd"},function(data)
		{ 
			if(data.result=="200"){
				$("#myapppasswordbox").text(data.password);
			}else{
				
			}
		$(obj).val("重置密码")
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

