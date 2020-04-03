<div class="pulic_top">
  <div class="user_info">
    <div class="message">用户名：<span class="redColor"><%=session("user_name")%></span></div>
    <div class="message">可使用金额 = <span class="redColor"><%=session("u_usemoney")%></span>元 + <span class="redColor"><%=session("u_premoney")%></span>元 (<span style="color:green">优惠券</span>)</div>
    <div class="message"><a class="user_cz" href="/customercenter/howpay.asp" target="_blank">账户充值</a></div>
  </div>
  <div ><%if session("priusername")<>"" then%>
    <a style="font-size:14px; color:#06c" href="<%=InstallDir%>manager/whoami.asp?module=returnme">还原身份:<%= session("priusername") %></a>
    <%end if%></div>
  <div class="kuaijie">
    <div class="kj_left">
      <ul>
        <li><a href="/manager/ordermanager/domain/" ><img src="/manager/images/new_tpl/kjie1.gif"  /></a>
          <div class="kj_link"><a href="/manager/ordermanager/domain/"  >域名订单</a></div>
        </li>
        <li><a href="/manager/useraccount/fapiao.asp" ><img src="/manager/images/new_tpl/kjie5.gif"  /></a>
          <div class="kj_link"><a href="/manager/useraccount/fapiao.asp"  >发票索取</a></div>
        </li>
        <li><a href="/manager/useraccount/mlist.asp" ><img src="/manager/images/new_tpl/kjie4.gif"  /></a>
          <div class="kj_link"><a href="/manager/useraccount/mlist.asp"  >财务明细</a></div>
        </li>
        <li><a href="/manager/question/subquestion.asp" ><img src="/manager/images/new_tpl/kjie2.gif"  /></a>
          <div class="kj_link"><a href="/manager/question/subquestion.asp"  >我要提问</a></div>
        </li>
        <li><a href="<%=InstallDir%>faq" target="_blank"><img src="/manager/images/new_tpl/kjie3.gif"  /></a>
          <div class="kj_link"><a href="<%=InstallDir%>faq" target="_blank" >常见问题</a></div>
        </li>
      </ul>
    </div>
    <div class="kj_right">
      <div class="kj_title">快捷菜单</div>
      <div class="kj_main">
        <ul>
          <li><a href="/manager/domainmanager">域名管理</a></li>
          <li><a href="/manager/sitemanager">虚拟主机管理</a></li>
          <li><a href="/manager/mailmanager">邮局管理</a></li>
          <li><a href="/customercenter/howpay.asp" target="_blank">预付款支付</a></li>
          <li><a href="/manager/usermanager/default2.asp" >个人资料修改</a></li>
          <li><a href="http://www.myhostadmin.net" target="_blank">独立控制面板</a></li>
        </ul>
      </div>
      <div class="kj_bottom"></div>
    </div>
  </div>
</div>
