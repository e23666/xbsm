<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(3)%>
<%



Set Rs2=Server.CreateObject("ADODB.RecordSet")
conn.open constr
ProcessType=Trim(Requesta("ProcessType"))
FilterType=Trim(Requesta("FilterType"))
ActID=Trim(Requesta("ActID"))
UserName=Trim(Requesta("UserName"))
Page=Trim(Requesta("page"))
RejectReason=Trim(Requesta("RejectReason"))


Sql="Select count(*) as TotalR from countlist where c_check="&PE_True&" and left(u_countid,5)='(OL)-'"
Rs.open Sql,conn,1,1
TotalRecord=0
If Not Rs.eof  Then
  If isNumeric(Rs("TotalR")) Then
	TotalRecord=Rs("TotalR")
  End If
End If
Rs.close
TotalHeight=TotalRecord*35+35
if ProcessType<>"" then
  if not isNumeric(ActID) then url_return "ȱ�ٲ���ID",-1
  Select Case ProcessType
	Case "InCount"
		Sql="Select * from PayEnd Where id=" & ActID
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "û���ҵ��˸���ȷ��",-1
		if Rs("p_state")<>0 then url_return "����ȷ�ϵ�״̬����[������],��������",-1
		thisPayTime=rs("PayDate")
		if IsDate(thisPayTime)=true then
			thisPayTime=year(thisPayTime)&"-"&month(thisPayTime)&"-"&day(thisPayTime)
		else
			thisPayTime=""
		end if
		'URL="OurMoney.asp?name=" & Rs("Name") & "&username=" & rs("username") & "&money=" & rs("Amount") & "&hktype=" & rs("PayMethod") & "&Orders=" & Replace(rs("Orders"),"#","") & "&id=" & ActID &"&PayTime="&thisPayTime
		URL="incount.asp?name=" & Rs("Name") & "&username=" & rs("username") & "&money=" & rs("Amount") & "&hktype=" & rs("PayMethod") & "&Orders=" & Replace(rs("Orders"),"#","") & "&PayendID=" & ActID &"&PayTime="&thisPayTime&"&module=PayEnd"
		Rs.close
		Response.ReDirect URL
	Case "Reject"
		Sql="Select * from PayEnd Where id=" & ActID
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "û���ҵ��˸���ȷ��",-1
		U_name=Rs("UserName")
		MailBody="�𾴵��û�" & Rs("Name") & "<br>&nbsp;&nbsp;����!<p>&nbsp;&nbsp;����" & formatDateTime(Rs("PDate"),1) & "����˾�ͻ������ύ�ĸ���ȷ��(��ʽ:" & Rs("PayMethod") & ",�����:" & Rs("Amount") & ",�������:" & formatDateTime(Rs("PayDate"),2) & ")û�б�����,ԭ����<font color=red><b>" 
		MailBody=MailBody & RejectReason & "</font></b>��Ϊ�˲�Ӱ����ҵ���������ͨ,�����յ��ʼ��󾡿����,Ȼ�������˾[��������-�������-����ȷ�ϲ�ѯ]�����[����ȷ��],��˾���յ�������ȷ�ϵ���������������������ҵ��"
		MailBOdy=MailBOdy & "<p>&nbsp;&nbsp;�����Դ��в����֮��,Ҳ��ӭ���µ���˾ҵ����ѯ,"
		MailBody=MailBody & "<br>&nbsp;&nbsp;�ɴ˸��������Ĳ���֮������ԭ��,��л���ĺ���,лл"
		MailBody=MailBody  & "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<br>��"
		MailBody=MailBody & "<p>" & companyname & "<br>��ַ:" & companynameurl & "<br>�绰:" & telphone
		Rs.close
		Sql="Select u_email from userdetail where u_name='" & U_name & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "����,û���ҵ����û�",-1
		sendHtmlMail Rs("u_email"),"����!����ȷ�ϱ��ܾ�",MailBody,true
		Rs.close
		Sql="Update PayEnd Set P_State=3,P_Memo='" & RejectReason & "' where id=" & ActID
		conn.Execute(Sql)
		Response.write "<script language=javascript>alert('�ܾ��ɹ�,�Ѿ����ʼ�֪ͨ�ͻ�����');</script>"
	Case "Erase"
		Sql="Delete from PayEnd Where id=" & ActID
		conn.Execute(Sql)
  end Select
