<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheckadmin.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>�������˵�</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<SCRIPT src="js/prototype.js"></SCRIPT>

<LINK href="css/Admin_left.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.6000.16525" name=GENERATOR>
</HEAD>
<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<TABLE cellSpacing=0 cellPadding=0 width=180 align=center border=0>
  <TBODY>
    <TR>
      <TD vAlign=top height=44><IMG 
  src="images/title.gif"></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=180 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle0 
    background=images/title_bg_quit.gif 
      height=23>&nbsp;&nbsp;<A 
      href="Admin_Index_Main.asp" 
      target=main><B><SPAN class=glow>������ҳ</SPAN></B></A><SPAN class=glow> | <a 
      href="<%=InstallDir%>signout.asp" 
      target=_parent><b><span class=glow>�˳���¼</span></b></a></SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu0 background=images/title_bg_admin.gif 
    height=97><DIV style="WIDTH: 180px">
          <TABLE cellSpacing=0 cellPadding=3 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=35>�����û�����<%=session("user_name")%></TD>
              </TR>
              <TR>
                <TD height=25><form action="chguser.asp" method="post" target="_blank"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><input type="hidden" name="module" value="chguser">
                    <input type=text onclick=this.value="" name="username" size =6 value="�ͻ�ID"></td>
    <td> <input type=submit name="sub" value="�л�"></td>
  </tr>
  <tr>
    <td colspan="2">�� <label id="money" style="color:red;"></label></td>
    </tr>
</table>

                  
                   
             
                </form></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px"></DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle1 
    onmouseover="this.className='menu_title2'" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu1')" 
    onmouseout="this.className='menu_title'" 
    background=images/Admin_left_1.gif height=28 ;><SPAN class=glow>ҵ�����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu1 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="domainmanager/default.asp" target="main">��������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/default.asp" target="main">������������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="servermanager/default.asp" target="main">����������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="mailmanager/default.asp" target="main">��ҵ�ʾֲ�Ʒ</a></TD>
              </TR>
               <TR>
                <TD height=20><a href="miniprogram/default.asp" target="main">΢��С����</a></TD>
              </TR>
            
              <TR>
                <TD height=20><a href="sqlmanager/default.asp" target="main">Mssql���ݿ����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/HostChg.asp" target="main">ҵ�����</a></TD>
              </TR>
              <TR>
                <TD height=20><A HREF="admin/syncPro.asp" TARGET="main">ҵ��ͬ��</A></TD>
              </TR>
              <TR>
                <TD height=20><A HREF="admin/IPchg.asp" TARGET="main">�����޸�IP</A></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 158px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=4></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle2 
    onmouseover="this.className='menu_title2'" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu2')" 
    onmouseout="this.className='menu_title'" 
    background=images/Admin_left_2.gif height=28 ;><SPAN class=glow>��������</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu2 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="domainmanager/PreDomain.asp" target="main">��������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/PreHost.asp" target="main">������������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="servermanager/ServerListnote.asp" target="main">���������ö���</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="search/default.asp" target="main">�ƹ��Ʒ����</a></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 158px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=4></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle3 
    onmouseover="this.className='menu_title2'" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu3')" 
    onmouseout="this.className='menu_title'" 
    background=images/Admin_left_3.gif height=28 ;><SPAN class=glow>�������</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu3 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=21><a href="billmanager/Vpayend.asp" target="main">����ȷ��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/incount.asp" target="main">�û����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/InActressCount.asp" target="main">�Ż����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/returncount.asp" target="main">�����뻧</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/comsume.asp" target="main">�ֹ��ۿ�</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/coupons.asp" target="main">�Ż�ȯ���</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/outOurMoney.asp" target="main">��¼��֧</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/ViewOurMoney.asp" target="main">�鿴��ˮ��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/Mlist.asp" target="main">�û�������ϸ</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/checkcount.asp" target="main">�������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/Mfapiao.asp" target="main">��Ʊ����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/HostChg.asp" target="main">�û����ת��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="clearfp.asp"  target="main">ɾ������ȿɿ���Ʊ</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="billmanager/chkcountlist.asp"  target="main">����ȶ�</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="billmanager/ranking.asp"  target="main">��������</a></TD>
              </TR>
			<!-- <TR>
                <TD height=20><a href="billmanager/excel.asp"  target="main">����excel</a></TD>
              </TR>-->
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 158px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=4></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle2104 
    onmouseover="this.className='menu_title2';" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu2104')" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_05.gif height=28><SPAN class=glow>�û�����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu2104 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="usermanager/default.asp" target="main">��Ա����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="levelmanager/default.asp" target="main">�����̼������</a></TD>
              </TR>
              <!--
              <TR>
                <TD height=20><a href="productmanager/RegisterPriceList.asp" target="main">�������ⶨ��</a></TD>
              </TR>-->
              <TR>
                <TD height=20><A HREF="levelmanager/chgLevelName.asp" TARGET="main">�޸Ĵ���������</A></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=5></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle202 
    onmouseover="this.className='menu_title2';" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu202')" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_4.gif height=28><SPAN class=glow>�ճ�����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu202 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="customercenter/default.asp" target="main">���ʱش�</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/Unprocess.asp" target="main">���ֹ�����ҵ��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/Enotice.asp" target="main">����֪ͨ����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="usermanager/mynotepad.asp" target="main">�ҵļ��±�</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="news/default.asp" target="main">���Ź���</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/AdminSendEmail.asp" target="main">�ʼ�Ⱥ��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sendSMS/index.asp" target="main">����Ⱥ��</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sendSMS/sendmaillog.asp" target="main">�ʼ�������־</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/c_charge.asp" target="main">����֪ͨ</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/ViewAPILog.asp" target="main">��־�鿴</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_newslist.asp" target="main">������������޸�</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_addnews.asp" target="main">��������������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_class.asp" target="main">��������������</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="admin/event_logs.asp" target="main">ҵ�������־</a></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=5></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle301 
    onmouseover="this.className='menu_title2';" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu301')" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_9.gif height=28><SPAN class=glow>��Ʒ����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu301 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
			 <TR>
                <TD height=20><a href="productmanager/syndomain.asp" target="main">ͬ�������۸�</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/addPro.asp" target="main">������Ʒ</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/default.asp" target="main">��Ʒ�б�/�۸�����</a></TD>
              </TR>
			 <TR>
                <TD height=20><a href="productmanager/Transfer.asp" target="main">����ת��۸�����</a></TD>
              </TR>
			  <!--
              <TR>
                <TD height=20><a href="SystemSet/PriceSet.asp" target="main">�������ⶨ��</a></TD>
              </TR>
              
              <TR>
                <TD height=20><a href="productmanager/RegisterPriceList.asp" target="main">�ͻ����깺��۸�</a></TD>
              </TR>-->
              <TR>
                <TD height=20><a href="productmanager/pricequery.asp" target="main">�۸��ѯ</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/protofree.asp" target="main">��Ʒ����</a></TD>
              </TR>
			   <TR>
              <TD height=20><a href="productmanager/shopcar.asp" target="main">���ﳵ����</a></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=5></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle201 
    onmouseover="this.className='menu_title2';" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu201')" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_01.gif height=28><SPAN class=glow>ϵͳ����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu201 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="SystemSet/EditConfig.asp" target="main">ϵͳ����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="setuser/" target="main">����Ա����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/EditNumber.asp" target="main">�����ʺ�����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/LogoUpload.asp" target="main">��վLogo����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/TemplateSet.asp" target="main">��վģ������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/noteTplSet.asp" target="main">֪ͨģ������</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/SetRegister.asp" target="main">�����ӿ�����</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="update/" target="main">ϵͳ��������</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="clearcaceh.asp" target="main">��ջ���</a></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=5></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<table cellspacing=0 cellpadding=0 width=167 align=center>
  <tbody>
    <tr>
      <td class=menu_title id=menuTitle210 
    onMouseOver="this.className='menu_title2';" style="CURSOR: hand" 
    onClick="new Element.toggle('submenu210')" 
    onMouseOut="this.className='menu_title';" 
    background=images/Admin_left_05.gif height=28><span class=glow>VCPģʽ����</span></td>
    </tr>
    <tr>
      <td id=submenu210 style="DISPLAY: none" align=right><div class=sec_menu style="WIDTH: 165px">
          <table cellspacing=0 cellpadding=0 width=130 align=center>
            <tbody>
              <tr>
                <td height=20><a href="vcp/vcp_adminUser.asp" target="main">vcp�û�����</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/vcp_verify.asp" target="main">vcp�û����</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/vcp_newautosettle.asp" target="main">vcp�Զ�����</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/adver.asp" target="main">������</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/settlelist.asp" target="main">�鿴����¼</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/break.asp" target="main">����VCP</a></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div style="WIDTH: 167px">
          <table cellspacing=0 cellpadding=0 width=130 align=center>
            <tbody>
              <tr>
                <td height=5></td>
              </tr>
            </tbody>
          </table>
        </div></td>
    </tr>
  </tbody>
