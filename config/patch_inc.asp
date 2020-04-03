<%

'补丁列表保存地址，用于服务器端
xmlSavePath="/update/server/"

'补丁源,用于客户/服务器端
xmlUpdate="http://update.myhostadmin.net/update/server/patch_list.xml"

'已经打了的补丁文件列表,用于客户端
xmlPatchFile=Server.MapPath(SystemAdminPath & "/update/apply_patch.xml")

'手工打补丁，文件存放路径
manualSavePath="/patches"

'定义一个简单类，用于存储补丁信息,用于客户端

class patcher
	public name, title, info, pdate,path, applyver,must,comment
end class

'获取返回值
function getPReturn(ByVal inputStr,byVal fdname)
	fdname=fdname & ":"
	fdname_len=len(fdname)
	ipos=instr(inputStr,fdname)
	if ipos>0 then
		jpos=instr(ipos,inputStr,vbcrlf)
			if jpos>0 then
				fieldStr=mid(inputStr,ipos,jpos-ipos)					
				getPReturn=mid(fieldStr,fdname_len+1)
			end if
	end if
end function

'执行SQL语句,多条语句可用;分隔
sub ExecuteSql(sqlname)
	on error resume next
	conn.open constr
	Set ofso=CreateObject(objName_FSO)
	if ofso.fileExists(sqlname) then
		Set oTxt=ofso.openTextFile(sqlname,1,false)
		fContent=oTxt.ReadAll
		if fContent<>"" then
			sqls=split(fContent,";")
			for each sql in sqls
				sql=Trim(sql)
				if sql<>"" then
					conn.Execute(sql)
				end if
			next
		end if
		oTxt.close
		set oTxt=nothing
	end if

	if not err then
		ofso.deletefile sqlname,true 
	else
		Response.write "执行SQL出错，错误信息" & err.description
	end if
	set ofso=nothing
	conn.close
end sub

'执行一个asp程序
sub ExecuteAcmd(Byval acmdName)
	on error resume next
	Set ofso=CreateObject(objName_FSO)
	Server.Execute(acmdName)
	ofso.deletefile Server.MapPath(acmdName),true
	set ofso=nothing
end sub

'删除一个补丁
function removePatchItem(Byval patchname)
	removePatchItem=false
	blIfound=false
	patchname=lcase(patchname)
	set ofso=CreateObject(objName_FSO)
	set oxml=CreateObject("microsoft.xmldom")

	plist=server.MapPath(xmlSavePath & "patch_list.xml")
	oxml.async=false
	oxml.load(plist)
	if oxml.parseerror.errorcode<>0 then
		exit function
	end if

	for each oNode in oxml.documentElement.childNodes
		pname=oNode.selectSingleNode("name").text
		pname=Lcase(pname)
		if patchname=pname then
			blIfound=true
			pUrl=oNode.selectSingleNode("path").text
			pPath=Server.MapPath(pUrl)
			if ofso.fileExists(pPath)  then
				ofso.deletefile pPath,true
			end if
			oxml.documentElement.removeChild(oNode)
		end if
	next
	if blIfound then
		oxml.save plist
	end if
	removePatchItem=true
end function


'添加一个新的补丁(用于服务端) 补丁名，标题，信息，应用版本,是否必须,其它相关信息,涉及文件
'必须保证补丁名唯一
function addPatchItem(p_name,p_title,p_info,p_applyver,p_must,p_comment,p_files)
	addPatchItem=false
	
	if not isNumeric(p_applyver) then
		exit function
	end if

	plist=server.MapPath(xmlSavePath & "patch_list.xml")
	set oxml=createObject("Microsoft.xmldom")
	oxml.async=false
	oxml.load(plist)
	if oxml.parseError.errorcode<>0 then
		exit function
	end if

	pURl=xmlSavePath & p_name & ".xml"

	if not toPackage(p_files,pUrl) then
		exit function
	end if

	p_info=p_info & vbcrlf &"更新的文件:" & vbcrlf
	for each txtFile in p_files
		if right(txtFile,4)<>".sql" then
			p_info=p_info & txtFile & vbcrlf
		end if
	next

	Set nodPatch=oxml.CreateElement("patch")
	Set nodName=oxml.CreateElement("name")
	Set nodTitle=oxml.createElement("title")
	Set nodInfo=oxml.CreateElement("info")
	Set nodPdate=oxml.CreateElement("pdate")
	Set nodPath=oxml.CreateElement("path")
	Set nodApplyver=oxml.CreateElement("applyver")
	Set nodMust=oxml.CreateElement("must")
	Set nodComment=oxml.CreateElement("comment")

	nodName.text=p_name
	nodTitle.text=p_title
	nodInfo.text=p_info
	nodPdate.text=date()
	nodPath.text=pURl
	nodApplyver.text=p_applyver
	nodMust.text=p_must
	nodComment.text=p_comment

	nodPatch.appendChild(nodName)
	nodPatch.appendChild(nodTitle)
	nodPatch.appendChild(nodInfo)
	nodPatch.appendChild(nodPdate)
	nodPatch.appendChild(nodPath)
	nodPatch.appendChild(nodApplyver)
	nodPatch.appendChild(nodMust)
	nodPatch.appendChild(nodComment)

	oxml.documentElement.appendChild(nodPatch)
	oxml.save plist

	Set oxml=nothing
	addPatchItem=true
