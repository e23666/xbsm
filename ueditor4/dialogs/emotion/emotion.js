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


inforBox['tab0'] = ['Kiss','Love','Yeah','����','��Ť','��','����','88','��','�˯','³��','��ש','����','���տ���','��Ц','�ٲ���~','����','����','ɵЦ','������','��ŭ','����','���Գ�','����','?','��','ŭ','ʤ��','HI','KISS','��˵','��Ҫ','����','����','��','��','����','����','����','��ˮ','���','��','������', '������', '����', '����', '��ף', '������', '�ô�', '����', 'ʤ��', '����', '������', '̰��', 'ӭ��', '��', '΢Ц','����','��Ƥ','����','ˣ��','����','����','��ˮ','���','','����','��','��NB','�ε�','����','͵Ц','���','�κ�','̾��','����','??','����','��ʹ','����','����','����','��ɵ','������'];
inforBox['tab1'] = ['Kiss','Love','Yeah','����','��Ť','��','����','88','��','�˯','³��','��ש','����','���տ���','̯��','˯��','̱��','����','������','��ת','Ҳ����','����','��Music','ץǽ','ײǽ����','��ͷ','����','Ʈ��','������ש','������','������','������','ʲô��','תͷ','�Ұ�ţ��','����','ҡ��','����','��������','��'];
inforBox['tab2'] = ['��Ц','�ٲ���~','����','����','ɵЦ','������','��ŭ','�Ҵ���','money','����','����','��','ŭ','ʤ��','ί��','����','˵ɶ�أ�','����','��','�������','����','ѣ��','ħ��','������','˯��','�Ҵ�','����','��','������','ˢ��','����','ը��','����','�κ���','а���Ц','��Ҫ��Ҫ','������','�Ŵ���ϸ��','͵��','������','��','�ɿ���','����','����','����','��','��','��~','���һ�ӭ','����','���Գ�','?'];
inforBox['tab3'] = ['HI','KISS','��˵','��Ҫ','����','����','��','��','����','����','����','��ˮ','���','��','����','����','����','����','ϲ��','��ת','�ټ�','ץ��','��','����','��','��Ѫ','��','����','����','����','����','��To','�Ի�','��������','�����','������','����','����','�ͳ�','����','ƻ��','��','','ɧ��','����','˯','������','ͱͱ','�赹','������','��Ľ','ҡ','ҡ��','��ˣ','�в�','��Ź','������','��','����','ŷ��','Ż��','��','��̵'];
inforBox['tab4'] = ['������', '������', '����', '����', '��ף', '������', '�ô�', '����', 'ʤ��', '����', '������', '̰��', 'ӭ��', '��', '��', '����', '����', '��', '�ͻ�', 'ѡ��'];
inforBox['tab5'] = ['΢Ц','����','��Ƥ','����','ˣ��','����','����','��ˮ','���','����','����','��','�佱','�ε�','����','ý��','����','����','����','����','','����','����','õ��','����','��','��Ц','�ɰ�','����','����','����','��������','��','��','����','����','��ˮ','�ʺ�','ҹ��','̫��','ǮǮ','����','����','����','����','��','ʤ��','��','����','OK'];
inforBox['tab6'] = ['�ж�','Ů��','����','�Թ�','͵Ц','��Ц','����','���','����','�κ�','̾��','����','ί��','����','??','����','����','��ʹ','����','����','����','��ˮ','�ᱼ','��ɵ','����ͷ','��ͷ','������','��ת','����','����','��','����','�ټ�','��ӭ����','��ϲ����','�Ե�','������','ˡ�����','�ⷿ�л�','����·��'];

//�����
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
    //��ȡ����Ԫ�ؾ������
    var tabMenu = $G("tabMenu").getElementsByTagName("div"),
        tabContent = $G("tabContent").getElementsByTagName("div"),
        i = 0,L = tabMenu.length;
    //�������г���Ԫ��
    for (; i < L; i++) {
        tabMenu[i].className = "";
        tabContent[i].style.display = "none";
    }
    //��ʾ��Ӧ����Ԫ��
    tabMenu[index].className = "on";
    tabContent[index].style.display = "block";
}
function createTab(tabName) {
    var faceVersion = "?v=1.1",//�汾��
        tab = $G(tabName),//��ȡ��Ҫ���ɵ�Div���
        imagePath = sBasePath + FaceHandler.imageFolders[tabName],//��ȡ��ʾ�����Ԥ�������·��
        imageColsNum = FaceHandler.imageCols[tabName],//ÿ����ʾ�ı������
        positionLine = imageColsNum / 2,//�м���
        iWidth = iHeight = FaceHandler.imageWidth[tabName],//ͼƬ����
        iColWidth = FaceHandler.imageColWidth[tabName],//���ʣ��ռ����ʾ����
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
