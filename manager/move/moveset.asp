<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
if session("u_levelid")=1 then  url_return "�㲻�Ǵ���",-1
conn.open constr
 module=requestf("module")
if module="module" then
	moveSet=requestf("moveSet")
	if moveSet=1 then
		sets=0
	else
		sets=1
	end if
	sql="update userDetail set u_moveSet="& sets &" where u_id="& session("u_sysid")
	conn.execute sql
  Alert_Redirect "���óɹ�","moveset.asp"
response.end
end if

sql="select top 1 u_moveSet from userDetail where u_id="& session("u_sysid") & " and u_level<>1"
rs.open sql,conn,1,3
if rs.eof then
    rs.close
	response.write "<script language=javascript>history.back();</script>"
	response.end
end if
moveset=trim(rs("u_moveSet"))
 start="����"

if moveset=1 then
 start="��ֹ"
 moveset=1
else
 moveset=0
end if
if start="����" then
	startbutton="��ֹ"
else
	startbutton="����"
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-ҵ��ת������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language=javascript>
 function dosub(){
   var p=document.form1.moveSet.value;
   var v="��ֹ";
   
   		if(p==1){
			v="����";
		}
		if(confirm("��ȷ��Ҫ-"+ v +"-�û�ת����?")){
			document.form1.module.value="module";
			document.form1.submit();
			return true;
		}else{
		  return false;
		}
   	
  
 }
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
        <li><a href="/manager/usermanager/default2.asp">ҵ��ת������</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <form name="form1" action="moveset.asp" method="post">
        <table  class="manager-table">
          <tr>
            <th>�������ҵ��Ŀǰ��ת��״̬��:<font color=red><%=start%></font>�������û�ת�뵽�����˺��¡�</th>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF" class="tdbg"><input type="hidden" value="<%=moveSet%>" name="moveSet">
              <input type="button" class="manager-btn s-btn" onClick="return dosub()" value="��Ҫ<%=startbutton%>�û�ת��"></td>
            <input type="hidden" value="" name="module">
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" class="tdbg"> ��ʾ��<br />
              ͨ���������ã����Խ�ֹ�Լ���ҵ��������Աת������ʹ��֪��ҵ���������Ҳ����ת����������������������ڶ�û�е�¼����˾��վ����������Զ�ʧЧ��</td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
