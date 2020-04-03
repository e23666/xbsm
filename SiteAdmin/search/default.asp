<!--#include virtual="/manager/config/config.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE6 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<%
checkclass=trim(requesta("checkclass"))
if checkclass&""="" then checkclass="0"

sqlArray=Array("p_name,产品名,str","p_agent_price,价格,int","buy_num,数量,int","datetime,提交时间,date","makedate,开通日期,date")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
conn.open constr
sql="select * from searchlist where u_id>0 and check='" & checkclass &"' "  & newsql
rs.open sql,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<script language="javascript">
function docheck(v){
	document.form1.action +="?checkclass="+ v;
	document.form1.submit();
}
</script>
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
<table width="100%" border="0" cellpadding="4" cellspacing="1" bordercolordark="#ffffff" class="border">
  <form name="form1" action="<%=request("script_name")%>" method="post">
    <tr>
      <td colspan="6" class="tdbg" nowrap><%=searchlist%>
        <input name="checkclass" type="radio" value="0" <%if checkclass="0" then response.write "checked"%> onClick="docheck(this.value)">
        未处理&nbsp;&nbsp;
        <input name="checkclass" type="radio" value="1" <%if checkclass="1" then response.write "checked"%> onClick="docheck(this.value)">
        处理完毕&nbsp;&nbsp;
        <input name="checkclass" type="radio" value="-1" <%if checkclass="-1" then response.write "checked"%> onClick="docheck(this.value)">
        被拒绝的&nbsp;&nbsp;
        <input name="checkclass" type="radio" value="-2" <%if checkclass="-2" then response.write "checked"%> onClick="docheck(this.value)">
        废弃的 </td>
    </tr>
    <tr class="Title">
      <td align="center" nowrap ><strong>产品名</strong></td>
      <td align="center" nowrap ><strong>价格</strong></td>
      <td align=center nowrap ><strong>数量</strong></td>
      <td align=center nowrap ><strong>提交/开通日期</strong></td>
      <td align=center nowrap ><strong>状态</strong></td>
    </tr>
    <%do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
%>
    <tr align=middle bgcolor="<%=tdcolor%>">
      <td align="center" class="tdbg"><a href="m_default.asp?id=<%=rs("id")%>"><%=rs("p_name")%>(<%=ucase(rs("p_proid"))%>)</a></td>
      <td align="center" nowrap class="tdbg"><%=rs("p_agent_price")%></td>
      <td align=center nowrap class="tdbg"><%=rs("buy_num")%></td>
      <td align=center nowrap class="tdbg"><%=formatDateTime(rs("datetime"),2)%>/
        <% if isDate(rs("makedate")) then
						Response.write formatDateTime(rs("makedate"),2)
					 else
					   Response.write "--"
					 end if%></td>
      <td align=center nowrap class="tdbg"><%
                    If rs("check")="1" Then 
                         Response.Write "处理完毕"
                       ElseIf rs("check")="-1" Then
					      Response.Write "订单被拒绝"
                       ElseIf rs("check")="-2" Then
					      Response.Write "订单已废弃"
					   else
					      Response.Write "未处理"
					End if
 %></td>
    </tr>
    <%    
 
	 	rs.movenext  
		cur=cur+1   
	 loop     
   %>
    <tr align="center" bgcolor="#FFFFFF">
      <td colspan="6" class="tdbg"><%=pagenumlist%></td>
    </tr>
  </form>
</table>
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
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
