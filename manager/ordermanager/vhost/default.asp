<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
act=requesta("act")
if act="del" then
	id=requesta("id")
	if id<>"" then
		sql="delete from Prehost where OrderNo='" & id & "' and u_name='"& session("user_name") &"'"
		conn.execute sql
		alert_redirect "删除成功",request("script_name")
	end if
end if
sqlArray=Array("ftpaccount,ftp名,str","OrderNo,订单号,str","years,订购年限,int","price,单价,int","proid,产品型号,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="Select * from Prehost Where U_Name='" & Session("user_name") & "' " & newsql & " order by opened,sdate desc"
rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-虚拟主机订单</title>
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
          <div class="tab">虚拟主机订单</div>
          <div class="table_out">
            <table   bordercolor="#FFFFFF" cellpadding="0" cellspacing="0" id="AutoNumber3" style="border-collapse: collapse" width="100%" height="218">
  <tr>
    <td height="175" width="99%" valign="top"><table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border managetable tableheight">
        <form name="form1" action="<%=request("script_name")%>" method="post">
          <tr align="center" class='titletr'>
            <td width="16%"><strong>订单号</strong></td>
            <td width="14%"><strong>产品名</strong></td>
            <td width="14%"><strong>单价</strong></td>
            <td width="17%"><strong>总价</strong></td>
            <td width="14%"><strong>下单时间</strong></td>
            <td width="12%"><strong>状态</strong></td>
            <td width="13%"><strong>操作</strong></td>
          </tr>
          <%
	Do While Not rs.eof And cur<=setsize
		tdcolor="#ffffff"
		if cur mod 2 =0 then tdcolor="#efefef"
		d_id=rs("OrderNo")
		 OrderID=100000 + clng(d_id)
		 s_comment=Rs("ftpaccount")
		 regDate=formatdatetime(Rs("sdate"),2)
		 years=Rs("years")
		 price=Rs("price")
		 proID=Rs("proid")
		 opened=rs("opened")		 
		 allprice=GetNeedPrice(session("user_name"),proID,years,"new")
		
	%>
          <tr bgcolor="<%=tdcolor%>">
            <td nowrap="nowrap" class="tdbg"><%=orderID%></td>
            <td nowrap="nowrap" class="tdbg"><%=s_comment& "["& proid &"]"%></td>
            <td nowrap="nowrap" class="tdbg"><%=Price&"￥"%></td>
            <td nowrap="nowrap" class="tdbg"><%=allprice&"￥/" & years & "年"%></td>
            <td nowrap="nowrap" class="tdbg"><%=regDate%></td>
            <td nowrap="nowrap" class="tdbg"><%=showstatus(opened)%></td>
            <td align="center" nowrap="nowrap" class="tdbg">
            <%if not opened then%>
            <a href="modify.asp?id=<%=d_id%>">管理</a>
            <%end if%>
            <a href="#" onClick="javascript:if(confirm('确定删除吗?')){location.href='<%=request("script_name")%>?act=del&id=<%=d_id%>'}">删除</a>            </td>
          </tr>
          <%
		cur=cur+1
		rs.movenext
		
	Loop
	rs.close
	conn.close
	%>
          <tr bgcolor="#FFFFFF">
            <td colspan ="9" align="center" class="tdbg"><%=pagenumlist%> </td>
          </tr>
          <tr>
            <td colspan="9" class="tdbg"><%=searchlist%></td>
          </tr>
        </form>
    </table></td>
  </tr>
</table>
<%
Function showstatus(svalues)

	if svalues then
		showstatus="<font color=#00cc00><b>完成</b></font>"
	elseif not svalues then
		showstatus="<font color=#999999>未开通</font>"
	else
		showstatus="<font color=#999999>未完成或未知</font>" & svalues
	end if
	

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
