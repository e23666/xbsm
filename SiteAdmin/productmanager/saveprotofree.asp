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
str=trim(requesta("str"))
pages=trim(requesta("pages"))
if str="" or len(str)<=0 then str="host"
proid=Requesta("proid")'ԭ��ƷID
freeproid=Requesta("freeproid")'��ƷID

freeproid1=trim(Requesta("freeproid1"))'��ƷID1
free1hidden=trim(request.Form("free1hidden"))'����ӵ�
if freeproid1="delelteall" then
  freeproid1=""
elseif freeproid1&""="" then
  freeproid1=free1hidden
end if

freeproid2=Requesta("freeproid2")'��ƷID2
freeproid3=Requesta("freeproid3")'��ƷID3
freeproid4=Requesta("freeproid4")'��ƷID4
'''''''�Զ������Ѷ�'''''''''
addTime=""
for i=1 to 4
  addpd=trim(request.form("addTime"&trim(i)))
  if addpd&""="" or addpd<>"1" then
    adds="0"
  else
    adds="1"
  end if
    addTime=addTime&adds&","
next
if addTime<>"" and right(addTime,1)="," then
  addTime=left(addTime,len(addTime)-1)
end if
'''''''''''''''''''''''''

conn.open constr
sql="select * from protofree where proid='"&proid&"' and type='"& str &"'"
set rss=conn.execute (sql)
If rss.bof And rss.eof Then
		sql="insert into protofree(proid,freeproid,freeproid1,freeproid2,freeproid3,freeproid4,type,addTime) values('"&proid&"','"&freeproid&"','"& freeproid1 &"','"& freeproid2 &"','"& freeproid3 &"','"& freeproid4 &"','"& str &"','"& addTime &"')"
		conn.Execute sql
		conn.close
else
		sql="update protofree set freeproid='"&freeproid&"',freeproid1='"&freeproid1&"',freeproid2='"&freeproid2&"',freeproid3='"&freeproid3&"',freeproid4='"&freeproid4&"',addTime='"& addTime &"' where proid='"&proid&"' and type='"& str &"'"
		response.Write(sql)
		conn.Execute(sql)
		
		conn.close	
End If
Response.redirect "protofree.asp?str="&str&"&module=search&pages="&pages
%>
 <!--#include virtual="/config/bottom_superadmin.asp" -->
