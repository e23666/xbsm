<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

<%
response.Charset="GB2312"
response.Expires=-1
conn.open constr
u_sysid = session("u_sysid")
action=requesta("act")
 
if action="checkzr" then

die Domaintransferinfo(u_sysid)


end if



function chgretcode(str)
	str=lcase(str) : chgretcode=str
	if instr(str,"does not exist")>0 then chgretcode="��������δע�������"
	if instr(str,"authorization")>0 then chgretcode="ת���������"
	if instr(str,"status prohibits")>0 then chgretcode="������״̬������"
	if instr(str,"syntax error")>0 then chgretcode="ϵͳ��������ϵ����Ա"
	if instr(str,"pending transfer")>0 then chgretcode="�Ѿ��ڴ����������ظ��ύ"
end function

function zrstate(st)
	select case st
		case 0 : s="���ύ������"
		case 1 : s="������"
		case 2 : s="�����"
		case 5 : s="�Ѿ�����"
		case 6 : s="����յ�"
		case 7 : s="�ܾ�"
		case 8 : s="���û�ȷ��"
		case 9 : s="�Զ�������"
		case 11: s="����ת��"
		case 12: s="ת�������ѷ�"
		case 14: s="ת��ʧ��"
		case 15: s="ת����"
		case 16: s="����ת��"
		case else : s="δ֪"&st
	end select
	zrstate = s
end function

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-����ת���ѯ</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script language="javascript" src="/jscripts/check.js"></script>
<script language="javascript" src="/jscripts/facebox.js"></script>
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" />
<script language="javascript">
function showzr(did){
	var url="zhuanru.asp?act=show&did="+did;
	$.facebox({ajax:url});
}</script>
</HEAD>
<body id="thrColEls">
<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">����ת���ѯ</div>
          <div class="table_out">  
       <div id="checkdname"></div>
      <table   bordercolor="#FFFFFF" cellpadding="0" cellspacing="0" id="AutoNumber3" style="border-collapse: collapse" width="100%" >
  <tr>
    <td height="175" width="99%" valign="top"> <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#ffffff" class="border managetable">
       
          <tr class='titletr'>
            <td width="40" height="30" align="center" ><strong>���</strong></td>
            <td width="200" align="center" ><strong>����</strong></td>
            <td width="150" align="center" ><strong>����״̬</strong></td>
          </tr>
          <%
		  ischeck=false
	cmdinfo="domainname" & vbcrlf & _
		"trans" & vbcrlf & _
		"entityname:get_state" & vbcrlf & _
		"domain:" & domains & vbcrlf & _
		"." & vbcrlf
	retCode=connectToUp(cmdinfo)
    if isdbsql then
	sql="select top 20 * from domainlist where userid=" & u_sysid & " and isnull(tran_state,0)>0 order by tran_state desc"
	else
	sql="select top 20 * from domainlist where userid=" & u_sysid & " and iif( isnull(tran_state),0,tran_state)>0 order by tran_state desc"
	end if
	rs.open sql,conn,1,1
cur=1
	while not rs.eof
		tdcolor="#ffffff"
		if cur mod 2 =0 then tdcolor="#EAF5FC"
		cur=cur+1
		if clng(rs("tran_state"))<>5 then
		ischeck=true
		end if
%>
<tr bgcolor="<%=tdcolor%>">
            <td height="25" align="center"><%=cur%></td>
            <td height="25" align="center"><%=rs("strDomain")%> </td>
            <td height="25" align="center"><%= zrstate( rs("tran_state") )%></td></tr>
          <%
		
		rs.movenext
		
	wend
	rs.close
%> 
          <tr>
            <td height="30" colspan="5">ת��ɹ�����������������б��в鿴</td>
          </tr>
    
    </table>
       
    </td>
  </tr>
</table>
             </form>
<%if ischeck then%>
<script>
 window.onload=function(){
    $("#checkdname").html("����ת��״̬��顾�����..��")
	 url="/manager/domainmanager/zhuanru.asp?act=checkzr&r="+Math.random();
	 $.get(url,function(t){
		  if(t=="True"){
			  $("#checkdname").html("����ת��״̬��顾��ɡ�����ˢ�º�鿴״̬")
			 }
		 })
 }
 
</script>
<%end if%>
            
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--#include virtual="/manager/bottom.asp" --> 
</div>
</body>
</html>
