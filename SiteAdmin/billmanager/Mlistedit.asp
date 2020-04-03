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
response.write "sysid 为空!"
response.end
end if

sql="select * from countlist  where sysid="&sysid
  conn.open constr
 Rs.open Sql,conn,3,2
if  rs.eof then 
response.write "没有这条记录!"
response.end
end if


if requesta("act")="del" then
Check_Is_Master(1)
sql="delete from countlist where sysid="&sysid
conn.execute(sql)
response.Write("<script>alert(""删除成功!"");history.back();</script>")
		response.End()


end if


c_memo=rs("c_memo")

if not rs("c_check") then
Check_Is_Master(1)
'response.write "已经审核过的不能修改!"
'response.end
end if


if requesta("moneytype")<>""  then
   if trim(requesta("moneytype"))="上门交费" then
     Check_Is_Master(1)
   end if

  sql="select * from countlist where sysid="&sysid
         rs11.open sql,conn,1,3  
		 if not rs11.eof then  
		   if trim(rs11("c_memo"))="上门交费" then  Check_Is_Master(1)
                          sql_money="select * from ourMoney where payDate=#"& rs11("c_date") &"# and PayMethod='"& trim(rs11("c_memo")) &"' and Amount="& trim(rs11("u_moneysum")) &" and UserName = (select u_name  from UserDetail where u_id="& trim(rs11("u_id")) &" )"
						  response.write sql_money
	                      rs1.open sql_money,conn,1,3
						  if not rs1.eof then
								c_date=requesta("newdate")
								if not isdate(c_date) then
									response.Write("<script>alert(""日期格式错误"");history.back();</script>")
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
									response.Write("<script>alert(""日期格式错误"");history.back();</script>")
									response.End()
								else
									if datediff("d",date(),c_date)<-30 then
										s_newdate=rs11("c_date")
									else
										s_newdate=c_date
									end if
								end if
           rs11("c_memo")= trim(requesta("moneytype"))'银行
		   rs11("c_date")=s_newdate'时期
		   rs11("u_countId")=trim(requesta("u_countId"))'凭证编号
           rs11.update     
        end if
		rs11.close
		
		
'sql="update countlist set c_memo='"&requesta("moneytype")&"',c_date='"&requesta("newdate")&"',u_countId='"&requesta("u_countId")&"' where sysid="&sysid
'conn.execute(sql)
		response.Write("<script>alert(""修改成功!"");history.back();</script>")
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
              <td width="137" height="1" valign="bottom" bgcolor="#E8E8E8">项目</td>
              <td width="71"  height="1" valign="bottom" bgcolor="#E8E8E8" >值</td>
            </tr>
            <%
    PageCount=0
  	   i=0

	Do While Not rs.eof And i<20
	%>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center"><font color="#000000">凭证单号 
                </font></td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="u_countId" value="<%=rs("u_countId")%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">发生金额</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <%=rs("u_moneysum")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">入账</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
               <%=rs("u_in")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">支出</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
       <%=rs("u_out")%>
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">时间</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <input type="text" name="newdate" size="15" value="<%=formatdatetime(rs("c_date"),2)%>">
                </font></td>
            </tr>
            <tr align=middle bgcolor="#FFFFFF"> 
              <td width="137" height="28" valign="center">款项类型</td>
              <td width="71" height="28" valign="center"><font color="#000000"> 
                <select name="moneytype" id="sid4">
                  <option value="邮政汇款"<%if c_memo="邮政汇款" then%> selected<%end if%>>邮政汇款</option>
                  <option value="招商银行"<%if c_memo="招商银行" then%> selected<%end if%>>招商银行</option>
                  <option value="招行2号"<%if c_memo="招行2号" then%> selected<%end if%>>招行2号</option>
                  <option value="财富通支付"<%if c_memo="财富通支付" then%> selected<%end if%>>财富通支付</option>

                  <option value="交通银行"<%if c_memo="交通银行" then%> selected<%end if%>>交通银行</option>
                  <option value="建设银行"<%if c_memo="建设银行" then%> selected<%end if%>>建设银行</option>
                  <option value="工商银行"<%if c_memo="工商银行" then%> selected<%end if%>>工商银行</option>
                  <option value="农业银行"<%if c_memo="农业银行" then%> selected<%end if%>>农业银行</option>
                  <option value="在线支付"<%if c_memo="在线支付" then%> selected<%end if%>>在线支付</option>
                  <option value="支付宝支付"<%if c_memo="支付宝支付" then%> selected<%end if%>>支付宝支付</option>
                  <option value="农业银行2"<%if c_memo="农业银行2" then%> selected<%end if%>>农业银行2</option>

                  <option value="公司转帐"<%if c_memo="公司转帐" then%> selected<%end if%>>公司转帐</option>
                  <option value="上门交费"<%if c_memo="上门交费" then%> selected<%end if%>>上门交费</option>
                  <option value="西联国际汇款"<%if c_memo="西联国际汇款" then%> selected<%end if%>>西联国际汇款</option>
                  <option value="公司转帐2"<%if c_memo="公司转帐2" then%> selected<%end if%>>公司转帐2</option>
                  <option value="邮政存折汇款"<%if c_memo="邮政存折汇款" then%> selected<%end if%>>邮政存折汇款</option>
                  <option value="云网支付"<%if c_memo="云网支付" then%> selected<%end if%>>云网支付</option>
                  <option value="快钱支付"<%if c_memo="快钱支付" then%> selected<%end if%>>快钱支付</option>

                  <option value="借款"<%if c_memo="借款" then%> selected<%end if%>>借款</option>
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
      </td>
    </tr>
  </table>
  
</div>

<!--#include virtual="/config/bottom_superadmin.asp" -->