end if

if not isNumeric(Page) then Page=1
Page=Cint(Page)
if not isNumeric(FilterType) then FilterType=0
Sql="Select * from PayEnd Where P_State=" & FilterType
if UserName<>"" then Sql=Sql & " and UserName like '%" & UserName &  "%'"
Sql=Sql & " Order by PDate Desc"

Rs.Open Sql,conn,3,3
Rs.PageSize=5
  PageCount=0
if Not Rs.eof Then
  PageCount=Rs.PageCount
  if Page<1 then page=1
  if Page>Rs.PageCount then Page=Rs.PageCount
  Rs.AbsolutePage=Page
end if
%>
<script language=javascript>
function Reject(form,strID){
	RejectReason=prompt("������ܾ�ԭ��:","������˾ע���Աʱ����д������(����,��ϵ��,�绰,��ַ��)����ʵ������");
	if (RejectReason!=null) {
		form.RejectReason.value=RejectReason;
		form.Actid.value=strID;
		form.ProcessType.value="Reject";
		form.submit();
	}
	return true;
}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<style type="text/css">
<!--
.STYLE4 {
	color: #FF0000
}
-->
</style>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<div align="left">
  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
    <tr class='topbg'>
      <td height='30' align="center" ><strong> ����ȷ��</strong></td>
    </tr>
  </table>
  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
    <tr class='tdbg'>
      <td width='91' height='30' align="center" ><strong>��������</strong></td>
      <td width="771">&nbsp;</td>
    </tr>
  </table>
  <br />
  <form method="post" action="<%=Requesta("SCRIPT_NAME ")%>" name="biaodan">
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td valign="top"><!--  BODY  -->
          <table width="100%" height="218" align="center" cellPadding="0" cellSpacing="0"   borderColor="#FFFFFF" id="AutoNumber3" style="border-collapse: collapse">
            <tr>
              <td height="175" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="2" height="49" ><table width="100%" border="0" cellpadding="3" cellspacing="0" class="border">
                        <tr>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button" value="<%if FilterType=0 then Response.write "��"%>������" onClick="this.form.FilterType.value=0;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button2" value="<%if FilterType=1 then Response.write "��"%>�Ѵ���" onClick="this.form.FilterType.value=1;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button22" value="<%if FilterType=3 then Response.write "��"%>�Ѿܾ�" onClick="this.form.FilterType.value=3;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">��<%=PageCount%>ҳ</font></td>
                          <td align="center" class="tdbg"><font size="2">��<%=Page%>ҳ</font></td>
                        </tr>
                        <tr>
                          <td align="center" class="tdbg"><font size="2">�û���:</font></td>
                          <td class="tdbg"><font size="2">
                            <input type="text" name="UserName" size="10" maxlength="50" value="<%=UserName%>">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button222" value="����" onClick="this.form.submit();">
                            <input type="hidden" name="ProcessType" >
                            <input type="hidden" name="FilterType" value="<%=FilterType%>">
                            <input type="hidden" name="Actid">
                            <input type="hidden" name="Page" value="<%=page%>">
                            <input type="hidden" name="RejectReason">
                            </font></td>
                          <td align="center" class="tdbg"><input type="button" name="Button" value="��һҳ" onClick="this.form.Page.value=parseInt(this.form.Page.value)-1;this.form.submit();">
                          </td>
                          <td align="center" class="tdbg"><input type="button" name="Submit4" value="��һҳ" onClick="this.form.Page.value=parseInt(this.form.Page.value)+1;this.form.submit();">
                          </td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr valign="top" align="center">
                    <td colspan="2"><%If TotalHeight>35 Then
%>
                      <iframe src="OLcheck.asp" width=620 align=center frameborder=0 height=<%=TotalHeight%> scrolling=auto vspace=0 hspace=0 marginwidth=0 marginheight=0></iframe>
                      <%
End If%>
                      <%
