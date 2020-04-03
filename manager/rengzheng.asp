 <%If 	session("u_email")=""  Or session("msn")="" Then%>
	<script language="javascript">
		$(function(){		 
			 $.dialog({
					title:'友情提示',
					content: '友情提示：您的联系资料还不完善请先完善联系资料后再进行其它操作!',
					lock:true,
					min:false,
					max:false,
					icon:'alert.gif',
					minWidth:200,
					button:[{name:unescape("%u786E%u5B9A"),focus:true}],
					close:function(){
						window.location='/manager/usermanager/default2.asp';
					}
			});
		}) 
		</script>
 
 
 <%elseif session("isauthmobile")&""<>"1" and ccur(session("u_resumesum"))>0  And sms_note then%>
	<script language="javascript">
		$(function(){		 
			 $.dialog({
					title:'友情提示',
					content: '友情提示：您的手机还未验证！必须通过验证后才能进行业务管理。请立即验证，谢谢！',
					lock:true,
					min:false,
					max:false,
					icon:'alert.gif',
					minWidth:200,
					button:[{name:unescape("%u786E%u5B9A"),focus:true}],
					close:function(){
						window.location='/manager/usermanager/renzheng.asp';
					}
			});
		}) 
		</script>
 <%end if%>