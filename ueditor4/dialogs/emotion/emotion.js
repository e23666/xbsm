function initImgBox(box, str, len) {
    if (box.length)return;
    var tmpStr = "",i = 1;
    for (; i <= len; i++) {
        tmpStr = str;
        if (i < 10)tmpStr = tmpStr + '0';
        tmpStr = tmpStr + i + '.gif';
        box.push(tmpStr);
    }
}
function $G(id) {
    return document.getElementById(id)
}
function InsertSmiley(url) {
    var obj = {
        src:editor.options.emotionLocalization ? editor.options.UEDITOR_HOME_URL + "dialogs/emotion/" + url : url
    };
    obj.data_ue_src = obj.src;
    editor.execCommand('insertimage', obj);
    dialog.popup.hide();
}

function over(td, srcPath, posFlag) {
    td.style.backgroundColor = "#ACCD3C";
    $G('faceReview').style.backgroundImage = "url(" + srcPath + ")";
    if (posFlag == 1) $G("tabIconReview").className = "show";
    $G("tabIconReview").style.display = 'block';
}
function out(td) {
    td.style.backgroundColor = "#FFFFFF";
    var tabIconRevew = $G("tabIconReview");
    tabIconRevew.className = "";
    tabIconRevew.style.display = 'none';
}
var emotion = {};
emotion.SmileyPath = editor.options.emotionLocalization ? 'images/' : "http://img.baidu.com/hi/";
emotion.SmileyBox = {tab0:[],tab1:[],tab2:[],tab3:[],tab4:[],tab5:[],tab6:[]};
emotion.SmileyInfor = {tab0:[],tab1:[],tab2:[],tab3:[],tab4:[],tab5:[],tab6:[]};
var faceBox = emotion.SmileyBox;
var inforBox = emotion.SmileyInfor;
var sBasePath = emotion.SmileyPath;
if (editor.options.emotionLocalization) {
    initImgBox(faceBox['tab0'], 'j_00', 84);
    initImgBox(faceBox['tab1'], 't_00', 40);
    initImgBox(faceBox['tab2'], 'l_00', 52);
    initImgBox(faceBox['tab3'], 'b_00', 63);
    initImgBox(faceBox['tab4'], 'bc_00', 20);
    initImgBox(faceBox['tab5'], 'f_00', 50);
    initImgBox(faceBox['tab6'], 'y_00', 40);
} else {
    initImgBox(faceBox['tab0'], 'j_00', 84);
    initImgBox(faceBox['tab1'], 't_00', 40);
    initImgBox(faceBox['tab2'], 'w_00', 52);
    initImgBox(faceBox['tab3'], 'B_00', 63);
    initImgBox(faceBox['tab4'], 'C_00', 20);
    initImgBox(faceBox['tab5'], 'i_f', 50);
    initImgBox(faceBox['tab6'], 'y_00', 40);
}


