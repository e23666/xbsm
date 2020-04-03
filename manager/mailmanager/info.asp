<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
m_id=requesta("m_id")
act=requesta("act")
if not isnumeric(m_id&"") then call url_return("参数错误","-1")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-企业邮局</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>  
   <script language="javascript" src="/jscripts/template.js"></script>
<style>

</style>
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
			    <li><a href="/Manager/mailmanager/">企业邮局</a></li>
			   <li>企业邮局管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg"> 
			  <ul class="manager-tab">
				<li class="liactive" tag="info"><a>邮局基本信息</a></li> 
			  </ul>
			  <div id="contenthtml"></div>  
		  </div>
	 </div> 
  </div>
  <script>
	var m_id=<%=m_id%>;
	var act="<%=act%>";
	var cfg={};
	$(function(){
		loadinfo();
	})

	
	function showinfo(){
	 	$("#contenthtml").html(template("tpl_info",cfg))
	}

	function upload(){
	 	$("#contenthtml").html(template("tpl_upload",cfg));
		$("input[name='m_free']").on("change",function(){
			 getprice();
		})
		$("input[name='postnum']").on("blur",function(){
			 getprice();
		});
		 getprice();

		 $("#upsure").on("click",function(){ 
			var obj_=$(this)
			
			 var m_free=$("input[name='m_free']:checked").val();
			 var postnum=$("input[name='postnum']").val();


			 $.dialog.confirm("您确定要将此邮局进行升级",function(){
				 obj_.attr("disabled","disabled");
				 var loading=loadbox()
				 $.ajax({
					 type: "POST",
					 url: "load.asp",
					 data: {act:"upsure",m_id:m_id,m_free:m_free,postnum:postnum},
					 dataType: "JSON",
					 success: function (resp) { 
						  if(resp.result=="200"){
							 $.dialog.tips(resp.msg);
							 window.setTimeout(function(){
								 location.href="./"
							 }, 200);
							
						  }else{
							  $.dialog.tips(resp.msg)	
						  }
					 },
					 complete:function(){
						obj_.removeAttr("disabled");
 					    loading.close();
					 } 
				 });

			 })

		 })
	}
	 

	function getprice()
	{
		var m_free=$("input[name='m_free']:checked").val();
		var postnum=$("input[name='postnum']").val();
		var loading=loadbox()
		$.ajax({
			type: "post",
			url: "load.asp",
			data: {act:"upprice",m_free:m_free,postnum:postnum,m_id:m_id},
			dataType: "json",
			success: function (resp) {
				if(resp.result=="200"){
					$("#msg").html(resp.datas.pricemsg)
					$("#price").html("&yen; "+resp.datas.price)
				}else{
					$.dialog.tips(resp.msg)	
				}
			},
			 complete:function(){
						 loading.close()
					}
		});
	}
	
	//重置密码
	function repwd(){
		$("#contenthtml").html(template("tpl_repwd",cfg));
		$("#repwdsure").on("click",function(){
			var obj=$(this);
			//obj.attr("disabled","disabled");
			 repwdsave(obj)
			
			})	
	 }

	 function repwdsave(obj){
		 var pwd=$("input[name='pwd']").val()
		 var repwd=$("input[name='repwd']").val()
		 if(pwd.length<6){
			$.dialog.tips("密码长度必须大于6位!");
			return false
		}
		if (repwd!=pwd)
		{
			$.dialog.tips("两次密码不一致!");
			return false
		}
		
		$.dialog.confirm("此操作会修改postmaster密码,请登陆后修改密码!<BR><font color=red>为了邮局安全邮局管理密码不在保存,请牢记</font>",function(){
			obj.attr("disabled","disabled");
			var loading=loadbox()
			$.ajax({
					 type: "POST",
					 url: "load.asp",
					 data: {act:"repwdsave",m_id:m_id,pwd:pwd,repwd:repwd},
					 dataType: "JSON",
					 success: function (resp) {
						 obj.removeAttr("disabled");
						 if(resp.result=="200"){
							$.dialog.tips(resp.msg);
							window.setTimeout(function(){
								location.href="./info.asp?m_id="+m_id;
							}, 200);
							
						}else{
							$.dialog.tips(resp.msg)	
						}
					 },
					 complete:function(){
								 loading.close()
							}
				 });
		
		})
	 
	 }

   function loadbox() {
		return $.dialog({
			title: false,
			content: "<div style=\"width:100px; text-align:center\" class=\"loadding-box\"><img src=\"/images/mallload.gif\" alt=\"加载中,请稍候..\"></div>",
			esc: false,
			lock: true,
			min: false,
			max: false,
			zIndex: 20000
		});
	}

	function renew(){
		$("#contenthtml").html(template("tpl_renew",cfg));
		$("select[name='alreadypay']").on("change",function(){
				getrenewprice();
		})
		$("#renewsure").on("click",function(){
				 var obj_=$(this)
				 var alreadypay=$("select[name='alreadypay']").val();
				 $.dialog.confirm("您确定要续费<font color=red>"+alreadypay+"</font>个月",function(){
				  var loading=loadbox()
					 	$.ajax({
							 type: "POST",
							 url: "load.asp",
							 data: {act:"renewsure",m_id:m_id,alreadypay:alreadypay},
							 dataType: "JSON",
							 success: function (resp) {
								 if(resp.result=="200"){
									$.dialog.tips(resp.msg);
									window.setTimeout(function(){
										location.href="./info.asp?m_id="+m_id;
									}, 200);
									
								}else{
									$.dialog.tips(resp.msg)	
								}
							 },
							complete:function(){
								 loading.close()
							}
						 });

				 })
		})
		getrenewprice();
	}
 



	function getrenewprice(){
		var alreadypay=$("select[name='alreadypay']").val()
		$.ajax({
			type: "POST",
			url: "load.asp",
			data: {act:"getrenewprice",m_id:m_id,alreadypay:alreadypay},
			dataType: "JSON",
			success: function (resp) {
				if(resp.result=="200"){
					$("#msg").html(resp.datas.pricemsg)
					$("#price").html("&yen; "+resp.datas.price)
				}else{
						$.dialog.tips(resp.msg)	 
					} 
			}
		});

	}
	function loadinfo(){
		$.ajax({
			type: "post",
			url: "load.asp",
			data: {act:"info",m_id:m_id},
			dataType: "json",
			success: function (response) {
				if(response.result=="200"){
						cfg=response.datas;
						chgaction();
				}else{
						$.dialog.tips(response.msg)	 
					} 
			
			}
		});
	}

	function chgaction(){
			switch (act) {
			case "up":
				upload();				
				break;
			case "renew":
				renew();				
				break;
			case "repwd":
				repwd();
				break
			default:
				showinfo();
				break;
		}

	}
	function syn(obj){
		  var loading=loadbox()
	     $(obj).attr("disabled","disabled");
		$.ajax({
			type: "POST",
			url: "load.asp",
			data: {act:"syn",m_id:m_id},
			dataType: "JSON",
			success: function (resp) {
				$.dialog.tips(resp.msg)
				window.setTimeout(function(){
								 location.reload();
							 }, 1000);	
			},
		    complete:function(){
				 $(obj).removeAttr("disabled");
				 loading.close()
			}
		});

	}


  </script>

