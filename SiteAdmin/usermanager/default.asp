<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
Function ConvertIt(SourceStr,ArrayVar,Ui)
  for iii=0 to Ui
    if (ArrayVar(iii,0)=Ucase(SourceStr)) then
		ConvertIt=ArrayVar(iii,1)
		Exit function
	end if
  next
  ConvertIt=SourceStr
End function


sqlstring="SELECT UserDetail.u_name, UserDetail.u_level, levellist.l_name, UserDetail.u_usemoney, UserDetail.u_province, UserDetail.u_city,UserDetail.u_regdate, UserDetail.u_know_from, UserDetail.u_id,UserDetail.U_levelName,UserDetail.u_resumesum,UserDetail.u_email,UserDetail.u_company,userDetail.LostLogTime,userDetail.isauthmobile FROM UserDetail INNER JOIN levellist ON UserDetail.u_level = levellist.l_level where UserDetail.u_id>0"

 
 dl=trim(requesta("dl"))
		If Requesta("module")="search" Then
			If  Requesta("pages")<>"" Then
				pages =strtonum(Requesta("Pages"))
				conn.open constr
					if dl="1" then
					sqlstring = sqlstring  & " order by LostLogTime desc"
					end if

				rs.open session("sqlsearch") ,conn,3
			  else
			  	
				u_level=Trim(Requesta("u_level"))
				u_name=Trim(Requesta("u_name"))
				u_resumesum_min=Trim(Requesta("u_resumesum1"))
				u_resumesum_mx=Trim(Requesta("u_resumesum2"))
				u_remcount_min=Trim(Requesta("u_remcount1"))
				u_remcount_mx=Trim(Requesta("u_remcount2"))
				u_province=Trim(Requesta("u_province"))
				u_from = Requesta("u_from")
				fieldname=requesta("fieldname")
				fieldcontent=trim(requesta("fieldcontent"))
				date1=requestf("date1")
				date2=requestf("date2")
				f_type=requestf("f_type")
				
				
				sqllimit=""
				If u_level<>"" Then  sqllimit= sqllimit & " and UserDetail.u_level ="&u_level&""
			'	If u_name<>"" Then sqllimit= sqllimit & " and UserDetail.u_name like '%"&u_name&"%'"
				If u_resumesum_mx<>"" Then sqllimit= sqllimit & " and UserDetail.u_resumesum<"&u_resumesum_mx&""
				If u_resumesum_min<>"" Then sqllimit= sqllimit & " and UserDetail.u_resumesum > "&u_resumesum_min&""
				If u_remcount_mx<>"" Then sqllimit= sqllimit & " and UserDetail.u_usemoney  <"&u_remcount_mx&""
				If u_remcount_min<>"" Then sqllimit= sqllimit & " and UserDetail.u_usemoney > "&u_remcount_min&""
				If u_from<>"" Then sqllimit= sqllimit & " and UserDetail.u_know_from = '"&u_from&"'"
				If u_province<>"" and u_province<>"ȫ��"  Then sqllimit= sqllimit & " and UserDetail.u_province = '"&u_province&"'"
				if fieldcontent<>"" then sqllimit= sqllimit & " and "& fieldname &" like '%"& fieldcontent &"%'"
				
						select case trim(f_type)
				case "0"
				sqllimit= sqllimit & " and UserDetail.u_name like '%"&u_name&"%'"
				case "1"
				sqllimit= sqllimit & " and UserDetail.msn_msg='"&u_name&"'"
				case "2"
				sqllimit= sqllimit & " and UserDetail.u_email='"&u_name&"'"
				case "3"
				sqllimit= sqllimit & " and UserDetail.u_namecn like '%"&u_name&"%'"
				case "-1"
				sqllimit= sqllimit & " and (UserDetail.u_namecn like '%"&u_name&"%' or  UserDetail.u_name like '%"&u_name&"%' or UserDetail.msn_msg='"&u_name&"' or UserDetail.u_email='"&u_name&"' or UserDetail.qq_msg='"&u_name&"'  or UserDetail.u_company='"&u_name&"'   or UserDetail.u_telphone='"&u_name&"'  or UserDetail.u_contract='"&u_name&"')"
				end select 
				
			
					If u_name<>"" Then
					sqlstring = sqlstring & sqllimit & " order by len(UserDetail.u_name)"
					else
					sqlstring = sqlstring & sqllimit & " ORDER BY UserDetail.u_id DESC"
					end if

					
				 
				conn.open constr
				session("sqlsearch") = sqlstring
				rs.open session("sqlsearch") ,conn,3
				
			End If
		  else
		 
			conn.open constr
				if dl="1" then
					sqlstring = sqlstring & sqllimit & " order by LostLogTime desc"
				else
				sqlstring = sqlstring & " order by u_regdate desc"
				end if
			session("sqlsearch") = sqlstring
			rs.open session("sqlsearch") ,conn,3
		End If
		
		if dl<>"1" then
		dls=1
		dlstr="down_sort"
		else
        dls=0
		dlstr="up_sort"
		end if
	
