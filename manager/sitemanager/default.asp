<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''
sorttype=trim(requesta("sorttype"))
sorts=trim(requesta("sorts"))
if sorttype="" then sorttype="desc"
if sorttype="asc" then 
	seesortstr="<img src=""/images/up_sort.png"" border=0 alt=""����"">"
else
	seesortstr="<img src=""/images/down_sort.png"" border=0 alt=""����"">"
end if

sortsql=""
if sorts="" then sorts="s_buydate"
	sortsql=" "& sorts &" " & sorttype
'''''''''''''''''''''''''''''''''''''''''''''''''''
sqlArray=Array("s_bindings,������,str","s_comment,վ����,str","p_name,������,str","s_productid,����ID,str","s_serverIP,IP��ַ,str","s_buydate,����ʱ��,date")
newsql=searchEnd(searchItem,condition,searchValue,othercode)


intDays = requesta("days")
if not isnumeric(intDays&"") then intDays=30	'��ѯ30���ڵ�������ʱ��
module=requesta("module")
if module="willexpire" then
	newsql = " And ( (dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))<=" & intDays & " And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_Y&",s_year,s_buydate))>0 and s_buytest="&PE_False&") or (dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_D&",7,s_buydate))<=" & intDays & " And dateDiff("&PE_DatePart_D&","&PE_Now&",dateadd("&PE_DatePart_D&",7,s_buydate))>0 and s_buytest="&PE_True&") )"
elseif module="expire" then
	newsql = " And ( (dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_Y&",s_year,s_buydate),"&PE_Now&")>0 and s_buytest="&PE_False&") or ( dateDiff("&PE_DatePart_D&",dateadd("&PE_DatePart_D&",7,s_buydate),"&PE_Now&")>0 and s_buytest="&PE_True&") )"
end if

'sqlstring="SELECT a.*,b.p_name FROM vhhostlist a inner join productlist b on (b.p_proid=a.s_productid)  where S_ownerid=" & session("u_sysid") & " " & newsql & " order by "& sortsql
sqlstring="select temp.*,remarks.r_txt from (select vhhostlist.*,productlist.p_name  from vhhostlist  inner join productlist on productlist.p_proid=vhhostlist.s_productid) as temp left join Remarks on (temp.s_sysid=Remarks.p_id and Remarks.r_type=1) where dateDiff("&PE_DatePart_D&","&PE_Now&",s_expiredate)>-30 and S_ownerid=" & session("u_sysid") & " " & newsql & " order by "& sortsql

rs.open sqlstring,conn,1,1
    setsize=10
	cur=1
	othercode=othercode & "&sorts="& sorts & "&sorttype="& sorttype
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-������������</title>
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
  <!--#include virtual="/manager/rengzheng.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li><a href="/Manager/sitemanager/">����������</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
		  <form name="form1" action="<%=request("script_name")%>" method="post">
	<%=searchlist%>		
  <table class="manager-table">
        <tr align=middle class='titletr'>
          <th colspan="" align="center" ><a href="javascript:dosort('s_comment')" class="STYLE1"><strong>վ����</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_bindings')" class="STYLE1"><strong>������</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_serverip')" ><strong>�ϴ���ַ</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_serverName')" ><strong>���Ե�ַ</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_siteState')" class="STYLE1"><strong>״̬</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_buydate')" class="STYLE1"><strong>ʹ������</strong><%=seesortstr%></a></th>
          <th align="center" ><a href="javascript:dosort('s_ProductId')" class="STYLE1"><strong>������[����ID]</strong><%=seesortstr%></a></th>
          <th align="center" ><strong>����</strong></th>
        </tr>
        <%

	do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#EAF5FC"
%>
         <tr align=middle bgcolor="<%=tdcolor%>">
          <td style="word-wrap: break-word;word-break:break-all;" ><a href="manage.asp?p_id=<%=Rs("s_sysid")%>"><font color=#ff6600><%=rs("s_comment")%></font> </a>
					</a><img src="/images/1341453609_help.gif" onclick="setmybak(<%=rs("s_sysid")%>,'<%=rs("s_comment")%>',1)">
						  <%if trim(rs("r_txt"))<>"" then
						  response.write("<div class=""hs"">("&rs("r_txt")&")</div>")
						  end if
						  %>
          <%
		  if rs("s_other_ip")<>"" then
		  response.Write("<BR><font color=red>[������IP]</font>")
		  end if
		  %> </td>
          <td style="word-wrap: break-word;word-break:break-all;" >
		  <%
		  	if instr(rs("p_name"),"mysql")<>0 then
				response.write "Mysql���ݿ�"
			else
			
				if not isNull(Rs("s_bindings")) and len(Rs("s_bindings"))>0 then 
					s_bindings=split(Rs("s_bindings"),",")
					my_s_bindings=split(Rs("s_bindings"),",")
					for kk=0 to ubound(s_bindings)
						response.write my_s_bindings(kk)&"<br>"
					next
				else
					response.write "--"
				end if
			
			end if
			
			pageurl="http://"&rs("s_comment")&"."&rs("s_serverName")
			
			%>           </td>
          <td  style="word-wrap: break-word;word-break:break-all;" ><%= rs("s_serverip")%></td>
          <td  style="word-wrap: break-word;word-break:break-all;" ><a href="<%=pageurl%>"><%=rs("s_comment")&"."&rs("s_serverName")%></a></td>
          <td><%=showstatus(rs("s_siteState"),rs("s_buytest") ,formatdatetime(rs("s_expiredate"),2))%></td>
          <td nowrap  ><%=formatdatetime(rs("s_buydate"),2)%>����<br><%
	  If rs("s_buytest") Then
		response.write FormatDateTime( DateAdd("d",6,rs("s_buydate")),2)
	  Else
	    response.write Formatdatetime(rs("s_expiredate"),2)
	  End if
		  %>����</td>
          <td style="word-wrap: break-word;word-break:break-all;"  ><%= rs("p_name")%><BR>[<%=rs("s_ProductId")%>]</td>
          <td align="center" nowrap  >
           <a href="manage.asp?p_id=<%=Rs("s_sysid")%>">����</a>&nbsp;
          <%if rs("s_buytest") then %>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="paytest.asp?hostID=<%=rs("s_sysid")%>">ת��</a>
		  <%else%>
          <a href="renewHost.asp?hostid=<%=Rs("s_sysid")%>">����</a>&nbsp;
          <a href="UpHost.asp?hostID=<%=rs("s_sysid")%>">����</a>
		  <%end if%>&nbsp;
         </td>
          </td>
        </tr>
        <%
		cur=cur+1
		rs.movenext
	Loop
	

rs.close
conn.close
%>

<tr align="center" bgcolor="#ffffff">
        <td colspan="9" class="tdbg"><%=pagenumlist%></td>
</tr> 

</table>
</form>
<br>
<table class="manager-table">
  <tr> 
    <th width="100%" bgcolor="#C2E3FC" height="21">&nbsp;��������״̬ͼ��˵��:</th>
  </tr>
  <tr> 
    <td> 
      <p align="center"> <img border="0" src="/images/green1.gif">��������&nbsp;&nbsp; 
        <img border="0" src="/images/green2.gif">������ͣ&nbsp;&nbsp; <img border="0" src="/images/yell1.gif">��������&nbsp;&nbsp; 
        <img border="0" src="/images/yell2.gif">����ֹͣ&nbsp;&nbsp; <img border="0" src="/images/fei1.gif">��վ�ѹ���&nbsp;&nbsp; 
        <img border="0" src="/images/sysstop.gif">��ϵͳֹͣ <img src="/manager/images/nodong.gif" width="17" height="17">δ����ɹ�
    </td>
  </tr>
</table>








		  </div>
	 </div>

  </div>
<script src="/jscripts/setmybak.js"></script>

 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>