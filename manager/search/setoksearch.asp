<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
id=Requesta("id")
makedate=now()
If id="" Then url_return "�Բ�����ѡ���ƷID�� !",-1
conn.open constr

sql="update searchlist set [check]='-2',makedate=now() where u_id=" & session("u_sysid") & " and id=" & id
conn.execute (sql)
   Call Alert_Redirect("�����ɹ���","m_default.asp?id="&id)
%>
