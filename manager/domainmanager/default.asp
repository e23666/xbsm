<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
''''''''''''''''''''''sort''''''''''''''''''''''''''
sorttype=trim(requesta("sorttype"))
sorts=trim(requesta("sorts"))
g_id=trim(requesta("g_id"))
if sorttype="" then sorttype="desc"
if sorttype="asc" then 
	seesortstr="<img src=""/images/up_sort.png"" border=0 alt=""升序"">"
else
	seesortstr="<img src=""/images/down_sort.png"" border=0 alt=""倒序"">"
end if

sortsql=""
if not isnumeric(g_id&"") then g_id=0
gsql=""
if g_id>0 then
gsql=" and d_id in (select yw_id  from groupinfo where gid="&g_id&") "
end if

if sorts="" then sorts="regdate"
	sortsql=" "& sorts &" " & sorttype
'''''''''''''''''''''''''''''''''''''''''''''''''''
sqlArray=Array("strdomain,域名,str","regdate,注册时间,date","rexpiredate,到期时间,date","years,购买年限,int")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="select  domainlist.*,Remarks.r_txt  from domainlist left join Remarks on (domainlist.d_id=Remarks.p_id and  Remarks.r_type=0) where userid=" &  session("u_sysid") &gsql& " " & newsql & " order by "& sortsql
rs.open sqlstring,conn,1,1
setsize=20
cur=1
othercode=othercode & "&sorts="& sorts & "&sorttype="& sorttype&"&g_id="&g_id
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
alldomain=""
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-域名管理</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
}
</script>

</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <!--#include virtual="/manager/rengzheng.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
     <div id="SiteMapPath">
                 <ul>
                   <li><a href="/">首页</a></li>
                   <li><a href="/Manager/">管理中心</a></li>
                   <li>域名管理</li>
                 </ul>
      </div>
	<form name="form1" action="<%=request("script_name")%>" method="post">
       <div class="manager-right-bg">
        <%=searchlist%>
		<input type="button" class="manager-btn s-btn" value="分组管理" onclick="location.href='groupUser.asp'">
        <div class="tab"></div>
         		  <div class="gorup mt-10">分组：
                   <%
         		  set d_rs=conn.execute("select * from groupUser where G_type=0 and G_UserID=" &  session("u_sysid"))
         		  do while not d_rs.eof
                   %>
         		<a href="?g_id=<%=d_rs("GID")%>"><%=d_rs("G_name")%></a>
         		  <%
         		  d_rs.movenext
         		  loop
         		  %>
</div>
                   <div style="clear:both"></div>
