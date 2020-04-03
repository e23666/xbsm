function initialize(LayerID) {
	
	if (LayerID!=""){	
		var obj=findObj(LayerID);		
		obj.open="false"
		clickOnEntity(obj);
	}
}


function clickOnEntity(entity) {
	
	if (entity.canopen=="true") {
		var obj=findObj(entity.id+1);		
		if (entity.open=="false"){
			eval("obj."+"style.display='block'");
			entity.open="true";					
		}
		else {
			eval("obj."+"style.display='none'");
			entity.open="false";		
		}
		
			
  	}
  	closelayer(entity) ;
  	
  	if (entity.lurl=="/quit.jsp") {
  		window.location = entity.lurl;
  	}
	window.event.cancelBubble = "true";
}

function findObj(n, d) { //v4.01
  	var p,i,x;  
	if(!d) d=document; 
	if((p=n.indexOf("?"))>0&&parent.frames.length) {
    		d=parent.frames[n.substring(p+1)].document; 
		n=n.substring(0,p);
	}
  	if(!(x=d[n])&&d.all) x=d.all[n]; 
	for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  	for(i=0;!x&&d.layers&&i<d.layers.length;i++) 
	x=MM_findObj(n,d.layers[i].document);
  	if(!x && d.getElementById) x=d.getElementById(n); return x;
}


function closelayer(entity) {
	
	for(i=0;i<folderTree.nodecount;i++) {
		k=i+1;
		d = "D";
		if(k<10) d = d+"0";
		if (entity.id!=(d+k)) {
			var obj=findObj(d+k+1);
			eval("obj."+"style.display='none'");
			var obj=findObj(d+k);
		}			
  	}
}

function displayTree() {
	if (folderTree.open=="true"){
		folderTree.style.display="none";	
		folderTree.open="false"	
		cimg.src="../images/top6.gif"
	}
	else{
		folderTree.style.display="block";
		folderTree.open="true";
		cimg.src="../images/top2.gif";
	}
	
}

function quitsys(){
	
	if (window.confirm("是否要退出系统？")){
		window.location="/quit.jsp";
	}
}

//增加了一些通用判断--szj

function checkmsg(a1,msg)
{
	if(a1.value=="") 
	{
		alert(msg);
		a1.focus();
		return false;
	}
	else
	{
		return true;
	}
		
}

function checkKeyNum()
{

if(event.keyCode>=48 && event.keyCode<=57 )
{
}
else
{
event.keyCode=null;
}
}
//打印
function pp()
{
	
	//去头尾
	document.all.Container.innerHTML=document.all.toBePrint.innerHTML;
	//标题居中
	document.all.xyz.align="center";
	//信息表格
	try
	{
	document.all.xxx.border=1;
	}
	catch(e)
	{
	}
	//内容表格
	try
	{
	document.all.zzz.border=1;
	}
	catch(e)
	{
	}
	
	//打印
	window.print();
}
