<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%
response.buffer=true
response.Charset="gb2312"
conn.open constr
dim usr_mobile
dim usr_email
call getusrinfo()
hostid=requesta("hostid")
if not isnumeric(hostid) or hostid="" then url_return "参数传递错误",-1
sqlstring="SELECT * FROM vhhostlist where S_ownerid=" &  session("u_sysid") & " and s_sysid=" & hostid

rs.open sqlstring,conn,1,1
if rs.eof and rs.bof then url_return "没有找到此主机",-1
s_comment=rs("s_comment")
s_year=rs("s_year")
s_buydate=formatDateTime(rs("s_buydate"),2)
s_expiredate=formatdateTime(rs("s_expiredate"),2)
s_productid=rs("s_productid")
s_buytest=rs("s_buytest")
s_ssl=rs("s_ssl")
s_sslprice=0
if not isnumeric(s_ssl&"") then s_ssl=0
if ccur(s_ssl)>0 then
	s_sslprice=getneedprice(session("user_name"),"vhostssl",1,"renew")
end if

if s_buytest then response.redirect "paytest.asp?hostid=" & hostid & "&productType=vhost":response.end


renewprice=ccur(getneedprice(session("user_name"),s_productid,1,"renew"))+ccur(s_sslprice)
otherip=getOtherip(s_comment,session("user_name"))
if isip(otherip) then
	if lcase(left(s_productid,2))="tw" then
		ipproid="twaddip"
		else
		ipproid="vhostaddip"
	end if

	 
		ipprice=getneedprice(session("user_name"),ipproid,1,"renew")
	 
	if ipprice&""="" or not isnumeric(ipprice) then ipprice=0
	renewprice=cdbl(renewprice)+cdbl(ipprice)
end if
if not isnumeric(ipprice&"") then ipprice=0

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>用户管理后台-虚拟主机续费</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
var ipprice=<%=ipprice%>;

	function doneedprice(myvalue,u_name,proid,s_comment){
		var url='../config/renewneedprice.asp?str=needprice';
		var sinfo='years='+myvalue+'&u_name='+escape(u_name)+'&proid='+ proid +"&p_name="+escape(s_comment);
		var divID='needprice';
		$("#"+divID).html('<img src="/Template/Tpl_01/images/new/load1.gif" border="0" id="loadimg" />');
		$.post(url,sinfo,function(data){
			$("#"+divID).html(data)
		})
		//makeRequestPost1(url,sinfo,divID);
		if(ipprice>0)
		{
		 $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> 含独立IP费用"+ myvalue+"年 </font>");
		}
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

$(function(){
	if(ipprice>0)
	{
     $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> 含独立IP费用"+ipprice+"元 </font>");
	}
})

$(function(){
	if(ipprice>0)
	{
     $("#others_ip_msg").html("&nbsp;&nbsp;<font color=red> 含独立IP费用1年 </font>");
	}
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
			    <li><a href="/Manager/sitemanager/">虚拟管理管理</a></li>
				<li>虚拟主机续费</li>
			 </ul>
		  </div>
		  <div class="manager-right-bg">


 <form name="form1" method="post" action="../config/renew.asp" >
  <div style="border:dashed 1px #ff0000; padding:7px; background:#ffff99; width:99%; margin:10px auto; margin-bottom:5px;">
友情提示:从2018年5月5日起，续费虚拟主机不再同步延长赠品邮局的时间。赠送的域名和邮局时间为1年，过期后需单独续费。
 </div>
              <table class="manager-table">
                <tbody>
                  <tr>
                    <th width="19%" align="right">主 &nbsp;  机：</th>
                    <td width="81%" height="15" align="left"><%=s_comment%></td>
                  </tr>
                  <tr>
                    <th align="right" > 年 限： </th>
                    <td height="16" align="left"><%=s_year%></td>
                  </tr>
				  <%if ccur(s_sslprice)>0 then%>
				   <tr>
                    <th align="right"  ><p align="right">SSL价格：</p></th>
                    <td height="2" align="left"><font color="red"><%=s_sslprice%></font>元/年  </td>
                  </tr>

				  <%end if%>
                  <tr>
                    <th align="right"  ><p align="right">注册日期：</p></th>
                    <td height="2" align="left"><%=s_buydate%></td>
                  </tr>
                  <tr>
                    <th align="right"  ><p align="right">到期日期：</p></th>
                    <td height="26" align="left"><%=s_expiredate%></td>
                  </tr>
<tr> 
            <td colspan="2" align="center"  class="tdbg">
              <div class="redAlert_Box RedLink">为了使您能快捷、准确地收到续费通知等信息，请核实您的手机为：<span class="GreenColor"><%=usr_mobile%></span>，邮箱为：<span class="GreenColor"><%=usr_email%></span>，若不对，请及时<a href="/manager/usermanager/default2.asp" class="Link_Blue">修改</a>！ </div>
            </td>
          </tr> 
                  <tr>
                    <th height="26" align="right"  > 选择交费年头：</th>
                    <td height="26" align="left" >
                      <select name="RenewYear" class="manager-select s-select" ONCHANGE="doneedprice(this.value,'<%=session("user_name")%>','<%=s_productid%>','<%=s_comment%>')">
                        <OPTION VALUE="1">请选择续费年限，推荐续三年！</OPTION>
					  <%
					  '2013 8-29 虚拟主机购/续多年送时间活动
					  dim xzli
					  xzli=0
					  showArray=split("2,续2年送1年|3,续3年送2年|5,续5年送5年|10,续10年送10年","|")
					 for each i in split("1,2,3,5,10",",") 

					   if xzli<=ubound(showArray) then
                            showtemp=split(showArray(xzli),",")
								if clng(showtemp(0))=clng(i) then
									showtxt="["&showtemp(1)&"]"
									xzli=xzli+1
									else
									showtxt=""
								end if
							end if
					  
					  %>
                      <OPTION VALUE="<%=i%>"><%=i%> 年<%=showtxt%><%if clng(i)=3 then response.write("（强烈推荐）")%></OPTION>
                      <%next%>
                      </select>
					  <LABEL id="others_ip_msg"></LABEL></td>
					  </td>
                  </tr>
                  <tr>
                    <th height="26" align="right"  > 交费金额：</th>
                    <td height="26" align="left">
                    <span id="needprice"><b><font color=red><%=renewprice%></font></b>￥/1年</span><font color=red>(续费虚拟主机不同步延长赠品邮局时间)</font></td>
                  </tr>
                  <tr>
                    <td height="1" colspan="2" align="center" >
                    
		  <input type="hidden" value="<%=hostid%>" name="p_id">
          <input type="hidden" name="productType" value="host">
          <span id="loadspan" style="display:none"><img src="../images/load.gif" border=0><br>正在执行,请稍候..<br></span>
          <INPUT NAME="C1" TYPE="button" CLASS="manager-btn s-btn"  VALUE="　确定续费　" onClick="return dosub(this.form)">                  </tr>
                </tbody>
              </table>
            
  </form>





		  </div>
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>