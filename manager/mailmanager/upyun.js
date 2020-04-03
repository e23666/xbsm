var loadbox = function () {
			return $.dialog({
				title: false,
				content: "<div style=\"width:200px; text-align:center\" class=\"loadding-box\"><img src=\"/images/loadani.gif\" alt=\"加载中,请稍候..\"></div>",
				esc: false,
				lock: true,
				min: false,
				max: false,
				zIndex: 20000
			});
		}
function upyun(obj)
{
	$.dialog.confirm("您确定要将此域名升级到云邮局,此操作不可逆!<br>如升级过程中有错误,请到管理中心先同步一次数据看是否成功",function(){
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