<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
sqlArray=Array("p_name,��Ʒ��,str","m_bindname,�ʾ�����,str","m_serverip,��Ӧ������,str","m_buydate,����ʱ��,date","m_expiredate,����ʱ��,date")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="select temp.*,remarks.r_txt  from (SELECT * FROM mailsitelist a INNER JOIN productlist b ON (a.m_productId = b.P_proId)) as temp left join Remarks on (temp.m_sysid=Remarks.p_id and Remarks.r_type=2) where  m_ownerid="&session("u_sysid")&" " & newsql & " order by m_buydate desc"
 
rs.open sqlstring,conn,1,1
    setsize=10
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<HEAD>
<title>�û������̨-��ҵ�ʾֹ���</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<style>
.hs{color:#666; text-align:center;}
</style>
</HEAD>

<body id="thrColEls">
<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">��ҵ�ʾֹ���</div>
          <div class="table_out">
            <table border="0" cellpadding="0" cellspacing="1" width="100%" bgcolor="#999999" height="45">
              <tr>
                <td width="100%" bgcolor="#C2E3FC" height="21">&nbsp;��ҵ�ʾ�״̬ͼ��˵��:</td>
              </tr>
              <tr>
                <td width="100%" bgcolor="#FFFFFF" height="20"><p align="center"><img src="/images/mail-vip.jpg" width="15" height="14"> �շ��ʾ�<img border="0" src="/images/green1.gif">����ʾ�&nbsp; <img border="0" src="/images/green2.gif">������ͣ&nbsp;&nbsp; <img border="0" src="/images/yell1.gif">��������&nbsp;&nbsp; <img border="0" src="/images/yell2.gif">����ֹͣ&nbsp;&nbsp; <img border="0" src="/images/fei1.gif">�ʾ��ѹ���&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">��ϵͳֹͣ <img src="/manager/images/nodong.gif" width="17" height="17">δ����ɹ� </td>
              </tr>
            </table>
            <br>
            <table width="99%" border="0" cellpadding="4" cellspacing="1"  class="border managetable tableheight">
              <form name=form1 method="post" action="<%=request("script_name")%>">
                <tr align=middle class="titletr" >
				<td  align="center" class="Title"><strong>�ʾ�����</strong></td>
                  <td  height="21" class="Title" ><strong>��Ʒ��</strong></td>
                  
                  <td  align="center" class="Title"><strong>��Ӧ������</strong></td>
                  <td  align="center" class="Title"><strong>ʹ������</strong></td>
                  <td align="center" class="Title"><strong>״̬</strong></td>
                  <td  align="center" class="Title"><strong>����</strong></td>
                </tr>
                <%
	do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#EAF5FC"
	%>
                <TR align=middle bgcolor="<%=tdcolor%>">
				 <td style="word-wrap: break-word;word-break:break-all; " ><%= replace(rs("m_bindname"),",","<br>") %>
				 <img src="/images/1341453609_help.gif" onclick="setmybak(<%=rs("m_sysId")%>,'<%=rs("m_bindname")%>',2)">
						  <%if trim(rs("r_txt"))<>"" then
						  response.write("<div class=""hs"">("&rs("r_txt")&")</div>")
						  end if
						  %>
				 </td>
                  <td  style="word-wrap: break-word;word-break:break-all;" ><a href="manage.asp?p_id=<%=rs("m_sysId")%>"><%= rs("p_name")%><BR>[<%=rs("m_productid")%>]</a></td>
                 
                  <td  style="word-wrap: break-word;word-break:break-all;"><%= rs("m_serverip") %></td>
                  <td  ><%= formatdatetime(rs("m_buydate"),2) & "����<br>"%> <%= formatDateTime(DateAdd("yyyy",Rs("m_years"),rs("m_buydate")),2) & "����"%></td>
                  <td  style="width:50px;"><%=showstatus(rs("m_status"),rs("m_free"),rs("m_buytest"))%></td>
                  <td align="center" ><a href="manage.asp?p_id=<%=rs("m_sysId")%>">����</a>
                    <%if rs("m_buytest") then %>
                    <a href="paytest.asp?m_id=<%=rs("m_sysId")%>">ת��</a>
                    <%else%>
                    <a href="renewMail.asp?id=<%=rs("m_sysId")%>">����</a> <a href="upMail.asp?id=<%=rs("m_sysId")%>">����</a>
                    <%end if%></td>
                </tr>
                <%
		rs.movenext
		cur=cur+1
	Loop

	%>
                <tr bgcolor="#FFFFFF">
                  <td colspan =8 align="center" #EAF5FC><%=pagenumlist%></td>
                </TR>
                <tr>
                  <td colspan="8" class="tdbg"><%=searchlist%></td>
                </tr>
              </form>
            </table>
            <%

	rs.close
	conn.close
Function showstatus(svalues,free,buytest)
		if not svalues and not free then
			if buytest then
				showstatus="<img src=/images/yell1.gif border=0 alt='�����ʾ�'>"
			else
				showstatus="<img src=/images/mail-vip.jpg alt=�շ��ʾ�>"
			end if
		else
			Select Case svalues
			  Case 0   '����
				showstatus="<img src=/images/green1.gif width=17 height=17 alt=����ʾ�>"
			  Case -1'
				showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=����ʾ�>"
			  Case else
				showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=����ʾ�>"
			End Select
		end if
	
End Function
%>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>
<script src="/jscripts/setmybak.js"></script>
</body>
</html>
