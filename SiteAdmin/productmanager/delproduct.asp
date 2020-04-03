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
proid=Requesta("proid")
conn.open constr
conn.Execute "delete FROM productlist where p_proid='"&proid&"'"
conn.Execute "delete FROM pricelist where p_proid='"&proid&"'"
conn.close
Call Alert_Redirect("É¾³ý³É¹¦","default.asp")
%><!--#include virtual="/config/bottom_superadmin.asp" -->
