<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%Check_Is_Master(1)%>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<%
	xmlpath=server.mappath("/database/data.xml")
	Set objMyData = Server.CreateObject("Scripting.Dictionary")
	objMyData.Add "domain_model","业务过期通知[域名、主机、mssql、vps、云主机等],/mailmodel/auto_sendxf.txt"
	'objMyData.Add "domain_model","过期域名邮件通知,/mailmodel/auto_domainexpri.txt"
	'objMyData.Add "vhost_model","过期虚拟主机邮件通知,/mailmodel/auto_hostexpri.txt"
	'objMyData.Add "mail_model","过期企业邮局邮件通知,/mailmodel/auto_mailexpri.txt"
	'objMyData.Add "mssql_model","过期mssql数据库邮件通知,/mailmodel/auto_mssqlexpri.txt"
	'objMyData.Add "server_model","过期独立主机邮件通知,/mailmodel/auto_serverexpri.txt"
	objMyData.Add "vhost_test_model","试用虚拟主机邮件通知,/mailmodel/auto_vhosttest.txt"
	objMyData.Add "mail_test_model","试用企业邮局邮件通知,/mailmodel/auto_mailtest.txt"
	objMyData.Add "sms_domain_model","过期域名短信内容,/mailmodel/sms_auto_domainexpri.txt"
	objMyData.Add "sms_vhost_model","过期虚拟主机短信内容,/mailmodel/sms_auto_hostexpri.txt"
	objMyData.Add "sms_mail_model","过期企业邮局短信内容,/mailmodel/sms_auto_mailexpri.txt"
	objMyData.Add "sms_mssql_model","过期mssql数据库短信内容,/mailmodel/sms_auto_mssqlexpri.txt"
	objMyData.Add "sms_server_model","过期独立主机短信内容,/mailmodel/sms_auto_serverexpri.txt"
	objMyData.Add "sms_vhost_test_model","试用虚拟主机短信内容,/mailmodel/sms_auto_vhosttest.txt"
	objMyData.Add "sms_mail_test_model","试用企业邮局短信内容,/mailmodel/sms_auto_mailtest.txt"
	objMyData.Add "forgetsub","密码找回邮件通知,/mailmodel/forgetsub.txt"
	objMyData.Add "regsub","新用户注册邮件通知,/mailmodel/regsub.txt"
	objMyData.Add "buyhostsucess","主机开通邮件通知,/mailmodel/buyhostsucess.txt"'主机开通
	objMyData.Add "BuyDomainSucess","域名开通邮件通知,/mailmodel/BuyDomainSucess.txt"'域名开通
	objMyData.Add "BuyMailSusess","邮局开通邮件通知,/mailmodel/BuyMailSucess.txt"
	objMyData.Add "BuyMssqlSusess","Mssql开通邮件通知,/mailmodel/BuyMssqlSucess.txt"
	objMyData.Add "BuyDnsDomainSusess","DNS开通邮件通知,/mailmodel/BuyDnsDomainSusess.txt"'dns开通
	objMyData.Add "domainorderlist","域名下订单邮件通知,/mailmodel/domainorderlist.txt"'域名下订单
	objMyData.Add "webHostorderlist","主机下订单邮件通知,/mailmodel/webHostorderlist.txt"'主机下订单
	objMyData.Add "payConfirm","入款通知,/mailmodel/payConfirm.txt"
	objMyData.Add "payendtomanager","汇款确认通知,/mailmodel/payendtomanager.txt"
	set fileobj=server.createobject("scripting.filesystemobject")
act=trim(requesta("act"))
if act="modify" then
	for curi = 1 to Request.form.count
		modelkey=trim(Request.form.key(curi))
		if objMydata.exists(modelkey) then
			dataArray=split(objMydata.item(modelkey),",")
			dataname=dataArray(0)
			modelpath=dataArray(1)
			
			modelvalue=trim(Request.form(modelkey))
			
			if modelvalue<>"" then
				pa=server.mappath(modelpath)
				if fileObj.fileExists(pa) then
					set middel_hand=fileobj.opentextfile(pa,1,false)
						oldcontent=middel_hand.readall()
						if trim(modelvalue)<>trim(oldcontent) then
							 Set OutStream =fileobj.OpenTextFile(pa, 2, True)
							  OutStream.Writeline modelvalue
							 set OutStream=nothing
						end if
					set middel=nothing
				end if
			end if
		end if
	next
	set fileobj=nothing
	set objMydata=nothing
	response.redirect request("script_name")
	response.end
elseif act="chg" then
	n=requesta("n")
	v=requesta(n)
	if len(v)>0 then
		call updatenoteSet(n,v)
	end if
	response.Redirect(request("script_name"))
	response.end