<script id="tpl_repwd" type="text/html">
	<table class="manager-table">
         <tbody>
		{{if m_productid=="yunmail"}}	
		 	<tr>
				<th colspan=3>企业云邮局详细信息</th>
			 </tr> 
					<tr>
						<th align=right width=230>邮箱域名：</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">使用帮助</a></td>
				 
					</tr>
					<tr>
						<th align=right >到期时间：</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >类型/状态：</th>
						<td align=left>{{if m_free}}基础版{{else}}专业版{{/if}}</td>
				 
					</tr>
					 
 
					<tr>
						<th align=right >帐号数量：</th>
						<td align=left>
						{{postnum}}个 

						</td>
					</tr>
					 
					<tr>
						<th align=right >设置密码：</th>
						<td align=left  ><input type="password" name="pwd" class="manager-input s-input"></td>
					</tr>
					<tr>
						<th align=right >重复一次密码：</th>
						<td align=left ><input type="password" name="repwd" class="manager-input s-input"></td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="重置密码" id="repwdsure" class="manager-btn s-btn">
							<input type="button" value="同步邮局" onclick="syn(this)" class="manager-btn s-btn">
						</th>
					</tr>
				{{/if}}
		 </tbody>
	</table>
</script>

<script id="tpl_renew"  type="text/html">
		<table class="manager-table">
         <tbody>
		{{if m_productid=="yunmail"}}	
		 	<tr>
				<th colspan=3>企业云邮局详细信息</th>
			 </tr> 
					<tr>
						<th align=right width=230>邮箱域名：</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">使用帮助</a></td>
				 
					</tr>
					<tr>
						<th align=right >到期时间：</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >类型/状态：</th>
						<td align=left>{{if m_free=="True"}}基础版{{else}}专业版{{/if}}</td>
				 
					</tr>
					 
 
					<tr>
						<th align=right >帐号数量：</th>
						<td align=left>
						{{postnum}}个
						</td>
					</tr>
					<tr>
						<th align=right >续费时长：</th>
						<td align=left>
						   <select name="alreadypay" id="alreadypay">
						   		<option value="3" select>3个月</option>
								<option value="6">6个月</option>
								<option value="12">1年</option>
								<option value="24">2年</option>
								<option value="36">3年</option>
								<option value="60">5年</option>
						   </select>
						</td>
					</tr>
					<tr>
						<th align=right >费用计算：</th>
						<td align=left id="msg"></td>
					</tr>
					<tr>
						<th align=right >费用：</th>
						<td align=left id="price" class="price">0</td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="立即续费" id="renewsure" class="manager-btn s-btn">
							<input type="button" value="同步邮局" onclick="syn(this)" class="manager-btn s-btn">
						</th>
					</tr>
				{{/if}}
		 </tbody>
	</table>
