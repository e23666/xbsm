<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
response.Buffer=true
conn.open constr
act=requesta("act")
select case trim(lcase(act))
case "adddomain"
adddomain()
case "deldomain"
delDomain()
case "addgroupdomain"
addgroupdomain
case "gettable"
gettable
end select


sub adddomain()
g_name=requesta("g_name")
g_id=requesta("g_id")
reg="^[A-Za-z0-9\u4e00-\u9fa5]+$"

if not checkRegExp(g_name,reg) then
die "300 格式错误"
end if


set a_rs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from groupUser where G_name='"&g_name&"' and  G_UserID=" &  session("u_sysid")&" and G_Type=0"
a_rs.open sql,conn,1,3
if not a_rs.eof then
response.write "300 分组名称已经存在"
else
	a_rs.addnew
		a_rs("G_UserID")=session("u_sysid")
        a_rs("G_name")=g_name
		a_rs("G_Type")=0
    a_rs.update
response.write "200 ok"
end if
a_rs.close
die ""
set a_rs=nothing
end sub

sub delDomain()
g_name=requesta("g_name")
'g_id=requesta("g_id")

set a_rs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from groupUser where G_name='"&g_name&"' and  G_UserID=" &  session("u_sysid")&" and G_Type=0 "
a_rs.open sql,conn,1,3
if a_rs.eof then
   response.write "300 分组查询失败"
else
   conn.execute("delete  from GroupInfo where GID="&a_rs("gid"))
   a_rs.delete
   response.write "200 ok"
end if
a_rs.close
die ""
end sub

sub addgroupdomain()
did=requesta("did")
g_name=requesta("g_name")
g_id=requesta("g_id")

ndid=checkNumArray(did)
	if trim(ndid)<>trim(did) then
	die "300 绑定域名有误"
	end if
	didstr=""  '新生成
	set d_rs=conn.execute("select top 20 d_id from domainlist where d_id in("&ndid&") and userid="&session("u_sysid"))
	do while not d_rs.eof
	   if didstr="" then
	   		didstr=d_rs("d_id")
	   else
	        didstr=didstr&","&d_rs("d_id")
	   end if
	d_rs.movenext
	loop
	if g_id>0 then
		sql="select count(*) from groupUser where g_name='"&g_name&"' and gid="&g_id
		if conn.execute(sql)(0)>0 then   '检查分组是否存在
			'删除以前归类
			sql="delete  from GroupInfo where yw_id in("&didstr&")"
	 
			conn.execute(sql)
			tempid=split(didstr,",")
			for ii=0 to ubound(tempid)
			sql="insert into groupInfo(gid,yw_id) values("&g_id&","&tempid(ii)&")"
	 
			conn.execute(sql)
			next
			die "200 ok"
		else
		die "300 参数非法"
		end if
	else
	   sql="delete  from GroupInfo where yw_id in("&didstr&")"
	   conn.execute(sql)
	   die "200 ok"
	end if

end sub

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
   checkNumArray=newArray
end function

sub gettable
page=requesta("page")
g_id=requesta("g_id")
k=requesta("k")
if not isnumeric(g_id&"") then g_id=0
if not isnumeric(page&"") then page=1
if trim(k)<>"" then
wherestr=" and strDomain like '%"&k&"%'"
end if

if g_id>0 then
sql="select top 1000 d_id,proid,strDomain,years,regdate,isreglocal from domainlist where  d_id in(select YW_ID from Groupinfo where GID="&g_id&") and userid=" &  session("u_sysid")&wherestr

else
sql="select top 1000 d_id,proid,strDomain,years,regdate,isreglocal from domainlist where  d_id not in(select YW_ID from Groupinfo where GID in(select GID from groupUser where G_Type=0 and  g_userid="&session("u_sysid")&")) and userid=" &  session("u_sysid")&wherestr
end if
set nrs=Server.CreateObject("adodb.recordset")
nrs.open sql,conn,1,1
if not nrs.eof then 
	nrs.pagesize=10
	if page<1 then page=1
	if clng(page)>clng(nrs.pagecount) then page=nrs.pagecount

	nrs.absolutepage=page
%>
	  <TABLE class="manager-table">
			  <TR>
			  	<Th width="40" align="center"><input name="checkall" type="checkbox" value="0" onclick="checkALL(this)" /></Th>
			  	<Th>域名</Th>
			  	<Th>类型</Th>
			  	<Th>状态</Th>
                <Th>类别</Th>
			  </TR>
              <%

			for i=0 to nrs.pagesize-1 '循环开始
				if nrs.bof or nrs.eof then exit for ' 不符合条件 跳出循环
			  %>
			  <TR>
			  	<TD align="center"><input name="d_id" type="checkbox" value="<%=nrs("d_id")%>" /></TD>
			  	<TD><%=nrs("strdomain")%></TD>
			  	<TD><%=nrs("proid")%></TD>
			  	<TD><%=showdomainstatus(nrs("regdate"),nrs("years"))%></TD>
                <TD><%
								If nrs("isreglocal") then
									Response.write "DNS管理"
								else
									Response.write "<font color=red>域名</font>"
								End If
						%></TD>
			  </TR>
              <%nrs.movenext
			 next
			 
			 if nrs.pagecount>0 then
			 %>
             <tr>
             	<td colspan="5" height="35" >
                  <%
				  if clng(page)>1 then
				  %>
                  <a href="javascript:void" onclick="gettable('<%=k%>',<%=g_id%>,<%=page-1%>)">上一页</a>
                  <%
				  end if
				  if clng(page)<clng(nrs.pagecount) then
				  %>
                  <a href="javascript:void" onclick="gettable('<%=k%>',<%=g_id%>,<%=page+1%>)">下一页</a>
                  <%
				  end if
				  %>
                
                </td>
             </tr>
             <%end if%>
			  </TABLE>

<%
else
	die "暂无数据"
end if
end sub
%>