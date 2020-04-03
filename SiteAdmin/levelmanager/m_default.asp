<!--#include virtual="/config/config.asp" --><%Check_Is_Master(6)%>
<script language="JavaScript" src="/config/selectTime.js"></script>
<%
function getLname(lid)
	Set lrs=conn.Execute("select l_name from levellist where l_level=" & lid)
	if not lrs.eof then
		getLname=lrs("l_name")
	else
		getLname=""
	end if
	lrs.close:set lrs=nothing
end function

 Check_Is_Master(1)

module=Requesta("module")
If  module="chglevel" Then
	u_level=Requesta("u_level")
	u_IsCheckAgent=0
	conn.open constr
	rs.open "select l_name from levellist where l_level="&u_level&"",conn,3
	
 	conn.Execute "update UserDetail set u_level="&u_level&" ,u_levelname ='"&rs("l_name")&"',u_IsCheckAgent="&u_IsCheckAgent&" where u_id = " & SESSION("u_id_DO") & ""
	rs.close
	
	sql="select FirstLevelTime,LastLevelTime from UserDetail where u_id = " & SESSION("u_id_DO") & ""
	rs.open sql,conn,1,3
	if not rs.eof then
		if IsBlank(rs(0)) then
			rs(0)=now()
		end if
		rs(1)=now()
		rs.update
	end if
	rs.close
	
	conn.execute "delete from userPrice where u_id=" & SESSION("u_id_DO")
	psql="select * from Pricelevellist where p_level="& u_level
	rs11.open psql,conn,1,1
	if not rs11.eof then
		do while not rs11.eof
			p_proid=rs11("p_proid")
			p_price=rs11("p_price")
			conn.execute "insert into userprice(proid,proprice,u_id) values('"& p_proid &"','"& p_price &"',"& SESSION("u_id_DO") &")"
		rs11.movenext
		loop
	end if
	rs11.close
	
	conn.close
elseif module="AddPrice"  then
	conn.open constr
	u_id =Requesta("u_id")
	ProName=""
	ProId=requesta("ProId")
	ProPrice=requesta("ProPrice")
	PriceId=requesta("PriceId")
	sql="SELECT * FROM productlist WHERE (P_proId = '"&ProId&"')"
	rs.open sql,conn,1,1
	if not rs.eof then
		if PriceId="" then
			sql="INSERT INTO UserPrice (u_id, ProName, ProId, ProPrice) VALUES ("&u_id&",'"&ProName&"','"&ProId&"',"&ProPrice&")"
			conn.execute(sql)
		else
			sql="UPDATE UserPrice SET  ProName = '"&ProName&"', ProId = '"&ProId&"', ProPrice = "&ProPrice&" where UserPriceid="&PriceId&""
			conn.execute(sql)
		end if
		response.Redirect("m_default.asp?u_id="&u_id&"")
	else
		response.Write("<script>alert(""产品id错误！"");history.back()</script>")
		response.End()
	end if
	conn.close
elseif module="DelPrice" then
	conn.open constr
	PriceId=requesta("PriceId")
	sql="delete from UserPrice where UserPriceid="&PriceId&""
	conn.execute(sql)
	conn.close
elseif module="chgftime" then
	if not isDate(requesta("FirstTime")) then url_return "日期格式不对",-1
	u_id =Requesta("u_id")
	conn.open constr
	sql="update UserDetail set FirstLevelTime='"&requesta("FirstTime")&"' where u_id="&u_id&""
	conn.execute(sql)
	conn.close
End If
	u_id =Requesta("u_id")
	If u_id<>"" Then
	sqlstring="select * from UserDetail where u_id="&u_id&""
	session("sqlcmd_l2")=sqlstring
	SESSION("u_id_DO")=u_id
	End If
'	Response.End
	conn.open constr
	rs.open session("sqlcmd_l2"),conn,3
	if rs("f_id")>0 then
		Sql="select u_contract,u_name from userdetail where u_id=" & rs("f_id")
		Set TTRs=conn.Execute(Sql)
		if not TTRs.eof then
			Message=TTRs("u_contract") & "(" & TTRS("u_name") & ")"
		end if
		TTRs.close
		Set TTRs=nothing
		VCPuser="Y"
	else
		VCPuser="N"
	end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>代理商级别调整</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>
