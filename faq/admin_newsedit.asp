<!--#include file="admin_head.asp"-->
<br><br>
<%
if request("method") = 1 then
	if Request("Unid") = "" then
		Errmsg = "<li>发现异常错误。<li>错误编号为: error 105。<li>请和数码在线联系解决问题。"
		FoundErr = true
	else
		Unid = Request("Unid")
	end if 
	if Request("Classid") = "" or Request("Nclassid") = "" then
		Errmsg = Errmsg + "<li>请选择文章所属的大栏目及小栏目。"
		FoundErr = true
	else
		Classid = Request("Classid")
		Nclassid = Request("Nclassid")
	end if
	if Trim(Request.Form("title")) = "" then
		Errmsg = Errmsg + "<li>请输入文章标题。"
		FoundErr = true
	else
		Title = Qcdn.checkStr(Trim(Request.Form("title")))
	end if
	
	if Trim(Request.Form("content")) = "" then
		Errmsg = Errmsg + "<li>请输入文章内容。"
		FoundErr = true
	else
		'Content = Qcdn.checkStr(Trim(Request.Form("content")))
		Content = Request.Form("content")
	'	Call htmlEnCode_(Content)
	end if
	if Qcdn.StrLength(Request.Form("synopsis"))>255 then
		Errmsg = Errmsg + "<li>输入的文章简介大于255字符的范围。"
		FoundErr = true
	else
		synopsis = Qcdn.checkStr(Trim(Request.Form("synopsis")))
	end if
	if Trim(Request.Form("nkey")) = "" then
		Errmsg = Errmsg + "<li>请输入相关文章。"
		FoundErr = true
	else
		nkey = Qcdn.checkStr(Trim(Request.Form("nkey")))
	end if
	if FoundErr then
		Call Qcdn.Err_List(Errmsg,1)
		Response.End()
	end if
	Intime = Request("year1") & "-" & Request("month1") & "-" & Request("day1")
	writer = Qcdn.checkStr(Trim(Request.Form("writer")))
	writefrom = Qcdn.checkStr(Trim(Request.Form("writefrom")))
	if Trim(Request.form("vouch")) = 1 then
		vouch = Now()&Time()
	else
		vouch = Trim(Request.form("vouch"))
	end if
	if Trim(Request.form("DefaultPic")) <> "" then
		pic = 1
		DefaultPic = Trim(Request.form("DefaultPic"))
	else
		pic = Request.Form("pic")
		DefaultPic = Trim(Request.form("DefaultPic"))
	end if
	Popedom = Request.Form("Popedom")

	Unid = clng(Unid)
	classid = clng(classid)



set rs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from article_info  where Unid = " & Unid
rs.open sql,conn,1,3
'rs.addnew
rs("content")=content
rs("title")=title
rs("nclassid")=nclassid
rs("classid")=classid
rs("nkey")=nkey
rs("Intime")=Intime
rs("writer")=writer
rs("writefrom")=writefrom
rs("author")=author
rs("flag")=0
rs("pic")=pic
rs("DefaultPic")=DefaultPic
rs("synopsis")=synopsis
rs("vouch")=vouch
rs("Popedom")=Popedom

