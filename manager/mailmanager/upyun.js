var loadbox = function () {
			return $.dialog({
				title: false,
				content: "<div style=\"width:200px; text-align:center\" class=\"loadding-box\"><img src=\"/images/loadani.gif\" alt=\"������,���Ժ�..\"></div>",
				esc: false,
				lock: true,
				min: false,
				max: false,
				zIndex: 20000
			});
		}
function upyun(obj)
{
	$.dialog.confirm("��ȷ��Ҫ�����������������ʾ�,�˲���������!<br>�������������д���,�뵽����������ͬ��һ�����ݿ��Ƿ�ɹ�",function(){
		   $(obj).attr("disabled","disabled");
		  var load=loadbox()
		$.ajax({
			type: "POST",
			url: "load.asp",
			data: {act:"upyun",m_id:m_id},
			dataType: "JSON",
			timeout:180000,
			success: function (resp) { 
				$.dialog.tips(resp.msg) 
			},
		    complete:function(){
				 load.close()
				 $(obj).removeAttr("disabled");
			}
		});
	})
}