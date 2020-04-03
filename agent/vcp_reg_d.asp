<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
if vcp_d=false then url_return "抱歉，本站暂时没有开通D模式，请联系管理员!",-1
call needregSession()
conn.open constr

Sql="Select * from userdetail Where u_name='" & Session("user_name") &"'"
Rs.open Sql,conn,1,1
if rs.eof and rs.bof then rs.close:url_return "用户错误!",-1
u_namecn=rs("u_namecn")
u_address=rs("u_address")
u_zipcode=rs("u_zipcode")
qq_msg=rs("qq_msg")
u_email=rs("u_email")
u_telphone=rs("u_telphone")
u_fax=rs("u_fax")
u_id=rs("u_id")

			call setHeaderAndfooter()
			call setagentLeft()
			tpl.set_file "main", USEtemplate&"/agent/vcp_reg_d.html"
			tpl.set_var "u_namecn",u_namecn,false
			tpl.set_var "u_address",u_address,false
			tpl.set_var "u_zipcode",u_zipcode,false
			tpl.set_var "qq_msg",qq_msg,false
			tpl.set_var "u_email",u_email,false
			tpl.set_var "u_telphone",u_telphone,false
			tpl.set_var "u_fax",u_fax,false
			tpl.set_var "u_id",u_id,false
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
			rs.close
			conn.close

%>