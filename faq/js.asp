<!--#include file="conn.asp"-->
<!--#include file="common.asp"-->
<%

dim path,classID,NclassID,showNclass,kind,dateNum,maxLen,listNum,bullet
dim hitColor,new_color,old_color

topType = Request("topType")

if Request("ClassNo") <> "" then
	ClassNo = split(Request("ClassNo"),"|")
	Classid = ClassNo(1)
	Nclassid = ClassNo(0)
end if

num = request.querystring("num")
maxlen = Request.querystring("maxlen")
showdate = Request("showdate")
showhits = Request("showhits")
showClass = Request("showClass")

bullet="·"			 '标题前的图片或符号
hitColor="#FF0000"   '点击数的颜色
new_color="#FF0000"  '新文章日期的颜色
old_color="#999999"  '旧文章日期的颜色


dim rs,sql,str,topic
Path="http://"&request.servervariables("server_name")&replace(request.servervariables("script_name"),"js.asp","")



set rs=server.createObject("Adodb.recordset")
sql = "Select top "& num &" Unid,title,classid,Nclassid,Intime,hits from article_info "

if NclassID<>"" then
	sql=sql&" where flag = 0 and Audit = 0 and NclassID="&NclassID
elseif classID<>"" then
	sql=sql&" where flag = 0 and Audit = 0 and classID="&classID
end if

select case topType
	case "new" sql=sql&" order by Unid desc,Unid"
	case "hot" sql=sql&" order by hits desc,Unid"
	'case "2" sql=sql&" DATEDIFF('d',intime,Now())<="&dateNum&" order by hits desc,Unid"
end select

set rs = conn.execute(sql)
if rs.bof and rs.eof then 
str=str+"没有符合条件的文章"
else

rs.movefirst
do while not rs.eof
	topic=Qcdn.GetString(rs("title"),maxlen)
	topic=replace(server.HTMLencode(topic)," ","&nbsp;")
	topic=replace(topic,"'","&nbsp;")
	str=str+bullet
	if showClass = 1 then
		str=str+"[<a href='"&path&"2j.asp?id="&rs("classid")&"&cid="& rs("Nclassid") &"'>"&Qcdn.Classlist(rs("nclassid"))&"</a>] "
	end if
	str=str+"<a href='"&Path&"list.asp?Unid="+Cstr(rs("Unid"))+"' target='_blank'  title='"&replace(replace(server.HTMLencode(rs("title"))," ","&nbsp;"),"'","&nbsp;")&"') >"+Topic+"</a>("
	if showdate = 1 then
		str=str & "<font color="
			if rs("intime")>=date then
				str=str & new_color
		 	else
				str=str & old_color
			end if
			str=str &">" & Month(rs("intime"))&"月"&Day(rs("intime"))&"日</font>,"
	end if
	if showhits = 1 then
		str=str&"<font color="& hitcolor &">"& rs("hits") &"</font>)<br>"
	else
		str=str&")<br>"
	end if

	rs.moveNext
loop
end if
rs.close : conn.close
set rs=nothing : set conn=nothing

response.write "document.write ("&Chr(34)&str&Chr(34)&");"
%>