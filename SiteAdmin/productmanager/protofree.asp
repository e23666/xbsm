<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->

<%Check_Is_Master(1)%>
<%
function productName(p_proid,p)

  if p_proid<>"" and p<>"" then

	  set rsa=conn.execute ("select top 1 p_name from productlist where p_type="& p &" and rtrim(p_proid)='" & trim(p_proid) & "'")
	  if not rsa.eof then
	  productName=rsa(0)&"|"&p_proid
	   
	  else

	  productName="δ֪"
	  
	  end if

  else
    productName="��"
  end if
end function

conn.open constr

act=requesta("act")
			
if act="syncall" then
	cmdstr=""
	cmdstr=cmdstr & "other" & vbcrlf
	cmdstr=cmdstr & "get" & vbcrlf
	cmdstr=cmdstr & "entityname:tablecontent" & vbcrlf
	cmdstr=cmdstr & "update:false" & vbcrlf
	cmdstr=cmdstr & "tbname:protofree" & vbcrlf
	cmdstr=cmdstr & "fieldlist:proid,freeproid,freeproid1,freeproid2,freeproid3,freeproid4,type,content,addTime" & vbcrlf & "." & vbcrlf
	
	synret=PCommand(cmdstr,session("user_name"))
	
	if left(synret,3)<>"200" then
		url_return "��Ʒͬ��ʧ��",-1
	else
		Response.write "<script language=javascript>alert('��Ʒͬ���ɹ�');</script>"
	end if
end if
			
str=trim(requesta("str"))
searchvalue=trim(request.form("searchvalue"))

searchSql=""

sqlstring="SELECT protofree.freeproid, protofree.freeproid1, protofree.freeproid2, protofree.freeproid3, protofree.freeproid4, productlist.P_proId, productlist.p_price, productlist.p_name, productlist.p_id, productlist.p_type, protofree.addTime FROM productlist left outer JOIN protofree ON productlist.P_proId = protofree.proid "


if searchvalue<>"" then
  sqlstring=sqlstring&" where (productlist.P_proId='"& searchvalue &"' or productlist.P_name like '%"&searchvalue&"%')"
else
	if str="" or str="host" then
			lookstr="�ռ�"
			sqlstring=sqlstring &" WHERE protofree.type = 'host'"
	elseif str="mail" then
			lookstr="�ʾ�"
			sqlstring=sqlstring &" WHERE protofree.type = 'mail'"
	end if
end if

sqlstring=sqlstring&" ORDER BY productlist.p_id DESC"

		'module="search"
		module=trim(requesta("module"))
		If module="search" Then
			If  Requesta("pages")<>"" Then
				pages =strtonum(Requesta("Pages"))
				rs.open session("sqlsearch") ,conn,3
			  else
				sqlcmd= sqlstring
				'���²���  �ֱ���Ҫ���� �������Ĳ����ȵ����
				session("sqlsearch")=sqlcmd 
				rs.open session("sqlsearch") ,conn,3
			End If
		  else
			sqlcmd= sqlstring
			session("sqlsearch")=sqlcmd
			rs.open session("sqlsearch"),conn,3
		End If


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��Ʒ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="protofree.asp?str=host">�ռ�</a> | <a href="protofree.asp?str=mail">�ʾ�| <a href="javascript:if (confirm('��ȷ��ͬ�����в�Ʒ����Ʒ�𣨱������ϼ�������һ�£���')){location.href='<%=request.ServerVariables("SCRIPT_NAME")%>?act=syncall';}">����ͬ��������Ʒ-���ϼ������̱���һ��</a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" cellpadding="4" cellspacing="0" class="border">
<form name="formsear" method="post" action="protofree.asp?str=<%=lovestr%>">
  <tr>
    <td width="42%" align="right" class="tdbg">�ؼ��֣�</td>
    <td width="14%" align="right" class="tdbg"><input name="searchvalue" type=text /></td>
    <td width="44%" class="tdbg"><input type="submit" value="����"></td>
  </tr>
</form>
</table>

<%
if trim(request("str"))="mail" then 
  lovestr="mail"
else
  lovestr="host"
end if
 
%>
<br>
<TABLE width="100%" border=0 cellPadding=2 cellSpacing=1 class="border">
                <TR> 
                  <td align="center" nowrap class="Title"><strong> <%=lookstr%>����</strong></td>
                  <td align="center" nowrap class="Title"><strong><%=lookstr%>�۸�</strong></td>
                  <td align="center" nowrap class="Title"><strong>�����ʾ�</strong></td>
				  <td align="center" nowrap class="Title"><strong>��������</strong></td>
				  <td align="center" nowrap class="Title"><strong>���Ϳռ�</strong></td>
				  <td align="center" nowrap class="Title"><strong>����mysql</strong></td>
				  <td align="center" nowrap class="Title"><strong>����mssql</strong></td>
                  <td align="center" nowrap class="Title"><p align="center" style="margin-left: 6"><strong>����</strong></p></td>
                </TR>
                <%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 10
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
				cur=0
	Do While Not rs.eof And i<11
	  if cur mod 2 =0 then 
	  cur_color="#ffffcc"
	  else
	  cur_color="#ffffff"
	  end if
	%>
	<form method="POST" name="form" action="saveprotofree.asp?str=<%=str%>">
                <TR align="left" bgcolor="<%=cur_color%>"> 
                  <td class="tdbg">
<p align="center" style="margin-left: 6"><%= rs("P_name")%><%="["&rs("P_proid")&"]"%></td>
                  <td class="tdbg">
