<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%response.Charset="gb2312"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�û������̨-������ϸ</title>
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<style type="text/css">
<!--
.STYLE4 {
	
	font-weight: bold;
}
.STYLE5 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
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
		response.Write "��"&formatNumber(sumout,2,-1,-1)
	else
		response.Write("��0.00")
	end if
	rs11.close
	conn.close
	response.end
end if

sqlArray=Array("c_date,ʱ��,date","c_memo,��������,str","u_countId,ƾ֤����,str","u_moneysum,�������,int","u_in,����,int","u_out,֧��,int")
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
</head>
<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">������ϸ</div>
          <div class="table_out">

<table width="100%" border=0 align=center cellpadding=4 cellspacing=0 class="border">
  <tbody>
    <tr bgcolor=#ffffff>
      <td align="right" nowrap class="tdbg">Ŀǰ���:</td>
      <td colspan=3 nowrap bgcolor=#ffffff class="tdbg"><%= session("u_level") %> </td>
    </tr>
    <tr bgcolor=#ffffff>
      <td align="right" nowrap class="tdbg">��ʹ�ý��:</td>
      <td nowrap class="tdbg STYLE5"><%= formatNumber(session("u_usemoney") ,2,-1,0)%> Ԫ </td>
      <td align="right" nowrap class="tdbg">δ��˿���:</td>
      <td nowrap class="tdbg STYLE5"><%= session("u_checkmoney") %> Ԫ</td>
    </tr>
    <tr bgcolor=#ffffff>
      <td align="right" nowrap class="tdbg">�Ż�ȯ:</td>
      <td  nowrap class="tdbg STYLE5"><%=session("u_premoney")%> Ԫ </td>
      <td align="right"  nowrap class="tdbg">�������ܶ�:</td>
      <td  nowrap class="tdbg STYLE5"><%= session("u_resumesum") %>Ԫ</td>
    </tr>
    <tr bgcolor=#ffffff>
  
      <td align="right" nowrap class="tdbg">���<span id="MonthNum"><%=MonthNum%></span>���������ܶ</td>
      <td colspan=3 nowrap class="tdbg">
        <span class="STYLE5" id="MonthMoney"></span>
        <input name="Button" type="button" value="���3����" onClick="javascript:doneedMum(3);">
        <input name="Button" type="button" value="�������" onClick="javascript:doneedMum(6);">
         <script language="javascript">
			doneedMum(<%=MonthNum%>);
		</script>      </td>
    </tr>
  </tbody>
</table>
<br />
<table width="99%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border managetable tableheight">
  <form name=form1 method="post" action="<%=request("script_name")%>">
    <tr class="titletr" >
      <td align="center" nowrap="nowrap" ><span class="STYLE4">ƾ֤����</span></td>
      <td align="center" nowrap="nowrap"><span class="STYLE4">�������</span></td>
      <td align="center" nowrap="nowrap"><span class="STYLE4">����</span></td>
      <td align="center" nowrap="nowrap"><span class="STYLE4">֧��</span></td>
      <td align="center" nowrap="nowrap"><span class="STYLE4">ʱ��</span></td>
      <td align="center"><span class="STYLE4">��������</span></td>
      <td align="center" nowrap="nowrap"><strong>���</strong></td>
      <td align="center" nowrap="nowrap"><span class="STYLE4">״̬</span></td>
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
				               		Response.Write "δ��"
				                   else
				               		Response.Write "���"
				                End If
				                %></td>
    </tr>
    <%
		rs.movenext
		cur=cur+1
	Loop

	%>
    <tr bgcolor="#E8E8E8">
    <td class="tdbg">ÿҳͳ��</td>
    <td class="tdbg">��<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_moneysum,2,-1)%></span></td>
    <td class="tdbg">��<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_in,2,-1)%></span></td>
    <td class="tdbg">��<span style="font-weight: bold; color: #FF0000"><%=formatNumber(allu_out,2,-1)%></span></td>
    <td colspan="4" class="tdbg">&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td colspan =9 align="center" class="tdbg"><%=pagenumlist%></td>
    </TR>
    <tr>
      <td colspan="9" class="tdbg"><%=searchlist%></td>
    </tr>
  </form>
</table>
          
          
          
            
          </div>
        </div>
      </div>
    </div>
  </div>
 <!--#include virtual="/manager/bottom.asp" -->
</div>



</body>
</html>
