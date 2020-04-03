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
		'u_namecn u_address u_address u_regdate v_royalty v_price
		 case "u_name"
		 	sqlstr11=" and "& str& " "  & cond & " " & "'" & strno &  trim(svalue)  & strno & "' "
         case "u_namecn" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
         case "u_address" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
         case "u_regdate"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
         case "v_royalty"
		 	sqlstr11=" and (select sum(v_royalty) from vcp_record where v_cid=userdetail.u_id)"& " " & cond & " "& "'"  & strno & trim(svalue) & strno & "' "
		 case "v_price"
		 	sqlstr11=" and (select sum(v_price) from vcp_record where v_cid=userdetail.u_id)"& " " & cond & " "& "'"  & strno & trim(svalue) & strno & "' "
	end select
	getsqlstring=sqlstr11
end function

sub getVcpInfo(Byval uid,Byref royalty,Byref Tprice)
	royalty=0:Tprice=0
	set lrs=conn.Execute("select sum(v_royalty) as royalty,sum(v_price) as tprice from vcp_record where v_cid=" & uid)
	if not lrs.eof then
		if not isNull(lrs("royalty")) then royalty=lrs("royalty")
		if not isNull(lrs("tprice")) then Tprice=lrs("tprice")
	end if
end sub

conn.open constr
Sql="Select C_AgentType,ModeD from Fuser Where u_id=" & Session("u_sysid") & " and l_ok="&PE_True&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "请先申请成为VCP",-1
ModeD=Rs("ModeD")
rs.close
pageNo=requesta("pageNo")
'searchItem condition searchValue
searchItem=requesta("searchItem")
condition=requesta("condition")
searchValue=requesta("searchValue")
otherhrefstr=""
if searchValue<>"" then
	cond=txt2Sig(condition)
	otherhrefstr="&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue
	newsqlstring = getsqlstring(searchItem,cond,searchValue)	
end if
Sql="Select N_total as Ntotal,d_End from fuser where L_ok="&PE_True&" and u_id="& session("u_sysid")
Set RsTemp=conn.Execute(Sql)
if isNumeric(RsTemp("Ntotal")) then monTotal=RsTemp("Ntotal")
dateEnd=formatDateTime(RsTemp("d_End"),2)
RsTemp.close
Set RsTemp=nothing

set rstemp=conn.execute("select sum(v_royalty) as overplus from vcp_record where v_start=0 and v_fid=" & session("u_sysid"))
overplus=0
if not isNull(rstemp(0)) then overplus=rstemp(0)
rstemp.close:set rstemp=nothing

'sql="select *,(select sum(v_royalty) from vcp_record where v_start=0 and v_fid=fuser.u_id group by v_fid) as overplus,(select count(*) from userdetail where f_id=fuser.u_id) as countuser from fuser where u_id="& session("u_sysid") &" and L_ok="&PE_True&" "& newsqlstring &" order by ModeD,D_date desc"

'sql="select *,(select cast(sum(v_royalty) as varchar(50))+'|'+cast(sum(v_price) as varchar(50)) from vcp_record where v_cid=userdetail.u_id) as countlist from userdetail where f_id="& session("u_sysid") &" and u_id<>"& session("u_sysid") & newsqlstring & " order by u_regdate desc"
sql="select * from userdetail where f_id="& session("u_sysid") &" and u_id<>"& session("u_sysid") & newsqlstring & " order by u_regdate desc"
rs.open sql,conn,1,1
		 if not isNumeric(pageNo) or pageNo<1 then pageNo=1
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
<title>用户管理后台-VCP用户管理</title>
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
        <li><a href="/manager/vcp/vcp_Vuser.asp">VCP用户管理</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table  class="manager-table">
        <tr class='tdbg'>
          <th colspan=6>尊敬的
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>模式合作伙伴，您好！(<a href="vcp_Edit.asp" style="color:red;">修改资料</a>)
            </td>
        </tr>
        <tr>
          <td colspan=6> 已总共打款:<font color="#ff0000"><%=monTotal%>￥</font>&nbsp;
            上次打款时间:<font color="#ff0000"><%=dateEnd%></font>&nbsp;
            余额:<font color="#ff0000s"><%=overplus%>￥</font></td>
        </tr>
        <form name=form1 action="<%=request("script_name")%>" method=post >
          <tr>
            <th>序号</th>
            <th>账号</th>
            <th>姓名</th>
            <th>地址</th>
            <th>注册时间</th>
            <th>消费额</th>
            <th>总利润</th>
          </tr>
          <%
  if not rs.eof then
  	 cur=1
	  do while not rs.eof and cur<=pageSizes
		  u_name=rs("u_name")
		  u_namecn=rs("u_namecn")
		  address=rs("u_address")
		  if Rs("u_regdate")<>"" then
			  regdate=formatDateTime(Rs("u_regdate"),2)
	      end if
		  price=0
		  royalty=0
		  getVcpInfo rs("u_id"),royalty,price  
	
	  %>
          <tr>
            <td><%=cur%></td>
            <td><%=u_name%></td>
            <td><%=u_namecn%></td>
            <td><%=address%></td>
            <td><%=regdate%></td>
            <td><%=price%></td>
            <td><%=royalty%></td>
          </tr>
          <%
	  cur=cur+1
	  rs.movenext
	  loop
  end if
  rs.close
%>
          <tr>
            <td colspan=9><select name="searchItem">
                u_namecn u_address u_address u_regdate v_royalty v_price
         
                <option value="u_name" <% if searchItem="u_name" then Response.write " selected"%>>账号</option>
                <option value="u_namecn" <% if searchItem="u_namecn" then Response.write " selected"%>>姓名</option>
                <option value="u_address" <% if searchItem="u_address" then Response.write " selected"%>>地址</option>
                <option value="u_regdate" <% if searchItem="u_regdate" then Response.write " selected"%>>注册时间</option>
                <option value="v_royalty" <% if searchItem="v_royalty" then Response.write " selected"%>>余款</option>
                <option value="v_price" <% if searchItem="v_price" then Response.write " selected"%>>消费总额</option>
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
              <input type="button" value=" 返 回 "  class="manager-btn s-btn" onClick="javascript:history.back();"></td>
          </tr>
          <tr>
            <td colspan=9 align="center"><a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp; <%=lookother1 & pagestr & lookother2%>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a> 总页数:<%=pageCounts%>&nbsp;
              总条数(用户数):<%=sUsers%></td>
          </tr>
        </form>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>