 
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
 
            <%
on error resume next
				module=Requesta("module")
				If module="priedit" Then
					p_proid=Requesta("p_proid")
					p_u_level=Requesta("p_u_level")
					p_price=Requesta("p_price")
					p_price_renew=Requesta("p_price_renew")
					if p_price="" then
						p_price="0"
					end if
					if p_price_renew="" then
						p_price_renew="0"
					end if

					conn.open constr
					sql="update pricelist set p_price="&p_price&", p_price_renew="&p_price_renew&" where p_proid='"&p_proid&"' and p_u_level="&p_u_level
					response.Write(sql)
					conn.Execute sql
					conn.close
if err then
response.write "发生错误，可能是输入的值不正确，请返回重新输入！"
response.write err.description 
response.end
end if

					'用户修改价格的不过是一条一条的修改
					Response.redirect "detail.asp"
				End If
%>
 <!--#include virtual="/config/bottom_superadmin.asp" -->
