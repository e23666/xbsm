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
  if not isNumeric(ActID) then url_return "缺少操作ID",-1
  Select Case ProcessType
	Case "InCount"
		Sql="Select * from PayEnd Where id=" & ActID
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "没有找到此付款确认",-1
		if Rs("p_state")<>0 then url_return "付款确认的状态不是[待处理],不能入帐",-1
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
		if Rs.eof then url_return "没有找到此付款确认",-1
		U_name=Rs("UserName")
		MailBody="尊敬的用户" & Rs("Name") & "<br>&nbsp;&nbsp;您好!<p>&nbsp;&nbsp;您于" & formatDateTime(Rs("PDate"),1) & "在我司客户中心提交的付款确认(汇款方式:" & Rs("PayMethod") & ",汇款金额:" & Rs("Amount") & ",汇款日期:" & formatDateTime(Rs("PayDate"),2) & ")没有被处理,原因是<font color=red><b>" 
		MailBody=MailBody & RejectReason & "</font></b>。为了不影响您业务的正常开通,请您收到邮件后尽快更正,然后进入我司[管理中心-财务管理-付款确认查询]处点击[重新确认],我司在收到您重新确认的申请后才能重新受理您的业务"
		MailBOdy=MailBOdy & "<p>&nbsp;&nbsp;您若对此有不清楚之处,也欢迎您致电我司业务部咨询,"
		MailBody=MailBody & "<br>&nbsp;&nbsp;由此给您带来的不便之处敬请原谅,感谢您的合作,谢谢"
		MailBody=MailBody  & "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;致<br>礼"
		MailBody=MailBody & "<p>" & companyname & "<br>网址:" & companynameurl & "<br>电话:" & telphone
		Rs.close
		Sql="Select u_email from userdetail where u_name='" & U_name & "'"
		Rs.open Sql,conn,1,1
		if Rs.eof then url_return "错误,没有找到此用户",-1
		sendHtmlMail Rs("u_email"),"紧急!付款确认被拒绝",MailBody,true
		Rs.close
		Sql="Update PayEnd Set P_State=3,P_Memo='" & RejectReason & "' where id=" & ActID
		conn.Execute(Sql)
		Response.write "<script language=javascript>alert('拒绝成功,已经发邮件通知客户更正');</script>"
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
	RejectReason=prompt("请输入拒绝原因:","您在我司注册会员时所填写的资料(姓名,联系人,电话,地址等)不真实或不完整");
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
      <td height='30' align="center" ><strong> 付款确认</strong></td>
    </tr>
  </table>
  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
    <tr class='tdbg'>
      <td width='91' height='30' align="center" ><strong>管理导航：</strong></td>
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
                            <input type="button" name="Button" value="<%if FilterType=0 then Response.write "★"%>待处理" onClick="this.form.FilterType.value=0;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button2" value="<%if FilterType=1 then Response.write "★"%>已处理" onClick="this.form.FilterType.value=1;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button22" value="<%if FilterType=3 then Response.write "★"%>已拒绝" onClick="this.form.FilterType.value=3;this.form.submit();">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">共<%=PageCount%>页</font></td>
                          <td align="center" class="tdbg"><font size="2">第<%=Page%>页</font></td>
                        </tr>
                        <tr>
                          <td align="center" class="tdbg"><font size="2">用户名:</font></td>
                          <td class="tdbg"><font size="2">
                            <input type="text" name="UserName" size="10" maxlength="50" value="<%=UserName%>">
                            </font></td>
                          <td align="center" class="tdbg"><font size="2">
                            <input type="button" name="Button222" value="查找" onClick="this.form.submit();">
                            <input type="hidden" name="ProcessType" >
                            <input type="hidden" name="FilterType" value="<%=FilterType%>">
                            <input type="hidden" name="Actid">
                            <input type="hidden" name="Page" value="<%=page%>">
                            <input type="hidden" name="RejectReason">
                            </font></td>
                          <td align="center" class="tdbg"><input type="button" name="Button" value="上一页" onClick="this.form.Page.value=parseInt(this.form.Page.value)-1;this.form.submit();">
                          </td>
                          <td align="center" class="tdbg"><input type="button" name="Submit4" value="下一页" onClick="this.form.Page.value=parseInt(this.form.Page.value)+1;this.form.submit();">
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
                              <input type="button" name="Button" value="入帐" onClick="this.form.ProcessType.value='InCount';this.form.Actid.value=<%=Rs("id")%>;this.form.submit();">
                              <input type="button" name="Submit3" value="拒绝" onClick="Reject(this.form,<%=Rs("id")%>)">
                              <input type="button" name="Submit2" value="删除" onClick="if (confirm('你确信删除此付款确认?')){this.form.ProcessType.value='Erase';this.form.Actid.value=<%=Rs("id")%>;this.form.submit();}">
                              </font></div></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">id：</font></td>
                          <td class="tdbg"><font color="#FF0000" size="2"><%=rs("id")%>　</font></td>
                          <td colspan="2" align="center" class="tdbg"><font size="2">用户所填资料</font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">姓名：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Name")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">姓名/单位名:<%=u_nameCn%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">用户名：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("UserName")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">英文:<%=u_nameEn%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">订单号：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Orders")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">联系人:<%=u_contract%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">汇款日期：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("PayDate")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">城市:<%=u_city%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">金额：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Amount")%> </font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">地址:<%=u_address%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">方式：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("PayMethod")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">电话:<%=u_telPhone%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">用途:</font></td>
                          <td class="tdbg"><font size="2"><%=rs("ForUse")%> &nbsp;</font></td>
                          <td colspan="2" class="tdbg"><font size="2" color="#000000">Email:<%=u_email%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">备注：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Memo") & "&nbsp;"%> </font></td>
                          <td rowspan="3" class="tdbg"><font size="2" color="#000000">注册IP:</font></td>
                          <td rowspan="3" class="tdbg"><font color="#000000" size="2"><%=u_ip%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">提交时间：</font></td>
                          <td class="tdbg"><font size="2"><%=rs("Pdate") & "&nbsp;"%></font></td>
                        </tr>
                        <tr>
                          <td class="tdbg"><font size="2">提交IP:</font></td>
                          <td class="tdbg"><font size="2"><%=rs("subip") & "&nbsp;"%></font></td>
                        </tr>
                        <%if FilterType=3 then%>
                        <tr>
                          <td class="tdbg"><font size="2">拒绝原因:</font></td>
                          <td colspan="3" class="tdbg"><font size="2">&nbsp;</font><font size="2">&nbsp;</font><font size="2"><%=rs("P_Memo") & "&nbsp;"%></font></td>
                        </tr>
                        <%end if%>
                        <%if rs("P_Pic")<>"" then
f_name=rs("P_Pic")
%>
                        <tr>
                          <td class="tdbg"><FONT SIZE="2">附图:</FONT></td>
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
