<div class="DownBlueLine"><img src="/Template/Tpl_05/newimages/spacer.gif" /></div>
<div class="DowndustLine"><img src="/Template/Tpl_05/newimages/spacer.gif" /></div>
<div class="DownContBox">
  <div id="BottomLink">
    <ul>
      <li><a href="/">������ҳ</a></li>
      <li><a href="/aboutus/">��������</a></li>
      <li><a href="/aboutus/contact.asp">��ϵ����</a></li>
      <li><a href="/customercenter/howpay.asp">���ʽ</a></li>
      <li><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp">���ʱش�</a></li>
      <li><a href="http://beian.vhostgo.com/">��վ����</a></li>
      <li><a href="http://www.myhostadmin.net/">�����������</a></li>
    </ul>
  </div>
  <div id="BottomContRight">
    <div id="idclogos">
    <img src="/Template/Tpl_05/newimages/default/xyd_logo.gif" alt="CNNIC���Ǽ�ע��������֤��" width="29" height="29" border="0" /><img src="/Template/Tpl_05/newimages/default/biaoshi-1.gif" alt="Ӫҵִ��" width="29" height="29" border="0" /><a href="http://sc.12321.cn/" target="_blank"></a><img src="/Template/Tpl_05/newimages/default/ico_wj.gif" alt="���Ͼ���" width="29" height="29" border="0" /> <img src="/Template/Tpl_05/newimages/kfmune/53kfindex.gif" alt="��ϵ���߿ͷ�" width="29" height="29" border="0" /><a target=blank href=tencent://message/?uin=<%=oicq%>&Site=<%=companyname%>&Menu=yes><img src="/Template/Tpl_05/newimages/qq_online.jpg" alt="<%=companyname%>�ٷ�QQ" width="29" height="29" border="0" /></a><a href="/manager/default.asp?page_main=/Manager/question/subquestion.asp"><img src="/Template/Tpl_05/newimages/qus.jpg" width="29" height="29" alt="���ʱش�" /></a>
    <img src="/Template/Tpl_05/newimages/sfdw.jpg">
    </div><div id="idclogos">
���л����񹲺͹���ֵ����ҵ��Ӫ����֤����ţ���B2-20080058��</div>
  </div>
  <div id="BottomCont">
    <ul>
      <li>CopyRight &copy; 2002~2011&nbsp;<%=companyname%>&nbsp;��Ȩ����</li>
      <li>�绰�ܻ���<span class="B"><%=telphone%></span>&nbsp;&nbsp;&nbsp;���棺<%=faxphone%></li>
      <li>���߿ͷ��� 
         <%
		for each oicqitem in split(oicq,",")
		%>
         <a target=blank href=tencent://message/?uin=<%=oicqitem%>&Site=<%=companyname%>&Menu=yes><img border="0" src=http://wpa.qq.com/pa?p=1:<%=oicqitem%>:4 alt="���������Ϣ���Է�"><%=oicqitem%></a>
        <%next%>
        
      </li>
    </ul>
  </div>
</div>