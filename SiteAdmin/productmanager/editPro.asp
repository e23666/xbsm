<!--#include virtual="/config/config.asp" -->
<%Check_Is_Master(1)%>
<%
on error resume next
module=Requesta("module")
If module="productedit" Then
p_id=Requesta("p_id")
p_appid=Requesta("p_appid")
p_server=Requesta("p_server")
p_name=Requesta("p_name")
p_maxmen=Requesta("p_maxmen")
P_proId=Requesta("P_proId")
p_price=Requesta("p_price")
p_costprice=requesta("p_costprice")
p_picture=Requesta("p_picture")
p_memo=Requesta("p_memo")
p_size=Requesta("p_size")
p_type=Requesta("p_type")
p_info=Requesta("p_info")
p_traffic=Requesta("p_traffic")
p_cpu=Requesta("p_cpu")
p_test=Requesta("p_test")
if trim(p_cpu)&""="" then p_cpu=0
conn.open constr

'sql="select p_proId from productlist where p_proId='"&P_proId&"' and p_id <> "&p_id
'rs.open sql,conn,1,3
'if not rs.eof then
'	url_return "��Ʒ����ʧ��",-1
'end if

sql="update productlist set p_info='"&p_info&"',p_picture='"&p_picture&"',p_size='"&p_size&"',p_type="&p_type&",p_test="&p_test&",p_traffic="&p_traffic&",p_cpu="&p_cpu&",p_price="&p_price&",p_costprice="& p_costprice &",p_proid='"&P_proId&"',p_memo='"&p_memo&"',p_maxmen="&p_maxmen&",p_name='"&p_name&"',p_appid="&p_appid&" where p_id="& p_id

conn.execute sql
conn.close
	alert_redirect "��Ʒ���³ɹ���",request.ServerVariables("script_name") & "?p_id="& p_id

end if

p_id=Requesta("p_id")
conn.open constr
rs.open "select * from productlist where p_id="& p_id,conn,1,3

if err then
response.write "�������󣬿����ǲ�ƷID��ʧ���������ҳ�����´򿪣�"
response.write err.description 
response.end
end if

if not rs.eof then

p_appid=rs("p_appid")
p_server=rs("p_server")
p_name=rs("p_name")
p_maxmen=rs("p_maxmen")
P_proId=rs("P_proId")
p_price=rs("p_price")
p_costprice=rs("p_costprice")
p_picture=rs("p_picture")
p_memo=rs("p_memo")
p_size=rs("p_size")
p_type=rs("p_type")
p_cpu=rs("p_cpu")
p_test=rs("p_test")
p_info=rs("p_info")
p_traffic=rs("p_traffic")
if isnull(p_traffic) then p_traffic=0
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/Admin_Style.css" rel=stylesheet>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1'>
  <tr class='topbg'>
    <td height='30' align="center" ><strong>��Ʒ����</strong></td>
  </tr>
</table>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
  <tr class='tdbg'>
    <td width='91' height='30' align="center" ><strong>��������</strong></td>
    <td width="771"><a href="addPro.asp">������Ʒ</a> | <a href="default.asp?module=search&p_type=1">�ռ�</a> | <a href="default.asp?module=search&p_type=2">�ʾ�</a> | <a href="default.asp?module=search&p_type=3">����</a> | <a href="default.asp?module=search&p_type=3">��վ�ƹ�</a> |<a href="default.asp?module=search&p_type=7"> ���ݿ�</a> | <a href="RegisterPriceList.asp">���ⶩ��</a></td>
  </tr>
