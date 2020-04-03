<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
conn.open constr
if requesta("act")="chkba" then
domain=requesta("domain")
			result=querybeian(domain,0,icpNo)
			beianstate="-1"
			icpNostate="" 
			if result="0" then 
				beianstate="0"
				 
			elseif result="999" then
				beianstate=999
			end if
die beianstate
end if



act=requesta("act")
eday=requesta("eday")
sday=0
if not  isnumeric(eday&"")  then eday=7
'if eday<0 then eday=1
if eday>30 then eday=30
if instr(",db,vhost,domain,mail,server,",","&act&",")=0 then act="domain"

uid=session("u_sysid")
betweenstr=" between "&sday&" and "&eday
strogher=""
if eday<0 then
eday=-1
betweenstr=" between -1 and -9999"
strogher="<font color=red>已过期</font>"
end if

if trim(act)="" then act="domain"
       
%>
<HEAD>
<title>用户管理后台-推广产品管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
if ( top.location !== self.location ) top.location=self.location; 
function goto(d,a)
{
	url="?eday="+d+"&act="+a;
	location.href=url;

}
$(function(){
	    $("input[name='chkall']:checkbox").click(function(){
 
			 $("input[type='checkbox']").attr("checked",$(this).attr("checked"));	
			})
			
			
		$("input[name='plredomin']").click(function(){
			var str="";
			var arrChk=$("input[name='checkdomain']:checked");
			$(arrChk).each(function(){
				if(str=="")
				{str=this.value}else
				{str+="\r\n"+this.value;}
			
			}); 
				
			if(str!="")
			{
				$("#redomin").val(str);
					$("form[name='renewdomain']").submit()
			}else{
				alert("请选择域名");
				return false
				}
			
			
			})
	
	})
	


 
 
 
</script> 


</HEAD>

<body>

<!--#include virtual="/manager/top.asp" -->

<div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">首页</a></li>
			   <li><a href="/Manager/">管理中心</a></li>
			   <li>最近到期业务</li>
			 </ul>
		  </div>
		  <style>
           .abtn-out a{margin: 0px 10px;}
           </style>
		  <ul class="manager-tab">
          				 <li <%if  trim(act)="domain" then response.Write(" class=""liactive""")%> ><a href="javascript:void(0);" onclick="goto(<%=eday%>,'domain')">域名</a> </li>
                          								  <li  <%if  trim(act)="vhost" then response.Write(" class=""liactive""")%> ><a href="javascript:void(0);" onclick="goto(<%=eday%>,'vhost')">虚拟主机</a></li>
                          								  <li  <%if  trim(act)="server" then response.Write(" class=""liactive""")%> ><a href="javascript:void(0);" onclick="goto(<%=eday%>,'server')">VPS/云主机</a></li>
                          								  <li  <%if  trim(act)="mail" then response.Write(" class=""liactive""")%> ><a href="javascript:void(0);" onclick="goto(<%=eday%>,'mail')">企业邮局</a></li>
                          								  <li  <%if  trim(act)="db" then response.Write(" class=""liactive""")%> ><a href="javascript:void(0);" onclick="goto(<%=eday%>,'db')">MSSQL</a></li>
          </ul>
		  <div class="manager-right-bg">
