<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<!--#include virtual="/config/parsecommand.asp" --> 
<!--#include virtual="/config/Template.inc.asp" --> 
<!--#include virtual="/config/action.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-�޸�������������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link href="<%=managercss1%>" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=managercss2%>" type="text/css" /></HEAD>
<%
d_id=requesta("id")
if not isnumeric(d_id) or d_id="" then url_return "������ʧ",-1
conn.open constr
act=requesta("act")
if act="del" then
	sql="delete from Prehost where OrderNo='" & d_id & "' and u_name='"& session("user_name") &"'"
	conn.execute sql
	conn.close
		alert_redirect "ɾ���ɹ�","default.asp"
elseif act="mod2" then
	newbuyyears=trim(requesta("newbuyyears"))
	sql="update Prehost set years=" & newbuyyears & " where u_name='"& session("user_name") &"' and OrderNo='"& d_id & "'"
	conn.execute sql
	conn.close
	alert_redirect "�����޸ĳɹ�",request("script_name")&"?id=" & d_id
elseif act="add" then
	returnstr=putOrderlist("vhost",d_id,session("user_name"))
	
	if left(returnstr,3)="200" then
		Sql="Update Prehost Set Opened="&PE_True&" Where orderNo='" & d_id & "'"
        conn.Execute(Sql)
			alterstr="����������ͨ�����ɹ���<br>" & _
					"���ڿɽ��� ��������-ҵ�����-�������� �Դ����������������"
					
										 
				echoString alterstr,"r"
	else
				echoString "����������ͨ����ʧ�� "& returnstr ,"e"
	end if
end if

sql="select * from Prehost where orderNo='" & d_id & "' and u_Name='"& session("user_name") &"'"
rs11.open sql,conn,1,1
if rs11.eof then url_return "û���ҵ��˶���",-1
orderID=100000 + d_id

		 s_comment=rs11("ftpaccount")
		 regDate=rs11("sdate")
		 years=rs11("years")
		 price=rs11("price")
		 proID=rs11("proid")
		 allprice=GetNeedPrice(session("user_name"),proID,years,"new")
%>
<script language=javascript>
function modifyyears(v,id){
	var f=document.form1;
	f.action=v + "?act=mod2&id=" + id;
	f.submit();

}
function dosub(f){
	if(confirm('ȷ���˲�����?')){
		document.getElementById('loadspan').style.display='';
		f.C1.disabled=true;
		f.submit();
		return true;
	}
	return false;
}		
</script>

<body id="thrColEls">

<div class="Style2009"> 
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV"> 
    <!--#include virtual="/manager/manageleft.asp" -->
    <div id="MainRight">
      <div class="new_right"> 
        <!--#include virtual="/manager/pulictop.asp" -->
        
        <div class="main_table">
          <div class="tab">�޸�������������</div>
          <div class="table_out">
          <table width="100%" border="0" align="center" cellpadding="5" cellspacing="1" class="border">
  <form name="form1" method="post" action="<%=request("script_name")%>?act=add&id=<%=d_id%>" >
    <tr class="tdbg">
      <td width="29%" align="right" nowrap="nowrap">������:</td>
      <td width="44%" class="tdbg"><%=orderID%></td>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">��Ʒ��:</td>
      <td class="tdbg"><%=s_comment%></td>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">�µ�����:</td>
      <td class="tdbg"><%=regDate%></td>
    </tr>
    <tr>
      <td align="right" nowrap="nowrap" class="tdbg">��������:</td>
      <%if act="mod" then%>
      <td class="tdbg"><%Pricestring=getpricelist(session("user_name"),proID)
  	priceArray=split(Pricestring,"|")
  %>
          <select name="newbuyyears">
            <%for jj=0 to 9
		selectedstr=""
		if years=(jj+1) then selectedstr=" selected "
	%>
            <option value="<%=jj+1%>" <%=selectedstr%>><%=priceArray(jj)%>��/<%=(jj+1)%>��</option>
            <%next%>
          </select>
          <span class="STYLE4"><a href=# onClick="javascript:modifyyears('<%=request("script_name")%>',<%=d_id%>);">[ȷ���޸�]</a> <a href="<%=request("script_name")%>?id=<%=d_id%>">[ȡ���޸�]</a></span> </td>
      <%else%>
      <td class="tdbg"><strong><%=years%>��&nbsp;</strong> <a href="<%=request("script_name")%>?act=mod&id=<%=d_id%>" class="tdbg">[�޸�����]</a></td>
      <%end if%>
    </tr>
    <tr class="tdbg">
      <td align="right" nowrap="nowrap">�ܼ۸�:</td>
      <td class="tdbg"><%=allprice%></td>
    </tr>
    <tr class="tdbg">
      <td colspan=2 align="center">
      	 <span id="loadspan" style="display:none"><img src="../../images/load.gif" border=0><br>����ִ��,���Ժ�..<br></span>
      	  <input type="button" name="C1" value="����ע��" onClick="return dosub(this.form)">
          <input type="button" onClick="javascript:if(confirm('ȷ��ɾ����?')){location.href='<%=request("script_name")%>?act=del&id=<%=d_id%>'}" value="ɾ������">
      </td>
    </tr>
  </form>
</table>
          </div>
        </div>
      </div>
    </div>
  </div>
 <!--#include virtual="/manager/bottom.asp" -->
</div>





</body>
</html>
