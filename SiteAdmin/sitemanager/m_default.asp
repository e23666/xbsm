<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)%>
<%
function getUname(Byval uid)
	set lrs=conn.Execute("select u_name from userdetail where u_id=" & uid )
	if not lrs.eof then
		getUname=lrs(0)
	else
		getUname=""
	end if
	lrs.close:set lrs=nothing
end function

function doUserSyn_vhost(byval p_name,BYval ownerid)
			syn_table="vhhostlist"
			sysfd="s_sysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
			syn_uname=getUname(ownerid)
			commandstr= "other" & vbcrlf & _
						"sync" & vbcrlf & _
						"entityname:record" & vbcrlf & _
						"tbname:" & syn_table & vbcrlf & _
						"fdlist:" & syn_fd & vbcrlf & _
						"ident:" & p_name & vbcrlf & _
						"." & vbcrlf
						'die commandstr
			doUserSyn_vhost=pcommand(commandstr,syn_uname)
end function

conn.open constr
hostid=requesta("hostid")
ACT=requesta("ACT")
showpwd=""
if ACT="FlUSHPASS" then
	stFtpName=requesta("FtpName")
	stUser=requesta("User")
	retstr=GetOperationPassWord(stFtpName,"host",stUser)
	if left(retstr,3)="200" then
	 	showpwd=getReturn(retstr,"ftppassword")
		Response.Write("<script>alert(""主机密码更新成功！"")</script>")
	else
		Response.Write("<script>alert(""主机密码更新失败！"")</script>")
	end if
elseif ACT="DEL" then
	Check_Is_Master(1)
	stFtpName=requesta("FtpName")
	sql="delete from vhhostlist where s_comment='"&stFtpName&"'"
	conn.execute(sql)
	 call Add_Event_logs(session("user_name"),0,stFtpName,"删除虚拟主机操作")
	Alert_Redirect "主机删除成功！","default.asp"
elseif ACT="SYNC" then
	if not regTest(hostid,"^[\d\,]+$") then url_return "错误的ID",-1

	sql="select s_comment,s_ownerid from vhhostlist where s_sysid in(" & hostid & ")"
	rs.open sql,conn,1,1
	while not rs.eof
		s_comment=rs("s_comment")
		s_ownerid=rs("s_ownerid")
		if s_comment<>"" then
			x_ret=doUserSyn_vhost(s_comment,s_ownerid)	
			if left(x_ret,3)<>"200" then
				errstr=errstr & "[" & s_comment & "]同步失败" & x_ret & ";\n" & s_ownerid
			end if
		end if
		rs.movenext
	wend
	rs.close
	if errstr="" then errstr = "同步成功"
	url_return errstr,-1
end if

