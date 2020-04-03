<%
Class Template
    
    Private m_FileName, m_Root, m_Unknowns, m_LastError, m_HaltOnErr
    Private m_ValueList, m_BlockList
    Private m_RegExp    
    ' ���캯��
    Private Sub Class_Initialize
        Set m_ValueList     = CreateObject("Scripting.Dictionary")
        Set m_BlockList     = CreateObject("Scripting.Dictionary")
        set m_RegExp        = New RegExp
        m_RegExp.IgnoreCase = False
        m_RegExp.Global     = True
        m_FileName          = "/template/"
        m_Root              = "."
        m_Unknowns          = "keep"
        m_LastError         = ""
        m_HaltOnErr         = true
    End Sub
    
    ' ��������
    Private Sub Class_Terminate
        Set m_RegExp       = Nothing
        Set m_BlockMatches = Nothing
        Set m_ValueMatches = nothing
    End Sub
    
    Public Property Get ClassName()
        ClassName = "Template"
    End Property
    
    Public Property Get Version()
        Version = "1.0"
    End Property
    
    Public Sub About()
        Response.Write("Template ASPҳ��ģ����<br>")
    End Sub
    
    '���Ŀ¼�Ƿ����
    Public Function FolderExist(ByVal path)
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")
        FolderExist = fso.FolderExists(Server.MapPath(path))
        Set fso = Nothing
    End Function
    '��ȡ�ļ�����
    Private Function LoadFile()
        Dim Filename, fso, hndFile
        Filename = m_Root
        If Right(Filename, 1)<>"/" And Right(Filename, 1)<>"\" Then Filename = Filename & "/"
        Filename = Server.MapPath(Filename & m_FileName)
        Set fso = CreateObject("Scripting.FileSystemObject")
        If Not fso.FileExists(Filename) Then ShowError("ģ���ļ�" & m_FileName & "������!")
        set hndFile = fso.OpenTextFile(Filename)
        LoadFile = hndFile.ReadAll
        Set hndFile = Nothing
        Set fso = Nothing
        If LoadFile = "" Then ShowError("���ܶ�ȡģ���ļ�" & m_FileName & "���ļ�Ϊ��!")
    End Function
    
    '���������Ϣ
    Private Sub ShowError(ByVal msg)
      '  m_LastError = msg
      '  Response.Write "<!--<font color=red style='font-size;14px'><b>ģ�����" & msg & "</b></font><br>-->"
      '  If m_HaltOnErr Then Response.End
    End Sub
    
    '����ģ���ļ�Ĭ��Ŀ¼
    'Ex: Template.set_root("/tmplate")
    '    Template.Root = "/tmplate"
    '    root = Template.get_root()
    '    root = Template.Root
    'ʹ������set_root����������������Ϊ�˼���phplib�����½������ظ�˵��
    Public Sub set_root(ByVal Value)
        If Not FolderExist(Value) Then ShowError(Value & "������ЧĿ¼��Ŀ¼������!")
        m_Root = Value
    End Sub
    Public Function get_root()
        get_root = m_Root
    End Function 
    Public Property Let Root(ByVal Value)
        set_root(Value)
    End Property
    Public Property Get Root()
        Root = m_Root
    End Property
    
    '����ģ���ļ�
    'Ex: Template.set_file("hndTpl", "index.htm")
    '���಻֧�ֶ�ģ���ļ���handleΪ����phplib������
    Public Sub set_file(ByVal handle,ByVal  filename)
        m_FileName = filename
        m_BlockList.Add Handle, LoadFile()
    End Sub
    Public Function get_file()
        get_file = m_FileName
    End Function
