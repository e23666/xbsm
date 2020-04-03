<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/uercheck.asp" -->
<%
p_proid=Requesta("productid")
If p_proid="" Then url_return "对不起，请选择推广产品 !",-1
conn.open constr

sql="select * from productlist where p_proid='"& p_proid &"'"
rs.open sql,conn,1,1
if rs.eof then url_return "没有找到此产品",-1

p_name=rs("p_name")
p_proid=rs("p_proid")
p_info=rs("p_info")
p_agent_price=GetNeedPrice(session("user_name"),p_proid,1,"new")

			call setHeaderAndfooter()
			tpl.set_file "seachleft",USEtemplate&"/config/seachLeft/seachleft.html"
			tpl.set_file "main", USEtemplate&"/services/search/buy.html"
			tpl.set_var "p_name",p_name,false
			tpl.set_var "p_proid",p_proid,false
			tpl.set_var "p_info",p_info,false
			tpl.set_var "p_agent_price",p_agent_price,false
			
			tpl.parse "#seachleft.html","seachleft",false
			tpl.parse "mains","main",false
			tpl.p "mains" 
			set tpl=nothing
			conn.close
%> 
