<!--#include file="common.asp"-->
<!--#include virtual="/config/const.asp" -->
<%
Const NetName="������������ע��-��������"        'վ������
Const NetUrl="/"        'վ����ַ
Const Logo="<img src='/images/logo.jpg' border='0'>"        'վ��LOGO
Const Ads="<img src='/images/westlogo.gif' border='0'>"        '�������
Const Smtp="sendmail.asdfsfd.cn"        'SMTP Server��ַ
Const Email="webmaster@sadf3.com"        '����ԱEmail
Const accredit="{companyname}"        '��Ȩ��Ϣ
Const EmailFlag=1        '�����ʼ����
Const PageCount=10        '��ҳ��ʾ��
Const MaxFileSize=500        '�ϴ��ļ���С����
Const SaveUpFilesPath="Upfiles"        '����ϴ��ļ���Ŀ¼
Const UpFileType="gif,jpg,doc,swf,rar,zip,exe"        '������ϴ��ļ�����
Const AddAuditing=false        '�Ƿ�����˹���
Const MenuFlag=true        '�Ƿ���ʾ��Ŀ�����˵�
Const CssDir="image/skin/7/"          'ǰ̨��ʽ�趨
Const AddNewPic=true        '�Ƿ���ʾ����ͼƬ����
Const AddNav=false        '�Ƿ���ʾ������Ŀ����
Const AddComment=false        '�Ƿ���ʾ�������۹���
Const AddOpenWin="_self"        '�������ʱ�Ƿ񵯿��´���
Const AddWriter=true        '�������ʱ�Ƿ���ʾ����
Const AddScroll=true        '�������ʱ�Ƿ�֧�ֹ�������
Const AddFavorite=true        '�������ʱ�Ƿ���ʾ�����ղع���
Const AddPrint=true        '�������ʱ�Ƿ���ʾ�����ӡ����
Const AddClose=true        '�������ʱ�Ƿ���ʾ����رչ���
Const AddPopedom=true        '�������ʱ�Ƿ�֧��Ȩ�����
Const copyright="Copyright (c) 2003-2008 All Rights Reserved."
'Const Version="NEWS Version"
Const kind=2        '��ҳ��������
Const maxLen=29        '���������ʾ��������ĸ��һ������������
Const listNum=10        '��ʾ���ٸ����±���
Const bullet="<img src='image/skin/1/bullet.gif' align=absmiddle>"        '����ǰ��ͼƬ�����
Const hitColor="#FF0000"        '���������ɫ
Const new_color="#FF0000"        '���������ڵ���ɫ
Const old_color="#999999"        '���������ڵ���ɫ
Const showNclass=true        '�Ƿ���ʾ��Ŀ����
Const DisPicico=true        '�Ƿ���ʾͼ�ı�־
Const regStatement="Ϊά�����Ϲ������������ȶ��������Ծ������������ </P><P>                                                          һ���������ñ�վΣ�����Ұ�ȫ��й¶�������ܣ������ַ�������Ἧ��ĺ͹���ĺϷ�Ȩ�棬�������ñ�վ���������ƺʹ���������Ϣ��</P><P>                                                          ��һ��ɿ�����ܡ��ƻ��ܷ��ͷ��ɡ���������ʵʩ�ģ�<BR>                                                          ������ɿ���߸�������Ȩ���Ʒ���������ƶȵģ�<BR>                                                          ������ɿ�����ѹ��ҡ��ƻ�����ͳһ�ģ�<BR>                                                          ���ģ�ɿ�������ޡ��������ӣ��ƻ������Ž�ģ�<BR>                                                          ���壩�������������ʵ��ɢ��ҥ�ԣ������������ģ�<BR>                                                          ����������⽨���š����ࡢɫ�顢�Ĳ�����������ɱ���ֲ�����������ģ�<BR>                                                          ���ߣ���Ȼ�������˻���������ʵ�̰����˵ģ����߽����������⹥���ģ�<BR>                                                          ���ˣ��𺦹��һ��������ģ�<BR>                                                          ���ţ�����Υ���ܷ��ͷ�����������ģ�<BR>                                                          ��ʮ��������ҵ�����Ϊ�ġ� <BR>                                                          �����������أ����Լ������ۺ���Ϊ����"     '��Աע����Ϣ
Const stopreg=true        '�Ƿ���ʱֹͣ��Աע��
Const LoadFiles=true    '�Ƿ�֧���ļ��ϴ�
Const Pwidth=135    '�Ƽ�����ͼƬ���
Const Pheight=97    '�Ƽ�����ͼƬ����
%>