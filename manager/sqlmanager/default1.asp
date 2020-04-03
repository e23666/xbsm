<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
sqlArray=Array("dbname,数据库名,str","dbserverip,IP地址,str","dbbuydate,开通日期,date","dbexpdate,过期日期,date","p_name,产品名,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="SELECT  productlist.p_name, databaselist.dbname,databaselist.dbpasswd,UserDetail.u_name, databaselist.dbserverip, databaselist.dbbuydate, databaselist.dbexpdate, databaselist.dbstatus, databaselist.dbsysid,databaselist.dbbuytest FROM (databaselist INNER JOIN productlist ON databaselist.dbproid = productlist.P_proId) INNER JOIN UserDetail ON databaselist.dbu_id = UserDetail.u_id where dbu_id=" & session("u_sysid") & " "& newsql & " order by dbbuydate desc"
    rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)                     
                   
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><title>用户管理后台-Mssql数据库管理</title>
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
          <div class="tab">Mssql数据库管理</div>
          <div class="table_out">
         
        

<table border="0" cellpadding="0" cellspacing="1" width="100%" bgcolor="#999999" height="45">
  <tr> 
    <td width="100%" bgcolor="#C2E3FC" height="21">&nbsp;数据库状态图标说明:</td>
  </tr>
  <tr> 
    <td width="100%" bgcolor="#FFFFFF" height="21"> 
      <p align="center"><img border="0" src="/images/green1.gif">购买运行<img border="0" src="/images/green2.gif">购买暂停&nbsp; 
        <img border="0" src="/images/fei1.gif">已过期&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">被系统停止 
        <img src="/manager/images/nodong.gif" width="17" height="17">未开设成功 
    </td>
  </tr>
</table>

<table width="99%" border="0" cellpadding="4" cellspacing="1" bordercolordark="#ffffff" class="border managetable tableheight">
<form name="form1" action="<%=request("script_name")%>" method="post">
          <TR align=middle class='titletr'> 
            
            <td align="center" nowrap class="Title"><strong>数据库名</strong></td>
            <td align="center" nowrap class="Title"><strong>产品名</strong></td>
            <td align="center" nowrap class="Title"><strong>IP地址</strong></td>
            <td align="center" nowrap class="Title"><strong>开通日期</strong></td>
            <td align="center" nowrap class="Title"><strong>结束日期</strong></td>
            <td align="center" nowrap class="Title"><strong>状态</strong></td>
            <td align="center" nowrap class="Title"><strong>操作</strong></td>
          </TR>
          <%Do While Not rs.eof and cur<=setsize
		  		tdcolor="#ffffff"
				if cur mod 2=0 then tdcolor="#efefef"
		  %>
          <TR align=center bgColor="<%=tdcolor%>"> 
            
            <td  bgcolor="<%=tdcolor%>" class="tdbg" style="word-wrap: break-word;word-break:break-all;"><a href="manage.asp?p_id=<%=rs("dbsysid")%>"><%= rs("dbname") %></a></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg" style="word-wrap: break-word;word-break:break-all;"><%= rs("p_name")%></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg" style="word-wrap: break-word;word-break:break-all;"><%= rs("dbserverip") %></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg"><%= formatDateTime(rs("dbbuydate"),2)%></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg"><%= formatDateTime(rs("dbexpdate"),2)%></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg"><%
			if datediff("d",now(),rs("dbexpdate"))<0 then
            response.write " <img border=""0"" src=""/images/fei1.gif"">"
			else
			 response.write showstatus(rs("dbstatus"),rs("dbbuytest"))
			end if%></td>
            <td  bgcolor="<%=tdcolor%>" class="tdbg">
            <a href="manage.asp?p_id=<%=rs("dbsysid")%>">管理</a>&nbsp;
            <%if rs("dbbuytest") then %>
       			 <a href="paytest.asp?id=<%=rs("dbsysId")%>">转正</a>
			<%else%>
            	<a href="updata.asp?id=<%=rs("dbsysid")%>">升级</a>
            	<a href="renewdata.asp?id=<%=rs("dbsysid")%>">续费</a>
            <%end if%>
           
            </td>
          </tr>
          <%
   
			 rs.movenext  
		 	cur=cur+1   
		  loop
	%>
        <tr align="center">
        <td colspan="10" class="tdbg"><%=pagenumlist%></td>
        </tr>
        <tr>
            <td colspan="10" class="tdbg"><%=searchlist%></td>
        </tr>
        </form>
        </table>
        <%
rs.close
conn.close

Function showstatus(svalues,byval buytest)
	Select Case svalues
	  Case 0   '运行
	  	if buytest then
			showstatus="<img src=/images/yell1.gif width=17 height=17 title='试用运行'>"			
		else
		showstatus="<img src=../images/green1.gif width=17 height=17>"
		end if
	  Case -1'
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	  Case else
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	End Select
End Function
%>
         
         
         
         

         
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>


</body>
</html>