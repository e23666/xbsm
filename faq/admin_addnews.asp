<!--#include file="admin_head.asp"-->

<br><br>
<%
if request("method") = 1 then
	
	if Request("Classid") = "" or Request("Nclassid") = "" then
		Errmsg = "<li>��ѡ�����������Ĵ���Ŀ��С��Ŀ��"
		FoundErr = true
	else
		Classid = Request("Classid")
		Nclassid = Request("Nclassid")
	end if
	if Trim(Request.Form("title")) = "" then
		Errmsg = Errmsg + "<li>���������±��⡣"
		FoundErr = true
	else
		Title = Qcdn.checkStr(Trim(Request.Form("title")))
	end if

	if Trim(Request("content")) = "" then
		Errmsg = Errmsg + "<li>�������������ݡ�"
		FoundErr = true
	else
		'Content = Qcdn.checkStr(Trim(Request("content")))
		Content = Request.Form("content")
		'Call htmlEnCode_(Content)
	end if
	if Qcdn.StrLength(Request.Form("synopsis"))>255 then
		Errmsg = Errmsg + "<li>��������¼�����255�ַ��ķ�Χ��"
		FoundErr = true
	else
		synopsis = Qcdn.checkStr(Trim(Request.Form("synopsis")))
	end if
	if Trim(Request.Form("nkey")) = "" then
		Errmsg = Errmsg + "<li>������������¡�"
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
	Audit = Request.Form("Audit")
	Popedom = Request.Form("Popedom")

	nclassid=clng(nclassid)
	classid=clng(classid)
set rs=Server.CreateObject("adodb.recordset")
sql="select top 1 * from article_info"
rs.open sql,conn,1,3
rs.addnew
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

	'Sql = "Insert into article_info(content,title,nclassid,classid,nkey,Intime,writer,writefrom,author,flag,pic,DefaultPic,synopsis,vouch,Audit,Popedom)values('"& content &"','"
	'Sql = Sql & title & "',"& nclassid &","& classid &",'"& nkey &"','"& Intime &"','"& writer &"','"& writefrom &"','"& Session("Admin_Name") &"',0,"& pic &",'"& DefaultPic &"','"& synopsis &"','"& vouch &"',"& Audit &","& Popedom &")"
	'Conn.execute(Sql)
	Response.Write("<script>alert(""��ӳɹ�"");location.href=""admin_newslist.asp"";</script>")
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
<table width="95%" border="1" cellspacing="0" cellpadding="2" align="center" style="border-collapse:collapse" bordercolor="#003366">
  <form action="?" name="form1" method="post" onsubmit="return check1();">
    <tr> 
      <td colspan="2" align="center" height="30" background="image/tablebg.gif"><b>�� 
        �� �� �� �� �� </b> </td>
    </tr>
    <tr valign="middle"> 
      <td width="15%" align="right">��Ŀѡ��</td>
      <td width="85%" height="25">
	  	<%
					sql = "select Unid,classname from article_class where flag = 0 order by Unid asc"
					set rs = conn.execute(sql)
					if rs.eof and rs.bof then
						response.write "���������Ŀ��"
						response.end
					else
					%>
              <select name="classid" onChange="changelocation(document.form1.classid.options[document.form1.classid.selectedIndex].value)" size="1">
			    <option value="">ѡ����Ŀ</option>
                <%do while not rs.eof%>
                <option value="<%=rs(0)%>"><%=Qcdn.HTMLcode(rs(1))%></option>
                <%
        				rs.movenext
       					loop
						end if
       					rs.close
        				set rs = nothing
						%>
              </select>
		&nbsp;
		<select name="Nclassid">
          <option value="">ѡ����Ŀ</option>
        </select> <font color="red">*</font></td>
    </tr>
    <tr valign="middle"> 
      <td align="right">���±��⣺</td>
      <td height="25">
	  <SELECT name=select4 onchange=Dotitle(this.options[this.selectedIndex].value)>
              <OPTION selected value="">ѡ��</OPTION> <OPTION value=[ԭ��]>[ԭ��]</OPTION> 
              <OPTION value=[ת��]>[ת��]</OPTION> 
              <OPTION value=[����]>[����]</OPTION> 
              <OPTION value=[�Ƽ�]>[�Ƽ�]</OPTION> <OPTION value=[����]>[����]</OPTION> 
              <OPTION value=[ע��]>[ע��]</OPTION>
              <OPTION value=[����]>[����]</OPTION></SELECT>
	<input name="title" type="text" size="65" maxlength="50"> <font color="red">*</font>
      </td>
    </tr>
<!--    <tr valign="middle">
      <td height="25">�ϴ�ͼƬ��</td>
      <td height="25">
	  <iframe name="ad" src="admin_upload.asp" width="300" height="25" frameborder=0 scrolling=no></iframe>
	  </td>
    </tr>
	<%
	if LoadFiles then
	%>
	<tr valign="middle">
      <td height="25">�ϴ�������</td>
      <td height="25">
	  <iframe name="ad" src="admin_uploadF.asp" width="300" height="25" frameborder=0 scrolling=no></iframe>
	  </td>
    </tr>
	<%
	end if
	%>
