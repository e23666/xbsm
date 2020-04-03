<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Template.inc.asp" --> 
<%
conn.open constr
sqlcmd="SELECT * FROM [news] order by newsid desc"
rs.open sqlcmd,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
	tpl.set_unknowns "remove"
	call setHeaderAndfooter()
	tpl.set_file "main", USEtemplate&"/news/default.html"
	tpl.set_file "left", USEtemplate&"/config/customercenterleft/CustomerCenterLeft.html"
	tpl.set_block "main", "newslist", "mylist"
			do while not rs.eof and cur<=setsize
				newsid=rs("newsid")
				newstitle=gotTopic(rs("newstitle"),80)
				newpic=trim(rs("newpic"))
				newpubtime=formatdatetime(rs("newpubtime"),2)
				
				If rs("newpic")&""<>"" Then tpl.set_var "newpic",newpic,false
					
				tpl.set_var "i",cur,false
				tpl.set_var "newsid",newsid,false
				tpl.set_var "newstitle",newstitle,false
				tpl.set_var "newpubtime",newpubtime,false
				tpl.parse "mylist", "newslist", true
			cur=cur+1
			rs.movenext
			Loop
			rs.close
			conn.close
	tpl.set_var "pagenumlist",pagenumlist,false
	tpl.parse "#CustomerCenterLeft.html","left",false
	tpl.parse "mains","main",false
	tpl.p "mains" 
	set tpl=nothing
%>


