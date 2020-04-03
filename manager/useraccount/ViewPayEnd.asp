<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
Page=Trim(requesta("Page"))
Act=Trim(requesta("Act"))
ActID=Trim(requesta("ActID"))
if not isNumeric(Page) then Page=1
if Act<>"" then
  if not isNumeric(ActID) then url_return "缺少ID号",-1
  if Act="Erase" then
	 Sql="Delete from PayEnd Where id=" & ActID & " and UserName='" & Session("User_name") & "'"
	 conn.Execute(Sql)
	elseif Act="ReSubmit" then
	 Sql="Select P_State from PayEnd Where id=" & ActID &" and UserName='" & Session("User_Name") & "'"
	  Rs.open Sql,conn,1,1
	  if Rs.eof then url_return "未找到此付款确认",-1
	  if Rs("P_state")<>3 then url_return "此付款确认没被拒绝,无法再次提交",-1
	  Rs.close
	  Sql="update PayEnd Set P_State=0,PDate='"&now()&"',SubIP='" & Request.ServerVariables("Remote_Addr") & "' where id=" & ActID & " and UserName='" & Session("user_name") & "'"
	  conn.Execute(Sql)
      Response.write "<script language=javascript>alert('付款确认重新提交成功，请等待处理');</script>"
  end if
end if
Sql="Select * from payend Where UserName='" & Session("User_name") & "' order by Pdate desc"
Rs.open Sql,conn,3,3

TotalPage=0
if not Rs.eof then
  Rs.PageSize=5
  TotalPage=Rs.PageCount
  if Page<1 then Page=1
  if Page>TotalPage then Page=TotalPage
  Rs.AbsolutePage=Page
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-汇款查询</title>
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
			   <li><a href="/manager/useraccount/ViewPayEnd.asp">汇款查询</a></li>
			   
			 </ul>
		  </div>
		  <div class="manager-right-bg">


                  <form name="form1" action="<%=Request("script_name")%>">
 <table class="manager-table">
  <%
i=1
do while not Rs.eof and i<=5
%>
                                <input type="hidden" name="Act">
                                <input type="hidden" name="Actid">
                                
                                  <tr valign="bottom">
                                    <th colspan="2"   ><a href="viewpayend.asp?Act=ReSubmit&Actid=<%=Rs("id")%>">重新确认</a> | <a href="viewpayend.asp?Act=Erase&Actid=<%=Rs("id")%>">删除</a>                              </th>
                                  </tr>
                                  <tr>
                                    <th width="26%" align="right" >状态：</tH>
                                    <td width="74%" align="left"> 
                                      <%
if Rs("P_State")=0 then 
   Response.write "待处理"
elseif Rs("P_State")=1 then
   Response.write "已处理"
elseif Rs("P_State")=3 then
   Response.write "<font color=red>被拒绝</font>"
end if
%> </td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >姓名：</tH>
                                    <td align=left><font size="2"><%=rs("Name")%> </font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >用户名：</tH>
                                    <td align=left><font size="2"><%=rs("UserName")%> </font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >订单号：</tH>
                                    <td align=left><font size="2"><%=rs("Orders")%> &nbsp;</font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >汇款日期：</tH>
                                    <td align=left><font size="2"><%=rs("PayDate")%> </font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >金额：</tH>
                                    <td align=left><font size="2"><%=rs("Amount")%> </font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >方式：</tH>
                                    <td align=left><font size="2"><%=rs("PayMethod")%> &nbsp;</font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >用途：</tH>
                                    <td align=left><font size="2"><%=rs("ForUse")%> &nbsp;</font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >备注：</tH>
                                    <td align=left><font size="2"><%=rs("Memo") & "&nbsp;"%> </font></td>
                                  </tr>
                                  <tr>
                                    <tH align="right" >提交时间：</tH>
                                    <td align=left><font size="2"><%=rs("Pdate") & "&nbsp;"%></font></td>
                                  </tr>
                                  <%if Rs("P_State")=3 then%>
                                  <tr>
                                    <tH align="right" >拒绝原因：</tH>
                                    <td align=left><font size="2"></font><font size="2"></font><font size="2"><%=rs("P_Memo") & "&nbsp;"%></font></td>
                                  </tr>
                                  <%end if%>
                        
                       
                              <%
Rs.moveNext
Loop
Rs.close
%>
      </table><br>
                            共计<%=TotalPage%>页,第<%=Page%>页,<a href="<%=Request("script_name")%>?Page=<%=Page-1%>" class="z_next_page">上一页</a>,<a href="<%=Request("script_name")%>?Page=<%=Page+1%>" class="z_next_page">下一页</a></td>
                         
          
            </form>


		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>






 