<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/ParseCommand.asp" -->
<!--#include virtual="/config/xml_class.asp" -->
<%Check_Is_Master(1)%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE10 {color: #666666; font-size: 12px; }
.STYLE11 {color: #FF0000}
.STYLE12 {color: #0099CC}
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
.setnewcss {
	font-weight: bold;
	font-size: 10pt;
	color: #333;
}
-->
</style>
<script language="javascript">
function dosub(){
	var f=document.form1;
	if(f.optValue.value!='' && !isNaN(f.optValue.value)){
		var dotypeObj=f.dotype;
		var isdotype=false;
		for(var i=0;i<dotypeObj.length;i++){
			if(dotypeObj[i].checked){
				isdotype=true;
				break;
			}
		}
		if(!isdotype){
				alert('请选择类别');
		}else{
			if (confirm('您确定批量调整价格吗?')){
				f.startAdjust.value='正在执行...';
				return true;
			}
		}
	}else{
		alert('输入值不正确');
		f.optValue.focus();
	}
	return false;
}
function dodel(sysid){
	if(sysid!=""){
		if(confirm("删除后将对本条记录操作的价格进行还原\r\n确定删除吗？")){
		location.href=window.location.pathname + "?act=del&sysid="+ sysid;
		}
	}
}
function doselectprimalprice(v){
	if(v.value!="")	{
		pobj=document.form1.primalprice;
		for(var i=0;i<pobj.length;i++){
			var bvalue=pobj.options[i].value;
			if(bvalue==v.value){
				pobj.selectedIndex=i;
				break;
			}
		}	
	}
}
function doselectprimalsetYear(v){
	if(v.value!="")	{
		pobj=document.form1.primalsetYear;
		for(var i=0;i<pobj.length;i++){
			var bvalue=pobj.options[i].value;
			if(bvalue==v.value){
				pobj.selectedIndex=i;
				break;
			}
		}
	}
}
</script>
<%
conn.open constr
xmlfilePath="/database/data.xml"
startAdjust=Request.Form("startAdjust")
if startAdjust<>"" then
	call dotoallprice()
elseif requesta("act")="del" then
	sysid=requesta("sysid")
	if sysid<>"" then
		delXML(sysid)
	end if
end if
%>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>价格批量调整</strong></td>
  </tr>
</table>
<TABLE WIDTH='100%' BORDER='0' ALIGN='center' CELLPADDING='2' CELLSPACING='1' CLASS='border'>
  <TR CLASS='tdbg'>
    <TD WIDTH='91' HEIGHT='30' ALIGN="center" ><STRONG>管理导航：</STRONG></TD>
    <TD WIDTH="771"><A HREF="addPro.asp">新增产品</A> | <A HREF="default.asp?module=search&p_type=1">空间</A> | <A HREF="default.asp?module=search&p_type=2">邮局</A> | <A HREF="default.asp?module=search&p_type=3">域名</A> | <A HREF="default.asp?module=search&p_type=4">网站推广</A> |<A HREF="default.asp?module=search&p_type=7"> 数据库</A>  | <A HREF="syncPro.asp">同步产品或价格</A></TD>
  </TR>
</TABLE>
<table width="90%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#cccccc">
  <FORM NAME="form1" METHOD="post" ACTION="<%=Request.ServerVariables("SCRIPT_NAME")%>" onSubmit="return dosub()">
  	<tr>
  	  <td height="54" colspan="3" align="center" nowrap bgcolor="#eaf5fc"><a href="pljg.asp?action=njg" onClick="return confirm('同步后所有级别价格将于直接客户一致，请确认操作！')">设置其它级别价格与直接用户价格一致 </a><br>
  	    <br><a href="pljg.asp?action=clearall" onClick="return confirm('清空所有价格数据后请先同步后再操作！')">清空所有价格数据</a>
  	 </td>
    </tr>
  	<tr>
      <td width="23%" align="right" nowrap bgcolor="#eaf5fc">选择类别:</td>
      <td width="38%" bgcolor="#FFFFFF">
      <input name="dotype" type="checkbox" value="new">购买
      <input name="dotype" type="checkbox" value="renew">续费
      </td>
      <td width="39%" nowrap bgcolor="#FFFFFF" class="STYLE10">
        <a href="<%=SystemAdminPath%>/SystemSet/PriceSet.asp"><font color="blue"><u>【批量设置用户首年特殊价格】</u></font></a>
      <br>      
      2009-4-15日后推荐不再使用用户首年特殊价格功能</td>
    </tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">更新的产品类型:</td>
      <td bgcolor="#FFFFFF">
        <select name="p_types" id="select">
          <%=GetPLIST()%>
        </select>      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">对哪种产品进行更新</span></td>
    </tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">更新的用户级别:</td>
      <td bgcolor="#FFFFFF">
       <select name="user_level" onChange="doselectprimalprice(this)">
          <%= getuserlevellist()%>
       </select>      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">对选择的用户级别设置价格</span></td>
    </tr>
    <tr>
    <td align="right" nowrap bgcolor="#eaf5fc">需更新价格项:</td>
    <td nowrap bgcolor="#FFFFFF"><select name="setYear" onChange="doselectprimalsetYear(this)">
          <%=getbuyyearlist()%>
      </select></td>
    <td bgcolor="#FFFFFF"><span class="STYLE10">选择需要修改的价格项</span></td>
    </tr>
    <tr><td align="right" nowrap bgcolor="#eaf5fc">选择原数据:</td>
    <td class="setnewcss" nowrap bgcolor="#FFFFFF">
    以<select name="primalprice">
		<%=getuserlevellist()%>
        </select>
        <select name="primalsetYear">
          <%=getbuyyearlist1()%>
        </select>
        <select name="primalpriceType">
       	  <option value="new" >购买</option>
          <option value="renew" >续费</option>  
    </select>价格</td><td bgcolor="#FFFFFF"><span class="STYLE10">将以此选择计算出的价格作为更新价格的<br> <span class="STYLE12">被加/乘数</span></span></td></tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">设置价格:</td>
      <td nowrap bgcolor="#FFFFFF">
        <select name="operator">
          <option value="+">加上</option>
          <option value="*">乘以</option>
        </select>
      <INPUT NAME="optValue" TYPE="text" class="inputbox" SIZE="2" MAXLENGTH="10">      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">
      对 <span class="STYLE12">选择的原数据</span> 加上或乘以填入的值，<br><span class="STYLE11">可填负数</span>。<br>
      如果要清空某价格项，可选择 乘以 0
      </span></td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td colspan="3" align="center"><INPUT TYPE="submit" NAME="startAdjust"  VALUE="确定调整"></td>
    </tr>
    <tr><td colspan="3" bgcolor="#FFFFFF">
    <%call selectXML()%>
    </td></tr>
  </FORM>
</table>
<hr size=1 color=#eaf5fc>
</body>
</html>
<%
function GetPList()
	set lrs=conn.Execute("select pt_id,pt_name from producttype")
	do while not lrs.eof
		if instr("网站建设,搜索引擎",lrs("pt_name"))=0 then
		GetPList=GetPList & "<option value=""" & lrs("pt_id") & """>" & lrs("pt_name") & "</option>" & vbcrlf
		end if
	lrs.movenext
	loop
	lrs.close
	set lrs=nothing
end function
function getuserlevellist()
	listStr=""
	sqllevel="select * from levellist order by l_level asc"
	set levelRs=conn.execute(sqllevel)
	if not levelRs.eof then
		do while not levelRs.eof
			listStr=listStr & "<option value="""& levelRs("l_level") &""">"& levelRs("l_name") &"</option>" & vbcrlf
		levelRs.movenext
		loop
	end if
	levelRs.close
	set levelRs=nothing
	getuserlevellist=listStr
end function
function getbuyyearlist()
 	for y=0 to 10
		if y=0 then 
			ytext="首年特价"
		else
			ytext=y & "年价格"
		end if
		selectedstr=""
		if y=1 then selectedstr=" selected"
		getbuyyearlist=getbuyyearlist & "<option value="& y & selectedstr & ">"& ytext &"</option>" & vbcrlf
	next
end function
function getbuyyearlist1()
 	for y=0 to 10
		if y=0 then 
			ytext="首年特殊"
		else
			ytext=y & "年"
		end if
		selectedstr=""
		if y=1 then selectedstr=" selected"
		getbuyyearlist1=getbuyyearlist1 & "<option value="& y & selectedstr & ">"& ytext &"</option>" & vbcrlf
	next
end function
function instrfirstprice(byval updatefildName,byval price,byval u_level,byval proid,byval buyyear)
		if trim(buyyear&"")="" then buyyear=0
		buyyear=int(buyyear)
		'	response.write(proid&"="&ccur(price)&"<BR>")
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
		
end function
function insertAccess(byval proid,byval price,byval u_level,byval buyyear,byval dotype)
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
		end select
		call instrfirstprice(updatefildName,price,u_level,proid,buyyear)
end function
function dotoallprice()
	dotype=request.Form("dotype")'new,renew
	setYear=request.Form("setyear")'将操作的年限
	operator=Request.Form("operator")'乘除
	optValue=Request.Form("optValue")'价格
	p_types=Request.Form("p_types")'产品类别
	user_level=request.Form("user_level")'用户级别
	primalprice=request.Form("primalprice")'执行标准
	primalsetYear=request.Form("primalsetYear")'基准年
	primalpriceType=request.Form("primalpriceType")'以购卖价或续费价为基准
	if dotype="" or p_types="" then exit function
	issusse=false
	sql="select p_proid from productlist where p_type="& p_types
	rs1.open sql,conn,1,1
	if not rs1.eof then
		paraid=round(timer()) & getNodeCount()
		do while not rs1.eof
			proid=rs1("p_proid")
			
			oldAllprice=getProlevelPrice(proid,user_level,setYear)
			siteAllPrice=getProlevelPrice(proid,primalprice,primalsetYear)
			
			
			for each typeItem in split(dotype,",")
				typeItem=trim(typeItem)
				if typeItem<>"" then
					priceArr=split(siteAllPrice&"","|")
					if ubound(priceArr)>0 then
						if typeItem="new" then
							sitePrice=priceArr(0)
							if primalpriceType="renew" then sitePrice=priceArr(1)
						else
							sitePrice=priceArr(1)
							if primalpriceType="new" then sitePrice=priceArr(0)
						end if
					end if
					
					oldpriceArr=split(oldAllprice&"","|")
					if ubound(oldpriceArr)>0 then
						if typeItem="new" then
							thisparaid="1" & paraid
							oldPrice=oldpriceArr(0)
						else
							thisparaid="2" & paraid
							oldPrice=oldpriceArr(1)
						end if
					end if
					if oldPrice&""="" then oldPrice=0
					if sitePrice&""="" then sitePrice=0
					getPrice=Round(eval(sitePrice & operator & optValue)+ccur(0.005),2)
					
					if getPrice>=0 then
						issusse=true
						'if typeItem="new" and getPrice=0 and setYear=1 then url_return "不能对“一年价格”设置为“0”元",-1
						call insertadjustPrice(thisparaid,oldprice,setYear,proid,user_level,typeItem)
						call insertAccess(proid,getPrice,user_level,setYear,typeItem)
					end if
				end if
			next
		rs1.movenext
		loop
		if issusse then
			for each typeItem in split(dotype,",")
				typeItem=trim(typeItem)
				if typeItem="new" then
						thisparaid="1" & paraid
				else
						thisparaid="2" & paraid
				end if
				call insertXML(thisparaid,typeItem,setyear,operator,optValue,p_types,user_level,primalprice,primalpriceType,primalsetYear)
			next
			Alert_Redirect "价格更新成功",request.ServerVariables("script_name")
		end if
	end if
	rs1.close
	url_return "更新失败",-1
end function
public function getProlevelPrice(byval proid,byval u_level,byval buyyear)
	if buyyear<0 then buyyear=0


	If isdbsql Then
		select case  buyyear
		case 0
			sql="select top 1 isnull(p_firstPrice,0),isnull(p_firstPrice_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
		case 1
			sql="select top 1 isnull(p_price,0),isnull(p_price_renew,0) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
		case else
			sql="select top 1 isnull(newPrice,0),isnull(RenewPrice,0) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'"
		end Select

	else
		select case  buyyear
		case 0
			sql="select top 1 iif(isnull(p_firstPrice),0,p_firstPrice),iif(isnull(p_firstPrice_renew),0,p_firstPrice_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
		case 1
			sql="select top 1 iif(isnull(p_price),0,p_price),iif(isnull(p_price_renew),0,p_price_renew) from pricelist where p_u_level="& u_level &" and p_proId='"& proid &"'"
		case else
			sql="select top 1 iif(isnull(newPrice),0,newPrice),iif(isnull(RenewPrice),0,RenewPrice) from registerDomainPrice where UserLevel="& u_level & " and NeedYear="& buyyear & " and ProId='"& ProId &"'"
		end select
    end if

	set prs=conn.execute(sql)
	if not prs.eof then
		getProlevelPrice=prs(0) &"|"& prs(1)
	else
		getProlevelPrice=""
	end if
	prs.close
	set prs=nothing
end function
function insertadjustPrice(byval paraid,byval oldprice,byval years,byval proid,byval user_level,byval dotype)
	if oldPrice<>"" and years<>"" and proid<>"" and paraid<>"" and user_level<>"" then
		conn.execute "insert into adjustPrice(a_paraid,a_oldprice,a_proid,years,user_level,dotype) values("& paraid &","& oldprice &",'"& proid &"',"& years &","& user_level &",'"& dotype &"')"
	end if
end function
function insertXML(byval paraid,byval dotype,byval setyear,byval operator,byval optValue,byval p_types,byval user_level,byval primalprice,byval primalpriceType,byval primalsetYear)
	Set xml=new xmlClass
		xml.xmlFileName=xmlfilePath
		set RootNodeObj=xml.xml_getNode("/ROOT/adjustPrice")
			
			xml.nodeObj=xml.xml_createChild("Priceitem")
			xml.xml_setValue "sysid",paraid'round(timer()) & RootNodeObj.childNodes.length
			xml.xml_setValue "dotype",dotype
			xml.xml_setValue "setyear",setyear
			xml.xml_setValue "operator",operator
			xml.xml_setValue "optValue",optValue
			xml.xml_setValue "p_types",p_types
			xml.xml_setValue "user_level",user_level
			xml.xml_setValue "primalprice",primalprice
			xml.xml_setValue "primalpriceType",primalpriceType
			xml.xml_setValue "primalsetYear",primalsetYear
			xml.xml_setValue "submitDate",now()
	set xml=nothing
end function
function getNodeCount()
	Set xml=new xmlClass
		xml.xmlFileName=xmlfilePath
		set RootNodeObj=xml.xml_getNode("/ROOT/adjustPrice")
		getNodeCount=RootNodeObj.childNodes.length
	set xml=nothing
	if getNodeCount<>"" and not isnumeric(getNodeCount) then getNodeCount=0
end function
sub selectXML()
%>
	<table border="0" width="100%" align="center" cellpadding="1" cellspacing="1" bordercolordark="#ffffff" bgcolor="#F0F0F0" class="border">
            <tr align="center" class="Title">
            <td><strong>类别</strong></td>
            <td><strong>更新产品类型</strong></td>
            <td><strong>更新用户级别</strong></td>
           	<td><strong>更新价格项</strong></td>
            <td><strong>更新结果</strong></td>
            <td><strong>更新时间</strong></td>
            <td width="5%" nowrap><strong>操作</strong></td>
          </tr>
<%
	Set xml=new xmlClass
		xml.xmlFileName=xmlfilePath
		set RootNodeObj=xml.xml_getNode("/ROOT/adjustPrice")
		cur=1
		for each childItem in RootNodeObj.childNodes
			xml.nodeObj=childItem
			sysid=xml.xml_getValue("sysid")
			dotype=xml.xml_getValue("dotype")
			setyear=xml.xml_getValue("setyear")
			operator=xml.xml_getValue("operator")
			optValue=xml.xml_getValue("optValue")
			p_types=xml.xml_getValue("p_types")
			user_level=xml.xml_getValue("user_level")
			primalprice=xml.xml_getValue("primalprice")
			primalpriceType=xml.xml_getValue("primalpriceType")
			primalsetYear=xml.xml_getValue("primalsetYear")
			submitDate=xml.xml_getValue("submitDate")
			bgcolor="#ffffff"
			if cur mod 2 =0 then bgcolor="#efefef"
			%>
          <tr align="center" bgcolor="<%=bgcolor%>">
            <td nowrap><%=getfomartstr(dotype,"dotype")%></td>
            <td nowrap><%=getfomartstr(p_types,"p_types")%></td>
            <td nowrap><%=getfomartstr(user_level,"user_level")%></td>
           	<td nowrap><%=getfomartstr(setyear,"setyear")%></td>
            <td nowrap><%=getfomartstr(primalprice,"primalprice")&getfomartstr(primalsetYear,"setyear1")&getfomartstr(primalpriceType,"dotype")&"价格"&getfomartstr(operator,"operator")&optValue%></td>
            <td><%=formatDatetime(submitDate,2)%></td>
            <td nowrap>
            <%if cur=1 then%>
            <a href="####" onClick="dodel(<%=sysid%>)"><font color="blue">【删除】</font></a>
            <%else%>
            <font color="#666666">【删除】</font>
            <%end if%></td>
          </tr>
      <%
			cur=cur+1
		next
		if cur<=1 then
			%>
            <tr><td colspan="20"><font color="#666666">您还没有进行过批量设置.无记录可显示</font></td></tr>
            <%
		else
			%>
            <tr><td colspan="20" bgcolor="#FFFFFF"><hr><font color="#666666">
            .只能按顺序从上到下的删除.<br>
            .删除后将对删除的记录操作价格<font color="#FF0000">进行还原</font>.
            </font></td></tr>
            <%
		end if
	set xml=nothing
	%>
    </table>
    <%
end sub
function delXML(byval sysid)
	Set xml=new xmlClass
		xml.xmlFileName=xmlfilePath
		set RootNodeObj=xml.xml_getNode("/ROOT/adjustPrice")

		for each childItem in RootNodeObj.childNodes
			xml.nodeObj=childItem
			xmlsysid=xml.xml_getValue("sysid")
			if xmlsysid=sysid then
				dotype=xml.xml_getValue("dotype")
				setyear=xml.xml_getValue("setyear")
				operator=xml.xml_getValue("operator")
				optValue=xml.xml_getValue("optValue")
				p_types=xml.xml_getValue("p_types")
				user_level=xml.xml_getValue("user_level")
				primalprice=xml.xml_getValue("primalprice")
				submitDate=xml.xml_getValue("submitDate")
				sql="select * from adjustPrice where a_paraid="& sysid
				set aRs=conn.execute(sql)
				if not aRs.eof then
					do while not aRs.eof
						proid=aRs("a_proid")
						oldPrice=aRs("a_oldPrice")
						user_level=aRs("user_level")
						setYear=aRs("years")
						dotype=aRs("dotype")
						call insertAccess(proid,oldPrice,user_level,setYear,dotype)
					aRs.movenext
					loop
				end if
				aRs.close
				set aRs=nothing
				xml.xml_delNode()
				conn.execute "delete from adjustPrice where  a_paraid="& sysid
			end if
		next
	set xml=nothing
end function
function getfomartstr(byval v,byval p)
	reStr=""
	v=trim(v)
	select case p
	case "dotype"
		if v="new" then
			reStr="购买"
		elseif v="renew" then
			reStr="续费"
		end if
	case "setyear"
		if v<>"" then
			if v=0 then
				reStr="首年价格"
			else
				reStr=v & "年价格"
			end if
		end if
	case "setyear1"
		if v<>"" then
			if v=0 then
				reStr="首年特殊"
			else
				reStr=v & "年"
			end if
		end if
	case "p_types"
	
		set prs=conn.execute("select top 1 pt_name from producttype where pt_id="& v)
		if not prs.eof then
			reStr=prs("pt_name")
		end if
		prs.close
		set prs=nothing
	case "user_level"
		set uRs=conn.execute("select l_name from levellist where l_level="& v)
		if not urs.eof then
			reStr=urs("l_name")
		end if
		urs.close
		set urs=nothing
	case "primalprice"
		if v=0 then
			reStr="原"
		else
			set uRs=conn.execute("select l_name from levellist where l_level="& v)
			if not urs.eof then
				reStr=urs("l_name")
			end if
			urs.close
			set urs=nothing
		end if
	case "operator"
		if v="*" then
			reStr="×"
		else
			reStr="＋"
		end if
	
	end select
	getfomartstr=reStr
end function
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
