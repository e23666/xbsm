<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->

			<%

			p_proid=Requesta("p_proid")
			If p_proid="" Then closeWithWin("�Բ�����ѡ���ƹ��Ʒ !")
			p_name=Requesta("p_name")
			p_info=trim(Requesta("p_info"))
			p_agent_price=Requesta("p_agent_price")
			buy_num=Requesta("buy_num")
			if Cint(buy_num)<=0 then url_return "����Ƿ�ʹ�ñ�ϵͳ",-1
			If p_agent_price*buy_num > StrToNum(session("u_usemoney")) Then url_return "�����ʻ�����",-1
			
			email=Requesta("email")
			url=Requesta("url")
			contact=Requesta("contact")&"  ��ַ��"&requesta("address")

			company=Requesta("company")
			phone=Requesta("phone")
			memo=Requesta("memo")
			if memo="" then memo=p_name
			If email="" Or url="" Or contact="" Or company="" Or phone="" Or memo="" Then url_return "���ύ����Ϣ��ȫ���벹��������",-1
			conn.open constr

			Sql="insert  into searchlist (p_proid,p_name,p_info,p_agent_price,[email],[url],contact,buy_num,company,phone,[memo],[datetime],[check],u_id,u_name)"
			sql=sql & " values ('" & p_proid & "','" & p_name & "','" & p_info & "'," & p_agent_price & ",'" & email & "','" & url & "','" & contact & "'," & buy_num & ",'" & company & "','" & phone  
			sql = sql & "','" & memo & "',now(),'0'," & session("u_sysid") & ",'" & session("user_name") & "')"
conn.execute(Sql)
					    alert_redirect "�����ύ�ɹ���" ,"/manager/search/"
			%>
