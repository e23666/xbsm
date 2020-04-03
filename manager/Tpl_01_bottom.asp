<table id="table1" background="/Template/Tpl_01/timages/bottomBg.gif" cellspacing="0" cellpadding="0" width="778" align="center" border="0">
  <tbody>
    <tr>
      <td 
    height="29" align="center"><strong><a href="/"><font color="#FFFFFF">返回首页</font></a> |<a href="/aboutus/"><font color="#FFFFFF">关于我们</font></a> 
            | <a href="/aboutus/contact.asp"><font color="#FFFFFF">联系我们</font></a> | <a href="/customercenter/howpay.asp"><font color="#FFFFFF">付款方式</font></a> 
      | <a href="/agent/mode-d.asp"><font color="#FFFFFF">广告联盟</font></a> | <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><font color="#FFFFFF">有问必答</font></a></strong></td>
    </tr>
  </tbody>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr> 
    <td height="86" valign="top" align="left"> 
      <div align="center"><br>
        版权所有 <%=companyname%>·严禁复制 <br>
        在线客服: 
        <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="点击发送消息给对方"><%=oicqitem%></a>
        <%next%>
        <br>
        服务热线：<%=telphone%>　传真：<%=faxphone%><br>
        信息反馈：<a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">业务咨询</a> 
        <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">技术问题</a> 
        <a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">问题投诉</a> 
        《中华人民共和国增值电信业务经营许可证》川B2-20030065号 <br>
        <br />
       </div>
    </td>
  </tr>
</table>
