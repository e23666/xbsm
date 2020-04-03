<table width=100% cellspacing=0 cellpadding=0>
	<tr>
	<td class="mframe-t-left"></td>
	<td class="mframe-t-mid">
	<span class="mframe-t-text">&nbsp; &gt;&gt;  文章栏目导航</span>
	</td>
	<td class="mframe-t-right"></td>
	</tr>
	</table>
	<table width=100% cellspacing=0 cellpadding=0>
	<tr>
	<td class="mframe-m-left"></td>
	      <td valign="top" class="mframe-m-mid"> 
			<%
			Sql = "Select Unid,Classname from article_class where flag = 0 order by Unid asc"
			Set Rs = conn.execute(Sql)
			if Rs.eof and Rs.bof then
				Response.write("<div align=center>还没有设置栏目。</div>")
			else
			%>
			<table width=98% align=center cellspacing=0 cellpadding=3 border=0>
			 <%do while not rs.eof%>
              <tr class='tdbg-dark'>
                <td colspan=6><img src='<%=CssDir%>bullet1.gif' align=absmiddle > 
                  <a href="2j.asp?id=<%=rs(0)%>"><b><%=Rs(1)%></b></a></td>
              </tr>
				<%
				Sqlt = "Select Unid,Classname from article_class where flag = "& rs(0) &" order by Unid asc"
				set Rst=conn.execute(Sqlt)
				if Rst.eof and Rst.bof then
					Response.write("<td align=center colspan=5>还没有设置子栏目。</td>")
				else
					while not Rst.eof
						Response.write("<tr>")
						Response.write("<td width='5%'></td>")
						for w = 1 to 5
							Response.write("<td width='19%'><a href=2j.asp?id="& rs(0) &"&cid="& Rst(0) &">"& Rst(1) &"</a></td>")
						Rst.movenext
						if Rst.eof then exit for
						next
						Response.write("</tr>")
					wend
				end if
				Rst.close
				rs.movenext
				loop
			  %>
            </table>
			<%
			end if
			Rs.close
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