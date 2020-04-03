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
response.write "id 为空!"
response.end
end if

sql="select * from ourmoney  where id="&id
  conn.open constr
 Rs.open Sql,conn,3,2

if  rs.eof then 
response.write "没有这条记录!"
response.end
else
c_memo=rs("PayMethod")
end if


if requesta("act")="del" then
Check_Is_Master(1)
sql="delete from countlist where id="&id
conn.execute(sql)
response.Write("<script>alert(""删除成功!"");history.back();</script>")
		response.End()


end if



if requesta("moneytype")<>""  then
sql="update ourmoney set PayMethod='"&requesta("moneytype")&"',PayDate='"&requesta("newdate")&"' where id="&id
conn.execute(sql)
		response.Write("<script>alert(""修改成功!"");history.back();</script>")
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
              <td width="137" height="1" valign="bottom" bgcolor="#E8E8E8">项目</td>
              <td width="71"  height="1" valign="bottom" bgcolor="#E8E8E8" >值</td>
            </tr>
            <%
    PageCount=0
  	   i=0

	Do While Not rs.eof And i<20
	%>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">发生金额</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <%=rs("Amount")%> </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">时间</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="newdate" size="15" value="<%=formatdatetime(rs("PayDate"),2)%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">款项类型</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <select name="moneytype" id="sid4">
                  <option value="邮政汇款">邮政汇款</option>
                  <option value="招商银行">招商银行</option>
                  <option value="招行2号">招行2号</option>
                  <option value="交通银行">交通银行</option>
                  <option value="建设银行">建设银行</option>
                  <option value="工商银行">工商银行</option>
                  <option value="农业银行">农业银行</option>
                  <option value="在线支付">在线支付</option>
                  <option value="支付宝支付">支付宝支付</option>
                  <option value="公司转帐">公司转帐</option>
                  <option value="云网支付">云网支付</option>
                  <option value="上门交费">上门交费</option>
                  <option value="西联国际汇款">西联国际汇款</option>
                  <option value="公司转帐2">公司转帐2</option>
                  <option value="邮政存折汇款">邮政存折汇款</option>
                  <option value="借款">借款</option>
                  <option value="工行金卡">工行金卡</option>
                  <option value="快钱支付">快钱支付</option>
                </select>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">修改</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="submit" name="Submit" value="修改">
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
          返回</a></p>
      </td>
    </tr>
  </table>
  
</div>

<!--#include virtual="/config/bottom_superadmin.asp" -->