'response.write(sqlstring)

'by Greatidc.com
Set localRs=conn.Execute("select top 5 * from levellist order by l_level asc")
	do while not localRs.eof
	' <input name="f_type" type="radio" value="-1" checked>ģ���ѯ
		'levelstr=levelstr & localRs("l_name") & "(" & localRs("l_level") & ")"
		levelstr=levelstr & "<label class=""fontup""><input name=""u_level"" type=""radio"" value=""" & localRs("l_level") &  " ""><span>" & localRs("l_name") &  "</span></label> "
		localRs.moveNext
		if not localRs.eof then
			levelstr=levelstr & "&nbsp;"
		end if
	loop
	localRs.close:set localRs=nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
.heightsover{ height:3px;}
label.fontup input{ width:12px; height:12px;}
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�û�����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="outexcl.asp" target="_blank">�������л�Ա��ϵ����</a></td>
  </tr>
</table><div  class="heightsover"></div>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="border">

                  <tr>
                    <td width="450" height="35" align="center" bgcolor="#449AE8"  ><font color="#FFFFFF"><strong>��Ա���ϲ�ѯ</strong></font></td>
                    <td align="center" bgcolor="#449AE8"><font color="#FFFFFF"><strong>��Ա�����ѯ</strong></font></td>
                  </tr>
                  <tr>
                    <td width="50%" height="35" bgcolor="#F0F0F0" class="tdbg">
                    
                    <form action="default.asp" method=post > 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr class="border">
                        <td width="100" height="35" align="right" bgcolor="#F0F0F0" class="tdbg">����ѯ���ͣ�</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><label class="fontup">
                          <input name="f_type" type="radio" value="-1"  checked>
                          <span>ģ���ѯ</span></label>
                          <label class="fontup">
                            <input name="f_type" type="radio" value="0">
                            <span>�ʺŲ�ѯ</span></label>
                          <label class="fontup">
                            <input name="f_type" type="radio" value="1">
                            <span>�ֻ���ѯ</span></label>
                          <label class="fontup">
                            <input name="f_type" type="radio" value="2">
                            <span>��������</span></label>
                          <label class="fontup">
                            <input name="f_type" type="radio" value="3">
                            <span>��ϵ����</span></label></td>
                      </tr>
                      <tr class="border">
                        <td width="100" height="35" align="right" bgcolor="#F0F0F0" class="tdbg">�ؼ��֣�</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><table width="100%" border="0" cellspacing="5" cellpadding="0">
                          <tr>
                            <td><input name="u_name" size="30"></td>
                            <td>�û����ԣ�</td>
                            <td><select name=u_province size="1">
                              <option value="ȫ��" selected>ȫ��</option>
                              <option value="Anhui">����</option>
                              <option value="Macao">����</option>
                              <option value="Beijing">����</option>
                              <option value="Chongqing">����</option>
                              <option value="Fujian">����</option>
                              <option value="Gansu">����</option>
                              <option value="Guangdong">�㶫</option>
                              <option value="Guangxi">����</option>
                              <option value="Guizhou">����</option>
                              <option value="Hainan">����</option>
                              <option value="Hebei">�ӱ�</option>
                              <option value="Heilongjiang">������</option>
                              <option value="Henan">����</option>
                              <option value="Hongkong">���</option>
                              <option value="Hunan">����</option>
                              <option value="Hubei">����</option>
                              <option value="Jiangsu">����</option>
                              <option value="Jiangxi">����</option>
                              <option value="Jilin">����</option>
                              <option value="Liaoning">����</option>
                              <option value="Neimenggu">���ɹ�</option>
                              <option value="Ningxia">����</option>
                              <option value="Qinghai">�ຣ</option>
                              <option value="Sichuan">�Ĵ�</option>
                              <option value="Shandong">ɽ��</option>
                              <option value="Shan1xi">ɽ��</option>
                              <option value="Shan2xi">����</option>
                              <option value="Shanghai">�Ϻ�</option>
                              <option value="Taiwan">̨��</option>
                              <option value="Tianjin">���</option>
                              <option value="Xinjiang">�½�</option>
                              <option value="Xizang">����</option>
                              <option value="Yunnan">����</option>
                              <option value="Zhejiang">�㽭</option>
                              <option value="Others">����</option>
                            </select>
                              <input name="u_from" size="8" type="hidden"></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr class="border">
                        <td width="100" height="35" align="right" bgcolor="#F0F0F0" class="tdbg"><input name=module type=hidden value=search>
                          �����ѯ��</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><label class="fontup">
                          <input name="u_level"  type="radio" value="" checked="CHECKED" class="fontup">
                          <span>��ѡ��</span></label>
                          <%=levelstr%></td>
                      </tr>
                      <tr align="center" class="border">
                        <td width="100" height="35" bgcolor="#F0F0F0" class="tdbg">&nbsp;</td>
                        <td height="35" align="left" bgcolor="#F0F0F0" class="tdbg">������������������ ��
                        <input name="sub" type="submit" value="�û���ѯ"></td>
                      </tr>
                    </table>
                    
                    </form>
                    </td>
                    <td bgcolor="#F0F0F0" class="tdbg">
                    <form action="default.asp" method=post > 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr class="border">
                        <td width="80" height="35" align="right" bgcolor="#F0F0F0" class="tdbg">�����ܶ</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><table width="300" border="0" align="left" cellpadding="0">
                          <tr>
                            <td><input name="u_resumesum1" size="8">
                              (����) -</td>
                            <td><input name="u_resumesum2" size="8">
                              (С��)</td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr class="border">
                        <td width="80" height="35" align="right" bgcolor="#F0F0F0" class="tdbg">�˻���</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><table width="300" border="0" cellpadding="0">
                          <tr>
                            <td><input name="u_remcount1" size="8">
                              (����) -</td>
                            <td><input name="u_remcount2" size="8">
                              (С��)</td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr class="border">
                        <td width="80" height="35" align="right" bgcolor="#F0F0F0" class="tdbg">�����Ϊ:</td>
                        <td height="35" bgcolor="#F0F0F0" class="tdbg"><font color=red><%=conn.execute("SELECT sum(u_usemoney) FROM UserDetail")(0)%>Ԫ</font></td>
                      </tr>
                      <tr>
                        <td width="80" height="35">&nbsp;</td>
                        <td height="35">������������
                          <input name=module type=hidden id="module" value=search>
                          ������ �� 
                          <!--<input type="submit" value="��ѯ" onClick="javascript:this.form.action='default1.asp';">-->

