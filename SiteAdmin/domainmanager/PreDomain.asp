<%
Response.buffer=false
%>
<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(6)%>
<%
conn.open constr



module=Trim(Requesta("module"))
OrderID=Trim(Requesta("OrderID"))
Opened=Trim(Requesta("Opened"))
%>

<STYLE type=text/css>.p12 {
	FONT-SIZE: 12px; TEXT-DECORATION: none
}
</STYLE>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>

<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong> ��������</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">��������</a></span> | <a href="ModifyDomain.asp">��������У��</a> | <a href="DomainIn.asp">����ת��</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">��������ת��</a> | <a href="../admin/HostChg.asp">ҵ����� </a></td>
  </tr>
</table>
      <br />
<TABLE width=100% border=0 cellPadding=0 cellSpacing=0>
  <TBODY> 
  <TR> 
    <TD vAlign=top align=middle> 
      <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
        <TBODY> 
        <TR> 
          <TD></TD>
        </TR>
        <TR valign="top"> 
          <TD> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
              <TBODY> 
              <TR> 
                <TD height="561" valign="top" colspan="3"> 
                  <%
  if module="Erase" then
    Sql="Delete from PreDomain Where d_id=" & OrderID 
    conn.Execute(Sql)
    Alert_Redirect "ɾ���ɹ�","PreDomain.asp"
  elseif module="Over" then

	if left(Session("results"),3)="200" then
        Sql="update PreDomain set opened="&PE_True&" Where d_id=" & OrderID
        conn.Execute(Sql)
		Response.write "<div align=center><img src=/images/process.jpg><br><br>����ʵʱע��ɹ�������������24Сʱ����Ч"

		orderid = getstrReturn(Session("results")&vbCrLf , "orderid")
		 mailbodys= mailbodys & "�𾴵Ŀͻ������ã�" & vbCrLf
		 mailbodys= mailbodys & "���Ķ���#" & orderid &"(����:" & Requesta("keyword") &",��������:" & Requesta("Password") & "����ע��ɹ���������24Сʱ�������ʹ�ã�������й�����������5��������ʹ�ã���" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "������������ʱ������д��DNS���ҹ�˾�ģ����ʹ���ҹ�˾��������ϵͳ�������������ȹ�������������ʽ������������ġ���������������������������壬���DNS������¼������������IP���������������" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "ͬʱ��Ҳ���Ե�½http://www.myhostadmin.net/����������������������ж�������������塣" & vbCrLf
		 mailbodys= mailbodys & "��½�������ģ��ɶ������������ƵĹ����磺�޸�����ע����Ϣ������DNS���������޸�����DNS���������ѵȣ���" & vbCrLf
	     mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & " " & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "Tel:" & telphone & vbCrLf
		 mailbodys= mailbodys & "Email:" & supportmail & vbCrLf
		 mailbodys= mailbodys & companynameurl

		Call sendMail(Trim(Requesta("Email")),"������֪ͨͨ",mailbodys)

    else
		Response.write "<div align=center><img src=/images/process.jpg><br><br>������ͨʧ�ܣ��������Ա��ϵ���������������Ƿ����㹻���!</div>&nbsp;&nbsp;RESULT:" & Session("results")
		response.write replace(session("mystrs"),vbCrLf,"<br>")
    end if

  elseif module="" then
	Sql="Select top 20 dom_org_m,d_id,regdate,username, strDomain, years, proid, dom_org, dom_adr1, opened, dom_em from PreDomain where opened<>"&PE_True&" "
	Page=Trim(Requesta("Page"))
	if not isNumeric(page) then Page=1
	Page=Cint(Page)
	PageSize=5
	SOrderNo=Trim(Requesta("SOrderNo"))
	if SOrderNo<>"" then
		if not isnumeric(SOrderNo) then
			url_return "������ֻ��Ϊ���֣�",-1
		end if
	SOrderNo=int(SOrderNo)-100000
	end if
	
	
	SDomain=Trim(Requesta("SDomain"))
	SUserName=Trim(Requesta("SUserName"))
	if SOrderNo<>"" then Sql=Sql & " and d_id=" & SOrderNo
	if SDomain<>"" then Sql=Sql & "  and strDomain='" & SDomain & "'"
	if SUserName<>"" then Sql=Sql & " and UserName='" & SUserName & "'"
	Sql=Sql & " order by d_id desc"
	Rs.open Sql,conn,3,2
	if Not Rs.eof then
		Rs.PageSize=PageSize
		PageCount=Rs.PageCount
		if Page<1 or Page>PageCount then Page=1
		Rs.AbsolutePage=Page
	end if
