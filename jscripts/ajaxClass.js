function AjaxLib(onState,onCompletion){    
    /**//**   
    ��Ա����   
    */   
    this.XMLHttpReq = null;         //XML����    
    this.method = "post";           //ִ�еķ���(post/get)    
    this.url = "";              //�첽���õ�ҳ���ַ    
    this.responseText = "";         //�첽���ص���Ӧ�ַ���    
    this.responseXML = "";          //�첽���ص���ӦXML    
    this.failed = false;   
	this.divId	="contentID";
	this.divId1 = "";
	this.timeout=0		//��ʱ���ã�0ΪxmlhttpĬ��
	//������������־    
    /**//**   
    �¼���   
    */ 
	this.onState   = onState;
    this.onCompletion = onCompletion;  //��Ӧ���ݽ������    
    this.onError = function() {};       //�첽�������¼�    
    this.onFail = function() {};        //��������ʧ�ܴ�������    
    this.aborts=function(){};
	
   /**//**   
    ��ʼ������(����ʱ�Զ���ʼ��)   
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
    ����������   
    @param data ���͵�����   
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
		
        //�����Ϣ��Ӧͷ 
		var cur=0
        this.XMLHttpReq.setRequestHeader("Content-Type","application/x-www-form-urlencoded");//�첽�ص�����    
        this.XMLHttpReq.onreadystatechange = function(){ 
			 //����δ����    
			 cur ++;
            if (self.failed) {    
                self.onFail();    
                return;    
            }  
			
			window.setTimeout(function(){
					if (self.timeout>0��&& self.XMLHttpReq.readyState  != 4){
							self.onCompletion("<img src=\"\\images\\new\\jingao.png\" border=0>",self.divId,self.divId1)
						 	self.onState("����ԭ��,��ѯ��ʱ,���Ժ�����",self.divId1);
							
							self.XMLHttpReq.abort(); //��ֹ����
							//self.XMLHttpReq=null;
							window.clearTimeout();
						} 
					 },self.timeout);
			//��Ϣ��Ӧ��־    
           if(self.XMLHttpReq.readyState==4){    
             		if(self.XMLHttpReq.status == 200) 
                	{ 
                    	self.responseText = self.XMLHttpReq.responseText; 
						self.onCompletion(self.responseText,self.divId,self.divId1);
						window.clearTimeout();
						 //self.responseXML = self.XMLHttpReq.responseXML; 
					}else{
						//self.responseText="�������:" + self.XMLHttpReq.status ;
						self.onCompletion("<img src=\"\\images\\new\\jingao.png\" border=0>",self.divId,self.divId1)
						self.onState("����ԭ��,��ѯ��ʱ,���Ժ�����",self.divId1);
						self.XMLHttpReq.abort(); //��ֹ����
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
            this.XMLHttpReq.send(data); //��������    
        }else{    
            this.XMLHttpReq.send();     //��������    
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
Ϊ�˼򵥵���
*/

function ajaxRequest(urlstr,sendstr,methodstr,dividstr,divid1str,doCompletion,imgstr){
//����:��ַ��������method��ʽ,��Ҫ������ʾ���ݵĿ�,��ʾ���ȵĿ�,������ִ�к���,������ͼƬ
//weiyanlover
		document.getElementById(dividstr).innerHTML=imgstr;
		var ajax = new AjaxLib(EventState,doCompletion);
		if(!ajax.failed){
			ajax.url=urlstr;
			ajax.method=methodstr;
			ajax.divId=dividstr;
			ajax.divId1=divid1str;
			ajax.timeout=60000;//��ʱ����,����
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
                strState = "δ��ʼ�����Ե�...";
                break;

                case 1:
                strState = "���ڲ�ѯ���Ե�...";
                break;

                case 2:
                strState = "��ȡ�������Ե�...";
				
                break;

                case 3:
                strState = "���ݼ��������Ե�...";
                break;
                default: 
               	 strState = strValue;
				
                break;
        }
   document.getElementById(dividstr).innerHTML = strState;
}