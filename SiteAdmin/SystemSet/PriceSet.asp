<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/manager/config/config.asp" -->
<%

Check_Is_Master(1)
server.scriptTimeout=9999
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE5 {
	color: #CCFFCC
}
INPUT {
	FONT-SIZE: 12px;height=10px;
}
.STYLE10 {color: #FF0000}
.STYLE12 {color: #0066CC}
.STYLE13 {
	color: #009933;
	font-weight: bold;
}
.STYLE14 {
	color: #999999;
	font-weight: bold;
}
.STYLE16 {color: #666666; font-size: 14px; }
.STYLE17 {color: #666666; font-size: 14px; font-weight: bold; }
.STYLE18 {color: #333333}
-->
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�۸�����</title>
</head>
<%
act=trim(requesta("act"))
xmlpath=server.MapPath("/database/data.xml")
conn.open constr
select case lcase(act)
case "add"
	addproid=requestf("addproid")
	addprice=requestf("addprice")
	addlevel=requestf("addlevel")
	if addproid<>"" and addprice<>"" then
		if not isproid(addproid) then url_return "��Ǹ,û���ҵ������õĲ�Ʒ�ͺ�",-1
		if isnumeric(addlevel) and isnumeric(addprice) and addPrice>0 then
		
			sqlo="select * from Pricelevellist where p_level=" & addlevel & " and p_proid='"& addproid &"'"
			rs1.open sqlo,conn,1,3
			if not rs1.eof then
				rs1("p_price")=addprice
				rs1.update()
			else
				rs1.addnew()
				rs1("p_level")=addlevel
				rs1("p_proid")=addproid
				rs1("p_price")=addprice
				rs1.update()
			end if
			rs1.close
			call addmsg(addlevel,addproid,addprice)
			conn.close
			alert_redirect "��ӳɹ�",request("script_name")
		end if
	end if
case "del"
	delitem=requestf("delitem")
	if delitem<>"" then
		for each delitem in split(delitem,",")
			if isnumeric(delitem) then
				sql="select * from Pricelevellist where p_id=" & delitem
				rs.open sql,conn,1,1
				if not rs.eof then
					p_proid=trim(rs("p_proid"))
					p_level=trim(rs("p_level"))
					
					if p_proid<>"" and isnumeric(p_level) then
						sqls="select * from (userPrice a inner join userdetail b on (a.u_id=b.u_id and b.u_level="& p_level &")) where Proid='" & p_proid & "'"
						rs11.open sqls,conn,1,1
						if not rs11.eof then
							do while not rs11.eof
								upid=rs11("userpriceid")
								conn.execute "delete from userPrice where userpriceid="& upid
								rs11.movenext
							loop
						end if
						rs11.close
					end if
				end if
				rs.close
				conn.execute "delete from Pricelevellist where p_id="& delitem
			end if
		next
		conn.close
		alert_redirect "ɾ���ɹ�",request("script_name") & "?PageNo="& request("pageNo")
	end if
case "mod"
	id=trim(requesta("id"))
	proprice=requesta("p_price"& id)
	if isnumeric(id) and isnumeric(proprice) and proprice>0 then
		sql="select * from Pricelevellist where p_id=" & id
		rs.open sql,conn,1,3
		if not rs.eof then
			p_proid=trim(rs("p_proid"))
			p_level=trim(rs("p_level"))
			rs("p_price")=proprice
			rs.update()
			call addmsg(p_level,p_proid,proprice)
			
		end if
		rs.close
		conn.close
		alert_redirect "�޸ĳɹ�",request("script_name") & "?PageNo="& request("pageNo")
	end if
case "renewcnprice"
		startdateobj=requesta("startDate")
		enddateobj  =requesta("endDate")
		exitdateobj =requesta("exitDate")
		setpriceobj =requesta("setPrice")
		isopen		=requesta("isopen")
		cnrenewlevel=requesta("cnrenewlevel")
		if startdateobj="" or enddateobj="" or exitdateobj="" or setpriceobj="" then url_return "��Ǹ,��������",-1
		call addcnPrice(startdateobj,enddateobj,exitdateobj,setpriceobj,cnrenewlevel,isopen)
		alert_redirect "���óɹ�",request("script_name")
end select

call readcnPrice(startDate,endDate,exitDate,setPrice,cnrenewlevel,isopen)
if isopen="" then isopen="0"
if startDate="" then startDate="2007-3-7"
if endDate="" then endDate="2009-2-28"
if exitDate="" then exitDate="2009-2-28"
if setPrice="" then setPrice="18"

sqlArray=Array("l_name,�û�����,str","p_proid,��Ʒ����,str","p_price,�����ؼ�,int")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="select a.*,b.l_name from Pricelevellist a inner join levellist b on a.p_level=b.l_level where 1=1 "& newsql &" order by a.p_date desc"

rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

levelsql="select * from levellist order by l_level asc"
rs11.open levelsql,conn,1,1
if rs11.eof then url_return "û���ҵ���ص��û�����",-1
%>
<script language=javascript>
function dosub(v){
	if(!isNaN(v)){
		document.form1.action +='?act=edlevel&l_level=' + v;
		document.form1.submit();
		return true;
	}
}
function doadd(){
	var addproid=document.form1.addproid;
	var addprice=document.form1.addprice;
	if(addproid.value==''){
		alert('��Ʒ���Ͳ������');
		addproid.focus();
		return false;
	}
	if(isNaN(addprice.value) || addprice.value<=0){
		alert('�۸�ӦΪ�����Ҵ���0');
		addprice.focus();
		return false;
	}
	
	if(confirm('��Ӻ�,�������д˼�����û�����ؼ�,ȷ�������?'))
	
	document.form1.action +='?act=add';
	document.form1.submit();
	document.getElementById('loadimg').style.display='';
	document.form1.addbutton.disabled=true;
	return true;
	
}
function domod(id){
	if(!isNaN(id)){
		var v=eval('document.form1.p_price'+ id);
		if(isNaN(v.value) || v.value<=0){
			alert('�۸�ӦΪ�����Ҵ���0');
			v.focus();
			return false;
		}
		if(confirm('�޸ĺ󽫶����д˼�����û����ؼ۽����޸�,ȷ���޸���?')){
			document.form1.action +='?act=mod&id=' + id;
			document.form1.submit();
			document.getElementById('loadimg'+id).style.display='';
			var dd=eval('document.form1.modbutton' + id) ;
			dd.disabled=true;
		}
	}
}
function dodel(id){
		var checkNum = 0; 
		var checkboxs =document.form1.delitem;
		var forcunt=checkboxs.length;
		if(!forcunt){
			if(checkboxs.checked){
				checkNum += 1;
			}
		}else{
			for(var i=0;i<forcunt;i++)  
			{ 
			����if(checkboxs[i].checked) //��ѡ���ʱ�� 
			����{ 
			��������checkNum += 1; 
					break;
			����} 
			} 
		}
		if(checkNum>0){
			if(confirm('ɾ����,���д˲�Ʒ���͵��û��ؼ۽��ᱻɾ��,��ȷ��ɾ����?'))
			{
				document.form1.action += '?act=del';
				document.form1.submit();
				document.getElementById('loadimgdel').style.display='';
				document.form1.delbutton.disabled=true;
				return true;
			}
		}else{
			alert('��û��ѡ��Ҫɾ��Ҫɾ������Ŀ');
			return false;
		}
}
function getdivselect(v){
	var f=CalendargetPos(v,"Left");
	var t=CalendargetPos(v,"Top");
	var c=document.getElementById('htmlselect');
	var ss=document.getElementById('setinput');
	ss.value=v.name;
	c.style.display=(c.style.display=="none")?"":"none";
	c.style.pixelLeft=f;
	c.style.pixelTop=t + v.offsetHeight;
}
function CalendargetPos(el,ePro)				/// Get Absolute Position
{
	var ePos=0;
	while(el!=null)
	{		
		ePos+=el["offset"+ePro];
		el=el.offsetParent;
	}
return ePos;
}
function dosetv(v){
	var ss=document.getElementById('setinput');
	var vs=ss.value;
	var vv=eval('document.form1.' + vs);
	 vv.value=v;
	document.getElementById('htmlselect').style.display='none';
	ss.value='';
}
function dorenewcndomain(){
		startdateobj=document.form1.startDate;
		enddateobj  =document.form1.endDate;
		exitdateobj =document.form1.exitDate;
		setpriceobj =document.form1.setPrice;
		if(!isDate(startdateobj.value)){
			alert("��Ǹ,ע�����ڸ�ʽ����");
			startdateobj.focus();
			return false;
		}
		if(!isDate(enddateobj.value)){
			alert("��Ǹ,ע�����ڸ�ʽ����");
			enddateobj.focus();
			return false;
		}
		if(!isDate(exitdateobj.value)){
			alert("��Ǹ,�������ڸ�ʽ����");
			exitdateobj.focus();
			return false;
		}
		
		if(isNaN(setpriceobj.value)){
			
			alert("��Ǹ,�������Ѽ۸�ʽ����");
			setpriceobj.focus();
			return false;
		}else{
			if (setpriceobj.value.indexOf(".")>0 || setpriceobj.value<=0 ){
				alert("��Ǹ,�������Ѽ�����д������");
				setpriceobj.focus();
				return false;
			}
		}
		document.form1.action += "?act=renewcnprice";
		document.form1.submit();
		document.form1.renewbutton.value="����ִ��...";
		document.form1.renewbutton.disabled=true;
		
}
function isDate(v){ 
	var reg=/^(\d{4})(-|\/)(\d{1,2})\2(\d{1,2}$)/ig;
	return reg.test(v);
} 

</script>
<body>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>�������ⶨ������</strong></td>
  </tr>
</table>
<table width="99%" border="0" cellspacing="0" >
  <form name="form1" action="<%=request("script_name")%>" method=post>
    <tr align="center">
      <td><table width="80%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#efefef" >
     	 
          <tr><td align="center">
          <fieldset align="center" style="font-size:9pt; width:95%"> 
           <legend class="STYLE17">���ò�Ʒ��<span class="STYLE18">�˼���<span class="STYLE10">�����û�</span>�����깺��</span>����۸�</legend>
          
          <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
          <tr>
            <td colspan="9" align="left" class="tdbg"><%=searchlist%></td>
          </tr>
          <tr align="center" class="Title">
            <td width="22%" nowrap="nowrap"><strong>�û�����</strong></td>
            <td width="27%" nowrap="nowrap"><strong>��Ʒ����</strong></td>
            <td width="31%" nowrap="nowrap"><strong>��������۸�</strong></td>
            <td width="10%" nowrap="nowrap">
            <img id="loadimgdel" src="/images/mallload.gif" style="display:none" border=0>
            <input name="delbutton" type="button" onclick="dodel()" value="ɾ��"></td>
            <td width="10%" nowrap="nowrap"><strong>�޸�</strong></td>
          </tr>
         <%
	  Do While Not rs.eof And cur<=setsize
		tdcolor="#ffffff"
		if cur mod 2 =0 then tdcolor="#efefef"
		p_id=trim(rs("p_id"))
	 %>
          <tr align="center" bgcolor="<%=tdcolor%>">
            <td nowrap="nowrap"><%=rs("l_name")%></td>
            <td nowrap="nowrap"><%=rs("p_proid")%></td>
            <td nowrap="nowrap"><input name="p_price<%=p_id%>" type="text" value="<%=rs("p_price")%>" size="5" maxlength="10" />
Ԫ</td>
            <td nowrap="nowrap"><input type="checkbox" value="<%=p_id%>" name="delitem"></td>
            <td nowrap="nowrap">
             <img id="loadimg<%=p_id%>" src="/images/mallload.gif" style="display:none" border=0>
            <input type="button" value="ȷ��"  name="modbutton<%=p_id%>" onclick="domod(<%=p_id%>)"></td>
          </tr>
          <%
	 	cur=cur+1
	 	rs.movenext
	  loop
	  
	 %>
          <tr bgcolor="#FFFFFF">
            <td colspan ="9" align="center"><%=pagenumlist%> </td>
          </tr>
          <tr align="center" bgcolor="#FFFFCC">
            <td nowrap="nowrap"><span class="STYLE5">
              <select name="addlevel">
                <%
	 do while not rs11.eof
	 %>
                <option value="<%=rs11("l_level")%>"><%=rs11("l_name")%></option>
                <%
	  rs11.movenext
	 loop
	 rs11.movefirst
	  %>
              </select>
              </span> </td>
            <td nowrap="nowrap"><input name="addproid" type="text" size="20" maxlength="20" value="domcn" onclick="getdivselect(this)" ></td>
            <td nowrap="nowrap"><input name="addprice" type="text" size="10" maxlength="10">Ԫ</td>
            <td nowrap="nowrap"></td>
            <td nowrap="nowrap">
            <img id="loadimg" src="/images/mallload.gif" style="display:none" border=0>
            <input name="addbutton" type="button" value="���" onclick="doadd()"></td>
          </tr>
          </table>
          <br />
          </fieldset>
          </td></tr>
          <tr><td align="center">
          <fieldset align="center" style="font-size:9pt; width:95%"> 
           <legend class="STYLE16"><strong>����cn������<span class="STYLE18">��������</span>�۸�</strong>(������gov.cn)</legend>
           
          	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
          
            <tr>
            <td align="right">�Ƿ�����:</td>
            <td align="center">
            <%if isopen="1" then%>
            <img src="/images/green1.gif" border="0" /><span class="STYLE13">������</span>
            <%elseif isopen="0" then %>
             <img src="/images/fei1.gif" border="0" /><span class="STYLE14">�ѽ���</span>
            <%end if%>
           <br />
            <input type="radio" value="0" name="isopen" <%if isopen="0" then response.write "checked"%> />
            ����&nbsp;&nbsp;
            <input type="radio" value="1" name="isopen" <%if isopen="1" then response.write "checked"%>/>
            ����
            </td>
            <td align="left">&nbsp;&nbsp;*���û��ֹ�˹���</td>
            <tr bgcolor="#efefef">
            <td width="14%" align="right">ע��ʱ��:</td>
            <td width="33%" align="left" nowrap="nowrap">
            <input name="startDate" type="text" value="<%=startDate%>" size="12"/>
            ��<input name="endDate" type="text" value="<%=endDate%>" size="12"/>
            </td>
            <td width="53%" align="left">&nbsp;&nbsp;*ѡ��cn������ע��ʱ�䷶Χ</td>
            </tr>
            <tr>
            <td align="right">��������:</td>
            <td align="left" nowrap="nowrap"><input name="exitDate" type="text" value="<%=exitDate%>" size="12" />��</td>
            <td align="left">&nbsp;&nbsp;*ѡ��cn�����ĵ���ʱ�䷶Χ</td>
            </tr>
            <tr bgcolor="#efefef">
            <td align="right" nowrap="nowrap">��������:</td>
            <td align="left" nowrap="nowrap"><select name="cnrenewlevel">
               <option value="">�����û�</option>
                <%
	 do while not rs11.eof
	 %>
                <option value="<%=rs11("l_level")%>" <%if trim(cnrenewlevel)=trim(rs11("l_level")) then response.write "selected"%>><%=rs11("l_name")%></option>
                <%
	  rs11.movenext
	 loop
	  %>
              </select>
               ���Ѽ�
               <input name="setPrice" type="text" value="<%=setPrice%>" size="5" />
            Ԫ</td>
            <td align="left">&nbsp;&nbsp;*����һ��ʱ��Ҫ�ļ۸�<br />
             &nbsp;&nbsp; (<span class="STYLE10">һ�������Ѷ����������Ч)</span></td></tr>
            <tr>
              <td colspan="3" align="center"><input type=button value=" ȷ������ " name="renewbutton" onclick="dorenewcndomain()" /></td></tr>
            </table><br /></fieldset>
          </td></tr>
            <tr><td colspan ="9" align="left">
              
              <ul>
                <span class="STYLE12">���ò�Ʒ�����깺��۸�˵��:</span>
              <li>���û������Ʒ��һ��ļ۸��������,��cn������һ�������۸�</li>
              <li>�����޸�,���,ɾ����,������ı���ϵͳ��Ķ�Ӧ�����ע���û��������ؼ�.</li>
              <li>��ϵͳ��ע���û�ʱ�����ݴ˴��������������û����ؼ�</li>
              <li>�۸�������ο�<a href="http://help.west.cn/help/list.asp?unid=373" target="_blank"><u>�´���ƽ̨��Ʒ�۸��ȡ����</u></a></li>
              <li>��������������۸�����������깺��ʱ���۸���㹫ʽΪ����������۸�+(����-1)*��������۸�
��������۸���<a href="../productmanager/default.asp"><u>��Ʒ�б�/�۸�����</u></a>�����á�ҵ�����Ѳ�������������۸� </li>
              </ul>
              <hr />
              <ul>
                <span class="STYLE12">����cn��������һ��۸�˵��:</span>
              <li>����cn��������һ��۸���ע��ʱ�䲻ͬ����ͬ�����ӵĹ���</li>
              <li>��д����Ӧ��ʱ���,�ڴ�ʱ����ڵ���������һ�갴�մ˴����õļ۸�ۿ�</li>
              </ul>
              
              </td></tr>
      </table></td>
    </tr>
  </form>

</table>
<%
rs11.close
rs.close
conn.close
function isproid(byval proid)
	isproid=false
	sqlp="select * from productlist where p_proid='"& proid &"'"
	set prs=conn.execute(sqlp)
	if not prs.eof then
		isproid=true
	end if
	prs.close
	set prs=nothing
end function
function addmsg(byval addlevel,byval addproid,byval addprice)
			sql="select * from userdetail where u_level=" & addlevel
			set rs2=conn.execute(sql)
			if not rs2.eof then
				do while not rs2.eof
					u_id=rs2("u_id")
					sql1="select * from userPrice where u_id="& u_id &" and proid='"& addproid &"'"
					rs11.open sql1,conn,1,3
					if not rs11.eof then
						rs11("proprice")=addPrice
						rs11.update()
					else
						rs11.addnew()
						rs11("u_id")=u_id
						rs11("proid")=addproid
						rs11("ProPrice")=addprice
						rs11.update()
					end if
					rs11.close
				rs2.movenext
				loop
			end if
			rs2.close
			set rs2=nothing
end function
function addcnPrice(byval startDate,byval endDate,byval exitDate,byval setPrice,byval cnrenewlevel,byval isopen)
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobjNode = isNodes("pageset","renewCnPrice",xmlpath,true,objDoms)
		myobjNode.setAttribute "startDate",startDate
		myobjNode.setAttribute "endDate",endDate
		myobjNode.setAttribute "exitDate",exitDate
		myobjNode.setAttribute "setPrice",setPrice
		myobjNode.setAttribute "cnrenewlevel",cnrenewlevel
		myobjNode.setAttribute "isopen",isopen
	objDoms.save(xmlpath)
	set myobjNode=nothing
	set objDoms=nothing
end function
function readcnPrice(byref startDate,byref endDate,byref exitDate,byref setPrice,byref cnrenewlevel,byref isopen)
	startDate="":endDate="":exitDate="":setPrice="":cnrenewlevel="":isopen=""
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobjNode = isNodes("pageset","renewCnPrice",xmlpath,true,objDoms)
		set startDateobj=myobjNode.Attributes.getNamedItem("startDate")
		set endDateobj=myobjNode.Attributes.getNamedItem("endDate")
		set exitDateobj=myobjNode.Attributes.getNamedItem("exitDate")
		set setPriceobj=myobjNode.Attributes.getNamedItem("setPrice")
		set cnrenewlevelobj=myobjNode.Attributes.getNamedItem("cnrenewlevel")
		set isopenobj=myobjNode.Attributes.getNamedItem("isopen")
		if not startDateobj is nothing then startDate=startDateobj.nodeValue
		if not endDateobj is nothing then endDate=endDateobj.nodeValue
		if not exitDateobj is nothing then exitDate=exitDateobj.nodeValue
		if not setPriceobj is nothing then setPrice=setPriceobj.nodeValue
		if not cnrenewlevelobj is nothing then cnrenewlevel=cnrenewlevelobj.nodeValue
		if not isopenobj is nothing then isopen=isopenobj.nodeValue
	set myobjNode=nothing
	set objDoms=nothing
end function
%>
<div id='htmlselect' style='display:none;position:absolute;width:150px;border:1px solid  #FF6633;padding:2px;background-color: #FFFF99'>
<table border="0" align="left" cellpadding="0" cellspacing="0">
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domcom')"><td>domcom[Ӣ�Ĺ���.com]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domnet')"><td>domnet[Ӣ�Ĺ���.net]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domorg')"><td>domorg[Ӣ�Ĺ���.org]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domcn')"><td>domcn[Ӣ�Ĺ���.cn]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domgovcn')"><td>domgovcn[Ӣ�Ĺ���.govcn]</td></tr>

</table>
 		  
</div>
<input type="hidden" id="setinput">
</body>
</html>
