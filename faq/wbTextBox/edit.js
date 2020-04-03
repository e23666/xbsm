
var bodyID,htmlableID;

var WBTB_yToolbars = new Array();

var WBTB_YInitialized = false;

var WBTB_filterScript = false;

var WBTB_charset="UTF-8";

function document.onreadystatechange()
{
	if (WBTB_YInitialized) return;
	WBTB_YInitialized = true;
	
	var i, s, curr;
	
	for (i=0; i<document.body.all.length;	i++)
	{
		curr=document.body.all[i];
		if (curr.className == "yToolbar")
		{
			WBTB_InitTB(curr);
			WBTB_yToolbars[WBTB_yToolbars.length] = curr;
		}
	}
}

function WBTB_InitBtn(btn)
{
	btn.onmouseover = WBTB_BtnMouseOver;
	btn.onmouseout = WBTB_BtnMouseOut;
	btn.onmousedown = WBTB_BtnMouseDown;
	btn.onmouseup	= WBTB_BtnMouseUp;
	btn.ondragstart = WBTB_YCancelEvent;
	btn.onselectstart = WBTB_YCancelEvent;
	btn.onselect = WBTB_YCancelEvent;
	btn.YUSERONCLICK = btn.onclick;
	btn.onclick = WBTB_YCancelEvent;
	btn.YINITIALIZED = true;
	return true;
}

function WBTB_InitTB(y)
{
	y.TBWidth = 0;
	if (!WBTB_PopulateTB(y)) return false;
	y.style.posWidth = y.TBWidth;
	return true;
}


function WBTB_YCancelEvent()
{
	event.returnValue=false;
	event.cancelBubble=true;
	return false;
}

function WBTB_BtnMouseOver()
{
	if (event.srcElement.tagName != "IMG") return false;
	var image = event.srcElement;
	var element = image.parentElement;
	
	if (image.className == "WBTB_Ico") element.className = "WBTB_BtnMouseOverUp";
	else if (image.className == "WBTB_IcoDown") element.className = "WBTB_BtnMouseOverDown";
	
	event.cancelBubble = true;
}

function WBTB_BtnMouseOut()
{
	if (event.srcElement.tagName != "IMG") {
		event.cancelBubble = true;
		return false;
	}
	
	var image = event.srcElement;
	var element =	image.parentElement;
	yRaisedElement = null;
	
	element.className = "WBTB_Btn";
	image.className = "WBTB_Ico";
	
	event.cancelBubble = true;
}

function WBTB_BtnMouseDown()
{
	if (event.srcElement.tagName != "IMG") {
		event.cancelBubble = true;
		event.returnValue=false;
		return false;
	}
	
	var image = event.srcElement;
	var element = image.parentElement;
	
	element.className = "WBTB_BtnMouseOverDown";
	image.className = "WBTB_IcoDown";
	
	event.cancelBubble = true;
	event.returnValue=false;
	return false;
}

function WBTB_BtnMouseUp()
{
	if (event.srcElement.tagName != "IMG") {
		event.cancelBubble = true;
		return false;
	}
	
	var image = event.srcElement;
	var element = image.parentElement;
	
	if (element.YUSERONCLICK) eval(element.YUSERONCLICK + "anonymous()");
	
	element.className = "WBTB_BtnMouseOverUp";
	image.className = "WBTB_Ico";
	
	event.cancelBubble = true;
	return false;
}

function WBTB_PopulateTB(y)
{
	var i, elements, element;
	
	elements = y.children;
	for (i=0; i<elements.length; i++) {
	element = elements[i];
	if (element.tagName== "SCRIPT" || element.tagName == "!") continue;
	
	switch (element.className) {
		case "WBTB_Btn":
			if (element.YINITIALIZED == null) {
				if (! WBTB_InitBtn(element))
					return false;
			}
			
			element.style.posLeft = y.TBWidth;
			y.TBWidth	+= element.offsetWidth + 1;
			break;
		
		case "WBTB_TBGen":
			element.style.posLeft = y.TBWidth;
			y.TBWidth	+= element.offsetWidth + 1;
			break;
		
			//default:
			//  return false;
		}
	}
	
	y.TBWidth += 1;
	return true;
}

