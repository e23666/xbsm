<TABLE border=0 align="right" cellPadding=5 cellSpacing=0> 
<TR> <TD nowrap>�û�����:</TD>
<TD nowrap><%=session("user_name")%></TD><TD nowrap>��ʹ�ý��:<%=session("u_usemoney")%>Ԫ</TD><TD nowrap>�����ѽ��:<%=session("u_resumesum")%>Ԫ</TD><!--                <td><font color="084B8F">�ʻ����:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret())%> 
                  Ԫ</font></td>
              </tr>
              <tr> 
                <td><font color="084B8F">�����Ѷ�:</font></td>
                <td><font color="084B8F">< %=userAccount.getConsumption()%>Ԫ</font></td>
                <td><font color="084B8F">δ�����:</font></td>
                <td><font color="084B8F">< %=(userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret())%>Ԫ</font></td>
                <td><font color="084B8F">�����ܶ�:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret() + userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret() + userAccount.getOverdraft())%>Ԫ</font></td> --></TR>


</TABLE>
