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
				alert('��ѡ�����');
		}else{
			if (confirm('��ȷ�����������۸���?')){
				f.startAdjust.value='����ִ��...';
				return true;
			}
		}
	}else{
		alert('����ֵ����ȷ');
		f.optValue.focus();
	}
	return false;
}
function dodel(sysid){
	if(sysid!=""){
		if(confirm("ɾ���󽫶Ա�����¼�����ļ۸���л�ԭ\r\nȷ��ɾ����")){
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
    <td height='30' align="center" ><strong>�۸���������</strong></td>
  </tr>
</table>
<TABLE WIDTH='100%' BORDER='0' ALIGN='center' CELLPADDING='2' CELLSPACING='1' CLASS='border'>
  <TR CLASS='tdbg'>
    <TD WIDTH='91' HEIGHT='30' ALIGN="center" ><STRONG>��������</STRONG></TD>
    <TD WIDTH="771"><A HREF="addPro.asp">������Ʒ</A> | <A HREF="default.asp?module=search&p_type=1">�ռ�</A> | <A HREF="default.asp?module=search&p_type=2">�ʾ�</A> | <A HREF="default.asp?module=search&p_type=3">����</A> | <A HREF="default.asp?module=search&p_type=4">��վ�ƹ�</A> |<A HREF="default.asp?module=search&p_type=7"> ���ݿ�</A>  | <A HREF="syncPro.asp">ͬ����Ʒ��۸�</A></TD>
  </TR>
</TABLE>
<table width="90%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#cccccc">
  <FORM NAME="form1" METHOD="post" ACTION="<%=Request.ServerVariables("SCRIPT_NAME")%>" onSubmit="return dosub()">
  	<tr>
  	  <td height="54" colspan="3" align="center" nowrap bgcolor="#eaf5fc"><a href="pljg.asp?action=njg" onClick="return confirm('ͬ�������м���۸���ֱ�ӿͻ�һ�£���ȷ�ϲ�����')">������������۸���ֱ���û��۸�һ�� </a><br>
  	    <br><a href="pljg.asp?action=clearall" onClick="return confirm('������м۸����ݺ�����ͬ�����ٲ�����')">������м۸�����</a>
  	 </td>
    </tr>
  	<tr>
      <td width="23%" align="right" nowrap bgcolor="#eaf5fc">ѡ�����:</td>
      <td width="38%" bgcolor="#FFFFFF">
      <input name="dotype" type="checkbox" value="new">����
      <input name="dotype" type="checkbox" value="renew">����
      </td>
      <td width="39%" nowrap bgcolor="#FFFFFF" class="STYLE10">
        <a href="<%=SystemAdminPath%>/SystemSet/PriceSet.asp"><font color="blue"><u>�����������û���������۸�</u></font></a>
      <br>      
      2009-4-15�պ��Ƽ�����ʹ���û���������۸���</td>
    </tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">���µĲ�Ʒ����:</td>
      <td bgcolor="#FFFFFF">
        <select name="p_types" id="select">
          <%=GetPLIST()%>
        </select>      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">�����ֲ�Ʒ���и���</span></td>
    </tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">���µ��û�����:</td>
      <td bgcolor="#FFFFFF">
       <select name="user_level" onChange="doselectprimalprice(this)">
          <%= getuserlevellist()%>
       </select>      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">��ѡ����û��������ü۸�</span></td>
    </tr>
    <tr>
    <td align="right" nowrap bgcolor="#eaf5fc">����¼۸���:</td>
    <td nowrap bgcolor="#FFFFFF"><select name="setYear" onChange="doselectprimalsetYear(this)">
          <%=getbuyyearlist()%>
      </select></td>
    <td bgcolor="#FFFFFF"><span class="STYLE10">ѡ����Ҫ�޸ĵļ۸���</span></td>
    </tr>
    <tr><td align="right" nowrap bgcolor="#eaf5fc">ѡ��ԭ����:</td>
    <td class="setnewcss" nowrap bgcolor="#FFFFFF">
    ��<select name="primalprice">
		<%=getuserlevellist()%>
        </select>
        <select name="primalsetYear">
          <%=getbuyyearlist1()%>
        </select>
        <select name="primalpriceType">
       	  <option value="new" >����</option>
          <option value="renew" >����</option>  
    </select>�۸�</td><td bgcolor="#FFFFFF"><span class="STYLE10">���Դ�ѡ�������ļ۸���Ϊ���¼۸��<br> <span class="STYLE12">����/����</span></span></td></tr>
    <tr>
      <td align="right" nowrap bgcolor="#eaf5fc">���ü۸�:</td>
      <td nowrap bgcolor="#FFFFFF">
        <select name="operator">
          <option value="+">����</option>
          <option value="*">����</option>
        </select>
      <INPUT NAME="optValue" TYPE="text" class="inputbox" SIZE="2" MAXLENGTH="10">      </td>
      <td width="39%" bgcolor="#FFFFFF"><span class="STYLE10">
      �� <span class="STYLE12">ѡ���ԭ����</span> ���ϻ���������ֵ��<br><span class="STYLE11">�����</span>��<br>
      ���Ҫ���ĳ�۸����ѡ�� ���� 0
      </span></td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td colspan="3" align="center"><INPUT TYPE="submit" NAME="startAdjust"  VALUE="ȷ������"></td>
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
		if instr("��վ����,��������",lrs("pt_name"))=0 then
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
			ytext="�����ؼ�"
		else
			ytext=y & "��۸�"
		end if
		selectedstr=""
		if y=1 then selectedstr=" selected"
		getbuyyearlist=getbuyyearlist & "<option value="& y & selectedstr & ">"& ytext &"</option>" & vbcrlf
	next
end function
function getbuyyearlist1()
 	for y=0 to 10
		if y=0 then 
			ytext="��������"
		else
			ytext=y & "��"
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
	setYear=request.Form("setyear")'������������
	operator=Request.Form("operator")'�˳�
	optValue=Request.Form("optValue")'�۸�
	p_types=Request.Form("p_types")'��Ʒ���
	user_level=request.Form("user_level")'�û�����
	primalprice=request.Form("primalprice")'ִ�б�׼
	primalsetYear=request.Form("primalsetYear")'��׼��
	primalpriceType=request.Form("primalpriceType")'�Թ����ۻ����Ѽ�Ϊ��׼
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
						'if typeItem="new" and getPrice=0 and setYear=1 then url_return "���ܶԡ�һ��۸�����Ϊ��0��Ԫ",-1
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
			Alert_Redirect "�۸���³ɹ�",request.ServerVariables("script_name")
		end if
	end if
	rs1.close
	url_return "����ʧ��",-1
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
            <td><strong>���</strong></td>
            <td><strong>���²�Ʒ����</strong></td>
            <td><strong>�����û�����</strong></td>
           	<td><strong>���¼۸���</strong></td>
            <td><strong>���½��</strong></td>
            <td><strong>����ʱ��</strong></td>
            <td width="5%" nowrap><strong>����</strong></td>
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
            <td nowrap><%=getfomartstr(primalprice,"primalprice")&getfomartstr(primalsetYear,"setyear1")&getfomartstr(primalpriceType,"dotype")&"�۸�"&getfomartstr(operator,"operator")&optValue%></td>
            <td><%=formatDatetime(submitDate,2)%></td>
            <td nowrap>
            <%if cur=1 then%>
            <a href="####" onClick="dodel(<%=sysid%>)"><font color="blue">��ɾ����</font></a>
            <%else%>
            <font color="#666666">��ɾ����</font>
            <%end if%></td>
          </tr>
      <%
			cur=cur+1
		next
		if cur<=1 then
			%>
            <tr><td colspan="20"><font color="#666666">����û�н��й���������.�޼�¼����ʾ</font></td></tr>
            <%
		else
			%>
            <tr><td colspan="20" bgcolor="#FFFFFF"><hr><font color="#666666">
            .ֻ�ܰ�˳����ϵ��µ�ɾ��.<br>
            .ɾ���󽫶�ɾ���ļ�¼�����۸�<font color="#FF0000">���л�ԭ</font>.
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
			reStr="����"
		elseif v="renew" then
			reStr="����"
		end if
	case "setyear"
		if v<>"" then
			if v=0 then
				reStr="����۸�"
			else
				reStr=v & "��۸�"
			end if
		end if
	case "setyear1"
		if v<>"" then
			if v=0 then
				reStr="��������"
			else
				reStr=v & "��"
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
			reStr="ԭ"
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
			reStr="��"
		else
			reStr="��"
		end if
	
	end select
	getfomartstr=reStr
end function
%>
<!--#include virtual="/config/bottom_superadmin.asp" -->