-->
	<tr valign="middle">
      <td align="right">Ĭ��ͼƬ��</td>
      <td height="25">
	  <input type="text" name="DefaultPic" size="65">
	  </td>
    </tr>
    <tr valign="middle"> 
      <td align="right">�������ڣ�</td>
      <td height="25"> <select name="year1">
          <option value="<%=year(Now())%>" selected><%=year(Now())%></option>
          <%
					for i=2001 to 2005
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        �� 
        <select name="month1">
          <option value="<%=month(Now())%>" selected><%=month(Now())%></option>
          <%
					for i=1 to 12
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        �� 
        <select name="day1">
          <option value="<%=day(Now())%>" selected><%=day(Now())%></option>
          <%
					for i=1 to 31
						response.write "<option value='"&i&"'>"&i&"</option>"
					next
					%>
        </select>
        ��</td>
    </tr>
	<tr valign="middle"> 
      <td align="right">�������ݣ�</td>
      <td height="25">
	  <script type="text/plain" id="editor" style="width:800px;"></script><textarea style="display:none" name="content"></textarea>
	  </td>
    </tr>
	<tr valign="middle"> 
      <td align="right">���¼�飺<br>�����ı���</td>
      <td height="25"><textarea name="synopsis" rows="3" cols="75" id="synopsis"></textarea>����255�ַ���</td>
    </tr>
    <tr valign="middle"> 
      <td align="right">������£�</td>
      <td height="25"><input name="nkey" type="text" id="nkey" size="50" maxlength="50">
	    <select name="select" onchange="Dokey(this.options[this.selectedIndex].value)">
          <option value="" selected></option>
          <%Call Qcdn.OptionList(1)%>
        </select> <font color="red">*</font></td>
    </tr>
    <tr valign="middle"> 
      <td align="right">��&nbsp;&nbsp;&nbsp;&nbsp;�ߣ�</td>
      <td height="25"><input name="writer" type="text" id="writer" size="50" maxlength="50"> 
        <select name="select2" onChange=Dowriter(this.options[this.selectedIndex].value)>
          <option value="" selected></option>
          <%Call Qcdn.OptionList(2)%>
        </select> </td>
    </tr>
    <tr valign="middle"> 
      <td align="right">��&nbsp;&nbsp;&nbsp;&nbsp;Դ��</td>
      <td height="25"><input name="writefrom" type="text" id="writefrom" size="50" maxlength="50"> 
        <select name="select3" onChange=Dowritefrom(this.options[this.selectedIndex].value)>
          <option value="" selected></option>
          <%Call Qcdn.OptionList(3)%>
        </select> </td>
    </tr>
    <tr valign="middle"> 
      <td align="right">����ͼƬ��</td>
      <td height="25"> �� <input type="radio" name="pic" value="1"> �� <input type="radio" name="pic" value="0" checked>���ڱ���ǰ����ʾ[ͼ��]��־���������¡����������в���ʾ��</td>
    </tr>
	<tr valign="middle"> 
      <td align="right">�Ƿ��Ƽ���</td>
      <td height="25"> �� <input type="radio" name="vouch" value="1"> �� <input type="radio" name="vouch" value="0" checked>���Ƽ����������Ĭ��ͼƬ����ʾ����ҳ��</td>
    </tr>
	<tr valign="middle"> 
      <td align="right">�Ƿ���ˣ�</td>
      <td height="25">
	  <%if AddAuditing then
			Response.Write("�� <input type=radio name=Audit value=1> �� <input type=radio name=Audit value=0 checked>")
	    else
			Response.Write("<font color=red>ϵͳֹͣ����˹��ܡ�</font>")
			Response.Write("<input type=hidden name=Audit value=0>")
		end if
	  %>
	  </td>
    </tr>
	<tr valign="middle"> 
      <td align="right">�Ƿ��Ա�����</td>
      <td height="25">
	  <%if AddPopedom then
			Response.Write("�� <input type=radio name=Popedom value=1> �� <input type=radio name=Popedom value=0 checked>")
	    else
			Response.Write("<font color=red>ϵͳֹͣ�˷�Ȩ������Ĺ��ܡ�</font>")
			Response.Write("<input type=hidden name=Popedom value=0>")
		end if
	  %>
	  </td>
    </tr>
    <tr> 
      <td height="25" colspan="2" align="center"> <input type="submit" name="Submit" value=" �� �� " class="tbutton"> 
        <input type="reset" name="Submit2" value=" �� �� " class="tbutton"> </td>
    </tr>
	<input type="hidden" name="method" value="1">
  </form>
</table>
<script language="javascript">
    var ue = new baidu.editor.ui.Editor({
		autoHeightEnabled : false,
		autoFloatEnabled : false
	});
    ue.render('editor');
	//ue.setContent(document.getElementById("hisContent").innerHTML);

function check1(){
	if (form1.classid.value =="" || form1.Nclassid.value==""){
	alert("��ѡ����Ŀ");
	return false;
	}
	if (form1.title.value ==""){
	alert("���������");
	form1.title.focus();
	return false;
	}
	if (!ue.hasContents()){
	alert("����������");
	return false;
	}
	if (form1.nkey.value ==""){
	alert("�������������");
	form1.nkey.focus();
	return false;
	}
	form1.content.value=ue.getContent();
	return true;
}
</script>
<!--#include file="admin_copy.asp"-->