document.writeln("<style type=\"text/css\">");
document.writeln("/*弹出层的STYLE*/");
document.writeln(".mydiv {");
document.writeln("background-color: #ffffff;");
document.writeln("border: 1px solid #cccccc;");
document.writeln("color:red;");
document.writeln("text-align: center;");
document.writeln("line-height: 40px;");
document.writeln("font-size: 12px;");
document.writeln("font-weight: bold;");
document.writeln("z-index:99;");
document.writeln("width: 300px;");
document.writeln("height: 120px;");
document.writeln("left:50%;/*FF IE7*/");
document.writeln("top: 50%;/*FF IE7*/");
document.writeln("");
document.writeln("margin-left:-150px!important;/*FF IE7 该值为本身宽的一半 */");
document.writeln("margin-top:-60px!important;/*FF IE7 该值为本身高的一半*/");
document.writeln("");
document.writeln("margin-top:0px;");
document.writeln("");
document.writeln("position:fixed!important;/*FF IE7*/");
document.writeln("position:absolute;/*IE6*/");
document.writeln("");
document.writeln("_top:       expression(eval(document.compatMode &&");
document.writeln("            document.compatMode==\'CSS1Compat\') ?");
document.writeln("            documentElement.scrollTop + (document.documentElement.clientHeight-this.offsetHeight)/2 :/*IE6*/");
document.writeln("            document.body.scrollTop + (document.body.clientHeight - this.clientHeight)/2);/*IE5 IE5.5*/");
document.writeln("");
document.writeln("}");
document.writeln("");
document.writeln("");
document.writeln(".bg {");
document.writeln("background-color: #eeeeee;");
document.writeln("width: 100%;");
document.writeln("height: 100%;");
document.writeln("left:0;");
document.writeln("top:0;/*FF IE7*/");
document.writeln("filter:alpha(opacity=50);/*IE*/");
document.writeln("opacity:0.5;/*FF*/");
document.writeln("z-index:1;");
document.writeln("");
document.writeln("position:fixed!important;/*FF IE7*/");
document.writeln("position:absolute;/*IE6*/");
document.writeln("");
document.writeln("_top:       expression(eval(document.compatMode &&");
document.writeln("            document.compatMode==\'CSS1Compat\') ?");
document.writeln("            documentElement.scrollTop + (document.documentElement.clientHeight-this.offsetHeight)/2 :/*IE6*/");
document.writeln("            document.body.scrollTop + (document.body.clientHeight - this.clientHeight)/2);/*IE5 IE5.5*/");
document.writeln("");
document.writeln("}");
document.writeln("/*The END*/");
document.writeln("");
document.writeln("</style>");


function showDiv(){
document.getElementById('popDiv').style.display='block';
document.getElementById('bg').style.display='block';
}

function closeDiv(){
document.getElementById('popDiv').style.display='none';
document.getElementById('bg').style.display='none';
}

document.writeln("  <div id=\"popDiv\" class=\"mydiv\" style=\"display:none;\">Loading...</div>");
document.writeln("<div id=\"bg\" class=\"bg\" style=\"display:none;\"></div>");
function showalertMoney(n)
{
	
$('#popDiv').html("非常抱歉，您的余额不足，暂不能开通业务<br><a href=\"/manager/onlinePay/onlinePay.asp?paymoney="+n+"\" target=\"_blank\" style=\"color:#c00\">马上充值!</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"javascript:closeDiv()\" style=\"color:green\">已充值完成!</a>")

   showDiv();
 
}