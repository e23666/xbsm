<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%

sqlArray=Array("p_name,��Ʒ��,str","p_agent_price,�۸�,int","buy_num,����,int","datetime,�ύʱ��,date","makedate,��ͨ����,date")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
conn.open constr
sql="select * from searchlist where u_id="&session("u_sysid")&" "  & newsql
rs.open sql,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<HEAD>
<title>�û������̨-�ƹ��Ʒ����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
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
          <div class="tab">�ƹ��Ʒ����</div>
          <div class="table_out">
            <table width="99%" border="0" cellpadding="4" cellspacing="1" bordercolordark="#ffffff" class="border managetable tableheight">
              <form name="form1" action="<%=request("script_name")%>" method="post">
                <tr class='titletr'>
                  <td align="center" nowrap ><strong>��Ʒ��</strong></td>
                  <td align="center" nowrap ><strong>�۸�</strong></td>
                  <td align=center nowrap ><strong>����</strong></td>
                  <td align=center nowrap ><strong>�ύ/��ͨ����</strong></td>
                  <td align=center nowrap ><strong>״̬</strong></td>
                </tr>
                <%do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
%>
                <tr align=middle bgcolor="<%=tdcolor%>">
                  <td align="center" style="word-wrap: break-word;word-break:break-all;" class="tdbg"><a href="m_default.asp?id=<%=rs("id")%>"><%=rs("p_name")%>(<%=ucase(rs("p_proid"))%>)</a></td>
                  <td align="center" style="word-wrap: break-word;word-break:break-all;" class="tdbg"><%=rs("p_agent_price")%></td>
                  <td align=center style="word-wrap: break-word;word-break:break-all;" class="tdbg"><%=rs("buy_num")%></td>
                  <td align=center style="word-wrap: break-word;word-break:break-all;" class="tdbg"><%=formatDateTime(rs("datetime"),2)%>/
                    <% if isDate(rs("makedate")) then
						Response.write formatDateTime(rs("makedate"),2)
					 else
					   Response.write "--"
					 end if%></td>
                  <td align=center nowrap class="tdbg"><%
                    If rs("check")="1" Then 
                         Response.Write "�������"
                       ElseIf rs("check")="-1" Then
					      Response.Write "�������ܾ�"
                       ElseIf rs("check")="-2" Then
					      Response.Write "�����ѷ���"
					   else
					      Response.Write "δ����"
					End if
 %></td>
                </tr>
                <%    
 
	 	rs.movenext  
		cur=cur+1   
	 loop     
   %>
                <tr align="center" bgcolor="#FFFFFF">
                  <td colspan="6" class="tdbg"><%=pagenumlist%></td>
                </tr>
                <tr>
                  <td colspan="6" class="tdbg"><%=searchlist%></td>
                </tr>
              </form>
            </table>
            <%
Function showstatus(svalues)
	Select Case svalues
	  Case 0   '����
		showstatus="<img src=/images/green1.gif width=17 height=17>"
	  Case -1'
		showstatus="<img src=/images/nodong.gif width=17 height=17>"
	  Case else
		showstatus="<img src=/images/nodong.gif width=17 height=17>"
	End Select
End Function
%>
            <p> 
              <!--#include virtual="/config/bottom_superadmin.asp" --> 
            </p>
            <p align="center"><a href="/">������ҳ</a></p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>
</body>
</html>