<table width="100%" border="0" align="center" cellPadding="3" cellSpacing="0" class="border">
  <tbody> 
  <tr> 
    <td colspan="3" class="Title"><strong>代理级别调整</strong></td>
  </tr>
  <tr> 
    <td class="tdbg">　</td>
    <td align="right" class="tdbg">级别：</td>
    <td class="tdbg"><%= rs("u_level") %> 
      <%thisUserLevel=rs("u_level")%>
    </td>
  </tr>
  <tr> 
    <td class="tdbg">　</td>
    <td align="right" class="tdbg">用户名：</td>
    <td class="tdbg"><%= rs("u_name") %></td>
  </tr>
  <tr> 
    <td class="tdbg">　</td>
    <td align="right" class="tdbg">消费总额：</td>
    <td class="tdbg"><%= rs("u_resumesum") %></td>
  </tr>
  <tr> 
    <td class="tdbg">　</td>
    <td align="right" class="tdbg">可用额：</td>
    <td class="tdbg"><%= rs("u_usemoney")%></td>
  </tr>
  <tr> 
    <td class="tdbg">　</td>
    <td align="right" class="tdbg">级称：</td>
    <td class="tdbg"><%= rs("u_levelname")%></td>
  </tr>
  <FORM name="DateForm" action="M_default.asp?u_id=<%=u_id%>" method=post onSubmit="return check(this)">
    <tr> 
      <td colspan="2" align="right" class="tdbg">第一次成为代理时间：</td>
      <td class="tdbg"> 
        <input type="text" name="FirstTime" value="<%= rs("FirstLevelTime")%>">
        <a href="javascript:" onClick="selectTime('DateForm.FirstTime',5)">选择</a> 
        <input type="submit" name="Submit2" value="确定">
        <input name="module" type="hidden" value="chgftime">
      </td>
    </tr>
  </form>
  <tr> 
    <td colspan="2" align="right" class="tdbg">最后修改代理时间：</td>
    <td class="tdbg"><%= rs("LastLevelTime")%></td>
  </tr>
  <tr> 
    <td class="tdbg"></td>
    <td colSpan="2" align="middle" class="tdbg"></td>
  </tr>
  <FORM action="M_default.asp?u_id=<%=u_id%>" method=post onSubmit="return check(this)">
    <tr> 
      <td class="tdbg">　</td>
      <td align="right" class="tdbg">改变级别：</td>
      <td class="tdbg"> 
        <select name="u_level">
          <option>--- 请选择新级别 ---</option>
          <%
		  sql="select * from levellist order by l_level asc"
		  rs1.open sql,conn,1,1
		  if not rs1.eof then
		  	do while not rs1.eof
				%>
                <option value="<%=rs1("l_level")%>" <%if thisUserLevel=rs1("l_level") then response.write " selected "%>><%=rs1("l_level")%> <%=rs1("l_name")%></option>
                <%
			rs1.movenext
			loop
		  end if
		  rs1.close
		  %>
          
        </select>
        <input name="sub" type="submit" value="确定">
        <input name="module" type="hidden" value="chglevel">
      </td>
    </tr>
    <input type=hidden name="VCPU" value="<%=VCPuser%>">
    <input type=hidden name="MESS" value="<%=Message%>">
  </FORM>
  </tbody> 
  <script language=javascript>
function check(form){
	if (form.VCPU.value=="Y")
		return confirm("您确认将VCP用户"+form.MESS.value+"发展的子用户<%=rs("u_name")%>升级为代理商？");
	return true;

}
</script>
  <%rs.close%>
</table>
<br />
		<%
		if requesta("module")="ModPrice" then
			sql="select * from UserPrice where UserPriceid="&requesta("PriceId")&""
			rs.open sql,conn,1,1
		end if
		%>
		  
