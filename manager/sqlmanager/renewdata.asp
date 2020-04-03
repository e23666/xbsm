<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.buffer=true
response.charset="gb2312"
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
p_id=requesta("id")
if not isnumeric(p_id) or p_id="" then url_return "参数传递错误",-1
sqlstring="select * from databaselist where dbsysid="&p_id&" and dbu_id=" & session("u_sysid")
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "没有找到此mssql数据库",-1
dbname=rs("dbname")
dbyear=rs("dbyear")
dbbuydate=formatDateTime(rs("dbbuydate"),2)
dbexpdate=formatdateTime(rs("dbexpdate"),2)
dbproid=rs("dbproid")
'm_buytest=rs("m_buytest")
'if s_buytest then response.redirect "paytest.asp?p_id=" & hostid & "&productType=vhost":response.end
renewprice=getneedprice(session("user_name"),dbproid,1,"renew")
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid;
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
			   			   <li><a href="/manager/sqlmanager/">Mssql数据库管理</a></li>
               			   <li>Mssql续费</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		   <div style="border:dashed 1px #ff0000; padding:7px; background:#ffff99; width:99%; margin:10px auto; margin-bottom:5px;color:red">如是通过虚拟主机开通的赠送数据库请不要单独续费,只用将相应虚拟主机续费即可正常使用</div>
		    <form name="form1" method="post" action="../config/renew.asp" >
               <table class="manager-table">

                               <tbody>
                                 <tr>
                                   <th width="19%" align="right" nowrap bgcolor="#FFFFFF" class="tdbg">MSSQL名：</th>
                                   <td width="81%" height="15" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbname%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><font color="#000000"> 年 限：</font></th>
                                   <td height="16" bgcolor="#FFFFFF"align="left" class="tdbg"><%=dbyear%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">注册日期：</p></th>
                                   <td height="2" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbbuydate%></td>
                                 </tr>
                                 <tr>
                                   <th align="right" nowrap bgcolor="#FFFFFF" class="tdbg"><p align="right">到期日期：</p></th>
                                   <td height="26" bgcolor="#FFFFFF" align="left" class="tdbg"><%=dbexpdate%></td>
                                 </tr>
                                 <tr>
                                   <td colspan="2" align="center" BGCOLOR="#FFFFFF" class="tdbg"><div class="redAlert_Box RedLink">为了使您能快捷、准确地收到续费通知等信息，请核实您的手机为：<span class="GreenColor"><%=usr_mobile%></span>，邮箱为：<span class="GreenColor"><%=usr_email%></span>，若不对，请及时<a href="/manager/usermanager/default2.asp" class="Link_Blue">修改</a>！ </div></td>
                                 </tr>
                                 <tr>
                                   <th height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> 选择交费年头：</th>
                                   <td height="26" bgcolor="#FFFFFF" class="tdbg" align="left"><select name="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=dbproid%>')">
                                       <%
               						showArray=split("|(买2年送1年)|(买3年送2年)|(买5年送5年)|(买10年送10年)","|")
               						xb=0
               						for each i in split("1,2,3,5,10",",")%>
                                       <OPTION VALUE="<%=i%>"><%=i%> 年<%=showArray(xb)%></OPTION>
                                       <%
               						xb=xb+1
               						next%>
                                     </select></td>
                                 </tr>
                                 <tr>
                                   <th height="26" align="right" nowrap bgcolor="#FFFFFF" class="tdbg"> 交费金额：</th>
                                   <td height="26" bgcolor="#FFFFFF" class="tdbg" align="left"><span id="needprice"><b><font color=red><%=renewprice%></font></b>￥/1年</span></td>
                                 </tr>
                                 <tr>
                                   <td height="1" colspan="2" align="center" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" value="<%=p_id%>" name="p_id">
                                     <input type="hidden" name="productType" value="mssql">
                                     <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>
                                     正在执行,请稍候..<br>
                                     </span>
                                     <INPUT NAME="C1" TYPE="button" class="manager-btn s-btn" VALUE="　确定续费　" onClick="return dosub(this.form)">
                                 </tr>
                               </tbody>

                           </table>
                            </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>