function WBTB_DebugObject(obj)
{
	var msg = "";
	for (var i in TB) {
		ans=prompt(i+"="+TB[i]+"\n");
		if (! ans) break;
	}
}


function WBTB_validateMode()
{
	if (!WBTB_bTextMode) return true;
	alert("请取消“查看HTML源代码”选项再使用系统编辑功能或者提交!");
	WBTB_Composition.focus();
	return false;
}

function WBTB_format1(what,opt)
{
	if (opt=="removeFormat")
	{
		what=opt;
		opt=null;
	}
	WBTB_Composition.focus();
	if (opt==null)
	{
		WBTB_Composition.document.execCommand(what);
	}else{
		WBTB_Composition.document.execCommand(what,"",opt);
	}
	WBTB_pureText = false;
	WBTB_Composition.focus();
}

function WBTB_format(what,opt)
{
	  if (!WBTB_validateMode()) return;
	
	  WBTB_format1(what,opt);
}

function WBTB_setMode()
{
	WBTB_bTextMode=!WBTB_bTextMode;
	WBTB_setTab();
	var cont;
	if (WBTB_bTextMode) {
		document.all.WBTB_Toolbars.style.display='none';
		WBTB_cleanHtml();
		cont=WBTB_Composition.document.body.innerHTML;
		cont=WBTB_correctUrl(cont);
		if (WBTB_filterScript)
			cont=WBTB_FilterScript(cont);
		WBTB_Composition.document.body.innerText=cont;
	} else {
		document.all.WBTB_Toolbars.style.display='';
		cont=WBTB_Composition.document.body.innerText;
		cont=WBTB_correctUrl(cont);
		if (WBTB_filterScript)
			cont=WBTB_FilterScript(cont);
		WBTB_Composition.document.body.innerHTML=cont;
	}
	WBTB_setStyle();
	WBTB_Composition.focus();
}

function WBTB_setStyle()
{
	bs = WBTB_Composition.document.body.runtimeStyle;
	//根据mode设置iframe样式表	
	if (WBTB_bTextMode) {
		bs.fontFamily="Arial";
		bs.fontSize="10pt";
	}else{
		bs.fontFamily="Arial";
		bs.fontSize="10.5pt";
	}
	bs.scrollbar3dLightColor= '#D4D0C8';
	bs.scrollbarArrowColor= '#000000';
	bs.scrollbarBaseColor= '#D4D0C8';
	bs.scrollbarDarkShadowColor= '#D4D0C8';
	bs.scrollbarFaceColor= '#D4D0C8';
	bs.scrollbarHighlightColor= '#808080';
	bs.scrollbarShadowColor= '#808080';
	bs.scrollbarTrackColor= '#D4D0C8';
	bs.border='0';
}

function WBTB_setTab()
{
	//html和design按钮的样式更改
	var mhtml=document.all.WBTB_TabHtml;
	var mdesign=document.all.WBTB_TabDesign;
	if (WBTB_bTextMode)
	{
		mhtml.className="WBTB_TabOn";
		mdesign.className="WBTB_TabOff";
	}else{
		mhtml.className="WBTB_TabOff";
		mdesign.className="WBTB_TabOn";
	}
}

function WBTB_getEl(sTag,start)
{
	while ((start!=null) && (start.tagName!=sTag)) start = start.parentElement;
	return start;
}

function WBTB_UserDialog(what)
{
	if (!WBTB_validateMode()) return;
	WBTB_Composition.focus();
	WBTB_Composition.document.execCommand(what, true);
	
	//去掉添加图片时的src="file://
	if(what=="InsertImage")
	{
		WBTB_Composition.document.body.innerHTML=(WBTB_Composition.document.body.innerHTML).replace("src=\"file://","src=\"");
	}
	
	WBTB_pureText = false;
	WBTB_Composition.focus();
}

function WBTB_foreColor()
{
	if (!WBTB_validateMode()) return;
	var arr = showModalDialog("wbTextBox/selcolor.html", "", "dialogWidth:18.5em; dialogHeight:17.5em; status:0; help:0");
	if (arr != null) WBTB_format('forecolor', arr);
	else WBTB_Composition.focus();
}

