<!--#include virtual="/config/config.asp" -->
<%
	managerurl=newInstallDir & "/manager"'�û��������ĵ�ַ
	If session("u_type")<>"0" Then
		managerurl=SystemAdminPath
	End If

	select case  trim(lcase(USEtemplate))
	case "tpl_01"
		call Tpl_01_top()
	case "tpl_02"
		call Tpl_02_top()
	case "tpl_03"
		call Tpl_03_top()
	case "tpl_04"
		call Tpl_04_top()
	case "tpl_05"
		call Tpl_05_top()
	case "tpl_2016"
		 call tpl_2016_top()
	
	end select


%>


<%sub Tpl_01_top%>
	<%if trim(session("user_name"))="" then%>
		  function checkLogin()
		  {
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		  }
		document.writeln(" <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          <tr> ");
		document.writeln("            <td nowrap>�û���:</td>");
		document.writeln("            <td nowrap><input name=\'u_name\' type=\'text\' class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap>�ܡ���: </td>");
		document.writeln("            <td nowrap><input name=\'u_password\'  type=\'password\'    class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap><input name=\'imageField\' type=\'image\' src=\'/Template/Tpl_01/images/Default_34.gif\' width=\'80\' height=\'21\' border=\'0\'></td>");
		document.writeln("            <td nowrap><a href=\'/reg\'><img src=\'/Template/Tpl_01/images/Default_36.gif\' width=\'80\' height=\'21\' border=\'0\'></a></td>");
		document.writeln("            <td nowrap><a href=\'/reg/forget.asp\'><font color=\'#CC0000\'>�������룿</font></a></td>");
		document.writeln("          </tr>");
		document.writeln("        </form>");
		document.writeln("      </table>");
	<%else%>
		document.writeln("      <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <tr> ");
		document.writeln("          <td nowrap><img src=\'/Template/Tpl_01/images/icoTip.gif\' width=\'14\' height=\'18\'>&nbsp;&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap>���ã�<font color=\'#CC0000\'><strong><%=session("user_name")%>&nbsp;&nbsp;</strong></font></td>");
		document.writeln("          <td nowrap>���ļ�����:<strong><font color=\'#CC0000\'><%=session("u_level")%>&nbsp;&nbsp;</font></strong></td>");
		document.writeln("          <td nowrap><a href=\'<%=managerurl%>\'><u><font color=\'#CC0000\'><strong>��������</strong></font></u></a>&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap><a href=\'/signout.asp\'><img src=\'/Template/Tpl_01/images/button_logout_03.gif\' border=\'0\'></a></td>");
		document.writeln("        </tr>");
		document.writeln("      </table>");
	<%end if%>
<%end sub%>

<%sub Tpl_02_top%>
	<%if trim(session("user_name"))="" then%>
		  function checkLogin()
		  {
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		  }
		document.writeln(" <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          <tr> ");
		document.writeln("            <td nowrap>�û���:</td>");
		document.writeln("            <td nowrap><input name=\'u_name\' type=\'text\' class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap>�ܡ���: </td>");
		document.writeln("            <td nowrap><input name=\'u_password\'  type=\'password\'    class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap><input name=\'imageField\' type=\'image\' src=\'/Template/Tpl_02/images/Default_34.gif\' width=\'80\' height=\'21\' border=\'0\'></td>");
		document.writeln("            <td nowrap><a href=\'/reg\'><img src=\'/Template/Tpl_02/images/Default_36.gif\' width=\'80\' height=\'21\' border=\'0\'></a></td>");
		document.writeln("            <td nowrap><a href=\'/reg/forget.asp\'><font color=\'#CC0000\'>�������룿</font></a></td>");
		document.writeln("          </tr>");
		document.writeln("        </form>");
		document.writeln("      </table>");
	<%else%>
		document.writeln("      <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <tr> ");
		document.writeln("          <td nowrap><img src=\'/Template/Tpl_01/images/icoTip.gif\' width=\'14\' height=\'18\'>&nbsp;&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap>���ã�<font color=\'#CC0000\'><strong><%=session("user_name")%>&nbsp;&nbsp;</strong></font></td>");
		document.writeln("          <td nowrap>���ļ�����:<strong><font color=\'#CC0000\'><%=session("u_level")%>&nbsp;&nbsp;</font></strong></td>");
		document.writeln("          <td nowrap><a href=\'<%=managerurl%>\'><u><font color=\'#CC0000\'><strong>��������</strong></font></u></a>&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap><a href=\'/signout.asp\'><img src=\'/Template/Tpl_03/images/button_logout_03.gif\' border=\'0\'></a></td>");
		document.writeln("        </tr>");
		document.writeln("      </table>");
	<%end if%>