%>
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" height="73">
                    <tr> 
                      <td width="100%" height="31" colspan="3" valign="top"> 
                        <form name="form1" method="post" action="PreDomain.asp">
                          <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolordark="#FFFFFF" class="border">
                            <tr> 
                              <td width="32%" align="right" class="tdbg">�����ţ�</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SOrderNo" maxlength="20" size="10">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">������</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SDomain" maxlength="50" size="20">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">�û���:</td>
                              <td width="14%" class="tdbg"> 
                                <input type="text" name="SUserName" maxlength="20" size="10">                              </td>
                              <td width="54%" class="tdbg"> 
                                <input type="submit" name="Submit" value="����">                              </td>
                            </tr>
                            <tr> 
                              <td colspan="3" class="tdbg"><a href=PreDomain.asp?page=<%=page-1%>>��һҳ</a>,<a href=PreDomain.asp?page=<%=Page+1%>>��һҳ</a>,��<%=PageCount%>ҳ,��<%=Page%>ҳ</td>
                            </tr>
                          </table>
                          <br>
                          <%
	i=1
	do while not Rs.eof and i<=pageSize
%>
                                
                          <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#000000" bordercolordark="#ffffff" class="border">
                            <tr> 
                              <td colspan="2" class="tdbg"><font size="2"><img src="/images/dnsline.gif" width="100%" height="1"></font></td>
                            </tr>
                            <tr> 
                              <td width="26%" align="right" class="tdbg"><%=Rs("opened")%>&nbsp; </td>
                              <td width="74%" class="tdbg">����ע�ᶩ��</td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">�û���:</td>
                              <td class="tdbg"><%=Rs("UserName")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> ������: </td>
                              <td class="tdbg"><%=int(Rs("d_id"))+100000%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> �µ�����: </td>
                              <td class="tdbg"><%=rs("regdate")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> ����: </td>
                              <td class="tdbg"><%=Rs("strDomain")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">���ޣ�</td>
                              <td class="tdbg"><%=Rs("years")%>�� </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> ����: </td>
                              <td class="tdbg"><%=GetNeedPrice(Rs("UserName"),rs("proid"),Rs("years"),"new")%>Ԫ 
                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">ע����: </td>
                              <td colspan="2" class="tdbg"><%=Rs("dom_org")%> 
                              </td>
                            </tr>
                            <tr>
                              <td align="right" class="tdbg">ע���ˣ����ģ���</td>
                              <td valign="top" class="tdbg"><%=Rs("dom_org_m")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">��ַ: </td>
                              <td valign="top" class="tdbg"><%=Rs("dom_adr1")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> Email: </td>
                              <td valign="top" class="tdbg"><%=Rs("dom_em")%></td>
                            </tr>
                            <tr> 
                              <td colspan="2" align="right" class="tdbg">
                                <input type="button" name="button" id="button" value="�༭����" onClick="javascript:location.href='modifyorder.asp?domainid=<%=Rs("d_id")%>';" /> <input type="button" name="Button" value="��ʽע��" onClick="window.location.href='RegCn.asp?module=Open&OrderID=<%=Rs("d_id")%>';">
                                <input type="button" name="Submit2" value="ɾ������" onClick=" if(confirm('ȷ��Ҫɾ��?')){this.form.module.value='Erase';this.form.OrderID.value=<%=Rs("d_id")%>;this.form.submit();}else{return false}" >
                              </td>
                            </tr>
                            <tr> 
                              <td colspan="2" class="tdbg"> <img src="/images/dnsline.gif" width="100%" height="1"></td>
                            </tr>
                          </table>
                          <%
	i=i+1
	Rs.MoveNext
Loop
	Rs.close
%>
                          <input type="hidden" name="module">
                          <input type="hidden" name="OrderID" value="">
                          <br>
                        </form>
                      </td>
                    </tr>
                  </table>
                  
                  
                </TD>
              </TR>
              </TBODY> 
            </TABLE>
          </TD>
        </TR>
        <TR> 
          <TD bgColor=#cfdfef> </TD>
        </TR>
        <TR></TR>
        </TBODY> 
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>

<%
end if

	
function Gbkcode(byval strdomain)
	on error resume next
  	   PHPURL="http://beianmii.gotoip1.com/idna/api.php?a=decode&p="&strdomain& "&pasd="& timer()
	  Set XMLobj=Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	  XMLobj.setTimeouts 10000, 10000, 10000, 30000  
	  XMLobj.open "GET",PHPURL,false
	  XMLobj.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	  XMLobj.send
	  retCode=XMLobj.ResponseText
	  Set XMLobj=nothing
	  Gbkcode=retCode'myinstr(retCode,":\s+([\w\.\-]+)\s*</pre>")
end function


conn.close

%><!--#include virtual="/config/bottom_superadmin.asp" -->
