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
                      <td width="15%"><font color=#084b8f>�û�����:</font></td>
                      <td width="20%"><%=session("user_name")%></td>
                      <td width="35%">��ʹ�ý��:<%= formatNumber(session("u_usemoney"),2,-1,0)%>Ԫ</td>
                      <td width="30%">�����ѽ��:<%= session("u_resumesum") %>Ԫ</td>
                      <!--                <td><font color="084B8F">�ʻ����:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret())%> 
                  Ԫ</font></td>
              </tr>
              <tr> 
                <td><font color="084B8F">�����Ѷ�:</font></td>
                <td><font color="084B8F">< %=userAccount.getConsumption()%>Ԫ</font></td>
                <td><font color="084B8F">δ�����:</font></td>
                <td><font color="084B8F">< %=(userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret())%>Ԫ</font></td>
                <td><font color="084B8F">�����ܶ�:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret() + userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret() + userAccount.getOverdraft())%>Ԫ</font></td> -->
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
                        <p style="margin-left: 20">����λ��: <a href="/">��ҳ</a> &gt; 
                          <a href="/manager">��������</a> &gt; ������Ϣ 
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
                                  <td><%= session("user_name") %> �ʻ����: 
                                      
                                    <table align=center bgcolor=#5785B2 border=0 cellpadding=3 cellspacing=1 width="500">
                                      <tbody> 
                                      <tr bgcolor=#ffffff> 
                                        <td width="120" nowrap>Ŀǰ���:</td>
                                        <td width="358" colspan=3 nowrap bgcolor=#ffffff> 
                                          <%= session("u_level") %> </td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <td width="98" nowrap>��ʹ�ý��:</td>
                                        <td width="130" nowrap> <%= formatNumber(session("u_usemoney") ,2,-1,0)%> 
                                          Ԫ </td>
                                        <td width="98" nowrap>δ��˿���:</td>
                                        <td width="130" nowrap> <%= session("u_checkmoney") %> 
                                          Ԫ</td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <td nowrap>�Ż�ȯ:</td>
                                        <td  nowrap><%=session("u_premoney")%> 
                                          Ԫ </td>
                                        <td  nowrap>�������ܶ�:</td>
                                        <td  nowrap><%= session("u_resumesum") %>Ԫ</td>
                                      </tr>
                                      <tr bgcolor=#ffffff> 
                                        <%
										  MonthNum=requesta("MonthNum")
										  if MonthNum="" then
										  		MonthNum="3"
										  end if
										  %>
                                        <td nowrap>���<span id="MonthNum"><%=MonthNum%></span>���������ܶ</td>
                                        <td colspan=3 nowrap><span id="MonthMoney"> 
                                          <script src=MonthMoney.asp?MonthNum=<%=MonthNum%>></script>
                                          </span> 
                                          <input name="Button" type="button" value="���3����" onClick="javascript:location.href='default.asp?MonthNum=3';">
                                          <input name="Button" type="button" value="�������" onClick="javascript:location.href='default.asp?MonthNum=6';">
                                        </td>
                                      </tr>
                                      </tbody> 
                                    </table>
                                    <br>
                                    �����ѯ: 
                                    <hr color=#000000 size=1>
                                    <table align=center bgcolor=#999999 border=0 cellpadding=3 cellspacing=1 width="372">
                                      <form action="default.asp" method=post>
                                        <tr bgcolor=#ffffff> 
                                          <td width="64" nowrap bgcolor="#FFFFFF">����/������:</td>
                                          <td width="293" bgcolor="#FFFFFF"> 
                                            <input name=module value="search" type=hidden>
                                            <input name=qid1 style="font-size: 9pt" size="20" maxlength="40">
                                          </td>
                                        </tr>
                                        <tr bgcolor=#ffffff> 
                                          <td bgcolor="#FFFFFF" >ʱ ��:</td>
                                          <td bgcolor="#FFFFFF"> 
                                            <input name=qid2 style="font-size: 9pt" onClick="getDateString(this,oCalendarChs)" value="2002-1-1" size="10" maxlength="15">
                                            �� 
                                            <input name=qid3 style="font-size: 9pt" onClick="getDateString(this,oCalendarChs)" value="<%=date()%>" size="10" maxlength="15">
                                            (yyyy-mm-dd) </td>
                                        </tr>
                                        <tr bgcolor=#ffffff> 
                                          <td bgcolor="#FFFFFF">�� ��:</td>
                                          <td bgcolor="#FFFFFF"> 
                                            <input name=qid4 style="font-size: 9pt" size="20" maxlength="10">
                                            Ԫ</td>
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
                                          <td width="103" height="1" valign="bottom" bgcolor="#E8E8E8">ƾ֤����</td>
                                          <td width="53"  height="1" valign="bottom" nowrap bgcolor="#E8E8E8" >�������</td>
                                          <td width="39"  height="1" valign="bottom" bgcolor="#E8E8E8" >����</td>
                                          <td width="38"  height="1" valign="bottom" bgcolor="#E8E8E8">֧��</td>
                                          <td width="62"  height="1" valign="bottom" bgcolor="#E8E8E8">ʱ��</td>
                                          <td width="89"  height="1" valign="bottom" bgcolor="#E8E8E8" >��������</td>
                                          <td width="24"  height="1" valign="bottom" bgcolor="#E8E8E8" >״̬</td>
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
				               		Response.Write "δ��"
				                   else
				               		Response.Write "���"
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
                                        <td>ÿҳͳ��</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_moneysum%></span>��</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_in%></span>��</td>
                                        <td><span style="font-weight: bold; color: #FF0000"><%=allu_out%></span>��</td>
                                        <td colspan="3"></td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF"> 
                                          <td colspan =8 height="21"> 
                                            <div align="right"> <a href="default.asp?module=search&pages=1">��һҳ</a> 
                                              &nbsp; <a href="default.asp?module=search&pages=<%=pages-1%>">ǰһҳ</a>&nbsp; 
                                              <a href="default.asp?module=search&pages=<%=pages+1%>">��һҳ</a>&nbsp; 
                                              <a href="default.asp?module=search&pages=<%=rsPageCount%>">��<%=rsPageCount%>ҳ</a>&nbsp; 
                                              ��<%=pages%>ҳ</div>                                          </td>
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
                            <td>��ʹ�ý���ʾ�û����ʺ��������Խ������ѵĽ��ͻ������ɿͷ����߲�����Ա��Ĭ��״̬�ǣ�δ��ˡ����ǲ�Ӱ�����ѡ� 
                              �����ڵڶ��������նԸÿ��������˺󣬸ñʽ��ײŻ��Ϊ���״̬��</td>
                          </tr>
                          <tr valign="top"> 
                            <td height="31">2.</td>
                            <td height="31">�û��ڲ�ѯ���ܿ��������������������ڣ���ɲ�ѯ����Ӧ���ֱ�ӵ����������ϸ����ɲ鿴�����еĲ����¼��</td>
                          </tr>
                          <tr valign="top"> 
                            <td height="24">3.</td>
                            <td height="24"><font color="#CC0000">δ��˿���Ϊ�û�����˾�ʻ���δ��������˵��û�����ʹ�õĽ���ʾ���û����������е׵�����˾������˾������ԱΪ��δ����������˵������ʱ�������ʲ��������ӵĿ�����û���ʹ�ý��Ҳͬʱ������Ӧ�Ľ���˾������˴˻��ȷʵ���ʺ��û������δ��˿������ȥ��Ӧ��</font></td>
                          </tr>
                          <tr valign="top"> 
                            <td height="30">4.</td>
                            <td height="30">�Ż�ȯ:��˾�Ĵ�������͵Ľ������������������ʾ֡����ݿ�Ĺ�������ѡ������������������ѡ����Ż�ȯ�Ľ�Ϊ0ʱ���������������Ȳ�Ʒʱ�����ȿ��Ż�ȯ�����Ż�ȯ�����ٿۿ��ý�</td>
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