function WBTB_backColor()
{
	if (!WBTB_validateMode()) return;
	var arr = showModalDialog("wbTextBox/selcolor.html", "", "dialogWidth:18.5em; dialogHeight:17.5em; status:0; help:0");
	if (arr != null) WBTB_format('backcolor', arr);
	else WBTB_Composition.focus();
}

function WBTB_fortable()
{
	if (!WBTB_validateMode())	return;
	var arr = showModalDialog("wbTextBox/table.html", "", "dialogWidth:14.5em; dialogHeight:16.5em; status:0; help:0");
	
	if (arr != null)
	{
		var ss;
		ss=arr.split("*")
		row=ss[0];
		if (row=="") row=1;
		col=ss[1];
		if (col=="") col=1;
		tbwidth=ss[2];
		if (tbwidth=="") tbwidth=500;
		tbborder=ss[3];
		if (tbborder=="") tbborder=1;
		celpadding=ss[4];
		if (celpadding=="") celpadding=2;
		bdcolor=ss[5];
		if (bdcolor=="") bdcolor="#CCCCCC";
		bgcolor=ss[6];
		if (bgcolor=="") bgcolor="#FFFFFF";
		tbalign=ss[7];
		if (tbalign=="") tbalign="center";
		var string;
		string="<table border="+ tbborder +" cellspacing=0 width="+tbwidth+" cellpadding="+ celpadding +" align="+tbalign+" bgcolor='"+ bgcolor +"' bordercolor="+ bdcolor +" style='border-collapse:collapse'>";
		for(i=1;i<=row;i++){
			string=string+"<tr>";
			for(j=1;j<=col;j++){
				string=string+"<td>&nbsp;</td>";
			}
			string=string+"</tr>";
		}
		string=string+"</table>";
		content=WBTB_Composition.document.body.innerHTML;
		content=content+string;
		WBTB_Composition.document.body.innerHTML=content;
	}
	else
		WBTB_Composition.focus();
}

function WBTB_forswf()
{
	var arr = showModalDialog("wbTextBox/swf.htm", "", "dialogWidth:15em; dialogHeight:13em; status:0; help:0");
	
	if (arr != null){
		var ss;
		ss=arr.split("*")
		path=ss[0];
		row=ss[1];
		col=ss[2];
		var string;
		string="<div align='center'><div style='width:640;text-align:left'><a href="+path+">[全屏查看]</a></div><object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'  codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0' width="+row+" height="+col+"><param name=movie value="+path+"><param name=quality value=high><embed src="+path+" pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width="+row+" height="+col+"></embed></object>"
		content=WBTB_Composition.document.body.innerHTML;
		content=content+string;
		WBTB_Composition.document.body.innerHTML=content;
	}
	else WBTB_Composition.focus();
}

function WBTB_forwmv()
{
	var arr = showModalDialog("wbTextBox/wmv.htm", "", "dialogWidth:15.5em; dialogHeight:14em; status:0; help:0");
	
	if (arr != null){
		var ss;
		ss=arr.split("*")
		path=ss[0];
		width=ss[1];
		height=ss[2];
		var string;
		//string="<object align=center classid=CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95 hspace=5 vspace=5 width="+ width +" height="+ height +"><param name=Filename value="+ path +"><param name=ShowStatusBar value=1><embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 flename=mp src="+ path +"  width="+ width +" height="+ height +"></embed></object>";
		string="<embed src='"+ path+"' width="+ width +" height="+ height +" autostart=true loop=false ></embed>";
		content=WBTB_Composition.document.body.innerHTML;
		content=content+string;
		WBTB_Composition.document.body.innerHTML=content;
	}
	else WBTB_Composition.focus();
}


