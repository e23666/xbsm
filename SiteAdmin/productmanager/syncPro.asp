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
			noteInfo="<font color=red>ͬ����Ʒ�۸�ɹ�!</font>"
		else
			noteInfo="ͬ����Ʒ�۸�ʧ��!"
		end if
	end if
	
	
	if Request.Form("vps_jfinfo")="sync" then
	
	'����sql
	conn.execute("delete from cache_app")
	application("server_diy_config")=""
	application("server_diy_config_sj")=""
		     if Syn_vpsjf() then
			 	noteInfo=noteInfo & "<BR>" & "<font color=red>ͬ��vps/������������Ϣ�ɹ�!</font>"
			 else
			 noteInfo=noteInfo & "<BR>" & "ͬ��vps/������������Ϣʧ��!"
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
			noteInfo=noteInfo & "<BR>" & "<font color=red>ͬ����Ʒ�б�ɹ�!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "ͬ����Ʒ�б�ʧ��!"
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
			noteInfo=noteInfo & "<BR>" & "<font color=red>ͬ���������ݳɹ�!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "ͬ����������ʧ��!"
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
			noteInfo=noteInfo & "<BR>" & "<font color=red>ͬ��vps/��������Ʒ�б�ɹ�!</font>"
		else
			noteInfo=noteInfo & "<BR>" & "ͬ��vps/��������Ʒ�б�ʧ��!"
		end if
		
		
	end if
end if

%> <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <HTML><HEAD><TITLE></TITLE> 
<META http-equiv=Content-Type content="text/html; charset=gb2312"> <LINK href="../css/Admin_Style.css" rel=stylesheet> <body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'> 
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'> 
<tr class='topbg'> <td height='30' align="center" ><strong>��Ʒ��۸�ͬ��</strong></td></tr> 
</table><TABLE WIDTH='100%' BORDER='0' ALIGN='center' CELLPADDING='2' CELLSPACING='1' CLASS='border'> 
<TR CLASS='tdbg'> <TD WIDTH='91' HEIGHT='30' ALIGN="center" ><STRONG>��������</STRONG></TD><TD WIDTH="771"><A HREF="addPro.asp">������Ʒ</A> 
| <A HREF="default.asp?module=search&p_type=1">�ռ�</A> | <A HREF="default.asp?module=search&p_type=2">�ʾ�</A> 
| <A HREF="default.asp?module=search&p_type=3">����</A> | <A HREF="default.asp?module=search&p_type=4">��վ�ƹ�</A> 
|<A HREF="default.asp?module=search&p_type=7"> ���ݿ�</A> |<A HREF="syncPro.asp">ͬ����Ʒ��۸�</A></TD>
</TR> </TABLE><BR><table width="100%" border="0" align="center"> 
<tr> <td>��ʾ��ϵͳ���Զ���ȡ�ϼ������̲�Ʒ��۸���е����ݣ����滻��������ƽ̨�еĲ�Ʒ��۸��������ӵĵ��ϼ������̲����ڵĲ�Ʒ����Ӱ�졣<BR> 
</td></tr> </table><%
if noteInfo<>"" then
	Response.write "<HR><center><B>==ͬ�����==</B><BR>" & noteInfo & "</center><HR>"
end if
%> <br> <table width="100%" border="0" cellspacing="0" cellpadding="3"> <tr> <td align="center"><FORM NAME="form1" METHOD="post" ACTION="<%=Request.ServerVariables("SCRIPT_NAME")%>" onSubmit="return confirm('��ȷ��ͬ��������?')"><INPUT TYPE="checkbox" NAME="productlist" VALUE="sync" CHECKED>ͬ����Ʒ�б� 
<INPUT TYPE="checkbox" NAME="pricelist" VALUE="sync">ͬ���۸��б�
<INPUT TYPE="checkbox" NAME="vps_price" VALUE="sync">ͬ��VPS/��������Ʒ���۸�
<INPUT TYPE="checkbox" NAME="vps_jfinfo" VALUE="sync">
ͬ��vps��������������Ϣ
<BR>
<BR>
<input name="xupdate" type="checkbox" id="xupdate" value="true">
��ͬ���ϼ������̵��²�Ʒ��۸�
<INPUT TYPE="submit" NAME="startSync" VALUE="ȷ��ͬ��"></FORM></td></tr> 
</table><HR> 
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
