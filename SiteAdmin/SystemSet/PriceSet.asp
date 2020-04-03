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
<title>价格设置</title>
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
		if not isproid(addproid) then url_return "抱歉,没有找到您设置的产品型号",-1
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
			alert_redirect "添加成功",request("script_name")
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
		alert_redirect "删除成功",request("script_name") & "?PageNo="& request("pageNo")
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
		alert_redirect "修改成功",request("script_name") & "?PageNo="& request("pageNo")
	end if
case "renewcnprice"
		startdateobj=requesta("startDate")
		enddateobj  =requesta("endDate")
		exitdateobj =requesta("exitDate")
		setpriceobj =requesta("setPrice")
		isopen		=requesta("isopen")
		cnrenewlevel=requesta("cnrenewlevel")
		if startdateobj="" or enddateobj="" or exitdateobj="" or setpriceobj="" then url_return "抱歉,参数错误",-1
		call addcnPrice(startdateobj,enddateobj,exitdateobj,setpriceobj,cnrenewlevel,isopen)
		alert_redirect "设置成功",request("script_name")
end select

call readcnPrice(startDate,endDate,exitDate,setPrice,cnrenewlevel,isopen)
if isopen="" then isopen="0"
if startDate="" then startDate="2007-3-7"
if endDate="" then endDate="2009-2-28"
if exitDate="" then exitDate="2009-2-28"
if setPrice="" then setPrice="18"

sqlArray=Array("l_name,用户级别,str","p_proid,产品类型,str","p_price,首年特价,int")
newsql=searchEnd(searchItem,condition,searchValue,othercode)
sqlstring="select a.*,b.l_name from Pricelevellist a inner join levellist b on a.p_level=b.l_level where 1=1 "& newsql &" order by a.p_date desc"

rs.open sqlstring,conn,1,1
    setsize=20
	cur=1
	pagenumlist=GetPageClass(rs,setsize,othercode,pageCounts,linecounts)

levelsql="select * from levellist order by l_level asc"
rs11.open levelsql,conn,1,1
if rs11.eof then url_return "没有找到相关的用户级别",-1
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
		alert('产品类型不能这空');
		addproid.focus();
		return false;
	}
	if(isNaN(addprice.value) || addprice.value<=0){
		alert('价格应为数字且大于0');
		addprice.focus();
		return false;
	}
	
	if(confirm('添加后,将对所有此级别的用户添加特价,确定添加吗?'))
	
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
			alert('价格应为数字且大于0');
			v.focus();
			return false;
		}
		if(confirm('修改后将对所有此级别的用户的特价进行修改,确定修改吗?')){
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
			　　if(checkboxs[i].checked) //被选择的时候 
			　　{ 
			　　　　checkNum += 1; 
					break;
			　　} 
			} 
		}
		if(checkNum>0){
			if(confirm('删除后,所有此产品类型的用户特价将会被删除,您确定删除吗?'))
			{
				document.form1.action += '?act=del';
				document.form1.submit();
				document.getElementById('loadimgdel').style.display='';
				document.form1.delbutton.disabled=true;
				return true;
			}
		}else{
			alert('您没有选中要删除要删除的项目');
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
			alert("抱歉,注册日期格式有误");
			startdateobj.focus();
			return false;
		}
		if(!isDate(enddateobj.value)){
			alert("抱歉,注册日期格式有误");
			enddateobj.focus();
			return false;
		}
		if(!isDate(exitdateobj.value)){
			alert("抱歉,到期日期格式有误");
			exitdateobj.focus();
			return false;
		}
		
		if(isNaN(setpriceobj.value)){
			
			alert("抱歉,首年续费价格式错误");
			setpriceobj.focus();
			return false;
		}else{
			if (setpriceobj.value.indexOf(".")>0 || setpriceobj.value<=0 ){
				alert("抱歉,首年续费价请填写正整数");
				setpriceobj.focus();
				return false;
			}
		}
		document.form1.action += "?act=renewcnprice";
		document.form1.submit();
		document.form1.renewbutton.value="正在执行...";
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
    <td height='30' align="center" ><strong>首年特殊定价设置</strong></td>
  </tr>
