<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)
act=trim(requesta("act"))
set p=new Proclass
p.promsg

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
	color: #333333;
	font-weight: bold;
}
.inputbox {
	font-family: "Arial", "Helvetica", "sans-serif";
	font-size: 12px;
	color: #333366;
	text-decoration: none;
	height: 18px;
	background:#FFFFFF;
	border-top: 1px solid #545454;
	border-right: 1px solid #545454;
	border-bottom: 1px solid #969696;
	border-left: 1px solid #969696;
}
.STYLE5 {
	color: #666666;
	font-size: 10pt;
}
-->
</style>
<script language="javascript">
function dosub(cur){
	if(checkinput(cur)==true){
		if(confirm("�޸ĺ󽫲��ܻ�ԭ.\nȷ���޸���?")){
		document.form1.act.value="sub";
		return true;
		}else{
		return false;
		}
	}else{
		return false;
	}
}
function checkinput(cur){
	var iserrlist=true;
	for(var j=1;j<cur;j++){
		for(var i=0;i<=10;i++){
			var buyObj=eval("document.form1.buyProPrice_" + i + "_" + j);
			var renewObj=eval("document.form1.renewProPrice_"+ i + "_" + j);
			var wrenewObj=eval("document.form1.wrenewProPrice_"+ i + "_" + j);
			var p_proid="<%=p.p_proId%>";
				var reg=/^[\d]{0,10}$/;
				if(!reg.test(buyObj.value)){
					dotoinput(buyObj,"err");
					iserrlist=false;
				}else{
					if(i==1 && p_proid!="dns001"){
						if(buyObj.value!=""){
							if(buyObj.value<=0){
								dotoinput(buyObj,"err");
								iserrlist=false;
							}
						}else{
								dotoinput(buyObj,"err");
								iserrlist=false;
						}
					}
				}
				var reg1=/^[\d]{0,10}$/;
				if(!reg1.test(renewObj.value)){
					dotoinput(renewObj,"err");
					iserrlist=false;
				}
				if (typeof(wrenewObj) != "undefined") { 
					if(!reg1.test(wrenewObj.value)){
						dotoinput(wrenewObj,"err");
						iserrlist=false;
					}
				}
		}
	}
	if(iserrlist==false){
		alert("��Ǹ������ӦΪ���ա�����������,1�깺��۸��������");
		return false;
	}
	return true;
}
function dotoinput(obj,types){
	if(types=="err"){
		obj.style.background="#FFCCCC";
		
	}else{
		obj.style.background="#ffffff";
	}
}
function mover(cur){
	document.getElementById("buytr"+cur).style.background="#ffffcc";
	document.getElementById("renewtr"+cur).style.background="#ffffcc";
	document.getElementById("wrenewtr"+cur).style.background="#ffffcc";
}
function mout(cur,trbgcolor){
	document.getElementById("buytr"+cur).style.background=trbgcolor;
	document.getElementById("renewtr"+cur).style.background=trbgcolor;
	document.getElementById("wrenewtr"+cur).style.background=trbgcolor;
}
</script>
<%

if act="sub" then
	proid=p.p_proId
	for i = 1 to Request.form.count
		formkey=trim(lcase(Request.form.key(i)))
		if instr(formkey,"proprice_")>0 then
			keyArr=split(formkey,"_")
			if ubound(keyArr)=2 then
				dotypelist=trim(keyArr(0))
				dotype="new"
				'if instr(dotypelist,"renew")>0 then dotype="renew"
				if "wrenewproprice"=dotypelist then dotype="wrenew"
				if "renewproprice"=dotypelist then dotype="renew"
				price=trim(Requesta(formkey))
				if price="" then price=0
				yearindex=keyArr(1)'��
				levelindex=keyArr(2)'���	
				call p.insertAccess(proid,price,levelindex,yearindex,dotype)				
			end if
		end if
	next
	'response.end
	Alert_Redirect "�۸���³ɹ�",request.ServerVariables("script_name") & "?p_id="& p.p_id
end if



%>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="addPro.asp">������Ʒ</a> | <a href="default.asp?module=search&searchtype=1">�ռ�</a> | <a href="default.asp?module=search&searchtype=2">�ʾ�</a> | <a href="default.asp?module=search&searchtype=3">����</a> | <a href="default.asp?module=search&searchtype=7"> ���ݿ�</a> |<A HREF="adjustPrice.asp">���������۸�</A></td></td>
  </tr>
