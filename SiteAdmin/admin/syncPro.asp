<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" --> 
<%Check_Is_Master(1)%> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <HTML><HEAD> 
<TITLE></TITLE> <META http-equiv=Content-Type content="text/html; charset=gb2312"> 
<LINK href="../css/Admin_Style.css" rel=stylesheet> <body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'> 
<%
synType=Request.Form("synType")
act=trim(Request.Form("act"))

if act="sub" and synType<>"" then

		conn.open constr
		tbnames=split(synType,",")

		for each tbname in tbnames
			tbname=Trim(tbname)
			select case tbname
				case "vhhostlist"
					xcmd="vhost"
					xinfo="虚拟主机"
				case "domainlist"
					xcmd="domain"
					xinfo="域名"
				case "mailsitelist"
					xcmd="mail"
					xinfo="企业邮局"
				case "databaselist"
					xcmd="database"			
					xinfo="MSSQL数据库"
				case "hostrental"
					xcmd="server"			
					xinfo="独立IP主机"
				case "allpwd"
					optCode="other" & vbcrlf & "sync" & vbcrlf & "entityname:allpassword" & vbcrlf & "." & vbcrlf
					synret=PCommand(optCode,Session("user_name"))
					if left(synret,3)="200" then
						noteInfo= noteInfo & "<font color=red> " &  "全部密码同步成功" & "</font><BR>"
					else
						noteInfo=noteInfo & "全部密码同步成功,返回码:" & synret & "<BR>"
					end if
					exit for
				case "syngift"
					optCode="other" & vbcrlf & "get" & vbcrlf & "entityname:gift" & vbcrlf & "." & vbcrlf
				
					synret=PCommand(optCode,Session("user_name"))
					 
					if left(synret,3)="200" then
						noteInfo= noteInfo & "<font color=red> " &  "同步虚拟主机赠送mssql数据成功" & "</font><BR>"
					    
					
					else
						noteInfo=noteInfo&" 同步虚拟主机赠送mssql数据失败"
					end if


					exit for
				case else
					exit for
			end select
	      
	
			Set AGS=CreateObject("Scripting.Dictionary"):AGS.compareMode=1
			AGS.RemoveAll
			AGS.Add "tbname",tbname
			Call getFdlistAndExclude(AGS)
			ret=AGS("result")
			if ret=0 then
				fdlist=AGS("fdlist")
				exclude=AGS("exclude")				
				optCode="other" & vbcrlf & "sync" & vbcrlf & "entityname:" & xcmd & vbcrlf
				optCode=optCode & "fdlist:" & fdlist & vbcrlf
				optCode=optCode & "exclude:" & exclude & vbcrlf & "." & vbcrlf
	
				synret=PCommand(optCode,Session("user_name"))
				
				if left(synret,3)="200" then
					noteInfo= noteInfo & "<font color=red>" & xinfo & "同步成功" & "</font><BR>"
				else
					noteInfo=noteInfo & xinfo & "同步成功,返回码:" & synret & "<BR>"
				end if
			end if
			Set AGS=nothing

		next
end if
%> 

<script language="javascript">
function dosub(f){
	if(confirm('确定此操作吗?')){
		document.getElementById('loadspan').style.display='';
		f.startSync.disabled=true;
		f.submit();
		return true;
	}
	return false;
}	
</script>



<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>业　务　同　步</strong></td></tr> 
</table><TABLE WIDTH="100%" BORDER="0" CELLPADDING="8" CELLSPACING="0" CLASS="border"> 
<TR> <TD CLASS="tdbg">说明:本功能将自动读取您在上级服务商中存在的，但在您的代理平台中不存在的主机、邮局、域名等业务，并转入到<%=session("user_name")%>名下     <a href="/SiteAdmin/admin/syncDomain.asp">同步上级域名</a>   <a href="/SiteAdmin/mailmanager/syn.asp">同步上级邮局</a></TD></TR> 
</TABLE><br> 
<h1><font color=red><center>业务同步功能已经升级请到相应产品列表页点击 业务同步 进行数据同步</center></font></h1>
<%
if noteInfo<>"" then
	Response.write "<hr><center><b>" & noteInfo & "</b></center><hr>"
end if
%><BR> <table width="100%" border="0" ALIGN="CENTER" cellpadding="4" cellspacing="0" class="border"> 
<form action="<%=Request("SCRIPT_NAME")%>" method="post" onSubmit="return confirm('确定同步?')"> 
<tr> <td WIDTH="33%" valign="top" bgcolor="#FFFFFF" class="tdbg"> 
<BR><BR> 
 </td><td WIDTH="67%" valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg"><input type="checkbox" name="synType" value="vhhostlist">
同步虚拟主机业务<br>
 
<input type="checkbox" name="synType" value="domainlist">
同步域名业务<br>
<input type="checkbox" name="synType" value="mailsitelist">
同步企业邮局业务 &nbsp;&nbsp;&nbsp;<a href="syncDomain.asp" style="color:red">如同步域名报错请点击此处同步</a><br>
 
<input type="checkbox" name="synType" value="databaselist">
同步MSSQL数据库业务<br>
<input type="checkbox" name="synType" value="hostrental">
同步独立IP主机业务<br>
<input type="checkbox" name="synType" value="allpwd">
同步所有业务密码<br>
<input type="checkbox" name="synType" value="syngift">
同步MSSQL赠品相关<br>
</td></tr>

<tr>
  <td valign="top" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
  <td valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg">
  <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>正在执行,请稍候..<br></span>
  <input type="hidden" name="act" value="sub">
  <input type="button" name="startSync" value="开始同步" onClick="return dosub(this.form)">
  &nbsp;&nbsp;<a href="syscTime.asp">到期时间同步</a></td>
</tr> 
</form></table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
