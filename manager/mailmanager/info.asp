<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
m_id=requesta("m_id")
act=requesta("act")
if not isnumeric(m_id&"") then call url_return("��������","-1")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��ҵ�ʾ�</title>
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
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			    <li><a href="/Manager/mailmanager/">��ҵ�ʾ�</a></li>
			   <li>��ҵ�ʾֹ���</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg"> 
			  <ul class="manager-tab">
				<li class="liactive" tag="info"><a>�ʾֻ�����Ϣ</a></li> 
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


			 $.dialog.confirm("��ȷ��Ҫ�����ʾֽ�������",function(){
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
	
	//��������
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
			$.dialog.tips("���볤�ȱ������6λ!");
			return false
		}
		if (repwd!=pwd)
		{
			$.dialog.tips("�������벻һ��!");
			return false
		}
		
		$.dialog.confirm("�˲������޸�postmaster����,���½���޸�����!<BR><font color=red>Ϊ���ʾְ�ȫ�ʾֹ������벻�ڱ���,���μ�</font>",function(){
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
			content: "<div style=\"width:100px; text-align:center\" class=\"loadding-box\"><img src=\"/images/mallload.gif\" alt=\"������,���Ժ�..\"></div>",
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
				 $.dialog.confirm("��ȷ��Ҫ����<font color=red>"+alreadypay+"</font>����",function(){
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
				<th colspan=3>��ҵ���ʾ���ϸ��Ϣ</th>
			 </tr> 
					<tr>
						<th align=right width=230>����������</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">ʹ�ð���</a></td>
				 
					</tr>
					<tr>
						<th align=right >����ʱ�䣺</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >����/״̬��</th>
						<td align=left>{{if m_free}}������{{else}}רҵ��{{/if}}</td>
				 
					</tr>
					 
 
					<tr>
						<th align=right >�ʺ�������</th>
						<td align=left>
						{{postnum}}�� 

						</td>
					</tr>
					 
					<tr>
						<th align=right >�������룺</th>
						<td align=left  ><input type="password" name="pwd" class="manager-input s-input"></td>
					</tr>
					<tr>
						<th align=right >�ظ�һ�����룺</th>
						<td align=left ><input type="password" name="repwd" class="manager-input s-input"></td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="��������" id="repwdsure" class="manager-btn s-btn">
							<input type="button" value="ͬ���ʾ�" onclick="syn(this)" class="manager-btn s-btn">
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
				<th colspan=3>��ҵ���ʾ���ϸ��Ϣ</th>
			 </tr> 
					<tr>
						<th align=right width=230>����������</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">ʹ�ð���</a></td>
				 
					</tr>
					<tr>
						<th align=right >����ʱ�䣺</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >����/״̬��</th>
						<td align=left>{{if m_free=="True"}}������{{else}}רҵ��{{/if}}</td>
				 
					</tr>
					 
 
					<tr>
						<th align=right >�ʺ�������</th>
						<td align=left>
						{{postnum}}��
						</td>
					</tr>
					<tr>
						<th align=right >����ʱ����</th>
						<td align=left>
						   <select name="alreadypay" id="alreadypay">
						   		<option value="3" select>3����</option>
								<option value="6">6����</option>
								<option value="12">1��</option>
								<option value="24">2��</option>
								<option value="36">3��</option>
								<option value="60">5��</option>
						   </select>
						</td>
					</tr>
					<tr>
						<th align=right >���ü��㣺</th>
						<td align=left id="msg"></td>
					</tr>
					<tr>
						<th align=right >���ã�</th>
						<td align=left id="price" class="price">0</td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="��������" id="renewsure" class="manager-btn s-btn">
							<input type="button" value="ͬ���ʾ�" onclick="syn(this)" class="manager-btn s-btn">
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
				<th colspan=3>��ҵ���ʾ���ϸ��Ϣ</th>
			 </tr> 
					<tr>
						<th align=right width=230>����������</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">ʹ�ð���</a></td>
				 
					</tr>
					<tr>
						<th align=right >����ʱ�䣺</th>
						<td align=left>{{m_expiredate}}</td>
				 
					</tr>
					<tr>
						<th align=right >����/״̬��</th>
						<td align=left>{{if m_free=="True"}}������{{else}}רҵ��{{/if}}</td>
				 
					</tr>
					<tr>
						<th align=right >���ͣ�</th>
						<td align=left>
							<input type="radio" name="m_free" value="1" {{if m_free=="True"}}checked{{/if}} id="m_free1"><label for="m_free1">������</label>&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="m_free" value="0" {{if m_free=="False"}}checked{{/if}} id="m_free0"><label for="m_free0">רҵ��</label>						
						</td>
					</tr>
 
					<tr>
						<th align=right >�ʺ�������</th>
						<td align=left>
						<input type="text" name="postnum"  value="{{postnum}}" class="manager-input s-input" datatype="n" errormsg="��¼����ȷ�ʺ�����!" nullmsg="�ʺ�����Ϊ��!" >
						</td>
					 
					</tr>
					<tr>
						<th align=right >���ü��㣺</th>
						<td align=left id="msg"></td>
					</tr>
					<tr>
						<th align=right >���ã�</th>
						<td align=left id="price" class="price">0</td>
					</tr>
					<tr>
						<th colspan=3>
							<input type="button" value="��������" id="upsure" class="manager-btn s-btn">
							<input type="button" value="ͬ���ʾ�" onclick="syn(this)" class="manager-btn s-btn">
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
				<th colspan=3>��ҵ���ʾ���ϸ��Ϣ</th>
			 </tr> 
					<tr>
						<th align=right width=230>����������</th>
						<td align=left>{{m_bindname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.yunyou.top/help/detail?id=4" target="_blank" class="blue-link">ʹ�ð���</a></td>
				 
					</tr>
					<tr>
						<th align=right >�������ͣ�</th>
						<td align=left>{{m_productid}}</td>
				 
					</tr>
					<tr>
						<th align=right >��Ʒ�ͺţ�</th>
						<td align=left>{{m_productid}}</td>
				 
					</tr>
					<tr>
						<th align=right >�ʾ��û�����</th>
						<td align=left>{{postnum}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:upload()" class="blue-link">�����û�</a>  </td>
				 
					</tr>
					<tr>
						<th  align=right >�ʺ�˵����</th>
						<td align=left> ���ɾ���û����½�ʾֹ����ַ -������ʾֹ���������ɾ������ </td>
					</tr>
 
					<tr>
						<th align=right >����Ա�˺ţ�</th>
						<td align=left>postmaster@{{m_bindname}}</td>
					 
					</tr>
					<tr>
						<th  align=right >�ʾֹ����ַ��</th>
						<td align=left><a href="https://www.yunyou.top/?domain={{m_bindname}}" target="_blank">https://www.yunyou.top</a></td>
					 
					</tr>

					<tr>
						<th  align=right >��ͨʱ�䣺</th>
						<td align=left>{{m_buydate}}</td>
				 
					</tr>
					<tr>
						<th  align=right >����ʱ�䣺</th>
						<td align=left>{{m_expiredate}}  </td>
					</tr> 
					<tr>
						<th colspan=3>
							<input type="button" value="�����ʾ�"  onclick="renew()" class="manager-btn s-btn">

							<input type="button" value="�����ʾ�"  onclick="upload()" class="manager-btn s-btn">

							<input type="button" value="ͬ���ʾ�"  onclick="syn(this)" class="manager-btn s-btn">
							<input type="button" value="�޸�����"  onclick="repwd()" class="manager-btn s-btn">
						</th>
					</tr>
				{{/if}}
		 </tbody>
	</table>

</script>
 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