function WBTB_forrm()
{
	var arr = showModalDialog("wbTextBox/rm.htm", "", "dialogWidth:15.5em; dialogHeight:14em; status:0; help:0");
	
	if (arr != null)
	{
		var ss;
		ss=arr.split("*")
		path=ss[0];
		row=ss[1];
		col=ss[2];
		var string;
		string="<object classid='clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA' width="+row+" height="+col+"><param name='CONTROLS' value='ImageWindow'><param name='CONSOLE' value='Clip1'><param name='AUTOSTART' value='-1'><param name=src value="+path+"></object><br><object classid='clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA'  width="+row+" height=60><param name='CONTROLS' value='ControlPanel,StatusBar'><param name='CONSOLE' value='Clip1'></object>";
		content=WBTB_Composition.document.body.innerHTML;
		content=content+string;
		WBTB_Composition.document.body.innerHTML=content;
	}
	else WBTB_Composition.focus();
}

function WBTB_InsertRow()
{
	editor = WBTB_Composition;
	objReference=WBTB_GetRangeReference(editor);
	objReference=WBTB_CheckTag(objReference,'/^(TABLE)|^(TR)|^(TD)|^(TBODY)/');
	switch(objReference.tagName)
	{
	case 'TABLE' :
	var newTable=objReference.cloneNode(true);
	var newRow= newTable.insertRow();
	
	for(x=0; x<newTable.rows[0].cells.length; x++)
	{
	var newCell = newRow.insertCell();
	}
	objReference.outerHTML=newTable.outerHTML;
	break;
	case 'TBODY' :
	var newTable=objReference.cloneNode(true);
	var newRow = newTable.insertRow();
	for(x=0; x<newTable.rows[0].cells.length; x++)
	{
	var newCell = newRow.insertCell();
	}
	objReference.outerHTML=newTable.outerHTML;
	break;
	case 'TR' :
	var rowIndex = objReference.rowIndex;
	var parentTable=objReference.parentElement.parentElement;
	var newTable=parentTable.cloneNode(true);
	var newRow = newTable.insertRow(rowIndex+1);
	for(x=0; x< newTable.rows[0].cells.length; x++)
	{
	var newCell = newRow.insertCell();
	}
	parentTable.outerHTML=newTable.outerHTML;
	break;
	case 'TD' :
	var parentRow=objReference.parentElement;
	var rowIndex = parentRow.rowIndex;
	var cellIndex=objReference.cellIndex;
	var parentTable=objReference.parentElement.parentElement.parentElement;
	var newTable=parentTable.cloneNode(true);
	var newRow = newTable.insertRow(rowIndex+1);
	for(x=0; x< newTable.rows[0].cells.length; x++)
	{
	var newCell = newRow.insertCell();
	if (x==cellIndex)newCell.id='ura';
	}
	parentTable.outerHTML=newTable.outerHTML;
	var r = editor.document.body.createTextRange();
	var item=editor.document.getElementById('ura');
	item.id='';
	r.moveToElementText(item);
	r.moveStart('character',r.text.length);
	r.select();
	break;
	default :
	return;
	}
}

function WBTB_DeleteRow()
{
	editor=WBTB_Composition;
	objReference=WBTB_GetRangeReference(editor);
	objReference=WBTB_CheckTag(objReference,'/^(TABLE)|^(TR)|^(TD)|^(TBODY)/');
	switch(objReference.tagName)
	{
	case 'TR' :var rowIndex = objReference.rowIndex;//Get rowIndex
	var parentTable=objReference.parentElement.parentElement;
	parentTable.deleteRow(rowIndex);
	break;
	case 'TD' :var cellIndex=objReference.cellIndex;
	var parentRow=objReference.parentElement;//Get Parent Row
	var rowIndex = parentRow.rowIndex;//Get rowIndex
	var parentTable=objReference.parentElement.parentElement.parentElement;
	parentTable.deleteRow(rowIndex);
	if (rowIndex>=parentTable.rows.length)
	{
	rowIndex=parentTable.rows.length-1;
	}
	if (rowIndex>=0)
	{
	var r = editor.document.body.createTextRange();
	r.moveToElementText(parentTable.rows[rowIndex].cells[cellIndex]);
	r.moveStart('character',r.text.length);
	r.select();
	}
	else
	{
	parentTable.removeNode(true);
	}
	break;
	default :return;
	}
}


