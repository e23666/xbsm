<!--#include virtual="/config/config.asp"-->
<%
conn.open constr
Check_Is_Master(1)
Dim dbpath, Barwidth
Action=trim(request("Action"))

If isdbsql And Action<>"SpaceSize" Then die "MSSQL��֧�����߹���"

dbpath = DBPath

Barwidth = 500
Response.Write "<html><head><title>���ݿ����</title>" & vbCrLf
Response.Write "<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbCrLf
Response.Write "<link href='../css/Admin_Style.css' rel='stylesheet' type='text/css'>" & vbCrLf
Response.Write "</head>" & vbCrLf
Response.Write "<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>" & vbCrLf
Response.Write "<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>" & vbCrLf
'Call ShowPageTitle("�� �� �� �� ��", 10009)
Response.Write "  <tr class='tdbg'>" & vbCrLf
Response.Write "    <td width='70' height='30' ><strong>��������</strong></td><td>"
Response.Write "<a href='Admin_Database.asp?Action=Backup'>�������ݿ�</a>&nbsp;|&nbsp;"
Response.Write "<a href='Admin_Database.asp?Action=Restore'>�ָ����ݿ�</a>&nbsp;|&nbsp;"
Response.Write "<a href='Admin_Database.asp?Action=Compact'>ѹ�����ݿ�</a>&nbsp;|&nbsp;"
Response.Write "<a href='Admin_Database.asp?Action=SpaceSize'>ϵͳ�ռ�ռ�����</a>"
Response.Write "    </td>" & vbCrLf
Response.Write "  </tr>" & vbCrLf
Response.Write "</table>" & vbCrLf

Select Case Action
Case "Backup"
    Call ShowBackup
Case "BackupData"
    Call BackupData
Case "Compact"
    Call ShowCompact
Case "CompactData"
    Call CompactData
Case "Restore"
    Call ShowRestore
Case "RestoreData"
    Call RestoreData
Case "Init"
    Call ShowInit
Case "Clear"
    Call ShowInit
Case "SpaceSize"
    Call SpaceSize
Case Else
    FoundErr = True
    ErrMsg = ErrMsg & "<li>���������</li>"
End Select
If FoundErr = True Then
    Call WriteErrMsg(ErrMsg, ComeUrl)
End If
Response.Write "</body></html>"
Call CloseConn

Sub ShowBackup()
    Response.Write "<form method='post' action='Admin_Database.asp?action=BackupData'>"
    Response.Write "<table width='100%' border='0' align='center' cellpadding='0' cellspacing='0' class='border'>"
    Response.Write "  <tr class='title'>"
    Response.Write "      <td align='center' height='22' valign='middle'><b>�� �� �� �� ��</b></td>"
    Response.Write "  </tr>"
    Response.Write "  <tr class='tdbg'>"
    Response.Write "    <td height='150' align='center' valign='middle'>"
    Response.Write "<table cellpadding='3' cellspacing='1' border='0' width='100%'>"
    Response.Write "  <tr>"
    Response.Write " <td width='200' height='33' align='right'>����Ŀ¼��</td>"
    Response.Write " <td><input type=text size=20 name=bkfolder value=Databackup></td>"
    Response.Write " <td>���·��Ŀ¼����Ŀ¼�����ڣ����Զ�����</td>"
    Response.Write "  </tr>"
    Response.Write "  <tr>"
    Response.Write " <td width='200' height='34' align='right'>�������ƣ�</td>"
    Response.Write " <td height='34'><input type=text size=20 name=bkDBname value='" & Date & "'></td>"
    Response.Write " <td height='34'>���������ļ�����׺��Ĭ��Ϊ��.asa����������ͬ���ļ���������</td>"
    Response.Write "  </tr>"
    Response.Write "  <tr align='center'>"
    Response.Write " <td height='40' colspan='3'><input name='submit' type=submit value=' ��ʼ���� '"
    If SystemDatabaseType = "SQL" Or ObjInstalled_FSO = False Then
        Response.Write " disabled"
    End If
    Response.Write "></td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
    If ObjInstalled_FSO = False Then
        Response.Write "<b><font color=red>��ķ�������֧�� FSO(Scripting.FileSystemObject)! ����ʹ�ñ�����</font></b>"
    End If
    Response.Write "    </td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
    Response.Write "</form>"
    If SystemDatabaseType = "SQL" Then
        Response.Write "<br><b>˵����</b><br>&nbsp;&nbsp;&nbsp;&nbsp;��ʹ�õ���SQL�棬��ֱ��ʹ��SQL2000�ṩ�����ݿⱸ�ݹ��ܽ��б��ݣ�<br><br>"
    End If
