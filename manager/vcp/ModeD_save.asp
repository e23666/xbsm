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
  Response.write "<script language=javascript>alert('请必须正确输入用户名与密码');history.back();</script>"
  Response.end
end if

remitMethod=remitMode

' Select case remitMode
'   Case "post"
'     remitMethod="邮政汇款"
'   Case "company"
'     remitMethod="公司转帐"
'   Case "person"
'     remitMethod="个人电汇"
' end Select


Sql="Select id from Fuser Where u_id=" & ReferenceID 
Set chkRs=conn.Execute(Sql)
if not chkRs.eof then
    Response.write "<script language=javascript>alert('错误,您已经申请成为C/Ｄ模式用户了，不能再次申请');history.back();</script>"
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
<title>－vcpD模式代理申请</title>
<meta name="description" content="代理结构-是西南地区最大的虚拟主机、域名注册、服务器租用服务商！20项虚拟主机领先优势，30000用户的共同选择!领先的虚拟主机技术,配合NAS存储设备、ddos防火墙，为您打造性价比最高的虚拟主机!全国领先的双线路虚拟主机，南北畅通无阻！Cn域名58元起！">
<meta name="keywords" content="代理结构-虚拟主机,,域名注册,主机租用,主机,服务器租用，主页空间,网站空间,主机托管,域名,asp空间">
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
                    <p><font color="#FF0000">恭喜您</font>,广告联盟申请成功!现在只需将我司的<a href="/vcp/newGetADS.asp"><font color="#0000FF">广告代码</font></a>加入您网站的源文件中即可： 
                    </p>

              </td>
                </tr>
                <tr>
                  <td width="15%">&nbsp;</td>
                  <td width="85%"><img src="/images/chakan.gif" width="32" height="32"><a href="/vcp/newGetADS.asp"><font color="#0000FF">查看广告代码</font></a></td>
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
