
    <!--��ർ�� ��ʼ-->

    <div class="navbar-left">
        <div class="nl-title">��������</div>
        <ul class="nl-list">
         <li class="item active"><a href="/faq/index.asp">��ҳ<i></i></a></li>
                    <%
        			 set crs=Server.CreateObject("adodb.recordset")
         sql="select   * from article_class where flag=0 order by unid asc"
         crs.open sql,conn,1,3
         do while not crs.eof
         			%>
           <li class="item "><a href=2j.asp?id=<%=crs("Unid")%>><%=crs("ClassName")%><i></i></a></li>
         <%crs.movenext
         loop%>


        </ul>
    </div>
    <!--��ർ�� ����-->