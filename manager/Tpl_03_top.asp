<script language="JavaScript" type="text/JavaScript">
<!--
try{
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
}catch(e){}
//-->
</script>
<style type="text/css">.fei{position:absolute;margin-top:-10px;float:left;height:15px;width:30px;margin-left:-10px;zoom:1;overflow:hidden;}</style>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" bgcolor="#000000"><img src="/Template/Tpl_03/images/Default_02.gif" width="110" height="7"></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="65"><img src="<%=logimgPath%>"></td>
    <td width="713" align="right" valign="top"  background="/Template/Tpl_03/images/tpl/ind_r1.jpg"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="/Template/Tpl_03/images/spacer.gif" width="3" height="3"></td>
        </tr>
      </table>
      <table border="0" cellspacing="0" cellpadding="1">
        <tr>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_19.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/buystep.asp">��������</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_23.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/howpay.asp">���ʽ</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_17.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/faq" target="_blank">��������</a></td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_15.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/manager/default.asp?page_main=%2FManager%2Fquestion%2Fsubquestion%2Easp">��������</a>&nbsp;</td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_21.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/customercenter/renew.asp">�������</a>&nbsp;</td>
          <td bgcolor="f2f2f2"><img src="/Template/Tpl_03/images/Default_15.gif" width="13" height="13"></td>
          <td bgcolor="f2f2f2"><a href="/bagshow/">���ﳵ</a></td>
          <td bgcolor="f2f2f2"><select onChange="MM_jumpMenu('parent',this,0)" name=menu1>
              <option selected>��Ʒ�������ͨ��</option>
              <option>----------------</option>
              <option value="/manager/default.asp?page_main=%2FManager%2Fproductall%2Fdefault%2Easp">==��Ʒ�۸�����==</option>
              <option value="http://www.miibeian.gov.cn/chaxun/sfba.jsp">==�Ƿ񱸰���ѯ==</option>
              <option value="/services/domain/">==����ע��==</option>
              <option value="/services/domain/">Ӣ������ע��</option>
              <option value="/services/domain/defaultcn.asp">��������ע��</option>
              <option value="/services/domain/dns.asp">DNS����</option>
              <option value="/services/search/">==��վ�ƹ�==</option>
              <option value="/services/webhosting/">==��������==</option>
              <option>----------------</option>
              <option value="/services/webhosting/twolinevhost.asp">˫��·��������</option>
              <option value="/services/webhosting/basic.asp">��������������</option>
              <option value="/services/webhosting/database.asp">���ݿ�</option>
              <option value="/services/application/">Ӧ�÷���</option>
              <option value="/services/webhosting/demohost.asp">���������������</option>
              <option value="/services/webhosting/SpeedTest.htm">�����ٶȲ���</option>
              <option>----------------</option>
              <option value="/services/server/">==�����й�==</option>
              <option value="/services/server/">����������</option>
              <option value="/services/trusteehost/default.asp">�����й�</option>
              <option>----------------</option>
              <option value="/services/mail/">==��ҵ�ʾ�==</option>
              <option value="/services/mail/">������ҵ�ʾ�</option>
              <option>----------------</option>
              <option value="/customercenter/howpay.asp">==���ʽ==</option>
              <option>----------------</option>
              <option value="/aboutus/contact.asp">==��ϵ����==</option>
              <option value="/faq/">��������</option>
            </select></td>
        </tr>
      </table>
      <%
	  if len(session("user_name"))>0 then
		  managerurl=newInstallDir & "/manager"
		  If session("u_type")<>"0" Then
			managerurl=SystemAdminPath
		 End If

	  %>
      <table border="0" cellspacing="0" cellpadding="3">
        <tr>
          <td nowrap><img src="/Template/Tpl_01/images/icoTip.gif" width="14" height="18">&nbsp;&nbsp;&nbsp;</td>
          <td nowrap>���ã�<font color="#CC0000"><strong><%=session("user_name")%>&nbsp;&nbsp;</strong></font></td>
          <td nowrap>���ļ�����:<strong><font color="#CC0000"><%=session("u_level")%>&nbsp;&nbsp;</font></strong></td>
          <td nowrap><a href="<%=managerurl%>"><u><font color="#CC0000"><strong>��������</strong></font></u></a>&nbsp;&nbsp;</td>
          <td nowrap><a href="/signout.asp"><img src="/Template/Tpl_01/images/button_logout_03.gif" border="0"></a></td>
        </tr>
      </table>
      <%else%>
      <script language="JavaScript">
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
	  </script>
      <table border="0" cellspacing="0" cellpadding="3">
        <form name="myform" action="/chklogin.asp" method="post" onSubmit="return checkLogin()">
          <tr>
            <td nowrap>�û���:</td>
            <td nowrap><input name="u_name" type="text" class="inputbox" size="16"></td>
            <td nowrap>�ܡ���: </td>
            <td nowrap><input name="u_password" type="password" class="inputbox" size="16"></td>
            <td nowrap><input name="imageField" type="image" src="/Template/Tpl_01/images/Default_34.gif" width="80" height="21" border="0"></td>
            <td nowrap><a href="/reg"><img src="/Template/Tpl_01/images/Default_36.gif" width="80" height="21" border="0"></a></td>
            <td nowrap><a href="/reg/forget.asp"><font color="#CC0000">�������룿</font></a></td>
          </tr>
        </form>
      </table>
      <%end if%></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#3366CC">
  <tr>
    <td width="4"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
    <td background="/Template/Tpl_03/images/tpl/ind_r3_c21_02.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="73" height="40" align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_46.gif" width="27" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/"><font color="#FFFF00">�� ҳ</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom" ><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_49.gif" width="48" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/services/domain/"><font color="#FFFFFF">����ע��</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_51.gif" width="65" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/services/webhosting/"><font color="#FFFFFF">��������</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/diyimages/Default_63_2.gif" width="64" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/services/CloudHost/"><font color="#FFFFFF">������</font></a><span style="background:url(/Template/tpl_04/images/tjnew.gif) no-repeat" class="fei"></span></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03\images/Default_63_sites.gif" width="52" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/services/webhosting/sites.asp"><font color="#FFFFFF">��Ʒ��վ</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom" ><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/vpsico.gif" width="29" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/services/vpsserver/"><font color="#FFFFFF">VPS����</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom" ><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_56.gif" width="35" height="5"></td>
              </tr>
              <tr>
                <td align="center" nowrap><a href="/services/mail/"><font color="#FFFFFF">��ҵ�ʾ�</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td  align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_61.gif" width="42" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/agent/"><font color="#FFFFFF">����ר��</font></a></td>
              </tr>
            </table></td>
          <td width="8" nowrap="nowrap"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif" width="4" height="40" border="0"><img src="/Template/Tpl_03/images/tpl/ind_r3_c21_01_01.gif" width="4" height="40" border="0"></td>
          <td align="center" valign="bottom"><table width="94%" height="21" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="6" align="left" valign="top" nowrap><img src="/Template/Tpl_03/images/Default_65.gif" width="56" height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top" nowrap><a href="/customercenter/"><font color="#FFFFFF">�ͷ�����</font></a></td>
              </tr>
            </table></td>
          <td width="4"><img border="0" src="/Template/Tpl_03/images/tpl/ind_r3_c21_03_02.gif"></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#000000"><img src="/Template/Tpl_03/images/spacer.gif" width="3" height="3"></td>
  </tr>
</table>
<script language="JavaScript" src="/jscripts/swfobject.js"></script>
