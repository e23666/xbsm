<!--#include virtual="/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
module=Requesta("module")
conn.open constr
rs.open "select * from userdetail where u_id=" & session("u_sysid") & "" ,conn,3
session("u_borrormax")=rs("u_borrormax")
session("u_checkmoney")=rs("u_checkmoney")
session("u_remcount")=rs("u_remcount")
session("u_usemoney")=rs("u_usemoney")
session("u_accumulate")=rs("u_accumulate")
session("u_resumesum")=rs("u_resumesum")
session("u_premoney")=rs("u_premoney")
rs.close
conn.close

sqlstring="select * from  vhhostlist where S_ownerid="&session("u_sysid")&""
If Requesta("module")="search" Then
	If Requesta("pages")<>"" Then
		pages =strtonum(Requesta("Pages"))
		conn.open constr
		rs.open session("sqlsearch") ,conn,3
	  else
		date1=Requesta("qid2")
		u_moneysum=Requesta("qid4")
		u_countid=Requesta("qid1")
		date2=Requesta("qid3")
		sqllimit=""
		If u_countid<>"" Then sqllimit= sqllimit & " and u_countid like'%"&u_countid&"%'"
		If date1<>"" Then  sqllimit= sqllimit & " and c_date >='"&date1&"'"
		If date1<>"" Then  sqllimit= sqllimit & " and c_date <='"&date2&"'"
		If u_moneysum<>"" Then  sqllimit= sqllimit & " and u_moneysum ='"&u_moneysum&"'"
		sqlcmd= sqlstring & sqllimit
		conn.open constr
		session("sqlsearch")=sqlcmd & " order by c_check desc , s_sysid desc"
		rs.open session("sqlsearch") ,conn,3
	End If
  else
	conn.open constr
	sqlcmd= sqlstring
	session("sqlsearch")=sqlcmd & " order by s_sysid desc"
	rs.open session("sqlsearch"),conn,3
