<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/regxml.asp" -->
<%Check_Is_Master(1)%>
<script language="javascript">
function dosub(v){
	var mypage=document.form1.action;
	document.form1.action=mypage+v;
	
}
function dosub1(v){
	var mypage="<%=request("script_name")%>";
	location.href=mypage+v;
	
}
function dosub2(){
	var bank_name=document.form1.bankname;
	var bank_img=document.form1.bank_img;
	var allowfile_type=document.form1.allowfiletype;
	var reg=/^[\w\(\)\_\-\.\u4e00-\u9fa5]{2,20}$/ig;
	if(!reg.test(bank_name.value)){
		alert("��Ǹ,�������Ʋ��ܺ��������ַ�!");
		bank_name.focus();
		return false;
	}
	if(bank_img.value.length<=4){
		alert("��Ǹ,���ϴ��ļ�������ύ!");
		document.frames.item('iFrame1').document.upfileform.file1.focus();
		return false;
	}
	document.form1.action +="?str=addbank";
	document.form1.submit();
	document.form1.addbankbutton.value="...���ڲ���...";
	document.form1.addbankbutton.disabled=true;
}
</script>
<%
	xmlpath=server.MapPath("/database/data.xml")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	str=trim(requesta("str"))
	getid=trim(requesta("id"))
	if str="addbank" then 
		addbank()
	elseif str="banknamedel" then
		delbank()
	end if
	set myobjNode = isNodes("bankcount","",xmlpath,0,objDoms)
select case str
	case "par"
	
		nodelength=myobjNode.childNodes.length
		partitle=trim(requesta("partitle"))
		if partitle<>"" then
			set element= objDoms.createelement("bankitem")
			myobjNode.appendChild element
			element.setAttribute "id",round(timer())&"_"&nodelength
			element.setAttribute "parid","0"
			element.setAttribute "title",partitle
			element.setAttribute "logo",""
			element.setAttribute "bankname",""
			element.setAttribute "bankcode",""
			element.setAttribute "banknum",""
			element.setAttribute "account",""
			objDoms.save(xmlpath)
			set myobjNode=nothing
			set objDoms=nothing
			response.redirect request("script_name")
		else
			url_return "���벻��Ϊ��",-1
		end if
		response.end
	case "item"
		nodelength=myobjNode.childNodes.length
		parid=trim(requesta("parid"))
		title=trim(requesta("title"&trim(parid)))
		logo=trim(requesta("logo"&trim(parid)))
		bankname=trim(requesta("bankname"&trim(parid)))
		bankcode=trim(requesta("bankcode"&trim(parid)))
		banknum=trim(requesta("banknum"&trim(parid)))
		account=trim(requesta("account"&trim(parid)))

		if parid<>"" then
			set element= objDoms.createelement("bankitem")
			myobjNode.appendChild element
			element.setAttribute "id",round(timer())&"_"&nodelength
			element.setAttribute "parid",parid
			element.setAttribute "title",title
			element.setAttribute "logo",logo
			element.setAttribute "bankname",bankname
			element.setAttribute "bankcode",bankcode
			element.setAttribute "banknum",banknum
			element.setAttribute "account",account
			objDoms.save(xmlpath)
			set myobjNode=nothing
			set objDoms=nothing
			response.redirect request("script_name")
		else
			url_return "�д���,ʧ��",-1
		end if
		response.end
	case "edit"
		title=trim(requesta("etitle"))
		logo=trim(requesta("elogo"&trim(getid)))
		bankname=trim(requesta("ebankname"))
		bankcode=trim(requesta("ebankcode"))
		banknum=trim(requesta("ebanknum"))
		account=trim(requesta("eaccount"))
		if getid<>"" then
			for each itemNode in myobjNode.childNodes
				setid=itemNode.Attributes.getNamedItem("id").nodeValue
				if trim(setid)=trim(getid) then
					itemNode.setAttribute "title",title
					itemNode.setAttribute "logo",logo
					itemNode.setAttribute "bankname",bankname
					itemNode.setAttribute "bankcode",bankcode
					itemNode.setAttribute "banknum",banknum
					itemNode.setAttribute "account",account
					objDoms.save(xmlpath)
					set myobjNode=nothing
					set objDoms=nothing
					response.redirect request("script_name")
					exit for
				end if
			next

		else
			url_return "�д���,ʧ��",-1
		end if
		response.end
	case "del"
		if getid<>"" then
			for each itemNode in myobjNode.childNodes
				setid=itemNode.Attributes.getNamedItem("id").nodeValue
				setparid=itemNode.Attributes.getNamedItem("parid").nodeValue
				if trim(setid)=trim(getid) or (trim(setparid)=trim(getid) and trim(setparid)<>"0") then
					myobjNode.removeChild itemNode
					
					
				end if
			next
					objDoms.save(xmlpath)
					set myobjNode=nothing
					set objDoms=nothing
					response.redirect request("script_name")
		
		else
			url_return "�д���,ʧ��",-1		
		end if
		response.end
	case "paredit"
		
			title=trim(requesta("epartitle"))
			if getid<>"" then
				for each itemNode in myobjNode.childNodes
					setid=itemNode.Attributes.getNamedItem("id").nodeValue
					if trim(setid)=trim(getid) then
						itemNode.setAttribute "title",title
						objDoms.save(xmlpath)
						set myobjNode=nothing
						set objDoms=nothing
						response.redirect request("script_name")
						exit for
					end if
				next
	
			else
				url_return "�д���,ʧ��",-1
			end if
		
		response.end
