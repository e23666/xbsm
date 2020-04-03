<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<%
synType=Request.Form("synType")
act=trim(Request.Form("act"))

if act="sub" and synType<>"" then
sysDay=cint(Requesta("sysDay"))
		conn.open constr
		
		'vh,dm,vm,svr,db(分别代表虚拟主机,域名,邮局,VPS,数据库)
	
		tbnames=split(synType,",")
		for each tbname in tbnames
			tbname=Trim(tbname)
			select case tbname
				case "vh"
					ptype="vh"
					xinfo="虚拟主机"
				case "dm"
					ptype="dm"
					xinfo="域名"
				case "vm"
					ptype="vm"
					xinfo="企业邮局"
				case "svr"
					ptype="svr"		
					xinfo="Vps"
				case "db"
					ptype="db"					
					xinfo="数据库"
				case else
				  noteInfo=noteInfo&"同步失败,错误码:501<BR>"
			end select
	
	
		Set AGS=CreateObject("Scripting.Dictionary"):AGS.compareMode=1
			AGS.RemoveAll
			AGS.Add "ptype",ptype
			AGS.Add "sysDay",sysDay
			
			call getProductName(AGS)
			ret=AGS("result")
			
 
			
			if ret=0 then
			
			    isSysok=True
				fdlist=split(AGS("fdlist"),"|$$|")
					for plup=0 to ubound(fdlist)
					 optCode=""
					     if trim(fdlist(plup))<>"" then	 
						 optCode="other" & vbcrlf & "get" & vbcrlf & "entityname:expdate" & vbcrlf
				        optCode=optCode & "ptype:" & ptype & vbcrlf
				        optCode=optCode & "pident:" & fdlist(plup) & vbcrlf & "." & vbcrlf
				   
				synret=PCommand(optCode,Session("user_name"))
		
	 
						if left(synret,3)="200" then
						
						isSyn=syn_server_time(ptype,synret)
								   if isSyn then
								
									noteInfo= noteInfo & "<font color=red>" & xinfo & "同步成功" & "</font><BR>"
								   else
								   noteInfo=noteInfo & xinfo & "同步失败,错误码:数据有误！<BR>"
								   end if
						   
						else
							noteInfo=noteInfo & xinfo & "同步失败,错误码:" & synret & "<BR>"
						end if
			 end if
                	'response.Write(optCode&"<hr>")
			    	next
					'response.End()

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
  <tr class='topbg'>
    <td height='30' align="center" ><strong>业　务　同　步</strong></td>
  </tr>
</table>
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="8" CELLSPACING="0" CLASS="border">
  <TR>
    <TD CLASS="tdbg">说明:本功能将自动读取您在上级服务商中存在的，但在您的代理平台中不存在的主机、邮局、域名等业务，并转入到<%=session("user_name")%>名下</TD>
  </TR>
</TABLE>
<br>
<%
if noteInfo<>"" then
	Response.write "<hr><center><b>" & noteInfo & "</b></center><hr>"
end if
%>
<BR>
<table width="100%" border="0" ALIGN="CENTER" cellpadding="4" cellspacing="0" class="border">
  <form action="<%=Request("SCRIPT_NAME")%>" method="post" onSubmit="return confirm('确定同步?')">
    <tr>
      <td WIDTH="33%" valign="top" bgcolor="#FFFFFF" class="tdbg"><BR>
        <BR></td>
      <td WIDTH="67%" valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg"><input type="checkbox" name="synType" value="vh">
        同步虚拟主机业务到期时间<br>
        <input type="checkbox" name="synType" value="dm">
        同步域名业务到期时间<br>
        <input type="checkbox" name="synType" value="vm">
        同步企业邮局业务到期时间<br>
        <input type="checkbox" name="synType" value="svr">
        同步独立主机业务到期时间<br>
        <input type="checkbox" name="synType" value="db">
        同步MSSQL数据库业务到期时间<br>
        同步时间：
        <select name="sysDay">
          <option value="30" selected>1个月</option>
          <option value="90">3个月</option>
          <option value="0">所有时间</option>
        </select></td>
    </tr>
    <tr>
      <td valign="top" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
      <td valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg"><span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>
        正在执行,请稍候..<br>
        </span>
        <input type="hidden" name="act" value="sub">
        <input type="button" name="startSync" value="开始同步" onClick="return dosub(this.form)">
        &nbsp;<a href="syncpro.asp">业务同步</a></td>
    </tr>
  </form>
</table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->