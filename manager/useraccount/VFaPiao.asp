<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%
conn.open constr

sub UpdateInvoiceStatus()
    If isdbsql Then
		set lrs=conn.Execute("select f_id,f_username from fapiao where (f_status=0 or f_status=1) and f_fid>0 and not  f_fid is null  and f_username='" & Session("user_name") & "'")
	else
		set lrs=conn.Execute("select f_id,f_username from fapiao where (f_status=0 or f_status=1) and f_fid>0 and not isnull(f_fid) and f_username='" & Session("user_name") & "'")
	End if
	do while not lrs.eof
		CmdString="other" & vbcrlf & "get" & vbcrlf & "entityname:invoice" & vbcrlf & "identity:" & lrs("f_id") & vbcrlf & "." & vbcrlf
		runRet=PCommand(CmdString,lrs("f_username"))
		lrs.moveNext
	loop
	lrs.close
	set lrs=nothing
end Sub

function showStatus(varValue)
  select case varValue
	case 0
		showStatus="<font color=red>待处理</font>"
	case 1
		showStatus="已处理"
	case 2
		showStatus="已寄出"
	case 3
		showStatus="<font color=blue>已拒绝</font>"
  end select
end function

'更新发票状态
Call UpdateInvoiceStatus()

module=Requesta("module")
if module="del" and isNumeric(Requesta("id"))then
  Sql="Select f_status from fapiao where f_username='" & Session("user_name") & "' and f_id=" & Trim(Requesta("id"))
  rs.open Sql,conn,1,3
  if Rs.eof then url_return "未找到此发票",-1
'删除发票时不能再退
'  sql="Update userdetail set u_invoice=u_invoice-" & Rs("f_money") & " where u_name='" & Session("user_name") & "'"
'  conn.Execute(Sql)
'  rs.close
'  Sql="Delete from fapiao where f_username='" & Session("user_name") & "' and f_id=" & Requesta("id") & " and f_status=0"
'  conn.Execute(Sql)
   if rs("f_status")<>"3" then url_return "状态不是拒绝，不能删除",-1
   rs.delete
   rs.close
   url_return "删除成功",-1
   response.End()
end if
rs.open "select * from fapiao where f_username='" & session("user_name") & "' order by f_status,f_SendDate desc" ,conn,3
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-发票查询</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
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
			   <li>发票查询</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
                 <table  class="manager-table">
                 <tr align="center" class='titletr'>
                                                   <th width="8%" class="Title"><strong>编号</strong></th>
                     <th width="11%" class="Title"><strong>发票抬头</strong></th>
                     <th width="6%" class="Title"><strong>金额</strong></th>
                     <th width="13%" class="Title"><strong>发票内容</strong></th>
                     <th width="19%" class="Title"><strong>邮寄地址</strong></th>
                     <th width="7%" class="Title"><strong>邮编</strong></th>
                     <th width="12%" class="Title"><strong>收件人</strong></th>
                     <th width="9%" class="Title"><strong>状态</strong></th>
                     <th width="12%" class="Title"><strong>寄出日期</strong></th>
                     <th width="3%" class="Title"><strong>删</strong></th>
                 </tr>
                                                 <%
                 do while not rs.eof
                 f_id=Rs("f_id")
                 f_no=Rs("f_no")
                 f_title=Rs("f_title")
                 f_money=Rs("f_money")
                 f_content=Rs("f_content")
                 f_address=Rs("f_address")
                 f_zip=Rs("f_zip")
                 f_receive=Rs("f_receive")
                 f_status=Rs("f_status")
                 if Rs("f_SendDate")<>"" then f_SendDate=formatDateTime(Rs("f_SendDate"),2)
                 f_SendDate=Cstr(f_SendDate)
                 if f_status=2 then
                   f_SendDate=Replace(f_SendDate,"-",".")
                 else
                   f_SendDate="&nbsp;"
                 end if

                 f_title2=""
                 f_content2=""
                 if len(f_title)>6 then f_title2=f_title:f_title=left(f_title,6) & ".."
                 if len(f_content)>5 then f_content2=f_content:f_content=left(f_content,5) & ".."
                 %>
                                                 <tr align="center">
                                                   <td width="8%"><%
                 if f_no<>"" then
                   Response.write f_no
                 else
                   Response.write "未分配"
                 end if%></td>
                                                   <td width="11%" title="<%=f_title2%>"><%=f_title%></td>
                                                   <td width="6%"><%=f_money%></td>
                                                   <td width="13%" title="<%=f_content2%>"><%=f_content%></td>
                                                   <td width="19%"><%=f_address%></td>
                                                   <td width="7%"><%=f_zip%></td>
                                                   <td width="12%"><%=f_receive%></td>
                                                   <td width="9%"><%response.write showStatus(f_status)
                 %>                                  </td>
                                                   <td width="12%"><%=f_SendDate%></td>
                                                   <% if f_status=3  then '已处理或已拒绝%>
                                                   <td width="3%"><b><a href="javascript:if (confirm('你确认删除此发票？')) window.location.href='VFaPiao.asp?module=del&id=<%=f_id%>';"  title="删除此发票"><font color="#FF0000">×</font></a></b></td>
                                                   <%else
                     Response.write "<td width=""5%"">-</td>"
                 end if%>
                   </tr>
                     <%
                 rs.moveNext
                 Loop
                 Rs.close
                 %>
                                               </table>

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>