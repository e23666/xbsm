<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet><body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>产品管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="addPro.asp">新增产品</a> | <a href="default.asp?module=search&p_type=1">空间</a> | <a href="default.asp?module=search&p_type=2">邮局</a> | <a href="default.asp?module=search&p_type=3">域名</a> | <a href="default.asp?module=search&p_type=3">网站推广</a> |<a href="default.asp?module=search&p_type=7"> 数据库</a></td>
  </tr>
</table>
<br><form action="addpro.asp" name =form1 method=post>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="border">

                  <%

on error resume next 
module=Requesta("module")
If module="productadd" Then
p_appid=Requesta("p_appid")
p_server=Requesta("p_server")
p_name=Requesta("p_name")
p_maxmen=Requesta("p_maxmen")
P_proId=Requesta("P_proId")
p_price=Requesta("p_price")
p_picture=Requesta("p_picture")
p_memo=Requesta("p_memo")
p_size=Requesta("p_size")
p_type=Requesta("p_type")
p_info=Requesta("p_info")
plevel=Requesta("level")
p_test=Requesta("p_test")
p_traffic=Requesta("p_traffic")
if not isnumeric(p_traffic) then p_traffic=0
If p_test="" Then  p_test=0
lparray=split(plevel,",")
conn.open constr
'---- 命令对象类型：存贮过程 ----

sql="select * from pricelist where (p_proid='"&P_proId&"')"
rs.open sql,conn,1,3
if not rs.eof then
	url_return "产品编号重复！",-1
end if
rs.close

sql="select p_name from productlist where p_name='"&p_name&"'"
rs.open sql,conn,1,3
if not rs.eof then
	url_return "产品名称重复！",-1
end if
rs.close

sql="insert into productlist (p_test,p_fatherid , p_info ,p_traffic, p_picture ,p_size , p_type , p_price , p_proid , p_memo , p_years , p_maxmen ,p_company , p_name , p_server ,p_appid) values ("&p_test&",0 , '"&p_info&"' ,'"&p_traffic&"', '"&p_picture&"' ,"&p_size&" , "&p_type&" , "&p_price&" , '"&P_proId&"' , '"&p_memo&"' , 1 , "&p_maxmen&" ,0 , '"&p_name&"' , "&p_server&" ,"&p_appid&")"
conn.execute(sql)
if err then
response.write "发生错误，可能是输入的值不正确，请返回重新输入！"

response.write err.description 
response.end
end if
for i=0 to ubound(lparray)
	sql="insert into pricelist  (p_u_level,u_id ,p_father , p_proid , p_price) values ("& (i+1) &",0,0,'"&P_proId&"',"&lparray(i)&")"
	conn.execute(sql)
next


Response.write " <tr><td colspan=2><center><font color=bule size=4>产品添加成功</font>  </center></td></tr>"
End If
%>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg" width="35%">　产品名称:</td>
                    <td class="tdbg"> 
                      <input name="module" type="hidden" value="productadd">
                      <input name="p_name" size="10">
        （可以自定义产品名称，如：专业型虚拟主机） </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品编号:</td>
                    <td class="tdbg"> 
                    <input name="P_proId" size="10">
        (必须跟上级服务器商的编号相同，如 b002) </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　子站数量:</td>
                    <td class="tdbg"> 
                    
        <input name="p_picture" size="10" value="0">
        （可以不填） </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品大小:</td>
                    <td class="tdbg"> 
                      <input name="p_size" size="10">
        M &nbsp;&nbsp;邮局或者空间的大小，只填数字，不用填M.</td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　每月流量:</td>
                    <td class="tdbg"> 
                      <input name="p_traffic" size="10" value="0">
        G 只填数字，不用填G,邮局等产品可以不填。</td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品类型:</td>
                    <td class="tdbg"> 
                    <%
	Response.Write "<SELECT name=p_type>"
 	conn.open constr
	sql="select * from producttype order by pt_id asc"
	rs1.open sql,conn,3
	do while not rs1.eof
		Response.Write "<OPTION value="&rs1("pt_id")&"> "&rs1("pt_name")&" </OPTION>"
	rs1.movenext
	loop
	rs1.close
	Response.Write "</select>"
%>                    </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品权限:</td>
                    <td class="tdbg"> 
                      <select name="p_appid">
                        <option selected>--- 请选择权限 ---</option>
                        <option value="111">ASP + CGI + php</option>
                        <option value="1">ASP</option>
                        <option value="11">ASP + CGI</option>
                        <option value="10">CGI</option>
                        <option value="100">PHP</option>
                        <option value="110">asp.net</option>
                        <option value="12">ASP + asp.net +cgi</option>
                        <option value="0">纯html</option>
                        <option value="0">其他产品</option>
                    </select>                    </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">虚拟主机是否试用:</td>
                    <td class="tdbg"> 
                      <SELECT name=p_test>
                        <OPTION value=0>可以</OPTION>
                        <OPTION value=1>不能</OPTION>
                    </select>                    </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　最大用户:</td>
                    <td class="tdbg"> 
                      <input name="p_maxmen" size="10">
        邮局适用（其他产品填0）</td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　机器类型:</td>
                    <td class="tdbg"> 
                    <%
	Response.Write "<SELECT name=p_server>"
	Response.Write "<OPTION value=""0""> 选择服务器类型/其他产品不用选 </OPTION>"
	sql="select * from server_type order by server_type_id asc"
	rs1.open sql,conn,3
	do while not rs1.eof
		Response.Write "<OPTION value="&rs1("server_type_num")&"> "&rs1("server_type_name")&" </OPTION>"
	rs1.movenext
	loop
	rs1.close
	Response.Write "</select>"
%>                    </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品价格:</td>
                    <td class="tdbg"> 
                    <input name="p_price" size="10">
        产品在前台显示的价格。 </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品说明:</td>
                    <td class="tdbg"> 
                    <input name="p_info" size="30">
        定义产品的说明。 </td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    <td align="right" class="tdbg">　产品备注:</td>
                    <td class="tdbg"> 
                      <input name="p_memo" size="30">
        &nbsp;&nbsp;&nbsp;&nbsp;填写产品的备注。</td>
    </tr>
                  <tr bgcolor="#eeeeee"> 
                    
      <td   align="middle" class="tdbg">　
        <div align="right">产品定价</div>
      </td>
	  <td></td>
    </tr>
    <%
	rs1.open "select * from levellist order by l_level asc",conn,1,1
	if not rs1.eof then
	do while not rs1.eof
	
	%>
     <TR bgColor=#EEEEEE><TD vAlign=bottom  align="right" ><%=rs1("l_level")%> <%=rs1("l_name")%></TD><TD width=361><INPUT size=10 name=level >元(整数)</TD></TR>
   <%
   	rs1.movenext
   loop
   end if
   rs1.close
   %>               
                  <tr bgcolor="#FFFFFF" align="center"> 
                    <td colspan="2" class="tdbg"> 
                    <input name="sub" type="submit" value=" 确定添加产品 ">                    </td>
    </tr>
            
</table>    </form>

<!--#include virtual="/config/bottom_superadmin.asp" -->
