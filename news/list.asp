<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
newsid=Requesta("newsid")
if not isnumeric(newsid&"") then url_return "错误的参数",-1
if newsid=172 then newsid=182
conn.open constr

set trs=conn.execute("select * from [news] where newsid=" & newsid)
if not trs.eof then
	newstitle=trs("newstitle")
	newscontent=trs("newscontent")
	newpic=trim(trs("newpic")) & ""
	Call htmlDeCode_(newscontent)
else
	newscontent="不存在此文章或被删除"
end if
trs.close			
if newPic<>"" then newpic="<img src="""& rs("newpic") & """>"

call setHeaderAndfooter()
tpl.set_file "main", USEtemplate&"/news/list.html"
tpl.set_file "left", USEtemplate&"/config/customercenterleft/CustomerCenterLeft.html"
tpl.set_var "newstitle",newstitle,false
tpl.set_var "newscontent",newscontent,false
tpl.set_var "newpic",newpic,false

tpl.parse "#CustomerCenterLeft.html","left",false
tpl.parse "mains","main",false
tpl.p "mains" 
set tpl=nothing
conn.close


%>