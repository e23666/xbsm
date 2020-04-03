<!--#include file="head.asp"-->
<%If LCase(USEtemplate)="tpl_2016" then%>
  <div id="content">
    <div class="content">
      <div class="wide1190 pt-40 cl">
<%else%>
 <div id="SiteMapPath">
    <ul>
 <li><a href="/">首页</a></li>
      <li><a href="/customercenter/">客服中心</a></li>
      <li><a href="/faq/">常见问题</a></li>
    </ul>
  </div>
<div id="MainContentDIV">

<%End if%>

      <!--#include file="left.asp"-->
      <div class="Faq_Div content-right cl">
            <div id="content_Div">
              <div class="contact_inf">
                <div class="cc_Title B">最新文章</div>
                <div class="auto_hight">
                  <div class="tui_div PIC_ul_li">
                    <ul>
                      	<%
      				Sql = "Select top 2 Unid,DefaultPic,title from article_info where DefaultPic<>'' and vouch<>'0' and Audit = 0 order by vouch desc"
      				set Rs = conn.execute(Sql)
      				if Rs.eof and rs.bof then
      					Response.write "<div align=center>还没有推荐文章。</div>"
      				else
      					do while not rs.eof

      						Response.write "<li><a href=list.asp?unid="& rs(0) &" target='"& AddOpenWin &"'>"& replace(rs(1),"width=120 height=90 vspace=5 border=0","vspace=5 border=0 width="& Pwidth &" height="& Pheight &"") &"</a><br>"
      						Response.write "<span style='width:90%'><a href=list.asp?unid="& rs(0) &" target='"& AddOpenWin &"'>"& 	Qcdn.HTMLcode(rs(2)) &"</a></span></li>"

      					rs.movenext
      					loop
      				end if
      				rs.close
      				%>

                    </ul>
                  </div>
                  <div class="new_div">
                    <%Call Qcdn.Toplist("12","Unid",1)%>
                  </div>
                </div>

              </div>

              <ul class="Morenewslist">


                  <!--#include file="sortmod.asp"-->

      <%if AddNav then%>
      <!--#include file="navigation.asp"-->
      <%end if%>









              </ul>
            </div>
          </div>
		  <%If LCase(USEtemplate)<>"tpl_2016" then%>
				<!--#include file="right.asp"-->
		   <%End if%>
      </div>
      </div>
      </div>



 <!--#include file="copy.asp"-->