end function


function inArray(oArray,Byval seekword)
	seekword=Lcase(Trim(seekword))
	inArray=false
	for each compStr in oArray
		compStr=Lcase(compStr)
		if compStr=seekword then
			inArray=true
			exit function
		end if
	next
end function

sub mkdir(fpath)
	Set ofso=CreateObject(objName_FSO)

	Paths=split(fpath,"/")
	SitePath=Server.MapPath("/")
	Uindex=Ubound(Paths)-1

	for i=1 to Uindex
		SitePath=SitePath & "\" & Paths(i)
		if not ofso.FolderExists(SitePath) then
			ofso.CreateFolder(SitePath)
		end if
	next

	Set ofso=nothing
end sub

function getHost(content)
	Set oReg=new RegExp
	oReg.IgnoreCase=true
	oReg.Pattern="(http://[\w\-\.]+)(/.+)?"
	if oReg.test(content) then
		Set oMatch=oReg.Execute(content)
		getHost=oMatch(0).subMatches(0)
	end if
	set oReg=nothing
end function

'扫描某个补丁之前是否存在未打的补丁
'全部补丁列表,已打补丁列表,补丁名,补丁版本
function scanPrevious(ByRef allpatch,Byref patchArr, Byval patchName,Byval pVer)
	scanPrevious=""
	pVer=Csng(pVer)
	patchName=Lcase(patchName)
	
	for i=0 to Ubound(allpatch)
		p_name=Lcase(allpatch(i).name)
		p_title=Lcase(allpatch(i).title)
		p_appver=Csng(allpatch(i).applyver)
		p_name=Lcase(p_name)

		if p_name<>patchName and p_appver<pVer and (not inArray(patchArr,p_name)) then
			scanPrevious=scanPrevious & p_name & "(" & p_title & ")" & ","
		end if
	next
	if right(scanPrevious,1)="," then scanPrevious=left(scanPrevious,len(scanPrevious)-1)
end function

function getRemoteVer()
	on error resume next
	Set ohttp=createobject("MSXML2.ServerXMLHTTP")
	verUrl=getHost(xmlUpdate) & xmlSavePath & "GetVer.asp?1=" & api_username & "&2=" & Server.UrlEncode(api_url) & "&3=" & companynameurl & "&4=" & timer()
	ohttp.open "GET",verUrl,false
	ohttp.send
	if ohttp.status=200 then
		getRemoteVer=ohttp.ResponseText
	else
		getRemoteVer="0.0"
	end if
	Set ohttp=nothing
end function

function getVer()
	Set oReg = new RegExp
	oReg.ignorecase=true
	oReg.pattern="version=""v([\d\.]+)"""

	v_file=server.mappath("/config/const.asp")
	set ofso=createobject(objName_FSO)
	set ofile=ofso.opentextfile(v_file,1,false)
	version_str=ofile.readall()
	ofile.close:set ofile=nothing
	set ofso=nothing

	if oReg.test(version_str) then
		Set xMatch=oReg.execute(version_str)
		getVer=Csng(xMatch(0).subMatches(0))
	else
		getVer=3.0
	end if
	Set oReg=nothing
end function

