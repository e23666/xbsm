 <!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(1)%>
<%
 


if(Requesta("check")="true") then
    
  this_id=Requesta("id")

	if session("u_sysid")-this_id=0 then 
		url_return "��Ǹ�����ܽ��Լ��ӹ���Ա�б�ɾ����",-1
	end if

  if(this_id="") then
    Alert_Redirect "Ҫɾ�����û�idΪ�գ�",request.servervariables("HTTP_REFERER")
  else
    conn.open constr
    sql="update userdetail set u_type = '0' where u_id ="&this_id
    conn.execute(sql)
	conn.close
    Alert_Redirect "����Աɾ�����!","default.asp"
  end if

else
  this_id=Requesta("id")
%>
  <script language="javascript">
   if(confirm("��ȷ��Ҫɾ���˲���Ա��"))
     window.location="member_del.asp?check=true&id=<%=this_id%>";
   else
     window.location="<%=request.servervariables("HTTP_REFERER")%>";
  </script>
<%
end if
%><!--#include virtual="/config/bottom_superadmin.asp" -->
