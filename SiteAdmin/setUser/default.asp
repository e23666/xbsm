<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
conn.open constr
sql="select * from Userdetail where u_type <> '0' order by u_id asc"
rs.open sql,conn,3

If  instr(1,adminusername,session("user_name"))=0 Then 
'	Response.Write "您不是授权的管理员"
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
    <td height='30' align="center" ><strong>管理员设置</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
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
                  <td align="center" class="Title"><strong>序号</strong></td>
                  <td align="center" class="Title"><strong>用户名</strong></td>
                  <td align="center" class="Title"><strong>身份</strong></td>
                  <td align="center" class="Title"><strong>操作</strong></td>
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
                      <font color="#FF0000">超级管理</font> 
                      <%else%>
                      <font color="#CCCCCC">超级管理</font> 
                      <%end if%>
                      <input type="checkbox" name="level_2" value="1" <%if(mid(rs("u_type"),2,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),2,1)="1")then%>
                      <font color="#FF9900">财务审核</font> 
                      <%else%>
                      <font color="#CCCCCC">财务审核</font> 
                      <%end if%>
                      <input type="checkbox" name="level_3" value="1" <%if(mid(rs("u_type"),3,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),3,1)="1")then%>
                      <font color="#FF9999">财务录入 </font> 
                      <%else%>
                      <font color="#CCCCCC">财务录入</font> 
                      <%end if%>
                      <br>
                      <input type="checkbox" name="level_4" value="1" <%if(mid(rs("u_type"),4,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),4,1)="1")then%>
                      <font color="#006699">网管人员</font> 
                      <%else%>
                      <font color="#CCCCCC">网管人员</font> 
                      <%end if%>
                      <input type="checkbox" name="level_5" value="1" <%if(mid(rs("u_type"),5,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),5,1)="1")then%>
                      <font color="#00CC99">客户服务</font> 
                      <%else%>
                      <font color="#CCCCCC">客户服务</font> 
                      <%end if%>
                      <input type="checkbox" name="level_6" value="1" <%if(mid(rs("u_type"),6,1)="1")then%> checked<%end if%>>
                      <%if(mid(rs("u_type"),6,1)="1")then%>
                      <font color="#00CC00">业务人员</font> 
                      <%else%>
                      <font color="#CCCCCC">业务人员</font> 
                      <%end if%>
                      <br>                    </td>
                    <td width="100" height="25" align="center" class="tdbg"> 
                      <input type="hidden" name="id" value="<%=rs("u_id")%>">
                      <input type="submit" name="Submit" value="修改">
                      　 <a href="member_del.asp?id=<%=rs("u_id")%>">删除</a></td>
                  </tr>
                </form>
                <%
							rs.movenext
							next
						%>
                <tr> 
                  <td colspan="4" align="center"><%        
						   if page=1 then  
							   response.write "首页&nbsp;上页&nbsp;"
						   else            
							   response.write "<a href="&filename&"?page=1" & add_mclass  & ">首页</a>&nbsp;"
							   response.write "<a href="&filename&"?page="&page-1 & add_mclass & ">上页</a>&nbsp;"
						   end if              
						   if pagecount=page then   
							   response.write "下页&nbsp;尾页&nbsp;"
						   else             
							   response.write "<a href="&filename&"?page="&page+1 & add_mclass &">下页</a>&nbsp;"
							   response.write "<a href="&filename&"?page="&pagecount & add_mclass &">尾页</a>&nbsp;"
						   end if 
						   response.write "<b><font size=2>[第" & page & "页/共" & pagecount& "页]</font></b>"
						   end if
						rs.close
						conn.close
						%></td>
                </tr>
              </table><br>
              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1"  bordercolor=#666666  bordercolordark=#ffffff class="border">
                <form name="formAdd" action="member_add_save.asp" method="post" >
                  <tr> 
                    
      <td height="6" colspan="2" class="Title"><b>管理员添加</b></td>
                  </tr>
                  <tr> 
                    <td height="6" align="center" class="Title"><b>用户名</b></td>
                    <td height="6" align="center" class="Title"><b>身份</b></td>
                  </tr>
                  <tr> 
                    <td height="25" align="center" class="tdbg"> 
                      <input type="text" name="u_name" value="" size="10" class="underline">                    </td>
                    <td height="25" class="tdbg"> 
                      <input type="checkbox" name="level_1" value="1">
                      超级管理 
                      <input type="checkbox" name="level_2" value="1">
                      财务审核 
                      
        <input type="checkbox" name="level_3" value="1" checked>
                      财务录入 <br>
                      <input type="checkbox" name="level_4" value="1">
                      网管人员 
                      
        <input type="checkbox" name="level_5" value="1" checked>
                      客户服务 
                      <input type="checkbox" name="level_6" value="1" checked>
        业务人员<br>
                            </td>
                  </tr>
                  <tr> 
                    <td height="30" colspan="3" align="center" class="tdbg"> 
                      <input type="submit" name="Submit" value=" 添 加 " class="button_up"  onMouseOver="this.className='button_down'" onMouseOut="this.className='button_up'" onClick="return confirm('友情提示:\n为了安全起见，您新增的超管用户名与密码,请勿跟主站代理帐号的用户名和密码相同！')">
                      （必须保证此用户已注册） </td>
                  </tr>
                </form>
</table>
              <br>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1"  bordercolordark=#ffffff class="border">
<tr> 
                  <td width="102" height="20" align="center" class="Title"><strong>身份</strong></td>
    <td width="452" height="20" align="center" class="Title"><strong>职能</strong></td>
</tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">业务人员</td>
                  <td width="452" height="20" class="tdbg">查看订单；查看出入款；查看充值记录；查看空间、域名、邮局信息；查看用户信息；调整1级代理；问题管理；个人资料修改。</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">客户服务</td>
                  
    <td width="452" height="20" class="tdbg">切换客户身份；空间、域名、邮局管理；</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">网管人员</td>
                  
    <td width="452" height="20" class="tdbg">服务器操作（添加、修改）；查看产品信息。(一般不需要使用该身份)</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">财务录入</td>
                  <td width="452" height="20" class="tdbg">入款扣款操作；账号充值确认。</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">财务审核</td>
                  
    <td width="452" height="20" class="tdbg">对财务录入人员的款项进行审核，以确认款项是否真实到帐。</td>
                </tr>
                <tr> 
                  <td width="102" height="20" align="center" class="tdbg">超级管理</td>
                  
    <td width="452" height="20" class="tdbg">拥有所有管理功能。</td>
                </tr>
              </table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