<%end sub%>
<%sub Tpl_03_top%>
	<%if trim(session("user_name"))="" then%>
		  function checkLogin()
		  {
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		  }
		document.writeln(" <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          <tr> ");
		document.writeln("            <td nowrap>�û���:</td>");
		document.writeln("            <td nowrap><input name=\'u_name\' type=\'text\' class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap>�ܡ���: </td>");
		document.writeln("            <td nowrap><input name=\'u_password\'  type=\'password\'    class=\'inputbox\' size=\'16\'></td>");
		document.writeln("            <td nowrap><input name=\'imageField\' type=\'image\' src=\'/Template/Tpl_02/images/Default_34.gif\' width=\'80\' height=\'21\' border=\'0\'></td>");
		document.writeln("            <td nowrap><a href='/reg'><img src=\'/Template/Tpl_02/images/Default_36.gif\' width=\'80\' height=\'21\' border=\'0\'></a></td>");
		document.writeln("            <td nowrap><a href=\'/reg/forget.asp\'><font color=\'#CC0000\'>�������룿</font></a></td>");
		document.writeln("          </tr>");
		document.writeln("        </form>");
		document.writeln("      </table>");
	<%else%>
		document.writeln("      <table border=\'0\' cellspacing=\'0\' cellpadding=\'3\'>");
		document.writeln("        <tr> ");
		document.writeln("          <td nowrap><img src=\'/Template/Tpl_03/images/icoTip.gif\' width=\'14\' height=\'18\'>&nbsp;&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap>���ã�<font color=\'#CC0000\'><strong><%=session("user_name")%>&nbsp;&nbsp;</strong></font></td>");
		document.writeln("          <td nowrap>���ļ�����:<strong><font color=\'#CC0000\'><%=session("u_level")%>&nbsp;&nbsp;</font></strong></td>");
		document.writeln("          <td nowrap><a href=\'<%=managerurl%>\'><u><font color=\'#CC0000\'><strong>��������</strong></font></u></a>&nbsp;&nbsp;</td>");
		document.writeln("          <td nowrap><a href=\'/signout.asp\'><img src=\'/Template/Tpl_03/images/button_logout_03.gif\' border=\'0\'></a></td>");
		document.writeln("        </tr>");
		document.writeln("      </table>");
	<%end if%>
<%end sub%>

<%sub Tpl_04_top%>
	<%if trim(session("user_name"))="" then%>
		  function checkLogin()
		  {
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		  }
		document.writeln("  <table width=\'100%\' border=\'0\' cellpadding=\'2\' cellspacing=\'0\'>");
		document.writeln("        <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          <tr> ");
		document.writeln("            <td align=\'right\' nowrap>&nbsp;&nbsp;&nbsp;�û���:</td>");
		document.writeln("            <td nowrap><input name=\'u_name\' type=\'text\' class=\'inputbox\' size=\'16\'></td>");
		document.writeln("          </tr>");
		document.writeln("          <tr>");
		document.writeln("            <td align=\'right\' nowrap>&nbsp;&nbsp;&nbsp;�ܡ���:</td>");
		document.writeln("            <td nowrap><input name=\'u_password\' type=\'password\'  class=\'inputbox\' size=\'16\' /></td>");
		document.writeln("          </tr>");
		document.writeln("          <tr>");
		document.writeln("            <td colspan=\'2\' nowrap><table width=\'100%\' border=\'0\' cellspacing=\'0\' cellpadding=\'1\'>");
		document.writeln("              <tr>");
		document.writeln("                <td><input type=\'submit\' class=\'ButtonBox_1\' value=\'�� ½\' width=\'80\' height=\'21\' border=\'0\' /></td>");
		document.writeln("                <td align=\'right\' nowrap=\'nowrap\'><input type=\'button\' name=\'button2\' id=\'button2\' value=\'ע ��\' class=\'ButtonBox_2\' onclick=\'javascript:location.href=/reg/\' /></td>");
		document.writeln("                <td align=\'right\' nowrap=\'nowrap\'><input type=\'button\' name=\'button\' id=\'button\' value=\'��������\' class=\'ButtonBox_2\' onclick=\"javascript:location.href='/reg/forget.asp'\" /></td>");
		document.writeln("              </tr>");
		document.writeln("            </table></td>");
		document.writeln("          </tr>");
		document.writeln("        </form>");
		document.writeln("      </table>");
		document.writeln("	  ");
	<%else%>
		document.writeln("      <table width=\'100%\' border=\'0\' cellpadding=\'3\' cellspacing=\'0\'>");
		document.writeln("        <tr>");
		document.writeln("          <td colspan=\'3\' align=\'center\' nowrap height=\'10\'></td>");
		document.writeln("        </tr>");
		document.writeln("        <tr> ");
		document.writeln("          <td rowspan=\'3\' align=\'center\' nowrap><img src=\'/Template/Tpl_04/images/icoTip.gif\' width=\'14\' height=\'18\'></td>");
		document.writeln("          <td colspan=\'2\' nowrap>���ã�<font color=\'#FF6600\'><strong><%=session("u_level")%>&nbsp;&nbsp;</strong></font><strong><font color=\'#CC0000\'>&nbsp;</font></strong></td>");
		document.writeln("        </tr>");
		document.writeln("        <tr>");
		document.writeln("          <td colspan=\'2\' nowrap>���ļ�����:<strong><font color=\'#FF6600\'><%=session("u_level")%>&nbsp;</font></strong></td>");
		document.writeln("        </tr>");
		document.writeln("        <tr>");
		document.writeln("          <td nowrap><a href=\'<%=managerurl%>\'><u><font color=\'#FF6600\'><strong>��������</strong></font></u></a>&nbsp;</td>");
		document.writeln("          <td nowrap><a href=\'/signout.asp\'>");
		document.writeln("            <input type=\'button\' name=\'button\' id=\'button\' value=\'�� ��\' class=\'ButtonBox\' onclick=\'javascript:location.href=/signout.asp\' />");
		document.writeln("          </a></td>");
		document.writeln("        </tr>");
		document.writeln("      </table>");
		document.writeln("");
	<%end if%>