End If
%>
<STYLE type=text/css>.p12 {
	FONT-SIZE: 12px; TEXT-DECORATION: none
}
</STYLE>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">  <TBODY> 
  <TR> 
    <TD vAlign=top width=167 height="444"> 
      <DIV align=center> </DIV>
    </TD>
    <TD vAlign=top width=1 bgColor=#63a5d6 height="444"></TD>
    <TD vAlign=top align=middle height="444" width="590"> 
      <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
        <TR> 
          <TD bgColor=#cfdfef height=28> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
              <TBODY> 
              <TR> 
                <TD width="471">
                  <table cellspacing=2 cellpadding=3 width="98%" border=0>
                    <tbody> 
                    <tr> 
                      <td width="15%"><font color=#084b8f>用户名称:</font></td>
                      <td width="20%"><%=session("user_name")%></td>
                      <td width="35%">可使用金额:<%= formatNumber(session("u_usemoney"),2,-1,0)%>元</td>
                      <td width="30%">已消费金额:<%= session("u_resumesum") %>元</td>
                      <!--                <td><font color="084B8F">帐户余额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret())%> 
                  元</font></td>
              </tr>
              <tr> 
                <td><font color="084B8F">已消费额:</font></td>
                <td><font color="084B8F">< %=userAccount.getConsumption()%>元</font></td>
                <td><font color="084B8F">未审余额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret())%>元</font></td>
                <td><font color="084B8F">可用总额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret() + userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret() + userAccount.getOverdraft())%>元</font></td> -->
                    </tr>
                    </tbody> 
                  </table>
                </TD>
              </TR>
              </TBODY> 
            </TABLE>
          </TD>
        </TR>
        <TR> 
          <TD></TD>
        </TR>
        <TR valign="top"> 
          <TD> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
              <TR> 
                <TD height="561" valign="top" colspan="3"> 
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" height="73">
                    <tr> 
                      <td width="100%" height="21" colspan="3"> 
                        <p style="margin-left: 20">您的位置: <a href="/">首页</a> &gt; 
                          <a href="/manager">管理中心</a> &gt; 财务信息 
                      </td>
                    </tr>
                    <tr> 
                      <td width="100%" height="31" colspan="3">
                        <div align="right"><a href="/manager/OnlinePay.asp"><img src="/manager/images/wszf.gif" width="107" height="32" border="0"></a></div>
                      </td>
                    </tr>
                    <tr> 
                      <td width="5%" height="21"> 
                        <p> 
                      </td>
                      <td width="89%" height="21"> 
                        <table width="130" height="118" align="center" cellpadding="0" cellspacing="0"   bordercolor="#5785B2" id="AutoNumber3" style="border-collapse: collapse">
                          <tr> 
                            <td height="4" width="527" valign="top" bgcolor="#FFFFFF"> 
                              <table align=center border=0 cellpadding=0 cellspacing=0 width="500">
                                <tr> 
                                  <td><%= session("user_name") %> 帐户情况: 
                                      
                                    <table align=center bgcolor=#5785B2 border=0 cellpadding=3 cellspacing=1 width="500">
                                      <tbody> 
                                      <tr bgcolor=#ffffff> 
                                        <td width="120" nowrap>目前身份:</td>
                                        <td width="358" colspan=3 nowrap bgcolor=#ffffff> 
                                          <%= session("u_level") %> </td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <td width="98" nowrap>可使用金额:</td>
                                        <td width="130" nowrap> <%= formatNumber(session("u_usemoney") ,2,-1,0)%> 
                                          元 </td>
                                        <td width="98" nowrap>未审核款项:</td>
                                        <td width="130" nowrap> <%= session("u_checkmoney") %> 
                                          元</td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <td nowrap>优惠券:</td>
                                        <td  nowrap><%=session("u_premoney")%> 
                                          元 </td>
                                        <td  nowrap>已消费总额:</td>
                                        <td  nowrap><%= session("u_resumesum") %>元</td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <%
										  MonthNum=requesta("MonthNum")
										  if MonthNum="" then
										  		MonthNum="3"
										  end if
										  %>
                                        <td nowrap>最近<span id="MonthNum"><%=MonthNum%></span>个月消费总额：</td>
                                        <td colspan=3 nowrap><span id="MonthMoney"> 
                                          <script src=MonthMoney.asp?MonthNum=<%=MonthNum%>></script>
                                          </span> 
                                          <input name="Button" type="button" value="最近3个月" onClick="javascript:location.href='default.asp?MonthNum=3';">
                                          <input name="Button" type="button" value="最近半年" onClick="javascript:location.href='default.asp?MonthNum=6';">
                                        </td>
                                      </tr>
                                      </tbody> 
                                    </table>
                                    <br>
                                    财务查询: 
                                    <hr color=#000000 size=1>
                                    <table align=center bgcolor=#999999 border=0 cellpadding=3 cellspacing=1 width="372">
                                      <form action="default.asp" method=post>
                                        <tr bgcolor=#ffffff> 
                                          <td width="64" nowrap bgcolor="#FFFFFF">域名/主机名:</td>
                                          <td width="293" bgcolor="#FFFFFF"> 
                                            <input name=module value="search" type=hidden>
                                            <input name=qid1 style="font-size: 9pt" size="20" maxlength="40">
                                          </td>
                                        </tr>
                                        <tr bgcolor=#ffffff> 
                                          <td bgcolor="#FFFFFF" >时 间:</td>
                                          <td bgcolor="#FFFFFF"> 
                                            <input name=qid2 style="font-size: 9pt" onClick="getDateString(this,oCalendarChs)" value="2002-1-1" size="10" maxlength="15">
                                            至 
                                            <input name=qid3 style="font-size: 9pt" onClick="getDateString(this,oCalendarChs)" value="<%=date()%>" size="10" maxlength="15">
                                            (yyyy-mm-dd) </td>
                                        </tr>
                                        <tr bgcolor=#ffffff> 
                                          <td bgcolor="#FFFFFF">金 额:</td>
                                          <td bgcolor="#FFFFFF"> 
                                            <input name=qid4 style="font-size: 9pt" size="20" maxlength="10">
                                            元</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF> 
                                          <td  align=center bgcolor="#FFFFFF">&nbsp; 
                                          </td>
                                          <td bgcolor="#FFFFFF"> 
                                            <input border=0 height=18 name=img src="/images/ordersearch.gif" type=image  width=30>
                                          </td>
                                        </tr>
                                      </form>
                                    </table>
                                    <%
If Not (rs.eof And rs.bof) Then
    Rs.PageSize = 30
    rsPageCount = rs.PageCount
    flag = pages - rsPageCount
    If pages < 1 or flag > 0 then pages = 1
    Rs.AbsolutePage = pages
