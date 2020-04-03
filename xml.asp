<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include virtual="/config/config.asp" -->
<%

function siteMappath(byval invl)
	invl=server.HTMLEncode(invl)
	theFilePath=replace(request.ServerVariables("SCRIPT_NAME"),"\","/")
	if left(theFilePath,1)="/" then theFilePath=right(theFilePath,len(theFilePath)-1)
	selectStr="//siteMapNode[@url='"& theFilePath &"']"
	  if theFilePath <>"" then

		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		nodesname="xsl:variable"
		siteMapStr=""
		set myobjNode=isNodes(nodesname,"",strXSLFile,false,objDoms)
		xslName=myobjNode.Attributes.getNamedItem("name").nodeValue
		if xslName="MyNodes" then
				myobjNode.setAttribute "select",selectStr
				objDoms.save(strXSLFile)
		end if
		set myobjNode=nothing	
	  end if
	set objDoms=nothing
	siteMappath=loadXmlStr(invl)
end function
Function loadXMLFile() 

	set objXML = Server.CreateObject("Microsoft.XMLDOM") 
	 objXML.async = false 
	objXML.load(strXMLFile) 
	set objXSL = Server.CreateObject("Microsoft.XMLDOM") 
	objXSL.async = false 
	objXSL.load(strXSLFile) 
	loadXMLFile=objXML.transformNode(objXSL)
	set objXSL=nothing
 	set objXML =nothing
End Function 
function loadXmlStr(byval invl)
	loadXmlStr=""
	xmlStr="<?xml version=""1.0"" encoding=""gb2312""?>" & loadXMLFile()
		set objXML = Server.CreateObject("Microsoft.XMLDOM") 
		objXML.async = false 
		objXML.loadXML(xmlStr)
		if objXML.ParseError.ErrorCode = 0 then
			Set objroot = objXML.documentElement
			mapstr=""
			call blchilde(objroot,mapstr,invl)
			if right(mapstr,len(invl))=invl then mapstr=left(mapstr,len(mapstr)-len(invl))
			loadXmlStr=mapstr
		end if
	set objXml=nothing
end function
function blchilde(byval objroots,byref mapstr,byval invl)
	if isobject(objroots) then
		for each objitem in objroots.childNodes
			itemurl=objitem.Attributes.getNamedItem("url").nodeValue
			itemtitle=objitem.Attributes.getNamedItem("title").nodeValue
			itemdescription=objitem.Attributes.getNamedItem("description").nodeValue
			mapstr=mapstr & "<a href='"& itemurl &"' title='"& itemdescription &"'>"& itemtitle & "</a>" & invl
			call blchilde(objitem,mapstr,invl)
		next
	else
		exit function
	end if
end function

response.write siteMappath("<b>-></b>")
%>