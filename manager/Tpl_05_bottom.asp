<div class="DownBlueLine"><img src="/Template/Tpl_05/newimages/spacer.gif" /></div>
<div class="DowndustLine"><img src="/Template/Tpl_05/newimages/spacer.gif" /></div>
<div class="DownContBox">
  <div id="BottomLink">
    <ul>
      <li><a href="/">返回首页</a></li>
      <li><a href="/aboutus/">关于我们</a></li>
      <li><a href="/aboutus/contact.asp">联系我们</a></li>
      <li><a href="/customercenter/howpay.asp">付款方式</a></li>
      <li><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">有问必答</a></li>
      <li><a href="http://beian.vhostgo.com/">网站备案</a></li>
      <li><a href="http://www.myhostadmin.net/">独立控制面板</a></li>
    </ul>
  </div>
  <div id="BottomContRight">
    <div id="idclogos">
    <img src="/Template/Tpl_05/newimages/default/xyd_logo.gif" alt="CNNIC四星级注册服务机构证书" width="29" height="29" border="0" /><img src="/Template/Tpl_05/newimages/default/biaoshi-1.gif" alt="营业执照" width="29" height="29" border="0" /><a href="http://sc.12321.cn/" target="_blank"></a><img src="/Template/Tpl_05/newimages/default/ico_wj.gif" alt="网上警察" width="29" height="29" border="0" /> <img src="/Template/Tpl_05/newimages/kfmune/53kfindex.gif" alt="联系在线客服" width="29" height="29" border="0" /><a target=blank href=tencent://message/?uin=<%=oicq%>&Site=<%=companyname%>&Menu=yes><img src="/Template/Tpl_05/newimages/qq_online.jpg" alt="<%=companyname%>官方QQ" width="29" height="29" border="0" /></a><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><img src="/Template/Tpl_05/newimages/qus.jpg" width="29" height="29" alt="有问必答" /></a>
    <img src="/Template/Tpl_05/newimages/sfdw.jpg">
    </div><div id="idclogos">
《中华人民共和国增值电信业务经营许可证》编号：川B2-20080058号</div>
  </div>
  <div id="BottomCont">
    <ul>
      <li>CopyRight &copy; 2002~2011&nbsp;<%=companyname%>&nbsp;版权所有</li>
      <li>电话总机：<span class="B"><%=telphone%></span>&nbsp;&nbsp;&nbsp;传真：<%=faxphone%></li>
      <li>在线客服： 
         <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="点击发送消息给对方"><%=oicqitem%></a>
        <%next%>
        
      </li>
    </ul>
  </div>
</div>
