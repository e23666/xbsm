<%
response.Charset="gb2312"
response.Buffer=true
%>
<!--#include virtual="/manager/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
sqlstring="select * from productlist where p_id > 0 "
conn.open constr
if  Requesta("module")="del" Then
  	 delinfo=requesta("delinfo")
	
	 if len(delinfo)>0 then
	 	sql="delete from productlist where p_Id in("& delinfo &")"
		conn.execute sql
		
		Alert_Redirect "ɾ���ɹ�",request("script_name")&"?pageNo="& request("pageNo")
	 else
	 	url_return "��ѡ����Ҫɾ������",-1
	 end if
elseif Requesta("module")="searchPrice" then
	Proid=trim(requesta("Proid"))
	response.write GetNeedPrice("",Proid,1,"new")
	conn.close
	response.end
End If

searchtype=requesta("searchtype")

sqlArray=Array("p_name,��Ʒ����,str","p_proid,��ƷID,str","p_price,��Ʒ�۸�,int","p_costprice,�ɱ���,int","server_type_name,���������,str")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
condition=requesta("condition")
searchValue=requesta("searchValue")
searchItem=requesta("searchItem")

othercode="&searchtype="& searchtype&"&condition="&condition&"&searchValue="&searchValue&"&searchItem="&searchItem
newsql1=" and p_type="& searchtype
if trim(searchtype)="0" or trim(searchtype)&""="" then newsql1="":searchtype="0"

sqlstring="select a.*,b.server_type_name from (productlist a left join server_type b on (a.p_server=b.server_type_num)) where p_id>0 " & newsql & newsql1 & " order by p_server,p_proid asc"
response.Write(sql)
rs.open sqlstring,conn,1,1
    setsize=15
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #0650D2;
	font-weight: bold;
}
.STYLE5 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
<script type="text/javascript" language="javascript" src="/jscripts/ajaxClass.js"></script>
<script language="javascript" src="/jscripts/check.js"></script>
<script language="javascript">
function searchPrice(v,c1){
	if(v!=""){
		var ajaxurlstr="<%=requesta("script_name")%>?module=searchPrice" ;
		var info="Proid="+ v.Trim() ;
		var imgmsg="<img src=\"/images/mallload.gif\" border=\"0\" id=\"loadimg\" />"		
		ajaxRequest(ajaxurlstr,info,"post",c1,c1+"_1",Completion,imgmsg);
	}
}
function Completion(strValue,dividstr,divid1str){
	document.getElementById(dividstr).innerHTML=strValue;
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
			document.form2.action='<%=request("script_name")%>?module=del&pageNo=<%=request("pageNo")%>';
			document.form2.submit();
		}
	}else{
		alert('��ѡ����Ҫɾ������');
	}
}
function dosearch(v){
	document.form2.submit();
}
</script>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��Ʒ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="addPro.asp">������Ʒ</a>|<A HREF="syncPro.asp">ͬ����Ʒ��۸�</A> | <A HREF="adjustPrice.asp" class="STYLE5">���������۸�</A> | <A HREF="syndomain.asp" class="STYLE5">ͬ�������۸�</A></td>
  </tr>
