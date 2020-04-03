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
this_id=Requesta("id")
if(Requesta("level_1")="1")then
  level_1="1"
else
  level_1="0"
end if
if(Requesta("level_2")="1")then
  level_2="1"
else
  level_2="0"
end if

if(Requesta("level_3")="1")then
  level_3="1"
else
  level_3="0"
end if

if(Requesta("level_4")="1")then
  level_4="1"
else
  level_4="0"
end if

if(Requesta("level_5")="1")then
  level_5="1"
else
  level_5="0"
end if

if(Requesta("level_6")="1")then
  level_6="1"
else
  level_6="0"
end if

admin_level = level_1 & level_2 & level_3 & level_4 & level_5 & level_6


if(this_id="") then Alert_Redirect "请进行正确操作！",request.servervariables("HTTP_REFERER")
if(admin_level="") then
    Alert_Redirect "请填写完整的用户信息！","javascript:history.back()"
else
    conn.open constr
    sql="select * from userdetail where u_id = "&this_id
     
    rs.open sql,conn,3,3
    if  rs.eof then
		rs.close
		conn.close
       Alert_Redirect "该用户名称不存在!","javascript:history.back()"
    else
       rs("u_type") = admin_level
       rs.update
		rs.close
		conn.close
       Alert_Redirect "操作员更改完成!","default.asp"
    end if
end if
%> 

<!--#include virtual="/config/bottom_superadmin.asp" -->
