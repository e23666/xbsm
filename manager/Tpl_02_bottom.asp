
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="bbbbbb"><img src="/template/Tpl_02/images/spacer.gif" width="1" height="2" /></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="494949"><img src="/template/Tpl_02/images/spacer.gif" width="1" height="7" /></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="6" cellspacing="0" bgcolor="ebebeb">
  <tr>
    <td width="124" align="center">&nbsp;</td>
    <td width="630"><a href="/">返回首页</a> |<a href="/aboutus/">关于我们</a> | <a href="/aboutus/contact.asp">联系我们</a> | <a href="/customercenter/howpay.asp">付款方式</a> | <a href="/agent/mode-d.asp">广告联盟</a> | <a href="/manager/default.asp?page_main=%2FManager%2Fquestion%2Fsubquestion%2Easp">有问必答</a></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
    <td>公司地址：<%=companyaddress%>　邮编：<%=postcode%><br>
      电话总机：<%=telphone%> 晚上0点以后拔<%=nightphone%><br>
      <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="点击发送消息给对方"><%=oicqitem%></a>
        <%next%>    </td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="6" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td align="center">版权所有 <%=companyname%><br>
      CopyRight (c) 2002~2008 <a href="{companynameurl}"><%=companynameurl%></a> 
      all right reserved.</td>
  </tr>
</table>