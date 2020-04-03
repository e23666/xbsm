<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%webroot = server.MapPath("/")
thispath= server.MapPath(".")
if trim(lcase(webroot))<> trim(lcase(thispath)) then
	response.write "发生错误：本系统必须安装在网站根目录才能正常运行！"
	response.end
end if
%>

<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
'检查是否已经安装
Call checkInstall()
'------------------------------
 if Trim(Requesta("ads"))<>"" then
	 Session("Ads")=Requesta("ads")
 end if
  DomainString=Lcase(Request.ServerVariables("server_name"))
 if left(DomainString,4)="www." then
   centerString=mid(DomainString,5)
 else
   centerString=DomainString
 end if
   session("ModeCDomain")=centerString
	if request.QueryString("Mode")<>"" then
		session("ModeCDomain")=request.QueryString("Mode")
		centerString=request.QueryString("Mode")
	end if
  if Trim(requesta("ReferenceID"))<>"" then
  			Response.Cookies("ModeD")=requesta("ReferenceID")
			Response.Cookies("ModeD").Expires=date+30
			Session("ModeD")=requesta("ReferenceID")
  end if
	if trim(request.Cookies("ModeD"))<>"" then
		Session("ModeD")=sqlincode(request.Cookies("ModeD"))
	end if


''''''''''''''''''''''开始模板程序'''''''''''''''''''''	

call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/default.html"  
tpl.set_file "left_News", USEtemplate&"/config/Left_News.htm" 
tpl.set_file "left_adv1", USEtemplate&"/config/Left_Adv_1.htm"  
tpl.set_file "Left_Adv2",USEtemplate&"/config/Left_Adv_2.htm" 


tpl.parse "#Left_News.htm","left_News",false
tpl.parse "#Left_Adv_1.htm","left_adv1",false
tpl.parse "#Left_Adv_2.htm","Left_Adv2",false
tpl.set_function "main","Price","tpl_function"
tpl.parse "mains", "main",false

'输出 
tpl.p "mains" 
set tpl=nothing

'------------------------------

%> 