</table>
<table width="99%" border="0" cellspacing="0" >
  <form name="form1" action="<%=request("script_name")%>" method=post>
    <tr align="center">
      <td><table width="80%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#efefef" >
     	 
          <tr><td align="center">
          <fieldset align="center" style="font-size:9pt; width:95%"> 
           <legend class="STYLE17">设置产品的<span class="STYLE18">此级别<span class="STYLE10">所有用户</span>的首年购买</span>特殊价格</legend>
          
          <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
          <tr>
            <td colspan="9" align="left" class="tdbg"><%=searchlist%></td>
          </tr>
          <tr align="center" class="Title">
            <td width="22%" nowrap="nowrap"><strong>用户级别</strong></td>
            <td width="27%" nowrap="nowrap"><strong>产品类型</strong></td>
            <td width="31%" nowrap="nowrap"><strong>首年特殊价格</strong></td>
            <td width="10%" nowrap="nowrap">
            <img id="loadimgdel" src="/images/mallload.gif" style="display:none" border=0>
            <input name="delbutton" type="button" onclick="dodel()" value="删除"></td>
            <td width="10%" nowrap="nowrap"><strong>修改</strong></td>
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
元</td>
            <td nowrap="nowrap"><input type="checkbox" value="<%=p_id%>" name="delitem"></td>
            <td nowrap="nowrap">
             <img id="loadimg<%=p_id%>" src="/images/mallload.gif" style="display:none" border=0>
            <input type="button" value="确定"  name="modbutton<%=p_id%>" onclick="domod(<%=p_id%>)"></td>
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
            <td nowrap="nowrap"><input name="addprice" type="text" size="10" maxlength="10">元</td>
            <td nowrap="nowrap"></td>
            <td nowrap="nowrap">
            <img id="loadimg" src="/images/mallload.gif" style="display:none" border=0>
            <input name="addbutton" type="button" value="添加" onclick="doadd()"></td>
          </tr>
          </table>
          <br />
          </fieldset>
          </td></tr>
          <tr><td align="center">
          <fieldset align="center" style="font-size:9pt; width:95%"> 
           <legend class="STYLE16"><strong>设置cn域名的<span class="STYLE18">首年续费</span>价格</strong>(不包括gov.cn)</legend>
           
          	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
          
            <tr>
            <td align="right">是否启用:</td>
            <td align="center">
            <%if isopen="1" then%>
            <img src="/images/green1.gif" border="0" /><span class="STYLE13">已启用</span>
            <%elseif isopen="0" then %>
             <img src="/images/fei1.gif" border="0" /><span class="STYLE14">已禁用</span>
            <%end if%>
           <br />
            <input type="radio" value="0" name="isopen" <%if isopen="0" then response.write "checked"%> />
            禁用&nbsp;&nbsp;
            <input type="radio" value="1" name="isopen" <%if isopen="1" then response.write "checked"%>/>
            启用
            </td>
            <td align="left">&nbsp;&nbsp;*启用或禁止此功能</td>
            <tr bgcolor="#efefef">
            <td width="14%" align="right">注册时间:</td>
            <td width="33%" align="left" nowrap="nowrap">
            <input name="startDate" type="text" value="<%=startDate%>" size="12"/>
            至<input name="endDate" type="text" value="<%=endDate%>" size="12"/>
            </td>
            <td width="53%" align="left">&nbsp;&nbsp;*选择cn域名的注册时间范围</td>
            </tr>
            <tr>
            <td align="right">到期日期:</td>
            <td align="left" nowrap="nowrap"><input name="exitDate" type="text" value="<%=exitDate%>" size="12" />内</td>
            <td align="left">&nbsp;&nbsp;*选择cn域名的到期时间范围</td>
            </tr>
            <tr bgcolor="#efefef">
            <td align="right" nowrap="nowrap">首年续费:</td>
            <td align="left" nowrap="nowrap"><select name="cnrenewlevel">
               <option value="">所有用户</option>
                <%
	 do while not rs11.eof
	 %>
                <option value="<%=rs11("l_level")%>" <%if trim(cnrenewlevel)=trim(rs11("l_level")) then response.write "selected"%>><%=rs11("l_name")%></option>
                <%
	  rs11.movenext
	 loop
	  %>
              </select>
               续费价
               <input name="setPrice" type="text" value="<%=setPrice%>" size="5" />
            元</td>
            <td align="left">&nbsp;&nbsp;*续费一年时需要的价格<br />
             &nbsp;&nbsp; (<span class="STYLE10">一次性续费多年此设置无效)</span></td></tr>
            <tr>
              <td colspan="3" align="center"><input type=button value=" 确定设置 " name="renewbutton" onclick="dorenewcndomain()" /></td></tr>
            </table><br /></fieldset>
          </td></tr>
            <tr><td colspan ="9" align="left">
              
              <ul>
                <span class="STYLE12">设置产品的首年购买价格说明:</span>
              <li>对用户购买产品第一年的价格进行设置,如cn域名第一年的特殊价格</li>
              <li>对于修改,添加,删除等,都将会改变您系统里的对应级别的注册用户的首年特价.</li>
              <li>您系统新注册用户时将根据此处设置来决定此用户的特价</li>
              <li>价格设置请参考<a href="http://help.west.cn/help/list.asp?unid=373" target="_blank"><u>新代理平台产品价格获取过程</u></a></li>
              <li>设置了首年特殊价格的域名，多年购买时，价格计算公式为：首年特殊价格+(年限-1)*域名单年价格
域名单年价格在<a href="../productmanager/default.asp"><u>产品列表/价格设置</u></a>中设置。业务续费不享受首年特殊价格。 </li>
              </ul>
              <hr />
              <ul>
                <span class="STYLE12">设置cn域名续费一年价格说明:</span>
              <li>由于cn域名续费一年价格以注册时间不同而不同而增加的功能</li>
              <li>填写好相应的时间段,在此时间段内的域名续费一年按照此处设置的价格扣款</li>
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
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domcom')"><td>domcom[英文国际.com]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domnet')"><td>domnet[英文国际.net]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domorg')"><td>domorg[英文国际.org]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domcn')"><td>domcn[英文国内.cn]</td></tr>
<tr onmouseover="this.style.background='#99cc00';" onmouseout="this.style.background='#FFFF99'" onclick="dosetv('domgovcn')"><td>domgovcn[英文国内.govcn]</td></tr>

</table>
 		  
</div>
<input type="hidden" id="setinput">
</body>
</html>
