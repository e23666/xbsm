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
<%Check_Is_Master(1)
id=requesta("id")
if id="" then
response.write "id Ϊ��!"
response.end
end if

sql="select * from ourmoney  where id="&id
  conn.open constr
 Rs.open Sql,conn,3,2

if  rs.eof then 
response.write "û��������¼!"
response.end
else
c_memo=rs("PayMethod")
end if


if requesta("act")="del" then
Check_Is_Master(1)
sql="delete from countlist where id="&id
conn.execute(sql)
response.Write("<script>alert(""ɾ���ɹ�!"");history.back();</script>")
		response.End()


end if



if requesta("moneytype")<>""  then
sql="update ourmoney set PayMethod='"&requesta("moneytype")&"',PayDate='"&requesta("newdate")&"' where id="&id
conn.execute(sql)
		response.Write("<script>alert(""�޸ĳɹ�!"");history.back();</script>")
		response.End()

rs.close
sql="select * from ourmoney  where id="&id
 Rs.open Sql,conn,3,2
c_memo=rs("PayMethod")
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
              <td width="137" height="28" valign="center">�������</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <%=rs("Amount")%> </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">ʱ��</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="newdate" size="15" value="<%=formatdatetime(rs("PayDate"),2)%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">��������</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <select name="moneytype" id="sid4">
                  <option value="�������">�������</option>
                  <option value="��������">��������</option>
                  <option value="����2��">����2��</option>
                  <option value="��ͨ����">��ͨ����</option>
                  <option value="��������">��������</option>
                  <option value="��������">��������</option>
                  <option value="ũҵ����">ũҵ����</option>
                  <option value="����֧��">����֧��</option>
                  <option value="֧����֧��">֧����֧��</option>
                  <option value="��˾ת��">��˾ת��</option>
                  <option value="����֧��">����֧��</option>
                  <option value="���Ž���">���Ž���</option>
                  <option value="�������ʻ��">�������ʻ��</option>
                  <option value="��˾ת��2">��˾ת��2</option>
                  <option value="�������ۻ��">�������ۻ��</option>
                  <option value="���">���</option>
                  <option value="���н�">���н�</option>
                  <option value="��Ǯ֧��">��Ǯ֧��</option>
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
        <p align="center"><a href="/SiteAdmin/billmanager/viewOurMoney.asp"><br>
          ����</a></p>
      </td>
    </tr>
  </table>
  
</div>

<!--#include virtual="/config/bottom_superadmin.asp" -->
