<%
'************************************************************************************
'*		维 2009-3-9																*
'*		用于操作xml文件类															*
'*----------------------------------------------------------------------------------*
'*		xmlFileName:设置xml文件路径													*
'*		xml_getNode:取得xml节点对像													*
'*		xml_getValue:得到节点对像的属性或text										*
'*		xml_setValue:设置节点对像的属性或text										*
'*		xml_delNode:删除节点对像													*
'*		nodeObj:设置类中要操作的节点对像,不设置为xml_getNode取得的对像				*
'*		xml_create:创建节点对像,xml_getNode取节点时如没有将自动运行此函数			*
'*		xml_createChild:创建子节点，返回新建的子节点								*
'************************************************************************************

class xmlClass
'操作xml类
	public xmlFile
	public isErr
	public Err_str
	public myrootnodes 
	public xmlpath
	public objDoms
	public objroot,isfirst
	Private Sub Class_Initialize'构造
		isErr=false
		isfirst=true
		Errstr=""
		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		objDoms.async = false '必须完成下载
	end Sub
	Private Sub Class_Terminate'析构
        Set objDoms= Nothing
		if not objroot is nothing then set objroot=nothing
		if not myrootnodes is nothing then set myrootnodes=nothing
    End Sub
	Public Property Let xmlFileName(ByVal Value)
	'设置xml文件位置
        xmlFile=Value
		xmlpath = Server.MapPath(xmlFile)
		objDoms.load(xmlpath)
		if objDoms.ParseError.ErrorCode <> 0 then 
			xml_Err(objDoms.ParseError.Reason)
		end if
		Set objroot = objDoms.documentElement'根节点
    End Property
	Public Property Let nodeObj(ByVal Value)
	'设置xml文件位置
        set myrootnodes=Value
    End Property
	public function xml_Err(byval errstr)
		err_str=err_str & errstr
		isErr=true
	end function
	public function xml_getNode(byval read_node)
	'读取节点内所有数据返回nodeobj
	'read_node:/root/getnode[@id=123456] 搜属性 //getnode搜节点
		if isErr then exit function
		set myrootnodes=objroot.selectSingleNode(read_node)'搜节点
		if myrootnodes is nothing then 
			set myrootnodes=xml_create(read_node)'如没有就创建
		end if
		set xml_getNode=myrootnodes
		'set childs=befelement.childNodes
		'if childs is nothing or childs=null then
			'xml_Read=myrootnode.getAttribute
		'end if
	end function
	public function xml_getValue(byval nodeValueName)
	'得到节点值
	'nodeValueName:值名称,为空就取text
		if isErr then exit function
		if trim(nodeValueName)="" then
			 xml_getValue=myrootnodes.text
		else
			 xml_getValue=myrootnodes.getAttribute(nodeValueName)
		end if
	end function
	public function xml_setValue(byval nodeName,byval nodeValue)
	'设置值
	'nodeName:属性名,为空就是设置text,nodeValue:设置的值
		if isErr then exit function
		if nodeName="" then
			myrootnodes.text=nodeValue
		else
			myrootnodes.setAttribute nodeName,nodeValue
		end if
		set xml_setValue=myrootnodes
		objDoms.save(xmlpath)
	end function
	public function xml_delNode()
		if isErr then exit function
		myrootnodes.parentNode.removeChild(myrootnodes)
		objDoms.save(xmlpath)
	end function
	public function xml_createChild(byval newNode_name)
		set newNode = objDoms.Createelement(newNode_name)
		if isfirst then
			myrootnodes.insertBefore newNode, myrootnodes.firstchild
		else
			myrootnodes.insertBefore newNode,null
		end if
		set xml_createChild=newNode
		'objDoms.save(xmlpath)
	end function
	public function xml_create(byval node_name)
	'node_name:/root/getnode[@id=123456] 建属性 //getnode建节点
		if isErr then exit function
		set newobjroot=objroot
		nodeStr=""
		for each nodeItem in split(node_name,"/")
			nodeItem=trim(nodeItem)
			if nodeItem<>"" then
				nodeStr=nodeStr & "/" & nodeItem
				set thisNodeObject=objDoms.selectSingleNode(nodeStr)
				if newobjroot is nothing then set newobjroot=objroot
				if thisNodeObject is nothing then
					set newNode = objDoms.Createelement(nodeItem)
					newobjroot.appendChild newNode
					set newobjroot=nothing
					set newobjroot=newNode
				else
					set newobjroot=objDoms.selectSingleNode(nodeStr)
				end if
			end if
		next
		set xml_create=newobjroot
		objDoms.save(xmlpath)
	end function
end class
'示例
'Set xml=new xmlClass
'	xml.xmlFileName="data.xml"  				 		'设置xml路径
'	set RootNodeObj=xml.xml_getNode("/root/item")		'得到节点对像
'	if xml.isErr then response.write xml.Err_str		'如果有错误返回错误
'	for each childItem in RootNodeObj.childNodes		'遍历子节点
'		xml.nodeObj=childItem							'设置类里要操作的节点对像
'		xml.xml_setValue "id","这是ID的值"				'设置属性值
'		response.write xml.xml_getValue("id") & "<br>"  '得到属性值
'	next
'set xml=nothing
%>
