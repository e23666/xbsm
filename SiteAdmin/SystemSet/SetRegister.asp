<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/Interface_bizcn.asp" -->
<!--#include virtual="/config/Interface_dnscn.asp" -->
<!--#include virtual="/config/Interface_netcn.asp" -->
<!--#include virtual="/config/Interface_xinet.asp" -->
<%Check_Is_Master(1)%>
<%
die "只能使用默认接口"
function isGrant(dmreg)
	select case dmreg
		case "dnscn"
			isGrant=GRANTCODE_DNSCN
		case "bizcn"
			isGrant=GRANTCODE_BIZCN
		case "netcn"
			isGrant=GRANTCODE_NETCN
		case "xinet"
			isGrant=GRANTCODE_XINET
		case else
			isGrant=true
	end select
end function

function GetAList()
	QS="select p_name,P_proId from productlist where p_type=3"
	Set localRs=CreateObject("Adodb.RecordSet")
	LocalRs.open QS,conn,1,1
	do while not LocalRs.eof
		GetAList=GetAList & vbcrlf 
		GetAList=GetAList & "<option value=""" & LocalRs("p_proid") & """>" & LocalRs("p_name") & "(" & LocalRs("P_proid") & ")" &  "</option>"
		LocalRs.moveNext
	Loop
	LocalRs.close
	Set LocalRs=nothing
end function

function GetPName(xxx)
	QS="select p_name from productlist where P_proId='" & xxx & "'"
	Set localRs=CreateObject("Adodb.RecordSet")
	LocalRs.open QS,conn,1,1
	if not LocalRs.eof then
		GetPName=LocalRs("p_name")
	else
		GetPName="未知"
	end if
	LocalRs.close
	Set LocalRs=nothing
end function

conn.open constr
MainSQL="select * from RegisterMap"
Act=Requesta("Act")

select case Act
	case "NEW"
		D_T=Requesta("D_T")
		R_V=Requesta("R_V")
		if D_T="" or R_V="" then url_return "请将信息填写完整!",-1
		if not isGrant(R_V) then
			Response.write "<script language=javascript>alert('错误,该接口" & R_V & "还未被授权，请查看页面提示，若满足条件请联系西部数码客服');history.back();</script>"
			Response.End()
		end if
		rs.open "select id from registerMap where domaintype='" & D_T &"'",conn,1,1
		if not rs.eof then
			rs.close
			Response.write  "<script language=javascript>alert('抱歉，该类型" & D_T & "已经存在');history.back();</script>"
			Response.end
		end if
		rs.close
		conn.execute("insert into RegisterMap(domaintype,register) values ('" & D_T & "','" & R_V & "')")
	case "UPDATE"
		for each formVar in Request.Form
			if left(formVar,3)="OP_" then
				opid=Cint(mid(formVar,4))
				opval=Request(formVar)
				if not isGrant(opval) then
					Response.write "<script language=javascript>alert('错误,该接口" & opval & "还未被授权，请联系西部数码客服');history.back();</script>"
				else
					conn.execute("update RegisterMap set register='" & opval & "' where id=" & opid )
				end if
			end if
		next
	case "DEL"
			ACTID=Requesta("ACTID")
			if not isNumeric(ACTID) then Response.write  "操作ID丢失":Response.End()
			conn.Execute("delete from RegisterMap where id=" & ACTID)
end select

rs.open MainSQL,conn,1,1
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>域 名 接 口 设 置</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>特别声明：</strong></td>
    <td width="771">此功能需要单独授权，若需支持请与管理员联系，并且在此之前您应先设置好相关服务商的用户名与密码。否则设置后域名注册功能将无法使用。若不设置，则所有域名默认使用西部数码接口注册。</td>
  </tr>
</table>

<br>
<table width="100%" border="0" align="center" cellpadding="4" cellspacing="1" class="border" borderdark="#ffffff">
<form name="form1" method="post" action="">    
    <tr align="center"> 
      <td align="center" class="Title"><strong>域名类别</strong></td>
      <td class="Title"><strong>产品编号</strong></td>
      <td class="Title"><strong>注册商</strong></td>
      <td class="Title"><strong>操作</strong></td>
    </tr>
<%do while not rs.eof%>
    <tr> 
      <td align="center" class="tdbg"><%=GetPName(rs("domaintype"))%></td>
      <td align="center" class="tdbg"><%=rs("domaintype")%></td>
      <td align="center" class="tdbg"> 
        <input type="text" name="OP_<%=rs("id")%>" value="<%=rs("register")%>">      </td>
      <td class="tdbg"> 
        <input type="button" name="Submit" value="删除" onClick="if (confirm('确定删除<%=rs("domaintype")%>?')){this.form.ACT.value='DEL';this.form.ACTID.value=<%=rs("id")%>;this.form.submit();}">      </td>
    </tr>
<%
rs.moveNext
loop%>
    <tr> 
      <td colspan="2" class="tdbg"> 
       <input type="hidden" name="ACT">
      <input type="hidden" name="ACTID">
        <select name="D_T">
			<%=GetAList()%>
        </select>      </td>
      <td align="center" class="tdbg"> 
        <select name="R_V">
          <option value="default">西部数码(默认)</option>
          <option value="bizcn">商务中国</option>
          <option value="xinet">新 网</option>
          <option value="dnscn">新网互联</option>
          <option value="netcn">万 网</option>
        </select>
        <input type="button" name="Submit3" value="添加" onClick="this.form.ACT.value='NEW';this.form.submit();">      </td>
      <td class="tdbg"> 
        <input type="button" name="Submit2" value="更新" onClick="this.form.ACT.value='UPDATE';this.form.submit();">      </td>
    </tr>
    <tr>
      <td colspan="4" class="tdbg">
        <p><br>
          说明:各注册商的缩写：default(西部数码) bizcn(商务中国),dnscn(新网互联),xinet(新网),netcn(万网)<br>
          本系统支持以上5个域名注册接口，默认只免费开通了西部数码接口。<br>
          若使用其他接口请先到西部数码  <a href="http://www.west263.com/reg" target="_blank">www.west263.com/reg</a> 注册为会员，需付费200元购买开通接口。 （通知：从2012年8月15日开始，停止出售其他接口）</p>
      <p>        若使用商务中国的接口，需要在服务器上运行商务中国的jdk+中间件并册组件mysocket.dll。若使用新网互联的接口，需要在服务器上注册新网互联的DLL文件。除万网以外的接口，都需要在域名注册商处设置IP授权。      </p></td>
    </tr>
    </form>
  </table>
</body>
</html>
