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
		response.write "<script>alert(""1������û��ע�ᣡ\n\n2��������û��������룡"");location.href=""UserReg.asp"";</script>"
		rs.close : set rs = nothing
		response.end
	else
		sql = "Insert into article_remark(articleid,username,content,faceid,intime,ip)values("& articleid &",'"& username &"','"& content &"',"& face &",Now(),'"& ip &"')"
		conn.execute(sql)
		Response.write "<script>alert(""���۷����ɹ�"");location.href=""remarkList.asp?unid="& articleid &""";</script>"
		response.end
	end if
elseif Request("method") = 2 then
	if Session("flag") = "" or Session("Admin_Name") = "" then
		Session("flag") = ""
		Session("Admin_Name") = ""
		Errmsg = "<li>�㲻��ϵͳ����Ա��"
		call Qcdn.Err_List(errmsg,1)
		Response.end
	end if
	unid = CLng(Request("unid"))
	Unid = qcdn.sqlcheck(Unid)
	sql = "update article_info set Audit = 0 where Unid in ("& unid &")"
	conn.execute(sql)
	Response.Write("<script>alert(""��˳ɹ�"");window.opener.location.reload();window.close();</script>")
	Response.End()
elseif Request("method") = 3 then
	unid = CLng(Request("unid"))
	Response.Write("<script>window.opener.location.href=""admin_newsedit.asp?unid="&Unid &""";window.close();</script>")
	Response.End()
end if
if Request("Unid") = "" then
	Errmsg = "<li>�����쳣����<li>���ݵ����±��Ϊ�ա�"
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
	Errmsg = "<li>�����쳣����<li>������Ϊ: error 108��<li>��͹���Ա��ϵ������⡣"
	call Qcdn.Err_List(errmsg,3)
	Response.End()
