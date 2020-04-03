<%
response.Charset="gb2312"
response.Buffer=true
%>
<!--#include virtual="/manager/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
sqlstring="select * from productlist where p_id > 0 "
conn.open constr
if  Requesta("module")="del" Then
  	 delinfo=requesta("delinfo")
	
	 if len(delinfo)>0 then
	 	sql="delete from productlist where p_Id in("& delinfo &")"
		conn.execute sql
		
		Alert_Redirect "删除成功",request("script_name")&"?pageNo="& request("pageNo")
	 else
	 	url_return "请选中您要删除的项",-1
	 end if
elseif Requesta("module")="searchPrice" then
	Proid=trim(requesta("Proid"))
	response.write GetNeedPrice("",Proid,1,"new")
	conn.close
	response.end
End If

searchtype=requesta("searchtype")

sqlArray=Array("p_name,产品名称,str","p_proid,产品ID,str","p_price,产品价格,int","p_costprice,成本价,int","server_type_name,服务器类别,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
condition=requesta("condition")
searchValue=requesta("searchValue")
searchItem=requesta("searchItem")

othercode="&searchtype="& searchtype&"&condition="&condition&"&searchValue="&searchValue&"&searchItem="&searchItem
newsql1=" and p_type="& searchtype
if trim(searchtype)="0" or trim(searchtype)&""="" then newsql1="":searchtype="0"

sqlstring="select a.*,b.server_type_name from (productlist a left join server_type b on (a.p_server=b.server_type_num)) where p_id>0 " & newsql & newsql1 & " order by p_server,p_proid asc"
response.Write(sql)
rs.open sqlstring,conn,1,1
    setsize=15
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #0650D2;
	font-weight: bold;
}
.STYLE5 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
<script type="text/javascript" language="javascript" src="/jscripts/ajaxClass.js"></script>
<script language="javascript" src="/jscripts/check.js"></script>
<script language="javascript">
function searchPrice(v,c1){
	if(v!=""){
		var ajaxurlstr="<%=requesta("script_name")%>?module=searchPrice" ;
		var info="Proid="+ v.Trim() ;
		var imgmsg="<img src=\"/images/mallload.gif\" border=\"0\" id=\"loadimg\" />"		
		ajaxRequest(ajaxurlstr,info,"post",c1,c1+"_1",Completion,imgmsg);
	}
}
function Completion(strValue,dividstr,divid1str){
	document.getElementById(dividstr).innerHTML=strValue;
}
function checkall(v){
	var el = document.getElementsByName('delinfo');
	var len = el.length;
	if (isNaN(len)){
		el.checked=v.checked;
	}else{
		for(var i=0; i<len; i++) 
		{ 
			el[i].checked =v.checked;
		} 
	}

}
function dodel(v){
	var ischeck=false;
	var el = document.getElementsByName('delinfo');
	var len = el.length;
	if (isNaN(len)){
		ischeck=el.checked;
	}else{
		for(var i=0; i<len; i++) 
		{ 
			ischeck=el[i].checked;
			if(el[i].checked)
				break;
		} 
	}
	if(ischeck){
		if(confirm('确定删除选中的项吗?')){
			document.form2.action='<%=request("script_name")%>?module=del&pageNo=<%=request("pageNo")%>';
			document.form2.submit();
		}
	}else{
		alert('请选中您要删除的项');
	}
}
function dosearch(v){
	document.form2.submit();
}
</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>产品管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="addPro.asp">新增产品</a>|<A HREF="syncPro.asp">同步产品或价格</A> | <A HREF="adjustPrice.asp" class="STYLE5">批量调整价格</A> | <A HREF="syndomain.asp" class="STYLE5">同步域名价格</A></td>
  </tr>
