<%
if  session("u_type")="" or IsNull(session("u_type")) or trim(session("u_type"))="0"  then  
	response.write "<script language=javascript>parent.location.href='/login.asp';</script>"
	response.end
end if
%>