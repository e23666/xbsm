 <%If 	session("u_email")=""  Or session("msn")="" Then%>
	<script language="javascript">
		$(function(){		 
			 $.dialog({
					title:'������ʾ',
					content: '������ʾ��������ϵ���ϻ�����������������ϵ���Ϻ��ٽ�����������!',
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
					title:'������ʾ',
					content: '������ʾ�������ֻ���δ��֤������ͨ����֤����ܽ���ҵ�������������֤��лл��',
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