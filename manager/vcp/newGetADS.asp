<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
response.Charset="gb2312"
function isNodes(rootNodes,nodesname,xmlpath,getRoot,byref objDoms)'�жϽڵ�治����,�����ھʹ���(���ڵ�,�ӽڵ�,xml�ļ�λ��,true/false�Ƿ�õ��Ӷ���,���صĶ���),���õ����ڵ����
		set fso=server.CreateObject(objName_FSO)
		set file=fso.opentextfile(server.mappath(xmlpath),1)
		p="n"
		objDoms.async = false
		objDoms.loadXML(file.readall)
		file.close
		
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
	  set xmlhttp=nothing

end function
sub getimgtree(mycontent,mycode,pds)
	for each itemNode1 in myobjNode.childNodes
		
			id1=trim(itemNode1.Attributes.getNamedItem("id").nodeValue)
			content1=itemNode1.Attributes.getNamedItem("content").nodeValue
			path1=itemNode1.Attributes.getNamedItem("path").nodeValue
			url1=itemNode1.Attributes.getNamedItem("url").nodeValue
			height1=itemNode1.Attributes.getNamedItem("height").nodeValue
			width1=itemNode1.Attributes.getNamedItem("width").nodeValue
			mark1=itemNode1.Attributes.getNamedItem("mark").nodeValue
			start1=itemNode1.Attributes.getNamedItem("start").nodeValue
			
			if trim(width1)<>"" then width11=" width="""& width1 &""" "
			if trim(height1)<>"" then height11=" height="""& height1 &""" "
		  if trim(mycontent)=trim(content1) and start1=1 then
		  	pds=true
			%>
<tr>
  <%if mycode="h" then%>
  <th align="right">HTML����</th>
  <td align="left"><textarea name="textarea4" cols="80" rows="3" onMouseOver="this.select();"  style="width:100%;height:60px;"><a href="<%=companynameurl%>/?ReferenceID=<%=session("u_sysid")%>" target=_blank><img src="<%=path1%>" border=0></a></textarea></td>
</tr>
<%end if%>
<%if mycode="u" then%>
<tr>
  <td align="right">UBB����</td>
  <td align="left"><textarea name="textarea4" cols="80" rows="3" onMouseOver="this.select();"  style="width:100%;height:60px;">[url=<%=companynameurl%>/?ReferenceID=<%=session("u_sysid")%>][img]<%=path1%>[/img][/url]</textarea></td>
</tr>
<%end if%>
<tr>
  <td colspan=2><a href="<%=companynameurl%>/?ReferenceID=<%=session("u_sysid")%>" target=_blank><img src="<%=path1%>" <%=width11%> <%=height11%> border=0></a></td>
</tr>
<tr>
  <td colspan="2" background="/images/line_23.gif" height=1></td>
</tr>
<%
		 
		  end if
	next
end sub



code=trim(requesta("code"))
if code="" then code="j"
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-VCP������</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
<link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
<link rel="stylesheet" href="/manager/css/2016/manager-new.css">
<script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
<script language="javascript">
function dosort(v){
 	if(v!=''){
		var sorttype="<%=request("sorttype")%>";
		if (sorttype=="") sorttype="desc";
		if (sorttype=="desc")
			sorttype="asc";
		else if(sorttype=="asc") 
			sorttype="desc";
     	document.form1.action="<%=request("script_name")%>?pageNo=<%=Requesta("pageNo")%>&sorttype="+ sorttype +"&sorts="+ v ;
		document.form1.submit();
	  }
}
</script>
</HEAD>
<body>
<!--#include virtual="/manager/top.asp" -->
<div id="MainContentDIV"> 
  <!--#include virtual="/manager/manageleft.asp" -->
  <div id="ManagerRight" class="ManagerRightShow">
    <div id="SiteMapPath">
      <ul>
        <li><a href="/">��ҳ</a></li>
        <li><a href="/Manager/">��������</a></li>
        <li><a href="/manager/vcp/newGetADS.asp?code=u">VCP������</a></li>
      </ul>
    </div>
    <div class="manager-right-bg">
      <table  class="manager-table">
        <tr >
          <th  colspan=2>�𾴵�
            <%if session("ModeD") then 
														Response.write "D"
													else
														Response.write "C"
													end if%>
            <%=name%>ģʽ������飬���ã�(<a href="vcp_Edit.asp" style="color:red;">�޸�����</a>)</th>
        </tr>
        <tr>
          <td colspan=2>����������!����ֻ�轫����Ĵ��������ҳԴ�ļ���ȴ�ɣ������⣬��Ҳ���Ը����Լ�����ҳ���ݣ����������ͼƬ��ֻҪ����Ϊ��<a href="<%=companynameurl%>/?ReferenceID=<%=Session("u_sysid")%>" target="_blank"><%=companynameurl%>/?ReferenceID=<%=Session("u_sysid")%></a> �Ϳ����ˡ����⻹��������̳�����͵ȷ������ƹ㣬UBB������Ҫ������̳�ƹ㣬�����Խ�UBB�������������̳ǩ���С�
            <p></p></td>
        </tr>
        <tr>
          <td colspan=2 ><input type="button" value="javascript����" class="manager-btn s-btn" onClick="javascript:location.href='<%=request("script_name")%>?code=j'" <%if code="j" then response.write "style=""background-color:#3399CC"""%>>
            <input type="button" value="    HTML����   " class="manager-btn s-btn" onClick="javascript:location.href='<%=request("script_name")%>?code=h'" <%if code="h" then response.write "style=""background-color:#3399CC"""%>>
            <input type="button" value="    UBB����     " class="manager-btn s-btn" onClick="javascript:location.href='<%=request("script_name")%>?code=u'" <%if code="u" then response.write "style=""background-color:#3399CC"""%>></td>
        </tr>
        <%if code="j" or code="" then%>
        <tr>
          <td colspan=2 ><span class="STYLE2">*</span>javascript����:����ͬ����ͼƬ��,����ж��ͼƬ,����ͼƬ���ڿͻ��������ʾ����һ�� </td>
        </tr>
        <%end if%>
        <%


   xmlpath=InstallDir&"database/data.asp"
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	str=trim(requesta("str"))
	getid=trim(requesta("getid"))
	set myobjNode = isNodes("advers","",xmlpath,0,objDoms)
	cur=0
		oldcontent=""
		for each itemNode in myobjNode.childNodes
			id=trim(itemNode.Attributes.getNamedItem("id").nodeValue)
			content=itemNode.Attributes.getNamedItem("content").nodeValue
			path=itemNode.Attributes.getNamedItem("path").nodeValue
			url=itemNode.Attributes.getNamedItem("url").nodeValue
			height=itemNode.Attributes.getNamedItem("height").nodeValue
			width=itemNode.Attributes.getNamedItem("width").nodeValue
			mark=itemNode.Attributes.getNamedItem("mark").nodeValue
			start=itemNode.Attributes.getNamedItem("start").nodeValue
			if instr(oldcontent,content)<=0 then
		%>
        <tr>
          <td colspan=2 class="Title"><span class="STYLE1"><%=mark%></span></td>
        </tr>
        <%
			dim pds:pds=false
			call getimgtree(content,code,pds)
			if code="j" or code="" and pds then%>
        <tr>
          <th align="right">javascript����:</th>
          <td align="left"><textarea name="textarea4" cols="80" rows="3" onMouseOver="this.select();" style="width:100%;height:60px;"><script language="javascript" src="<%=companynameurl%>/manager/vcp/getJScode.asp?ReferenceID=<%=session("u_sysid")&"&No="&content%>"></script></textarea></td>
        </tr>
        <%	 end if		%>
        <%
			end if
			oldcontent=oldcontent & "|" & trim(content)
			
		next
	set objDoms=nothing
	set myobjNode=nothing
	%>
        <tr>
          <th align="right">���ִ��룺 </th>
          <td align="left"><textarea name="textarea2" cols="40" rows="3" onMouseOver="this.select();" style="width:100%;height:60px;">&lt;a href=&quot;<%=companynameurl%>/index.asp?ReferenceID=<%=Session("u_sysid")%>&quot; 
target=&quot;_blank&quot;&gt;��������&lt;/a&gt;</textarea>
            <BR>
            <a href="<%=companynameurl%>/index.asp?ReferenceID=<%=Session("u_sysid")%>" target="_blank">��������</a></td>
        </tr>
        <tr>
          <th align="right">���ִ���: </th>
          <td align="left"><textarea name="textarea3" cols="40" rows="3" onMouseOver="this.select();"  style="width:100%;height:60px;">��л<%=companyname%>�ṩ&lt;a <%=companynameurl%>/index.asp?ReferenceID=<%=Session("u_sysid")%>&quot; 
target=&quot;_blank&quot;&gt;��������&lt;/a&gt;</textarea>
            <BR>
            ��л<%=companyname%>�ṩ<a href="<%=companynameurl%>/index.asp?ReferenceID=<%=Session("u_sysid")%>" target="_blank">��������</a></td>
        </tr>
      </table>
      </td>
      </tr>
      </table>
    </div>
  </div>
</div>

<!--#include virtual="/manager/bottom.asp" -->
</body>
</html>