<input name="sub" type="submit" value="�����ѯ"></td>
                      </tr>
                    </table>
                     </form>
                    </td>
  </tr>
                 
                </table>
 <div  class="heightsover"></div>
<%
If Not (rs.eof And rs.bof) Then
	recordcount = rs.recordcount
	Rs.PageSize = 10
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" bordercolor=#999999 bordercolordark=#FFFFFF class="border">
<tr align="middle"> 
                    <td align="center" nowrap class="Title" ><strong>�û���</strong></td>
                    <td align="center" nowrap class="Title"><strong>��������</strong></td>
                    <td align="center" nowrap class="Title"><strong>����</strong></td>
					<td align="center" nowrap class="Title"><strong>�ֻ���֤</strong></td>
                    <td align="center" nowrap class="Title"><strong>����</strong></td>
                    <td align="center" nowrap class="Title"><strong>�����ܶ�</strong></td>
                    <td align="center" nowrap class="Title"><strong>�ʻ����</strong></td>
                    <td align="center" nowrap class="Title"><strong>����</strong></td>
                    <td align="center" nowrap class="Title"><strong>����</strong></td>
                    <td align="center" nowrap class="Title"><strong>ע������</strong></td>
					<td align="center" nowrap class="Title"><strong>����½<a href="?dl=<%=dls%>" title="<%if dls="1" then response.write("������½ʱ������") else response.write("��ע��ʱ������") end if%>"><img tag="3" src="/images/<%=dlstr%>.png" align="absmiddle"></a></strong></td>
                    
                  </tr>
                  <%
	Do While Not rs.eof And i<10
	
			if rs("u_name")="AgentUserVCP" then
			%>
            <tr  class="tdbg"><td><%= rs("u_name") %></td>
            <td colspan="10">���ڼ���vcp�û�����ɼ۵�ϵͳ�û�,����ɾ��,��Ҫ����ı伶��(����Ӱ��vcp��ɼ�)</td>
  </tr>
