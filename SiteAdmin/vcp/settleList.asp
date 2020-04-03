<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
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
		 case "u_name"
		 	sqlstr11=" and "& str& " "  & cond & " " & "'" & strno &  trim(svalue)  & strno & "'"
         case "s_date" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "s_money" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
        
	end select
	getsqlstring=sqlstr11
end function
conn.open constr

uid=trim(requesta("uid"))
pageNo=requesta("pageNo")
if uid<>"" then
	uidsqlstring = " and s_userid="& uid
end if
searchValue=requesta("searchValue")
searchItem=requesta("searchItem")
condition=requesta("condition")
if searchValue<>"" then
	cond=txt2Sig(condition)
	otherhrefstr="&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue

	newsqlstring = getsqlstring(searchItem,cond,searchValue)
end if
sql="select b.u_name,a.* from vcp_settleList a inner join userdetail b on a.s_userid=b.u_id where 1=1 "& uidsqlstring & newsqlstring &" order by s_date desc"

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
				pagestr=pagestr & "<a href='"&request("script_name")&"?pageNo="& ii & otherhrefstr & "&uid="& uid &"'>"& ii & "</a> "
			else
				pagestr=pagestr &"<b><font color=red>"& ii &"</font></b> "
			end if
		 next

		 if forstr1>1 then lookother1="<a href='"&request("script_name")&"?pageNo="& (forstr1-(1+5)) & otherhrefstr& "&uid="& uid &"'><b>...</b></a> "
		 if forstr1<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+5)) & otherhrefstr& "&uid="& uid &"'><b>...</b></a> "

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>VCP模式管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="vcp_newautoSettle.asp">自动结算</a> | <a href="adver.asp">广告管理</a> | <a href="settlelist.asp">查看打款记录</a></td>
  </tr>
</table> <br>
<table width="100%" border="0" cellpadding="5" cellspacing="0" class="border">
<form name=form1 action="<%=request("script_name")& "?uid="& uid%>" method=post >
  <tr>
    <td align="center" class="tdbg"><select name="searchItem">
         <option value="u_name" <% if searchItem="u_name" then Response.write " selected"%>>用户名</option>
         <option value="s_date" <% if searchItem="s_date" then Response.write " selected"%>>打款时间</option>
         <option value="s_money" <% if searchItem="s_money" then Response.write " selected"%>>打款金额</option>
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
    <input type="submit" value="查 询"></td>
  </tr>
</form>
</table>
<br>

<table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border">
<form name=form1 action="<%=request("script_name")& "?uid="& uid%>" method=post >
<tr align="center">
<td class="Title"><span class="STYLE1"><strong>序号</strong></span></td>
<td class="Title"><span class="STYLE1"><strong>用户</strong></span></td>
<td class="Title"><span class="STYLE1"><strong>结算时间</strong></span></td>
<td class="Title"><span class="STYLE1"><strong>结算金额</strong></span></td>
</tr>
<%
if not rs.eof then
	cur=1
	do while not rs.eof and cur<=pageSizes
		u_name=rs("u_name")
		s_date=formatDateTime(rs("s_date"),2)
		s_money=rs("s_money")
%>
<tr>
<td class="tdbg"><%=cur%></td>
<td class="tdbg"><%=u_name%></td>
<td class="tdbg"><%=s_date%></td>
<td class="tdbg"><%=s_money%></td>
</tr>
<%
	rs.movenext
	cur=cur+1
	loop
end if
rs.close
%>
<tr>
    <td colspan=9 align="center" nowrap="nowrap" class="tdbg">
    <a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr& "&uid="& uid%>">首页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr& "&uid="& uid%>">上一页</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr& "&uid="& uid%>">下一页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr& "&uid="& uid%>">未页</a>
    总页数:<%=pageCounts%>&nbsp;
    总条数:<%=sUsers%></td>
  </tr>
<tr>
</form>
</table>

</body>
</html>
