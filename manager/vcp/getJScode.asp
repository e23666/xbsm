<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%
response.Buffer=true

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	No=requesta("No")'指定的标识
	ReferenceID=requesta("ReferenceID")'vcpid
	
	redim adverArray(0)
	xmlpath=server.MapPath("/database/data.asp")
	set objDoms=Server.CreateObject("Microsoft.XMLDOM")
	str=trim(requesta("str"))
	getid=trim(requesta("getid"))
	set myobjNode = isNodes("advers","",xmlpath,0,objDoms)
	cur=0
	for each itemNode in myobjNode.childNodes
		id=trim(itemNode.Attributes.getNamedItem("id").nodeValue)
		content=itemNode.Attributes.getNamedItem("content").nodeValue
		path=itemNode.Attributes.getNamedItem("path").nodeValue
		url=itemNode.Attributes.getNamedItem("url").nodeValue
		height=itemNode.Attributes.getNamedItem("height").nodeValue
		width=itemNode.Attributes.getNamedItem("width").nodeValue
		start=itemNode.Attributes.getNamedItem("start").nodeValue
		if trim(content)=trim(No) and start=1 then
			adverArray(cur)=path & "|" & width &"|"& height & "|" & url
			cur=cur+1
			Redim preserve adverArray(cur)
		end if
	
	next
	set objDoms=nothing
	set myobjNode=nothing
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
    Randomize
	
	Maxnum=ubound(adverArray)-1
	
	if Maxnum>0 then
		getnum=int((Maxnum-0+1)*Rnd+0)
	else
		getnum=0
	end if
	
	theAdver=adverArray(getNum)
	if theAdver<>"" then
		strArray=split(theAdver,"|")
		if ubound(strArray)>=3 then
			Auto_p=strArray(0)'路径
			Auto_w=strArray(1)
			Auto_h=strArray(2)
			Auto_u=strArray(3)'url
			if trim(Auto_w)<>"" then width11=" width="""& Auto_w &""" "
			if trim(Auto_h)<>"" then height11=" height="""& Auto_h &""" "
			%>
            document.write('<a href="<%=companynameurl%>/?ReferenceID=<%=ReferenceID%>" target="_blank">');
            document.write('<img src="<%=Auto_p%>" <%=width11%> <%=height11%> border=0>');
            document.write('</a>');

            <%
		end if
	end if
	
%>
