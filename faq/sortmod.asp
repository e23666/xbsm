<%If LCase(USEtemplate)="tpl_2016" then%>

<table id="dlAll" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;">
<%
sql = "Select Unid,Classname from article_class where flag = 0 order by Unid asc"
Set Rs = Conn.Execute(sql)
if Rs.eof and Rs.bof then
	Response.write("<tr>")
	Response.write("<td><div align=center>还没有设置栏目。</div>")
	Response.write("</td></tr>")
else
	do while not Rs.eof
%>
	<tr>
	<%
	for i = 1 to 2
	%>
		<td valign="Top">

			
			<table width=100% cellspacing=0 cellpadding=0>
			<tr>
			<td class="mframe-t-left"></td>
			<td class="mframe-t-mid">
				<table width="100%" height="100%" cellpadding=0 cellspacing=0 border=0>
				<tr><td>
					<div class="cr-title"><a href="2j.asp?id=<%=rs(0)%>"><span class="mframe-t-text"><%=rs(1)%></span></a>
					<a href="2j.asp?id=<%=rs(0)%>" class="more">more>></a>
					</div>
				</td><td align=right>

				</td></tr>
				</table>
			</td>
			<td class="mframe-t-right"></td>
			</tr>
			</table>
			<table width=100% cellspacing=0 cellpadding=0>
			<tr>
			<td class="mframe-m-left"></td>
			    <td valign="top" class="mframe-m-mid"> 
					<%
					  SqlStr = "Select top "& listNum &" Unid,title,classid,Nclassid,Intime,hits,pic from article_info where flag = 0 and Audit = 0 and classid = "& Rs(0) &" order by Unid desc"
					  Set RsStr = Conn.Execute(SqlStr)
					  if RsStr.eof and RsStr.bof then
						Response.write("<div align=center>还没有添加文章。</div>")
					  else
						do while not RsStr.eof
					%>
				  <table class="list-table" width=100% cellpadding=0 cellspacing=0 border=0>
                    <tr>
                      <td>
					  <%=bullet%><a href="list.asp?Unid=<%=RsStr(0)%>" target="<%=AddOpenWin%>"><%=Qcdn.GetString(RsStr(1),maxLen)%></a> 
					  <%
					  	if DisPicico then
							if RsStr("pic") = 1 then
									Response.write " <img src=image/movie.gif border=0 align=absmiddle>"
							end if
						end if
					  %>
                      </td>
                      <td  align=right>
						<%
						if RsStr("intime")>=date then
							Response.write("<span class='time'>")
						else
							Response.write("<span class='gray'>")
						end if
						Response.write Qcdn.FormatTime(RsStr("intime"))
						Response.write("</span>")
						%>
                      </td>
                    </tr>
                  </table>
				  <%
				  RsStr.movenext
				  loop
				  end if
				  RsStr.close
				  %>
			    </td>
			<td class="mframe-m-right"></td>
			</tr>
			</table>
			<table width=100% style="margin-top: 15px" cellspacing=0 cellpadding=0 >
			<tr>
			<td class="mframe-b-left"></td>
			<td class="mframe-b-mid">&nbsp;</td>
			<td class="mframe-b-right"></td>
			</tr>
			</table>


		</td>
		<td width="50"></td>
		<%
		rs.movenext
		if rs.eof then exit for
		next
		%>
	</tr>
<%
	loop
	end if
	rs.close
%>
</table>




<%else%>
<table id="dlAll" cellspacing="0" border="0" style="width:100%;border-collapse:collapse;">
<%
sql = "Select Unid,Classname from article_class where flag = 0 order by Unid asc"
Set Rs = Conn.Execute(sql)
if Rs.eof and Rs.bof then
	Response.write("<tr>")
	Response.write("<td><div align=center>还没有设置栏目。</div>")
	Response.write("</td></tr>")
else
	do while not Rs.eof
%>
	<tr>
	<%
	for i = 1 to 2
	%>
		<td valign="Top" style="width:50%;">

			
			<table width=100% cellspacing=0 cellpadding=0>
			<tr>
			<td class="mframe-t-left"></td>
			<td class="mframe-t-mid">
				<table width="100%" height="100%" cellpadding=0 cellspacing=0 border=0>
				<tr><td>
					<a href="2j.asp?id=<%=rs(0)%>"><span class="mframe-t-text"><%=rs(1)%></span></a>
				</td><td align=right>
					<a href="2j.asp?id=<%=rs(0)%>"><img src="<%=CssDir%>more.gif" border=0></a>
				</td></tr>
				</table>
			</td>
			<td class="mframe-t-right"></td>
			</tr>
			</table>
			<table width=100% cellspacing=0 cellpadding=0>
			<tr>
			<td class="mframe-m-left"></td>
			    <td valign="top" class="mframe-m-mid"> 
					<%
					  SqlStr = "Select top "& listNum &" Unid,title,classid,Nclassid,Intime,hits,pic from article_info where flag = 0 and Audit = 0 and classid = "& Rs(0) &" order by Unid desc"
					  Set RsStr = Conn.Execute(SqlStr)
					  if RsStr.eof and RsStr.bof then
						Response.write("<div align=center>还没有添加文章。</div>")
					  else
						do while not RsStr.eof
					%>
				  <table width=100% cellpadding=0 cellspacing=0 border=0>
                    <tr>
                      <td>
					  <%=bullet%><a href="list.asp?Unid=<%=RsStr(0)%>" target="<%=AddOpenWin%>"><%=Qcdn.GetString(RsStr(1),maxLen)%></a> 
					  <%
					  	if DisPicico then
							if RsStr("pic") = 1 then
									Response.write " <img src=image/movie.gif border=0 align=absmiddle>"
							end if
						end if
					  %>
                      </td>
                      <td width=35 align=center> 
						<%
						if RsStr("intime")>=date then
							Response.write("<span class='time'>")
						else
							Response.write("<span class='gray'>")
						end if
						Response.write Qcdn.FormatTime(RsStr("intime"))
						Response.write("</span>")
						%>
                      </td>
                    </tr>
                  </table>
				  <%
				  RsStr.movenext
				  loop
				  end if
				  RsStr.close
				  %>
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
		<%
		rs.movenext
		if rs.eof then exit for
		next
		%>
	</tr>
<%
	loop
	end if
	rs.close
%>
</table>

<%End if%>