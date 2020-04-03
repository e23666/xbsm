<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
id=Requesta("id")
makedate=now()
If id="" Then url_return "对不起，请选择产品ID号 !",-1
conn.open constr

sql="update searchlist set [check]='-2',makedate=now() where u_id=" & session("u_sysid") & " and id=" & id
conn.execute (sql)
   Call Alert_Redirect("操作成功！","m_default.asp?id="&id)
%>
