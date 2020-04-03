<!--#include virtual="/config/config.asp"-->
<%Check_Is_Master(6)%>
<%
UserChoice=Request("UserChoice")
act=requesta("act")
if act="sub" then
	if UserChoice<>"" then 
		conn.open constr
		for each ucitem in split(UserChoice,",")
			select case trim(ucitem)
				case "mail"
					
					Sql="Update mailsitelist set m_serverip='" & Request("NewIP") & "' where m_serverip='" & Request("OldIP") & "'"
				case "vhost"
					
					Sql="Update vhhostlist set s_serverip='" & Request("NewIP") & "' where s_serverip='" & Request("OldIP") & "'"
			end select
			
				conn.Execute(Sql)
		next
			conn.close
			Response.write "<script language=javascript>alert('命令运行成功');history.back();</script>"
			Response.end
	else
		url_return "请选择您需要修改的IP类型",-1
	end if
end if
%>
<html>
<head>
<title>ＩＰ批量修改</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="/admin/config/Admin_Style.css" rel=stylesheet>
</head>
<script language=javascript>
function subform(form,choice){
	if (form.OldIP.value==""||form.NewIP.value=="")
	{
	alert("必须填写源ＩＰ与目标ＩＰ");return false;
	}
	if (confirm("您确认"+choice.value+"?,原IP:"+form.OldIP.value+"，目标IP:"+form.NewIP.value))
	{
				var check = function(v)
				{
					try
					{
						return (v <= 255 && v >= 0);
					}
					catch(x)
					{
						return false;
					}
				}
				
				var myArray = new Array(form.OldIP.value,form.NewIP.value); 
				for(var i=0;i<=1;i++)
				{
					
						var re = myArray[i].split(".")
						if(re.length==4)
						{
							 if (check(re[0]) && check(re[1]) && check(re[2]) && check(re[3]))
							 {
									form.UserChoice.value=choice.name;
									form.submit();
							 }
							 else
							 {
								alert('ip不合法')
								return false
							 }
						}
						else
						{
						  alert('ip不合法')
						  return false
						}
			
			  }
	
	}
	else
	{
	return false;
	}
}
</script>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>批量修改IP</strong></td>
  </tr>
</table>
<table width="509" height="109" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#0066cc" class="border">
  <form name="form1" method="post" action="<%=Request("SCRIPT_NAME")%>">
    <tr align="center">
      <td height="21" colspan="2" bgcolor="#CCCCCC">批量ＩＰ地址修改，只影响数据库记录
      </td>
    </tr>
    <tr>
      <td bgcolor="#efefef">原ＩＰ：
        <input type="text" name="OldIP" size="15" maxlength="20">
      </td>
      <td bgcolor="#efefef">新ＩＰ:
        <input type="text" name="NewIP" size="15" maxlength="20">
      </td>
      
    </tr>
    
    <tr>
      <td colspan="2" nowrap bgcolor="#efefef">
      <input type="checkbox" value="mail" name="UserChoice">企业邮局IP  &nbsp;&nbsp;  <input type="checkbox" value="vhost" name="UserChoice">虚拟主机IP
      </td>
    </tr>
    <tr>
      <td  colspan="2" align="center" bgcolor="#efefef">
      <input type="button" name="a" value=" 确定修改 " onClick="subform(this.form,this);">
      <input type="hidden" name="act" value="sub">
      </td>
    </tr>
  </form>
</table>

</body>
</html>
