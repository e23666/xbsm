<!--#include virtual="/config/config.asp" -->
<%
check_is_master(1)
response.Buffer=true
conn.open constr


u_name=request("u_name")
if u_name="" then url_return "�û�������",-1
u_sysid=finduserid(u_name)

Sql="Select C_AgentType,ModeD from Fuser Where u_id=" & u_sysid & " and l_ok="&PE_True&""
Rs.open Sql,conn,1,1
if Rs.eof then url_return "����VCP�û�",-1
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
    <td height='30' align="center" ><strong>VCP�����ϸ</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' align="center" >&nbsp;</td>
  </tr>
</table>
<br>

   ���ܹ����:<font color="#3399CC"><%=monTotal%>��</font>&nbsp;
   �ϴδ��ʱ��:<font color="#3399CC"><%=dateEnd%></font>&nbsp;
   ���:<font color="#3399CC"><%=overplus%>��</font>	
<table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border">
<form name=form1 action="<%=request("script_name")%>" method=post >
  <tr>
    <td colspan=10 align="left" nowrap="nowrap">
    <input type="button" value=" �鿴ȫ�� " <%if str="" or str="0" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=0&u_name=<%=u_name%>';">
    <input type="button" value="�鿴δ���" <%if str="1" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=1&u_name=<%=u_name%>';">
    <input type="button" value="�鿴�����" <%if  str="2" then response.write "style=""background-color:#3399CC"""%> onClick="javascript:location.href='<%=request("script_name")%>?str=2&u_name=<%=u_name%>';">
    ,�û���:
    <input name="u_name" type="text" id="u_name" value="<%=u_name%>">
    <input type="submit" name="Submit" value="����"></td>
   </tr>
  <tr align="center">
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>���</strong></span></td>
    <td width="13%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>�˺�</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>����</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>��Ʒ��</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>����</strong></span></td>
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>����</strong></span></td>
    <td width="38%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>����ʱ��</strong></span></td>
    <td width="7%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>���Ѷ�</strong></span></td>
    <td width="6%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>�����</strong></span></td>
    <td width="5%" nowrap="nowrap" class="Title"><span class="STYLE1"><strong>״̬</strong></span></td>
 </tr>
  <%
  if not rs.eof then
  	 cur=1
	  do while not rs.eof and cur<=pageSizes
		  u_name=rs("u_name")
		  u_namecn=rs("u_namecn")
		  proid=rs("p_name")
		  content=getproducttype(rs("v_content"),0)'��ע
		  years=rs("v_years")
		  buydate=formatdateTime(rs("v_date"),2)
		  buyprice=rs("v_price")
		  royalty=rs("v_royalty")'����
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
    <a href="<%=request("script_name")%>?pageNo=1<%=otherhrefstr%>">��ҳ</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)-1%><%=otherhrefstr%>">��һҳ</a>&nbsp;
    <%=lookother1 & pagestr & lookother2%>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=clng(pageNo)+1%><%=otherhrefstr%>">��һҳ</a>&nbsp;
    <a href="<%=request("script_name")%>?pageNo=<%=pageCounts%><%=otherhrefstr%>">δҳ</a>
    ��ҳ��:<%=pageCounts%>&nbsp;
    ������(�û���):<%=sUsers%>    </td>
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
				getproducttype="����"
			case "buydomain"
				getproducttype="����"
			case "buymssql"
				getproducttype="mssql���ݿ�"
			case "buymysql"
				getproducttype="mysql���ݿ�"
			case "buydns"
				getproducttype="DNS"
			case "buytesthost"
				getproducttype="��������ת��"
			case "buytestmail"
				getproducttype="�����ʾ�ת��"
			case else
				getproducttype=str
		end select
	else
		select case trim(str)
		case "����"
			getproducttype="buyhost"
		case "����"
			getproducttype="buydomain"
		case "mssql���ݿ�"
			getproducttype="buymssql"
		case "mysql���ݿ�"
			getproducttype="buymysql"
		case "DNS"
			getproducttype="buydns"
		case "��������ת��"
			getproducttype="buytesthost"
		case "�����ʾ�ת��"
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
				getImgstart="<img border=0 src=""/images/green2.gif"" title=""δ���"">"
			case else
				
				getImgstart="<img border=0 src=""/images/green1.gif"" title=""�Ѵ��"">"
		end select
	end if
end function
%>