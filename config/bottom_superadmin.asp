<%
'====朱小维=================07-3-20===============

' 关闭所有数据库对象并且释放内存 

On Error Resume Next 

'Dim ws  
'Dim db  
'Dim rs 
if not isnull(conn) then
	conn.close
end if
if not isnull(rs) then
	rs.close
end if
if not isnull(rs1) then
	rs1.close
end if

'=====================================================
%>