function WBTB_InsertColumn()
{
	editor = WBTB_Composition;
	objReference= WBTB_GetRangeReference(editor);
	objReference=WBTB_CheckTag(objReference,'/^(TABLE)|^(TR)|^(TD)|^(TBODY)/');
	switch(objReference.tagName)
	{
	case 'TABLE' :// IF a table is selected, it adds a new column on the right hand side of the table.
	var newTable=objReference.cloneNode(true);
	for(x=0; x<newTable.rows.length; x++)
	{
	var newCell = newTable.rows[x].insertCell();
	}
	newCell.focus();
	objReference.outerHTML=newTable.outerHTML;
	break;
	case 'TBODY' :// IF a table is selected, it adds a new column on the right hand side of the table.
	var newTable=objReference.cloneNode(true);
	for(x=0; x<newTable.rows.length; x++)
	{
	var newCell = newTable.rows[x].insertCell();
	}
	objReference.outerHTML=newTable.outerHTML;
	break;
	case 'TR' :// IF a table is selected, it adds a new column on the right hand side of the table.
	objReference=objReference.parentElement.parentElement;
	var newTable=objReference.cloneNode(true);
	for(x=0; x<newTable.rows.length; x++)
	{
	var newCell = newTable.rows[x].insertCell();
	}
	objReference.outerHTML=newTable.outerHTML;
	break;
	case 'TD' :// IF the cursor is in a cell, or a cell is selected, it adds a new column to the right of that cell.
	var cellIndex = objReference.cellIndex;//Get cellIndex
	var rowIndex=objReference.parentElement.rowIndex;
	var parentTable=objReference.parentElement.parentElement.parentElement;
	var newTable=parentTable.cloneNode(true);
	for(x=0; x<newTable.rows.length; x++)
	{
	var newCell = newTable.rows[x].insertCell(cellIndex+1);
	if (x==rowIndex)newCell.id='ura';
	}
	parentTable.outerHTML=newTable.outerHTML;
	var r = editor.document.body.createTextRange();
	var item=editor.document.getElementById('ura');
	item.id='';
	r.moveToElementText(item);
	r.moveStart('character',r.text.length);
	r.select();
	break;
	default :
	return;
	}
}
 

function WBTB_DeleteColumn()
{
	editor = WBTB_Composition;
	objReference=WBTB_GetRangeReference(editor);
	objReference=WBTB_CheckTag(objReference,'/^(TABLE)|^(TR)|^(TD)|^(TBODY)/');
	switch(objReference.tagName)
	{
	
	case 'TD' :var rowIndex=objReference.parentElement.rowIndex;
	var cellIndex = objReference.cellIndex;//Get cellIndex
	var parentTable=objReference.parentElement.parentElement.parentElement;
	var newTable=parentTable.cloneNode(true);
	if (newTable.rows[0].cells.length==1)
	{
	parentTable.removeNode(true);
	return;
	}
	for(x=0; x<newTable.rows.length; x++)
	{
	if (newTable.rows[x].cells[cellIndex]=='[object]')
	{
	newTable.rows[x].deleteCell(cellIndex);
	}
	}
	if (cellIndex>=newTable.rows[0].cells.length)
	{
	cellIndex=newTable.rows[0].cells.length-1;
	}
	if (cellIndex>=0)  newTable.rows[rowIndex].cells[cellIndex].id='ura';
	parentTable.outerHTML=newTable.outerHTML;
	if (cellIndex>=0){
	var r = editor.document.body.createTextRange();
	var item=editor.document.getElementById('ura');
	item.id='';
	r.moveToElementText(item);
	r.moveStart('character',r.text.length);
	r.select();
	}
	break;
	default :return;
	}
}


function WBTB_GetRangeReference(editor)
{
	editor.focus();
	var objReference = null;
	var RangeType = editor.document.selection.type;
	var selectedRange = editor.document.selection.createRange();
	
	switch(RangeType)
	{
	case 'Control' :
	if (selectedRange.length > 0 ) 
	{
	objReference = selectedRange.item(0);
	}
	break;
	
	case 'None' :
	objReference = selectedRange.parentElement();
	break;
	
	case 'Text' :
	objReference = selectedRange.parentElement();
	break;
	}
	return objReference
}

