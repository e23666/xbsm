<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.buffer=true
response.charset="gb2312"

 
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
mailid=requesta("id")
if not isnumeric(mailid) or mailid="" then url_return "参数传递错误",-1
sqlstring="Select * from mailsitelist where m_sysid=" & MailID & " and m_ownerid=" & Session("u_sysid")
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "没有找到此邮局",-1
m_bindname=rs("m_bindname")
m_years=rs("m_years")
m_buydate=formatDateTime(rs("m_buydate"),2)
m_expiredate=formatdateTime(rs("m_expiredate"),2)
m_productid=rs("m_productid")
m_buytest=rs("m_buytest")
if s_buytest then response.redirect "paytest.asp?p_id=" & hostid & "&productType=vhost":response.end
	if trim(m_productid)="diymail" then
	renewprice=getDiyMailprice(rs("m_size")/rs("m_mxuser"),rs("m_mxuser"))
	else
	renewprice=getneedprice(session("user_name"),m_productid,1,"renew")
	end if
%>
 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-企业邮局</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<style>
.redAlert_Box {
    background-color: #FFFDE4;
    border: 1px solid #FF9900;
    padding: 10px;
    margin: 0px 1px 0px 2px;
    font-size: 14px;
    color: #F30;
    font-weight: bold;
    line-height: 22px;
}
</style>
<script language="javascript">
	var m_id=<%=mailid%>
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid+'&mailid='+<%=requesta("id")%>;
		var divID='needprice';
		makeRequestPost1(url,sinfo,divID)
	}
function dosub(f){
	if(confirm('确定此操作吗?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}
</script>
<script src="upyun.js" type="text/javascript" ></script>


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
			   <li><a href="/Manager/mailmanager/">企业邮局</a></li>
			   <li>企业邮局续费</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
			
			<div class="redAlert_Box RedLink" id="lockmsg" style="margin:10px 0;"> 
					全球云邮震撼登场，集群架构、强力反垃圾，全新界面，支持数十项超强功能，协同办公更高效，推荐升级！ <a href="javascript:upyun()" class="manager-btn s-btn red-btn">一键免费升级到云邮</a>
				</div>

<table class="manager-table">
<form name="form1" method="post" action="../config/renew.asp" >
                <tbody>
                  <tr>
                    <th width="36%" align="right" nowrap class="tdbg">邮 局：</th>
                    <td width="64%" height="15" align="left" class="tdbg"><%=m_bindname%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><font color="#000000"> 年 限：</font></th>
                    <td height="16" class="tdbg" align="left"><%=m_years%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><p align="right">注册日期：</p></th>
                    <td height="2" class="tdbg" align="left"><%=m_buydate%></td>
                  </tr>
                  <tr>
                    <th align="right" nowrap class="tdbg"><p align="right">到期日期：</p></th>
                    <td height="26" class="tdbg" align="left"><%=m_expiredate%></td>
                  </tr>
<tr>
            <td colspan="2"style="text-align: center" BGCOLOR="#FFFFFF" class="tdbg">
              <div class="redAlert_Box RedLink">为了使您能快捷、准确地收到续费通知等信息，请核实您的手机为：<span class="GreenColor"><%=usr_mobile%></span>，邮箱为：<span class="GreenColor"><%=usr_email%></span>，若不对，请及时<a href="/manager/usermanager/default2.asp" class="Link_Blue">修改</a>！ </div>
            </td>
          </tr>
                  <tr>
                    <th height="26" align="right" nowrap class="tdbg"> 选择交费年头：</th>
                    <td height="26" class="tdbg" align="left">
                      <select name="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=m_productId%>')">
                      <%for i=1 to 10
					saveStr=""
					    if i=2 then
						saveStr="【买二年送一年】"
					    elseif i=3 then
						saveStr="【买三年送二年】"
						elseif i=5 then
						saveStr="【买五年送五年】"
						elseif i=10 then
						saveStr="【买五年送五年】"
						end if
					  %>
                      <OPTION VALUE="<%=i%>"><%=i%> 年<%=saveStr%></OPTION>
                      <%next%>
                      </select></td>
                  </tr>
                  <tr>
                    <th height="26" align="right" nowrap class="tdbg"> 交费金额：</th>
                    <td height="26" class="tdbg" align="left">
                    <span id="needprice"><b><font color=red><%=renewprice%></font></b>￥/1年</span>                    </td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" style="text-align: center"  class="tdbg">

		  <input type="hidden" value="<%=mailid%>" name="p_id">
          <input type="hidden" name="productType" value="mail">
          <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>正在执行,请稍候..<br></span>
          <INPUT NAME="C1" TYPE="button" class="manager-btn s-btn"   VALUE="　确定续费　" onClick="return dosub(this.form)">        </td>  </tr>
                </tbody>
  </form>
              </table>

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>