<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
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
		 case "username"
		 	sqlstr11=" and "& str& " "  & cond & " " & "'" & strno &  trim(svalue)  & strno & "'"
         case "C_domain" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "D_End" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "N_total"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "N_remain"
		 	sqlstr11=" and isnull((select sum(v_royalty) from vcp_record where v_start=0 and v_fid=fuser.u_id ),0)"& " " & cond & " "& "'"  & strno & trim(svalue) & strno & "'"
	end select
	getsqlstring=sqlstr11
end function

function getRoyalty(uid)
	getRoyalty=0
	set lrs=conn.Execute("select sum(v_royalty) as exp1 from vcp_record where v_start=0 and v_fid=" & uid)
	if not lrs.eof then
		if not isnull(lrs(0)) then getRoyalty=lrs(0)
	end if
	lrs.close :set lrs=nothing
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
	conn.execute(sql)
	response.write "<script>location.href='"& request("script_name") &"?pageNo="& pageNo & otherhrefstr &"'</script>"
	response.end
end if

if str="del" and toid<>"" then
	conn.Execute("delete from fuser where id=" & toid)
end if

Sql="Select sum(N_total) as Ntotal from fuser where L_ok="&PE_True&""
Set RsTemp=conn.Execute(Sql)
 if isNumeric(RsTemp("Ntotal")) then monTotal=RsTemp("Ntotal")
RsTemp.close
Set RsTemp=nothing

sql="select *,(select count(*) from userdetail where f_id=fuser.u_id) as countuser from fuser where L_ok="&PE_True&" "& newsqlstring &" order by ModeD,D_date desc"
'Response.write sql
rs.open sql,conn,1,1
		 if not isNumeric(pageNo) then pageNo=1
		 if pageNo<1 then PageNo=1
		 pageSizes=15
		 Rs.pageSize=pageSizes
		 pageCounts=Rs.pageCount
		 sUsers=Rs.RecordCount
		
		 if clng(pageNo)>clng(pageCounts) then pageNo=pageCounts
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
		 if forstr2<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+5)) & otherhrefstr &"'><b>...</b></a> "
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
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
</table> 
<br>
提示：如果要使用VCP-C模式，需要将用户申请的域名都解析并绑定到您的主站上。<br>
如果要使用VCP-D模式，需要在系统中保留一个名为：AgentUserVCP的用户。该用户的级别一般设置为“普通代理商”，这样VCP-D模式的代理提成就是普通代理与直接客户价格的差额。<br>
<table width="100%" border="0" cellpadding="6" cellspacing="0" class="border">
<form name=formsd action="" method=post >
  <tr>
    <td align="center" class="tdbg"><select name="searchItem">
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
      <input type="submit" value="查 询"></td>
  </tr>
    </form>

</table>
<br>

总共打款:<%=monTotal%>￥&nbsp;

<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border">
<form name=form1 action="<%=request("script_name")%>" method=post >
  <tr align="center">
    <td width="3%" nowrap class="Title"><span class="STYLE1"><strong>序号</strong></span></td>
    <td width="11%" nowrap class="Title"><span class="STYLE1"><strong>用户名</strong></span></td>
    <td width="8%" nowrap class="Title"><span class="STYLE1"><strong>模式</strong></span></td>
    <td width="15%" nowrap class="Title"><span class="STYLE1"><strong>域名</strong></span></td>
    <td width="13%" nowrap class="Title"><span class="STYLE1"><strong>注册用户</strong></span></td>
    <td width="13%" nowrap class="Title"><span class="STYLE1"><strong>打款总计</strong></span></td>
    <td width="13%" nowrap class="Title"><span class="STYLE1"><strong>上次打款</strong></span></td>
	<td width="16%" nowrap class="Title"><span class="STYLE1"><strong>余额</strong></span></td>
    <td width="8%" nowrap class="Title"><span class="STYLE1"><strong>操作</strong></span></td>
  </tr>
  <%
  if not rs.eof then
  	 cur=1
	  do while not rs.eof and cur<=pageSizes
	  	  u_id=rs("u_id")
	  	  username=rs("username")
		  modeD=rs("modeD")
		  domain=rs("c_domain")
		  countuser=rs("countuser")
		  total=Rs("N_total")
		  dateEnd=rs("D_end")
		  overplus=getRoyalty(u_id)
		  id=trim(rs("id"))
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
      <tr>
		<td nowrap class="tdbg"><%=cur%></td>
		<td nowrap class="tdbg"><%=username%></td>
		<td align="center" nowrap class="tdbg"><%=MString%></td>
        <td nowrap class="tdbg"><input type=text value="<%=domain%>" name="moddomain"></td>
        <td nowrap class="tdbg"><%=countuser%></td>
        <td nowrap class="tdbg"><%=total%></td>
        <td nowrap class="tdbg"><%=formatDateTime(dateEnd,1)%></td>
        <td nowrap class="tdbg"><%=overplus%></td>
        <td nowrap class="tdbg"><a href=# onClick="javascript:document.form1.action='<%=request("script_name")%>?pageNo=<%=pageNo%>&str=add&toid=<%=id%><%=otherhrefstr%>';document.form1.submit();">确定</a>|<a href=# onClick="javascript:location.href='<%=request("script_name")%>?pageNo=<%=pageNo%><%=otherhrefstr%>';">取消</a></td>
  </tr>
          <%
		  else
	  %>
	  <tr>
		<td nowrap class="tdbg"><%=cur%></td>
		<td nowrap class="tdbg"><%=username%></td>
		<td align="center" nowrap class="tdbg"><%=MString%></td>
        <td nowrap class="tdbg"><%=domain%></td>
        <td nowrap class="tdbg"><%=countuser%></td>
        <td nowrap class="tdbg"><%=total%></td>
        <td nowrap class="tdbg"><%=formatDateTime(dateEnd,1)%></td>
        <td nowrap class="tdbg"><%=overplus%></td>
        <td nowrap class="tdbg">
        <a href="RoyaltyList.asp?u_name=<%=username%>">明细</a>|<a href="<%=request("script_name")%>?pageNo=<%=pageNo%>&str=mod&toid=<%=id%><%=otherhrefstr%>">修改</a>|<a href="javascript:if (confirm('您确定删除')){location.href='<%=request("script_name")%>?pageNo=<%=pageNo%>&str=del&toid=<%=id%>'}">删除</a></td>
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
    <td colspan=9 align="center" nowrap class="tdbg">
    <a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a>
    总页数:<%=pageCounts%>&nbsp;
    总条数(用户数):<%=sUsers%>    </td>
  </tr>
  </form>
</table>


</body>
</html>
