<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
conn.open constr
sql="select * from Userdetail where u_type <> '0' order by u_id asc"
rs.open sql,conn,3

If  instr(1,adminusername,session("user_name"))=0 Then 
'	Response.Write "��������Ȩ�Ĺ���Ա"
'	response.End()
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>����Ա����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>

<%
						pagesize=20
						filename=Request("script_name")

						page=strtonum(Requesta("page"))
						recordcount=rs.recordcount
						rs.pagesize=pagesize
						if (recordcount mod pagesize)=0 then            
							pagecount= recordcount \ pagesize            
						else            
							pagecount= recordcount \ pagesize + 1
						end if            
						if page<1 then            
							page=1            
						end if            
						if page>pagecount then
							page=pagecount
						end if            
						if not rs.eof then
						  rs.absolutepage=page
						%>
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1"  bordercolor=0  bordercolordark=#ffffff class="border">
                <tr> 
                  <td align="center" class="Title"><strong>���</strong></td>
                  <td align="center" class="Title"><strong>�û���</strong></td>
                  <td align="center" class="Title"><strong>���</strong></td>
                  <td align="center" class="Title"><strong>����</strong></td>
                </tr>
                <%
						   For iPage = 1 To pagesize
							if rs.EOF Then Exit For
							if (ipage mod 2) = 1 then
							  bg="#E9E0C2"
							else
							  bg="#FAF9DE"
							end if	
							position=(page-1)*pagesize+ipage
						%>
                <form name="formAdd" action="member_edit_save.asp" method="post" >
                  <tr> 
                    <td height="25" align="center" class="tdbg"><%=position%></td>
                    <td height="25" align="center" class="tdbg"> <%=rs("u_name")%> </td>
                    <td height="25" class="tdbg"> 
                      <input type="checkbox" name="level_1" value="1" <%if(mid(rs("u_type"),1,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),1,1)="1")then%>
                      <font color="#FF0000">��������</font> 
                      <%else%>
                      <font color="#CCCCCC">��������</font> 
                      <%end if%>
                      <input type="checkbox" name="level_2" value="1" <%if(mid(rs("u_type"),2,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),2,1)="1")then%>
                      <font color="#FF9900">�������</font> 
                      <%else%>
                      <font color="#CCCCCC">�������</font> 
                      <%end if%>
                      <input type="checkbox" name="level_3" value="1" <%if(mid(rs("u_type"),3,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),3,1)="1")then%>
                      <font color="#FF9999">����¼�� </font> 
                      <%else%>
                      <font color="#CCCCCC">����¼��</font> 
                      <%end if%>
                      <br>
                      <input type="checkbox" name="level_4" value="1" <%if(mid(rs("u_type"),4,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),4,1)="1")then%>
                      <font color="#006699">������Ա</font> 
                      <%else%>
                      <font color="#CCCCCC">������Ա</font> 
                      <%end if%>
                      <input type="checkbox" name="level_5" value="1" <%if(mid(rs("u_type"),5,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),5,1)="1")then%>
                      <font color="#00CC99">�ͻ�����</font> 
                      <%else%>
                      <font color="#CCCCCC">�ͻ�����</font> 
                      <%end if%>
                      <input type="checkbox" name="level_6" value="1" <%if(mid(rs("u_type"),6,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),6,1)="1")then%>
                      <font color="#00CC00">ҵ����Ա</font> 
                      <%else%>
                      <font color="#CCCCCC">ҵ����Ա</font> 
                      <%end if%>
                      <br>                    </td>
                    <td width="100" height="25" align="center" class="tdbg"> 
                      <input type="hidden" name="id" value="<%=rs("u_id")%>">
                      <input type="submit" name="Submit" value="�޸�">
                      �� <a href="member_del.asp?id=<%=rs("u_id")%>">ɾ��</a></td>
                  </tr>
                </form>
                <%
							rs.movenext
							next
						%>
                <tr> 
                  <td colspan="4" align="center"><%        
						   if page=1 then  
							   response.write "��ҳ&nbsp;��ҳ&nbsp;"
						   else            
							   response.write "<a href="&filename&"?page=1" & add_mclass  & ">��ҳ</a>&nbsp;"
							   response.write "<a href="&filename&"?page="&page-1 & add_mclass & ">��ҳ</a>&nbsp;"
						   end if              
						   if pagecount=page then   
							   response.write "��ҳ&nbsp;βҳ&nbsp;"
						   else             
							   response.write "<a href="&filename&"?page="&page+1 & add_mclass &">��ҳ</a>&nbsp;"
							   response.write "<a href="&filename&"?page="&pagecount & add_mclass &">βҳ</a>&nbsp;"
						   end if 
						   response.write "<b><font size=2>[��" & page & "ҳ/��" & pagecount& "ҳ]</font></b>"
						   end if
						rs.close
						conn.close
						%></td>
                </tr>
              </table><br>
              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1"  bordercolor=#666666  bordercolordark=#ffffff class="border">
                <form name="formAdd" action="member_add_save.asp" method="post" >
                  <tr> 
                    
      <td height="6" colspan="2" class="Title"><b>����Ա���</b></td>
                  </tr>
                  <tr> 
                    <td height="6" align="center" class="Title"><b>�û���</b></td>
                    <td height="6" align="center" class="Title"><b>���</b></td>
                  </tr>
                  <tr> 
                    <td height="25" align="center" class="tdbg"> 
                      <input type="text" name="u_name" value="" size="10" class="underline">                    </td>
                    <td height="25" class="tdbg"> 
                      <input type="checkbox" name="level_1" value="1">
                      �������� 
                      <input type="checkbox" name="level_2" value="1">
                      ������� 
                      
        <input type="checkbox" name="level_3" value="1" checked>
                      ����¼�� <br>
                      <input type="checkbox" name="level_4" value="1">
                      ������Ա 
                      
        <input type="checkbox" name="level_5" value="1" checked>
                      �ͻ����� 
                      <input type="checkbox" name="level_6" value="1" checked>
        ҵ����Ա<br>
                            </td>
                  </tr>
                  <tr> 
                    <td height="30" colspan="3" align="center" class="tdbg"> 
                      <input type="submit" name="Submit" value=" �� �� " class="button_up"  onMouseOver="this.className='button_down'" onMouseOut="this.className='button_up'" onClick="return confirm('������ʾ:\nΪ�˰�ȫ������������ĳ����û���������,�������վ�����ʺŵ��û�����������ͬ��')">
                      �����뱣֤���û���ע�ᣩ </td>
                  </tr>
                </form>
