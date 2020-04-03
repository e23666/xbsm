/**
 *  ueditor����������
 *  �������������������༭��������
 */

(function () {
    //������������ó�ueditorĿ¼������վ�����Ŀ¼֮������·�����߾���·����ָ��http��ͷ�ľ���·����
    //window.UEDITOR_HOME_URL�������ⲿ���ã�����Ͳ���������
    //������������ж��ҳ��ʹ��ͬһĿ¼�µ�editor,��Ϊ·����ͬ��������ʹ��editor��ҳ�����������·��д�����js���
    //var URL = window.UEDITOR_HOME_URL || '../';
    var tmp = window.location.pathname,
	URL = "/ueditor4/";				//�༭�����·��
    UEDITOR_CONFIG = {
        imagePath:"", //ͼƬ�ļ������ڵ�·����������ʾʱ������̨���ص�ͼƬurl������ͼƬ����·����Ҫ�ں�̨���á���important
        compressSide:0,                   //�ȱ�ѹ���Ļ�׼��ȷ��maxImageSideLength�����Ĳ��ն���0Ϊ������ߣ�1Ϊ���տ�ȣ�2Ϊ���ո߶�
        maxImageSideLength:900,          //�ϴ�ͼƬ�������ı߳����������Զ��ȱ�����,�����ž�����һ���Ƚϴ��ֵ
        relativePath:true,                //�Ƿ������·��������״̬�����б���ͼƬ��·�����������·����ʽ���б���.ǿ�ҽ��鿪����

        filePath:URL + "server/upload/",  //�����ļ��б���·��
	    catchRemoteImageEnable:true,                                   //�Ƿ���Զ��ͼƬץȡ
        catcherUrl:URL +"server/getRemoteImage_x.phx",             //����Զ��ͼƬץȡ�ĵ�ַ
        localDomain:"baidu.com",                                        //���ض���������������Զ��ͼƬץȡʱ������֮����������������µ�ͼƬ������ץȡ������
	    imageManagerPath:URL + "server/imageManager_x.phx",       //ͼƬ��������Ĵ����ַ
        UEDITOR_HOME_URL:URL,                                          //Ϊeditor���һ��ȫ��·��
        //�������ϵ����еĹ��ܰ�ť�������򣬿�����new�༭����ʵ��ʱѡ���Լ���Ҫ�Ĵ��¶���
        toolbars:[
            ['FullScreen', 'Source', '|', 'Undo', 'Redo', '|',
                'Bold', 'Italic', 'Underline', 'StrikeThrough', 'Superscript', 'Subscript', 'RemoveFormat', 'FormatMatch','AutoTypeSet', '|',
                'BlockQuote', '|', 'PastePlain', '|', 'ForeColor', 'BackColor', 'InsertOrderedList', 'InsertUnorderedList','SelectAll', 'ClearDoc', '|', 'CustomStyle',
                'Paragraph', '|','RowSpacingTop', 'RowSpacingBottom','LineHeight', '|','FontFamily', 'FontSize', '|',
                'DirectionalityLtr', 'DirectionalityRtl', '|', '', 'Indent', '|',
                'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyJustify', '|',
                'Link', 'Unlink', 'Anchor', '|', 'ImageNone', 'ImageLeft', 'ImageRight', 'ImageCenter', '|', 'InsertImage', 'Emotion', 'InsertVideo', 'Attachment', 'Map', 'GMap', 'InsertFrame', 'PageBreak', 'HighlightCode', '|',
                'Horizontal', 'Date', 'Time', 'Spechars','SnapScreen', 'WordImage', '|',
                'InsertTable', 'DeleteTable', 'InsertParagraphBeforeTable', 'InsertRow', 'DeleteRow', 'InsertCol', 'DeleteCol', 'MergeCells', 'MergeRight', 'MergeDown', 'SplittoCells', 'SplittoRows', 'SplittoCols', '|',
                 'Print', 'Preview', 'SearchReplace','Help']
        ],
        //�������ڹ�������ʱ��ʾ��tooltip��ʾ
        labelMap:{
            'anchor':'ê��', 'undo':'����', 'redo':'����', 'bold':'�Ӵ�', 'indent':'��������','snapscreen': '��ͼ',
            'italic':'б��', 'underline':'�»���', 'strikethrough':'ɾ����', 'subscript':'�±�',
            'superscript':'�ϱ�', 'formatmatch':'��ʽˢ', 'source':'Դ����', 'blockquote':'����',
            'pasteplain':'���ı�ճ��ģʽ', 'selectall':'ȫѡ', 'print':'��ӡ', 'preview':'Ԥ��',
            'horizontal':'�ָ���', 'removeformat':'�����ʽ', 'time':'ʱ��', 'date':'����',
            'unlink':'ȡ������', 'insertrow':'ǰ������', 'insertcol':'ǰ������', 'mergeright':'�Һϲ���Ԫ��', 'mergedown':'�ºϲ���Ԫ��',
            'deleterow':'ɾ����', 'deletecol':'ɾ����', 'splittorows':'��ֳ���', 'splittocols':'��ֳ���', 'splittocells':'��ȫ��ֵ�Ԫ��',
            'mergecells':'�ϲ������Ԫ��', 'deletetable':'ɾ�����', 'insertparagraphbeforetable':'���ǰ����', 'cleardoc':'����ĵ�',
            'fontfamily':'����', 'fontsize':'�ֺ�', 'paragraph':'�����ʽ', 'insertimage':'ͼƬ', 'inserttable':'���', 'link':'������',
            'emotion':'����', 'spechars':'�����ַ�', 'searchreplace':'��ѯ�滻', 'map':'Baidu��ͼ', 'gmap':'Google��ͼ',
            'insertvideo':'��Ƶ', 'help':'����', 'justifyleft':'�������', 'justifyright':'���Ҷ���', 'justifycenter':'���ж���',
            'justifyjustify':'���˶���', 'forecolor':'������ɫ', 'backcolor':'����ɫ', 'insertorderedlist':'�����б�',
            'insertunorderedlist':'�����б�', 'fullscreen':'ȫ��', 'directionalityltr':'������������', 'directionalityrtl':'������������',
            'RowSpacingTop':'��ǰ��', 'RowSpacingBottom':'�κ��','highlightcode':'�������', 'pagebreak':'��ҳ', 'insertframe':'����Iframe', 'imagenone':'Ĭ��',
            'imageleft':'�󸡶�', 'imageright':'�Ҹ���','attachment':'����', 'imagecenter':'����', 'wordimage':'ͼƬת��',
            'lineheight':'�м��', 'customstyle':'�Զ������','autotypeset': '�Զ��Ű�'
        },
        //dialog���ݵ�·�� ���ᱻ�滻��URL
        iframeUrlMap:{
            'anchor':'~/dialogs/anchor/anchor.html',
            'insertimage':'~/dialogs/image/image.html',
            'inserttable':'~/dialogs/table/table.html',
            'link':'~/dialogs/link/link.html',
            'spechars':'~/dialogs/spechars/spechars.html',
            'searchreplace':'~/dialogs/searchreplace/searchreplace.html',
            'map':'~/dialogs/map/map.html',
            'gmap':'~/dialogs/gmap/gmap.html',
            'insertvideo':'~/dialogs/video/video.html',
            'help':'~/dialogs/help/help.html',
            'highlightcode':'~/dialogs/code/code.html',
            'emotion':'~/dialogs/emotion/emotion.html',
            'wordimage':'~/dialogs/wordimage/wordimage.html',
            'attachment':'~/dialogs/attachment/attachment.html',
            'insertframe':'~/dialogs/insertframe/insertframe.html',
            'edittd':'~/dialogs/table/edittd.html',
            'snapscreen': '~/dialogs/snapscreen/snapscreen.html'
        },
        //���еĵ���������ʾ������
        listMap:{
            //����
            'fontfamily':['����', '����', '����', '����', 'andale mono', 'arial', 'arial black', 'comic sans ms', 'impact', 'times new roman'],
            //�ֺ�
            'fontsize':[10, 11, 12, 14, 16, 18, 20, 24, 36],
            //�����ʽ ֵ:��ʾ������
            'paragraph':['p:����', 'h1:���� 1', 'h2:���� 2', 'h3:���� 3', 'h4:���� 4', 'h5:���� 5', 'h6:���� 6'],
            //�μ�� ֵ����ʾ��������ͬ
            'rowspacing':['5', '10', '15', '20', '25'],
            //���ڼ�� ֵ����ʾ��������ͬ
            'lineheight':['1', '1.5','1.75','2', '3', '4', '5'],
            //block��Ԫ�����������ö�����߼����õģ�inline��Ԫ������BIU���߼�����
            //����ʹ��һЩ���õı�ǩ
            //����˵��
            //tag ʹ�õı�ǩ����
            //label ��ʾ������Ҳ��������ʶ��ͬ���͵ı�ʶ����ע�����ֵÿ��Ҫ��ͬ��
            //style ��ӵ���ʽ
            //ÿһ���������һ���Զ������ʽ
            'customstyle':[
                {tag:'h1', label:'���б���', style:'border-bottom:#ccc 2px solid;padding:0 4px 0 0;text-align:center;margin:0 0 20px 0;'},
                {tag:'h1', label:'�������', style:'border-bottom:#ccc 2px solid;padding:0 4px 0 0;margin:0 0 10px 0;'},
                {tag:'span', label:'ǿ��', style:'font-style:italic;font-weight:bold;color:#000'},
                {tag:'span', label:'����ǿ��', style:'font-style:italic;font-weight:bold;color:rgb(51, 153, 204)'}
            ]
        },
        //�����Ӧ��styleֵ
        fontMap:{
            '����':['����', 'SimSun'],
            '����':['����', '����_GB2312', 'SimKai'],
            '����':['����', 'SimHei'],
            '����':['����', 'SimLi'],
            'andale mono':['andale mono'],
            'arial':['arial', 'helvetica', 'sans-serif'],
            'arial black':['arial black', 'avant garde'],
            'comic sans ms':['comic sans ms'],
            'impact':['impact', 'chicago'],
            'times new roman':['times new roman']
        },
        //�������Ҽ��˵�������
        contextMenu:[
            {
                label:'ɾ��',
                cmdName:'delete'

            },
            {
                label:'ȫѡ',
                cmdName:'selectall'

            },
            {
                label:'ɾ������',
                cmdName:'highlightcode',
                icon:'deletehighlightcode'

            },
            {
                label:'����ĵ�',
                cmdName:'cleardoc',
                exec:function () {

                    if ( confirm( 'ȷ������ĵ���' ) ) {

                        this.execCommand( 'cleardoc' );
                    }
                }
            },
            '-',
            {
                label:'ȡ������',
                cmdName:'unlink'
            },
            '-',
            {
                group:'�����ʽ',
                icon:'justifyjustify',

                subMenu:[
                    {
                        label:'�������',
                        cmdName:'justify',
                        value:'left'
                    },
                    {
                        label:'���Ҷ���',
                        cmdName:'justify',
                        value:'right'
                    },
                    {
                        label:'���ж���',
                        cmdName:'justify',
                        value:'center'
                    },
                    {
                        label:'���˶���',
                        cmdName:'justify',
                        value:'justify'
                    }
                ]
            },
            '-',
            {
                label:'�������',
                cmdName:'edittable',
                exec:function () {
                    this.tableDialog.open();
                }
            },
            {
                label:'��Ԫ������',
                cmdName:'edittd',
                exec:function () {

                    this.ui._dialogs['tdDialog'].open();
                }
            },
            {
                group:'���',
                icon:'table',

                subMenu:[
                    {
                        label:'ɾ�����',
                        cmdName:'deletetable'
                    },
                    {
                        label:'���ǰ����',
                        cmdName:'insertparagraphbeforetable'
                    },
                    '-',
                    {
                        label:'ɾ����',
                        cmdName:'deleterow'
                    },
                    {
                        label:'ɾ����',
                        cmdName:'deletecol'
                    },
                    '-',
                    {
                        label:'ǰ������',
                        cmdName:'insertrow'
                    },
                    {
                        label:'ǰ������',
                        cmdName:'insertcol'
                    },
                    '-',
                    {
                        label:'�Һϲ���Ԫ��',
                        cmdName:'mergeright'
                    },
                    {
                        label:'�ºϲ���Ԫ��',
                        cmdName:'mergedown'
                    },
                    '-',
                    {
                        label:'��ֳ���',
                        cmdName:'splittorows'
                    },
                    {
                        label:'��ֳ���',
                        cmdName:'splittocols'
                    },
                    {
                        label:'�ϲ������Ԫ��',
                        cmdName:'mergecells'
                    },
                    {
                        label:'��ȫ��ֵ�Ԫ��',
                        cmdName:'splittocells'
                    }
                ]
            },
            {
                label:'����(ctrl+c)',
                cmdName:'copy',
                exec:function () {
                    alert( "��ʹ��ctrl+c���и���" );
                }
            },
            {
                label:'ճ��(ctrl+v)',
                cmdName:'paste',
                exec:function () {
                    alert( "��ʹ��ctrl+v����ճ��" );
                }
            }
        ],

        initialStyle://�༭���ڲ���ʽ
        //ѡ�е�td�ϵ���ʽ
        '.selectTdClass{background-color:#3399FF !important}' +
        //����ı���Ĭ����ʽ
        'table{clear:both;margin-bottom:10px;border-collapse:collapse;word-break:break-all;}' +
        //��ҳ������ʽ
        '.pagebreak{display:block;clear:both !important;cursor:default !important;width: 100% !important;margin:0;}' +
        //ê�����ʽ,ע�����ﱳ��ͼ��·��
        '.anchorclass{background: url("' + URL + 'themes/default/images/anchor.gif") no-repeat scroll left center transparent;border: 1px dotted #0000FF;cursor: auto;display: inline-block;height: 16px;width: 15px;}' +
        //�������ܵ�����
        '.view{padding:0;word-wrap:break-word;word-break:break-all;cursor:text;height:100%;}\n' +
        'body{margin:8px;font-family:"����";font-size:16px;}' +
        //���li�Ĵ���
        'li{clear:both}' +
        //���ö�����
        'p{margin:5px 0;}',
        //��ʼ���༭��������,Ҳ����ͨ��textarea/script��ֵ������������
        initialContent:'',
        autoClearinitialContent:false, //�Ƿ��Զ�����༭����ʼ���ݣ�ע�⣺���focus��������Ϊtrue,���ҲΪ�棬��ô�༭��һ�����ͻᴥ�����³�ʼ�������ݿ�������
        iframeCssUrl:'themes/default/iframe.css', //Ҫ����css��url
        removeFormatTags:'b,big,code,del,dfn,em,font,i,ins,kbd,q,samp,small,span,strike,strong,sub,sup,tt,u,var', //�����ʽɾ���ı�ǩ
        removeFormatAttributes:'class,style,lang,width,height,align,hspace,valign', //�����ʽɾ��������
        enterTag:'p', //�༭���س���ǩ��p��br
        maxUndoCount:20, //�����Ի��˵Ĵ���
        maxInputCount:20, //��������ַ���������ֵʱ������һ���ֳ�
        selectedTdClass:'selectTdClass', //�趨ѡ��td����ʽ����
        pasteplain:false, //�Ƿ��ı�ճ����falseΪ��ʹ�ô��ı�ճ����trueΪʹ�ô��ı�ճ��
        //�ύ��ʱ����������ȡ�༭���ύ���ݵ����õĲ�������ʵ��ʱ���Ը�����name���ԣ��Ὣname������ֵ��Ϊÿ��ʵ���ļ�ֵ������ÿ��ʵ������ʱ���������ֵ
        textarea:'editorValue',
        focus:false, //��ʼ��ʱ���Ƿ��ñ༭����ý���true��false
        indentValue:'2em', //��ʼ��ʱ��������������
        pageBreakTag:'_baidu_page_break_tag_', //��ҳ��
        minFrameHeight:320, //��С�߶�
        autoHeightEnabled:true, //�Ƿ��Զ�����
        autoFloatEnabled:true, //�Ƿ񱣳�toolbar��λ�ò���
        elementPathEnabled:true, //�Ƿ�����elementPath
        wordCount:true, //�Ƿ�������ͳ��
        maximumWords:10000, //���������ַ���
        tabSize:4, //tab�Ŀ��
        tabNode:'&nbsp;', //tabʱ�ĵ�һ�ַ�
        imagePopup:true, //ͼƬ�����ĸ��㿪�أ�Ĭ�ϴ�
        emotionLocalization:false, //�Ƿ������鱾�ػ���Ĭ�Ϲرա���Ҫ������ȷ��emotion�ļ����°��������ṩ��images�����ļ���
        sourceEditor:"codemirror", //Դ��Ĳ鿴��ʽ��codemirror �Ǵ��������textarea���ı���
        tdHeight:'20', //��Ԫ���Ĭ�ϸ߶�
        highlightJsUrl:URL + "third-party/SyntaxHighlighter/shCore.js",
        highlightCssUrl:URL + "third-party/SyntaxHighlighter/shCoreDefault.css",
        codeMirrorJsUrl:URL + "third-party/codemirror2.15/codemirror.js",
        codeMirrorCssUrl:URL + "third-party/codemirror2.15/codemirror.css",
        zIndex : 999, //�༭��z-index�Ļ���
        fullscreen : false, //�Ƿ���������ȫ��
        snapscreenHost: '127.0.0.1', //��Ļ��ͼ��server���ļ����ڵ���վ��ַ����ip���벻Ҫ��http://
        snapscreenServerFile: URL +"server/upload/php/snapImgUp.php", //��Ļ��ͼ��server�˱������UEditor�ķ�������Ϊ��URL +"server/upload/php/snapImgUp.php"��
        snapscreenServerPort: 80,//��Ļ��ͼ��server�˶˿�
        snapscreenImgAlign: 'center', //��ͼ��ͼƬĬ�ϵ��Ű淽ʽ
        snapscreenImgIsUseImagePath: 1, //�Ƿ�ʹ�����涨���imagepath�����Ϊ����ôserver����Ҫֱ�ӷ���ͼƬ������·��
        messages:{
            pasteMsg:'�༭���ѹ��˵���ճ�������в�֧�ֵĸ�ʽ��', //ճ����ʾ
            wordCountMsg:'��ǰ������ {#count} ���ַ���������������{#leave} ���ַ� ', //����ͳ����ʾ��{#count}����ǰ������{#leave}����������������ַ�����
            wordOverFlowMsg:'��������ַ������Ѿ������������ֵ�����������ܻ�ܾ����棡', //������������
            pasteWordImgMsg:'��ճ���������а�������ͼƬ����Ҫת��������ȷ��ʾ��',
            snapScreenNotIETip: '��ͼ������Ҫ��ie�������ʹ��',
            snapScreenMsg:'��ͼ�ϴ�ʧ�ܣ��������PHP������ '
        },
        serialize:function () {                              //���ù��˱�ǩ
//            var X = baidu.editor.utils.extend;
//            var inline = {strong:1,em:1,b:1,i:1,u:1,span:1,a:1,img:1};
//            var block = X(inline, {p:1,div:1,blockquote:1,$:{style:1,dir:1}});
            return {
                //�༭���в��ܹ�����ı�ǩ������������Щ��ǩ����ȥ����Ӧ�ı�ǩ��
                blackList:{style:1, link:1, object:1, applet:1, input:1, meta:1, base:1, button:1, select:1, textarea:1, '#comment':1, 'map':1, 'area':1}
//                whiteList: {
//                    div: X(block,{$:{style:1,'class':1}}),
//                    img: {$:{style:1,src:1,title:1,'data-imgref':1, 'data-refid':1, 'class':1}},
//                    a: X(inline, {$:{href:1}, a:0, sup:0}),
//                    strong: inline, em: inline, b: inline, i: inline,
//                    p: block,
//                    span: X(inline, {br:1,$:{style:1,id:1,highlight:1}}
//                }
            };
        }(),
        //������Ĭ����ʾ������
        ComboxInitial:{
            FONT_FAMILY:'����',
            FONT_SIZE:'�ֺ�',
            PARAGRAPH:'�����ʽ',
            CUSTOMSTYLE:'�Զ�����ʽ'
        },
        //�Զ��Ű����
        autotypeset:{
            mergeEmptyline : true,          //�ϲ�����
            removeClass : true,            //ȥ�������class
            removeEmptyline : false,        //ȥ������
            textAlign : "left",             //������Ű淽ʽ�������� left,right,center,justify ȥ��������Ա�ʾ��ִ���Ű�
            imageBlockLine : 'center',      //ͼƬ�ĸ�����ʽ����ռһ�о���,���Ҹ�����Ĭ��: center,left,right,none ȥ��������Ա�ʾ��ִ���Ű�
            pasteFilter : false,             //���ݹ������û��ճ������������
            clearFontSize : false,           //ȥ�����е���Ƕ�ֺţ�ʹ�ñ༭��Ĭ�ϵ��ֺ�
            clearFontFamily : false,         //ȥ�����е���Ƕ���壬ʹ�ñ༭��Ĭ�ϵ�����
            removeEmptyNode : false,         // ȥ���սڵ�
            //����ȥ���ı�ǩ
            removeTagNames : {div:1,a:1,abbr:1,acronym:1,address:1,b:1,bdo:1,big:1,cite:1,code:1,del:1,dfn:1,em:1,font:1,i:1,ins:1,label:1,kbd:1,q:1,s:1,samp:1,small:1,span:1,strike:1,strong:1,sub:1,sup:1,tt:1,u:1,'var':1},
            indent : false,                  // ��������
            indentValue : '2em'             //���������Ĵ�С
        }
    };
})();