</table>
<br>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" bordercolordark="#ffffff" bgcolor="#F0F0F0" class="border">
  <tr bgcolor="#FFFFFF">
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >����Ʒ����:</td>
    <td height="30" ><%=p.p_name%>&nbsp;<a href="editPro.asp?p_id=<%=p.p_id%>"><font color="#0000FF">����ϸ�޸ġ�</font></a></td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >����Ʒ���:</td>
    <td height="30" bgcolor="#FFFFFF" ><span class="STYLE4"><%=p.p_proId%></span></td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >����Ʒ��С:</td>
    <td height="30" ><%=p.p_size%>M</td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >����Ʒ����:</td>
    <td height="30" ><%=p.p_typeName%> </td>
  </tr>
  <tr bgcolor="#FFFFFF">
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >����ƷȨ��:</td>
    <td height="30" ><%=p.p_appidName%></td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >������û�:</td>
    <td height="30" ><%=p.p_maxmen%></td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >��ÿ������:</td>
    <td height="30" bgcolor="#FFFFFF" ><%=p.p_traffic%>G</td>
    <td height="30" align="right" nowrap bgcolor="#EAF5FC" >���ҵĳɱ���:</td>
    <td height="30" ><%
	if check_as_master(1) then
	%>
    <%=p.p_costPrice%> <a href="<%=SystemAdminPath%>/productmanager/pricecompare.asp?prodid=<%=p.p_proId%>"><font color="#0000FF">�����»�ȡ��</font></a>
    <%
	else
	response.Write("-")	
    end if%>
    </td>
  </tr>