<div class="new_right">
<div class="mt-10 mb-10 abtn-out">
<a href="javascript:void(0);" onclick="goto(30,'<%=act%>')" <%if clng(eday)=30 then response.Write(" class=""manager-btn s-btn""")%>>30天内</a>
<a href="javascript:void(0);" onclick="goto(15,'<%=act%>')" <%if clng(eday)=15 then response.Write(" class=""manager-btn s-btn""")%>>15天内</a>
<a href="javascript:void(0);" onclick="goto(7,'<%=act%>')" <%if clng(eday)=7 then response.Write(" class=""manager-btn s-btn""")%>>7天内</a>
<a href="javascript:void(0);" onclick="goto(3,'<%=act%>')" <%if clng(eday)=3 then response.Write(" class=""manager-btn s-btn""")%>>3天内</a>
<a href="javascript:void(0);" onclick="goto(1,'<%=act%>')" <%if clng(eday)=1 then response.Write(" class=""manager-btn s-btn""")%>>1天内</a>
<a href="javascript:void(0);" onclick="goto(-1,'<%=act%>')" <%if clng(eday)=-1 then response.Write(" class=""manager-btn s-btn""")%>>过期</a>
</div>







        <table class="manager-table" id="z_table">
          <tr>
            <th  ><input type="checkbox" name="chkall" id="chkall"  /></th>
            <th  >业务类型</th>
            <th >业务名称</th>
            <th  >注册日期</th>
            <th  >到期日期</th>
            <th width="12%" class="nolin">管理</th>
          </tr>




             <%

		   wherestr=""
		 select case trim(act)
			 case "db"
			  sql="select dbsysid as ywid,'数据库'as ywType,dbname as ywName,dbexpdate as expdate,dbbuydate as StartTime,'' as otherstr  from databaselist where datediff("&PE_DatePart_D&","&PE_Now&",dbexpdate)"&betweenstr&" and dbu_id="&uid&" order by dbexpdate asc"
			 case "vhost"
			 sql="select * from (select s_sysid as ywid,'虚拟主机' as ywType,s_comment  as ywName,DateAdd("&PE_DatePart_Y&",s_year,s_buydate) as expdate,s_buydate as StartTime,'' as otherstr from vhhostlist where datediff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_Y&",s_year,s_buydate))"&betweenstr&" and  s_ownerid="&uid&" union "&_
			 "select s_sysid as ywid,'虚拟主机(试用)' as ywType,s_comment  as ywName,DateAdd("&PE_DatePart_D&",7,s_buydate) as expdate,s_buydate as StartTime,'' as otherstr from vhhostlist where datediff("&PE_DatePart_D&","&PE_Now&",DateAdd("&PE_DatePart_D&",s_year,s_buydate))  "&betweenstr&" and s_buytest="&PE_True&" and  s_ownerid="&uid&") as temp  order by StartTime asc"
			 case "domain"
			 sql="select d_id as ywid,'域名'as ywType,strDomain as ywName, rexpiredate  as expdate,regdate as StartTime,s_memo as otherstr from domainlist where datediff("&PE_DatePart_D&","&PE_Now&",rexpiredate) "&betweenstr&" and userid="&uid&" order by rexpiredate asc"
			 case "mail"
			  sql="select m_sysid as ywid,'企业邮局'as ywType,m_bindname as ywName,m_expiredate as expdate,m_buydate as StartTime,'' as otherstr from mailsitelist where datediff("&PE_DatePart_D&","&PE_Now&",m_expiredate) "&betweenstr&" and m_ownerid="&uid&" order by m_expiredate asc"
			 case "server"
			 sql="select id as ywid,'服务器或vps' as ywtype,AllocateIP as ywName,StartTime,Dateadd("&PE_DatePart_D&",preday,DATEADD("&PE_DatePart_M&",AlreadyPay,StartTime)) as expdate,'' as otherstr from HostRental left join UserDetail on UserDetail.u_name=HostRental.u_name where DATEDIFF("&PE_DatePart_D&","&PE_Now&",Dateadd("&PE_DatePart_D&",preday,DATEADD("&PE_DatePart_M&",AlreadyPay,StartTime))) "&betweenstr&" and UserDetail.u_id="&uid&"  and start="&PE_True&" order by StartTime asc"
			 case else
			  sql="select d_id as ywid,'域名'as ywType,strDomain as ywName, rexpiredate  as expdate,regdate as StartTime,s_memo as otherstr from domainlist where datediff("&PE_DatePart_D&","&PE_Now&",rexpiredate) "&betweenstr&" and userid="&uid&" order by rexpiredate asc"
			 act="domain"
		 end select
	'	 response.write sql
		 set yw_rs=Server.CreateObject("adodb.recordset")
		 yw_rs.open sql,conn,1,1
    setsize=50
	cur=1
	othercode="&eday="& eday&"&act="& act
	pagenumlist=GetPageClass(yw_rs,setsize,othercode,pageCounts,linecounts)

		if not yw_rs.eof then
			  Do While Not yw_rs.eof And cur<=setsize
			select case trim(yw_rs("ywtype"))
			case "虚拟主机"
			glurl="/manager/sitemanager/manage.asp?p_id="&yw_rs("ywid")
			xfurl="/manager/sitemanager/renewHost.asp?hostid="&yw_rs("ywid")
			case "虚拟主机(试用)"
			glurl="/manager/sitemanager/manage.asp?p_id="&yw_rs("ywid")
			xfurl="/manager/sitemanager/paytest.asp?hostID="&yw_rs("ywid")
			case "域名"
			glurl="/manager/domainmanager/manage.asp?p_id="&yw_rs("ywid")
			xfurl="/manager/domainmanager/renewDomain.asp?domainid="&yw_rs("ywid")
			case "服务器或vps"
			glurl="/manager/servermanager/modify.asp?id="&yw_rs("ywid")
			xfurl="/manager/servermanager/renew.asp?id="&yw_rs("ywid")
			case "企业邮局"
			glurl="/manager/mailmanager/manage.asp?p_id="&yw_rs("ywid")
			xfurl="/manager/mailmanager/renewMail.asp?id="&yw_rs("ywid")
			case "数据库"
			glurl="/manager/sqlmanager/manage.asp?p_id="&yw_rs("ywid")
			xfurl="/manager/sqlmanager/renewdata.asp?id="&yw_rs("ywid")
			end select
			%>
          <tr>
            <td>

            </td>
          <td><%=yw_rs("ywtype")%></td>
          <td  class="aa" ischk="False"><a href="<%=glurl%>" class="link" target="_blank">
		  <%
		  if trim(act)="domain" then
		     if instr(yw_rs("ywname"),"xn--")>0 then
			     response.Write(yw_rs("otherstr"))
			 else
			    response.Write(yw_rs("ywname"))
			 end if
		  else
		      response.Write(yw_rs("ywname"))
		  end if
		  %>&nbsp;
		  <%=strogher%></a></td>
          <td><%=formatdatetime(yw_rs("StartTime"),2)%></td>
          <td><%

		  response.Write(formatdatetime(yw_rs("expdate"),2))
	 		  %></td>
          <td><a href="<%=xfurl%>"  target="_blank">续费</a> | <a href="<%=glurl%>"  target="_blank">管理</a></td>
          </tr>

			<%
			cur=cur+1
			yw_rs.movenext
			loop
			yw_rs.close


		else
			response.Write("<center>最近暂无需要续费业务或过期业务！</center>")
		end if
			%>














          </table>

      <div style="width:100%; text-align:center; margin:10px auto"><%=pagenumlist%></div>





					</div>
		  </div>
	 </div>

  </div>

		<!--#include virtual="/manager/bottom.asp" --> 

</body>
</html>