end select	

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>ϵ ͳ �� ��</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1">
  <form name=form1 action="<%=request("script_name")%>" method="post">
    <%for each itemNode in myobjNode.childNodes
		rootid=itemNode.Attributes.getNamedItem("id").nodeValue'id
		roottitle=itemNode.Attributes.getNamedItem("title").nodeValue'����
		rootparid=itemNode.Attributes.getNamedItem("parid").nodeValue'ʵ��id
		'''''''''''''''''''''''''''''''
		if trim(rootparid)="0" then
		
		if str="paredititem" and getid=trim(rootid) then
		%>
    <tr>
      <td class="topbg"><input type=text value="<%=roottitle%>" name="epartitle">
        &nbsp;<a href=#### onClick="javascript:dosub('?str=paredit&id=<%=rootid%>');document.form1.submit();"><font color="#FFFFFF">ȷ��</font></a>&nbsp;<a href=#### onClick="dosub1('')"><font color="#FFFFFF">ȡ��</font></a> </td>
    </tr>
    <%
		else
	%>
    <tr>
      <td><br>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
          <tr>
            <td class="topbg"><strong><%=roottitle%></strong></td>
            <td align="right" class="topbg"><a href=#### onClick="dosub1('?str=paredititem&id=<%=rootid%>')"><font color="#FFFFFF">�༩</font></a>&nbsp;<a href=#### onClick="javascript:if(confirm('ȷ��ɾ����?\nɾ��ʱ����С��һ��ɾ��')){dosub1('?str=del&id=<%=rootid%>');}"><font color="#FFFFFF">ɾ��</font></a> </td>
          </tr>
        </table></td>
    </tr>
    <%
	  end if
	  %>
    <tr>
      <td class="tdbg"><table width="100%" border="0" cellpadding="2" cellspacing="1" class="border">
          <tr align="center" bgcolor="#D4D0C8">
            <td width="16%" class="Title"><strong>������</strong></td>
            <td width="18%" class="Title"><strong>ͼƬlogo</strong></td>
            <td width="17%" class="Title"><strong>��ַ</strong></td>
            <td width="17%" class="Title"><strong>�ʱ�</strong></td>
            <td width="23%" class="Title"><strong>�����˺�</strong></td>
            <td width="19%" class="Title"><strong>�˻���</strong></td>
            <td width="7%" class="Title"><strong>����</strong></td>
          </tr>
          <%
			
			for each itemNode1 in myobjNode.childNodes
				id=itemNode1.Attributes.getNamedItem("id").nodeValue'id
				title=itemNode1.Attributes.getNamedItem("title").nodeValue'����
				parid=itemNode1.Attributes.getNamedItem("parid").nodeValue'ʵ��id
				'''''''''''''''''''''''''''''''
				logo=itemNode1.Attributes.getNamedItem("logo").nodeValue'ͼƬ
				bankname=itemNode1.Attributes.getNamedItem("bankname").nodeValue'��������
				bankcode=itemNode1.Attributes.getNamedItem("bankcode").nodeValue'�����ʱ�
				banknum=itemNode1.Attributes.getNamedItem("banknum").nodeValue'�˺�
				account=itemNode1.Attributes.getNamedItem("account").nodeValue'�˻���
				
				if trim(parid)<>"0" and parid=rootid then
					if str="edititem" and getid=trim(id) then
					%>
          <tr bgcolor="#FFFFFF">
            <td bgcolor="#FFFFFF" class="tdbg"><input name="etitle" type="text" size=10 value="<%=trim(title)%>"></td>
            <td bgcolor="#FFFFFF" class="tdbg"><select name="elogo<%=trim(id)%>"  onchange="javascript:document.getElementById('ebankimg<%=trim(id)%>').src=this.value;">
                <option value="\images\banklogo\bank_1.gif" <%if instr(logo,"bank_1.gif")>0 then response.write "selected"%>>�й���������</option>
                <option value="\images\banklogo\bank_2.gif" <%if instr(logo,"bank_2.gif")>0 then response.write "selected"%>>�й���������</option>
                <option value="\images\banklogo\bank_3.gif" <%if instr(logo,"bank_3.gif")>0 then response.write "selected"%>>�й���������</option>
                <option value="\images\banklogo\bank_4.gif" <%if instr(logo,"bank_4.gif")>0 then response.write "selected"%>>�й�ũҵ����</option>
                <option value="\images\banklogo\bank_6.gif" <%if instr(logo,"bank_6.gif")>0 then response.write "selected"%>>�Ϻ���չ����</option>
                <option value="\images\banklogo\bank_7.gif" <%if instr(logo,"bank_7.gif")>0 then response.write "selected"%>>�й���������</option>
                <option value="\images\banklogo\bank_09.gif" <%if instr(logo,"bank_09.gif")>0 then response.write "selected"%>>���ڷ�չ����</option>
                <option value="\images\banklogo\bank_13.gif" <%if instr(logo,"bank_13.gif")>0 then response.write "selected"%>>�й���ͨ����</option>
                <option value="\images\banklogo\bank_12.gif" <%if instr(logo,"bank_12.gif")>0 then response.write "selected"%>>��ҵ����</option>
                <option value="\image\banklogo\bank_Logo_1.gif" <%if instr(logo,"bank_1.gif")>0 then response.write "selected"%>>�й�����</option>
                <%
			set mybankNodes = isNodes("bankNameCode","",xmlpath,0,objDoms)
			for each itemNode2 in mybankNodes.childNodes
				bankname=itemNode2.Attributes.getNamedItem("bankname").nodeValue'id
				bankimg=itemNode2.Attributes.getNamedItem("bankimg").nodeValue'����
				%>
                <option value="<%=bankimg%>" <%if instr(logo,bankimg)>0 then response.write "selected"%>><%=bankname%></option>
                <%
			next
			set mybankNodes=nothing
			%>
              </select>
              <img id="ebankimg<%=trim(id)%>" src="<%=logo%>" border=0> </td>
            <td bgcolor="#FFFFFF" class="tdbg"><input name="ebankname" type="text" size=12 value="<%=trim(bankname)%>"></td>
            <td bgcolor="#FFFFFF" class="tdbg"><input name="ebankcode" type="text" size=10 value="<%=trim(bankcode)%>"></td>
            <td bgcolor="#FFFFFF" class="tdbg"><input name="ebanknum" type="text" size=12 value="<%=trim(banknum)%>"></td>
            <td bgcolor="#FFFFFF" class="tdbg"><input name="eaccount" type="text" size=10 value="<%=trim(account)%>"></td>
            <td nowrap="nowrap" bgcolor="#FFFFFF" class="tdbg"><a href=#### onClick="javascript:dosub('?str=edit&id=<%=id%>');document.form1.submit();">ȷ��</a>&nbsp;<a href=#### onClick="dosub1('')">ȡ��</a></td>
          </tr>
          <tr>
            <td colspan=7 background="/manager/images/style/bg_dot.gif" height="1"></td>
          </tr>
          <%
                    else
					
			%>
          <tr bgcolor="#FFFFFF">
            <td bgcolor="#FFFFFF" class="tdbg"><%=title%></td>
            <td bgcolor="#FFFFFF" class="tdbg"><img border=0 src="<%=logo%>"></td>
            <td bgcolor="#FFFFFF" class="tdbg"><%=bankname%></td>
            <td bgcolor="#FFFFFF" class="tdbg"><%=bankcode%></td>
            <td bgcolor="#FFFFFF" class="tdbg"><%=banknum%></td>
            <td bgcolor="#FFFFFF" class="tdbg"><%=account%></td>
            <td nowrap="nowrap" bgcolor="#FFFFFF" class="tdbg"><a href=#### onClick="dosub1('?str=edititem&id=<%=id%>')">�༩</a>&nbsp;<a href=#### onClick="javascript:if(confirm('ȷ��ɾ����?')){dosub1('?str=del&id=<%=id%>');}">ɾ��</a></td>
          </tr>
          <tr>
            <td colspan=7 background="/manager/images/style/bg_dot.gif" height="1"></td>
          </tr>
          <%		end if
				end if
			next
			%>
          <tr align="center" bgcolor="#efefef">
            <td><input name="title<%=trim(rootid)%>" value="" type=text size="10"></td>
            <td nowrap="nowrap"><select name="logo<%=trim(rootid)%>"  onchange="javascript:document.getElementById('bankimg<%=trim(rootid)%>').src=this.value;">
                <option value="\images\banklogo\bank_1.gif">�й���������</option>
                <option value="\images\banklogo\bank_2.gif">�й���������</option>
                <option value="\images\banklogo\bank_3.gif">�й���������</option>
                <option value="\images\banklogo\bank_4.gif">�й�ũҵ����</option>
                <option value="\images\banklogo\bank_7.gif">�й���������</option>
                <option value="\images\banklogo\bank_13.gif">�й���ͨ����</option>
                <option value="\images\banklogo\bank_6.gif">�Ϻ���չ����</option>
                <option value="\images\banklogo\bank_09.gif">���ڷ�չ����</option>
                <option value="\images\banklogo\bank_12.gif">��ҵ����</option>
                <option value="\images\banklogo\bank_Logo_1.gif">�й�����</option>
                <%
			set mybankNodes = isNodes("bankNameCode","",xmlpath,0,objDoms)
			for each itemNode2 in mybankNodes.childNodes
				bankname=itemNode2.Attributes.getNamedItem("bankname").nodeValue'id
				bankimg=itemNode2.Attributes.getNamedItem("bankimg").nodeValue'����
				%>
                <option value="<%=bankimg%>" <%if instr(logo,bankimg)>0 then response.write "selected"%>><%=bankname%></option>
                <%
			next
			set mybankNodes=nothing
			%>
              </select>
              <img id="bankimg<%=trim(rootid)%>" src="\images\banklogo\bank_1.gif" border=0> </td>
            <td><input name="bankname<%=trim(rootid)%>" value="" type=text size="12"></td>
            <td><input name="bankcode<%=trim(rootid)%>" value="" type=text size="10"></td>
            <td><input name="banknum<%=trim(rootid)%>" value="" type=text size="12"></td>
            <td><input name="account<%=trim(rootid)%>" value="" type=text size="10"></td>
            <td><input name="mysubmit1<%=trim(rootid)%>" type="submit" value="���" onClick="dosub('?str=item&parid=<%=rootid%>')"></td>
          </tr>
        </table></td>
    </tr>
    <%end if%>
    <%next%>
    <tr bgcolor="#FFFFFF">
      <td><table border="0" cellpadding="3" cellspacing="1">
          <tr>
            <td valign="top"><table border="0" cellpadding="3" cellspacing="1" class="border">
                <tr>
                  <td colspan=3 class="Title"><strong>��Ӵ���</strong></td>
                </tr>
                <tr bgcolor="#FFFFFF">
                  <td nowrap="nowrap" bgcolor="#FFFFFF" class="tdbg"><strong>�������</strong></td>
                  <td bgcolor="#FFFFFF" class="tdbg"><input type=text name="partitle"></td>
                  <td bgcolor="#FFFFFF" class="tdbg"><input type="submit" name="mysubmit2" value="���" onClick="dosub('?str=par')"></td>
                </tr>
              </table></td>
            <td valign="top"><table border="0" cellpadding="3" cellspacing="1" class="border">
                <tr>
                  <td colspan=3 class="Title"><strong>�������</strong></td>
                </tr>
                <tr bgcolor="#FFFFFF">
                  <td nowrap="nowrap" bgcolor="#FFFFFF" ><strong>��������:</strong></td>
                  <td bgcolor="#FFFFFF"><input type=text name="bankname"></td>
                </tr>
                <tr bgcolor="#FFFFFF">
                  <td nowrap="nowrap" bgcolor="#FFFFFF"><strong>����ͼƬ:</strong></td>
                  <td bgcolor="#FFFFFF" ><iframe id="iFrame1" name="iFrame1" src="/manager/question/upload_file.asp?inputobj=bank_img&filesize=1&fileName=<%="bank"& round(timer(),0)%>&filePath=<%=server.URLEncode("/images/banklogo")%>" align="left" frameborder="0" width="300" height="25" scrolling="no"></iframe>
                    <input type="hidden" name="bank_img" value="">
                  </td>
                </tr>
                <tr>
                  <td colspan=3 align="center" ><input type="button" value="ȷ�����" name="addbankbutton" onclick="dosub2()">
                  </td>
                </tr>
                <tr>
                  <td colspan=3 background="/manager/images/style/bg_dot.gif" height="1"></td>
                </tr>
                <tr>
                  <td colspan="3"><table width="100%" border="0" cellpadding="3" cellspacing="1" class="border">
                      <%
                set mybankNodes = isNodes("bankNameCode","",xmlpath,0,objDoms)
				for each itemNode2 in mybankNodes.childNodes
                    bankname=itemNode2.Attributes.getNamedItem("bankname").nodeValue
                    bankimg=itemNode2.Attributes.getNamedItem("bankimg").nodeValue
					id=itemNode2.Attributes.getNamedItem("id").nodeValue'id
				%>
                      <tr>
                        <td width="26%"><%=bankname%></td>
                        <td width="65%"><img border="0" src="<%=bankimg%>"></td>
                        <td width="9%" nowrap><a href=#### onClick="javascript:if(confirm('ȷ��ɾ����?')){dosub1('?str=banknamedel&id=<%=id%>');}">[ɾ��]</a></td>
                      </tr>
                      <tr>
                        <td colspan=3 background="/manager/images/style/bg_dot.gif" height="1"></td>
                      </tr>
                      <%
				next
				set mybankNodes=nothing 
				%>
                    </table></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </form>
