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
			die "��ѯ�û�����ʧ�ܣ�"
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
			call Add_Event_logs(session("user_name"),3,mname,"�����߱����["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop

		die 200
	 else
          die "Ȩ�޲���"
	 end if
end if


	if requesta("module")="dele" then
sysids = requesta("sysids")
	if not regtest(sysids&"," , "^(\d+\,)+$") then Die "����Ĳ�������"

		'conn.execute("delete from HostRental where id in(" & sysids & ")")

		sql="select AllocateIP  from HostRental where id in(" & sysids & ")"
		set d_rs=Server.CreateObject("adodb.recordset")
		d_rs.open sql,conn,1,3
		do while not d_rs.eof 
        call Add_Event_logs(session("user_name"),3,d_rs("AllocateIP"),"ɾ��Server����")
        d_rs.delete()
		d_rs.movenext
		loop
		d_rs.close
		set d_rs=nothing
		conn.close



		result = "��ѡ�ļ�¼�Ѿ�ɾ����<a href='javascript:void(0)' onclick='location.reload()'>������ˢ��</a>"
		die result
end if
if requesta("act")="savememo" then

	txt=requesta("txt")
	id=requesta("id")
	if not isnumeric(id&"") or txt="" then die ""
	rs.open "select memo from hostrental where id=" & id,conn,1,3
	if rs.eof then die "�޴˼�¼"
	rs("memo")=requesta("txt")
	rs.update
	rs.close
	die "200 ok"
end if
sqlstring="Select * from HostRental where id<>0"
sqlArray=Array("allocateip,IP��ַ,str","StartTime,��ͨ����,date","Name,��ϵ��,str","Telephone,�绰,str","U_name,�û���,str")
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
				alert("�Զ��������" + xml)
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
		alert("��ѡ��Ҫ��������");
	}else{
		if (module=="dele"){if (!confirm("ȷ��ɾ��?")) return false;}
		var post="module="+module+"&sysids="+sysids;
	 $("#actresult").html("<img src='/images/ajax001.gif'> ����ִ��...");
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
    <td height='30' align="center" ><strong>�� �� �� �� �� �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="default.asp">������/VPS����</a> | <a href="ServerListnote.asp">�鿴�¶���</a> | <a href="ServerWarn.asp">�鿴���ڶ���</a> | <a href="syn.asp">ͬ���ϼ�������</a></td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
<tr>
<td>
<label><input type="checkbox" onClick="selectItem('s_sysid')" />��ѡ</label> 
[<a href="javascript:void(0)" title="��ɾ�����ݿ���Ϣ" onClick="Actstart('dele')">ɾ��ѡ��</a>]<span style="color:red" id="actresult"></span></td>
<td align="right">&nbsp;</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="2" cellspacing="1" class="border">
        <tr align=middle class='title'>

          <td align="center"><strong>���</strong></td>
          <td align="center"><strong>������IP</strong></td>
 
          <td align="center"><strong>��ϵ��</strong></td>
          <td align="center"><strong>��ϵ�绰</strong></td>
          <td align="center"><strong>״̬</strong></td>
          <td align="center"><strong>����</strong></td>
          <td align="center"><strong>�û�</strong></td>
         
          <td align="center"><strong>��ͨ����</strong></td>
			<td align="center"><strong>�༭</strong></td>
        </tr>
        <%
do while not rs.eof and cur<=setsize
	tdcolor="#ffffff"
	if cur mod 2=0 then tdcolor="#efefef"
	pid=rs("id")
	%>
        <tr align=middle bgcolor="<%=tdcolor%>" title="��CPU��<%=Rs("CPU")%>&#10;���ڴ桿<%=Rs("Memory")%>&#10;��Ӳ�̡�<%=Rs("HardDisk")%>&#10;������<%=rs("flux")%>">

          <td bgcolor="#EAF5FC" class="tdbg"><span class="checkbx"><input type="checkbox" name="s_sysid" value="<%=Rs("id")%>" /></span> <%=getHostType(Rs("hostType"))%></td>
          <td  class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>"><font color=red><%=Rs("AllocateIP")%></font></a><br>  <%If rs("ddos")>0 Then %>
			<p style="color:#fe6b1b">(�߷�������ֵ:<%=rs("ddos")%>G)</p>
		  <%End if%>
		  <%If rs("prodtype")&""="1" Then%>
			<font style="color:#fe6b1b">(��ƵCPU��)</font>
		  <%End if%>
		  </td>
         
          <td  class="tdbg"><%=Rs("Name")%></td>
          <td  class="tdbg"><%=Rs("Telephone")%><br>          </td>
          <td align="center"  class="tdbg"> 
		  <%
		  
		  if Rs("Start") then
		    etime=formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime"))),2)
			   if datediff("d",now,etime)<0 then
				 response.Write("<font color=red>����</font>")
			   else
				response.Write("<font color=green>����</font>")
			   end if
		  else
		   response.Write("<font color=red>δ֪</font>")
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
				Response.write "��" & formatDateTime(Rs("StartTime"),2) & "��ʼ, "
				response.write "��" & formatDateTime(DateAdd("d",rs("preday"),DateAdd("m",rs("alreadypay"),rs("starttime"))),2)&"����"
			else
				Response.write "�µ�ʱ��:"& Rs("SubmitTime")
			end if
%><br>
<textarea name="memo<%=pid%>" cols="30" rows="2"><%=replace(rs("memo")&"","<BR>",vbcrlf)%></textarea>
</td>
		<td  class="tdbg"><a href="HostSummary.asp?id=<%=Rs("id")%>">�༭</a></td>
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
			��ѡ��ҵ�������:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="ȷ������" onclick="ywgh()">&nbsp;&nbsp;
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
alert("ҵ�������Ϊ��!")
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
 alert("��ѡ��Ҫ����������!")
 return false;
 }
  if(confirm("���붨Ҫ��ѡ��ҵ���Ƶ�["+u.val()+"]�ʻ��£�"))
  
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
		getStatus="δ��ͨ"
	elseif sta then
		getStatus="�ѿ�ͨ"
	end if
	
end function
function getHostType(ByVal xxx)
	select case xxx
		case 0
			getHostType="<b><font color=green>����</font></b>"
		case 1
			getHostType="<b><font color=red>VPS</font></b>"
		case 2
			getHostType="<b><font color=blue>�й�</font></b>"
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