function WBTB_CheckTag(item,tagName)
{
	if (item.tagName.search(tagName)!=-1)
	{
	return item;
	}
	if (item.tagName=='BODY')
	{
	return false;
	}
	item=item.parentElement;
	return WBTB_CheckTag(item,tagName);
}

function WBTB_code()
{
	WBTB_specialtype("<div class=quote style='cursor:hand'; title='Click to run the code' onclick=\"preWin=window.open('','','');preWin.document.open();preWin.document.write(this.innerText);preWin.document.close();\">","</div>");	
}

function WBTB_replace()
{
	var arr = showModalDialog("wbTextBox/replace.html", "", "dialogWidth:16.5em; dialogHeight:13em; status:0; help:0");
	
	if (arr != null){
		var ss;
		ss=arr.split("*")
		a=ss[0];
		b=ss[1];
		i=ss[2];
		con=WBTB_Composition.document.body.innerHTML;
		if (i==1)
		{
			con=WBTB_rCode(con,a,b,true);
		}else{
			con=WBTB_rCode(con,a,b);
		}
		WBTB_Composition.document.body.innerHTML=con;
	}
	else WBTB_Composition.focus();
}


function WBTB_CleanCode() {
	editor=WBTB_Composition;
	editor.focus();
	// 0bject based cleaning
	var body = editor.document.body;
	for (var index = 0; index < body.all.length; index++) {
		tag = body.all[index];
		//if (tag.Attribute["className"].indexOf("mso") > -1)
		tag.removeAttribute("className","",0);
		tag.removeAttribute("style","",0);
	}

	// Regex based cleaning
	var html = editor.document.body.innerHTML;
	html = html.replace(/<o:p>&nbsp;<\/o:p>/gi, "");
	html = html.replace(/o:/gi, "");
	//html = html.replace(/<st1:[^>]*>/gi, "");

	// Final clean up of empty tags
	html = html.replace(/<font[^>]*>\s*<\/font>/gi, "");
	html = html.replace(/<span>\s*<\/span>/gi, "");
	
	editor.document.body.innerHTML = html;
}


function WBTB_FilterScript(content)
{
	content = WBTB_rCode(content, 'javascript:', 'javascript :');
	//var RegExp = /<script[^>]*>(.|\n)*<\/script>/ig;
	//content = content.replace(RegExp, "<!-- Script Filtered -->");
	var RegExp = /<script[^>]*>/ig;
	content = content.replace(RegExp, "<!-- Script Filtered/n");
	RegExp = /<\/script>/ig;
	content = content.replace(RegExp, "/n-->");
	return content;
}

function WBTB_cleanHtml()
{
	var fonts = WBTB_Composition.document.body.all.tags("FONT");
	var curr;
	for (var i = fonts.length - 1; i >= 0; i--) {
		curr = fonts[i];
		if (curr.style.backgroundColor == "#ffffff") curr.outerHTML = curr.innerHTML;
	}
}

function WBTB_getPureHtml()
{
	var str = "";
	//var paras = WBTB_Composition.document.body.all.tags("P");
	//if (paras.length > 0){
	//  for	(var i=paras.length-1; i >= 0; i--) str= paras[i].innerHTML + "\n" + str;
	//} else {
	str = WBTB_Composition.document.body.innerHTML;
	//}
	str=WBTB_correctUrl(str);
	return str;
}


function WBTB_correctUrl(cont)
{
	var url=location.href.substring(0,location.href.lastIndexOf("/")+1);
	cont=WBTB_rCode(cont,location.href+"#","#");
	cont=WBTB_rCode(cont,url,"");
	return cont;
}

var WBTB_bLoad=false
var WBTB_pureText=true
var WBTB_bTextMode=false

WBTB_public_description=new WBTB_Editor

function WBTB_Editor()
{
	this.put_HtmlMode=WBTB_setMode;
	this.put_value=WBTB_putText;
	this.get_value=WBTB_getText;
}

function WBTB_getText()
{
	if (WBTB_bTextMode)
		return WBTB_Composition.document.body.innerText;
	else
	{
		WBTB_cleanHtml();
		return WBTB_Composition.document.body.innerHTML;
	}
}