i=1
Do While Not Rs.eof and i<=5
  Sql="Select * from userdetail where u_name='" & Rs("UserName") & "'"
  Rs2.open Sql,conn,1,1
 if Not Rs2.eof then
    u_nameCN=Rs2("u_namecn")
	u_nameEn=Rs2("u_nameEn")
	u_contract=Rs2("u_contract")
	u_city=Rs2("u_city")
	u_address=Rs2("u_address")
	u_telphone=Rs2("u_telphone")
	u_email=Rs2("u_email")
	u_ips=Rs2("u_ip")
	u_ip=""
	jj=0
	if trim(u_ips)&""<>"" then
		for each ipItem in split(u_ips,",")
			ipItem=trim(ipItem)
			if trim(ipItem)&""<>"" and inStr(ipItem,"|")>0 then
				newIpItem=split(ipItem,"|")
				if ubound(newipItem)>=1 then
					u_ip=u_ip & newipItem(0) & "<br>"
					if jj>4 then exit for
					jj=jj+1
				end if
			end if

		next
	end if
 end if
	Rs2.close
%>
                      <table width="100%" border="0" cellpadding="2" cellspacing="1" bordercolorlight="#000000" bordercolordark="#FFFFFF" bgcolor="#FFFFFF" class="border">
                        <tr valign="bottom">
                          <td colspan="4" class="tdbg"><div align="center"> <font size="2">
                              <input type="button" name="Button" value="����" onClick="this.form.ProcessType.value='InCount';this.form.Actid.value=<%=Rs("id")%>;this.form.submit();">
                              <input type="button" name="Submit3" value="�ܾ�" onClick="Reject(this.form,<%=Rs("id")%>)">
                              <input type="button" name="Submit2" value="ɾ��" onClick="if (confirm('��ȷ��ɾ���˸���ȷ��?')){this.form.ProcessType.value='Erase';this.form.Actid.value=<%=Rs("id")%>;this.form.submit();}">
                              </font></div></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">id��</font></td>
                          <td class="tdbg"><font color="#FF0000" size="2"><%=rs("id")%>��</font></td>
                          <td colspan="2" align="center" class="tdbg"><font size="2">�û���������</font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">������</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Name")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">����/��λ��:<%=u_nameCn%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">�û�����</font></td>
                          <td class="tdbg"><font size="2"><%=rs("UserName")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">Ӣ��:<%=u_nameEn%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">�����ţ�</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Orders")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">��ϵ��:<%=u_contract%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">������ڣ�</font></td>
                          <td class="tdbg"><font size="2"><%=rs("PayDate")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">����:<%=u_city%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">��</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Amount")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">��ַ:<%=u_address%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">��ʽ��</font></td>
                          <td class="tdbg"><font size="2"><%=rs("PayMethod")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">�绰:<%=u_telPhone%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">��;:</font></td>
                          <td class="tdbg"><font size="2"><%=rs("ForUse")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">Email:<%=u_email%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">��ע��</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Memo") & "&nbsp;"%> </font></td>
                          <td rowspan="3" class="tdbg"><font size="2" color="#000000">ע��IP:</font></td>
                          <td rowspan="3" class="tdbg"><font color="#000000" size="2"><%=u_ip%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">�ύʱ�䣺</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Pdate") & "&nbsp;"%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">�ύIP:</font></td>
                          <td class="tdbg"><font size="2"><%=rs("subip") & "&nbsp;"%></font></td>
                        </tr>
                        <%if FilterType=3 then%>
                        <tr>
                          <td class="tdbg"><font size="2">�ܾ�ԭ��:</font></td>
                          <td colspan="3" class="tdbg"><font size="2">&nbsp;</font><font size="2">&nbsp;</font><font size="2"><%=rs("P_Memo") & "&nbsp;"%></font></td>
                        </tr>
                        <%end if%>
                        <%if rs("P_Pic")<>"" then
f_name=rs("P_Pic")
%>
                        <tr>
                          <td class="tdbg"><FONT SIZE="2">��ͼ:</FONT></td>
                          <td colspan="3" class="tdbg"><a href=<%=f_name%> target=_blank><img src="<%=f_name%>" border=0 WIDTH="428" HEIGHT="75"></a></td>
                        </tr>
                        <%end if%>
                      </table>
                      <br>
                      <hr size="1">
                      <%
Rs.moveNext
i=i+1
Loop
Rs.close
%>
                      <p>&nbsp;</p></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          <!--  BODY END -->
        </td>
      </tr>
    </table>
  </form>
</div>
<!--#include virtual="/config/bottom_superadmin.asp" -->
