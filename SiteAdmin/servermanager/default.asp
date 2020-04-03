<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr:response.Charset="gb2312"


if requesta("act")="ywgh"  then
	if Check_as_Master(1) then
		u=trim(requesta("u"))
		set u_rs=conn.execute("select u_id,u_name from UserDetail where u_name='"&u&"'")
		if u_rs.eof then
			die "查询用户名称失败！"
		else
			u_id=u_rs("u_id")
			u_name=u_rs("u_name")
			u_rs.close
			set u_rs=nothing
		end if
		d_id=checkNumArray(trim(requesta("id")))
		'conn.execute("update vhhostlist set S_ownerid="&u_id&" where s_sysid in("&d_id&")")
		set hrs=Server.Createobject("adodb.recordset")
		sql="select * from HostRental where id in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("u_name")<>u_name then
			mname=hrs("AllocateIP")
  			hrs("u_name")=u_name
			hrs.update
			call Add_Event_logs(session("user_name"),3,mname,"所有者变更到["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "权限不足"
	 end if
end if


	if requesta("module")="dele" then
sysids = requesta("sysids")
	if not regtest(sysids&"," , "^(\d+\,)+$") then Die "错误的操作参数"

		'conn.execute("delete from HostRental where id in(" & sysids & ")")

		sql="select AllocateIP  from HostRental where id in(" & sysids & ")"
		set d_rs=Server.CreateObject("adodb.recordset")
		d_rs.open sql,conn,1,3
		do while not d_rs.eof 
        call Add_Event_logs(session("user_name"),3,d_rs("AllocateIP"),"删除Server操作")
        d_rs.delete()
		d_rs.movenext
		loop
		d_rs.close
		set d_rs=nothing
		conn.close



		result = "所选的记录已经删除，<a href='javascript:void(0)' onclick='location.reload()'>点这里刷新</a>"
		die result
end if
if requesta("act")="savememo" then

	txt=requesta("txt")
	id=requesta("id")
	if not isnumeric(id&"") or txt="" then die ""
	rs.open "select memo from hostrental where id=" & id,conn,1,3
	if rs.eof then die "无此记录"
	rs("memo")=requesta("txt")
	rs.update
	rs.close
	die "200 ok"
end if
sqlstring="Select * from HostRental where id<>0"
sqlArray=Array("allocateip,IP地址,str","StartTime,开通日期,date","Name,联系人,str","Telephone,电话,str","U_name,用户名,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="Select * from HostRental where 1=1 " & newsql & " order by  Start asc,SubmitTime desc"
rs.open sqlstring,conn,1,1
setsize=10
cur=1
pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script language="javascript" src="/jscripts/check.js"></script>
<script type="text/javascript">
$(function(){
	$("textarea").blur(function(){
		var obj=$(this);
		if (obj.attr("tag")==obj.val()) return false;
		var t = null;
		if (t = obj.attr("name").match(/(\d+)[^\d]*$/))
		{
			var post="act=savememo&id=" + t[1] + "&txt=" + escape( $(this).val() );
			$.post("?",post,function(xml){
				if (xml.substr(0,3)!="200") {
				alert("自动保存错误：" + xml)
				}else{
					obj.css("border","1px solid green");
				};
			})
		}
	}).focus(function(){
		$(this).attr("tag",$(this).val());
	})
})



function Actstart(module){
	var sysids = getcheckval("s_sysid");
	if (sysids=="") {
		alert("请选择要操作对象");
	}else{
		if (module=="dele"){if (!confirm("确定删除?")) return false;}
		var post="module="+module+"&sysids="+sysids;
	 $("#actresult").html("<img src='/images/ajax001.gif'> 正在执行...");
		$.post("?",post,function(xml){
			$("#actresult").html(xml);
		})
	}
}
function getcheckval(nm){
	var chk_value =[];    
	var obj=$("input[name='" + nm + "']:checkbox:checked").each(function(){    
		chk_value.push($(this).val());    
	});
	return chk_value;
}
function selectItem(nm){
	$(':checkbox[name=' + nm + ']').each(function(){
		this.checked= !this.checked;
	})
}
</script>

		
 
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>服 务 器 租 用 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><a href="default.asp">服务器/VPS管理</a> | <a href="ServerListnote.asp">查看新订单</a> | <a href="ServerWarn.asp">查看过期订单</a> | <a href="syn.asp">同步上级服务器</a></td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
<tr>
<td>
<label><input type="checkbox" onClick="selectItem('s_sysid')" />反选</label> 
[<a href="javascript:void(0)" title="仅删除数据库信息" onClick="Actstart('dele')">删除选中</a>]<span style="color:red" id="actresult"></span></td>
<td align="right">&nbsp;</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border">
        <tr align=middle class='title'>

          <td align="center"><strong>类别</strong></td>
          <td align="center"><strong>服务器IP</strong></td>
 
          <td align="center"><strong>联系人</strong></td>
          <td align="center"><strong>联系电话</strong></td>
          <td align="center"><strong>状态</strong></td>
          <td align="center"><strong>年限</strong></td>
          <td align="center"><strong>用户</strong></td>
         
          <td align="center"><strong>开通日期</strong></td>
			<td align="center"><strong>编辑</strong></td>
        </tr>
        <%
do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
	pid=rs("id")
	%>
        <tr align=middle bgcolor="<%=tdcolor%>" title="【CPU】<%=Rs("CPU")%>&#10;【内存】<%=Rs("Memory")%>&#10;【硬盘】<%=Rs("HardDisk")%>&#10;【带宽】<%=rs("flux")%>">

          <td bgcolor="#EAF5FC" class="tdbg"><span class="checkbx"><input type="checkbox" name="s_sysid" value="<%=Rs("id")%>" /></span> <%=getHostType(Rs("hostType"))%></td>
          <td  class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>"><font color=red><%=Rs("AllocateIP")%></font></a><br>  <%If rs("ddos")>0 Then %>
			<p style="color:#fe6b1b">(高防防护峰值:<%=rs("ddos")%>G)</p>
		  <%End if%>
		  <%If rs("prodtype")&""="1" Then%>
			<font style="color:#fe6b1b">(高频CPU型)</font>
		  <%End if%>
		  </td>
         
          <td  class="tdbg"><%=Rs("Name")%></td>
          <td  class="tdbg"><%=Rs("Telephone")%><br>          </td>
          <td align="center"  class="tdbg"> 
		  <%
		  
		  if Rs("Start") then
		    etime=formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime"))),2)
			   if datediff("d",now,etime)<0 then
				 response.Write("<font color=red>到期</font>")
			   else
				response.Write("<font color=green>正常</font>")
			   end if
		  else
		   response.Write("<font color=red>未知</font>")
		  end if
		  %>
 </td>
          <td  class="tdbg"><%=Rs("Years")%></td>
          <td  class="tdbg">
<%if isNull(rs("u_name")) then
			response.write "&nbsp;"
else
			response.write "<a href=""../chguser.asp?module=chguser&username="&rs("u_name")&""" target=""_blank"">"&rs("u_name")&"</a>"
end if%></td>
          
          <td align="center" nowrap class="tdbg"><%
			if Rs("Start") then
				Response.write "从" & formatDateTime(Rs("StartTime"),2) & "开始, "
				response.write "到" & formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime"))),2)&"结束"
			else
				Response.write "下单时间:"& Rs("SubmitTime")
			end if
%><br>
<textarea name="memo<%=pid%>" cols="30" rows="2"><%=replace(rs("memo")&"","<BR>",vbcrlf)%></textarea>
</td>
		<td  class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>">编辑</a></td>
        </tr>
        <%
		rs.movenext
		cur=cur+1
	Loop
	rs.close
	conn.close
	%>
        <tr bgcolor="#FFFFFF">
          <td colspan =12 align="center" class="tdbg"><%=pagenumlist%></td>
        </tr>
        <tr>
            <td colspan="12" class="tdbg">
			<form name="form3" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
			将选中业务过户到:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="确定过户" onclick="ywgh()">&nbsp;&nbsp;
			<%=searchlist%>
            </form>
            </td>
	 </tr>
</table>

<script>
function ywgh()
{
domstr=""
obj=$("input[name='s_sysid']:checkbox")
u=$("input[name=gh_u_name]");
if(u.val()==="")
{
alert("业务过户者为空!")
u.focus()
return false;
}
 for(var i=0;i<obj.length;i++)
 {
    if(obj[i].checked)
	{
	   if(domstr==="")
	   {
		   domstr=obj[i].value;
	   }else{
	      domstr+=","+obj[i].value;
	   }
	}
 }
 if(domstr==="")
 {
 alert("请选择要过户的域名!")
 return false;
 }
  if(confirm("你请定要将选中业务移到["+u.val()+"]帐户下！"))
  
  {

		 url="?act=ywgh&u="+u.val()+"&id="+domstr

		 $.get(url,"",function(date){
			  if(date=="200")
			  {
			  location.reload()
			  }else
			  {
			  alert(date);
			  }
		 })
}
}  
</script>
<%
function getStatus(byval sta)
	if sta="" or isnull(sta) or not sta then
		getStatus="未开通"
	elseif sta then
		getStatus="已开通"
	end if
	
end function
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


function checkNumArray(str)
   temparray=split(str,",")
   newArray=""
   for i=0 to ubound(temparray)
      if isnumeric(temparray(i)&"") then
	  		if newArray="" then
				newArray=temparray(i)
			else
				newArray=newArray&","&temparray(i)
			end if
	  end if
   next
   if newArray="" then newArray=0
   checkNumArray=newArray
end function
%>

<!--#include virtual="/config/bottom_superadmin.asp" -->
