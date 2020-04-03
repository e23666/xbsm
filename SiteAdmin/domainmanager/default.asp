<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr
response.Charset="gb2312"
response.Buffer=true
''''''''''''''''''''''sort''''''''''''''''''''''''''
sorttype=trim(requesta("sorttype"))
sorts=trim(requesta("sorts"))
act=trim(requesta("act"))
if act="ywgh"  then
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
		d_id=checkNumArray(trim(requesta("did")))
		'conn.execute("update domainlist set userid="&u_id&" where d_id in("&d_id&")")
			set hrs=Server.Createobject("adodb.recordset")
		sql="select * from domainlist where d_id in("&d_id&")"
		hrs.open sql,conn,1,3
		do while not hrs.eof
			if hrs("userid")<>u_id then
			mname=hrs("strdomain")
  			hrs("userid")=u_id
			hrs.update
			call Add_Event_logs(session("user_name"),1,mname,"所有者变更到["&u_name&"]["&u_id&"]")
			end if
		hrs.movenext
		loop



		die 200
	 else
          die "权限不足"
	 end if
end if
if sorttype="" then sorttype="desc"
if sorttype="asc" then 
	seesortstr="<img src=""/images/up_sort.png"" border=0 alt=""升序"">"
else
	seesortstr="<img src=""/images/down_sort.png"" border=0 alt=""倒序"">"
end if

sortsql=""
if sorts="" then sorts="regdate"
	sortsql=" "& sorts &" " & sorttype

'''''''''''''''''''''''''''''''''''''''''''''''''''
sqlstring="SELECT top 1000 domainlist.userid,domainlist.rexpiredate, domainlist.strDomain, domainlist.s_memo, domainlist.regdate, domainlist.bizcnorder, domainlist.years, domainlist.isreglocal, domainlist.d_id, UserDetail.u_name,domainlist.strdomainpwd,domainlist.proid  FROM domainlist left JOIN UserDetail ON domainlist.userid = UserDetail.u_id where domainlist.userid>0"
If Requesta("module")="search" Then
	If  Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		rs.open session("sqlsearch") &  " order by "& sortsql ,conn,3
	  else
		username=Trim(Requesta("username"))
		timemode=Trim(Requesta("timemode"))
		domain=Trim(Requesta("domain"))
		Submit=Requesta("Submit11")
		reg_date1=Requesta("reg_date1")
		reg_date2=Requesta("reg_date2")
		extname=Requesta("extname")
		ordermode=Requesta("ordermode")
		datelimit="regdate"
		sqllimit =""
		If timemode=1 Then datelimit="rexpiredate"
		if extname<>"" then sqllimit=sqllimit & " and domainlist.proid='" & extname & "'"
		If username<>"" Then sqllimit=sqllimit & " and UserDetail.u_name = '"&username&"'"
		If isdate(reg_date1) Then sqllimit=sqllimit & " and dateDiff("&PE_DatePart_D&","& datelimit&",'"& reg_date1&"')<=0"
		If isdate(reg_date2) Then sqllimit=sqllimit & " and dateDiff("&PE_DatePart_D&","& datelimit&",'"& reg_date2&"')>=0"
		If domain<>"" Then sqllimit=sqllimit & " and (domainlist.strDomain  like '%"&domain&"%' or domainlist.s_memo like '%"& domain &"%') "
		
		sqlcmd= sqlstring & sqllimit
		'重新查找  分别需要定义 传上来的参数等等求出
		session("sqlsearch")=sqlcmd
		rs.open session("sqlsearch") &  " order by "& sortsql ,conn,3
	End If
elseif  Requesta("module")="del" Then
  	 delinfo=requesta("delinfo")
	
	 if len(delinfo)>0 then
	 	sql="delete from  domainlist where d_Id in("& delinfo &")"
		conn.execute sql
		conn.close
		Alert_Redirect "删除成功",request("script_name")
	 else
	 	Alert_Redirect "请选中您要删除的项",request("script_name")
	 end if
	 
