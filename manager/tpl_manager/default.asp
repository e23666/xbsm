<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script src="/manager/js/menu.js" type="text/javascript"></script>
<link rel="stylesheet" href="/manager/css/default.css" type="text/css" />
<%
conn.open constr
Sql="Select * from Fuser Where username='" & Session("user_name") & "' and L_ok="&PE_True&""
Set FRs=conn.Execute(Sql)
return_vcp=false
if not FRs.eof then
	return_vcp=true
end if
frs.close
set frs=nothing
session("vcp")=return_vcp
%>
<title>�û������̨</title>
<body>
<dl id="header">
	<dt></dt>
	<dd>
		<li><a href="/" target="_blank">��ҳ</a>&nbsp;|&nbsp;</li>
		<li><a href="/signout.asp">�˳�</a>&nbsp;</li>
	</dd>
</dl>
<div id="contents">
	<div class="left">
		<ul id="manageruser">
			<li><img src="/manager/images/Style/user_ico.gif" border=0>&nbsp; <a href="../usermanager/default2.asp" onclick="doopenpage1('TabPage2','left_tab6','�޸�����','userpage11')" target="content3" title="�޸�����" ><span class="fil" style="cursor:pointer"><%=gotTopic(session("user_name"),19)%></span></a></li>
			<li><img src="/manager/images/Style/users_ico.gif" border=0>&nbsp; <%If session("priusername")<>"" Then%><a href="../whoami.asp?module=returnme" style="cursor:pointer"><span class="fil">��ԭ���:<%= session("priusername") %></span></a><%else%><span class="fil"><%=session("u_level")%></span><%end if%></li>
		</ul>
		<div class="menu_top"></div>
		<div class="menu" id="TabPage3">
			<ul id="TabPage2">
				<li id="left_tab1" class="Selected" onClick="javascript:border_left('TabPage2','left_tab1');" title="ҵ�����">ҵ��</li>
				<li id="left_tab2" onClick="javascript:border_left('TabPage2','left_tab2');" title="��������">����</li>		
				<li id="left_tab3" onClick="javascript:border_left('TabPage2','left_tab3');" title="�������">����</li>
				<li id="left_tab6" onClick="javascript:border_left('TabPage2','left_tab6');" title="�˺Ź���">�˺�</li>
                <%if session("vcp") or session("u_levelid")>1 then%>
				<li id="left_tab4" onClick="javascript:border_left('TabPage2','left_tab4');" title="�����̹���">����</li><%end if%>
				<li id="left_tab5" onClick="javascript:border_left('TabPage2','left_tab5');" title="��������">����</li>
			</ul>
			<div id="left_menu_cnt">
				<ul id="dleft_tab1">
					<li id="now11" class="Selected"><a id="domain11" href="../domainmanager/default.asp" onClick="go_cmdurl('��������',this);" target="content3" title="��������">��������</a></li>
				  <li id="now11"><a id="host11" href="../sitemanager/default.asp" onClick="go_cmdurl('�ռ����',this);" target="content3" title="�ռ����">������������</a></li>
				  <li id="now11"><a id="mail11" href="../mailmanager/default.asp" onClick="go_cmdurl('�ʾֹ���',this);" target="content3" title="�ʾֹ���">��ҵ�ʾֹ���</a></li>
				  <li id="now11"><a href="../servermanager/default.asp" onClick="go_cmdurl('�����й�',this)" target="content3" title="�����й�">���������й�</a></li>
				  <li id="now11"><a href="../search/default.asp" onClick="go_cmdurl('�ƹ��Ʒ',this);" target="content3" title="�ƹ��Ʒ">�ƹ��Ʒ����</a></li>
				  <li id="now11"><a href="../sqlmanager/default.asp" onClick="go_cmdurl('Mssql',this)" target="content3" title="Mssql">Mssql���ݿ����</a></li>
				  <li id="now11"><a href="../move/movein.asp" onClick="go_cmdurl('ҵ��ת��',this)" target="content3" title="ҵ��ת��">ҵ��ת��</a></li>
				  <li id="now11"><a href="../move/moveout.asp" onClick="go_cmdurl('ҵ��ת��',this)" target="content3" title="ҵ��ת��">ҵ��ת��</a></li>
                  <li id="now11"><a href="../domainmanager/zhuanru.asp" onClick="go_cmdurl('����ת��',this)" target="content3" title="����ת���б�">����ת���ѯ</a></li>
				  <li id="now11"><a href="http://beian.vhostgo.com/" target="_blank" title="������˾ί�б���ϵͳ">ICP��վ����</a></li>
			  </ul>
				<ul id="dleft_tab2" style="display:none;">
					<li id="now11"><a id="domainorder11" href="../ordermanager/domain/default.asp" onClick="go_cmdurl('��������',this)" target="content3" title="��������">��������</a></li>
					<li id="now11"><a id="hostorder11" href="../ordermanager/vhost/default.asp" onClick="go_cmdurl('��������',this)" target="content3" title="��������">������������</a></li>
				</ul>
				<ul id="dleft_tab3" style="display:none;">
					<li id="now11"><a id="mlist11" href="../useraccount/mlist.asp" onClick="go_cmdurl('������ϸ',this)" target="content3" title="������ϸ">������ϸ</a></li>
					<li id="now11"><a id="onlinePay11" href="../onlinePay/onlinePay.asp" onClick="go_cmdurl('����֧��',this)" target="content3" title="����֧��">����֧��</a></li>
					<li id="now11"><a id="fapiao11" href="../useraccount/fapiao.asp" onClick="go_cmdurl('��Ʊ��ȡ',this)" target="content3" title="��Ʊ��ȡ">��Ʊ��ȡ</a></li>
                    <li id="now11"><a href="../useraccount/VFaPiao.asp" onClick="go_cmdurl('��Ʊ��ѯ',this)" target="content3" title="��Ʊ��ѯ">��Ʊ��ѯ</a></li>
					<li id="now11"><a href="../useraccount/payend.asp" onClick="go_cmdurl('���ȷ��',this)" target="content3" title="���ȷ��">���ȷ��</a></li>
                    <li id="now11"><a href="../useraccount/ViewPayEnd.asp" onClick="go_cmdurl('����ѯ',this)" target="content3" title="����ѯ">����ѯ</a></li>
                   
				</ul>
				<ul id="dleft_tab6" style="display:none;">
					<li id="now11"><a id="userpage11" href="../usermanager/default2.asp" onClick="go_cmdurl('�޸�����',this)" target="content3" title="�޸�����">�޸�����</a></li>
					<li id="now11"><a href="../productall/default.asp" onClick="go_cmdurl('��Ʒ�۸�',this)" target="content3" title="��Ʒ�۸�">��Ʒ�۸�</a></li>
					<li id="now11"><a href="../usermanager/userlog.asp" onClick="go_cmdurl('��½��־',this)" target="content3" title="��½��־">��½��־</a></li>
					
				</ul>
				<ul id="dleft_tab4" style="display:none;">
                <%if session("vcp") then%>
					<li id="now11"><a href="../vcp/vcp_index.asp" onClick="go_cmdurl('VCP����',this)" target="content3" title="VCP����">VCPҵ�����</a></li>
					<li id="now11"><a href="../vcp/vcp_Vuser.asp" onClick="go_cmdurl('VCP�û�',this)" target="content3" title="VCP�û�">�ҵ�VCP�û�</a></li>
					<li id="now11"><a href="../vcp/settleList.asp" onClick="go_cmdurl('VCP���',this)" target="content3" title="VCP���">VCP�����ϸ</a></li>
					<li id="now11"><a href="../vcp/royalty.asp" onClick="go_cmdurl('VCP����',this)" target="content3" title="VCP����">VCP������ϸ</a></li>
                    <li id="now11"><a href="../vcp/vcp_Edit.asp" onClick="go_cmdurl('�޸�����',this)" target="content3" title="�޸�����">�޸�VCP����</a></li>
                    <li id="now11"><a href="../vcp/newGetADS.asp?code=u" onClick="go_cmdurl('VCP���',this)" target="content3" title="VCP���">VCP������</a></li>
                 <%end if%>
                 <%if session("u_levelid")>1 then%>
                    <li id="now11"><a href="../usermanager/APIconfig.asp" onClick="go_cmdurl('API����',this)" target="content3" title="API����">API�ӿ�����</a></li>
                    <li id="now11"><a href="../move/moveset.asp" onClick="go_cmdurl('ҵ��ת��',this)" target="content3" title="ҵ��ת��">ҵ��ת������</a></li>
                 <%end if%>
				</ul>
				<ul id="dleft_tab5" style="display:none;">
					<li id="now11"><a href="/faq" onClick="go_cmdurl('��������',this)" target="content3" title="��������">��������FAQ</a></li>
					<li id="now11"><a id="question11" href="../question/subquestion.asp" onClick="go_cmdurl('���ʱش�',this)" target="content3" title="���ʱش�">���ʱش�</a></li>
					<li id="now11"><a href="../question/allquestion.asp?module=search&qtype=myall" onClick="go_cmdurl('�������',this)" target="content3" title="�������">���⴦�����</a></li>
                    <li id="now11"><a href="/customercenter/" onClick="go_cmdurl('�ͷ�����',this)" target="_blank" title="�ͷ�����">�ͷ�����</a></li>		
				</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div class="menu_end"></div>
	</div>
	<div class="right">
	   <ul id="TabPage1">
			<li id="Tab1" class="Selected" onClick="javascript:switchTab('TabPage1','Tab1');" title="������ҳ">������ҳ</li>
			
			<li id="Tab3" onClick="javascript:switchTab('TabPage1','Tab3');"><span id="dnow99" style="display:block">��������</span></li>
	   </ul>
		<div id="cnt">
		  <div id="dTab1" class="Box">
		  <iframe src="/manager/tpl_manager/main.asp" name="content1" frameborder="0" scrolling="auto"></iframe>
		  </div>
			<div id="dTab3" class="HackBox Box">
			<iframe src="../domainmanager/default.asp" name="content3" id="content3" frameborder="0" scrolling="auto"></iframe>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<%
page_main=request("page_main")
if page_main<>"" then
	if instr(page_main,"onlinePay.asp")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab3','����֧��','onlinePay11');"
	elseif instr(page_main,"subquestion.asp")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab5','���ʱش�','question11');"
	elseif instr(page_main,"domainmanager")>0 then
		response.write "<script language=javascript>doopenpage1('TabPage2','left_tab1','��������','domain11');"
	end if
	response.write "document.frames['content3'].location.href='"& page_main &"';</script>"
end if
%>
</body>
</html>