%>
                                    <form action="default.asp" method=post>
                                      <table align=center bgcolor=#999999 border=0 cellpadding=3 cellspacing=1 width="508" height="1">
                                        <tr align=middle  bgcolor="#FFFFFF" > 
                                          <td width="103" height="1" valign="bottom" bgcolor="#E8E8E8">凭证单号</td>
                                          <td width="53"  height="1" valign="bottom" nowrap bgcolor="#E8E8E8" >发生金额</td>
                                          <td width="39"  height="1" valign="bottom" bgcolor="#E8E8E8" >入账</td>
                                          <td width="38"  height="1" valign="bottom" bgcolor="#E8E8E8">支出</td>
                                          <td width="62"  height="1" valign="bottom" bgcolor="#E8E8E8">时间</td>
                                          <td width="89"  height="1" valign="bottom" bgcolor="#E8E8E8" >款项类型</td>
                                          <td width="24"  height="1" valign="bottom" bgcolor="#E8E8E8" >状态</td>
                                        </tr>
                              <%   i=1
		allu_moneysum=0
		allu_in=0
		allu_out=0
	Do While Not rs.eof And i<=30
		if isnull(rs("u_moneysum")) then 
			u_moneysum=0
		else
			u_moneysum=rs("u_moneysum")
		end if
		allu_moneysum=ccur(allu_moneysum)+ccur(u_moneysum)
		allu_in=ccur(allu_in)+ccur(rs("u_in"))
		allu_out=ccur(allu_out)+ccur(rs("u_out"))
	%>
                                        <tr align=middle bgcolor="#FFFFFF"> 
                                          <td width="103" height="1" valign="center"><font color="#000000"><%=rs("u_countId")%></font></td>
                                          <td width="53" height="1" valign="center"><font color="#000000"><%=u_moneysum%>.00</font></td>
                                          <td width="39" height="1" valign="center"><font color="#000000"><%=rs("u_in")%>.00</font></td>
                                          <td width="38" height="1" valign="center"><font color="#000000"><%=rs("u_out")%>.00</font></td>
                                          <td width="62" height="1" valign="center"><font color="#000000"><%=formatdatetime(rs("c_date"),2)%></font></td>
                                          <td width="89" height="1" valign="center"><font color="#000000"><%=rs("c_memo")%></font></td>
                                          <td height="1" valign="center"  > <font color="#000000"> 
                                            <%
				                If rs("c_check") Then
				               		Response.Write "未审"
				                   else
				               		Response.Write "完成"
				                End If
				                %>
                                            </font> </td>
                                        </tr>
                                        <%
		rs.movenext
		i=i+1
	Loop
	rs.close
	conn.close
	%>
    									<tr bgcolor="#E8E8E8">
                                        <td>每页统计</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_moneysum%></span>￥</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_in%></span>￥</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_out%></span>￥</td>
                                        <td colspan="3"></td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF"> 
                                          <td colspan =8 height="21"> 
                                            <div align="right"> <a href="default.asp?module=search&pages=1">第一页</a> 
                                              &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">前一页</a>&nbsp; 
                                              <a href="default.asp?module=search&pages=<%=pages+1%>">下一页</a>&nbsp; 
                                              <a href="default.asp?module=search&pages=<%=rsPageCount%>">共<%=rsPageCount%>页</a>&nbsp; 
                                              第<%=pages%>页</div>                                          </td>
                                        </tr>
                                      </table>
                                    </form>
                                    <br>
                                    <%
  else
	rs.close
	conn.close
End If

%>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                      </td>
                      <td width="6%" height="21"> </td>
                    </tr>
                    <tr> 
                      <td width="100%" height="21" colspan="3"> 
                        <table>
                          <tr valign="top"> 
                            <td>1.</td>
                            <td>可使用金额，表示用户的帐号真正可以进行消费的金额。客户汇款后，由客服或者财务人员入款，默认状态是：未审核。但是不影响消费。 
                              出纳在第二个工作日对该款项进行审核后，该笔交易才会变为审核状态。</td>
                          </tr>
                          <tr valign="top"> 
                            <td height="31">2.</td>
                            <td height="31">用户在查询功能框内输入金额数或款项发生日期，则可查询到相应款项。直接点击“财务明细”则可查看到所有的财务记录。</td>
                          </tr>
                          <tr valign="top"> 
                            <td height="24">3.</td>
                            <td height="24"><font color="#CC0000">未审核款项为用户汇款到我司帐户后未经财务审核但用户可以使用的金额表示。用户汇款并传真银行底单到我司，由我司工作人员为在未经过财务审核到帐情况时进行入帐操作后增加的款项金额，用户可使用金额也同时增加相应的金额，我司财务审核此汇款确实倒帐后，用户财务的未审核款项将减区去相应金额。</font></td>
                          </tr>
                          <tr valign="top"> 
                            <td height="30">4.</td>
                            <td height="30">优惠券:公司的促销活动赠送的金额，可用于虚拟主机、邮局、数据库的购买和续费。不能用于域名的消费。当优惠券的金额不为0时，购买虚拟主机等产品时会优先扣优惠券，若优惠券不足再扣可用金额。</td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </TD>
              </TR>
            </TABLE>
          </TD>
        </TR>
        <TR> 
          <TD bgColor=#cfdfef> </TD>
        </TR>
        <TR></TR>
      </TABLE>
    </TD>
  </TR>
</TABLE>

