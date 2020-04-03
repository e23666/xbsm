<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
sqlArray=Array("p_name,产品名,str","m_bindname,邮局域名,str","m_serverip,对应服务器,str","m_buydate,购买时间,date","m_expiredate,到期时间,date")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="select temp.*,remarks.r_txt  from (SELECT * FROM mailsitelist a INNER JOIN productlist b ON (a.m_productId = b.P_proId)) as temp left join Remarks on (temp.m_sysid=Remarks.p_id and Remarks.r_type=2) where m_status>=0 and  m_ownerid="&session("u_sysid")&" " & newsql & " order by m_buydate desc"

rs.open sqlstring,conn,1,1
    setsize=10
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-企业邮局管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
   <style>
.jcbclass{position: relative;
    display: inline-block;
    padding: 0 6px;
    font-size: 12px;
    text-align: center;
     background-color: #eee!important;
    color: #666!important;
    border-radius: 2px;}
.zybclass{
position: relative;
    display: inline-block;
    padding: 0 6px;
    font-size: 12px;
    text-align: center;
    background-color: #1E9FFF;
    color: #fff;
    border-radius: 2px;
}
</style>
</HEAD>
<body>
  <!--#include virtual="/manager/rengzheng.asp" -->
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>企业邮局管理</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
                         <div class="table_out">
                          <form name=form1 method="post" action="<%=request("script_name")%>">
                           <%=searchlist%>
                           <table class="manager-table">
                               <tr align=middle class="titletr" >
               			         <th  align="center" ><strong>邮局域名</strong></th>
                                 <th  align="center" ><strong>产品名</strong></th>
                                 <th  align="center" ><strong>对应服务器</strong></th>
                                 <th  align="center" ><strong>使用期限</strong></th>
                                 <th align="center"  ><strong>状态</strong></th>
                                 <th  align="center"><strong>操作</strong></th>
                               </tr>
                               <%
               	do while not rs.eof and cur<=setsize
               	tdcolor="#ffffff"
               	if cur mod 2=0 then tdcolor="#EAF5FC"
               	%>
                               <TR align=middle bgcolor="<%=tdcolor%>">
               				 <td style="word-wrap: break-word;word-break:break-all; " ><%= replace(rs("m_bindname"),",","<br>") %>
               				 <img src="/images/1341453609_help.gif" onclick="setmybak(<%=rs("m_sysId")%>,'<%=rs("m_bindname")%>',2)">
               						  <%if trim(rs("r_txt"))<>"" then
               						  response.write("<div class=""hs"">("&rs("r_txt")&")</div>")
               						  end if
               						  %>
               				 </td>
                                 <td  style="word-wrap: break-word;word-break:break-all;" ><a href="manage.asp?p_id=<%=rs("m_sysId")%>"><%= rs("p_name")%><BR>
								    [<%If rs("m_productid")="yunmail" then %>
										<%If rs("m_free") then%>
											基础版
										<%else%>
											专业版
										<%End if%>
									<%else%>
								 
									<%=rs("m_productid")%>
								 <%End if%>]
								 </a></td>

                                 <td  style="word-wrap: break-word;word-break:break-all;"><%= iif(rs("m_productId")="yunmail","-",rs("m_serverip")) %></td>
                                 <td>
								 
							 							 
									<%= formatdatetime(rs("m_buydate"),2) & "购买<br>"%> <%= formatDateTime(rs("m_expiredate"),2) & "到期"%>
								 
								 
								 </td>
                                 <td  style="width:50px;"><%=showstatus(rs("m_productId"),rs("m_status"),rs("m_free"),rs("m_buytest"))%></td>
                                 <td align="center" >
                                  <%If rs("m_productId")="yunmail" then%>
                                     <a href="info.asp?m_id=<%=rs("m_sysId")%>">管理</a>
                                     <a href="info.asp?m_id=<%=rs("m_sysId")%>&act=renew">续费</a>
                                     <a href="info.asp?m_id=<%=rs("m_sysId")%>&act=up">升级</a>
                                 <%else%>
                                    <a href="manage.asp?p_id=<%=rs("m_sysId")%>">管理</a>
                                    <%if rs("m_buytest") then %>
                                    <a href="paytest.asp?m_id=<%=rs("m_sysId")%>">转正</a>
                                    <%else%>
                                    <a href="renewMail.asp?id=<%=rs("m_sysId")%>">续费</a> <a href="upMail.asp?id=<%=rs("m_sysId")%>">升级</a>
                                    <%end if%>
                                   <%end if%>
                                   </td>
                               </tr>
                               <%
               		rs.movenext
               		cur=cur+1
               	Loop

               	%>
                               <tr bgcolor="#FFFFFF">
                                 <td colspan =8 align="center" #EAF5FC><%=pagenumlist%></td>
                               </TR>
                             </form>
                           </table>
                           <%

               	rs.close
               	conn.close
               Function showstatus(productId,svalues,free,buytest)
					If productId="yunmail" Then
						Select Case svalues
							Case 0:	showstatus="<img src=/manager/images/nodong.gif border=0 alt='未开设成功'>"
							Case 1:showstatus="<img src=/images/green2.gif border=0 alt='暂停'>"
							Case 2:showstatus=IIF(free,"<img src=/images/green1.gif border=0 alt='基础版'>","<img src=/images/mail-vip.jpg border=0 alt='专业版'>")
							Case Else
								 showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
						End select 

					else
						if not svalues and not free then
							if buytest then
								showstatus="<img src=/images/yell1.gif border=0 alt='试用邮局'>"
							else
								showstatus="<img src=/images/mail-vip.jpg alt=收费邮局>"
							end if
						else
							Select Case svalues
							  Case 0   '运行
								showstatus="<img src=/images/green1.gif width=17 height=17 alt=免费邮局>"
							  Case -1'
								showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
							  Case else
								showstatus="<img src=/images/nodong2.gif width=17 height=17 alt=免费邮局>"
							End Select
						end If
					end if
               End Function
               %>
           </div>
           <br>
           <table class="manager-table">
             <tr>
               <th width="100%" bgcolor="#C2E3FC" height="21">&nbsp;企业邮局状态图标说明:</th>
             </tr>
             <tr>
                <td width="100%" bgcolor="#FFFFFF" height="20"><p align="center"><img src="/images/mail-vip.jpg" width="15" height="14">收费邮局&nbsp;&nbsp; <img border="0" src="/images/green1.gif">免费邮局&nbsp;&nbsp; <img border="0" src="/images/green2.gif">购买暂停&nbsp;&nbsp; <img border="0" src="/images/yell1.gif">试用运行&nbsp;&nbsp; <img border="0" src="/images/yell2.gif">试用停止&nbsp;&nbsp; <img border="0" src="/images/fei1.gif">邮局已过期&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">被系统停止 <img src="/manager/images/nodong.gif" width="17" height="17">未开设成功 </td>
             </tr>
           </table>
		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>