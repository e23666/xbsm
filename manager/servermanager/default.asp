<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
act=requesta("act")
select case act
       case "modhostid"
	   id=requesta("id")
	   value1=requesta("value1")
	   if not isnumeric(id) then die "error"
	   set urs=Server.CreateObject("adodb.recordset")
	   sql="select top 1 *  from HostRental where u_name='"& session("user_name") &"' and id=" & id
	   urs.open sql,conn,1,3
		if not urs.eof then
			urs("s_bz")=value1
			urs.update
			
			if trim(value1)="" then
			   if urs("HostID")="ebscloud" then
			      value1="����������"
			  else
			      value1=urs("HostID")
			  end if
			end if
			
			
		urs.close
		set urs=nothing	
			
		die value1		
		else
		die "error"
		end if
	   case "del"
	   		id=requesta("id")
			if id<>"" then
'	   			conn.execute "delete from HostRental where u_name='"& session("user_name") &"' and id=" & id
'			    response.redirect request("script_name")
				response.end
			end if
end select

'ɾ��10������δ��ͨ����
conn.execute "delete from HostRental where datediff("&PE_DatePart_H&",submittime,"&PE_Now&")>=10 and (AllocateIP is null or AllocateIP='') and Start="&PE_False&""

'ɾ����������
conn.execute "delete from HostRental where datediff("&PE_DatePart_H&",submittime,"&PE_Now&")>=6 and buytest="&PE_True&""

sqlArray=Array("h.StartTime,��ͨ����,date","AllocateIP,IP,a")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="Select *  from HostRental  where u_name='"& session("user_name") &"' " & newsql & " and (Start="&PE_True&" or buytest="&PE_True&") order by id desc"
 
