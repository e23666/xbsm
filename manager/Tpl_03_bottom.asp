<table width="778" border="0" align="center" cellpadding="0" cellspacing="0"> 
<tr> <td bgcolor="#000000"><img src="/Template/Tpl_01/images/spacer.gif" width="3" height="1"></td></tr> 
</table><table width="778" border="0" align="center" cellpadding="0" cellspacing="0"> 
<tr> <td bgcolor="#cc0000"><img src="/Template/Tpl_01/images/spacer.gif" width="3" height="4"></td></tr> 
</table><table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="f2f2f2"> 
<tr> <td width="20" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> <td valign="top"><img src="/Template/Tpl_01/images/Default_219.gif" width="17" height="9"></td></tr> 
</table></td><td width="758"><table width="100%" border="0" cellspacing="0" cellpadding="3"> 
<tr> 
          <td align="center"><strong><a href="/">返回首页</a> |<a href="/aboutus/">关于我们</a> 
            | <a href="/aboutus/contact.asp">联系我们</a> | <a href="/customercenter/howpay.asp">付款方式</a> 
            | <a href="/agent/mode-d.asp">广告联盟</a> | <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">有问必答</a></strong></td>
</tr> 
</table></td></tr> </table><table width="778" border="0" align="center" cellpadding="0" cellspacing="0"> 
<tr> <td bgcolor="3E6388"><img src="/Template/Tpl_01/images/spacer.gif" width="3" height="2"></td></tr> 
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000" style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#3B81C2,endColorStr=#82B0DA);/*IE6*/
background:-moz-linear-gradient(top,#3B81C2,#82B0DA);/*非IE6的其它*/
background:-webkit-gradient(linear, 0% 0%, 0% 100%, from(#3B81C2), to(#82B0DA));/*非IE6的其它*/
%>">
  <tr> 
    <td height="86" valign="top" align="left"> 
      <div align="center"><font color="#FFFFFF"><br>
        版权所有 <%=companyname%>·严禁复制 <br>
        在线客服: 
         <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="点击发送消息给对方"><%=oicqitem%></a>
        <%next%>
        <br>
        服务热线：<%=telphone%>　传真：<%=faxphone%><br>
        信息反馈：</font><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><font color="#FFFFFF">业务咨询</font></a><font color="#FFFFFF"> 
        </font><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><font color="#FFFFFF">技术问题</font></a><font color="#FFFFFF"> 
        </font><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><font color="#FFFFFF">问题投诉</font></a><font color="#FFFFFF"> 
        《中华人民共和国增值电信业务经营许可证》川B2-20030065号 <br>
        </font> <font color="#FFFFFF"> </font> <font color="#FFFFFF"><br>
        </font> </div>
    </td>
  </tr>
</table>
