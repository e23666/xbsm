<div class="pulic_top">
  <div class="user_info">
    <div class="message">�û�����<span class="redColor"><%=session("user_name")%></span></div>
    <div class="message">��ʹ�ý�� = <span class="redColor"><%=session("u_usemoney")%></span>Ԫ + <span class="redColor"><%=session("u_premoney")%></span>Ԫ (<span style="color:green">�Ż�ȯ</span>)</div>
    <div class="message"><a class="user_cz" href="/customercenter/howpay.asp" target="_blank">�˻���ֵ</a></div>
  </div>
  <div ><%if session("priusername")<>"" then%>
    <a style="font-size:14px; color:#06c" href="<%=InstallDir%>manager/whoami.asp?module=returnme">��ԭ���:<%= session("priusername") %></a>
    <%end if%></div>
  <div class="kuaijie">
    <div class="kj_left">
      <ul>
        <li><a href="/manager/ordermanager/domain/" ><img src="/manager/images/new_tpl/kjie1.gif"  /></a>
          <div class="kj_link"><a href="/manager/ordermanager/domain/"  >��������</a></div>
        </li>
        <li><a href="/manager/useraccount/fapiao.asp" ><img src="/manager/images/new_tpl/kjie5.gif"  /></a>
          <div class="kj_link"><a href="/manager/useraccount/fapiao.asp"  >��Ʊ��ȡ</a></div>
        </li>
        <li><a href="/manager/useraccount/mlist.asp" ><img src="/manager/images/new_tpl/kjie4.gif"  /></a>
          <div class="kj_link"><a href="/manager/useraccount/mlist.asp"  >������ϸ</a></div>
        </li>
        <li><a href="/manager/question/subquestion.asp" ><img src="/manager/images/new_tpl/kjie2.gif"  /></a>
          <div class="kj_link"><a href="/manager/question/subquestion.asp"  >��Ҫ����</a></div>
        </li>
        <li><a href="<%=InstallDir%>faq" target="_blank"><img src="/manager/images/new_tpl/kjie3.gif"  /></a>
          <div class="kj_link"><a href="<%=InstallDir%>faq" target="_blank" >��������</a></div>
        </li>
      </ul>
    </div>
    <div class="kj_right">
      <div class="kj_title">��ݲ˵�</div>
      <div class="kj_main">
        <ul>
          <li><a href="/manager/domainmanager">��������</a></li>
          <li><a href="/manager/sitemanager">������������</a></li>
          <li><a href="/manager/mailmanager">�ʾֹ���</a></li>
          <li><a href="/customercenter/howpay.asp" target="_blank">Ԥ����֧��</a></li>
          <li><a href="/manager/usermanager/default2.asp" >���������޸�</a></li>
          <li><a href="http://www.myhostadmin.net" target="_blank">�����������</a></li>
        </ul>
      </div>
      <div class="kj_bottom"></div>
    </div>
  </div>
</div>
