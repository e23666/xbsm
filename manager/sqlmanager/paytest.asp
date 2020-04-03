<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.charset="gb2312"
ID=Trim(Requesta("id"))
act=trim(lcase(requesta("act")))

conn.open constr

if not isNumeric(ID) or id="" then url_return "参数错误",-1
Sql="Select * from databaselist where dbsysid=" & ID & " and dbu_id=" & Session("u_sysid")
Rs.open Sql,conn,1,1
if Rs.eof then url_return "未找到此主机",-1
s_buyDate=Rs("dbbuyDate")		'原购买时间
s_year=Rs("dbyear")		 		'原主机年限
s_ProductId=Rs("dbproid")	'原型号
s_price=getneedprice(session("user_name"),s_ProductId,1,"renew")			'原价格
m_bindname=rs("dbname")	
m_buytest=rs("dbbuytest")

if not m_buytest then
	Url_return "抱歉，正式mssql不用转正",-1
end if	
'''''''''''''''''''操作''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><title>用户管理后台-Mssql数据库转正</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
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
    			   <li>Mssql数据库转正</li>
    			 </ul>
    		  </div>
      <div class="manager-right-bg">

        <div class="main_table">
          <div class="table_out">
         
         <table width="100%" border="0" align="center" cellpadding="6" cellspacing="0" class="manager-table">
<form name="form1" method="post" action="../config/paytest.asp">
					<tbody> 
					<tr> 
					  <th width="22%" align="right" class="tdbg">MSSQL名称</th>
					  <td width="58%" align="left" height="15" class="tdbg"><%=Rs("dbname")%></td>
					</tr>
                                    
					<tr> 
					  <th align="right" class="tdbg"><font color="#000000">年 限</font></th>
					  <td height="16" align="left"  class="tdbg"> <%=Rs("dbyear")%></td>
					</tr>
					<tr> 
					  <th align="right" class="tdbg">
					  <p align="right">开通日期：</p>                              </th>
					  <td height="2" align="left" class="tdbg"><%=formatDateTime(s_buydate,2)%></td>
					</tr>
					<tr> 
					  <th align="right" class="tdbg">
					  <p align="right">到期日期：</p>                              </th>
					  <td height="26" align="left" class="tdbg"><%=formatDateTime(DateAdd("yyyy",s_year,s_buydate),2)%></td>
					</tr>
					
					<tr> 
					  <th height="26" align="right" class="tdbg"> 类型：</th>
					  <td height="26" align="left" class="tdbg"><%=s_ProductId%></td>
					</tr>
					<tr> 
					  <th height="26" align="right" bgcolor="#FFFFFF" class="tdbg">转正所需金额：</th>
					  <td height="26" align="left" class="tdbg" ><%=GetNeedPrice(Session("user_name"),s_ProductId,s_year,"new")%>元</td>
					</tr>
					<tr align="center" class="no-border">
					<td></td>
					  <td  class="tdbg" align="left">
    	              <input type="hidden" name="productType" value="mssql">
	                  <input type="hidden" value="<%=ID%>" name="p_id">					 
					  <INPUT NAME="act" TYPE="submit" CLASS="app_ImgBtn_Big manager-btn s-btn" id="act" onClick="return confirm('确定转正操作吗?')"  VALUE="确定转正">
					  </td>
					</tr>
					</tbody> 
        </form>
				  </table>
         
         
         
         
       



         
         
         
         

         
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 





</body>
</html>