elseif 	  Requesta("module")="syntime" Then
       delinfo=requesta("delinfo")
	 message="域名同步操作：\n"
	 if len(delinfo)>0 then
	 	sql="select domainlist.strDomain,UserDetail.u_name from  domainlist,UserDetail where domainlist.d_Id in("& delinfo &") and domainlist.strDomain<>'' and domainlist.userid = UserDetail.u_id"
		set synrs=conn.execute(sql)
		do while not synrs.eof
		'die synrs("strDomain")&"|"&now
		if trim(synrs("strDomain"))<>"" then
			returnstr=doUserSyn("domain",trim(synrs("strDomain")),Trim(synrs("u_name")))
			 
			if left(returnstr,3)="200" then
			message=message&synrs("strDomain")&"【成功】\n"
			else
			message=message&synrs("strDomain")&"〖失败〗\n"
			end if
		end if
		synrs.movenext
		loop
		Alert_Redirect message,request("script_name")
	else
		Alert_Redirect "无同步资料请选中",request("script_name")
	end if

	 
  else
	sqlcmd= sqlstring 
	session("sqlsearch")=sqlcmd
	If sortsql<>"" Then sortsql=" order by "&sortsql
	rs.open session("sqlsearch") & sortsql,conn,1,3
End If

function doUserSyn(byval p_type,byval p_name,ByVal cu_name)
	select case trim(lcase(p_type))
		case "domain"
			syn_table="domainlist"
			sysfd="d_id"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "vhost"
			syn_table="vhhostlist"
			sysfd="s_sysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "server"
			syn_table="hostrental"
			sysfd="id"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "mail"
			syn_table="mailsitelist"
			sysfd="m_sysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case "mssql"
			syn_table="databaselist"
			sysfd="dbsysid"
			syn_fd=getTableFdlist(syn_table,sysfd)
		case else
			dousersyn="404 标识参数出错":exit function
	end select
	commandstr= "other" & vbcrlf & _
				"sync" & vbcrlf & _
				"entityname:record" & vbcrlf & _
				"tbname:" & syn_table & vbcrlf & _
				"fdlist:" & syn_fd & vbcrlf & _
				"ident:" & p_name & vbcrlf & _
				"." & vbcrlf
				
	doUserSyn=pcommand(commandstr,cu_name)
end function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script src="/jscripts/jq.js"></script>
<script language="javascript">
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

function syntime()
{
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
		if(confirm('确定要同步选中的域名项吗?')){
			document.form2.action='<%=request("script_name")%>?module=syntime';
			document.form2.submit();
		}
	}else{
		alert('请选中您要删除的项');
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
			document.form2.action='<%=request("script_name")%>?module=del';
			document.form2.submit();
		}
	}else{
		alert('请选中您要删除的项');
	}
}
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
			
     	document.form1.action="<%=request("script_name")%>?pages=<%=Requesta("pages")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
		
		
	  }

}

