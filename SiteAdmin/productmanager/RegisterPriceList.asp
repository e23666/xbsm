<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
conn.open constr

PN=Requesta("PN")
Sitem=Requesta("Sitem")
Svalue=Requesta("Svalue")

act=Requesta("act")
id=Requesta("id")

if act="del" and isNumeric(id) then
	conn.Execute("delete from RegisterDomainPrice where RegisterDomainPriceID=" & id)
end if
if act="alldellist" then
	conn.execute("delete from RegisterDomainPrice")
	Alert_Redirect "ɾ���ɹ�",request("script_name")
end if
if  act="alldel" Then
  	 delinfo=requesta("delinfo")
	
	 if len(delinfo)>0 then
	 	sql="delete from RegisterDomainPrice where RegisterDomainPriceID in("& delinfo &")"
		conn.execute sql
		
		Alert_Redirect "ɾ���ɹ�",request("script_name")
	 else
	 	Alert_Redirect "��ѡ����Ҫɾ������",request("script_name")
	 end if
end if
if act="mod" and isNumeric(id) then
	Qs="update RegisterDomainPrice set proid='" & requesta("proid") & "',user_name='" & requesta("uname") & "',UserLevel=" & iif(requesta("ulevel")<>"",requesta("ulevel"),"null") & ",newprice=" & requesta("newprice") & ",renewprice=" & requesta("renewprice") & ",needyear=" & requesta("years") & " where RegisterDomainPriceID=" & id
	conn.execute(Qs)
end if

Sql="select * from RegisterDomainPrice"
if Sitem<>"" and Svalue<>"" then
	if Sitem="proid" or Sitem="user_name" then
		Sql=Sql & " where " & Sitem & "='" & Svalue & "'"
	else
		Sql=Sql & " where " & Sitem & "=" & Svalue
	end if
end if
Sql=Sql & " order by proid,NeedYear"

if not isNumeric(PN) then PN=1
PN=Cint(PN)
if PN<1 then PN=1
Rs.open sql,conn,1,3

Rs.PageSize=20
if Rs.PageCount<PN then PN=Rs.PageCount
if not rs.eof then Rs.AbsolutePage=PN

PNtmp="<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?Sitem=" & Sitem & "&Svalue=" & Svalue & "&PN="
PStr="��" & Rs.PageCount & "ҳ,��" & PN & "ҳ��" & PNtmp & (PN-1) & ">��һҳ</a>��" & PNtmp & (PN+1) & ">��һҳ</a>��" & PNtmp & "1>��ҳ</a>��" & PNTmp & Rs.PageCount & ">βҳ</a>"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<script language="javascript">
function toedit(pid,proid,uname,ulevel,newprice,renewprice,years){
	form=document.form1;
	form.id.value=pid;
	form.proid.value=proid;
	form.uname.value=uname;
	form.ulevel.value=ulevel;
	form.newprice.value=newprice;
	form.renewprice.value=renewprice;
	form.years.value=years;
	document.getElementById("editbox").style.display="block";
}

function save(form){
	ckNumber=/^[\d\.]+$/;
	ckNull=/.+/;

	if (!ckNumber.test(form.newprice.value)) {alert('����۸����������');return;}
	if (!ckNumber.test(form.renewprice.value)) {alert('���Ѽ۸����������');return;}
	if (!ckNumber.test(form.years.value)) {alert('���ޱ���������');return;}

	if (!ckNull.test(form.proid.value)){alert('��ƷID����Ϊ��');return;}
	
	if (!/^\d*$/.test(form.ulevel.value)) {alert('�������������');return;}
	

	form.act.value='mod';
	form.submit();
}
function cancel(form){
	form.act.value='';
	form.id.value='';
	document.getElementById("editbox").style.display='none';
}

function del(id){
	if (confirm('��ȷ��ɾ��')){
		form=document.form1;
		form.act.value='del';
		form.id.value=id;
		form.submit();
	}
}

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
		if(confirm('ȷ��ɾ��ѡ�е�����?')){
			document.form2.action='<%=request("script_name")%>?act=alldel';
			document.form2.submit();
		}
	}else{
		alert('��ѡ����Ҫɾ������');
	}
}
function doalldel(){
	if(confirm('ȷ��ɾ�����еĶ��깺��۸���\nɾ���󽫲��ָܻ�')){
		location.href='<%=request("script_name")%>?act=alldellist';
	}
}

</script>
<style type="text/css">
<!--
.STYLE1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>���ⶨ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="RegisterPriceAdd.asp">�������ⶨ��</a> | <a href="../levelmanager/default.asp">�����������ⶨ��</a> 
      | <A href="RegisterPriceList.asp" target="main">��Ʒ���깺��۸�</A> | <A HREF="adjustPrice.asp" class="STYLE1">���������۸�</A></td>
  </tr>
