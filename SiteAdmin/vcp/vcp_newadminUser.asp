<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" href="vcp_style.css" type="text/css">
<title>vcp用户管理</title>
<style type="text/css">
<!--
.STYLE1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<%
function txt2Sig(strSig)
	select case trim(strSig)
	  case "eq"
		 txt2Sig="="
	  case "gt"
		 txt2Sig=">"
	   case "ge"
		 txt2Sig=">="
	   case "lt"
		 txt2Sig="<"
	   case "le"
		 txt2Sig="<="
	   case "ne"
		 txt2Sig="<>"
	   case "$"
		 txt2Sig="Like"
	end select
end function
function getsqlstring(str,cond,svalue)
	sqlstr11=""
	strno=""
	if cond="Like" then
		strno="%"
	end if
	select Case trim(str)
		 case "username"
		 	sqlstr11=" and "& str& " "  & cond & " " & "'" & strno &  trim(svalue)  & strno & "'"
         case "C_domain" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "D_End" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "N_total"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "N_remain"
		 	sqlstr11=" and isnull((select sum(v_royalty) from vcp_record where v_start=0 and v_fid=fuser.u_id group by v_fid),0)"& " " & cond & " "& "'"  & strno & trim(svalue) & strno & "'"
	end select
	getsqlstring=sqlstr11
end function
conn.open constr
pageNo=requesta("pageNo")
str=trim(requesta("str"))
toid=trim(requesta("toid"))
'searchItem condition searchValue
searchItem=request("searchItem")
condition=request("condition")
searchValue=requesta("searchValue")
otherhrefstr=""

if searchValue<>"" then
	cond=txt2Sig(condition)
	otherhrefstr="&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue
	newsqlstring = getsqlstring(searchItem,cond,searchValue)
	
end if
if str="add" and toid<>"" then
	cdomain=trim(requesta("moddomain"))
	sql="update fuser set c_domain='"& cdomain &"' where id=" & toid
	conn.execute sql
	response.write "<script>location.href='"& request("script_name") &"?pageNo="& pageNo & otherhrefstr &"'</script>"
	response.end
end if

Sql="Select sum(N_total) as Ntotal from fuser where L_ok="&PE_True&""
Set RsTemp=conn.Execute(Sql)
 if isNumeric(RsTemp("Ntotal")) then monTotal=RsTemp("Ntotal")
RsTemp.close
Set RsTemp=nothing

sql="select *,(select sum(v_royalty) from vcp_record where v_start=0 and v_fid=fuser.u_id group by v_fid) as overplus,(select count(*) from userdetail where f_id=fuser.u_id) as countuser from fuser where L_ok="&PE_True&" "& newsqlstring &" order by ModeD,D_date desc"
rs.open sql,conn,1,1
		 if not isNumeric(pageNo) then pageNo=1
		 if pageNo<1 then PageNo=1
		 pageSizes=15
		 Rs.pageSize=pageSizes
		 pageCounts=Rs.pageCount
		 sUsers=Rs.RecordCount
		
		 if pageNo>pageCounts then page=pageCounts
		 if not Rs.eof then Rs.AbsolutePage=pageNo
		 forstr1=clng(pageNo)-5
		 forstr2=clng(pageNo)+5
		 if forstr1<1 then forstr1=1
		 if forstr2>pageCounts then forstr2=pageCounts
		 pagestr=""

		 for ii=forstr1 to forstr2
		 	if clng(ii)<>clng(pageNo) then
				pagestr=pagestr & "<a href='"&request("script_name")&"?pageNo="& ii & otherhrefstr &"'>"& ii & "</a> "
			else
				pagestr=pagestr &"<b><font color=red>"& ii &"</font></b> "
			end if
		 next

		 if forstr1>1 then lookother1="<a href='"&request("script_name")&"?pageNo="& (forstr1-(1+5)) & otherhrefstr &"'><b>...</b></a> "
		 if forstr1<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+5)) & otherhrefstr &"'><b>...</b></a> "