inforBox['tab0'] = ['Kiss','Love','Yeah','°¡£¡','±³Å¤','¶¥','¶¶ÐØ','88','º¹','î§Ë¯','Â³À­','ÅÄ×©','ÈàÁ³','ÉúÈÕ¿ìÀÖ','´óÐ¦','ÆÙ²¼º¹~','¾ªÑÈ','³ôÃÀ','ÉµÐ¦','Å×ÃÄÑÛ','·¢Å­','´ò½´ÓÍ','¸©ÎÔ³Å','Æø·ß','?','ÎÇ','Å­','Ê¤Àû','HI','KISS','²»Ëµ','²»Òª','³¶»¨','´óÐÄ','¶¥','´ó¾ª','·ÉÎÇ','¹íÁ³','º¦Ðß','¿ÚË®','¿ñ¿Þ','À´','·¢²ÆÁË', '³ÔÎ÷¹Ï', 'Ì×ÀÎ', 'º¦Ðß', 'Çì×£', 'ÎÒÀ´ÁË', 'ÇÃ´ò', 'ÔÎÁË', 'Ê¤Àû', '³ôÃÀ', '±»´òÁË', 'Ì°³Ô', 'Ó­½Ó', '¿á', 'Î¢Ð¦','Ç×ÎÇ','µ÷Æ¤','¾ª¿Ö','Ë£¿á','·¢»ð','º¦Ðß','º¹Ë®','´ó¿Þ','','¼ÓÓÍ','À§','ÄãNB','ÔÎµ¹','¿ªÐÄ','ÍµÐ¦','´ó¿Þ','µÎº¹','Ì¾Æø','³¬ÔÞ','??','·ÉÎÇ','ÌìÊ¹','Èö»¨','ÉúÆø','±»ÔÒ','ÏÅÉµ','ËæÒâÍÂ'];
inforBox['tab1'] = ['Kiss','Love','Yeah','°¡£¡','±³Å¤','¶¥','¶¶ÐØ','88','º¹','î§Ë¯','Â³À­','ÅÄ×©','ÈàÁ³','ÉúÈÕ¿ìÀÖ','Ì¯ÊÖ','Ë¯¾õ','Ì±×ø','ÎÞÁÄ','ÐÇÐÇÉÁ','Ðý×ª','Ò²²»ÐÐ','ÓôÃÆ','ÕýMusic','×¥Ç½','×²Ç½ÖÁËÀ','ÍáÍ·','´ÁÑÛ','Æ®¹ý','»¥ÏàÅÄ×©','¿³ËÀÄã','ÈÓ×À×Ó','ÉÙÁÖËÂ','Ê²Ã´£¿','×ªÍ·','ÎÒ°®Å£ÄÌ','ÎÒÌß','Ò¡»Î','ÔÎØÊ','ÔÚÁý×ÓÀï','Õðµ´'];
inforBox['tab2'] = ['´óÐ¦','ÆÙ²¼º¹~','¾ªÑÈ','³ôÃÀ','ÉµÐ¦','Å×ÃÄÑÛ','·¢Å­','ÎÒ´íÁË','money','Æø·ß','Ìô¶º','ÎÇ','Å­','Ê¤Àû','Î¯Çü','ÊÜÉË','ËµÉ¶ÄØ£¿','±Õ×ì','²»','¶ºÄãÍæ¶ù','·ÉÎÇ','Ñ£ÔÎ','Ä§·¨','ÎÒÀ´ÁË','Ë¯ÁË','ÎÒ´ò','±Õ×ì','´ò','´òÔÎÁË','Ë¢ÑÀ','±¬×á','Õ¨µ¯','µ¹Á¢','¹Îºú×Ó','Ð°¶ñµÄÐ¦','²»Òª²»Òª','°®ÁµÖÐ','·Å´ó×ÐÏ¸¿´','Íµ¿ú','³¬¸ßÐË','ÔÎ','ËÉ¿ÚÆø','ÎÒÅÜ','ÏíÊÜ','ÐÞÑø','¿Þ','º¹','°¡~','ÈÈÁÒ»¶Ó­','´ò½´ÓÍ','¸©ÎÔ³Å','?'];
inforBox['tab3'] = ['HI','KISS','²»Ëµ','²»Òª','³¶»¨','´óÐÄ','¶¥','´ó¾ª','·ÉÎÇ','¹íÁ³','º¦Ðß','¿ÚË®','¿ñ¿Þ','À´','ÀáÑÛ','Á÷Àá','ÉúÆø','ÍÂÉà','Ï²»¶','Ðý×ª','ÔÙ¼û','×¥¿ñ','º¹','±ÉÊÓ','°Ý','ÍÂÑª','Ðê','´òÈË','±ÄÌø','±äÁ³','³¶Èâ','³ÔTo','³Ô»¨','´µÅÝÅÝÌÇ','´ó±äÉí','·ÉÌìÎè','»Øíø','¿ÉÁ¯','ÃÍ³é','ÅÝÅÝ','Æ»¹û','Ç×','','É§Îè','ÉÕÏã','Ë¯','Ì×ÍÞÍÞ','Í±Í±','Îèµ¹','Î÷ºìÊÁ','°®Ä½','Ò¡','Ò¡°Ú','ÔÓË£','ÕÐ²Æ','±»Å¹','±»ÇòÃÆ','´ó¾ª','ÀíÏë','Å·´ò','Å»ÍÂ','Ëé','ÍÂÌµ'];
inforBox['tab4'] = ['·¢²ÆÁË', '³ÔÎ÷¹Ï', 'Ì×ÀÎ', 'º¦Ðß', 'Çì×£', 'ÎÒÀ´ÁË', 'ÇÃ´ò', 'ÔÎÁË', 'Ê¤Àû', '³ôÃÀ', '±»´òÁË', 'Ì°³Ô', 'Ó­½Ó', '¿á', '¶¥', 'ÐÒÔË', '°®ÐÄ', '¶ã', 'ËÍ»¨', 'Ñ¡Ôñ'];
inforBox['tab5'] = ['Î¢Ð¦','Ç×ÎÇ','µ÷Æ¤','¾ªÑÈ','Ë£¿á','·¢»ð','º¦Ðß','º¹Ë®','´ó¿Þ','µÃÒâ','±ÉÊÓ','À§','¿ä½±','ÔÎµ¹','ÒÉÎÊ','Ã½ÆÅ','¿ñÍÂ','ÇàÍÜ','·¢³î','Ç×ÎÇ','','°®ÐÄ','ÐÄËé','Ãµ¹å','ÀñÎï','¿Þ','¼éÐ¦','¿É°®','µÃÒâ','ßÚÑÀ','±©º¹','³þ³þ¿ÉÁ¯','À§','¿Þ','ÉúÆø','¾ªÑÈ','¿ÚË®','²Êºç','Ò¹¿Õ','Ì«Ñô','Ç®Ç®','µÆÅÝ','¿§·È','µ°¸â','ÒôÀÖ','°®','Ê¤Àû','ÔÞ','±ÉÊÓ','OK'];
inforBox['tab6'] = ['ÄÐ¶µ','Å®¶µ','¿ªÐÄ','¹Ô¹Ô','ÍµÐ¦','´óÐ¦','³éÆü','´ó¿Þ','ÎÞÄÎ','µÎº¹','Ì¾Æø','¿ñÔÎ','Î¯Çü','³¬ÔÞ','??','ÒÉÎÊ','·ÉÎÇ','ÌìÊ¹','Èö»¨','ÉúÆø','±»ÔÒ','¿ÚË®','Àá±¼','ÏÅÉµ','ÍÂÉàÍ·','µãÍ·','ËæÒâÍÂ','Ðý×ª','À§À§','±ÉÊÓ','¿ñ¶¥','ÀºÇò','ÔÙ¼û','»¶Ó­¹âÁÙ','¹§Ï²·¢²Æ','ÉÔµÈ','ÎÒÔÚÏß','Ë¡²»Òé¼Û','¿â·¿ÓÐ»õ','»õÔÚÂ·ÉÏ'];

