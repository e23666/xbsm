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
		response.Write("<script>alert(""��Ʒid����"");history.back()</script>")
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
	if not isDate(requesta("FirstTime")) then url_return "���ڸ�ʽ����",-1
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
    <td height='30' align="center" ><strong>�����̼������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table><br>
<table width="100%" border="0" align="center" cellPadding="3" cellSpacing="0" class="border">
  <tbody> 
  <tr> 
    <td colspan="3" class="Title"><strong>���������</strong></td>
  </tr>
  <tr> 
    <td class="tdbg">��</td>
    <td align="right" class="tdbg">����</td>
    <td class="tdbg"><%= rs("u_level") %> 
      <%thisUserLevel=rs("u_level")%>
    </td>
  </tr>
  <tr> 
    <td class="tdbg">��</td>
    <td align="right" class="tdbg">�û�����</td>
    <td class="tdbg"><%= rs("u_name") %></td>
  </tr>
  <tr> 
    <td class="tdbg">��</td>
    <td align="right" class="tdbg">�����ܶ</td>
    <td class="tdbg"><%= rs("u_resumesum") %></td>
  </tr>
  <tr> 
    <td class="tdbg">��</td>
    <td align="right" class="tdbg">���ö</td>
    <td class="tdbg"><%= rs("u_usemoney")%></td>
  </tr>
  <tr> 
    <td class="tdbg">��</td>
    <td align="right" class="tdbg">���ƣ�</td>
    <td class="tdbg"><%= rs("u_levelname")%></td>
  </tr>
  <FORM name="DateForm" action="M_default.asp?u_id=<%=u_id%>" method=post onSubmit="return check(this)">
    <tr> 
      <td colspan="2" align="right" class="tdbg">��һ�γ�Ϊ����ʱ�䣺</td>
      <td class="tdbg"> 
        <input type="text" name="FirstTime" value="<%= rs("FirstLevelTime")%>">
        <a href="javascript:" onClick="selectTime('DateForm.FirstTime',5)">ѡ��</a> 
        <input type="submit" name="Submit2" value="ȷ��">
        <input name="module" type="hidden" value="chgftime">
      </td>
    </tr>
  </form>
  <tr> 
    <td colspan="2" align="right" class="tdbg">����޸Ĵ���ʱ�䣺</td>
    <td class="tdbg"><%= rs("LastLevelTime")%></td>
  </tr>
  <tr> 
    <td class="tdbg"></td>
    <td colSpan="2" align="middle" class="tdbg"></td>
  </tr>
  <FORM action="M_default.asp?u_id=<%=u_id%>" method=post onSubmit="return check(this)">
    <tr> 
      <td class="tdbg">��</td>
      <td align="right" class="tdbg">�ı伶��</td>
      <td class="tdbg"> 
        <select name="u_level">
          <option>--- ��ѡ���¼��� ---</option>
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
        <input name="sub" type="submit" value="ȷ��">
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
		return confirm("��ȷ�Ͻ�VCP�û�"+form.MESS.value+"��չ�����û�<%=rs("u_name")%>����Ϊ�����̣�");
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
    <td colspan="3" class="Title"><strong>�Զ�������۸�</strong></td>
  </tr>
  <tr> 
    <td colspan="3"> 
      <div align="left">������Զ���������һ�깺�������۸񡣱���.Cn����������������Ϊ��һ�깺��Ϊ1Ԫ���ڶ��껹�ǰ������50Ԫ��</div>
    </td>
  </tr>
  <form name="form1" method="post" action="m_default.asp?u_id=<%=u_id%>">
    <tr> 
      <td width="15%" align="right">��ƷProid</td>
      <td width="23%"> 
        <input type="text" name="ProId" value="<%if requesta("module")="ModPrice" then%><%=rs("ProId")%><%end if%>">
      </td>
      <td width="62%"> 
        <select name="select1" onChange="ChanggeValue()">
          <option value="">��ѡ��</option>
          <option value="domcom">Ӣ�Ĺ���.com</option>
          <option value="domnet">Ӣ�Ĺ���.net</option>
          <option value="domorg">Ӣ�Ĺ���.org</option>
          <option value="domcn">Ӣ�Ĺ���.cn(������.cn��β������)</option>
          <option value="domgovcn">Ӣ�Ĺ���.govcn</option>
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
      <td align="right" height="29">ִ�м۸�</td>
      <td height="29"> 
        <input type="text" name="ProPrice" value="<%if requesta("module")="ModPrice" then%><%=rs("ProPrice")%><%end if%>">
      </td>
      <td height="29">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right">&nbsp;</td>
      <td> 
        <input type="submit" name="Submit" value="ȷ��">
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
    <td width="32%" align="center" class="Title"><strong>��ƷProId</strong></td>
            <td width="24%" align="center" class="Title"><strong>���û����깺��۸�</strong></td>
            <td width="26%" align="center" nowrap class="Title"><strong>����</strong></td>
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
            <td align="center" nowrap bgcolor="#FFFFFF" class="tdbg"><a href="m_default.asp?u_id=<%=u_id%>&PriceId=<%=rs("UserPriceId")%>&module=ModPrice">�༭</a> 
              &nbsp;<a href="m_default.asp?u_id=<%=u_id%>&PriceId=<%=rs("UserPriceId")%>&module=DelPrice">ɾ��</a></td>
          </tr>
          <%
rs.movenext
loop
else
%>
          <tr align="center" bgcolor="#FFFFFF"> 
            <td colspan="5">û���κμ�¼</td>
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
		GetProLevelPrice="��Ʒ�Ѿ�������"
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