<%
			else
	%>
                  <tr> 
                    <td height="30" class="tdbg"><a href="detail.asp?u_id=<%=rs("u_id")%>" ><font color=#ff6600><%= rs("u_name") %></font></a></td>
                    <td height="30" class="tdbg"><a href="mailto:<%= rs("u_email") %>"><%= rs("u_email") %></a></td>
                    <td height="30" class="tdbg" title="<%=rs("u_company")%>"><%= left(rs("u_company")&"",10) %></td>
					<td class="tdbg"  align="center">
						<%if rs("isauthmobile")>0 then
							response.write("<font color=green>��֤</font>")
						else
							response.write("<font color=red>δ��֤</font>")
						end if
						%>
					</td>
                  
                      <td height="30" class="tdbg"> <%= rs("u_levelname") %>��</td>
                      <td height="30" class="tdbg"> <%= rs("u_resumesum") %>��</td>
                      <td height="30" class="tdbg"><%= rs("u_usemoney") %></td>
                      <td height="30" class="tdbg"><%= rs("u_province") %> <%= rs("u_city") %></td>
                      
    <td height="30" align="center" class="tdbg"><a href="../chguser.asp?module=chguser&username=<%=rs("u_name")%>"><font color="#0000FF">����</font></a> 
    </td>
                      <td height="30" class="tdbg" title="<%=rs("u_regdate")%>"> 
                        <% = rs("u_regdate") %>                    </td>
					  <td height="30" class="tdbg"  title="<%=rs("LostLogTime")%>"> <% =rs("LostLogTime")%></td>
                       
                  </tr>
                  <%
			end if
		rs.movenext
		i=i+1
	Loop
		rs.close
		conn.close
	%>
                  <tr> 
                    <td colspan =11 align="center" class="tdbg">                       <a href="default.asp?module=search&pages=1&dl=<%=dl%>">��һҳ</a> 
                      &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>&dl=<%=dl%>">ǰһҳ</a>&nbsp; 
                      <a href="default.asp?module=search&pages=<%
					if pages>=rsPagecount then 
					  	response.Write rsPagecount
					else
						response.Write pages+1
					end if
					%>">��һҳ</a>&nbsp; 
                      <a href="default.asp?module=search&pages=<%=rsPageCount%>&dl=<%=dl%>"> ��<%=rsPageCount%>ҳ&nbsp;��<%=recordcount%>��</a>&nbsp;
                      ��<%=pages%>ҳ </td>
                  </TR>
                </table>
<%
  else
  response.Write("û���κ�����")
	rs.close
	conn.close
End If
%>

<!--#include virtual="/config/bottom_superadmin.asp" -->
