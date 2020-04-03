<table width="100%" border="0" cellspacing="0" cellpadding="4">
        <tr> 
          <td align="right" nowrap bgcolor="#000000"><font color="#FFFFFF">用户名称：</font></td>
          <td nowrap bgcolor="#000000"><font color="#FFFFFF"><%=session("user_name")%></font></td>
          <td align="right" nowrap bgcolor="#000000"><font color="#FFFFFF">可使用金额：</font></td>
          <td nowrap bgcolor="#000000"><font color="#FFFFFF"><%= session("u_usemoney") %>元</font></td>
          <td align="right" nowrap bgcolor="#000000"><font color="#FFFFFF">已消费金额：</font></td>
          <td nowrap bgcolor="#000000"><font color="#FFFFFF"><%= session("u_resumesum") %>元</font></td>
        </tr>
      </table>