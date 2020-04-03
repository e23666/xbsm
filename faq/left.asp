<%If LCase(USEtemplate)="tpl_2016" then
tempid=requesta("id")
if not isnumeric(tempid&"") then tempid=0
%>
    <!--左侧导航 开始-->

    <div class="navbar-left">
        <div class="nl-title">常见问题</div>
        <ul class="nl-list">
         <li class="item <%if clng(tempid)=0 then response.write("active")%>"><a href="/faq/index.asp">首页<i></i></a></li>
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
    <!--左侧导航 结束-->

	<%else%>
<div id="MainLeft">
      <div class="DomainLeftMenu">
        <div id="DoaminLeftHead">常见问题</div>
        <div id="DomainLeftMenuContent">
          <ul>
            <li><a href="/faq/index.asp">首页</a></li>
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
        <div id="DoaminLeftHead_blue"><img src="/Template/Tpl_05/newimages/Domains/20080524152554784.gif" width="10" height="10" /> 为何选择我们</div>
        <div id="DomainLeftMenuContentList">
          <div>
            <ul>
              <li>7年优质服务经验</li>
              <li>10万用户的共同选择</li>
              <li>更低的价格更好的服务</li>
              <li>CNNIC四星级认证服务商</li>
              <li>拥有正规经营许可证(ICP)</li>
              <li>先进的解析技术10分钟生效</li>
              <li>6组DNS负载均衡更快更稳定</li>
            </ul>
          </div>
        </div>
        <div id="DomainLeftMenuBottom"><img src="/Template/Tpl_05/newimages/Domains/LeftMenu_buttom.gif" width="201" height="8" /></div>
      </div>
      <div id="DomainLeftGuestSay"><a href="/agent/"><img src="/Template/Tpl_05/newimages/Domains/guest_Say_ico.jpg" width="200" height="85" /></a></div>
    </div>


	<%End if%>