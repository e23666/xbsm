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
					xinfo="��������"
				case "domainlist"
					xcmd="domain"
					xinfo="����"
				case "mailsitelist"
					xcmd="mail"
					xinfo="��ҵ�ʾ�"
				case "databaselist"
					xcmd="database"			
					xinfo="MSSQL���ݿ�"
				case "hostrental"
					xcmd="server"			
					xinfo="����IP����"
				case "allpwd"
					optCode="other" & vbcrlf & "sync" & vbcrlf & "entityname:allpassword" & vbcrlf & "." & vbcrlf
					synret=PCommand(optCode,Session("user_name"))
					if left(synret,3)="200" then
						noteInfo= noteInfo & "<font color=red> " &  "ȫ������ͬ���ɹ�" & "</font><BR>"
					else
						noteInfo=noteInfo & "ȫ������ͬ���ɹ�,������:" & synret & "<BR>"
					end if
					exit for
				case "syngift"
					optCode="other" & vbcrlf & "get" & vbcrlf & "entityname:gift" & vbcrlf & "." & vbcrlf
				
					synret=PCommand(optCode,Session("user_name"))
					 
					if left(synret,3)="200" then
						noteInfo= noteInfo & "<font color=red> " &  "ͬ��������������mssql���ݳɹ�" & "</font><BR>"
					    
					
					else
						noteInfo=noteInfo&" ͬ��������������mssql����ʧ��"
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
					noteInfo= noteInfo & "<font color=red>" & xinfo & "ͬ���ɹ�" & "</font><BR>"
				else
					noteInfo=noteInfo & xinfo & "ͬ���ɹ�,������:" & synret & "<BR>"
				end if
			end if
			Set AGS=nothing

		next
end if
%> 

<script language="javascript">
function dosub(f){
	if(confirm('ȷ���˲�����?')){
		document.getElementById('loadspan').style.display='';
		f.startSync.disabled=true;
		f.submit();
		return true;
	}
	return false;
}	
</script>



<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>ҵ����ͬ����</strong></td></tr> 
</table><TABLE WIDTH="100%" BORDER="0" CELLPADDING="8" CELLSPACING="0" CLASS="border"> 
<TR> <TD CLASS="tdbg">˵��:�����ܽ��Զ���ȡ�����ϼ��������д��ڵģ��������Ĵ���ƽ̨�в����ڵ��������ʾ֡�������ҵ�񣬲�ת�뵽<%=session("user_name")%>����     <a href="/SiteAdmin/admin/syncDomain.asp">ͬ���ϼ�����</a>   <a href="/SiteAdmin/mailmanager/syn.asp">ͬ���ϼ��ʾ�</a></TD></TR> 
</TABLE><br> 
<h1><font color=red><center>ҵ��ͬ�������Ѿ������뵽��Ӧ��Ʒ�б�ҳ��� ҵ��ͬ�� ��������ͬ��</center></font></h1>
<%
if noteInfo<>"" then
	Response.write "<hr><center><b>" & noteInfo & "</b></center><hr>"
end if
%><BR> <table width="100%" border="0" ALIGN="CENTER" cellpadding="4" cellspacing="0" class="border"> 
<form action="<%=Request("SCRIPT_NAME")%>" method="post" onSubmit="return confirm('ȷ��ͬ��?')"> 
<tr> <td WIDTH="33%" valign="top" bgcolor="#FFFFFF" class="tdbg"> 
<BR><BR> 
 </td><td WIDTH="67%" valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg"><input type="checkbox" name="synType" value="vhhostlist">
ͬ����������ҵ��<br>
 
<input type="checkbox" name="synType" value="domainlist">
ͬ������ҵ��<br>
<input type="checkbox" name="synType" value="mailsitelist">
ͬ����ҵ�ʾ�ҵ�� &nbsp;&nbsp;&nbsp;<a href="syncDomain.asp" style="color:red">��ͬ���������������˴�ͬ��</a><br>
 
<input type="checkbox" name="synType" value="databaselist">
ͬ��MSSQL���ݿ�ҵ��<br>
<input type="checkbox" name="synType" value="hostrental">
ͬ������IP����ҵ��<br>
<input type="checkbox" name="synType" value="allpwd">
ͬ������ҵ������<br>
<input type="checkbox" name="synType" value="syngift">
ͬ��MSSQL��Ʒ���<br>
</td></tr>

<tr>
  <td valign="top" bgcolor="#FFFFFF" class="tdbg">&nbsp;</td>
  <td valign="MIDDLE" bgcolor="#FFFFFF" class="tdbg">
  <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
  <input type="hidden" name="act" value="sub">
  <input type="button" name="startSync" value="��ʼͬ��" onClick="return dosub(this.form)">
  &nbsp;&nbsp;<a href="syscTime.asp">����ʱ��ͬ��</a></td>
</tr> 
</form></table>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