%>
<body>
<table width="100%" border="1" cellspacing="0" cellpadding="4" bordercolor="#006699" bordercolordark="#ffffff">
<form name=form1 action="<%=request("script_name")%>" method=post >
  <tr>
    <td colspan=9>
    <a href="vcp_newautoSettle.asp">自动结算</a><br>
    总共打款:<%=monTotal%>￥&nbsp;

    </td>
  </tr>
  <tr>
    <td colspan=9 align="center" nowrap="nowrap">
    <a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a>
    总页数:<%=pageCounts%>&nbsp;
    总条数(用户数):<%=sUsers%>
    </td>
  </tr>
  <tr align="center">
    <td width="5%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">序号</span></td>
    <td width="15%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">用户名</span></td>
    <td width="8%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">模式</span></td>
    <td width="8%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">域名</span></td>
    <td width="14%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">注册用户</span></td>
    <td width="14%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">打款总计</span></td>
    <td width="14%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">上次打款</span></td>
	<td width="18%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">余额</span></td>
    <td width="4%" nowrap="nowrap" bgcolor="#3399CC"><span class="STYLE1">操作</span></td>
  </tr>
  <%
  if not rs.eof then
  	 cur=1
	  do while not rs.eof and cur<=pageSizes
	  	  username=rs("username")
		  modeD=rs("modeD")
		  domain=rs("c_domain")
		  countuser=rs("countuser")
		  total=Rs("N_total")
		  dateEnd=rs("D_end")
		  overplus=rs("overplus")
		  id=trim(rs("id"))
		  	if isnull(overplus) or overplus="" then overplus=0
			if len(domain)=0 then domain="&nbsp;"
		    if ModeD then
				MString="<font color=red><b>D</b></font>"
			else
				MString="<font color=blue><b>C</b></font>"
			end if
		  
		  trcolor="#ffffff"
		  if cur mod 2 =0 then trcolor="#efefef"
		  
		  if str="mod" and toid=id then'修改----------------------------
		  %>
      <tr bgcolor="#ccffcc">
		<td><%=cur%></td>
		<td><%=username%></td>
		<td><%=MString%></td>
        <td nowrap="nowrap"><input type=text value="<%=domain%>" name="moddomain"></td>
        <td><%=countuser%></td>
        <td><%=total%></td>
        <td><%=formatDateTime(dateEnd,1)%></td>
        <td><%=overplus%></td>
        <td><a href=# onClick="javascript:document.form1.action='<%=request("script_name")%>?pageNo=<%=pageNo%>&str=add&toid=<%=id%><%=otherhrefstr%>';document.form1.submit();">确定</a></td>
	  </tr>
          <%
		  else
	  %>
	  <tr bgcolor="<%=trcolor%>">
		<td><%=cur%></td>
		<td><%=username%></td>
		<td><%=MString%></td>
        <td nowrap="nowrap"><%=domain%></td>
        <td><%=countuser%></td>
        <td><%=total%></td>
        <td><%=formatDateTime(dateEnd,1)%></td>
        <td><%=overplus%></td>
        <td><a href="<%=request("script_name")%>?pageNo=<%=pageNo%>&str=mod&toid=<%=id%><%=otherhrefstr%>">修改</a></td>
	  </tr>
	  <%
	  	 end if
	  cur=cur+1
	  rs.movenext
	  loop
  end if
  rs.close
  %>
  <tr>
    <td colspan=9 nowrap="nowrap">
     <select name="searchItem">
         <option value="username" <% if searchItem="username" then Response.write " selected"%>>用户名</option>
         <option value="C_domain" <% if searchItem="C_domain" then Response.write " selected"%>>域名</option>
         <option value="D_End" <% if searchItem="D_End" then Response.write " selected"%>>上次打款</option>
         <option value="N_total" <% if searchItem="N_total" then Response.write " selected"%>>打款总计</option>
         <option value="N_remain" <% if searchItem="N_remain" then Response.write " selected"%>>余款</option>
     </select>
      <select name="condition">
          <option value="eq" <% if condition="eq" then Response.write " selected"%>>=</option>
          <option value="gt" <% if condition="gt" then Response.write " selected"%>>&gt;</option>
          <option value="ge" <% if condition="ge" then Response.write " selected"%>>&gt;=</option>
          <option value="lt" <% if condition="lt" then Response.write " selected"%>>&lt;</option>
          <option value="le" <% if condition="le" then Response.write " selected"%>>&lt;=</option>
          <option value="ne" <% if condition="ne" then Response.write " selected"%>>&lt;&gt;</option>
          <option value="$" <% if condition="$" then Response.write " selected"%>>包含</option>
     </select>
    <input type="text" name="searchValue" size="20" value=<%=SearchValue%>>
    <input type="submit" value="查 询">
    </td>
  </tr>
    <tr>
    <td colspan=9 align="center" nowrap="nowrap">
    <a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a>
    总页数:<%=pageCounts%>&nbsp;
    总条数(用户数):<%=sUsers%>
    </td>
  </tr>
  </form>
</table>


</body>
</html>
