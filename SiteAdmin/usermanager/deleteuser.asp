<!-- top end -->
<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<%Check_Is_Master(1)%>
<%
u_id=Requesta("u_id")
conn.open constr
conn.Execute "delete FROM userdetail where u_id="&u_id&""
conn.close
Call Alert_Redirect("É¾³ý³É¹¦","default.asp")
%><!--#include virtual="/config/bottom_superadmin.asp" -->
