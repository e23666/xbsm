<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
 

sqlstring="select * from UserDetail where u_id="&session("u_sysid")
session("sqlcmd_VU")=sqlstring 
rs.open session("sqlcmd_VU") ,conn,3
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-�޸��˺�����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<link href="/noedit/check/chkcss.css" rel="stylesheet" type="text/css" />
<script src="/database/cache/citypost.js"></script>
<script language="javascript" src="/noedit/check/Validform.js"></script>

<SCRIPT language=javaScript>

$(function(){
$("#regForm").Validform({
		tiptype:2,
		showAllError:true,
		btnSubmit:".manager-btn"})


})

</script>
</HEAD>
<body>
<!--#include virtual="/manager/top.asp" -->
<div id="MainContentDIV"> 
  <!--#include virtual="/manager/manageleft.asp" -->
  <div id="ManagerRight" class="ManagerRightShow">
    <div id="SiteMapPath">
      <ul>
        <li><a href="/">��ҳ</a></li>
        <li><a href="/Manager/">��������</a></li>
        <li><a href="/manager/usermanager/default2.asp">�޸��˺�����</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="regForm" id="regForm"  action="success.asp" method=post>
        <table class="manager-table">
          <tr>
            <th colspan=4> ˵��:Ϊ���Ͽͻ�Ȩ�棬��˾���Ƽ����������޸ģ���Ҫ�޸ģ��봫��Ӫҵִ�ո�ӡ�������˴������֤��ӡ����<%=faxphone%>����ע��"<font color="#FF0000">�޸��û�����</font>" </th>
          </tr>
          <tr>
            <td  colspan=4><strong>��������</strong></td>
          </tr>
          <tr>
            <th align="right">�û�����</th>
            <td colspan="3"  align="left"><input type=hidden value="u_modi" name=module>
              &nbsp;<%=rs("u_name")%>&nbsp;&nbsp;
              <%
			  if qq_isLogin then
			  
			  if rs("qq_openid")="" or isnull(rs("qq_openid")) then
			  response.Write(" <a href=""#"" onclick=""bindQQ(1)""><img src=""/images/qq_login.png"" title=""��qq��""></a>")
			  else
			  response.Write(" <a href=""#"" onclick=""bindQQ(2)""><img src=""/images/qq_loginqx.png"" title=""ȡ����qq��""></a>")
			  end if
			  %>
              <script type="text/javascript">
			  var childWindowQQ;
			  function bindQQ(v)
			  {	
			  childWindowQQ = window.open("/reg/redirect.asp?t="+v,"TencentLogin","width=450,height=320,menubar=0,scrollbars=1, resizable=1,status=1,titlebar=0,toolbar=0,location=1");	
			  } 
			  function closeChildWindow()
			  {childWindowQQ.close();window.location.reload()	}
              </script>
              <%end if%></td>
          </tr>
          <tr>
            <th align="right"> �����룺</th>
            <td align="left">&nbsp;
              <label><input name="u_password" id="u_password" class="manager-input s-input" type="password" datatype="pwd"  ignore="ignore" value="" size=20></label>
			    <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
            <th align="right"> ȷ�������룺</th>
            <td align="left">&nbsp;
              <label><input name="u_password2" id="u_password2" class="manager-input s-input" type="password" recheck="u_password" datatype="*0-100"   errormsg="������������˺����벻һ�£�"  size=20></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
          </tr>
          <tr>
            <th align="right"> ��ϵ��(<font color=red>*</font>)��</th>
            <td align="left">&nbsp;
              <label><input name=u_contract class="manager-input s-input" value="<%=rs("u_contract")%>"  size=20 datatype="cn2-18" errormsg="������������ϵ�ˣ�" nullmsg="������������ϵ�ˣ�"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
              </th>
            <th align="right"> ��˾(<font color=red>*</font>)��</th>
            <td  align="left">&nbsp;
              <%
readonly="readonly"
if Session("priusername")="" then 
   Session("u_namecn")=Rs("u_namecn")
   Session("u_company")=rs("u_company")  
   if rs("u_company")&""="" or rs("u_namecn")="" then readonly=""
else
	readonly=""
