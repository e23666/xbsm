<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%> <%Check_Is_Master(6)%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>我的记事本</strong></td>
  </tr>
</table>
<br>

  <table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
<tr> 
      <td valign="top" class="tdbg"><%
	conn.open constr
	u_id=session("u_sysid")

	if  Requesta("userinfo")<>"" then
		Sql="Update userdetail set u_memo='" & Requesta("userinfo") & "' where u_id=" & u_id
		conn.Execute(Sql)
		response.write "更新成功!"
	end if

		sqlstring="select * from UserDetail where u_id="&session("u_sysid")
		session("sqlcmd_VU")=sqlstring
	rs.open session("sqlcmd_VU") ,conn,3





	

%>
             </td>
    </tr>
<form name="form1" method="post" action="">
<tr> 
      <td valign="top" class="tdbg"> 
        
          
        <p align="center">提示：这里可以记录一些小东西，但数据大小不能超过2页。 
          <input type="submit" name="Submit" value="更新">
          </p>              </td>
    </tr>
    <tr>
      <td align="center" valign="top" class="tdbg" height="367"> 
        <textarea cols="100" rows="20" name="userinfo"><%=rs("u_memo")%></textarea>
      </td>
    </tr>
    <tr>
      <td align="center" valign="top" class="tdbg"><input type="submit" name="Submit2" value="更新"></td>
    </tr>
    </form>
</table>
    
	<%
rs.close
conn.close

%> <!--#include virtual="/config/bottom_superadmin.asp" -->
