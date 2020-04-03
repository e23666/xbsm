<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
id=requesta("id")
If id="" Then url_return "对不起，请选择推广产品 !",-1
conn.open constr
sql="select * from searchlist where u_id="&session("u_sysid")&" and id="& id &""
rs.open sql,conn,1,1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><title>用户管理后台-推广产品管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
</HEAD>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">推广产品管理</div>
          <div class="table_out">
         
         <table width="100%" border=0 align=center  cellpadding=4 cellspacing=1 class="border managetable tableheight">
<tbody>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">产品名称：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("p_name")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">产品ID号：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=ucase(rs("p_proid"))%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">产品说明：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("p_info")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">产品单价：</td>
                            <td bgcolor="#FFFFFF" class="tdbg"><b><font 
        color=#084b8e>&nbsp;￥<%=rs("p_agent_price")%></font></b></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">购买年限/数量：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("buy_num")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF">
                            <td align=right bgcolor="#FFFFFF" class="tdbg">订单总金额：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;￥<%=rs("p_agent_price")*rs("buy_num")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">联系人姓名：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("contact")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">公司名称：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("company")%>                            </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">联系电话：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("phone")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">Email 地址：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("email")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">网站 URL 地址：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("url")%> </td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">备注：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp;<%=rs("memo")%></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td align=right bgcolor="#FFFFFF" class="tdbg">状态：</td>
                            <td bgcolor="#FFFFFF" class="tdbg">&nbsp; 
                            <%
                    If rs("check")="1" Then 
                         Response.Write "处理完毕"
                       ElseIf rs("check")="-1" Then
					      Response.Write "订单被拒绝"
                       ElseIf rs("check")="-2" Then
					      Response.Write "订单已废弃"
					   else
					      Response.Write "未处理"
					End if
 %>                            </td>
                          </tr>
                          <%
If rs("check")="0" Then 
%>
                          <tr align="center" bgcolor="#FFFFFF"> 
                            <td colspan="2" bgcolor="#FFFFFF" class="tdbg"> <a href="setoksearch.asp?action=drop&id=<%=rs("id")%>">废弃订单</a>                            </td>
                          </tr>
                          <%
End  if
%>
</table>
<%
conn.close
Function showstatus(svalues)
    Select Case svalues
      Case 0   '运行
        showstatus="<img src=/images/green1.gif width=17 height=17>"
      Case -1'
        showstatus="<img src=/images/nodong.gif width=17 height=17>"
      Case else
        showstatus="<img src=/images/nodong.gif width=17 height=17>"
    End Select
End Function
%>
         
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>

</body>
</html>

