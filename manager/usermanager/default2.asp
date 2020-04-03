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
<title>用户管理后台-修改账号资料</title>
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
        <li><a href="/">首页</a></li>
        <li><a href="/Manager/">管理中心</a></li>
        <li><a href="/manager/usermanager/default2.asp">修改账号资料</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="regForm" id="regForm"  action="success.asp" method=post>
        <table class="manager-table">
          <tr>
            <th colspan=4> 说明:为保障客户权益，公司名称及姓名不可修改，若要修改，请传真营业执照复印件，个人传真身份证复印件到<%=faxphone%>，并注明"<font color="#FF0000">修改用户资料</font>" </th>
          </tr>
          <tr>
            <td  colspan=4><strong>基本资料</strong></td>
          </tr>
          <tr>
            <th align="right">用户名：</th>
            <td colspan="3"  align="left"><input type=hidden value="u_modi" name=module>
              &nbsp;<%=rs("u_name")%>&nbsp;&nbsp;
              <%
			  if qq_isLogin then
			  
			  if rs("qq_openid")="" or isnull(rs("qq_openid")) then
			  response.Write(" <a href=""#"" onclick=""bindQQ(1)""><img src=""/images/qq_login.png"" title=""绑定qq号""></a>")
			  else
			  response.Write(" <a href=""#"" onclick=""bindQQ(2)""><img src=""/images/qq_loginqx.png"" title=""取消绑定qq号""></a>")
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
            <th align="right"> 新密码：</th>
            <td align="left">&nbsp;
              <label><input name="u_password" id="u_password" class="manager-input s-input" type="password" datatype="pwd"  ignore="ignore" value="" size=20></label>
			    <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
            <th align="right"> 确认新密码：</th>
            <td align="left">&nbsp;
              <label><input name="u_password2" id="u_password2" class="manager-input s-input" type="password" recheck="u_password" datatype="*0-100"   errormsg="您两次输入的账号密码不一致！"  size=20></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
          </tr>
          <tr>
            <th align="right"> 联系人(<font color=red>*</font>)：</th>
            <td align="left">&nbsp;
              <label><input name=u_contract class="manager-input s-input" value="<%=rs("u_contract")%>"  size=20 datatype="cn2-18" errormsg="请输入您的联系人！" nullmsg="请输入您的联系人！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
              </th>
            <th align="right"> 公司(<font color=red>*</font>)：</th>
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
            <th align="right"> 姓名(中文)(<font color=red>*</font>)：</th>
            <td  align="left">&nbsp;
              <label><input  name=u_namecn class="manager-input s-input" value="<%=rs("u_namecn")%>" size=20 <%=readonly%> datatype="cn2-18" errormsg="请输入您的中文全名！" nullmsg="请输入您的中文全名！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
            <th align="right"> 姓名(拼音)(<font color=red>*</font>)：</th>
            <td align="left">&nbsp;
               <label><input name="u_nameen"class="manager-input s-input" type="text" value="<%=rs("u_nameen")%>" size=20  maxlength="60" datatype="enname" errormsg="请输入您的英文姓名,限(60字符内)！" nullmsg="英文姓名为空！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> 国家(<font color=red>*</font>)：</th>
            <td  align="left">&nbsp;
              <input name="u_contry" class="manager-input s-input" value="<%=rs("u_contry")%>" size="20" maxlength="2"></td>
            <th align="right"> 省份(<font color=red>*</font>)：</th>
            <td align="left">&nbsp;
              <select name=u_province size="1">
                <option value="<%=rs("u_province")%>"><%=rs("u_province")%></option>
                <option value=Anhui>安徽</option>
                <option value=Macao>澳门</option>
                <option value=Beijing>北京</option>
                <option value=Chongqing>重庆</option>
                <option value=Fujian>福建</option>
                <option value=Gansu>甘肃</option>
                <option value=Guangdong>广东</option>
                <option value=Guangxi>广西</option>
                <option value=Guizhou>贵州</option>
                <option value=Hainan>海南</option>
                <option value=Hebei>河北</option>
                <option value=Heilongjiang>黑龙江</option>
                <option value=Henan>河南</option>
                <option value=Hongkong>香港</option>
                <option value=Hunan>湖南</option>
                <option value=Hubei>湖北</option>
                <option value=Jiangsu>江苏</option>
                <option value=Jiangxi>江西</option>
                <option value=Jilin>吉林</option>
                <option value=Liaoning>辽宁</option>
                <option value=Neimenggu>内蒙古</option>
                <option value=Ningxia>宁夏</option>
                <option value=Qinghai>青海</option>
                <option value=Sichuan>四川</option>
                <option value=Shandong>山东</option>
                <option value=Shan1xi>山西</option>
                <option value=Shan2xi>陕西</option>
                <option value=Shanghai>上海</option>
                <option value=Taiwan>台湾</option>
                <option value=Tianjin>天津</option>
                <option value=Xinjiang>新疆</option>
                <option value=Xizang>西藏</option>
                <option value=Yunnan>云南</option>
                <option value=Zhejiang>浙江</option>
                <option value=Others>其它</option>
              </select></td>
          </tr>
          <tr>
            <th align="right"> 城市(<font color=red>*</font>)：</th>
            <td align="left">&nbsp;
              <input name=u_city class="manager-input s-input" value="<%=rs("u_city")%>" size=20></td>
            <th align="right"> 邮编：</th>
            <td align="left">&nbsp;
              <label><input name=u_zipcode class="manager-input s-input" value="<%=rs("u_zipcode")%>" size=20  maxlength="6" datatype="zip" errormsg="请输入您的邮政编码！" nullmsg="邮政编码为空！"> </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> 电话：</th>
            <td align="left">&nbsp;
               <label><input name=u_telphone class="manager-input s-input" value="<%=rs("u_telphone")%>" size=20    errormsg="请输入您的正确电话号码！" nullmsg="电话号码为空！">
			   </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
            <th align="right"> 传真：</th>
            <td align="left">&nbsp;
              <label><input name=u_fax class="manager-input s-input" value="<%=rs("u_fax")%>" size=20   errormsg="请输入您的正确电话号码！" nullmsg="电话号码为空！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>
			  </td>
          </tr>
          <tr>
            <th align="right"> 移动电话(<font color=red>*</font>)：</th>
            <td align="left" >&nbsp;
              <label><input name=msn class="manager-input s-input" value="<%=rs("msn_msg")%>" datatype="m" errormsg="请输入正确的手机号码！" nullmsg="手机号码不能为空">
			  
			  <%if rs("isauthmobile")>0 then
							response.write("(<font color=green>认证</font>)")
						else
							response.write("(<a href='renzheng.asp'><font color=red>未认证</font></a>)")
						end if
			  %>
			  </label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label>  
			</td>
            <th align="right"> 有效证件号：</th>
            <td align="left" >&nbsp;
              <input name=u_trade class="manager-input s-input" value="<%=rs("u_trade")%>"  size="20" <%if rs("u_trade")<>"" then Response.write " readonly"%>></td>
          </tr>
          <tr>
            <th align="right"> 电子邮件：</th>
            <td  align="left">&nbsp;
              <label><input name=u_email class="manager-input s-input" value="<%=rs("u_email")%>" datatype="e" nullmsg="电子邮箱为空！" errormsg="电子邮箱格式错误！">
              (<font color=red>*</font>)</label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label> </td>
            <th align="right"> QQ号：</th>
            <td  align="left">&nbsp;
               <label><input name=qq class="manager-input s-input" value="<%=rs("qq_msg")%>" ignore="ignore" maxlength="30" datatype="qq" errormsg="请输入正确的QQ号码！！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
          <tr>
            <th align="right"> 地址(<font color=red>*</font>)：</th>
            <td align="left" colspan="3">&nbsp;
              <label><input name=u_address class="manager-input s-input" value="<%=rs("u_address")%>" size=40  datatype="*4-40" nullmsg="联系地址为空!" errormsg="联系地址错误！"></label>
			  <label><label class="Validform_checktip" style="margin-left: 130px"></label></label></td>
          </tr>
        
        <tr>
          <th height="45" colspan=4 >
			
			<input name="ok2" class="manager-btn s-btn" type="submit" value="更 新">
            <input name="reset2" type="reset" value="重 填" class="manager-btn s-btn"></th>
        </tr>
      </form>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
