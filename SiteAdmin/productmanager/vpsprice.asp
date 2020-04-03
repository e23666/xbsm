<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/parsecommand.asp" -->
<%Check_Is_Master(6)%>
<%
p_proid=requesta("p_proid")
act=requesta("act")
sysid=requesta("sysid")
conn.open constr
sql="select * from productlist where p_proid='"& p_proid &"'"
rs11.open sql,conn,1,1
if rs11.eof then rs11.close:conn.close:url_return "没有找到此产品id",-1
p_name=rs11("p_name")
p_id=rs11("p_id")
rs11.close
if act="edit" and sysid<>"" then
	v_monthprice=requesta("monthprice_"&sysid)
	v_seasonprice=requesta("seasonprice_"&sysid)
	v_halfyearprice=requesta("halfyearprice_"&sysid)
	v_yearprice=requesta("yearprice_"&sysid)
	if isnumeric(v_monthprice) and isnumeric(v_seasonprice) and isnumeric(v_halfyearprice) and isnumeric(v_yearprice) then
		sql="select * from vps_price where v_sysid="& sysid
		rs.open sql,conn,1,3
		if not rs.eof then
			rs("v_monthprice")=v_monthprice
			rs("v_seasonprice")=v_seasonprice
			rs("v_halfyearprice")=v_halfyearprice
			rs("v_yearprice")=v_yearprice
			rs.update
		end if
		rs.close:conn.close
		alert_redirect "修改成功",requesta("script_name") & "?p_proid="& p_proid
	else
		url_return "值有错误，请检查",-1
	end if
	response.end
elseif act="syn" then
	call doUserSyn_vps(p_proid,true)
	alert_redirect "同步成功",requesta("script_name") & "?p_proid="& p_proid
elseif act="addagent" then
	new_discount=requesta("new_discount")
	new_level=requesta("new_level")
	if isnumeric(new_discount) and new_discount<>"" and isnumeric(new_level) and new_level<>"" then
		sql="select * from vps_agentprice where p_proid='"& p_proid &"' and a_level="& new_level
		rs.open sql,conn,1,3
		if rs.eof then
			rs.addnew()
			rs("p_proid")=p_proid
			rs("a_discount")=new_discount
			rs("a_level")=new_level
			rs.update()
			alert_redirect "添加成功",requesta("script_name") & "?p_proid="& p_proid
		else
			rs.close()
			url_return "该级别折扣价已存在，不能重复定义",-1
		end if
		rs.close
	else
		url_return "参数有误",-1
	end if
elseif act="modagent" then
	a_discount=requesta("a_discount_"&sysid)
	a_level=requesta("a_level_"&sysid)
	if isnumeric(a_discount) and a_discount<>"" and isnumeric(a_level) and a_level<>"" then
		sql="select * from vps_agentprice where a_sysid="& sysid
		rs.open sql,conn,1,3
		if not rs.eof then
			rs("a_discount")=a_discount
			rs("a_level")=a_level
			rs.update()
			alert_redirect "修改成功",requesta("script_name") & "?p_proid="& p_proid
		else
			rs.close()
			url_return "该记录不存在",-1
		end if
		rs.close
	else
		url_return "参数有误!",-1
	end if
elseif act="delagent" then
	if isnumeric(sysid) and sysid<>"" then
		conn.execute "delete from vps_agentprice where a_sysid="& sysid
		alert_redirect "删除成功",requesta("script_name") & "?p_proid="& p_proid
	else
		url_return "参数有误",-1
	end if
end if
call doUserSyn_vps(p_proid,false)
sql="select * from vps_price where p_proid='"& p_proid &"' and room_isStop="&PE_False&""
rs.open sql,conn,1,1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>vps价格设置</title>
<link href="/manager/css/admin.css" rel="stylesheet" type="text/css" />
<link href="/manager/css/style.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="/jscripts/jq.js"></script>
<script language="javascript">
function dosub(p,id){
	$("input[name='act']:hidden").val(p);
	$("input[name='sysid']:hidden").val(id);
	$("form[name='form1']").submit();
}
function dosyn(){
	if(confirm("确定同步？同步后价格将恢复到初始状态"))
	{
	$("input[name='act']:hidden").val("syn");
	$("form[name='form1']").submit();
	}
}
function doagentadd(){
	$("input[name='act']:hidden").val("addagent");
	$("form[name='form1']").submit();
}
function doagentmod(id){
	if(confirm("确定修改?")){
		$("input[name='sysid']:hidden").val(id);
		$("input[name='act']:hidden").val("modagent");
		$("form[name='form1']").submit();
	}
}
function doagentdel(id){
	if(confirm("确定删除?")){
		$("input[name='sysid']:hidden").val(id);
		$("input[name='act']:hidden").val("delagent");
		$("form[name='form1']").submit();
	}
}
</script>
</head>
<body>
<div style="font-size:14px; font-weight:bold;"> 产品类型id:<span style="color:#C33"><%=p_proid%></span>&nbsp;&nbsp;<%=p_name%> <a href="###" onclick="javascript:dosyn()">[同步价格]</a>
<a href="editpro.asp?p_id=<%=p_id%>">[详细修改]</a>
  <input type="button" value="返回" onclick="javascript:window.location.href='default.asp'" />
