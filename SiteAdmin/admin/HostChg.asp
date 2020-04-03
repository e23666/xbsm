<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<%
module=Trim(Requesta("module"))
mname=Trim(Requesta("mname"))
clientname=Trim(Requesta("clientname"))
conn.open constr
'if mname="" then   url_return "需要转移业务为空",-1
mname=formattxt(mname)
function formattxt(txt)
	temp=split(txt,vbcrlf)
	formattxt=""
	for li=0 to ubound(temp)
		if trim(temp(li))<>"" then
			if formattxt="" then
				formattxt="'"&trim(temp(li))&"'"
			else
				formattxt=formattxt&",'"&trim(temp(li))&"'"
			end if
		end if
	next
end function
if module="mchgdomain" then 
		Sql="Select u_id,f_id from userdetail where u_name='" & clientname & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "未找到此用户",-1
		if Rs("f_id")>0 then url_return "VCP子用户，无法过户",-1
		u_id=Rs("u_id")
		Rs.close
		
		Sql="Select * from domainlist where strDomain in (" & mname &")"
		'die sql
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "没有此域名",-1
		do while not rs.eof
			d_id=Rs("d_id")
			o_id=Rs("userid")
			strDomain=rs("strDomain")
			call Add_Event_logs(session("user_name"),1,strDomain,"所有者变更到["&clientname&"]["&Rs("userid")&"]")
			
			Sql="Update orderlist set o_ownerid=" & u_id & " where o_typeid=" & d_id & " and o_producttype=3 and o_ownerid=" & o_id
			conn.Execute(Sql)
			Sql="Update domainlist set userid=" & u_id & " where d_id=" & d_id
			conn.Execute(Sql)
			rs.movenext
		loop
		Rs.close
		url_return "操作成功",-1
		
end if
if module="chgserver" then
		Sql="Select u_id,f_id from userdetail where u_name='" & clientname & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此服务器",-1
		if Rs("f_id")>0 then url_return "ＶＣＰ子用户，无法过户",-1
		u_id=Rs("u_id")
		Rs.close
		
		'Sql="update HostRental set u_name='" & clientname & "' where allocateip='" & mname & "'"
		Sql="select * from  HostRental  where allocateip in (" & mname & ")"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此服务器",-1
		do while not rs.eof
			allocateip=rs("allocateip")
			call Add_Event_logs(session("user_name"),3,allocateip,"所有者变更到["&clientname&"]["&u_id&"]")
			conn.execute("update HostRental set u_name='" & clientname & "' where allocateip='"&allocateip& "'")
			rs.movenext
		loop
		rs.close
		url_return "操作成功",-1
end if
if module="mchguser" then
		Sql="Select u_id,f_id from userdetail where u_name='" & clientname & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此用户",-1
		if Rs("f_id")>0 then url_return "ＶＣＰ子用户，无法过户",-1
		u_id=Rs("u_id")
		Rs.close
		
		Sql="select * from mailsitelist where     m_bindname  in (" & mname & ")"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此邮局",-1
			do while not rs.eof
			m_bindname=rs("m_bindname")
			Sql="update mailsitelist set m_ownerid=" & u_id & ",m_father=" & u_id & "  where m_bindname='" &m_bindname & "'"
			call Add_Event_logs(session("user_name"),2,m_bindname,"所有者变更到["&clientname&"]["&u_id&"]")
			conn.Execute(Sql)
			rs.movenext
		loop
		rs.close
		url_return "操作成功",-1
end if
if module="chgmssql" then
		Sql="Select u_id,f_id from userdetail where u_name='" & clientname & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此用户",-1
		if Rs("f_id")>0 then url_return "ＶＣＰ子用户，无法过户",-1
		u_id=Rs("u_id")
		Rs.close
		
		Sql="select * from databaselist where     dbname in (" & mname & ")"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此数据库",-1
		do while not rs.eof
			dbname=rs("dbname")
			Sql="update databaselist set dbu_id=" & u_id & ",dbf_id=" & u_id & "  where dbname='" & dbname & "'"
			call Add_Event_logs(session("user_name"),4,dbname,"所有者变更到["&clientname&"]["&u_id&"]")
			conn.Execute(Sql)
			rs.movenext
		loop
		rs.close
		url_return "操作成功",-1
end if
if module="chghostuser" then
		Sql="Select u_id,f_id from userdetail where u_name='" & clientname & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此用户",-1
		if Rs("f_id")>0 then url_return "VCP子用户，无法过户",-1
		u_id=Rs("u_id")
		rs.close
		Sql="select * from vhhostlist     where s_comment in ("& mname & ")"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "无此数据库",-1
		do while not rs.eof
			s_comment=rs("s_comment")
			Sql="update vhhostlist set s_ownerid=" & u_id & " where s_comment='" &s_comment & "'"
			call Add_Event_logs(session("user_name"),0,s_comment,"所有者变更到["&clientname&"]["&u_id&"]")
			conn.Execute(Sql)
		rs.movenext
		loop
		rs.close
		url_return "操作成功",-1