sql="select * from vhhostlist where s_sysid="&hostid
rs.open sql,conn,1,3
if rs.eof or rs.bof then
	rs.close
	conn.close
	url_return "此虚拟主机不存在",-1
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {color: #FF0000}
.STYLE5 {
	color: #0099FF;
	font-weight: bold;
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>虚 拟 主 机 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">虚拟主机管理</a> | <a href="addnewsite.asp">手工添加虚拟主机</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
  </tr>
</table>
      <br />

  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<form name="form1" method="post" action="m_default.asp?hostid=<%=hostid%>">
    <tr> 
      <td width="29%" align="right" class="tdbg">&nbsp;</td>
      <td width="21%" class="tdbg">&nbsp;</td>
      <td width="15%" class="tdbg">&nbsp;</td>
      <td width="35%" class="tdbg">
<%
	if ACT="Modi" then
		BuyDate=requesta("BuyDate")
		if not isdate(BuyDate) then
			url_return "主机开通时间格式错误",-1
		end if
		ExDate=requesta("ExDate")
		if not isdate(ExDate) then
			url_return "主机到期时间格式错误",-1
		end if
		BuyYears=requesta("BuyYears")
		P_type=requesta("P_type")
		s_memo=requesta("Remark")
		s_other_ip=requesta("s_other_ip")
		
		if isdbsql then
		sql="update vhhostlist set s_buydate='"&BuyDate&"',s_expiredate='"&ExDate&"',s_year="&BuyYears&",s_productid='"&P_type&"',s_remarks='"&s_memo&"',s_other_ip='"&s_other_ip&"' where s_sysid="&hostid
		else
		sql="update vhhostlist set s_buydate=#"&BuyDate&"#,s_expiredate=#"&ExDate&"#,s_year="&BuyYears&",s_productid='"&P_type&"',s_remarks='"&s_memo&"',s_other_ip='"&s_other_ip&"' where s_sysid="&hostid
		end if
		conn.execute(sql)
		response.Write("<font class='STYLE4'>虚拟主机信息已经修改成功！</font>")
	end if
%>      </td>
    </tr>
	
    <tr>
      <td height="30" align="right" class="tdbg">FTP用户名：</td>
      <td height="30" class="tdbg"><%=rs("s_comment")%>&nbsp;&nbsp;<a href="ftp://<%=rs("s_comment")&":"&rs("s_ftppassword")&"@"&rs("s_serverIP")%>/" target="_blank"><span class="STYLE5">[上传]</span></a></td>
      <td align="right" class="tdbg">开通时间：</td>
      <td class="tdbg">
        <input type="text" name="BuyDate" id="BuyDate" value="<%=rs("s_buydate")%>">      </td>
    </tr>
    <tr> 
      <td align="right" valign="middle" class="tdbg">FTP密码：</td>
      <td valign="middle" class="tdbg"><table border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td nowrap><%=showpwd%></td>
            <td><a href="m_default.asp?ACT=FlUSHPASS&FtpName=<%=rs("s_comment")%>&User=<%=GetUserName(rs("s_Ownerid"))%>&hostid=<%=hostid%>"><img src="/images/pic_03.gif" alt="更新密码" border="0"></a></td>
          </tr>
        </table></td>
      <td align="right" valign="middle" class="tdbg">到期时间：</td>
      <td valign="middle" class="tdbg"><input type="text" name="ExDate" id="ExDate" value="<%=rs("s_expiredate")%>">      </td>
    </tr>
    <tr> 
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">年限：</td>
      <td class="tdbg"><select name="BuyYears" id="BuyYears">
      <%for i=1 to 10%>
        <option value="<%=i%>"<%if rs("s_year")=i then%> selected<%end if%>><%=i%></option>
       <%next%>
      </select>      </td>
    </tr>
    <tr>
      <td align="right" class="tdbg">主机管理：</td>
      <td class="tdbg"><a href="/manager/jump.asp?t=vhost&n=<%=rs("s_comment")%>" target="_blank"><span class="STYLE4">进入并且管理此虚拟主机</span></a></td>
      <td align="right" class="tdbg">虚拟主机型号：</td>
      <td class="tdbg"><select name="P_type" id="P_type" style="width:250px">
      <%
	  sql1="select * from productlist where p_type=1"
	  rs1.open sql1,conn,1,3
	  if not rs1.eof then
	  do while not rs1.eof
	  %>
        <option value="<%=rs1("p_proid")%>"<%if lcase(rs1("p_proid"))=lcase(rs("s_productid")) then%> selected<%end if%>><%=rs1("p_proid")%></option>
       <%
	   rs1.movenext
	   loop
	   end if
	   rs1.close
	   %>
      </select></td>
    </tr>


    <tr>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">提示:如果进入高级管理提示密码错误，请先同步密码<a href="m_default.asp?ACT=FlUSHPASS&FtpName=<%=rs("s_comment")%>&User=<%=GetUserName(rs("s_Ownerid"))%>&hostid=<%=hostid%>"><img src="/images/pic_03.gif" alt="更新密码" border="0"></a></td>
      <td align="right" class="tdbg">备注：</td>
      <td class="tdbg"><textarea name="Remark" cols="42" rows="4" id="Remark"><%=rs("s_remarks")%></textarea></td>
    </tr>
    <tr>
      <td align="right" class="tdbg">删除主机：</td>
      <td class="tdbg"><table border="0" cellspacing="0" cellpadding="3">
        <tr>
          <td nowrap><a href=# onClick="javascript:if(confirm('确定删除吗?'))location.href='m_default.asp?ACT=DEL&FtpName=<%=rs("s_comment")%>&Domainid=<%=Domainid%>'"><span class="STYLE4">删除该主机</span></a></td>
          <td><a href=# onClick="javascript:if(confirm('确定删除吗?'))location.href='m_default.asp?ACT=DEL&FtpName=<%=rs("s_comment")%>&Domainid=<%=Domainid%>'"><img src="/images/20070730192531213.gif" alt="删除" border="0"></a></td>
        </tr>
      </table></td>
	  <td align="right" class="tdbg">独立IP:</td>
      <td class="tdbg"><input type="text" name="s_other_ip"  id="s_other_ip"  value="<%=rs("s_other_ip")%>"/></td>

     
    </tr>
    <tr>
      <td align="right" class="tdbg">数据同步：</td>
      <td class="tdbg"><input type="button" name="button2" id="button2" value="同步数据" onClick="this.form.ACT.value='SYNC';this.form.submit();"></td>
       <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg"><input type="submit" name="button" id="button" value="　仅修改数据库　">
        <input name="ACT" type="hidden" id="ACT" value="Modi"></td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
    <tr>
      <td class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
      <td align="right" class="tdbg">&nbsp;</td>
      <td class="tdbg">&nbsp;</td>
    </tr>
  </form>
  </table>
<p>&nbsp;</p>
</body>
</html>
<%conn.close%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