</div>
<form name="form1" action="<%=requesta("script_name")%>" method="post">
  <div class="tb-void">
    <table>
      <tr>
        <th width="12%">机房线路</th>
        <th width="16%">月付</th>
        <th width="15%">季付</th>
        <th width="16%">半年付</th>
        <th width="16%">年付</th>
        <th width="8%" class="nolin">操作</th>
      </tr>
      <%
  if not rs.eof then
  cur=1
  do while not rs.eof
  	v_sysid=rs("v_sysid")
  	v_room=trim(rs("v_room"))&""
	v_monthprice=rs("v_monthprice")
	v_seasonprice=rs("v_seasonprice")
	v_halfyearprice=rs("v_halfyearprice")
	v_yearprice=rs("v_yearprice")
	room_isStop=rs("room_isStop")
	month_isStop=rs("month_isStop")
	season_isStop=rs("season_isStop")
	halfyear_isStop=rs("halfyear_isStop")
	year_isStop=rs("year_isStop")
	bgcolor=""
	if cur mod 2=0 then bgcolor="bgcolor=""#fbfbfb"""
	if room_isStop then bgcolor="bgcolor=""#cccccc"""
  %>
      <tr <%=bgcolor%> class="trhover">
        <td align="center" nowrap="nowrap"><%=getroomname_(v_room,"","")%></td>
        <td align="center" nowrap="nowrap" <%if month_isStop then response.write "bgcolor=""#cccccc"""%>><%if month_isStop then response.write "已停用"%>
          <input type="text" name="monthPrice_<%=v_sysid%>" size="10" class="inputbox" value="<%=v_monthprice%>" /></td>
        <td align="center" nowrap="nowrap" <%if season_isStop then response.write "bgcolor=""#cccccc"""%>><%if season_isStop then response.write "已停用"%>
          <input type="text" name="seasonPrice_<%=v_sysid%>" size="10" class="inputbox" value="<%=v_seasonprice%>" /></td>
        <td align="center" nowrap="nowrap" <%if halfyear_isStop then response.write "bgcolor=""#cccccc"""%>><%if halfyear_isStop then response.write "已停用"%>
          <input type="text" name="halfyearPrice_<%=v_sysid%>" size="10" class="inputbox" value="<%=v_halfyearprice%>" /></td>
        <td align="center" nowrap="nowrap" <%if year_isStop then response.write "bgcolor=""#cccccc"""%>><%if year_isStop then response.write "已停用"%>
          <input type="text" name="yearPrice_<%=v_sysid%>" size="10" class="inputbox" value="<%=v_yearprice%>" /></td>
        <td><input type="button" value="确定修改" class="btn_mini" onClick="return dosub('edit','<%=v_sysid%>')"  /></td>
      </tr>
      <%
	cur=cur+1
  	rs.movenext
   loop
   else
   %>
      <tr>
        <td colspan="9" style="text-align:center; color:#777">还没有任何记录，请在下面添加</td>
      </tr>
      <%
   end if
   rs.close
  %>
    </table>
  </div>
  <div class="tb-void" style="width:500px;">
    <table>
      <tr>
        <th width="12%">代理级别</th>
        <th width="16%">折扣价</th>
        <th width="8%" class="nolin">操作</th>
      </tr>
      <%
	sql="select * from vps_agentprice where p_proid='"& p_proid &"'"
	rs.open sql,conn,1,1
	do while not rs.eof
		a_sysid=rs("a_sysid")
	%>
      <tr>
        <td><%call getlevellist(rs("a_level"),"a_level_"&a_sysid)%></td>
        <td><input type="text" style="width:100px" value="<%=formatnumber(rs("a_discount"),2,-1,-2)%>" name="a_discount_<%=a_sysid%>" /></td>
        <td><a href="###" onclick="javascript:doagentmod(<%=a_sysid%>)">[修改]</a><a href="###" onclick="javascript:doagentdel(<%=a_sysid%>)">[删除]</a></td>
      </tr>
      <%
	rs.movenext
	loop
	rs.close
	%>
      <tr>
        <td><%call getlevellist(1,"new_level")%></td>
        <td><input type="text" style="width:100px" name="new_discount" value="0.95" /></td>
        <td><input type="button" value="确定添加" onclick="javascript:doagentadd()" /></td>
      </tr>
      <tr>
        <td colspan="2"> 用户需支付费用:折扣价×产品价 </td>
      </tr>
    </table>
  </div>
  <input type="hidden" name="p_proid" value="<%=p_proid%>" />
  <input type="hidden" name="act" />
  <input type="hidden" name="sysid" />
</form>
</body>
</html>
<%
sub getlevellist(byval levelid,byval selectname)
%>
<select name="<%=selectname%>">
  <%
	sql="select * from levellist order by l_level"
	rs1.open sql,conn,1,1
	do while not rs1.eof
		selectedstr=""
		if levelid=rs1("l_level") then selectedstr="selected=""selected"""
	%>
  <option <%=selectedstr%>  value="<%=rs1("l_level")%>"><%=rs1("l_name")%></option>
  <%
	rs1.movenext
	loop
	rs1.close
	%>
</select>
<%
end sub
sub getselectbox(byval s_room,byval sysid)
%>
<select name="room_<%=sysid%>" <%if sysid="add" then response.write "multiple=""multiple"" size=8" %>>
  <%
	roomsql="select * from serverRoomlist order by r_typecode"
	set roomRs=conn.execute(roomsql)
	if not roomRs.eof then
		do while not roomRs.eof
		
		%>
  <option value="<%=trim(roomRs("r_typecode"))%>" <%if trim(roomRs("r_typecode"))=trim(s_room) then response.write "selected style=""background:#9FF"""%>><%=trim(roomRs("r_name"))%></option>
  <%
		roomRs.movenext
		loop
	end if
	roomRS.close
	set roomRs=nothing
	%>
</select>
<%
end sub

function isadd(byval room,byval sysid,byval p_proid)
	isadd=true
	if room="" or sysid="" then exit function
	psql="select * from vps_price where v_sysid<>"& sysid &" and p_proid='"& p_proid &"' and v_room="& room
	set prs=conn.execute(psql)
	if not prs.eof then
		isadd=false
	end if
	prs.close
	set prs=nothing
end function

%>
