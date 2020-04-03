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
    <td height='30' align="center" ><strong> 域名管理</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
    <td width="771"><span style="margin-left: 20"><a href="default.asp">域名管理</a></span> | <a href="ModifyDomain.asp">域名日期校正</a> | <a href="DomainIn.asp">域名转入</a> | <a href="http://www.cnnic.net.cn/html/Dir/2003/10/29/1112.htm" target="_blank">中文域名转码</a> | <a href="../admin/HostChg.asp">业务过户 </a></td>
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
    Alert_Redirect "删除成功","PreDomain.asp"
  elseif module="Over" then

	if left(Session("results"),3)="200" then
        Sql="update PreDomain set opened="&PE_True&" Where d_id=" & OrderID
        conn.Execute(Sql)
		Response.write "<div align=center><img src=/images/process.jpg><br><br>域名实时注册成功，该域名将在24小时内生效"

		orderid = getstrReturn(Session("results")&vbCrLf , "orderid")
		 mailbodys= mailbodys & "尊敬的客户：您好！" & vbCrLf
		 mailbodys= mailbodys & "您的订单#" & orderid &"(域名:" & Requesta("keyword") &",管理密码:" & Requesta("Password") & "）已注册成功，域名在24小时后可正常使用（如果是中国国家域名则5天后可正常使用）。" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "若您申请域名时，所填写的DNS是我公司的，则可使用我公司域名管理系统进行域名解析等管理工作。操作方式：进入管理中心—域名管理，点击该域名进入控制面板，点击DNS解析记录管理，进入增加IP，完成域名解析。" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "同时您也可以登陆http://www.myhostadmin.net/，输入域名和域名密码进行独立域名控制面板。" & vbCrLf
		 mailbodys= mailbodys & "登陆管理中心，可对域名进行完善的管理（如：修改域名注册信息、域名DNS解析管理、修改域名DNS、域名续费等）。" & vbCrLf
	     mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & " " & vbCrLf
		 mailbodys= mailbodys & "" & vbCrLf
		 mailbodys= mailbodys & "Tel:" & telphone & vbCrLf
		 mailbodys= mailbodys & "Email:" & supportmail & vbCrLf
		 mailbodys= mailbodys & companynameurl

		Call sendMail(Trim(Requesta("Email")),"域名开通通知",mailbodys)

    else
		Response.write "<div align=center><img src=/images/process.jpg><br><br>域名开通失败，请与管理员联系，或检查您的帐上是否有足够余额!</div>&nbsp;&nbsp;RESULT:" & Session("results")
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
			url_return "定单号只能为数字！",-1
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
                              <td width="32%" align="right" class="tdbg">订单号：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SOrderNo" maxlength="20" size="10">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">域名：</td>
                              <td colspan="2" class="tdbg"> 
                                <input type="text" name="SDomain" maxlength="50" size="20">                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">用户名:</td>
                              <td width="14%" class="tdbg"> 
                                <input type="text" name="SUserName" maxlength="20" size="10">                              </td>
                              <td width="54%" class="tdbg"> 
                                <input type="submit" name="Submit" value="查找">                              </td>
                            </tr>
                            <tr> 
                              <td colspan="3" class="tdbg"><a href=PreDomain.asp?page=<%=page-1%>>上一页</a>,<a href=PreDomain.asp?page=<%=Page+1%>>下一页</a>,共<%=PageCount%>页,第<%=Page%>页</td>
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
                              <td width="74%" class="tdbg">域名注册订单</td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">用户名:</td>
                              <td class="tdbg"><%=Rs("UserName")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 订单号: </td>
                              <td class="tdbg"><%=int(Rs("d_id"))+100000%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 下单日期: </td>
                              <td class="tdbg"><%=rs("regdate")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 域名: </td>
                              <td class="tdbg"><%=Rs("strDomain")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">年限：</td>
                              <td class="tdbg"><%=Rs("years")%>年 </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> 单价: </td>
                              <td class="tdbg"><%=GetNeedPrice(Rs("UserName"),rs("proid"),Rs("years"),"new")%>元 
                              </td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">注册人: </td>
                              <td colspan="2" class="tdbg"><%=Rs("dom_org")%> 
                              </td>
                            </tr>
                            <tr>
                              <td align="right" class="tdbg">注册人（中文）：</td>
                              <td valign="top" class="tdbg"><%=Rs("dom_org_m")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg">地址: </td>
                              <td valign="top" class="tdbg"><%=Rs("dom_adr1")%></td>
                            </tr>
                            <tr> 
                              <td align="right" class="tdbg"> Email: </td>
                              <td valign="top" class="tdbg"><%=Rs("dom_em")%></td>
                            </tr>
                            <tr> 
                              <td colspan="2" align="right" class="tdbg">
                                <input type="button" name="button" id="button" value="编辑订单" onClick="javascript:location.href='modifyorder.asp?domainid=<%=Rs("d_id")%>';" /> <input type="button" name="Button" value="正式注册" onClick="window.location.href='RegCn.asp?module=Open&OrderID=<%=Rs("d_id")%>';">
                                <input type="button" name="Submit2" value="删除订单" onClick=" if(confirm('确定要删除?')){this.form.module.value='Erase';this.form.OrderID.value=<%=Rs("d_id")%>;this.form.submit();}else{return false}" >
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