else
	Popedom = Rs(9)
	if AddPopedom then
		if Popedom = 1 then
			if Request.Cookies("qcdn")("user_name") = "" then
				Response.write ("<script>alert(""������ǻ�Ա�����½�������"");window.close();</script>")
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
<html xmlns="http://www.w3.org/1999/xhtml"><HEAD><TITLE><%=Qcdn.HTMLcode(title)%>- <%=Qcdn.Classlist(Classid)%>,<%=netName%>-��������</TITLE>
<meta name="description" content="���ڴ������������,רҵ�ṩ��������,����ע��,��ҵ�ʾ�,��վ�ƹ�,����ʵ������ҵ��������֧������֧����ʵʱע�ᣬʵʱ��ͨ����������"><meta name="keywords" content="><%=Qcdn.HTMLcode(title)%>- <%=Qcdn.Classlist(Classid)%>,<%=netName%>,��������,��ҳ����,����ע��,����,��ҵ�ʾ�,��ҳ�ռ�,������ҳ,����ʵ��,�����й�,��վ����,����"><META content="text/html; charset=gb2312" http-equiv=Content-Type>
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
 <li><a href="/">��ҳ</a></li>
      <li><a href="/customercenter/">�ͷ�����</a></li>
      <li><a href="/faq/">��������</a></li>
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
      	&nbsp; <a href='index.asp'><%=NetName%></a> �� <a href="2j.asp?id=<%=Classid%>"><%=Qcdn.Classlist(Classid)%></a> �� <%=Qcdn.Classlist(Nclassid)%>
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
      			Response.write("���ߣ�<span id=AuthorLabel>")
      			if writer<>"" then
      				response.Write(writer)
      				response.write("</span>")
      			end if
      		end if
      		if ad = 1 then
      			if Session("flag") = "" or Session("Admin_Name") = "" then
      				Session("flag") = ""
      				Session("Admin_Name") = ""
      				Errmsg = "<li>��û�е�¼ϵͳ��<li>���Ե�½��ʱ��<li><a href=admin_index.asp>����������µ�½</a>"
      				call Qcdn.Err_List(errmsg,1)
      				Response.end
      			end if
      			Response.write("<a href='list.asp?unid="& Unid &"&method=2'>���</a>&nbsp;&nbsp;<a href='list.asp?unid="& Unid &"&method=3'>�޸�</a>")
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
                <td width="150"> ��Դ��<span id="SourceLabel">
                  <%if writefrom<>"" then response.Write(writefrom)%>
                  </span><br>
                  �Ķ���<span id="HitsLabel"><%=hits%></span> ��<br>
                  ���ڣ�<span id="TimeLabel"><%=Intime%></span><br>
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
      		Response.write "�� ˫������ ��&nbsp;"
      	end if
      	if EmailFlag<>0 then
      		Response.write "�� <a href=Sendmail.asp?Unid="& Unid &" target=_blank>�Ƽ�����</a> ��&nbsp;"
      	end if
      	if AddComment then
      		Response.write "�� <a href=remarkList.asp?Unid="& Unid &" target=_blank>����</a> ��&nbsp;"
      	end if
      	if AddFavorite then
      		Response.write "�� <A href=""javascript:window.external.AddFavorite('"& NetUrl &"/list.asp?Unid="& Unid &"','"& Replace(Replace(title,"'",""),"""","") &"')"">�ղ�</a> ��&nbsp;"
      	end if
      	if AddPrint then
      		Response.write "�� <A href='javascript:window.print()'>��ӡ</a> ��&nbsp;"
      	end if
      	if AddClose then
      		Response.write "�� <A href='javascript:window.close()'>�ر�</a> ��"
      	end if
      	%>
                  �� ���壺<a href="javascript:ContentSize(16)">��</a> <a href="javascript:ContentSize(14)">��</a>
                  <a href="javascript:ContentSize(12)">С</a> ��&nbsp; </td>
              </tr>
            </table>
            <table width=97% align=center>
              <tr>
                <td>
                  <%
      		sql = "Select Unid,title from article_info where Unid = "& Unid-1
      		Set Rs = conn.execute(sql)
      		if Rs.eof and Rs.bof then
      			Response.write "��һƪ���Ѿ�û���ˡ�"
      		else
      			Response.write "��һƪ��<a href=list.asp?unid="& rs(0) &">"& Qcdn.HTMLcode(rs(1)) &"</a>"
      		end if
      		%>
                  <br>
                  <%
      		rs.close
      		sql = "Select Unid,title from article_info where Unid = "& Unid+1
      		Set Rs = conn.execute(sql)
      		if Rs.eof and Rs.bof then
      			Response.write "��һƪ���Ѿ�û���ˡ�"
      		else
      			Response.write "��һƪ��<a href=list.asp?unid="& rs(0) &">"& Qcdn.HTMLcode(rs(1)) &"</a>"
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
          <td class="summary-title">&nbsp; &gt;&gt; ������� </td>
        </tr>
        <tr valign=top class="tdbg">
          <td style="padding:5px 2px">&nbsp;
            <%
      	sql = "Select top 8 Unid,title from article_info where Nkey = '"& Nkey &"' and Audit = 0 and  Unid<>"& Unid &" order by Unid desc"
      	Set Rs = conn.execute(sql)
      	if Rs.eof and Rs.bof then
      		Response.Write("û��������¡�")
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
          <td align=center class="summary-title"> �������� </td>
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
      			{	alert("����д��������");
      				form.content.focus();
      				return false;
      			}
      			if (form.username.value=="")
      			{	alert("����д����");
      				form.username.focus();
      				return false;
      			}
      			if (form.content.value.length>200)
      			{	alert("�������ݲ����Գ���200��");
      				form.content.focus();
      				return false;
      			}
      			if (form.username.value.length>10)
      			{	alert("���������Գ���10����");
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
                    ��&nbsp;&nbsp;����
                    <textarea name="content" cols="40" Rows="4" onKeyDown="showLen(this)" onKeyUp="showLen(this)"></textarea>
                    ����<span id="bodyLen">0</span> <br>
                    <%
      			if Request.Cookies("qcdn")("user_name")="" then
      				Response.write("�û�����&nbsp;<input type=text name='username' value='' MaxLength=50 size=10>")
      				Response.write("&nbsp;���룺")
      				Response.write("<input type=password name='password' value='' MaxLength=50 size=10>")
      			else
      				Response.write("<input type=hidden name=username value='"& Request.Cookies("qcdn")("user_name") &"'>")
      				Response.write("<input type=hidden name=password value='"& Request.Cookies("qcdn")("password") &"'>")
      			end if
      			%>
                    <input type=submit name=submit value=" �� �� " >
                    <br>
                    <br>
                  </td>
                  <td width=350>
                    <ul style="list-style-type:square;margin-left:1em;line-height:150%">
                      <li>�������ϵ��£������л����񹲺͹��ĸ����йط��ɷ���
                      <li> �е�һ����������Ϊ��ֱ�ӻ��ӵ��µ����»����·�������
                      <li> ��վ������Ա��Ȩ������ɾ�����Ͻ�����е���������
                      <li> ��վ��Ȩ����վ��ת�ػ�������������
                      <li> ���뱾���ۼ��������Ѿ��Ķ���������������
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