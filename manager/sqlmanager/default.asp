<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
sqlArray=Array("dbname,���ݿ���,str","dbserverip,IP��ַ,str","dbbuydate,��ͨ����,date","dbexpdate,��������,date","p_name,��Ʒ��,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)

sqlstring="SELECT  productlist.p_name, databaselist.dbname,databaselist.dbpasswd,UserDetail.u_name, databaselist.dbserverip, databaselist.dbbuydate, databaselist.dbexpdate, databaselist.dbstatus, databaselist.dbsysid,databaselist.dbbuytest FROM (databaselist INNER JOIN productlist ON databaselist.dbproid = productlist.P_proId) INNER JOIN UserDetail ON databaselist.dbu_id = UserDetail.u_id where dbu_id=" & session("u_sysid") & " "& newsql & " order by dbbuydate desc"
    rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-��������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>

</HEAD>
<body>
 <!--#include virtual="/manager/rengzheng.asp" -->
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li>Mssql���ݿ����</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">
              <form name="form1" action="<%=request("script_name")%>" method="post">
              <%=searchlist%>
               <table class="manager-table">

                         <TR align=middle class='titletr'>

                           <th align="center" nowrap ><strong>���ݿ���</strong></th>
                           <th align="center" nowrap ><strong>��Ʒ��</strong></th>
                           <th align="center" nowrap ><strong>IP��ַ</strong></th>
                           <th align="center" nowrap ><strong>��ͨ����</strong></th>
                           <th align="center" nowrap ><strong>��������</strong></th>
                           <th align="center" nowrap ><strong>״̬</strong></th>
                           <th align="center" nowrap ><strong>����</strong></th>
                         </TR>
                         <%Do While Not rs.eof and cur<=setsize
               		  		tdcolor="#ffffff"
               				if cur mod 2=0 then tdcolor="#efefef"
               		  %>
                         <TR align=center >

                           <td   class="tdbg" style="word-wrap: break-word;word-break:break-all;"><a href="manage.asp?p_id=<%=rs("dbsysid")%>"><%= rs("dbname") %></a></td>
                           <td  class="tdbg" style="word-wrap: break-word;word-break:break-all;"><%= rs("p_name")%></td>
                           <td   class="tdbg" style="word-wrap: break-word;word-break:break-all;"><%= rs("dbserverip") %></td>
                           <td  class="tdbg"><%= formatDateTime(rs("dbbuydate"),2)%></td>
                           <td   class="tdbg"><%= formatDateTime(rs("dbexpdate"),2)%></td>
                           <td   class="tdbg"><%
               			if datediff("d",now(),rs("dbexpdate"))<0 then
                           response.write " <img border=""0"" src=""/images/fei1.gif"">"
               			else
               			 response.write showstatus(rs("dbstatus"),rs("dbbuytest"))
               			end if%></td>
                           <td   class="tdbg">
                           <a href="manage.asp?p_id=<%=rs("dbsysid")%>">����</a>&nbsp;
                           <%if rs("dbbuytest") then %>
                      			 <a href="paytest.asp?id=<%=rs("dbsysId")%>">ת��</a>
               			<%else%>
                           	<a href="updata.asp?id=<%=rs("dbsysid")%>">����</a>
                           	<a href="renewdata.asp?id=<%=rs("dbsysid")%>">����</a>
                           <%end if%>

                           </td>
                         </tr>
                         <%

               			 rs.movenext
               		 	cur=cur+1
               		  loop
               	%>
                       <tr align="center">
                       <td colspan="10" class="tdbg"><%=pagenumlist%></td>
                       </tr>
                       </table>
                            </form>
                       <%
               rs.close
               conn.close

               Function showstatus(svalues,byval buytest)
               	Select Case svalues
               	  Case 0   '����
               	  	if buytest then
               			showstatus="<img src=/images/yell1.gif width=17 height=17 title='��������'>"
               		else
               		showstatus="<img src=../images/green1.gif width=17 height=17>"
               		end if
               	  Case -1'
               		showstatus="<img src=../images/nodong.gif width=17 height=17>"
               	  Case else
               		showstatus="<img src=../images/nodong.gif width=17 height=17>"
               	End Select
               End Function
               %>
               <br/>
               <table class="manager-table">
                            <tbody><tr>
                              <th width="100%" bgcolor="#C2E3FC" height="21">&nbsp;���ݿ�״̬ͼ��˵��:</th>
                            </tr>
                            <tr>
                               <td width="100%" bgcolor="#FFFFFF" height="21">
                                                                           <p align="center"><img border="0" src="/images/green1.gif">��������<img border="0" src="/images/green2.gif">������ͣ&nbsp;
                                                                             <img border="0" src="/images/fei1.gif">�ѹ���&nbsp;&nbsp; <img border="0" src="/images/sysstop.gif">��ϵͳֹͣ
                                                                             <img src="/manager/images/nodong.gif" width="17" height="17">δ����ɹ�
                                                                         </td>
                            </tr>
                          </tbody>
                          </table>

		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>