End Sub

Sub ShowCompact()
    Response.Write "<form method='post' action='Admin_Database.asp?action=CompactData'>"
    Response.Write "<table class='border' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>"
    Response.Write " <tr class='title'>"
    Response.Write "     <td align='center' height='22' valign='middle'><b>���ݿ�����ѹ��</b></td>"
    Response.Write " </tr>"
    Response.Write " <tr class='tdbg'>"
    Response.Write "     <td align='center' height='150' valign='middle'>"
    Response.Write "      <br>"
    Response.Write "      <br>"
    Response.Write "      ѹ��ǰ�������ȱ������ݿ⣬���ⷢ��������� <br>"
    Response.Write "      <br>"
    Response.Write "      <br>"
    Response.Write " <input name='submit' type=submit value=' ѹ�����ݿ� '"
    If SystemDatabaseType = "SQL" Then
        Response.Write " disabled"
    End If
    Response.Write "><br><br>"
    If ObjInstalled_FSO = False Or ObjInstalled_FSO = False Then
        Response.Write "<b><font color=red>��ķ�������֧�� FSO(Scripting.FileSystemObject)! ����ʹ�ñ�����</font></b>"
    End If
    Response.Write "    </td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
    Response.Write "</form>"
    If SystemDatabaseType = "SQL" Then
        Response.Write "<br><b>˵����</b><br>&nbsp;&nbsp;&nbsp;&nbsp;��ʹ�õ���SQL�棬�������ѹ��������<br><br>"
    End If
End Sub

Sub ShowRestore()
    Response.Write "<form method='post' action='Admin_Database.asp?action=RestoreData'>"
    Response.Write "<table width='100%' class='border' border='0' align='center' cellpadding='0' cellspacing='0'>"
    Response.Write "  <tr class='title'>"
    Response.Write "    <td align='center' height='22' valign='middle'><b>���ݿ�ָ�</b></td>"
    Response.Write "  </tr>"
    Response.Write "  <tr class='tdbg'>"
    Response.Write "    <td align='center' height='150' valign='middle'>"
    Response.Write "      <table width='100%' border='0' cellspacing='0' cellpadding='0'>"
    Response.Write "        <tr>"
    Response.Write "          <td width='200' height='30' align='right'>ԭ�������ݿ�·������ԣ���</td>"
    Response.Write "          <td height='30'><input name=backpath type=text id='backpath' value='Databackup\data.asa' size=50 maxlength='200'></td>"
    Response.Write "        </tr>"
    Response.Write "        <tr align='center'>"
    Response.Write "          <td height='40' colspan='2'><input name='submit' type=submit value=' �ָ����� '"
    If SystemDatabaseType = "SQL" Or ObjInstalled_FSO = False Then
        Response.Write " disabled"
    End If
    Response.Write ">"
    Response.Write "          </td>"
    Response.Write "        </tr>"
    Response.Write "      </table>"
    If ObjInstalled_FSO = False Then
        Response.Write "<b><font color=red>��ķ�������֧�� FSO(Scripting.FileSystemObject)! ����ʹ�ñ�����</font></b>"
    End If
    Response.Write "    </td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
    Response.Write "</form>"
    If SystemDatabaseType = "SQL" Then
        Response.Write "<br><b>˵����</b><br>&nbsp;&nbsp;&nbsp;&nbsp;��ʹ�õ���SQL�棬��ֱ��ʹ��SQL2000�ṩ�����ݿ�ָ����ܽ��лָ���<br><br>"
    Else
        Response.Write "<br><b>˵����</b><br>&nbsp;&nbsp;&nbsp;&nbsp;ԭ�������ݿ����չ������Ϊ��asa����asp<br><br>"
    End If
End Sub

