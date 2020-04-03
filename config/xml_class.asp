<%
'************************************************************************************
'*		ά 2009-3-9																*
'*		���ڲ���xml�ļ���															*
'*----------------------------------------------------------------------------------*
'*		xmlFileName:����xml�ļ�·��													*
'*		xml_getNode:ȡ��xml�ڵ����													*
'*		xml_getValue:�õ��ڵ��������Ի�text										*
'*		xml_setValue:���ýڵ��������Ի�text										*
'*		xml_delNode:ɾ���ڵ����													*
'*		nodeObj:��������Ҫ�����Ľڵ����,������Ϊxml_getNodeȡ�õĶ���				*
'*		xml_create:�����ڵ����,xml_getNodeȡ�ڵ�ʱ��û�н��Զ����д˺���			*
'*		xml_createChild:�����ӽڵ㣬�����½����ӽڵ�								*
'************************************************************************************

class xmlClass
'����xml��
	public xmlFile
	public isErr
	public Err_str
	public myrootnodes 
	public xmlpath
	public objDoms
	public objroot,isfirst
	Private Sub Class_Initialize'����
		isErr=false
		isfirst=true
		Errstr=""
		set objDoms=Server.CreateObject("Microsoft.XMLDOM")
		objDoms.async = false '�����������
	end Sub
	Private Sub Class_Terminate'����
        Set objDoms= Nothing
		if not objroot is nothing then set objroot=nothing
		if not myrootnodes is nothing then set myrootnodes=nothing
    End Sub
	Public Property Let xmlFileName(ByVal Value)
	'����xml�ļ�λ��
        xmlFile=Value
		xmlpath = Server.MapPath(xmlFile)
		objDoms.load(xmlpath)
		if objDoms.ParseError.ErrorCode <> 0 then 
			xml_Err(objDoms.ParseError.Reason)
		end if
		Set objroot = objDoms.documentElement'���ڵ�
    End Property
	Public Property Let nodeObj(ByVal Value)
	'����xml�ļ�λ��
        set myrootnodes=Value
    End Property
	public function xml_Err(byval errstr)
		err_str=err_str & errstr
		isErr=true
	end function
	public function xml_getNode(byval read_node)
	'��ȡ�ڵ����������ݷ���nodeobj
	'read_node:/root/getnode[@id=123456] ������ //getnode�ѽڵ�
		if isErr then exit function
		set myrootnodes=objroot.selectSingleNode(read_node)'�ѽڵ�
		if myrootnodes is nothing then 
			set myrootnodes=xml_create(read_node)'��û�оʹ���
		end if
		set xml_getNode=myrootnodes
		'set childs=befelement.childNodes
		'if childs is nothing or childs=null then
			'xml_Read=myrootnode.getAttribute
		'end if
	end function
	public function xml_getValue(byval nodeValueName)
	'�õ��ڵ�ֵ
	'nodeValueName:ֵ����,Ϊ�վ�ȡtext
		if isErr then exit function
		if trim(nodeValueName)="" then
			 xml_getValue=myrootnodes.text
		else
			 xml_getValue=myrootnodes.getAttribute(nodeValueName)
		end if
	end function
	public function xml_setValue(byval nodeName,byval nodeValue)
	'����ֵ
	'nodeName:������,Ϊ�վ�������text,nodeValue:���õ�ֵ
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
	'node_name:/root/getnode[@id=123456] ������ //getnode���ڵ�
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
'ʾ��
'Set xml=new xmlClass
'	xml.xmlFileName="data.xml"  				 		'����xml·��
'	set RootNodeObj=xml.xml_getNode("/root/item")		'�õ��ڵ����
'	if xml.isErr then response.write xml.Err_str		'����д��󷵻ش���
'	for each childItem in RootNodeObj.childNodes		'�����ӽڵ�
'		xml.nodeObj=childItem							'��������Ҫ�����Ľڵ����
'		xml.xml_setValue "id","����ID��ֵ"				'��������ֵ
'		response.write xml.xml_getValue("id") & "<br>"  '�õ�����ֵ
'	next
'set xml=nothing
%>
