<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%
response.buffer=true
response.charset="gb2312"
conn.open constr

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/config/ajax.js"></script>
<script language="javascript">
	function doneedprice(myvalue,u_name,proid,strdomain){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid+'&p_name='+escape(strdomain);
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
 
dim usr_mobile
dim usr_email
call getusrinfo()
DomainID=requesta("DomainID")
module=trim(requesta("module"))
if not isnumeric(DomainID) or DomainID="" then url_return "�������ݴ���",-1

sqlstring="SELECT * FROM domainlist where userid=" &  session("u_sysid") & " and d_id=" & DomainID
rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "û���ҵ�������",-1
strdomain=trim(rs("strdomain"))
regdate=rs("regdate")
years=rs("years")
islocal="����"
renewtype="domain"
domainRegister=getDomUpReg(strdomain)
ThisDomainEndDate=dateadd("yyyy",years,regdate)

'DiffYears=datediff("yyyy",now(),ThisDomainEndDate)
'renewMaxyear = 10	'�����������
'if now < ThisDomainEndDate then'�������û�е���
'	DiffYears=DiffYears+1
'end if
'renewMaxyear=renewMaxyear-DiffYears

'MaxRenewDate=dateadd("d",3650,now())
MaxRenewDay=Datediff("yyyy",now(),ThisDomainEndDate)
renewMaxyear=9-MaxRenewDay

if rs("isreglocal") then 
	islocal="DNS"
	renewtype="dnsdomain"
	p_proid=rs("proid")
	renewprice=getRenewCnPrice(strdomain,1)
	if renewprice="" then
		renewprice=getneedprice(session("user_name"),p_proid,1,"renew")
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
			renewprice=getneedprice(session("user_name"),p_proid,1,"renew")
		end if
end if
	


isafter=false'�Ƿ����
if datediff("d",DateAdd("yyyy",years,regdate),now())>0 then isafter=true


strchgchncmd="domainname"&vbcrlf&_
	   "check"&vbcrlf&_
	   "entityname:chgchn"&vbcrlf&_
	   "domain:"&strdomain&""&vbcrlf&_
	   "."&vbcrlf
retCode=connectToUp(strchgchncmd)
renewmode=""
renewmodemsg=""
if left(retCode,3)="200" then
	temp_=split(retCode,",")
	if ubound(temp_)>=2 then
		renewmode=temp_(1)
		renewmodemsg=temp_(2)
	end if
end if

%>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/domainmanager/">��������</a></li>
			   <li>��������</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
    <form name="form1" action="/manager/config/renew.asp" method="post">
		 <TABLE  class="manager-table">
                <TR BGCOLOR="#FFFFFF">
                  <th ALIGN="right" width="30%"><%=islocal%>��</th>
                  <TD align="left"> <%=Rs("strDomain")%></TD>
                </TR>
                <TR BGCOLOR="#FFFFFF">
                  <th ALIGN="right">�������ޣ�</th>
                  <TD align="left"><%=Rs("years")%></TD>
                </TR>
                <TR BGCOLOR="#FFFFFF">
                  <th ALIGN="right"  ><P ALIGN="right">ע�����ڣ�</P></th>
                  <TD align="left"> <%=formatDateTime(Rs("regdate"),2)%></TD>
                </TR>
                <TR BGCOLOR="#FFFFFF">
                  <Th ALIGN="right"  ><P ALIGN="right">�������ڣ�</P></Th>
                  <TD align="left"> <%=formatDateTime(DateAdd("yyyy",Rs("years"),Rs("regdate")),2)%></TD>
                </TR>
                <tr>
                  <td colspan="2" align="center" BGCOLOR="#FFFFFF" ><div class="redAlert_Box RedLink">Ϊ��ʹ���ܿ�ݡ�׼ȷ���յ�����֪ͨ����Ϣ�����ʵ�����ֻ�Ϊ��<span class="GreenColor"><%=usr_mobile%></span>������Ϊ��<span class="GreenColor"><%=usr_email%></span>�������ԣ��뼰ʱ<a href="/manager/usermanager/default2.asp" class="Link_Blue">�޸�</a>�� </div></td>
                </tr>
				<%if isafter then%>
                <TR>
                  <TD COLSPAN="2" align="center" > 

                      <img src='/images/!.GIF' border=0><font color=blue>����<%=islocal%>���ڹ��ں����ѣ������Ѻ���Ҫ</font><font color=red>24Сʱ����</font><font color=blue>������Ч��</font>
                    </TD>
                </TR>
				<%end if%>
				<%if trim(renewmode)<>"" then%>
				<tr>
					<th ALIGN="right"><P ALIGN="right">���ѷ�ʽ��</p></th>
					<td ALIGN="left">
						<label><input type="radio" value="" name="renewmode" checked > ��۽ӿڣ�ֱ�����ѣ��ʺ��ݲ�������վ�����������</label><br>
						<label><input type="radio" value="<%=renewmode%>" name="renewmode"> <%=renewmodemsg%></label>
						<input type="hidden" name="RenewYear" value=1>
					 </td>
				</tr>
				<%else%>

				<TR BGCOLOR="#FFFFFF">
                  <th ALIGN="right"  > ѡ���������ޣ�</th>
                  <TD  align="left" >&nbsp;
                    <SELECT NAME="RenewYear" class="manager-select s-select"  ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=p_proid%>','<%=Rs("strDomain")%>')">
                      <%
					    xhstr=""
						
						'����Ҫ����ʱ�䴮
						for	ii=1 to renewMaxyear
						   if xhstr="" then 
						   xhstr=ii
						   else
						   xhstr=xhstr&","&ii
						   end if
						next

						'���⴦��
						if trim(p_proid)="domhk" or trim(p_proid)="domtw"  then
							xhstr="1,2,3,5"
						end if
						
						if trim(xhstr)="" then
						xhstr="1"
						end if	
					  for each i in split(xhstr,",")%>
                      <OPTION VALUE="<%=i%>"><%=i%> ��</OPTION>
                      <%next%>
                    </SELECT></TD>
                </TR>

				<%end if%>
                
                <TR BGCOLOR="#FFFFFF">
                  <th ALIGN="right"  >���ѽ�</th>
                  <TD align="left" ><span id="needprice"><b><font color=red><%=renewprice%></font></b>��/1��</span></TD>
                </TR>
                <TR ALIGN="center">
                  <TD COLSPAN="2" BGCOLOR="#FFFFFF"  id=waitbanner aligh=center><input type="hidden" value="<%=DomainID%>" name="p_id">
                    <input type="hidden" name="module" value="addshopcart">
                    <input type="hidden" name="productType" value="<%=renewtype%>">
                    <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>
                    ����ִ��,���Ժ�..<br>
                    </span>
                    <INPUT NAME="C1" TYPE="button" CLASS="manager-btn s-btn"  VALUE="��ȷ�����ѡ�" onClick="return dosub(this.form)"></TD>
                </TR>
            </TABLE>
   </form> 

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>