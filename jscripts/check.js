// JavaScript Document. 2011-5-30 sun
document.write("<sc"+"ript lang"+"uage=\"java"+"script\" src=\"/jscripts/jq\.js\"></scr"+"ipt>");

String.prototype.Trim = function() 
{ 
return this.replace(/(^\s*)|(\s*$)/g, ""); 
} 

String.prototype.LTrim = function() 
{ 
return this.replace(/(^\s*)/g, ""); 
} 

String.prototype.RTrim = function() 
{ 
return this.replace(/(\s*$)/g, ""); 
}
function cTrim(sInputString,iType)
{
var sTmpStr = ' '
var i = -1

if(iType == 0 || iType == 1)
{
while(sTmpStr == ' ')
{
++i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(i)
}

if(iType == 0 || iType == 2)
{
sTmpStr = ' '
i = sInputString.length
while(sTmpStr == ' ')
{
--i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(0,i+1)
}
return sInputString
}
function isIp(data){
	dotc=0;
	segment=new Array();
	while ((pos=data.indexOf("."))!=-1){
			segment[dotc++]=data.substring(0,pos);	
			data=data.substring(pos+1);
		}
	segment[dotc]=data;
	if (dotc!=3) return false;
	for (i=0;i<segment.length;i++)
		if (!isNum(segment[i])) return false;
	for (i=0;i<segment.length;i++)
		if (parseInt(segment[i])<0||parseInt(segment[i])>255) return false;
	return true;
}
function isMobile(Mno){
	var regMobile=/^0?1(3|5|8)\d{9}$/;
	return regMobile.test(Mno);

}

function getStringLength(str)
    {
        var num=0;
        if (str!="")
        {
            var i;
            var s;
            for(i=0;i<str.length;i++)
            {
                s=str.charCodeAt(i);
                if(s-128<0) num=num+1;
                else num=num+2;
            }
        }
        return num;
        //alert(num);
}
function isEmail(strEmail) {
if (strEmail.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1)
	return true;
else
	return false;
}
function isChinese(obj)
{   
        //i表示忽略大小写
        re = new RegExp("[^0-9a-z_\u4e00-\u9fa5]","i");
		//如果匹配，返回空；如果不匹配，返回不匹配的那个字符
        r  = obj.value.match(re) ;
        if(r!=null)
        {
           // alert("字符"+r+"非法！");
    		//obj.focus();
    		return false;
        }
		else
		{
		     return  true;
		}
}
function isEN(text){
	for (i=0;i<text.length;i++)
		if (text.charCodeAt(i)>255) {
		//alert("抱歉!提交失败,"+text+"不能含有汉字!");
		//data.focus();
		//data.select();
		return false;
		}
	return true;
}
function isNum(number){
var i,str1="0123456789";
	if (number==null||number=="")  return false;
	for(i=0;i<number.length;i++){
	if(str1.indexOf(number.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function isNull(text){
	if (text==""){
		//alert("抱歉!提交失败，"+text+"不能为空!");
		//data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function hasGB(text){
	for (i=0;i<text.length;i++)
		if (text.charCodeAt(i)>255) return true;
	//alert("抱歉!提交失败,"+text+"必须含有汉字!");
	//data.focus();
	//data.select();
	return false;
}
function validChar(text){
	charList="&^%$#@!*()~`+";
	for (i=0;i<charList.length;i++)
		if (text.indexOf(charList.charAt(i))!=-1) {
				//alert("错误，" +text+"不能含有特殊符号["+charList.charAt(i)+"]!");
				//data.focus();
				//data.select();
				return false;
			}
	return true;
}
function isNumberString(inString, refString) {
	if (inString.length == 0)
		return false;
	for (Count=0; Count<inString.length; Count++) {
		tempChar = inString.substring(Count, Count + 1);
		if (refString.indexOf(tempChar, 0) == -1)
			return false;
	}
	return true;
}

function isIdCardNo(idValue) {
        var len=0, re;
        len=idValue.length;
        if (len == 15 && isNumberString(idValue,"1234567890"))
        re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
        else if (len == 18 && isNumberString(idValue,"1234567890xX"))
        re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
        else {
       // alert("输入的公民身份号码不合法，请重新输入!");
        return false;
        }
        var a = idValue.match(re);
        if (a != null){
                if (len==15){
                    var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
          }else{
                    var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
            var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
          }
          if (!B) {
						//alert("输入的公民身份号码 "+ a[0] +" 的日期不合法，请重新输入!");
						//alert("输入的公民身份号码不合法，请重新输入!");
						return false;
					}
        }
        if(len == 18 && !verifyGmsfhLast(idValue)){
						if (idValue.substr(17,1)=='x'){
						//alert("公民身份号码的最后一位校验码不正确('x'应为大写),请检查!");
						}else
						{
						//alert("输入的公民身份号码不合法，请重新输入!");
						}
            return false;
        }
        return true;
}
function verifyGmsfhLast(sVal){
        if(sVal.length != 18) return false;
        var wi = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1);

        var vi = new Array(1,0,'X',9,8,7,6,5,4,3,2)
        var ai = new Array(17);
        var sum = 0;
        var remaining = 0;
        var verifyNum = "";
        //通过循环把18位身份证的前17位存到数组ai中
        for(var i = 0; i < 17; i++){
            ai[i] = parseInt(sVal.substring(i,i+1));
        }
        for(var m = 0; m < ai.length; m++){
            //加权
            sum = sum + wi[m] * ai[m];
        }
        remaining = sum % 11;
        if(remaining == 2){
            verifyNum = "X";
        }else{
            verifyNum = vi[remaining];
        }
        if(verifyNum != sVal.substring(17,18)){
            return false;
        }else{
            return true;
        }
    }
function DBC2SBC(str){
    var result = '';
    for (i=0 ; i<str.length; i++){
        code = str.charCodeAt(i);//获取当前字符的unicode编码
        if (code >= 65281 && code <= 65373)//在这个unicode编码范围中的是所有的英文字母已经各种字符
        {
            result += String.fromCharCode(str.charCodeAt(i) - 65248);//把全角字符的unicode编码转换为对应半角字符的unicode码
        }else if (code == 12288)//空格
        {
            result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
        }else
        {
            result += str.charAt(i);
        }
    }
    return result;
}
function PasswordStrength(showed){	
	this.showed = (typeof(showed) == "boolean")?showed:true;
	this.styles = new Array();	
	this.styles[0] = {backgroundColor:"#EBEBEB",borderLeft:"solid 1px #FFFFFF",borderRight:"solid 1px #BEBEBE",borderBottom:"solid 1px #BEBEBE"};	
	this.styles[1] = {backgroundColor:"#FF4545",borderLeft:"solid 1px #FFFFFF",borderRight:"solid 1px #BB2B2B",borderBottom:"solid 1px #BB2B2B"};
	this.styles[2] = {backgroundColor:"#FFD35E",borderLeft:"solid 1px #FFFFFF",borderRight:"solid 1px #E9AE10",borderBottom:"solid 1px #E9AE10"};
	this.styles[3] = {backgroundColor:"#95EB81",borderLeft:"solid 1px #FFFFFF",borderRight:"solid 1px #3BBC1B",borderBottom:"solid 1px #3BBC1B"};
	
	this.labels= ["弱","中","强"];

	this.divName = "pwd_div_"+Math.ceil(Math.random()*100000);
	this.minLen = 6;
	
	this.width = "150px";
	this.height = "16px";
	
	this.content = "";
	
	this.selectedIndex = 0;
	
	this.init();	
}
PasswordStrength.prototype.init = function(){
	var s = '<table cellpadding="0" id="'+this.divName+'_table" cellspacing="0" style="width:'+this.width+';height:'+this.height+';">';
	s += '<tr>';
	for(var i=0;i<3;i++){
		s += '<td id="'+this.divName+'_td_'+i+'" width="33%" align="center"><span style="font-size:1px">&nbsp;</span><span id="'+this.divName+'_label_'+i+'" style="display:none;font-family: Courier New, Courier, mono;font-size: 12px;color: #000000;">'+this.labels[i]+'</span></td>';
	}	
	s += '</tr>';
	s += '</table>';
	this.content = s;
	if(this.showed){
		document.write(s);
		this.copyToStyle(this.selectedIndex);
	}	
}
PasswordStrength.prototype.copyToObject = function(o1,o2){
	for(var i in o1){
		o2[i] = o1[i];
	}
}
PasswordStrength.prototype.copyToStyle = function(id){
	this.selectedIndex = id;
	for(var i=0;i<3;i++){
		if(i == id-1){
			this.$(this.divName+"_label_"+i).style.display = "inline";
		}else{
			this.$(this.divName+"_label_"+i).style.display = "none";
		}
	}
	for(var i=0;i<id;i++){
		this.copyToObject(this.styles[id],this.$(this.divName+"_td_"+i).style);			
	}
	for(;i<3;i++){
		this.copyToObject(this.styles[0],this.$(this.divName+"_td_"+i).style);
	}
}
PasswordStrength.prototype.$ = function(s){
	return document.getElementById(s);
}
PasswordStrength.prototype.setSize = function(w,h){
	this.width = w;
	this.height = h;
}
PasswordStrength.prototype.setMinLength = function(n){
	if(isNaN(n)){
		return ;
	}
	n = Number(n);
	if(n>1){
		this.minLength = n;
	}
}
PasswordStrength.prototype.setStyles = function(){
	if(arguments.length == 0){
		return ;
	}
	for(var i=0;i<arguments.length && i < 4;i++){
		this.styles[i] = arguments[i];
	}
	this.copyToStyle(this.selectedIndex);
}
PasswordStrength.prototype.write = function(s){
	if(this.showed){
		return ;
	}
	var n = (s == 'string') ? this.$(s) : s;
	if(typeof(n) != "object"){
		return ;
	}
	n.innerHTML = this.content;
	this.copyToStyle(this.selectedIndex);
}
PasswordStrength.prototype.update = function(s){
	if(s.length < this.minLen){
		this.copyToStyle(0);
		return;
	}
	var ls = -1;
	if (s.match(/[a-z]/ig)){
		ls++;
	}
	if (s.match(/[0-9]/ig)){
		ls++;
	}
 	if (s.match(/(.[^a-z0-9])/ig)){
		ls++;
	}
	if (s.length < 6 && ls > 0){
		ls--;
	}
	 switch(ls) { 
		 case 0:
			 this.copyToStyle(1);
			 break;
		 case 1:
			 this.copyToStyle(2);
			 break;
		 case 2:
			 this.copyToStyle(3);
			 break;
		 default:
			 this.copyToStyle(0);
	 }
}

function ajaxsubmit_(p_url,p_data,p_back){
	$.ajax({
		type: "POST",
		url: p_url,
		data: p_data,
		timeout:20000,
		error:function(xm,tx,er){
			alert("发生系统错误：" + xm.responseText);
		},
		success:p_back
	})
} 
function jquerypoststr(_thisfrom){
	var poststr="";
	var tmpcval="";
	_thisfrom.find("input[type='hidden'][name],input[type='text'][name],textarea[name],input[type='radio'][name]:checked,select[name]").each( function(index){
		poststr += "&"+this.name+"="+escape(this.value).replace(/\+/,"%2B");
	});
	_thisfrom.find("input[type='checkbox'][name]").each( function(index){
		tmpcval=""; 
		if ( $(this).attr("checked") ) tmpcval = escape(this.value);
		poststr += "&"+this.name+"="+tmpcval;
	});
 	return poststr.substring(1);
}
function jquerysubmit_(jform,callback){
	ajaxsubmit_(jform.attr("action"),jquerypoststr(jform),callback);
}






function doouttitlemsg() {

    var v = arguments[0];
	
    var titletextinfo = $.trim(arguments[1]);
    var box_width = 220;
    var box_height = 50;
    var box_left = 15;
    if (arguments.length >= 3) {
        if (!isNaN(arguments[2]) && arguments[2] != "") box_width = arguments[2]
    }
    if (arguments.length >= 4) {
        if (!isNaN(arguments[3]) && arguments[3] != "") box_height = arguments[3]
    }
    if (arguments.length >= 5) {
        if (!isNaN(arguments[4]) && arguments[4] != "") box_left = arguments[4]
    }
	
    $("#titletext").width((parseInt(box_width) - 20));
    $("#titlemsg").width(box_width + 10);
    $("#top_left").width(box_width);
    $("#bottom_left").width(box_width);
    $("#bottom_left").height(box_height);
    $("#bottom_right").height(box_height);
    $("#titletext").height(parseInt(box_height) + 10);

    if (titletextinfo != "") {
        var offsetobj = $(v).offset();
        var T = parseInt(offsetobj.top) - 10;
        var W = parseInt($(v).width());
        var L = parseInt(offsetobj.left) + W + box_left;
        $("#titlemsg").css({
            top: T.toString() + "px",
            left: L.toString() + "px"
        });
        $("#titlemsg").fadeIn(300);
        if ($.browser.msie && $.browser.version <= 6) {
            setTimeout(function() {
                document.getElementById("titletext").innerHTML = titletextinfo
            },
            0)
			// alert(titletextinfo)
        } else {
            $("#titletext").html(titletextinfo)
        }
    }
}