<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
id=Requesta("id")
If id="" Then url_return "对不起，请选择产品ID号 !",-1
conn.open constr
sql="select * from searchlist where id="&id
rs.open sql,conn,1,1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE6 {color: #FFFFFF; font-weight: bold; }
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 推广业务管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">推广业务管理</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />
<TABLE width="100%" border=0 align=center  cellPadding=2 cellSpacing=0 class="border">
<TBODY> 
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">用户名：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("u_name")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">产品名称：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("p_name")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">产品ID号：</TD>
                  <TD class="tdbg">&nbsp;<%=ucase(rs("p_proid"))%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">产品说明：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("p_info")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">产品单价：</TD>
                  <TD class="tdbg"><B><FONT 
        color=#084b8e>&nbsp;￥<%=rs("p_agent_price")%></FONT></B></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">购买数量：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("buy_num")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">联系人姓名：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("contact")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">公司名称：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("company")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">联系电话：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("phone")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">Email 地址：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("email")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">网站 URL 地址：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("url")%> </TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">备注：</TD>
                  <TD class="tdbg">&nbsp;<%=rs("memo")%></TD>
    </TR>
                <TR bgcolor="#FFFFFF"> 
                  <TD align=right class="tdbg">状态：</TD>
                  <TD class="tdbg">&nbsp; <%
                    If rs("check")="1" Then 
                         Response.Write "处理完毕"
                       ElseIf rs("check")="-1" Then
					      Response.Write "订单被拒绝"
                       ElseIf rs("check")="-2" Then
					      Response.Write "订单已废弃"
					   else
					      Response.Write "未处理"
					End if
                    %> </TD>
    </TR>
                <form <%if ucase(rs("p_proid"))<>"CN001" then%>action="setoksearch.asp" 
<%else
%>
action="setokdomain.asp" 
<%end if

%>meth=post>
                  <TR bgcolor="#FFFFFF"> 
                    <TD align="right" class="tdbg">备注/拒绝原因： </TD>
                    <TD align="center" class="tdbg"> 
                    <textarea name="Mark" cols="30" rows="5"><%=rs("Mark")%></textarea>                    </TD>
                  </TR>
                  <%
If rs("check")=0 Then

%> 
                  <TR bgcolor="#FFFFFF"> 
                    <TD colspan="2" align="center" class="tdbg"> 
					  <input type="button" name="sub1" value=" 审 核 通 过 " onClick="subForm(this.form,'pass')">
					  <input type="button" name="sub1" value=" 拒 绝 订 单 " onClick="subForm(this.form,'refuse')">
					  <input type="button" name="sub1" value=" 废 弃 订 单 " onClick="subForm(this.form,'drop')">
                      <input type="hidden" name="action" value="" >
                      <input type="hidden" name="id" value="<%=rs("id")%>">                    </TD>
                  </TR>
                  <%
else
%>                  <TR bgcolor="#FFFFFF"> 
                    <TD colspan="2" align="center" class="tdbg">
					  <input type="submit" name="submit1" value=" 修 改 备 注 ">
                      <input type="hidden" name="action" value="keep">
                      <input type="hidden" name="id" value="<%=rs("id")%>">               </TD>
                  </TR>
<%
End If
%> 
                </form>
<script language=javascript>
function subForm(form,op){
	if (op=="refuse"){
			if (form.Mark.value==""){
				alert("给个拒绝的理由，好吗？^_^");
				form.Mark.value="请在此输入理由";
				form.Mark.select();
				form.Mark.focus();
				return false;
			}
		}
	form.action.value=op;
	form.submit();
	}
</script>
              </TABLE>      
<%
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
%><!--#include virtual="/config/bottom_superadmin.asp" -->