sub setVer(newVersion)
	constFile=Server.MapPath("/config/const.asp")
	set ofso=createObject(objName_FSO)
	set opat=new regexp
	opat.ignorecase=true
	opat.pattern="version=""v[\d\.]+"""

	set oTxt=ofso.openTextFile(constFile,1,false)
	oInfos=oTxt.ReadAll()
	oTxt.close:Set oTxt=nothing

	if opat.test(oInfos) and isNumeric(newVersion) then
		oInfos=opat.replace(oInfos,"version=""v" & newVersion & """")
		Set oTxt=ofso.openTextFile(constFile,2,false)
		oTxt.write(oInfos)
		oTxt.close:Set oTxt=nothing
	end if
	Set ofso=nothing
	Set opat=nothing
end sub


function getPatchList()
	getPatchList=""
	Set oxml=createobject("microsoft.xmldom")
	oxml.async=false
	oxml.load(xmlPatchFile)
	if oxml.parseError.errorcode<>0 then exit function
	Set olist=oxml.documentElement.childNodes
	for each ochild in olist
		if ochild.nodeName="patch" then
			getPatchList=getPatchList & ochild.childNodes(0).nodeValue & ","
		end if
	next
	if right(getPatchList,1)="," then getPatchList=left(getPatchList,len(getPatchList)-1)
	set oxml=nothing
end function

function addPatchlist(patchname)
	addPatchlist=false
	Set oxml=createobject("microsoft.xmldom")
	oxml.async=false
	oxml.load(xmlPatchFile)
	if oxml.parseError.errorcode<>0 then exit function
	Set oNode=oxml.CreateElement("patch")
	Set oTxt=oxml.CreateTextNode(patchname)
	oNode.appendchild(oTxt)
	oxml.documentElement.appendchild(oNode)
	oxml.save(xmlPatchFile)
	set oxml=nothing
	addPatchlist=true
end function

function getremotePatch(Byval atServer)
	'获取远程服务器的补丁列表
	on error resume next
	getremotePatch=Array()
	getremotePatch_tmp=Array()
	
	Set ohttp=CreateObject("MSXML2.ServerXMLHTTP")
	ohttp.open "GET",xmlUpdate & "?v=" & timer(),false
	ohttp.send

	if ohttp.status<>200 then
		exit function
	end if

	if ohttp.ResponseXML.parseError.errorCode<>0 then
		exit function
	end if
	set patchlist=ohttp.ResponseXML.documentElement.childNodes

	for each oPatch in patchlist
		Set allnode=oPatch.childNodes
		Set oInfo=new patcher

		for each objX in allnode
		    ele_value=objX.firstChild.nodeValue
			select case objX.nodeName
				case "name"
					oInfo.name=ele_value
				case "title"
					oInfo.title=ele_value
				case "info"
					oInfo.info=ele_value
				case "pdate"
					oInfo.pdate=ele_value
				case "path"
					oInfo.path=ele_value
				case "applyver"
					oInfo.applyver=ele_value
				case "must"
					oInfo.must=ele_value
				case "comment"
					oInfo.comment=ele_value
			end select

		next
		if atServer then
			if getVer()>=Csng(oInfo.applyver) then
				lastIndex=Ubound(getremotePatch_tmp)+1
				Redim preserve getremotePatch_tmp(lastIndex)
				Set getremotePatch_tmp(lastIndex)=oInfo
			end if
		else
			if getVer()<Csng(oInfo.applyver) then
				lastIndex=Ubound(getremotePatch_tmp)+1
				Redim preserve getremotePatch_tmp(lastIndex)
				Set getremotePatch_tmp(lastIndex)=oInfo
			end if
		end if
		
		Set oInfo=nothing
	next
	set ohttp=nothing
	getremotePatch=getremotePatch_tmp
end function

function toPackage(fileNames,ByVal xmlFile)
	pzXml=server.MapPath(xmlFile)

	Set lfso=CreateObject("Scripting.FileSystemObject")

	toPackage=false
	Set oado=CreateObject("Adodb.Stream")
	oado.type=1
	oado.mode=3
	oado.open

	Set oxml=CreateObject("Microsoft.xmldom")
	oxml.async=false
	oxml.loadXML("<?xml version=""1.0"" encoding=""gb2312""?><patchfiles xmlns:dt=""urn:schemas-microsoft-com:datatypes""></patchfiles>")
	if oxml.parseError.errorCode<>0 then
		exit function
	end if

	for each fileName in fileNames 
			pzF=Server.MapPath(fileName)

			if lfso.fileExists(pzF) then 
				oado.setEos
				oado.loadFromFile(pzF)
				
				Set oNode=oxml.CreateElement("file")
				Set oNodename=oxml.CreateElement("name")
				Set oNodevalue=oxml.CreateElement("content")
				oNodevalue.datatype="bin.base64"
				oNodevalue.nodeTypedValue=oado.read(-1)

				Set oTxt=oxml.CreateTextNode(fileName)
				oNodename.AppendChild(oTxt)

				oNode.AppendChild(oNodename)
				oNode.AppendChild(oNodevalue)

				oxml.documentElement.appendChild(oNode)
		elseif lfso.folderExists(pzF) then
				if right(pzF,1)="\" then pzF=left(pzF,len(pzF)-1)
				if right(fileName,1)="/" then fileName=left(fileName,len(fileName)-1)

				for each sfile in lfso.getFolder(pzF).Files
					sdir=pzF & "\" & sfile.name

					oado.setEos
					oado.loadFromFile(sdir)
					
					Set oNode=oxml.CreateElement("file")
					Set oNodename=oxml.CreateElement("name")
					Set oNodevalue=oxml.CreateElement("content")
					oNodevalue.datatype="bin.base64"
					oNodevalue.nodeTypedValue=oado.read(-1)

					Set oTxt=oxml.CreateTextNode(fileName & "/" & sfile.name)
					oNodename.AppendChild(oTxt)

					oNode.AppendChild(oNodename)
					oNode.AppendChild(oNodevalue)
					oxml.documentElement.appendChild(oNode)				
				next
		end if
	next

	oxml.save(pzXml)
	toPackage=true

	set oxml=nothing
	set oado=nothing
end function

function unPackage(Byval HttpXmlFile,Byval strPName,Byval blManual)
	unPackage=false
	if blManual then
		strFixPath=ManualSavePath & "/" & strPName
	else
		strFixPath=""
	end if
	

	Set oxmlhttp=CreateObject("MSXML2.ServerXMLHTTP")
	oxmlhttp.open "GET",HttpXmlFile,false
	oxmlhttp.send
	if oxmlhttp.status<>200 then
		exit function
	end if
	Set oxml=oxmlhttp.ResponseXml

	if oxml.parseError.errorcode<>0 then
		exit function
	end if

	set oado=CreateObject("adodb.Stream")
	oado.type=1
	oado.mode=3
	oado.open

	Set AllNodes=oxml.documentElement.childNodes

	for each oNode in AllNodes
		Set oFileNode=oNode.getElementsByTagName("name")(0)
		Set fileValue=oNode.getElementsByTagName("content")(0)

		txtfileName=oFileNode.firstChild.nodeValue
		txtfileName=fixPath(txtfileName)
		txtfileName=strFixPath & txtfileName

		oado.SetEos
		oado.write fileValue.nodeTypedValue
		Call mkdir(txtfileName)
		oado.saveToFile Server.mapPath(txtfileName),2

		if right(txtfileName,4)=".sql" then
			Call ExecuteSql(Server.mapPath(txtfileName))
		end if

		if right(txtfileName,5)=".acmd" then
			Call ExecuteAcmd(txtfileName)
		end if
	next

	set oado=nothing
	set oxml=nothing
	set oxmlhttp=nothing

	unPackage=true
end function

'主程序,应用某个补丁
function applyPatch(Byval patchName,Byval patchUrl,ByVal patchver,Byval manual)
	xmlUrl=getHost(xmlUpdate) & patchUrl
	if dohulue="hulue" then 
		Call addPatchlist(patchName)
		Call SetVer(patchver)
		applyPatch=true
		exit function
	end if
	if unPackage(xmlUrl,patchName,manual) then
		Call addPatchlist(patchName)
		Call SetVer(patchver)
		applyPatch=true
	else
		applyPatch=false
	end if
end function
'旧补丁重新升级
function reapplyPatch(Byval patchName,Byval patchInfo,ByVal nowpatchver,Byval manual,byref packstr)
'补丁名称,补丁文件,补丁版本号,是否手动升级
	reapplyPatch=false
	xmlUpdateHost=getHost(xmlUpdate)
	packstr=""
	patchinfoArr=split(patchInfo,"更新的文件:")
	if ubound(patchinfoArr)>=1 then
		oldpatchList=getremotePatch(true) '得到已打过的全部补丁的数组
		for each patchInfo_item in split(patchinfoArr(1),chr(10))
			patchInfo_item=trim(patchInfo_item)
			if patchInfo_item<>"" and left(patchInfo_item,1)="/" and instr(patchInfo_item,".")>0 then
				repatchxmlUrl=findpatch(patchInfo_item,oldpatchList)
				if repatchxmlUrl<>"" then
					xmlUrl=xmlUpdateHost & repatchxmlUrl'包含该文件的最新补丁内容xml路径
					
					if not reunPackageItem(xmlUrl,patchInfo_item,patchName,manual) then '对单独文件打补丁
						packstr=packstr & patchInfo_item & vbcrlf
					end if
				end if
			end if
		next
		if packstr="" then 
			reapplyPatch=true
			call formartApplyXml(oldpatchList)
		end if
	end if
	
end function
'格式化apply_patch.xml,因为以前错打补丁后引起了xml混乱
function formartApplyXml(Byval oldpatchList)
'平台当前版本,所有已打补丁列表
	Set xml=new xmlClass
		xml.isfirst=false
		xml.xmlFileName="apply_patch.xml"				 	
		set RootNodeObj=xml.xml_getNode("/patchlist")		
		if xml.isErr then response.write xml.Err_str	
		for each node_item in RootNodeObj.childNodes
			xml.nodeObj=node_item
			xml.xml_delNode()
		next
		for each repatchlist_item in oldpatchList
				thispatchName=repatchlist_item.name
				if thispatchName<>"" then
						xml.nodeObj=RootNodeObj
						xml.nodeObj=xml.xml_createChild("patch")
						xml.xml_setValue "",thispatchName
				end if
		next
	set xml=nothing
end function
'对单独一个文件打补丁
function reunPackageItem(Byval HttpXmlFile,Byval patchPage,Byval strPName,Byval blManual)
'补丁内容所在的xml网络路径,一个补丁虚拟路径,补丁名,是否手动升级
	reunPackageItem=false
	if blManual then
		strFixPath=ManualSavePath & "/" & strPName
	else
		strFixPath=""
	end if
	Set oxmlhttp=CreateObject("MSXML2.ServerXMLHTTP")
	oxmlhttp.open "GET",HttpXmlFile,false
	oxmlhttp.send
	if oxmlhttp.status<>200 then
		exit function
	end if
	Set oxml=oxmlhttp.ResponseXml

	if oxml.parseError.errorcode<>0 then
		exit function
	end if

	set oado=CreateObject("adodb.Stream")
	oado.type=1
	oado.mode=3
	oado.open

	Set AllNodes=oxml.documentElement.childNodes

	for each oNode in AllNodes
		Set oFileNode=oNode.getElementsByTagName("name")(0)
		Set fileValue=oNode.getElementsByTagName("content")(0)
		
		txtfileName=oFileNode.firstChild.nodeValue
		if lcase(trim(txtfileName))=lcase(trim(patchPage)) then
			txtfileName=fixPath(txtfileName)
			txtfileName=strFixPath & txtfileName
			oado.SetEos
			oado.write fileValue.nodeTypedValue
			Call mkdir(txtfileName)
			oado.saveToFile Server.mapPath(txtfileName),2
			if right(txtfileName,4)=".sql" then
				Call ExecuteSql(Server.mapPath(txtfileName))
			end if
			if right(txtfileName,5)=".acmd" then
				Call ExecuteAcmd(txtfileName)
			end if
			reunPackageItem=true
			exit for
		end if
	next

	set oado=nothing
	set oxml=nothing
	set oxmlhttp=nothing
	
end function
'找到最新的指定文件
function findpatch(byval patchpage,byval repatchList)
	findpatch=""
	for each repatchlist_item in repatchList
		if reinstr(repatchlist_item.info,patchpage,chr(10)) then
			findpatch=repatchlist_item.path
		end if
	next
end function
'一行一行的精确匹配
function reinstr(byval bigstr,byval smallstr,byval xx)
	reinstr=false
	for each bigstr_item in split(bigstr,xx)
		bigstr_item=lcase(trim(bigstr_item))
		if bigstr_item<>"" then
			if bigstr_item=lcase(trim(smallstr)) then
				reinstr=true
				exit for
			end if
		end if
	next
end function
'修正路径
function fixPath(oriPath)
	fixPath=oriPath
	'去掉两边斜线
	if right(SystemAdminPath,1)="/" then
		s_SystemAdminPath=left(SystemAdminPath,len(SystemAdminPath)-1)
	else
		s_SystemAdminPath=SystemAdminPath
	end if
	
	if left(s_SystemAdminPath,1)="/" then
		s_SystemAdminPath=mid(s_SystemAdminPath,2)
	end if
	s_SystemAdminPath=Lcase(s_SystemAdminPath)
	oldPath="siteadmin"
	
	blCheck=(oldPath<>s_SystemAdminPath)

	PathList=split(oriPath,"/")
	if Ubound(PathList)>1 then
		dirTmp=Lcase(PathList(1))
		if blCheck and dirTmp=oldPath then
			PathList(1)=s_SystemAdminPath
			fixPath=""
			for z=1 to Ubound(PathList)
				fixPath=fixPath & "/" & PathList(z)
			next
		end if
	end if
end function
%>