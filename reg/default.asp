<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->

<!--#include virtual="/config/Template.inc.asp" --> 
<%
response.buffer=true
response.charset="gb2312"
str=trim(requesta("str"))
v=trim(requestf("v"))
select case str
case "u_name"
	conn.open constr
	vsql="select * from userdetail where u_name='"& v &"'"
	set vRs=conn.execute(vsql)
	if not vRs.eof then
		response.write "<br><div style=""border:ccff99 solid 1px; background:#ffffcc""><img src=""/Template/Tpl_01/images/new/stop_zxw.gif"" border=0>很遗憾,该帐号已经被注册.<br>&nbsp;&nbsp;请重新选择一个会员号,谢谢。</div><input id=""u_name_span_pd"" type=""hidden"" value=""errs"">"
	else
		response.write "<br><img src=""/Template/Tpl_01/images/new/ok_zxw.gif"" border=0><font color=""#336600"">恭喜.此用户名可用</font><input id=""u_name_span_pd"" type=""hidden"" value=""ok"">"
	end if
	vRs.close
	set vRs=nothing
	conn.close
	response.end
end select
'''''''''''''''template''''''''''''''''''''''''
Call setwebhostingLeft()
call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/reg/default.html"
if alipaylog then
tpl.set_var "alipaylog","<dt><a href=""/reg/alipaylog.asp""><img src=""/images/alipay/alipaylog.png"" /></a></dt>",false 
else
tpl.set_var "alipaylog","",false
end if
tpl.parse "mains", "main",false
tpl.p "mains" 
set tpl=nothing
%>