</table>
<br>
</p> <form name="form2" action="<%=request("script_name")%>" method="post" >
<TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">

  <tr bgcolor="#FFFFFF">
    <td colspan =9 align="left" nowrap bgcolor="#FFFFFF">
	<%=searchlist%>
    <input type="radio" name="searchtype" value="0" onClick="dosearch(this.value)" <%if searchtype="0" then response.write "checked"%>>全部&nbsp;
    <input type="radio" name="searchtype" value="1" onClick="dosearch(this.value)" <%if searchtype="1" then response.write "checked"%>>空间&nbsp;
    <input type="radio" name="searchtype" value="2" onClick="dosearch(this.value)" <%if searchtype="2" then response.write "checked"%>>邮局&nbsp;
    <input type="radio" name="searchtype" value="3" onClick="dosearch(this.value)" <%if searchtype="3" then response.write "checked"%>>域名&nbsp;
    <input type="radio" name="searchtype" value="4" onClick="dosearch(this.value)" <%if searchtype="4" then response.write "checked"%>>网站推广&nbsp;
    <input type="radio" name="searchtype" value="7" onClick="dosearch(this.value)" <%if searchtype="7" then response.write "checked"%>>数据库
    <input type="radio" name="searchtype" value="9" onClick="dosearch(this.value)" <%if searchtype="9" then response.write "checked"%>>VPS
    <input type="radio" name="searchtype" value="11" onClick="dosearch(this.value)" <%if searchtype="11" then response.write "checked"%>>云主机
    <input type="radio" name="searchtype" value="12" onClick="dosearch(this.value)" <%if searchtype="12" then response.write "checked"%>>OEMVPS
    <input type="radio" name="searchtype" value="13" onClick="dosearch(this.value)" <%if searchtype="13" then response.write "checked"%>>OEM云主机 
		<input type="radio" name="searchtype" value="15" onClick="dosearch(this.value)" <%if searchtype="15" then response.write "checked"%>>云建站
		<input type="radio" name="searchtype" value="16" onClick="dosearch(this.value)" <%if searchtype="16" then response.write "checked"%>>SSL
		<input type="radio" name="searchtype" value="17" onClick="dosearch(this.value)" <%if searchtype="17" then response.write "checked"%>>微信小程序
    </td>
  </TR>
  <TR align=middle>
    <td align="left" class="Title"><input type="checkbox"  id="headerchk"  title="全选/全消"  class="checkbox"  onclick="checkall(this)" />
      <a href="#" title="仅删除数据库信息" onClick="javascript:dodel()">[选中删除]</a>   <strong>产品名称</strong></td>
    <td align="center" class="Title"><strong>产品ID</strong></td>
    <td align="center" class="Title"><strong>产品首年价格</strong></td>
    <td align="center" class="Title"><strong>成本价<input type="button" onClick="javascript:location.href='pricecompare.asp'" title="重新获取成本价" value="重新获取"></strong></td>
    <td align="center" class="Title"><strong>产品大小</strong></td>
    <td align="center" class="Title"><strong>产品限制</strong></td>
    <td align="center" class="Title"><strong>服务器类别</strong></td>
    <td align="center" class="Title"><strong>操作</strong></td>
  </TR>
  <%
	do while not rs.eof and cur<=setsize
		tdcolor="#ffffff"
		p_type=rs("p_type")
		if cur mod 2=0 then tdcolor="#EAF5FC"
  %>
                            
  <TR align=middle bgcolor="<%=tdcolor%>">
    <td align="left" ><input type="checkbox" value="<%=rs("p_Id")%>" name="delinfo">
    <%if instr(",9,11,12,13,",","&p_type&",")>0 then%>
    <a href="vpsprice.asp?p_proid=<%=rs("p_proid")%>"><font color="#0000FF"><%= rs("p_name") %></font></a>
    <%else%>
    <a href="detail.asp?p_id=<%=rs("p_id")%>"><font color="#0000FF"><%= rs("p_name") %></font></a>
    <%end if%>
    </td>
    <td ><%= rs("p_proid") %></td>
    <td >
    <%=GetNeedPrice("",rs("p_proid"),1,"new")%>
    </td>
    <td ><%
	if check_as_master(1) then
	costPrice=rs("p_costprice")
	else
	costPrice=0
	end if
	if len(costPrice)=0 or costPrice&""="0" then costPrice="未知"
	response.write costPrice
	%></td>
    <td ><%= rs("p_size") %> </td>
    <td ><%= rs("p_maxmen") %></td>
    <td ><%=rs("server_type_name") %></td>
    <td ><a href="delproduct.asp?proid=<%=rs("p_proid")%>">删除</a></td>
  </tr>
  <%
		cur=cur+1
		rs.movenext
	Loop
	rs.close
	
	%>
  <tr bgcolor="#FFFFFF">
    <td colspan =9 align="center" nowrap bgcolor="#FFFFFF"><%=pagenumlist%></td>
  </TR>


</table>  </form>
<br>
<%
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