end if%>
              <input name=u_company class="manager-input s-input" value="<%=rs("u_company")%>"  size=20 <%=readonly%>></td>
          </tr>
          <tr>
            <th align="right"> ����(����)(<font color=red>*</font>)��</th>
            <td  align="left">&nbsp;
              <label><input  name=u_namecn class="manager-input s-input" value="<%=rs("u_namecn")%>" size=20 <%=readonly%> datatype="cn2-18" errormsg="��������������ȫ����" nullmsg="��������������ȫ����"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
            <th align="right"> ����(ƴ��)(<font color=red>*</font>)��</th>
            <td align="left">&nbsp;
               <label><input name="u_nameen"class="manager-input s-input" type="text" value="<%=rs("u_nameen")%>" size=20  maxlength="60" datatype="enname" errormsg="����������Ӣ������,��(60�ַ���)��" nullmsg="Ӣ������Ϊ�գ�"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> ����(<font color=red>*</font>)��</th>
            <td  align="left">&nbsp;
              <input name="u_contry" class="manager-input s-input" value="<%=rs("u_contry")%>" size="20" maxlength="2"></td>
            <th align="right"> ʡ��(<font color=red>*</font>)��</th>
            <td align="left">&nbsp;
              <select name=u_province size="1">
                <option value="<%=rs("u_province")%>"><%=rs("u_province")%></option>
                <option value=Anhui>����</option>
                <option value=Macao>����</option>
                <option value=Beijing>����</option>
                <option value=Chongqing>����</option>
                <option value=Fujian>����</option>
                <option value=Gansu>����</option>
                <option value=Guangdong>�㶫</option>
                <option value=Guangxi>����</option>
                <option value=Guizhou>����</option>
                <option value=Hainan>����</option>
                <option value=Hebei>�ӱ�</option>
                <option value=Heilongjiang>������</option>
                <option value=Henan>����</option>
                <option value=Hongkong>���</option>
                <option value=Hunan>����</option>
                <option value=Hubei>����</option>
                <option value=Jiangsu>����</option>
                <option value=Jiangxi>����</option>
                <option value=Jilin>����</option>
                <option value=Liaoning>����</option>
                <option value=Neimenggu>���ɹ�</option>
                <option value=Ningxia>����</option>
                <option value=Qinghai>�ຣ</option>
                <option value=Sichuan>�Ĵ�</option>
                <option value=Shandong>ɽ��</option>
                <option value=Shan1xi>ɽ��</option>
                <option value=Shan2xi>����</option>
                <option value=Shanghai>�Ϻ�</option>
                <option value=Taiwan>̨��</option>
                <option value=Tianjin>���</option>
                <option value=Xinjiang>�½�</option>
                <option value=Xizang>����</option>
                <option value=Yunnan>����</option>
                <option value=Zhejiang>�㽭</option>
                <option value=Others>����</option>
              </select></td>
          </tr>
          <tr>
            <th align="right"> ����(<font color=red>*</font>)��</th>
            <td align="left">&nbsp;
              <input name=u_city class="manager-input s-input" value="<%=rs("u_city")%>" size=20></td>
            <th align="right"> �ʱࣺ</th>
            <td align="left">&nbsp;
              <label><input name=u_zipcode class="manager-input s-input" value="<%=rs("u_zipcode")%>" size=20  maxlength="6" datatype="zip" errormsg="�����������������룡" nullmsg="��������Ϊ�գ�"> </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> �绰��</th>
            <td align="left">&nbsp;
               <label><input name=u_telphone class="manager-input s-input" value="<%=rs("u_telphone")%>" size=20    errormsg="������������ȷ�绰���룡" nullmsg="�绰����Ϊ�գ�">
			   </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
            <th align="right"> ���棺</th>
            <td align="left">&nbsp;
              <label><input name=u_fax class="manager-input s-input" value="<%=rs("u_fax")%>" size=20   errormsg="������������ȷ�绰���룡" nullmsg="�绰����Ϊ�գ�"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
          </tr>
          <tr>
            <th align="right"> �ƶ��绰(<font color=red>*</font>)��</th>
            <td align="left" >&nbsp;
              <label><input name=msn class="manager-input s-input" value="<%=rs("msn_msg")%>" datatype="m" errormsg="��������ȷ���ֻ����룡" nullmsg="�ֻ����벻��Ϊ��">
			  
			  <%if rs("isauthmobile")>0 then
							response.write("(<font color=green>��֤</font>)")
						else
							response.write("(<a href='renzheng.asp'><font color=red>δ��֤</font></a>)")
						end if
			  %>
			  </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>  
			</td>
            <th align="right"> ��Ч֤���ţ�</th>
            <td align="left" >&nbsp;
              <input name=u_trade class="manager-input s-input" value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" then Response.write " readonly"%>></td>
          </tr>
          <tr>
            <th align="right"> �����ʼ���</th>
            <td  align="left">&nbsp;
              <label><input name=u_email class="manager-input s-input" value="<%=rs("u_email")%>" datatype="e" nullmsg="��������Ϊ�գ�" errormsg="���������ʽ����">
              (<font color=red>*</font>)</label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label> </td>
            <th align="right"> QQ�ţ�</th>
            <td  align="left">&nbsp;
               <label><input name=qq class="manager-input s-input" value="<%=rs("qq_msg")%>" ignore="ignore" maxlength="30" datatype="qq" errormsg="��������ȷ��QQ���룡��"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> ��ַ(<font color=red>*</font>)��</th>
            <td align="left" colspan="3">&nbsp;
              <label><input name=u_address class="manager-input s-input" value="<%=rs("u_address")%>" size=40  datatype="*4-40" nullmsg="��ϵ��ַΪ��!" errormsg="��ϵ��ַ����"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
        
        <tr>
          <th height="45" colspan=4 >
			
			<input name="ok2" class="manager-btn s-btn" type="submit" value="�� ��">
            <input name="reset2" type="reset" value="�� ��" class="manager-btn s-btn"></th>
        </tr>
      </form>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
