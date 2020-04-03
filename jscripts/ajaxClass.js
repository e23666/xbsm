function AjaxLib(onState,onCompletion){    
    /**//**   
    成员变量   
    */   
    this.XMLHttpReq = null;         //XML对象    
    this.method = "post";           //执行的方法(post/get)    
    this.url = "";              //异步调用的页面地址    
    this.responseText = "";         //异步返回的响应字符串    
    this.responseXML = "";          //异步返回的响应XML    
    this.failed = false;   
	this.divId	="contentID";
	this.divId1 = "";
	this.timeout=0		//超时设置，0为xmlhttp默认
	//创建对象错误标志    
    /**//**   
    事件区   
    */ 
	this.onState   = onState;
    this.onCompletion = onCompletion;  //响应内容解析完成    
    this.onError = function() {};       //异步错误处理事件    
    this.onFail = function() {};        //创建对象失败处理世界    
    this.aborts=function(){};
	
   /**//**   
    初始化函数(构造时自动初始化)   
    */   
    this.init = function(){    
        if(window.XMLHttpRequest){    
            this.XMLHttpReq = new XMLHttpRequest();    
        }else if (window.ActiveXObject){    
            try{this.XMLHttpReq = new ActiveXObject("Msxml4.XMLHTTP");}    
            catch(e){    
                try{this.XMLHttpReq = new ActiveXObject("Msxml3.XMLHTTP");}    
                catch(e){    
                    try{this.XMLHttpReq = new ActiveXObject("Msxml2.XMLHTTP");}    
                    catch(e){    
                        try{this.XMLHttpReq = new ActiveXObject("Microsoft.XMLHTTP");}    
                        catch(oc){this.failed=true;}    
                    }    
                }    
            }    
        }    
    };    
   
    /**//**   
    发送请求函数   
    @param data 发送的数据   
    @example send("id=1");   
    */   
    this.send=function(data){    
        var self=this;    
		self.url=(self.url.indexOf("?")<0)?self.url+"?tempt=" + new Date().getTime():self.url + "&tempt=" + new Date().getTime();
		if(this.method=="post") {    
            this.XMLHttpReq.open(self.method,self.url,true);    
        }else{    
            this.XMLHttpReq.open(self.method,self.url + "&" + encodeURI(data),true);    
        }    
		
        //添加消息响应头 
		var cur=0
        this.XMLHttpReq.setRequestHeader("Content-Type","application/x-www-form-urlencoded");//异步回调函数    
        this.XMLHttpReq.onreadystatechange = function(){ 
			 //对象未创建    
			 cur ++;
            if (self.failed) {    
                self.onFail();    
                return;    
            }  
			
			window.setTimeout(function(){
					if (self.timeout>0　&& self.XMLHttpReq.readyState  != 4){
							self.onCompletion("<img src=\"\\images\\new\\jingao.png\" border=0>",self.divId,self.divId1)
						 	self.onState("网络原因,查询超时,请稍候再试",self.divId1);
							
							self.XMLHttpReq.abort(); //终止请求
							//self.XMLHttpReq=null;
							window.clearTimeout();
						} 
					 },self.timeout);
			//消息响应标志    
           if(self.XMLHttpReq.readyState==4){    
             		if(self.XMLHttpReq.status == 200) 
                	{ 
                    	self.responseText = self.XMLHttpReq.responseText; 
						self.onCompletion(self.responseText,self.divId,self.divId1);
						window.clearTimeout();
						 //self.responseXML = self.XMLHttpReq.responseXML; 
					}else{
						//self.responseText="出错错误:" + self.XMLHttpReq.status ;
						self.onCompletion("<img src=\"\\images\\new\\jingao.png\" border=0>",self.divId,self.divId1)
						self.onState("网络原因,查询超时,请稍候再试",self.divId1);
						self.XMLHttpReq.abort(); //终止请求
						window.clearTimeout();
					}
					//window.clearTimeout();
                    
			}else{
					if(self.divId1!=""){
						self.onState(self.XMLHttpReq.readyState,self.divId1);
					}
					
            }    
        };    
            
            
        if(this.method=="post"){    
            this.XMLHttpReq.send(data); //发送请求    
        }else{    
            this.XMLHttpReq.send();     //发送请求    
        }    
    };    
        
    this.abort=function(){
        this.XMLHttpReq.abort();    
    }  
	this.Close=function(){
		this.XMLHttpReq=null;	
	}
    this.init();    
}

/*
为了简单调用
*/

function ajaxRequest(urlstr,sendstr,methodstr,dividstr,divid1str,doCompletion,imgstr){
//参数:网址，参数，method方式,需要操作显示内容的块,显示进度的块,结束后执行函数,进度条图片
//weiyanlover
		document.getElementById(dividstr).innerHTML=imgstr;
		var ajax = new AjaxLib(EventState,doCompletion);
		if(!ajax.failed){
			ajax.url=urlstr;
			ajax.method=methodstr;
			ajax.divId=dividstr;
			ajax.divId1=divid1str;
			ajax.timeout=60000;//超时设置,毫秒
			ajax.send(sendstr);
			if(ajax.responseText!=""){
				ajax.abort();
				ajax.Close();	
			}
			
		}
		
		var ajax=null;
}

function EventState(strValue,dividstr)
{
	    var strState = null;
        switch (strValue)
        {
                case 0:
                strState = "未初始化请稍等...";
                break;

                case 1:
                strState = "正在查询请稍等...";
                break;

                case 2:
                strState = "读取数据请稍等...";
				
                break;

                case 3:
                strState = "数据计算中请稍等...";
                break;
                default: 
               	 strState = strValue;
				
                break;
        }
   document.getElementById(dividstr).innerHTML = strState;
}