/*/////////////////////////////////////////////////////////////////
函数说明：风声日期和时间选择器，整个功能只有一个函数调用极其方便
作　　者：风声
电子邮件：rumor@17560.net	
函数原型：
function selectTime(thisName[,mode])
参数说明：
	thisName：接受返回值的对象名称,
		例如：
		"myDate""选择器将返回myDate.value=选择的结果
		"form1.myDate"选择器将返回form1.myDate.value=选择的结果
	mode	：返回值类型
		0：默认值，返回yyyy-mm-dd hh-mm-ss
		1：返回yyyy-mm-dd
		2：返回hh-mm-ss
		3：返回mm-dd
		4：返回hh-mm
		5：返回yyyy-mm-dd hh-mm
时　　间：2004-5-26
////////////////////////////////////////////////////////////////*/
function selectTime(thisName){
var argv=selectTime.arguments;
var argc=selectTime.arguments.length;
var mode=(argc>1)?argv[1]:0;
try{
	var strTime=eval(thisName).value;
	strTime=strTime.replace(/[-:]/g," ");
	var arrTime=strTime.split(" ");
}catch(e){
	return false;
}
var dateNow	= new Date();
var intYear	= dateNow.getYear();
var intMonth	= dateNow.getMonth();
var intDate	= dateNow.getDate();
var intHour	= dateNow.getHours();
var intMinute	= dateNow.getMinutes();
var intSecond	= dateNow.getSeconds();

var i=0;
if(!isNaN(arrTime[0])){
	i=parseInt(arrTime[0]);
	if(i>1000&&i<9000)intYear=i;
}
if(!isNaN(arrTime[1])){
	i=parseInt(arrTime[1]);
	if(i>0&&i<13)intMonth=i-1;
}
var dateFirst=new Date(intYear,intMonth,1);
var intDay=dateFirst.getDay();
var arrDays=new Array(31,28,31,30,31,30,31,31,30,31,30,31);
var intDays=arrDays[intMonth];
if(intMonth==1)intDays+=!(intYear%4);
if(!isNaN(arrTime[2])){
	i=parseInt(arrTime[2]);
	if(i>0&&i<=intDays)intDate=i;
}
if(!isNaN(arrTime[3])){
	i=parseInt(arrTime[3]);
	if(i>=0&&i<24)intHour=i;
}
if(!isNaN(arrTime[4])){
	i=parseInt(arrTime[4]);
	if(i>=0&&i<60)intMinute=i;
}
if(!isNaN(arrTime[5])){
	i=parseInt(arrTime[5]);
	if(i>=0&&i<60)intSecond=i;
}

var myWindow	= window.open("","","height=304,width=404");
var arrMonth=new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");

var strHTML="";
strHTML+="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">";
strHTML+="<title>选择日期和时间</title><style type=\"text/css\"><!--\n";
strHTML+="table {font-size: 12px;}";
strHTML+=".f8 {	font-size: 7px;}";
strHTML+=".myinput {text-align: center;width: 20px;border: 0px;height: 16px;vertical-align: baseline;}";
strHTML+=".boxIn {border-top: 2px solid #423E3B;border-right: 1px solid #FFFCF5;border-bottom: 1px solid #FFFCF5;border-left: 2px solid #423E3B;background: #FFFFFF;}";
strHTML+=".myButton {height: 10px;width: 25px;font-size: 4px;}";
strHTML+="\n--></style>";
strHTML+="<script language=\"JavaScript\">";
strHTML+="var day="+intDate+";";
strHTML+="var strTemp=\"\",intTemp=0;";
strHTML+="function onTimeKeyUp(obj,num,maxnum,next){";
strHTML+="var strTemp=obj.value;";	
strHTML+="if(isNaN(strTemp))obj.value=strTemp.substring(0,strTemp.length-1);";
strHTML+="else{var intTemp=parseInt(strTemp);";
strHTML+="if(intTemp>maxnum)obj.value=strTemp.substring(0,strTemp.length-1);";
strHTML+="else if(intTemp>num){next.focus();}";
strHTML+="}}";
strHTML+="function setCalendar(intYear,intMonth,intDate){";
strHTML+="var dateFirst=new Date(intYear,intMonth,1);";
strHTML+="var intDay=dateFirst.getDay();";
strHTML+="var arrDays=new Array(31,28,31,30,31,30,31,31,30,31,30,31);";
strHTML+="var intDays=arrDays[intMonth],str=\"\";";
strHTML+="if(month==1)intDays+=!(intYear%4);";
strHTML+="if(intDate>intDays)intDate=intDays;";
strHTML+="intDay--;";
strHTML+="for(var i=0;i<42;i++){";
strHTML+="if(i<=intDay)date[i].innerHTML=\"\";";
strHTML+="else if(i<=intDays+intDay){str=i-intDay;if(str<10)str=\"&nbsp;\"+str;";
strHTML+="if(i-intDay==intDate){strTemp=str;";
strHTML+="str=\"<font color=\'#FFFFFF\' style=\'background:#0A246A\'>\"+str+\"</font>\";";
strHTML+="intTemp=i;day=intDate;}";
strHTML+="date[i].innerHTML=str;}";
strHTML+="else date[i].innerHTML=\"\";";
strHTML+="}}";
strHTML+="function setNewDate(num){"
strHTML+="var str=date[num].innerHTML;";
strHTML+="var i=str.length;";
strHTML+="if(i>1&&i<8){";
strHTML+="date[intTemp].innerHTML=strTemp;intTemp=num;strTemp=str;";
strHTML+="date[num].innerHTML=\"<font color=\'#FFFFFF\' style=\'background:#0A246A\'>\"+strTemp+\"</font>\";";
strHTML+="if(i>2)str=str.substr(i-1);day=parseInt(str);}}";
strHTML+="function isOk(){";
switch(mode){
case 0:strHTML+="window.opener."+thisName+".value=year.value+\"-\"+(parseInt(month.value)+1)+\"-\"+day+\" \"+hour.value+\":\"+minute.value+\":\"+second.value;";break;
case 1:strHTML+="window.opener."+thisName+".value=year.value+\"-\"+(parseInt(month.value)+1)+\"-\"+day;";break;
case 2:strHTML+="window.opener."+thisName+".value=hour.value+\":\"+minute.value+\":\"+second.value;";break;
case 3:strHTML+="window.opener."+thisName+".value=(parseInt(month.value)+1)+\"-\"+day;";break;
case 4:strHTML+="window.opener."+thisName+".value=hour.value+\":\"+minute.value;";break;
case 5:strHTML+="window.opener."+thisName+".value=year.value+\"-\"+(parseInt(month.value)+1)+\"-\"+day+\" \"+hour.value+\":\"+minute.value;";break;
}
strHTML+="window.close();}";
strHTML+="function timeAdd(obj0){var i=parseInt(obj.value);if(i<intMax)obj.value=i+1;obj.select();obj0.focus();}";
strHTML+="function timeRid(obj0){var i=parseInt(obj.value);if(i>0)obj.value=i-1;obj.select();obj0.focus();}";
strHTML+="</script>";
strHTML+="</head>";

strHTML+="<body bgcolor=\"#D4CFC9\" style=\"border:0;margin:5\" oncontextmenu=\"return(false)\">";
strHTML+="<table width=\"394\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
strHTML+="<tr>";
strHTML+="<td height=\"24\" align=\"center\" style=\"border-left:1px solid #FFFCF5;border-top:1px solid #FFFCF5\">日期和时间</td>";
strHTML+="<td colspan=\"2\" style=\"border-left:2px solid #423E3B;border-bottom:1px solid #FFFCF5\">&nbsp;</td>";
strHTML+="</tr><tr> ";
strHTML+="<td height=\"200\" colspan=\"2\" align=\"center\" style=\"border-left:1px solid #FFFCF5;margin:5px;\">";
strHTML+="<fieldset style=\"width:190;height:190\"><legend>日期(D)</legend>";
strHTML+="<select name=\"month\" id=\"month\" style=\"width:82\" onChange=\"&#115&#101&#116&#67&#97&#108&#101&#110&#100&#97&#114(year.value,month.value,day)\">";
for(i=0;i<12;i++){
	strHTML+="<option value=\""+i+"\"";
	if(i==intMonth)strHTML+=" selected";
	strHTML+=">"+arrMonth[i]+"</option>";
}
strHTML+="</select> ";
strHTML+="<select name=\"year\" id=\"year\" style=\"width:82\" onChange=\"&#115&#101&#116&#67&#97&#108&#101&#110&#100&#97&#114(year.value,month.value,day)\">";
for(i=intYear-10;i<intYear+10;i++){
	strHTML+="<option value=\""+i+"\"";
	if(i==intYear)strHTML+=" selected";
	strHTML+=">"+i+"年</option>";
}
strHTML+="</select>";
strHTML+="<div class=\"f8\">&nbsp;</div>";
strHTML+="<table width=\"168\" height=\"133\" border=\"0\" cellpadding=\"2\" cellspacing=\"0\" class=\"boxIn\" style=\"cursor:default\">";
strHTML+="<tr align=\"center\" bgcolor=\"#999999\">";
strHTML+="<td width=24 height=19>日</td><td width=24>一</td><td width=24>二</td><td width=24>三</td><td width=24>四</td><td width=24>五</td><td width=24>六</td>";
for(i=0;i<42;i++){
	if(i%7==0)strHTML+="</tr><tr align=\"center\">";
	strHTML+="<td id=\"date\" height=19 onclick=\"&#115&#101&#116&#78&#101&#119&#68&#97&#116&#101("+i+")\">&nbsp;</td>";
}
strHTML+="</tr></table></fieldset></td>";
strHTML+="<td align=\"center\" style=\"border-right:2px solid #423E3B;margin:5px;\">";
strHTML+="<fieldset style=\"width:170;height:190\"><legend>时间(T)</legend>";
strHTML+="<div style=\"height:142\">&nbsp;</div>";
strHTML+="<table width=\"150\" border=\"0\" cellspacing=\"2\" cellpadding=\"0\"><tr>";
strHTML+="<td width=\"125\" align=\"right\" class=\"boxIn\">";
strHTML+="<input name=\"hour\" type=\"text\" class=\"myinput\" id=\"hour\" onBlur=\"if(this.value=='')this.value='0';\" onFocus=\"this.select();obj=this;intMax=23\" value=\""+intHour+"\" maxlength=\"2\" onkeyup=\"onTimeKeyUp(this,2,23,minute)\">:";
strHTML+="<input name=\"minute\" type=\"text\" class=\"myinput\" id=\"minute\" onBlur=\"if(this.value=='')this.value='0';\" onFocus=\"this.select();obj=this;intMax=59\" value=\""+intMinute+"\" maxlength=\"2\" onkeyup=\"onTimeKeyUp(this,5,59,second)\">:";
strHTML+="<input name=\"second\" type=\"text\" class=\"myinput\" id=\"second\" onBlur=\"if(this.value=='')this.value='0';\" onFocus=\"this.select();obj=this;intMax=59\" value=\""+intSecond+"\" maxlength=\"2\" onkeyup=\"onTimeKeyUp(this,59,59,null)\">";
strHTML+="</td>";
strHTML+="<td width=\"25\"><input name=\"Submit\" type=\"button\" class=\"myButton\" value=\"◆\" onClick=\"timeAdd(this)\">";
strHTML+="<input name=\"Submit4\" type=\"button\" class=\"myButton\" value=\"◆\" onClick=\"timeRid(this)\"></td>";
strHTML+="</tr></table></fieldset></td>";
strHTML+="</tr><tr> ";
strHTML+="<td height=\"40\" colspan=\"3\" style=\"border-left:1px solid #FFFCF5;border-right:2px solid #423E3B;border-bottom:2px solid #423E3B;margin:5px;\">";
strHTML+="　Rumor Date And Time Selector<br><br></td></tr><tr><td width=\"80\" height=\"8\">";
strHTML+="";
strHTML+="</td>";
strHTML+="<td width=\"127\" align=\"right\"></td>";
strHTML+="<td width=\"187\" align=\"right\"></td>";
strHTML+="</tr><tr><td>&nbsp;</td>";
strHTML+="<td colspan=\"2\" align=\"right\">";
strHTML+="<input type=\"button\" name=\"Submit1\" value=\"　确定　\" onclick=\"isOk()\"> ";
strHTML+="<input type=\"button\" name=\"Submit2\" value=\"　取消　\" onclick=\"window.close()\"> ";
strHTML+="<input type=\"button\" name=\"Submit3\" value=\"　应用　\" disabled></td>";
strHTML+="</tr></table></body></html>";
strHTML+="<script language=\"javascript\">var obj=document.getElementById(\"hour\"),intMax=23;";
strHTML+="setCalendar("+intYear+","+intMonth+","+intDate+");</script>";
myWindow.document.write(strHTML);
}