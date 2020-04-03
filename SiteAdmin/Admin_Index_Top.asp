<!--#include virtual="/config/config.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>顶部管理导航菜单</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<STYLE type=text/css>A:link {
	COLOR: #ffffff; TEXT-DECORATION: none
}
A:hover {
	COLOR: #ffffff
}
A:visited {
	COLOR: #f0f0f0; TEXT-DECORATION: none
}
.spa {
	FONT-SIZE: 9pt; FILTER: Glow(Color=#0F42A6, Strength=2) dropshadow(Color=#0F42A6, OffX=2, OffY=1,); COLOR: #8aade9; FONT-FAMILY: '宋体'
}
IMG {
	FILTER: Alpha(opacity:100); chroma: #FFFFFF)
}
</STYLE>

<SCRIPT language=JavaScript type=text/JavaScript>
function preloadImg(src) {
  var img=new Image();
  img.src=src
}
preloadImg('Images/admin_top_open.gif');

var displayBar=true;
function switchBar(obj) {
  if (displayBar) {
    parent.frame.cols='0,*';
    displayBar=false;
    obj.src='Images/admin_top_open.gif';
    obj.title='打开左边管理导航菜单';
  } else {
    parent.frame.cols='200,*';
    displayBar=true;
    obj.src='Images/admin_top_close.gif';
    obj.title='关闭左边管理导航菜单';
  }
}
</SCRIPT>

<META content="MSHTML 6.00.6000.16525" name=GENERATOR></HEAD>
<BODY leftMargin=0 background=images/admin_top_bg.gif 
topMargin=0>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY> 
  <TR vAlign=center> 
    <TD width=60><IMG title=关闭左边管理导航菜单 style="CURSOR: hand" 
      onclick=switchBar(this) 
src="images/admin_top_close.gif"></TD>
    <TD width=92><a href="<%=InstallDir%>" target="_blank"><img src="images/agent_topbutton_3.gif" width="92" height="53" border="0"></a></TD>
    <TD width=92><a href="http://help.west.cn/help" target="main"><img src="images/agent_topbutton_2.gif" width="92" height="53" border="0"></a></TD>
    <TD width=89><a href="update/" target="main"><img src="images/agent_topbutton_1.gif" border="0"></a></TD>
    <TD width=89><a href="admin/default2.asp" target="main"><img src="images/agent_topbutton_5.gif" border="0"></a></TD>
    <TD width=92><a href="<%=InstallDir%>manager" target="_blank"><img src="images/agent_topbutton_4.gif" width="92" height="53" border="0"></a></TD>
    <TD class=spa align=right width="471">西部数码虚拟主机域名分销平台 </TD>
  </TR>
  </TBODY>
</TABLE>
</BODY></HTML>