</table>
<%
call p.pricelist
set p=nothing
Class Proclass
	public p_id
	public p_name,p_proId,p_size,p_typeName,p_appidName,p_maxmen,p_traffic,p_costPrice
	Private Sub Class_Initialize
		conn.open constr
	end sub
	Private Sub Class_Terminate
		if rs.state=1 then rs.close
		if conn.state=1 then conn.close
    End Sub
	public function promsg()
		p_id=trim(Requesta("p_id")&"")
		if p_id="" then conn.close:url_return "��������",-1
		sql="select * from productlist where p_id=" & p_id
		rs.open sql,conn,1,1
		if rs.eof then rs.close:conn.close:url_return "û�д˲�Ʒ",-1
		 p_name=rs("p_name")
		 p_proid=rs("p_proid")
		 p_size=rs("p_size")
		 p_typeName=gettypeName(rs("p_type"))
		 p_appidName=getappidName(rs("p_appid"))
		 p_maxmen=rs("p_maxmen")
		 p_traffic=rs("p_traffic")
		 p_costPrice=rs("p_costPrice")
		 rs.close
	end function
	''''''''''''''''''''''''''''''''''''''''
	private function getappidName(byval p_appid)
		select case p_appid
			case "111"
				getappidName="asp,php,cgi"
			case "110"
				getappidName="asp.net"
			case "1"
				 getappidName="asp"
			case "11"
				 getappidName="asp,cgi"
			case "10"
				getappidName="cgi"
			case "100"
				getappidName="php"
			case "0"
				getappidName="��html"
			case else
				getappidName="����"
		end select
	end function
	public function instrfirstprice(byval updatefildName,byval price,byval u_level,byval proid,byval buyyear)
		if trim(buyyear&"")="" then buyyear=0
		buyyear=int(buyyear)
		if buyyear=0 then
				sql="select top 1 * from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"				
				rs.open sql,conn,1,3
				if rs.eof and rs.bof then 
					rs.addnew()
					rs("p_u_level")=u_level
					rs("p_proid")=proid
				end if
				rs(updatefildName)=ccur(price)
				rs.update()
				rs.close
		elseif buyyear=1 then			
				sql="select top 1 * from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
				rs.open sql,conn,1,3
				if rs.eof and rs.bof then
					rs.addnew()
					rs("p_u_level")=u_level
					rs("p_proid")=proid
				end if
				rs(updatefildName)=price
				rs.update()
				rs.close
		else
				sql="select top 1 * from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& proid &"'"
				rs.open sql,conn,1,3
				if rs.eof and rs.bof then
					rs.addnew()
					rs("UserLevel")=u_level
					rs("needYear")=buyyear
					rs("proid")=proid
				end if
				rs(updatefildName)=price
				rs.update
				rs.close
		end if
		'response.write updatefildName & "|" & price & "|" & buyyear & "|" & sql & "<br>"
	end function
	public function insertAccess(byval proid,byval price,byval u_level,buyyear,byval dotype)
		if trim(buyyear&"")="" then buyyear=0
		buyyear=int(buyyear)
		select case dotype
		case "new"
				if buyyear=0 then
					updatefildName="p_firstPrice"
				elseif buyyear=1 then
					updatefildName="p_price"
				else
					updatefildName="newPrice"
				end if
		case "renew"
				if buyyear=0 then
					updatefildName="p_firstPrice_renew"
				elseif buyyear=1 then
					updatefildName="p_price_renew"
				else
					updatefildName="RenewPrice"
				end if
		case "wrenew"
				if buyyear=0 then
					updatefildName="p_wfirstPrice_renew"
				elseif buyyear=1 then
					updatefildName="p_wprice_renew"
				else
					updatefildName="wRenewPrice"
				end if
		end select
		call instrfirstprice(updatefildName,price,u_level,proid,buyyear)
	end function
	private function gettypeName(byval p_type)
		gettypeName=""
		if not isnumeric(p_type) then exit function
		select case p_type
			case 1
				gettypeName="�ռ�"
			case 2
				gettypeName="�ʾ�"
			case 3
				gettypeName="����"
			case else
				gettypeName="δ֪"
		end select
	end function
	public function getProlevelPrice(byval proid,byval u_level,byval buyyear)
		if buyyear<0 then buyyear=0
		select case  buyyear
		case 0
			If isdbsql Then
				sql="select top 1 isnull(p_firstPrice,0),isnull(p_firstPrice_renew,0),isnull(p_wfirstPrice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
			else
				sql="select top 1 iif(isnull(p_firstPrice),0,p_firstPrice),iif(isnull(p_firstPrice_renew),0,p_firstPrice_renew),iif(isnull(p_wfirstPrice_renew),0,p_wfirstPrice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
			End if
		case 1
		    If isdbsql Then
				sql="select top 1 isnull(p_price,0),isnull(p_price_renew,0),isnull(p_wprice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
			else
				sql="select top 1 iif(isnull(p_price),0,p_price),iif(isnull(p_price_renew),0,p_price_renew),iif(isnull(p_wprice_renew),0,p_wprice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
			End if
		case Else
			If isdbsql Then
				sql="select top 1 isnull(newPrice,0),isnull(RenewPrice,0),isnull(wRenewPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'"
			else
				sql="select top 1 iif(isnull(newPrice),0,newPrice),iif(isnull(RenewPrice),0,RenewPrice),iif(isnull(wRenewPrice),0,wRenewPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'"
			End if
		end select
		set prs=conn.execute(sql)
		if not prs.eof then
			getProlevelPrice=prs(0) &"|"& prs(1)&"|"& prs(2)
		else
			getProlevelPrice=""
		end if
		prs.close
		set prs=nothing
	end function
	public sub pricelist()
	%>
<fieldset align="center" style="font-size:9pt; width:100%">
<legend class="STYLE17 STYLE5"><strong>���øò�Ʒ�ļ۸�</strong></legend>
<table border="0" width="95%" align="center" cellpadding="1" cellspacing="1" bordercolordark="#ffffff" bgcolor="#F0F0F0" class="border">
  <form name="form1" action="<%=request.ServerVariables("script_name")%>" method="post">
  <tr align="center" class="Title">
    <td><strong>������</strong></td>
    <td><strong>����</strong></td>
    <td><strong>�����ؼ�</strong></td>
    <%for i=1 to 10%>
    <td><strong><%=i%>��</strong></td>
    <%next%>
  </tr>
  <%
    sql="select * from levellist order by l_level asc"
	rs.open sql,conn,1,1
	cur=1
	do while not rs.eof
		bgcolor="#ffffff"
		if cur mod 2 =0 then bgcolor="#EAF5FC"
		l_level=rs("l_level")
		redim buyArr(10)
		redim renewArr(10)
		redim wrenewArr(10)
		for i=0 to 10
			buyprice=0
			renewPrice=0
			wrenewPrice=0
			buyrenewprice=getProlevelPrice(p_proid,l_level,i)
			if buyrenewprice<>"" then
				priceArr=split(buyrenewprice,"|")
				if ubound(priceArr)>0 then
					buyprice=priceArr(0)
					renewPrice=priceArr(1)
					wrenewPrice=priceArr(2)
				end if
			end if
			'if renewPrice=0 and i>0 then renewPrice=buyPrice
			if p_proId="dns001" and i=1 then
				if buyprice="" then buyprice=0
			else
				if buyprice=0 then buyprice=""
			end if
			if renewprice=0 then renewPrice=""
			if wrenewPrice=0 then wrenewPrice=""
			buyArr(i)=buyPrice
			renewArr(i)=renewPrice
			wrenewArr(i)=wrenewPrice
			'if i=1 and renewArr(0)=0 then renewArr(0)=renewPrice
		next
		rowspan=2
		 if p_typeName="����" then rowspan=3
	%>
  <tr bgcolor="<%=bgcolor%>" id="buytr<%=cur%>" onMouseOver="mover(<%=cur%>)" onMouseOut="mout(<%=cur%>,'<%=bgcolor%>')" align="center">
    <td rowspan="<%=rowspan%>" align="right"><strong><%=rs("l_name")%></strong></td>
    <td>����:</td>
    <%for i=0 to 10%>
    <td><input name="buyProPrice_<%=i%>_<%=cur%>" type="text" class="inputbox" size="2" maxlength="10" value="<%=buyArr(i)%>" onFocus="dotoinput(this,'ok')"></td>
    <%next%>
  </tr>
  <tr bgcolor="<%=bgcolor%>" id="renewtr<%=cur%>" onMouseOver="mover(<%=cur%>)" onMouseOut="mout(<%=cur%>,'<%=bgcolor%>')">
    <td align="center">����:</td>
    <%for i=0 to 10%>
    <td align="center"><input name="renewProPrice_<%=i%>_<%=cur%>" type="text" class="inputbox" size="2" value="<%=renewArr(i)%>" onFocus="dotoinput(this,'ok')"></td>
    <%next%>
  </tr>
  <%
	  if p_typeName="����" then
	  %>
      <tr bgcolor="<%=bgcolor%>" id="wrenewtr<%=cur%>" onMouseOver="mover(<%=cur%>)" onMouseOut="mout(<%=cur%>,'<%=bgcolor%>')">
        <td align="center">��������<img style="width:10px" src="/images/1341453609_help.gif" title="��������˸���������ע�������������룬�����ü۸�����">:</td>
        <%for i=0 to 10%>
        <td align="center"><input name="wrenewProPrice_<%=i%>_<%=cur%>" type="text" class="inputbox" size="2" value="<%=wrenewArr(i)%>" onFocus="dotoinput(this,'ok')"></td>
        <%next%>
      </tr>
      <%
	  end if
	  %>
  <tr>
    <td colspan=20 background="/manager/images/style/bg_dot.gif" height="1"></td>
  </tr>
  <%	Erase buyArr
  		Erase renewArr
	 	cur=cur+1
	rs.movenext
	loop
	rs.close
    %>
   <tr>
   <td colspan="20" align="center">
   <input type="submit" name="addbutton" value="  �� ��  " onClick="return dosub(<%=cur%>)">
   &nbsp;&nbsp;
   <input type="reset" name="resetbutton" value="  �� ��  ">
   <input type="hidden" name="act">
   <input type="hidden" name="p_id" value="<%=p_id%>">
   </td>
   </tr>
   <tr><td colspan="20" bgcolor="#FFFFFF">
  <ul>
  <li>���������"�����ؼ�",�۸񽫰�"N��۸�"����</li>
  <li>���������"N��۸�",�۸񽫰�"1��"�۸������/����"����"����</li>
  <li>���������"�����ؼ�",�۸񽫰�"�����ؼ�"������/����*("����"��1)����</li>
  <li>����˲�Ʒ��"<a href="/SiteAdmin/levelmanager/default.asp">�û��ؼ�</a>",�۸񽫰�"�û��ؼ�"������/����*("����"��1)����</li>
  <li>����˲�Ʒû������"���Ѽ۸�",�۸񽫰�"1��"����۸������"����"����</li>
  
  </ul>
  </td></tr>
   </form>
</table>
</fieldset>
<%	 
	end sub
end Class

%>
