if(typeof(jQuery)=="undefined"){document.write("<sc" + "ript lang" + "uage=\"javas" + "cript\" src=\"/jscripts/jq.js\"></scr" + "ipt>")};

function setmybak(id_,pname,pt)
{
	var ret = prompt("请输入"+pname+"备注信息(50个汉字以内)。","")
	 if (ret!=null)
	 {
		postdate="id="+id_+"&pname="+escape(pname)+"&ptype="+escape(pt)+"&txt="+escape(ret)
		$.get("/noedit/setmybak.asp",postdate,function(data){
			alert(data);
			location.reload()
		})	
	 }
		
	 
}
