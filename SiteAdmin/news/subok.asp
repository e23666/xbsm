<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>新闻管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">所有新闻</a> | <a href="addnews.asp">发布新闻</a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
          <tr>
            <td align="center" class="tdbg"><p><BR>
              <%
'			formtest
'			content = Request("content")
'			checkbox2 = Request("checkbox2")
'			Response.End
			subject=Request("subject")
			stype=Request("type")
			ip=Request("ip")
			domain=Request("domain")
			content=Request("content")
			keyword=Request("keyword")
			checkbox=Request("checkbox")
			checkbox2=Request("checkbox2")
			If checkbox2="" Then
				content=replace(content," ","&nbsp;")
				content=replace(content,vbCrLf ,"<BR>")
			End If
			If checkbox2="" Then checkbox2="1"
			If checkbox="" Then checkbox="1"
			If subject<>"" and content <>"" Then
				conn.open constr
				rs.open "select top 1 * from [news] where newstitle = '"&subject&"' and dateDiff("&PE_DatePart_D&", '"&now()&"', newpubtime) =0",conn,1,3
				If rs.eof Then
					If checkbox="0" Then
						session("add_newnews")="insert into [news](newsman,newstitle,newscontent,html,newpic) values ('"&session("user_name")&"','"&subject&"','"&content&"','"&checkbox2&"','[!null!]')"
						rs.close
						conn.close
					  else
						rs.addnew
						rs("newsman")=session("user_name")
						rs("newstitle")=subject
						rs("newscontent")=content
						rs("html")=checkbox2
						rs.update
						rs.close
						conn.close
						alert_redirect "添加成功,预览","default.asp"
					End If
					if checkbox="0" then
						Response.Write "请添加图片,否则新闻无法添加"
					%>
              <BR>
              <BR>
            </p>
          <table width=60% border=0 cellpadding=5 cellspacing=0 class="border">
<FORM ACTION="uploadfile.asp" ENCTYPE="MULTIPART/FORM-DATA" METHOD="POST">
					  <tr>
						<td align="right">图片文件:</td>
						<td><input type="file" name="file"></td>
		  </tr>
					  <tr>
						<td height="14" colspan="2" align="center">							<input type="submit" name="Submit" value="提交">						  </td>
		  </tr>
					</form>
					</table>
					<%
					End If
				  else
					Response.Write "新闻发布失败"
				End If
			  else
				url_return "新闻标题和内容必须填写",-1
			End If
			%>			            <br />
			<br /></td>
          </tr>
        </table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
