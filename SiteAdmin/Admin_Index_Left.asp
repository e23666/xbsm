<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheckadmin.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>管理导航菜单</TITLE>
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
      target=main><B><SPAN class=glow>管理首页</SPAN></B></A><SPAN class=glow> | <a 
      href="<%=InstallDir%>signout.asp" 
      target=_parent><b><span class=glow>退出登录</span></b></a></SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu0 background=images/title_bg_admin.gif 
    height=97><DIV style="WIDTH: 180px">
          <TABLE cellSpacing=0 cellPadding=3 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=35>您的用户名：<%=session("user_name")%></TD>
              </TR>
              <TR>
                <TD height=25><form action="chguser.asp" method="post" target="_blank"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><input type="hidden" name="module" value="chguser">
                    <input type=text onclick=this.value="" name="username" size =6 value="客户ID"></td>
    <td> <input type=submit name="sub" value="切换"></td>
  </tr>
  <tr>
    <td colspan="2">余额： <label id="money" style="color:red;"></label></td>
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
    background=images/Admin_left_1.gif height=28 ;><SPAN class=glow>业务管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu1 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="domainmanager/default.asp" target="main">域名管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/default.asp" target="main">虚拟主机管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="servermanager/default.asp" target="main">服务器管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="mailmanager/default.asp" target="main">企业邮局产品</a></TD>
              </TR>
               <TR>
                <TD height=20><a href="miniprogram/default.asp" target="main">微信小程序</a></TD>
              </TR>
            
              <TR>
                <TD height=20><a href="sqlmanager/default.asp" target="main">Mssql数据库管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/HostChg.asp" target="main">业务过户</a></TD>
              </TR>
              <TR>
                <TD height=20><A HREF="admin/syncPro.asp" TARGET="main">业务同步</A></TD>
              </TR>
              <TR>
                <TD height=20><A HREF="admin/IPchg.asp" TARGET="main">批量修改IP</A></TD>
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
    background=images/Admin_left_2.gif height=28 ;><SPAN class=glow>订单管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu2 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="domainmanager/PreDomain.asp" target="main">域名订单</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/PreHost.asp" target="main">虚拟主机订单</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="servermanager/ServerListnote.asp" target="main">服务器租用订单</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="search/default.asp" target="main">推广产品订单</a></TD>
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
    background=images/Admin_left_3.gif height=28 ;><SPAN class=glow>财务管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu3 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=132 align=center>
            <TBODY>
              <TR>
                <TD height=21><a href="billmanager/Vpayend.asp" target="main">付款确认</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/incount.asp" target="main">用户入款</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/InActressCount.asp" target="main">优惠入款</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/returncount.asp" target="main">还款入户</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/comsume.asp" target="main">手工扣款</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/coupons.asp" target="main">优惠券入款</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/outOurMoney.asp" target="main">记录开支</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/ViewOurMoney.asp" target="main">查看流水帐</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/Mlist.asp" target="main">用户财务明细</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/checkcount.asp" target="main">财务审核</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="billmanager/Mfapiao.asp" target="main">发票管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/HostChg.asp" target="main">用户金额转移</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="clearfp.asp"  target="main">删除上年度可开发票</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="billmanager/chkcountlist.asp"  target="main">财务比对</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="billmanager/ranking.asp"  target="main">消费排行</a></TD>
              </TR>
			<!-- <TR>
                <TD height=20><a href="billmanager/excel.asp"  target="main">导出excel</a></TD>
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
    background=images/Admin_left_05.gif height=28><SPAN class=glow>用户管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu2104 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="usermanager/default.asp" target="main">会员管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="levelmanager/default.asp" target="main">代理商级别调整</a></TD>
              </TR>
              <!--
              <TR>
                <TD height=20><a href="productmanager/RegisterPriceList.asp" target="main">代理特殊定价</a></TD>
              </TR>-->
              <TR>
                <TD height=20><A HREF="levelmanager/chgLevelName.asp" TARGET="main">修改代理级别名称</A></TD>
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
    background=images/Admin_left_4.gif height=28><SPAN class=glow>日常管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu202 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="customercenter/default.asp" target="main">有问必答</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/Unprocess.asp" target="main">待手工处理业务</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/Enotice.asp" target="main">紧急通知设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="usermanager/mynotepad.asp" target="main">我的记事本</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="news/default.asp" target="main">新闻管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/AdminSendEmail.asp" target="main">邮件群发</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sendSMS/index.asp" target="main">短信群发</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sendSMS/sendmaillog.asp" target="main">邮件发送日志</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/c_charge.asp" target="main">续费通知</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="sitemanager/ViewAPILog.asp" target="main">日志查看</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_newslist.asp" target="main">常见问题管理修改</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_addnews.asp" target="main">常见问题管理添加</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="/faq/admin_class.asp" target="main">常见问题分类添加</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="admin/event_logs.asp" target="main">业务操作日志</a></TD>
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
    background=images/Admin_left_9.gif height=28><SPAN class=glow>产品管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu301 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
			 <TR>
                <TD height=20><a href="productmanager/syndomain.asp" target="main">同步域名价格</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/addPro.asp" target="main">新增产品</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/default.asp" target="main">产品列表/价格设置</a></TD>
              </TR>
			 <TR>
                <TD height=20><a href="productmanager/Transfer.asp" target="main">域名转入价格设置</a></TD>
              </TR>
			  <!--
              <TR>
                <TD height=20><a href="SystemSet/PriceSet.asp" target="main">首年特殊定价</a></TD>
              </TR>
              
              <TR>
                <TD height=20><a href="productmanager/RegisterPriceList.asp" target="main">客户多年购买价格</a></TD>
              </TR>-->
              <TR>
                <TD height=20><a href="productmanager/pricequery.asp" target="main">价格查询</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="productmanager/protofree.asp" target="main">赠品管理</a></TD>
              </TR>
			   <TR>
              <TD height=20><a href="productmanager/shopcar.asp" target="main">购物车管理</a></TD>
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
    background=images/Admin_left_01.gif height=28><SPAN class=glow>系统设置</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu201 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><a href="SystemSet/EditConfig.asp" target="main">系统设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="setuser/" target="main">管理员设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/EditNumber.asp" target="main">银行帐号设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/LogoUpload.asp" target="main">网站Logo管理</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/TemplateSet.asp" target="main">网站模板设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/noteTplSet.asp" target="main">通知模板设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="SystemSet/SetRegister.asp" target="main">域名接口设置</a></TD>
              </TR>
              <TR>
                <TD height=20><a href="update/" target="main">系统在线升级</a></TD>
              </TR>
			  <TR>
                <TD height=20><a href="clearcaceh.asp" target="main">清空缓存</a></TD>
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
    background=images/Admin_left_05.gif height=28><span class=glow>VCP模式管理</span></td>
    </tr>
    <tr>
      <td id=submenu210 style="DISPLAY: none" align=right><div class=sec_menu style="WIDTH: 165px">
          <table cellspacing=0 cellpadding=0 width=130 align=center>
            <tbody>
              <tr>
                <td height=20><a href="vcp/vcp_adminUser.asp" target="main">vcp用户管理</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/vcp_verify.asp" target="main">vcp用户审核</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/vcp_newautosettle.asp" target="main">vcp自动结算</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/adver.asp" target="main">广告管理</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/settlelist.asp" target="main">查看打款记录</a></td>
              </tr>
              <tr>
                <td height=20><a href="vcp/break.asp" target="main">脱离VCP</a></td>
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
    background=images/Admin_left_03.gif height=28><SPAN class=glow>数据库管理</SPAN></TD>
    </TR>
    <TR>
      <TD id=submenu206 style="DISPLAY: none" align=right><DIV class=sec_menu style="WIDTH: 165px">
          <TABLE cellSpacing=0 cellPadding=0 width=130 align=center>
            <TBODY>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Backup" 
            target=main>备份数据库</A></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Restore" 
            target=main>恢复数据库</A></TD>
              </TR>
              <TR>
                <TD height=20><a href="DataBaseManager/clearData.asp" target="main">清理数据库</a></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=Compact" 
            target=main>压缩数据库</A></TD>
              </TR>
              <TR>
                <TD height=20><A 
            href="DataBaseManager/Admin_Database.asp?Action=SpaceSize" 
            target=main>系统空间占用</A></TD>
              </TR>
              <TR>
                <TD height=20><a href="admin/sqlcmd.asp" target="main">SQL命令执行</a></TD>
              </TR>
             <!-- <TR>
                <TD height=20><A 
            href="admin/sitecheck.asp" 
            target=main>文件对比</A></TD>
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
      height=28><SPAN>系统信息</SPAN> </TD>
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
