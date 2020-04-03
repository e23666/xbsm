<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<!--#include file="md5.asp"-->
<%
if Request("method") = 1 then
	articleid = Request.form("articleid")
	face = Request.form("face")
	content = Qcdn.checkStr(Trim(Request.form("content")))
	username = Qcdn.checkStr(Trim(Request.form("username")))
	password = Qcdn.checkStr(Trim(Request.form("password")))
	if Request.Cookies("qcdn")("user_name") = "" then
		password = md5(password,16)
	end if

	ip = Request.ServerVariables("REMOTE_ADDR")

	Sql = "select Unid from article_User where username = '"& username &"' and password = '"& password &"'"
	set rs = conn.execute(sql)
	if rs.eof and rs.bof then
		response.write "<script>alert(""1、您还没有注册！\n\n2、错误的用户名或密码！"");location.href=""UserReg.asp"";</script>"
		rs.close : set rs = nothing
		response.end
	else
		sql = "Insert into article_remark(articleid,username,content,faceid,intime,ip)values("& articleid &",'"& username &"','"& content &"',"& face &",Now(),'"& ip &"')"
		conn.execute(sql)
		Response.write "<script>alert(""评论发布成功"");location.href=""remarkList.asp?unid="& articleid &""";</script>"
		response.end
	end if
elseif Request("method") = 2 then
	if Session("flag") = "" or Session("Admin_Name") = "" then
		Session("flag") = ""
		Session("Admin_Name") = ""
		Errmsg = "<li>你不是系统管理员。"
		call Qcdn.Err_List(errmsg,1)
		Response.end
	end if
	unid = CLng(Request("unid"))
	Unid = qcdn.sqlcheck(Unid)
	sql = "update article_info set Audit = 0 where Unid in ("& unid &")"
	conn.execute(sql)
	Response.Write("<script>alert(""审核成功"");window.opener.location.reload();window.close();</script>")
	Response.End()
elseif Request("method") = 3 then
	unid = CLng(Request("unid"))
	Response.Write("<script>window.opener.location.href=""admin_newsedit.asp?unid="&Unid &""";window.close();</script>")
	Response.End()
end if
if Request("Unid") = "" then
	Errmsg = "<li>发现异常错误。<li>传递的文章编号为空。"
	call Qcdn.Err_List(errmsg,3)
	Response.End()
else
	Unid = CLng(Request("Unid"))
	Unid = qcdn.sqlcheck(Unid)
end if
ad = Request("ad")
Sql = "Select title,content,Nclassid,classid,Nkey,hits,writer,writefrom,Intime,Popedom from article_info where Unid = " & Unid

Set Rs = conn.execute(Sql)
if Rs.eof and Rs.bof then
	Errmsg = "<li>发现异常错误。<li>错误编号为: error 108。<li>请和管理员联系解决问题。"
	call Qcdn.Err_List(errmsg,3)
	Response.End()
else
	Popedom = Rs(9)
	if AddPopedom then
		if Popedom = 1 then
			if Request.Cookies("qcdn")("user_name") = "" then
				Response.write ("<script>alert(""如果您是会员，请登陆后浏览。"");window.close();</script>")
				Response.end
			end if
		end if
	end if
	sql = "Update article_info set hits=hits+1 where Unid = " & Unid
	Conn.execute(sql)
	title = Rs(0)
	content = Rs(1)
	Nclassid = Rs(2)
	classid = Rs(3)
	Nkey = Rs(4)
	hits = Rs(5)
	writer = Rs(6)
	writefrom = Rs(7)
	Intime = Rs(8)
end if
Rs.close