</table>
              <br>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1"  bordercolordark=#ffffff class="border">
<tr> 
                  <td width="102" height="20" align="center" class="Title"><strong>���</strong></td>
    <td width="452" height="20" align="center" class="Title"><strong>ְ��</strong></td>
</tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">ҵ����Ա</td>
                  <td width="452" height="20" class="tdbg">�鿴�������鿴�����鿴��ֵ��¼���鿴�ռ䡢�������ʾ���Ϣ���鿴�û���Ϣ������1����������������������޸ġ�</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">�ͻ�����</td>
                  
    <td width="452" height="20" class="tdbg">�л��ͻ���ݣ��ռ䡢�������ʾֹ���</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">������Ա</td>
                  
    <td width="452" height="20" class="tdbg">��������������ӡ��޸ģ����鿴��Ʒ��Ϣ��(һ�㲻��Ҫʹ�ø����)</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">����¼��</td>
                  <td width="452" height="20" class="tdbg">���ۿ�������˺ų�ֵȷ�ϡ�</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">�������</td>
                  
    <td width="452" height="20" class="tdbg">�Բ���¼����Ա�Ŀ��������ˣ���ȷ�Ͽ����Ƿ���ʵ���ʡ�</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">��������</td>
                  
    <td width="452" height="20" class="tdbg">ӵ�����й����ܡ�</td>
                </tr>
              </table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
