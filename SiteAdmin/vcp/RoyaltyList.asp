<!--#include virtual="/config/config.asp" -->
<%
check_is_master(1)
response.Buffer=true
conn.open constr


u_name=request("u_name")
if u_name="" then url_return "用户不存在",-1
u_sysid=finduserid(u_name)

Sql="Select C_AgentType,ModeD from Fuser Where u_id=" & u_sysid & " and l_ok="&PE_True&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "不是VCP用户",-1
rs.close

pageNo=requesta("pageNo")
str=trim(requesta("str"))&""
otherhrefstr="&u_name=" & u_name
newsqlstring1=""
if str="0" then
		otherhrefstr=otherhrefstr & "&str="&str
		newsqlstring1=" "
elseif str="1" then
		otherhrefstr=otherhrefstr & "&str="&str
		newsqlstring1=" and v_start=0 "
elseif str="2" then
		otherhrefstr=otherhrefstr & "&str="&str
		newsqlstring1=" and v_start=1 "
end if
Sql="Select N_total as Ntotal,d_End from fuser where L_ok="&PE_True&" and u_id="& u_sysid
Set RsTemp=conn.Execute(Sql)
 if isNumeric(RsTemp("Ntotal")) then monTotal=RsTemp("Ntotal")
  dateEnd=formatDateTime(RsTemp("d_End"),2)
 RsTemp.close
Set RsTemp=nothing
 newsql="select sum(v_royalty) as overplus from vcp_record where v_start=0 and v_fid=" &  u_sysid
 set newRs=conn.execute(newsql) 
 if not newRs.eof then
 
  	overplus=newRs("overplus")
 else
 	overplus=0
 end if
 newRs.close
 set newRs=nothing


sql="select a.*,b.u_name,b.u_namecn,c.p_name from (vcp_record a inner join userdetail b on b.u_id=a.v_cid) left join productlist c on a.v_proid=c.p_proid  where v_fid="& u_sysid & newsqlstring1 & newsqlstring &" order by v_date desc"

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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet><body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>VCP提成明细</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' align="center" >&nbsp;</td>
  </tr>
</table>
<br>

   已总共打款:<font color="#3399CC"><%=monTotal%>￥</font>&nbsp;
   上次打款时间:<font color="#3399CC"><%=dateEnd%></font>&nbsp;
   余额:<font color="#3399CC"><%=overplus%>￥</font>	
<table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border">
<form name=form1 action="<%=request("script_name")%>" method=post >
  <tr>
    <td colspan=10 align="left" nowrap="nowrap">
    <input type="button" value=" 查看全部 " <%if str="" or str="0" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=0&u_name=<%=u_name%>';">
    <input type="button" value="查看未提成" <%if str="1" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=1&u_name=<%=u_name%>';">
    <input type="button" value="查看已提成" <%if  str="2" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=2&u_name=<%=u_name%>';">
    ,用户名:
    <input name="u_name" type="text" id="u_name" value="<%=u_name%>">
    <input type="submit" name="Submit" value="查找"></td>
   </tr>
  <tr align="center">
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>序号</strong></span></td>
    <td width="13%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>账号</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>姓名</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>产品名</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>类型</strong></span></td>
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>年限</strong></span></td>
    <td width="38%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>购买时间</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>消费额</strong></span></td>
    <td width="6%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>利润额</strong></span></td>
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>状态</strong></span></td>
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
      <tr>
    <td colspan=10 align="center" nowrap="nowrap" class="tdbg">
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
<%
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
%>