</table>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle206 
    onmouseover="this.className='menu_title2';" style="CURSOR: hand" 
    onclick="new Element.toggle('submenu206')" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_03.gif height=28><SPAN class=glow>���ݿ����</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu206 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Backup" 
            target=main>�������ݿ�</A></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Restore" 
            target=main>�ָ����ݿ�</A></TD>
              </TR>
              <TR>
                <TD height=20><a href="DataBaseManager/clearData.asp" target="main">�������ݿ�</a></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Compact" 
            target=main>ѹ�����ݿ�</A></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=SpaceSize" 
            target=main>ϵͳ�ռ�ռ��</A></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/sqlcmd.asp" target="main">SQL����ִ��</a></TD>
              </TR>
             <!-- <TR>
                <TD height=20><A 
            href="admin/sitecheck.asp" 
            target=main>�ļ��Ա�</A></TD>
              </TR>
              -->
            </TBODY>
          </TABLE>
        </DIV>
        <DIV style="WIDTH: 167px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=5></TD>
              </TR>
            </TBODY>
          </TABLE>
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=167 align=center>
  <TBODY>
    <TR>
      <TD class=menu_title id=menuTitle208 
    onmouseover="this.className='menu_title2';" 
    onmouseout="this.className='menu_title';" 
    background=images/Admin_left_04.gif 
      height=28><SPAN>ϵͳ��Ϣ</SPAN> </TD>
    </TR>
    <TR>
      <TD align=right><DIV class=sec_menu style="WIDTH: 165px">
          <!--#include file="copyright.asp" -->
        </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
   <script src="getmoney.asp"></script>
<div id="lyajaxcode"></div>
</BODY>
</HTML>
