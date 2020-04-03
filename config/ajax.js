var http_request = false;
if(typeof(jQuery)=="undefined") document.write("<sc" + "ript lang" + "uage=\"javas" + "cript\" src=\"/jscripts/jq.js\"></scr" + "ipt>");

function makeRequest(url,divID) {
		 $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			
			if(data!=""){
         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime()+"&t="+data;
        
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		var outtimes=setTimeout("document.getElementById('"+divID+"').innerHTML='<b><font color=red>对不起,查询超时,请重试</font><b>'",60000);
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															clearTimeout(outtimes);
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
																
															} else {
														document.getElementById(divID).innerHTML='页面正在加载中....';
															}
														}
												
													}


        http_request.open('GET', url, true);
        http_request.send(null);
		}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})

    }
	function makeRequestPost(url,sinfo,divID) {
         document.getElementById(divID).innerHTML='<img src="/Template/Tpl_01/images/load.gif" border="0" id="loadimg" /><br>正在执行,请稍候....';
		    $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			if(data!=""){
         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime();
       sinfo=sinfo+"&t="+data;
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
																
															} else {
														document.getElementById(divID).innerHTML='错误,请重试.'+http_request.responseText;
															}
														}
														
												
													}


        http_request.open('POST', url, true);
		http_request.setRequestHeader("Content-Length",sinfo.length); 
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var poststr=sinfo;

        http_request.send(poststr);
		}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})

    }
	function makeRequestPost1(url,sinfo,divID) {
         document.getElementById(divID).innerHTML='<img src="/Template/Tpl_01/images/new/load1.gif" border="0" id="loadimg" />';
		   $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			if(data!=""){
         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime();
       sinfo=sinfo+"&t="+data;
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
																
															} else {
														document.getElementById(divID).innerHTML='错误,请重试:'+http_request.responseText;
															}
														}
														
												
													}


        http_request.open('POST', url, true);
		http_request.setRequestHeader("Content-Length",sinfo.length); 
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var poststr=sinfo;

        http_request.send(poststr);
		}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})
    }
	function makeRequestPost2(url,sinfo,divID) {
         document.getElementById(divID).innerHTML='<img src="/Template/Tpl_01/images/new/load1.gif" border="0" id="loadimg" />';
		   $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			if(data!=""){
         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime();
         sinfo=sinfo+"&t="+data;
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
														functionxml(divID,http_request.responseText);
																
															} else {
														document.getElementById(divID).innerHTML='错误,请重试!'+http_request.responseText;
															}
														}
														
												
													};

        http_request.open('POST', url, true);
		http_request.setRequestHeader("Content-Length",sinfo.length); 
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var poststr=sinfo;

        http_request.send(poststr);
		}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})

    }
		function makeRequestPost3(url,sinfo,divID) {
         document.getElementById(divID).innerHTML='<div style="margin-top:60px; margin-left:150px;"><img src="/Template/Tpl_01/images/load.gif" border="0" id="loadimg" /><br>正在执行,请稍候....</div>';
		 







        $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			if(data!=""){


         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime();
         sinfo=sinfo+"&t="+data
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
														functionxml(divID,http_request.responseText);
																
															} else {
														document.getElementById(divID).innerHTML='错误,请重试!!'+http_request.responseText;
															}
														}
														
												
													};

        http_request.open('POST', url, true);
		http_request.setRequestHeader("Content-Length",sinfo.length); 
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var poststr=sinfo;

        http_request.send(poststr);
	}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})
    }
	
	
		function makeRequestPost4(url,sinfo,divID) {
         document.getElementById(divID).innerHTML='<div style="margin-top:60px; margin-left:150px;"><img src="/Template/Tpl_01/images/load.gif" border="0" id="loadimg" /><br>正在执行,请稍候....</div>';
		 

        $.get("/gettoken.asp?m="+Math.random(),"",function(data){
			if(data!=""){
		 
         http_request = false;
		 var nextTime = new Date(); 
         url=url+"&dn="+nextTime.getTime();
         sinfo=sinfo+"&t="+data;
       //alert(url)
        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
            try {
                http_request = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    http_request = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e) {}
            }
        }

        if (!http_request) {
            alert('对不起,您的浏览器不支持');
            return false;
        }
		
        http_request.onreadystatechange = function(){

														if (http_request.readyState == 4) {
															
															if (http_request.status == 200) {
														document.getElementById(divID).innerHTML=http_request.responseText;
														functionxml(divID,http_request.responseText);
														showelite();		
															} else {
														document.getElementById(divID).innerHTML='错误,请重试!!'+http_request.responseText;
															}
														}
														
												
													};

        http_request.open('POST', url, true);
		http_request.setRequestHeader("Content-Length",sinfo.length); 
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var poststr=sinfo;

        http_request.send(poststr);

			}else{
			document.getElementById(divID).innerHTML='服务器忙请稍后!!'
			}
		})
    }