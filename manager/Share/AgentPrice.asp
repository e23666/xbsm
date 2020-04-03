<TABLE border=0 align="right" cellPadding=5 cellSpacing=0> 
<TR> <TD nowrap>用户名称:</TD>
<TD nowrap><%=session("user_name")%></TD><TD nowrap>可使用金额:<%=session("u_usemoney")%>元</TD><TD nowrap>已消费金额:<%=session("u_resumesum")%>元</TD><!--                <td><font color="084B8F">帐户余额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret())%> 
                  元</font></td>
              </tr>
              <tr> 
                <td><font color="084B8F">已消费额:</font></td>
                <td><font color="084B8F">< %=userAccount.getConsumption()%>元</font></td>
                <td><font color="084B8F">未审余额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret())%>元</font></td>
                <td><font color="084B8F">可用总额:</font></td>
                <td><font color="084B8F">< %=(userAccount.getBalance() + userAccount.getBalanceUnret() + userAccount.getFloatBalance() + userAccount.getFloatBalanceUnret() + userAccount.getOverdraft())%>元</font></td> --></TR>


</TABLE>
