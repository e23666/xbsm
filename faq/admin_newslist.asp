<!--#include file="admin_head.asp"-->
<br><br>
<%
Select case Request("method")
	Case 1
		Call Delarticle()
	Case 2
		Call MoveClass()
End Select

	'-----�޸�ÿҳ��ʾ���� Start--------
	const MaxPerPage=10
	'-----�޸�ÿҳ��ʾ���� End  --------
   	dim totalPut
   	dim CurrentPage
	if not isempty(request("page")) then
      		currentPage=cint(request("page"))
   	else
      		currentPage=1
   	end if
	
	if Request("keyword") <> "" then
		
		ClassNo = Request("ClassNo")
		ClassNo1 = split(Request("ClassNo"),"|")
		Classid = ClassNo1(1)
		Nclassid = ClassNo1(0)
		keyword = Trim(Qcdn.checkStr(Request("keyword")))
	end if
%>
<table width="95%" border="1" cellspacing="0" cellpadding="3" align="center" bordercolorlight="#ECEEE4" bordercolordark="#CCCABC">
  <tr> 
    <td colspan="6" align="center" height="30" background="image/tablebg.gif"><b>�� 
      �� ɾ �� �� ��</b> </td>
  </tr>
  <tr align="center"> 
    <td height="25">ID</td>
    <td>����</td>
    <td>��������Ŀ</td>
    <td>���±���</td>
    <td>ʱ��</td>
  </tr>
  <tr> 
    <form name="newsearch" action="" method="post">
      <td height="25" colspan="5">���²��ң� 
        <select name="ClassNo">
          <%=Qcdn.ClassOptionlist()%> 
        </select>
        <input type="text" name="keyword" maxlength="50" size="30">
        <input type="submit" name="Submit2" value="�ύ">
      </td>
    </form>
  </tr>
  <tr> 
    <td height="25" colspan="5"> 
      <%
	set rs=server.createobject("adodb.recordset")
	if keyword <> "" then
		Sql = "Select Unid,Nclassid,title,author,Intime,pic,Audit,Popedom from article_info where flag = 0 and title like '%"& keyword &"%' and classid = "& classid &" and nclassid = "& nclassid &" order by Unid desc"
	else
		Sql = "Select Unid,Nclassid,title,author,Intime,pic,Audit,Popedom from article_info where flag = 0 order by Unid desc"
	end if
	
	rs.open sql,conn,1,1
 	if rs.eof and rs.bof then
		Response.Write "<center><font color=red>��û��������¡�</font></center>"
	else
		totalPut=rs.recordcount
      		if currentpage<1 then
          		currentpage=1
      		end if
      		if (currentpage-1)*MaxPerPage>totalput then
	   		if (totalPut mod MaxPerPage)=0 then
	     			currentpage= totalPut \ MaxPerPage
	  		else
	      			currentpage= totalPut \ MaxPerPage + 1
	   		end if
      		end if
       		if currentPage=1 then
           		showpage totalput,MaxPerPage,"admin_newslist.asp"
            		showContent
            		showpage totalput,MaxPerPage,"admin_newslist.asp"
       		else
          		if (currentPage-1)*MaxPerPage<totalPut then
            			rs.move  (currentPage-1)*MaxPerPage
            			dim bookmark
            			bookmark=rs.bookmark
           			showpage totalput,MaxPerPage,"admin_newslist.asp"
            			showContent
             			showpage totalput,MaxPerPage,"admin_newslist.asp"
        		else
	        		currentPage=1
           			showpage totalput,MaxPerPage,"admin_newslist.asp"
           			showContent
           			showpage totalput,MaxPerPage,"admin_newslist.asp"
	      		end if
	   		end if
		rs.close
		set rs = nothing	
   	end if 
	sub showContent
	dim i 
	   	i=0
	%>
    </td>
  </tr>
  <form action="" name="form1" method="post">
    <%do while not rs.eof%>
    <tr> 
      <td height="25" align="center"><%=rs(0)%></td>
      <td height="25" align="center"> 
        <input type="checkbox" name="newsid" value="<%=rs(0)%>">
      </td>
      <td height="25" align="center"><%=Qcdn.Classlist(rs(1))%></td>
      <td height="25"><a href="admin_newsedit.asp?Unid=<%=rs(0)%>"><%=Qcdn.HTMLcode(rs(2))%></a> 
        <%
	if rs(5) = 1 then	
		response.write "<img src=image/img.gif valign=absbottom>"
	end if
	if rs(6) = 1 then
		response.write("&nbsp;<img src=image/lock.gif valign=absbottom alt='δ��˵�����'>")
	end if
	if rs(7) = 1 then
		response.write("&nbsp;<img src=image/key.gif valign=absbottom alt='��Ȩ�޵�����'>")
	end if
	%>
      </td>
      <td align="center"><%=rs(4)%></td>
    </tr>
    <%
  i=i+1
	      if i>=MaxPerPage then exit do
  rs.movenext
  loop
  %>
    <tr> 
      <td height="25" colspan="5">���������ȫ��ѡ�� 
        <input type="checkbox" name="chkall" onClick="javascript:CheckAll(this.form)">
        <input onClick="{if(confirm('ȷ��ɾ��ѡ����������?\n\n���½��ȱ�ɾ��������վ�С�')){this.document.form1.submit();return true;}return false;}" type=submit value=ɾ�� name=action class="tbutton">
        &nbsp; 
        <input type="submit" name="Submit" value="��ѡ���������ƶ���" onClick="document.form1.method.value='2'" class="tbutton">
        <select name="moveid">
          <option value="">ת�Ƶ�..</option>
          <%Call Qcdn.ClassOptionlist()%>
        </select>
        <input type="hidden" name="method" value="1">
      </td>
    </tr>
  </form>
  <tr> 
    <td height="25" colspan="5"> 
      <%
   end sub 

	function showpage(totalnumber,maxperpage,filename)
  	dim n

  	if totalnumber mod maxperpage=0 then
     		n= totalnumber \ maxperpage
  	else
     		n= totalnumber \ maxperpage+1
  	end if
  	response.write "<table cellspacing=1 width='100%' border=0 colspan='4' ><form method=Post action="""&filename&"?keyword="& keyword &"&ClassNo="& ClassNo &"""><tr><td align=right> "
  	if CurrentPage<2 then
    		response.write "��<b><font color=red>"&totalnumber&"</font></b>ƪ����&nbsp;��ҳ ��һҳ&nbsp;"
  	else
    		response.write "��<b><font color=red>"&totalnumber&"</font></b>ƪ����&nbsp;<a href="&filename&"?page=1&keyword="& keyword &"&ClassNo="& ClassNo &">��ҳ</a>&nbsp;"
    		response.write "<a href="&filename&"?page="&CurrentPage-1&"&keyword="& keyword &"&ClassNo="& ClassNo &">��һҳ</a>&nbsp;"
  	end if

  	if n-currentpage<1 then
    		response.write "��һҳ βҳ"
  	else
    		response.write "<a href="&filename&"?page="&(CurrentPage+1)&"&keyword="& keyword &"&ClassNo="& ClassNo &">"
    		response.write "��һҳ</a> <a href="&filename&"?page="&n&"&keyword="& keyword &"&ClassNo="& ClassNo &">βҳ</a>"
  	end if
   	response.write "&nbsp;ҳ�Σ�<strong><font color=red>"&CurrentPage&"</font>/"&n&"</strong>ҳ "
    	response.write "&nbsp;<b>"&maxperpage&"</b>λ�û�/ҳ "
%>
      ת���� 
      <select name='page' size='1' style="font-size: 9pt" onChange='javascript:submit()'>
        <%for i = 1 to n%>
        <option value='<%=i%>' <%if CurrentPage=cint(i) then%> selected <%end if%>>��<%=i%>ҳ</option>
        <%next%>
      </select>
      <%   
	response.write "</td></tr></FORM></table>"
end function

Sub Delarticle()
	if Request("newsid") = "" then
		Errmsg = "<li>�빴ѡ��Ҫɾ�������¡�"
		call Qcdn.Err_List(errmsg,1)
		Response.end
	end if
	newsid = Request("newsid")
	sql = "delete from article_info where Unid in ("& newsid &")"
	conn.execute(sql)
	Response.Write("<script>alert(""ɾ���ɹ�"");location.href=""admin_newslist.asp"";</script>")
	Response.End()
End Sub
Sub MoveClass()
	if Request("newsid") = "" then
		Errmsg = "<li>�빴ѡ��Ҫ�ƶ������¡�"
		FoundErr = true
	end if
	if Request("moveid") = "" then
		Errmsg = Errmsg + "<li>��ѡ������Ҫ�ƶ�������Ŀ���ơ�"
		FoundErr = true
	else
		moveid = split(Request("moveid"),"|")
		Classid = moveid(1)
		Nclassid = moveid(0)
	end if
	if FoundErr then
		call Qcdn.Err_List(errmsg,1)
		Response.end
	end if
	sql = "Update article_info set classid = "& classid &",nclassid="& nclassid &" where Unid in("& Request("newsid") &")"
	Conn.execute(sql)
	Response.write "<script>alert(""��Ŀת�Ƴɹ�"");location.href=""admin_newslist.asp"";</script>"
	Response.end
End Sub
%>
    </td>
  </tr>
</table>
<!--#include file="admin_copy.asp"-->