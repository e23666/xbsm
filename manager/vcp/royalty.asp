<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
response.Buffer=true
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
function getproducttype(str,p)
	if p=0 then
		select case trim(str)
			case "buyhost"
				getproducttype="主机"
			case "buydomain"
				getproducttype="域名"
			case "buymssql"
				getproducttype="mssql数据库"
			case "buymysql"
				getproducttype="mysql数据库"
			case "buydns"
				getproducttype="DNS"
			case "buytesthost"
				getproducttype="试用主机转正"
			case "buytestmail"
				getproducttype="试用邮局转正"
			case else
				getproducttype=str
		end select
	else
		select case trim(str)
		case "主机"
			getproducttype="buyhost"
		case "域名"
			getproducttype="buydomain"
		case "mssql数据库"
			getproducttype="buymssql"
		case "mysql数据库"
			getproducttype="buymysql"
		case "DNS"
			getproducttype="buydns"
		case "试用主机转正"
			getproducttype="buytesthost"
		case "试用邮局转正"
				getproducttype="buytestmail"
		case else
			getproducttype=str
		end select
	end if
end function
function getImgstart(str)
	if str<>"" then
		select case trim(cstr(str))
			case "0"
				getImgstart="<img border=0 src=""/images/green2.gif"" title=""未打款"">"
			case else
				
				getImgstart="<img border=0 src=""/images/green1.gif"" title=""已打款"">"
		end select
	end if
end function
function getsqlstring(str,cond,svalue)
	sqlstr11=""
	strno=""
	if cond="Like" then
		strno="%"
	end if
	select Case trim(str)
		'v_proid v_content v_years v_date v_price v_royalty
		 case "u_name"
		 	sqlstr11=" and "& str& " "  & cond & " " & "'" & strno &  trim(svalue)  & strno & "' "
         case "u_namecn" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
         case "p_name" 
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
         case "v_content"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  getproducttype(trim(svalue),1)  & strno & "' "
         case "v_years"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
		 case "v_date"
		 	sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
		case "v_price"
			sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
		case "v_royalty"
			sqlstr11=" and "& str& " "  & cond & " "  & "'" & strno &  trim(svalue)  & strno & "' "
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
'searchItem condition searchValue
searchItem=requesta("searchItem")
condition=requesta("condition")
searchValue=requesta("searchValue")
str=trim(requesta("str"))&""
otherhrefstr=""
newsqlstring1=""

if str="0" then
		otherhrefstr="&str="&str
		newsqlstring1=" "
elseif str="1" then
		otherhrefstr="&str="&str
		newsqlstring1=" and v_start=0 "
elseif str="2" then
		otherhrefstr="&str="&str
		newsqlstring1=" and v_start=1 "
end if
if searchValue<>"" then
	cond=txt2Sig(condition)
	otherhrefstr=otherhrefstr&"&searchItem="&searchItem&"&condition="&condition&"&searchValue="&searchValue
	newsqlstring = getsqlstring(searchItem,cond,searchValue)
end if
Sql="Select N_total as Ntotal,d_End from fuser where L_ok="&PE_True&" and u_id="& session("u_sysid")
Set RsTemp=conn.Execute(Sql)
 if isNumeric(RsTemp("Ntotal")) then monTotal=RsTemp("Ntotal")
  dateEnd=formatDateTime(RsTemp("d_End"),2)
 RsTemp.close
Set RsTemp=nothing
 newsql="select sum(v_royalty) as overplus from vcp_record where v_start=0 and v_fid=" &  session("u_sysid")
 set newRs=conn.execute(newsql) 
 if not newRs.eof then
 
  	overplus=newRs("overplus")
 else
 	overplus=0
 end if
 newRs.close
 set newRs=nothing