function ywgh()
{
domstr=""
obj=$("input[name='delinfo']:checkbox")
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
  if(confirm("你请定要将选中域名移到["+u.val()+"]帐户下！"))
  
  {

		 url="?act=ywgh&u="+u.val()+"&did="+domstr

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
<style type="text/css">
<!--
.STYLE4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域 名 管 理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">域名管理</a></span> | <a href="ModifyDomain.asp">域名日期校正</a> | <a href="DomainIn.asp">域名转入</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a> | <A HREF="<%=SystemAdminPath%>/admin/syncDomain.asp">同步上级域名</A> </td>
  </tr>
</table>

<br>
<table   bordercolor="#FFFFFF" cellpadding="0" cellspacing="0" id="AutoNumber3" style="border-collapse: collapse" width="100%" height="218">
  <tr>
    <td height="175" width="99%" valign="top"><%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 20
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
	
%>
      <table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#FFFFFF" class="border">
        <form name="form2" action="<%=request("script_name")%>" method="post" >
        
        <tr class='title'>
          <td align="left" nowrap><input type="checkbox"  id="headerchk"  title="全选/全消"  class="checkbox"  onclick="checkall(this)" />
            <a href="#" title="仅能同步当前页域名" onClick="javascript:syntime()">[<font color="#fff">同步选中资料</font>]</a>&nbsp;&nbsp;<a href="#" title="仅删除数据库信息" onClick="javascript:dodel()">[选中删除]</a>&nbsp;&nbsp;<a href="javascript:dosort('strDomain')"><span class="STYLE4">域名/管理</span><%=seesortstr%></a></td>
          <td align="center" nowrap><a href="javascript:dosort('u_name')"><span class="STYLE4">用户名</span><%=seesortstr%></a></td>
          <td align="center" nowrap>代管</td>
          <td width="5%" align="center" nowrap><strong>财务</strong></td>
          <td align="center" nowrap><a href="javascript:dosort('regdate')"><span class="STYLE4">注册日期</span><%=seesortstr%></a></td>
          <td align="center" nowrap><a href="javascript:dosort('rexpiredate')"><span class="STYLE4">到期日期</span><%=seesortstr%></a></td>
          <td align="center" nowrap><a href="javascript:dosort('bizcnorder')"><span class="STYLE4">所属注册商</span><%=seesortstr%></a></td>
          <td align="center" nowrap><span class="STYLE4">状态</span></td>
          <td align="center" nowrap><a href="javascript:dosort('isreglocal')"><span class="STYLE4">类别</span><%=seesortstr%></a></td>
          <td align="center" nowrap><span class="STYLE4">操作</span></td>
        </tr>
        <%
	Do While Not rs.eof And i<Rs.PageSize
		 bgcolorstr="#EAF5FC"
		if i mod 2 =0 then bgcolorstr="#ffffff"
 
	%>
        <tr bgcolor="<%=bgcolorstr%>">
          <td align="left" ><input type="checkbox" value="<%=rs("d_Id")%>" name="delinfo">
            <a href="DomainCtr.asp?Domainid=<%=rs("d_id")%>">
            <%if instr(rs("strDomain"),"xn--")=0 then
  Response.write  rs("strDomain") 
	else
  Response.write  rs("strDomain") & "("&rs("s_memo")&")"
	end if%>
            </a>  </td>
          <td align="center" nowrap ><a href="../usermanager/detail.asp?u_id=<%=Rs("userid")%>" target="_blank"><font color="#0000FF"><%=rs("u_name")%></font></a></td>
          <td align="center" nowrap ><a href="../chguser.asp?module=chguser&username=<%=rs("u_name")%>"><font color="#0000FF">代管</font></a></td>
          <td align="center" nowrap  width="5%"><a href="../billmanager/Mlist.asp?username=<%=rs("u_name")%>&module=serach" target="_blank"><img src="../images/finance.gif" width="16" height="16" border="0" alt="查看该用户的财务记录"></a></td>
          <td align="center" nowrap ><%= formatdatetime(rs("regdate"),2) %> </td>
          <td align="center" nowrap ><%
		If rs("rexpiredate")<> "" Then
			Response.Write left(replace(rs("rexpiredate")," ","   "),10)
		End If'strDomain,s_memo,u_name,regdate,bizcnorder,years,strDomain,isreglocal,d_id，rexpiredate
		%>
          </td>
          <td align="center" nowrap ><%
								If left(rs("bizcnorder"),5)="default" Then
									Response.Write "西部数码"
								elseIf left(rs("bizcnorder"),5)="netcn" Then
									Response.Write "万网"
								elseIf left(rs("bizcnorder"),5)="dnscn" Then
									Response.Write "新网互联"
								elseIf left(rs("bizcnorder"),5)="bizcn" Then
									Response.Write "商务中国"
								elseIf left(rs("bizcnorder"),5)="xinet" Then
									Response.Write "新网"
								  else
									Response.Write "默认注册商"
								End If
								%>
          </td>
          <td align="center" nowrap ><%=showdomainstatus(rs("regdate"),rs("years"))%></td>
          <td align="center" nowrap ><%
								If rs("isreglocal") then
									Response.write "DNS管理"
								else
									Response.write "<font color=red>域名</font>"
								End If
						%>
          </td>
          <td align="left" nowrap ><a href="DomainCtr.asp?Domainid=<%=rs("d_id")%>">管理</a>|<a href="renewDomain.asp?DomainID=<%=Rs("d_id")%>">续费</a>
            <%If not rs("isreglocal") then 
            	
				mydomaintype=GetDomainType(rs("strDomain"))
				if  instr(right(mydomaintype,2),"cn")>0 then
					cerhref="cercn.asp?DomainID="& rs("d_id")
				else
					cerhref="cer.asp?DomainID="& rs("d_id")
				end if
				%>
            |<a href="/manager/domainmanager/cer/<%=cerhref%>&u_id=<%=Rs("userid")%>" target="_blank">证书</a>
            <%end if%>
          </td>
        </tr>
        <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
        <tr>
          <td colspan ="12" align="center" bgcolor="#efefef"><a href="default.asp?module=search&amp;pages=1&sorts=<%=sorts%>&sorttype=<%=sorttype%>">第一页</a> &nbsp; <a href="default.asp?module=search&amp;pages=<%=pages-1%>&sorts=<%=sorts%>&sorttype=<%=sorttype%>">前一页</a>&nbsp; <a href="default.asp?module=search&amp;pages=<%=pages+1%>&sorts=<%=sorts%>&sorttype=<%=sorttype%>">下一页</a>&nbsp; <a href="default.asp?module=search&amp;pages=<%=rsPageCount%>&sorts=<%=sorts%>&sorttype=<%=sorttype%>">共<%=rsPageCount%>页</a>&nbsp; 
            第<%=pages%>页</td>
        </tr>
        </form>
		<tr>
		<td colspan="12"><form>将选中域名过户到:<INPUT TYPE="text" NAME="gh_u_name" id="gh_u_name"><INPUT TYPE="button" value="确定过户" onclick="ywgh()"></form></td>
		</tr>
      </table>
      <%
  else
	rs.close
	conn.close
End If

%>
      <br />
             <form action="default.asp" method="post" name="form1" id="form1">
 <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#FFFFFF" class="border">
          <tr>
            <td align="right" class="tdbg"><p style="margin-left: 9">　域名:</p></td>
            <td class="tdbg">
                <input name="domain" id="domain" size="20" style="font-size: 9pt" value="<%=domain%>" />
            </td>
         
            <td align="right" class="tdbg"><p style="margin-left: 9">　用户名:</p></td>
            <td   class="tdbg">  <input name="username" size="20" style="font-size: 9pt" <%=username%>/>
             </td>
           
            <td align="right" class="tdbg">类别:</td>
            <td class="tdbg"><p style="margin-left: 9">
                <select name="extname">
                  <%
				  if extname<>"" then
				  	%>
                    <option value="<%=extname%>" selected><%=extname%></option>
                    <%
				  end if
				  %>
                  <option value="">全部</option>
                  <option value="WA079">通用网址</option>
                  <option value="domhzcom">中文.com</option>
				  <option value="domhznet">中文.net</option>
                  <option value="dom中国">中文.公司/网络</option>
                  <option value="dns001">DNS管理</option>
                  <option value="domcom">.com</option>
                  <option value="domcn">.cn</option>
                  <option value="domnet">.net</option>
                  <option value="domorg">.org</option>
                  <option value="domnetcn">.net.cn</option>
                  <option value="dominfo">.info</option>
                  <option value="domgxcn">.gx.cn</option>
                  <option value="domgovcn">.gov.cn</option>
                  <option value="domcomcn">.com.cn</option>
                  <option value="dommobi">.mobi</option>
                  <option value="domname">.name</option>
                  <option value="domcc">.cc</option>
                  <option value="dmbiz">.biz</option>
                  <option value="domorgcn">.org.cn</option>
                  <option value="domtv">.tv</option>
                </select>
              </p></td>
          </tr>
			<tr>
            <td align="right" class="tdbg"><p style="margin-left: 9">　时间:</p></td>
            <td class="tdbg"><p style="margin-left: 9">
<select name="timemode">
	<option value="0" <%if timemode=0 then response.write "selected"%>>申请时间
	<option value="1"  <%if timemode=1 then response.write "selected"%>>过期时间
</select> </p></td>
            <td align="right" class="tdbg"><p style="margin-left: 9">　日期:</p></td>
            <td width="17%" class="tdbg"><p style="margin-left: 9">
                <input name="reg_date1" size="10" style="font-size: 9pt" value="<%=reg_date1%>" placeholder="<%=FormatDateTime(Now(),2)%>"/>到
                <input name="reg_date2" size="10" style="font-size: 9pt" value="<%=reg_date2%>"  placeholder="<%=FormatDateTime(Now(),2)%>"/>
              </p></td>
            <td></td>
            <td class="tdbg"><p style="margin-left: 9">
                <input name="module" type="hidden" value="search" />
                <input name="Submit11" type="submit" value="　查　询　" style="font-size: 9pt" />
				 <input type="button" name="Submit2" value="whois查询" onclick="showwhoist()">
            </td>
          </tr>
     
      </table>   </form></td>
  </tr>
</table>

<script>
function showwhoist(){
     domstr=$("#domain").val();
	 if (domstr=="")
	 {
	 alert("请先录入域名");
	 return false
	 }
	 location.href="view.asp?domain="+escape(domstr)
}
</script>
<br />

<%
Function showdomainstatus(regdate,regyears)
	If isnull(regdate)  Then
		showdomainstatus = "注册失败"
		exit function
	End If
	expiredate =  dateadd("yyyy",regyears,cdate(regdate))
	showdomainstatus = "过期"
	If cdate(expiredate) >= Date Then showdomainstatus = "正常"
End Function

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