</script>

<script id="tpl_upload" type="text/html">
		<table class="manager-table">
         <tbody>
		{{if m_productid=="yunmail"}}	
		 	<tr>
				<th colspan=3>企业云邮局详细信息</th>
			 </tr> 
					<tr>
						<th align=right width=230>邮箱域名：</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">使用帮助</a></td>
				 
					</tr>
					<tr>
						<th align=right >到期时间：</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >类型/状态：</th>
						<td align=left>{{if m_free=="True"}}基础版{{else}}专业版{{/if}}</td>
				 
					</tr>
					<tr>
						<th align=right >类型：</th>
						<td align=left>
							<input type="radio" name="m_free" value="1" {{if m_free=="True"}}checked{{/if}} id="m_free1"><label for="m_free1">基础版</label>&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="m_free" value="0" {{if m_free=="False"}}checked{{/if}} id="m_free0"><label for="m_free0">专业版</label>						
						</td>
					</tr>
 
					<tr>
						<th align=right >帐号数量：</th>
						<td align=left>
						<input type="text" name="postnum"  value="{{postnum}}" class="manager-input s-input" datatype="n" errormsg="请录入正确帐号数量!" nullmsg="帐号数量为空!" >
						</td>
					 
					</tr>
					<tr>
						<th align=right >费用计算：</th>
						<td align=left id="msg"></td>
					</tr>
					<tr>
						<th align=right >费用：</th>
						<td align=left id="price" class="price">0</td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="立即升级" id="upsure" class="manager-btn s-btn">
							<input type="button" value="同步邮局" onclick="syn(this)" class="manager-btn s-btn">
						</th>
					</tr>
				{{/if}}
		 </tbody>
	</table>

</script>

<script id="tpl_info" type="text/html">
	<table class="manager-table">
         <tbody>
		{{if m_productid=="yunmail"}}	
		 	<tr>
				<th colspan=3>企业云邮局详细信息</th>
			 </tr> 
					<tr>
						<th align=right width=230>邮箱域名：</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">使用帮助</a></td>
				 
					</tr>
					<tr>
						<th align=right >邮箱类型：</th>
						<td align=left>{{m_productid}}</td>
				 
					</tr>
					<tr>
						<th align=right >产品型号：</th>
						<td align=left>{{m_productid}}</td>
				 
					</tr>
					<tr>
						<th align=right >邮局用户数：</th>
						<td align=left>{{postnum}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:upload()" class="blue-link">增加用户</a>  </td>
				 
					</tr>
					<tr>
						<th  align=right >帐号说明：</th>
						<td align=left> 添加删除用户请登陆邮局管理地址 -》点击邮局管理进行添加删除操作 </td>
					</tr>
 
					<tr>
						<th align=right >管理员账号：</th>
						<td align=left>postmaster@{{m_bindname}}</td>
					 
					</tr>
					<tr>
						<th  align=right >邮局管理地址：</th>
						<td align=left><a href="https://www.yunyou.top/?domain={{m_bindname}}" target="_blank">https://www.yunyou.top</a></td>
					 
					</tr>

					<tr>
						<th  align=right >开通时间：</th>
						<td align=left>{{m_buydate}}</td>
				 
					</tr>
					<tr>
						<th  align=right >到期时间：</th>
						<td align=left>{{m_expiredate}}  </td>
					</tr> 
					<tr>
						<th colspan=3>
							<input type="button" value="续费邮局"  onclick="renew()" class="manager-btn s-btn">

							<input type="button" value="升级邮局"  onclick="upload()" class="manager-btn s-btn">

							<input type="button" value="同步邮局"  onclick="syn(this)" class="manager-btn s-btn">
							<input type="button" value="修改密码"  onclick="repwd()" class="manager-btn s-btn">
						</th>
					</tr>
				{{/if}}
		 </tbody>
	</table>

</script>
 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
