<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/action.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-修改虚拟主机订单</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" /></HEAD>
<%
d_id=requesta("id")
if not isnumeric(d_id) or d_id="" then url_return "参数丢失",-1
conn.open constr
act=requesta("act")
if act="del" then
	sql="delete from Prehost where OrderNo='" & d_id & "' and u_name='"& session("user_name") &"'"
	conn.execute sql
	conn.close
		alert_redirect "删除成功","default.asp"
elseif act="mod2" then
	newbuyyears=trim(requesta("newbuyyears"))
	sql="update Prehost set years=" & newbuyyears & " where u_name='"& session("user_name") &"' and OrderNo='"& d_id & "'"
	conn.execute sql
	conn.close
	alert_redirect "年限修改成功",request("script_name")&"?id=" & d_id
elseif act="add" then
	returnstr=putOrderlist("vhost",d_id,session("user_name"))
	
	if left(returnstr,3)="200" then
		Sql="Update Prehost Set Opened="&PE_True&" Where orderNo='" & d_id & "'"
        conn.Execute(Sql)
			alterstr="虚拟主机开通订单成功，<br>" & _
					"现在可进入 管理中心-业务管理-主机管理 对此主机进行相关设置"
					
										 
				echoString alterstr,"r"
	else
				echoString "虚拟主机开通订单失败 "& returnstr ,"e"
	end if
end if

sql="select * from Prehost where orderNo='" & d_id & "' and u_Name='"& session("user_name") &"'"
rs11.open sql,conn,1,1
if rs11.eof then url_return "没有找到此订单",-1
orderID=100000 + d_id

		 s_comment=rs11("ftpaccount")
		 regDate=rs11("sdate")
		 years=rs11("years")
		 price=rs11("price")
		 proID=rs11("proid")
		 allprice=GetNeedPrice(session("user_name"),proID,years,"new")
%>
<script language=javascript>
function modifyyears(v,id){
	var f=document.form1;
	f.action=v + "?act=mod2&id=" + id;
	f.submit();

}
function dosub(f){
	if(confirm('确定此操作吗?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}		
</script>

<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">修改虚拟主机订单</div>
          <div class="table_out">
          <table width="100%" border="0" align="center" cellpadding="5" cellspacing="1" class="border">
  <form name="form1" method="post" action="<%=request("script_name")%>?act=add&id=<%=d_id%>" >
    <tr class="tdbg">
      <td width="29%" align="right" nowrap="nowrap">订单号:</td>
      <td width="44%" class="tdbg"><%=orderID%></td>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">产品名:</td>
      <td class="tdbg"><%=s_comment%></td>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">下单日期:</td>
      <td class="tdbg"><%=regDate%></td>
    </tr>
    <tr>
      <td align="right" nowrap="nowrap" class="tdbg">购买年限:</td>
      <%if act="mod" then%>
      <td class="tdbg"><%Pricestring=getpricelist(session("user_name"),proID)
  	priceArray=split(Pricestring,"|")
  %>
          <select name="newbuyyears">
            <%for jj=0 to 9
		selectedstr=""
		if years=(jj+1) then selectedstr=" selected "
	%>
            <option value="<%=jj+1%>" <%=selectedstr%>><%=priceArray(jj)%>￥/<%=(jj+1)%>年</option>
            <%next%>
          </select>
          <span class="STYLE4"><a href=# onClick="javascript:modifyyears('<%=request("script_name")%>',<%=d_id%>);">[确定修改]</a> <a href="<%=request("script_name")%>?id=<%=d_id%>">[取消修改]</a></span> </td>
      <%else%>
      <td class="tdbg"><strong><%=years%>年&nbsp;</strong> <a href="<%=request("script_name")%>?act=mod&id=<%=d_id%>" class="tdbg">[修改年限]</a></td>
      <%end if%>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">总价格:</td>
      <td class="tdbg"><%=allprice%></td>
    </tr>
    <tr class="tdbg">
      <td colspan=2 align="center">
      	 <span id="loadspan" style="display:none"><img src="../../images/load.gif" border=0><br>正在执行,请稍候..<br></span>
      	  <input type="button" name="C1" value="立即注册" onClick="return dosub(this.form)">
          <input type="button" onClick="javascript:if(confirm('确定删除吗?')){location.href='<%=request("script_name")%>?act=del&id=<%=d_id%>'}" value="删除订单">
      </td>
    </tr>
  </form>
</table>
          </div>
        </div>
      </div>
    </div>
  </div>
 <!--#include virtual="/manager/bottom.asp" -->
</div>





</body>
</html>