<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr> 
    <td colspan="3" class="Title"><strong>自定义特殊价格</strong></td>
  </tr>
  <tr> 
    <td colspan="3"> 
      <div align="left">这里可以定义域名第一年购买的特殊价格。比如.Cn域名，代理商设置为第一年购买为1元，第二年还是按代理价50元。</div>
    </td>
  </tr>
  <form name="form1" method="post" action="m_default.asp?u_id=<%=u_id%>">
    <tr> 
      <td width="15%" align="right">产品Proid</td>
      <td width="23%"> 
        <input type="text" name="ProId" value="<%if requesta("module")="ModPrice" then%><%=rs("ProId")%><%end if%>">
      </td>
      <td width="62%"> 
        <select name="select1" onChange="ChanggeValue()">
          <option value="">请选择</option>
          <option value="domcom">英文国际.com</option>
          <option value="domnet">英文国际.net</option>
          <option value="domorg">英文国际.org</option>
          <option value="domcn">英文国内.cn(所有以.cn结尾的域名)</option>
          <option value="domgovcn">英文国内.govcn</option>
        </select>
        <script>
function ChanggeValue()
{
	form1.ProId.value=form1.select1.value;
}
</script>
      </td>
    </tr>
    <tr> 
      <td align="right" height="29">执行价格</td>
      <td height="29"> 
        <input type="text" name="ProPrice" value="<%if requesta("module")="ModPrice" then%><%=rs("ProPrice")%><%end if%>">
      </td>
      <td height="29">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right">&nbsp;</td>
      <td> 
        <input type="submit" name="Submit" value="确定">
        <input type="hidden" name="module" value="AddPrice">
        <input type="hidden" name="PriceId" value="<%if requesta("module")="ModPrice" then%><%=rs("UserPriceid")%><%end if%>">
      </td>
      <td>&nbsp;</td>
    </tr>
  </form>
</table>
<%if requesta("module")="ModPrice" then
rs.close
end if%><br />
<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="efefef" class="border">
  <tr> 
    <td width="32%" align="center" class="Title"><strong>产品ProId</strong></td>
            <td width="24%" align="center" class="Title"><strong>此用户首年购买价格</strong></td>
            <td width="26%" align="center" nowrap class="Title"><strong>操作</strong></td>
  </tr>
          <%
u_id =Requesta("u_id")
sql="select * from UserPrice where u_id="&u_id
rs.open sql,conn,1,1
if not rs.eof then
do while not rs.eof
 %>
          <tr bgcolor="#FFFFFF"> 
            <td bgcolor="#FFFFFF" class="tdbg"><%=rs("ProId")%></td>
            <td bgcolor="#FFFFFF" class="tdbg"><%=rs("ProPrice")%></td>
            <td align="center" nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?u_id=<%=u_id%>&PriceId=<%=rs("UserPriceId")%>&module=ModPrice">编辑</a> 
              &nbsp;<a href="m_default.asp?u_id=<%=u_id%>&PriceId=<%=rs("UserPriceId")%>&module=DelPrice">删除</a></td>
          </tr>
          <%
rs.movenext
loop
else
%>
          <tr align="center" bgcolor="#FFFFFF"> 
            <td colspan="5">没有任何记录</td>
          </tr>
          <%
end if
%>
        </table>



<%
function GetProLevelPrice(UserLevel,ProductID)
	set LevelPriceRS=server.CreateObject("adodb.recordset")
	sql="SELECT p_price FROM pricelist WHERE (p_u_level = "&UserLevel&") AND (p_proid = '"&ProductID&"')"
	LevelPriceRS.open sql,conn,1,1
	if LevelPriceRS.eof then
		GetProLevelPrice="产品已经不存在"
	else
		GetProLevelPrice=LevelPriceRS(0)
	end if
	LevelPriceRS.close
end function
conn.close

Function IsBlank(Str)
	If Str="" or IsEmpty(Str) or isnull(Str) then
		IsBlank=True
	Else
		IsBlank=False
	End If
End Function

%><!--#include virtual="/config/bottom_superadmin.asp" -->