</table>
<br>��ʾ��ʹ�øù��ܿ������ò�Ʒ���깺�����ѵ������Żݼ۸񡣻��������ĳһ���û�������������ļ۸�<br>
ע�⣺.cn����ע�����ļ۸��������ⶨ�ۣ����µ����޶�Ӧ�ļ۸񡣱���ע��5��۸�10������ۣ�+232(4���Żݼ�)=242Ԫ 
<form name="form1" method="post" action="<%=Request.ServerVariables("Script_name")%>">
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' colspan="7" align="center" >
      <select name="Sitem">
        <option value="proid" <%if Sitem="proid" then Response.Write("selected")%>>��Ʒid</option>
        <option value="user_name"  <%if Sitem="user_name" then Response.Write("selected")%>>�û���</option>
        <option value="UserLevel"  <%if Sitem="User_Level" then Response.Write("selected")%>>�û��ȼ�</option>
        <option value="NeedYear"  <%if Sitem="NeedYear" then Response.Write("selected")%>>����</option>
        <option value="NewPrice"  <%if Sitem="NewPrice" then Response.Write("selected")%>> ����۸�</option>
        <option value="RenewPrice"  <%if Sitem="RenewPrice" then Response.Write("selected")%>>���Ѽ۸�</option>
      </select>
      ����
      <input type="text" name="Svalue" value=<%=Svalue%>>
      <input type="submit" name="Submit" value="�� ��"> 
  	  <input type="hidden" name="act" value="">
	  <input type="hidden" name="id" value="">
      <input type="button" name="delbutton" value="ɾ�����м�¼" onClick="doalldel()">
	     </td>
  </tr>
</table><BR>
 <span id="editbox" style="display:none">
<table width="100%" border="0" align="center" cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td height='30' align="center" >��ƷID</td>
    <td align="center" >ָ���û�</td>
    <td align="center" >�û��ȼ�</td>
    <td align="center" >����</td>
    <td align="center" >����۸�</td>
    <td align="center" >���Ѽ۸�</td>
    <td align="center" >����</td>
  </tr>
  <tr class='tdbg'>
    <td height='30' align="center" ><input name="proid" type="text" size="10"></td>
    <td align="center" ><input name="uname" type="text" size="10"></td>
    <td align="center" ><input name="ulevel" type="text" size="10"></td>
    <td align="center" ><input name="years" type="text" size="10"></td>
    <td align="center" ><input name="newprice" type="text" size="10"></td>
    <td align="center" ><input name="renewprice" type="text" size="10"></td>
    <td align="center" ><input type="button" name="Submit2" value="����" onClick="save(this.form)">
      <input type="button" name="Submit3" value="����" onClick="cancel(this.form)">
	  </td>
  </tr>

</table>
 </span> 

</form>
<table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
<form name="form2" action="<%=request("script_name")%>" method="post" >
  <tr align="center"> 
    <td width="7%" align="left" nowrap class="Title"><input type="checkbox"  id="headerchk"  title="ȫѡ/ȫ��"  class="checkbox"  onclick="checkall(this)" />
      <a href="#" title="��ɾ�����ݿ���Ϣ" onClick="javascript:dodel()">[ѡ��ɾ��]</a>   <strong><font color="#FFFFFF">��Ʒid </font></strong></td>
    <td width="15%" class="Title"><strong><font color="#FFFFFF">��Ʒ����</font></strong></td>
    <td width="17%" class="Title"><strong><font color="#FFFFFF">ָ���û�</font></strong></td>
    <td width="21%" class="Title"><font color="#FFFFFF"><strong>�û��ȼ�</strong></font></td>
    <td width="9%" class="Title"><strong>����</strong></td>
    <td width="9%" class="Title"><strong>����۸�</strong></td>
    <td width="9%" class="Title"><strong>���Ѽ۸�</strong></td>
    <td width="13%" class="Title"><font color="#FFFFFF"><strong>����</strong></font></td>
  </tr>
<%
ii=1
do while not rs.eof and ii<=Rs.pageSize%>
  <tr> 
    <td align="left" class="tdbg"><input type="checkbox" value="<%=rs("RegisterDomainPriceID")%>" name="delinfo">&nbsp;<font color="#003366"><%=rs("ProId")%> </font></td>
    <td align="center" class="tdbg"><%=PPGetPName(rs("Proid"))%></td>
    <td align="center" class="tdbg"><%=rs("User_Name")%>&nbsp;</td>
    <td align="center" class="tdbg"><%=rs("UserLevel")%>&nbsp;</td>
    <td align="center" class="tdbg"><%=rs("NeedYear")%></td>
    <td align="center" class="tdbg"><%=Rs("NewPrice")%></td>
    <td align="center" class="tdbg"><%=Rs("RenewPrice")%></td>
    <td align="center" class="tdbg"><a href="#" onClick="toedit(<%=Rs("RegisterDomainPriceID")%>,'<%=Rs("proid")%>','<%=Rs("user_name")%>','<%=Rs("userLevel")%>','<%=Rs("newprice")%>','<%=Rs("renewprice")%>','<%=Rs("needYear")%>')">����</a>/<a href="javascript:del(<%=Rs("RegisterDomainPriceID")%>)">ɾ��</a></td>
  </tr>
  <%
  	ii=ii+1
	rs.MoveNext
	loop
	rs.close
	
%>
</form>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr> 
    <td align="center"> 
     <%=PStr%>
    </td>
  </tr>
</table>
<%
function PPGetPName(pid)
	set rs2=server.CreateObject("adodb.recordset")
	sql="select p_name from productlist where p_proid='"&pid&"'"
	rs2.open sql,conn,1,3
	if not rs2.eof then
		PPGetPName=rs2(0)
	end if
	rs2.close
end function

function iif(a,b,c)
	if a then 
		iif=b
	else
		iif=c
	end if
end function
%>
</body>
</html>
<!--#include virtual="/config/bottom_superadmin.asp" -->
