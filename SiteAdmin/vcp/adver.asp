<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
  <script language="JavaScript">
      function dochecked(e,id){
	  	var v;
	  	e.checked?v=1:v=0;
			document.form1.action +='?str=check&getid='+id+'&start='+v;
			document.form1.submit();
			
	  } 
	  
  </script>
<%
function Alert_Redirect1(this_url)
%>
  <script language="JavaScript">
        window.location='<%=this_url%>';
  </script>
<%
  response.end
end function
function isNodes(rootNodes,nodesname,xmlpath,getRoot,byref objDoms)'�жϽڵ�治����,�����ھʹ���(���ڵ�,�ӽڵ�,xml�ļ�λ��,true/false�Ƿ�õ��Ӷ���,���صĶ���),���õ����ڵ����
	'xmlpath=server.mappath("/config/data.xml")
		p="n"
		objDoms.async = false
		objDoms.load(xmlpath)
		if objDoms.ParseError.ErrorCode = 0 then
			 Set objroot = objDoms.documentElement
			 set myrootnodes=objDoms.selectSingleNode("//"& rootNodes)
			 if myrootnodes is nothing then
			 	set rootelement= objDoms.createelement(rootNodes)
				objroot.appendChild rootelement
				set myrootnodes=rootelement
				p="y"
			 end if
			  if trim(nodesname)<>"" then 
			 	  set mynodes=myrootnodes.selectSingleNode(trim(nodesname))
				  if mynodes is Nothing  then 
					'�ڵ㲻���ھͽ�
					set mynodes= objDoms.createelement(trim(nodesname))
					myrootnodes.appendChild mynodes
					
					p="y"
				  end if 
				  if getRoot then
					set isNodes=mynodes
					
				  else
					set isNodes=myrootnodes
				  end if
			  else
			  	set isNodes=myrootnodes
			  end if
			  if p="y" then
			  	objDoms.save(xmlpath)
			  end if
	  else
	 	Response.Write objDoms.ParseError.Reason
	  end if

end function
	xmlpath=server.MapPath(InstallDir&"database/data.asp")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	str=trim(requesta("str"))
	getid=trim(requesta("getid"))
	set myobjNode = isNodes("advers","",xmlpath,0,objDoms)
	select case str
		case "add"
		nodelength=myobjNode.childNodes.length
		content=server.htmlEncode(trim(requesta("content")))
		path=server.htmlEncode(trim(requesta("path")))
		url=server.htmlEncode(trim(requesta("url")))
		height=trim(requesta("height"))
		width=trim(requesta("width"))
		start=trim(requesta("astart"))
		mark=trim(requesta("mark"))
		if start="" then start=0
		if path<>"" then
			set element= objDoms.createelement("aditem")
			myobjNode.appendChild element
			element.setAttribute "id",round(timer())&"_"&nodelength
			element.setAttribute "content",content
			element.setAttribute "path",path
			element.setAttribute "url",url
			element.setAttribute "height",height
			element.setAttribute "width",width
			element.setAttribute "mark",mark
			element.setAttribute "start",start
			objDoms.save(xmlpath)
			set myobjNode=nothing
			set objDoms=nothing
			Alert_Redirect1 request("script_name")
		else
			url_return "���벻��Ϊ��",-1
		end if
		response.end
		case "edit"
			content=server.Htmlencode(trim(requesta("econtent")))
			path=server.htmlEncode(trim(requesta("epath")))
			url=server.htmlEncode(trim(requesta("eurl")))
			height=trim(requesta("eheight"))
			width=trim(requesta("ewidth"))
			mark=trim(requesta("emark"))
			start=trim(requesta("estart"))
			if start="" then start=0

			if getid<>"" then
				for each itemNode in myobjNode.childNodes
					setid=itemNode.Attributes.getNamedItem("id").nodeValue
					if trim(setid)=trim(getid) then
						itemNode.setAttribute "content",content
						itemNode.setAttribute "path",path
						itemNode.setAttribute "url",url
						itemNode.setAttribute "height",height
						itemNode.setAttribute "width",width
						itemNode.setAttribute "mark",mark
						itemNode.setAttribute "start",start
						
						objDoms.save(xmlpath)
						set myobjNode=nothing
						set objDoms=nothing
						Alert_Redirect1 request("script_name")
						exit for
					end if
				next
	
			else
				url_return "�д���,ʧ��",-1
			end if
			response.end
		case "check"	
			if getid<>"" then
			start=trim(requesta("start"))
			if start="" then start=0
				for each itemNode in myobjNode.childNodes
					setid=itemNode.Attributes.getNamedItem("id").nodeValue
					if trim(setid)=trim(getid) then
						itemNode.setAttribute "start",start
						
						objDoms.save(xmlpath)
						set myobjNode=nothing
						set objDoms=nothing
						Alert_Redirect1 request("script_name")
						exit for
					end if
				next
			end if
		case "del"
			if getid<>"" then
				for each itemNode in myobjNode.childNodes
					setid=itemNode.Attributes.getNamedItem("id").nodeValue
					if trim(setid)=trim(getid) then
						myobjNode.removeChild itemNode
					end if
				next
					objDoms.save(xmlpath)
					set myobjNode=nothing
					set objDoms=nothing
					Alert_Redirect1 request("script_name")
		
			else
				url_return "�д���,ʧ��",-1		
			end if
			response.end
	end select
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>VCPģʽ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="vcp_newautoSettle.asp">�Զ�����</a> | <a href="adver.asp">������</a> | <a href="settlelist.asp">�鿴����¼</a></td>
  </tr>
