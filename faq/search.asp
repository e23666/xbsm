<!--#include file="head.asp"-->
<!----------------------------------------------

	Powered by QCDN_NEWS Version 4.13.1 (�ഴ����ϵͳ - ���԰�)
	������Ѱ�
	http://www.qcdn.net/
	�˰汾ֻ���ڸ�����վʹ�ò�Ҫ�����������߰�Ȩ��

-------------------------------------------------->
<%
	keyword = replace(Trim(Requesta("keyword")),"%"," ")
where =replace(trim(Requesta("where")),"%"," ")

select case where
case "title"
where="title"
case "content"
where="content"
case "writer"
where="writer"
case else
where=""
end select 

page =trim(Requesta("page"))
	if keyword = "" then
		Errmsg = "<li>����дҪ���ҵĹؼ��֡�"
		FoundErr = true
	end if
	if where = "" then
		Errmsg = Errmsg + "<li>�����쳣����<li>������Ϊ: error 109��<li>�������������ϵ������⡣"
		FoundErr = true
	end if
	
	if FoundErr then
		Call Qcdn.Err_List(Errmsg,1)
		Response.End()
	end if
	MaxPerPage=PageCount
   	dim totalPut
   	dim CurrentPage
	if not isNumeric(page)  then
      		currentPage=1
   	else
      		currentPage=cint(page)
   	end if
%>

    <div id="content">
      <div class="content">
        <div class="wide1190 pt-40 cl">
        <!--#include file="left.asp"-->
        <div id="Mainlist" class="content-right cl">

        <table width=100% cellpadding=0 cellspacing=0 border=0 align=center>
        <tr align="left" valign=top >
        <td>

        	<table width=100% cellspacing=0 cellpadding=0>
        	<tr>
        	<td class="mframe-t-left"></td>
        	<td class="mframe-t-mid">
        		<span class="mframe-t-text">&nbsp; &gt;&gt; <span id="NameLabel">
        		��������
        		</span></span>
        	</td>
        	<td class="mframe-t-right"></td>
        	</tr>
        	</table>
        	<table width=100% cellspacing=0 cellpadding=0>
        	<tr>
        	<td class="mframe-m-left"></td>
        	      <td valign="top" class="mframe-m-mid">
        			<%
        					  set rs=server.createobject("adodb.recordset")
        					  Sql = "Select Unid,title,content,classid,hits,intime,pic,synopsis from article_info where "& where &" like '%"& Qcdn.checkStr(keyword) &"%' and flag = 0 and Audit = 0 order by Unid desc"
        					  rs.open sql,conn,1,1
        					  if Rs.eof and Rs.bof then
        					  	response.Write("û�в�ѯ����������¡�")
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
                   		showpage totalput,MaxPerPage,"search.asp"
                    		showContent
                    		showpage totalput,MaxPerPage,"search.asp"
               		else
                  		if (currentPage-1)*MaxPerPage<totalPut then
                    			rs.move  (currentPage-1)*MaxPerPage
                    			dim bookmark
                    			bookmark=rs.bookmark
                   			showpage totalput,MaxPerPage,"search.asp"
                    			showContent
                     			showpage totalput,MaxPerPage,"search.asp"
                		else
        	        		currentPage=1
                   			showpage totalput,MaxPerPage,"search.asp"
                   			showContent
                   			showpage totalput,MaxPerPage,"search.asp"
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
                        <td class='summary-title' width="71%">&nbsp;<img src='image/skin/1/bullet.gif' align=absmiddle>
        				<%
        					if cid = "" then
        								Response.Write ("[<a class='link' href=2j.asp?id="&id&"&cid="&Nclassid&">" & Qcdn.Classlist(Nclassid) & "</a>]")
        					end if
        					Response.Write("<a href=list.asp?unid="& rs(0) &" target='"& AddOpenWin &"'>" & title & "</a>")
        					if DisPicico then
        							if pic = 1 then
        									Response.write " [ͼ��]"
        							end if
        					end if
        				%>
        				</td>

                        <td width="29%">
        				<%
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
          	response.write "<table cellspacing=1 width='100%' border=0 colspan='4'><form method=Post action="""&filename&"?id="&id&"&cid="&cid&"&where="& where &"&keyword="& keyword &"""><tr><td align=right> "
          	if CurrentPage<2 then
            		response.write "����������<font color=red>"&totalnumber&"</font> ƪ����&nbsp;��ҳ ��һҳ&nbsp;"
          	else
            		response.write "����������<font color=red>"&totalnumber&"</font> ƪ����&nbsp;<a href="&filename&"?page=1&id="&id&"&cid="&cid&"&where="& where &"&keyword="& keyword &" class=gray>��ҳ</a>&nbsp;"
            		response.write "<a href="&filename&"?page="&CurrentPage-1&"&id="&id&"&cid="&cid&"&where="& where &"&keyword="& keyword &" class=gray>��һҳ</a>&nbsp;"
          	end if

          	if n-currentpage<1 then
            		response.write "��һҳ βҳ"
          	else
            		response.write "<a href="&filename&"?page="&(CurrentPage+1)&"&id="&id&"&cid="&cid&"&where="& where &"&keyword="& keyword &" class=gray>"
            		response.write "��һҳ</a> <a href="&filename&"?page="&n&"&id="&id&"&cid="&cid&"&where="& where &"&keyword="& keyword &" class=gray>βҳ</a>"
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
        	<td class="mframe-m-right"></td>
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


<!--#include file="copy.asp"-->