</table>
<%
set myobjNode=nothing
set objDoms=nothing
sub addbank()
		bankname=requesta("bankname")
		bankimg=requesta("bank_img")
		if len(bankname)=0 then Alert_Redirect "��Ǹ,�������Ʋ���Ϊ��",request("script_name")
		if len(bankimg)=0 then Alert_Redirect "��Ǹ,���ϴ�����ͼƬ",request("script_name")
		set myobjNode = isNodes("bankNameCode","",xmlpath,0,objDoms)
			nodelength=myobjNode.childNodes.length
			set element= objDoms.createelement("bankNameitem")
			myobjNode.appendChild element
			element.setAttribute "id",round(timer())&"_"&nodelength
			element.setAttribute "bankname",bankname
			element.setAttribute "bankimg",bankimg
			objDoms.save(xmlpath)
			set element=nothing
			set myobjNode=nothing
			set objDoms=nothing
			response.redirect request("script_name")
			response.end
end sub
sub delbank()
	getid=trim(requesta("id"))
	if len(getid)>0 then
			set myobjNode = isNodes("bankNameCode","",xmlpath,0,objDoms)
			for each itemNode in myobjNode.childNodes
				setid=itemNode.Attributes.getNamedItem("id").nodeValue
				if trim(setid)=trim(getid) then
					bankimg=itemNode.Attributes.getNamedItem("bankimg").nodeValue
					myobjNode.removeChild itemNode
						Set fileobj=server.CreateObject("Scripting.filesystemobject")
						if len(bankimg)>0 and fileobj.fileExists(server.MapPath(bankimg)) then
							fileobj.deletefile server.MapPath(bankimg),true
						end if
						set fileobj=nothing
					exit for
				end if
			next
					objDoms.save(xmlpath)
					set myobjNode=nothing
					set objDoms=nothing
					Alert_Redirect "ɾ���ɹ�!",request("script_name")
					response.end
	end if
end sub
%>
</body>
</html>