rs.open sqlstring,conn,1,1
    setsize=10
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-���������йܹ���</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script>
function setbname(_id,_old){
	 var obj=$("#h_"+_id);
	 var ret = prompt("������������ı�ע��Ϣ(50����������)�����Ϊ�ս���ʾ�����ͺš�",_old);
	 
	 if (ret == null){ret=""};
	 if (ret==_old) return false;
	 
	 $.post("?","act=modhostid&id=" + _id + "&value1=" + escape(ret)+"&r="+Math.random(),function(xml){
            obj.html(xml)
		});


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
			   <li><a href="/Manager/servermanager/">����IP��������</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 

<form name=form1 method="post" action="<%=request("script_name")%>"> 
  <%=searchlist%>
          <table class="manager-table">
        <tr>
          <th><strong>���</strong></th>
          <th><strong>����IP</strong></th>
          <th><strong>����</strong></th>
          <th><strong>״̬</strong></th>
          <th><strong>֧����ʽ</strong></th>
          <th><strong>ʹ������</strong></th>
          <th><strong>����</strong></th>
    </tr>
     <%

	do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
%>
        <tr align=middle bgcolor="<%=tdcolor%>">
          <td  class="tdbg" >
          <label id="h_<%=rs("id")%>">
		  <%
		  if trim(rs("s_bz"))<>"" then
		     response.Write(trim(rs("s_bz")))  
		  else 
			  if rs("HostID")="ebscloud" then
			  Response.Write("����������")
			  else
			  response.Write(rs("HostID"))
			  end if
		  end if 
		 %></label>&nbsp;&nbsp;<img src="/images/1341453609_help.gif" onclick="setbname(<%=rs("id")%>,'<%=rs("s_bz")%>')" /></td>
          <td   class="tdbg"><%=Rs("AllocateIP")%>&nbsp;
		  <%If rs("ddos")>0 Then %>
			<p style="color:#fe6b1b">(�߷�������ֵ:<%=rs("ddos")%>G)</p>
		  <%End if%>
		  <%If rs("prodtype")&""="1" Then%>
			<BR><font style="color:#fe6b1b">(��ƵCPU��)</font>
		  <%End if%>
		  <%If rs("snapadv")&""="1" Then%>
			<BR><font style="color:#fe6b1b">(�߼��ƿ���)</font>
		  <%End if%>
		   <%If rs("cc")&""="1" Then%>
			<BR><font style="color:#fe6b1b">(CC����)</font>
		  <%End if%>
		  </td>
          <td   class="tdbg">  <%if Rs("HostID")="ebscloud" then
		  %>
          CPU:<%=Rs("CPU")%>����<br />
		  �ڴ�:<%=Rs("Memory")%>M<br />
		  Ӳ��:<%=Rs("HardDisk")%>G<BR />
          ����:<%=Rs("flux")%>M
          <%
		  else
		  %>
		  <%=Rs("CPU")%><br /><%=Rs("Memory")%><br /><%=Rs("HardDisk")%>
          <%end if%></td>
          <td   class="tdbg"  >
		  
		  <%
		  if Rs("Start") then
		 
		    'etime=formatDateTime(DateAdd("m",rs("alreadypay"),rs("starttime")),2)
			etime=formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",Rs("alreadypay"),Rs("starttime"))),2)
			   if datediff("d",now,etime)<0 then
				 response.Write("<font color=red>����</font>")
			   else
				response.Write("<font color=green>����</font>")
			   end if
		  else
		   response.Write("<font color=red>δ֪</font>")
		  end if
		  %>
	 <%if rs("buytest") then
		  response.Write("<br>(<font color=red>����</font>)")
		  end if
		  %>&nbsp;<%'=datediff("h",rs("StartTime"),"&PE_Now&")%></td>
          <td nowrap class="tdbg"  ><%if rs("paymethod")=1 then
		   		response.write "����"
			elseif rs("paymethod")=2 then
			   response.write "����"
			elseif rs("paymethod")=0 then
			   response.write "��"
			elseif rs("paymethod")=3 then
			   response.write "����"
			end if%></td>
          <td align="center" nowrap class="tdbg" ><%

		  if isnull(Rs("preday")) Or Rs("preday")="" then 
		  preday=0
		  else
		  preday=clng(Rs("preday"))
		  end if
		  

			if Rs("Start") and isdate(rs("starttime")) and  rs("starttime")&""<>"" then
				Response.write "��" & formatDateTime(Rs("StartTime"),2) & "��ʼ<br>"
				response.write "��" & formatDateTime(DateAdd("d",preday,DateAdd("m",rs("alreadypay"),rs("starttime"))),2)&"����"
			else
				Response.write "δ��ͨ"
			end if
%>		  </td>
      <td align="center" nowrap class="tdbg" >
	  <%
	  if isip(rs("AllocateIP")&"") then
	  %>
	  <a href="renew.asp?id=<%=rs("id")%>">����</a> 
        | <a href="modify.asp?id=<%=rs("id")%>">����</a> |     <%
		if Rs("HostID")="ebscloud" then
		%>
         <a href="updatediy.asp?id=<%=rs("id")%>">����</a> | <a href="snap.asp?id=<%=rs("id")%>">����</a>
        <%
		else
		%>
        <a href="update.asp?id=<%=rs("id")%>">����</a>
        <%end if%>
		<%else
		response.write("-")
		end if
		%>
		
		</td>
    </tr>
        <%
		rs.movenext
		cur=cur+1
	Loop

%>
	    <tr align="center" bgcolor="#ffffff">
        <td colspan="12" class="tdbg"><%=pagenumlist%></td>
    </tr>
 
        </form>
</table>

<!--#include virtual="/config/bottom_superadmin.asp" -->
<%
rs.close
conn.close
function getStatus(byval sta)
	if sta="" or isnull(sta) or not sta then
		getStatus="δ��ͨ"
	elseif sta then
		getStatus="�ѿ�ͨ"
	end if
	
end function
function getHostType(ByVal xxx)
	select case xxx
		case 0
			getHostType="<b><font color=green>����</font></b>"
		case 1
			getHostType="<b><font color=red>VPS</font></b>"
		case 2
			getHostType="<b><font color=blue>�й�</font></b>"
	end select
end function
%>
          
        







		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>