</table>
<br>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolor="#61BCF6" bordercolordark="#ffffff" class="border">
  <form action="editpro.asp" name =form1 method=post>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ����:</td>
      <td width="581" height="30" class="tdbg"><input name="module" type="hidden" value="productedit">
        <input name="p_id" type="hidden" value="<%=p_id%>">
        <input name="p_name" size="10" value="<%=p_name%>">
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ���:</td>
      <td width="581" height="30" class="tdbg"><input name="P_proId" size="10" value="<%=p_proid%>">
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����վ����:</td>
      <td width="581" height="30" class="tdbg"><input name="p_picture" size="10" value="<%=p_picture%>">
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ��С:</td>
      <td width="581" height="30" class="tdbg"><input name="p_size" size="10" value="<%=p_size%>">
        M &nbsp;&nbsp;�ʾֻ��߿ռ�Ĵ�С</td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">���������:</td>
      <td width="581" height="30" class="tdbg"><input name="p_traffic" size="10" value="<%if p_traffic>0 then 
					  			response.write p_traffic
					else
								response.write "0"
					end if%>">
        G/��</td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ����:</td>
      <td width="581" height="30" class="tdbg"><select name="p_type">
          <option value="1" <%if p_type="1" then Response.write "selected"%>>�ռ�</option>
          <option value="2" <%if p_type="2" then Response.write "selected"%>>�ʾ�</option>
          <option value="3" <%if p_type="3" then Response.write "selected"%>>����</option>
          <option value="4" <%if p_type="4" then Response.write "selected"%>>��������</option>
          <option value="7" <%if p_type="7" then Response.write "selected"%>>���ݿ�</option>
          <option value="5" <%if p_type="5" then Response.write "selected"%>>dns������</option>
       <option value="9" <%if p_type="9" then Response.write "selected"%>>VPS</option>
     <option value="11" <%if p_type="11" then Response.write "selected"%>>������</option>
     
        <option value="9" <%if p_type="9" then Response.write "selected"%>>VPS</option>
     <option value="12" <%if p_type="12" then Response.write "selected"%>>OEMVPS</option>
       <option value="13" <%if p_type="13" then Response.write "selected"%>>OEM������</option>
	    <option value="15" <%if p_type="15" then Response.write "selected"%>>�ƽ�վ</option>
		 <option value="16" <%if p_type="16" then Response.write "selected"%>>SSL</option>
		 <option value="17" <%if p_type="17" then Response.write "selected"%>>С����</option>
        </select>
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����ƷȨ��:</td>
      <td width="581" height="30" class="tdbg"><select name="p_appid">
          <option value="111" <%if p_appid="111" then Response.write "selected"%>>asp,php,cgi</option>
          <option value="110" <%if p_appid="110" then Response.write "selected"%>>asp.net</option>
          <option value="1" <%if p_appid="1" then Response.write "selected"%>>ASP</option>
          <option value="11" <%if p_appid="11" then Response.write "selected"%>>ASP 
          + CGI</option>
          <option value="10" <%if p_appid="10" then Response.write "selected"%>>CGI</option>
          <option value="100" <%if p_appid="100" then Response.write "selected"%>>PHP</option>
          <option value="0" <%if p_appid="0" then Response.write "selected"%>>���� 
          ��html</option>
        </select>
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">�������ã�</td>
      <td width="581" height="30" class="tdbg"><input type="radio" name="p_test" value="0" <%if p_test=0 then%>checked<%end if%>>
        ����
        <input type="radio" name="p_test" value="1" <%if p_test=1 then%>checked<%end if%>>
        ������ </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">������û�:</td>
      <td width="581" height="30" class="tdbg"><input name="p_maxmen" size="10" value="<%=p_maxmen%>">
        �ʾ�����</td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ�۸�:</td>
      <td width="581" height="30" class="tdbg"><input name="p_price" size="10" value="<%=p_price%>">
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">���ɱ��۸�:</td>
      <td width="581" height="30" class="tdbg"><input name="p_costprice" size="10" value="<%=p_costprice%>"></td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ˵��:</td>
      <td width="581" height="30" class="tdbg"><textarea name="p_info" cols="60" rows="5"><%=decodehtml(p_info)%></textarea>
      </td>
    </tr>
    <tr>
      <td width="279" height="30" align="right" class="tdbg">����Ʒ��ע:</td>
      <td width="581" height="30" class="tdbg"><input name="p_memo" size="30" value="<%=p_memo%>">
      </td>
    </tr>
    <tr>
      <td height="30" colspan="2" align="center" class="tdbg"><input name="sub" type="submit" value="  �� ��  ">
      <input name="back" type="button" value="  �� ��  " onClick="javascript:location.href='detail.asp?p_id=<%=p_id%>'" >
        <input type="hidden" name="p_cpu" id="p_cpu" value="<%=p_cpu%>" size="10" /></td>
    </tr>
  </form>
</table>
<!--#include virtual="/config/bottom_superadmin.asp" -->