rs.update
	'Sql = "Update article_info set content = '"& content &"',title = '"& title &"',nclassid = "& nclassid &",classid = "
	'Sql = Sql & classid & ",nkey = '"& nkey &"',Intime = '"& Intime &"',writer = '"& writer &"',writefrom = '"& writefrom &"',pic = "& pic &",DefaultPic = '"& DefaultPic &"',synopsis = '"& synopsis &"',vouch = '"& vouch &"',Popedom = "& Popedom &" where Unid = " & Unid
	'Conn.execute(Sql)
	Response.Write("<script>alert(""修改成功"");location.href=""admin_newsedit.asp?Unid=" & unid & """;</script>")
	Response.End()
end if
sql = "select * from article_class where flag <>0 order by Unid asc"
set rs = conn.execute(sql)
%>
<script language = "JavaScript">
var onecount;
onecount=0;
subcat = new Array();
        <%
        count = 0
        do while not rs.eof 
        %>
subcat[<%=count%>] = new Array("<%=Qcdn.HTMLcode(rs(1))%>","<%=rs(2)%>","<%=rs(0)%>");
        <%
        count = count + 1
        rs.movenext
        loop
        rs.close
        %>
onecount=<%=count%>;

function changelocation(locationid)
    {
    document.form1.Nclassid.length = 0; 

    var locationid=locationid;
    var i;
    for (i=0;i < onecount; i++)
        {
            if (subcat[i][1] == locationid)
            { 
                document.form1.Nclassid.options[document.form1.Nclassid.length] = new Option(subcat[i][0], subcat[i][2]);
            }        
        }
        
    }    
</script>
<script src="inc/forms.js"></script>
<%
Unid = Request("unid")
Sql = "Select title,content,classid,nclassid,Intime,writer,writefrom,nkey,pic,DefaultPic,synopsis,vouch,Popedom from article_info where Unid = " & Unid
set Rs = conn.execute(Sql)
if not rs.eof then
	title = rs(0)
	content = server.HTMLEncode(rs(1))
	newContent = rs(1)
	classid = rs(2)
	nclassid = rs(3)
	Intime = rs(4)
	writer = rs(5)
	writefrom = rs(6)
	nkey = rs(7)
	pic = rs(8)
	DefaultPic = rs(9)
	synopsis = rs(10)
	vouch = rs(11)
	Popedom = rs(12)
end if
rs.close
Call htmlDeCode_(newContent)
%>

<table width="95%" border="1" cellspacing="0" cellpadding="3" align="center" bordercolorlight="#ECEEE4" bordercolordark="#CCCABC">
  <form action="?" name="form1" method="post" onsubmit="return check1();">
  <input type="hidden" name="Unid" value="<%=Unid%>">
    <tr> 
      <td colspan="2" align="center" height="30" background="image/tablebg.gif"><b>修 
        改 文 章 内 容 </b> </td>
    </tr>
    <tr valign="middle"> 
      <td width="15%" height="25">栏目选择：</td>
      <td width="85%" height="25">
	  	<%			
					sql = "select Unid,classname from article_class where flag = 0 order by Unid asc"
					set rs = conn.execute(sql)
					if rs.eof and rs.bof then
						response.write "请先添加栏目。"
						response.end
					else
					%>
              <select name="classid" onChange="changelocation(document.form1.classid.options[document.form1.classid.selectedIndex].value)" size="1">
                <%do while not rs.eof%>
                <option value="<%=rs(0)%>" <%if Cint(classid) = Cint(rs(0)) then response.Write("selected")%>><%=Qcdn.HTMLcode(rs(1))%></option>
                <%
        				rs.movenext
       					loop
						end if
       					rs.close
        				set rs = nothing
						%>
              </select>
		&nbsp;
		<select name="Nclassid" size="1">
                <%
	sql = "select * from article_class where flag = "& Classid &" order by Unid asc"
 	set rs = conn.execute(sql)
	if not rs.eof then
        do while not rs.eof
        if cint(nclassid)=cint(rs(0)) then
               sel="selected"
        else
               sel=""
        end if	
        response.write "<option " & sel & " value='" +  Cstr(rs(0)) + "'>" + rs(1) + "</option>"
        rs.MoveNext
        Loop
	end if
        rs.close
%>
              </select> <font color="red">*</font></td>
    </tr>
    <tr valign="middle"> 
      <td height="25">文章标题：</td>
      <td height="25">
	  <SELECT name=select4 onchange=Dotitle(this.options[this.selectedIndex].value)>
              <OPTION selected value="">选择</OPTION> <OPTION value=[原创]>[原创]</OPTION> 
              <OPTION value=[转帖]>[转帖]</OPTION> 
              <OPTION value=[讨论]>[讨论]</OPTION> 
              <OPTION value=[推荐]>[推荐]</OPTION> <OPTION value=[公告]>[公告]</OPTION> 
              <OPTION value=[注意]>[注意]</OPTION>
              <OPTION value=[分享]>[分享]</OPTION></SELECT>
	  <input name="title" type="text" value="<%=Qcdn.HTMLcode(title)%>" size="65" maxlength="50"> <font color="red">*</font>
      </td>
    </tr>
<!--    <tr valign="middle">
      <td height="25">上传图片：</td>
      <td height="25">
	  <iframe name="upload" src="admin_upload.asp" width="300" height="25" frameborder=0 scrolling=no></iframe>
	  </td>
    </tr>
	<%
	if LoadFiles then
	%>
	<tr valign="middle">
      <td height="25">上传附件：</td>
      <td height="25">
	  <iframe name="ad" src="admin_uploadF.asp" width="300" height="25" frameborder=0 scrolling=no></iframe>
	  </td>
    </tr>
	<%
	end if
	%>
-->
	<tr valign="middle">
      <td height="25">默认图片：</td>
      <td height="25">
	  <input type="text" name="DefaultPic" size="65" value="<%=DefaultPic%>">
	  </td>
    </tr>
    <tr valign="middle"> 
      <td height="25">发布日期：</td>
      <td height="25"> <select name="year1">
          <option value="<%=year(intime)%>" selected><%=year(Intime)%></option>
          <%
					for i=year(now())-5 to year(now())
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        年 
        <select name="month1">
          <option value="<%=month(Intime)%>" selected><%=month(Intime)%></option>
          <%
					for i=1 to 12
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        月 
        <select name="day1">
          <option value="<%=day(Intime)%>" selected><%=day(Intime)%></option>
          <%
					for i=1 to 31
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        日</td>
    </tr>
	<tr valign="middle"> 
      <td height="25">文章内容：</td>
      <td height="25">
	  <script type="text/plain" id="editor" style="width:800px;"></script><textarea style="display:none" name="content"></textarea>
	  </td>
    </tr>
	<tr valign="middle"> 
      <td height="25">文章简介：<br>（纯文本）</td>
      <td height="25"><textarea name="synopsis" rows="3" cols="75" id="synopsis"><%=synopsis%></textarea>（限255字符）</td>
    </tr>
    <tr valign="middle"> 
      <td height="25">相关文章：</td>
      <td height="25"><input name="nkey" type="text" id="nkey" value="<%=nkey%>" size="50" maxlength="50">
	    <select name="select" onchange=Dokey(this.options[this.selectedIndex].value)>
          <option value="" selected></option>
          <%Call Qcdn.OptionList(1)%>
        </select> <font color="red">*</font></td>
    </tr>
    <tr valign="middle"> 
      <td height="25">作&nbsp;&nbsp;&nbsp;&nbsp;者：</td>
      <td height="25"><input name="writer" type="text" id="writer" value="<%=writer%>" size="50" maxlength="50"> 
        <select name="select2" onChange=Dowriter(this.options[this.selectedIndex].value)>
          <option value="" selected></option>
          <%Call Qcdn.OptionList(2)%>
        </select> </td>
    </tr>
    <tr valign="middle"> 
      <td height="25">来&nbsp;&nbsp;&nbsp;&nbsp;源：</td>
      <td height="25"><input name="writefrom" type="text" id="writefrom" value="<%=writefrom%>" size="50" maxlength="50"> 
        <select name="select3" onChange=Dowritefrom(this.options[this.selectedIndex].value)>
          <option value="" selected></option>
          <%Call Qcdn.OptionList(3)%>
        </select> </td>
    </tr>
    <tr valign="middle"> 
      <td height="25">包含图片：</td>
      <td height="25"> 是 <input type="radio" name="pic" value="1" <%if Pic = 1 then response.write "checked"%>> 否 <input type="radio" name="pic" value="0" <%if Pic = 0 then response.write "checked"%>>（在标题前面显示[图文]标志，热门文章、最新文章中不显示）</td>
    </tr>
	<tr valign="middle"> 
      <td height="25">是否推荐：</td>
      <td height="25"> 是 <input type="radio" name="vouch" value="1" <%if vouch <> "0" then response.write "checked"%>> 否 <input type="radio" name="vouch" value="0" <%if vouch = "0" then response.write "checked"%>>（推荐文章需包含默认图片，显示在首页）</td>
    </tr>
	<tr valign="middle"> 
      <td height="25">是否会员浏览：</td>
      <td height="25">
	  <%if AddPopedom then
			Response.Write("是 <input type=radio name=Popedom value=1")
				if Popedom = 1 then Response.write (" checked")
			Response.write("> 否 <input type=radio name=Popedom value=0")
				if Popedom = 0 then Response.write (" checked")
			Response.write(">")
	    else
			Response.Write("<font color=red>系统停止了分权限浏览的功能。</font>")
			Response.Write("<input type=hidden name=Popedom value=0>")
		end if
	  %>
	  </td>
    </tr>
    <tr> 
      <td height="25" colspan="2" align="center"> <input type="submit" name="Submit" value=" 提 交 " class="tbutton"> 
        <input type="reset" name="Submit2" value=" 重 置 " class="tbutton"> </td>
    </tr>
	<input type="hidden" name="method" value="1">
  </form>
</table>
<div id="hisContent" style="display:none"><%=newContent%></div>
<script type="text/javascript">
    var ue = new baidu.editor.ui.Editor({
		autoHeightEnabled : false,
		autoFloatEnabled : false
	});
    ue.render('editor');
	ue.setContent(document.getElementById("hisContent").innerHTML);

function check1(){
	if (form1.classid.value =="" || form1.Nclassid.value==""){
	alert("请选择栏目");
	return false;
	}
	if (form1.title.value ==""){
	alert("请输入标题");
	form1.title.focus();
	return false;
	}
	if (!ue.hasContents()){
	alert("请输入内容");
	return false;
	}
	if (form1.nkey.value ==""){
	alert("请输入相关文章");
	form1.nkey.focus();
	return false;
	}
	form1.content.value=ue.getContent();
	return true;
}
</script>
<!--#include file="admin_copy.asp"-->