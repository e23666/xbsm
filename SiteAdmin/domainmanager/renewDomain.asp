<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%Check_Is_Master(6)%>
<%
response.buffer=true
response.charset="gb2312"
%>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid,p_name){
		var url='/manager/config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid + '&p_name='+ escape(p_name);
		var divID='needprice';
		makeRequestPost1(url,sinfo,divID)
	}
function dosub(f){
	if(confirm('ȷ���˲�����?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}	
</script>
<%
conn.open constr
DomainID=requesta("DomainID")
module=trim(requesta("module"))
if not isnumeric(DomainID) or DomainID="" then url_return "�������ݴ���",-1

sqlstring="SELECT a.*,b.u_name,b.u_level,b.u_usemoney FROM (domainlist a inner join userdetail b on (a.userid=b.u_id))  where d_id=" & DomainID
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ�������",-1
strdomain=trim(rs("strdomain"))
regdate=rs("regdate")
years=rs("years")
u_name=Rs("u_name")
u_level=Rs("u_level")
u_usemoney=Rs("u_usemoney")
domainRegister=getDomUpReg(strdomain)

islocal="����"
renewtype="domain"
renewMaxyear=10
if rs("isreglocal") then 
	islocal="DNS"
	renewtype="dnsdomain"
	p_proid=rs("proid")
	

		renewprice=getRenewCnPrice(strdomain,1)
		if renewprice="" then
			renewprice=getneedprice(u_name,p_proid,1,"renew")
		end if
	
	if p_proid="dns001" then
		bl_bind=isbindings(strdomain,vhostyear,vhostbuydate)				
		if bl_bind then''''''''''''�а�
			
				dnsExpri=dateadd("yyyy",years,regdate)
				hostExpri=dateadd("yyyy",vhostyear,vhostbuydate)
				dnsrenewdate=dateadd("yyyy",1,dnsExpri)
				if datediff("yyyy",dnsrenewdate,hostExpri)>=0 then
					renewprice=0
				end if
		end if
	end if	
else
	p_proid=GetDomainType(strdomain)
	renewprice=getRenewCnPrice(strdomain,1)
	if renewprice="" then
		renewprice=getneedprice(u_name,p_proid,1,"renew")
	end if
end if
	


isafter=false'�Ƿ����
if datediff("d",DateAdd("yyyy",years,regdate),now())>0 then isafter=true




%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">��������</a></span> | <a href="ModifyDomain.asp">��������У��</a> | <a href="DomainIn.asp">����ת��</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
<br>
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="6" CELLSPACING="0" class="border">
<form name="form1" action="/manager/config/renew.asp" method="post">
    <TR BGCOLOR="#FFFFFF">
      <TD ALIGN="right" nowrap="nowrap" class="tdbg"><%=islocal%>��</TD>
      <TD WIDTH="574" HEIGHT="15" class="tdbg"><%=Rs("strDomain")%></TD>
    </TR>
    <TR BGCOLOR="#FFFFFF">
      <TD ALIGN="right" nowrap="nowrap" class="tdbg"><FONT COLOR="#000000"> �������ޣ�</FONT></TD>
      <TD WIDTH="574" HEIGHT="16" class="tdbg"><%=Rs("years")%></TD>
    </TR>
    <TR BGCOLOR="#FFFFFF">
      <TD ALIGN="right" nowrap="nowrap" class="tdbg"><P ALIGN="right">ע�����ڣ�</P></TD>
      <TD WIDTH="574" HEIGHT="2" class="tdbg"><%=formatDateTime(Rs("regdate"),2)%></TD>
    </TR>
    <TR BGCOLOR="#FFFFFF">
      <TD ALIGN="right" nowrap="nowrap" class="tdbg"><P ALIGN="right">�������ڣ�</P></TD>
      <TD WIDTH="574" HEIGHT="26" class="tdbg"><%=formatDateTime(DateAdd("yyyy",Rs("years"),Rs("regdate")),2)%></TD>
    </TR>
    <TR>
      <TD HEIGHT="26" COLSPAN="2" align="center" BGCOLOR="#FFFFFF" class="tdbg"><P>
          <%
if isafter then
	%>
    <img src='/images/!.GIF' border=0><font color=blue>����<%=islocal%>���ڹ��ں����ѣ������Ѻ���Ҫ</font><font color=red>24Сʱ����</font><font color=blue>������Ч��</font>
  <%
end if

%>
         
        </P></TD>
    </TR>
    <TR BGCOLOR="#FFFFFF">
      <TD WIDTH="274" HEIGHT="26" ALIGN="right" nowrap="nowrap" class="tdbg"> ѡ���������ޣ�</TD>
      <TD WIDTH="574" HEIGHT="26" class="tdbg">&nbsp;
        <SELECT NAME="RenewYear"  ONCHANGE="doneedprice(this.value,'<%=u_name%>','<%=p_proid%>','<%=strdomain%>')">
          <%for i=1 to renewMaxyear%>
          <OPTION VALUE="<%=i%>"><%=i%> ��</OPTION>
          <%next%>
        </SELECT>
      </TD>
    </TR>
    <TR BGCOLOR="#FFFFFF">
      <TD WIDTH="274" HEIGHT="26" ALIGN="right" nowrap="nowrap" class="tdbg">���ѽ�</TD>
      <TD WIDTH="574" HEIGHT="26" class="tdbg">
		<span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span>
      </TD>
    </TR>
    <TR ALIGN="center">
      <TD HEIGHT="1" COLSPAN="2" BGCOLOR="#FFFFFF" class="tdbg" id=waitbanner aligh=center>
      <input type="hidden" value="<%=DomainID%>" name="p_id">
          <input type="hidden" name="module" value="addshopcart">
          <input type="hidden" name="productType" value="<%=renewtype%>">
           <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
          <INPUT NAME="C1" TYPE="button" CLASS="app_ImgBtn_Big"  VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)">
        </TD>
    </TR>

  </form>
</TABLE>
<!--#include virtual="/config/bottom_superadmin.asp" -->
</body>
