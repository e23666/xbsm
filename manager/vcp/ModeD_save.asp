<!--#include virtual="/config/config.asp" -->
<%
conn.open constr

Account=requesta("Account")
ReferenceID=requesta("ReferenceID")
bankNo=Trim(Requesta("bankNo"))
bank=Trim(Requesta("bank"))
remitMode=Trim(Requesta("remitMode"))
from=Trim(Requesta("from"))
'Domain=Trim(requesta("Domain"))
domain="www.vcp-d-mode-user.com"

if not isNumeric(ReferenceID) then
  Response.write "<script language=javascript>alert('�������ȷ�����û���������');history.back();</script>"
  Response.end
end if

remitMethod=remitMode

' Select case remitMode
'   Case "post"
'     remitMethod="�������"
'   Case "company"
'     remitMethod="��˾ת��"
'   Case "person"
'     remitMethod="���˵��"
' end Select


Sql="Select id from Fuser Where u_id=" & ReferenceID 
Set chkRs=conn.Execute(Sql)
if not chkRs.eof then
    Response.write "<script language=javascript>alert('����,���Ѿ������ΪC/��ģʽ�û��ˣ������ٴ�����');history.back();</script>"
    Response.end
end if
   chkRs.close
   Set chkRs=nothing


Set FRs=Server.CreateObject("ADODB.RecordSet")
FRs.open "Fuser",conn,2,2
FRs.AddNew

FRs("u_id")=ReferenceID
FRs("username")=Account
FRs("C_Accounts")=bankNo
FRs("C_bank")=bank
FRs("C_RemitMode")=remitMethod
FRs("C_domain")=domain
FRs("C_dCenter")=domain
FRs("C_AgentType")=15
FRs("C_from")=from
FRs("D_end")=dateAdd("d",now,-1)
FRs("N_remain")=0
FRs("N_total")=0
FRs("N_Ptotal")=0
FRs("D_date")=now
FRs("L_ok")=1
FRs("ModeD")=1
FRs.Update

FRs.close
Set FRs=nothing

%>

<html>
<head>
<title>��vcpDģʽ��������</title>
<meta name="description" content="����ṹ-�����ϵ���������������������ע�ᡢ���������÷����̣�20�����������������ƣ�30000�û��Ĺ�ͬѡ��!���ȵ�������������,���NAS�洢�豸��ddos����ǽ��Ϊ�������Լ۱���ߵ���������!ȫ�����ȵ�˫��·�����������ϱ���ͨ���裡Cn����58Ԫ��">
<meta name="keywords" content="����ṹ-��������,,����ע��,��������,����,���������ã���ҳ�ռ�,��վ�ռ�,�����й�,����,asp�ռ�">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link href="/css/css.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<!--#include virtual="/config/top.asp"-->
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="#FFFFFF"><img src="/images/top_main_2_agent.gif" width="778" height="120"></td>
  </tr>
</table>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td > 
      <table width="100%" border="0" cellspacing="0" cellpadding="2" height="101">
        <tr> 
          <td width="201" align="right" valign="top" bgcolor="#FFFFFF" height="398"> 
            <!--#include virtual="/config/AgentLeft/AgentLeft.htm" -->
          </td>
          <td class="lineY" valign="top" height="398"></td>
          <td width="594" valign="top" bgcolor="#FFFFFF" height="398"> 
            <div align="center"> 
              <p><font color="#FF0000"><br>
                </font></p>
              <table width="95%" border="0">
                <tr>
                  <td width="15%" height="62"><img src="/images/doc_wawa.gif" width="80" height="86"></td>
                  <td width="85%" height="62"> 
                    <p><font color="#FF0000">��ϲ��</font>,�����������ɹ�!����ֻ�轫��˾��<a href="/vcp/newGetADS.asp"><font color="#0000FF">������</font></a>��������վ��Դ�ļ��м��ɣ� 
                    </p>

              </td>
                </tr>
                <tr>
                  <td width="15%">&nbsp;</td>
                  <td width="85%"><img src="/images/chakan.gif" width="32" height="32"><a href="/vcp/newGetADS.asp"><font color="#0000FF">�鿴������</font></a></td>
                </tr>
              </table>
              <p><font color="#FF0000"> </font></p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp; </p>
            </div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="1" align="center" class="line"></td>
  </tr>
  <tr> 
    <td height="1" align="center" class="line"></td>
  </tr>
</table>
  <!--#include virtual="/config/bottom.asp" -->
</body>
</html>
