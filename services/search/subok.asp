<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

			<%

			p_proid=Requesta("p_proid")
			If p_proid="" Then closeWithWin("对不起，请选择推广产品 !")
			p_name=Requesta("p_name")
			p_info=trim(Requesta("p_info"))
			p_agent_price=Requesta("p_agent_price")
			buy_num=Requesta("buy_num")
			if Cint(buy_num)<=0 then url_return "请勿非法使用本系统",-1
			If p_agent_price*buy_num > StrToNum(session("u_usemoney")) Then url_return "您的帐户余额不足",-1
			
			email=Requesta("email")
			url=Requesta("url")
			contact=Requesta("contact")&"  地址："&requesta("address")

			company=Requesta("company")
			phone=Requesta("phone")
			memo=Requesta("memo")
			if memo="" then memo=p_name
			If email="" Or url="" Or contact="" Or company="" Or phone="" Or memo="" Then url_return "您提交的信息不全，请补充完整。",-1
			conn.open constr

			Sql="insert  into searchlist (p_proid,p_name,p_info,p_agent_price,[email],[url],contact,buy_num,company,phone,[memo],[datetime],[check],u_id,u_name)"
			sql=sql & " values ('" & p_proid & "','" & p_name & "','" & p_info & "'," & p_agent_price & ",'" & email & "','" & url & "','" & contact & "'," & buy_num & ",'" & company & "','" & phone  
			sql = sql & "','" & memo & "',now(),'0'," & session("u_sysid") & ",'" & session("user_name") & "')"
conn.execute(Sql)
					    alert_redirect "订单提交成功。" ,"/manager/search/"
			%>
