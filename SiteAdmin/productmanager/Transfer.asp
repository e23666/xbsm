<%
response.Charset="gb2312"
response.Buffer=true
%>
<!--#include virtual="/manager/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
 
conn.open constr
act=requesta("act")
if act="saveedit" then
p_proid=requesta("p_proid")
leve1=requesta("leve1")
leve2=requesta("leve2")
leve3=requesta("leve3")
leve4=requesta("leve4")
leve5=requesta("leve5")
	if not isnumeric(leve1) or not isnumeric(leve2) or not isnumeric(leve3)  or not isnumeric(leve4) or not isnumeric(leve5) then
	die url_return("价格设置有误",-1)
	end if
	
	sql="update pricelist set Transfer="&leve1&" where p_proid='"&p_proid&"' and p_u_level=1"
	conn.execute(sql)
	sql="update pricelist set Transfer="&leve2&" where p_proid='"&p_proid&"' and p_u_level=2"
	conn.execute(sql)
	sql="update pricelist set Transfer="&leve3&" where p_proid='"&p_proid&"' and p_u_level=3"
	conn.execute(sql)
	sql="update pricelist set Transfer="&leve4&" where p_proid='"&p_proid&"' and p_u_level=4"
	conn.execute(sql)
	sql="update pricelist set Transfer="&leve5&" where p_proid='"&p_proid&"' and p_u_level=5"
	conn.execute(sql)
die Alert_Redirect("价格修改成功","?act=ok")
end if
 
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
    <td height='30' align="center" ><strong>域名转入价格设置</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="addPro.asp">新增产品</a>|<A HREF="syncPro.asp">同步产品或价格</A> | <A HREF="adjustPrice.asp" class="STYLE5">批量调整价格</A></td>
  </tr>
</table>
 
<table width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">
  <tr>
    <td align="center" valign="middle" class="Title">转入域名产品名称</td>
    <td align="center" valign="middle" class="Title">产品编号</td>
    <%set lrs=conn.execute("select top 5 * from levellist order by l_level asc")
	do while not lrs.eof%>
    <td align="center" valign="middle"  class="Title"><%=lrs("l_name")%></td>
    <%
	lrs.movenext
	loop
	lrs.close
	%>
    <td align="center" valign="middle" class="Title">操作</td>
  </tr>
  <%
  i=1
  set prs=conn.execute("select p_name,P_proId from productlist where P_proId in('"&replace(DomainTransfer,",","','")&"')")
  do while not prs.eof
  %>
  <form action="?act=saveedit" method="post" onSubmit="return checkform(this)">
  <tr <%if i mod 2=0 then response.Write("bgcolor=""#EAF5FC""")%>>
    <td align="center" valign="middle"><%=prs("p_name")%><input name="p_proid" type="hidden" value="<%=prs("p_proid")%>" readonly="true"></td>
    <td align="center" valign="middle"><%=prs("P_proId")%></td>
    <td align="center" valign="middle"> <input name="leve1" id="leve1" type="text" value="<%=getDnameTransfer(prs("P_proId"),1)%>" size="5">
    元</td>
    <td align="center" valign="middle"><input name="leve2" id="leve2" value="<%=getDnameTransfer(prs("P_proId"),2)%>" type="text" size="5">
    元</td>
    <td align="center" valign="middle"><input name="leve3" id="leve3" value="<%=getDnameTransfer(prs("P_proId"),3)%>" type="text" size="5">
    元</td>
    <td align="center" valign="middle"><input name="leve4" id="leve4" value="<%=getDnameTransfer(prs("P_proId"),4)%>" type="text" size="5">
    元</td>
    <td align="center" valign="middle"><input name="leve5" id="leve5" value="<%=getDnameTransfer(prs("P_proId"),5)%>" type="text" size="5">
    元</td>
    <td align="center" valign="middle"><input type="submit" name="button" id="button" value="修改"></td>
  </tr>
  </form>
  <%
  i=i+1
  prs.movenext
  loop
  %>
</table>
<script language="javascript">
function checkform(obj)
{ 
l1=obj.leve1
l2=obj.leve2
l3=obj.leve3
l4=obj.leve4
l5=obj.leve5

if(isNaN(l1.value) || l1.value==""){alert("请设置正确价格");	l1.focus();	return false}
if(isNaN(l2.value) || l2.value==""){alert("请设置正确价格");	l2.focus();return false}
if(isNaN(l3.value) || l3.value==""){alert("请设置正确价格");	l3.focus();return false	}
if(isNaN(l4.value) || l4.value==""){alert("请设置正确价格");	l4.focus();	return false}
if(isNaN(l5.value) || l5.value==""){alert("请设置正确价格");	l5.focus();return false	}

 return true;
	
}
</script>
<%

conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
