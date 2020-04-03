var Quote = 0;
var Bold  = 0;
var Italic = 0;
var Underline = 0;
var Code = 0;
var Center = 0;
var Strike = 0;
var Sound = 0;
var Swf = 0;
var Ra = 0;
var Rm = 0;
var Marquee = 0;
var Fly = 0;
var fanzi=0;
var text_enter_url      = "请输入连接网址";
var text_enter_txt      = "请输入连接说明";
var text_enter_image    = "请输入图片网址";
var text_enter_sound    = "请输入声音文件网址";
var text_enter_swf      = "请输入FLASH动画网址";
var text_enter_ra      = "请输入Real音乐相对路径";
var text_enter_rm      = "请输入Real影片相对路径";
var text_enter_wmv      = "请输入Media影片相对路径";
var text_enter_wma      = "请输入Media音乐相对路径";
var text_enter_mov      = "请输入QuickTime音乐网址";
var text_enter_sw      = "请输入shockwave音乐网址";
var text_enter_email    = "请输入邮件网址";
var error_no_url        = "您必须输入网址";
var error_no_txt        = "您必须连接说明";
var error_no_title      = "您必须输入首页标题";
var error_no_email      = "您必须输入邮件网址";
var error_no_gset       = "必须正确按照各式输入！";
var error_no_gtxt       = "必须输入文字！";
var text_enter_guang1   = "文字的长度、颜色和边界大小";
var text_enter_guang2   = "要产生效果的文字！";
function commentWrite(NewCode) {
document.form1.content.value+=NewCode;
document.form1.content.focus();
return;
}
function storeCaret(text) { 
	if (text.createTextRange) {
		text.caretPos = document.selection.createRange().duplicate();
	}
        if(event.ctrlKey && window.event.keyCode==13){i++;if (i>1) {alert('帖子正在发出，请耐心等待！');return false;}this.document.form.submit();}
}
function AddText(text) {
	if (document.form1.content.createTextRange && document.form1.content.caretPos) {      
		var caretPos = document.form1.content.caretPos;      
		caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == ' ' ?
		text + ' ' : text;
	}
	else document.form1.content.value += text;
	document.form1.content.focus(caretPos);
}
function inputs(str)
{
AddText(str);
}
function Curl() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_url, "http://");
var enterTxT   = prompt(text_enter_txt, enterURL);
if (!enterURL)    {
FoundErrors += "\n" + error_no_url;
}
if (!enterTxT)    {
FoundErrors += "\n" + error_no_txt;
}
if (FoundErrors)  {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[URL="+enterURL+"]"+enterTxT+"[/URL]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cimage() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_image, "http://");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[IMG]"+enterURL+"[/IMG]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cemail() {
var emailAddress = prompt(text_enter_email,"");
if (!emailAddress) { alert(error_no_email); return; }
var ToAdd = "[EMAIL]"+emailAddress+"[/EMAIL]";
commentWrite(ToAdd);
}
function Ccode() {
if (Code == 0) {
ToAdd = "[CODE]";
document.form.code.value = " 代码*";
Code = 1;
} else {
ToAdd = "[/CODE]";
document.form.code.value = " 代码 ";
Code = 0;
}
commentWrite(ToAdd);
}
function Cquote() {
fontbegin="[QUOTE]";
fontend="[/QUOTE]";
fontchuli();
}
function Cbold() {
fontbegin="[B]";
fontend="[/B]";
fontchuli();
}
function Citalic() {
fontbegin="[I]";
fontend="[/I]";
fontchuli();
}
function Cunder() {
fontbegin="[U]";
fontend="[/U]";
fontchuli();
}
function Ccenter() {
fontbegin="[center]";
fontend="[/center]";
fontchuli();
}
function Cstrike() {
fontbegin="[strike]";
fontend="[/strike]";
fontchuli();
}
function Csound() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_sound, "http://");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[SOUND]"+enterURL+"[/SOUND]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}

function Cswf() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_swf, "http://");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[FLASH]"+enterURL+"[/FLASH]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cra() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_ra, "rm/");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[RA]"+enterURL+"[/RA]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Crm() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_rm, "rm/");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[RM=500,350]"+enterURL+"[/RM]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cwmv() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_wmv, "mpg/");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[MP=500,350]"+enterURL+"[/MP]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}

function Cfanzi() {
fontbegin="[xray]";
fontend="[/xray]";
fontchuli();
}

function Cwma() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_wma, "mpg/");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[wma]"+enterURL+"[/wma]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cmov() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_mov, "mpg/");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[QT=500,350]"+enterURL+"[/QT]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cdir() {
var FoundErrors = '';
var enterURL   = prompt(text_enter_sw, "http://");
if (!enterURL) {
FoundErrors += "\n" + error_no_url;
}
if (FoundErrors) {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[DIR=500,350]"+enterURL+"[/DIR]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}
function Cmarquee() {
fontbegin="[move]";
fontend="[/move]";
fontchuli();
}
function Cfly() {
fontbegin="[fly]";
fontend="[/fly]";
fontchuli();
}

function paste(text) {
	if (opener.document.form1.content.createTextRange && opener.document.form1.content.caretPos) {      
		var caretPos = opener.document.form1.content.caretPos;      
		caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == ' ' ?
		text + ' ' : text;
	}
	else opener.document.form1.content.value += text;
	opener.document.form1.content.focus(caretPos);
}

function showsize(size){
fontbegin="[size="+size+"]";
fontend="[/size]";
fontchuli();
}

function showfont(font){
fontbegin="[face="+font+"]";
fontend="[/face]";
fontchuli();
}

function showcolor(color){
fontbegin="[color="+color+"]";
fontend="[/color]";
fontchuli();
}

function fontchuli(){
if ((document.selection)&&(document.selection.type == "Text")) {
var range = document.selection.createRange();
var ch_text=range.text;
range.text = fontbegin + ch_text + fontend;
} 
else {
document.form1.content.value=fontbegin+document.form1.content.value+fontend;
document.form1.content.focus();
}
}

function Cguang() {
var FoundErrors = '';
var enterSET   = prompt(text_enter_guang1, "255,red,2");
var enterTxT   = prompt(text_enter_guang2, "文字");
if (!enterSET)    {
FoundErrors += "\n" + error_no_gset;
}
if (!enterTxT)    {
FoundErrors += "\n" + error_no_gtxt;
}
if (FoundErrors)  {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[glow="+enterSET+"]"+enterTxT+"[/glow]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}

function Cying() {
var FoundErrors = '';
var enterSET   = prompt(text_enter_guang1, "255,blue,1");
var enterTxT   = prompt(text_enter_guang2, "文字");
if (!enterSET)    {
FoundErrors += "\n" + error_no_gset;
}
if (!enterTxT)    {
FoundErrors += "\n" + error_no_gtxt;
}
if (FoundErrors)  {
alert("错误！"+FoundErrors);
return;
}
var ToAdd = "[SHADOW="+enterSET+"]"+enterTxT+"[/SHADOW]";
document.form1.content.value+=ToAdd;
document.form1.content.focus();
}

ie = (document.all)? true:false
if (ie){
function ctlent(eventobject){if(event.ctrlKey && window.event.keyCode==13){this.document.form1.submit();}}
}
function DoTitle(addTitle) { 
var revisedTitle; 
var currentTitle = document.form1.subject.value; 
revisedTitle = currentTitle+addTitle; 
document.form1.subject.value=revisedTitle; 
document.form1.subject.focus(); 
return; }

function insertsmilie(smilieface){

	document.form1.content.value+=smilieface;
}