'     Public Property Let File(handle, filename)
'         set_file handle, filename
'     End Property
'     Public Property Get File()
'         File = m_FileName
'     End Property
    
    '���ö�δָ���ı�ǵĴ���ʽ����keep��remove��comment����
    Public Sub set_unknowns(ByVal unknowns)
        m_Unknowns = unknowns
    End Sub
    Public Function get_unknowns()
        get_unknowns = m_Unknowns
    End Function
    Public Property Let Unknowns(ByVal unknown)
        m_Unknowns = unknown
    End Property
    Public Property Get Unknowns()
        Unknowns = m_Unknowns
    End Property
    
    Public Sub set_block(ByVal Parent, ByVal BlockTag, ByVal Name)
        Dim Matches
        m_RegExp.Pattern = "<!--\s+BEGIN " & BlockTag & "\s+-->([\s\S.]*)<!--\s+END " & BlockTag & "\s+-->"
        If Not m_BlockList.Exists(Parent) Then ShowError("δָ���Ŀ���[" & Parent&"]")
        set Matches = m_RegExp.Execute(m_BlockList.Item(Parent))
        For Each Match In Matches
            m_BlockList.Add BlockTag, Match.SubMatches(0)
            m_BlockList.Item(Parent) = Replace(m_BlockList.Item(Parent), Match.Value, "{" & Name & "}")
        Next
        set Matches = nothing
    End Sub
	'���ô������ı��
	'����:����,û�д�()�ı���ַ�,ָ������ĺ�����
	'zxw 2008-4-17
    Public function set_function(Byval handle,Byval N,byval function_name)
		If m_BlockList.Exists(handle) and N<>"" Then
			set_function=m_BlockList.Item(handle) 
				m_RegExp.Pattern="\{"& trim(N) &"\((.+?)\)\}"
				set regExplist=m_RegExp.execute(set_function)
				for each vv in regExplist
					itm=vv.subMatches(0)
					f=function_name& "("""& itm &""")"
					ff=eval(f)
					
					
					call set_var(N&"("&itm&")",ff,false)
				next
			
		else
			call ShowError("δָ���� ����[" & handle&"]["&N&"]["&function_name&"]")	
		end if
	End function
    Public Sub set_var(ByVal Name, ByVal Value, ByVal Append)
        Dim Val
        If IsNull(Value) Then Val = "" Else Val = Value
        If m_ValueList.Exists(Name) Then
            If Append Then m_ValueList.Item(Name) = m_ValueList.Item(Name) & Val _
            Else m_ValueList.Item(Name) = Val
        Else
            m_ValueList.Add Name, Value
        End If
    End Sub
    
    Public Sub unset_var(ByVal Name)
        If m_ValueList.Exists(Name) Then m_ValueList.Remove(Name)
    End Sub
    
    Private Function InstanceValue(ByVal BlockTag)
        Dim keys, i
        InstanceValue = m_BlockList.Item(BlockTag)
        keys = m_ValueList.Keys
        For i=0 To m_ValueList.Count-1
			if not isnull(m_ValueList.Item(keys(i))) then InstanceValue = Replace(InstanceValue, "{" & keys(i) & "}", m_ValueList.Item(keys(i)))
		Next
    End Function
    
    Public Sub parse(ByVal Name, ByVal BlockTag, ByVal Append)
        If Not m_BlockList.Exists(BlockTag) Then ShowError("δָ���� ����[" & Parent&"]["&Name&"]["&Append&"]")
        If m_ValueList.Exists(Name) Then
            If Append Then m_ValueList.Item(Name) = m_ValueList.Item(Name) & InstanceValue(BlockTag) _
            Else m_ValueList.Item(Name) = InstanceValue(BlockTag)
        Else
            m_ValueList.Add Name, InstanceValue(BlockTag)
        End If
    End Sub
    
    Private Function finish(ByVal content)
        Select Case m_Unknowns
            Case "keep" finish = content
            Case "remove"
                m_RegExp.Pattern = "\{[^ \t\r\n}]+\}"
                finish = m_RegExp.Replace(content, "")
            Case "comment"
                m_RegExp.Pattern = "\{([^ \t\r\n}]+)\}"
                finish = m_RegExp.Replace(content, "<!-- Template Variable $1 undefined -->")
            Case Else finish = content
        End Select
    End Function
    
    Public Sub p(ByVal Name)
        If Not m_ValueList.Exists(Name) Then ShowError("�����ڵı��" & Name)
        Response.Write(finish(m_ValueList.Item(Name)))
    End Sub
	Public function vP(ByVal Name)
		 If Not m_ValueList.Exists(Name) Then ShowError("�����ڵı��" & Name)
          vP=finish(m_ValueList.Item(Name))
	end function
End Class
set tpl=new Template'ʵ����ģ����
tpl.set_root("/Template")'����ģ��ĸ�Ŀ¼
if USEtemplate="" then USEtemplate="Tpl_01"
%>