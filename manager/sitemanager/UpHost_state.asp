<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/action.asp" -->
<!--#include virtual="/config/uphost_class.asp" -->
<%
response.Charset="gb2312"
conn.open constr
hostID=Trim(Requesta("HostID"))		'���β���������ID
act=trim(requesta("act"))
set up=new uphost_class:up.u_sysid=session("u_sysid"):up.setHostid=hostid

if act="reupdate" then
	commandstr="vhost"& vbcrlf & _
			   "set"& vbcrlf & _
			   "entityname:reupvhost" & vbcrlf & _
			   "siteName:" & up.s_comment & vbcrlf & _
			   "." & vbcrlf	   
	resultstr=pcommand(commandstr,up.u_name)	
	set up=nothing	
	if left(resultstr,3)="200" then
		gowithwin "uphost.asp?hostid="&hostid
	else
		alert_redirect resultstr,requesta("script_name")&"?hostid="&hostid
	end if
	response.end
end if
if up.istostatepage and instr(requesta("script_name"),"uphost_state.asp")=0 then 
	gowithwin "uphost_state.asp?hostid="&hostid
elseif not up.istostatepage and instr(requesta("script_name"),"uphost.asp")=0 then
	gowithwin "uphost.asp?hostid="&hostid	 
end if
call doUserSyn("vhost",up.s_comment)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-������������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
	<script language="javascript">
	$(function(){
		$("input[name='reupdatebutton']:button").click(function(){
			if(confirm("ȷ��ɾ����������¼����������"))
			window.location.href="uphost_state.asp?act=reupdate&hostID=<%=hostid%>";
		});
	});
	</script>
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			    <li><a href="/Manager/sitemanager/">����������</a></li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
 
	
		  <table class="manager-table">
			<tbody>
				<tr><th colspan=2>����IP��������</th></tr>
				<tr>
					<th align="right">վ������:</th>
					<td align="left"><%=up.s_comment%></td>
				</tr>
				<tr>
					<th align="right">ʹ��ʱ��:</th>
					<td align="left"><%=up.s_buydate%>��<%=up.s_expiredate%>&nbsp;&nbsp;ʣ������:<%=up.dayHave%>��</td>
				</tr>
				<tr>
					<th align="right">��ǰ�ͺ�:</th>
					<td align="left"><%=up.s_ProName%>(<%=up.s_productid%>)</td>
				</tr>
				<tr>
					<th align="right">��ǰ����:</th>
					<td align="left"><%=up.s_roomname%></td>
				</tr>
				<tr>
					<th align="right">��ǰ�ͺ�:</th>
					<td align="left"><%=up.s_ProName%>(<%=up.s_productid%>)</td>
				</tr>
				<tr>
					<td colspan=2>



			<table class="manager-table">
				<tbody>
					<tr>
						<th colspan=2>  
							 <%if up.movestate=0 then%>
							  <div class="adsf">������վ���·������������Ƿ�����</div>
							  <%elseif up.movestate=1 then%>
							  <div class="adsf">����Ǩ������</div>
							  <%elseif up.movestate=3 then%>
							  <div class="adsf">����ת��ʧ��,����ϵ����Ա</div>
							  <%elseif up.movestate=2 then%>
							  <div class="adsf">������ԭ���ݵ��»���</div>
							  <%end if%>
						 </th>
					  </tr>
 <%if up.s_ProNameClass="mysql" then%>
					 <tr>
						<td>
      <form name="mysqlform1" method="post" action="http://mysql.myhostadmin.net/index.php" target="_blank">
                
                  <div>ԭIP:<%=up.old_serverip%><a href="###" onclick=javascript:$('form[name="mysqlform1"]').submit() style="color:#06c">[����]</a></div>
                  <div>mysql��:<%=up.s_comment%></div>
                  <div>mysql����:<%=up.s_ftppassword%></div>
                  <input type="hidden" name="mysqlhost" value="<%=up.old_serverip%>">
                  <input type="hidden" name="pma_username" value="<%=up.s_comment%>">
                  <input type="hidden" name="pma_password" value="<%=up.s_ftppassword%>">
                  <input type="hidden" name="mysqlport" value="3306">
                  <input type="hidden" name="server" value="1">
                  <input type="hidden" name="lang" value="zh-utf-8">
                  <input type="hidden" name="convcharset" value="iso-8859-1">
                
              </form>
						</td>

						<td>
				 <form name="mysqlform2" method="post" action="http://mysql.myhostadmin.net/index.php" target="_blank">
               
                  <div>��ǰIP:<%=up.s_serverip%><a href="###" onclick=javascript:$('form[name="mysqlform2"]').submit()  style="color:#06c">[����]</a></div>
                  <div>mysql��:<%=up.s_comment%></div>
                  <div>mysql����:<%=up.s_ftppassword%></div>
                  <input type="hidden" name="mysqlhost" value="<%=up.s_serverip%>">
                  <input type="hidden" name="pma_username" value="<%=up.s_comment%>">
                  <input type="hidden" name="pma_password" value="<%=up.s_ftppassword%>">
                  <input type="hidden" name="mysqlport" value="3306">
                  <input type="hidden" name="server" value="1">
                  <input type="hidden" name="lang" value="zh-utf-8">
                  <input type="hidden" name="convcharset" value="iso-8859-1">
               
              </form>		
		
						</td>
					 </tr>
					     <%else%>
		<tr>
			<td> 
                <div>ԭIP:<%=up.old_serverip%><a href="ftp://<%=up.s_comment%>:<%=up.s_ftppassword%>@<%=up.old_serverip%>/" style="color:#06c" target="_blank">[����]</a></div>
                <div>ftp��:<%=up.s_comment%></div>
                <div>ftp����:<%=up.s_ftppassword%></div>
             </td>

			<td> 
                <div>��ǰIP:<%=up.targetip%><a href="ftp://<%=up.s_comment%>:<%=up.s_ftppassword%>@<%=up.targetip%>/"  style="color:#06c" target="_blank">[����]</a></div>
                <div>ftp��:<%=up.s_comment%></div>
                <div>ftp����:<%=up.s_ftppassword%></div>
            </td>
		</tr>
		<%if up.movestate<>1 then %>
			<tr><th colspan=2> <input type="button" value="ɾ����¼��������" name="reupdatebutton"  class="manager-btn s-btn" /></th></tr>
		<%end if%>
		<%End if%>
				</tbody>
			</table>








			 
					
					
					
					</td>
				</tr>
				<tr>
				<td colspan=2 align="left">
					1.���������ͺſ��Ի�ø���Ŀռ�͸����ϵͳ��Դ��<br />
              2.�����������ĵ������ڲ��䣬��������Ϊ���¾������ͺ�ÿ��Ĳ��*����ʣ����������������ò���30Ԫ�ģ���30Ԫ���㡣<br />
              3.�����������Ӧ����ҵ�ʾ��Զ��������������ͺ������������Ʒ�����޷���ȡ��<br />
              4.��Ⱥ����ֻ������ҵ�û��������û���������Ϊ�ֲ�ʽ��Ⱥ�����������޷���������<br>
              5.���ܽ�վ�������������������������ݲ��ܱ���������Ҫ�ؽ���վ!���ԭ����������֧��asp.net������������Ҫʹ��asp.net���ܵģ�����ϵ�ͷ�����&quot;network 
              service&quot;Ȩ�ޡ�<br />
              6.���ѡ����"�Զ�ת������"������Ҫ������Ǩ����ɺ�ϵͳ������������������������IP�Ȳ���;�������Ҫ���ݣ�����ʵʱ��Ч�����ź���ͨ����֮���ٶȺ��������������̫�󣬿�����Ҫ�൱����ת��ʱ�䣬����ת��ʧ�ܡ�<br />
              7.���������ܹ���ʱ���Żݻ
				</td>
			</tbody>
		  </table>
  

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>