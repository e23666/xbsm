<!--#include virtual="/config/config.asp" --> 
<!--#include virtual="/config/ParseCommand.asp" --> <%Check_Is_Master(1)%> <%
conn.open constr
Server.ScriptTimeOut=99999

startSync=Request.Form("startSync")

if startSync<>"" then


	if Request.Form("pricelist")="sync" then
		fdlist=getTableFdlist("pricelist","p_sysid")
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:tablecontent" & vbcrlf
		optCode=optCode & "tbname:pricelist" & vbcrlf
		if Request.Form("xupdate")<>"" then
			optCode=optCode & "update:true" & vbcrlf
		else
			optCode=optCode & "update:false" & vbcrlf
		end if
		optCode=optCode & "fieldlist:" & fdlist & vbcrlf & "." & vbcrlf
		
		retCode=Pcommand(optCode,Session("user_name"))
		
		if left(retcode,3)="200" then
			noteInfo="<font color=red>同步产品价格成功!</font>"
		else
			noteInfo="同步产品价格失败!"
		end if
	end if
	
	
	if Request.Form("vps_jfinfo")="sync" then
	
	'清理sql
	conn.execute("delete from cache_app")
	application("server_diy_config")=""
	application("server_diy_config_sj")=""
		     if Syn_vpsjf() then
			 	noteInfo=noteInfo & "<BR>" & "<font color=red>同步vps/云主机机房信息成功!</font>"
			 else
			 noteInfo=noteInfo & "<BR>" & "同步vps/云主机机房信息失败!"
			 end if

	    end if
	
	if Request.Form("productlist")="sync" then
		fdlist=getTableFdlist("productlist","p_id")
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:tablecontent" & vbcrlf
		optCode=optCode & "tbname:productlist" & vbcrlf
		if Request.Form("xupdate")<>"" then
			optCode=optCode & "update:true" & vbcrlf
		else
			optCode=optCode & "update:false" & vbcrlf
		end if
		optCode=optCode & "fieldlist:" & fdlist & vbcrlf & "." & vbcrlf
		
		retCode=Pcommand(optCode,Session("user_name"))

		if left(retcode,3)="200" then
			noteInfo=noteInfo & "<BR>" & "<font color=red>同步产品列表成功!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "同步产品列表失败!"
		end if
	end if
	if requesta("vps_price")="sync" then
		fdlist=getTableFdlist("serverroomlist","v_sysid")
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:tablecontent" & vbcrlf
		optCode=optCode & "tbname:serverroomlist" & vbcrlf
		'if Request.Form("xupdate")<>"" then
			'optCode=optCode & "update:true" & vbcrlf
		'else
			optCode=optCode & "update:false" & vbcrlf
		'end if
		optCode=optCode & "fieldlist:" & fdlist & vbcrlf & "." & vbcrlf		
		retCode=Pcommand(optCode,Session("user_name"))	
			
		if left(retcode,3)="200" then
			noteInfo=noteInfo & "<BR>" & "<font color=red>同步关联数据成功!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "同步关联数据失败!"
		end if
	
	
		fdlist=getTableFdlist("vps_price","v_sysid")
		optCode="other" & vbcrlf
		optCode=optCode & "get" & vbcrlf
		optCode=optCode & "entityname:tablecontent" & vbcrlf
		optCode=optCode & "tbname:vps_price" & vbcrlf
		if Request.Form("xupdate")<>"" then
			optCode=optCode & "update:true" & vbcrlf
		else
			optCode=optCode & "update:false" & vbcrlf
		end if
		optCode=optCode & "fieldlist:" & fdlist & vbcrlf & "." & vbcrlf		
		 
		retCode=Pcommand(optCode,Session("user_name"))		
		if left(retcode,3)="200" then
			noteInfo=noteInfo & "<BR>" & "<font color=red>同步vps/云主机产品列表成功!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "同步vps/云主机产品列表失败!"
		end if
		
		
	end if
end if

%> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <HTML><HEAD><TITLE></TITLE> 
<META http-equiv=Content-Type content="text/html; charset=gb2312"> <LINK href="../css/Admin_Style.css" rel=stylesheet> <body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'> 
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>产品或价格同步</strong></td></tr> 
</table><TABLE WIDTH='100%' BORDER='0' ALIGN='center' CELLPADDING='2' CELLSPACING='1' CLASS='border'> 
<TR CLASS='tdbg'> <TD WIDTH='91' HEIGHT='30' ALIGN="center" ><STRONG>管理导航：</STRONG></TD><TD WIDTH="771"><A HREF="addPro.asp">新增产品</A> 
| <A HREF="default.asp?module=search&p_type=1">空间</A> | <A HREF="default.asp?module=search&p_type=2">邮局</A> 
| <A HREF="default.asp?module=search&p_type=3">域名</A> | <A HREF="default.asp?module=search&p_type=4">网站推广</A> 
|<A HREF="default.asp?module=search&p_type=7"> 数据库</A> |<A HREF="syncPro.asp">同步产品或价格</A></TD>
</TR> </TABLE><BR><table width="100%" border="0" align="center"> 
<tr> <td>提示：系统将自动读取上级服务商产品或价格库中的数据，并替换掉您代理平台中的产品或价格。您新增加的但上级服务商不存在的产品不受影响。<BR> 
</td></tr> </table><%
if noteInfo<>"" then
	Response.write "<HR><center><B>==同步结果==</B><BR>" & noteInfo & "</center><HR>"
end if
%> <br> <table width="100%" border="0" cellspacing="0" cellpadding="3"> <tr> <td align="center"><FORM NAME="form1" METHOD="post" ACTION="<%=Request.ServerVariables("SCRIPT_NAME")%>" onSubmit="return confirm('您确定同步数据吗?')"><INPUT TYPE="checkbox" NAME="productlist" VALUE="sync" CHECKED>同步产品列表 
<INPUT TYPE="checkbox" NAME="pricelist" VALUE="sync">同步价格列表
<INPUT TYPE="checkbox" NAME="vps_price" VALUE="sync">同步VPS/云主机产品及价格
<INPUT TYPE="checkbox" NAME="vps_jfinfo" VALUE="sync">
同步vps及云主机机房信息
<BR>
<BR>
<input name="xupdate" type="checkbox" id="xupdate" value="true">
仅同步上级服务商的新产品与价格
<INPUT TYPE="submit" NAME="startSync" VALUE="确定同步"></FORM></td></tr> 
</table><HR> 
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