//´ó¶ÔÏó
FaceHandler = {
    imageFolders:{    tab0:'jx2/',tab1:'tsj/',tab2:'ldw/',tab3:'bobo/',tab4:'babycat/',tab5:'face/',tab6:'youa/'},
    imageWidth:{tab0:35,tab1:35,tab2:35,tab3:35,tab4:35,tab5:35,tab6:35},
    imageCols:{tab0:11,tab1:11,tab2:11,tab3:11,tab4:11,tab5:11,tab6:11},
    imageColWidth:{tab0:3,tab1:3,tab2:3,tab3:3,tab4:3,tab5:3,tab6:3},
    imageCss:{tab0:'jd',tab1:'tsj',tab2:'ldw',tab3:'bb',tab4:'cat',tab5:'pp',tab6:'youa'},
    imageCssOffset:{tab0:35,tab1:35,tab2:35,tab3:35,tab4:35,tab5:25,tab6:35},
    tabExist:[0,0,0,0,0,0,0]
};
function switchTab(index) {
    if (FaceHandler.tabExist[index] == 0) {
        FaceHandler.tabExist[index] = 1;
        createTab('tab' + index);
    }
    //»ñÈ¡³ÊÏÖÔªËØ¾ä±úÊý×é
    var tabMenu = $G("tabMenu").getElementsByTagName("div"),
        tabContent = $G("tabContent").getElementsByTagName("div"),
        i = 0,L = tabMenu.length;
    //Òþ²ØËùÓÐ³ÊÏÖÔªËØ
    for (; i < L; i++) {
        tabMenu[i].className = "";
        tabContent[i].style.display = "none";
    }
    //ÏÔÊ¾¶ÔÓ¦³ÊÏÖÔªËØ
    tabMenu[index].className = "on";
    tabContent[index].style.display = "block";
}
function createTab(tabName) {
    var faceVersion = "?v=1.1",//°æ±¾ºÅ
        tab = $G(tabName),//»ñÈ¡½«ÒªÉú³ÉµÄDiv¾ä±ú
        imagePath = sBasePath + FaceHandler.imageFolders[tabName],//»ñÈ¡ÏÔÊ¾±íÇéºÍÔ¤ÀÀ±íÇéµÄÂ·¾¶
        imageColsNum = FaceHandler.imageCols[tabName],//Ã¿ÐÐÏÔÊ¾µÄ±íÇé¸öÊý
        positionLine = imageColsNum / 2,//ÖÐ¼äÊý
        iWidth = iHeight = FaceHandler.imageWidth[tabName],//Í¼Æ¬³¤¿í
        iColWidth = FaceHandler.imageColWidth[tabName],//±í¸ñÊ£Óà¿Õ¼äµÄÏÔÊ¾±ÈÀý
        tableCss = FaceHandler.imageCss[tabName],
        cssOffset = FaceHandler.imageCssOffset[tabName],
        textHTML = ['<table class="smileytable" cellpadding="1" cellspacing="0" align="center" style="border-collapse:collapse;" border="1" bordercolor="#BAC498" width="100%">'],
        i = 0,imgNum = faceBox[tabName].length,imgColNum = FaceHandler.imageCols[tabName],faceImage,
        sUrl,realUrl,posflag,offset,infor;
    for (; i < imgNum;) {
        textHTML.push('<tr>');
        for (var j = 0; j < imgColNum; j++,i++) {
            faceImage = faceBox[tabName][i];
            if (faceImage) {
                sUrl = imagePath + faceImage + faceVersion;
                realUrl = imagePath + faceImage;
                posflag = j < positionLine ? 0 : 1;
                offset = cssOffset * i * (-1) - 1;
                infor = inforBox[tabName][i];
                textHTML.push('<td  class="' + tableCss + '"   border="1" width="' + iColWidth + '%" style="border-collapse:collapse;" align="center"  bgcolor="#FFFFFF" onclick="InsertSmiley(\'' + realUrl.replace(/'/g, "\\'") + '\')" onmouseover="over(this,\'' + sUrl + '\',\'' + posflag + '\')" onmouseout="out(this)">');
                textHTML.push('<span  style="display:block;">');
                textHTML.push('<img  style="background-position:left ' + offset + 'px;" title="' + infor + '" src="' + sBasePath + (editor.options.emotionLocalization ? '0.gif" width="' : 'default/0.gif" width="') + iWidth + '" height="' + iHeight + '"></img>');
                textHTML.push('</span>');
            } else {
                textHTML.push('<td width="' + iColWidth + '%"   bgcolor="#FFFFFF">');
            }
            textHTML.push('</td>');
        }
        textHTML.push('</tr>');
    }
    textHTML.push('</table>');
    textHTML = textHTML.join("");
    tab.innerHTML = textHTML;
}
var tabIndex = 0;//getDialogInstance()?(getDialogInstance().smileyTabId?getDialogInstance().smileyTabId:0):0;
switchTab(tabIndex);
$G("tabIconReview").style.display = 'none';