Sub htmlDeCode_(strng)
	strng = strng & ""
	strng = Replace(strng,"&lt1;","<")
	strng = Replace(strng,"&gt1;",">")
	strng = Replace(strng,"&#391;","'")
	strng = Replace(strng,"&quot1;","""")
	strng = Replace(strng,"&nbsp1;"," ")
End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><HEAD><TITLE><%=Qcdn.HTMLcode(title)%>- <%=Qcdn.Classlist(Classid)%>,<%=netName%>-帮助中心</TITLE>
<meta name="description" content="国内大型网络服务商,专业提供虚拟主机,域名注册,企业邮局,网站推广,网络实名等企业上网服务。支持在线支付，实时注册，实时开通，自主管理。"><meta name="keywords" content="><%=Qcdn.HTMLcode(title)%>- <%=Qcdn.Classlist(Classid)%>,<%=netName%>,虚拟主机,网页制作,域名注册,主机,企业邮局,主页空间,个人主页,网络实名,主机托管,网站建设,域名"><META content="text/html; charset=gb2312" http-equiv=Content-Type>
<%If LCase(USEtemplate)="tpl_2016" then%>
  <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
  <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
  <link rel="stylesheet" href="/template/Tpl_2016/css/tp2016.css">
    <link href="/template/Tpl_2016/css/Customercenter.css" rel="stylesheet" type="text/css">
  <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<link href="/ueditor4/third-party/SyntaxHighlighter/shCoreDefault.css" rel="stylesheet" type="text/css">
<script src="/ueditor4/third-party/SyntaxHighlighter/shCore.js"></script>
<%else%>
<link href="/Template/Tpl_05/css/Global.css" rel="stylesheet" type="text/css">
<link href="/Template/Tpl_05/css/faq.css" rel="stylesheet" type="text/css">
<link href="/Template/Tpl_05/css/weiyanlover.css" rel="stylesheet" type="text/css">
<link href="/ueditor4/third-party/SyntaxHighlighter/shCoreDefault.css" rel="stylesheet" type="text/css">
<script src="/ueditor4/third-party/SyntaxHighlighter/shCore.js"></script>

<%End if%>

</head>
<%If LCase(USEtemplate)="tpl_2016" then%>
<body class="min990">

<script language="JavaScript" type="text/JavaScript">
<!--

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<%
server.execute "/faq/top.asp"
%>

  <div id="content">
    <div class="content">
      <div class="wide1190 pt-40 cl">
<%else%>
<body id="thrColEls">

<div class="Style2009">
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<%
server.execute "/faq/top.asp"
%>


  <div id="SiteMapPath">
    <ul>
 <li><a href="/">首页</a></li>
      <li><a href="/customercenter/">客服中心</a></li>
      <li><a href="/faq/">常见问题</a></li>
    </ul>
  </div>
<div id="MainContentDIV">

<%End if%>


      <!--#include file="left.asp"-->
      <div id="Mainlist" class="content-right cl">

      <script language=javascript>
      function ContentSize(size)
      {
      	var obj=document.all.ContentBody;
      	obj.style.fontSize=size+"px";
      }
      </script>

      <table align=center cellspacing=0 width=100%>
      <tr>
      <td class="summary-title">
      	&nbsp; <a href='index.asp'><%=NetName%></a> → <a href="2j.asp?id=<%=Classid%>"><%=Qcdn.Classlist(Classid)%></a> → <%=Qcdn.Classlist(Nclassid)%>
      </td>
      </tr>
        <tr >
          <td valign=top class="tdbg"> <br>
            <center class="aTitle">
              <br>
              <%=Qcdn.HTMLcode(title)%>
            </center>

            <table width=100% >
              <tr>
                <td></td>
                <td>
                  <%
      		if AddWriter then
      			Response.write("作者：<span id=AuthorLabel>")
      			if writer<>"" then
      				response.Write(writer)
      				response.write("</span>")
      			end if
      		end if
      		if ad = 1 then
      			if Session("flag") = "" or Session("Admin_Name") = "" then
      				Session("flag") = ""
      				Session("Admin_Name") = ""
      				Errmsg = "<li>你没有登录系统。<li>你以登陆超时。<li><a href=admin_index.asp>点击这里重新登陆</a>"
      				call Qcdn.Err_List(errmsg,1)
      				Response.end
      			end if
      			Response.write("<a href='list.asp?unid="& Unid &"&method=2'>审核</a>&nbsp;&nbsp;<a href='list.asp?unid="& Unid &"&method=3'>修改</a>")
      		end if
      		%>
                  <br>
                </td>
              </tr>
            </table>
            <span id="ContentBody" class="content" style="display:block;padding:0px 2px"><%
      	  Call htmlDeCode_(content)
      	  response.Write content

      	  %>
              <script>SyntaxHighlighter.all()</script>
            <div style='width:100%;text-align:right;'></div>
            </span><br>
            <br>
            <table width="100%" cellpadding=0 cellspacing=0 style="table-layout:fixed;word-break:break-all">
              <tr>
                <td ></td>
                <td width="150"> 来源：<span id="SourceLabel">
                  <%if writefrom<>"" then response.Write(writefrom)%>
                  </span><br>
                  阅读：<span id="HitsLabel"><%=hits%></span> 次<br>
                  日期：<span id="TimeLabel"><%=Intime%></span><br>
                  <br>
                </td>
              <tr>
                <td colspan=2 align=right>
                  <%
      	if AddScroll then
      		Response.write "<script language=JavaScript>"
      		Response.write "var currentpos,timer;"
      		Response.write "function initializeScroll() { timer=setInterval('scrollwindow()',80);} "
      		Response.write "function scrollclear(){clearInterval(timer);}"
      		Response.write "function scrollwindow() "
      		Response.write "{currentpos=document.body.scrollTop;window.scroll(0,++currentpos);"
      		Response.write "if (currentpos != document.body.scrollTop) sc();}"
      		Response.write "document.onmousedown=scrollclear;"
      		Response.write "document.ondblclick=initializeScroll;"
      		Response.write "</script>"
      		Response.write "【 双击滚屏 】&nbsp;"
      	end if
      	if EmailFlag<>0 then
      		Response.write "【 <a href=Sendmail.asp?Unid="& Unid &" target=_blank>推荐朋友</a> 】&nbsp;"
      	end if
      	if AddComment then
      		Response.write "【 <a href=remarkList.asp?Unid="& Unid &" target=_blank>评论</a> 】&nbsp;"
      	end if
      	if AddFavorite then
      		Response.write "【 <A href=""javascript:window.external.AddFavorite('"& NetUrl &"/list.asp?Unid="& Unid &"','"& Replace(Replace(title,"'",""),"""","") &"')"">收藏</a> 】&nbsp;"
      	end if
      	if AddPrint then
      		Response.write "【 <A href='javascript:window.print()'>打印</a> 】&nbsp;"
      	end if
      	if AddClose then
      		Response.write "【 <A href='javascript:window.close()'>关闭</a> 】"
      	end if
      	%>
                  【 字体：<a href="javascript:ContentSize(16)">大</a> <a href="javascript:ContentSize(14)">中</a>
                  <a href="javascript:ContentSize(12)">小</a> 】&nbsp; </td>
              </tr>
            </table>
            <table width=97% align=center>
              <tr>
                <td>
                  <%
      		sql = "Select Unid,title from article_info where Unid = "& Unid-1
      		Set Rs = conn.execute(sql)
      		if Rs.eof and Rs.bof then
      			Response.write "上一篇：已经没有了。"
      		else
      			Response.write "上一篇：<a href=list.asp?unid="& rs(0) &">"& Qcdn.HTMLcode(rs(1)) &"</a>"
      		end if
      		%>
                  <br>
                  <%
      		rs.close
      		sql = "Select Unid,title from article_info where Unid = "& Unid+1
      		Set Rs = conn.execute(sql)
      		if Rs.eof and Rs.bof then
      			Response.write "下一篇：已经没有了。"
      		else
      			Response.write "下一篇：<a href=list.asp?unid="& rs(0) &">"& Qcdn.HTMLcode(rs(1)) &"</a>"
      		end if
      		rs.close
      		%>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tbody id="printHide" name="printHide" >
        <tr>
          <td class="summary-title">&nbsp; &gt;&gt; 相关文章 </td>
        </tr>
        <tr valign=top class="tdbg">
          <td style="padding:5px 2px">&nbsp;
            <%
      	sql = "Select top 8 Unid,title from article_info where Nkey = '"& Nkey &"' and Audit = 0 and  Unid<>"& Unid &" order by Unid desc"
      	Set Rs = conn.execute(sql)
      	if Rs.eof and Rs.bof then
      		Response.Write("没有相关文章。")
      	else
      		do while not rs.eof
      			Response.Write("<div style=line-height:150% align=left>&nbsp;&nbsp;")
      			Response.Write bullet & "<a href=list.asp?Unid="& rs(0) &">" & rs(1)
      			Response.Write("</a></div>")
      		rs.movenext
      		loop
      	end if
      	rs.close
      	%>
          </td>
        </tr>
        <%if AddComment then%>
        <tr>
          <td align=center class="summary-title"> 发表评论 </td>
        <tr>
          <form name="remarkForm" action="" method="post" onSubmit="return checkRemark();">
            <input type="hidden" name="articleid" value="<%=Unid%>">
            <td class="tdbg">
              <table width=100% cellpadding=5 cellspacing=0 border=0>
                <tr>
                  <td>
                    <script>
      			function checkRemark()
      			{
      			var form=document.all.remarkForm;
      			if (form.content.value=="")
      			{	alert("请填写评论内容");
      				form.content.focus();
      				return false;
      			}
      			if (form.username.value=="")
      			{	alert("请填写姓名");
      				form.username.focus();
      				return false;
      			}
      			if (form.content.value.length>200)
      			{	alert("评论内容不可以超过200字");
      				form.content.focus();
      				return false;
      			}
      			if (form.username.value.length>10)
      			{	alert("姓名不可以超过10个字");
      				form.username.focus();
      				return false;
      			}
      			form.submit.disabled=true;
      			return true;
      			}
      			function showLen(obj)
      			{
      				document.all.bodyLen.innerText=obj.value.length;
      			}
      			</script>
                    <input type="radio" name="face" value="1" true>
                    <img src=image/face/face1.gif>
                    <input type="radio" name="face" value="2">
                    <img src=image/face/face2.gif>
                    <input type="radio" name="face" value="3">
                    <img src=image/face/face3.gif>
                    <input type="radio" name="face" value="4">
                    <img src=image/face/face4.gif>
                    <input type="radio" name="face" value="5">
                    <img src=image/face/face5.gif>
                    <input type="radio" name="face" value="6">
                    <img src=image/face/face6.gif>
                    <input type="radio" name="face" value="7">
                    <img src=image/face/face7.gif>
                    <input type="radio" name="face" value="8">
                    <img src=image/face/face8.gif>
                    <input type="radio" name="face" value="9">
                    <img src=image/face/face9.gif><br>
                    <input type="radio" name="face" value="10">
                    <img src=image/face/face10.gif>
                    <input type="radio" name="face" value="11">
                    <img src=image/face/face11.gif>
                    <input type="radio" name="face" value="12">
                    <img src=image/face/face12.gif>
                    <input type="radio" name="face" value="13">
                    <img src=image/face/face13.gif>
                    <input type="radio" name="face" value="14">
                    <img src=image/face/face14.gif>
                    <input type="radio" name="face" value="15">
                    <img src=image/face/face15.gif>
                    <input type="radio" name="face" value="16">
                    <img src=image/face/face16.gif>
                    <input type="radio" name="face" value="17">
                    <img src=image/face/face17.gif>
                    <input type="radio" name="face" value="18">
                    <img src=image/face/face18.gif><br>
                    点&nbsp;&nbsp;评：
                    <textarea name="content" cols="40" Rows="4" onKeyDown="showLen(this)" onKeyUp="showLen(this)"></textarea>
                    字数<span id="bodyLen">0</span> <br>
                    <%
      			if Request.Cookies("qcdn")("user_name")="" then
      				Response.write("用户名：&nbsp;<input type=text name='username' value='' MaxLength=50 size=10>")
      				Response.write("&nbsp;密码：")
      				Response.write("<input type=password name='password' value='' MaxLength=50 size=10>")
      			else
      				Response.write("<input type=hidden name=username value='"& Request.Cookies("qcdn")("user_name") &"'>")
      				Response.write("<input type=hidden name=password value='"& Request.Cookies("qcdn")("password") &"'>")
      			end if
      			%>
                    <input type=submit name=submit value=" 发 表 " >
                    <br>
                    <br>
                  </td>
                  <td width=350>
                    <ul style="list-style-type:square;margin-left:1em;line-height:150%">
                      <li>尊重网上道德，遵守中华人民共和国的各项有关法律法规
                      <li> 承担一切因您的行为而直接或间接导致的民事或刑事法律责任
                      <li> 本站管理人员有权保留或删除其管辖留言中的任意内容
                      <li> 本站有权在网站内转载或引用您的评论
                      <li> 参与本评论即表明您已经阅读并接受上述条款
                    </ul>
                  </td>
                </tr>
              </table>
            </td>
            <input type="hidden" name="method" value="1">
          </form>
        </tr>
        <%end if%>
        </tbody>
      </table>
      </div>
      </div>
      </div>
      </div>


<!--#include file="copy.asp"-->