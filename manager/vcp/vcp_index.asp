<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
if session("u_sysid")="" then 
   Response.write "<script language=javascript>alert('请先登录');top.location.href='/login.asp';</script>"
   Response.end
end if
Sql="Select u_namecn from userdetail where u_id=" & session("u_sysid")
Rs.open Sql,conn,1,1
name=Rs("u_namecn")
Rs.close
Sql="Select C_AgentType,ModeD from Fuser Where u_id=" & Session("u_sysid") & " and l_ok="&PE_True&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "请先申请成为VCP",-1
Prate=Rs("C_AgentType")
ModeD=Rs("ModeD")
Session("ModeD")=ModeD
Rs.close
Sql="Select count(*) as TotalUser from userdetail where f_id=" & Session("u_sysid") & " and u_id <>" & Session("u_sysid")
 Rs.open Sql,Conn,1,1
 users=Rs("TotalUser")
  Rs.close
Sql="Select D_end,N_total,N_remain,N_Ptotal,C_domain from Fuser Where u_id=" & Session("u_sysid")
Rs.open Sql,conn,1,1

LastPay=Rs("D_end")
N_Total=Rs("N_total")
R_Total=Rs("N_remain")
N_Ptotal=Rs("N_Ptotal")
C_domain=Rs("C_domain")
Rs.close

sql="select sum(v_price) as uprice,sum(v_royalty) as royalty from vcp_record where v_fid="&session("u_sysid")
rs.open sql,conn,1,1
if not rs.eof then
	uprice=rs("uprice")
	royalty=rs("royalty")
end if
rs.close
if trim(uprice)&""="" then uprice=0
if trim(royalty)&""="" then royalty=0

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-VCP业务管理</title>
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
        <li><a href="/manager/vcp/vcp_index.asp">VCP业务管理</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table class="manager-table">
        <tr >
          <th colspan=2>尊敬的
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            模式合作伙伴<%=name%>，您好！(<a href="vcp_Edit.asp" style="color:red;">修改资料</a>)</th>
        </tr>
        <tr>
          <td colspan="2"><strong>统计信息</strong></td>
        </tr>
        <tr>
          <td height="56" colspan="2" >部分用户由于提供的汇款方式有误，如果结算后没有收到汇款，请修改资料后与财务部联系，QQ：<%=oicq%> 电话：<%=telphone%><br></td>
        </tr>
        <tr>
          <th width="40%" align="right" >注册用户数：</th>
          <td width="60%" align="left"><%=users%>（人）</td>
        </tr>
        <tr>
          <th align="right" >用户总消费：</th>
          <td  align="left">￥<%=uprice%></td>
        </tr>
        <tr>
          <th align="right" >结算总额：</th>
          <td align="left" >￥<%=formatnumber(N_Ptotal,2,-1)%></td>
        </tr>
        <tr>
          <th align="right" >上次打款时间：</th>
          <td align="left" ><%=formatDateTime(lastPay,1)%></td>
        </tr>
        <tr>
          <th align="right" >打款总额：</th>
          <td  align="left">￥<%=formatnumber(N_Total,0,-1)%>元 </td>
        </tr>
        <tr bgcolor="#ffffff">
          <th align="right" >当前利润：</th>
          <td align="left" >￥<%=royalty%>元 </td>
        </tr>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