</table>
<br>
</p> <form name="form2" action="<%=request("script_name")%>" method="post" >
<TABLE width="100%" border=0 align=center cellPadding=3 cellSpacing=1 class="border">

  <tr bgcolor="#FFFFFF">
    <td colspan =9 align="left" nowrap bgcolor="#FFFFFF">
	<%=searchlist%>
    <input type="radio" name="searchtype" value="0" onClick="dosearch(this.value)" <%if searchtype="0" then response.write "checked"%>>ȫ��&nbsp;
    <input type="radio" name="searchtype" value="1" onClick="dosearch(this.value)" <%if searchtype="1" then response.write "checked"%>>�ռ�&nbsp;
    <input type="radio" name="searchtype" value="2" onClick="dosearch(this.value)" <%if searchtype="2" then response.write "checked"%>>�ʾ�&nbsp;
    <input type="radio" name="searchtype" value="3" onClick="dosearch(this.value)" <%if searchtype="3" then response.write "checked"%>>����&nbsp;
    <input type="radio" name="searchtype" value="4" onClick="dosearch(this.value)" <%if searchtype="4" then response.write "checked"%>>��վ�ƹ�&nbsp;
    <input type="radio" name="searchtype" value="7" onClick="dosearch(this.value)" <%if searchtype="7" then response.write "checked"%>>���ݿ�
    <input type="radio" name="searchtype" value="9" onClick="dosearch(this.value)" <%if searchtype="9" then response.write "checked"%>>VPS
    <input type="radio" name="searchtype" value="11" onClick="dosearch(this.value)" <%if searchtype="11" then response.write "checked"%>>������
    <input type="radio" name="searchtype" value="12" onClick="dosearch(this.value)" <%if searchtype="12" then response.write "checked"%>>OEMVPS
    <input type="radio" name="searchtype" value="13" onClick="dosearch(this.value)" <%if searchtype="13" then response.write "checked"%>>OEM������ 
		<input type="radio" name="searchtype" value="15" onClick="dosearch(this.value)" <%if searchtype="15" then response.write "checked"%>>�ƽ�վ
		<input type="radio" name="searchtype" value="16" onClick="dosearch(this.value)" <%if searchtype="16" then response.write "checked"%>>SSL
		<input type="radio" name="searchtype" value="17" onClick="dosearch(this.value)" <%if searchtype="17" then response.write "checked"%>>΢��С����
    </td>
  </TR>
  <TR align=middle>
    <td align="left" class="Title"><input type="checkbox"  id="headerchk"  title="ȫѡ/ȫ��"  class="checkbox"  onclick="checkall(this)" />
      <a href="#" title="��ɾ�����ݿ���Ϣ" onClick="javascript:dodel()">[ѡ��ɾ��]</a>   <strong>��Ʒ����</strong></td>
    <td align="center" class="Title"><strong>��ƷID</strong></td>
    <td align="center" class="Title"><strong>��Ʒ����۸�</strong></td>
    <td align="center" class="Title"><strong>�ɱ���<input type="button" onClick="javascript:location.href='pricecompare.asp'" title="���»�ȡ�ɱ���" value="���»�ȡ"></strong></td>
    <td align="center" class="Title"><strong>��Ʒ��С</strong></td>
    <td align="center" class="Title"><strong>��Ʒ����</strong></td>
    <td align="center" class="Title"><strong>���������</strong></td>
    <td align="center" class="Title"><strong>����</strong></td>
  </TR>
  <%
	do while not rs.eof and cur<=setsize
		tdcolor="#ffffff"
		p_type=rs("p_type")
		if cur mod 2=0 then tdcolor="#EAF5FC"
  %>
                            
  <TR align=middle bgcolor="<%=tdcolor%>">
    <td align="left" ><input type="checkbox" value="<%=rs("p_Id")%>" name="delinfo">
    <%if instr(",9,11,12,13,",","&p_type&",")>0 then%>
    <a href="vpsprice.asp?p_proid=<%=rs("p_proid")%>"><font color="#0000FF"><%= rs("p_name") %></font></a>
    <%else%>
    <a href="detail.asp?p_id=<%=rs("p_id")%>"><font color="#0000FF"><%= rs("p_name") %></font></a>
    <%end if%>
    </td>
    <td ><%= rs("p_proid") %></td>
    <td >
    <%=GetNeedPrice("",rs("p_proid"),1,"new")%>
    </td>
    <td ><%
	if check_as_master(1) then
	costPrice=rs("p_costprice")
	else
	costPrice=0
	end if
	if len(costPrice)=0 or costPrice&""="0" then costPrice="δ֪"
	response.write costPrice
	%></td>
    <td ><%= rs("p_size") %> </td>
    <td ><%= rs("p_maxmen") %></td>
    <td ><%=rs("server_type_name") %></td>
    <td ><a href="delproduct.asp?proid=<%=rs("p_proid")%>">ɾ��</a></td>
  </tr>
  <%
		cur=cur+1
		rs.movenext
	Loop
	rs.close
	
	%>
  <tr bgcolor="#FFFFFF">
    <td colspan =9 align="center" nowrap bgcolor="#FFFFFF"><%=pagenumlist%></td>
  </TR>


</table>  </form>
<br>
<%
conn.close
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