<!--table-->
       <table class="manager-table">
           	<thead>
               	   <tr>
                   	   <th width="40"><input type="checkbox" name="checkall" class="checkall" /></th>
                       <th>域名<a href="javascript:dosort('strDomain')" ><%=seesortstr%></a></th>
                       <th>注册日期<a href="javascript:dosort('regdate')"><%=seesortstr%></a></th>
                       <th>到期日期<a href="javascript:dosort('rexpiredate')"><%=seesortstr%></a></th>
                       <th>状态</th>
                       <th>业务种类<a href="javascript:dosort('isreglocal')"><%=seesortstr%></a></th>
                       <th>类别<a href="javascript:dosort('proid')"><%=seesortstr%></a></th>
					   <th>实名认证</th>
                       <th>操作</th>
                   </tr>
               </thead>
               <tbody>
                       <%
		
         	Do While Not rs.eof And cur<=setsize
         		tdcolor="#ffffff"
         		if cur mod 2 =0 then tdcolor="#EAF5FC"

         	%>
                   <tr>
                   	   <td><input type="checkbox" name="d_id" value="<%=rs("strDomain")%>" /></td>
                       <td>
                       <a href="manage.asp?p_id=<%=rs("d_id")%>" class="link">
                                   <%
         			response.Write domainlook(rs("strDomain"))
         			if instr(",11,9,12,",","& rs("tran_state")&",")>0 then
         				response.Write "<img src='/Template/Tpl_01/images/star1.gif' border='0'>"
         			end if
         			%>
                                   </a><img src="/images/1341453609_help.gif" onclick="setmybak(<%=rs("d_id")%>,'<%=rs("strDomain")%>',0)">
         						  <%if trim(rs("r_txt"))<>"" then
         						  response.write("<div class=""hs"">("&rs("r_txt")&")</div>")
         						  end if
         						  %>
                        </td>  
                        <td><%= FormatDateTime(rs("regdate"),2) %></td>
                         <td ><%=FormatDateTime(rs("rexpiredate"),2)%></td>
                         <td><%=showdomainstatus(rs("regdate"),rs("years"))%></td>
                         <td><%If rs("isreglocal") Then
                                    Response.Write "DNS管理"
                                else
                                    Response.Write "本站注册"
                                End If
                                %>
                         </td>
						  
						  

                          <td><%
         								If rs("isreglocal") then
         									Response.write "DNS管理"
         								else
         									Response.write "域名"
											if trim(alldomain)="" then
												alldomain=Trim(rs("strDomain"))
											else
												alldomain=alldomain&","&Trim(rs("strDomain"))
											end if
         								End If
         						%></td>
					   <td data-dm="<%=Trim(rs("strDomain"))%>">
								<%If rs("isreglocal") then%>
									无
								<%
								else
								    response.write("检查中")
								end if
								%>
						</td>
                       <td><a href="manage.asp?p_id=<%=rs("d_id")%>">管理</a>&nbsp; <a href="renew_check.asp?DomainID=<%=Rs("d_id")%>">续费</a>
                                   <%If not rs("isreglocal") then %>
                                   <%
         				mydomaintype=GetDomainType(rs("strDomain"))
         				if instr(right(mydomaintype,2),"cn")>0 then
         					cerhref="cercn.asp?DomainID="& rs("d_id")
         				else
         					cerhref="cer.asp?DomainID="& rs("d_id")
         				end if
         				%>
                                   <a href="/manager/domainmanager/cer/<%=cerhref%>" target="_blank">证书</a>&nbsp;
                                   <%end if%></td>
					  
                  </tr>
                  <%
         		cur=cur+1
         		rs.movenext

         	Loop
         	rs.close
         	conn.close
         	%>
            <tr>
            	<th colspan="10" style="padding-left:20px; text-align:left"><input type="checkbox" name="checkall" class="checkall" /> <input type="button" value="模板过户" onclick="gouhusure()" class="manager-btn s-btn" /></th>
            </tr>
              </tbody>
        </table>
<!--table end-->

<!--分页-->
<div class="mf-page ">

 
    
    
    
    
    
    
    <%=pagenumlist%>
    
    
 
</div>
</form>

    </div>

      </div>
    </div>



 <!--#include virtual="/manager/bottom.asp" -->

<script>

$(function(){
		$(".checkall").click(function(){ 
				$("input[name='d_id']").prop("checked",$(this).prop("checked"))
			})
	})

function gouhusure()
{
	var  ids=[];
	$("input[name='d_id']:checked").each(function(i,o){
			ids.push(o.value);		
	})
	if(ids.length<=0)
	{
		$.dialog.alert("请先选择要模板过户的域名");
		return false
	}
	location.href="contactinfo/?tab=gh&ghdomain="+ids.join(",")
}


 window.onload=function(){
	 url="/manager/domainmanager/zhuanru.asp?act=checkzr&r="+Math.random();
	 $.get(url,function(t){})
 }
 var chkdm="<%=alldomain%>"
 var sign="<%=ASP_MD5(api_password&alldomain&webmanagespwd&date())%>"
$(function(){
getdmrz()
})
function getdmrz()
{
	if($.trim(chkdm)=="")
	{
		return false;
	}
	var postdata="dm="+escape(chkdm)+"&sign="+sign
	$.post("shimingchk.asp",postdata ,function(data){
		if(data.result=="200")
		{
		    
			for(name in data.infos)
			{
			var obj=data.infos[name]
			text=""
			url="javascript:;;"
			if(obj.status!="-1")
			{
				txt=obj.txt;
				url=obj.url;
				if(obj.status=="6")
				{
					text="<font color=green>"+txt+"</font>"
				}else{
					text="<a href='"+url+"' target='_blank'><font color=red>"+txt+"</font></a>"
				}
			}else{
				text="<font color='#333'>-</font>"
			}

				$("td[data-dm='"+name+"']").html(text)
				
			}
			  
		
		}else{
			$.each(chkdm.split(","),function(i,n){
				 
				$("td[data-dm='"+n+"']").html("<font color=red>err</font>")
			
			})
		}	
	
	},"json")
}

</script>
<script src="/jscripts/setmybak.js"></script>
</body>
</html>