<!--#include virtual="/config/config.asp" -->
<%
Check_Is_Master(6)
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
		sql="select * from mailsitelist where m_sysid in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("m_ownerid")<>u_id then
			mname=hrs("m_bindname")
  			hrs("m_ownerid")=u_id
			hrs.update
			call Add_Event_logs(session("user_name"),2,mname,"所有者变更到["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "权限不足"
	 end if
end if



sqlstring="SELECT productlist.p_name,mailsitelist.m_ownerid,mailsitelist.m_bindname, mailsitelist.m_serverip, mailsitelist.m_sysid, mailsitelist.m_expiredate, UserDetail.u_name, mailsitelist.m_status, mailsitelist.m_free, mailsitelist.m_buytest,m_productid FROM (mailsitelist INNER JOIN productlist ON mailsitelist.m_productId = productlist.P_proId) INNER JOIN UserDetail ON mailsitelist.m_ownerid = UserDetail.u_id where  mailsitelist.m_sysid>0"
If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		m_bindname=Requesta("m_bindname")
		searchClass=requestf("searchClass")
		sqllimit =""
 		If m_bindname<>"" then
		  if searchClass="m_bindname" Then sqllimit=sqllimit & " and mailsitelist.m_bindname like '%"&m_bindname&"%'"
		  if searchClass="u_name" then sqllimit=sqllimit & " and UserDetail.u_name = '"&m_bindname&"'"
		  if searchClass="m_serverip" then sqllimit=sqllimit & " and mailsitelist.m_serverip = '"&m_bindname&"'"
		end if
		
 		sqlcmd= sqlstring & sqllimit  & "  ORDER BY mailsitelist.m_buydate DESC"
		'重新查找  分别需要定义 传上来的参数等等求出
		conn.open constr
		session("sqlsearch")=sqlcmd
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & "  ORDER BY mailsitelist.m_buydate DESC"
	rs.open session("sqlsearch"),conn,3
End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<script type="text/javascript" src="/jscripts/check.js"></script>

<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> 企业邮局管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">
		<a href="default.asp">企业邮局管理</a> | <a href="MailAdd.asp">手工添加企业邮局</a> 
      | <a href="../admin/HostChg.asp">业务过户 </a> 
      | <a href="syn.asp">同步业务 </a>
	  
	  </td>
  </tr>
</table>
      <br />
      
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="border">
                <tr> 
                  <form name="search" method="post" action="default.asp">
                    <td colspan="3"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
							<tr><td align="right" class="tdbg"><input type="hidden" name="module" value="search">
							  项目：</td>
							  <td class="tdbg"><select name="searchClass" >
                                <option selected value="m_bindname">邮局名</option>
                                <option  value="u_name">用户名</option>
                                <option value="m_serverip">IP</option>
                              </select></td>
							</tr>
							<tr>
							<td width="40%" align="right" class="tdbg">关键字：</td>
							<td width="60%" class="tdbg">
							<input type="text" name="m_bindname" size="20">							</td>
							</tr>
							
							<tr><td align="center" class="tdbg">&nbsp;</td>
							  <td class="tdbg"><input type="submit" name="button" id="button" value=" 开始搜索 "></td>
							</tr>
					</table>                    </td>
                  </form>
                </tr>
              </table>
<%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 10
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%><br>
                <TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
<form action="default.asp" method=post>
                  <TR align=middle> 
				   <td align="center" class="Title"><input type="checkbox" onClick="selectItem('s_sysid')" /></td>
                    <td width="12%" align="center" class="Title"><strong>产品名</strong></td>
                    <td width="14%" align="center" class="Title"><strong>域　名</strong></td>
                    <td width="13%" align="center" class="Title"><strong>IP地址</strong></td>
                    <td width="19%" align="center" class="Title"><strong>到期日期</strong></td>
                    <td width="13%" align="center" class="Title"><strong>用户</strong></td>
                    <td width="5%" align="center" nowrap class="Title"><strong>代管</strong></td>
                    <td width="10%" align="center" class="Title"><strong>状态</strong></td>
                    <td width="14%" align="center" class="Title"><strong>管理</strong></td>
    </TR>
                  <%
	Do While Not rs.eof And i<11

	%> 
                  <TR align=middle> 
				  <td class="tdbg"><input type="checkbox" name="s_sysid" value="<%=Rs("m_sysid")%>" /></td>
                    <td class="tdbg"><%= rs("p_name")%>
					<%If rs("m_productid")="yunmail" then %>
							<%If rs("m_free") then%>
								<font color=green>(基础版)</font>
							<%else%>
								<font color=blue>(专业版)</font>
							<%End if%>
					<%End if%>
					</td>
                    <td class="tdbg"><%= replace(rs("m_bindname"),",","<br>") %></td>
                    <td class="tdbg"><%= rs("m_serverip") %></td>
                    <td class="tdbg"><%= left(replace(rs("m_expiredate")," ","   "),10) %></td>
                    <td class="tdbg"><a href="../usermanager/detail.asp?u_id=<%=Rs("m_ownerid")%>" target="_blank"><font color="#0000FF"><%=rs("u_name")%></font></a> </td>
                    <td class="tdbg"><a href="../chguser.asp?module=chguser&username=<%=rs("u_name")%>"><font color="#0000FF">代管</font></a> </td>
                    <td nowrap class="tdbg"><%
					if not rs("m_free") and rs("m_status")=0 then
						if rs("m_buytest")=0 or isnull("m_buytest") then
						
						Response.write "收费邮局"
						else
						Response.write "试用邮局"
						end if
					else
						Response.write showstatus(rs("m_status"),rs("m_productid"))
					end if
					%></td>
                    <td align="center" nowrap class="tdbg">
				
					<a href="info.asp?module=detail&sid=<%=rs("m_sysId")%>">管理</a> | <a href="javascript:void(0)" onclick="delmail(<%=Rs("m_sysId")%>,<%=Rs("m_ownerid")%>)">删除操作</a>
					 
					</td>
    </tr>
                  <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%> 
	 <tr>
            <td colspan="9" class="tdbg">
			<form name="form3" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
			将选中业务过户到:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="确定过户" onclick="ywgh()">&nbsp;&nbsp;
			 
            </form>
            </td>
	 </tr>
                  <tr bgcolor="#FFFFFF"> 
                    <td colspan =9 align="center"> 
                        <a href="default.asp?module=search&pages=1"><font color="#07339C">第一页</font></a> 
                      &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>"><font color="#07339C">前一页</font></a>&nbsp; 
                      <a href="default.asp?module=search&pages=<%=pages+1%>"><font color="#07339C">下一页</font></a>&nbsp; 
                      <a href="default.asp?module=search&pages=<%=rsPageCount%>"><font color="#07339C">共<%=rsPageCount%>页</font></a>&nbsp; 
                      <font color="#07339C">第<%=pages%>页</font> </td>
                  </TR>
</form>      
</table>
                <%
  else
	rs.close
	conn.close
End If

Function showstatus(svalues,t_)
	If t_="yunmail" Then
		Select Case svalues
		Case 2
			showstatus="<img src=/images/green1.gif width=17 height=17 alt=免费邮局>"
		Case else
			showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
		End select
	else
		Select Case svalues
		  Case 0   '运行
			showstatus="<img src=/images/green1.gif width=17 height=17 alt=免费邮局>"
		  Case -1'
			showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
		  Case else
			showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
		End Select
	End if
End Function
%><!--#include virtual="/config/bottom_superadmin.asp" -->
<br>
<table border="0" cellpadding="0" cellspacing="1" width="100%" bgcolor="#999999" height="45">
  <tr> 
    <td width="100%" bgcolor="#C2E3FC" height="21">&nbsp;企业邮局状态图标说明:</td>
  </tr>
  <tr> 
    <td width="100%" bgcolor="#FFFFFF" height="20"> 
      <p align="center"><img src="/images/mail-vip.jpg" width="15" height="14"> 
        收费邮局<img border="0" src="/images/green1.gif">免费邮局&nbsp; <img border="0" src="/images/green2.gif">购买暂停&nbsp;&nbsp; 
        <img border="0" src="/images/yell1.gif">试用运行&nbsp;&nbsp; <img border="0" src="/images/yell2.gif">试用停止&nbsp;&nbsp; 
        <img border="0" src="/images/fei1.gif">邮局已过期&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">被系统停止 
        <img src="/manager/images/nodong.gif" width="17" height="17">未开设成功 
    </td>
  </tr>
</table>
<script>
function delmail(m,u){
	if(confirm("您确定要删除此邮局?")){
			$.post("load.asp",{act:"del",m_id:m,userid:u},function(data){
					alert(data.msg)
			},"json")

	}

}

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