<p align="center" style="margin-left: 6"><%= rs("p_price")%></td>
                    <td class="tdbg"> <p align="center" style="margin-left: 6"> 
                        <select name="freeproid" class="box">
						<%
						sql="select p_proid,p_type,p_id from productlist where p_type=2 order by p_id desc"
						Set rss=conn.Execute (sql)
						%>
					 <option value="<%=rs("freeproid")%>" checked><%=rs("freeproid")%></option>
						<%
						Do While Not rss.eof
						%>
                          <option value="<%=rss("p_proid")%>"><%=rss("p_proid")%></option>
						<%	
							rss.movenext
							Loop
						%>
						<option value="" >��</option>
                        </select>
                    </td>
				  <td nowrap="NOWRAP" class="tdbg">
				    
				        <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
				          <tr><td>
				            
				            <select name="freeproid1" size=5 multiple style="height:160px">
				              <%
						sql="select p_name,p_proid from productlist where p_type=3   order by p_id"
						Set rss=conn.Execute (sql)
						Do While Not rss.eof
						%>
				              <option value="<%=rss("p_proid")%>"><%=rss("p_proid")%></option>
				              <%	
							rss.movenext
							Loop
						%>
				              <option value="delelteall">��</option>
			                </select>
				            </td>
				        <td>
				          <%
				 
				  if trim(rs("freeproid1"))&""<>"" then
				    for each domains in split(rs("freeproid1"),",")
					  if trim(domains)<>"" then
					    'response.write "<font color=red>"&productName(domains,3)&"</font><br>"
						response.write "<font color=red>"&domains&"</font><br>"
						
					  end if
					next
				  end if
				  %>
				          <input type="hidden" value="<%=trim(rs("freeproid1"))%>" name="free1hidden">
				          <%
				    if trim(rs("addTime"))&""<>"" then
					  addTime_s=trim(rs("addTime"))
					else
					  addTime_s="0,0,0,0"
					end if
					   addTime = split(addTime_s,",")
					 
				
				  %>
				          <input type="checkbox" name="addTime1" value="1" <%if trim(addTime(0))="1" then response.write "checked" %> />�Զ�����				        </td></tr>
		                </table>		            </td>
				    <td nowrap="nowrap" class="tdbg">
				      
				        <select name="freeproid2" class="box">
				          <%
						sql="select p_name,p_proid from productlist where p_type=1 order by p_id desc"
						Set rss=conn.Execute (sql)
				   %>
				          <option value="<%=rs("freeproid2")%>" checked><%=rs("freeproid2")%></option>
				          <%
						Do While Not rss.eof
						%>
				          <option value="<%=rss("p_proid")%>"><%=rss("p_proid")%></option>
				          <%	
							rss.movenext
							Loop
							
							rss.close
							set rss=nothing
							
							
						
						%>
				          <option value="">��</option>
			            </select>	
				        <input type="checkbox" name="addTime2" value="1" <%if trim(addTime(1))="1" then response.write "checked" %> />
			        �Զ�����		          </td>
				   <td nowrap="nowrap" class="tdbg">
				     
				         <select name="freeproid3" class="box">
				           <%
						sql="select p_name,p_proid from productlist where p_type=1 and (p_server=10 or p_server=14 or p_proid='b079' or p_proid='b080' or p_proid='b069') order by p_id"
						Set rss=conn.Execute (sql)
				   %>
				           <option value="<%=rs("freeproid3")%>" checked><%=rs("freeproid3")%></option>
				           <%
						Do While Not rss.eof
						%>
				            <option value="<%=rss("p_proid")%>"><%=rss("p_proid")%></option>
				           <%	
							rss.movenext
							Loop
							
							rss.close
							set rss=nothing
							
							
						
						%>
				           <option value="">��</option>
			            </select>	
			            <input type="checkbox" name="addTime3" value="1" <%if trim(addTime(2))="1" then response.write "checked" %> />
		            �Զ�����		            </td>
				   <td nowrap="nowrap" class="tdbg">
				     
				         <select name="freeproid4" class="box">
				           <%
						sql="select p_name,p_proid from productlist where p_type=7 order by p_id desc"
						Set rss=conn.Execute (sql)
				   %>
				           <option value="<%=rs("freeproid4")%>" checked><%=rs("freeproid4")%></option>
				           <%
						Do While Not rss.eof
						%>
				            <option value="<%=rss("p_proid")%>"><%=rss("p_proid")%></option>
				           <%	
							rss.movenext
							Loop
							
							rss.close
							set rss=nothing
				%>
				           <option value="">��</option>
			            </select>	
			            <input type="checkbox" name="addTime4" value="1" <%if trim(addTime(3))="1" then response.write "checked" %> />
		            �Զ�����		   </td>
                  <td class="tdbg"> 
                    
                        <input type="submit" name="Submit" value="�޸�">
                        <input type="hidden" name="proid" value="<%=rs("p_proid")%>">                     </td>
                </TR>
  </form>
                <%
		rs.movenext
		i=i+1
		cur=cur+1
	Loop
	rs.close
	conn.close
  else
	rs.close
	conn.close
End If
	%>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan =8 align="center" bgcolor="#FFFFFF">  <a href="protofree.asp?module=search&pages=1">��һҳ</a> 
                    &nbsp; <a href="protofree.asp?str=<%=str%>&module=search&pages=<%=pages-1%>">ǰһҳ</a>&nbsp; 
                    <a href="protofree.asp?str=<%=str%>&module=search&pages=<%=pages+1%>">��һҳ</a>&nbsp; 
                    <a href="protofree.asp?str=<%=str%>&module=search&pages=<%=rsPageCount%>">��<%=rsPageCount%>ҳ</a>&nbsp; ��<%=pages%>ҳ</td>
                </TR>
</table>


<!--#include virtual="/config/bottom_superadmin.asp" -->