function WBTB_putText(v)
{
	if (WBTB_bTextMode)
		WBTB_Composition.document.body.innerText = v;
	else
		WBTB_Composition.document.body.innerHTML = v;
}

function WBTB_InitDocument(hiddenid, charset)
{	
	if (charset!=null)
		WBTB_charset=charset;
	var WBTB_bodyTag="<html><head><style type=text/css>.quote{margin:5px 20px;border:1px solid #CCCCCC;padding:5px; background:#F3F3F3 }\nbody{boder:0px}</style></head><BODY bgcolor=\"#FFFFFF\" >";
	var editor=WBTB_Composition;
	var h=document.getElementById(hiddenid);
	editor.document.designMode="On"
	editor.document.open();
	editor.document.write(WBTB_bodyTag);
	if (h.value!="")
	{
		editor.document.write(h.value);
	}
	editor.document.write("</html>");
	editor.document.close();
	editor.document.body.contentEditable = "True";
	editor.document.charset=WBTB_charset;
	
	WBTB_bLoad=true;
	WBTB_setStyle();
	//eval("WBTB_Composition.document.body.innerHTML+=(self.opener."+ htmlableID +".checked)?(self.opener."+bodyID+".value):(WBTB_ubb2html(self.opener."+ bodyID +".value))");
}


function WBTB_doSelectClick(str, el) {
	var Index = el.selectedIndex;
	if (Index != 0){
		el.selectedIndex = 0;
		WBTB_format(str,el.options[Index].value);
	}
}

var WBTB_bIsIE5 = (navigator.userAgent.indexOf("IE 5")  > -1) || (navigator.userAgent.indexOf("IE 6")  > -1);
var WBTB_edit;	//selectRang
var WBTB_RangeType;
var WBTB_selection;

//应用html
function WBTB_specialtype(Mark1, Mark2){
	var strHTML;
	if (WBTB_bIsIE5) WBTB_selectRange();
	if (WBTB_RangeType == "Text"){
		if (Mark2==null)
		{
			strHTML = "<" + Mark1 + ">" + WBTB_edit.htmlText + "</" + Mark1 + ">"; 
		}else{
			strHTML = Mark1 + WBTB_edit.htmlText +  Mark2; 
		}
		WBTB_edit.pasteHTML(strHTML);
		WBTB_Composition.focus();
		WBTB_edit.select();
	}		
}

//选择内容替换文本
function WBTB_InsertSymbol(str1)
{
	WBTB_Composition.focus();
	if (WBTB_bIsIE5) WBTB_selectRange();	
	WBTB_edit.pasteHTML(str1);
}


function WBTB_selectRange(){
	WBTB_selection = WBTB_Composition.document.selection;
	WBTB_edit = WBTB_Composition.document.selection.createRange();
	WBTB_RangeType =  WBTB_Composition.document.selection.type;
}

function WBTB_rCode(s,a,b,i){
	//s原字串，a要换掉pattern，b换成字串，i是否区分大小写
	a = a.replace("?","\\?");
	if (i==null)
	{
		var r = new RegExp(a,"gi");
	}else if (i) {
		var r = new RegExp(a,"g");
	}
	else{
		var r = new RegExp(a,"gi");
	}
	return s.replace(r,b); 
}


//提交数据到opener，已无用
/*
function WBTB_handin()
{
	if (!WBTB_validateMode()) return;
	var strHTMLbegin;
	var strHTMLend;
	strHTMLbegin = "";
	strHTMLend = "";
//	eval("self.opener."+bodyID+".value=strHTMLbegin + WBTB_getPureHtml(WBTB_Composition.document.body.innerHTML) + strHTMLend;self.opener."+htmlableID+".checked=true;");
	self.close();
}
*/