Sub ShowInit()
    Dim ChannelTable, rsChannel, sqlChannel
    Response.Write "<script language = 'JavaScript'>" & vbCrLf
    Response.Write "function CheckForm(){" & vbCrLf
    Response.Write "  if(confirm('ȷʵҪ���ѡ���ı���һ��������޷��ָ���'))" & vbCrLf
    Response.Write "    {" & vbCrLf
    Response.Write "      if (document.myform.PE_User.checked==true)" & vbCrLf
    Response.Write "        {" & vbCrLf
    Response.Write "           if(confirm('��ѡ���������Ա���ݣ������ϵͳ�Ļ�Ա������ϵͳ�������ݿ⣬��һ��������޷��ָ���'))" & vbCrLf
    Response.Write "             return true;" & vbCrLf
    Response.Write "           else" & vbCrLf
    Response.Write "             return false;" & vbCrLf
    Response.Write "        }" & vbCrLf
    Response.Write "      else" & vbCrLf
    Response.Write "         return true;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  else" & vbCrLf
    Response.Write "    return false;" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function UnCheckChannel(){" & vbCrLf
    Response.Write "  if(document.myform.chkChannel.checked){" & vbCrLf
    Response.Write "    document.myform.chkChannel.checked = document.myform.chkChannel.checked&0;" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function CheckChannel(form){" & vbCrLf
    Response.Write "  for (var i=0;i<form.elements.length;i++){" & vbCrLf
    Response.Write "    var e = form.elements[i];" & vbCrLf
    Response.Write "    if (e.name){" & vbCrLf
    Response.Write "      if (e.name.substr(0,5) == 'C_PE_' && e.disabled==false)" & vbCrLf
    Response.Write "         e.checked = form.chkChannel.checked;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function UnCheckShop(){" & vbCrLf
    Response.Write "  if(document.myform.chkShop.checked){" & vbCrLf
    Response.Write "    document.myform.chkShop.checked = document.myform.chkShop.checked&0;" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function CheckShop(form){" & vbCrLf
    Response.Write "  for (var i=0;i<form.elements.length;i++){" & vbCrLf
    Response.Write "    var e = form.elements[i];" & vbCrLf
    Response.Write "    if (e.name){" & vbCrLf
    Response.Write "      if (e.name.substr(0,5) == 'S_PE_' && e.disabled==false)" & vbCrLf
    Response.Write "         e.checked = form.chkShop.checked;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf

    Response.Write "function UnCheckJob(){" & vbCrLf
    Response.Write "  if(document.myform.chkJob.checked){" & vbCrLf
    Response.Write "    document.myform.chkJob.checked = document.myform.chkJob.checked&0;" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function CheckJob(form){" & vbCrLf
    Response.Write "  for (var i=0;i<form.elements.length;i++){" & vbCrLf
    Response.Write "    var e = form.elements[i];" & vbCrLf
    Response.Write "    if (e.name){" & vbCrLf
    Response.Write "      if (e.name.substr(0,2) == 'J_' && e.disabled==false)" & vbCrLf
    Response.Write "         e.checked = form.chkJob.checked;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function UnCheckHouse(){" & vbCrLf
    Response.Write "  if(document.myform.chkHouse.checked){" & vbCrLf
    Response.Write "    document.myform.chkHouse.checked = document.myform.chkHouse.checked&0;" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function CheckHouse(form){" & vbCrLf
    Response.Write "  for (var i=0;i<form.elements.length;i++){" & vbCrLf
    Response.Write "    var e = form.elements[i];" & vbCrLf
    Response.Write "    if (e.name){" & vbCrLf
    Response.Write "      if (e.name.substr(0,2) == 'H_' && e.disabled==false)" & vbCrLf
    Response.Write "         e.checked = form.chkHouse.checked;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function UnCheckOther(){" & vbCrLf
    Response.Write "  if(document.myform.chkOther.checked){" & vbCrLf
    Response.Write "    document.myform.chkOther.checked = document.myform.chkOther.checked&0;" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "function CheckOther(form){" & vbCrLf
    Response.Write "  for (var i=0;i<form.elements.length;i++){" & vbCrLf
    Response.Write "    var e = form.elements[i];" & vbCrLf
    Response.Write "    if (e.name){" & vbCrLf
    Response.Write "      if (e.name.substr(0,3) == 'PE_' && e.disabled==false)" & vbCrLf
    Response.Write "         e.checked = form.chkOther.checked;" & vbCrLf
    Response.Write "    }" & vbCrLf
    Response.Write "  }" & vbCrLf
    Response.Write "}" & vbCrLf
    Response.Write "</script>" & vbCrLf
    Response.Write "<form action='Admin_Database.asp' method='post' name='myform' id='myform' onSubmit='return CheckForm();'>"
    Response.Write "<table class='border' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>"
    Response.Write "  <tr class='title'>"
    Response.Write "    <td align='center' height='22' valign='middle'><b>ϵ ͳ �� ʼ ��</b></td>"
    Response.Write "  </tr>"
    Response.Write "  <tr class='tdbg'>"
    Response.Write "    <td width='100%' height='150' align=center valign='middle'>"
    If Action = "Clear" Then
        Response.Write "      <div align='left'>"
        Call ClearData
        Response.Write "      </div>"
    Else
        Response.Write "      <table border='0' cellspacing='0' cellpadding='5'>"
        Response.Write "        <tr>"
        Response.Write "          <td>"
        Response.Write "            <fieldset name='ChannelData'><legend>Ƶ������ <input name='chkChannel' type='checkbox' id='chkChannel' onclick='CheckChannel(this.form)' value=''></legend><table width='600' border='0' cellpadding='0' cellspacing='5'>"

        sqlChannel = "select * from PE_Channel where ChannelType<=1 and ChannelID<>4 order by OrderID"
        Set rsChannel = Conn.Execute(sqlChannel)
        Do While Not rsChannel.EOF
            Select Case rsChannel("ModuleType")
            Case 1
                ChannelTable = "PE_Article"
            Case 2
                ChannelTable = "PE_Soft"
            Case 3
                ChannelTable = "PE_Photo"
            Case 5
                ChannelTable = "PE_Product"
            End Select
            Response.Write "              <tr>"
            Response.Write "                <td width='20%'><input name='C_PE_Class_" & rsChannel("ChannelID") & "' type='checkbox' id='C_PE_Class_" & rsChannel("ChannelID") & "' onclick='UnCheckChannel()' value='yes'> " & rsChannel("ChannelName") & "��Ŀ</td>"
            Response.Write "                <td width='20%'><input name='C_PE_Special_" & rsChannel("ChannelID") & "' type='checkbox' id='C_PE_Special_" & rsChannel("ChannelID") & "' onclick='UnCheckChannel()' value='yes'> " & rsChannel("ChannelName") & "ר��</td>"
            Response.Write "                <td width='20%'><input name='C_" & ChannelTable & "_" & rsChannel("ChannelID") & "' type='checkbox' id='C_" & ChannelTable & "_" & rsChannel("ChannelID") & "' onclick='UnCheckChannel()' value='yes'> " & rsChannel("ChannelName") & "����</td>"
            Response.Write "                <td width='20%'><input name='C_PE_Comment_" & rsChannel("ChannelID") & "' type='checkbox' id='C_PE_Comment_" & rsChannel("ChannelID") & "' onclick='UnCheckChannel()' value='yes'> " & rsChannel("ChannelName") & "����</td>"
            Response.Write "                <td width='20%'><input name='C_PE_JsFile_" & rsChannel("ChannelID") & "' type='checkbox' id='C_PE_JsFile_" & rsChannel("ChannelID") & "' onclick='UnCheckChannel()' value='yes'> " & rsChannel("ChannelName") & "JS����</td>"
            Response.Write "              </tr>"
            rsChannel.MoveNext
        Loop
        rsChannel.Close
        Set rsChannel = Nothing
        Response.Write "            </table></fieldset>"
        Response.Write "          </td>"
        Response.Write "        </tr>"
        Response.Write "        <tr>"
        Response.Write "          <td>"
        Response.Write "            <fieldset name='ShoprData'><legend>�̳����� <input name='chkShop' type='checkbox' id='chkShop' onclick='CheckShop(this.form)' value=''></legend><table width='600' border='0' cellpadding='0' cellspacing='5'>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='S_PE_OrderForm' type='checkbox' id='S_PE_OrderForm' onclick='UnCheckShop()' value='yes'> ��������</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Bank' type='checkbox' id='S_PE_Bank' onclick='UnCheckShop()' value='yes'> �����ʻ�</td>"
        Response.Write "                <td width='20%'><input name='S_PE_BankrollItem' type='checkbox' id='S_PE_BankrollItem' onclick='UnCheckShop()' value='yes'> �ʽ��¼</td>"
        Response.Write "                <td width='20%'><input name='S_PE_DeliverItem' type='checkbox' id='S_PE_DeliverItem' onclick='UnCheckShop()' value='yes'> ���˻���¼</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Payment' type='checkbox' id='S_PE_Payment' onclick='UnCheckShop()' value='yes'> ����֧����¼</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='S_PE_DeliverType' type='checkbox' id='S_PE_DeliverType' onclick='UnCheckShop()' value='yes'> �ͻ���ʽ</td>"
        Response.Write "                <td width='20%'><input name='S_PE_PaymentType' type='checkbox' id='S_PE_PaymentType' onclick='UnCheckShop()' value='yes'> ���ʽ</td>"
        Response.Write "                <td width='20%'><input name='S_PE_PresentProject' type='checkbox' id='S_PE_PresentProject' onclick='UnCheckShop()' value='yes'> ��������</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Producer' type='checkbox' id='S_PE_Producer' onclick='UnCheckShop()' value='yes'> �� �� ��</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Trademark' type='checkbox' id='S_PE_Trademark' onclick='UnCheckShop()' value='yes'> ��ƷƷ��</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='S_PE_Client' type='checkbox' id='S_PE_Client' onclick='UnCheckShop()' value='yes'> �ͻ���Ϣ</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Company' type='checkbox' id='S_PE_Company' onclick='UnCheckShop()' value='yes'> ��ҵ��Ϣ</td>"
        Response.Write "                <td width='20%'><input name='S_PE_Contacter' type='checkbox' id='S_PE_Contacter' onclick='UnCheckShop()' value='yes'> ��ϵ����Ϣ</td>"
        Response.Write "                <td width='20%'><input name='S_PE_ServiceItem' type='checkbox' id='S_PE_ServiceItem' onclick='UnCheckShop()' value='yes'> �����¼</td>"
        Response.Write "                <td width='20%'><input name='S_PE_ComplainItem' type='checkbox' id='S_PE_ComplainItem' onclick='UnCheckShop()' value='yes'> Ͷ�߼�¼</td>"
        Response.Write "              </tr>"
        Response.Write "            </table></fieldset>"
        Response.Write "          </td>"
        Response.Write "        </tr>"

        Response.Write "        <tr>"
        Response.Write "          <td>"
        Response.Write "            <fieldset name='ShoprData'><legend>��Ƹ���� <input name='chkJob' type='checkbox' id='chkJob' onclick='CheckJob(this.form)' value=''></legend><table width='600' border='0' cellpadding='0' cellspacing='5'>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='J_PE_JobCategory' type='checkbox' id='J_PE_JobCategory' onclick='UnCheckJob()' value='yes'> �������</td>"
        Response.Write "                <td width='20%'><input name='J_PE_Position' type='checkbox' id='J_PE_Position' onclick='UnCheckJob()' value='yes'> ְλ��Ϣ</td>"
        Response.Write "                <td width='20%'><input name='J_PE_PositionSupplyInfo' type='checkbox' id='J_PE_PositionSupplyInfo' onclick='UnCheckJob()' value='yes'> ����ְλ��¼</td>"
        Response.Write "                <td width='20%'><input name='J_PE_SubCompany' type='checkbox' id='J_PE_SubCompany' onclick='UnCheckJob()' value='yes'> �ֹ�˾��Ϣ</td>"
        Response.Write "                <td width='20%'><input name='J_PE_WorkPlace' type='checkbox' id='J_PE_WorkPlace' onclick='UnCheckJob()' value='yes'> �����ص�</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='J_PE_Resume' type='checkbox' id='J_PE_Resume' onclick='UnCheckJob()' value='yes'> ���˼���</td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "              </tr>"
        Response.Write "            </table></fieldset>"
        Response.Write "          </td>"
        Response.Write "        </tr>"
        Response.Write "        <tr>"
        Response.Write "          <td>"
        Response.Write "            <fieldset name='ShoprData'><legend>�������� <input name='chkHouse' type='checkbox' id='chkHouse' onclick='CheckHouse(this.form)' value=''></legend><table width='600' border='0' cellpadding='0' cellspacing='5'>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseConfig' type='checkbox' id='H_PE_HouseConfig' onclick='UnCheckHouse()' value='yes'> ������Ϣ����</td>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseCZ' type='checkbox' id='H_PE_HouseCZ' onclick='UnCheckHouse()' value='yes'> ������Ϣ</td>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseCS' type='checkbox' id='H_PE_HouseCS' onclick='UnCheckHouse()' value='yes'> ������Ϣ</td>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseQG' type='checkbox' id='H_PE_HouseQG' onclick='UnCheckHouse()' value='yes'> ����Ϣ</td>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseQZ' type='checkbox' id='H_PE_HouseQZ' onclick='UnCheckHouse()' value='yes'> ������Ϣ</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='H_PE_HouseHZ' type='checkbox' id='H_PE_HouseHZ' onclick='UnCheckHouse()' value='yes'> ������Ϣ</td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "              </tr>"
        Response.Write "            </table></fieldset>"
        Response.Write "          </td>"
        Response.Write "        </tr>"
        Response.Write "        <tr>"
        Response.Write "          <td>"
        Response.Write "            <fieldset name='OtherData'><legend>�������� <input name='chkOther' type='checkbox' id='chkOther' onclick='CheckOther(this.form)' value=''></legend><table width='600' border='0' cellpadding='0' cellspacing='5'>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='PE_Announce' type='checkbox' id='PE_Announce' onclick='UnCheckOther()' value='yes'> ��վ����</td>"
        Response.Write "                <td width='20%'><input name='PE_Advertisement' type='checkbox' id='PE_Advertisement' onclick='UnCheckOther()' value='yes'> ��վ���</td>"
        Response.Write "                <td width='20%'><input name='PE_Vote' type='checkbox' id='PE_Vote' onclick='UnCheckOther()' value='yes'> ��վ����</td>"
        Response.Write "                <td width='20%'><input name='PE_FriendSite' type='checkbox' id='PE_FriendSite' onclick='UnCheckOther()' value='yes'> ��������</td>"
        Response.Write "                <td width='20%'><input name='PE_Log' type='checkbox' id='PE_Log' onclick='UnCheckOther()' value='yes'> ��վ��־</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='PE_GuestBook' type='checkbox' id='PE_GuestBook' onclick='UnCheckOther()' value='yes'> ��������</td>"
        Response.Write "                <td width='20%'><input name='PE_Author' type='checkbox' id='PE_Author' onclick='UnCheckOther()' value='yes'> ��������</td>"
        Response.Write "                <td width='20%'><input name='PE_CopyFrom' type='checkbox' id='PE_CopyFrom' onclick='UnCheckOther()' value='yes'> ��Դ����</td>"
        Response.Write "                <td width='20%'><input name='PE_NewKeys' type='checkbox' id='PE_NewKeys' onclick='UnCheckOther()' value='yes'> �� �� ��</td>"
        Response.Write "                <td width='20%'><input name='PE_KeyLink' type='checkbox' id='PE_KeyLink' onclick='UnCheckOther()' value='yes'> վ������</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='PE_User' type='checkbox' id='PE_User' onclick='UnCheckOther()' value='yes'> ע���Ա</td>"
        Response.Write "                <td width='20%'><input name='PE_UserGroup' type='checkbox' id='PE_UserGroup' onclick='UnCheckOther()' value='yes'> �Զ����Ա��</td>"
        Response.Write "                <td width='20%'><input name='PE_ConsumeLog' type='checkbox' id='PE_ConsumeLog' onclick='UnCheckOther()' value='yes'> ������ϸ</td>"
        Response.Write "                <td width='20%'><input name='PE_Favorite' type='checkbox' id='PE_Favorite' onclick='UnCheckOther()' value='yes'> �ղؼ�¼</td>"
        Response.Write "                <td width='20%'><input name='PE_Card' type='checkbox' id='PE_Card' onclick='UnCheckOther()' value='yes'> �� ֵ ��</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='PE_Field' type='checkbox' id='PE_Field' onclick='UnCheckOther()' value='yes'> �Զ����ֶ�</td>"
        Response.Write "                <td width='20%'><input name='PE_Label' type='checkbox' id='PE_Label' onclick='UnCheckOther()' value='yes'> �Զ����ǩ</td>"
        Response.Write "                <td width='20%'><input name='PE_Item' type='checkbox' id='PE_Item' onclick='UnCheckOther()' value='yes'> �ɼ�����</td>"
        Response.Write "                <td width='20%'><input name='PE_Equipment' type='checkbox' id='PE_Equipment' onclick='UnCheckOther()' value='yes'> �ҳ��豸</td>"
        Response.Write "                <td width='20%'><input name='PE_Message' type='checkbox' id='PE_Message' onclick='UnCheckOther()' value='yes'> ���ж���Ϣ</td>"
        Response.Write "              </tr>"
        Response.Write "              <tr>"
        Response.Write "                <td width='20%'><input name='PE_Supply' type='checkbox' id='PE_Supply' onclick='UnCheckShop()' value='yes'> ������Ϣ</td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "                <td width='20%'></td>"
        Response.Write "              </tr>"
        Response.Write "            </table></fieldset>"
        Response.Write "          </td>"
        Response.Write "        </tr>"
        Response.Write "        <tr>"
        Response.Write "          <td align='center'><input name='Action' type='hidden' id='Action' value='Clear'>"
        Response.Write "            <input type='submit' name='Submit' value='�����ѡ���ݿ�����'>"
        Response.Write "          </td>"
        Response.Write "        </tr>"
        Response.Write "      </table>"
    End If
    Response.Write "    </td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
    Response.Write "</form>"
    If Action <> "Clear" Then
        Response.Write "<b>˵����</b>&nbsp;&nbsp;<font color='#FF0000'>�����ô˹��ܣ���Ϊһ��������޷��ָ���</font><br>"
    End If
End Sub

Sub SpaceSize()
    'On Error Resume Next
    Response.Write "<br><table class='border' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>"
    Response.Write "  <tr class='title'>"
    Response.Write "    <td align='center' height='22' valign='middle'><b>ϵͳ�ռ�ռ�����</b></td>"
    Response.Write "  </tr>"
    Response.Write "  <tr class='tdbg'>"
    Response.Write "    <td width='100%' height='150' valign='middle'>"
    Response.Write "    <blockquote>"
    Response.Write "      <br><b>ϵͳ�ļ�ռ�ÿռ������</b><br>"
    Response.Write "      ģ��ռ�ÿռ䣺" & ShowSpace("Template")
    Response.Write "      <br>"
    Response.Write "      ���ݿ�ռ�ÿռ䣺" & ShowSpace("Database")
    Response.Write "      <br>"
	backDatabasedir=replace(SystemAdminPath,"/","")&"/DataBaseManager/Databackup/"
	Response.Write "      �������ݿ�ռ�ÿռ䣺" & ShowSpace(backDatabasedir)
    Response.Write "      <br>"
    Response.Write "      FAQռ�ÿռ䣺" & ShowSpace("faq")
    Response.Write "      <br>"

    Response.Write "      <br>��վռ�ÿռ��ܼƣ�" & ShowSpace(" ")
    Response.Write "    </blockquote>"
    Response.Write "    </td>"
    Response.Write "  </tr>"
    Response.Write "</table>"
End Sub

function testname1(strng)
	dim oreg :Set oreg=New RegExp
	oreg.Pattern="^[\w\-]+$"
	testname1 = oreg.Test(strng)
	set oreg=nothing
end function

Sub BackupData()
    Dim bkfolder, bkdbname
    bkfolder = Trim(Request("bkfolder"))
    bkdbname = Trim(Request("bkdbname"))
	if not testname1(bkfolder) or not testname1(bkdbname) then
		FoundErr = True
        ErrMsg = ErrMsg & "<li>����Ŀ¼�����ƣ�ֻ������ĸ���ֺͺ��ߡ�</li>"
	end if
    If bkfolder = "" Then
        FoundErr = True
        ErrMsg = ErrMsg & "<li>��ָ������Ŀ¼��</li>"
    End If
    If bkdbname = "" Then
        FoundErr = True
        ErrMsg = ErrMsg & "<li>��ָ�������ļ���</li>"
    End If
    If FoundErr = True Then 
		url_return ErrMsg,-1
		Exit Sub
	end if
    bkfolder = Server.MapPath(bkfolder)
    If fso.FileExists(dbpath) Then
        If fso.FolderExists(bkfolder) = False Then
            fso.CreateFolder (bkfolder)
        End If
        fso.copyfile dbpath, bkfolder & "\" & bkdbname & ".asa"
        Call WriteSuccessMsg("�������ݿ�ɹ������ݵ����ݿ�Ϊ��<br>" & bkfolder & "\" & bkdbname & ".asa", ComeUrl)
        'Call WriteEntry(1, AdminName, "�������ݿ�")
    Else
        FoundErr = True
        ErrMsg = ErrMsg & "<li>�Ҳ���Դ���ݿ��ļ�������Conn.asp�е����á�</li>"
    End If
End Sub

Sub CompactData()
    'On Error Resume Next

    Dim Engine, strDBPath
    Call CloseConn

    strDBPath = Left(dbpath, InStrRev(dbpath, "\"))
    If fso.FileExists(dbpath) Then
        Set Engine = Server.CreateObject("JRO.JetEngine")
        Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbpath, " Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp.mdb"
        fso.copyfile strDBPath & "temp.mdb", dbpath
        fso.DeleteFile (strDBPath & "temp.mdb")
        Set Engine = Nothing
        Call WriteSuccessMsg("���ݿ�ѹ���ɹ�!", ComeUrl)
    Else
        FoundErr = True
        ErrMsg = ErrMsg & "<li>���ݿ�û���ҵ�!</li>"
    End If
    If Err.Number <> 0 Then
        FoundErr = True
        ErrMsg = ErrMsg & Err.Description
        Err.Clear
        Exit Sub
    End If
End Sub

Sub RestoreData()
    Dim backpath
    backpath = Trim(Request.Form("backpath"))
    If backpath = "" Then
        FoundErr = True
        ErrMsg = ErrMsg & "<li>��ָ��ԭ���ݵ����ݿ��ļ�����</li>"
        Exit Sub
    End If
    If GetFileExt(backpath) <> "asa" And GetFileExt(backpath) <> "asp" Then
        FoundErr = True
        ErrMsg = ErrMsg & "<li>ԭ�������ݿ��ļ�����չ������Ϊasa��asp��</li>"
        Exit Sub
    End If
    backpath = Server.MapPath(backpath)
    If fso.FileExists(backpath) Then
        fso.copyfile backpath, dbpath
        Call WriteSuccessMsg("�ɹ��ָ����ݣ�", ComeUrl)
    Else
        FoundErr = True
        ErrMsg = ErrMsg & "<li>�Ҳ���ָ���ı����ļ���</li>"
    End If
End Sub


Function ShowSpace(FolderPath)
    Dim ft, fd, fs, TotalSize, SpaceSize, FolderBarWidth, arrPath, strSize, i
    Set ft = fso.GetFolder(Server.MapPath(InstallDir))
    TotalSize = ft.size
    If TotalSize = 0 Then TotalSize = 1

    SpaceSize = 0
    arrPath = Split(FolderPath, "|")
    For i = 0 To UBound(arrPath)
        If arrPath(i) = "SiteRoot" Then
            Set fd = fso.GetFolder(Server.MapPath(InstallDir))
            For Each fs In fd.Files
                SpaceSize = SpaceSize + fs.size
            Next
        Else
            If fso.FolderExists(Server.MapPath(InstallDir & arrPath(i))) Then
                Set fd = fso.GetFolder(Server.MapPath(InstallDir & arrPath(i)))
                SpaceSize = SpaceSize + fd.size
            End If
        End If
    Next
    FolderBarWidth = CLng((SpaceSize / TotalSize) * Barwidth)

    strSize = SpaceSize & "&nbsp;Byte"
    If SpaceSize > 1024 Then
       SpaceSize = (SpaceSize / 1024)
       strSize = FormatNumber(SpaceSize, 2, vbTrue, vbFalse, vbTrue) & "&nbsp;KB"
    End If
    If SpaceSize > 1024 Then
       SpaceSize = (SpaceSize / 1024)
       strSize = FormatNumber(SpaceSize, 2, vbTrue, vbFalse, vbTrue) & "&nbsp;MB"
    End If
    If SpaceSize > 1024 Then
       SpaceSize = (SpaceSize / 1024)
       strSize = FormatNumber(SpaceSize, 2, vbTrue, vbFalse, vbTrue) & "&nbsp;GB"
    End If
    strSize = "<font face=verdana>" & strSize & "</font>"
    ShowSpace = "&nbsp;<img src='../images/bar.gif' width='" & FolderBarWidth & "' height='10' title='" & FolderPath & "'>&nbsp;" & strSize
End Function

Function GetOtherFolder()
    Dim ft, fd, strOther, strSystem, arrPath
    strSystem = "AD|Admin|AuthorPic|BlogPic|CopyFromPic|Count|Database|Editor|FriendSite|Images|Inc|JS|Language|Reg|Sdms|SiteMap|Skin|Temp|User|xml"

    Set ft = fso.GetFolder(Server.MapPath(InstallDir))
    For Each fd In ft.SubFolders
        If InStr("|" & strSystem & "|", "|" & fd.name & "|") = 0 Then
            If strOther = "" Then
                strOther = fd.name
            Else
                strOther = strOther & "|" & fd.name
            End If
        End If
    Next
    GetOtherFolder = strOther
End Function

'**************************************************
'��������ReplaceBadChar
'��  �ã����˷Ƿ���SQL�ַ�
'��  ����strChar-----Ҫ���˵��ַ�
'����ֵ�����˺���ַ�
'**************************************************
Function ReplaceBadChar(strChar)
    If strChar = "" Or IsNull(strChar) Then
        ReplaceBadChar = ""
        Exit Function
    End If
    Dim strBadChar, arrBadChar, tempChar, i
    strBadChar = "+,',%,^,&,?,(,),<,>,[,],{,},/,\,;,:," & Chr(34) & "," & Chr(0) & ",--"
    arrBadChar = Split(strBadChar, ",")
    tempChar = strChar
    For i = 0 To UBound(arrBadChar)
        tempChar = Replace(tempChar, arrBadChar(i), "")
    Next
    tempChar = Replace(tempChar, "@@", "@")
    ReplaceBadChar = tempChar
End Function
%>
