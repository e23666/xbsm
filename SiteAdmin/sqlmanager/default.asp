<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)
Response.Charset="gb2312"



if requesta("act")="ywgh"  then
	conn.open constr
	if Check_as_Master(1) then
		
		u=trim(requesta("u"))
		set u_rs=conn.execute("select u_id,u_name from UserDetail where u_name='"&u&"'")
		if u_rs.eof then
			die "查询用户名称失败！"
		else
			u_id=u_rs("u_id")
			u_name=u_rs("u_name")
			u_rs.close
			set u_rs=nothing
		end if
		d_id=checkNumArray(trim(requesta("id")))
		'conn.execute("update vhhostlist set S_ownerid="&u_id&" where s_sysid in("&d_id&")")
		set hrs=Server.Createobject("adodb.recordset")
		sql="select * from databaselist where dbsysid in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("dbu_id")<>u_id then
			mname=hrs("dbname")
  			hrs("dbu_id")=u_id
			hrs.update
			call Add_Event_logs(session("user_name"),4,mname,"所有者变更到["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "权限不足"
	 end if
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<script type="text/javascript" src="/jscripts/check.js"></script>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>SQL 数 据 库 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">SQL数据库管理</a> | <a href="adddatabase.asp">手工添加SQL数据库</a> | <a href="../admin/HostChg.asp">业务过户 </a> | <a href="syn.asp">同步上级数据库 </a></td>
  </tr>
</table>
<br />
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" bgcolor="#000000" class="border">
<form name="search" method="post" action="default.asp">
            <tr bgcolor="#FFFFFF"> 
              <td width="38%" align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">查找数据库:              </td>
              <td width="62%" bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbname" type="text" class="textfield" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">查找数据库用户名:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbloguser" type="text" class="textfield" id="dbloguser" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">查找用户名:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="u_name" type="text" class="textfield" id="u_name" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td align="right" bgcolor="#FFFFFF" class="tdbg"> 
              <p style="margin-left: 9;">查找IP:              </td>
              <td bgcolor="#FFFFFF" class="tdbg"> 
                <p style="margin-left: 9;"> 
                  <input name="dbserverip" type="text" class="textfield" id="dbserverip" >
              </td>
    </tr>
            <tr bgcolor="#FFFFFF"> 
              <td bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
              <td bgcolor="#FFFFFF" class="tdbg">
                <p style="margin-left: 9;"> <input type="submit" name="button" id="button" value="　开始查找　" />
              <input type="hidden" name="module" value="search" /></td>
    </tr>
          </form>
        </table>      
<br />
      <%

sqlstring="select temp.*,giftabout.gcomment from (SELECT  productlist.p_name, databaselist.dbname, UserDetail.u_name, databaselist.dbserverip, databaselist.dbloguser, databaselist.dbbuydate, databaselist.dbexpdate, databaselist.dbstatus, databaselist.dbsysid FROM (databaselist INNER JOIN productlist ON databaselist.dbproid = productlist.P_proId) INNER JOIN [UserDetail] ON databaselist.dbu_id = UserDetail.u_id   where databaselist.dbsysid>0) as temp  left join [giftabout] on ([giftabout].gname=[temp].dbname and  [giftabout].gtype=1) where 1=1 "
If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages")) 
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		dbname=trim(Requesta("dbname"))
		u_name=trim(Requesta("u_name"))
		dbloguser=trim(Requesta("dbloguser"))
		u_name=trim(Requesta("u_name"))
		dbserverip=trim(Requesta("dbserverip"))
		sqllimit =""
 		If dbname<>"" Then sqllimit=sqllimit & " and dbname like '%"&dbname&"%'"
		If u_name<>"" Then sqllimit=sqllimit & " and u_name like '%"&u_name&"%'"
		If dbloguser<>"" Then sqllimit=sqllimit & " and dbloguser like '%"&dbloguser&"%'"
		If dbserverip<>"" Then sqllimit=sqllimit & " and dbserverip = '"&dbserverip&"'"
 		sqlcmd= sqlstring & sqllimit  & "  order by dbbuydate desc"
		'重新查找  分别需要定义 传上来的参数等等求出
		conn.open constr
	 
		session("sqlsearch")=sqlcmd 
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & "  order by dbbuydate desc"
	rs.open session("sqlsearch"),conn,3
End If
%>
<%
If Not (rs.eof And rs.bof) Then
MaxPerPage=20
if Requesta("page")<>"" then
     currentPage=cint(Requesta("page"))
   	else
      currentPage=1
end if
totalPut=rs.recordcount                           
if currentpage<1 then                           
	currentpage=1                           
end if                           
                          
      		if (currentpage-1)*MaxPerPage>totalput then                           
	   		if (totalPut mod MaxPerPage)=0 then                           
	     			currentpage= totalPut \ MaxPerPage                           
	   		else                           
	      			currentpage= totalPut \ MaxPerPage + 1                           
	   		end if                           
      		end if                           
       		if currentPage=1 then                           
            		showContent                           
            		showpage totalput,MaxPerPage,"default.asp"                           
       		else                           
          		if (currentPage-1)*MaxPerPage<totalPut then                           
            			rs.move  (currentPage-1)*MaxPerPage                           
            			dim bookmark                           
            			bookmark=rs.bookmark                           
            			showContent                           
             			showpage totalput,MaxPerPage,"default.asp"                           
        		else                           
	        		currentPage=1                           
           			showContent                           
           			showpage totalput,MaxPerPage,"default.asp"                           
	      		end if                           
	   	end if                           
   	rs.close                                                   
   	sub showContent                           
       	dim i                           
	i=0                        
%>
        <TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 class="border">
          <TR align=middle> 
		   <td align="center" class="Title"><input type="checkbox" onClick="selectItem('s_sysid')" /></td>
            <td align="center" nowrap class="Title"><strong>产品名</strong></td>
            <td align="center" nowrap class="Title"><strong>数据库名</strong></td>
            <td align="center" nowrap class="Title"><strong>用户名</strong></td>
            <td align="center" nowrap class="Title"><strong>IP地址</strong></td>
            <td align="center" nowrap class="Title"><strong>开通日期</strong></td>
            <td align="center" nowrap class="Title"><strong>结束日期</strong></td>
            <td align="center" nowrap class="Title"><strong>状态</strong></td>
            <td align="center" nowrap class="Title"><strong>操作</strong></td>
          </TR>
          <%Do While Not rs.eof %>
          <TR align=center bgColor="#EAF5FC"> 
		   <td nowrap bgcolor="#FFFFFF" class="tdbg"><input type="checkbox" name="s_sysid" value="<%=Rs("dbsysid")%>" /></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>"><%= rs("p_name")%></a>
			
			</td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>"><%= replace(rs("dbname"),",","<br>") %></a><%
			if trim(rs("gcomment"))<>"" then
			response.write("(<font color=red>赠品</font>)")
			end if
			%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= rs("u_name") %></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= rs("dbserverip") %></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= formatDateTime(rs("dbbuydate"),2)%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%= formatDateTime(rs("dbexpdate"),2)%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><%
			if datediff("d",now(),rs("dbexpdate"))<0 then
            response.write " <img border=""0"" src=""/images/fei1.gif"">"
			else
			response.write showstatus(rs("dbstatus"))
			end if%></td>
            <td nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?module=detail&sid=<%=rs("dbsysId")%>">管理</a>|<a href="RenewDatabase.asp?dataID=<%=rs("dbsysId")%>">续费</a>|<a href="Updatabase.asp?dataID=<%=rs("dbsysId")%>">升级</a></td>
          </tr>
          <%
	 i=i+1     
	 if i>=MaxPerPage then exit do     
	 rs.movenext     
	 loop
	%>
	 <tr>
            <td colspan="9" class="tdbg">
			<form name="form3" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
			将选中邮局过户到:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="确定过户" onclick="ywgh()">&nbsp;&nbsp;
			 
            </form>
            </td>
	 </tr>
          <tr bgcolor="#FFFFFF"> 
            <form method=Post action="default.asp">
              <td colspan="11" align="center"> 
                <%end sub %>
                <%     
	function showpage(totalnumber,maxperpage,filename)     
  	dim n  
  	if totalnumber mod maxperpage=0 then     
     		n= totalnumber \ maxperpage     
  	else     
     		n= totalnumber \ maxperpage+1     
  	end if     
  	
  	if CurrentPage<2 then     
    		response.write "共有纪录 "&totalnumber&" 个&nbsp;首页 上一页&nbsp;"     
  	else     
    		response.write "共有纪录 "&totalnumber&" 个&nbsp;<a href="&filename&"?module=search&page=1&dbname="&dbname&"&u_name="&u_name&">首页</a>&nbsp;"     
    		response.write "<a href="&filename&"?module=search&page="&CurrentPage-1&"&dbname="&dbname&"&u_name="&u_name&">上一页</a>&nbsp;"     
  	end if     
     
  	if n-currentpage<1 then     
    		response.write "下一页 尾页"     
  	else     
    		response.write "<a href="&filename&"?module=search&page="&(CurrentPage+1)&"&dbname="&dbname&"&u_name="&u_name&">"       
    		response.write "下一页</a> <a href="&filename&"?module=search&page="&n&"&dbname="&dbname&"&u_name="&u_name&">尾页</a>"     
  	end if     
response.write "&nbsp;页次：<strong><font color=red>"&CurrentPage&"</font>/"&n&"</strong>页 "     
response.write "&nbsp;<b>"&maxperpage&"</b>个/页 "   
%>
                <% end function  %>              </td>
            </form>
          </tr>
        </table>
<%
  else
End If
conn.close
%>
        
        <%
Function showstatus(svalues)
	Select Case svalues
	  Case 0   '运行
		showstatus="<img src=../images/green1.gif width=17 height=17>"
	  Case -1'
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	  Case else
		showstatus="<img src=../images/nodong.gif width=17 height=17>"
	End Select
End Function
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
<br>
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
<script>

function selectItem(nm){
	$(':checkbox[name=' + nm + ']').each(function(){
		this.checked= !this.checked;
	})
}
function ywgh()
{
domstr=""
obj=$("input[name='s_sysid']:checkbox")
u=$("input[name=gh_u_name]");
if(u.val()==="")
{
alert("业务过户者为空!")
u.focus()
return false;
}
 for(var i=0;i<obj.length;i++)
 {
    if(obj[i].checked)
	{
	   if(domstr==="")
	   {
		   domstr=obj[i].value;
	   }else{
	      domstr+=","+obj[i].value;
	   }
	}
 }
 if(domstr==="")
 {
 alert("请选择要过户的域名!")
 return false;
 }
  if(confirm("你请定要将选中业务移到["+u.val()+"]帐户下！"))
  
  {

		 url="?act=ywgh&u="+u.val()+"&id="+domstr

		 $.get(url,"",function(date){
			  if(date=="200")
			  {
			  location.reload()
			  }else
			  {
			  alert(date);
			  }
		 })
}
}  

</script>
<%

function checkNumArray(str)
   temparray=split(str,",")
   newArray=""
   for i=0 to ubound(temparray)
      if isnumeric(temparray(i)&"") then
	  		if newArray="" then
				newArray=temparray(i)
			else
				newArray=newArray&","&temparray(i)
			end if
	  end if
   next
   if newArray="" then newArray=0
   checkNumArray=newArray
end function
%>