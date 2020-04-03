<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/class/Page_Class.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
Check_Is_Master(6):Response.Charset="gb2312":Response.Buffer=True:act=requesta("act"):conn.open constr
e_type=requesta("e_type")
keywords=requesta("keywords")
 
cur = 1 : setsize = requesta("psize") : if not isnumeric(setsize&"") then setsize=15 else setsize=clng(setsize)
' --------------------------------------------------------------------------------------
if not isnumeric(e_type&"") then e_type=""
if e_type<>"" then
newsql=newsql&" and  e_type="&e_type
end if

if trim(keywords)<>"" then
newsql=newsql&" and  (e_uname='"&keywords&"' or ywname='"&keywords&"')"
end if
 

isql="select * from event_logs "
isql=isql & " where 1=1 " & newsql
isql=isql & " order by  e_sysid desc"

rs.open isql,conn,1,1
 
othercode="&e_type="&e_type&"&keywords="&keywords
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>业务操作过户日志</title>
<script type="text/javascript" src="/jscripts/check.js"></script>
<script type="text/javascript" src="/jscripts/dateinput.min.js"></script>
<link href="/jscripts/dateinput.min.css" rel="stylesheet">
<link href="../css/Admin_Style.css" rel="stylesheet">
 </head>

<body style="padding:0 5px;">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='0' style="margin:1px 0">
  <tr class='topbg'>
    <th height="25" style="font-weight:bold;font-size:14px;">业务操作过户日志</th>
  </tr>
</table>

<br />
 <form method="post" action="?" name="frmsearch">
 类型:<SELECT NAME="e_type">
     <option value="">--不限--</option>
	 <option value="0">虚拟主机</option>
	 <option value="1">域名</option>
	 <option value="2">企业邮局</option>
	 <option value="3">vps/弹性云</option>
	 <option value="4">数据库</option>
	  <option value="5">小程序</option>
 </SELECT>
 关键字:<INPUT TYPE="text" NAME="keywords" placeholder="帐号/业务名称"><INPUT TYPE="submit" value="查询">
</form>
<br />


<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border" id="datalist">
<thead>
<tr class="Title">
    <th>编号</th>
    <th>业务类型</th>
    <th>操作人</th>
    <th>业务名称</th>
    <th>操作事件</th>
    <th>操作时间</th>
</tr>
</thead>
<tbody><%
while not rs.eof and cur<=setsize
	for i=0 to Rs.Fields.Count-1:execute( "i_" & rs.Fields(i).Name & "=rs.Fields(" & i & ").value"):next
 
	 
%><tr>
    <td><%=i_e_sysid%></td>
    <td height="25"><%
	select case cstr(i_e_type)
	case "0"
	response.write("虚拟主机")
	case "1"
	response.write("域名")
	case "2"
	response.write("企业邮局")
	case "3"
	response.write("vps/弹性云")
	case "4"
	response.write("数据库")
	case "5"
	response.write("小程序")
	case else
    response.write("未知")
	end select
	%> </td>
    <td><div style='line-height:100%'><%=i_e_uname%></div></td>
    <td><div><%=i_ywname%></div></td>
    <td><%=i_e_Event%></td>
    <td><%=i_e_addtime%></td> 
</tr><%
	cur=cur+1
	rs.movenext
wend
rs.close
%></tbody>
</table>
 <div class="pagenav"><center><%=pagenumlist%></center></div>


</body>
</html> 