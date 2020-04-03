<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->

<%
if request("Unid") = "" then
	Errmsg = "<li>发现异常错误。<li>传递的文章编号为空。"
	call Qcdn.Err_List(errmsg,3)
	Response.End()
else
	Unid = Cint(request("Unid"))
end if

Sql = "Select title,content,Nclassid,classid,Nkey,hits,writer,writefrom,Intime from article_info where Unid = " & Unid 
Set Rs = conn.execute(Sql)
if Rs.eof and Rs.bof then
	Errmsg = "<li>发现异常错误。<li>错误编号为: error 108。<li>请和数码在线联系解决问题。"
	call Qcdn.Err_List(errmsg,3)
	Response.End()
else
	Conn.execute("Update article_info set hits=hits+1 where Unid = " & Unid)
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


%>

<HTML><HEAD><TITLE>打印文章：<%=Qcdn.HTMLcode(title)%></TITLE>
<meta name="description" content="<%=Qcdn.HTMLcode(title)%> -国内大型网络服务商,专业提供虚拟主机,域名注册,企业邮局,网站推广,网络实名等企业上网服务。200M虚拟主机200元，国际域名80元,国内cn域名240元，赠送企业邮局、20个二级域名。支持在线支付，实时注册，实时开通，自主管理。"><meta name="keywords" content="<%=Qcdn.HTMLcode(title)%>,虚拟主机,网页制作,域名注册,主机,企业邮局,主页空间,个人主页,网络实名,主机托管,网站建设,域名"><META content="text/html; charset=gb2312" http-equiv=Content-Type>
<link href="<%=CssDir%>style.css" rel="stylesheet" type="text/css">
</head>


<body leftmargin="0" topmargin="0" >

<script language="JavaScript" type="text/JavaScript">
<!--

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="#000000"><img src="/Template/Tpl_01/images/spacer.gif" width="3" height="3"></td>
  </tr>
</table>

<br>

<script language=javascript>
function ContentSize(size)
{
	var obj=document.all.ContentBody;
	obj.style.fontSize=size+"px";
}
</script>
<table class="twidth" align=center cellspacing=0>
  <tr> 
    <td class="summary-title"> &nbsp; <a href='index.asp'><%=NetName%></a> → <a href="2j.asp?id=<%=Classid%>"><%=Qcdn.Classlist(Classid)%></a> 
      → <%=Qcdn.Classlist(Nclassid)%> </td>
  </tr>
  <tr > 
    <td valign=top class="tdbg"> <br>
      <center class="aTitle">
        <%=Qcdn.HTMLcode(title)%> 
      </center>
      <table width=100% >
        <tr> 
          <td width=600 ></td>
          <td> <span id="AuthorLabel"> 
<%
Response.write "【 <A href='javascript:window.print()'>打印</a> 】&nbsp;"

%>
            </span><br>
          </td>
        </tr>
      </table>
      <span id="ContentBody" class="content" style="display:block;padding:0px 10px"> 
      <%
	If datediff("d",Intime,"2004-11-4")>0  Then
		Response.write content
	else
		Response.write Qcdn.UBBCode(content)
	End If
	%>
      <br>
      <div style='width:100%;text-align:right;'></div>
      </span> 
      <div align="center"><br>
        <br>
      </div>
    </td>
  </tr>
  <tbody id="printHide" name="printHide" > 
  <%if AddComment then%>
  <%end if%>
  </tbody> 
</table>

</body>

</html>