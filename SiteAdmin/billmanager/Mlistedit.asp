<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<style type="text/css">
<!--
p {  font-size: 9pt}
td {  font-size: 9pt}
a:active {  text-decoration: none; color: #000000}
a:hover {  text-decoration: blink; color: #FF0000}
a:link {  text-decoration: none; color: #660000}
a:visited {  text-decoration: none; color: #990000}
.line {  background-image: url(dotline2.gif); background-repeat: repeat-y}
-->
</style>
<%Check_Is_Master(6)
sysid=requesta("sysid")
if sysid="" then
response.write "sysid Ϊ��!"
response.end
end if

sql="select * from countlist  where sysid="&sysid
  conn.open constr
 Rs.open Sql,conn,3,2
if  rs.eof then 
response.write "û��������¼!"
response.end
end if


if requesta("act")="del" then
Check_Is_Master(1)
sql="delete from countlist where sysid="&sysid
conn.execute(sql)
response.Write("<script>alert(""ɾ���ɹ�!"");history.back();</script>")
		response.End()


end if


c_memo=rs("c_memo")

if not rs("c_check") then
Check_Is_Master(1)
'response.write "�Ѿ���˹��Ĳ����޸�!"
'response.end
end if


if requesta("moneytype")<>""  then
   if trim(requesta("moneytype"))="���Ž���" then
     Check_Is_Master(1)
   end if

  sql="select * from countlist where sysid="&sysid
         rs11.open sql,conn,1,3  
		 if not rs11.eof then  
		   if trim(rs11("c_memo"))="���Ž���" then  Check_Is_Master(1)
                          sql_money="select * from ourMoney where payDate=#"& rs11("c_date") &"# and PayMethod='"& trim(rs11("c_memo")) &"' and Amount="& trim(rs11("u_moneysum")) &" and UserName = (select u_name  from UserDetail where u_id="& trim(rs11("u_id")) &" )"
						  response.write sql_money
	                      rs1.open sql_money,conn,1,3
						  if not rs1.eof then
								c_date=requesta("newdate")
								if not isdate(c_date) then
									response.Write("<script>alert(""���ڸ�ʽ����"");history.back();</script>")
									response.End()
								else
									if datediff("d",date(),c_date)<-30 then
										s_newdate=rs1("payDate")
									else
										s_newdate=c_date
									end if
								end if
						     rs1("payDate")=s_newdate
							 rs1("payMethod")=trim(requesta("moneytype"))
							 rs1.update
						  end if
						  rs1.close
						 
						  
 								c_date=requesta("newdate")
								if not isdate(c_date) then
									response.Write("<script>alert(""���ڸ�ʽ����"");history.back();</script>")
									response.End()
								else
									if datediff("d",date(),c_date)<-30 then
										s_newdate=rs11("c_date")
									else
										s_newdate=c_date
									end if
								end if
           rs11("c_memo")= trim(requesta("moneytype"))'����
		   rs11("c_date")=s_newdate'ʱ��
		   rs11("u_countId")=trim(requesta("u_countId"))'ƾ֤���
           rs11.update     
        end if
		rs11.close
		
		
'sql="update countlist set c_memo='"&requesta("moneytype")&"',c_date='"&requesta("newdate")&"',u_countId='"&requesta("u_countId")&"' where sysid="&sysid
'conn.execute(sql)
		response.Write("<script>alert(""�޸ĳɹ�!"");history.back();</script>")
		response.End()

rs.close
sql="select * from countlist  where sysid="&sysid
 Rs.open Sql,conn,3,2
c_memo=rs("c_memo")


end if

%>

<div align="left"> </div>
<div align="left">
  <table border="0" cellpadding="0" cellspacing="0" height="528">
    <tr> 
      <td width="624" height="306" valign="top"> 
        <!--  BODY END -->
        <br>
        <form name="form1" method="post" action="">
          <p>&nbsp; </p>
          <table align=center bgcolor=#999999 border=0 cellpadding=3 cellspacing=1 height="1">
            <tr align=middle  bgcolor="#FFFFFF" > 
              <td width="137" height="1" valign="bottom" bgcolor="#E8E8E8">��Ŀ</td>
              <td width="71"  height="1" valign="bottom" bgcolor="#E8E8E8" >ֵ</td>
            </tr>
            <%
    PageCount=0
  	   i=0

	Do While Not rs.eof And i<20
	%>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center"><font color="#000000">ƾ֤���� 
                </font></td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="u_countId" value="<%=rs("u_countId")%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">�������</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <%=rs("u_moneysum")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">����</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
               <%=rs("u_in")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">֧��</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
       <%=rs("u_out")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">ʱ��</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="newdate" size="15" value="<%=formatdatetime(rs("c_date"),2)%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">��������</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <select name="moneytype" id="sid4">
                  <option value="�������"<%if c_memo="�������" then%> selected<%end if%>>�������</option>
                  <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
                  <option value="����2��"<%if c_memo="����2��" then%> selected<%end if%>>����2��</option>
                  <option value="�Ƹ�֧ͨ��"<%if c_memo="�Ƹ�֧ͨ��" then%> selected<%end if%>>�Ƹ�֧ͨ��</option>

                  <option value="��ͨ����"<%if c_memo="��ͨ����" then%> selected<%end if%>>��ͨ����</option>
                  <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
                  <option value="��������"<%if c_memo="��������" then%> selected<%end if%>>��������</option>
                  <option value="ũҵ����"<%if c_memo="ũҵ����" then%> selected<%end if%>>ũҵ����</option>
                  <option value="����֧��"<%if c_memo="����֧��" then%> selected<%end if%>>����֧��</option>
                  <option value="֧����֧��"<%if c_memo="֧����֧��" then%> selected<%end if%>>֧����֧��</option>
                  <option value="ũҵ����2"<%if c_memo="ũҵ����2" then%> selected<%end if%>>ũҵ����2</option>

                  <option value="��˾ת��"<%if c_memo="��˾ת��" then%> selected<%end if%>>��˾ת��</option>
                  <option value="���Ž���"<%if c_memo="���Ž���" then%> selected<%end if%>>���Ž���</option>
                  <option value="�������ʻ��"<%if c_memo="�������ʻ��" then%> selected<%end if%>>�������ʻ��</option>
                  <option value="��˾ת��2"<%if c_memo="��˾ת��2" then%> selected<%end if%>>��˾ת��2</option>
                  <option value="�������ۻ��"<%if c_memo="�������ۻ��" then%> selected<%end if%>>�������ۻ��</option>
                  <option value="����֧��"<%if c_memo="����֧��" then%> selected<%end if%>>����֧��</option>
                  <option value="��Ǯ֧��"<%if c_memo="��Ǯ֧��" then%> selected<%end if%>>��Ǯ֧��</option>

                  <option value="���"<%if c_memo="���" then%> selected<%end if%>>���</option>
                </select>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">�޸�</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="submit" name="Submit" value="�޸�">
                </font></td>
            </tr>
            <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
          </table>
        </form>
      </td>
    </tr>
  </table>
  
</div>

<!--#include virtual="/config/bottom_superadmin.asp" -->