function WBTB_View()
{
	if (WBTB_bTextMode) {
		cont=WBTB_Composition.document.body.innerText;
	} else {
		cont=WBTB_Composition.document.body.innerHTML;
	}
	cont=WBTB_correctUrl(cont);
	bodyTag="<html><head><style type=text/css>.quote{margin:5px 20px;border:1px solid #CCCCCC;padding:5px; background:#F3F3F3 }\nbody{boder:0px; font-family:Arial; font-size:10.5pt}</style></head><BODY bgcolor=\"#FFFFFF\" >";
	if (WBTB_filterScript)
		cont=WBTB_FilterScript(cont);
	//cont=WBTB_rCode(cont,"\\[dvnews_ad]","<img src='wbTextBox/images/pic_ad.jpg' vspace=10 hspace=10 align=left border=1 title='Advertising'>");
	//cont=WBTB_rCode(cont,"\\[dvnews_page]","<br><br><hr size=2 width=95% align=left>&nbsp; <font color=red face='Tahoma,Arail' size=2><b>Next Page ...</b></font><br><hr size=2 width=95% align=left>");
	preWin=window.open('preview','','left=0,top=0,width=550,height=400,resizable=1,scrollbars=1, status=1, toolbar=1, menubar=0');
	preWin.document.open();
	preWin.document.write(bodyTag);
	preWin.document.write(cont);
	preWin.document.close();
	preWin.document.title="Preview";
	preWin.document.charset=WBTB_charset;
}


// 修改编辑栏高度
function WBTB_Size(num)
{
	var obj=document.all.WBTB_Container;
	if (parseInt(obj.height)+num>=300) {
		obj.height = parseInt(obj.height) + num;	
	}
	if (num>0)
	{
		obj.width="100%";	
	}
}

/*
function WBTB_ubbcode(){
	if (!WBTB_validateMode()) return;
	cont=WBTB_getPureHtml(WBTB_Composition.document.body.innerHTML);
	var aryCode0 = new Array("<strong>","[b]","</strong>","[/b]","<p","[p","</p>","[/p]","<a href=","[url=","</a>","[/url]");
	var aryCode1 = new Array("<em>","[i]","</em>","[/i]","<u>","[u]","</u>","[/u]","<ul>","[list]","</ul>","[/list]","<ol>","[list=1]","</ol>","[/list]");
	var aryCode2 = new Array("<li>","[*]","</li>","","<font color=","[color=","<font face=","[font=","<font size=","[size=");
	var aryCode9 = new Array(">","]","<","[","</","[/");
	var aryCode = aryCode0.concat(aryCode1).concat(aryCode2).concat(aryCode9);
	
	for (var i=0;i<aryCode.length;i+=2){
		cont=WBTB_rCode(cont,aryCode[i],aryCode[i+1]);	
	}
//	eval("self.opener."+bodyID+".value+=cont;");
	self.close();
}

function WBTB_ubb2html(str){
	if (str=="")
		return str;
	var aryCode0 = new Array("<br>","\n","<strong>","\\[b]","</strong>","\\[/b]","<p","\\[p","</p>","\\[/p]","<a href=","\\[url=","</a>","\\[/url]");
	var aryCode1 = new Array("<em>","\\[i]","</em>","\\[/i]","<u>","\\[u]","</u>","\\[/u]","<ul>","\\[list]","</ul>","\\[/list]","<ol>","\\[list=1]","</ol>","\\[/list]");
	var aryCode = aryCode0.concat(aryCode1);
	
	for (var i=0;i<aryCode.length;i+=2){
		str=WBTB_rCode(str,aryCode[i+1],aryCode[i]);	
	}
	return str;
}
*/

// 拷贝数据到hidden
function WBTB_CopyData(hiddenid)
{
	d = WBTB_Composition.document;
	if (WBTB_bTextMode)
	{
		cont=d.body.innerText;
	}else{
		cont=d.body.innerHTML;  
	}
	cont=WBTB_correctUrl(cont);
	if (WBTB_filterScript)
		cont=WBTB_FilterScript(cont);
	document.getElementById(hiddenid).value = cont;  
	if (document.getElementById(hiddenid).value == '<P>&nbsp;</P>')
	{
		document.getElementById(hiddenid).value = '';
	}
}

function WBTB_insert(cons)
{
	var WBTB_Composition;
	WBTB_Composition.document.body.innerHTML=cons;
}

function WBTB_help()
{
	showModalDialog("wbTextBox/help.html", "", "dialogWidth:13.5em; dialogHeight:12.5em; status:0; help:0");
}