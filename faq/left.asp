<%If LCase(USEtemplate)="tpl_2016" then
tempid=requesta("id")
if not isnumeric(tempid&"") then tempid=0
%>
    <!--��ർ�� ��ʼ-->

    <div class="navbar-left">
        <div class="nl-title">��������</div>
        <ul class="nl-list">
         <li class="item <%if clng(tempid)=0 then response.write("active")%>"><a href="/faq/index.asp">��ҳ<i></i></a></li>
                    <%
        			 set crs=Server.CreateObject("adodb.recordset")
         sql="select   * from article_class where flag=0 order by unid asc"
         crs.open sql,conn,1,3
         do while not crs.eof
         			%>
           <li class="item <%if clng(tempid)=clng(crs("unid")) then response.write("active")%>"><a href=2j.asp?id=<%=crs("Unid")%>><%=crs("ClassName")%><i></i></a></li>
         <%crs.movenext
         loop%>


        </ul>
    </div>
    <!--��ർ�� ����-->

	<%else%>
<div id="MainLeft">
      <div class="DomainLeftMenu">
        <div id="DoaminLeftHead">��������</div>
        <div id="DomainLeftMenuContent">
          <ul>
            <li><a href="/faq/index.asp">��ҳ</a></li>
            <%
			 set crs=Server.CreateObject("adodb.recordset")
 sql="select   * from article_class where flag=0 order by unid asc"
 crs.open sql,conn,1,3
 do while not crs.eof
 			%>
   <li><a href=2j.asp?id=<%=crs("Unid")%>><%=crs("ClassName")%></a></li>          
 <%crs.movenext
 loop%>           
       
          </ul>
        </div>
        <div id="DomainLeftMenuBottom"><img src="/Template/Tpl_05/newimages/Domains/LeftMenu_buttom.gif" width="201" height="8" /></div>
      </div>
      <div class="DomainLeftMenu">
        <div id="DoaminLeftHead_blue"><img src="/Template/Tpl_05/newimages/Domains/20080524152554784.gif" width="10" height="10" /> Ϊ��ѡ������</div>
        <div id="DomainLeftMenuContentList">
          <div>
            <ul>
              <li>7�����ʷ�����</li>
              <li>10���û��Ĺ�ͬѡ��</li>
              <li>���͵ļ۸���õķ���</li>
              <li>CNNIC���Ǽ���֤������</li>
              <li>ӵ�����澭Ӫ���֤(ICP)</li>
              <li>�Ƚ��Ľ�������10������Ч</li>
              <li>6��DNS���ؾ��������ȶ�</li>
            </ul>
          </div>
        </div>
        <div id="DomainLeftMenuBottom"><img src="/Template/Tpl_05/newimages/Domains/LeftMenu_buttom.gif" width="201" height="8" /></div>
      </div>
      <div id="DomainLeftGuestSay"><a href="/agent/"><img src="/Template/Tpl_05/newimages/Domains/guest_Say_ico.jpg" width="200" height="85" /></a></div>
    </div>


	<%End if%>