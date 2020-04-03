<!--#include virtual="/manager/config/config.asp" -->


<%
response.buffer=true
response.charset="gb2312"
conn.open constr

dologout=true
If trim(session("u_sysid"))&""="" or trim(Session("safecode"))<>trim(sqlincode(request.Cookies("safecode"))) Then
	dologout=not check_is_cookie() 
	
else
	
 
	rs.open "select u_usemoney,u_resumesum,u_premoney from userdetail where u_id=" & session("u_sysid"),conn,1,1
	if not rs.eof then
		dologout=false
		session("u_usemoney")=FormatNumber(rs("u_usemoney"),-1,-1)
		session("u_resumesum")=FormatNumber(rs("u_resumesum"),-1,-1)
		session("u_premoney")=rs("u_premoney")'优券
	end if
	rs.close
	
End If

if dologout then
die "请登陆后操作"
end if








id=requesta("id")
pname=requesta("pname")
txt=requesta("txt")
ptype=requesta("ptype")
if not isnumeric(ptype&"") then die "参数错误"
sql="select top 1 * from Remarks where r_type="&ptype&" and p_id="&id
set p_rs=Server.createObject("adodb.recordset")
p_rs.open sql,conn,1,3
if p_rs.eof then
p_rs.addnew
	p_rs("p_id")=id
	p_rs("r_type")=ptype
	p_rs("p_name")=pname
end if
	p_rs("r_txt")=txt
p_rs.update
p_rs.close
conn.close
die "操作成功"
%>