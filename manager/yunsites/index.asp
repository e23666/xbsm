<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr 
sqlstring="select * from yunsites where userid="& session("u_sysid")&" order by id desc"
rs.open sqlstring,conn,1,1
setsize=20
cur=1 
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-云建站管理</title>
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
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>云建站管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
			<table class="manager-table">
           	<thead>
               	   <tr>
                       <th>编号</th>
                       <th>帐号</th>
					   <th>购买时间</th>
                       <th>结束时间</th>
					   <th>管理</th>
                   </tr>
               </thead>
               <tbody>
			   <%	Do While Not rs.eof And cur<=setsize%>
                 <tr>
					<td><%=cur%></td>
					<td><%=rs("s_webadmin")%></td>
					<td><%=FormatDateTime(rs("s_buytime"),2)%></td>
					<td><%=FormatDateTime(rs("s_exprietime"),2)%></td>
					<td><a href="manager.asp?id=<%=rs("id")%>">管理</a></td>
				 </tr>			 
			<%
         		cur=cur+1
         		rs.movenext

         	Loop
         	rs.close
         	conn.close
         	%>
		       </tbody>
			   </table>



		<div class="mf-page "><%=pagenumlist%></div>




		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>