</table> <br>

<table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolordark="#ffffff" class="border">
<form name=form1 action="<%=request("script_name")%>" method=post>
<tr align="center" class="Title">
<td><span class="STYLE1"><strong>��ʶ</strong></span></td>
<td><span class="STYLE1"><strong>ͼƬλ��</strong></span></td>
<td><span class="STYLE1"><strong>����λ��</strong></span></td>
<td><span class="STYLE1"><strong>Ĭ�Ͽ��</strong></span></td>
<td><span class="STYLE1"><strong>Ĭ�ϸ߶�</strong></span></td>
<td><span class="STYLE1"><strong>˵��</strong></span></td>
<td><span class="STYLE1"><strong>����</strong></span></td>
<td><span class="STYLE1"><strong>����</strong></span></td>
</tr>
<%
for each itemNode in myobjNode.childNodes
		id=trim(itemNode.Attributes.getNamedItem("id").nodeValue)'id
		mark=trim(itemNode.Attributes.getNamedItem("mark").nodeValue)'˵��
		content=trim(itemNode.Attributes.getNamedItem("content").nodeValue)'��ʶ
		path=itemNode.Attributes.getNamedItem("path").nodeValue'id
		url=itemNode.Attributes.getNamedItem("url").nodeValue
		height=itemNode.Attributes.getNamedItem("height").nodeValue'ʵ��id
		width=itemNode.Attributes.getNamedItem("width").nodeValue'ʵ��id
		start=itemNode.Attributes.getNamedItem("start").nodeValue'ʵ��id
		if start="" then start=0
		'''''''''''''''''''''''''''''''
	if str="edit1" and getid=id then
	%>
    <tr>
    <td class="tdbg"><input name="econtent" type=text value="<%=content%>" size="10"></td>  
    <td class="tdbg"><input type=text value="<%=path%>" name="epath"></td>
    <td class="tdbg"><input type=text value="<%=url%>" name="eurl"></td>
    <td class="tdbg"><input name="ewidth" type=text value="<%=width%>" size="10"></td>
    <td class="tdbg"><input name="eheight" type=text value="<%=height%>" size="10"></td>
    <td class="tdbg"><input type=text value="<%=mark%>" name="emark"></td>
    <td class="tdbg"><input type="checkbox" value="1" <%if start then response.write "checked"%> name="estart"></td>
    <td class="tdbg">
    <input type="submit" value="ȷ��" onClick="javascript:this.form.action +='?str=edit&getid=<%=id%>'">&nbsp;
    <input type="button" value="ȡ��" onClick="javascript:location.href='<%=request("script_name")%>'">    </td>
    </tr>
    <%
	else
		%>
       
<tr>
<td class="tdbg"><%=content%>&nbsp;</td>
<td class="tdbg"><%=right(path,15)%>..&nbsp;</td>
<td class="tdbg"><%=url%>&nbsp;</td>
<td class="tdbg"><%=width%>&nbsp;</td>
<td class="tdbg"><%=height%>&nbsp;</td>
<td class="tdbg"><%=mark%>&nbsp;</td>
<td class="tdbg"><input type="checkbox" name="start" onClick="javascript:dochecked(this,'<%=id%>')" value=1  <%if start then response.write "checked"%>>&nbsp;</td>
<td class="tdbg">
<input type="button" value="�޸�" onClick="javascript:location.href='<%=request("script_name")%>?str=edit1&getid=<%=id%>'">
<input type="button" value="ɾ��" onClick="javascript:if(confirm('ȷ��ɾ����?')){location.href='<%=request("script_name")%>?str=del&getid=<%=id%>';}"></td>
</tr>
 <%
 	end if
next 
 %>
<tr bgcolor="#CCFFFF">
<td class="tdbg"><input name="content" type="text" size="10"></td>
<td class="tdbg"><input type="text" name="path" value="<%=companynameurl%>/vcp/vcp_img/"></td>
<td class="tdbg"><input type="text" name="url" value="<%=companynameurl%>"></td>
<td class="tdbg"><input name="width" type="text" size="10"></td>
<td class="tdbg"><input name="height" type="text" size="10"></td>
<td class="tdbg"><input type="text" name="mark"></td>
<td class="tdbg"><input type="checkbox" name="astart" value=1></td>
<td class="tdbg"><input type="submit" value="�����" onClick="javascript:this.form.action +='?str=add'"></td>
</tr>
</form>
</table>
<br>
<span class="STYLE3">��</span><span class="STYLE2">��<font color=blue>��ͬ��ʶ</font>��,������Ӵ���ͬʱ���ý��ڿͻ��������ʾ</span>
</body>
