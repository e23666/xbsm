<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%Check_Is_Master(1)%>
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<%
	xmlpath=server.mappath("/database/data.xml")
	Set objMyData = Server.CreateObject("Scripting.Dictionary")
	objMyData.Add "domain_model","ҵ�����֪ͨ[������������mssql��vps����������],/mailmodel/auto_sendxf.txt"
	'objMyData.Add "domain_model","���������ʼ�֪ͨ,/mailmodel/auto_domainexpri.txt"
	'objMyData.Add "vhost_model","�������������ʼ�֪ͨ,/mailmodel/auto_hostexpri.txt"
	'objMyData.Add "mail_model","������ҵ�ʾ��ʼ�֪ͨ,/mailmodel/auto_mailexpri.txt"
	'objMyData.Add "mssql_model","����mssql���ݿ��ʼ�֪ͨ,/mailmodel/auto_mssqlexpri.txt"
	'objMyData.Add "server_model","���ڶ��������ʼ�֪ͨ,/mailmodel/auto_serverexpri.txt"
	objMyData.Add "vhost_test_model","�������������ʼ�֪ͨ,/mailmodel/auto_vhosttest.txt"
	objMyData.Add "mail_test_model","������ҵ�ʾ��ʼ�֪ͨ,/mailmodel/auto_mailtest.txt"
	objMyData.Add "sms_domain_model","����������������,/mailmodel/sms_auto_domainexpri.txt"
	objMyData.Add "sms_vhost_model","��������������������,/mailmodel/sms_auto_hostexpri.txt"
	objMyData.Add "sms_mail_model","������ҵ�ʾֶ�������,/mailmodel/sms_auto_mailexpri.txt"
	objMyData.Add "sms_mssql_model","����mssql���ݿ��������,/mailmodel/sms_auto_mssqlexpri.txt"
	objMyData.Add "sms_server_model","���ڶ���������������,/mailmodel/sms_auto_serverexpri.txt"
	objMyData.Add "sms_vhost_test_model","��������������������,/mailmodel/sms_auto_vhosttest.txt"
	objMyData.Add "sms_mail_test_model","������ҵ�ʾֶ�������,/mailmodel/sms_auto_mailtest.txt"
	objMyData.Add "forgetsub","�����һ��ʼ�֪ͨ,/mailmodel/forgetsub.txt"
	objMyData.Add "regsub","���û�ע���ʼ�֪ͨ,/mailmodel/regsub.txt"
	objMyData.Add "buyhostsucess","������ͨ�ʼ�֪ͨ,/mailmodel/buyhostsucess.txt"'������ͨ
	objMyData.Add "BuyDomainSucess","������ͨ�ʼ�֪ͨ,/mailmodel/BuyDomainSucess.txt"'������ͨ
	objMyData.Add "BuyMailSusess","�ʾֿ�ͨ�ʼ�֪ͨ,/mailmodel/BuyMailSucess.txt"
	objMyData.Add "BuyMssqlSusess","Mssql��ͨ�ʼ�֪ͨ,/mailmodel/BuyMssqlSucess.txt"
	objMyData.Add "BuyDnsDomainSusess","DNS��ͨ�ʼ�֪ͨ,/mailmodel/BuyDnsDomainSusess.txt"'dns��ͨ
	objMyData.Add "domainorderlist","�����¶����ʼ�֪ͨ,/mailmodel/domainorderlist.txt"'�����¶���
	objMyData.Add "webHostorderlist","�����¶����ʼ�֪ͨ,/mailmodel/webHostorderlist.txt"'�����¶���
	objMyData.Add "payConfirm","���֪ͨ,/mailmodel/payConfirm.txt"
	objMyData.Add "payendtomanager","���ȷ��֪ͨ,/mailmodel/payendtomanager.txt"
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
      <td width="26%" height="38">����ҵ���Ƿ������ʼ��Զ�֪ͨ:</td>
      <td width="74%" height="38"> 
        <input type=radio value=1 name="mailset" <%if mailset=1 then response.write "checked"%> onclick="dosub(this.name)" >����
    <input type=radio value=0 name="mailset" <%if mailset=0 then response.write "checked"%> onclick="dosub(this.name)" >
        �ر� <br>
        (ϵͳ���ڵ���ǰ��30,15,3��ֱ��ʼ�֪ͨ�û�����) </td>
 	
  </tr>
    <tr>
      <td width="26%">����ҵ���Ƿ����ö����Զ�֪ͨ:</td>  <td width="74%"> 
        <input type=radio value=1 name="smsset" <%if smsset=1 then response.write "checked"%> onclick="dosub(this.name)" <%=smsradiostr%>>����
    <input type=radio value=0 name="smsset" <%if smsset=0 then response.write "checked"%> onclick="dosub(this.name)" <%=smsradiostr%>>
        �ر� 
        <%if not sms_note then response.write "<font color=red>����������� ϵͳ����&gt;�ʼ��Ͷ��� ��<b>��������֪ͨ</b></font>"%>
        <br>
        ��ϵͳ���ڵ���ǰ��5�췢����֪ͨ�û�����)</td>
 	
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
  <input type="submit" value="ȷ���޸�" >
  <input type="hidden" name="act" value="modify">
  </td></tr>
  </form>
</table>
<%
set ojbMyData=nothing
set fileobj=nothing
%>