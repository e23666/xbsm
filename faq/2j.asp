<!--#include file="head.asp"-->
 
<%
id=Request("id")
cid = Request("cid")
page=Request("page")

	if not isnumeric(id) then
		'Errmsg = "<li>�����쳣����<li>������Ϊ: error 110��<li>�������������ϵ������⡣"
'		call Qcdn.Err_List(errmsg,2)
'		Response.End()
id=0
	else
		 
		id = cint(qcdn.sqlcheck(id))
	end if
	
	
	if not isnumeric(cid) then
	'	Errmsg = "<li>�����쳣����<li>������Ϊ: error 110��<li>�������������ϵ������⡣"
'		call Qcdn.Err_List(errmsg,2)
'		Response.End()
cid=0
	end if
	
	
	
	cid = qcdn.sqlcheck(cid)
	
	MaxPerPage=PageCount
   	dim totalPut
   	dim CurrentPage
	
	if   not isnumeric(page) then
      		currentPage=1
			Else
			currentPage=page
   	end if
%>

<%If LCase(USEtemplate)="tpl_2016" then%>
  <div id="content">
    <div class="content">
      <div class="wide1190 pt-40 cl">
<%else%>
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
      <table width="100%" cellpadding=0 cellspacing=0 border=0 align=center>
      <tr align="left" valign=top >
      <td>

      	<table width=100% cellspacing=0 cellpadding=0>
      	<tr>
      	<td class="mframe-t-left"></td>
      	<td class="mframe-t-mid"> <center class="aTitle">
      		<span class="mframe-t-text"><span id="NameLabel">
      		<%
      		if cid <>"" then
      			Response.write Qcdn.Classlist(cid)
      		else
      			Response.write Qcdn.Classlist(id)
      		end if
      		%>
      		</span></span></center>
      	</td>
      	<td class="mframe-t-right"></td>
      	</tr>
      	</table>
      	<table class="z_table">
      	<tr>
      	 <td valign="top" class="mframe-m-mid">
      									<%
      					  set rs=server.createobject("adodb.recordset")
      					  if cid<>"" Then
      					     If cid>0 then
      						  Sql = "Select Unid,title,content,Nclassid,hits,intime,pic,synopsis from article_info where classid = "& id &" and Nclassid="& cid &" and flag = 0 and Audit = 0 order by Unid desc"
      						  Else
      						   Sql = "Select Unid,title,content,Nclassid,hits,intime,pic,synopsis from article_info where classid = "& id &"  and flag = 0 and Audit = 0 order by Unid desc"
      						  End if
      					  else
      					  	  Sql = "Select Unid,title,content,Nclassid,hits,intime,pic,synopsis from article_info where flag = 0 and classid = "& id &" and Audit = 0 order by Unid desc"
      					  end If
      					 ' Response.write(Sql)
      					  rs.open sql,conn,1,1
      					  if Rs.eof and Rs.bof then
      					  	response.Write("����Ŀ�»�û��������¡�")
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
                 		showpage totalput,MaxPerPage,"2j.asp"
                  		showContent
                  		showpage totalput,MaxPerPage,"2j.asp"
             		else
                		if (currentPage-1)*MaxPerPage<totalPut then
                  			rs.move  (currentPage-1)*MaxPerPage
                  			dim bookmark
                  			bookmark=rs.bookmark
                 			showpage totalput,MaxPerPage,"2j.asp"
                  			showContent
                   			showpage totalput,MaxPerPage,"2j.asp"
              		else
      	        		currentPage=1
                 			showpage totalput,MaxPerPage,"2j.asp"
                 			showContent
                 			showpage totalput,MaxPerPage,"2j.asp"
      	      		end if
      	   		end if
      		rs.close
      		set rs = nothing
         	end if
      	sub showContent
      	dim i
      	   	i=0
      	do while not rs.eof
      						  Unid = rs(0)
      						  title = rs(1)
      						  content = rs(2)
      						  Nclassid = rs(3)
      						  hits = rs(4)
      						  intime = rs(5)
      						  pic = rs(6)
      						  synopsis = rs(7)
      			%>
      			<table width=100% cellpadding=0 cellspacing=0 border=0>
                    <tr>
                      <td width="71%">&nbsp;
      				<%
      					if cid = "" then
      								Response.Write ("[<a class='link' href=2j.asp?id="&id&"&cid="&Nclassid&">" & Qcdn.Classlist(Nclassid) & "</a>]")
      					end if
      					Response.Write(" <a  href=list.asp?unid="& rs(0) &" target='"& AddOpenWin &"'>" & title & "</a>")
      					if DisPicico then
      							if pic = 1 then
      									Response.write " [ͼ��]"
      							end if
      					end if
      				%>


      				</td>
                      <td width="29%" nowrap="nowrap">
      				����<%
      				Response.Write "����" & Qcdn.HTMLcode(synopsis)
      				Response.write ("<div style='width:100%;text-align:right'><font class=gray>("& intime &",<font class=hit>"& hits &"</font>)</font>   <a href=list.asp?unid="& rs(0) &" target='"& AddOpenWin &"'>[�鿴ȫ��]</a> </div>")
      				%>
                        </td>
                    </tr>
                  </table>

      <%
      		  i=i+1
      	      if i>=MaxPerPage then exit do
        rs.movenext
        loop

      %>

                  <table width=95% align=center height=40><tr><td align=center><table cellpadding=0 cellspacing=0 width=100%><tr>
                            <td>
      	 <%
      	end sub
      	function showpage(totalnumber,maxperpage,filename)
        	dim n

        	if totalnumber mod maxperpage=0 then
           		n= totalnumber \ maxperpage
        	else
           		n= totalnumber \ maxperpage+1
        	end if
        	response.write "<table cellspacing=1 width='100%' border=0 colspan='4'><form method=Post action="""&filename&"?id="&id&"&cid="&cid&"""><tr><td align=right> "
        	if CurrentPage<2 then
          		response.write "��<font color=red>"&totalnumber&"</font>ƪ����&nbsp;��ҳ ��һҳ&nbsp;"
        	else
          		response.write "��<font color=red>"&totalnumber&"</font>ƪ����&nbsp;<a href="&filename&"?page=1&id="&id&"&cid="&cid&" class=gray>��ҳ</a>&nbsp;"
          		response.write "<a href="&filename&"?page="&CurrentPage-1&"&id="&id&"&cid="&cid&" class=gray>��һҳ</a>&nbsp;"
        	end if

        	if n-currentpage<1 then
          		response.write "��һҳ βҳ"
        	else
          		response.write "<a href="&filename&"?page="&(CurrentPage+1)&"&id="&id&"&cid="&cid&" class=gray>"
          		response.write "��һҳ</a> <a href="&filename&"?page="&n&"&id="&id&"&cid="&cid&" class=gray>βҳ</a>"
        	end if
         	response.write "&nbsp;ҳ�Σ�<strong><font color=red>"&CurrentPage&"</font>/"&n&"</strong>ҳ "
          	response.write "&nbsp;<b>"&maxperpage&"</b>ƪ����/ҳ "
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
      					  %>
         					  </td>
                          </tr></table></td></tr></table>
      					<!-----------����������----------->
      					<%Call Qcdn.Searchlist()%>
      					<!-----------����������----------->
      	      </td>
      	</tr>
      	</table>
      	<table width=100% cellspacing=0 cellpadding=0 >
      	<tr>
      	<td class="mframe-b-left"></td>
      	<td class="mframe-b-mid">&nbsp;</td>
      	<td class="mframe-b-right"></td>
      	</tr>
      	</table>

      </td>
      </tr>
      </table>
      </div>
      </div>
      </div>
      </div>


</div>

<!--#include file="copy.asp"-->