end if
if module="movemoney" then
	p_u_name=requesta("p_u_name")
	t_u_name=requesta("t_u_name")
	tomoney=requesta("tomoney")
	str=trim(requesta("str"))
	
	lookstr=""
	Sql="Select u_id,f_id,u_usemoney from userdetail where u_name='" & p_u_name & "'"
  	 Rs.open Sql,conn,1,1
	 if not rs.eof then
	 	p_u_id=rs("u_id")
	 	if ccur(rs("u_usemoney")) < ccur(tomoney) then url_return "源用户没有足够的金额",-1
	 	if Rs("f_id")>0 then
			lookstr=lookstr&"源用户."
		end if
	 else
	 	url_return "源用户不存在",-1
	 end if
	 rs.close
	Sql="Select u_id,f_id,u_usemoney from userdetail where u_name='" & t_u_name & "'"
	rs.open sql,conn,1,1
	if not rs.eof then
		t_u_id=rs("u_id")
		if Rs("f_id")>0 then
			lookstr=lookstr& "目标用户."
		end if
	else
	 	url_return "目标用户不存在",-1
	end if
	rs.close
	if str="ok" then
		conn.execute "update Userdetail set u_usemoney = u_usemoney  - "& tomoney &" , u_checkmoney = u_checkmoney- "& tomoney &"  where u_name = '"& p_u_name &"'"
	   '显示余额功能
		u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&p_u_name&"'")(0)
		conn.execute "insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput,c_type,o_id,p_proid,u_Balance) values ("& p_u_id &",-"& tomoney &",-"& tomoney &" ,0, '"& session("user_name") &"-"& date() &"' , '转入"& t_u_name &"', '"&now()&"','"&now()&"' ,8,0,'',"&u_Balance&")"
		
		conn.execute "update Userdetail set u_usemoney = u_usemoney  + "& tomoney &" , u_checkmoney = u_checkmoney+ "& tomoney &"  where u_name = '"& t_u_name &"'"
		'显示余额功能
		t_u_Balance=conn.execute("select u_usemoney from Userdetail  where u_name = '"&t_u_name&"'")(0)
		conn.execute "insert into countlist (u_id,u_moneysum,u_in,u_out, u_countid , c_memo ,c_date ,c_dateinput,c_type,o_id,p_proid,u_Balance) values ("& t_u_id &",-"& tomoney &",0,-"& tomoney &" , '"& session("user_name") &"-"& date() &"' , '"& p_u_name &"转来', '"&now()&"','"&now()&"' ,8,0,'',"&t_u_Balance&")"

		 call Add_Event_logs(session("user_name"),5,"["&p_u_name&"]===>["&t_u_name&"]","用户金额转移["&tomoney&"]元")
		Alert_Redirect "操作成功",request("script_name")
	else
	 if lookstr<>"" then
			response.write "<script language=javascript>if(confirm('"& lookstr &"是vcp子用户')){location.href='"&request("script_name")&"?str=ok&module="& module &"&p_u_name="& p_u_name &"&t_u_name="& t_u_name &"&tomoney="& tomoney &"'}else{history.back();}</script>"
	  else
	  		response.write "<script language=javascript>location.href='"&request("script_name")&"?str=ok&module="& module &"&p_u_name="& p_u_name &"&t_u_name="& t_u_name &"&tomoney="& tomoney &"'</script>"
	 end if
	end if
end if
%>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>业　务　过　户</strong></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>虚拟主机转换下属客户：</b>(<font color="red">一行一个业务名称</font>)<br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="chghostuser">
        主机名:<br>
        <textarea rows="3" cols="60"  name="mname" ></textarea> 
        → 客户名:
        <input type=text name="clientname" size =10>
        <input type=submit name="sub" value="主机转换"></td>
    </tr>
  </form>
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>邮局转换下属客户：</b><br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="mchguser">
        邮局名:<br>
         <textarea rows="3" cols="60"  name="mname" ></textarea>
        → 客户名:
        <input type=text name="clientname" size =10>
        <input type=submit name="subs" value="邮局转换"></td>
    </tr>
  </form>
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>MSSQL数据库转换下属客户：</b><br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="chgmssql">
        mssql数据库名:<br>
         <textarea rows="3" cols="60"  name="mname" ></textarea>
        → 客户名:
        <input type=text name="clientname" size =10>
        <input type=submit name="subs" value="MSSQL数据库转换"></td>
    </tr>
  </form>
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>域名转换下属客户：</b><br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="mchgdomain">
        域名:<br>
         <textarea rows="3" cols="60" name="mname"></textarea>
        → 客户名:
        <input type=text name="clientname" size =10>
        <input type=submit name="subs" value="域名转换"></td>
    </tr>
  </form>
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>独立IP主机转换下属客户：</b><br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="chgserver">
        IP:<br>
        <textarea rows="3" cols="60"  name="mname" ></textarea>
        → 客户名:
        <input type=text name="clientname" size =10>
        <input type=submit name="subs" value="主机转换"></td>
    </tr>
  </form>
  <form action="<%=Request("SCRIPT_NAME")%>" method="post">
    <tr>
      <td width="537" height="1" valign="top" bgcolor="#FFFFFF" class="tdbg"><br>
        <b>用户金额转移：</b><br></td>
    </tr>
    <tr>
      <td width="537" height="10" valign="top" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" name="module" value="movemoney">
        源账户:
        <input type=text name="p_u_name" size =10>
        → 目标账户:
        <input type=text name="t_u_name" size =10>
        转移金额:
        <input type=text name="tomoney" size =10>
        <input type=submit name="subs" value="金额转移"></td>
    </tr>
    <tr>
      <td height="10" valign="top" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
    </tr>
  </form>
</table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->