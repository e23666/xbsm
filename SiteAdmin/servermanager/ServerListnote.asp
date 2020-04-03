<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
function getHostType(ByVal xxx)
	select case xxx
		case 0
			getHostType="<b><font color=green>租用</font></b>"
		case 1
			getHostType="<b><font color=red>VPS</font></b>"
		case 2
			getHostType="<b><font color=blue>托管</font></b>"
	end select
end function

Check_is_Master(6)
%>

<%
Page=Trim(Requesta("Page"))
if not isNumeric(page) then Page=1
Page=Cint(Page)
ListItem=Trim(Requesta("ListItem"))
Entry=Trim(Requesta("Entry"))
conn.open conStr
if Entry<>"" then
	Sql="Select a.*,b.u_usemoney from HostRental a left join userdetail b on a.u_name=b.u_name where a." & ListItem & " like '%" & Entry &"%'"
else
	Sql="Select a.*,b.u_usemoney from HostRental a left join userdetail b on a.u_name=b.u_name where a.Start=0"
end if
	Sql=Sql & " order by id Desc"
Rs.open Sql,conn,3,3
PageSize=20
TotalRecord=0
PageCount=0
if not Rs.eof then
	Rs.pageSize=PageSize
	PageCount=Rs.PageCount
	if Page<1 or Page>Rs.PageCount then Page=1
	Rs.AbsolutePage=Page
	TotalRecord=Rs.RecordCount
end if
%>
<script language="javascript">
<!--
function isNumber(number){
var i,str1="0123456789.";
	for(i=0;i<number.value.length;i++){
	if(str1.indexOf(number.value.charAt(i))==-1){
		return false;
		break;
			}
		}
return true;
}
function checkNull(data,text){
	if (data.value==""){
		alert("抱歉!提交失败，"+text+"不能为空!");
		data.focus();
	   return false;
			}
	else{ 
		return true;}
}
function isDigital(data,text){
if (data.value!=""){
	if (!isNumber(data)) {
	alert("抱歉!["+text+"]必须是数字,否则无法提交");
	data.focus();
	data.select();
	return false;
	}
}
return true;
}

