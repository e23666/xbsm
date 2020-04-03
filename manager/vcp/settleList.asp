<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
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
		 	if not isdate(svalue) then url_return "日期格式错误",-1
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
         case "s_money" 
		 if not isnumeric(svalue) then url_return "金额格式错误",-1
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "'"
        
	end select
	getsqlstring=sqlstr11
end function
conn.open constr
Sql="Select C_AgentType,ModeD from Fuser Where u_id=" & Session("u_sysid") & " and l_ok="&PE_True&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "请先申请成为VCP",-1
ModeD=Rs("ModeD")
rs.close


pageNo=requesta("pageNo")

searchValue=requesta("searchValue")
searchItem=requesta("searchItem")
condition=requesta("condition")
if searchValue<>"" then
	cond=txt2Sig(condition)
	otherhrefstr="&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue
	newsqlstring = getsqlstring(searchItem,cond,searchValue)
end if
sql="select b.u_name,a.* from (vcp_settleList a inner join userdetail b on a.s_userid=b.u_id) where s_userid="& session("u_sysid") & newsqlstring &" order by s_date desc"

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
		 if forstr1<pageCounts then lookother2="<a href='"&request("script_name")&"?pageNo="& (forstr2+(1+5)) & otherhrefstr &"'><b>...</b></a> "

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-VCP打款明细</title>
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
        <li><a href="/manager/vcp/settleList.asp">VCP打款明细</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table   class="manager-table">
        <tr class='tdbg'>
          <th colspan=5>尊敬的
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>模式合作伙伴，您好！(<a href="vcp_Edit.asp" style="color: red;">修改资料</a>)
            </td>
        </tr>
        <form name=form1 action="<%=request("script_name")%>" method=post >
          <tr align="center" class='titletr'>
            <th>序号</th>
            <th>结算时间</th>
            <th>结算金额</th>
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
            <td><%=cur%></td>
            <td><%=s_date%></td>
            <td><%=s_money%></td>
          </tr>
          <%
	rs.movenext
	cur=cur+1
	loop
end if
rs.close
%>
          <tr>
            <td colspan=9 align="center" ><a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp; <%=lookother1 & pagestr & lookother2%>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a> 总页数:<%=pageCounts%>&nbsp;
              总条数:<%=sUsers%></td>
          </tr>
          <tr>
            <td colspan=9  ><select name="searchItem">
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
              <input name="searchValue" type="text"  class="manager-input s-input"  value="<%=SearchValue%>" size="20" maxlength="100">
              <input type="submit" value="查 询"  class="manager-btn s-btn">
              <input type="button" value=" 返 回 "  class="manager-btn s-btn" onClick="javascript:history.back();" /></td>
          </tr>
        </form>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