sql="select a.*,b.u_name,b.u_namecn,c.p_name from (vcp_record a inner join userdetail b on b.u_id=a.v_cid) left join productlist c on a.v_proid=c.p_proid  where v_fid="& session("u_sysid") & newsqlstring1 & newsqlstring &" order by v_date desc"

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
<title>用户管理后台-VCP利润明细</title>
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
        <li><a href="/manager/vcp/royalty.asp">VCP利润明细</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table  class="manager-table">
        <tr class='tdbg' >
          <th colspan=10>尊敬的
            <%if ModeD then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>模式合作伙伴，您好！(<a href="vcp_Edit.asp" style="color:red;">修改资料</a>)</th>
        </tr>
        <tr>
          <td  colspan=10> 已总共打款:<font color="#ff0000"><%=monTotal%>￥</font>&nbsp;
            上次打款时间:<font color="#ff0000"><%=dateEnd%></font>&nbsp;
            余额:<font color="#ff0000"><%=overplus%>￥</font></td>
        </tr>
        <form name=form1 action="<%=request("script_name")%>" method=post >
          <tr>
            <td colspan=10 align="left" nowrap="nowrap"><input type="button" value=" 查看全部 " class="manager-btn s-btn" <%if str="" or str="0" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=0';">
              <input type="button" value="查看未提成"  class="manager-btn s-btn"  <%if str="1" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=1';">
              <input type="button" value="查看已提成"  class="manager-btn s-btn"  <%if  str="2" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=2';"></td>
          </tr>
          <tr align="center" class='titletr'>
            <th width="5%">序号</th>
            <th width="13%">账号</th>
            <th width="7%">姓名</th>
            <th width="7%">产品名</th>
            <th width="7%">类型</th>
            <th width="5%">年限</th>
            <th width="38%">购买时间</th>
            <th width="7%">消费额</th>
            <th width="6%">利润额</th>
            <th width="5%">状态</th>
          </tr>
          <%
  if not rs.eof then
  	 cur=1
	  do while not rs.eof and cur<=pageSizes
		  u_name=rs("u_name")
		  u_namecn=rs("u_namecn")
		  proid=rs("p_name")
		  content=getproducttype(rs("v_content"),0)'备注
		  years=rs("v_years")
		  buydate=formatdateTime(rs("v_date"),2)
		  buyprice=rs("v_price")
		  royalty=rs("v_royalty")'利润
		  start=getImgstart(rs("v_start"))
		
		 if isnull(overplus) or overplus="" then overplus=0
		 if len(domain)=0 then domain="&nbsp;"
		  
		  
		  trcolor="#ffffff"
		  if cur mod 2 =0 then trcolor="#efefef"
	  %>
          <tr bgcolor="<%=trcolor%>">
            <td nowrap="nowrap" class="tdbg"><%=cur%></td>
            <td nowrap="nowrap" class="tdbg"><%=u_name%></td>
            <td nowrap class="tdbg"><%=u_namecn%></td>
            <td nowrap="nowrap" class="tdbg"><%=proid%></td>
            <td nowrap class="tdbg"><%=content%></td>
            <td nowrap class="tdbg"><%=years%></td>
            <td nowrap class="tdbg"><%=buydate%></td>
            <td nowrap class="tdbg"><%=buyprice%></td>
            <td nowrap class="tdbg"><%=royalty%></td>
            <td nowrap class="tdbg"><%=start%></td>
          </tr>
          <%
	  cur=cur+1
	  rs.movenext
	  loop
  end if
  rs.close
  %>
          <%
   If isdbsql Then
			sql1="select * from vcp_record where v_fid="& session("u_sysid") &" and isnull(v_cid,0)=0 "& newsqlstring1
   else
		sql1="select * from vcp_record where v_fid="& session("u_sysid") &" and iif(v_cid,v_cid,0)=0 "& newsqlstring1
   End if
  rs11.open sql1,conn,1,1
  if not rs11.eof then
  cur1=1
  do while not rs11.eof
  	 	  content=getproducttype(rs11("v_content"),0)'备注
		  buydate=formatdateTime(rs11("v_date"),2)
		  royalty=rs11("v_royalty")'利润
		  start=getImgstart(rs11("v_start"))
  %>
          <tr bgcolor="#CCFFFF">
            <td nowrap="nowrap" class="tdbg"><%=cur1%></td>
            <td nowrap="nowrap" class="tdbg">&nbsp;</td>
            <td nowrap class="tdbg">&nbsp;</td>
            <td nowrap="nowrap" class="tdbg">&nbsp;</td>
            <td nowrap class="tdbg"><%=content%></td>
            <td nowrap class="tdbg">&nbsp;</td>
            <td nowrap class="tdbg"><%=buydate%></td>
            <td nowrap class="tdbg">&nbsp;</td>
            <td nowrap class="tdbg"><%=royalty%></td>
            <td nowrap class="tdbg"><%=start%></td>
          </tr>
          <%
  cur1=cur1+1
  rs11.movenext
  loop

  end if
  rs11.close
  %>
          <tr>
            <td colspan=10 nowrap="nowrap" class="tdbg"><select name="searchItem">
                u_namecn u_address u_address u_regdate v_royalty v_price
         
                <option value="u_name" <% if searchItem="u_name" then Response.write " selected"%>>账号</option>
                <option value="u_namecn" <% if searchItem="u_namecn" then Response.write " selected"%>>姓名</option>
                <option value="p_name" <% if searchItem="p_name" then Response.write " selected"%>>产品名</option>
                <option value="v_content" <% if searchItem="v_content" then Response.write " selected"%>>类型</option>
                <option value="v_years" <% if searchItem="v_years" then Response.write " selected"%>>年限</option>
                <option value="v_date" <% if searchItem="v_date" then Response.write " selected"%>>购买时间</option>
                <option value="v_price" <% if searchItem="v_price" then Response.write " selected"%>>消费额</option>
                <option value="v_royalty" <% if searchItem="v_royalty" then Response.write " selected"%>>利润额</option>
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
              <input name="searchValue" type="text" class="manager-input s-input" value="<%=SearchValue%>" size="20" maxlength="100">
              <input type="submit" value="查 询"  class="manager-btn s-btn" >
              <input type="button" value=" 返 回 " onClick="javascript:history.back();"  class="manager-btn s-btn" ></td>
          </tr>
          <tr>
            <td colspan=10 align="center" nowrap="nowrap" class="tdbg"><a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">首页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">上一页</a>&nbsp; <%=lookother1 & pagestr & lookother2%>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">下一页</a>&nbsp; <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">未页</a> 总页数:<%=pageCounts%>&nbsp;
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
