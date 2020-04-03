<!--#include virtual="/config/config.asp" -->
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<MM:EndLock>
<%Check_Is_Master(1)%> <%

conn.open constr

if request("action")<>"" then
	q_public=Requesta("q_public")
	if q_public<>"1" then
		q_public="0"
	end if
	'reply_content=server.htmlencode(request("textarea"))
	reply_content=request("textarea")
	'reply_content=Replace(reply_content,"'","‘")
	'reply_content=Replace(reply_content,vbcrlf,"<br>")
	sql="update Question set q_reply_content='" & reply_content &"',q_public=" & q_public & " where q_id="&request("hiddenField")
	conn.execute(sql)
	response.Redirect("reply.asp?qid="&request("hiddenField"))
end if

sql="Select * from Question where q_id="&requesta("qid")
rs.open sql,conn,1,3

if rs("q_public") then
	q_public="checked"
else
	q_public=""
end if

function dvHTMLEncode(fString)
if not isnull(fString) then
    fString = replace(fString, ">", "&gt;")
    fString = replace(fString, "<", "&lt;")

    fString = Replace(fString, " ", "&nbsp;")
    fString = Replace(fString, CHR(34), "&quot;")
    fString = Replace(fString, CHR(39), "&#39;")
    fString = Replace(fString, CHR(13), "")
    fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
    fString = Replace(fString, CHR(10), "<BR> ")

    dvHTMLEncode = fString
end if
end function

function HTMLCode(SString)
if SString<>"" then


    SString = replace(SString, "&gt;",">")
    SString = replace(SString,  "&lt;","<")

   SString = Replace(SString, "&nbsp;", " ")
   SString = Replace(SString, "&quot;", CHR(34))
   SString = Replace(SString, "&#39;",  CHR(39))
   SString = Replace(SString, "</P><P> ", CHR(10) & CHR(10))
   SString = Replace(SString,  "<BR> ",CHR(10))

    HTMLCode = SString
end if
end function


q_reply_content=rs("q_reply_content")
q_reply_content=Replace(q_reply_content,"<br>",vbcrlf)
q_reply_content=Replace(q_reply_content,"<BR>",vbcrlf)
%>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><form name="form1" method="post" action="">
        是否允许公共搜索:
        <input type="checkbox" name="q_public" value="1" <%=q_public%>>
        <br>
        <textarea name="textarea" cols="80" rows="20" wrap="VIRTUAL"><%=q_reply_content%></textarea>
        <br>
        <br>
        <input type="submit" name="Submit" value="确定修改"> <input type="hidden" name="action" value="mod">
        <input type="hidden" name="hiddenField" value="<%=request("qid")%>">
      </form></td>
  </tr>
</table>
<%
rs.close
conn.close

%><!--#include virtual="/config/bottom_superadmin.asp" -->