function check(form){
	if (!checkNull(form.Page,"页码")) return false;
	if (!isDigital(form.Page,"页码")) return false;
	return true;
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>

<script language=javascript>

function Mark(id,Memo){
  document.form1.id.value=id;
  document.form1.Act.value="Mark";
  document.form1.Memo.value=Memo;
  document.form1.submit();
}
</script>
<script language=javascript>
function maskit(form,values){
	form.MaskItem.value=values;
	form.submit();
}
</script>


<style type="text/css">
<!--
tr {
	font-size: 10pt;
}
-->
</style>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>服 务 器 租 用 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">服务器/VPS管理</a> | <a href="ServerListnote.asp">查看新订单</a> | <a href="ServerWarn.asp">查看过期订单</a></td>
  </tr>
</table>
<br />
<table width="100%"  border="0">
<tr> 
       <form name="form1" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" onSubmit="return check(this)">
         
    <td colspan="10"> 
  <table width="100%"  border="0" cellpadding="2" cellspacing="1" class="border">
          <tr> 
                  
            <td width="48%" height="18" class="tdbg" scope="col"> 
              <table width="100%"  border="0" cellspacing="2" cellpadding="2">
                      <tr> 
                        
                  <td width="26%" scope="col" height="8"> 
                    <p> 
                            <select name="ListItem" id="ListItem">
                              <option value="AllocateIP">IP地址</option>
                              <option value="Name">联系人</option>
                              <option value="Telephone">电话</option>
                              <option value="U_name">用户名</option>
                            </select>
                          </p>                        </td>
                        
                  <td width="44%" scope="col" height="8">含 
                    <input name="Entry" type="text" id="Entry" size="15" maxlength="100" value="<%=Entry%>">                        </td>
                        
                  <td width="30%" scope="col" height="8"> 
                    <input type="submit" name="Submit" value="查询">
                          <input type="button" name="Submit" value="返回" onClick="top.location.href='/SiteAdmin';">                        </td>
                      </tr>
                    </table>                  </td>
                  
            <td width="31%" height="18" class="tdbg" scope="col">共<%=PageCount%>页/共<%=TotalRecord%>台主机/每页<%=PageSize%>台主机<a href="ServerWarn.asp">(过期情况)</a> 
              <a href="/SetInManager/admin/ServerList.asp">服务器管理</a> </td>
                  
            <td width="21%" height="18" class="tdbg" scope="col"> 
              <p> 
                      <input name="PrePage" type="button" id="PrePage" value="&lt;" onClick="this.form.Page.value--;this.form.submit();">
                      <input name="NextPage" type="button" id="NextPage" value="&gt;" onClick="this.form.Page.value++;this.form.submit();">
                      <input name="Page" type="text" id="Page" size="3" maxlength="5" value="<%=Page%>">
                      <input type="submit" name="Submit" value="Go">
                    </p>                  </td>
                </tr>
              </table>
         </td>
    </form>
       </tr>
		
  <tr>
    <td> 
      <form name="form1" method="post" action="/SetInManager/admin/ServerListnote.asp">
        <table width="99%"  border="0" cellpadding="2" cellspacing="1" bordercolorlight="#000000" bordercolordark="#FFFFFF" class="border">
          <tr align="center"> 
            <td width="3%" nowrap class="Title" scope="col"><strong>修改查看</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>开通服务</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>类型</strong></td>
            <td width="13%" nowrap class="Title" scope="col"><strong>配置</strong></td>
            <td width="5%" nowrap class="Title" scope="col"><strong>联系人</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>联系电话</strong></td>
            <td width="4%" nowrap class="Title" scope="col"><strong>手机</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>年限</strong></td>
			<td width="3%" nowrap class="Title" scope="col"><strong>机房</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>用户</strong></td>
            <td width="38%" nowrap class="Title" scope="col"><strong>备注</strong></td>
            <td width="3%" nowrap class="Title" scope="col"><strong>修改查看</strong></td>
          </tr>
          <%
i=1
do while not rs.eof and i<=PageSize
if Rs("Start") then
	if DateDiff("d",Now(),DateAdd("yyyy",Rs("Years"),Rs("StartTime")))<0 then
		Status="<font color=red>已过期</font>"
	else
		ExpireTime=DateAdd("m",Rs("AlreadyPay"),Rs("StartTime"))
		if DateDiff("d",Now(),ExpireTime)<0 then
			Status="<font color=Green>已欠费</font>"
		else
			Status="正常"
		end if
	end if
else
	Status="<font color=blue>未开通</font>"
end if
if i mod 2 =0 then
trcolor="#ffffff"
else
trcolor="#C8FCFF"
end if
%>
          <tr> 
            <td width="3%" align="center" class="tdbg"><a href="HostSummary2.asp?id=<%=Rs("id")%>" target="_blank"><%=(page-1)*pageSize+i%></a></td>
            <td width="3%" class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>" target="_blank"><%=(page-1)*pageSize+i%></a></td>
            <td width="3%" class="tdbg"> 
            <%=getHostType(Rs("hostType"))%>            </td>
            <td width="13%" class="tdbg"><%=Rs("CPU")%>/<%=Rs("Memory")%>/<%=Rs("HardDisk")%></td>
            <td width="5%" align="center" class="tdbg"><%=Rs("Name")%></td>
            <td width="3%" align="center" class="tdbg"><%=Rs("Telephone")%>&nbsp;</td>
            <td width="4%" align="center" class="tdbg"><%=Rs("Fax")%>&nbsp;</td>
            <td width="3%" align="center" class="tdbg"><%=Rs("Years")%></td>
			<td width="3%" align="center" class="tdbg">&nbsp;<%=Rs("serverRoom")%></td>
            <td width="3%" align="center" class="tdbg"> 
<%if isNull(rs("u_name")) then
  response.write "&nbsp;"
else
	u_usemoney=rs("u_usemoney")
  'if not isnumeric(u_usemoney) then u_usemoney=0
  if int(u_usemoney)>=299 then
  	response.write "<font color=red title=""余额:"& u_usemoney &""">"& rs("u_name") &"</font>"
  else
  	response.write rs("u_name")
  end if
end if%>            </td>
            <td width="38%" align="center" class="tdbg"> 
            <%
			if rs("memo")<>"" then
				Response.write rs("memo")
			else
				Response.write "无"

			end if
			
%>            </td>
            <td width="3%" align="center" class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>">查看编辑</a></td>
          <%
	Rs.MoveNext
	i=i+1
	Loop
	Rs.close
%>
          </tr>
          <tr> 
            <td height="43" colspan="12" bgcolor="#F0F0F0"> 
              <input type="hidden" name="id" >
              <input type="hidden" name="Act">
              <input type="hidden" name="Memo">            </td>
          </tr>
        </table>
      </form>
    </td>
  </tr>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