end if
function updatenoteSet(byval nottype,byval v)
	
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	set myobject=isnodes("pageset","noteset",xmlpath,1,objDoms)
	set mytype=myobject.selectSingleNode("@"& nottype)
	if mytype is nothing then
			myobject.setAttribute nottype,v
			objDoms.save(xmlpath)
	end if
	set mytype=nothing
		myobject.setAttribute nottype,v
		objDoms.save(xmlpath)

	set myobject=nothing
	set objDoms=nothing
end function

set objDoms=Server.CreateObject("Microsoft.XMLDOM")
set myobject=isnodes("pageset","noteset",xmlpath,1,objDoms)
set mytype=myobject.selectSingleNode("@mailset")
if mytype is nothing then
		myobject.setAttribute "mailset",1
		objDoms.save(xmlpath)
end if
set mytype=nothing
set myprice=myobject.selectSingleNode("@smsset")
if myprice is nothing then
	myobject.setAttribute "smsset",0
	objDoms.save(xmlpath)
end if
smsradiostr=""
if not sms_note then myobject.setAttribute "smsset",0:objDoms.save(xmlpath):smsradiostr="disabled=""disabled"""
set myprice=nothing
mailset=myobject.attributes.getNamedItem("mailset").nodeValue
smsset=myobject.attributes.getNamedItem("smsset").nodeValue

set myobject=nothing
set objDoms=nothing
%>
<script language="javascript">
function dosub(n){
	document.form1.action +='?act=chg&n=' + n;
	document.form1.submit();
}
function docarry(v){
	

		var list=document.getElementsByTagName("textarea");

        for(var i=0;i<list.length && list[i];i++)
        {
              
                 list[i].style.overflow="auto";
				list[i].style.background="#cccccc";
          
        } 
		v.style.overflow="visible";
		v.style.background="#ffffff";
}
</script>
<table width="100%" border="1" cellspacing="0" cellpadding="4" bordercolor="#006699" bordercolordark="#ffffff">
<form name="form1" action="<%=request("script_name")%>" method=post>
  
  <tr>
      <td width="26%" height="38">过期业务是否启用邮件自动通知:</td>
      <td width="74%" height="38"> 
        <input type=radio value=1 name="mailset" <%if mailset=1 then response.write "checked"%> onclick="dosub(this.name)" >启用
    <input type=radio value=0 name="mailset" <%if mailset=0 then response.write "checked"%> onclick="dosub(this.name)" >
        关闭 <br>
        (系统将在到期前第30,15,3天分别发邮件通知用户续费) </td>
 	
  </tr>
    <tr>
      <td width="26%">过期业务是否启用短信自动通知:</td>  <td width="74%"> 
        <input type=radio value=1 name="smsset" <%if smsset=1 then response.write "checked"%> onclick="dosub(this.name)" <%=smsradiostr%>>启用
    <input type=radio value=0 name="smsset" <%if smsset=0 then response.write "checked"%> onclick="dosub(this.name)" <%=smsradiostr%>>
        关闭 
        <%if not sms_note then response.write "<font color=red>如果设置请在 系统设置&gt;邮件和短信 里<b>开启短信通知</b></font>"%>
        <br>
        （系统将在到期前第5天发短信通知用户续费)</td>
 	
  </tr>
 
  <%
  cur=1
  for each mydata in objMyData
	
	if objMydata.exists(mydata) then
		datavalue=objMyData.item(mydata)
		datavaluelist=split(datavalue,",")
		if ubound(datavaluelist)>0 then
			dataName=datavaluelist(0)
			modelcontent=datavaluelist(1)
			if modelcontent<>"" then
				modelcontent=server.mappath(modelcontent)
				if fileObj.fileExists(modelcontent) then
					set middel_hand=fileobj.opentextfile(modelcontent,1,false)
					content_model=middel_hand.readall()
					trcolor="#ffffff"
					if cur mod 2 =0 then trcolor="#efefef"
				
	  %>
	  <tr bgcolor="<%=trcolor%>">
		<td nowrap colspan=3><span style="color: #0066cc; font-weight: bold; font-size: 16px"><%=dataName%>:</span><br>
		<textarea name="<%=mydata%>" rows="7" style="width:100%;overflow:hidden;overflow:auto; background: #C0C0C0;"  onclick="docarry(this)"><%=content_model%></textarea>		</td>
    </tr>
	  <%			set middel_hand=nothing
	  				cur=cur+1
				end if
			end if
  	end if
	end if
	
  next
  %>
  <tr><td colspan=3>
  <input type="submit" value="确定修改" >
  <input type="hidden" name="act" value="modify">
  </td></tr>
  </form>
</table>
<%
set ojbMyData=nothing
set fileobj=nothing
%>