<%end sub%>


<%sub Tpl_05_top%>
	<%if trim(session("user_name"))="" then%>
		function checkLogin()
		{
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		}
		document.writeln("  <div id=\'TitleLogin\'>");
		document.writeln("        <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          <div id=\'LoginUname\'> �û���:");
		document.writeln("            <input name=\'u_name\' type=\'text\' class=\'inputbox\' value=\'\' size=\'16\'>");
		document.writeln("          </div>");
		document.writeln("          <div id=\'LoginPass\'> �ܡ���:");
		document.writeln("            <input name=\'u_password\' type=\'password\' class=\'inputbox\'   size=\'16\'>");
		document.writeln("          </div>");
		document.writeln("          <div id=\'LoginButton\'>");
		document.writeln("            <input name=\'imageField\' type=\'image\' src=\'/Template/Tpl_05/newimages/default/shortButton_login.gif\' border=\'0\'>");
		document.writeln("          </div>");
		document.writeln("          <div id=\'RegButton\'><a href=\'/reg\'><img src=\'/Template/Tpl_05/newimages/default/shortButton_reg.gif\' width=\'54\' height=\'24\' /></a></div>");
		document.writeln("          <div id=\'FindPassButton\'><a href=\'/reg/forget.asp\'><img src=\'/Template/Tpl_05/newimages/default/LongButton_FindPass.gif\' width=\'84\' height=\'24\' /></a></div>");
		document.writeln("        </form>");
		document.writeln("      </div>");
	<%else%>
		document.writeln("");
		document.writeln("<div id=\'TitleLoginOk\'>");
		document.writeln("  <div id=\'Logout\'><a href=\'/signout.asp\'><img src=\'/Template/Tpl_05/newimages/LongButton_logout.gif\' width=\'84\' height=\'24\' /></a></div>");
		document.writeln("  <div id=\'lblManager\'><a href=\'<%=managerurl%>\' class=\'Link_Blue\'>[��������]</a> </div>");
		document.writeln("  <div id=\'LogLevelName\'> ���ļ�����:<span class=\'redColor\'><%=session("u_level")%></span> </div>");
		document.writeln("  <div id=\'LoginUnameOk\'> ����:<span class=\'OrangeText\'><%=session("user_name")%></span></div>");
		document.writeln("</div>");
		document.writeln("");
	<%end if%>
<%end sub%>



<%sub tpl_2016_top%>
	<%if trim(session("user_name"))="" then%>
		 function checkLogin()
		  {
			if(myform.u_name.value=="")
			{
				alert("�û�������Ϊ�գ�");
				myform.u_name.focus();
				return false;
			}
			if(myform.u_password.value=="")
			{
				alert("���벻��Ϊ�գ�");
				myform.u_password.focus();
				return false;
			}
		  }
		document.writeln("     <form name=\'myform\' action=\'/chklogin.asp\' method=\'post\' onSubmit=\'return checkLogin()\'>");
		document.writeln("          �û���:");
		document.writeln("            <input name=\'u_name\' type=\'text\' class=\'login-input\' value=\'\'/>");
		document.writeln("        �ܡ���:");
		document.writeln("            <input name=\'u_password\' type=\'password\' class=\'login-input\'  />");
		document.writeln("			<input type=\'submit\' name=\'imageField\' value=\'��¼\' class=\'login-btn common-btn \' />");
		document.writeln("        <a href=\'/reg\' class=\'mr-10 header-reg\'>ע��</a> <a href=\'/reg/forget.asp\' class=\'mr-10 header-reg\'>��������?</a>");
		document.writeln("<span class=\'kjlogin\'>��ݵ�¼: <script src=\'/noedit/oauth.asp\'></script></span>");
		document.writeln("        </form>");

	<%else%>
		document.writeln("<div id=\'TitleLoginOk\'>");
		document.writeln("  ����:&nbsp;<a href=\'<%=managerurl%>\' class=\'link\'><%=session("user_name")%></a>&nbsp;&nbsp;&nbsp;");
		document.writeln("���ļ�����:&nbsp;<span class=\'redColor\'><%=session("u_level")%></span>  &nbsp;&nbsp;&nbsp;<a href=\'<%=managerurl%>\' class=\'link\'>��������</a>");
		document.writeln("  <a href=\'/signout.asp\' class=\'gray-link ml-15\'>�� ��</a>");
		document.writeln("</div>");
	<%end if%>
<%end sub%>