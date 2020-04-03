<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%response.Charset="gb2312"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <style>
   .manager-btn, .common-btn {
       background: #ff6c3a!important;}
</style>
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<%


conn.open constr
 MonthNum=requesta("MonthNum")
if trim(MonthNum)&""="" then MonthNum="3"
act=trim(requesta("act"))
if act="checkMonthNum" then
	MonthNum=requesta("MonthNum")

	sql="SELECT SUM(u_out) AS outMoney FROM countlist WHERE (dateDiff("&PE_DatePart_M&", c_date, "&PE_Now&") <= "& MonthNum &") AND (u_id = "&session("u_sysid")&")"
	rs11.open sql,conn,1,1
	if not rs11.eof then
		sumout=rs11(0)
		if isnull(sumout) or sumout="" then
			sumout=0
		end if
		response.Write "￥"&formatNumber(sumout,2,-1,-1)
	else
		response.Write("￥0.00")
	end if
	rs11.close
	conn.close
	response.end
end if

sqlArray=Array("c_date,时间,date","c_memo,款项类型,str","u_countId,凭证单号,str","u_moneysum,发生金额,int","u_in,入账,int","u_out,支出,int")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="SELECT * FROM countlist where  u_id="&session("u_sysid")&"  " & newsql & " order by sysid desc"
rs.open sqlstring,conn,1,1
    setsize=10
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedMum(MonthNum){
		var url='<%=request("script_name")%>?act=checkMonthNum';
		var sinfo='MonthNum='+MonthNum;
		var divID='MonthMoney';
		document.getElementById('MonthNum').innerHTML=MonthNum;
		makeRequestPost1(url,sinfo,divID)
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
			   <li>域名管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">

<table  class="manager-table">
  <tbody>
    <tr bgcolor=#ffffff>
      <th align="right" nowrap class="tdbg">目前身份:</th>
      <td colspan=3 nowrap bgcolor=#ffffff class="tdbg" align="left"><%= session("u_level") %> </td>
    </tr>
    <tr bgcolor=#ffffff>
      <th align="right" nowrap class="tdbg">可使用金额:</th>
      <td nowrap class="tdbg STYLE5" align="left"><%= formatNumber(session("u_usemoney") ,2,-1,0)%> 元 </td>
      <th align="right" nowrap class="tdbg">未审核款项:</th>
      <td nowrap class="tdbg STYLE5" align="left"><%= session("u_checkmoney") %> 元</td>
    </tr>
    <tr bgcolor=#ffffff>
      <th align="right" nowrap class="tdbg">优惠券:</th>
      <td  nowrap class="tdbg STYLE5" align="left"><%=session("u_premoney")%> 元 </td>
      <th align="right"  nowrap class="tdbg">已消费总额:</th>
      <td  nowrap class="tdbg STYLE5" align="left"><%= session("u_resumesum") %>元</td>
    </tr>
    <tr bgcolor=#ffffff>

      <th align="right" nowrap class="tdbg">最近<span id="MonthNum"><%=MonthNum%></span>个月消费总额：</th>
      <td colspan=3 nowrap class="tdbg" align="left">
        <span class="STYLE5" id="MonthMoney"></span>
        <input name="Button" type="button" value="最近3个月" onClick="javascript:doneedMum(3); " class="manager-btn s-btn" >
        <input name="Button" type="button" value="最近半年" onClick="javascript:doneedMum(6);" class="manager-btn s-btn" >
         <script language="javascript">
			doneedMum(<%=MonthNum%>);
		</script>      </td>
    </tr>
  </tbody>
</table>
<br />
 <form name=form1 method="post" action="<%=request("script_name")%>">
<%=searchlist%>
<table  class="manager-table">
    <tr class="titletr" >
      <th align="center" nowrap="nowrap" ><span class="STYLE4">凭证单号</span></th>
      <th align="center" nowrap="nowrap"><span class="STYLE4">发生金额</span></th>
      <th align="center" nowrap="nowrap"><span class="STYLE4">入账</span></th>
      <th align="center" nowrap="nowrap"><span class="STYLE4">支出</span></th>
      <th align="center" nowrap="nowrap"><span class="STYLE4">时间</span></th>
      <th align="center"><span class="STYLE4">款项类型</span></th>
      <th align="center" nowrap="nowrap"><strong>余额</strong></th>
      <th align="center" nowrap="nowrap"><span class="STYLE4">状态</span></th>
    </tr>
    <%
	do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"

		if isnull(rs("u_moneysum")) then
			u_moneysum=0
		else
			u_moneysum=rs("u_moneysum")
		end if
		allu_moneysum=ccur(allu_moneysum)+ccur(u_moneysum)
		allu_in=ccur(allu_in)+ccur(rs("u_in"))
		allu_out=ccur(allu_out)+ccur(rs("u_out"))
	%>
    <TR align=middle bgcolor="<%=tdcolor%>">
      <td nowrap="nowrap" class="tdbg"><%=rs("u_countId")%></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%=u_moneysum%></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%=rs("u_in")%></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%=rs("u_out")%></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%=formatdatetime(rs("c_date"),2)%></td>
      <td align="left"  class="tdbg"><%
	  if left(rs("u_countId")&"",5)="sysu_" then
	  Response.write("system")
	  else
	  Response.write(rs("c_memo"))
	  end if
      %></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%=rs("u_Balance")%></td>
      <td align="center" nowrap="nowrap" class="tdbg"><%
				                If rs("c_check") Then
				               		Response.Write "未审"
				                   else
				               		Response.Write "完成"
				                End If
				                %></td>
    </tr>
    <%
		rs.movenext
		cur=cur+1
	Loop

	%>
    <tr>
    <td class="tdbg">每页统计</td>
    <td class="tdbg">￥<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_moneysum,2,-1)%></span></td>
    <td class="tdbg">￥<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_in,2,-1)%></span></td>
    <td class="tdbg">￥<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_out,2,-1)%></span></td>
    <td colspan="4" class="tdbg">&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td colspan =9 align="center" class="tdbg"><%=pagenumlist%></td>
    </TR>


</table>
  </form>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
